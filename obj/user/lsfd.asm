
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
  80003d:	68 60 22 80 00       	push   $0x802260
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
  80006f:	e8 07 0e 00 00       	call   800e7b <argstart>
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
  80008b:	e8 1f 0e 00 00       	call   800eaf <argnext>
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
  8000c5:	68 74 22 80 00       	push   $0x802274
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
  8000df:	e8 0a 14 00 00       	call   8014ee <fstat>
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
  800100:	68 74 22 80 00       	push   $0x802274
  800105:	6a 01                	push   $0x1
  800107:	e8 07 18 00 00       	call   801913 <fprintf>
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
  80013a:	a3 04 40 80 00       	mov    %eax,0x804004

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
  80016d:	e8 57 10 00 00       	call   8011c9 <close_all>
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
  800284:	e8 67 1d 00 00       	call   801ff0 <__udivdi3>
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
  8002c2:	e8 39 1e 00 00       	call   802100 <__umoddi3>
  8002c7:	83 c4 14             	add    $0x14,%esp
  8002ca:	0f be 80 a6 22 80 00 	movsbl 0x8022a6(%eax),%eax
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
  800371:	3e ff 24 85 e0 23 80 	notrack jmp *0x8023e0(,%eax,4)
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
  80043e:	8b 14 85 40 25 80 00 	mov    0x802540(,%eax,4),%edx
  800445:	85 d2                	test   %edx,%edx
  800447:	74 18                	je     800461 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800449:	52                   	push   %edx
  80044a:	68 71 26 80 00       	push   $0x802671
  80044f:	53                   	push   %ebx
  800450:	56                   	push   %esi
  800451:	e8 aa fe ff ff       	call   800300 <printfmt>
  800456:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800459:	89 7d 14             	mov    %edi,0x14(%ebp)
  80045c:	e9 66 02 00 00       	jmp    8006c7 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800461:	50                   	push   %eax
  800462:	68 be 22 80 00       	push   $0x8022be
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
  800489:	b8 b7 22 80 00       	mov    $0x8022b7,%eax
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
  800c13:	68 9f 25 80 00       	push   $0x80259f
  800c18:	6a 23                	push   $0x23
  800c1a:	68 bc 25 80 00       	push   $0x8025bc
  800c1f:	e8 1f 12 00 00       	call   801e43 <_panic>

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
  800ca0:	68 9f 25 80 00       	push   $0x80259f
  800ca5:	6a 23                	push   $0x23
  800ca7:	68 bc 25 80 00       	push   $0x8025bc
  800cac:	e8 92 11 00 00       	call   801e43 <_panic>

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
  800ce6:	68 9f 25 80 00       	push   $0x80259f
  800ceb:	6a 23                	push   $0x23
  800ced:	68 bc 25 80 00       	push   $0x8025bc
  800cf2:	e8 4c 11 00 00       	call   801e43 <_panic>

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
  800d2c:	68 9f 25 80 00       	push   $0x80259f
  800d31:	6a 23                	push   $0x23
  800d33:	68 bc 25 80 00       	push   $0x8025bc
  800d38:	e8 06 11 00 00       	call   801e43 <_panic>

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
  800d72:	68 9f 25 80 00       	push   $0x80259f
  800d77:	6a 23                	push   $0x23
  800d79:	68 bc 25 80 00       	push   $0x8025bc
  800d7e:	e8 c0 10 00 00       	call   801e43 <_panic>

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
  800db8:	68 9f 25 80 00       	push   $0x80259f
  800dbd:	6a 23                	push   $0x23
  800dbf:	68 bc 25 80 00       	push   $0x8025bc
  800dc4:	e8 7a 10 00 00       	call   801e43 <_panic>

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
  800dfe:	68 9f 25 80 00       	push   $0x80259f
  800e03:	6a 23                	push   $0x23
  800e05:	68 bc 25 80 00       	push   $0x8025bc
  800e0a:	e8 34 10 00 00       	call   801e43 <_panic>

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
  800e6a:	68 9f 25 80 00       	push   $0x80259f
  800e6f:	6a 23                	push   $0x23
  800e71:	68 bc 25 80 00       	push   $0x8025bc
  800e76:	e8 c8 0f 00 00       	call   801e43 <_panic>

00800e7b <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800e7b:	f3 0f 1e fb          	endbr32 
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	8b 55 08             	mov    0x8(%ebp),%edx
  800e85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e88:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800e8b:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  800e8d:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800e90:	83 3a 01             	cmpl   $0x1,(%edx)
  800e93:	7e 09                	jle    800e9e <argstart+0x23>
  800e95:	ba 71 22 80 00       	mov    $0x802271,%edx
  800e9a:	85 c9                	test   %ecx,%ecx
  800e9c:	75 05                	jne    800ea3 <argstart+0x28>
  800e9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea3:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  800ea6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  800ead:	5d                   	pop    %ebp
  800eae:	c3                   	ret    

00800eaf <argnext>:

int
argnext(struct Argstate *args)
{
  800eaf:	f3 0f 1e fb          	endbr32 
  800eb3:	55                   	push   %ebp
  800eb4:	89 e5                	mov    %esp,%ebp
  800eb6:	53                   	push   %ebx
  800eb7:	83 ec 04             	sub    $0x4,%esp
  800eba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  800ebd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  800ec4:	8b 43 08             	mov    0x8(%ebx),%eax
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	74 74                	je     800f3f <argnext+0x90>
		return -1;

	if (!*args->curarg) {
  800ecb:	80 38 00             	cmpb   $0x0,(%eax)
  800ece:	75 48                	jne    800f18 <argnext+0x69>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  800ed0:	8b 0b                	mov    (%ebx),%ecx
  800ed2:	83 39 01             	cmpl   $0x1,(%ecx)
  800ed5:	74 5a                	je     800f31 <argnext+0x82>
		    || args->argv[1][0] != '-'
  800ed7:	8b 53 04             	mov    0x4(%ebx),%edx
  800eda:	8b 42 04             	mov    0x4(%edx),%eax
  800edd:	80 38 2d             	cmpb   $0x2d,(%eax)
  800ee0:	75 4f                	jne    800f31 <argnext+0x82>
		    || args->argv[1][1] == '\0')
  800ee2:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800ee6:	74 49                	je     800f31 <argnext+0x82>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  800ee8:	83 c0 01             	add    $0x1,%eax
  800eeb:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800eee:	83 ec 04             	sub    $0x4,%esp
  800ef1:	8b 01                	mov    (%ecx),%eax
  800ef3:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  800efa:	50                   	push   %eax
  800efb:	8d 42 08             	lea    0x8(%edx),%eax
  800efe:	50                   	push   %eax
  800eff:	83 c2 04             	add    $0x4,%edx
  800f02:	52                   	push   %edx
  800f03:	e8 d6 fa ff ff       	call   8009de <memmove>
		(*args->argc)--;
  800f08:	8b 03                	mov    (%ebx),%eax
  800f0a:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800f0d:	8b 43 08             	mov    0x8(%ebx),%eax
  800f10:	83 c4 10             	add    $0x10,%esp
  800f13:	80 38 2d             	cmpb   $0x2d,(%eax)
  800f16:	74 13                	je     800f2b <argnext+0x7c>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  800f18:	8b 43 08             	mov    0x8(%ebx),%eax
  800f1b:	0f b6 10             	movzbl (%eax),%edx
	args->curarg++;
  800f1e:	83 c0 01             	add    $0x1,%eax
  800f21:	89 43 08             	mov    %eax,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  800f24:	89 d0                	mov    %edx,%eax
  800f26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f29:	c9                   	leave  
  800f2a:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800f2b:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800f2f:	75 e7                	jne    800f18 <argnext+0x69>
	args->curarg = 0;
  800f31:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  800f38:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  800f3d:	eb e5                	jmp    800f24 <argnext+0x75>
		return -1;
  800f3f:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  800f44:	eb de                	jmp    800f24 <argnext+0x75>

00800f46 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  800f46:	f3 0f 1e fb          	endbr32 
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	53                   	push   %ebx
  800f4e:	83 ec 04             	sub    $0x4,%esp
  800f51:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  800f54:	8b 43 08             	mov    0x8(%ebx),%eax
  800f57:	85 c0                	test   %eax,%eax
  800f59:	74 12                	je     800f6d <argnextvalue+0x27>
		return 0;
	if (*args->curarg) {
  800f5b:	80 38 00             	cmpb   $0x0,(%eax)
  800f5e:	74 12                	je     800f72 <argnextvalue+0x2c>
		args->argvalue = args->curarg;
  800f60:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  800f63:	c7 43 08 71 22 80 00 	movl   $0x802271,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  800f6a:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  800f6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f70:	c9                   	leave  
  800f71:	c3                   	ret    
	} else if (*args->argc > 1) {
  800f72:	8b 13                	mov    (%ebx),%edx
  800f74:	83 3a 01             	cmpl   $0x1,(%edx)
  800f77:	7f 10                	jg     800f89 <argnextvalue+0x43>
		args->argvalue = 0;
  800f79:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  800f80:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  800f87:	eb e1                	jmp    800f6a <argnextvalue+0x24>
		args->argvalue = args->argv[1];
  800f89:	8b 43 04             	mov    0x4(%ebx),%eax
  800f8c:	8b 48 04             	mov    0x4(%eax),%ecx
  800f8f:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800f92:	83 ec 04             	sub    $0x4,%esp
  800f95:	8b 12                	mov    (%edx),%edx
  800f97:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  800f9e:	52                   	push   %edx
  800f9f:	8d 50 08             	lea    0x8(%eax),%edx
  800fa2:	52                   	push   %edx
  800fa3:	83 c0 04             	add    $0x4,%eax
  800fa6:	50                   	push   %eax
  800fa7:	e8 32 fa ff ff       	call   8009de <memmove>
		(*args->argc)--;
  800fac:	8b 03                	mov    (%ebx),%eax
  800fae:	83 28 01             	subl   $0x1,(%eax)
  800fb1:	83 c4 10             	add    $0x10,%esp
  800fb4:	eb b4                	jmp    800f6a <argnextvalue+0x24>

00800fb6 <argvalue>:
{
  800fb6:	f3 0f 1e fb          	endbr32 
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	83 ec 08             	sub    $0x8,%esp
  800fc0:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  800fc3:	8b 42 0c             	mov    0xc(%edx),%eax
  800fc6:	85 c0                	test   %eax,%eax
  800fc8:	74 02                	je     800fcc <argvalue+0x16>
}
  800fca:	c9                   	leave  
  800fcb:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  800fcc:	83 ec 0c             	sub    $0xc,%esp
  800fcf:	52                   	push   %edx
  800fd0:	e8 71 ff ff ff       	call   800f46 <argnextvalue>
  800fd5:	83 c4 10             	add    $0x10,%esp
  800fd8:	eb f0                	jmp    800fca <argvalue+0x14>

00800fda <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fda:	f3 0f 1e fb          	endbr32 
  800fde:	55                   	push   %ebp
  800fdf:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	05 00 00 00 30       	add    $0x30000000,%eax
  800fe9:	c1 e8 0c             	shr    $0xc,%eax
}
  800fec:	5d                   	pop    %ebp
  800fed:	c3                   	ret    

00800fee <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fee:	f3 0f 1e fb          	endbr32 
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ffd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801002:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801007:	5d                   	pop    %ebp
  801008:	c3                   	ret    

00801009 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801009:	f3 0f 1e fb          	endbr32 
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801015:	89 c2                	mov    %eax,%edx
  801017:	c1 ea 16             	shr    $0x16,%edx
  80101a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801021:	f6 c2 01             	test   $0x1,%dl
  801024:	74 2d                	je     801053 <fd_alloc+0x4a>
  801026:	89 c2                	mov    %eax,%edx
  801028:	c1 ea 0c             	shr    $0xc,%edx
  80102b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801032:	f6 c2 01             	test   $0x1,%dl
  801035:	74 1c                	je     801053 <fd_alloc+0x4a>
  801037:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80103c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801041:	75 d2                	jne    801015 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80104c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801051:	eb 0a                	jmp    80105d <fd_alloc+0x54>
			*fd_store = fd;
  801053:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801056:	89 01                	mov    %eax,(%ecx)
			return 0;
  801058:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80105d:	5d                   	pop    %ebp
  80105e:	c3                   	ret    

0080105f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80105f:	f3 0f 1e fb          	endbr32 
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801069:	83 f8 1f             	cmp    $0x1f,%eax
  80106c:	77 30                	ja     80109e <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80106e:	c1 e0 0c             	shl    $0xc,%eax
  801071:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801076:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80107c:	f6 c2 01             	test   $0x1,%dl
  80107f:	74 24                	je     8010a5 <fd_lookup+0x46>
  801081:	89 c2                	mov    %eax,%edx
  801083:	c1 ea 0c             	shr    $0xc,%edx
  801086:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80108d:	f6 c2 01             	test   $0x1,%dl
  801090:	74 1a                	je     8010ac <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801092:	8b 55 0c             	mov    0xc(%ebp),%edx
  801095:	89 02                	mov    %eax,(%edx)
	return 0;
  801097:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80109c:	5d                   	pop    %ebp
  80109d:	c3                   	ret    
		return -E_INVAL;
  80109e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010a3:	eb f7                	jmp    80109c <fd_lookup+0x3d>
		return -E_INVAL;
  8010a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010aa:	eb f0                	jmp    80109c <fd_lookup+0x3d>
  8010ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010b1:	eb e9                	jmp    80109c <fd_lookup+0x3d>

008010b3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010b3:	f3 0f 1e fb          	endbr32 
  8010b7:	55                   	push   %ebp
  8010b8:	89 e5                	mov    %esp,%ebp
  8010ba:	83 ec 08             	sub    $0x8,%esp
  8010bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c0:	ba 48 26 80 00       	mov    $0x802648,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8010c5:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010ca:	39 08                	cmp    %ecx,(%eax)
  8010cc:	74 33                	je     801101 <dev_lookup+0x4e>
  8010ce:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8010d1:	8b 02                	mov    (%edx),%eax
  8010d3:	85 c0                	test   %eax,%eax
  8010d5:	75 f3                	jne    8010ca <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010d7:	a1 04 40 80 00       	mov    0x804004,%eax
  8010dc:	8b 40 48             	mov    0x48(%eax),%eax
  8010df:	83 ec 04             	sub    $0x4,%esp
  8010e2:	51                   	push   %ecx
  8010e3:	50                   	push   %eax
  8010e4:	68 cc 25 80 00       	push   $0x8025cc
  8010e9:	e8 30 f1 ff ff       	call   80021e <cprintf>
	*dev = 0;
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010f7:	83 c4 10             	add    $0x10,%esp
  8010fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010ff:	c9                   	leave  
  801100:	c3                   	ret    
			*dev = devtab[i];
  801101:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801104:	89 01                	mov    %eax,(%ecx)
			return 0;
  801106:	b8 00 00 00 00       	mov    $0x0,%eax
  80110b:	eb f2                	jmp    8010ff <dev_lookup+0x4c>

0080110d <fd_close>:
{
  80110d:	f3 0f 1e fb          	endbr32 
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	57                   	push   %edi
  801115:	56                   	push   %esi
  801116:	53                   	push   %ebx
  801117:	83 ec 24             	sub    $0x24,%esp
  80111a:	8b 75 08             	mov    0x8(%ebp),%esi
  80111d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801120:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801123:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801124:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80112a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80112d:	50                   	push   %eax
  80112e:	e8 2c ff ff ff       	call   80105f <fd_lookup>
  801133:	89 c3                	mov    %eax,%ebx
  801135:	83 c4 10             	add    $0x10,%esp
  801138:	85 c0                	test   %eax,%eax
  80113a:	78 05                	js     801141 <fd_close+0x34>
	    || fd != fd2)
  80113c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80113f:	74 16                	je     801157 <fd_close+0x4a>
		return (must_exist ? r : 0);
  801141:	89 f8                	mov    %edi,%eax
  801143:	84 c0                	test   %al,%al
  801145:	b8 00 00 00 00       	mov    $0x0,%eax
  80114a:	0f 44 d8             	cmove  %eax,%ebx
}
  80114d:	89 d8                	mov    %ebx,%eax
  80114f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801152:	5b                   	pop    %ebx
  801153:	5e                   	pop    %esi
  801154:	5f                   	pop    %edi
  801155:	5d                   	pop    %ebp
  801156:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801157:	83 ec 08             	sub    $0x8,%esp
  80115a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80115d:	50                   	push   %eax
  80115e:	ff 36                	pushl  (%esi)
  801160:	e8 4e ff ff ff       	call   8010b3 <dev_lookup>
  801165:	89 c3                	mov    %eax,%ebx
  801167:	83 c4 10             	add    $0x10,%esp
  80116a:	85 c0                	test   %eax,%eax
  80116c:	78 1a                	js     801188 <fd_close+0x7b>
		if (dev->dev_close)
  80116e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801171:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801174:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801179:	85 c0                	test   %eax,%eax
  80117b:	74 0b                	je     801188 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80117d:	83 ec 0c             	sub    $0xc,%esp
  801180:	56                   	push   %esi
  801181:	ff d0                	call   *%eax
  801183:	89 c3                	mov    %eax,%ebx
  801185:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801188:	83 ec 08             	sub    $0x8,%esp
  80118b:	56                   	push   %esi
  80118c:	6a 00                	push   $0x0
  80118e:	e8 64 fb ff ff       	call   800cf7 <sys_page_unmap>
	return r;
  801193:	83 c4 10             	add    $0x10,%esp
  801196:	eb b5                	jmp    80114d <fd_close+0x40>

00801198 <close>:

int
close(int fdnum)
{
  801198:	f3 0f 1e fb          	endbr32 
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011a5:	50                   	push   %eax
  8011a6:	ff 75 08             	pushl  0x8(%ebp)
  8011a9:	e8 b1 fe ff ff       	call   80105f <fd_lookup>
  8011ae:	83 c4 10             	add    $0x10,%esp
  8011b1:	85 c0                	test   %eax,%eax
  8011b3:	79 02                	jns    8011b7 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8011b5:	c9                   	leave  
  8011b6:	c3                   	ret    
		return fd_close(fd, 1);
  8011b7:	83 ec 08             	sub    $0x8,%esp
  8011ba:	6a 01                	push   $0x1
  8011bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8011bf:	e8 49 ff ff ff       	call   80110d <fd_close>
  8011c4:	83 c4 10             	add    $0x10,%esp
  8011c7:	eb ec                	jmp    8011b5 <close+0x1d>

008011c9 <close_all>:

void
close_all(void)
{
  8011c9:	f3 0f 1e fb          	endbr32 
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	53                   	push   %ebx
  8011d1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011d4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011d9:	83 ec 0c             	sub    $0xc,%esp
  8011dc:	53                   	push   %ebx
  8011dd:	e8 b6 ff ff ff       	call   801198 <close>
	for (i = 0; i < MAXFD; i++)
  8011e2:	83 c3 01             	add    $0x1,%ebx
  8011e5:	83 c4 10             	add    $0x10,%esp
  8011e8:	83 fb 20             	cmp    $0x20,%ebx
  8011eb:	75 ec                	jne    8011d9 <close_all+0x10>
}
  8011ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f0:	c9                   	leave  
  8011f1:	c3                   	ret    

008011f2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011f2:	f3 0f 1e fb          	endbr32 
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	57                   	push   %edi
  8011fa:	56                   	push   %esi
  8011fb:	53                   	push   %ebx
  8011fc:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801202:	50                   	push   %eax
  801203:	ff 75 08             	pushl  0x8(%ebp)
  801206:	e8 54 fe ff ff       	call   80105f <fd_lookup>
  80120b:	89 c3                	mov    %eax,%ebx
  80120d:	83 c4 10             	add    $0x10,%esp
  801210:	85 c0                	test   %eax,%eax
  801212:	0f 88 81 00 00 00    	js     801299 <dup+0xa7>
		return r;
	close(newfdnum);
  801218:	83 ec 0c             	sub    $0xc,%esp
  80121b:	ff 75 0c             	pushl  0xc(%ebp)
  80121e:	e8 75 ff ff ff       	call   801198 <close>

	newfd = INDEX2FD(newfdnum);
  801223:	8b 75 0c             	mov    0xc(%ebp),%esi
  801226:	c1 e6 0c             	shl    $0xc,%esi
  801229:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80122f:	83 c4 04             	add    $0x4,%esp
  801232:	ff 75 e4             	pushl  -0x1c(%ebp)
  801235:	e8 b4 fd ff ff       	call   800fee <fd2data>
  80123a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80123c:	89 34 24             	mov    %esi,(%esp)
  80123f:	e8 aa fd ff ff       	call   800fee <fd2data>
  801244:	83 c4 10             	add    $0x10,%esp
  801247:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801249:	89 d8                	mov    %ebx,%eax
  80124b:	c1 e8 16             	shr    $0x16,%eax
  80124e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801255:	a8 01                	test   $0x1,%al
  801257:	74 11                	je     80126a <dup+0x78>
  801259:	89 d8                	mov    %ebx,%eax
  80125b:	c1 e8 0c             	shr    $0xc,%eax
  80125e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801265:	f6 c2 01             	test   $0x1,%dl
  801268:	75 39                	jne    8012a3 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80126a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80126d:	89 d0                	mov    %edx,%eax
  80126f:	c1 e8 0c             	shr    $0xc,%eax
  801272:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801279:	83 ec 0c             	sub    $0xc,%esp
  80127c:	25 07 0e 00 00       	and    $0xe07,%eax
  801281:	50                   	push   %eax
  801282:	56                   	push   %esi
  801283:	6a 00                	push   $0x0
  801285:	52                   	push   %edx
  801286:	6a 00                	push   $0x0
  801288:	e8 24 fa ff ff       	call   800cb1 <sys_page_map>
  80128d:	89 c3                	mov    %eax,%ebx
  80128f:	83 c4 20             	add    $0x20,%esp
  801292:	85 c0                	test   %eax,%eax
  801294:	78 31                	js     8012c7 <dup+0xd5>
		goto err;

	return newfdnum;
  801296:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801299:	89 d8                	mov    %ebx,%eax
  80129b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80129e:	5b                   	pop    %ebx
  80129f:	5e                   	pop    %esi
  8012a0:	5f                   	pop    %edi
  8012a1:	5d                   	pop    %ebp
  8012a2:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012a3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012aa:	83 ec 0c             	sub    $0xc,%esp
  8012ad:	25 07 0e 00 00       	and    $0xe07,%eax
  8012b2:	50                   	push   %eax
  8012b3:	57                   	push   %edi
  8012b4:	6a 00                	push   $0x0
  8012b6:	53                   	push   %ebx
  8012b7:	6a 00                	push   $0x0
  8012b9:	e8 f3 f9 ff ff       	call   800cb1 <sys_page_map>
  8012be:	89 c3                	mov    %eax,%ebx
  8012c0:	83 c4 20             	add    $0x20,%esp
  8012c3:	85 c0                	test   %eax,%eax
  8012c5:	79 a3                	jns    80126a <dup+0x78>
	sys_page_unmap(0, newfd);
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	56                   	push   %esi
  8012cb:	6a 00                	push   $0x0
  8012cd:	e8 25 fa ff ff       	call   800cf7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012d2:	83 c4 08             	add    $0x8,%esp
  8012d5:	57                   	push   %edi
  8012d6:	6a 00                	push   $0x0
  8012d8:	e8 1a fa ff ff       	call   800cf7 <sys_page_unmap>
	return r;
  8012dd:	83 c4 10             	add    $0x10,%esp
  8012e0:	eb b7                	jmp    801299 <dup+0xa7>

008012e2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012e2:	f3 0f 1e fb          	endbr32 
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	53                   	push   %ebx
  8012ea:	83 ec 1c             	sub    $0x1c,%esp
  8012ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f3:	50                   	push   %eax
  8012f4:	53                   	push   %ebx
  8012f5:	e8 65 fd ff ff       	call   80105f <fd_lookup>
  8012fa:	83 c4 10             	add    $0x10,%esp
  8012fd:	85 c0                	test   %eax,%eax
  8012ff:	78 3f                	js     801340 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801301:	83 ec 08             	sub    $0x8,%esp
  801304:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801307:	50                   	push   %eax
  801308:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80130b:	ff 30                	pushl  (%eax)
  80130d:	e8 a1 fd ff ff       	call   8010b3 <dev_lookup>
  801312:	83 c4 10             	add    $0x10,%esp
  801315:	85 c0                	test   %eax,%eax
  801317:	78 27                	js     801340 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801319:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80131c:	8b 42 08             	mov    0x8(%edx),%eax
  80131f:	83 e0 03             	and    $0x3,%eax
  801322:	83 f8 01             	cmp    $0x1,%eax
  801325:	74 1e                	je     801345 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80132a:	8b 40 08             	mov    0x8(%eax),%eax
  80132d:	85 c0                	test   %eax,%eax
  80132f:	74 35                	je     801366 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801331:	83 ec 04             	sub    $0x4,%esp
  801334:	ff 75 10             	pushl  0x10(%ebp)
  801337:	ff 75 0c             	pushl  0xc(%ebp)
  80133a:	52                   	push   %edx
  80133b:	ff d0                	call   *%eax
  80133d:	83 c4 10             	add    $0x10,%esp
}
  801340:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801343:	c9                   	leave  
  801344:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801345:	a1 04 40 80 00       	mov    0x804004,%eax
  80134a:	8b 40 48             	mov    0x48(%eax),%eax
  80134d:	83 ec 04             	sub    $0x4,%esp
  801350:	53                   	push   %ebx
  801351:	50                   	push   %eax
  801352:	68 0d 26 80 00       	push   $0x80260d
  801357:	e8 c2 ee ff ff       	call   80021e <cprintf>
		return -E_INVAL;
  80135c:	83 c4 10             	add    $0x10,%esp
  80135f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801364:	eb da                	jmp    801340 <read+0x5e>
		return -E_NOT_SUPP;
  801366:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80136b:	eb d3                	jmp    801340 <read+0x5e>

0080136d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80136d:	f3 0f 1e fb          	endbr32 
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	57                   	push   %edi
  801375:	56                   	push   %esi
  801376:	53                   	push   %ebx
  801377:	83 ec 0c             	sub    $0xc,%esp
  80137a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80137d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801380:	bb 00 00 00 00       	mov    $0x0,%ebx
  801385:	eb 02                	jmp    801389 <readn+0x1c>
  801387:	01 c3                	add    %eax,%ebx
  801389:	39 f3                	cmp    %esi,%ebx
  80138b:	73 21                	jae    8013ae <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80138d:	83 ec 04             	sub    $0x4,%esp
  801390:	89 f0                	mov    %esi,%eax
  801392:	29 d8                	sub    %ebx,%eax
  801394:	50                   	push   %eax
  801395:	89 d8                	mov    %ebx,%eax
  801397:	03 45 0c             	add    0xc(%ebp),%eax
  80139a:	50                   	push   %eax
  80139b:	57                   	push   %edi
  80139c:	e8 41 ff ff ff       	call   8012e2 <read>
		if (m < 0)
  8013a1:	83 c4 10             	add    $0x10,%esp
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	78 04                	js     8013ac <readn+0x3f>
			return m;
		if (m == 0)
  8013a8:	75 dd                	jne    801387 <readn+0x1a>
  8013aa:	eb 02                	jmp    8013ae <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013ac:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013ae:	89 d8                	mov    %ebx,%eax
  8013b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013b3:	5b                   	pop    %ebx
  8013b4:	5e                   	pop    %esi
  8013b5:	5f                   	pop    %edi
  8013b6:	5d                   	pop    %ebp
  8013b7:	c3                   	ret    

008013b8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013b8:	f3 0f 1e fb          	endbr32 
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	53                   	push   %ebx
  8013c0:	83 ec 1c             	sub    $0x1c,%esp
  8013c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013c9:	50                   	push   %eax
  8013ca:	53                   	push   %ebx
  8013cb:	e8 8f fc ff ff       	call   80105f <fd_lookup>
  8013d0:	83 c4 10             	add    $0x10,%esp
  8013d3:	85 c0                	test   %eax,%eax
  8013d5:	78 3a                	js     801411 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013d7:	83 ec 08             	sub    $0x8,%esp
  8013da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013dd:	50                   	push   %eax
  8013de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e1:	ff 30                	pushl  (%eax)
  8013e3:	e8 cb fc ff ff       	call   8010b3 <dev_lookup>
  8013e8:	83 c4 10             	add    $0x10,%esp
  8013eb:	85 c0                	test   %eax,%eax
  8013ed:	78 22                	js     801411 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013f6:	74 1e                	je     801416 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013fb:	8b 52 0c             	mov    0xc(%edx),%edx
  8013fe:	85 d2                	test   %edx,%edx
  801400:	74 35                	je     801437 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801402:	83 ec 04             	sub    $0x4,%esp
  801405:	ff 75 10             	pushl  0x10(%ebp)
  801408:	ff 75 0c             	pushl  0xc(%ebp)
  80140b:	50                   	push   %eax
  80140c:	ff d2                	call   *%edx
  80140e:	83 c4 10             	add    $0x10,%esp
}
  801411:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801414:	c9                   	leave  
  801415:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801416:	a1 04 40 80 00       	mov    0x804004,%eax
  80141b:	8b 40 48             	mov    0x48(%eax),%eax
  80141e:	83 ec 04             	sub    $0x4,%esp
  801421:	53                   	push   %ebx
  801422:	50                   	push   %eax
  801423:	68 29 26 80 00       	push   $0x802629
  801428:	e8 f1 ed ff ff       	call   80021e <cprintf>
		return -E_INVAL;
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801435:	eb da                	jmp    801411 <write+0x59>
		return -E_NOT_SUPP;
  801437:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80143c:	eb d3                	jmp    801411 <write+0x59>

0080143e <seek>:

int
seek(int fdnum, off_t offset)
{
  80143e:	f3 0f 1e fb          	endbr32 
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
  801445:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801448:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80144b:	50                   	push   %eax
  80144c:	ff 75 08             	pushl  0x8(%ebp)
  80144f:	e8 0b fc ff ff       	call   80105f <fd_lookup>
  801454:	83 c4 10             	add    $0x10,%esp
  801457:	85 c0                	test   %eax,%eax
  801459:	78 0e                	js     801469 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80145b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801461:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801464:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801469:	c9                   	leave  
  80146a:	c3                   	ret    

0080146b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80146b:	f3 0f 1e fb          	endbr32 
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	53                   	push   %ebx
  801473:	83 ec 1c             	sub    $0x1c,%esp
  801476:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801479:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80147c:	50                   	push   %eax
  80147d:	53                   	push   %ebx
  80147e:	e8 dc fb ff ff       	call   80105f <fd_lookup>
  801483:	83 c4 10             	add    $0x10,%esp
  801486:	85 c0                	test   %eax,%eax
  801488:	78 37                	js     8014c1 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80148a:	83 ec 08             	sub    $0x8,%esp
  80148d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801490:	50                   	push   %eax
  801491:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801494:	ff 30                	pushl  (%eax)
  801496:	e8 18 fc ff ff       	call   8010b3 <dev_lookup>
  80149b:	83 c4 10             	add    $0x10,%esp
  80149e:	85 c0                	test   %eax,%eax
  8014a0:	78 1f                	js     8014c1 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014a9:	74 1b                	je     8014c6 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ae:	8b 52 18             	mov    0x18(%edx),%edx
  8014b1:	85 d2                	test   %edx,%edx
  8014b3:	74 32                	je     8014e7 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014b5:	83 ec 08             	sub    $0x8,%esp
  8014b8:	ff 75 0c             	pushl  0xc(%ebp)
  8014bb:	50                   	push   %eax
  8014bc:	ff d2                	call   *%edx
  8014be:	83 c4 10             	add    $0x10,%esp
}
  8014c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c4:	c9                   	leave  
  8014c5:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014c6:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014cb:	8b 40 48             	mov    0x48(%eax),%eax
  8014ce:	83 ec 04             	sub    $0x4,%esp
  8014d1:	53                   	push   %ebx
  8014d2:	50                   	push   %eax
  8014d3:	68 ec 25 80 00       	push   $0x8025ec
  8014d8:	e8 41 ed ff ff       	call   80021e <cprintf>
		return -E_INVAL;
  8014dd:	83 c4 10             	add    $0x10,%esp
  8014e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e5:	eb da                	jmp    8014c1 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8014e7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014ec:	eb d3                	jmp    8014c1 <ftruncate+0x56>

008014ee <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014ee:	f3 0f 1e fb          	endbr32 
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
  8014f5:	53                   	push   %ebx
  8014f6:	83 ec 1c             	sub    $0x1c,%esp
  8014f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ff:	50                   	push   %eax
  801500:	ff 75 08             	pushl  0x8(%ebp)
  801503:	e8 57 fb ff ff       	call   80105f <fd_lookup>
  801508:	83 c4 10             	add    $0x10,%esp
  80150b:	85 c0                	test   %eax,%eax
  80150d:	78 4b                	js     80155a <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80150f:	83 ec 08             	sub    $0x8,%esp
  801512:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801515:	50                   	push   %eax
  801516:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801519:	ff 30                	pushl  (%eax)
  80151b:	e8 93 fb ff ff       	call   8010b3 <dev_lookup>
  801520:	83 c4 10             	add    $0x10,%esp
  801523:	85 c0                	test   %eax,%eax
  801525:	78 33                	js     80155a <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80152a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80152e:	74 2f                	je     80155f <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801530:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801533:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80153a:	00 00 00 
	stat->st_isdir = 0;
  80153d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801544:	00 00 00 
	stat->st_dev = dev;
  801547:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80154d:	83 ec 08             	sub    $0x8,%esp
  801550:	53                   	push   %ebx
  801551:	ff 75 f0             	pushl  -0x10(%ebp)
  801554:	ff 50 14             	call   *0x14(%eax)
  801557:	83 c4 10             	add    $0x10,%esp
}
  80155a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    
		return -E_NOT_SUPP;
  80155f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801564:	eb f4                	jmp    80155a <fstat+0x6c>

00801566 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801566:	f3 0f 1e fb          	endbr32 
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	56                   	push   %esi
  80156e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80156f:	83 ec 08             	sub    $0x8,%esp
  801572:	6a 00                	push   $0x0
  801574:	ff 75 08             	pushl  0x8(%ebp)
  801577:	e8 fb 01 00 00       	call   801777 <open>
  80157c:	89 c3                	mov    %eax,%ebx
  80157e:	83 c4 10             	add    $0x10,%esp
  801581:	85 c0                	test   %eax,%eax
  801583:	78 1b                	js     8015a0 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801585:	83 ec 08             	sub    $0x8,%esp
  801588:	ff 75 0c             	pushl  0xc(%ebp)
  80158b:	50                   	push   %eax
  80158c:	e8 5d ff ff ff       	call   8014ee <fstat>
  801591:	89 c6                	mov    %eax,%esi
	close(fd);
  801593:	89 1c 24             	mov    %ebx,(%esp)
  801596:	e8 fd fb ff ff       	call   801198 <close>
	return r;
  80159b:	83 c4 10             	add    $0x10,%esp
  80159e:	89 f3                	mov    %esi,%ebx
}
  8015a0:	89 d8                	mov    %ebx,%eax
  8015a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015a5:	5b                   	pop    %ebx
  8015a6:	5e                   	pop    %esi
  8015a7:	5d                   	pop    %ebp
  8015a8:	c3                   	ret    

008015a9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	56                   	push   %esi
  8015ad:	53                   	push   %ebx
  8015ae:	89 c6                	mov    %eax,%esi
  8015b0:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015b2:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015b9:	74 27                	je     8015e2 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015bb:	6a 07                	push   $0x7
  8015bd:	68 00 50 80 00       	push   $0x805000
  8015c2:	56                   	push   %esi
  8015c3:	ff 35 00 40 80 00    	pushl  0x804000
  8015c9:	e8 44 09 00 00       	call   801f12 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015ce:	83 c4 0c             	add    $0xc,%esp
  8015d1:	6a 00                	push   $0x0
  8015d3:	53                   	push   %ebx
  8015d4:	6a 00                	push   $0x0
  8015d6:	e8 b2 08 00 00       	call   801e8d <ipc_recv>
}
  8015db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015de:	5b                   	pop    %ebx
  8015df:	5e                   	pop    %esi
  8015e0:	5d                   	pop    %ebp
  8015e1:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015e2:	83 ec 0c             	sub    $0xc,%esp
  8015e5:	6a 01                	push   $0x1
  8015e7:	e8 7e 09 00 00       	call   801f6a <ipc_find_env>
  8015ec:	a3 00 40 80 00       	mov    %eax,0x804000
  8015f1:	83 c4 10             	add    $0x10,%esp
  8015f4:	eb c5                	jmp    8015bb <fsipc+0x12>

008015f6 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015f6:	f3 0f 1e fb          	endbr32 
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	8b 40 0c             	mov    0xc(%eax),%eax
  801606:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80160b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801613:	ba 00 00 00 00       	mov    $0x0,%edx
  801618:	b8 02 00 00 00       	mov    $0x2,%eax
  80161d:	e8 87 ff ff ff       	call   8015a9 <fsipc>
}
  801622:	c9                   	leave  
  801623:	c3                   	ret    

00801624 <devfile_flush>:
{
  801624:	f3 0f 1e fb          	endbr32 
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
  801631:	8b 40 0c             	mov    0xc(%eax),%eax
  801634:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801639:	ba 00 00 00 00       	mov    $0x0,%edx
  80163e:	b8 06 00 00 00       	mov    $0x6,%eax
  801643:	e8 61 ff ff ff       	call   8015a9 <fsipc>
}
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <devfile_stat>:
{
  80164a:	f3 0f 1e fb          	endbr32 
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	53                   	push   %ebx
  801652:	83 ec 04             	sub    $0x4,%esp
  801655:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	8b 40 0c             	mov    0xc(%eax),%eax
  80165e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801663:	ba 00 00 00 00       	mov    $0x0,%edx
  801668:	b8 05 00 00 00       	mov    $0x5,%eax
  80166d:	e8 37 ff ff ff       	call   8015a9 <fsipc>
  801672:	85 c0                	test   %eax,%eax
  801674:	78 2c                	js     8016a2 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801676:	83 ec 08             	sub    $0x8,%esp
  801679:	68 00 50 80 00       	push   $0x805000
  80167e:	53                   	push   %ebx
  80167f:	e8 a4 f1 ff ff       	call   800828 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801684:	a1 80 50 80 00       	mov    0x805080,%eax
  801689:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80168f:	a1 84 50 80 00       	mov    0x805084,%eax
  801694:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <devfile_write>:
{
  8016a7:	f3 0f 1e fb          	endbr32 
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	83 ec 0c             	sub    $0xc,%esp
  8016b1:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8016b7:	8b 52 0c             	mov    0xc(%edx),%edx
  8016ba:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8016c0:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8016c5:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8016ca:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8016cd:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8016d2:	50                   	push   %eax
  8016d3:	ff 75 0c             	pushl  0xc(%ebp)
  8016d6:	68 08 50 80 00       	push   $0x805008
  8016db:	e8 fe f2 ff ff       	call   8009de <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8016e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e5:	b8 04 00 00 00       	mov    $0x4,%eax
  8016ea:	e8 ba fe ff ff       	call   8015a9 <fsipc>
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <devfile_read>:
{
  8016f1:	f3 0f 1e fb          	endbr32 
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	56                   	push   %esi
  8016f9:	53                   	push   %ebx
  8016fa:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	8b 40 0c             	mov    0xc(%eax),%eax
  801703:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801708:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80170e:	ba 00 00 00 00       	mov    $0x0,%edx
  801713:	b8 03 00 00 00       	mov    $0x3,%eax
  801718:	e8 8c fe ff ff       	call   8015a9 <fsipc>
  80171d:	89 c3                	mov    %eax,%ebx
  80171f:	85 c0                	test   %eax,%eax
  801721:	78 1f                	js     801742 <devfile_read+0x51>
	assert(r <= n);
  801723:	39 f0                	cmp    %esi,%eax
  801725:	77 24                	ja     80174b <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801727:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80172c:	7f 33                	jg     801761 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80172e:	83 ec 04             	sub    $0x4,%esp
  801731:	50                   	push   %eax
  801732:	68 00 50 80 00       	push   $0x805000
  801737:	ff 75 0c             	pushl  0xc(%ebp)
  80173a:	e8 9f f2 ff ff       	call   8009de <memmove>
	return r;
  80173f:	83 c4 10             	add    $0x10,%esp
}
  801742:	89 d8                	mov    %ebx,%eax
  801744:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801747:	5b                   	pop    %ebx
  801748:	5e                   	pop    %esi
  801749:	5d                   	pop    %ebp
  80174a:	c3                   	ret    
	assert(r <= n);
  80174b:	68 58 26 80 00       	push   $0x802658
  801750:	68 5f 26 80 00       	push   $0x80265f
  801755:	6a 7c                	push   $0x7c
  801757:	68 74 26 80 00       	push   $0x802674
  80175c:	e8 e2 06 00 00       	call   801e43 <_panic>
	assert(r <= PGSIZE);
  801761:	68 7f 26 80 00       	push   $0x80267f
  801766:	68 5f 26 80 00       	push   $0x80265f
  80176b:	6a 7d                	push   $0x7d
  80176d:	68 74 26 80 00       	push   $0x802674
  801772:	e8 cc 06 00 00       	call   801e43 <_panic>

00801777 <open>:
{
  801777:	f3 0f 1e fb          	endbr32 
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	56                   	push   %esi
  80177f:	53                   	push   %ebx
  801780:	83 ec 1c             	sub    $0x1c,%esp
  801783:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801786:	56                   	push   %esi
  801787:	e8 59 f0 ff ff       	call   8007e5 <strlen>
  80178c:	83 c4 10             	add    $0x10,%esp
  80178f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801794:	7f 6c                	jg     801802 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801796:	83 ec 0c             	sub    $0xc,%esp
  801799:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80179c:	50                   	push   %eax
  80179d:	e8 67 f8 ff ff       	call   801009 <fd_alloc>
  8017a2:	89 c3                	mov    %eax,%ebx
  8017a4:	83 c4 10             	add    $0x10,%esp
  8017a7:	85 c0                	test   %eax,%eax
  8017a9:	78 3c                	js     8017e7 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8017ab:	83 ec 08             	sub    $0x8,%esp
  8017ae:	56                   	push   %esi
  8017af:	68 00 50 80 00       	push   $0x805000
  8017b4:	e8 6f f0 ff ff       	call   800828 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bc:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c9:	e8 db fd ff ff       	call   8015a9 <fsipc>
  8017ce:	89 c3                	mov    %eax,%ebx
  8017d0:	83 c4 10             	add    $0x10,%esp
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	78 19                	js     8017f0 <open+0x79>
	return fd2num(fd);
  8017d7:	83 ec 0c             	sub    $0xc,%esp
  8017da:	ff 75 f4             	pushl  -0xc(%ebp)
  8017dd:	e8 f8 f7 ff ff       	call   800fda <fd2num>
  8017e2:	89 c3                	mov    %eax,%ebx
  8017e4:	83 c4 10             	add    $0x10,%esp
}
  8017e7:	89 d8                	mov    %ebx,%eax
  8017e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ec:	5b                   	pop    %ebx
  8017ed:	5e                   	pop    %esi
  8017ee:	5d                   	pop    %ebp
  8017ef:	c3                   	ret    
		fd_close(fd, 0);
  8017f0:	83 ec 08             	sub    $0x8,%esp
  8017f3:	6a 00                	push   $0x0
  8017f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8017f8:	e8 10 f9 ff ff       	call   80110d <fd_close>
		return r;
  8017fd:	83 c4 10             	add    $0x10,%esp
  801800:	eb e5                	jmp    8017e7 <open+0x70>
		return -E_BAD_PATH;
  801802:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801807:	eb de                	jmp    8017e7 <open+0x70>

00801809 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801809:	f3 0f 1e fb          	endbr32 
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801813:	ba 00 00 00 00       	mov    $0x0,%edx
  801818:	b8 08 00 00 00       	mov    $0x8,%eax
  80181d:	e8 87 fd ff ff       	call   8015a9 <fsipc>
}
  801822:	c9                   	leave  
  801823:	c3                   	ret    

00801824 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801824:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801828:	7f 01                	jg     80182b <writebuf+0x7>
  80182a:	c3                   	ret    
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	53                   	push   %ebx
  80182f:	83 ec 08             	sub    $0x8,%esp
  801832:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801834:	ff 70 04             	pushl  0x4(%eax)
  801837:	8d 40 10             	lea    0x10(%eax),%eax
  80183a:	50                   	push   %eax
  80183b:	ff 33                	pushl  (%ebx)
  80183d:	e8 76 fb ff ff       	call   8013b8 <write>
		if (result > 0)
  801842:	83 c4 10             	add    $0x10,%esp
  801845:	85 c0                	test   %eax,%eax
  801847:	7e 03                	jle    80184c <writebuf+0x28>
			b->result += result;
  801849:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80184c:	39 43 04             	cmp    %eax,0x4(%ebx)
  80184f:	74 0d                	je     80185e <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801851:	85 c0                	test   %eax,%eax
  801853:	ba 00 00 00 00       	mov    $0x0,%edx
  801858:	0f 4f c2             	cmovg  %edx,%eax
  80185b:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80185e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <putch>:

static void
putch(int ch, void *thunk)
{
  801863:	f3 0f 1e fb          	endbr32 
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	53                   	push   %ebx
  80186b:	83 ec 04             	sub    $0x4,%esp
  80186e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801871:	8b 53 04             	mov    0x4(%ebx),%edx
  801874:	8d 42 01             	lea    0x1(%edx),%eax
  801877:	89 43 04             	mov    %eax,0x4(%ebx)
  80187a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80187d:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801881:	3d 00 01 00 00       	cmp    $0x100,%eax
  801886:	74 06                	je     80188e <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  801888:	83 c4 04             	add    $0x4,%esp
  80188b:	5b                   	pop    %ebx
  80188c:	5d                   	pop    %ebp
  80188d:	c3                   	ret    
		writebuf(b);
  80188e:	89 d8                	mov    %ebx,%eax
  801890:	e8 8f ff ff ff       	call   801824 <writebuf>
		b->idx = 0;
  801895:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  80189c:	eb ea                	jmp    801888 <putch+0x25>

0080189e <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80189e:	f3 0f 1e fb          	endbr32 
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8018b4:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8018bb:	00 00 00 
	b.result = 0;
  8018be:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8018c5:	00 00 00 
	b.error = 1;
  8018c8:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8018cf:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8018d2:	ff 75 10             	pushl  0x10(%ebp)
  8018d5:	ff 75 0c             	pushl  0xc(%ebp)
  8018d8:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8018de:	50                   	push   %eax
  8018df:	68 63 18 80 00       	push   $0x801863
  8018e4:	e8 38 ea ff ff       	call   800321 <vprintfmt>
	if (b.idx > 0)
  8018e9:	83 c4 10             	add    $0x10,%esp
  8018ec:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8018f3:	7f 11                	jg     801906 <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8018f5:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8018fb:	85 c0                	test   %eax,%eax
  8018fd:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    
		writebuf(&b);
  801906:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80190c:	e8 13 ff ff ff       	call   801824 <writebuf>
  801911:	eb e2                	jmp    8018f5 <vfprintf+0x57>

00801913 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801913:	f3 0f 1e fb          	endbr32 
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80191d:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801920:	50                   	push   %eax
  801921:	ff 75 0c             	pushl  0xc(%ebp)
  801924:	ff 75 08             	pushl  0x8(%ebp)
  801927:	e8 72 ff ff ff       	call   80189e <vfprintf>
	va_end(ap);

	return cnt;
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <printf>:

int
printf(const char *fmt, ...)
{
  80192e:	f3 0f 1e fb          	endbr32 
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
  801935:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801938:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  80193b:	50                   	push   %eax
  80193c:	ff 75 08             	pushl  0x8(%ebp)
  80193f:	6a 01                	push   $0x1
  801941:	e8 58 ff ff ff       	call   80189e <vfprintf>
	va_end(ap);

	return cnt;
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801948:	f3 0f 1e fb          	endbr32 
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	56                   	push   %esi
  801950:	53                   	push   %ebx
  801951:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801954:	83 ec 0c             	sub    $0xc,%esp
  801957:	ff 75 08             	pushl  0x8(%ebp)
  80195a:	e8 8f f6 ff ff       	call   800fee <fd2data>
  80195f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801961:	83 c4 08             	add    $0x8,%esp
  801964:	68 8b 26 80 00       	push   $0x80268b
  801969:	53                   	push   %ebx
  80196a:	e8 b9 ee ff ff       	call   800828 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80196f:	8b 46 04             	mov    0x4(%esi),%eax
  801972:	2b 06                	sub    (%esi),%eax
  801974:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80197a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801981:	00 00 00 
	stat->st_dev = &devpipe;
  801984:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80198b:	30 80 00 
	return 0;
}
  80198e:	b8 00 00 00 00       	mov    $0x0,%eax
  801993:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801996:	5b                   	pop    %ebx
  801997:	5e                   	pop    %esi
  801998:	5d                   	pop    %ebp
  801999:	c3                   	ret    

0080199a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80199a:	f3 0f 1e fb          	endbr32 
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
  8019a1:	53                   	push   %ebx
  8019a2:	83 ec 0c             	sub    $0xc,%esp
  8019a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8019a8:	53                   	push   %ebx
  8019a9:	6a 00                	push   $0x0
  8019ab:	e8 47 f3 ff ff       	call   800cf7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8019b0:	89 1c 24             	mov    %ebx,(%esp)
  8019b3:	e8 36 f6 ff ff       	call   800fee <fd2data>
  8019b8:	83 c4 08             	add    $0x8,%esp
  8019bb:	50                   	push   %eax
  8019bc:	6a 00                	push   $0x0
  8019be:	e8 34 f3 ff ff       	call   800cf7 <sys_page_unmap>
}
  8019c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <_pipeisclosed>:
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	57                   	push   %edi
  8019cc:	56                   	push   %esi
  8019cd:	53                   	push   %ebx
  8019ce:	83 ec 1c             	sub    $0x1c,%esp
  8019d1:	89 c7                	mov    %eax,%edi
  8019d3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8019d5:	a1 04 40 80 00       	mov    0x804004,%eax
  8019da:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8019dd:	83 ec 0c             	sub    $0xc,%esp
  8019e0:	57                   	push   %edi
  8019e1:	e8 c1 05 00 00       	call   801fa7 <pageref>
  8019e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019e9:	89 34 24             	mov    %esi,(%esp)
  8019ec:	e8 b6 05 00 00       	call   801fa7 <pageref>
		nn = thisenv->env_runs;
  8019f1:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019f7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8019fa:	83 c4 10             	add    $0x10,%esp
  8019fd:	39 cb                	cmp    %ecx,%ebx
  8019ff:	74 1b                	je     801a1c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a01:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a04:	75 cf                	jne    8019d5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a06:	8b 42 58             	mov    0x58(%edx),%eax
  801a09:	6a 01                	push   $0x1
  801a0b:	50                   	push   %eax
  801a0c:	53                   	push   %ebx
  801a0d:	68 92 26 80 00       	push   $0x802692
  801a12:	e8 07 e8 ff ff       	call   80021e <cprintf>
  801a17:	83 c4 10             	add    $0x10,%esp
  801a1a:	eb b9                	jmp    8019d5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a1c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a1f:	0f 94 c0             	sete   %al
  801a22:	0f b6 c0             	movzbl %al,%eax
}
  801a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a28:	5b                   	pop    %ebx
  801a29:	5e                   	pop    %esi
  801a2a:	5f                   	pop    %edi
  801a2b:	5d                   	pop    %ebp
  801a2c:	c3                   	ret    

00801a2d <devpipe_write>:
{
  801a2d:	f3 0f 1e fb          	endbr32 
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	57                   	push   %edi
  801a35:	56                   	push   %esi
  801a36:	53                   	push   %ebx
  801a37:	83 ec 28             	sub    $0x28,%esp
  801a3a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801a3d:	56                   	push   %esi
  801a3e:	e8 ab f5 ff ff       	call   800fee <fd2data>
  801a43:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a45:	83 c4 10             	add    $0x10,%esp
  801a48:	bf 00 00 00 00       	mov    $0x0,%edi
  801a4d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a50:	74 4f                	je     801aa1 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a52:	8b 43 04             	mov    0x4(%ebx),%eax
  801a55:	8b 0b                	mov    (%ebx),%ecx
  801a57:	8d 51 20             	lea    0x20(%ecx),%edx
  801a5a:	39 d0                	cmp    %edx,%eax
  801a5c:	72 14                	jb     801a72 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801a5e:	89 da                	mov    %ebx,%edx
  801a60:	89 f0                	mov    %esi,%eax
  801a62:	e8 61 ff ff ff       	call   8019c8 <_pipeisclosed>
  801a67:	85 c0                	test   %eax,%eax
  801a69:	75 3b                	jne    801aa6 <devpipe_write+0x79>
			sys_yield();
  801a6b:	e8 d7 f1 ff ff       	call   800c47 <sys_yield>
  801a70:	eb e0                	jmp    801a52 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a75:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801a79:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801a7c:	89 c2                	mov    %eax,%edx
  801a7e:	c1 fa 1f             	sar    $0x1f,%edx
  801a81:	89 d1                	mov    %edx,%ecx
  801a83:	c1 e9 1b             	shr    $0x1b,%ecx
  801a86:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801a89:	83 e2 1f             	and    $0x1f,%edx
  801a8c:	29 ca                	sub    %ecx,%edx
  801a8e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801a92:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801a96:	83 c0 01             	add    $0x1,%eax
  801a99:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801a9c:	83 c7 01             	add    $0x1,%edi
  801a9f:	eb ac                	jmp    801a4d <devpipe_write+0x20>
	return i;
  801aa1:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa4:	eb 05                	jmp    801aab <devpipe_write+0x7e>
				return 0;
  801aa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aae:	5b                   	pop    %ebx
  801aaf:	5e                   	pop    %esi
  801ab0:	5f                   	pop    %edi
  801ab1:	5d                   	pop    %ebp
  801ab2:	c3                   	ret    

00801ab3 <devpipe_read>:
{
  801ab3:	f3 0f 1e fb          	endbr32 
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
  801aba:	57                   	push   %edi
  801abb:	56                   	push   %esi
  801abc:	53                   	push   %ebx
  801abd:	83 ec 18             	sub    $0x18,%esp
  801ac0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ac3:	57                   	push   %edi
  801ac4:	e8 25 f5 ff ff       	call   800fee <fd2data>
  801ac9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801acb:	83 c4 10             	add    $0x10,%esp
  801ace:	be 00 00 00 00       	mov    $0x0,%esi
  801ad3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ad6:	75 14                	jne    801aec <devpipe_read+0x39>
	return i;
  801ad8:	8b 45 10             	mov    0x10(%ebp),%eax
  801adb:	eb 02                	jmp    801adf <devpipe_read+0x2c>
				return i;
  801add:	89 f0                	mov    %esi,%eax
}
  801adf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ae2:	5b                   	pop    %ebx
  801ae3:	5e                   	pop    %esi
  801ae4:	5f                   	pop    %edi
  801ae5:	5d                   	pop    %ebp
  801ae6:	c3                   	ret    
			sys_yield();
  801ae7:	e8 5b f1 ff ff       	call   800c47 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801aec:	8b 03                	mov    (%ebx),%eax
  801aee:	3b 43 04             	cmp    0x4(%ebx),%eax
  801af1:	75 18                	jne    801b0b <devpipe_read+0x58>
			if (i > 0)
  801af3:	85 f6                	test   %esi,%esi
  801af5:	75 e6                	jne    801add <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801af7:	89 da                	mov    %ebx,%edx
  801af9:	89 f8                	mov    %edi,%eax
  801afb:	e8 c8 fe ff ff       	call   8019c8 <_pipeisclosed>
  801b00:	85 c0                	test   %eax,%eax
  801b02:	74 e3                	je     801ae7 <devpipe_read+0x34>
				return 0;
  801b04:	b8 00 00 00 00       	mov    $0x0,%eax
  801b09:	eb d4                	jmp    801adf <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b0b:	99                   	cltd   
  801b0c:	c1 ea 1b             	shr    $0x1b,%edx
  801b0f:	01 d0                	add    %edx,%eax
  801b11:	83 e0 1f             	and    $0x1f,%eax
  801b14:	29 d0                	sub    %edx,%eax
  801b16:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b1e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b21:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801b24:	83 c6 01             	add    $0x1,%esi
  801b27:	eb aa                	jmp    801ad3 <devpipe_read+0x20>

00801b29 <pipe>:
{
  801b29:	f3 0f 1e fb          	endbr32 
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
  801b30:	56                   	push   %esi
  801b31:	53                   	push   %ebx
  801b32:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801b35:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b38:	50                   	push   %eax
  801b39:	e8 cb f4 ff ff       	call   801009 <fd_alloc>
  801b3e:	89 c3                	mov    %eax,%ebx
  801b40:	83 c4 10             	add    $0x10,%esp
  801b43:	85 c0                	test   %eax,%eax
  801b45:	0f 88 23 01 00 00    	js     801c6e <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b4b:	83 ec 04             	sub    $0x4,%esp
  801b4e:	68 07 04 00 00       	push   $0x407
  801b53:	ff 75 f4             	pushl  -0xc(%ebp)
  801b56:	6a 00                	push   $0x0
  801b58:	e8 0d f1 ff ff       	call   800c6a <sys_page_alloc>
  801b5d:	89 c3                	mov    %eax,%ebx
  801b5f:	83 c4 10             	add    $0x10,%esp
  801b62:	85 c0                	test   %eax,%eax
  801b64:	0f 88 04 01 00 00    	js     801c6e <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801b6a:	83 ec 0c             	sub    $0xc,%esp
  801b6d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b70:	50                   	push   %eax
  801b71:	e8 93 f4 ff ff       	call   801009 <fd_alloc>
  801b76:	89 c3                	mov    %eax,%ebx
  801b78:	83 c4 10             	add    $0x10,%esp
  801b7b:	85 c0                	test   %eax,%eax
  801b7d:	0f 88 db 00 00 00    	js     801c5e <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b83:	83 ec 04             	sub    $0x4,%esp
  801b86:	68 07 04 00 00       	push   $0x407
  801b8b:	ff 75 f0             	pushl  -0x10(%ebp)
  801b8e:	6a 00                	push   $0x0
  801b90:	e8 d5 f0 ff ff       	call   800c6a <sys_page_alloc>
  801b95:	89 c3                	mov    %eax,%ebx
  801b97:	83 c4 10             	add    $0x10,%esp
  801b9a:	85 c0                	test   %eax,%eax
  801b9c:	0f 88 bc 00 00 00    	js     801c5e <pipe+0x135>
	va = fd2data(fd0);
  801ba2:	83 ec 0c             	sub    $0xc,%esp
  801ba5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ba8:	e8 41 f4 ff ff       	call   800fee <fd2data>
  801bad:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801baf:	83 c4 0c             	add    $0xc,%esp
  801bb2:	68 07 04 00 00       	push   $0x407
  801bb7:	50                   	push   %eax
  801bb8:	6a 00                	push   $0x0
  801bba:	e8 ab f0 ff ff       	call   800c6a <sys_page_alloc>
  801bbf:	89 c3                	mov    %eax,%ebx
  801bc1:	83 c4 10             	add    $0x10,%esp
  801bc4:	85 c0                	test   %eax,%eax
  801bc6:	0f 88 82 00 00 00    	js     801c4e <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bcc:	83 ec 0c             	sub    $0xc,%esp
  801bcf:	ff 75 f0             	pushl  -0x10(%ebp)
  801bd2:	e8 17 f4 ff ff       	call   800fee <fd2data>
  801bd7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801bde:	50                   	push   %eax
  801bdf:	6a 00                	push   $0x0
  801be1:	56                   	push   %esi
  801be2:	6a 00                	push   $0x0
  801be4:	e8 c8 f0 ff ff       	call   800cb1 <sys_page_map>
  801be9:	89 c3                	mov    %eax,%ebx
  801beb:	83 c4 20             	add    $0x20,%esp
  801bee:	85 c0                	test   %eax,%eax
  801bf0:	78 4e                	js     801c40 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801bf2:	a1 20 30 80 00       	mov    0x803020,%eax
  801bf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bfa:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801bfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bff:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801c06:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c09:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c0e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c15:	83 ec 0c             	sub    $0xc,%esp
  801c18:	ff 75 f4             	pushl  -0xc(%ebp)
  801c1b:	e8 ba f3 ff ff       	call   800fda <fd2num>
  801c20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c23:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c25:	83 c4 04             	add    $0x4,%esp
  801c28:	ff 75 f0             	pushl  -0x10(%ebp)
  801c2b:	e8 aa f3 ff ff       	call   800fda <fd2num>
  801c30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c33:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c36:	83 c4 10             	add    $0x10,%esp
  801c39:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c3e:	eb 2e                	jmp    801c6e <pipe+0x145>
	sys_page_unmap(0, va);
  801c40:	83 ec 08             	sub    $0x8,%esp
  801c43:	56                   	push   %esi
  801c44:	6a 00                	push   $0x0
  801c46:	e8 ac f0 ff ff       	call   800cf7 <sys_page_unmap>
  801c4b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801c4e:	83 ec 08             	sub    $0x8,%esp
  801c51:	ff 75 f0             	pushl  -0x10(%ebp)
  801c54:	6a 00                	push   $0x0
  801c56:	e8 9c f0 ff ff       	call   800cf7 <sys_page_unmap>
  801c5b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801c5e:	83 ec 08             	sub    $0x8,%esp
  801c61:	ff 75 f4             	pushl  -0xc(%ebp)
  801c64:	6a 00                	push   $0x0
  801c66:	e8 8c f0 ff ff       	call   800cf7 <sys_page_unmap>
  801c6b:	83 c4 10             	add    $0x10,%esp
}
  801c6e:	89 d8                	mov    %ebx,%eax
  801c70:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c73:	5b                   	pop    %ebx
  801c74:	5e                   	pop    %esi
  801c75:	5d                   	pop    %ebp
  801c76:	c3                   	ret    

00801c77 <pipeisclosed>:
{
  801c77:	f3 0f 1e fb          	endbr32 
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c81:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c84:	50                   	push   %eax
  801c85:	ff 75 08             	pushl  0x8(%ebp)
  801c88:	e8 d2 f3 ff ff       	call   80105f <fd_lookup>
  801c8d:	83 c4 10             	add    $0x10,%esp
  801c90:	85 c0                	test   %eax,%eax
  801c92:	78 18                	js     801cac <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801c94:	83 ec 0c             	sub    $0xc,%esp
  801c97:	ff 75 f4             	pushl  -0xc(%ebp)
  801c9a:	e8 4f f3 ff ff       	call   800fee <fd2data>
  801c9f:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca4:	e8 1f fd ff ff       	call   8019c8 <_pipeisclosed>
  801ca9:	83 c4 10             	add    $0x10,%esp
}
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801cae:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb7:	c3                   	ret    

00801cb8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801cb8:	f3 0f 1e fb          	endbr32 
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801cc2:	68 aa 26 80 00       	push   $0x8026aa
  801cc7:	ff 75 0c             	pushl  0xc(%ebp)
  801cca:	e8 59 eb ff ff       	call   800828 <strcpy>
	return 0;
}
  801ccf:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <devcons_write>:
{
  801cd6:	f3 0f 1e fb          	endbr32 
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	57                   	push   %edi
  801cde:	56                   	push   %esi
  801cdf:	53                   	push   %ebx
  801ce0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ce6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ceb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801cf1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cf4:	73 31                	jae    801d27 <devcons_write+0x51>
		m = n - tot;
  801cf6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801cf9:	29 f3                	sub    %esi,%ebx
  801cfb:	83 fb 7f             	cmp    $0x7f,%ebx
  801cfe:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801d03:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801d06:	83 ec 04             	sub    $0x4,%esp
  801d09:	53                   	push   %ebx
  801d0a:	89 f0                	mov    %esi,%eax
  801d0c:	03 45 0c             	add    0xc(%ebp),%eax
  801d0f:	50                   	push   %eax
  801d10:	57                   	push   %edi
  801d11:	e8 c8 ec ff ff       	call   8009de <memmove>
		sys_cputs(buf, m);
  801d16:	83 c4 08             	add    $0x8,%esp
  801d19:	53                   	push   %ebx
  801d1a:	57                   	push   %edi
  801d1b:	e8 7a ee ff ff       	call   800b9a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801d20:	01 de                	add    %ebx,%esi
  801d22:	83 c4 10             	add    $0x10,%esp
  801d25:	eb ca                	jmp    801cf1 <devcons_write+0x1b>
}
  801d27:	89 f0                	mov    %esi,%eax
  801d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d2c:	5b                   	pop    %ebx
  801d2d:	5e                   	pop    %esi
  801d2e:	5f                   	pop    %edi
  801d2f:	5d                   	pop    %ebp
  801d30:	c3                   	ret    

00801d31 <devcons_read>:
{
  801d31:	f3 0f 1e fb          	endbr32 
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	83 ec 08             	sub    $0x8,%esp
  801d3b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801d40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d44:	74 21                	je     801d67 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801d46:	e8 71 ee ff ff       	call   800bbc <sys_cgetc>
  801d4b:	85 c0                	test   %eax,%eax
  801d4d:	75 07                	jne    801d56 <devcons_read+0x25>
		sys_yield();
  801d4f:	e8 f3 ee ff ff       	call   800c47 <sys_yield>
  801d54:	eb f0                	jmp    801d46 <devcons_read+0x15>
	if (c < 0)
  801d56:	78 0f                	js     801d67 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801d58:	83 f8 04             	cmp    $0x4,%eax
  801d5b:	74 0c                	je     801d69 <devcons_read+0x38>
	*(char*)vbuf = c;
  801d5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d60:	88 02                	mov    %al,(%edx)
	return 1;
  801d62:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    
		return 0;
  801d69:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6e:	eb f7                	jmp    801d67 <devcons_read+0x36>

00801d70 <cputchar>:
{
  801d70:	f3 0f 1e fb          	endbr32 
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801d80:	6a 01                	push   $0x1
  801d82:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d85:	50                   	push   %eax
  801d86:	e8 0f ee ff ff       	call   800b9a <sys_cputs>
}
  801d8b:	83 c4 10             	add    $0x10,%esp
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <getchar>:
{
  801d90:	f3 0f 1e fb          	endbr32 
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801d9a:	6a 01                	push   $0x1
  801d9c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d9f:	50                   	push   %eax
  801da0:	6a 00                	push   $0x0
  801da2:	e8 3b f5 ff ff       	call   8012e2 <read>
	if (r < 0)
  801da7:	83 c4 10             	add    $0x10,%esp
  801daa:	85 c0                	test   %eax,%eax
  801dac:	78 06                	js     801db4 <getchar+0x24>
	if (r < 1)
  801dae:	74 06                	je     801db6 <getchar+0x26>
	return c;
  801db0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    
		return -E_EOF;
  801db6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801dbb:	eb f7                	jmp    801db4 <getchar+0x24>

00801dbd <iscons>:
{
  801dbd:	f3 0f 1e fb          	endbr32 
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dc7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dca:	50                   	push   %eax
  801dcb:	ff 75 08             	pushl  0x8(%ebp)
  801dce:	e8 8c f2 ff ff       	call   80105f <fd_lookup>
  801dd3:	83 c4 10             	add    $0x10,%esp
  801dd6:	85 c0                	test   %eax,%eax
  801dd8:	78 11                	js     801deb <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddd:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801de3:	39 10                	cmp    %edx,(%eax)
  801de5:	0f 94 c0             	sete   %al
  801de8:	0f b6 c0             	movzbl %al,%eax
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <opencons>:
{
  801ded:	f3 0f 1e fb          	endbr32 
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801df7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dfa:	50                   	push   %eax
  801dfb:	e8 09 f2 ff ff       	call   801009 <fd_alloc>
  801e00:	83 c4 10             	add    $0x10,%esp
  801e03:	85 c0                	test   %eax,%eax
  801e05:	78 3a                	js     801e41 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e07:	83 ec 04             	sub    $0x4,%esp
  801e0a:	68 07 04 00 00       	push   $0x407
  801e0f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e12:	6a 00                	push   $0x0
  801e14:	e8 51 ee ff ff       	call   800c6a <sys_page_alloc>
  801e19:	83 c4 10             	add    $0x10,%esp
  801e1c:	85 c0                	test   %eax,%eax
  801e1e:	78 21                	js     801e41 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e23:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e29:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e35:	83 ec 0c             	sub    $0xc,%esp
  801e38:	50                   	push   %eax
  801e39:	e8 9c f1 ff ff       	call   800fda <fd2num>
  801e3e:	83 c4 10             	add    $0x10,%esp
}
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e43:	f3 0f 1e fb          	endbr32 
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
  801e4a:	56                   	push   %esi
  801e4b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801e4c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801e4f:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801e55:	e8 ca ed ff ff       	call   800c24 <sys_getenvid>
  801e5a:	83 ec 0c             	sub    $0xc,%esp
  801e5d:	ff 75 0c             	pushl  0xc(%ebp)
  801e60:	ff 75 08             	pushl  0x8(%ebp)
  801e63:	56                   	push   %esi
  801e64:	50                   	push   %eax
  801e65:	68 b8 26 80 00       	push   $0x8026b8
  801e6a:	e8 af e3 ff ff       	call   80021e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801e6f:	83 c4 18             	add    $0x18,%esp
  801e72:	53                   	push   %ebx
  801e73:	ff 75 10             	pushl  0x10(%ebp)
  801e76:	e8 4e e3 ff ff       	call   8001c9 <vcprintf>
	cprintf("\n");
  801e7b:	c7 04 24 70 22 80 00 	movl   $0x802270,(%esp)
  801e82:	e8 97 e3 ff ff       	call   80021e <cprintf>
  801e87:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801e8a:	cc                   	int3   
  801e8b:	eb fd                	jmp    801e8a <_panic+0x47>

00801e8d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801e8d:	f3 0f 1e fb          	endbr32 
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
  801e94:	56                   	push   %esi
  801e95:	53                   	push   %ebx
  801e96:	8b 75 08             	mov    0x8(%ebp),%esi
  801e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801e9f:	85 c0                	test   %eax,%eax
  801ea1:	74 3d                	je     801ee0 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801ea3:	83 ec 0c             	sub    $0xc,%esp
  801ea6:	50                   	push   %eax
  801ea7:	e8 8a ef ff ff       	call   800e36 <sys_ipc_recv>
  801eac:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801eaf:	85 f6                	test   %esi,%esi
  801eb1:	74 0b                	je     801ebe <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801eb3:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801eb9:	8b 52 74             	mov    0x74(%edx),%edx
  801ebc:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801ebe:	85 db                	test   %ebx,%ebx
  801ec0:	74 0b                	je     801ecd <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801ec2:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801ec8:	8b 52 78             	mov    0x78(%edx),%edx
  801ecb:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801ecd:	85 c0                	test   %eax,%eax
  801ecf:	78 21                	js     801ef2 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801ed1:	a1 04 40 80 00       	mov    0x804004,%eax
  801ed6:	8b 40 70             	mov    0x70(%eax),%eax
}
  801ed9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801edc:	5b                   	pop    %ebx
  801edd:	5e                   	pop    %esi
  801ede:	5d                   	pop    %ebp
  801edf:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801ee0:	83 ec 0c             	sub    $0xc,%esp
  801ee3:	68 00 00 c0 ee       	push   $0xeec00000
  801ee8:	e8 49 ef ff ff       	call   800e36 <sys_ipc_recv>
  801eed:	83 c4 10             	add    $0x10,%esp
  801ef0:	eb bd                	jmp    801eaf <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801ef2:	85 f6                	test   %esi,%esi
  801ef4:	74 10                	je     801f06 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801ef6:	85 db                	test   %ebx,%ebx
  801ef8:	75 df                	jne    801ed9 <ipc_recv+0x4c>
  801efa:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801f01:	00 00 00 
  801f04:	eb d3                	jmp    801ed9 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801f06:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801f0d:	00 00 00 
  801f10:	eb e4                	jmp    801ef6 <ipc_recv+0x69>

00801f12 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f12:	f3 0f 1e fb          	endbr32 
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	57                   	push   %edi
  801f1a:	56                   	push   %esi
  801f1b:	53                   	push   %ebx
  801f1c:	83 ec 0c             	sub    $0xc,%esp
  801f1f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f22:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f25:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801f28:	85 db                	test   %ebx,%ebx
  801f2a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801f2f:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801f32:	ff 75 14             	pushl  0x14(%ebp)
  801f35:	53                   	push   %ebx
  801f36:	56                   	push   %esi
  801f37:	57                   	push   %edi
  801f38:	e8 d2 ee ff ff       	call   800e0f <sys_ipc_try_send>
  801f3d:	83 c4 10             	add    $0x10,%esp
  801f40:	85 c0                	test   %eax,%eax
  801f42:	79 1e                	jns    801f62 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801f44:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f47:	75 07                	jne    801f50 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801f49:	e8 f9 ec ff ff       	call   800c47 <sys_yield>
  801f4e:	eb e2                	jmp    801f32 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801f50:	50                   	push   %eax
  801f51:	68 db 26 80 00       	push   $0x8026db
  801f56:	6a 59                	push   $0x59
  801f58:	68 f6 26 80 00       	push   $0x8026f6
  801f5d:	e8 e1 fe ff ff       	call   801e43 <_panic>
	}
}
  801f62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f65:	5b                   	pop    %ebx
  801f66:	5e                   	pop    %esi
  801f67:	5f                   	pop    %edi
  801f68:	5d                   	pop    %ebp
  801f69:	c3                   	ret    

00801f6a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f6a:	f3 0f 1e fb          	endbr32 
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f74:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801f79:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f7c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f82:	8b 52 50             	mov    0x50(%edx),%edx
  801f85:	39 ca                	cmp    %ecx,%edx
  801f87:	74 11                	je     801f9a <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801f89:	83 c0 01             	add    $0x1,%eax
  801f8c:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f91:	75 e6                	jne    801f79 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801f93:	b8 00 00 00 00       	mov    $0x0,%eax
  801f98:	eb 0b                	jmp    801fa5 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801f9a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801f9d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fa2:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fa5:	5d                   	pop    %ebp
  801fa6:	c3                   	ret    

00801fa7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fa7:	f3 0f 1e fb          	endbr32 
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fb1:	89 c2                	mov    %eax,%edx
  801fb3:	c1 ea 16             	shr    $0x16,%edx
  801fb6:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801fbd:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801fc2:	f6 c1 01             	test   $0x1,%cl
  801fc5:	74 1c                	je     801fe3 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801fc7:	c1 e8 0c             	shr    $0xc,%eax
  801fca:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801fd1:	a8 01                	test   $0x1,%al
  801fd3:	74 0e                	je     801fe3 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801fd5:	c1 e8 0c             	shr    $0xc,%eax
  801fd8:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801fdf:	ef 
  801fe0:	0f b7 d2             	movzwl %dx,%edx
}
  801fe3:	89 d0                	mov    %edx,%eax
  801fe5:	5d                   	pop    %ebp
  801fe6:	c3                   	ret    
  801fe7:	66 90                	xchg   %ax,%ax
  801fe9:	66 90                	xchg   %ax,%ax
  801feb:	66 90                	xchg   %ax,%ax
  801fed:	66 90                	xchg   %ax,%ax
  801fef:	90                   	nop

00801ff0 <__udivdi3>:
  801ff0:	f3 0f 1e fb          	endbr32 
  801ff4:	55                   	push   %ebp
  801ff5:	57                   	push   %edi
  801ff6:	56                   	push   %esi
  801ff7:	53                   	push   %ebx
  801ff8:	83 ec 1c             	sub    $0x1c,%esp
  801ffb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801fff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802003:	8b 74 24 34          	mov    0x34(%esp),%esi
  802007:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80200b:	85 d2                	test   %edx,%edx
  80200d:	75 19                	jne    802028 <__udivdi3+0x38>
  80200f:	39 f3                	cmp    %esi,%ebx
  802011:	76 4d                	jbe    802060 <__udivdi3+0x70>
  802013:	31 ff                	xor    %edi,%edi
  802015:	89 e8                	mov    %ebp,%eax
  802017:	89 f2                	mov    %esi,%edx
  802019:	f7 f3                	div    %ebx
  80201b:	89 fa                	mov    %edi,%edx
  80201d:	83 c4 1c             	add    $0x1c,%esp
  802020:	5b                   	pop    %ebx
  802021:	5e                   	pop    %esi
  802022:	5f                   	pop    %edi
  802023:	5d                   	pop    %ebp
  802024:	c3                   	ret    
  802025:	8d 76 00             	lea    0x0(%esi),%esi
  802028:	39 f2                	cmp    %esi,%edx
  80202a:	76 14                	jbe    802040 <__udivdi3+0x50>
  80202c:	31 ff                	xor    %edi,%edi
  80202e:	31 c0                	xor    %eax,%eax
  802030:	89 fa                	mov    %edi,%edx
  802032:	83 c4 1c             	add    $0x1c,%esp
  802035:	5b                   	pop    %ebx
  802036:	5e                   	pop    %esi
  802037:	5f                   	pop    %edi
  802038:	5d                   	pop    %ebp
  802039:	c3                   	ret    
  80203a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802040:	0f bd fa             	bsr    %edx,%edi
  802043:	83 f7 1f             	xor    $0x1f,%edi
  802046:	75 48                	jne    802090 <__udivdi3+0xa0>
  802048:	39 f2                	cmp    %esi,%edx
  80204a:	72 06                	jb     802052 <__udivdi3+0x62>
  80204c:	31 c0                	xor    %eax,%eax
  80204e:	39 eb                	cmp    %ebp,%ebx
  802050:	77 de                	ja     802030 <__udivdi3+0x40>
  802052:	b8 01 00 00 00       	mov    $0x1,%eax
  802057:	eb d7                	jmp    802030 <__udivdi3+0x40>
  802059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802060:	89 d9                	mov    %ebx,%ecx
  802062:	85 db                	test   %ebx,%ebx
  802064:	75 0b                	jne    802071 <__udivdi3+0x81>
  802066:	b8 01 00 00 00       	mov    $0x1,%eax
  80206b:	31 d2                	xor    %edx,%edx
  80206d:	f7 f3                	div    %ebx
  80206f:	89 c1                	mov    %eax,%ecx
  802071:	31 d2                	xor    %edx,%edx
  802073:	89 f0                	mov    %esi,%eax
  802075:	f7 f1                	div    %ecx
  802077:	89 c6                	mov    %eax,%esi
  802079:	89 e8                	mov    %ebp,%eax
  80207b:	89 f7                	mov    %esi,%edi
  80207d:	f7 f1                	div    %ecx
  80207f:	89 fa                	mov    %edi,%edx
  802081:	83 c4 1c             	add    $0x1c,%esp
  802084:	5b                   	pop    %ebx
  802085:	5e                   	pop    %esi
  802086:	5f                   	pop    %edi
  802087:	5d                   	pop    %ebp
  802088:	c3                   	ret    
  802089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802090:	89 f9                	mov    %edi,%ecx
  802092:	b8 20 00 00 00       	mov    $0x20,%eax
  802097:	29 f8                	sub    %edi,%eax
  802099:	d3 e2                	shl    %cl,%edx
  80209b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80209f:	89 c1                	mov    %eax,%ecx
  8020a1:	89 da                	mov    %ebx,%edx
  8020a3:	d3 ea                	shr    %cl,%edx
  8020a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8020a9:	09 d1                	or     %edx,%ecx
  8020ab:	89 f2                	mov    %esi,%edx
  8020ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020b1:	89 f9                	mov    %edi,%ecx
  8020b3:	d3 e3                	shl    %cl,%ebx
  8020b5:	89 c1                	mov    %eax,%ecx
  8020b7:	d3 ea                	shr    %cl,%edx
  8020b9:	89 f9                	mov    %edi,%ecx
  8020bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8020bf:	89 eb                	mov    %ebp,%ebx
  8020c1:	d3 e6                	shl    %cl,%esi
  8020c3:	89 c1                	mov    %eax,%ecx
  8020c5:	d3 eb                	shr    %cl,%ebx
  8020c7:	09 de                	or     %ebx,%esi
  8020c9:	89 f0                	mov    %esi,%eax
  8020cb:	f7 74 24 08          	divl   0x8(%esp)
  8020cf:	89 d6                	mov    %edx,%esi
  8020d1:	89 c3                	mov    %eax,%ebx
  8020d3:	f7 64 24 0c          	mull   0xc(%esp)
  8020d7:	39 d6                	cmp    %edx,%esi
  8020d9:	72 15                	jb     8020f0 <__udivdi3+0x100>
  8020db:	89 f9                	mov    %edi,%ecx
  8020dd:	d3 e5                	shl    %cl,%ebp
  8020df:	39 c5                	cmp    %eax,%ebp
  8020e1:	73 04                	jae    8020e7 <__udivdi3+0xf7>
  8020e3:	39 d6                	cmp    %edx,%esi
  8020e5:	74 09                	je     8020f0 <__udivdi3+0x100>
  8020e7:	89 d8                	mov    %ebx,%eax
  8020e9:	31 ff                	xor    %edi,%edi
  8020eb:	e9 40 ff ff ff       	jmp    802030 <__udivdi3+0x40>
  8020f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8020f3:	31 ff                	xor    %edi,%edi
  8020f5:	e9 36 ff ff ff       	jmp    802030 <__udivdi3+0x40>
  8020fa:	66 90                	xchg   %ax,%ax
  8020fc:	66 90                	xchg   %ax,%ax
  8020fe:	66 90                	xchg   %ax,%ax

00802100 <__umoddi3>:
  802100:	f3 0f 1e fb          	endbr32 
  802104:	55                   	push   %ebp
  802105:	57                   	push   %edi
  802106:	56                   	push   %esi
  802107:	53                   	push   %ebx
  802108:	83 ec 1c             	sub    $0x1c,%esp
  80210b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80210f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802113:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802117:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80211b:	85 c0                	test   %eax,%eax
  80211d:	75 19                	jne    802138 <__umoddi3+0x38>
  80211f:	39 df                	cmp    %ebx,%edi
  802121:	76 5d                	jbe    802180 <__umoddi3+0x80>
  802123:	89 f0                	mov    %esi,%eax
  802125:	89 da                	mov    %ebx,%edx
  802127:	f7 f7                	div    %edi
  802129:	89 d0                	mov    %edx,%eax
  80212b:	31 d2                	xor    %edx,%edx
  80212d:	83 c4 1c             	add    $0x1c,%esp
  802130:	5b                   	pop    %ebx
  802131:	5e                   	pop    %esi
  802132:	5f                   	pop    %edi
  802133:	5d                   	pop    %ebp
  802134:	c3                   	ret    
  802135:	8d 76 00             	lea    0x0(%esi),%esi
  802138:	89 f2                	mov    %esi,%edx
  80213a:	39 d8                	cmp    %ebx,%eax
  80213c:	76 12                	jbe    802150 <__umoddi3+0x50>
  80213e:	89 f0                	mov    %esi,%eax
  802140:	89 da                	mov    %ebx,%edx
  802142:	83 c4 1c             	add    $0x1c,%esp
  802145:	5b                   	pop    %ebx
  802146:	5e                   	pop    %esi
  802147:	5f                   	pop    %edi
  802148:	5d                   	pop    %ebp
  802149:	c3                   	ret    
  80214a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802150:	0f bd e8             	bsr    %eax,%ebp
  802153:	83 f5 1f             	xor    $0x1f,%ebp
  802156:	75 50                	jne    8021a8 <__umoddi3+0xa8>
  802158:	39 d8                	cmp    %ebx,%eax
  80215a:	0f 82 e0 00 00 00    	jb     802240 <__umoddi3+0x140>
  802160:	89 d9                	mov    %ebx,%ecx
  802162:	39 f7                	cmp    %esi,%edi
  802164:	0f 86 d6 00 00 00    	jbe    802240 <__umoddi3+0x140>
  80216a:	89 d0                	mov    %edx,%eax
  80216c:	89 ca                	mov    %ecx,%edx
  80216e:	83 c4 1c             	add    $0x1c,%esp
  802171:	5b                   	pop    %ebx
  802172:	5e                   	pop    %esi
  802173:	5f                   	pop    %edi
  802174:	5d                   	pop    %ebp
  802175:	c3                   	ret    
  802176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80217d:	8d 76 00             	lea    0x0(%esi),%esi
  802180:	89 fd                	mov    %edi,%ebp
  802182:	85 ff                	test   %edi,%edi
  802184:	75 0b                	jne    802191 <__umoddi3+0x91>
  802186:	b8 01 00 00 00       	mov    $0x1,%eax
  80218b:	31 d2                	xor    %edx,%edx
  80218d:	f7 f7                	div    %edi
  80218f:	89 c5                	mov    %eax,%ebp
  802191:	89 d8                	mov    %ebx,%eax
  802193:	31 d2                	xor    %edx,%edx
  802195:	f7 f5                	div    %ebp
  802197:	89 f0                	mov    %esi,%eax
  802199:	f7 f5                	div    %ebp
  80219b:	89 d0                	mov    %edx,%eax
  80219d:	31 d2                	xor    %edx,%edx
  80219f:	eb 8c                	jmp    80212d <__umoddi3+0x2d>
  8021a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021a8:	89 e9                	mov    %ebp,%ecx
  8021aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8021af:	29 ea                	sub    %ebp,%edx
  8021b1:	d3 e0                	shl    %cl,%eax
  8021b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021b7:	89 d1                	mov    %edx,%ecx
  8021b9:	89 f8                	mov    %edi,%eax
  8021bb:	d3 e8                	shr    %cl,%eax
  8021bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8021c9:	09 c1                	or     %eax,%ecx
  8021cb:	89 d8                	mov    %ebx,%eax
  8021cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021d1:	89 e9                	mov    %ebp,%ecx
  8021d3:	d3 e7                	shl    %cl,%edi
  8021d5:	89 d1                	mov    %edx,%ecx
  8021d7:	d3 e8                	shr    %cl,%eax
  8021d9:	89 e9                	mov    %ebp,%ecx
  8021db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021df:	d3 e3                	shl    %cl,%ebx
  8021e1:	89 c7                	mov    %eax,%edi
  8021e3:	89 d1                	mov    %edx,%ecx
  8021e5:	89 f0                	mov    %esi,%eax
  8021e7:	d3 e8                	shr    %cl,%eax
  8021e9:	89 e9                	mov    %ebp,%ecx
  8021eb:	89 fa                	mov    %edi,%edx
  8021ed:	d3 e6                	shl    %cl,%esi
  8021ef:	09 d8                	or     %ebx,%eax
  8021f1:	f7 74 24 08          	divl   0x8(%esp)
  8021f5:	89 d1                	mov    %edx,%ecx
  8021f7:	89 f3                	mov    %esi,%ebx
  8021f9:	f7 64 24 0c          	mull   0xc(%esp)
  8021fd:	89 c6                	mov    %eax,%esi
  8021ff:	89 d7                	mov    %edx,%edi
  802201:	39 d1                	cmp    %edx,%ecx
  802203:	72 06                	jb     80220b <__umoddi3+0x10b>
  802205:	75 10                	jne    802217 <__umoddi3+0x117>
  802207:	39 c3                	cmp    %eax,%ebx
  802209:	73 0c                	jae    802217 <__umoddi3+0x117>
  80220b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80220f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802213:	89 d7                	mov    %edx,%edi
  802215:	89 c6                	mov    %eax,%esi
  802217:	89 ca                	mov    %ecx,%edx
  802219:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80221e:	29 f3                	sub    %esi,%ebx
  802220:	19 fa                	sbb    %edi,%edx
  802222:	89 d0                	mov    %edx,%eax
  802224:	d3 e0                	shl    %cl,%eax
  802226:	89 e9                	mov    %ebp,%ecx
  802228:	d3 eb                	shr    %cl,%ebx
  80222a:	d3 ea                	shr    %cl,%edx
  80222c:	09 d8                	or     %ebx,%eax
  80222e:	83 c4 1c             	add    $0x1c,%esp
  802231:	5b                   	pop    %ebx
  802232:	5e                   	pop    %esi
  802233:	5f                   	pop    %edi
  802234:	5d                   	pop    %ebp
  802235:	c3                   	ret    
  802236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80223d:	8d 76 00             	lea    0x0(%esi),%esi
  802240:	29 fe                	sub    %edi,%esi
  802242:	19 c3                	sbb    %eax,%ebx
  802244:	89 f2                	mov    %esi,%edx
  802246:	89 d9                	mov    %ebx,%ecx
  802248:	e9 1d ff ff ff       	jmp    80216a <__umoddi3+0x6a>
