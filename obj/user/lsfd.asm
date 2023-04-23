
obj/user/lsfd.debug:     file format elf32-i386


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
  80002c:	e8 e8 00 00 00       	call   800119 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: lsfd [-1]\n");
  80003d:	68 c0 27 80 00       	push   $0x8027c0
  800042:	e8 d7 01 00 00       	call   80021e <cprintf>
	exit();
  800047:	e8 17 01 00 00       	call   800163 <exit>
}
  80004c:	83 c4 10             	add    $0x10,%esp
  80004f:	c9                   	leave  
  800050:	c3                   	ret    

00800051 <umain>:

void
umain(int argc, char **argv)
{
  800051:	f3 0f 1e fb          	endbr32 
  800055:	55                   	push   %ebp
  800056:	89 e5                	mov    %esp,%ebp
  800058:	57                   	push   %edi
  800059:	56                   	push   %esi
  80005a:	53                   	push   %ebx
  80005b:	81 ec b0 00 00 00    	sub    $0xb0,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800061:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800067:	50                   	push   %eax
  800068:	ff 75 0c             	pushl  0xc(%ebp)
  80006b:	8d 45 08             	lea    0x8(%ebp),%eax
  80006e:	50                   	push   %eax
  80006f:	e8 b6 0e 00 00       	call   800f2a <argstart>
	while ((i = argnext(&args)) >= 0)
  800074:	83 c4 10             	add    $0x10,%esp
	int i, usefprint = 0;
  800077:	be 00 00 00 00       	mov    $0x0,%esi
	while ((i = argnext(&args)) >= 0)
  80007c:	8d 9d 4c ff ff ff    	lea    -0xb4(%ebp),%ebx
		if (i == '1')
			usefprint = 1;
  800082:	bf 01 00 00 00       	mov    $0x1,%edi
	while ((i = argnext(&args)) >= 0)
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	53                   	push   %ebx
  80008b:	e8 ce 0e 00 00       	call   800f5e <argnext>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	85 c0                	test   %eax,%eax
  800095:	78 10                	js     8000a7 <umain+0x56>
		if (i == '1')
  800097:	83 f8 31             	cmp    $0x31,%eax
  80009a:	75 04                	jne    8000a0 <umain+0x4f>
			usefprint = 1;
  80009c:	89 fe                	mov    %edi,%esi
  80009e:	eb e7                	jmp    800087 <umain+0x36>
		else
			usage();
  8000a0:	e8 8e ff ff ff       	call   800033 <usage>
  8000a5:	eb e0                	jmp    800087 <umain+0x36>

	for (i = 0; i < 32; i++)
  8000a7:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fstat(i, &st) >= 0) {
  8000ac:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
  8000b2:	eb 26                	jmp    8000da <umain+0x89>
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000b4:	83 ec 08             	sub    $0x8,%esp
  8000b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000ba:	ff 70 04             	pushl  0x4(%eax)
  8000bd:	ff 75 dc             	pushl  -0x24(%ebp)
  8000c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8000c3:	57                   	push   %edi
  8000c4:	53                   	push   %ebx
  8000c5:	68 d4 27 80 00       	push   $0x8027d4
  8000ca:	e8 4f 01 00 00       	call   80021e <cprintf>
  8000cf:	83 c4 20             	add    $0x20,%esp
	for (i = 0; i < 32; i++)
  8000d2:	83 c3 01             	add    $0x1,%ebx
  8000d5:	83 fb 20             	cmp    $0x20,%ebx
  8000d8:	74 37                	je     800111 <umain+0xc0>
		if (fstat(i, &st) >= 0) {
  8000da:	83 ec 08             	sub    $0x8,%esp
  8000dd:	57                   	push   %edi
  8000de:	53                   	push   %ebx
  8000df:	e8 be 14 00 00       	call   8015a2 <fstat>
  8000e4:	83 c4 10             	add    $0x10,%esp
  8000e7:	85 c0                	test   %eax,%eax
  8000e9:	78 e7                	js     8000d2 <umain+0x81>
			if (usefprint)
  8000eb:	85 f6                	test   %esi,%esi
  8000ed:	74 c5                	je     8000b4 <umain+0x63>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f5:	ff 70 04             	pushl  0x4(%eax)
  8000f8:	ff 75 dc             	pushl  -0x24(%ebp)
  8000fb:	ff 75 e0             	pushl  -0x20(%ebp)
  8000fe:	57                   	push   %edi
  8000ff:	53                   	push   %ebx
  800100:	68 d4 27 80 00       	push   $0x8027d4
  800105:	6a 01                	push   $0x1
  800107:	e8 bb 18 00 00       	call   8019c7 <fprintf>
  80010c:	83 c4 20             	add    $0x20,%esp
  80010f:	eb c1                	jmp    8000d2 <umain+0x81>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800111:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800114:	5b                   	pop    %ebx
  800115:	5e                   	pop    %esi
  800116:	5f                   	pop    %edi
  800117:	5d                   	pop    %ebp
  800118:	c3                   	ret    

00800119 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800119:	f3 0f 1e fb          	endbr32 
  80011d:	55                   	push   %ebp
  80011e:	89 e5                	mov    %esp,%ebp
  800120:	56                   	push   %esi
  800121:	53                   	push   %ebx
  800122:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800125:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800128:	e8 f7 0a 00 00       	call   800c24 <sys_getenvid>
  80012d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800132:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800135:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80013a:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80013f:	85 db                	test   %ebx,%ebx
  800141:	7e 07                	jle    80014a <libmain+0x31>
		binaryname = argv[0];
  800143:	8b 06                	mov    (%esi),%eax
  800145:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80014a:	83 ec 08             	sub    $0x8,%esp
  80014d:	56                   	push   %esi
  80014e:	53                   	push   %ebx
  80014f:	e8 fd fe ff ff       	call   800051 <umain>

	// exit gracefully
	exit();
  800154:	e8 0a 00 00 00       	call   800163 <exit>
}
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80015f:	5b                   	pop    %ebx
  800160:	5e                   	pop    %esi
  800161:	5d                   	pop    %ebp
  800162:	c3                   	ret    

00800163 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800163:	f3 0f 1e fb          	endbr32 
  800167:	55                   	push   %ebp
  800168:	89 e5                	mov    %esp,%ebp
  80016a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80016d:	e8 0b 11 00 00       	call   80127d <close_all>
	sys_env_destroy(0);
  800172:	83 ec 0c             	sub    $0xc,%esp
  800175:	6a 00                	push   $0x0
  800177:	e8 63 0a 00 00       	call   800bdf <sys_env_destroy>
}
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	c9                   	leave  
  800180:	c3                   	ret    

00800181 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800181:	f3 0f 1e fb          	endbr32 
  800185:	55                   	push   %ebp
  800186:	89 e5                	mov    %esp,%ebp
  800188:	53                   	push   %ebx
  800189:	83 ec 04             	sub    $0x4,%esp
  80018c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80018f:	8b 13                	mov    (%ebx),%edx
  800191:	8d 42 01             	lea    0x1(%edx),%eax
  800194:	89 03                	mov    %eax,(%ebx)
  800196:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800199:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80019d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a2:	74 09                	je     8001ad <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001a4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001ad:	83 ec 08             	sub    $0x8,%esp
  8001b0:	68 ff 00 00 00       	push   $0xff
  8001b5:	8d 43 08             	lea    0x8(%ebx),%eax
  8001b8:	50                   	push   %eax
  8001b9:	e8 dc 09 00 00       	call   800b9a <sys_cputs>
		b->idx = 0;
  8001be:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001c4:	83 c4 10             	add    $0x10,%esp
  8001c7:	eb db                	jmp    8001a4 <putch+0x23>

008001c9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001c9:	f3 0f 1e fb          	endbr32 
  8001cd:	55                   	push   %ebp
  8001ce:	89 e5                	mov    %esp,%ebp
  8001d0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001d6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001dd:	00 00 00 
	b.cnt = 0;
  8001e0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001e7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ea:	ff 75 0c             	pushl  0xc(%ebp)
  8001ed:	ff 75 08             	pushl  0x8(%ebp)
  8001f0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001f6:	50                   	push   %eax
  8001f7:	68 81 01 80 00       	push   $0x800181
  8001fc:	e8 20 01 00 00       	call   800321 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800201:	83 c4 08             	add    $0x8,%esp
  800204:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80020a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800210:	50                   	push   %eax
  800211:	e8 84 09 00 00       	call   800b9a <sys_cputs>

	return b.cnt;
}
  800216:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80021c:	c9                   	leave  
  80021d:	c3                   	ret    

0080021e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80021e:	f3 0f 1e fb          	endbr32 
  800222:	55                   	push   %ebp
  800223:	89 e5                	mov    %esp,%ebp
  800225:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800228:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80022b:	50                   	push   %eax
  80022c:	ff 75 08             	pushl  0x8(%ebp)
  80022f:	e8 95 ff ff ff       	call   8001c9 <vcprintf>
	va_end(ap);

	return cnt;
}
  800234:	c9                   	leave  
  800235:	c3                   	ret    

00800236 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	57                   	push   %edi
  80023a:	56                   	push   %esi
  80023b:	53                   	push   %ebx
  80023c:	83 ec 1c             	sub    $0x1c,%esp
  80023f:	89 c7                	mov    %eax,%edi
  800241:	89 d6                	mov    %edx,%esi
  800243:	8b 45 08             	mov    0x8(%ebp),%eax
  800246:	8b 55 0c             	mov    0xc(%ebp),%edx
  800249:	89 d1                	mov    %edx,%ecx
  80024b:	89 c2                	mov    %eax,%edx
  80024d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800250:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800253:	8b 45 10             	mov    0x10(%ebp),%eax
  800256:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800259:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80025c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800263:	39 c2                	cmp    %eax,%edx
  800265:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800268:	72 3e                	jb     8002a8 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	ff 75 18             	pushl  0x18(%ebp)
  800270:	83 eb 01             	sub    $0x1,%ebx
  800273:	53                   	push   %ebx
  800274:	50                   	push   %eax
  800275:	83 ec 08             	sub    $0x8,%esp
  800278:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027b:	ff 75 e0             	pushl  -0x20(%ebp)
  80027e:	ff 75 dc             	pushl  -0x24(%ebp)
  800281:	ff 75 d8             	pushl  -0x28(%ebp)
  800284:	e8 d7 22 00 00       	call   802560 <__udivdi3>
  800289:	83 c4 18             	add    $0x18,%esp
  80028c:	52                   	push   %edx
  80028d:	50                   	push   %eax
  80028e:	89 f2                	mov    %esi,%edx
  800290:	89 f8                	mov    %edi,%eax
  800292:	e8 9f ff ff ff       	call   800236 <printnum>
  800297:	83 c4 20             	add    $0x20,%esp
  80029a:	eb 13                	jmp    8002af <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	56                   	push   %esi
  8002a0:	ff 75 18             	pushl  0x18(%ebp)
  8002a3:	ff d7                	call   *%edi
  8002a5:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002a8:	83 eb 01             	sub    $0x1,%ebx
  8002ab:	85 db                	test   %ebx,%ebx
  8002ad:	7f ed                	jg     80029c <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002af:	83 ec 08             	sub    $0x8,%esp
  8002b2:	56                   	push   %esi
  8002b3:	83 ec 04             	sub    $0x4,%esp
  8002b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b9:	ff 75 e0             	pushl  -0x20(%ebp)
  8002bc:	ff 75 dc             	pushl  -0x24(%ebp)
  8002bf:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c2:	e8 a9 23 00 00       	call   802670 <__umoddi3>
  8002c7:	83 c4 14             	add    $0x14,%esp
  8002ca:	0f be 80 06 28 80 00 	movsbl 0x802806(%eax),%eax
  8002d1:	50                   	push   %eax
  8002d2:	ff d7                	call   *%edi
}
  8002d4:	83 c4 10             	add    $0x10,%esp
  8002d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002da:	5b                   	pop    %ebx
  8002db:	5e                   	pop    %esi
  8002dc:	5f                   	pop    %edi
  8002dd:	5d                   	pop    %ebp
  8002de:	c3                   	ret    

008002df <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002df:	f3 0f 1e fb          	endbr32 
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002e9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ed:	8b 10                	mov    (%eax),%edx
  8002ef:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f2:	73 0a                	jae    8002fe <sprintputch+0x1f>
		*b->buf++ = ch;
  8002f4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002f7:	89 08                	mov    %ecx,(%eax)
  8002f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fc:	88 02                	mov    %al,(%edx)
}
  8002fe:	5d                   	pop    %ebp
  8002ff:	c3                   	ret    

00800300 <printfmt>:
{
  800300:	f3 0f 1e fb          	endbr32 
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
  800307:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80030a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80030d:	50                   	push   %eax
  80030e:	ff 75 10             	pushl  0x10(%ebp)
  800311:	ff 75 0c             	pushl  0xc(%ebp)
  800314:	ff 75 08             	pushl  0x8(%ebp)
  800317:	e8 05 00 00 00       	call   800321 <vprintfmt>
}
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	c9                   	leave  
  800320:	c3                   	ret    

00800321 <vprintfmt>:
{
  800321:	f3 0f 1e fb          	endbr32 
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	57                   	push   %edi
  800329:	56                   	push   %esi
  80032a:	53                   	push   %ebx
  80032b:	83 ec 3c             	sub    $0x3c,%esp
  80032e:	8b 75 08             	mov    0x8(%ebp),%esi
  800331:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800334:	8b 7d 10             	mov    0x10(%ebp),%edi
  800337:	e9 8e 03 00 00       	jmp    8006ca <vprintfmt+0x3a9>
		padc = ' ';
  80033c:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800340:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800347:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80034e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800355:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80035a:	8d 47 01             	lea    0x1(%edi),%eax
  80035d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800360:	0f b6 17             	movzbl (%edi),%edx
  800363:	8d 42 dd             	lea    -0x23(%edx),%eax
  800366:	3c 55                	cmp    $0x55,%al
  800368:	0f 87 df 03 00 00    	ja     80074d <vprintfmt+0x42c>
  80036e:	0f b6 c0             	movzbl %al,%eax
  800371:	3e ff 24 85 40 29 80 	notrack jmp *0x802940(,%eax,4)
  800378:	00 
  800379:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80037c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800380:	eb d8                	jmp    80035a <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800382:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800385:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800389:	eb cf                	jmp    80035a <vprintfmt+0x39>
  80038b:	0f b6 d2             	movzbl %dl,%edx
  80038e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800391:	b8 00 00 00 00       	mov    $0x0,%eax
  800396:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800399:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80039c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003a0:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003a3:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003a6:	83 f9 09             	cmp    $0x9,%ecx
  8003a9:	77 55                	ja     800400 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8003ab:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003ae:	eb e9                	jmp    800399 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b3:	8b 00                	mov    (%eax),%eax
  8003b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bb:	8d 40 04             	lea    0x4(%eax),%eax
  8003be:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c8:	79 90                	jns    80035a <vprintfmt+0x39>
				width = precision, precision = -1;
  8003ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003d7:	eb 81                	jmp    80035a <vprintfmt+0x39>
  8003d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003dc:	85 c0                	test   %eax,%eax
  8003de:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e3:	0f 49 d0             	cmovns %eax,%edx
  8003e6:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ec:	e9 69 ff ff ff       	jmp    80035a <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003f4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003fb:	e9 5a ff ff ff       	jmp    80035a <vprintfmt+0x39>
  800400:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800403:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800406:	eb bc                	jmp    8003c4 <vprintfmt+0xa3>
			lflag++;
  800408:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80040b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80040e:	e9 47 ff ff ff       	jmp    80035a <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800413:	8b 45 14             	mov    0x14(%ebp),%eax
  800416:	8d 78 04             	lea    0x4(%eax),%edi
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	53                   	push   %ebx
  80041d:	ff 30                	pushl  (%eax)
  80041f:	ff d6                	call   *%esi
			break;
  800421:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800424:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800427:	e9 9b 02 00 00       	jmp    8006c7 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80042c:	8b 45 14             	mov    0x14(%ebp),%eax
  80042f:	8d 78 04             	lea    0x4(%eax),%edi
  800432:	8b 00                	mov    (%eax),%eax
  800434:	99                   	cltd   
  800435:	31 d0                	xor    %edx,%eax
  800437:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800439:	83 f8 0f             	cmp    $0xf,%eax
  80043c:	7f 23                	jg     800461 <vprintfmt+0x140>
  80043e:	8b 14 85 a0 2a 80 00 	mov    0x802aa0(,%eax,4),%edx
  800445:	85 d2                	test   %edx,%edx
  800447:	74 18                	je     800461 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800449:	52                   	push   %edx
  80044a:	68 d5 2b 80 00       	push   $0x802bd5
  80044f:	53                   	push   %ebx
  800450:	56                   	push   %esi
  800451:	e8 aa fe ff ff       	call   800300 <printfmt>
  800456:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800459:	89 7d 14             	mov    %edi,0x14(%ebp)
  80045c:	e9 66 02 00 00       	jmp    8006c7 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800461:	50                   	push   %eax
  800462:	68 1e 28 80 00       	push   $0x80281e
  800467:	53                   	push   %ebx
  800468:	56                   	push   %esi
  800469:	e8 92 fe ff ff       	call   800300 <printfmt>
  80046e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800471:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800474:	e9 4e 02 00 00       	jmp    8006c7 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800479:	8b 45 14             	mov    0x14(%ebp),%eax
  80047c:	83 c0 04             	add    $0x4,%eax
  80047f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800482:	8b 45 14             	mov    0x14(%ebp),%eax
  800485:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800487:	85 d2                	test   %edx,%edx
  800489:	b8 17 28 80 00       	mov    $0x802817,%eax
  80048e:	0f 45 c2             	cmovne %edx,%eax
  800491:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800494:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800498:	7e 06                	jle    8004a0 <vprintfmt+0x17f>
  80049a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80049e:	75 0d                	jne    8004ad <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004a3:	89 c7                	mov    %eax,%edi
  8004a5:	03 45 e0             	add    -0x20(%ebp),%eax
  8004a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ab:	eb 55                	jmp    800502 <vprintfmt+0x1e1>
  8004ad:	83 ec 08             	sub    $0x8,%esp
  8004b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b3:	ff 75 cc             	pushl  -0x34(%ebp)
  8004b6:	e8 46 03 00 00       	call   800801 <strnlen>
  8004bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004be:	29 c2                	sub    %eax,%edx
  8004c0:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004c3:	83 c4 10             	add    $0x10,%esp
  8004c6:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004c8:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cf:	85 ff                	test   %edi,%edi
  8004d1:	7e 11                	jle    8004e4 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	53                   	push   %ebx
  8004d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8004da:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004dc:	83 ef 01             	sub    $0x1,%edi
  8004df:	83 c4 10             	add    $0x10,%esp
  8004e2:	eb eb                	jmp    8004cf <vprintfmt+0x1ae>
  8004e4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004e7:	85 d2                	test   %edx,%edx
  8004e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ee:	0f 49 c2             	cmovns %edx,%eax
  8004f1:	29 c2                	sub    %eax,%edx
  8004f3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004f6:	eb a8                	jmp    8004a0 <vprintfmt+0x17f>
					putch(ch, putdat);
  8004f8:	83 ec 08             	sub    $0x8,%esp
  8004fb:	53                   	push   %ebx
  8004fc:	52                   	push   %edx
  8004fd:	ff d6                	call   *%esi
  8004ff:	83 c4 10             	add    $0x10,%esp
  800502:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800505:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800507:	83 c7 01             	add    $0x1,%edi
  80050a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80050e:	0f be d0             	movsbl %al,%edx
  800511:	85 d2                	test   %edx,%edx
  800513:	74 4b                	je     800560 <vprintfmt+0x23f>
  800515:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800519:	78 06                	js     800521 <vprintfmt+0x200>
  80051b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80051f:	78 1e                	js     80053f <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800521:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800525:	74 d1                	je     8004f8 <vprintfmt+0x1d7>
  800527:	0f be c0             	movsbl %al,%eax
  80052a:	83 e8 20             	sub    $0x20,%eax
  80052d:	83 f8 5e             	cmp    $0x5e,%eax
  800530:	76 c6                	jbe    8004f8 <vprintfmt+0x1d7>
					putch('?', putdat);
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	53                   	push   %ebx
  800536:	6a 3f                	push   $0x3f
  800538:	ff d6                	call   *%esi
  80053a:	83 c4 10             	add    $0x10,%esp
  80053d:	eb c3                	jmp    800502 <vprintfmt+0x1e1>
  80053f:	89 cf                	mov    %ecx,%edi
  800541:	eb 0e                	jmp    800551 <vprintfmt+0x230>
				putch(' ', putdat);
  800543:	83 ec 08             	sub    $0x8,%esp
  800546:	53                   	push   %ebx
  800547:	6a 20                	push   $0x20
  800549:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80054b:	83 ef 01             	sub    $0x1,%edi
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	85 ff                	test   %edi,%edi
  800553:	7f ee                	jg     800543 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800555:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800558:	89 45 14             	mov    %eax,0x14(%ebp)
  80055b:	e9 67 01 00 00       	jmp    8006c7 <vprintfmt+0x3a6>
  800560:	89 cf                	mov    %ecx,%edi
  800562:	eb ed                	jmp    800551 <vprintfmt+0x230>
	if (lflag >= 2)
  800564:	83 f9 01             	cmp    $0x1,%ecx
  800567:	7f 1b                	jg     800584 <vprintfmt+0x263>
	else if (lflag)
  800569:	85 c9                	test   %ecx,%ecx
  80056b:	74 63                	je     8005d0 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80056d:	8b 45 14             	mov    0x14(%ebp),%eax
  800570:	8b 00                	mov    (%eax),%eax
  800572:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800575:	99                   	cltd   
  800576:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	8d 40 04             	lea    0x4(%eax),%eax
  80057f:	89 45 14             	mov    %eax,0x14(%ebp)
  800582:	eb 17                	jmp    80059b <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	8b 50 04             	mov    0x4(%eax),%edx
  80058a:	8b 00                	mov    (%eax),%eax
  80058c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8d 40 08             	lea    0x8(%eax),%eax
  800598:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80059b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80059e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005a1:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005a6:	85 c9                	test   %ecx,%ecx
  8005a8:	0f 89 ff 00 00 00    	jns    8006ad <vprintfmt+0x38c>
				putch('-', putdat);
  8005ae:	83 ec 08             	sub    $0x8,%esp
  8005b1:	53                   	push   %ebx
  8005b2:	6a 2d                	push   $0x2d
  8005b4:	ff d6                	call   *%esi
				num = -(long long) num;
  8005b6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005b9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005bc:	f7 da                	neg    %edx
  8005be:	83 d1 00             	adc    $0x0,%ecx
  8005c1:	f7 d9                	neg    %ecx
  8005c3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005cb:	e9 dd 00 00 00       	jmp    8006ad <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	8b 00                	mov    (%eax),%eax
  8005d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d8:	99                   	cltd   
  8005d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005df:	8d 40 04             	lea    0x4(%eax),%eax
  8005e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e5:	eb b4                	jmp    80059b <vprintfmt+0x27a>
	if (lflag >= 2)
  8005e7:	83 f9 01             	cmp    $0x1,%ecx
  8005ea:	7f 1e                	jg     80060a <vprintfmt+0x2e9>
	else if (lflag)
  8005ec:	85 c9                	test   %ecx,%ecx
  8005ee:	74 32                	je     800622 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	8b 10                	mov    (%eax),%edx
  8005f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005fa:	8d 40 04             	lea    0x4(%eax),%eax
  8005fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800600:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800605:	e9 a3 00 00 00       	jmp    8006ad <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	8b 10                	mov    (%eax),%edx
  80060f:	8b 48 04             	mov    0x4(%eax),%ecx
  800612:	8d 40 08             	lea    0x8(%eax),%eax
  800615:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800618:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80061d:	e9 8b 00 00 00       	jmp    8006ad <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8b 10                	mov    (%eax),%edx
  800627:	b9 00 00 00 00       	mov    $0x0,%ecx
  80062c:	8d 40 04             	lea    0x4(%eax),%eax
  80062f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800632:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800637:	eb 74                	jmp    8006ad <vprintfmt+0x38c>
	if (lflag >= 2)
  800639:	83 f9 01             	cmp    $0x1,%ecx
  80063c:	7f 1b                	jg     800659 <vprintfmt+0x338>
	else if (lflag)
  80063e:	85 c9                	test   %ecx,%ecx
  800640:	74 2c                	je     80066e <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8b 10                	mov    (%eax),%edx
  800647:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064c:	8d 40 04             	lea    0x4(%eax),%eax
  80064f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800652:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800657:	eb 54                	jmp    8006ad <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8b 10                	mov    (%eax),%edx
  80065e:	8b 48 04             	mov    0x4(%eax),%ecx
  800661:	8d 40 08             	lea    0x8(%eax),%eax
  800664:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800667:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80066c:	eb 3f                	jmp    8006ad <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8b 10                	mov    (%eax),%edx
  800673:	b9 00 00 00 00       	mov    $0x0,%ecx
  800678:	8d 40 04             	lea    0x4(%eax),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80067e:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800683:	eb 28                	jmp    8006ad <vprintfmt+0x38c>
			putch('0', putdat);
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	53                   	push   %ebx
  800689:	6a 30                	push   $0x30
  80068b:	ff d6                	call   *%esi
			putch('x', putdat);
  80068d:	83 c4 08             	add    $0x8,%esp
  800690:	53                   	push   %ebx
  800691:	6a 78                	push   $0x78
  800693:	ff d6                	call   *%esi
			num = (unsigned long long)
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8b 10                	mov    (%eax),%edx
  80069a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80069f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006a2:	8d 40 04             	lea    0x4(%eax),%eax
  8006a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a8:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006ad:	83 ec 0c             	sub    $0xc,%esp
  8006b0:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006b4:	57                   	push   %edi
  8006b5:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b8:	50                   	push   %eax
  8006b9:	51                   	push   %ecx
  8006ba:	52                   	push   %edx
  8006bb:	89 da                	mov    %ebx,%edx
  8006bd:	89 f0                	mov    %esi,%eax
  8006bf:	e8 72 fb ff ff       	call   800236 <printnum>
			break;
  8006c4:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006ca:	83 c7 01             	add    $0x1,%edi
  8006cd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006d1:	83 f8 25             	cmp    $0x25,%eax
  8006d4:	0f 84 62 fc ff ff    	je     80033c <vprintfmt+0x1b>
			if (ch == '\0')
  8006da:	85 c0                	test   %eax,%eax
  8006dc:	0f 84 8b 00 00 00    	je     80076d <vprintfmt+0x44c>
			putch(ch, putdat);
  8006e2:	83 ec 08             	sub    $0x8,%esp
  8006e5:	53                   	push   %ebx
  8006e6:	50                   	push   %eax
  8006e7:	ff d6                	call   *%esi
  8006e9:	83 c4 10             	add    $0x10,%esp
  8006ec:	eb dc                	jmp    8006ca <vprintfmt+0x3a9>
	if (lflag >= 2)
  8006ee:	83 f9 01             	cmp    $0x1,%ecx
  8006f1:	7f 1b                	jg     80070e <vprintfmt+0x3ed>
	else if (lflag)
  8006f3:	85 c9                	test   %ecx,%ecx
  8006f5:	74 2c                	je     800723 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	8b 10                	mov    (%eax),%edx
  8006fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800701:	8d 40 04             	lea    0x4(%eax),%eax
  800704:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800707:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80070c:	eb 9f                	jmp    8006ad <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	8b 10                	mov    (%eax),%edx
  800713:	8b 48 04             	mov    0x4(%eax),%ecx
  800716:	8d 40 08             	lea    0x8(%eax),%eax
  800719:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800721:	eb 8a                	jmp    8006ad <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8b 10                	mov    (%eax),%edx
  800728:	b9 00 00 00 00       	mov    $0x0,%ecx
  80072d:	8d 40 04             	lea    0x4(%eax),%eax
  800730:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800733:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800738:	e9 70 ff ff ff       	jmp    8006ad <vprintfmt+0x38c>
			putch(ch, putdat);
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	53                   	push   %ebx
  800741:	6a 25                	push   $0x25
  800743:	ff d6                	call   *%esi
			break;
  800745:	83 c4 10             	add    $0x10,%esp
  800748:	e9 7a ff ff ff       	jmp    8006c7 <vprintfmt+0x3a6>
			putch('%', putdat);
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	53                   	push   %ebx
  800751:	6a 25                	push   $0x25
  800753:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800755:	83 c4 10             	add    $0x10,%esp
  800758:	89 f8                	mov    %edi,%eax
  80075a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80075e:	74 05                	je     800765 <vprintfmt+0x444>
  800760:	83 e8 01             	sub    $0x1,%eax
  800763:	eb f5                	jmp    80075a <vprintfmt+0x439>
  800765:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800768:	e9 5a ff ff ff       	jmp    8006c7 <vprintfmt+0x3a6>
}
  80076d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800770:	5b                   	pop    %ebx
  800771:	5e                   	pop    %esi
  800772:	5f                   	pop    %edi
  800773:	5d                   	pop    %ebp
  800774:	c3                   	ret    

00800775 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800775:	f3 0f 1e fb          	endbr32 
  800779:	55                   	push   %ebp
  80077a:	89 e5                	mov    %esp,%ebp
  80077c:	83 ec 18             	sub    $0x18,%esp
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800785:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800788:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80078c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80078f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800796:	85 c0                	test   %eax,%eax
  800798:	74 26                	je     8007c0 <vsnprintf+0x4b>
  80079a:	85 d2                	test   %edx,%edx
  80079c:	7e 22                	jle    8007c0 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80079e:	ff 75 14             	pushl  0x14(%ebp)
  8007a1:	ff 75 10             	pushl  0x10(%ebp)
  8007a4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007a7:	50                   	push   %eax
  8007a8:	68 df 02 80 00       	push   $0x8002df
  8007ad:	e8 6f fb ff ff       	call   800321 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007b5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007bb:	83 c4 10             	add    $0x10,%esp
}
  8007be:	c9                   	leave  
  8007bf:	c3                   	ret    
		return -E_INVAL;
  8007c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007c5:	eb f7                	jmp    8007be <vsnprintf+0x49>

008007c7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007c7:	f3 0f 1e fb          	endbr32 
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007d1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007d4:	50                   	push   %eax
  8007d5:	ff 75 10             	pushl  0x10(%ebp)
  8007d8:	ff 75 0c             	pushl  0xc(%ebp)
  8007db:	ff 75 08             	pushl  0x8(%ebp)
  8007de:	e8 92 ff ff ff       	call   800775 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007e3:	c9                   	leave  
  8007e4:	c3                   	ret    

008007e5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007e5:	f3 0f 1e fb          	endbr32 
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007f8:	74 05                	je     8007ff <strlen+0x1a>
		n++;
  8007fa:	83 c0 01             	add    $0x1,%eax
  8007fd:	eb f5                	jmp    8007f4 <strlen+0xf>
	return n;
}
  8007ff:	5d                   	pop    %ebp
  800800:	c3                   	ret    

00800801 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800801:	f3 0f 1e fb          	endbr32 
  800805:	55                   	push   %ebp
  800806:	89 e5                	mov    %esp,%ebp
  800808:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80080b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80080e:	b8 00 00 00 00       	mov    $0x0,%eax
  800813:	39 d0                	cmp    %edx,%eax
  800815:	74 0d                	je     800824 <strnlen+0x23>
  800817:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80081b:	74 05                	je     800822 <strnlen+0x21>
		n++;
  80081d:	83 c0 01             	add    $0x1,%eax
  800820:	eb f1                	jmp    800813 <strnlen+0x12>
  800822:	89 c2                	mov    %eax,%edx
	return n;
}
  800824:	89 d0                	mov    %edx,%eax
  800826:	5d                   	pop    %ebp
  800827:	c3                   	ret    

00800828 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800828:	f3 0f 1e fb          	endbr32 
  80082c:	55                   	push   %ebp
  80082d:	89 e5                	mov    %esp,%ebp
  80082f:	53                   	push   %ebx
  800830:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800833:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800836:	b8 00 00 00 00       	mov    $0x0,%eax
  80083b:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80083f:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800842:	83 c0 01             	add    $0x1,%eax
  800845:	84 d2                	test   %dl,%dl
  800847:	75 f2                	jne    80083b <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800849:	89 c8                	mov    %ecx,%eax
  80084b:	5b                   	pop    %ebx
  80084c:	5d                   	pop    %ebp
  80084d:	c3                   	ret    

0080084e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80084e:	f3 0f 1e fb          	endbr32 
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	53                   	push   %ebx
  800856:	83 ec 10             	sub    $0x10,%esp
  800859:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80085c:	53                   	push   %ebx
  80085d:	e8 83 ff ff ff       	call   8007e5 <strlen>
  800862:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	01 d8                	add    %ebx,%eax
  80086a:	50                   	push   %eax
  80086b:	e8 b8 ff ff ff       	call   800828 <strcpy>
	return dst;
}
  800870:	89 d8                	mov    %ebx,%eax
  800872:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800875:	c9                   	leave  
  800876:	c3                   	ret    

00800877 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800877:	f3 0f 1e fb          	endbr32 
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	56                   	push   %esi
  80087f:	53                   	push   %ebx
  800880:	8b 75 08             	mov    0x8(%ebp),%esi
  800883:	8b 55 0c             	mov    0xc(%ebp),%edx
  800886:	89 f3                	mov    %esi,%ebx
  800888:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80088b:	89 f0                	mov    %esi,%eax
  80088d:	39 d8                	cmp    %ebx,%eax
  80088f:	74 11                	je     8008a2 <strncpy+0x2b>
		*dst++ = *src;
  800891:	83 c0 01             	add    $0x1,%eax
  800894:	0f b6 0a             	movzbl (%edx),%ecx
  800897:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80089a:	80 f9 01             	cmp    $0x1,%cl
  80089d:	83 da ff             	sbb    $0xffffffff,%edx
  8008a0:	eb eb                	jmp    80088d <strncpy+0x16>
	}
	return ret;
}
  8008a2:	89 f0                	mov    %esi,%eax
  8008a4:	5b                   	pop    %ebx
  8008a5:	5e                   	pop    %esi
  8008a6:	5d                   	pop    %ebp
  8008a7:	c3                   	ret    

008008a8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008a8:	f3 0f 1e fb          	endbr32 
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	56                   	push   %esi
  8008b0:	53                   	push   %ebx
  8008b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008b7:	8b 55 10             	mov    0x10(%ebp),%edx
  8008ba:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008bc:	85 d2                	test   %edx,%edx
  8008be:	74 21                	je     8008e1 <strlcpy+0x39>
  8008c0:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008c4:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008c6:	39 c2                	cmp    %eax,%edx
  8008c8:	74 14                	je     8008de <strlcpy+0x36>
  8008ca:	0f b6 19             	movzbl (%ecx),%ebx
  8008cd:	84 db                	test   %bl,%bl
  8008cf:	74 0b                	je     8008dc <strlcpy+0x34>
			*dst++ = *src++;
  8008d1:	83 c1 01             	add    $0x1,%ecx
  8008d4:	83 c2 01             	add    $0x1,%edx
  8008d7:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008da:	eb ea                	jmp    8008c6 <strlcpy+0x1e>
  8008dc:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008de:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008e1:	29 f0                	sub    %esi,%eax
}
  8008e3:	5b                   	pop    %ebx
  8008e4:	5e                   	pop    %esi
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008e7:	f3 0f 1e fb          	endbr32 
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008f4:	0f b6 01             	movzbl (%ecx),%eax
  8008f7:	84 c0                	test   %al,%al
  8008f9:	74 0c                	je     800907 <strcmp+0x20>
  8008fb:	3a 02                	cmp    (%edx),%al
  8008fd:	75 08                	jne    800907 <strcmp+0x20>
		p++, q++;
  8008ff:	83 c1 01             	add    $0x1,%ecx
  800902:	83 c2 01             	add    $0x1,%edx
  800905:	eb ed                	jmp    8008f4 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800907:	0f b6 c0             	movzbl %al,%eax
  80090a:	0f b6 12             	movzbl (%edx),%edx
  80090d:	29 d0                	sub    %edx,%eax
}
  80090f:	5d                   	pop    %ebp
  800910:	c3                   	ret    

00800911 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800911:	f3 0f 1e fb          	endbr32 
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	53                   	push   %ebx
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091f:	89 c3                	mov    %eax,%ebx
  800921:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800924:	eb 06                	jmp    80092c <strncmp+0x1b>
		n--, p++, q++;
  800926:	83 c0 01             	add    $0x1,%eax
  800929:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80092c:	39 d8                	cmp    %ebx,%eax
  80092e:	74 16                	je     800946 <strncmp+0x35>
  800930:	0f b6 08             	movzbl (%eax),%ecx
  800933:	84 c9                	test   %cl,%cl
  800935:	74 04                	je     80093b <strncmp+0x2a>
  800937:	3a 0a                	cmp    (%edx),%cl
  800939:	74 eb                	je     800926 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80093b:	0f b6 00             	movzbl (%eax),%eax
  80093e:	0f b6 12             	movzbl (%edx),%edx
  800941:	29 d0                	sub    %edx,%eax
}
  800943:	5b                   	pop    %ebx
  800944:	5d                   	pop    %ebp
  800945:	c3                   	ret    
		return 0;
  800946:	b8 00 00 00 00       	mov    $0x0,%eax
  80094b:	eb f6                	jmp    800943 <strncmp+0x32>

0080094d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80094d:	f3 0f 1e fb          	endbr32 
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80095b:	0f b6 10             	movzbl (%eax),%edx
  80095e:	84 d2                	test   %dl,%dl
  800960:	74 09                	je     80096b <strchr+0x1e>
		if (*s == c)
  800962:	38 ca                	cmp    %cl,%dl
  800964:	74 0a                	je     800970 <strchr+0x23>
	for (; *s; s++)
  800966:	83 c0 01             	add    $0x1,%eax
  800969:	eb f0                	jmp    80095b <strchr+0xe>
			return (char *) s;
	return 0;
  80096b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    

00800972 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800972:	f3 0f 1e fb          	endbr32 
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800980:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800983:	38 ca                	cmp    %cl,%dl
  800985:	74 09                	je     800990 <strfind+0x1e>
  800987:	84 d2                	test   %dl,%dl
  800989:	74 05                	je     800990 <strfind+0x1e>
	for (; *s; s++)
  80098b:	83 c0 01             	add    $0x1,%eax
  80098e:	eb f0                	jmp    800980 <strfind+0xe>
			break;
	return (char *) s;
}
  800990:	5d                   	pop    %ebp
  800991:	c3                   	ret    

00800992 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800992:	f3 0f 1e fb          	endbr32 
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	57                   	push   %edi
  80099a:	56                   	push   %esi
  80099b:	53                   	push   %ebx
  80099c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80099f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009a2:	85 c9                	test   %ecx,%ecx
  8009a4:	74 31                	je     8009d7 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009a6:	89 f8                	mov    %edi,%eax
  8009a8:	09 c8                	or     %ecx,%eax
  8009aa:	a8 03                	test   $0x3,%al
  8009ac:	75 23                	jne    8009d1 <memset+0x3f>
		c &= 0xFF;
  8009ae:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009b2:	89 d3                	mov    %edx,%ebx
  8009b4:	c1 e3 08             	shl    $0x8,%ebx
  8009b7:	89 d0                	mov    %edx,%eax
  8009b9:	c1 e0 18             	shl    $0x18,%eax
  8009bc:	89 d6                	mov    %edx,%esi
  8009be:	c1 e6 10             	shl    $0x10,%esi
  8009c1:	09 f0                	or     %esi,%eax
  8009c3:	09 c2                	or     %eax,%edx
  8009c5:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009c7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009ca:	89 d0                	mov    %edx,%eax
  8009cc:	fc                   	cld    
  8009cd:	f3 ab                	rep stos %eax,%es:(%edi)
  8009cf:	eb 06                	jmp    8009d7 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d4:	fc                   	cld    
  8009d5:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009d7:	89 f8                	mov    %edi,%eax
  8009d9:	5b                   	pop    %ebx
  8009da:	5e                   	pop    %esi
  8009db:	5f                   	pop    %edi
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    

008009de <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009de:	f3 0f 1e fb          	endbr32 
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	57                   	push   %edi
  8009e6:	56                   	push   %esi
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009f0:	39 c6                	cmp    %eax,%esi
  8009f2:	73 32                	jae    800a26 <memmove+0x48>
  8009f4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009f7:	39 c2                	cmp    %eax,%edx
  8009f9:	76 2b                	jbe    800a26 <memmove+0x48>
		s += n;
		d += n;
  8009fb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009fe:	89 fe                	mov    %edi,%esi
  800a00:	09 ce                	or     %ecx,%esi
  800a02:	09 d6                	or     %edx,%esi
  800a04:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a0a:	75 0e                	jne    800a1a <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a0c:	83 ef 04             	sub    $0x4,%edi
  800a0f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a12:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a15:	fd                   	std    
  800a16:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a18:	eb 09                	jmp    800a23 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a1a:	83 ef 01             	sub    $0x1,%edi
  800a1d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a20:	fd                   	std    
  800a21:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a23:	fc                   	cld    
  800a24:	eb 1a                	jmp    800a40 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a26:	89 c2                	mov    %eax,%edx
  800a28:	09 ca                	or     %ecx,%edx
  800a2a:	09 f2                	or     %esi,%edx
  800a2c:	f6 c2 03             	test   $0x3,%dl
  800a2f:	75 0a                	jne    800a3b <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a31:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a34:	89 c7                	mov    %eax,%edi
  800a36:	fc                   	cld    
  800a37:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a39:	eb 05                	jmp    800a40 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a3b:	89 c7                	mov    %eax,%edi
  800a3d:	fc                   	cld    
  800a3e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a40:	5e                   	pop    %esi
  800a41:	5f                   	pop    %edi
  800a42:	5d                   	pop    %ebp
  800a43:	c3                   	ret    

00800a44 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a44:	f3 0f 1e fb          	endbr32 
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
  800a4b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a4e:	ff 75 10             	pushl  0x10(%ebp)
  800a51:	ff 75 0c             	pushl  0xc(%ebp)
  800a54:	ff 75 08             	pushl  0x8(%ebp)
  800a57:	e8 82 ff ff ff       	call   8009de <memmove>
}
  800a5c:	c9                   	leave  
  800a5d:	c3                   	ret    

00800a5e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a5e:	f3 0f 1e fb          	endbr32 
  800a62:	55                   	push   %ebp
  800a63:	89 e5                	mov    %esp,%ebp
  800a65:	56                   	push   %esi
  800a66:	53                   	push   %ebx
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6d:	89 c6                	mov    %eax,%esi
  800a6f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a72:	39 f0                	cmp    %esi,%eax
  800a74:	74 1c                	je     800a92 <memcmp+0x34>
		if (*s1 != *s2)
  800a76:	0f b6 08             	movzbl (%eax),%ecx
  800a79:	0f b6 1a             	movzbl (%edx),%ebx
  800a7c:	38 d9                	cmp    %bl,%cl
  800a7e:	75 08                	jne    800a88 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a80:	83 c0 01             	add    $0x1,%eax
  800a83:	83 c2 01             	add    $0x1,%edx
  800a86:	eb ea                	jmp    800a72 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a88:	0f b6 c1             	movzbl %cl,%eax
  800a8b:	0f b6 db             	movzbl %bl,%ebx
  800a8e:	29 d8                	sub    %ebx,%eax
  800a90:	eb 05                	jmp    800a97 <memcmp+0x39>
	}

	return 0;
  800a92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a97:	5b                   	pop    %ebx
  800a98:	5e                   	pop    %esi
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a9b:	f3 0f 1e fb          	endbr32 
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aa8:	89 c2                	mov    %eax,%edx
  800aaa:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aad:	39 d0                	cmp    %edx,%eax
  800aaf:	73 09                	jae    800aba <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ab1:	38 08                	cmp    %cl,(%eax)
  800ab3:	74 05                	je     800aba <memfind+0x1f>
	for (; s < ends; s++)
  800ab5:	83 c0 01             	add    $0x1,%eax
  800ab8:	eb f3                	jmp    800aad <memfind+0x12>
			break;
	return (void *) s;
}
  800aba:	5d                   	pop    %ebp
  800abb:	c3                   	ret    

00800abc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800abc:	f3 0f 1e fb          	endbr32 
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	57                   	push   %edi
  800ac4:	56                   	push   %esi
  800ac5:	53                   	push   %ebx
  800ac6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800acc:	eb 03                	jmp    800ad1 <strtol+0x15>
		s++;
  800ace:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ad1:	0f b6 01             	movzbl (%ecx),%eax
  800ad4:	3c 20                	cmp    $0x20,%al
  800ad6:	74 f6                	je     800ace <strtol+0x12>
  800ad8:	3c 09                	cmp    $0x9,%al
  800ada:	74 f2                	je     800ace <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800adc:	3c 2b                	cmp    $0x2b,%al
  800ade:	74 2a                	je     800b0a <strtol+0x4e>
	int neg = 0;
  800ae0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ae5:	3c 2d                	cmp    $0x2d,%al
  800ae7:	74 2b                	je     800b14 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ae9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800aef:	75 0f                	jne    800b00 <strtol+0x44>
  800af1:	80 39 30             	cmpb   $0x30,(%ecx)
  800af4:	74 28                	je     800b1e <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800af6:	85 db                	test   %ebx,%ebx
  800af8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800afd:	0f 44 d8             	cmove  %eax,%ebx
  800b00:	b8 00 00 00 00       	mov    $0x0,%eax
  800b05:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b08:	eb 46                	jmp    800b50 <strtol+0x94>
		s++;
  800b0a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b0d:	bf 00 00 00 00       	mov    $0x0,%edi
  800b12:	eb d5                	jmp    800ae9 <strtol+0x2d>
		s++, neg = 1;
  800b14:	83 c1 01             	add    $0x1,%ecx
  800b17:	bf 01 00 00 00       	mov    $0x1,%edi
  800b1c:	eb cb                	jmp    800ae9 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b1e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b22:	74 0e                	je     800b32 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b24:	85 db                	test   %ebx,%ebx
  800b26:	75 d8                	jne    800b00 <strtol+0x44>
		s++, base = 8;
  800b28:	83 c1 01             	add    $0x1,%ecx
  800b2b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b30:	eb ce                	jmp    800b00 <strtol+0x44>
		s += 2, base = 16;
  800b32:	83 c1 02             	add    $0x2,%ecx
  800b35:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b3a:	eb c4                	jmp    800b00 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b3c:	0f be d2             	movsbl %dl,%edx
  800b3f:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b42:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b45:	7d 3a                	jge    800b81 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b47:	83 c1 01             	add    $0x1,%ecx
  800b4a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b4e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b50:	0f b6 11             	movzbl (%ecx),%edx
  800b53:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b56:	89 f3                	mov    %esi,%ebx
  800b58:	80 fb 09             	cmp    $0x9,%bl
  800b5b:	76 df                	jbe    800b3c <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b5d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b60:	89 f3                	mov    %esi,%ebx
  800b62:	80 fb 19             	cmp    $0x19,%bl
  800b65:	77 08                	ja     800b6f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b67:	0f be d2             	movsbl %dl,%edx
  800b6a:	83 ea 57             	sub    $0x57,%edx
  800b6d:	eb d3                	jmp    800b42 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b6f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b72:	89 f3                	mov    %esi,%ebx
  800b74:	80 fb 19             	cmp    $0x19,%bl
  800b77:	77 08                	ja     800b81 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b79:	0f be d2             	movsbl %dl,%edx
  800b7c:	83 ea 37             	sub    $0x37,%edx
  800b7f:	eb c1                	jmp    800b42 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b85:	74 05                	je     800b8c <strtol+0xd0>
		*endptr = (char *) s;
  800b87:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b8a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b8c:	89 c2                	mov    %eax,%edx
  800b8e:	f7 da                	neg    %edx
  800b90:	85 ff                	test   %edi,%edi
  800b92:	0f 45 c2             	cmovne %edx,%eax
}
  800b95:	5b                   	pop    %ebx
  800b96:	5e                   	pop    %esi
  800b97:	5f                   	pop    %edi
  800b98:	5d                   	pop    %ebp
  800b99:	c3                   	ret    

00800b9a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b9a:	f3 0f 1e fb          	endbr32 
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	57                   	push   %edi
  800ba2:	56                   	push   %esi
  800ba3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ba4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800baf:	89 c3                	mov    %eax,%ebx
  800bb1:	89 c7                	mov    %eax,%edi
  800bb3:	89 c6                	mov    %eax,%esi
  800bb5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bb7:	5b                   	pop    %ebx
  800bb8:	5e                   	pop    %esi
  800bb9:	5f                   	pop    %edi
  800bba:	5d                   	pop    %ebp
  800bbb:	c3                   	ret    

00800bbc <sys_cgetc>:

int
sys_cgetc(void)
{
  800bbc:	f3 0f 1e fb          	endbr32 
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	57                   	push   %edi
  800bc4:	56                   	push   %esi
  800bc5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bc6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcb:	b8 01 00 00 00       	mov    $0x1,%eax
  800bd0:	89 d1                	mov    %edx,%ecx
  800bd2:	89 d3                	mov    %edx,%ebx
  800bd4:	89 d7                	mov    %edx,%edi
  800bd6:	89 d6                	mov    %edx,%esi
  800bd8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bda:	5b                   	pop    %ebx
  800bdb:	5e                   	pop    %esi
  800bdc:	5f                   	pop    %edi
  800bdd:	5d                   	pop    %ebp
  800bde:	c3                   	ret    

00800bdf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bdf:	f3 0f 1e fb          	endbr32 
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	57                   	push   %edi
  800be7:	56                   	push   %esi
  800be8:	53                   	push   %ebx
  800be9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bec:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bf1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf4:	b8 03 00 00 00       	mov    $0x3,%eax
  800bf9:	89 cb                	mov    %ecx,%ebx
  800bfb:	89 cf                	mov    %ecx,%edi
  800bfd:	89 ce                	mov    %ecx,%esi
  800bff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c01:	85 c0                	test   %eax,%eax
  800c03:	7f 08                	jg     800c0d <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c08:	5b                   	pop    %ebx
  800c09:	5e                   	pop    %esi
  800c0a:	5f                   	pop    %edi
  800c0b:	5d                   	pop    %ebp
  800c0c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c0d:	83 ec 0c             	sub    $0xc,%esp
  800c10:	50                   	push   %eax
  800c11:	6a 03                	push   $0x3
  800c13:	68 ff 2a 80 00       	push   $0x802aff
  800c18:	6a 23                	push   $0x23
  800c1a:	68 1c 2b 80 00       	push   $0x802b1c
  800c1f:	e8 8b 17 00 00       	call   8023af <_panic>

00800c24 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c24:	f3 0f 1e fb          	endbr32 
  800c28:	55                   	push   %ebp
  800c29:	89 e5                	mov    %esp,%ebp
  800c2b:	57                   	push   %edi
  800c2c:	56                   	push   %esi
  800c2d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c33:	b8 02 00 00 00       	mov    $0x2,%eax
  800c38:	89 d1                	mov    %edx,%ecx
  800c3a:	89 d3                	mov    %edx,%ebx
  800c3c:	89 d7                	mov    %edx,%edi
  800c3e:	89 d6                	mov    %edx,%esi
  800c40:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c42:	5b                   	pop    %ebx
  800c43:	5e                   	pop    %esi
  800c44:	5f                   	pop    %edi
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    

00800c47 <sys_yield>:

void
sys_yield(void)
{
  800c47:	f3 0f 1e fb          	endbr32 
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	57                   	push   %edi
  800c4f:	56                   	push   %esi
  800c50:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c51:	ba 00 00 00 00       	mov    $0x0,%edx
  800c56:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c5b:	89 d1                	mov    %edx,%ecx
  800c5d:	89 d3                	mov    %edx,%ebx
  800c5f:	89 d7                	mov    %edx,%edi
  800c61:	89 d6                	mov    %edx,%esi
  800c63:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c65:	5b                   	pop    %ebx
  800c66:	5e                   	pop    %esi
  800c67:	5f                   	pop    %edi
  800c68:	5d                   	pop    %ebp
  800c69:	c3                   	ret    

00800c6a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c6a:	f3 0f 1e fb          	endbr32 
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	57                   	push   %edi
  800c72:	56                   	push   %esi
  800c73:	53                   	push   %ebx
  800c74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c77:	be 00 00 00 00       	mov    $0x0,%esi
  800c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c82:	b8 04 00 00 00       	mov    $0x4,%eax
  800c87:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c8a:	89 f7                	mov    %esi,%edi
  800c8c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8e:	85 c0                	test   %eax,%eax
  800c90:	7f 08                	jg     800c9a <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c95:	5b                   	pop    %ebx
  800c96:	5e                   	pop    %esi
  800c97:	5f                   	pop    %edi
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9a:	83 ec 0c             	sub    $0xc,%esp
  800c9d:	50                   	push   %eax
  800c9e:	6a 04                	push   $0x4
  800ca0:	68 ff 2a 80 00       	push   $0x802aff
  800ca5:	6a 23                	push   $0x23
  800ca7:	68 1c 2b 80 00       	push   $0x802b1c
  800cac:	e8 fe 16 00 00       	call   8023af <_panic>

00800cb1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cb1:	f3 0f 1e fb          	endbr32 
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	57                   	push   %edi
  800cb9:	56                   	push   %esi
  800cba:	53                   	push   %ebx
  800cbb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc4:	b8 05 00 00 00       	mov    $0x5,%eax
  800cc9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ccc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ccf:	8b 75 18             	mov    0x18(%ebp),%esi
  800cd2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd4:	85 c0                	test   %eax,%eax
  800cd6:	7f 08                	jg     800ce0 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cdb:	5b                   	pop    %ebx
  800cdc:	5e                   	pop    %esi
  800cdd:	5f                   	pop    %edi
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce0:	83 ec 0c             	sub    $0xc,%esp
  800ce3:	50                   	push   %eax
  800ce4:	6a 05                	push   $0x5
  800ce6:	68 ff 2a 80 00       	push   $0x802aff
  800ceb:	6a 23                	push   $0x23
  800ced:	68 1c 2b 80 00       	push   $0x802b1c
  800cf2:	e8 b8 16 00 00       	call   8023af <_panic>

00800cf7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cf7:	f3 0f 1e fb          	endbr32 
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	57                   	push   %edi
  800cff:	56                   	push   %esi
  800d00:	53                   	push   %ebx
  800d01:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d04:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d09:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0f:	b8 06 00 00 00       	mov    $0x6,%eax
  800d14:	89 df                	mov    %ebx,%edi
  800d16:	89 de                	mov    %ebx,%esi
  800d18:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d1a:	85 c0                	test   %eax,%eax
  800d1c:	7f 08                	jg     800d26 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d21:	5b                   	pop    %ebx
  800d22:	5e                   	pop    %esi
  800d23:	5f                   	pop    %edi
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d26:	83 ec 0c             	sub    $0xc,%esp
  800d29:	50                   	push   %eax
  800d2a:	6a 06                	push   $0x6
  800d2c:	68 ff 2a 80 00       	push   $0x802aff
  800d31:	6a 23                	push   $0x23
  800d33:	68 1c 2b 80 00       	push   $0x802b1c
  800d38:	e8 72 16 00 00       	call   8023af <_panic>

00800d3d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d3d:	f3 0f 1e fb          	endbr32 
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	57                   	push   %edi
  800d45:	56                   	push   %esi
  800d46:	53                   	push   %ebx
  800d47:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d55:	b8 08 00 00 00       	mov    $0x8,%eax
  800d5a:	89 df                	mov    %ebx,%edi
  800d5c:	89 de                	mov    %ebx,%esi
  800d5e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d60:	85 c0                	test   %eax,%eax
  800d62:	7f 08                	jg     800d6c <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d67:	5b                   	pop    %ebx
  800d68:	5e                   	pop    %esi
  800d69:	5f                   	pop    %edi
  800d6a:	5d                   	pop    %ebp
  800d6b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6c:	83 ec 0c             	sub    $0xc,%esp
  800d6f:	50                   	push   %eax
  800d70:	6a 08                	push   $0x8
  800d72:	68 ff 2a 80 00       	push   $0x802aff
  800d77:	6a 23                	push   $0x23
  800d79:	68 1c 2b 80 00       	push   $0x802b1c
  800d7e:	e8 2c 16 00 00       	call   8023af <_panic>

00800d83 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d83:	f3 0f 1e fb          	endbr32 
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	57                   	push   %edi
  800d8b:	56                   	push   %esi
  800d8c:	53                   	push   %ebx
  800d8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d95:	8b 55 08             	mov    0x8(%ebp),%edx
  800d98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9b:	b8 09 00 00 00       	mov    $0x9,%eax
  800da0:	89 df                	mov    %ebx,%edi
  800da2:	89 de                	mov    %ebx,%esi
  800da4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da6:	85 c0                	test   %eax,%eax
  800da8:	7f 08                	jg     800db2 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800daa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dad:	5b                   	pop    %ebx
  800dae:	5e                   	pop    %esi
  800daf:	5f                   	pop    %edi
  800db0:	5d                   	pop    %ebp
  800db1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	50                   	push   %eax
  800db6:	6a 09                	push   $0x9
  800db8:	68 ff 2a 80 00       	push   $0x802aff
  800dbd:	6a 23                	push   $0x23
  800dbf:	68 1c 2b 80 00       	push   $0x802b1c
  800dc4:	e8 e6 15 00 00       	call   8023af <_panic>

00800dc9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dc9:	f3 0f 1e fb          	endbr32 
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	57                   	push   %edi
  800dd1:	56                   	push   %esi
  800dd2:	53                   	push   %ebx
  800dd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ddb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800de6:	89 df                	mov    %ebx,%edi
  800de8:	89 de                	mov    %ebx,%esi
  800dea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dec:	85 c0                	test   %eax,%eax
  800dee:	7f 08                	jg     800df8 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df3:	5b                   	pop    %ebx
  800df4:	5e                   	pop    %esi
  800df5:	5f                   	pop    %edi
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df8:	83 ec 0c             	sub    $0xc,%esp
  800dfb:	50                   	push   %eax
  800dfc:	6a 0a                	push   $0xa
  800dfe:	68 ff 2a 80 00       	push   $0x802aff
  800e03:	6a 23                	push   $0x23
  800e05:	68 1c 2b 80 00       	push   $0x802b1c
  800e0a:	e8 a0 15 00 00       	call   8023af <_panic>

00800e0f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e0f:	f3 0f 1e fb          	endbr32 
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	57                   	push   %edi
  800e17:	56                   	push   %esi
  800e18:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e19:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e24:	be 00 00 00 00       	mov    $0x0,%esi
  800e29:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e2c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e2f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e31:	5b                   	pop    %ebx
  800e32:	5e                   	pop    %esi
  800e33:	5f                   	pop    %edi
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e36:	f3 0f 1e fb          	endbr32 
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	57                   	push   %edi
  800e3e:	56                   	push   %esi
  800e3f:	53                   	push   %ebx
  800e40:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e43:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e48:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e50:	89 cb                	mov    %ecx,%ebx
  800e52:	89 cf                	mov    %ecx,%edi
  800e54:	89 ce                	mov    %ecx,%esi
  800e56:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e58:	85 c0                	test   %eax,%eax
  800e5a:	7f 08                	jg     800e64 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5f:	5b                   	pop    %ebx
  800e60:	5e                   	pop    %esi
  800e61:	5f                   	pop    %edi
  800e62:	5d                   	pop    %ebp
  800e63:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e64:	83 ec 0c             	sub    $0xc,%esp
  800e67:	50                   	push   %eax
  800e68:	6a 0d                	push   $0xd
  800e6a:	68 ff 2a 80 00       	push   $0x802aff
  800e6f:	6a 23                	push   $0x23
  800e71:	68 1c 2b 80 00       	push   $0x802b1c
  800e76:	e8 34 15 00 00       	call   8023af <_panic>

00800e7b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e7b:	f3 0f 1e fb          	endbr32 
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	57                   	push   %edi
  800e83:	56                   	push   %esi
  800e84:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e85:	ba 00 00 00 00       	mov    $0x0,%edx
  800e8a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e8f:	89 d1                	mov    %edx,%ecx
  800e91:	89 d3                	mov    %edx,%ebx
  800e93:	89 d7                	mov    %edx,%edi
  800e95:	89 d6                	mov    %edx,%esi
  800e97:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e99:	5b                   	pop    %ebx
  800e9a:	5e                   	pop    %esi
  800e9b:	5f                   	pop    %edi
  800e9c:	5d                   	pop    %ebp
  800e9d:	c3                   	ret    

00800e9e <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800e9e:	f3 0f 1e fb          	endbr32 
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	57                   	push   %edi
  800ea6:	56                   	push   %esi
  800ea7:	53                   	push   %ebx
  800ea8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb6:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ebb:	89 df                	mov    %ebx,%edi
  800ebd:	89 de                	mov    %ebx,%esi
  800ebf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec1:	85 c0                	test   %eax,%eax
  800ec3:	7f 08                	jg     800ecd <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800ec5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec8:	5b                   	pop    %ebx
  800ec9:	5e                   	pop    %esi
  800eca:	5f                   	pop    %edi
  800ecb:	5d                   	pop    %ebp
  800ecc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecd:	83 ec 0c             	sub    $0xc,%esp
  800ed0:	50                   	push   %eax
  800ed1:	6a 0f                	push   $0xf
  800ed3:	68 ff 2a 80 00       	push   $0x802aff
  800ed8:	6a 23                	push   $0x23
  800eda:	68 1c 2b 80 00       	push   $0x802b1c
  800edf:	e8 cb 14 00 00       	call   8023af <_panic>

00800ee4 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800ee4:	f3 0f 1e fb          	endbr32 
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	57                   	push   %edi
  800eec:	56                   	push   %esi
  800eed:	53                   	push   %ebx
  800eee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efc:	b8 10 00 00 00       	mov    $0x10,%eax
  800f01:	89 df                	mov    %ebx,%edi
  800f03:	89 de                	mov    %ebx,%esi
  800f05:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f07:	85 c0                	test   %eax,%eax
  800f09:	7f 08                	jg     800f13 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f0e:	5b                   	pop    %ebx
  800f0f:	5e                   	pop    %esi
  800f10:	5f                   	pop    %edi
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f13:	83 ec 0c             	sub    $0xc,%esp
  800f16:	50                   	push   %eax
  800f17:	6a 10                	push   $0x10
  800f19:	68 ff 2a 80 00       	push   $0x802aff
  800f1e:	6a 23                	push   $0x23
  800f20:	68 1c 2b 80 00       	push   $0x802b1c
  800f25:	e8 85 14 00 00       	call   8023af <_panic>

00800f2a <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800f2a:	f3 0f 1e fb          	endbr32 
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	8b 55 08             	mov    0x8(%ebp),%edx
  800f34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f37:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800f3a:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  800f3c:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800f3f:	83 3a 01             	cmpl   $0x1,(%edx)
  800f42:	7e 09                	jle    800f4d <argstart+0x23>
  800f44:	ba d1 27 80 00       	mov    $0x8027d1,%edx
  800f49:	85 c9                	test   %ecx,%ecx
  800f4b:	75 05                	jne    800f52 <argstart+0x28>
  800f4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f52:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  800f55:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  800f5c:	5d                   	pop    %ebp
  800f5d:	c3                   	ret    

00800f5e <argnext>:

int
argnext(struct Argstate *args)
{
  800f5e:	f3 0f 1e fb          	endbr32 
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	53                   	push   %ebx
  800f66:	83 ec 04             	sub    $0x4,%esp
  800f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  800f6c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  800f73:	8b 43 08             	mov    0x8(%ebx),%eax
  800f76:	85 c0                	test   %eax,%eax
  800f78:	74 74                	je     800fee <argnext+0x90>
		return -1;

	if (!*args->curarg) {
  800f7a:	80 38 00             	cmpb   $0x0,(%eax)
  800f7d:	75 48                	jne    800fc7 <argnext+0x69>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  800f7f:	8b 0b                	mov    (%ebx),%ecx
  800f81:	83 39 01             	cmpl   $0x1,(%ecx)
  800f84:	74 5a                	je     800fe0 <argnext+0x82>
		    || args->argv[1][0] != '-'
  800f86:	8b 53 04             	mov    0x4(%ebx),%edx
  800f89:	8b 42 04             	mov    0x4(%edx),%eax
  800f8c:	80 38 2d             	cmpb   $0x2d,(%eax)
  800f8f:	75 4f                	jne    800fe0 <argnext+0x82>
		    || args->argv[1][1] == '\0')
  800f91:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800f95:	74 49                	je     800fe0 <argnext+0x82>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  800f97:	83 c0 01             	add    $0x1,%eax
  800f9a:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800f9d:	83 ec 04             	sub    $0x4,%esp
  800fa0:	8b 01                	mov    (%ecx),%eax
  800fa2:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  800fa9:	50                   	push   %eax
  800faa:	8d 42 08             	lea    0x8(%edx),%eax
  800fad:	50                   	push   %eax
  800fae:	83 c2 04             	add    $0x4,%edx
  800fb1:	52                   	push   %edx
  800fb2:	e8 27 fa ff ff       	call   8009de <memmove>
		(*args->argc)--;
  800fb7:	8b 03                	mov    (%ebx),%eax
  800fb9:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800fbc:	8b 43 08             	mov    0x8(%ebx),%eax
  800fbf:	83 c4 10             	add    $0x10,%esp
  800fc2:	80 38 2d             	cmpb   $0x2d,(%eax)
  800fc5:	74 13                	je     800fda <argnext+0x7c>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  800fc7:	8b 43 08             	mov    0x8(%ebx),%eax
  800fca:	0f b6 10             	movzbl (%eax),%edx
	args->curarg++;
  800fcd:	83 c0 01             	add    $0x1,%eax
  800fd0:	89 43 08             	mov    %eax,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  800fd3:	89 d0                	mov    %edx,%eax
  800fd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fd8:	c9                   	leave  
  800fd9:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800fda:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800fde:	75 e7                	jne    800fc7 <argnext+0x69>
	args->curarg = 0;
  800fe0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  800fe7:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  800fec:	eb e5                	jmp    800fd3 <argnext+0x75>
		return -1;
  800fee:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  800ff3:	eb de                	jmp    800fd3 <argnext+0x75>

00800ff5 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  800ff5:	f3 0f 1e fb          	endbr32 
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	53                   	push   %ebx
  800ffd:	83 ec 04             	sub    $0x4,%esp
  801000:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801003:	8b 43 08             	mov    0x8(%ebx),%eax
  801006:	85 c0                	test   %eax,%eax
  801008:	74 12                	je     80101c <argnextvalue+0x27>
		return 0;
	if (*args->curarg) {
  80100a:	80 38 00             	cmpb   $0x0,(%eax)
  80100d:	74 12                	je     801021 <argnextvalue+0x2c>
		args->argvalue = args->curarg;
  80100f:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801012:	c7 43 08 d1 27 80 00 	movl   $0x8027d1,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801019:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  80101c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80101f:	c9                   	leave  
  801020:	c3                   	ret    
	} else if (*args->argc > 1) {
  801021:	8b 13                	mov    (%ebx),%edx
  801023:	83 3a 01             	cmpl   $0x1,(%edx)
  801026:	7f 10                	jg     801038 <argnextvalue+0x43>
		args->argvalue = 0;
  801028:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  80102f:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801036:	eb e1                	jmp    801019 <argnextvalue+0x24>
		args->argvalue = args->argv[1];
  801038:	8b 43 04             	mov    0x4(%ebx),%eax
  80103b:	8b 48 04             	mov    0x4(%eax),%ecx
  80103e:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801041:	83 ec 04             	sub    $0x4,%esp
  801044:	8b 12                	mov    (%edx),%edx
  801046:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  80104d:	52                   	push   %edx
  80104e:	8d 50 08             	lea    0x8(%eax),%edx
  801051:	52                   	push   %edx
  801052:	83 c0 04             	add    $0x4,%eax
  801055:	50                   	push   %eax
  801056:	e8 83 f9 ff ff       	call   8009de <memmove>
		(*args->argc)--;
  80105b:	8b 03                	mov    (%ebx),%eax
  80105d:	83 28 01             	subl   $0x1,(%eax)
  801060:	83 c4 10             	add    $0x10,%esp
  801063:	eb b4                	jmp    801019 <argnextvalue+0x24>

00801065 <argvalue>:
{
  801065:	f3 0f 1e fb          	endbr32 
  801069:	55                   	push   %ebp
  80106a:	89 e5                	mov    %esp,%ebp
  80106c:	83 ec 08             	sub    $0x8,%esp
  80106f:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801072:	8b 42 0c             	mov    0xc(%edx),%eax
  801075:	85 c0                	test   %eax,%eax
  801077:	74 02                	je     80107b <argvalue+0x16>
}
  801079:	c9                   	leave  
  80107a:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80107b:	83 ec 0c             	sub    $0xc,%esp
  80107e:	52                   	push   %edx
  80107f:	e8 71 ff ff ff       	call   800ff5 <argnextvalue>
  801084:	83 c4 10             	add    $0x10,%esp
  801087:	eb f0                	jmp    801079 <argvalue+0x14>

00801089 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801089:	f3 0f 1e fb          	endbr32 
  80108d:	55                   	push   %ebp
  80108e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	05 00 00 00 30       	add    $0x30000000,%eax
  801098:	c1 e8 0c             	shr    $0xc,%eax
}
  80109b:	5d                   	pop    %ebp
  80109c:	c3                   	ret    

0080109d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80109d:	f3 0f 1e fb          	endbr32 
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010b1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010b6:	5d                   	pop    %ebp
  8010b7:	c3                   	ret    

008010b8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010b8:	f3 0f 1e fb          	endbr32 
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
  8010bf:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010c4:	89 c2                	mov    %eax,%edx
  8010c6:	c1 ea 16             	shr    $0x16,%edx
  8010c9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010d0:	f6 c2 01             	test   $0x1,%dl
  8010d3:	74 2d                	je     801102 <fd_alloc+0x4a>
  8010d5:	89 c2                	mov    %eax,%edx
  8010d7:	c1 ea 0c             	shr    $0xc,%edx
  8010da:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010e1:	f6 c2 01             	test   $0x1,%dl
  8010e4:	74 1c                	je     801102 <fd_alloc+0x4a>
  8010e6:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010eb:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010f0:	75 d2                	jne    8010c4 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010fb:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801100:	eb 0a                	jmp    80110c <fd_alloc+0x54>
			*fd_store = fd;
  801102:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801105:	89 01                	mov    %eax,(%ecx)
			return 0;
  801107:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80110c:	5d                   	pop    %ebp
  80110d:	c3                   	ret    

0080110e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80110e:	f3 0f 1e fb          	endbr32 
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801118:	83 f8 1f             	cmp    $0x1f,%eax
  80111b:	77 30                	ja     80114d <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80111d:	c1 e0 0c             	shl    $0xc,%eax
  801120:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801125:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80112b:	f6 c2 01             	test   $0x1,%dl
  80112e:	74 24                	je     801154 <fd_lookup+0x46>
  801130:	89 c2                	mov    %eax,%edx
  801132:	c1 ea 0c             	shr    $0xc,%edx
  801135:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80113c:	f6 c2 01             	test   $0x1,%dl
  80113f:	74 1a                	je     80115b <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801141:	8b 55 0c             	mov    0xc(%ebp),%edx
  801144:	89 02                	mov    %eax,(%edx)
	return 0;
  801146:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80114b:	5d                   	pop    %ebp
  80114c:	c3                   	ret    
		return -E_INVAL;
  80114d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801152:	eb f7                	jmp    80114b <fd_lookup+0x3d>
		return -E_INVAL;
  801154:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801159:	eb f0                	jmp    80114b <fd_lookup+0x3d>
  80115b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801160:	eb e9                	jmp    80114b <fd_lookup+0x3d>

00801162 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801162:	f3 0f 1e fb          	endbr32 
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	83 ec 08             	sub    $0x8,%esp
  80116c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80116f:	ba 00 00 00 00       	mov    $0x0,%edx
  801174:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801179:	39 08                	cmp    %ecx,(%eax)
  80117b:	74 38                	je     8011b5 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80117d:	83 c2 01             	add    $0x1,%edx
  801180:	8b 04 95 a8 2b 80 00 	mov    0x802ba8(,%edx,4),%eax
  801187:	85 c0                	test   %eax,%eax
  801189:	75 ee                	jne    801179 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80118b:	a1 08 40 80 00       	mov    0x804008,%eax
  801190:	8b 40 48             	mov    0x48(%eax),%eax
  801193:	83 ec 04             	sub    $0x4,%esp
  801196:	51                   	push   %ecx
  801197:	50                   	push   %eax
  801198:	68 2c 2b 80 00       	push   $0x802b2c
  80119d:	e8 7c f0 ff ff       	call   80021e <cprintf>
	*dev = 0;
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011ab:	83 c4 10             	add    $0x10,%esp
  8011ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011b3:	c9                   	leave  
  8011b4:	c3                   	ret    
			*dev = devtab[i];
  8011b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8011bf:	eb f2                	jmp    8011b3 <dev_lookup+0x51>

008011c1 <fd_close>:
{
  8011c1:	f3 0f 1e fb          	endbr32 
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	57                   	push   %edi
  8011c9:	56                   	push   %esi
  8011ca:	53                   	push   %ebx
  8011cb:	83 ec 24             	sub    $0x24,%esp
  8011ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8011d1:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011d7:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011d8:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011de:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011e1:	50                   	push   %eax
  8011e2:	e8 27 ff ff ff       	call   80110e <fd_lookup>
  8011e7:	89 c3                	mov    %eax,%ebx
  8011e9:	83 c4 10             	add    $0x10,%esp
  8011ec:	85 c0                	test   %eax,%eax
  8011ee:	78 05                	js     8011f5 <fd_close+0x34>
	    || fd != fd2)
  8011f0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011f3:	74 16                	je     80120b <fd_close+0x4a>
		return (must_exist ? r : 0);
  8011f5:	89 f8                	mov    %edi,%eax
  8011f7:	84 c0                	test   %al,%al
  8011f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011fe:	0f 44 d8             	cmove  %eax,%ebx
}
  801201:	89 d8                	mov    %ebx,%eax
  801203:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801206:	5b                   	pop    %ebx
  801207:	5e                   	pop    %esi
  801208:	5f                   	pop    %edi
  801209:	5d                   	pop    %ebp
  80120a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80120b:	83 ec 08             	sub    $0x8,%esp
  80120e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801211:	50                   	push   %eax
  801212:	ff 36                	pushl  (%esi)
  801214:	e8 49 ff ff ff       	call   801162 <dev_lookup>
  801219:	89 c3                	mov    %eax,%ebx
  80121b:	83 c4 10             	add    $0x10,%esp
  80121e:	85 c0                	test   %eax,%eax
  801220:	78 1a                	js     80123c <fd_close+0x7b>
		if (dev->dev_close)
  801222:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801225:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801228:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80122d:	85 c0                	test   %eax,%eax
  80122f:	74 0b                	je     80123c <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801231:	83 ec 0c             	sub    $0xc,%esp
  801234:	56                   	push   %esi
  801235:	ff d0                	call   *%eax
  801237:	89 c3                	mov    %eax,%ebx
  801239:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80123c:	83 ec 08             	sub    $0x8,%esp
  80123f:	56                   	push   %esi
  801240:	6a 00                	push   $0x0
  801242:	e8 b0 fa ff ff       	call   800cf7 <sys_page_unmap>
	return r;
  801247:	83 c4 10             	add    $0x10,%esp
  80124a:	eb b5                	jmp    801201 <fd_close+0x40>

0080124c <close>:

int
close(int fdnum)
{
  80124c:	f3 0f 1e fb          	endbr32 
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801256:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801259:	50                   	push   %eax
  80125a:	ff 75 08             	pushl  0x8(%ebp)
  80125d:	e8 ac fe ff ff       	call   80110e <fd_lookup>
  801262:	83 c4 10             	add    $0x10,%esp
  801265:	85 c0                	test   %eax,%eax
  801267:	79 02                	jns    80126b <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801269:	c9                   	leave  
  80126a:	c3                   	ret    
		return fd_close(fd, 1);
  80126b:	83 ec 08             	sub    $0x8,%esp
  80126e:	6a 01                	push   $0x1
  801270:	ff 75 f4             	pushl  -0xc(%ebp)
  801273:	e8 49 ff ff ff       	call   8011c1 <fd_close>
  801278:	83 c4 10             	add    $0x10,%esp
  80127b:	eb ec                	jmp    801269 <close+0x1d>

0080127d <close_all>:

void
close_all(void)
{
  80127d:	f3 0f 1e fb          	endbr32 
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	53                   	push   %ebx
  801285:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801288:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	53                   	push   %ebx
  801291:	e8 b6 ff ff ff       	call   80124c <close>
	for (i = 0; i < MAXFD; i++)
  801296:	83 c3 01             	add    $0x1,%ebx
  801299:	83 c4 10             	add    $0x10,%esp
  80129c:	83 fb 20             	cmp    $0x20,%ebx
  80129f:	75 ec                	jne    80128d <close_all+0x10>
}
  8012a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    

008012a6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012a6:	f3 0f 1e fb          	endbr32 
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	57                   	push   %edi
  8012ae:	56                   	push   %esi
  8012af:	53                   	push   %ebx
  8012b0:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012b3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012b6:	50                   	push   %eax
  8012b7:	ff 75 08             	pushl  0x8(%ebp)
  8012ba:	e8 4f fe ff ff       	call   80110e <fd_lookup>
  8012bf:	89 c3                	mov    %eax,%ebx
  8012c1:	83 c4 10             	add    $0x10,%esp
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	0f 88 81 00 00 00    	js     80134d <dup+0xa7>
		return r;
	close(newfdnum);
  8012cc:	83 ec 0c             	sub    $0xc,%esp
  8012cf:	ff 75 0c             	pushl  0xc(%ebp)
  8012d2:	e8 75 ff ff ff       	call   80124c <close>

	newfd = INDEX2FD(newfdnum);
  8012d7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012da:	c1 e6 0c             	shl    $0xc,%esi
  8012dd:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012e3:	83 c4 04             	add    $0x4,%esp
  8012e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012e9:	e8 af fd ff ff       	call   80109d <fd2data>
  8012ee:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012f0:	89 34 24             	mov    %esi,(%esp)
  8012f3:	e8 a5 fd ff ff       	call   80109d <fd2data>
  8012f8:	83 c4 10             	add    $0x10,%esp
  8012fb:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012fd:	89 d8                	mov    %ebx,%eax
  8012ff:	c1 e8 16             	shr    $0x16,%eax
  801302:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801309:	a8 01                	test   $0x1,%al
  80130b:	74 11                	je     80131e <dup+0x78>
  80130d:	89 d8                	mov    %ebx,%eax
  80130f:	c1 e8 0c             	shr    $0xc,%eax
  801312:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801319:	f6 c2 01             	test   $0x1,%dl
  80131c:	75 39                	jne    801357 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80131e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801321:	89 d0                	mov    %edx,%eax
  801323:	c1 e8 0c             	shr    $0xc,%eax
  801326:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80132d:	83 ec 0c             	sub    $0xc,%esp
  801330:	25 07 0e 00 00       	and    $0xe07,%eax
  801335:	50                   	push   %eax
  801336:	56                   	push   %esi
  801337:	6a 00                	push   $0x0
  801339:	52                   	push   %edx
  80133a:	6a 00                	push   $0x0
  80133c:	e8 70 f9 ff ff       	call   800cb1 <sys_page_map>
  801341:	89 c3                	mov    %eax,%ebx
  801343:	83 c4 20             	add    $0x20,%esp
  801346:	85 c0                	test   %eax,%eax
  801348:	78 31                	js     80137b <dup+0xd5>
		goto err;

	return newfdnum;
  80134a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80134d:	89 d8                	mov    %ebx,%eax
  80134f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801352:	5b                   	pop    %ebx
  801353:	5e                   	pop    %esi
  801354:	5f                   	pop    %edi
  801355:	5d                   	pop    %ebp
  801356:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801357:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80135e:	83 ec 0c             	sub    $0xc,%esp
  801361:	25 07 0e 00 00       	and    $0xe07,%eax
  801366:	50                   	push   %eax
  801367:	57                   	push   %edi
  801368:	6a 00                	push   $0x0
  80136a:	53                   	push   %ebx
  80136b:	6a 00                	push   $0x0
  80136d:	e8 3f f9 ff ff       	call   800cb1 <sys_page_map>
  801372:	89 c3                	mov    %eax,%ebx
  801374:	83 c4 20             	add    $0x20,%esp
  801377:	85 c0                	test   %eax,%eax
  801379:	79 a3                	jns    80131e <dup+0x78>
	sys_page_unmap(0, newfd);
  80137b:	83 ec 08             	sub    $0x8,%esp
  80137e:	56                   	push   %esi
  80137f:	6a 00                	push   $0x0
  801381:	e8 71 f9 ff ff       	call   800cf7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801386:	83 c4 08             	add    $0x8,%esp
  801389:	57                   	push   %edi
  80138a:	6a 00                	push   $0x0
  80138c:	e8 66 f9 ff ff       	call   800cf7 <sys_page_unmap>
	return r;
  801391:	83 c4 10             	add    $0x10,%esp
  801394:	eb b7                	jmp    80134d <dup+0xa7>

00801396 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801396:	f3 0f 1e fb          	endbr32 
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
  80139d:	53                   	push   %ebx
  80139e:	83 ec 1c             	sub    $0x1c,%esp
  8013a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a7:	50                   	push   %eax
  8013a8:	53                   	push   %ebx
  8013a9:	e8 60 fd ff ff       	call   80110e <fd_lookup>
  8013ae:	83 c4 10             	add    $0x10,%esp
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	78 3f                	js     8013f4 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b5:	83 ec 08             	sub    $0x8,%esp
  8013b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013bb:	50                   	push   %eax
  8013bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013bf:	ff 30                	pushl  (%eax)
  8013c1:	e8 9c fd ff ff       	call   801162 <dev_lookup>
  8013c6:	83 c4 10             	add    $0x10,%esp
  8013c9:	85 c0                	test   %eax,%eax
  8013cb:	78 27                	js     8013f4 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013d0:	8b 42 08             	mov    0x8(%edx),%eax
  8013d3:	83 e0 03             	and    $0x3,%eax
  8013d6:	83 f8 01             	cmp    $0x1,%eax
  8013d9:	74 1e                	je     8013f9 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013de:	8b 40 08             	mov    0x8(%eax),%eax
  8013e1:	85 c0                	test   %eax,%eax
  8013e3:	74 35                	je     80141a <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013e5:	83 ec 04             	sub    $0x4,%esp
  8013e8:	ff 75 10             	pushl  0x10(%ebp)
  8013eb:	ff 75 0c             	pushl  0xc(%ebp)
  8013ee:	52                   	push   %edx
  8013ef:	ff d0                	call   *%eax
  8013f1:	83 c4 10             	add    $0x10,%esp
}
  8013f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013f9:	a1 08 40 80 00       	mov    0x804008,%eax
  8013fe:	8b 40 48             	mov    0x48(%eax),%eax
  801401:	83 ec 04             	sub    $0x4,%esp
  801404:	53                   	push   %ebx
  801405:	50                   	push   %eax
  801406:	68 6d 2b 80 00       	push   $0x802b6d
  80140b:	e8 0e ee ff ff       	call   80021e <cprintf>
		return -E_INVAL;
  801410:	83 c4 10             	add    $0x10,%esp
  801413:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801418:	eb da                	jmp    8013f4 <read+0x5e>
		return -E_NOT_SUPP;
  80141a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80141f:	eb d3                	jmp    8013f4 <read+0x5e>

00801421 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801421:	f3 0f 1e fb          	endbr32 
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
  801428:	57                   	push   %edi
  801429:	56                   	push   %esi
  80142a:	53                   	push   %ebx
  80142b:	83 ec 0c             	sub    $0xc,%esp
  80142e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801431:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801434:	bb 00 00 00 00       	mov    $0x0,%ebx
  801439:	eb 02                	jmp    80143d <readn+0x1c>
  80143b:	01 c3                	add    %eax,%ebx
  80143d:	39 f3                	cmp    %esi,%ebx
  80143f:	73 21                	jae    801462 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801441:	83 ec 04             	sub    $0x4,%esp
  801444:	89 f0                	mov    %esi,%eax
  801446:	29 d8                	sub    %ebx,%eax
  801448:	50                   	push   %eax
  801449:	89 d8                	mov    %ebx,%eax
  80144b:	03 45 0c             	add    0xc(%ebp),%eax
  80144e:	50                   	push   %eax
  80144f:	57                   	push   %edi
  801450:	e8 41 ff ff ff       	call   801396 <read>
		if (m < 0)
  801455:	83 c4 10             	add    $0x10,%esp
  801458:	85 c0                	test   %eax,%eax
  80145a:	78 04                	js     801460 <readn+0x3f>
			return m;
		if (m == 0)
  80145c:	75 dd                	jne    80143b <readn+0x1a>
  80145e:	eb 02                	jmp    801462 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801460:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801462:	89 d8                	mov    %ebx,%eax
  801464:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801467:	5b                   	pop    %ebx
  801468:	5e                   	pop    %esi
  801469:	5f                   	pop    %edi
  80146a:	5d                   	pop    %ebp
  80146b:	c3                   	ret    

0080146c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80146c:	f3 0f 1e fb          	endbr32 
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	53                   	push   %ebx
  801474:	83 ec 1c             	sub    $0x1c,%esp
  801477:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80147a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80147d:	50                   	push   %eax
  80147e:	53                   	push   %ebx
  80147f:	e8 8a fc ff ff       	call   80110e <fd_lookup>
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	85 c0                	test   %eax,%eax
  801489:	78 3a                	js     8014c5 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80148b:	83 ec 08             	sub    $0x8,%esp
  80148e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801491:	50                   	push   %eax
  801492:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801495:	ff 30                	pushl  (%eax)
  801497:	e8 c6 fc ff ff       	call   801162 <dev_lookup>
  80149c:	83 c4 10             	add    $0x10,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	78 22                	js     8014c5 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014aa:	74 1e                	je     8014ca <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014af:	8b 52 0c             	mov    0xc(%edx),%edx
  8014b2:	85 d2                	test   %edx,%edx
  8014b4:	74 35                	je     8014eb <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014b6:	83 ec 04             	sub    $0x4,%esp
  8014b9:	ff 75 10             	pushl  0x10(%ebp)
  8014bc:	ff 75 0c             	pushl  0xc(%ebp)
  8014bf:	50                   	push   %eax
  8014c0:	ff d2                	call   *%edx
  8014c2:	83 c4 10             	add    $0x10,%esp
}
  8014c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c8:	c9                   	leave  
  8014c9:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014ca:	a1 08 40 80 00       	mov    0x804008,%eax
  8014cf:	8b 40 48             	mov    0x48(%eax),%eax
  8014d2:	83 ec 04             	sub    $0x4,%esp
  8014d5:	53                   	push   %ebx
  8014d6:	50                   	push   %eax
  8014d7:	68 89 2b 80 00       	push   $0x802b89
  8014dc:	e8 3d ed ff ff       	call   80021e <cprintf>
		return -E_INVAL;
  8014e1:	83 c4 10             	add    $0x10,%esp
  8014e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e9:	eb da                	jmp    8014c5 <write+0x59>
		return -E_NOT_SUPP;
  8014eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014f0:	eb d3                	jmp    8014c5 <write+0x59>

008014f2 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014f2:	f3 0f 1e fb          	endbr32 
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ff:	50                   	push   %eax
  801500:	ff 75 08             	pushl  0x8(%ebp)
  801503:	e8 06 fc ff ff       	call   80110e <fd_lookup>
  801508:	83 c4 10             	add    $0x10,%esp
  80150b:	85 c0                	test   %eax,%eax
  80150d:	78 0e                	js     80151d <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80150f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801515:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801518:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80151f:	f3 0f 1e fb          	endbr32 
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
  801526:	53                   	push   %ebx
  801527:	83 ec 1c             	sub    $0x1c,%esp
  80152a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80152d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801530:	50                   	push   %eax
  801531:	53                   	push   %ebx
  801532:	e8 d7 fb ff ff       	call   80110e <fd_lookup>
  801537:	83 c4 10             	add    $0x10,%esp
  80153a:	85 c0                	test   %eax,%eax
  80153c:	78 37                	js     801575 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80153e:	83 ec 08             	sub    $0x8,%esp
  801541:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801544:	50                   	push   %eax
  801545:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801548:	ff 30                	pushl  (%eax)
  80154a:	e8 13 fc ff ff       	call   801162 <dev_lookup>
  80154f:	83 c4 10             	add    $0x10,%esp
  801552:	85 c0                	test   %eax,%eax
  801554:	78 1f                	js     801575 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801559:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80155d:	74 1b                	je     80157a <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80155f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801562:	8b 52 18             	mov    0x18(%edx),%edx
  801565:	85 d2                	test   %edx,%edx
  801567:	74 32                	je     80159b <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801569:	83 ec 08             	sub    $0x8,%esp
  80156c:	ff 75 0c             	pushl  0xc(%ebp)
  80156f:	50                   	push   %eax
  801570:	ff d2                	call   *%edx
  801572:	83 c4 10             	add    $0x10,%esp
}
  801575:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801578:	c9                   	leave  
  801579:	c3                   	ret    
			thisenv->env_id, fdnum);
  80157a:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80157f:	8b 40 48             	mov    0x48(%eax),%eax
  801582:	83 ec 04             	sub    $0x4,%esp
  801585:	53                   	push   %ebx
  801586:	50                   	push   %eax
  801587:	68 4c 2b 80 00       	push   $0x802b4c
  80158c:	e8 8d ec ff ff       	call   80021e <cprintf>
		return -E_INVAL;
  801591:	83 c4 10             	add    $0x10,%esp
  801594:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801599:	eb da                	jmp    801575 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80159b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015a0:	eb d3                	jmp    801575 <ftruncate+0x56>

008015a2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015a2:	f3 0f 1e fb          	endbr32 
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	53                   	push   %ebx
  8015aa:	83 ec 1c             	sub    $0x1c,%esp
  8015ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b3:	50                   	push   %eax
  8015b4:	ff 75 08             	pushl  0x8(%ebp)
  8015b7:	e8 52 fb ff ff       	call   80110e <fd_lookup>
  8015bc:	83 c4 10             	add    $0x10,%esp
  8015bf:	85 c0                	test   %eax,%eax
  8015c1:	78 4b                	js     80160e <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015c3:	83 ec 08             	sub    $0x8,%esp
  8015c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c9:	50                   	push   %eax
  8015ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cd:	ff 30                	pushl  (%eax)
  8015cf:	e8 8e fb ff ff       	call   801162 <dev_lookup>
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	85 c0                	test   %eax,%eax
  8015d9:	78 33                	js     80160e <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8015db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015de:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015e2:	74 2f                	je     801613 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015e4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015e7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015ee:	00 00 00 
	stat->st_isdir = 0;
  8015f1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015f8:	00 00 00 
	stat->st_dev = dev;
  8015fb:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801601:	83 ec 08             	sub    $0x8,%esp
  801604:	53                   	push   %ebx
  801605:	ff 75 f0             	pushl  -0x10(%ebp)
  801608:	ff 50 14             	call   *0x14(%eax)
  80160b:	83 c4 10             	add    $0x10,%esp
}
  80160e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801611:	c9                   	leave  
  801612:	c3                   	ret    
		return -E_NOT_SUPP;
  801613:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801618:	eb f4                	jmp    80160e <fstat+0x6c>

0080161a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80161a:	f3 0f 1e fb          	endbr32 
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	56                   	push   %esi
  801622:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801623:	83 ec 08             	sub    $0x8,%esp
  801626:	6a 00                	push   $0x0
  801628:	ff 75 08             	pushl  0x8(%ebp)
  80162b:	e8 fb 01 00 00       	call   80182b <open>
  801630:	89 c3                	mov    %eax,%ebx
  801632:	83 c4 10             	add    $0x10,%esp
  801635:	85 c0                	test   %eax,%eax
  801637:	78 1b                	js     801654 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801639:	83 ec 08             	sub    $0x8,%esp
  80163c:	ff 75 0c             	pushl  0xc(%ebp)
  80163f:	50                   	push   %eax
  801640:	e8 5d ff ff ff       	call   8015a2 <fstat>
  801645:	89 c6                	mov    %eax,%esi
	close(fd);
  801647:	89 1c 24             	mov    %ebx,(%esp)
  80164a:	e8 fd fb ff ff       	call   80124c <close>
	return r;
  80164f:	83 c4 10             	add    $0x10,%esp
  801652:	89 f3                	mov    %esi,%ebx
}
  801654:	89 d8                	mov    %ebx,%eax
  801656:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801659:	5b                   	pop    %ebx
  80165a:	5e                   	pop    %esi
  80165b:	5d                   	pop    %ebp
  80165c:	c3                   	ret    

0080165d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	56                   	push   %esi
  801661:	53                   	push   %ebx
  801662:	89 c6                	mov    %eax,%esi
  801664:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801666:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80166d:	74 27                	je     801696 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80166f:	6a 07                	push   $0x7
  801671:	68 00 50 80 00       	push   $0x805000
  801676:	56                   	push   %esi
  801677:	ff 35 00 40 80 00    	pushl  0x804000
  80167d:	e8 fc 0d 00 00       	call   80247e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801682:	83 c4 0c             	add    $0xc,%esp
  801685:	6a 00                	push   $0x0
  801687:	53                   	push   %ebx
  801688:	6a 00                	push   $0x0
  80168a:	e8 6a 0d 00 00       	call   8023f9 <ipc_recv>
}
  80168f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801692:	5b                   	pop    %ebx
  801693:	5e                   	pop    %esi
  801694:	5d                   	pop    %ebp
  801695:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801696:	83 ec 0c             	sub    $0xc,%esp
  801699:	6a 01                	push   $0x1
  80169b:	e8 36 0e 00 00       	call   8024d6 <ipc_find_env>
  8016a0:	a3 00 40 80 00       	mov    %eax,0x804000
  8016a5:	83 c4 10             	add    $0x10,%esp
  8016a8:	eb c5                	jmp    80166f <fsipc+0x12>

008016aa <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016aa:	f3 0f 1e fb          	endbr32 
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ba:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c2:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016cc:	b8 02 00 00 00       	mov    $0x2,%eax
  8016d1:	e8 87 ff ff ff       	call   80165d <fsipc>
}
  8016d6:	c9                   	leave  
  8016d7:	c3                   	ret    

008016d8 <devfile_flush>:
{
  8016d8:	f3 0f 1e fb          	endbr32 
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e8:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f2:	b8 06 00 00 00       	mov    $0x6,%eax
  8016f7:	e8 61 ff ff ff       	call   80165d <fsipc>
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <devfile_stat>:
{
  8016fe:	f3 0f 1e fb          	endbr32 
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	53                   	push   %ebx
  801706:	83 ec 04             	sub    $0x4,%esp
  801709:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	8b 40 0c             	mov    0xc(%eax),%eax
  801712:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801717:	ba 00 00 00 00       	mov    $0x0,%edx
  80171c:	b8 05 00 00 00       	mov    $0x5,%eax
  801721:	e8 37 ff ff ff       	call   80165d <fsipc>
  801726:	85 c0                	test   %eax,%eax
  801728:	78 2c                	js     801756 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80172a:	83 ec 08             	sub    $0x8,%esp
  80172d:	68 00 50 80 00       	push   $0x805000
  801732:	53                   	push   %ebx
  801733:	e8 f0 f0 ff ff       	call   800828 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801738:	a1 80 50 80 00       	mov    0x805080,%eax
  80173d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801743:	a1 84 50 80 00       	mov    0x805084,%eax
  801748:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801756:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <devfile_write>:
{
  80175b:	f3 0f 1e fb          	endbr32 
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	83 ec 0c             	sub    $0xc,%esp
  801765:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801768:	8b 55 08             	mov    0x8(%ebp),%edx
  80176b:	8b 52 0c             	mov    0xc(%edx),%edx
  80176e:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801774:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801779:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80177e:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801781:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801786:	50                   	push   %eax
  801787:	ff 75 0c             	pushl  0xc(%ebp)
  80178a:	68 08 50 80 00       	push   $0x805008
  80178f:	e8 4a f2 ff ff       	call   8009de <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801794:	ba 00 00 00 00       	mov    $0x0,%edx
  801799:	b8 04 00 00 00       	mov    $0x4,%eax
  80179e:	e8 ba fe ff ff       	call   80165d <fsipc>
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <devfile_read>:
{
  8017a5:	f3 0f 1e fb          	endbr32 
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	56                   	push   %esi
  8017ad:	53                   	push   %ebx
  8017ae:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017bc:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c7:	b8 03 00 00 00       	mov    $0x3,%eax
  8017cc:	e8 8c fe ff ff       	call   80165d <fsipc>
  8017d1:	89 c3                	mov    %eax,%ebx
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	78 1f                	js     8017f6 <devfile_read+0x51>
	assert(r <= n);
  8017d7:	39 f0                	cmp    %esi,%eax
  8017d9:	77 24                	ja     8017ff <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8017db:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017e0:	7f 33                	jg     801815 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017e2:	83 ec 04             	sub    $0x4,%esp
  8017e5:	50                   	push   %eax
  8017e6:	68 00 50 80 00       	push   $0x805000
  8017eb:	ff 75 0c             	pushl  0xc(%ebp)
  8017ee:	e8 eb f1 ff ff       	call   8009de <memmove>
	return r;
  8017f3:	83 c4 10             	add    $0x10,%esp
}
  8017f6:	89 d8                	mov    %ebx,%eax
  8017f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017fb:	5b                   	pop    %ebx
  8017fc:	5e                   	pop    %esi
  8017fd:	5d                   	pop    %ebp
  8017fe:	c3                   	ret    
	assert(r <= n);
  8017ff:	68 bc 2b 80 00       	push   $0x802bbc
  801804:	68 c3 2b 80 00       	push   $0x802bc3
  801809:	6a 7c                	push   $0x7c
  80180b:	68 d8 2b 80 00       	push   $0x802bd8
  801810:	e8 9a 0b 00 00       	call   8023af <_panic>
	assert(r <= PGSIZE);
  801815:	68 e3 2b 80 00       	push   $0x802be3
  80181a:	68 c3 2b 80 00       	push   $0x802bc3
  80181f:	6a 7d                	push   $0x7d
  801821:	68 d8 2b 80 00       	push   $0x802bd8
  801826:	e8 84 0b 00 00       	call   8023af <_panic>

0080182b <open>:
{
  80182b:	f3 0f 1e fb          	endbr32 
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	56                   	push   %esi
  801833:	53                   	push   %ebx
  801834:	83 ec 1c             	sub    $0x1c,%esp
  801837:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80183a:	56                   	push   %esi
  80183b:	e8 a5 ef ff ff       	call   8007e5 <strlen>
  801840:	83 c4 10             	add    $0x10,%esp
  801843:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801848:	7f 6c                	jg     8018b6 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  80184a:	83 ec 0c             	sub    $0xc,%esp
  80184d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801850:	50                   	push   %eax
  801851:	e8 62 f8 ff ff       	call   8010b8 <fd_alloc>
  801856:	89 c3                	mov    %eax,%ebx
  801858:	83 c4 10             	add    $0x10,%esp
  80185b:	85 c0                	test   %eax,%eax
  80185d:	78 3c                	js     80189b <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  80185f:	83 ec 08             	sub    $0x8,%esp
  801862:	56                   	push   %esi
  801863:	68 00 50 80 00       	push   $0x805000
  801868:	e8 bb ef ff ff       	call   800828 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80186d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801870:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801875:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801878:	b8 01 00 00 00       	mov    $0x1,%eax
  80187d:	e8 db fd ff ff       	call   80165d <fsipc>
  801882:	89 c3                	mov    %eax,%ebx
  801884:	83 c4 10             	add    $0x10,%esp
  801887:	85 c0                	test   %eax,%eax
  801889:	78 19                	js     8018a4 <open+0x79>
	return fd2num(fd);
  80188b:	83 ec 0c             	sub    $0xc,%esp
  80188e:	ff 75 f4             	pushl  -0xc(%ebp)
  801891:	e8 f3 f7 ff ff       	call   801089 <fd2num>
  801896:	89 c3                	mov    %eax,%ebx
  801898:	83 c4 10             	add    $0x10,%esp
}
  80189b:	89 d8                	mov    %ebx,%eax
  80189d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a0:	5b                   	pop    %ebx
  8018a1:	5e                   	pop    %esi
  8018a2:	5d                   	pop    %ebp
  8018a3:	c3                   	ret    
		fd_close(fd, 0);
  8018a4:	83 ec 08             	sub    $0x8,%esp
  8018a7:	6a 00                	push   $0x0
  8018a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ac:	e8 10 f9 ff ff       	call   8011c1 <fd_close>
		return r;
  8018b1:	83 c4 10             	add    $0x10,%esp
  8018b4:	eb e5                	jmp    80189b <open+0x70>
		return -E_BAD_PATH;
  8018b6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018bb:	eb de                	jmp    80189b <open+0x70>

008018bd <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018bd:	f3 0f 1e fb          	endbr32 
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cc:	b8 08 00 00 00       	mov    $0x8,%eax
  8018d1:	e8 87 fd ff ff       	call   80165d <fsipc>
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8018d8:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8018dc:	7f 01                	jg     8018df <writebuf+0x7>
  8018de:	c3                   	ret    
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
  8018e2:	53                   	push   %ebx
  8018e3:	83 ec 08             	sub    $0x8,%esp
  8018e6:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8018e8:	ff 70 04             	pushl  0x4(%eax)
  8018eb:	8d 40 10             	lea    0x10(%eax),%eax
  8018ee:	50                   	push   %eax
  8018ef:	ff 33                	pushl  (%ebx)
  8018f1:	e8 76 fb ff ff       	call   80146c <write>
		if (result > 0)
  8018f6:	83 c4 10             	add    $0x10,%esp
  8018f9:	85 c0                	test   %eax,%eax
  8018fb:	7e 03                	jle    801900 <writebuf+0x28>
			b->result += result;
  8018fd:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801900:	39 43 04             	cmp    %eax,0x4(%ebx)
  801903:	74 0d                	je     801912 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801905:	85 c0                	test   %eax,%eax
  801907:	ba 00 00 00 00       	mov    $0x0,%edx
  80190c:	0f 4f c2             	cmovg  %edx,%eax
  80190f:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801912:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <putch>:

static void
putch(int ch, void *thunk)
{
  801917:	f3 0f 1e fb          	endbr32 
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	53                   	push   %ebx
  80191f:	83 ec 04             	sub    $0x4,%esp
  801922:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801925:	8b 53 04             	mov    0x4(%ebx),%edx
  801928:	8d 42 01             	lea    0x1(%edx),%eax
  80192b:	89 43 04             	mov    %eax,0x4(%ebx)
  80192e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801931:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801935:	3d 00 01 00 00       	cmp    $0x100,%eax
  80193a:	74 06                	je     801942 <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  80193c:	83 c4 04             	add    $0x4,%esp
  80193f:	5b                   	pop    %ebx
  801940:	5d                   	pop    %ebp
  801941:	c3                   	ret    
		writebuf(b);
  801942:	89 d8                	mov    %ebx,%eax
  801944:	e8 8f ff ff ff       	call   8018d8 <writebuf>
		b->idx = 0;
  801949:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801950:	eb ea                	jmp    80193c <putch+0x25>

00801952 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801952:	f3 0f 1e fb          	endbr32 
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
  801959:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801968:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  80196f:	00 00 00 
	b.result = 0;
  801972:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801979:	00 00 00 
	b.error = 1;
  80197c:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801983:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801986:	ff 75 10             	pushl  0x10(%ebp)
  801989:	ff 75 0c             	pushl  0xc(%ebp)
  80198c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801992:	50                   	push   %eax
  801993:	68 17 19 80 00       	push   $0x801917
  801998:	e8 84 e9 ff ff       	call   800321 <vprintfmt>
	if (b.idx > 0)
  80199d:	83 c4 10             	add    $0x10,%esp
  8019a0:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8019a7:	7f 11                	jg     8019ba <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8019a9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8019af:	85 c0                	test   %eax,%eax
  8019b1:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    
		writebuf(&b);
  8019ba:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8019c0:	e8 13 ff ff ff       	call   8018d8 <writebuf>
  8019c5:	eb e2                	jmp    8019a9 <vfprintf+0x57>

008019c7 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8019c7:	f3 0f 1e fb          	endbr32 
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
  8019ce:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8019d1:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8019d4:	50                   	push   %eax
  8019d5:	ff 75 0c             	pushl  0xc(%ebp)
  8019d8:	ff 75 08             	pushl  0x8(%ebp)
  8019db:	e8 72 ff ff ff       	call   801952 <vfprintf>
	va_end(ap);

	return cnt;
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <printf>:

int
printf(const char *fmt, ...)
{
  8019e2:	f3 0f 1e fb          	endbr32 
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8019ec:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8019ef:	50                   	push   %eax
  8019f0:	ff 75 08             	pushl  0x8(%ebp)
  8019f3:	6a 01                	push   $0x1
  8019f5:	e8 58 ff ff ff       	call   801952 <vfprintf>
	va_end(ap);

	return cnt;
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019fc:	f3 0f 1e fb          	endbr32 
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a06:	68 ef 2b 80 00       	push   $0x802bef
  801a0b:	ff 75 0c             	pushl  0xc(%ebp)
  801a0e:	e8 15 ee ff ff       	call   800828 <strcpy>
	return 0;
}
  801a13:	b8 00 00 00 00       	mov    $0x0,%eax
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <devsock_close>:
{
  801a1a:	f3 0f 1e fb          	endbr32 
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
  801a21:	53                   	push   %ebx
  801a22:	83 ec 10             	sub    $0x10,%esp
  801a25:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a28:	53                   	push   %ebx
  801a29:	e8 e5 0a 00 00       	call   802513 <pageref>
  801a2e:	89 c2                	mov    %eax,%edx
  801a30:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a33:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801a38:	83 fa 01             	cmp    $0x1,%edx
  801a3b:	74 05                	je     801a42 <devsock_close+0x28>
}
  801a3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a42:	83 ec 0c             	sub    $0xc,%esp
  801a45:	ff 73 0c             	pushl  0xc(%ebx)
  801a48:	e8 e3 02 00 00       	call   801d30 <nsipc_close>
  801a4d:	83 c4 10             	add    $0x10,%esp
  801a50:	eb eb                	jmp    801a3d <devsock_close+0x23>

00801a52 <devsock_write>:
{
  801a52:	f3 0f 1e fb          	endbr32 
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a5c:	6a 00                	push   $0x0
  801a5e:	ff 75 10             	pushl  0x10(%ebp)
  801a61:	ff 75 0c             	pushl  0xc(%ebp)
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	ff 70 0c             	pushl  0xc(%eax)
  801a6a:	e8 b5 03 00 00       	call   801e24 <nsipc_send>
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <devsock_read>:
{
  801a71:	f3 0f 1e fb          	endbr32 
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
  801a78:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a7b:	6a 00                	push   $0x0
  801a7d:	ff 75 10             	pushl  0x10(%ebp)
  801a80:	ff 75 0c             	pushl  0xc(%ebp)
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	ff 70 0c             	pushl  0xc(%eax)
  801a89:	e8 1f 03 00 00       	call   801dad <nsipc_recv>
}
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <fd2sockid>:
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
  801a93:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a96:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a99:	52                   	push   %edx
  801a9a:	50                   	push   %eax
  801a9b:	e8 6e f6 ff ff       	call   80110e <fd_lookup>
  801aa0:	83 c4 10             	add    $0x10,%esp
  801aa3:	85 c0                	test   %eax,%eax
  801aa5:	78 10                	js     801ab7 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aaa:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801ab0:	39 08                	cmp    %ecx,(%eax)
  801ab2:	75 05                	jne    801ab9 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ab4:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    
		return -E_NOT_SUPP;
  801ab9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801abe:	eb f7                	jmp    801ab7 <fd2sockid+0x27>

00801ac0 <alloc_sockfd>:
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	56                   	push   %esi
  801ac4:	53                   	push   %ebx
  801ac5:	83 ec 1c             	sub    $0x1c,%esp
  801ac8:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801aca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801acd:	50                   	push   %eax
  801ace:	e8 e5 f5 ff ff       	call   8010b8 <fd_alloc>
  801ad3:	89 c3                	mov    %eax,%ebx
  801ad5:	83 c4 10             	add    $0x10,%esp
  801ad8:	85 c0                	test   %eax,%eax
  801ada:	78 43                	js     801b1f <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801adc:	83 ec 04             	sub    $0x4,%esp
  801adf:	68 07 04 00 00       	push   $0x407
  801ae4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ae7:	6a 00                	push   $0x0
  801ae9:	e8 7c f1 ff ff       	call   800c6a <sys_page_alloc>
  801aee:	89 c3                	mov    %eax,%ebx
  801af0:	83 c4 10             	add    $0x10,%esp
  801af3:	85 c0                	test   %eax,%eax
  801af5:	78 28                	js     801b1f <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afa:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b00:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b05:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b0c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b0f:	83 ec 0c             	sub    $0xc,%esp
  801b12:	50                   	push   %eax
  801b13:	e8 71 f5 ff ff       	call   801089 <fd2num>
  801b18:	89 c3                	mov    %eax,%ebx
  801b1a:	83 c4 10             	add    $0x10,%esp
  801b1d:	eb 0c                	jmp    801b2b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b1f:	83 ec 0c             	sub    $0xc,%esp
  801b22:	56                   	push   %esi
  801b23:	e8 08 02 00 00       	call   801d30 <nsipc_close>
		return r;
  801b28:	83 c4 10             	add    $0x10,%esp
}
  801b2b:	89 d8                	mov    %ebx,%eax
  801b2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b30:	5b                   	pop    %ebx
  801b31:	5e                   	pop    %esi
  801b32:	5d                   	pop    %ebp
  801b33:	c3                   	ret    

00801b34 <accept>:
{
  801b34:	f3 0f 1e fb          	endbr32 
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
  801b3b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	e8 4a ff ff ff       	call   801a90 <fd2sockid>
  801b46:	85 c0                	test   %eax,%eax
  801b48:	78 1b                	js     801b65 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b4a:	83 ec 04             	sub    $0x4,%esp
  801b4d:	ff 75 10             	pushl  0x10(%ebp)
  801b50:	ff 75 0c             	pushl  0xc(%ebp)
  801b53:	50                   	push   %eax
  801b54:	e8 22 01 00 00       	call   801c7b <nsipc_accept>
  801b59:	83 c4 10             	add    $0x10,%esp
  801b5c:	85 c0                	test   %eax,%eax
  801b5e:	78 05                	js     801b65 <accept+0x31>
	return alloc_sockfd(r);
  801b60:	e8 5b ff ff ff       	call   801ac0 <alloc_sockfd>
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <bind>:
{
  801b67:	f3 0f 1e fb          	endbr32 
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	e8 17 ff ff ff       	call   801a90 <fd2sockid>
  801b79:	85 c0                	test   %eax,%eax
  801b7b:	78 12                	js     801b8f <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801b7d:	83 ec 04             	sub    $0x4,%esp
  801b80:	ff 75 10             	pushl  0x10(%ebp)
  801b83:	ff 75 0c             	pushl  0xc(%ebp)
  801b86:	50                   	push   %eax
  801b87:	e8 45 01 00 00       	call   801cd1 <nsipc_bind>
  801b8c:	83 c4 10             	add    $0x10,%esp
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <shutdown>:
{
  801b91:	f3 0f 1e fb          	endbr32 
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	e8 ed fe ff ff       	call   801a90 <fd2sockid>
  801ba3:	85 c0                	test   %eax,%eax
  801ba5:	78 0f                	js     801bb6 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801ba7:	83 ec 08             	sub    $0x8,%esp
  801baa:	ff 75 0c             	pushl  0xc(%ebp)
  801bad:	50                   	push   %eax
  801bae:	e8 57 01 00 00       	call   801d0a <nsipc_shutdown>
  801bb3:	83 c4 10             	add    $0x10,%esp
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <connect>:
{
  801bb8:	f3 0f 1e fb          	endbr32 
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
  801bbf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc5:	e8 c6 fe ff ff       	call   801a90 <fd2sockid>
  801bca:	85 c0                	test   %eax,%eax
  801bcc:	78 12                	js     801be0 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801bce:	83 ec 04             	sub    $0x4,%esp
  801bd1:	ff 75 10             	pushl  0x10(%ebp)
  801bd4:	ff 75 0c             	pushl  0xc(%ebp)
  801bd7:	50                   	push   %eax
  801bd8:	e8 71 01 00 00       	call   801d4e <nsipc_connect>
  801bdd:	83 c4 10             	add    $0x10,%esp
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <listen>:
{
  801be2:	f3 0f 1e fb          	endbr32 
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bec:	8b 45 08             	mov    0x8(%ebp),%eax
  801bef:	e8 9c fe ff ff       	call   801a90 <fd2sockid>
  801bf4:	85 c0                	test   %eax,%eax
  801bf6:	78 0f                	js     801c07 <listen+0x25>
	return nsipc_listen(r, backlog);
  801bf8:	83 ec 08             	sub    $0x8,%esp
  801bfb:	ff 75 0c             	pushl  0xc(%ebp)
  801bfe:	50                   	push   %eax
  801bff:	e8 83 01 00 00       	call   801d87 <nsipc_listen>
  801c04:	83 c4 10             	add    $0x10,%esp
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <socket>:

int
socket(int domain, int type, int protocol)
{
  801c09:	f3 0f 1e fb          	endbr32 
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
  801c10:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c13:	ff 75 10             	pushl  0x10(%ebp)
  801c16:	ff 75 0c             	pushl  0xc(%ebp)
  801c19:	ff 75 08             	pushl  0x8(%ebp)
  801c1c:	e8 65 02 00 00       	call   801e86 <nsipc_socket>
  801c21:	83 c4 10             	add    $0x10,%esp
  801c24:	85 c0                	test   %eax,%eax
  801c26:	78 05                	js     801c2d <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801c28:	e8 93 fe ff ff       	call   801ac0 <alloc_sockfd>
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	53                   	push   %ebx
  801c33:	83 ec 04             	sub    $0x4,%esp
  801c36:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c38:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c3f:	74 26                	je     801c67 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c41:	6a 07                	push   $0x7
  801c43:	68 00 60 80 00       	push   $0x806000
  801c48:	53                   	push   %ebx
  801c49:	ff 35 04 40 80 00    	pushl  0x804004
  801c4f:	e8 2a 08 00 00       	call   80247e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c54:	83 c4 0c             	add    $0xc,%esp
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	e8 97 07 00 00       	call   8023f9 <ipc_recv>
}
  801c62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c67:	83 ec 0c             	sub    $0xc,%esp
  801c6a:	6a 02                	push   $0x2
  801c6c:	e8 65 08 00 00       	call   8024d6 <ipc_find_env>
  801c71:	a3 04 40 80 00       	mov    %eax,0x804004
  801c76:	83 c4 10             	add    $0x10,%esp
  801c79:	eb c6                	jmp    801c41 <nsipc+0x12>

00801c7b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c7b:	f3 0f 1e fb          	endbr32 
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	56                   	push   %esi
  801c83:	53                   	push   %ebx
  801c84:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c8f:	8b 06                	mov    (%esi),%eax
  801c91:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c96:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9b:	e8 8f ff ff ff       	call   801c2f <nsipc>
  801ca0:	89 c3                	mov    %eax,%ebx
  801ca2:	85 c0                	test   %eax,%eax
  801ca4:	79 09                	jns    801caf <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ca6:	89 d8                	mov    %ebx,%eax
  801ca8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cab:	5b                   	pop    %ebx
  801cac:	5e                   	pop    %esi
  801cad:	5d                   	pop    %ebp
  801cae:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801caf:	83 ec 04             	sub    $0x4,%esp
  801cb2:	ff 35 10 60 80 00    	pushl  0x806010
  801cb8:	68 00 60 80 00       	push   $0x806000
  801cbd:	ff 75 0c             	pushl  0xc(%ebp)
  801cc0:	e8 19 ed ff ff       	call   8009de <memmove>
		*addrlen = ret->ret_addrlen;
  801cc5:	a1 10 60 80 00       	mov    0x806010,%eax
  801cca:	89 06                	mov    %eax,(%esi)
  801ccc:	83 c4 10             	add    $0x10,%esp
	return r;
  801ccf:	eb d5                	jmp    801ca6 <nsipc_accept+0x2b>

00801cd1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801cd1:	f3 0f 1e fb          	endbr32 
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	53                   	push   %ebx
  801cd9:	83 ec 08             	sub    $0x8,%esp
  801cdc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce2:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ce7:	53                   	push   %ebx
  801ce8:	ff 75 0c             	pushl  0xc(%ebp)
  801ceb:	68 04 60 80 00       	push   $0x806004
  801cf0:	e8 e9 ec ff ff       	call   8009de <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801cf5:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801cfb:	b8 02 00 00 00       	mov    $0x2,%eax
  801d00:	e8 2a ff ff ff       	call   801c2f <nsipc>
}
  801d05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d0a:	f3 0f 1e fb          	endbr32 
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d24:	b8 03 00 00 00       	mov    $0x3,%eax
  801d29:	e8 01 ff ff ff       	call   801c2f <nsipc>
}
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <nsipc_close>:

int
nsipc_close(int s)
{
  801d30:	f3 0f 1e fb          	endbr32 
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3d:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d42:	b8 04 00 00 00       	mov    $0x4,%eax
  801d47:	e8 e3 fe ff ff       	call   801c2f <nsipc>
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d4e:	f3 0f 1e fb          	endbr32 
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
  801d55:	53                   	push   %ebx
  801d56:	83 ec 08             	sub    $0x8,%esp
  801d59:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d64:	53                   	push   %ebx
  801d65:	ff 75 0c             	pushl  0xc(%ebp)
  801d68:	68 04 60 80 00       	push   $0x806004
  801d6d:	e8 6c ec ff ff       	call   8009de <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d72:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d78:	b8 05 00 00 00       	mov    $0x5,%eax
  801d7d:	e8 ad fe ff ff       	call   801c2f <nsipc>
}
  801d82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d87:	f3 0f 1e fb          	endbr32 
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d91:	8b 45 08             	mov    0x8(%ebp),%eax
  801d94:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d9c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801da1:	b8 06 00 00 00       	mov    $0x6,%eax
  801da6:	e8 84 fe ff ff       	call   801c2f <nsipc>
}
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    

00801dad <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801dad:	f3 0f 1e fb          	endbr32 
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	56                   	push   %esi
  801db5:	53                   	push   %ebx
  801db6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801dc1:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801dc7:	8b 45 14             	mov    0x14(%ebp),%eax
  801dca:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801dcf:	b8 07 00 00 00       	mov    $0x7,%eax
  801dd4:	e8 56 fe ff ff       	call   801c2f <nsipc>
  801dd9:	89 c3                	mov    %eax,%ebx
  801ddb:	85 c0                	test   %eax,%eax
  801ddd:	78 26                	js     801e05 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801ddf:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801de5:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801dea:	0f 4e c6             	cmovle %esi,%eax
  801ded:	39 c3                	cmp    %eax,%ebx
  801def:	7f 1d                	jg     801e0e <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801df1:	83 ec 04             	sub    $0x4,%esp
  801df4:	53                   	push   %ebx
  801df5:	68 00 60 80 00       	push   $0x806000
  801dfa:	ff 75 0c             	pushl  0xc(%ebp)
  801dfd:	e8 dc eb ff ff       	call   8009de <memmove>
  801e02:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801e05:	89 d8                	mov    %ebx,%eax
  801e07:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e0a:	5b                   	pop    %ebx
  801e0b:	5e                   	pop    %esi
  801e0c:	5d                   	pop    %ebp
  801e0d:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e0e:	68 fb 2b 80 00       	push   $0x802bfb
  801e13:	68 c3 2b 80 00       	push   $0x802bc3
  801e18:	6a 62                	push   $0x62
  801e1a:	68 10 2c 80 00       	push   $0x802c10
  801e1f:	e8 8b 05 00 00       	call   8023af <_panic>

00801e24 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e24:	f3 0f 1e fb          	endbr32 
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
  801e2b:	53                   	push   %ebx
  801e2c:	83 ec 04             	sub    $0x4,%esp
  801e2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e32:	8b 45 08             	mov    0x8(%ebp),%eax
  801e35:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e3a:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e40:	7f 2e                	jg     801e70 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e42:	83 ec 04             	sub    $0x4,%esp
  801e45:	53                   	push   %ebx
  801e46:	ff 75 0c             	pushl  0xc(%ebp)
  801e49:	68 0c 60 80 00       	push   $0x80600c
  801e4e:	e8 8b eb ff ff       	call   8009de <memmove>
	nsipcbuf.send.req_size = size;
  801e53:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e59:	8b 45 14             	mov    0x14(%ebp),%eax
  801e5c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e61:	b8 08 00 00 00       	mov    $0x8,%eax
  801e66:	e8 c4 fd ff ff       	call   801c2f <nsipc>
}
  801e6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    
	assert(size < 1600);
  801e70:	68 1c 2c 80 00       	push   $0x802c1c
  801e75:	68 c3 2b 80 00       	push   $0x802bc3
  801e7a:	6a 6d                	push   $0x6d
  801e7c:	68 10 2c 80 00       	push   $0x802c10
  801e81:	e8 29 05 00 00       	call   8023af <_panic>

00801e86 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e86:	f3 0f 1e fb          	endbr32 
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e90:	8b 45 08             	mov    0x8(%ebp),%eax
  801e93:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9b:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea3:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ea8:	b8 09 00 00 00       	mov    $0x9,%eax
  801ead:	e8 7d fd ff ff       	call   801c2f <nsipc>
}
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801eb4:	f3 0f 1e fb          	endbr32 
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
  801ebb:	56                   	push   %esi
  801ebc:	53                   	push   %ebx
  801ebd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ec0:	83 ec 0c             	sub    $0xc,%esp
  801ec3:	ff 75 08             	pushl  0x8(%ebp)
  801ec6:	e8 d2 f1 ff ff       	call   80109d <fd2data>
  801ecb:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ecd:	83 c4 08             	add    $0x8,%esp
  801ed0:	68 28 2c 80 00       	push   $0x802c28
  801ed5:	53                   	push   %ebx
  801ed6:	e8 4d e9 ff ff       	call   800828 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801edb:	8b 46 04             	mov    0x4(%esi),%eax
  801ede:	2b 06                	sub    (%esi),%eax
  801ee0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ee6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801eed:	00 00 00 
	stat->st_dev = &devpipe;
  801ef0:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ef7:	30 80 00 
	return 0;
}
  801efa:	b8 00 00 00 00       	mov    $0x0,%eax
  801eff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f02:	5b                   	pop    %ebx
  801f03:	5e                   	pop    %esi
  801f04:	5d                   	pop    %ebp
  801f05:	c3                   	ret    

00801f06 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f06:	f3 0f 1e fb          	endbr32 
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
  801f0d:	53                   	push   %ebx
  801f0e:	83 ec 0c             	sub    $0xc,%esp
  801f11:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f14:	53                   	push   %ebx
  801f15:	6a 00                	push   $0x0
  801f17:	e8 db ed ff ff       	call   800cf7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f1c:	89 1c 24             	mov    %ebx,(%esp)
  801f1f:	e8 79 f1 ff ff       	call   80109d <fd2data>
  801f24:	83 c4 08             	add    $0x8,%esp
  801f27:	50                   	push   %eax
  801f28:	6a 00                	push   $0x0
  801f2a:	e8 c8 ed ff ff       	call   800cf7 <sys_page_unmap>
}
  801f2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <_pipeisclosed>:
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	57                   	push   %edi
  801f38:	56                   	push   %esi
  801f39:	53                   	push   %ebx
  801f3a:	83 ec 1c             	sub    $0x1c,%esp
  801f3d:	89 c7                	mov    %eax,%edi
  801f3f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801f41:	a1 08 40 80 00       	mov    0x804008,%eax
  801f46:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f49:	83 ec 0c             	sub    $0xc,%esp
  801f4c:	57                   	push   %edi
  801f4d:	e8 c1 05 00 00       	call   802513 <pageref>
  801f52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f55:	89 34 24             	mov    %esi,(%esp)
  801f58:	e8 b6 05 00 00       	call   802513 <pageref>
		nn = thisenv->env_runs;
  801f5d:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f63:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f66:	83 c4 10             	add    $0x10,%esp
  801f69:	39 cb                	cmp    %ecx,%ebx
  801f6b:	74 1b                	je     801f88 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f6d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f70:	75 cf                	jne    801f41 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f72:	8b 42 58             	mov    0x58(%edx),%eax
  801f75:	6a 01                	push   $0x1
  801f77:	50                   	push   %eax
  801f78:	53                   	push   %ebx
  801f79:	68 2f 2c 80 00       	push   $0x802c2f
  801f7e:	e8 9b e2 ff ff       	call   80021e <cprintf>
  801f83:	83 c4 10             	add    $0x10,%esp
  801f86:	eb b9                	jmp    801f41 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f88:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f8b:	0f 94 c0             	sete   %al
  801f8e:	0f b6 c0             	movzbl %al,%eax
}
  801f91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f94:	5b                   	pop    %ebx
  801f95:	5e                   	pop    %esi
  801f96:	5f                   	pop    %edi
  801f97:	5d                   	pop    %ebp
  801f98:	c3                   	ret    

00801f99 <devpipe_write>:
{
  801f99:	f3 0f 1e fb          	endbr32 
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	57                   	push   %edi
  801fa1:	56                   	push   %esi
  801fa2:	53                   	push   %ebx
  801fa3:	83 ec 28             	sub    $0x28,%esp
  801fa6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801fa9:	56                   	push   %esi
  801faa:	e8 ee f0 ff ff       	call   80109d <fd2data>
  801faf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801fb1:	83 c4 10             	add    $0x10,%esp
  801fb4:	bf 00 00 00 00       	mov    $0x0,%edi
  801fb9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801fbc:	74 4f                	je     80200d <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fbe:	8b 43 04             	mov    0x4(%ebx),%eax
  801fc1:	8b 0b                	mov    (%ebx),%ecx
  801fc3:	8d 51 20             	lea    0x20(%ecx),%edx
  801fc6:	39 d0                	cmp    %edx,%eax
  801fc8:	72 14                	jb     801fde <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801fca:	89 da                	mov    %ebx,%edx
  801fcc:	89 f0                	mov    %esi,%eax
  801fce:	e8 61 ff ff ff       	call   801f34 <_pipeisclosed>
  801fd3:	85 c0                	test   %eax,%eax
  801fd5:	75 3b                	jne    802012 <devpipe_write+0x79>
			sys_yield();
  801fd7:	e8 6b ec ff ff       	call   800c47 <sys_yield>
  801fdc:	eb e0                	jmp    801fbe <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fe1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801fe5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801fe8:	89 c2                	mov    %eax,%edx
  801fea:	c1 fa 1f             	sar    $0x1f,%edx
  801fed:	89 d1                	mov    %edx,%ecx
  801fef:	c1 e9 1b             	shr    $0x1b,%ecx
  801ff2:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ff5:	83 e2 1f             	and    $0x1f,%edx
  801ff8:	29 ca                	sub    %ecx,%edx
  801ffa:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ffe:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802002:	83 c0 01             	add    $0x1,%eax
  802005:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802008:	83 c7 01             	add    $0x1,%edi
  80200b:	eb ac                	jmp    801fb9 <devpipe_write+0x20>
	return i;
  80200d:	8b 45 10             	mov    0x10(%ebp),%eax
  802010:	eb 05                	jmp    802017 <devpipe_write+0x7e>
				return 0;
  802012:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802017:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80201a:	5b                   	pop    %ebx
  80201b:	5e                   	pop    %esi
  80201c:	5f                   	pop    %edi
  80201d:	5d                   	pop    %ebp
  80201e:	c3                   	ret    

0080201f <devpipe_read>:
{
  80201f:	f3 0f 1e fb          	endbr32 
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	57                   	push   %edi
  802027:	56                   	push   %esi
  802028:	53                   	push   %ebx
  802029:	83 ec 18             	sub    $0x18,%esp
  80202c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80202f:	57                   	push   %edi
  802030:	e8 68 f0 ff ff       	call   80109d <fd2data>
  802035:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802037:	83 c4 10             	add    $0x10,%esp
  80203a:	be 00 00 00 00       	mov    $0x0,%esi
  80203f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802042:	75 14                	jne    802058 <devpipe_read+0x39>
	return i;
  802044:	8b 45 10             	mov    0x10(%ebp),%eax
  802047:	eb 02                	jmp    80204b <devpipe_read+0x2c>
				return i;
  802049:	89 f0                	mov    %esi,%eax
}
  80204b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80204e:	5b                   	pop    %ebx
  80204f:	5e                   	pop    %esi
  802050:	5f                   	pop    %edi
  802051:	5d                   	pop    %ebp
  802052:	c3                   	ret    
			sys_yield();
  802053:	e8 ef eb ff ff       	call   800c47 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802058:	8b 03                	mov    (%ebx),%eax
  80205a:	3b 43 04             	cmp    0x4(%ebx),%eax
  80205d:	75 18                	jne    802077 <devpipe_read+0x58>
			if (i > 0)
  80205f:	85 f6                	test   %esi,%esi
  802061:	75 e6                	jne    802049 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802063:	89 da                	mov    %ebx,%edx
  802065:	89 f8                	mov    %edi,%eax
  802067:	e8 c8 fe ff ff       	call   801f34 <_pipeisclosed>
  80206c:	85 c0                	test   %eax,%eax
  80206e:	74 e3                	je     802053 <devpipe_read+0x34>
				return 0;
  802070:	b8 00 00 00 00       	mov    $0x0,%eax
  802075:	eb d4                	jmp    80204b <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802077:	99                   	cltd   
  802078:	c1 ea 1b             	shr    $0x1b,%edx
  80207b:	01 d0                	add    %edx,%eax
  80207d:	83 e0 1f             	and    $0x1f,%eax
  802080:	29 d0                	sub    %edx,%eax
  802082:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802087:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80208a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80208d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802090:	83 c6 01             	add    $0x1,%esi
  802093:	eb aa                	jmp    80203f <devpipe_read+0x20>

00802095 <pipe>:
{
  802095:	f3 0f 1e fb          	endbr32 
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	56                   	push   %esi
  80209d:	53                   	push   %ebx
  80209e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8020a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020a4:	50                   	push   %eax
  8020a5:	e8 0e f0 ff ff       	call   8010b8 <fd_alloc>
  8020aa:	89 c3                	mov    %eax,%ebx
  8020ac:	83 c4 10             	add    $0x10,%esp
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	0f 88 23 01 00 00    	js     8021da <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020b7:	83 ec 04             	sub    $0x4,%esp
  8020ba:	68 07 04 00 00       	push   $0x407
  8020bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c2:	6a 00                	push   $0x0
  8020c4:	e8 a1 eb ff ff       	call   800c6a <sys_page_alloc>
  8020c9:	89 c3                	mov    %eax,%ebx
  8020cb:	83 c4 10             	add    $0x10,%esp
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	0f 88 04 01 00 00    	js     8021da <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8020d6:	83 ec 0c             	sub    $0xc,%esp
  8020d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020dc:	50                   	push   %eax
  8020dd:	e8 d6 ef ff ff       	call   8010b8 <fd_alloc>
  8020e2:	89 c3                	mov    %eax,%ebx
  8020e4:	83 c4 10             	add    $0x10,%esp
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	0f 88 db 00 00 00    	js     8021ca <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020ef:	83 ec 04             	sub    $0x4,%esp
  8020f2:	68 07 04 00 00       	push   $0x407
  8020f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8020fa:	6a 00                	push   $0x0
  8020fc:	e8 69 eb ff ff       	call   800c6a <sys_page_alloc>
  802101:	89 c3                	mov    %eax,%ebx
  802103:	83 c4 10             	add    $0x10,%esp
  802106:	85 c0                	test   %eax,%eax
  802108:	0f 88 bc 00 00 00    	js     8021ca <pipe+0x135>
	va = fd2data(fd0);
  80210e:	83 ec 0c             	sub    $0xc,%esp
  802111:	ff 75 f4             	pushl  -0xc(%ebp)
  802114:	e8 84 ef ff ff       	call   80109d <fd2data>
  802119:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80211b:	83 c4 0c             	add    $0xc,%esp
  80211e:	68 07 04 00 00       	push   $0x407
  802123:	50                   	push   %eax
  802124:	6a 00                	push   $0x0
  802126:	e8 3f eb ff ff       	call   800c6a <sys_page_alloc>
  80212b:	89 c3                	mov    %eax,%ebx
  80212d:	83 c4 10             	add    $0x10,%esp
  802130:	85 c0                	test   %eax,%eax
  802132:	0f 88 82 00 00 00    	js     8021ba <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802138:	83 ec 0c             	sub    $0xc,%esp
  80213b:	ff 75 f0             	pushl  -0x10(%ebp)
  80213e:	e8 5a ef ff ff       	call   80109d <fd2data>
  802143:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80214a:	50                   	push   %eax
  80214b:	6a 00                	push   $0x0
  80214d:	56                   	push   %esi
  80214e:	6a 00                	push   $0x0
  802150:	e8 5c eb ff ff       	call   800cb1 <sys_page_map>
  802155:	89 c3                	mov    %eax,%ebx
  802157:	83 c4 20             	add    $0x20,%esp
  80215a:	85 c0                	test   %eax,%eax
  80215c:	78 4e                	js     8021ac <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  80215e:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802163:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802166:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802168:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802172:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802175:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802177:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802181:	83 ec 0c             	sub    $0xc,%esp
  802184:	ff 75 f4             	pushl  -0xc(%ebp)
  802187:	e8 fd ee ff ff       	call   801089 <fd2num>
  80218c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80218f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802191:	83 c4 04             	add    $0x4,%esp
  802194:	ff 75 f0             	pushl  -0x10(%ebp)
  802197:	e8 ed ee ff ff       	call   801089 <fd2num>
  80219c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80219f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8021a2:	83 c4 10             	add    $0x10,%esp
  8021a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021aa:	eb 2e                	jmp    8021da <pipe+0x145>
	sys_page_unmap(0, va);
  8021ac:	83 ec 08             	sub    $0x8,%esp
  8021af:	56                   	push   %esi
  8021b0:	6a 00                	push   $0x0
  8021b2:	e8 40 eb ff ff       	call   800cf7 <sys_page_unmap>
  8021b7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8021ba:	83 ec 08             	sub    $0x8,%esp
  8021bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8021c0:	6a 00                	push   $0x0
  8021c2:	e8 30 eb ff ff       	call   800cf7 <sys_page_unmap>
  8021c7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8021ca:	83 ec 08             	sub    $0x8,%esp
  8021cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8021d0:	6a 00                	push   $0x0
  8021d2:	e8 20 eb ff ff       	call   800cf7 <sys_page_unmap>
  8021d7:	83 c4 10             	add    $0x10,%esp
}
  8021da:	89 d8                	mov    %ebx,%eax
  8021dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021df:	5b                   	pop    %ebx
  8021e0:	5e                   	pop    %esi
  8021e1:	5d                   	pop    %ebp
  8021e2:	c3                   	ret    

008021e3 <pipeisclosed>:
{
  8021e3:	f3 0f 1e fb          	endbr32 
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
  8021ea:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021f0:	50                   	push   %eax
  8021f1:	ff 75 08             	pushl  0x8(%ebp)
  8021f4:	e8 15 ef ff ff       	call   80110e <fd_lookup>
  8021f9:	83 c4 10             	add    $0x10,%esp
  8021fc:	85 c0                	test   %eax,%eax
  8021fe:	78 18                	js     802218 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802200:	83 ec 0c             	sub    $0xc,%esp
  802203:	ff 75 f4             	pushl  -0xc(%ebp)
  802206:	e8 92 ee ff ff       	call   80109d <fd2data>
  80220b:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80220d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802210:	e8 1f fd ff ff       	call   801f34 <_pipeisclosed>
  802215:	83 c4 10             	add    $0x10,%esp
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80221a:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80221e:	b8 00 00 00 00       	mov    $0x0,%eax
  802223:	c3                   	ret    

00802224 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802224:	f3 0f 1e fb          	endbr32 
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
  80222b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80222e:	68 47 2c 80 00       	push   $0x802c47
  802233:	ff 75 0c             	pushl  0xc(%ebp)
  802236:	e8 ed e5 ff ff       	call   800828 <strcpy>
	return 0;
}
  80223b:	b8 00 00 00 00       	mov    $0x0,%eax
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <devcons_write>:
{
  802242:	f3 0f 1e fb          	endbr32 
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	57                   	push   %edi
  80224a:	56                   	push   %esi
  80224b:	53                   	push   %ebx
  80224c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802252:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802257:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80225d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802260:	73 31                	jae    802293 <devcons_write+0x51>
		m = n - tot;
  802262:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802265:	29 f3                	sub    %esi,%ebx
  802267:	83 fb 7f             	cmp    $0x7f,%ebx
  80226a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80226f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802272:	83 ec 04             	sub    $0x4,%esp
  802275:	53                   	push   %ebx
  802276:	89 f0                	mov    %esi,%eax
  802278:	03 45 0c             	add    0xc(%ebp),%eax
  80227b:	50                   	push   %eax
  80227c:	57                   	push   %edi
  80227d:	e8 5c e7 ff ff       	call   8009de <memmove>
		sys_cputs(buf, m);
  802282:	83 c4 08             	add    $0x8,%esp
  802285:	53                   	push   %ebx
  802286:	57                   	push   %edi
  802287:	e8 0e e9 ff ff       	call   800b9a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80228c:	01 de                	add    %ebx,%esi
  80228e:	83 c4 10             	add    $0x10,%esp
  802291:	eb ca                	jmp    80225d <devcons_write+0x1b>
}
  802293:	89 f0                	mov    %esi,%eax
  802295:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802298:	5b                   	pop    %ebx
  802299:	5e                   	pop    %esi
  80229a:	5f                   	pop    %edi
  80229b:	5d                   	pop    %ebp
  80229c:	c3                   	ret    

0080229d <devcons_read>:
{
  80229d:	f3 0f 1e fb          	endbr32 
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
  8022a4:	83 ec 08             	sub    $0x8,%esp
  8022a7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8022ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022b0:	74 21                	je     8022d3 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8022b2:	e8 05 e9 ff ff       	call   800bbc <sys_cgetc>
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	75 07                	jne    8022c2 <devcons_read+0x25>
		sys_yield();
  8022bb:	e8 87 e9 ff ff       	call   800c47 <sys_yield>
  8022c0:	eb f0                	jmp    8022b2 <devcons_read+0x15>
	if (c < 0)
  8022c2:	78 0f                	js     8022d3 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8022c4:	83 f8 04             	cmp    $0x4,%eax
  8022c7:	74 0c                	je     8022d5 <devcons_read+0x38>
	*(char*)vbuf = c;
  8022c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022cc:	88 02                	mov    %al,(%edx)
	return 1;
  8022ce:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022d3:	c9                   	leave  
  8022d4:	c3                   	ret    
		return 0;
  8022d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022da:	eb f7                	jmp    8022d3 <devcons_read+0x36>

008022dc <cputchar>:
{
  8022dc:	f3 0f 1e fb          	endbr32 
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
  8022e3:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8022ec:	6a 01                	push   $0x1
  8022ee:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022f1:	50                   	push   %eax
  8022f2:	e8 a3 e8 ff ff       	call   800b9a <sys_cputs>
}
  8022f7:	83 c4 10             	add    $0x10,%esp
  8022fa:	c9                   	leave  
  8022fb:	c3                   	ret    

008022fc <getchar>:
{
  8022fc:	f3 0f 1e fb          	endbr32 
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802306:	6a 01                	push   $0x1
  802308:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80230b:	50                   	push   %eax
  80230c:	6a 00                	push   $0x0
  80230e:	e8 83 f0 ff ff       	call   801396 <read>
	if (r < 0)
  802313:	83 c4 10             	add    $0x10,%esp
  802316:	85 c0                	test   %eax,%eax
  802318:	78 06                	js     802320 <getchar+0x24>
	if (r < 1)
  80231a:	74 06                	je     802322 <getchar+0x26>
	return c;
  80231c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802320:	c9                   	leave  
  802321:	c3                   	ret    
		return -E_EOF;
  802322:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802327:	eb f7                	jmp    802320 <getchar+0x24>

00802329 <iscons>:
{
  802329:	f3 0f 1e fb          	endbr32 
  80232d:	55                   	push   %ebp
  80232e:	89 e5                	mov    %esp,%ebp
  802330:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802333:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802336:	50                   	push   %eax
  802337:	ff 75 08             	pushl  0x8(%ebp)
  80233a:	e8 cf ed ff ff       	call   80110e <fd_lookup>
  80233f:	83 c4 10             	add    $0x10,%esp
  802342:	85 c0                	test   %eax,%eax
  802344:	78 11                	js     802357 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802349:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80234f:	39 10                	cmp    %edx,(%eax)
  802351:	0f 94 c0             	sete   %al
  802354:	0f b6 c0             	movzbl %al,%eax
}
  802357:	c9                   	leave  
  802358:	c3                   	ret    

00802359 <opencons>:
{
  802359:	f3 0f 1e fb          	endbr32 
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
  802360:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802363:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802366:	50                   	push   %eax
  802367:	e8 4c ed ff ff       	call   8010b8 <fd_alloc>
  80236c:	83 c4 10             	add    $0x10,%esp
  80236f:	85 c0                	test   %eax,%eax
  802371:	78 3a                	js     8023ad <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802373:	83 ec 04             	sub    $0x4,%esp
  802376:	68 07 04 00 00       	push   $0x407
  80237b:	ff 75 f4             	pushl  -0xc(%ebp)
  80237e:	6a 00                	push   $0x0
  802380:	e8 e5 e8 ff ff       	call   800c6a <sys_page_alloc>
  802385:	83 c4 10             	add    $0x10,%esp
  802388:	85 c0                	test   %eax,%eax
  80238a:	78 21                	js     8023ad <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802395:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023a1:	83 ec 0c             	sub    $0xc,%esp
  8023a4:	50                   	push   %eax
  8023a5:	e8 df ec ff ff       	call   801089 <fd2num>
  8023aa:	83 c4 10             	add    $0x10,%esp
}
  8023ad:	c9                   	leave  
  8023ae:	c3                   	ret    

008023af <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8023af:	f3 0f 1e fb          	endbr32 
  8023b3:	55                   	push   %ebp
  8023b4:	89 e5                	mov    %esp,%ebp
  8023b6:	56                   	push   %esi
  8023b7:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8023b8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8023bb:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8023c1:	e8 5e e8 ff ff       	call   800c24 <sys_getenvid>
  8023c6:	83 ec 0c             	sub    $0xc,%esp
  8023c9:	ff 75 0c             	pushl  0xc(%ebp)
  8023cc:	ff 75 08             	pushl  0x8(%ebp)
  8023cf:	56                   	push   %esi
  8023d0:	50                   	push   %eax
  8023d1:	68 54 2c 80 00       	push   $0x802c54
  8023d6:	e8 43 de ff ff       	call   80021e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8023db:	83 c4 18             	add    $0x18,%esp
  8023de:	53                   	push   %ebx
  8023df:	ff 75 10             	pushl  0x10(%ebp)
  8023e2:	e8 e2 dd ff ff       	call   8001c9 <vcprintf>
	cprintf("\n");
  8023e7:	c7 04 24 d0 27 80 00 	movl   $0x8027d0,(%esp)
  8023ee:	e8 2b de ff ff       	call   80021e <cprintf>
  8023f3:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8023f6:	cc                   	int3   
  8023f7:	eb fd                	jmp    8023f6 <_panic+0x47>

008023f9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023f9:	f3 0f 1e fb          	endbr32 
  8023fd:	55                   	push   %ebp
  8023fe:	89 e5                	mov    %esp,%ebp
  802400:	56                   	push   %esi
  802401:	53                   	push   %ebx
  802402:	8b 75 08             	mov    0x8(%ebp),%esi
  802405:	8b 45 0c             	mov    0xc(%ebp),%eax
  802408:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  80240b:	85 c0                	test   %eax,%eax
  80240d:	74 3d                	je     80244c <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  80240f:	83 ec 0c             	sub    $0xc,%esp
  802412:	50                   	push   %eax
  802413:	e8 1e ea ff ff       	call   800e36 <sys_ipc_recv>
  802418:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  80241b:	85 f6                	test   %esi,%esi
  80241d:	74 0b                	je     80242a <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  80241f:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802425:	8b 52 74             	mov    0x74(%edx),%edx
  802428:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  80242a:	85 db                	test   %ebx,%ebx
  80242c:	74 0b                	je     802439 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  80242e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802434:	8b 52 78             	mov    0x78(%edx),%edx
  802437:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  802439:	85 c0                	test   %eax,%eax
  80243b:	78 21                	js     80245e <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  80243d:	a1 08 40 80 00       	mov    0x804008,%eax
  802442:	8b 40 70             	mov    0x70(%eax),%eax
}
  802445:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802448:	5b                   	pop    %ebx
  802449:	5e                   	pop    %esi
  80244a:	5d                   	pop    %ebp
  80244b:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  80244c:	83 ec 0c             	sub    $0xc,%esp
  80244f:	68 00 00 c0 ee       	push   $0xeec00000
  802454:	e8 dd e9 ff ff       	call   800e36 <sys_ipc_recv>
  802459:	83 c4 10             	add    $0x10,%esp
  80245c:	eb bd                	jmp    80241b <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  80245e:	85 f6                	test   %esi,%esi
  802460:	74 10                	je     802472 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802462:	85 db                	test   %ebx,%ebx
  802464:	75 df                	jne    802445 <ipc_recv+0x4c>
  802466:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80246d:	00 00 00 
  802470:	eb d3                	jmp    802445 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802472:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802479:	00 00 00 
  80247c:	eb e4                	jmp    802462 <ipc_recv+0x69>

0080247e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80247e:	f3 0f 1e fb          	endbr32 
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	57                   	push   %edi
  802486:	56                   	push   %esi
  802487:	53                   	push   %ebx
  802488:	83 ec 0c             	sub    $0xc,%esp
  80248b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80248e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802491:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802494:	85 db                	test   %ebx,%ebx
  802496:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80249b:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  80249e:	ff 75 14             	pushl  0x14(%ebp)
  8024a1:	53                   	push   %ebx
  8024a2:	56                   	push   %esi
  8024a3:	57                   	push   %edi
  8024a4:	e8 66 e9 ff ff       	call   800e0f <sys_ipc_try_send>
  8024a9:	83 c4 10             	add    $0x10,%esp
  8024ac:	85 c0                	test   %eax,%eax
  8024ae:	79 1e                	jns    8024ce <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  8024b0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024b3:	75 07                	jne    8024bc <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  8024b5:	e8 8d e7 ff ff       	call   800c47 <sys_yield>
  8024ba:	eb e2                	jmp    80249e <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  8024bc:	50                   	push   %eax
  8024bd:	68 77 2c 80 00       	push   $0x802c77
  8024c2:	6a 59                	push   $0x59
  8024c4:	68 92 2c 80 00       	push   $0x802c92
  8024c9:	e8 e1 fe ff ff       	call   8023af <_panic>
	}
}
  8024ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024d1:	5b                   	pop    %ebx
  8024d2:	5e                   	pop    %esi
  8024d3:	5f                   	pop    %edi
  8024d4:	5d                   	pop    %ebp
  8024d5:	c3                   	ret    

008024d6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8024d6:	f3 0f 1e fb          	endbr32 
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
  8024dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8024e0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8024e5:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8024e8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8024ee:	8b 52 50             	mov    0x50(%edx),%edx
  8024f1:	39 ca                	cmp    %ecx,%edx
  8024f3:	74 11                	je     802506 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8024f5:	83 c0 01             	add    $0x1,%eax
  8024f8:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024fd:	75 e6                	jne    8024e5 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8024ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802504:	eb 0b                	jmp    802511 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802506:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802509:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80250e:	8b 40 48             	mov    0x48(%eax),%eax
}
  802511:	5d                   	pop    %ebp
  802512:	c3                   	ret    

00802513 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802513:	f3 0f 1e fb          	endbr32 
  802517:	55                   	push   %ebp
  802518:	89 e5                	mov    %esp,%ebp
  80251a:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80251d:	89 c2                	mov    %eax,%edx
  80251f:	c1 ea 16             	shr    $0x16,%edx
  802522:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802529:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80252e:	f6 c1 01             	test   $0x1,%cl
  802531:	74 1c                	je     80254f <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802533:	c1 e8 0c             	shr    $0xc,%eax
  802536:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80253d:	a8 01                	test   $0x1,%al
  80253f:	74 0e                	je     80254f <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802541:	c1 e8 0c             	shr    $0xc,%eax
  802544:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80254b:	ef 
  80254c:	0f b7 d2             	movzwl %dx,%edx
}
  80254f:	89 d0                	mov    %edx,%eax
  802551:	5d                   	pop    %ebp
  802552:	c3                   	ret    
  802553:	66 90                	xchg   %ax,%ax
  802555:	66 90                	xchg   %ax,%ax
  802557:	66 90                	xchg   %ax,%ax
  802559:	66 90                	xchg   %ax,%ax
  80255b:	66 90                	xchg   %ax,%ax
  80255d:	66 90                	xchg   %ax,%ax
  80255f:	90                   	nop

00802560 <__udivdi3>:
  802560:	f3 0f 1e fb          	endbr32 
  802564:	55                   	push   %ebp
  802565:	57                   	push   %edi
  802566:	56                   	push   %esi
  802567:	53                   	push   %ebx
  802568:	83 ec 1c             	sub    $0x1c,%esp
  80256b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80256f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802573:	8b 74 24 34          	mov    0x34(%esp),%esi
  802577:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80257b:	85 d2                	test   %edx,%edx
  80257d:	75 19                	jne    802598 <__udivdi3+0x38>
  80257f:	39 f3                	cmp    %esi,%ebx
  802581:	76 4d                	jbe    8025d0 <__udivdi3+0x70>
  802583:	31 ff                	xor    %edi,%edi
  802585:	89 e8                	mov    %ebp,%eax
  802587:	89 f2                	mov    %esi,%edx
  802589:	f7 f3                	div    %ebx
  80258b:	89 fa                	mov    %edi,%edx
  80258d:	83 c4 1c             	add    $0x1c,%esp
  802590:	5b                   	pop    %ebx
  802591:	5e                   	pop    %esi
  802592:	5f                   	pop    %edi
  802593:	5d                   	pop    %ebp
  802594:	c3                   	ret    
  802595:	8d 76 00             	lea    0x0(%esi),%esi
  802598:	39 f2                	cmp    %esi,%edx
  80259a:	76 14                	jbe    8025b0 <__udivdi3+0x50>
  80259c:	31 ff                	xor    %edi,%edi
  80259e:	31 c0                	xor    %eax,%eax
  8025a0:	89 fa                	mov    %edi,%edx
  8025a2:	83 c4 1c             	add    $0x1c,%esp
  8025a5:	5b                   	pop    %ebx
  8025a6:	5e                   	pop    %esi
  8025a7:	5f                   	pop    %edi
  8025a8:	5d                   	pop    %ebp
  8025a9:	c3                   	ret    
  8025aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025b0:	0f bd fa             	bsr    %edx,%edi
  8025b3:	83 f7 1f             	xor    $0x1f,%edi
  8025b6:	75 48                	jne    802600 <__udivdi3+0xa0>
  8025b8:	39 f2                	cmp    %esi,%edx
  8025ba:	72 06                	jb     8025c2 <__udivdi3+0x62>
  8025bc:	31 c0                	xor    %eax,%eax
  8025be:	39 eb                	cmp    %ebp,%ebx
  8025c0:	77 de                	ja     8025a0 <__udivdi3+0x40>
  8025c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c7:	eb d7                	jmp    8025a0 <__udivdi3+0x40>
  8025c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025d0:	89 d9                	mov    %ebx,%ecx
  8025d2:	85 db                	test   %ebx,%ebx
  8025d4:	75 0b                	jne    8025e1 <__udivdi3+0x81>
  8025d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025db:	31 d2                	xor    %edx,%edx
  8025dd:	f7 f3                	div    %ebx
  8025df:	89 c1                	mov    %eax,%ecx
  8025e1:	31 d2                	xor    %edx,%edx
  8025e3:	89 f0                	mov    %esi,%eax
  8025e5:	f7 f1                	div    %ecx
  8025e7:	89 c6                	mov    %eax,%esi
  8025e9:	89 e8                	mov    %ebp,%eax
  8025eb:	89 f7                	mov    %esi,%edi
  8025ed:	f7 f1                	div    %ecx
  8025ef:	89 fa                	mov    %edi,%edx
  8025f1:	83 c4 1c             	add    $0x1c,%esp
  8025f4:	5b                   	pop    %ebx
  8025f5:	5e                   	pop    %esi
  8025f6:	5f                   	pop    %edi
  8025f7:	5d                   	pop    %ebp
  8025f8:	c3                   	ret    
  8025f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802600:	89 f9                	mov    %edi,%ecx
  802602:	b8 20 00 00 00       	mov    $0x20,%eax
  802607:	29 f8                	sub    %edi,%eax
  802609:	d3 e2                	shl    %cl,%edx
  80260b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80260f:	89 c1                	mov    %eax,%ecx
  802611:	89 da                	mov    %ebx,%edx
  802613:	d3 ea                	shr    %cl,%edx
  802615:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802619:	09 d1                	or     %edx,%ecx
  80261b:	89 f2                	mov    %esi,%edx
  80261d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802621:	89 f9                	mov    %edi,%ecx
  802623:	d3 e3                	shl    %cl,%ebx
  802625:	89 c1                	mov    %eax,%ecx
  802627:	d3 ea                	shr    %cl,%edx
  802629:	89 f9                	mov    %edi,%ecx
  80262b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80262f:	89 eb                	mov    %ebp,%ebx
  802631:	d3 e6                	shl    %cl,%esi
  802633:	89 c1                	mov    %eax,%ecx
  802635:	d3 eb                	shr    %cl,%ebx
  802637:	09 de                	or     %ebx,%esi
  802639:	89 f0                	mov    %esi,%eax
  80263b:	f7 74 24 08          	divl   0x8(%esp)
  80263f:	89 d6                	mov    %edx,%esi
  802641:	89 c3                	mov    %eax,%ebx
  802643:	f7 64 24 0c          	mull   0xc(%esp)
  802647:	39 d6                	cmp    %edx,%esi
  802649:	72 15                	jb     802660 <__udivdi3+0x100>
  80264b:	89 f9                	mov    %edi,%ecx
  80264d:	d3 e5                	shl    %cl,%ebp
  80264f:	39 c5                	cmp    %eax,%ebp
  802651:	73 04                	jae    802657 <__udivdi3+0xf7>
  802653:	39 d6                	cmp    %edx,%esi
  802655:	74 09                	je     802660 <__udivdi3+0x100>
  802657:	89 d8                	mov    %ebx,%eax
  802659:	31 ff                	xor    %edi,%edi
  80265b:	e9 40 ff ff ff       	jmp    8025a0 <__udivdi3+0x40>
  802660:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802663:	31 ff                	xor    %edi,%edi
  802665:	e9 36 ff ff ff       	jmp    8025a0 <__udivdi3+0x40>
  80266a:	66 90                	xchg   %ax,%ax
  80266c:	66 90                	xchg   %ax,%ax
  80266e:	66 90                	xchg   %ax,%ax

00802670 <__umoddi3>:
  802670:	f3 0f 1e fb          	endbr32 
  802674:	55                   	push   %ebp
  802675:	57                   	push   %edi
  802676:	56                   	push   %esi
  802677:	53                   	push   %ebx
  802678:	83 ec 1c             	sub    $0x1c,%esp
  80267b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80267f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802683:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802687:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80268b:	85 c0                	test   %eax,%eax
  80268d:	75 19                	jne    8026a8 <__umoddi3+0x38>
  80268f:	39 df                	cmp    %ebx,%edi
  802691:	76 5d                	jbe    8026f0 <__umoddi3+0x80>
  802693:	89 f0                	mov    %esi,%eax
  802695:	89 da                	mov    %ebx,%edx
  802697:	f7 f7                	div    %edi
  802699:	89 d0                	mov    %edx,%eax
  80269b:	31 d2                	xor    %edx,%edx
  80269d:	83 c4 1c             	add    $0x1c,%esp
  8026a0:	5b                   	pop    %ebx
  8026a1:	5e                   	pop    %esi
  8026a2:	5f                   	pop    %edi
  8026a3:	5d                   	pop    %ebp
  8026a4:	c3                   	ret    
  8026a5:	8d 76 00             	lea    0x0(%esi),%esi
  8026a8:	89 f2                	mov    %esi,%edx
  8026aa:	39 d8                	cmp    %ebx,%eax
  8026ac:	76 12                	jbe    8026c0 <__umoddi3+0x50>
  8026ae:	89 f0                	mov    %esi,%eax
  8026b0:	89 da                	mov    %ebx,%edx
  8026b2:	83 c4 1c             	add    $0x1c,%esp
  8026b5:	5b                   	pop    %ebx
  8026b6:	5e                   	pop    %esi
  8026b7:	5f                   	pop    %edi
  8026b8:	5d                   	pop    %ebp
  8026b9:	c3                   	ret    
  8026ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026c0:	0f bd e8             	bsr    %eax,%ebp
  8026c3:	83 f5 1f             	xor    $0x1f,%ebp
  8026c6:	75 50                	jne    802718 <__umoddi3+0xa8>
  8026c8:	39 d8                	cmp    %ebx,%eax
  8026ca:	0f 82 e0 00 00 00    	jb     8027b0 <__umoddi3+0x140>
  8026d0:	89 d9                	mov    %ebx,%ecx
  8026d2:	39 f7                	cmp    %esi,%edi
  8026d4:	0f 86 d6 00 00 00    	jbe    8027b0 <__umoddi3+0x140>
  8026da:	89 d0                	mov    %edx,%eax
  8026dc:	89 ca                	mov    %ecx,%edx
  8026de:	83 c4 1c             	add    $0x1c,%esp
  8026e1:	5b                   	pop    %ebx
  8026e2:	5e                   	pop    %esi
  8026e3:	5f                   	pop    %edi
  8026e4:	5d                   	pop    %ebp
  8026e5:	c3                   	ret    
  8026e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026ed:	8d 76 00             	lea    0x0(%esi),%esi
  8026f0:	89 fd                	mov    %edi,%ebp
  8026f2:	85 ff                	test   %edi,%edi
  8026f4:	75 0b                	jne    802701 <__umoddi3+0x91>
  8026f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026fb:	31 d2                	xor    %edx,%edx
  8026fd:	f7 f7                	div    %edi
  8026ff:	89 c5                	mov    %eax,%ebp
  802701:	89 d8                	mov    %ebx,%eax
  802703:	31 d2                	xor    %edx,%edx
  802705:	f7 f5                	div    %ebp
  802707:	89 f0                	mov    %esi,%eax
  802709:	f7 f5                	div    %ebp
  80270b:	89 d0                	mov    %edx,%eax
  80270d:	31 d2                	xor    %edx,%edx
  80270f:	eb 8c                	jmp    80269d <__umoddi3+0x2d>
  802711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802718:	89 e9                	mov    %ebp,%ecx
  80271a:	ba 20 00 00 00       	mov    $0x20,%edx
  80271f:	29 ea                	sub    %ebp,%edx
  802721:	d3 e0                	shl    %cl,%eax
  802723:	89 44 24 08          	mov    %eax,0x8(%esp)
  802727:	89 d1                	mov    %edx,%ecx
  802729:	89 f8                	mov    %edi,%eax
  80272b:	d3 e8                	shr    %cl,%eax
  80272d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802731:	89 54 24 04          	mov    %edx,0x4(%esp)
  802735:	8b 54 24 04          	mov    0x4(%esp),%edx
  802739:	09 c1                	or     %eax,%ecx
  80273b:	89 d8                	mov    %ebx,%eax
  80273d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802741:	89 e9                	mov    %ebp,%ecx
  802743:	d3 e7                	shl    %cl,%edi
  802745:	89 d1                	mov    %edx,%ecx
  802747:	d3 e8                	shr    %cl,%eax
  802749:	89 e9                	mov    %ebp,%ecx
  80274b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80274f:	d3 e3                	shl    %cl,%ebx
  802751:	89 c7                	mov    %eax,%edi
  802753:	89 d1                	mov    %edx,%ecx
  802755:	89 f0                	mov    %esi,%eax
  802757:	d3 e8                	shr    %cl,%eax
  802759:	89 e9                	mov    %ebp,%ecx
  80275b:	89 fa                	mov    %edi,%edx
  80275d:	d3 e6                	shl    %cl,%esi
  80275f:	09 d8                	or     %ebx,%eax
  802761:	f7 74 24 08          	divl   0x8(%esp)
  802765:	89 d1                	mov    %edx,%ecx
  802767:	89 f3                	mov    %esi,%ebx
  802769:	f7 64 24 0c          	mull   0xc(%esp)
  80276d:	89 c6                	mov    %eax,%esi
  80276f:	89 d7                	mov    %edx,%edi
  802771:	39 d1                	cmp    %edx,%ecx
  802773:	72 06                	jb     80277b <__umoddi3+0x10b>
  802775:	75 10                	jne    802787 <__umoddi3+0x117>
  802777:	39 c3                	cmp    %eax,%ebx
  802779:	73 0c                	jae    802787 <__umoddi3+0x117>
  80277b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80277f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802783:	89 d7                	mov    %edx,%edi
  802785:	89 c6                	mov    %eax,%esi
  802787:	89 ca                	mov    %ecx,%edx
  802789:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80278e:	29 f3                	sub    %esi,%ebx
  802790:	19 fa                	sbb    %edi,%edx
  802792:	89 d0                	mov    %edx,%eax
  802794:	d3 e0                	shl    %cl,%eax
  802796:	89 e9                	mov    %ebp,%ecx
  802798:	d3 eb                	shr    %cl,%ebx
  80279a:	d3 ea                	shr    %cl,%edx
  80279c:	09 d8                	or     %ebx,%eax
  80279e:	83 c4 1c             	add    $0x1c,%esp
  8027a1:	5b                   	pop    %ebx
  8027a2:	5e                   	pop    %esi
  8027a3:	5f                   	pop    %edi
  8027a4:	5d                   	pop    %ebp
  8027a5:	c3                   	ret    
  8027a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027ad:	8d 76 00             	lea    0x0(%esi),%esi
  8027b0:	29 fe                	sub    %edi,%esi
  8027b2:	19 c3                	sbb    %eax,%ebx
  8027b4:	89 f2                	mov    %esi,%edx
  8027b6:	89 d9                	mov    %ebx,%ecx
  8027b8:	e9 1d ff ff ff       	jmp    8026da <__umoddi3+0x6a>
