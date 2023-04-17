
obj/user/num.debug:     file format elf32-i386


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
  80002c:	e8 58 01 00 00       	call   800189 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	83 ec 10             	sub    $0x10,%esp
  80003f:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800042:	8d 5d f7             	lea    -0x9(%ebp),%ebx
  800045:	eb 43                	jmp    80008a <num+0x57>
		if (bol) {
			printf("%5d ", ++line);
  800047:	a1 00 40 80 00       	mov    0x804000,%eax
  80004c:	83 c0 01             	add    $0x1,%eax
  80004f:	a3 00 40 80 00       	mov    %eax,0x804000
  800054:	83 ec 08             	sub    $0x8,%esp
  800057:	50                   	push   %eax
  800058:	68 60 21 80 00       	push   $0x802160
  80005d:	e8 27 18 00 00       	call   801889 <printf>
			bol = 0;
  800062:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  800069:	00 00 00 
  80006c:	83 c4 10             	add    $0x10,%esp
		}
		if ((r = write(1, &c, 1)) != 1)
  80006f:	83 ec 04             	sub    $0x4,%esp
  800072:	6a 01                	push   $0x1
  800074:	53                   	push   %ebx
  800075:	6a 01                	push   $0x1
  800077:	e8 97 12 00 00       	call   801313 <write>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	83 f8 01             	cmp    $0x1,%eax
  800082:	75 24                	jne    8000a8 <num+0x75>
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
  800084:	80 7d f7 0a          	cmpb   $0xa,-0x9(%ebp)
  800088:	74 36                	je     8000c0 <num+0x8d>
	while ((n = read(f, &c, 1)) > 0) {
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	6a 01                	push   $0x1
  80008f:	53                   	push   %ebx
  800090:	56                   	push   %esi
  800091:	e8 a7 11 00 00       	call   80123d <read>
  800096:	83 c4 10             	add    $0x10,%esp
  800099:	85 c0                	test   %eax,%eax
  80009b:	7e 2f                	jle    8000cc <num+0x99>
		if (bol) {
  80009d:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  8000a4:	74 c9                	je     80006f <num+0x3c>
  8000a6:	eb 9f                	jmp    800047 <num+0x14>
			panic("write error copying %s: %e", s, r);
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	50                   	push   %eax
  8000ac:	ff 75 0c             	pushl  0xc(%ebp)
  8000af:	68 65 21 80 00       	push   $0x802165
  8000b4:	6a 13                	push   $0x13
  8000b6:	68 80 21 80 00       	push   $0x802180
  8000bb:	e8 31 01 00 00       	call   8001f1 <_panic>
			bol = 1;
  8000c0:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c7:	00 00 00 
  8000ca:	eb be                	jmp    80008a <num+0x57>
	}
	if (n < 0)
  8000cc:	78 07                	js     8000d5 <num+0xa2>
		panic("error reading %s: %e", s, n);
}
  8000ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000d1:	5b                   	pop    %ebx
  8000d2:	5e                   	pop    %esi
  8000d3:	5d                   	pop    %ebp
  8000d4:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	50                   	push   %eax
  8000d9:	ff 75 0c             	pushl  0xc(%ebp)
  8000dc:	68 8b 21 80 00       	push   $0x80218b
  8000e1:	6a 18                	push   $0x18
  8000e3:	68 80 21 80 00       	push   $0x802180
  8000e8:	e8 04 01 00 00       	call   8001f1 <_panic>

008000ed <umain>:

void
umain(int argc, char **argv)
{
  8000ed:	f3 0f 1e fb          	endbr32 
  8000f1:	55                   	push   %ebp
  8000f2:	89 e5                	mov    %esp,%ebp
  8000f4:	57                   	push   %edi
  8000f5:	56                   	push   %esi
  8000f6:	53                   	push   %ebx
  8000f7:	83 ec 1c             	sub    $0x1c,%esp
	int f, i;

	binaryname = "num";
  8000fa:	c7 05 04 30 80 00 a0 	movl   $0x8021a0,0x803004
  800101:	21 80 00 
	if (argc == 1)
  800104:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800108:	74 46                	je     800150 <umain+0x63>
  80010a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80010d:	8d 70 04             	lea    0x4(%eax),%esi
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800110:	bf 01 00 00 00       	mov    $0x1,%edi
  800115:	3b 7d 08             	cmp    0x8(%ebp),%edi
  800118:	7d 48                	jge    800162 <umain+0x75>
			f = open(argv[i], O_RDONLY);
  80011a:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	6a 00                	push   $0x0
  800122:	ff 36                	pushl  (%esi)
  800124:	e8 a9 15 00 00       	call   8016d2 <open>
  800129:	89 c3                	mov    %eax,%ebx
			if (f < 0)
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	85 c0                	test   %eax,%eax
  800130:	78 3d                	js     80016f <umain+0x82>
				panic("can't open %s: %e", argv[i], f);
			else {
				num(f, argv[i]);
  800132:	83 ec 08             	sub    $0x8,%esp
  800135:	ff 36                	pushl  (%esi)
  800137:	50                   	push   %eax
  800138:	e8 f6 fe ff ff       	call   800033 <num>
				close(f);
  80013d:	89 1c 24             	mov    %ebx,(%esp)
  800140:	e8 ae 0f 00 00       	call   8010f3 <close>
		for (i = 1; i < argc; i++) {
  800145:	83 c7 01             	add    $0x1,%edi
  800148:	83 c6 04             	add    $0x4,%esi
  80014b:	83 c4 10             	add    $0x10,%esp
  80014e:	eb c5                	jmp    800115 <umain+0x28>
		num(0, "<stdin>");
  800150:	83 ec 08             	sub    $0x8,%esp
  800153:	68 a4 21 80 00       	push   $0x8021a4
  800158:	6a 00                	push   $0x0
  80015a:	e8 d4 fe ff ff       	call   800033 <num>
  80015f:	83 c4 10             	add    $0x10,%esp
			}
		}
	exit();
  800162:	e8 6c 00 00 00       	call   8001d3 <exit>
}
  800167:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80016a:	5b                   	pop    %ebx
  80016b:	5e                   	pop    %esi
  80016c:	5f                   	pop    %edi
  80016d:	5d                   	pop    %ebp
  80016e:	c3                   	ret    
				panic("can't open %s: %e", argv[i], f);
  80016f:	83 ec 0c             	sub    $0xc,%esp
  800172:	50                   	push   %eax
  800173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800176:	ff 30                	pushl  (%eax)
  800178:	68 ac 21 80 00       	push   $0x8021ac
  80017d:	6a 27                	push   $0x27
  80017f:	68 80 21 80 00       	push   $0x802180
  800184:	e8 68 00 00 00       	call   8001f1 <_panic>

00800189 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800189:	f3 0f 1e fb          	endbr32 
  80018d:	55                   	push   %ebp
  80018e:	89 e5                	mov    %esp,%ebp
  800190:	56                   	push   %esi
  800191:	53                   	push   %ebx
  800192:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800195:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800198:	e8 41 0b 00 00       	call   800cde <sys_getenvid>
  80019d:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001a2:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001a5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001aa:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001af:	85 db                	test   %ebx,%ebx
  8001b1:	7e 07                	jle    8001ba <libmain+0x31>
		binaryname = argv[0];
  8001b3:	8b 06                	mov    (%esi),%eax
  8001b5:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8001ba:	83 ec 08             	sub    $0x8,%esp
  8001bd:	56                   	push   %esi
  8001be:	53                   	push   %ebx
  8001bf:	e8 29 ff ff ff       	call   8000ed <umain>

	// exit gracefully
	exit();
  8001c4:	e8 0a 00 00 00       	call   8001d3 <exit>
}
  8001c9:	83 c4 10             	add    $0x10,%esp
  8001cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001cf:	5b                   	pop    %ebx
  8001d0:	5e                   	pop    %esi
  8001d1:	5d                   	pop    %ebp
  8001d2:	c3                   	ret    

008001d3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d3:	f3 0f 1e fb          	endbr32 
  8001d7:	55                   	push   %ebp
  8001d8:	89 e5                	mov    %esp,%ebp
  8001da:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001dd:	e8 42 0f 00 00       	call   801124 <close_all>
	sys_env_destroy(0);
  8001e2:	83 ec 0c             	sub    $0xc,%esp
  8001e5:	6a 00                	push   $0x0
  8001e7:	e8 ad 0a 00 00       	call   800c99 <sys_env_destroy>
}
  8001ec:	83 c4 10             	add    $0x10,%esp
  8001ef:	c9                   	leave  
  8001f0:	c3                   	ret    

008001f1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001f1:	f3 0f 1e fb          	endbr32 
  8001f5:	55                   	push   %ebp
  8001f6:	89 e5                	mov    %esp,%ebp
  8001f8:	56                   	push   %esi
  8001f9:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001fa:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001fd:	8b 35 04 30 80 00    	mov    0x803004,%esi
  800203:	e8 d6 0a 00 00       	call   800cde <sys_getenvid>
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	ff 75 0c             	pushl  0xc(%ebp)
  80020e:	ff 75 08             	pushl  0x8(%ebp)
  800211:	56                   	push   %esi
  800212:	50                   	push   %eax
  800213:	68 c8 21 80 00       	push   $0x8021c8
  800218:	e8 bb 00 00 00       	call   8002d8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80021d:	83 c4 18             	add    $0x18,%esp
  800220:	53                   	push   %ebx
  800221:	ff 75 10             	pushl  0x10(%ebp)
  800224:	e8 5a 00 00 00       	call   800283 <vcprintf>
	cprintf("\n");
  800229:	c7 04 24 0f 26 80 00 	movl   $0x80260f,(%esp)
  800230:	e8 a3 00 00 00       	call   8002d8 <cprintf>
  800235:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800238:	cc                   	int3   
  800239:	eb fd                	jmp    800238 <_panic+0x47>

0080023b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80023b:	f3 0f 1e fb          	endbr32 
  80023f:	55                   	push   %ebp
  800240:	89 e5                	mov    %esp,%ebp
  800242:	53                   	push   %ebx
  800243:	83 ec 04             	sub    $0x4,%esp
  800246:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800249:	8b 13                	mov    (%ebx),%edx
  80024b:	8d 42 01             	lea    0x1(%edx),%eax
  80024e:	89 03                	mov    %eax,(%ebx)
  800250:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800253:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800257:	3d ff 00 00 00       	cmp    $0xff,%eax
  80025c:	74 09                	je     800267 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80025e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800262:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800265:	c9                   	leave  
  800266:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800267:	83 ec 08             	sub    $0x8,%esp
  80026a:	68 ff 00 00 00       	push   $0xff
  80026f:	8d 43 08             	lea    0x8(%ebx),%eax
  800272:	50                   	push   %eax
  800273:	e8 dc 09 00 00       	call   800c54 <sys_cputs>
		b->idx = 0;
  800278:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80027e:	83 c4 10             	add    $0x10,%esp
  800281:	eb db                	jmp    80025e <putch+0x23>

00800283 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800283:	f3 0f 1e fb          	endbr32 
  800287:	55                   	push   %ebp
  800288:	89 e5                	mov    %esp,%ebp
  80028a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800290:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800297:	00 00 00 
	b.cnt = 0;
  80029a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002a1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002a4:	ff 75 0c             	pushl  0xc(%ebp)
  8002a7:	ff 75 08             	pushl  0x8(%ebp)
  8002aa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b0:	50                   	push   %eax
  8002b1:	68 3b 02 80 00       	push   $0x80023b
  8002b6:	e8 20 01 00 00       	call   8003db <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002bb:	83 c4 08             	add    $0x8,%esp
  8002be:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002c4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002ca:	50                   	push   %eax
  8002cb:	e8 84 09 00 00       	call   800c54 <sys_cputs>

	return b.cnt;
}
  8002d0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002d6:	c9                   	leave  
  8002d7:	c3                   	ret    

008002d8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002d8:	f3 0f 1e fb          	endbr32 
  8002dc:	55                   	push   %ebp
  8002dd:	89 e5                	mov    %esp,%ebp
  8002df:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002e2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002e5:	50                   	push   %eax
  8002e6:	ff 75 08             	pushl  0x8(%ebp)
  8002e9:	e8 95 ff ff ff       	call   800283 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002ee:	c9                   	leave  
  8002ef:	c3                   	ret    

008002f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	57                   	push   %edi
  8002f4:	56                   	push   %esi
  8002f5:	53                   	push   %ebx
  8002f6:	83 ec 1c             	sub    $0x1c,%esp
  8002f9:	89 c7                	mov    %eax,%edi
  8002fb:	89 d6                	mov    %edx,%esi
  8002fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800300:	8b 55 0c             	mov    0xc(%ebp),%edx
  800303:	89 d1                	mov    %edx,%ecx
  800305:	89 c2                	mov    %eax,%edx
  800307:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80030a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80030d:	8b 45 10             	mov    0x10(%ebp),%eax
  800310:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800313:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800316:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80031d:	39 c2                	cmp    %eax,%edx
  80031f:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800322:	72 3e                	jb     800362 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	ff 75 18             	pushl  0x18(%ebp)
  80032a:	83 eb 01             	sub    $0x1,%ebx
  80032d:	53                   	push   %ebx
  80032e:	50                   	push   %eax
  80032f:	83 ec 08             	sub    $0x8,%esp
  800332:	ff 75 e4             	pushl  -0x1c(%ebp)
  800335:	ff 75 e0             	pushl  -0x20(%ebp)
  800338:	ff 75 dc             	pushl  -0x24(%ebp)
  80033b:	ff 75 d8             	pushl  -0x28(%ebp)
  80033e:	e8 bd 1b 00 00       	call   801f00 <__udivdi3>
  800343:	83 c4 18             	add    $0x18,%esp
  800346:	52                   	push   %edx
  800347:	50                   	push   %eax
  800348:	89 f2                	mov    %esi,%edx
  80034a:	89 f8                	mov    %edi,%eax
  80034c:	e8 9f ff ff ff       	call   8002f0 <printnum>
  800351:	83 c4 20             	add    $0x20,%esp
  800354:	eb 13                	jmp    800369 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800356:	83 ec 08             	sub    $0x8,%esp
  800359:	56                   	push   %esi
  80035a:	ff 75 18             	pushl  0x18(%ebp)
  80035d:	ff d7                	call   *%edi
  80035f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800362:	83 eb 01             	sub    $0x1,%ebx
  800365:	85 db                	test   %ebx,%ebx
  800367:	7f ed                	jg     800356 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800369:	83 ec 08             	sub    $0x8,%esp
  80036c:	56                   	push   %esi
  80036d:	83 ec 04             	sub    $0x4,%esp
  800370:	ff 75 e4             	pushl  -0x1c(%ebp)
  800373:	ff 75 e0             	pushl  -0x20(%ebp)
  800376:	ff 75 dc             	pushl  -0x24(%ebp)
  800379:	ff 75 d8             	pushl  -0x28(%ebp)
  80037c:	e8 8f 1c 00 00       	call   802010 <__umoddi3>
  800381:	83 c4 14             	add    $0x14,%esp
  800384:	0f be 80 eb 21 80 00 	movsbl 0x8021eb(%eax),%eax
  80038b:	50                   	push   %eax
  80038c:	ff d7                	call   *%edi
}
  80038e:	83 c4 10             	add    $0x10,%esp
  800391:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800394:	5b                   	pop    %ebx
  800395:	5e                   	pop    %esi
  800396:	5f                   	pop    %edi
  800397:	5d                   	pop    %ebp
  800398:	c3                   	ret    

00800399 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800399:	f3 0f 1e fb          	endbr32 
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003a3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003a7:	8b 10                	mov    (%eax),%edx
  8003a9:	3b 50 04             	cmp    0x4(%eax),%edx
  8003ac:	73 0a                	jae    8003b8 <sprintputch+0x1f>
		*b->buf++ = ch;
  8003ae:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003b1:	89 08                	mov    %ecx,(%eax)
  8003b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b6:	88 02                	mov    %al,(%edx)
}
  8003b8:	5d                   	pop    %ebp
  8003b9:	c3                   	ret    

008003ba <printfmt>:
{
  8003ba:	f3 0f 1e fb          	endbr32 
  8003be:	55                   	push   %ebp
  8003bf:	89 e5                	mov    %esp,%ebp
  8003c1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003c4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003c7:	50                   	push   %eax
  8003c8:	ff 75 10             	pushl  0x10(%ebp)
  8003cb:	ff 75 0c             	pushl  0xc(%ebp)
  8003ce:	ff 75 08             	pushl  0x8(%ebp)
  8003d1:	e8 05 00 00 00       	call   8003db <vprintfmt>
}
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	c9                   	leave  
  8003da:	c3                   	ret    

008003db <vprintfmt>:
{
  8003db:	f3 0f 1e fb          	endbr32 
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	57                   	push   %edi
  8003e3:	56                   	push   %esi
  8003e4:	53                   	push   %ebx
  8003e5:	83 ec 3c             	sub    $0x3c,%esp
  8003e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8003eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003ee:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003f1:	e9 8e 03 00 00       	jmp    800784 <vprintfmt+0x3a9>
		padc = ' ';
  8003f6:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003fa:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800401:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800408:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80040f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800414:	8d 47 01             	lea    0x1(%edi),%eax
  800417:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80041a:	0f b6 17             	movzbl (%edi),%edx
  80041d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800420:	3c 55                	cmp    $0x55,%al
  800422:	0f 87 df 03 00 00    	ja     800807 <vprintfmt+0x42c>
  800428:	0f b6 c0             	movzbl %al,%eax
  80042b:	3e ff 24 85 20 23 80 	notrack jmp *0x802320(,%eax,4)
  800432:	00 
  800433:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800436:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80043a:	eb d8                	jmp    800414 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80043c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80043f:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800443:	eb cf                	jmp    800414 <vprintfmt+0x39>
  800445:	0f b6 d2             	movzbl %dl,%edx
  800448:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80044b:	b8 00 00 00 00       	mov    $0x0,%eax
  800450:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800453:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800456:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80045a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80045d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800460:	83 f9 09             	cmp    $0x9,%ecx
  800463:	77 55                	ja     8004ba <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800465:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800468:	eb e9                	jmp    800453 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80046a:	8b 45 14             	mov    0x14(%ebp),%eax
  80046d:	8b 00                	mov    (%eax),%eax
  80046f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800472:	8b 45 14             	mov    0x14(%ebp),%eax
  800475:	8d 40 04             	lea    0x4(%eax),%eax
  800478:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80047b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80047e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800482:	79 90                	jns    800414 <vprintfmt+0x39>
				width = precision, precision = -1;
  800484:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800487:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80048a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800491:	eb 81                	jmp    800414 <vprintfmt+0x39>
  800493:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800496:	85 c0                	test   %eax,%eax
  800498:	ba 00 00 00 00       	mov    $0x0,%edx
  80049d:	0f 49 d0             	cmovns %eax,%edx
  8004a0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004a6:	e9 69 ff ff ff       	jmp    800414 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004ae:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004b5:	e9 5a ff ff ff       	jmp    800414 <vprintfmt+0x39>
  8004ba:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c0:	eb bc                	jmp    80047e <vprintfmt+0xa3>
			lflag++;
  8004c2:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004c8:	e9 47 ff ff ff       	jmp    800414 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8004cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d0:	8d 78 04             	lea    0x4(%eax),%edi
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	53                   	push   %ebx
  8004d7:	ff 30                	pushl  (%eax)
  8004d9:	ff d6                	call   *%esi
			break;
  8004db:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004de:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004e1:	e9 9b 02 00 00       	jmp    800781 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8004e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e9:	8d 78 04             	lea    0x4(%eax),%edi
  8004ec:	8b 00                	mov    (%eax),%eax
  8004ee:	99                   	cltd   
  8004ef:	31 d0                	xor    %edx,%eax
  8004f1:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004f3:	83 f8 0f             	cmp    $0xf,%eax
  8004f6:	7f 23                	jg     80051b <vprintfmt+0x140>
  8004f8:	8b 14 85 80 24 80 00 	mov    0x802480(,%eax,4),%edx
  8004ff:	85 d2                	test   %edx,%edx
  800501:	74 18                	je     80051b <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800503:	52                   	push   %edx
  800504:	68 b1 25 80 00       	push   $0x8025b1
  800509:	53                   	push   %ebx
  80050a:	56                   	push   %esi
  80050b:	e8 aa fe ff ff       	call   8003ba <printfmt>
  800510:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800513:	89 7d 14             	mov    %edi,0x14(%ebp)
  800516:	e9 66 02 00 00       	jmp    800781 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80051b:	50                   	push   %eax
  80051c:	68 03 22 80 00       	push   $0x802203
  800521:	53                   	push   %ebx
  800522:	56                   	push   %esi
  800523:	e8 92 fe ff ff       	call   8003ba <printfmt>
  800528:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80052b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80052e:	e9 4e 02 00 00       	jmp    800781 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800533:	8b 45 14             	mov    0x14(%ebp),%eax
  800536:	83 c0 04             	add    $0x4,%eax
  800539:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80053c:	8b 45 14             	mov    0x14(%ebp),%eax
  80053f:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800541:	85 d2                	test   %edx,%edx
  800543:	b8 fc 21 80 00       	mov    $0x8021fc,%eax
  800548:	0f 45 c2             	cmovne %edx,%eax
  80054b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80054e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800552:	7e 06                	jle    80055a <vprintfmt+0x17f>
  800554:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800558:	75 0d                	jne    800567 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80055a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80055d:	89 c7                	mov    %eax,%edi
  80055f:	03 45 e0             	add    -0x20(%ebp),%eax
  800562:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800565:	eb 55                	jmp    8005bc <vprintfmt+0x1e1>
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	ff 75 d8             	pushl  -0x28(%ebp)
  80056d:	ff 75 cc             	pushl  -0x34(%ebp)
  800570:	e8 46 03 00 00       	call   8008bb <strnlen>
  800575:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800578:	29 c2                	sub    %eax,%edx
  80057a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80057d:	83 c4 10             	add    $0x10,%esp
  800580:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800582:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800586:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800589:	85 ff                	test   %edi,%edi
  80058b:	7e 11                	jle    80059e <vprintfmt+0x1c3>
					putch(padc, putdat);
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	53                   	push   %ebx
  800591:	ff 75 e0             	pushl  -0x20(%ebp)
  800594:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800596:	83 ef 01             	sub    $0x1,%edi
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	eb eb                	jmp    800589 <vprintfmt+0x1ae>
  80059e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005a1:	85 d2                	test   %edx,%edx
  8005a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a8:	0f 49 c2             	cmovns %edx,%eax
  8005ab:	29 c2                	sub    %eax,%edx
  8005ad:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005b0:	eb a8                	jmp    80055a <vprintfmt+0x17f>
					putch(ch, putdat);
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	53                   	push   %ebx
  8005b6:	52                   	push   %edx
  8005b7:	ff d6                	call   *%esi
  8005b9:	83 c4 10             	add    $0x10,%esp
  8005bc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005bf:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005c1:	83 c7 01             	add    $0x1,%edi
  8005c4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005c8:	0f be d0             	movsbl %al,%edx
  8005cb:	85 d2                	test   %edx,%edx
  8005cd:	74 4b                	je     80061a <vprintfmt+0x23f>
  8005cf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005d3:	78 06                	js     8005db <vprintfmt+0x200>
  8005d5:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005d9:	78 1e                	js     8005f9 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8005db:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005df:	74 d1                	je     8005b2 <vprintfmt+0x1d7>
  8005e1:	0f be c0             	movsbl %al,%eax
  8005e4:	83 e8 20             	sub    $0x20,%eax
  8005e7:	83 f8 5e             	cmp    $0x5e,%eax
  8005ea:	76 c6                	jbe    8005b2 <vprintfmt+0x1d7>
					putch('?', putdat);
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	53                   	push   %ebx
  8005f0:	6a 3f                	push   $0x3f
  8005f2:	ff d6                	call   *%esi
  8005f4:	83 c4 10             	add    $0x10,%esp
  8005f7:	eb c3                	jmp    8005bc <vprintfmt+0x1e1>
  8005f9:	89 cf                	mov    %ecx,%edi
  8005fb:	eb 0e                	jmp    80060b <vprintfmt+0x230>
				putch(' ', putdat);
  8005fd:	83 ec 08             	sub    $0x8,%esp
  800600:	53                   	push   %ebx
  800601:	6a 20                	push   $0x20
  800603:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800605:	83 ef 01             	sub    $0x1,%edi
  800608:	83 c4 10             	add    $0x10,%esp
  80060b:	85 ff                	test   %edi,%edi
  80060d:	7f ee                	jg     8005fd <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80060f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800612:	89 45 14             	mov    %eax,0x14(%ebp)
  800615:	e9 67 01 00 00       	jmp    800781 <vprintfmt+0x3a6>
  80061a:	89 cf                	mov    %ecx,%edi
  80061c:	eb ed                	jmp    80060b <vprintfmt+0x230>
	if (lflag >= 2)
  80061e:	83 f9 01             	cmp    $0x1,%ecx
  800621:	7f 1b                	jg     80063e <vprintfmt+0x263>
	else if (lflag)
  800623:	85 c9                	test   %ecx,%ecx
  800625:	74 63                	je     80068a <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8b 00                	mov    (%eax),%eax
  80062c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062f:	99                   	cltd   
  800630:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	8d 40 04             	lea    0x4(%eax),%eax
  800639:	89 45 14             	mov    %eax,0x14(%ebp)
  80063c:	eb 17                	jmp    800655 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8b 50 04             	mov    0x4(%eax),%edx
  800644:	8b 00                	mov    (%eax),%eax
  800646:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800649:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8d 40 08             	lea    0x8(%eax),%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800655:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800658:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80065b:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800660:	85 c9                	test   %ecx,%ecx
  800662:	0f 89 ff 00 00 00    	jns    800767 <vprintfmt+0x38c>
				putch('-', putdat);
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	53                   	push   %ebx
  80066c:	6a 2d                	push   $0x2d
  80066e:	ff d6                	call   *%esi
				num = -(long long) num;
  800670:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800673:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800676:	f7 da                	neg    %edx
  800678:	83 d1 00             	adc    $0x0,%ecx
  80067b:	f7 d9                	neg    %ecx
  80067d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800680:	b8 0a 00 00 00       	mov    $0xa,%eax
  800685:	e9 dd 00 00 00       	jmp    800767 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	8b 00                	mov    (%eax),%eax
  80068f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800692:	99                   	cltd   
  800693:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	8d 40 04             	lea    0x4(%eax),%eax
  80069c:	89 45 14             	mov    %eax,0x14(%ebp)
  80069f:	eb b4                	jmp    800655 <vprintfmt+0x27a>
	if (lflag >= 2)
  8006a1:	83 f9 01             	cmp    $0x1,%ecx
  8006a4:	7f 1e                	jg     8006c4 <vprintfmt+0x2e9>
	else if (lflag)
  8006a6:	85 c9                	test   %ecx,%ecx
  8006a8:	74 32                	je     8006dc <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8b 10                	mov    (%eax),%edx
  8006af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b4:	8d 40 04             	lea    0x4(%eax),%eax
  8006b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ba:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8006bf:	e9 a3 00 00 00       	jmp    800767 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8b 10                	mov    (%eax),%edx
  8006c9:	8b 48 04             	mov    0x4(%eax),%ecx
  8006cc:	8d 40 08             	lea    0x8(%eax),%eax
  8006cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006d2:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8006d7:	e9 8b 00 00 00       	jmp    800767 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8b 10                	mov    (%eax),%edx
  8006e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e6:	8d 40 04             	lea    0x4(%eax),%eax
  8006e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ec:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8006f1:	eb 74                	jmp    800767 <vprintfmt+0x38c>
	if (lflag >= 2)
  8006f3:	83 f9 01             	cmp    $0x1,%ecx
  8006f6:	7f 1b                	jg     800713 <vprintfmt+0x338>
	else if (lflag)
  8006f8:	85 c9                	test   %ecx,%ecx
  8006fa:	74 2c                	je     800728 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8b 10                	mov    (%eax),%edx
  800701:	b9 00 00 00 00       	mov    $0x0,%ecx
  800706:	8d 40 04             	lea    0x4(%eax),%eax
  800709:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80070c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800711:	eb 54                	jmp    800767 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8b 10                	mov    (%eax),%edx
  800718:	8b 48 04             	mov    0x4(%eax),%ecx
  80071b:	8d 40 08             	lea    0x8(%eax),%eax
  80071e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800721:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800726:	eb 3f                	jmp    800767 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	8b 10                	mov    (%eax),%edx
  80072d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800732:	8d 40 04             	lea    0x4(%eax),%eax
  800735:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800738:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80073d:	eb 28                	jmp    800767 <vprintfmt+0x38c>
			putch('0', putdat);
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	53                   	push   %ebx
  800743:	6a 30                	push   $0x30
  800745:	ff d6                	call   *%esi
			putch('x', putdat);
  800747:	83 c4 08             	add    $0x8,%esp
  80074a:	53                   	push   %ebx
  80074b:	6a 78                	push   $0x78
  80074d:	ff d6                	call   *%esi
			num = (unsigned long long)
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8b 10                	mov    (%eax),%edx
  800754:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800759:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80075c:	8d 40 04             	lea    0x4(%eax),%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800762:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800767:	83 ec 0c             	sub    $0xc,%esp
  80076a:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80076e:	57                   	push   %edi
  80076f:	ff 75 e0             	pushl  -0x20(%ebp)
  800772:	50                   	push   %eax
  800773:	51                   	push   %ecx
  800774:	52                   	push   %edx
  800775:	89 da                	mov    %ebx,%edx
  800777:	89 f0                	mov    %esi,%eax
  800779:	e8 72 fb ff ff       	call   8002f0 <printnum>
			break;
  80077e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800781:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800784:	83 c7 01             	add    $0x1,%edi
  800787:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80078b:	83 f8 25             	cmp    $0x25,%eax
  80078e:	0f 84 62 fc ff ff    	je     8003f6 <vprintfmt+0x1b>
			if (ch == '\0')
  800794:	85 c0                	test   %eax,%eax
  800796:	0f 84 8b 00 00 00    	je     800827 <vprintfmt+0x44c>
			putch(ch, putdat);
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	53                   	push   %ebx
  8007a0:	50                   	push   %eax
  8007a1:	ff d6                	call   *%esi
  8007a3:	83 c4 10             	add    $0x10,%esp
  8007a6:	eb dc                	jmp    800784 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8007a8:	83 f9 01             	cmp    $0x1,%ecx
  8007ab:	7f 1b                	jg     8007c8 <vprintfmt+0x3ed>
	else if (lflag)
  8007ad:	85 c9                	test   %ecx,%ecx
  8007af:	74 2c                	je     8007dd <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8007b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b4:	8b 10                	mov    (%eax),%edx
  8007b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007bb:	8d 40 04             	lea    0x4(%eax),%eax
  8007be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c1:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8007c6:	eb 9f                	jmp    800767 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8007c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cb:	8b 10                	mov    (%eax),%edx
  8007cd:	8b 48 04             	mov    0x4(%eax),%ecx
  8007d0:	8d 40 08             	lea    0x8(%eax),%eax
  8007d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d6:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8007db:	eb 8a                	jmp    800767 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8007dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e0:	8b 10                	mov    (%eax),%edx
  8007e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007e7:	8d 40 04             	lea    0x4(%eax),%eax
  8007ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ed:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8007f2:	e9 70 ff ff ff       	jmp    800767 <vprintfmt+0x38c>
			putch(ch, putdat);
  8007f7:	83 ec 08             	sub    $0x8,%esp
  8007fa:	53                   	push   %ebx
  8007fb:	6a 25                	push   $0x25
  8007fd:	ff d6                	call   *%esi
			break;
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	e9 7a ff ff ff       	jmp    800781 <vprintfmt+0x3a6>
			putch('%', putdat);
  800807:	83 ec 08             	sub    $0x8,%esp
  80080a:	53                   	push   %ebx
  80080b:	6a 25                	push   $0x25
  80080d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80080f:	83 c4 10             	add    $0x10,%esp
  800812:	89 f8                	mov    %edi,%eax
  800814:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800818:	74 05                	je     80081f <vprintfmt+0x444>
  80081a:	83 e8 01             	sub    $0x1,%eax
  80081d:	eb f5                	jmp    800814 <vprintfmt+0x439>
  80081f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800822:	e9 5a ff ff ff       	jmp    800781 <vprintfmt+0x3a6>
}
  800827:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80082a:	5b                   	pop    %ebx
  80082b:	5e                   	pop    %esi
  80082c:	5f                   	pop    %edi
  80082d:	5d                   	pop    %ebp
  80082e:	c3                   	ret    

0080082f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80082f:	f3 0f 1e fb          	endbr32 
  800833:	55                   	push   %ebp
  800834:	89 e5                	mov    %esp,%ebp
  800836:	83 ec 18             	sub    $0x18,%esp
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80083f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800842:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800846:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800849:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800850:	85 c0                	test   %eax,%eax
  800852:	74 26                	je     80087a <vsnprintf+0x4b>
  800854:	85 d2                	test   %edx,%edx
  800856:	7e 22                	jle    80087a <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800858:	ff 75 14             	pushl  0x14(%ebp)
  80085b:	ff 75 10             	pushl  0x10(%ebp)
  80085e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800861:	50                   	push   %eax
  800862:	68 99 03 80 00       	push   $0x800399
  800867:	e8 6f fb ff ff       	call   8003db <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80086c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80086f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800875:	83 c4 10             	add    $0x10,%esp
}
  800878:	c9                   	leave  
  800879:	c3                   	ret    
		return -E_INVAL;
  80087a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80087f:	eb f7                	jmp    800878 <vsnprintf+0x49>

00800881 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800881:	f3 0f 1e fb          	endbr32 
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80088b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80088e:	50                   	push   %eax
  80088f:	ff 75 10             	pushl  0x10(%ebp)
  800892:	ff 75 0c             	pushl  0xc(%ebp)
  800895:	ff 75 08             	pushl  0x8(%ebp)
  800898:	e8 92 ff ff ff       	call   80082f <vsnprintf>
	va_end(ap);

	return rc;
}
  80089d:	c9                   	leave  
  80089e:	c3                   	ret    

0080089f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80089f:	f3 0f 1e fb          	endbr32 
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ae:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008b2:	74 05                	je     8008b9 <strlen+0x1a>
		n++;
  8008b4:	83 c0 01             	add    $0x1,%eax
  8008b7:	eb f5                	jmp    8008ae <strlen+0xf>
	return n;
}
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008bb:	f3 0f 1e fb          	endbr32 
  8008bf:	55                   	push   %ebp
  8008c0:	89 e5                	mov    %esp,%ebp
  8008c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c5:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cd:	39 d0                	cmp    %edx,%eax
  8008cf:	74 0d                	je     8008de <strnlen+0x23>
  8008d1:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008d5:	74 05                	je     8008dc <strnlen+0x21>
		n++;
  8008d7:	83 c0 01             	add    $0x1,%eax
  8008da:	eb f1                	jmp    8008cd <strnlen+0x12>
  8008dc:	89 c2                	mov    %eax,%edx
	return n;
}
  8008de:	89 d0                	mov    %edx,%eax
  8008e0:	5d                   	pop    %ebp
  8008e1:	c3                   	ret    

008008e2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008e2:	f3 0f 1e fb          	endbr32 
  8008e6:	55                   	push   %ebp
  8008e7:	89 e5                	mov    %esp,%ebp
  8008e9:	53                   	push   %ebx
  8008ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f5:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008f9:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008fc:	83 c0 01             	add    $0x1,%eax
  8008ff:	84 d2                	test   %dl,%dl
  800901:	75 f2                	jne    8008f5 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800903:	89 c8                	mov    %ecx,%eax
  800905:	5b                   	pop    %ebx
  800906:	5d                   	pop    %ebp
  800907:	c3                   	ret    

00800908 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800908:	f3 0f 1e fb          	endbr32 
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	53                   	push   %ebx
  800910:	83 ec 10             	sub    $0x10,%esp
  800913:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800916:	53                   	push   %ebx
  800917:	e8 83 ff ff ff       	call   80089f <strlen>
  80091c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80091f:	ff 75 0c             	pushl  0xc(%ebp)
  800922:	01 d8                	add    %ebx,%eax
  800924:	50                   	push   %eax
  800925:	e8 b8 ff ff ff       	call   8008e2 <strcpy>
	return dst;
}
  80092a:	89 d8                	mov    %ebx,%eax
  80092c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80092f:	c9                   	leave  
  800930:	c3                   	ret    

00800931 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800931:	f3 0f 1e fb          	endbr32 
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	56                   	push   %esi
  800939:	53                   	push   %ebx
  80093a:	8b 75 08             	mov    0x8(%ebp),%esi
  80093d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800940:	89 f3                	mov    %esi,%ebx
  800942:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800945:	89 f0                	mov    %esi,%eax
  800947:	39 d8                	cmp    %ebx,%eax
  800949:	74 11                	je     80095c <strncpy+0x2b>
		*dst++ = *src;
  80094b:	83 c0 01             	add    $0x1,%eax
  80094e:	0f b6 0a             	movzbl (%edx),%ecx
  800951:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800954:	80 f9 01             	cmp    $0x1,%cl
  800957:	83 da ff             	sbb    $0xffffffff,%edx
  80095a:	eb eb                	jmp    800947 <strncpy+0x16>
	}
	return ret;
}
  80095c:	89 f0                	mov    %esi,%eax
  80095e:	5b                   	pop    %ebx
  80095f:	5e                   	pop    %esi
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    

00800962 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800962:	f3 0f 1e fb          	endbr32 
  800966:	55                   	push   %ebp
  800967:	89 e5                	mov    %esp,%ebp
  800969:	56                   	push   %esi
  80096a:	53                   	push   %ebx
  80096b:	8b 75 08             	mov    0x8(%ebp),%esi
  80096e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800971:	8b 55 10             	mov    0x10(%ebp),%edx
  800974:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800976:	85 d2                	test   %edx,%edx
  800978:	74 21                	je     80099b <strlcpy+0x39>
  80097a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80097e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800980:	39 c2                	cmp    %eax,%edx
  800982:	74 14                	je     800998 <strlcpy+0x36>
  800984:	0f b6 19             	movzbl (%ecx),%ebx
  800987:	84 db                	test   %bl,%bl
  800989:	74 0b                	je     800996 <strlcpy+0x34>
			*dst++ = *src++;
  80098b:	83 c1 01             	add    $0x1,%ecx
  80098e:	83 c2 01             	add    $0x1,%edx
  800991:	88 5a ff             	mov    %bl,-0x1(%edx)
  800994:	eb ea                	jmp    800980 <strlcpy+0x1e>
  800996:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800998:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80099b:	29 f0                	sub    %esi,%eax
}
  80099d:	5b                   	pop    %ebx
  80099e:	5e                   	pop    %esi
  80099f:	5d                   	pop    %ebp
  8009a0:	c3                   	ret    

008009a1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009a1:	f3 0f 1e fb          	endbr32 
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ae:	0f b6 01             	movzbl (%ecx),%eax
  8009b1:	84 c0                	test   %al,%al
  8009b3:	74 0c                	je     8009c1 <strcmp+0x20>
  8009b5:	3a 02                	cmp    (%edx),%al
  8009b7:	75 08                	jne    8009c1 <strcmp+0x20>
		p++, q++;
  8009b9:	83 c1 01             	add    $0x1,%ecx
  8009bc:	83 c2 01             	add    $0x1,%edx
  8009bf:	eb ed                	jmp    8009ae <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c1:	0f b6 c0             	movzbl %al,%eax
  8009c4:	0f b6 12             	movzbl (%edx),%edx
  8009c7:	29 d0                	sub    %edx,%eax
}
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009cb:	f3 0f 1e fb          	endbr32 
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	53                   	push   %ebx
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d9:	89 c3                	mov    %eax,%ebx
  8009db:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009de:	eb 06                	jmp    8009e6 <strncmp+0x1b>
		n--, p++, q++;
  8009e0:	83 c0 01             	add    $0x1,%eax
  8009e3:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009e6:	39 d8                	cmp    %ebx,%eax
  8009e8:	74 16                	je     800a00 <strncmp+0x35>
  8009ea:	0f b6 08             	movzbl (%eax),%ecx
  8009ed:	84 c9                	test   %cl,%cl
  8009ef:	74 04                	je     8009f5 <strncmp+0x2a>
  8009f1:	3a 0a                	cmp    (%edx),%cl
  8009f3:	74 eb                	je     8009e0 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f5:	0f b6 00             	movzbl (%eax),%eax
  8009f8:	0f b6 12             	movzbl (%edx),%edx
  8009fb:	29 d0                	sub    %edx,%eax
}
  8009fd:	5b                   	pop    %ebx
  8009fe:	5d                   	pop    %ebp
  8009ff:	c3                   	ret    
		return 0;
  800a00:	b8 00 00 00 00       	mov    $0x0,%eax
  800a05:	eb f6                	jmp    8009fd <strncmp+0x32>

00800a07 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a07:	f3 0f 1e fb          	endbr32 
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a15:	0f b6 10             	movzbl (%eax),%edx
  800a18:	84 d2                	test   %dl,%dl
  800a1a:	74 09                	je     800a25 <strchr+0x1e>
		if (*s == c)
  800a1c:	38 ca                	cmp    %cl,%dl
  800a1e:	74 0a                	je     800a2a <strchr+0x23>
	for (; *s; s++)
  800a20:	83 c0 01             	add    $0x1,%eax
  800a23:	eb f0                	jmp    800a15 <strchr+0xe>
			return (char *) s;
	return 0;
  800a25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    

00800a2c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a2c:	f3 0f 1e fb          	endbr32 
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a3a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a3d:	38 ca                	cmp    %cl,%dl
  800a3f:	74 09                	je     800a4a <strfind+0x1e>
  800a41:	84 d2                	test   %dl,%dl
  800a43:	74 05                	je     800a4a <strfind+0x1e>
	for (; *s; s++)
  800a45:	83 c0 01             	add    $0x1,%eax
  800a48:	eb f0                	jmp    800a3a <strfind+0xe>
			break;
	return (char *) s;
}
  800a4a:	5d                   	pop    %ebp
  800a4b:	c3                   	ret    

00800a4c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a4c:	f3 0f 1e fb          	endbr32 
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	57                   	push   %edi
  800a54:	56                   	push   %esi
  800a55:	53                   	push   %ebx
  800a56:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a59:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a5c:	85 c9                	test   %ecx,%ecx
  800a5e:	74 31                	je     800a91 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a60:	89 f8                	mov    %edi,%eax
  800a62:	09 c8                	or     %ecx,%eax
  800a64:	a8 03                	test   $0x3,%al
  800a66:	75 23                	jne    800a8b <memset+0x3f>
		c &= 0xFF;
  800a68:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a6c:	89 d3                	mov    %edx,%ebx
  800a6e:	c1 e3 08             	shl    $0x8,%ebx
  800a71:	89 d0                	mov    %edx,%eax
  800a73:	c1 e0 18             	shl    $0x18,%eax
  800a76:	89 d6                	mov    %edx,%esi
  800a78:	c1 e6 10             	shl    $0x10,%esi
  800a7b:	09 f0                	or     %esi,%eax
  800a7d:	09 c2                	or     %eax,%edx
  800a7f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a81:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a84:	89 d0                	mov    %edx,%eax
  800a86:	fc                   	cld    
  800a87:	f3 ab                	rep stos %eax,%es:(%edi)
  800a89:	eb 06                	jmp    800a91 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8e:	fc                   	cld    
  800a8f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a91:	89 f8                	mov    %edi,%eax
  800a93:	5b                   	pop    %ebx
  800a94:	5e                   	pop    %esi
  800a95:	5f                   	pop    %edi
  800a96:	5d                   	pop    %ebp
  800a97:	c3                   	ret    

00800a98 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a98:	f3 0f 1e fb          	endbr32 
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	57                   	push   %edi
  800aa0:	56                   	push   %esi
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aa7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aaa:	39 c6                	cmp    %eax,%esi
  800aac:	73 32                	jae    800ae0 <memmove+0x48>
  800aae:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ab1:	39 c2                	cmp    %eax,%edx
  800ab3:	76 2b                	jbe    800ae0 <memmove+0x48>
		s += n;
		d += n;
  800ab5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab8:	89 fe                	mov    %edi,%esi
  800aba:	09 ce                	or     %ecx,%esi
  800abc:	09 d6                	or     %edx,%esi
  800abe:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ac4:	75 0e                	jne    800ad4 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ac6:	83 ef 04             	sub    $0x4,%edi
  800ac9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800acc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800acf:	fd                   	std    
  800ad0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad2:	eb 09                	jmp    800add <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ad4:	83 ef 01             	sub    $0x1,%edi
  800ad7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ada:	fd                   	std    
  800adb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800add:	fc                   	cld    
  800ade:	eb 1a                	jmp    800afa <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae0:	89 c2                	mov    %eax,%edx
  800ae2:	09 ca                	or     %ecx,%edx
  800ae4:	09 f2                	or     %esi,%edx
  800ae6:	f6 c2 03             	test   $0x3,%dl
  800ae9:	75 0a                	jne    800af5 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aeb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aee:	89 c7                	mov    %eax,%edi
  800af0:	fc                   	cld    
  800af1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af3:	eb 05                	jmp    800afa <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800af5:	89 c7                	mov    %eax,%edi
  800af7:	fc                   	cld    
  800af8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800afa:	5e                   	pop    %esi
  800afb:	5f                   	pop    %edi
  800afc:	5d                   	pop    %ebp
  800afd:	c3                   	ret    

00800afe <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800afe:	f3 0f 1e fb          	endbr32 
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b08:	ff 75 10             	pushl  0x10(%ebp)
  800b0b:	ff 75 0c             	pushl  0xc(%ebp)
  800b0e:	ff 75 08             	pushl  0x8(%ebp)
  800b11:	e8 82 ff ff ff       	call   800a98 <memmove>
}
  800b16:	c9                   	leave  
  800b17:	c3                   	ret    

00800b18 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b18:	f3 0f 1e fb          	endbr32 
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	56                   	push   %esi
  800b20:	53                   	push   %ebx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b27:	89 c6                	mov    %eax,%esi
  800b29:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b2c:	39 f0                	cmp    %esi,%eax
  800b2e:	74 1c                	je     800b4c <memcmp+0x34>
		if (*s1 != *s2)
  800b30:	0f b6 08             	movzbl (%eax),%ecx
  800b33:	0f b6 1a             	movzbl (%edx),%ebx
  800b36:	38 d9                	cmp    %bl,%cl
  800b38:	75 08                	jne    800b42 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b3a:	83 c0 01             	add    $0x1,%eax
  800b3d:	83 c2 01             	add    $0x1,%edx
  800b40:	eb ea                	jmp    800b2c <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b42:	0f b6 c1             	movzbl %cl,%eax
  800b45:	0f b6 db             	movzbl %bl,%ebx
  800b48:	29 d8                	sub    %ebx,%eax
  800b4a:	eb 05                	jmp    800b51 <memcmp+0x39>
	}

	return 0;
  800b4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b51:	5b                   	pop    %ebx
  800b52:	5e                   	pop    %esi
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b55:	f3 0f 1e fb          	endbr32 
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b62:	89 c2                	mov    %eax,%edx
  800b64:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b67:	39 d0                	cmp    %edx,%eax
  800b69:	73 09                	jae    800b74 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b6b:	38 08                	cmp    %cl,(%eax)
  800b6d:	74 05                	je     800b74 <memfind+0x1f>
	for (; s < ends; s++)
  800b6f:	83 c0 01             	add    $0x1,%eax
  800b72:	eb f3                	jmp    800b67 <memfind+0x12>
			break;
	return (void *) s;
}
  800b74:	5d                   	pop    %ebp
  800b75:	c3                   	ret    

00800b76 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b76:	f3 0f 1e fb          	endbr32 
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	57                   	push   %edi
  800b7e:	56                   	push   %esi
  800b7f:	53                   	push   %ebx
  800b80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b83:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b86:	eb 03                	jmp    800b8b <strtol+0x15>
		s++;
  800b88:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b8b:	0f b6 01             	movzbl (%ecx),%eax
  800b8e:	3c 20                	cmp    $0x20,%al
  800b90:	74 f6                	je     800b88 <strtol+0x12>
  800b92:	3c 09                	cmp    $0x9,%al
  800b94:	74 f2                	je     800b88 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b96:	3c 2b                	cmp    $0x2b,%al
  800b98:	74 2a                	je     800bc4 <strtol+0x4e>
	int neg = 0;
  800b9a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b9f:	3c 2d                	cmp    $0x2d,%al
  800ba1:	74 2b                	je     800bce <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ba9:	75 0f                	jne    800bba <strtol+0x44>
  800bab:	80 39 30             	cmpb   $0x30,(%ecx)
  800bae:	74 28                	je     800bd8 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bb0:	85 db                	test   %ebx,%ebx
  800bb2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bb7:	0f 44 d8             	cmove  %eax,%ebx
  800bba:	b8 00 00 00 00       	mov    $0x0,%eax
  800bbf:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bc2:	eb 46                	jmp    800c0a <strtol+0x94>
		s++;
  800bc4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bc7:	bf 00 00 00 00       	mov    $0x0,%edi
  800bcc:	eb d5                	jmp    800ba3 <strtol+0x2d>
		s++, neg = 1;
  800bce:	83 c1 01             	add    $0x1,%ecx
  800bd1:	bf 01 00 00 00       	mov    $0x1,%edi
  800bd6:	eb cb                	jmp    800ba3 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bdc:	74 0e                	je     800bec <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bde:	85 db                	test   %ebx,%ebx
  800be0:	75 d8                	jne    800bba <strtol+0x44>
		s++, base = 8;
  800be2:	83 c1 01             	add    $0x1,%ecx
  800be5:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bea:	eb ce                	jmp    800bba <strtol+0x44>
		s += 2, base = 16;
  800bec:	83 c1 02             	add    $0x2,%ecx
  800bef:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bf4:	eb c4                	jmp    800bba <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800bf6:	0f be d2             	movsbl %dl,%edx
  800bf9:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bfc:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bff:	7d 3a                	jge    800c3b <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c01:	83 c1 01             	add    $0x1,%ecx
  800c04:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c08:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c0a:	0f b6 11             	movzbl (%ecx),%edx
  800c0d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c10:	89 f3                	mov    %esi,%ebx
  800c12:	80 fb 09             	cmp    $0x9,%bl
  800c15:	76 df                	jbe    800bf6 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c17:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c1a:	89 f3                	mov    %esi,%ebx
  800c1c:	80 fb 19             	cmp    $0x19,%bl
  800c1f:	77 08                	ja     800c29 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c21:	0f be d2             	movsbl %dl,%edx
  800c24:	83 ea 57             	sub    $0x57,%edx
  800c27:	eb d3                	jmp    800bfc <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c29:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c2c:	89 f3                	mov    %esi,%ebx
  800c2e:	80 fb 19             	cmp    $0x19,%bl
  800c31:	77 08                	ja     800c3b <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c33:	0f be d2             	movsbl %dl,%edx
  800c36:	83 ea 37             	sub    $0x37,%edx
  800c39:	eb c1                	jmp    800bfc <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c3b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3f:	74 05                	je     800c46 <strtol+0xd0>
		*endptr = (char *) s;
  800c41:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c44:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c46:	89 c2                	mov    %eax,%edx
  800c48:	f7 da                	neg    %edx
  800c4a:	85 ff                	test   %edi,%edi
  800c4c:	0f 45 c2             	cmovne %edx,%eax
}
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c54:	f3 0f 1e fb          	endbr32 
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	57                   	push   %edi
  800c5c:	56                   	push   %esi
  800c5d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c63:	8b 55 08             	mov    0x8(%ebp),%edx
  800c66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c69:	89 c3                	mov    %eax,%ebx
  800c6b:	89 c7                	mov    %eax,%edi
  800c6d:	89 c6                	mov    %eax,%esi
  800c6f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c71:	5b                   	pop    %ebx
  800c72:	5e                   	pop    %esi
  800c73:	5f                   	pop    %edi
  800c74:	5d                   	pop    %ebp
  800c75:	c3                   	ret    

00800c76 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c76:	f3 0f 1e fb          	endbr32 
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	57                   	push   %edi
  800c7e:	56                   	push   %esi
  800c7f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c80:	ba 00 00 00 00       	mov    $0x0,%edx
  800c85:	b8 01 00 00 00       	mov    $0x1,%eax
  800c8a:	89 d1                	mov    %edx,%ecx
  800c8c:	89 d3                	mov    %edx,%ebx
  800c8e:	89 d7                	mov    %edx,%edi
  800c90:	89 d6                	mov    %edx,%esi
  800c92:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c99:	f3 0f 1e fb          	endbr32 
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	57                   	push   %edi
  800ca1:	56                   	push   %esi
  800ca2:	53                   	push   %ebx
  800ca3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cab:	8b 55 08             	mov    0x8(%ebp),%edx
  800cae:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb3:	89 cb                	mov    %ecx,%ebx
  800cb5:	89 cf                	mov    %ecx,%edi
  800cb7:	89 ce                	mov    %ecx,%esi
  800cb9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cbb:	85 c0                	test   %eax,%eax
  800cbd:	7f 08                	jg     800cc7 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc2:	5b                   	pop    %ebx
  800cc3:	5e                   	pop    %esi
  800cc4:	5f                   	pop    %edi
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc7:	83 ec 0c             	sub    $0xc,%esp
  800cca:	50                   	push   %eax
  800ccb:	6a 03                	push   $0x3
  800ccd:	68 df 24 80 00       	push   $0x8024df
  800cd2:	6a 23                	push   $0x23
  800cd4:	68 fc 24 80 00       	push   $0x8024fc
  800cd9:	e8 13 f5 ff ff       	call   8001f1 <_panic>

00800cde <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cde:	f3 0f 1e fb          	endbr32 
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	57                   	push   %edi
  800ce6:	56                   	push   %esi
  800ce7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ced:	b8 02 00 00 00       	mov    $0x2,%eax
  800cf2:	89 d1                	mov    %edx,%ecx
  800cf4:	89 d3                	mov    %edx,%ebx
  800cf6:	89 d7                	mov    %edx,%edi
  800cf8:	89 d6                	mov    %edx,%esi
  800cfa:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cfc:	5b                   	pop    %ebx
  800cfd:	5e                   	pop    %esi
  800cfe:	5f                   	pop    %edi
  800cff:	5d                   	pop    %ebp
  800d00:	c3                   	ret    

00800d01 <sys_yield>:

void
sys_yield(void)
{
  800d01:	f3 0f 1e fb          	endbr32 
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	57                   	push   %edi
  800d09:	56                   	push   %esi
  800d0a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d10:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d15:	89 d1                	mov    %edx,%ecx
  800d17:	89 d3                	mov    %edx,%ebx
  800d19:	89 d7                	mov    %edx,%edi
  800d1b:	89 d6                	mov    %edx,%esi
  800d1d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d1f:	5b                   	pop    %ebx
  800d20:	5e                   	pop    %esi
  800d21:	5f                   	pop    %edi
  800d22:	5d                   	pop    %ebp
  800d23:	c3                   	ret    

00800d24 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d24:	f3 0f 1e fb          	endbr32 
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	57                   	push   %edi
  800d2c:	56                   	push   %esi
  800d2d:	53                   	push   %ebx
  800d2e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d31:	be 00 00 00 00       	mov    $0x0,%esi
  800d36:	8b 55 08             	mov    0x8(%ebp),%edx
  800d39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3c:	b8 04 00 00 00       	mov    $0x4,%eax
  800d41:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d44:	89 f7                	mov    %esi,%edi
  800d46:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d48:	85 c0                	test   %eax,%eax
  800d4a:	7f 08                	jg     800d54 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4f:	5b                   	pop    %ebx
  800d50:	5e                   	pop    %esi
  800d51:	5f                   	pop    %edi
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d54:	83 ec 0c             	sub    $0xc,%esp
  800d57:	50                   	push   %eax
  800d58:	6a 04                	push   $0x4
  800d5a:	68 df 24 80 00       	push   $0x8024df
  800d5f:	6a 23                	push   $0x23
  800d61:	68 fc 24 80 00       	push   $0x8024fc
  800d66:	e8 86 f4 ff ff       	call   8001f1 <_panic>

00800d6b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d6b:	f3 0f 1e fb          	endbr32 
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	57                   	push   %edi
  800d73:	56                   	push   %esi
  800d74:	53                   	push   %ebx
  800d75:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d78:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7e:	b8 05 00 00 00       	mov    $0x5,%eax
  800d83:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d86:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d89:	8b 75 18             	mov    0x18(%ebp),%esi
  800d8c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8e:	85 c0                	test   %eax,%eax
  800d90:	7f 08                	jg     800d9a <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d95:	5b                   	pop    %ebx
  800d96:	5e                   	pop    %esi
  800d97:	5f                   	pop    %edi
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9a:	83 ec 0c             	sub    $0xc,%esp
  800d9d:	50                   	push   %eax
  800d9e:	6a 05                	push   $0x5
  800da0:	68 df 24 80 00       	push   $0x8024df
  800da5:	6a 23                	push   $0x23
  800da7:	68 fc 24 80 00       	push   $0x8024fc
  800dac:	e8 40 f4 ff ff       	call   8001f1 <_panic>

00800db1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800db1:	f3 0f 1e fb          	endbr32 
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	57                   	push   %edi
  800db9:	56                   	push   %esi
  800dba:	53                   	push   %ebx
  800dbb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc9:	b8 06 00 00 00       	mov    $0x6,%eax
  800dce:	89 df                	mov    %ebx,%edi
  800dd0:	89 de                	mov    %ebx,%esi
  800dd2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd4:	85 c0                	test   %eax,%eax
  800dd6:	7f 08                	jg     800de0 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddb:	5b                   	pop    %ebx
  800ddc:	5e                   	pop    %esi
  800ddd:	5f                   	pop    %edi
  800dde:	5d                   	pop    %ebp
  800ddf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de0:	83 ec 0c             	sub    $0xc,%esp
  800de3:	50                   	push   %eax
  800de4:	6a 06                	push   $0x6
  800de6:	68 df 24 80 00       	push   $0x8024df
  800deb:	6a 23                	push   $0x23
  800ded:	68 fc 24 80 00       	push   $0x8024fc
  800df2:	e8 fa f3 ff ff       	call   8001f1 <_panic>

00800df7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800df7:	f3 0f 1e fb          	endbr32 
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	57                   	push   %edi
  800dff:	56                   	push   %esi
  800e00:	53                   	push   %ebx
  800e01:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e04:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e09:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0f:	b8 08 00 00 00       	mov    $0x8,%eax
  800e14:	89 df                	mov    %ebx,%edi
  800e16:	89 de                	mov    %ebx,%esi
  800e18:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1a:	85 c0                	test   %eax,%eax
  800e1c:	7f 08                	jg     800e26 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e21:	5b                   	pop    %ebx
  800e22:	5e                   	pop    %esi
  800e23:	5f                   	pop    %edi
  800e24:	5d                   	pop    %ebp
  800e25:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e26:	83 ec 0c             	sub    $0xc,%esp
  800e29:	50                   	push   %eax
  800e2a:	6a 08                	push   $0x8
  800e2c:	68 df 24 80 00       	push   $0x8024df
  800e31:	6a 23                	push   $0x23
  800e33:	68 fc 24 80 00       	push   $0x8024fc
  800e38:	e8 b4 f3 ff ff       	call   8001f1 <_panic>

00800e3d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e3d:	f3 0f 1e fb          	endbr32 
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	57                   	push   %edi
  800e45:	56                   	push   %esi
  800e46:	53                   	push   %ebx
  800e47:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e55:	b8 09 00 00 00       	mov    $0x9,%eax
  800e5a:	89 df                	mov    %ebx,%edi
  800e5c:	89 de                	mov    %ebx,%esi
  800e5e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e60:	85 c0                	test   %eax,%eax
  800e62:	7f 08                	jg     800e6c <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e67:	5b                   	pop    %ebx
  800e68:	5e                   	pop    %esi
  800e69:	5f                   	pop    %edi
  800e6a:	5d                   	pop    %ebp
  800e6b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6c:	83 ec 0c             	sub    $0xc,%esp
  800e6f:	50                   	push   %eax
  800e70:	6a 09                	push   $0x9
  800e72:	68 df 24 80 00       	push   $0x8024df
  800e77:	6a 23                	push   $0x23
  800e79:	68 fc 24 80 00       	push   $0x8024fc
  800e7e:	e8 6e f3 ff ff       	call   8001f1 <_panic>

00800e83 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e83:	f3 0f 1e fb          	endbr32 
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	57                   	push   %edi
  800e8b:	56                   	push   %esi
  800e8c:	53                   	push   %ebx
  800e8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e95:	8b 55 08             	mov    0x8(%ebp),%edx
  800e98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ea0:	89 df                	mov    %ebx,%edi
  800ea2:	89 de                	mov    %ebx,%esi
  800ea4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea6:	85 c0                	test   %eax,%eax
  800ea8:	7f 08                	jg     800eb2 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ead:	5b                   	pop    %ebx
  800eae:	5e                   	pop    %esi
  800eaf:	5f                   	pop    %edi
  800eb0:	5d                   	pop    %ebp
  800eb1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb2:	83 ec 0c             	sub    $0xc,%esp
  800eb5:	50                   	push   %eax
  800eb6:	6a 0a                	push   $0xa
  800eb8:	68 df 24 80 00       	push   $0x8024df
  800ebd:	6a 23                	push   $0x23
  800ebf:	68 fc 24 80 00       	push   $0x8024fc
  800ec4:	e8 28 f3 ff ff       	call   8001f1 <_panic>

00800ec9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ec9:	f3 0f 1e fb          	endbr32 
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	57                   	push   %edi
  800ed1:	56                   	push   %esi
  800ed2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed9:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ede:	be 00 00 00 00       	mov    $0x0,%esi
  800ee3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ee9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eeb:	5b                   	pop    %ebx
  800eec:	5e                   	pop    %esi
  800eed:	5f                   	pop    %edi
  800eee:	5d                   	pop    %ebp
  800eef:	c3                   	ret    

00800ef0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ef0:	f3 0f 1e fb          	endbr32 
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	57                   	push   %edi
  800ef8:	56                   	push   %esi
  800ef9:	53                   	push   %ebx
  800efa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f02:	8b 55 08             	mov    0x8(%ebp),%edx
  800f05:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f0a:	89 cb                	mov    %ecx,%ebx
  800f0c:	89 cf                	mov    %ecx,%edi
  800f0e:	89 ce                	mov    %ecx,%esi
  800f10:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f12:	85 c0                	test   %eax,%eax
  800f14:	7f 08                	jg     800f1e <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f19:	5b                   	pop    %ebx
  800f1a:	5e                   	pop    %esi
  800f1b:	5f                   	pop    %edi
  800f1c:	5d                   	pop    %ebp
  800f1d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1e:	83 ec 0c             	sub    $0xc,%esp
  800f21:	50                   	push   %eax
  800f22:	6a 0d                	push   $0xd
  800f24:	68 df 24 80 00       	push   $0x8024df
  800f29:	6a 23                	push   $0x23
  800f2b:	68 fc 24 80 00       	push   $0x8024fc
  800f30:	e8 bc f2 ff ff       	call   8001f1 <_panic>

00800f35 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f35:	f3 0f 1e fb          	endbr32 
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	05 00 00 00 30       	add    $0x30000000,%eax
  800f44:	c1 e8 0c             	shr    $0xc,%eax
}
  800f47:	5d                   	pop    %ebp
  800f48:	c3                   	ret    

00800f49 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f49:	f3 0f 1e fb          	endbr32 
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f58:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f5d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f62:	5d                   	pop    %ebp
  800f63:	c3                   	ret    

00800f64 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f64:	f3 0f 1e fb          	endbr32 
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f70:	89 c2                	mov    %eax,%edx
  800f72:	c1 ea 16             	shr    $0x16,%edx
  800f75:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f7c:	f6 c2 01             	test   $0x1,%dl
  800f7f:	74 2d                	je     800fae <fd_alloc+0x4a>
  800f81:	89 c2                	mov    %eax,%edx
  800f83:	c1 ea 0c             	shr    $0xc,%edx
  800f86:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f8d:	f6 c2 01             	test   $0x1,%dl
  800f90:	74 1c                	je     800fae <fd_alloc+0x4a>
  800f92:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f97:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f9c:	75 d2                	jne    800f70 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800fa7:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800fac:	eb 0a                	jmp    800fb8 <fd_alloc+0x54>
			*fd_store = fd;
  800fae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fb1:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fb8:	5d                   	pop    %ebp
  800fb9:	c3                   	ret    

00800fba <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fba:	f3 0f 1e fb          	endbr32 
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fc4:	83 f8 1f             	cmp    $0x1f,%eax
  800fc7:	77 30                	ja     800ff9 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fc9:	c1 e0 0c             	shl    $0xc,%eax
  800fcc:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fd1:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800fd7:	f6 c2 01             	test   $0x1,%dl
  800fda:	74 24                	je     801000 <fd_lookup+0x46>
  800fdc:	89 c2                	mov    %eax,%edx
  800fde:	c1 ea 0c             	shr    $0xc,%edx
  800fe1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fe8:	f6 c2 01             	test   $0x1,%dl
  800feb:	74 1a                	je     801007 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fed:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ff0:	89 02                	mov    %eax,(%edx)
	return 0;
  800ff2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff7:	5d                   	pop    %ebp
  800ff8:	c3                   	ret    
		return -E_INVAL;
  800ff9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ffe:	eb f7                	jmp    800ff7 <fd_lookup+0x3d>
		return -E_INVAL;
  801000:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801005:	eb f0                	jmp    800ff7 <fd_lookup+0x3d>
  801007:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80100c:	eb e9                	jmp    800ff7 <fd_lookup+0x3d>

0080100e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80100e:	f3 0f 1e fb          	endbr32 
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	83 ec 08             	sub    $0x8,%esp
  801018:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80101b:	ba 88 25 80 00       	mov    $0x802588,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801020:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801025:	39 08                	cmp    %ecx,(%eax)
  801027:	74 33                	je     80105c <dev_lookup+0x4e>
  801029:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80102c:	8b 02                	mov    (%edx),%eax
  80102e:	85 c0                	test   %eax,%eax
  801030:	75 f3                	jne    801025 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801032:	a1 08 40 80 00       	mov    0x804008,%eax
  801037:	8b 40 48             	mov    0x48(%eax),%eax
  80103a:	83 ec 04             	sub    $0x4,%esp
  80103d:	51                   	push   %ecx
  80103e:	50                   	push   %eax
  80103f:	68 0c 25 80 00       	push   $0x80250c
  801044:	e8 8f f2 ff ff       	call   8002d8 <cprintf>
	*dev = 0;
  801049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801052:	83 c4 10             	add    $0x10,%esp
  801055:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80105a:	c9                   	leave  
  80105b:	c3                   	ret    
			*dev = devtab[i];
  80105c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801061:	b8 00 00 00 00       	mov    $0x0,%eax
  801066:	eb f2                	jmp    80105a <dev_lookup+0x4c>

00801068 <fd_close>:
{
  801068:	f3 0f 1e fb          	endbr32 
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	57                   	push   %edi
  801070:	56                   	push   %esi
  801071:	53                   	push   %ebx
  801072:	83 ec 24             	sub    $0x24,%esp
  801075:	8b 75 08             	mov    0x8(%ebp),%esi
  801078:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80107b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80107e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80107f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801085:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801088:	50                   	push   %eax
  801089:	e8 2c ff ff ff       	call   800fba <fd_lookup>
  80108e:	89 c3                	mov    %eax,%ebx
  801090:	83 c4 10             	add    $0x10,%esp
  801093:	85 c0                	test   %eax,%eax
  801095:	78 05                	js     80109c <fd_close+0x34>
	    || fd != fd2)
  801097:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80109a:	74 16                	je     8010b2 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80109c:	89 f8                	mov    %edi,%eax
  80109e:	84 c0                	test   %al,%al
  8010a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a5:	0f 44 d8             	cmove  %eax,%ebx
}
  8010a8:	89 d8                	mov    %ebx,%eax
  8010aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ad:	5b                   	pop    %ebx
  8010ae:	5e                   	pop    %esi
  8010af:	5f                   	pop    %edi
  8010b0:	5d                   	pop    %ebp
  8010b1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010b2:	83 ec 08             	sub    $0x8,%esp
  8010b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010b8:	50                   	push   %eax
  8010b9:	ff 36                	pushl  (%esi)
  8010bb:	e8 4e ff ff ff       	call   80100e <dev_lookup>
  8010c0:	89 c3                	mov    %eax,%ebx
  8010c2:	83 c4 10             	add    $0x10,%esp
  8010c5:	85 c0                	test   %eax,%eax
  8010c7:	78 1a                	js     8010e3 <fd_close+0x7b>
		if (dev->dev_close)
  8010c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010cc:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8010cf:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8010d4:	85 c0                	test   %eax,%eax
  8010d6:	74 0b                	je     8010e3 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8010d8:	83 ec 0c             	sub    $0xc,%esp
  8010db:	56                   	push   %esi
  8010dc:	ff d0                	call   *%eax
  8010de:	89 c3                	mov    %eax,%ebx
  8010e0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010e3:	83 ec 08             	sub    $0x8,%esp
  8010e6:	56                   	push   %esi
  8010e7:	6a 00                	push   $0x0
  8010e9:	e8 c3 fc ff ff       	call   800db1 <sys_page_unmap>
	return r;
  8010ee:	83 c4 10             	add    $0x10,%esp
  8010f1:	eb b5                	jmp    8010a8 <fd_close+0x40>

008010f3 <close>:

int
close(int fdnum)
{
  8010f3:	f3 0f 1e fb          	endbr32 
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
  8010fa:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801100:	50                   	push   %eax
  801101:	ff 75 08             	pushl  0x8(%ebp)
  801104:	e8 b1 fe ff ff       	call   800fba <fd_lookup>
  801109:	83 c4 10             	add    $0x10,%esp
  80110c:	85 c0                	test   %eax,%eax
  80110e:	79 02                	jns    801112 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801110:	c9                   	leave  
  801111:	c3                   	ret    
		return fd_close(fd, 1);
  801112:	83 ec 08             	sub    $0x8,%esp
  801115:	6a 01                	push   $0x1
  801117:	ff 75 f4             	pushl  -0xc(%ebp)
  80111a:	e8 49 ff ff ff       	call   801068 <fd_close>
  80111f:	83 c4 10             	add    $0x10,%esp
  801122:	eb ec                	jmp    801110 <close+0x1d>

00801124 <close_all>:

void
close_all(void)
{
  801124:	f3 0f 1e fb          	endbr32 
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	53                   	push   %ebx
  80112c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80112f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801134:	83 ec 0c             	sub    $0xc,%esp
  801137:	53                   	push   %ebx
  801138:	e8 b6 ff ff ff       	call   8010f3 <close>
	for (i = 0; i < MAXFD; i++)
  80113d:	83 c3 01             	add    $0x1,%ebx
  801140:	83 c4 10             	add    $0x10,%esp
  801143:	83 fb 20             	cmp    $0x20,%ebx
  801146:	75 ec                	jne    801134 <close_all+0x10>
}
  801148:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80114d:	f3 0f 1e fb          	endbr32 
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	57                   	push   %edi
  801155:	56                   	push   %esi
  801156:	53                   	push   %ebx
  801157:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80115a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80115d:	50                   	push   %eax
  80115e:	ff 75 08             	pushl  0x8(%ebp)
  801161:	e8 54 fe ff ff       	call   800fba <fd_lookup>
  801166:	89 c3                	mov    %eax,%ebx
  801168:	83 c4 10             	add    $0x10,%esp
  80116b:	85 c0                	test   %eax,%eax
  80116d:	0f 88 81 00 00 00    	js     8011f4 <dup+0xa7>
		return r;
	close(newfdnum);
  801173:	83 ec 0c             	sub    $0xc,%esp
  801176:	ff 75 0c             	pushl  0xc(%ebp)
  801179:	e8 75 ff ff ff       	call   8010f3 <close>

	newfd = INDEX2FD(newfdnum);
  80117e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801181:	c1 e6 0c             	shl    $0xc,%esi
  801184:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80118a:	83 c4 04             	add    $0x4,%esp
  80118d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801190:	e8 b4 fd ff ff       	call   800f49 <fd2data>
  801195:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801197:	89 34 24             	mov    %esi,(%esp)
  80119a:	e8 aa fd ff ff       	call   800f49 <fd2data>
  80119f:	83 c4 10             	add    $0x10,%esp
  8011a2:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011a4:	89 d8                	mov    %ebx,%eax
  8011a6:	c1 e8 16             	shr    $0x16,%eax
  8011a9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011b0:	a8 01                	test   $0x1,%al
  8011b2:	74 11                	je     8011c5 <dup+0x78>
  8011b4:	89 d8                	mov    %ebx,%eax
  8011b6:	c1 e8 0c             	shr    $0xc,%eax
  8011b9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011c0:	f6 c2 01             	test   $0x1,%dl
  8011c3:	75 39                	jne    8011fe <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011c8:	89 d0                	mov    %edx,%eax
  8011ca:	c1 e8 0c             	shr    $0xc,%eax
  8011cd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011d4:	83 ec 0c             	sub    $0xc,%esp
  8011d7:	25 07 0e 00 00       	and    $0xe07,%eax
  8011dc:	50                   	push   %eax
  8011dd:	56                   	push   %esi
  8011de:	6a 00                	push   $0x0
  8011e0:	52                   	push   %edx
  8011e1:	6a 00                	push   $0x0
  8011e3:	e8 83 fb ff ff       	call   800d6b <sys_page_map>
  8011e8:	89 c3                	mov    %eax,%ebx
  8011ea:	83 c4 20             	add    $0x20,%esp
  8011ed:	85 c0                	test   %eax,%eax
  8011ef:	78 31                	js     801222 <dup+0xd5>
		goto err;

	return newfdnum;
  8011f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011f4:	89 d8                	mov    %ebx,%eax
  8011f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f9:	5b                   	pop    %ebx
  8011fa:	5e                   	pop    %esi
  8011fb:	5f                   	pop    %edi
  8011fc:	5d                   	pop    %ebp
  8011fd:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011fe:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801205:	83 ec 0c             	sub    $0xc,%esp
  801208:	25 07 0e 00 00       	and    $0xe07,%eax
  80120d:	50                   	push   %eax
  80120e:	57                   	push   %edi
  80120f:	6a 00                	push   $0x0
  801211:	53                   	push   %ebx
  801212:	6a 00                	push   $0x0
  801214:	e8 52 fb ff ff       	call   800d6b <sys_page_map>
  801219:	89 c3                	mov    %eax,%ebx
  80121b:	83 c4 20             	add    $0x20,%esp
  80121e:	85 c0                	test   %eax,%eax
  801220:	79 a3                	jns    8011c5 <dup+0x78>
	sys_page_unmap(0, newfd);
  801222:	83 ec 08             	sub    $0x8,%esp
  801225:	56                   	push   %esi
  801226:	6a 00                	push   $0x0
  801228:	e8 84 fb ff ff       	call   800db1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80122d:	83 c4 08             	add    $0x8,%esp
  801230:	57                   	push   %edi
  801231:	6a 00                	push   $0x0
  801233:	e8 79 fb ff ff       	call   800db1 <sys_page_unmap>
	return r;
  801238:	83 c4 10             	add    $0x10,%esp
  80123b:	eb b7                	jmp    8011f4 <dup+0xa7>

0080123d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80123d:	f3 0f 1e fb          	endbr32 
  801241:	55                   	push   %ebp
  801242:	89 e5                	mov    %esp,%ebp
  801244:	53                   	push   %ebx
  801245:	83 ec 1c             	sub    $0x1c,%esp
  801248:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80124b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80124e:	50                   	push   %eax
  80124f:	53                   	push   %ebx
  801250:	e8 65 fd ff ff       	call   800fba <fd_lookup>
  801255:	83 c4 10             	add    $0x10,%esp
  801258:	85 c0                	test   %eax,%eax
  80125a:	78 3f                	js     80129b <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80125c:	83 ec 08             	sub    $0x8,%esp
  80125f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801262:	50                   	push   %eax
  801263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801266:	ff 30                	pushl  (%eax)
  801268:	e8 a1 fd ff ff       	call   80100e <dev_lookup>
  80126d:	83 c4 10             	add    $0x10,%esp
  801270:	85 c0                	test   %eax,%eax
  801272:	78 27                	js     80129b <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801274:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801277:	8b 42 08             	mov    0x8(%edx),%eax
  80127a:	83 e0 03             	and    $0x3,%eax
  80127d:	83 f8 01             	cmp    $0x1,%eax
  801280:	74 1e                	je     8012a0 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801285:	8b 40 08             	mov    0x8(%eax),%eax
  801288:	85 c0                	test   %eax,%eax
  80128a:	74 35                	je     8012c1 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80128c:	83 ec 04             	sub    $0x4,%esp
  80128f:	ff 75 10             	pushl  0x10(%ebp)
  801292:	ff 75 0c             	pushl  0xc(%ebp)
  801295:	52                   	push   %edx
  801296:	ff d0                	call   *%eax
  801298:	83 c4 10             	add    $0x10,%esp
}
  80129b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80129e:	c9                   	leave  
  80129f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012a0:	a1 08 40 80 00       	mov    0x804008,%eax
  8012a5:	8b 40 48             	mov    0x48(%eax),%eax
  8012a8:	83 ec 04             	sub    $0x4,%esp
  8012ab:	53                   	push   %ebx
  8012ac:	50                   	push   %eax
  8012ad:	68 4d 25 80 00       	push   $0x80254d
  8012b2:	e8 21 f0 ff ff       	call   8002d8 <cprintf>
		return -E_INVAL;
  8012b7:	83 c4 10             	add    $0x10,%esp
  8012ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012bf:	eb da                	jmp    80129b <read+0x5e>
		return -E_NOT_SUPP;
  8012c1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012c6:	eb d3                	jmp    80129b <read+0x5e>

008012c8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012c8:	f3 0f 1e fb          	endbr32 
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	57                   	push   %edi
  8012d0:	56                   	push   %esi
  8012d1:	53                   	push   %ebx
  8012d2:	83 ec 0c             	sub    $0xc,%esp
  8012d5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012d8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e0:	eb 02                	jmp    8012e4 <readn+0x1c>
  8012e2:	01 c3                	add    %eax,%ebx
  8012e4:	39 f3                	cmp    %esi,%ebx
  8012e6:	73 21                	jae    801309 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012e8:	83 ec 04             	sub    $0x4,%esp
  8012eb:	89 f0                	mov    %esi,%eax
  8012ed:	29 d8                	sub    %ebx,%eax
  8012ef:	50                   	push   %eax
  8012f0:	89 d8                	mov    %ebx,%eax
  8012f2:	03 45 0c             	add    0xc(%ebp),%eax
  8012f5:	50                   	push   %eax
  8012f6:	57                   	push   %edi
  8012f7:	e8 41 ff ff ff       	call   80123d <read>
		if (m < 0)
  8012fc:	83 c4 10             	add    $0x10,%esp
  8012ff:	85 c0                	test   %eax,%eax
  801301:	78 04                	js     801307 <readn+0x3f>
			return m;
		if (m == 0)
  801303:	75 dd                	jne    8012e2 <readn+0x1a>
  801305:	eb 02                	jmp    801309 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801307:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801309:	89 d8                	mov    %ebx,%eax
  80130b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80130e:	5b                   	pop    %ebx
  80130f:	5e                   	pop    %esi
  801310:	5f                   	pop    %edi
  801311:	5d                   	pop    %ebp
  801312:	c3                   	ret    

00801313 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801313:	f3 0f 1e fb          	endbr32 
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	53                   	push   %ebx
  80131b:	83 ec 1c             	sub    $0x1c,%esp
  80131e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801321:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801324:	50                   	push   %eax
  801325:	53                   	push   %ebx
  801326:	e8 8f fc ff ff       	call   800fba <fd_lookup>
  80132b:	83 c4 10             	add    $0x10,%esp
  80132e:	85 c0                	test   %eax,%eax
  801330:	78 3a                	js     80136c <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801332:	83 ec 08             	sub    $0x8,%esp
  801335:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801338:	50                   	push   %eax
  801339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133c:	ff 30                	pushl  (%eax)
  80133e:	e8 cb fc ff ff       	call   80100e <dev_lookup>
  801343:	83 c4 10             	add    $0x10,%esp
  801346:	85 c0                	test   %eax,%eax
  801348:	78 22                	js     80136c <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80134a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80134d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801351:	74 1e                	je     801371 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801353:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801356:	8b 52 0c             	mov    0xc(%edx),%edx
  801359:	85 d2                	test   %edx,%edx
  80135b:	74 35                	je     801392 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80135d:	83 ec 04             	sub    $0x4,%esp
  801360:	ff 75 10             	pushl  0x10(%ebp)
  801363:	ff 75 0c             	pushl  0xc(%ebp)
  801366:	50                   	push   %eax
  801367:	ff d2                	call   *%edx
  801369:	83 c4 10             	add    $0x10,%esp
}
  80136c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80136f:	c9                   	leave  
  801370:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801371:	a1 08 40 80 00       	mov    0x804008,%eax
  801376:	8b 40 48             	mov    0x48(%eax),%eax
  801379:	83 ec 04             	sub    $0x4,%esp
  80137c:	53                   	push   %ebx
  80137d:	50                   	push   %eax
  80137e:	68 69 25 80 00       	push   $0x802569
  801383:	e8 50 ef ff ff       	call   8002d8 <cprintf>
		return -E_INVAL;
  801388:	83 c4 10             	add    $0x10,%esp
  80138b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801390:	eb da                	jmp    80136c <write+0x59>
		return -E_NOT_SUPP;
  801392:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801397:	eb d3                	jmp    80136c <write+0x59>

00801399 <seek>:

int
seek(int fdnum, off_t offset)
{
  801399:	f3 0f 1e fb          	endbr32 
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a6:	50                   	push   %eax
  8013a7:	ff 75 08             	pushl  0x8(%ebp)
  8013aa:	e8 0b fc ff ff       	call   800fba <fd_lookup>
  8013af:	83 c4 10             	add    $0x10,%esp
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	78 0e                	js     8013c4 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8013b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013bc:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013c6:	f3 0f 1e fb          	endbr32 
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
  8013cd:	53                   	push   %ebx
  8013ce:	83 ec 1c             	sub    $0x1c,%esp
  8013d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d7:	50                   	push   %eax
  8013d8:	53                   	push   %ebx
  8013d9:	e8 dc fb ff ff       	call   800fba <fd_lookup>
  8013de:	83 c4 10             	add    $0x10,%esp
  8013e1:	85 c0                	test   %eax,%eax
  8013e3:	78 37                	js     80141c <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e5:	83 ec 08             	sub    $0x8,%esp
  8013e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013eb:	50                   	push   %eax
  8013ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ef:	ff 30                	pushl  (%eax)
  8013f1:	e8 18 fc ff ff       	call   80100e <dev_lookup>
  8013f6:	83 c4 10             	add    $0x10,%esp
  8013f9:	85 c0                	test   %eax,%eax
  8013fb:	78 1f                	js     80141c <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801400:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801404:	74 1b                	je     801421 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801406:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801409:	8b 52 18             	mov    0x18(%edx),%edx
  80140c:	85 d2                	test   %edx,%edx
  80140e:	74 32                	je     801442 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801410:	83 ec 08             	sub    $0x8,%esp
  801413:	ff 75 0c             	pushl  0xc(%ebp)
  801416:	50                   	push   %eax
  801417:	ff d2                	call   *%edx
  801419:	83 c4 10             	add    $0x10,%esp
}
  80141c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80141f:	c9                   	leave  
  801420:	c3                   	ret    
			thisenv->env_id, fdnum);
  801421:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801426:	8b 40 48             	mov    0x48(%eax),%eax
  801429:	83 ec 04             	sub    $0x4,%esp
  80142c:	53                   	push   %ebx
  80142d:	50                   	push   %eax
  80142e:	68 2c 25 80 00       	push   $0x80252c
  801433:	e8 a0 ee ff ff       	call   8002d8 <cprintf>
		return -E_INVAL;
  801438:	83 c4 10             	add    $0x10,%esp
  80143b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801440:	eb da                	jmp    80141c <ftruncate+0x56>
		return -E_NOT_SUPP;
  801442:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801447:	eb d3                	jmp    80141c <ftruncate+0x56>

00801449 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801449:	f3 0f 1e fb          	endbr32 
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
  801450:	53                   	push   %ebx
  801451:	83 ec 1c             	sub    $0x1c,%esp
  801454:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801457:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80145a:	50                   	push   %eax
  80145b:	ff 75 08             	pushl  0x8(%ebp)
  80145e:	e8 57 fb ff ff       	call   800fba <fd_lookup>
  801463:	83 c4 10             	add    $0x10,%esp
  801466:	85 c0                	test   %eax,%eax
  801468:	78 4b                	js     8014b5 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80146a:	83 ec 08             	sub    $0x8,%esp
  80146d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801470:	50                   	push   %eax
  801471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801474:	ff 30                	pushl  (%eax)
  801476:	e8 93 fb ff ff       	call   80100e <dev_lookup>
  80147b:	83 c4 10             	add    $0x10,%esp
  80147e:	85 c0                	test   %eax,%eax
  801480:	78 33                	js     8014b5 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801485:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801489:	74 2f                	je     8014ba <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80148b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80148e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801495:	00 00 00 
	stat->st_isdir = 0;
  801498:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80149f:	00 00 00 
	stat->st_dev = dev;
  8014a2:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014a8:	83 ec 08             	sub    $0x8,%esp
  8014ab:	53                   	push   %ebx
  8014ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8014af:	ff 50 14             	call   *0x14(%eax)
  8014b2:	83 c4 10             	add    $0x10,%esp
}
  8014b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    
		return -E_NOT_SUPP;
  8014ba:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014bf:	eb f4                	jmp    8014b5 <fstat+0x6c>

008014c1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014c1:	f3 0f 1e fb          	endbr32 
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	56                   	push   %esi
  8014c9:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014ca:	83 ec 08             	sub    $0x8,%esp
  8014cd:	6a 00                	push   $0x0
  8014cf:	ff 75 08             	pushl  0x8(%ebp)
  8014d2:	e8 fb 01 00 00       	call   8016d2 <open>
  8014d7:	89 c3                	mov    %eax,%ebx
  8014d9:	83 c4 10             	add    $0x10,%esp
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	78 1b                	js     8014fb <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8014e0:	83 ec 08             	sub    $0x8,%esp
  8014e3:	ff 75 0c             	pushl  0xc(%ebp)
  8014e6:	50                   	push   %eax
  8014e7:	e8 5d ff ff ff       	call   801449 <fstat>
  8014ec:	89 c6                	mov    %eax,%esi
	close(fd);
  8014ee:	89 1c 24             	mov    %ebx,(%esp)
  8014f1:	e8 fd fb ff ff       	call   8010f3 <close>
	return r;
  8014f6:	83 c4 10             	add    $0x10,%esp
  8014f9:	89 f3                	mov    %esi,%ebx
}
  8014fb:	89 d8                	mov    %ebx,%eax
  8014fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801500:	5b                   	pop    %ebx
  801501:	5e                   	pop    %esi
  801502:	5d                   	pop    %ebp
  801503:	c3                   	ret    

00801504 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	56                   	push   %esi
  801508:	53                   	push   %ebx
  801509:	89 c6                	mov    %eax,%esi
  80150b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80150d:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801514:	74 27                	je     80153d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801516:	6a 07                	push   $0x7
  801518:	68 00 50 80 00       	push   $0x805000
  80151d:	56                   	push   %esi
  80151e:	ff 35 04 40 80 00    	pushl  0x804004
  801524:	e8 fa 08 00 00       	call   801e23 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801529:	83 c4 0c             	add    $0xc,%esp
  80152c:	6a 00                	push   $0x0
  80152e:	53                   	push   %ebx
  80152f:	6a 00                	push   $0x0
  801531:	e8 68 08 00 00       	call   801d9e <ipc_recv>
}
  801536:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801539:	5b                   	pop    %ebx
  80153a:	5e                   	pop    %esi
  80153b:	5d                   	pop    %ebp
  80153c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80153d:	83 ec 0c             	sub    $0xc,%esp
  801540:	6a 01                	push   $0x1
  801542:	e8 34 09 00 00       	call   801e7b <ipc_find_env>
  801547:	a3 04 40 80 00       	mov    %eax,0x804004
  80154c:	83 c4 10             	add    $0x10,%esp
  80154f:	eb c5                	jmp    801516 <fsipc+0x12>

00801551 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801551:	f3 0f 1e fb          	endbr32 
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
  801558:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	8b 40 0c             	mov    0xc(%eax),%eax
  801561:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801566:	8b 45 0c             	mov    0xc(%ebp),%eax
  801569:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80156e:	ba 00 00 00 00       	mov    $0x0,%edx
  801573:	b8 02 00 00 00       	mov    $0x2,%eax
  801578:	e8 87 ff ff ff       	call   801504 <fsipc>
}
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <devfile_flush>:
{
  80157f:	f3 0f 1e fb          	endbr32 
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	8b 40 0c             	mov    0xc(%eax),%eax
  80158f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801594:	ba 00 00 00 00       	mov    $0x0,%edx
  801599:	b8 06 00 00 00       	mov    $0x6,%eax
  80159e:	e8 61 ff ff ff       	call   801504 <fsipc>
}
  8015a3:	c9                   	leave  
  8015a4:	c3                   	ret    

008015a5 <devfile_stat>:
{
  8015a5:	f3 0f 1e fb          	endbr32 
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	53                   	push   %ebx
  8015ad:	83 ec 04             	sub    $0x4,%esp
  8015b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8015b9:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015be:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c3:	b8 05 00 00 00       	mov    $0x5,%eax
  8015c8:	e8 37 ff ff ff       	call   801504 <fsipc>
  8015cd:	85 c0                	test   %eax,%eax
  8015cf:	78 2c                	js     8015fd <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015d1:	83 ec 08             	sub    $0x8,%esp
  8015d4:	68 00 50 80 00       	push   $0x805000
  8015d9:	53                   	push   %ebx
  8015da:	e8 03 f3 ff ff       	call   8008e2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015df:	a1 80 50 80 00       	mov    0x805080,%eax
  8015e4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015ea:	a1 84 50 80 00       	mov    0x805084,%eax
  8015ef:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015f5:	83 c4 10             	add    $0x10,%esp
  8015f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <devfile_write>:
{
  801602:	f3 0f 1e fb          	endbr32 
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	83 ec 0c             	sub    $0xc,%esp
  80160c:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80160f:	8b 55 08             	mov    0x8(%ebp),%edx
  801612:	8b 52 0c             	mov    0xc(%edx),%edx
  801615:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  80161b:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801620:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801625:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801628:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80162d:	50                   	push   %eax
  80162e:	ff 75 0c             	pushl  0xc(%ebp)
  801631:	68 08 50 80 00       	push   $0x805008
  801636:	e8 5d f4 ff ff       	call   800a98 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80163b:	ba 00 00 00 00       	mov    $0x0,%edx
  801640:	b8 04 00 00 00       	mov    $0x4,%eax
  801645:	e8 ba fe ff ff       	call   801504 <fsipc>
}
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

0080164c <devfile_read>:
{
  80164c:	f3 0f 1e fb          	endbr32 
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	56                   	push   %esi
  801654:	53                   	push   %ebx
  801655:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	8b 40 0c             	mov    0xc(%eax),%eax
  80165e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801663:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801669:	ba 00 00 00 00       	mov    $0x0,%edx
  80166e:	b8 03 00 00 00       	mov    $0x3,%eax
  801673:	e8 8c fe ff ff       	call   801504 <fsipc>
  801678:	89 c3                	mov    %eax,%ebx
  80167a:	85 c0                	test   %eax,%eax
  80167c:	78 1f                	js     80169d <devfile_read+0x51>
	assert(r <= n);
  80167e:	39 f0                	cmp    %esi,%eax
  801680:	77 24                	ja     8016a6 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801682:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801687:	7f 33                	jg     8016bc <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801689:	83 ec 04             	sub    $0x4,%esp
  80168c:	50                   	push   %eax
  80168d:	68 00 50 80 00       	push   $0x805000
  801692:	ff 75 0c             	pushl  0xc(%ebp)
  801695:	e8 fe f3 ff ff       	call   800a98 <memmove>
	return r;
  80169a:	83 c4 10             	add    $0x10,%esp
}
  80169d:	89 d8                	mov    %ebx,%eax
  80169f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a2:	5b                   	pop    %ebx
  8016a3:	5e                   	pop    %esi
  8016a4:	5d                   	pop    %ebp
  8016a5:	c3                   	ret    
	assert(r <= n);
  8016a6:	68 98 25 80 00       	push   $0x802598
  8016ab:	68 9f 25 80 00       	push   $0x80259f
  8016b0:	6a 7c                	push   $0x7c
  8016b2:	68 b4 25 80 00       	push   $0x8025b4
  8016b7:	e8 35 eb ff ff       	call   8001f1 <_panic>
	assert(r <= PGSIZE);
  8016bc:	68 bf 25 80 00       	push   $0x8025bf
  8016c1:	68 9f 25 80 00       	push   $0x80259f
  8016c6:	6a 7d                	push   $0x7d
  8016c8:	68 b4 25 80 00       	push   $0x8025b4
  8016cd:	e8 1f eb ff ff       	call   8001f1 <_panic>

008016d2 <open>:
{
  8016d2:	f3 0f 1e fb          	endbr32 
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	56                   	push   %esi
  8016da:	53                   	push   %ebx
  8016db:	83 ec 1c             	sub    $0x1c,%esp
  8016de:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016e1:	56                   	push   %esi
  8016e2:	e8 b8 f1 ff ff       	call   80089f <strlen>
  8016e7:	83 c4 10             	add    $0x10,%esp
  8016ea:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016ef:	7f 6c                	jg     80175d <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8016f1:	83 ec 0c             	sub    $0xc,%esp
  8016f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f7:	50                   	push   %eax
  8016f8:	e8 67 f8 ff ff       	call   800f64 <fd_alloc>
  8016fd:	89 c3                	mov    %eax,%ebx
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	85 c0                	test   %eax,%eax
  801704:	78 3c                	js     801742 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801706:	83 ec 08             	sub    $0x8,%esp
  801709:	56                   	push   %esi
  80170a:	68 00 50 80 00       	push   $0x805000
  80170f:	e8 ce f1 ff ff       	call   8008e2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801714:	8b 45 0c             	mov    0xc(%ebp),%eax
  801717:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80171c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80171f:	b8 01 00 00 00       	mov    $0x1,%eax
  801724:	e8 db fd ff ff       	call   801504 <fsipc>
  801729:	89 c3                	mov    %eax,%ebx
  80172b:	83 c4 10             	add    $0x10,%esp
  80172e:	85 c0                	test   %eax,%eax
  801730:	78 19                	js     80174b <open+0x79>
	return fd2num(fd);
  801732:	83 ec 0c             	sub    $0xc,%esp
  801735:	ff 75 f4             	pushl  -0xc(%ebp)
  801738:	e8 f8 f7 ff ff       	call   800f35 <fd2num>
  80173d:	89 c3                	mov    %eax,%ebx
  80173f:	83 c4 10             	add    $0x10,%esp
}
  801742:	89 d8                	mov    %ebx,%eax
  801744:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801747:	5b                   	pop    %ebx
  801748:	5e                   	pop    %esi
  801749:	5d                   	pop    %ebp
  80174a:	c3                   	ret    
		fd_close(fd, 0);
  80174b:	83 ec 08             	sub    $0x8,%esp
  80174e:	6a 00                	push   $0x0
  801750:	ff 75 f4             	pushl  -0xc(%ebp)
  801753:	e8 10 f9 ff ff       	call   801068 <fd_close>
		return r;
  801758:	83 c4 10             	add    $0x10,%esp
  80175b:	eb e5                	jmp    801742 <open+0x70>
		return -E_BAD_PATH;
  80175d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801762:	eb de                	jmp    801742 <open+0x70>

00801764 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801764:	f3 0f 1e fb          	endbr32 
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80176e:	ba 00 00 00 00       	mov    $0x0,%edx
  801773:	b8 08 00 00 00       	mov    $0x8,%eax
  801778:	e8 87 fd ff ff       	call   801504 <fsipc>
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80177f:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801783:	7f 01                	jg     801786 <writebuf+0x7>
  801785:	c3                   	ret    
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	53                   	push   %ebx
  80178a:	83 ec 08             	sub    $0x8,%esp
  80178d:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80178f:	ff 70 04             	pushl  0x4(%eax)
  801792:	8d 40 10             	lea    0x10(%eax),%eax
  801795:	50                   	push   %eax
  801796:	ff 33                	pushl  (%ebx)
  801798:	e8 76 fb ff ff       	call   801313 <write>
		if (result > 0)
  80179d:	83 c4 10             	add    $0x10,%esp
  8017a0:	85 c0                	test   %eax,%eax
  8017a2:	7e 03                	jle    8017a7 <writebuf+0x28>
			b->result += result;
  8017a4:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8017a7:	39 43 04             	cmp    %eax,0x4(%ebx)
  8017aa:	74 0d                	je     8017b9 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8017ac:	85 c0                	test   %eax,%eax
  8017ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b3:	0f 4f c2             	cmovg  %edx,%eax
  8017b6:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8017b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <putch>:

static void
putch(int ch, void *thunk)
{
  8017be:	f3 0f 1e fb          	endbr32 
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	53                   	push   %ebx
  8017c6:	83 ec 04             	sub    $0x4,%esp
  8017c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8017cc:	8b 53 04             	mov    0x4(%ebx),%edx
  8017cf:	8d 42 01             	lea    0x1(%edx),%eax
  8017d2:	89 43 04             	mov    %eax,0x4(%ebx)
  8017d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017d8:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8017dc:	3d 00 01 00 00       	cmp    $0x100,%eax
  8017e1:	74 06                	je     8017e9 <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  8017e3:	83 c4 04             	add    $0x4,%esp
  8017e6:	5b                   	pop    %ebx
  8017e7:	5d                   	pop    %ebp
  8017e8:	c3                   	ret    
		writebuf(b);
  8017e9:	89 d8                	mov    %ebx,%eax
  8017eb:	e8 8f ff ff ff       	call   80177f <writebuf>
		b->idx = 0;
  8017f0:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8017f7:	eb ea                	jmp    8017e3 <putch+0x25>

008017f9 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8017f9:	f3 0f 1e fb          	endbr32 
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80180f:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801816:	00 00 00 
	b.result = 0;
  801819:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801820:	00 00 00 
	b.error = 1;
  801823:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  80182a:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80182d:	ff 75 10             	pushl  0x10(%ebp)
  801830:	ff 75 0c             	pushl  0xc(%ebp)
  801833:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801839:	50                   	push   %eax
  80183a:	68 be 17 80 00       	push   $0x8017be
  80183f:	e8 97 eb ff ff       	call   8003db <vprintfmt>
	if (b.idx > 0)
  801844:	83 c4 10             	add    $0x10,%esp
  801847:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  80184e:	7f 11                	jg     801861 <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801850:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801856:	85 c0                	test   %eax,%eax
  801858:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    
		writebuf(&b);
  801861:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801867:	e8 13 ff ff ff       	call   80177f <writebuf>
  80186c:	eb e2                	jmp    801850 <vfprintf+0x57>

0080186e <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80186e:	f3 0f 1e fb          	endbr32 
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801878:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  80187b:	50                   	push   %eax
  80187c:	ff 75 0c             	pushl  0xc(%ebp)
  80187f:	ff 75 08             	pushl  0x8(%ebp)
  801882:	e8 72 ff ff ff       	call   8017f9 <vfprintf>
	va_end(ap);

	return cnt;
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <printf>:

int
printf(const char *fmt, ...)
{
  801889:	f3 0f 1e fb          	endbr32 
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801893:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801896:	50                   	push   %eax
  801897:	ff 75 08             	pushl  0x8(%ebp)
  80189a:	6a 01                	push   $0x1
  80189c:	e8 58 ff ff ff       	call   8017f9 <vfprintf>
	va_end(ap);

	return cnt;
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8018a3:	f3 0f 1e fb          	endbr32 
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	56                   	push   %esi
  8018ab:	53                   	push   %ebx
  8018ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8018af:	83 ec 0c             	sub    $0xc,%esp
  8018b2:	ff 75 08             	pushl  0x8(%ebp)
  8018b5:	e8 8f f6 ff ff       	call   800f49 <fd2data>
  8018ba:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8018bc:	83 c4 08             	add    $0x8,%esp
  8018bf:	68 cb 25 80 00       	push   $0x8025cb
  8018c4:	53                   	push   %ebx
  8018c5:	e8 18 f0 ff ff       	call   8008e2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8018ca:	8b 46 04             	mov    0x4(%esi),%eax
  8018cd:	2b 06                	sub    (%esi),%eax
  8018cf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8018d5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018dc:	00 00 00 
	stat->st_dev = &devpipe;
  8018df:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  8018e6:	30 80 00 
	return 0;
}
  8018e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f1:	5b                   	pop    %ebx
  8018f2:	5e                   	pop    %esi
  8018f3:	5d                   	pop    %ebp
  8018f4:	c3                   	ret    

008018f5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8018f5:	f3 0f 1e fb          	endbr32 
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	53                   	push   %ebx
  8018fd:	83 ec 0c             	sub    $0xc,%esp
  801900:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801903:	53                   	push   %ebx
  801904:	6a 00                	push   $0x0
  801906:	e8 a6 f4 ff ff       	call   800db1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80190b:	89 1c 24             	mov    %ebx,(%esp)
  80190e:	e8 36 f6 ff ff       	call   800f49 <fd2data>
  801913:	83 c4 08             	add    $0x8,%esp
  801916:	50                   	push   %eax
  801917:	6a 00                	push   $0x0
  801919:	e8 93 f4 ff ff       	call   800db1 <sys_page_unmap>
}
  80191e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <_pipeisclosed>:
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	57                   	push   %edi
  801927:	56                   	push   %esi
  801928:	53                   	push   %ebx
  801929:	83 ec 1c             	sub    $0x1c,%esp
  80192c:	89 c7                	mov    %eax,%edi
  80192e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801930:	a1 08 40 80 00       	mov    0x804008,%eax
  801935:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801938:	83 ec 0c             	sub    $0xc,%esp
  80193b:	57                   	push   %edi
  80193c:	e8 77 05 00 00       	call   801eb8 <pageref>
  801941:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801944:	89 34 24             	mov    %esi,(%esp)
  801947:	e8 6c 05 00 00       	call   801eb8 <pageref>
		nn = thisenv->env_runs;
  80194c:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801952:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801955:	83 c4 10             	add    $0x10,%esp
  801958:	39 cb                	cmp    %ecx,%ebx
  80195a:	74 1b                	je     801977 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80195c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80195f:	75 cf                	jne    801930 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801961:	8b 42 58             	mov    0x58(%edx),%eax
  801964:	6a 01                	push   $0x1
  801966:	50                   	push   %eax
  801967:	53                   	push   %ebx
  801968:	68 d2 25 80 00       	push   $0x8025d2
  80196d:	e8 66 e9 ff ff       	call   8002d8 <cprintf>
  801972:	83 c4 10             	add    $0x10,%esp
  801975:	eb b9                	jmp    801930 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801977:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80197a:	0f 94 c0             	sete   %al
  80197d:	0f b6 c0             	movzbl %al,%eax
}
  801980:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801983:	5b                   	pop    %ebx
  801984:	5e                   	pop    %esi
  801985:	5f                   	pop    %edi
  801986:	5d                   	pop    %ebp
  801987:	c3                   	ret    

00801988 <devpipe_write>:
{
  801988:	f3 0f 1e fb          	endbr32 
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	57                   	push   %edi
  801990:	56                   	push   %esi
  801991:	53                   	push   %ebx
  801992:	83 ec 28             	sub    $0x28,%esp
  801995:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801998:	56                   	push   %esi
  801999:	e8 ab f5 ff ff       	call   800f49 <fd2data>
  80199e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8019a0:	83 c4 10             	add    $0x10,%esp
  8019a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8019a8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8019ab:	74 4f                	je     8019fc <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019ad:	8b 43 04             	mov    0x4(%ebx),%eax
  8019b0:	8b 0b                	mov    (%ebx),%ecx
  8019b2:	8d 51 20             	lea    0x20(%ecx),%edx
  8019b5:	39 d0                	cmp    %edx,%eax
  8019b7:	72 14                	jb     8019cd <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8019b9:	89 da                	mov    %ebx,%edx
  8019bb:	89 f0                	mov    %esi,%eax
  8019bd:	e8 61 ff ff ff       	call   801923 <_pipeisclosed>
  8019c2:	85 c0                	test   %eax,%eax
  8019c4:	75 3b                	jne    801a01 <devpipe_write+0x79>
			sys_yield();
  8019c6:	e8 36 f3 ff ff       	call   800d01 <sys_yield>
  8019cb:	eb e0                	jmp    8019ad <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8019cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019d0:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8019d4:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8019d7:	89 c2                	mov    %eax,%edx
  8019d9:	c1 fa 1f             	sar    $0x1f,%edx
  8019dc:	89 d1                	mov    %edx,%ecx
  8019de:	c1 e9 1b             	shr    $0x1b,%ecx
  8019e1:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8019e4:	83 e2 1f             	and    $0x1f,%edx
  8019e7:	29 ca                	sub    %ecx,%edx
  8019e9:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8019ed:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8019f1:	83 c0 01             	add    $0x1,%eax
  8019f4:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8019f7:	83 c7 01             	add    $0x1,%edi
  8019fa:	eb ac                	jmp    8019a8 <devpipe_write+0x20>
	return i;
  8019fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ff:	eb 05                	jmp    801a06 <devpipe_write+0x7e>
				return 0;
  801a01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a09:	5b                   	pop    %ebx
  801a0a:	5e                   	pop    %esi
  801a0b:	5f                   	pop    %edi
  801a0c:	5d                   	pop    %ebp
  801a0d:	c3                   	ret    

00801a0e <devpipe_read>:
{
  801a0e:	f3 0f 1e fb          	endbr32 
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
  801a15:	57                   	push   %edi
  801a16:	56                   	push   %esi
  801a17:	53                   	push   %ebx
  801a18:	83 ec 18             	sub    $0x18,%esp
  801a1b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801a1e:	57                   	push   %edi
  801a1f:	e8 25 f5 ff ff       	call   800f49 <fd2data>
  801a24:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a26:	83 c4 10             	add    $0x10,%esp
  801a29:	be 00 00 00 00       	mov    $0x0,%esi
  801a2e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a31:	75 14                	jne    801a47 <devpipe_read+0x39>
	return i;
  801a33:	8b 45 10             	mov    0x10(%ebp),%eax
  801a36:	eb 02                	jmp    801a3a <devpipe_read+0x2c>
				return i;
  801a38:	89 f0                	mov    %esi,%eax
}
  801a3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a3d:	5b                   	pop    %ebx
  801a3e:	5e                   	pop    %esi
  801a3f:	5f                   	pop    %edi
  801a40:	5d                   	pop    %ebp
  801a41:	c3                   	ret    
			sys_yield();
  801a42:	e8 ba f2 ff ff       	call   800d01 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801a47:	8b 03                	mov    (%ebx),%eax
  801a49:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a4c:	75 18                	jne    801a66 <devpipe_read+0x58>
			if (i > 0)
  801a4e:	85 f6                	test   %esi,%esi
  801a50:	75 e6                	jne    801a38 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801a52:	89 da                	mov    %ebx,%edx
  801a54:	89 f8                	mov    %edi,%eax
  801a56:	e8 c8 fe ff ff       	call   801923 <_pipeisclosed>
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	74 e3                	je     801a42 <devpipe_read+0x34>
				return 0;
  801a5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a64:	eb d4                	jmp    801a3a <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a66:	99                   	cltd   
  801a67:	c1 ea 1b             	shr    $0x1b,%edx
  801a6a:	01 d0                	add    %edx,%eax
  801a6c:	83 e0 1f             	and    $0x1f,%eax
  801a6f:	29 d0                	sub    %edx,%eax
  801a71:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801a76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a79:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801a7c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801a7f:	83 c6 01             	add    $0x1,%esi
  801a82:	eb aa                	jmp    801a2e <devpipe_read+0x20>

00801a84 <pipe>:
{
  801a84:	f3 0f 1e fb          	endbr32 
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	56                   	push   %esi
  801a8c:	53                   	push   %ebx
  801a8d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801a90:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a93:	50                   	push   %eax
  801a94:	e8 cb f4 ff ff       	call   800f64 <fd_alloc>
  801a99:	89 c3                	mov    %eax,%ebx
  801a9b:	83 c4 10             	add    $0x10,%esp
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	0f 88 23 01 00 00    	js     801bc9 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801aa6:	83 ec 04             	sub    $0x4,%esp
  801aa9:	68 07 04 00 00       	push   $0x407
  801aae:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab1:	6a 00                	push   $0x0
  801ab3:	e8 6c f2 ff ff       	call   800d24 <sys_page_alloc>
  801ab8:	89 c3                	mov    %eax,%ebx
  801aba:	83 c4 10             	add    $0x10,%esp
  801abd:	85 c0                	test   %eax,%eax
  801abf:	0f 88 04 01 00 00    	js     801bc9 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801ac5:	83 ec 0c             	sub    $0xc,%esp
  801ac8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801acb:	50                   	push   %eax
  801acc:	e8 93 f4 ff ff       	call   800f64 <fd_alloc>
  801ad1:	89 c3                	mov    %eax,%ebx
  801ad3:	83 c4 10             	add    $0x10,%esp
  801ad6:	85 c0                	test   %eax,%eax
  801ad8:	0f 88 db 00 00 00    	js     801bb9 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ade:	83 ec 04             	sub    $0x4,%esp
  801ae1:	68 07 04 00 00       	push   $0x407
  801ae6:	ff 75 f0             	pushl  -0x10(%ebp)
  801ae9:	6a 00                	push   $0x0
  801aeb:	e8 34 f2 ff ff       	call   800d24 <sys_page_alloc>
  801af0:	89 c3                	mov    %eax,%ebx
  801af2:	83 c4 10             	add    $0x10,%esp
  801af5:	85 c0                	test   %eax,%eax
  801af7:	0f 88 bc 00 00 00    	js     801bb9 <pipe+0x135>
	va = fd2data(fd0);
  801afd:	83 ec 0c             	sub    $0xc,%esp
  801b00:	ff 75 f4             	pushl  -0xc(%ebp)
  801b03:	e8 41 f4 ff ff       	call   800f49 <fd2data>
  801b08:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b0a:	83 c4 0c             	add    $0xc,%esp
  801b0d:	68 07 04 00 00       	push   $0x407
  801b12:	50                   	push   %eax
  801b13:	6a 00                	push   $0x0
  801b15:	e8 0a f2 ff ff       	call   800d24 <sys_page_alloc>
  801b1a:	89 c3                	mov    %eax,%ebx
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	85 c0                	test   %eax,%eax
  801b21:	0f 88 82 00 00 00    	js     801ba9 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b27:	83 ec 0c             	sub    $0xc,%esp
  801b2a:	ff 75 f0             	pushl  -0x10(%ebp)
  801b2d:	e8 17 f4 ff ff       	call   800f49 <fd2data>
  801b32:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801b39:	50                   	push   %eax
  801b3a:	6a 00                	push   $0x0
  801b3c:	56                   	push   %esi
  801b3d:	6a 00                	push   $0x0
  801b3f:	e8 27 f2 ff ff       	call   800d6b <sys_page_map>
  801b44:	89 c3                	mov    %eax,%ebx
  801b46:	83 c4 20             	add    $0x20,%esp
  801b49:	85 c0                	test   %eax,%eax
  801b4b:	78 4e                	js     801b9b <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801b4d:	a1 24 30 80 00       	mov    0x803024,%eax
  801b52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b55:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801b57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b5a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801b61:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b64:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b69:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801b70:	83 ec 0c             	sub    $0xc,%esp
  801b73:	ff 75 f4             	pushl  -0xc(%ebp)
  801b76:	e8 ba f3 ff ff       	call   800f35 <fd2num>
  801b7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b7e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801b80:	83 c4 04             	add    $0x4,%esp
  801b83:	ff 75 f0             	pushl  -0x10(%ebp)
  801b86:	e8 aa f3 ff ff       	call   800f35 <fd2num>
  801b8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b8e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801b91:	83 c4 10             	add    $0x10,%esp
  801b94:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b99:	eb 2e                	jmp    801bc9 <pipe+0x145>
	sys_page_unmap(0, va);
  801b9b:	83 ec 08             	sub    $0x8,%esp
  801b9e:	56                   	push   %esi
  801b9f:	6a 00                	push   $0x0
  801ba1:	e8 0b f2 ff ff       	call   800db1 <sys_page_unmap>
  801ba6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ba9:	83 ec 08             	sub    $0x8,%esp
  801bac:	ff 75 f0             	pushl  -0x10(%ebp)
  801baf:	6a 00                	push   $0x0
  801bb1:	e8 fb f1 ff ff       	call   800db1 <sys_page_unmap>
  801bb6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801bb9:	83 ec 08             	sub    $0x8,%esp
  801bbc:	ff 75 f4             	pushl  -0xc(%ebp)
  801bbf:	6a 00                	push   $0x0
  801bc1:	e8 eb f1 ff ff       	call   800db1 <sys_page_unmap>
  801bc6:	83 c4 10             	add    $0x10,%esp
}
  801bc9:	89 d8                	mov    %ebx,%eax
  801bcb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bce:	5b                   	pop    %ebx
  801bcf:	5e                   	pop    %esi
  801bd0:	5d                   	pop    %ebp
  801bd1:	c3                   	ret    

00801bd2 <pipeisclosed>:
{
  801bd2:	f3 0f 1e fb          	endbr32 
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bdc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bdf:	50                   	push   %eax
  801be0:	ff 75 08             	pushl  0x8(%ebp)
  801be3:	e8 d2 f3 ff ff       	call   800fba <fd_lookup>
  801be8:	83 c4 10             	add    $0x10,%esp
  801beb:	85 c0                	test   %eax,%eax
  801bed:	78 18                	js     801c07 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801bef:	83 ec 0c             	sub    $0xc,%esp
  801bf2:	ff 75 f4             	pushl  -0xc(%ebp)
  801bf5:	e8 4f f3 ff ff       	call   800f49 <fd2data>
  801bfa:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bff:	e8 1f fd ff ff       	call   801923 <_pipeisclosed>
  801c04:	83 c4 10             	add    $0x10,%esp
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801c09:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801c0d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c12:	c3                   	ret    

00801c13 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801c13:	f3 0f 1e fb          	endbr32 
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801c1d:	68 ea 25 80 00       	push   $0x8025ea
  801c22:	ff 75 0c             	pushl  0xc(%ebp)
  801c25:	e8 b8 ec ff ff       	call   8008e2 <strcpy>
	return 0;
}
  801c2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <devcons_write>:
{
  801c31:	f3 0f 1e fb          	endbr32 
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	57                   	push   %edi
  801c39:	56                   	push   %esi
  801c3a:	53                   	push   %ebx
  801c3b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801c41:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801c46:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801c4c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c4f:	73 31                	jae    801c82 <devcons_write+0x51>
		m = n - tot;
  801c51:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c54:	29 f3                	sub    %esi,%ebx
  801c56:	83 fb 7f             	cmp    $0x7f,%ebx
  801c59:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801c5e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801c61:	83 ec 04             	sub    $0x4,%esp
  801c64:	53                   	push   %ebx
  801c65:	89 f0                	mov    %esi,%eax
  801c67:	03 45 0c             	add    0xc(%ebp),%eax
  801c6a:	50                   	push   %eax
  801c6b:	57                   	push   %edi
  801c6c:	e8 27 ee ff ff       	call   800a98 <memmove>
		sys_cputs(buf, m);
  801c71:	83 c4 08             	add    $0x8,%esp
  801c74:	53                   	push   %ebx
  801c75:	57                   	push   %edi
  801c76:	e8 d9 ef ff ff       	call   800c54 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801c7b:	01 de                	add    %ebx,%esi
  801c7d:	83 c4 10             	add    $0x10,%esp
  801c80:	eb ca                	jmp    801c4c <devcons_write+0x1b>
}
  801c82:	89 f0                	mov    %esi,%eax
  801c84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c87:	5b                   	pop    %ebx
  801c88:	5e                   	pop    %esi
  801c89:	5f                   	pop    %edi
  801c8a:	5d                   	pop    %ebp
  801c8b:	c3                   	ret    

00801c8c <devcons_read>:
{
  801c8c:	f3 0f 1e fb          	endbr32 
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 08             	sub    $0x8,%esp
  801c96:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801c9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c9f:	74 21                	je     801cc2 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801ca1:	e8 d0 ef ff ff       	call   800c76 <sys_cgetc>
  801ca6:	85 c0                	test   %eax,%eax
  801ca8:	75 07                	jne    801cb1 <devcons_read+0x25>
		sys_yield();
  801caa:	e8 52 f0 ff ff       	call   800d01 <sys_yield>
  801caf:	eb f0                	jmp    801ca1 <devcons_read+0x15>
	if (c < 0)
  801cb1:	78 0f                	js     801cc2 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801cb3:	83 f8 04             	cmp    $0x4,%eax
  801cb6:	74 0c                	je     801cc4 <devcons_read+0x38>
	*(char*)vbuf = c;
  801cb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbb:	88 02                	mov    %al,(%edx)
	return 1;
  801cbd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    
		return 0;
  801cc4:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc9:	eb f7                	jmp    801cc2 <devcons_read+0x36>

00801ccb <cputchar>:
{
  801ccb:	f3 0f 1e fb          	endbr32 
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801cdb:	6a 01                	push   $0x1
  801cdd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ce0:	50                   	push   %eax
  801ce1:	e8 6e ef ff ff       	call   800c54 <sys_cputs>
}
  801ce6:	83 c4 10             	add    $0x10,%esp
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <getchar>:
{
  801ceb:	f3 0f 1e fb          	endbr32 
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801cf5:	6a 01                	push   $0x1
  801cf7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801cfa:	50                   	push   %eax
  801cfb:	6a 00                	push   $0x0
  801cfd:	e8 3b f5 ff ff       	call   80123d <read>
	if (r < 0)
  801d02:	83 c4 10             	add    $0x10,%esp
  801d05:	85 c0                	test   %eax,%eax
  801d07:	78 06                	js     801d0f <getchar+0x24>
	if (r < 1)
  801d09:	74 06                	je     801d11 <getchar+0x26>
	return c;
  801d0b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    
		return -E_EOF;
  801d11:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801d16:	eb f7                	jmp    801d0f <getchar+0x24>

00801d18 <iscons>:
{
  801d18:	f3 0f 1e fb          	endbr32 
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
  801d1f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d22:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d25:	50                   	push   %eax
  801d26:	ff 75 08             	pushl  0x8(%ebp)
  801d29:	e8 8c f2 ff ff       	call   800fba <fd_lookup>
  801d2e:	83 c4 10             	add    $0x10,%esp
  801d31:	85 c0                	test   %eax,%eax
  801d33:	78 11                	js     801d46 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d38:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801d3e:	39 10                	cmp    %edx,(%eax)
  801d40:	0f 94 c0             	sete   %al
  801d43:	0f b6 c0             	movzbl %al,%eax
}
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    

00801d48 <opencons>:
{
  801d48:	f3 0f 1e fb          	endbr32 
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801d52:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d55:	50                   	push   %eax
  801d56:	e8 09 f2 ff ff       	call   800f64 <fd_alloc>
  801d5b:	83 c4 10             	add    $0x10,%esp
  801d5e:	85 c0                	test   %eax,%eax
  801d60:	78 3a                	js     801d9c <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801d62:	83 ec 04             	sub    $0x4,%esp
  801d65:	68 07 04 00 00       	push   $0x407
  801d6a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d6d:	6a 00                	push   $0x0
  801d6f:	e8 b0 ef ff ff       	call   800d24 <sys_page_alloc>
  801d74:	83 c4 10             	add    $0x10,%esp
  801d77:	85 c0                	test   %eax,%eax
  801d79:	78 21                	js     801d9c <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7e:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801d84:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d89:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801d90:	83 ec 0c             	sub    $0xc,%esp
  801d93:	50                   	push   %eax
  801d94:	e8 9c f1 ff ff       	call   800f35 <fd2num>
  801d99:	83 c4 10             	add    $0x10,%esp
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d9e:	f3 0f 1e fb          	endbr32 
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	56                   	push   %esi
  801da6:	53                   	push   %ebx
  801da7:	8b 75 08             	mov    0x8(%ebp),%esi
  801daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dad:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801db0:	85 c0                	test   %eax,%eax
  801db2:	74 3d                	je     801df1 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801db4:	83 ec 0c             	sub    $0xc,%esp
  801db7:	50                   	push   %eax
  801db8:	e8 33 f1 ff ff       	call   800ef0 <sys_ipc_recv>
  801dbd:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801dc0:	85 f6                	test   %esi,%esi
  801dc2:	74 0b                	je     801dcf <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801dc4:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801dca:	8b 52 74             	mov    0x74(%edx),%edx
  801dcd:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801dcf:	85 db                	test   %ebx,%ebx
  801dd1:	74 0b                	je     801dde <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801dd3:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801dd9:	8b 52 78             	mov    0x78(%edx),%edx
  801ddc:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801dde:	85 c0                	test   %eax,%eax
  801de0:	78 21                	js     801e03 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801de2:	a1 08 40 80 00       	mov    0x804008,%eax
  801de7:	8b 40 70             	mov    0x70(%eax),%eax
}
  801dea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ded:	5b                   	pop    %ebx
  801dee:	5e                   	pop    %esi
  801def:	5d                   	pop    %ebp
  801df0:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801df1:	83 ec 0c             	sub    $0xc,%esp
  801df4:	68 00 00 c0 ee       	push   $0xeec00000
  801df9:	e8 f2 f0 ff ff       	call   800ef0 <sys_ipc_recv>
  801dfe:	83 c4 10             	add    $0x10,%esp
  801e01:	eb bd                	jmp    801dc0 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801e03:	85 f6                	test   %esi,%esi
  801e05:	74 10                	je     801e17 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801e07:	85 db                	test   %ebx,%ebx
  801e09:	75 df                	jne    801dea <ipc_recv+0x4c>
  801e0b:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801e12:	00 00 00 
  801e15:	eb d3                	jmp    801dea <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801e17:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801e1e:	00 00 00 
  801e21:	eb e4                	jmp    801e07 <ipc_recv+0x69>

00801e23 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e23:	f3 0f 1e fb          	endbr32 
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
  801e2a:	57                   	push   %edi
  801e2b:	56                   	push   %esi
  801e2c:	53                   	push   %ebx
  801e2d:	83 ec 0c             	sub    $0xc,%esp
  801e30:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e33:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e36:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801e39:	85 db                	test   %ebx,%ebx
  801e3b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801e40:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801e43:	ff 75 14             	pushl  0x14(%ebp)
  801e46:	53                   	push   %ebx
  801e47:	56                   	push   %esi
  801e48:	57                   	push   %edi
  801e49:	e8 7b f0 ff ff       	call   800ec9 <sys_ipc_try_send>
  801e4e:	83 c4 10             	add    $0x10,%esp
  801e51:	85 c0                	test   %eax,%eax
  801e53:	79 1e                	jns    801e73 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801e55:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e58:	75 07                	jne    801e61 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801e5a:	e8 a2 ee ff ff       	call   800d01 <sys_yield>
  801e5f:	eb e2                	jmp    801e43 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801e61:	50                   	push   %eax
  801e62:	68 f6 25 80 00       	push   $0x8025f6
  801e67:	6a 59                	push   $0x59
  801e69:	68 11 26 80 00       	push   $0x802611
  801e6e:	e8 7e e3 ff ff       	call   8001f1 <_panic>
	}
}
  801e73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e76:	5b                   	pop    %ebx
  801e77:	5e                   	pop    %esi
  801e78:	5f                   	pop    %edi
  801e79:	5d                   	pop    %ebp
  801e7a:	c3                   	ret    

00801e7b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e7b:	f3 0f 1e fb          	endbr32 
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801e85:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801e8a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801e8d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801e93:	8b 52 50             	mov    0x50(%edx),%edx
  801e96:	39 ca                	cmp    %ecx,%edx
  801e98:	74 11                	je     801eab <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801e9a:	83 c0 01             	add    $0x1,%eax
  801e9d:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ea2:	75 e6                	jne    801e8a <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801ea4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea9:	eb 0b                	jmp    801eb6 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801eab:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801eae:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801eb3:	8b 40 48             	mov    0x48(%eax),%eax
}
  801eb6:	5d                   	pop    %ebp
  801eb7:	c3                   	ret    

00801eb8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801eb8:	f3 0f 1e fb          	endbr32 
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ec2:	89 c2                	mov    %eax,%edx
  801ec4:	c1 ea 16             	shr    $0x16,%edx
  801ec7:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801ece:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801ed3:	f6 c1 01             	test   $0x1,%cl
  801ed6:	74 1c                	je     801ef4 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801ed8:	c1 e8 0c             	shr    $0xc,%eax
  801edb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801ee2:	a8 01                	test   $0x1,%al
  801ee4:	74 0e                	je     801ef4 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ee6:	c1 e8 0c             	shr    $0xc,%eax
  801ee9:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801ef0:	ef 
  801ef1:	0f b7 d2             	movzwl %dx,%edx
}
  801ef4:	89 d0                	mov    %edx,%eax
  801ef6:	5d                   	pop    %ebp
  801ef7:	c3                   	ret    
  801ef8:	66 90                	xchg   %ax,%ax
  801efa:	66 90                	xchg   %ax,%ax
  801efc:	66 90                	xchg   %ax,%ax
  801efe:	66 90                	xchg   %ax,%ax

00801f00 <__udivdi3>:
  801f00:	f3 0f 1e fb          	endbr32 
  801f04:	55                   	push   %ebp
  801f05:	57                   	push   %edi
  801f06:	56                   	push   %esi
  801f07:	53                   	push   %ebx
  801f08:	83 ec 1c             	sub    $0x1c,%esp
  801f0b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801f0f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801f13:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f17:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801f1b:	85 d2                	test   %edx,%edx
  801f1d:	75 19                	jne    801f38 <__udivdi3+0x38>
  801f1f:	39 f3                	cmp    %esi,%ebx
  801f21:	76 4d                	jbe    801f70 <__udivdi3+0x70>
  801f23:	31 ff                	xor    %edi,%edi
  801f25:	89 e8                	mov    %ebp,%eax
  801f27:	89 f2                	mov    %esi,%edx
  801f29:	f7 f3                	div    %ebx
  801f2b:	89 fa                	mov    %edi,%edx
  801f2d:	83 c4 1c             	add    $0x1c,%esp
  801f30:	5b                   	pop    %ebx
  801f31:	5e                   	pop    %esi
  801f32:	5f                   	pop    %edi
  801f33:	5d                   	pop    %ebp
  801f34:	c3                   	ret    
  801f35:	8d 76 00             	lea    0x0(%esi),%esi
  801f38:	39 f2                	cmp    %esi,%edx
  801f3a:	76 14                	jbe    801f50 <__udivdi3+0x50>
  801f3c:	31 ff                	xor    %edi,%edi
  801f3e:	31 c0                	xor    %eax,%eax
  801f40:	89 fa                	mov    %edi,%edx
  801f42:	83 c4 1c             	add    $0x1c,%esp
  801f45:	5b                   	pop    %ebx
  801f46:	5e                   	pop    %esi
  801f47:	5f                   	pop    %edi
  801f48:	5d                   	pop    %ebp
  801f49:	c3                   	ret    
  801f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f50:	0f bd fa             	bsr    %edx,%edi
  801f53:	83 f7 1f             	xor    $0x1f,%edi
  801f56:	75 48                	jne    801fa0 <__udivdi3+0xa0>
  801f58:	39 f2                	cmp    %esi,%edx
  801f5a:	72 06                	jb     801f62 <__udivdi3+0x62>
  801f5c:	31 c0                	xor    %eax,%eax
  801f5e:	39 eb                	cmp    %ebp,%ebx
  801f60:	77 de                	ja     801f40 <__udivdi3+0x40>
  801f62:	b8 01 00 00 00       	mov    $0x1,%eax
  801f67:	eb d7                	jmp    801f40 <__udivdi3+0x40>
  801f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f70:	89 d9                	mov    %ebx,%ecx
  801f72:	85 db                	test   %ebx,%ebx
  801f74:	75 0b                	jne    801f81 <__udivdi3+0x81>
  801f76:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7b:	31 d2                	xor    %edx,%edx
  801f7d:	f7 f3                	div    %ebx
  801f7f:	89 c1                	mov    %eax,%ecx
  801f81:	31 d2                	xor    %edx,%edx
  801f83:	89 f0                	mov    %esi,%eax
  801f85:	f7 f1                	div    %ecx
  801f87:	89 c6                	mov    %eax,%esi
  801f89:	89 e8                	mov    %ebp,%eax
  801f8b:	89 f7                	mov    %esi,%edi
  801f8d:	f7 f1                	div    %ecx
  801f8f:	89 fa                	mov    %edi,%edx
  801f91:	83 c4 1c             	add    $0x1c,%esp
  801f94:	5b                   	pop    %ebx
  801f95:	5e                   	pop    %esi
  801f96:	5f                   	pop    %edi
  801f97:	5d                   	pop    %ebp
  801f98:	c3                   	ret    
  801f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fa0:	89 f9                	mov    %edi,%ecx
  801fa2:	b8 20 00 00 00       	mov    $0x20,%eax
  801fa7:	29 f8                	sub    %edi,%eax
  801fa9:	d3 e2                	shl    %cl,%edx
  801fab:	89 54 24 08          	mov    %edx,0x8(%esp)
  801faf:	89 c1                	mov    %eax,%ecx
  801fb1:	89 da                	mov    %ebx,%edx
  801fb3:	d3 ea                	shr    %cl,%edx
  801fb5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801fb9:	09 d1                	or     %edx,%ecx
  801fbb:	89 f2                	mov    %esi,%edx
  801fbd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fc1:	89 f9                	mov    %edi,%ecx
  801fc3:	d3 e3                	shl    %cl,%ebx
  801fc5:	89 c1                	mov    %eax,%ecx
  801fc7:	d3 ea                	shr    %cl,%edx
  801fc9:	89 f9                	mov    %edi,%ecx
  801fcb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801fcf:	89 eb                	mov    %ebp,%ebx
  801fd1:	d3 e6                	shl    %cl,%esi
  801fd3:	89 c1                	mov    %eax,%ecx
  801fd5:	d3 eb                	shr    %cl,%ebx
  801fd7:	09 de                	or     %ebx,%esi
  801fd9:	89 f0                	mov    %esi,%eax
  801fdb:	f7 74 24 08          	divl   0x8(%esp)
  801fdf:	89 d6                	mov    %edx,%esi
  801fe1:	89 c3                	mov    %eax,%ebx
  801fe3:	f7 64 24 0c          	mull   0xc(%esp)
  801fe7:	39 d6                	cmp    %edx,%esi
  801fe9:	72 15                	jb     802000 <__udivdi3+0x100>
  801feb:	89 f9                	mov    %edi,%ecx
  801fed:	d3 e5                	shl    %cl,%ebp
  801fef:	39 c5                	cmp    %eax,%ebp
  801ff1:	73 04                	jae    801ff7 <__udivdi3+0xf7>
  801ff3:	39 d6                	cmp    %edx,%esi
  801ff5:	74 09                	je     802000 <__udivdi3+0x100>
  801ff7:	89 d8                	mov    %ebx,%eax
  801ff9:	31 ff                	xor    %edi,%edi
  801ffb:	e9 40 ff ff ff       	jmp    801f40 <__udivdi3+0x40>
  802000:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802003:	31 ff                	xor    %edi,%edi
  802005:	e9 36 ff ff ff       	jmp    801f40 <__udivdi3+0x40>
  80200a:	66 90                	xchg   %ax,%ax
  80200c:	66 90                	xchg   %ax,%ax
  80200e:	66 90                	xchg   %ax,%ax

00802010 <__umoddi3>:
  802010:	f3 0f 1e fb          	endbr32 
  802014:	55                   	push   %ebp
  802015:	57                   	push   %edi
  802016:	56                   	push   %esi
  802017:	53                   	push   %ebx
  802018:	83 ec 1c             	sub    $0x1c,%esp
  80201b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80201f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802023:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802027:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80202b:	85 c0                	test   %eax,%eax
  80202d:	75 19                	jne    802048 <__umoddi3+0x38>
  80202f:	39 df                	cmp    %ebx,%edi
  802031:	76 5d                	jbe    802090 <__umoddi3+0x80>
  802033:	89 f0                	mov    %esi,%eax
  802035:	89 da                	mov    %ebx,%edx
  802037:	f7 f7                	div    %edi
  802039:	89 d0                	mov    %edx,%eax
  80203b:	31 d2                	xor    %edx,%edx
  80203d:	83 c4 1c             	add    $0x1c,%esp
  802040:	5b                   	pop    %ebx
  802041:	5e                   	pop    %esi
  802042:	5f                   	pop    %edi
  802043:	5d                   	pop    %ebp
  802044:	c3                   	ret    
  802045:	8d 76 00             	lea    0x0(%esi),%esi
  802048:	89 f2                	mov    %esi,%edx
  80204a:	39 d8                	cmp    %ebx,%eax
  80204c:	76 12                	jbe    802060 <__umoddi3+0x50>
  80204e:	89 f0                	mov    %esi,%eax
  802050:	89 da                	mov    %ebx,%edx
  802052:	83 c4 1c             	add    $0x1c,%esp
  802055:	5b                   	pop    %ebx
  802056:	5e                   	pop    %esi
  802057:	5f                   	pop    %edi
  802058:	5d                   	pop    %ebp
  802059:	c3                   	ret    
  80205a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802060:	0f bd e8             	bsr    %eax,%ebp
  802063:	83 f5 1f             	xor    $0x1f,%ebp
  802066:	75 50                	jne    8020b8 <__umoddi3+0xa8>
  802068:	39 d8                	cmp    %ebx,%eax
  80206a:	0f 82 e0 00 00 00    	jb     802150 <__umoddi3+0x140>
  802070:	89 d9                	mov    %ebx,%ecx
  802072:	39 f7                	cmp    %esi,%edi
  802074:	0f 86 d6 00 00 00    	jbe    802150 <__umoddi3+0x140>
  80207a:	89 d0                	mov    %edx,%eax
  80207c:	89 ca                	mov    %ecx,%edx
  80207e:	83 c4 1c             	add    $0x1c,%esp
  802081:	5b                   	pop    %ebx
  802082:	5e                   	pop    %esi
  802083:	5f                   	pop    %edi
  802084:	5d                   	pop    %ebp
  802085:	c3                   	ret    
  802086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80208d:	8d 76 00             	lea    0x0(%esi),%esi
  802090:	89 fd                	mov    %edi,%ebp
  802092:	85 ff                	test   %edi,%edi
  802094:	75 0b                	jne    8020a1 <__umoddi3+0x91>
  802096:	b8 01 00 00 00       	mov    $0x1,%eax
  80209b:	31 d2                	xor    %edx,%edx
  80209d:	f7 f7                	div    %edi
  80209f:	89 c5                	mov    %eax,%ebp
  8020a1:	89 d8                	mov    %ebx,%eax
  8020a3:	31 d2                	xor    %edx,%edx
  8020a5:	f7 f5                	div    %ebp
  8020a7:	89 f0                	mov    %esi,%eax
  8020a9:	f7 f5                	div    %ebp
  8020ab:	89 d0                	mov    %edx,%eax
  8020ad:	31 d2                	xor    %edx,%edx
  8020af:	eb 8c                	jmp    80203d <__umoddi3+0x2d>
  8020b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020b8:	89 e9                	mov    %ebp,%ecx
  8020ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8020bf:	29 ea                	sub    %ebp,%edx
  8020c1:	d3 e0                	shl    %cl,%eax
  8020c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020c7:	89 d1                	mov    %edx,%ecx
  8020c9:	89 f8                	mov    %edi,%eax
  8020cb:	d3 e8                	shr    %cl,%eax
  8020cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8020d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020d9:	09 c1                	or     %eax,%ecx
  8020db:	89 d8                	mov    %ebx,%eax
  8020dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020e1:	89 e9                	mov    %ebp,%ecx
  8020e3:	d3 e7                	shl    %cl,%edi
  8020e5:	89 d1                	mov    %edx,%ecx
  8020e7:	d3 e8                	shr    %cl,%eax
  8020e9:	89 e9                	mov    %ebp,%ecx
  8020eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020ef:	d3 e3                	shl    %cl,%ebx
  8020f1:	89 c7                	mov    %eax,%edi
  8020f3:	89 d1                	mov    %edx,%ecx
  8020f5:	89 f0                	mov    %esi,%eax
  8020f7:	d3 e8                	shr    %cl,%eax
  8020f9:	89 e9                	mov    %ebp,%ecx
  8020fb:	89 fa                	mov    %edi,%edx
  8020fd:	d3 e6                	shl    %cl,%esi
  8020ff:	09 d8                	or     %ebx,%eax
  802101:	f7 74 24 08          	divl   0x8(%esp)
  802105:	89 d1                	mov    %edx,%ecx
  802107:	89 f3                	mov    %esi,%ebx
  802109:	f7 64 24 0c          	mull   0xc(%esp)
  80210d:	89 c6                	mov    %eax,%esi
  80210f:	89 d7                	mov    %edx,%edi
  802111:	39 d1                	cmp    %edx,%ecx
  802113:	72 06                	jb     80211b <__umoddi3+0x10b>
  802115:	75 10                	jne    802127 <__umoddi3+0x117>
  802117:	39 c3                	cmp    %eax,%ebx
  802119:	73 0c                	jae    802127 <__umoddi3+0x117>
  80211b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80211f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802123:	89 d7                	mov    %edx,%edi
  802125:	89 c6                	mov    %eax,%esi
  802127:	89 ca                	mov    %ecx,%edx
  802129:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80212e:	29 f3                	sub    %esi,%ebx
  802130:	19 fa                	sbb    %edi,%edx
  802132:	89 d0                	mov    %edx,%eax
  802134:	d3 e0                	shl    %cl,%eax
  802136:	89 e9                	mov    %ebp,%ecx
  802138:	d3 eb                	shr    %cl,%ebx
  80213a:	d3 ea                	shr    %cl,%edx
  80213c:	09 d8                	or     %ebx,%eax
  80213e:	83 c4 1c             	add    $0x1c,%esp
  802141:	5b                   	pop    %ebx
  802142:	5e                   	pop    %esi
  802143:	5f                   	pop    %edi
  802144:	5d                   	pop    %ebp
  802145:	c3                   	ret    
  802146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80214d:	8d 76 00             	lea    0x0(%esi),%esi
  802150:	29 fe                	sub    %edi,%esi
  802152:	19 c3                	sbb    %eax,%ebx
  802154:	89 f2                	mov    %esi,%edx
  802156:	89 d9                	mov    %ebx,%ecx
  802158:	e9 1d ff ff ff       	jmp    80207a <__umoddi3+0x6a>
