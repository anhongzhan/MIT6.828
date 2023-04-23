
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
  800058:	68 e0 26 80 00       	push   $0x8026e0
  80005d:	e8 db 18 00 00       	call   80193d <printf>
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
  800077:	e8 4b 13 00 00       	call   8013c7 <write>
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
  800091:	e8 5b 12 00 00       	call   8012f1 <read>
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
  8000af:	68 e5 26 80 00       	push   $0x8026e5
  8000b4:	6a 13                	push   $0x13
  8000b6:	68 00 27 80 00       	push   $0x802700
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
  8000dc:	68 0b 27 80 00       	push   $0x80270b
  8000e1:	6a 18                	push   $0x18
  8000e3:	68 00 27 80 00       	push   $0x802700
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
  8000fa:	c7 05 04 30 80 00 20 	movl   $0x802720,0x803004
  800101:	27 80 00 
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
  800124:	e8 5d 16 00 00       	call   801786 <open>
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
  800140:	e8 62 10 00 00       	call   8011a7 <close>
		for (i = 1; i < argc; i++) {
  800145:	83 c7 01             	add    $0x1,%edi
  800148:	83 c6 04             	add    $0x4,%esi
  80014b:	83 c4 10             	add    $0x10,%esp
  80014e:	eb c5                	jmp    800115 <umain+0x28>
		num(0, "<stdin>");
  800150:	83 ec 08             	sub    $0x8,%esp
  800153:	68 24 27 80 00       	push   $0x802724
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
  800178:	68 2c 27 80 00       	push   $0x80272c
  80017d:	6a 27                	push   $0x27
  80017f:	68 00 27 80 00       	push   $0x802700
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
  8001aa:	a3 0c 40 80 00       	mov    %eax,0x80400c

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
  8001dd:	e8 f6 0f 00 00       	call   8011d8 <close_all>
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
  800213:	68 48 27 80 00       	push   $0x802748
  800218:	e8 bb 00 00 00       	call   8002d8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80021d:	83 c4 18             	add    $0x18,%esp
  800220:	53                   	push   %ebx
  800221:	ff 75 10             	pushl  0x10(%ebp)
  800224:	e8 5a 00 00 00       	call   800283 <vcprintf>
	cprintf("\n");
  800229:	c7 04 24 cc 2b 80 00 	movl   $0x802bcc,(%esp)
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
  80033e:	e8 2d 21 00 00       	call   802470 <__udivdi3>
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
  80037c:	e8 ff 21 00 00       	call   802580 <__umoddi3>
  800381:	83 c4 14             	add    $0x14,%esp
  800384:	0f be 80 6b 27 80 00 	movsbl 0x80276b(%eax),%eax
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
  80042b:	3e ff 24 85 a0 28 80 	notrack jmp *0x8028a0(,%eax,4)
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
  8004f8:	8b 14 85 00 2a 80 00 	mov    0x802a00(,%eax,4),%edx
  8004ff:	85 d2                	test   %edx,%edx
  800501:	74 18                	je     80051b <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800503:	52                   	push   %edx
  800504:	68 35 2b 80 00       	push   $0x802b35
  800509:	53                   	push   %ebx
  80050a:	56                   	push   %esi
  80050b:	e8 aa fe ff ff       	call   8003ba <printfmt>
  800510:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800513:	89 7d 14             	mov    %edi,0x14(%ebp)
  800516:	e9 66 02 00 00       	jmp    800781 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80051b:	50                   	push   %eax
  80051c:	68 83 27 80 00       	push   $0x802783
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
  800543:	b8 7c 27 80 00       	mov    $0x80277c,%eax
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
  800ccd:	68 5f 2a 80 00       	push   $0x802a5f
  800cd2:	6a 23                	push   $0x23
  800cd4:	68 7c 2a 80 00       	push   $0x802a7c
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
  800d5a:	68 5f 2a 80 00       	push   $0x802a5f
  800d5f:	6a 23                	push   $0x23
  800d61:	68 7c 2a 80 00       	push   $0x802a7c
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
  800da0:	68 5f 2a 80 00       	push   $0x802a5f
  800da5:	6a 23                	push   $0x23
  800da7:	68 7c 2a 80 00       	push   $0x802a7c
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
  800de6:	68 5f 2a 80 00       	push   $0x802a5f
  800deb:	6a 23                	push   $0x23
  800ded:	68 7c 2a 80 00       	push   $0x802a7c
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
  800e2c:	68 5f 2a 80 00       	push   $0x802a5f
  800e31:	6a 23                	push   $0x23
  800e33:	68 7c 2a 80 00       	push   $0x802a7c
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
  800e72:	68 5f 2a 80 00       	push   $0x802a5f
  800e77:	6a 23                	push   $0x23
  800e79:	68 7c 2a 80 00       	push   $0x802a7c
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
  800eb8:	68 5f 2a 80 00       	push   $0x802a5f
  800ebd:	6a 23                	push   $0x23
  800ebf:	68 7c 2a 80 00       	push   $0x802a7c
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
  800f24:	68 5f 2a 80 00       	push   $0x802a5f
  800f29:	6a 23                	push   $0x23
  800f2b:	68 7c 2a 80 00       	push   $0x802a7c
  800f30:	e8 bc f2 ff ff       	call   8001f1 <_panic>

00800f35 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f35:	f3 0f 1e fb          	endbr32 
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	57                   	push   %edi
  800f3d:	56                   	push   %esi
  800f3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f44:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f49:	89 d1                	mov    %edx,%ecx
  800f4b:	89 d3                	mov    %edx,%ebx
  800f4d:	89 d7                	mov    %edx,%edi
  800f4f:	89 d6                	mov    %edx,%esi
  800f51:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f53:	5b                   	pop    %ebx
  800f54:	5e                   	pop    %esi
  800f55:	5f                   	pop    %edi
  800f56:	5d                   	pop    %ebp
  800f57:	c3                   	ret    

00800f58 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800f58:	f3 0f 1e fb          	endbr32 
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	57                   	push   %edi
  800f60:	56                   	push   %esi
  800f61:	53                   	push   %ebx
  800f62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f65:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f70:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f75:	89 df                	mov    %ebx,%edi
  800f77:	89 de                	mov    %ebx,%esi
  800f79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	7f 08                	jg     800f87 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800f7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f82:	5b                   	pop    %ebx
  800f83:	5e                   	pop    %esi
  800f84:	5f                   	pop    %edi
  800f85:	5d                   	pop    %ebp
  800f86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f87:	83 ec 0c             	sub    $0xc,%esp
  800f8a:	50                   	push   %eax
  800f8b:	6a 0f                	push   $0xf
  800f8d:	68 5f 2a 80 00       	push   $0x802a5f
  800f92:	6a 23                	push   $0x23
  800f94:	68 7c 2a 80 00       	push   $0x802a7c
  800f99:	e8 53 f2 ff ff       	call   8001f1 <_panic>

00800f9e <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800f9e:	f3 0f 1e fb          	endbr32 
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	57                   	push   %edi
  800fa6:	56                   	push   %esi
  800fa7:	53                   	push   %ebx
  800fa8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb6:	b8 10 00 00 00       	mov    $0x10,%eax
  800fbb:	89 df                	mov    %ebx,%edi
  800fbd:	89 de                	mov    %ebx,%esi
  800fbf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc1:	85 c0                	test   %eax,%eax
  800fc3:	7f 08                	jg     800fcd <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800fc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc8:	5b                   	pop    %ebx
  800fc9:	5e                   	pop    %esi
  800fca:	5f                   	pop    %edi
  800fcb:	5d                   	pop    %ebp
  800fcc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fcd:	83 ec 0c             	sub    $0xc,%esp
  800fd0:	50                   	push   %eax
  800fd1:	6a 10                	push   $0x10
  800fd3:	68 5f 2a 80 00       	push   $0x802a5f
  800fd8:	6a 23                	push   $0x23
  800fda:	68 7c 2a 80 00       	push   $0x802a7c
  800fdf:	e8 0d f2 ff ff       	call   8001f1 <_panic>

00800fe4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fe4:	f3 0f 1e fb          	endbr32 
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	05 00 00 00 30       	add    $0x30000000,%eax
  800ff3:	c1 e8 0c             	shr    $0xc,%eax
}
  800ff6:	5d                   	pop    %ebp
  800ff7:	c3                   	ret    

00800ff8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ff8:	f3 0f 1e fb          	endbr32 
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801007:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80100c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    

00801013 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801013:	f3 0f 1e fb          	endbr32 
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80101f:	89 c2                	mov    %eax,%edx
  801021:	c1 ea 16             	shr    $0x16,%edx
  801024:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80102b:	f6 c2 01             	test   $0x1,%dl
  80102e:	74 2d                	je     80105d <fd_alloc+0x4a>
  801030:	89 c2                	mov    %eax,%edx
  801032:	c1 ea 0c             	shr    $0xc,%edx
  801035:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80103c:	f6 c2 01             	test   $0x1,%dl
  80103f:	74 1c                	je     80105d <fd_alloc+0x4a>
  801041:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801046:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80104b:	75 d2                	jne    80101f <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801056:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80105b:	eb 0a                	jmp    801067 <fd_alloc+0x54>
			*fd_store = fd;
  80105d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801060:	89 01                	mov    %eax,(%ecx)
			return 0;
  801062:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801067:	5d                   	pop    %ebp
  801068:	c3                   	ret    

00801069 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801069:	f3 0f 1e fb          	endbr32 
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801073:	83 f8 1f             	cmp    $0x1f,%eax
  801076:	77 30                	ja     8010a8 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801078:	c1 e0 0c             	shl    $0xc,%eax
  80107b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801080:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801086:	f6 c2 01             	test   $0x1,%dl
  801089:	74 24                	je     8010af <fd_lookup+0x46>
  80108b:	89 c2                	mov    %eax,%edx
  80108d:	c1 ea 0c             	shr    $0xc,%edx
  801090:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801097:	f6 c2 01             	test   $0x1,%dl
  80109a:	74 1a                	je     8010b6 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80109c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80109f:	89 02                	mov    %eax,(%edx)
	return 0;
  8010a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a6:	5d                   	pop    %ebp
  8010a7:	c3                   	ret    
		return -E_INVAL;
  8010a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ad:	eb f7                	jmp    8010a6 <fd_lookup+0x3d>
		return -E_INVAL;
  8010af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010b4:	eb f0                	jmp    8010a6 <fd_lookup+0x3d>
  8010b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010bb:	eb e9                	jmp    8010a6 <fd_lookup+0x3d>

008010bd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010bd:	f3 0f 1e fb          	endbr32 
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	83 ec 08             	sub    $0x8,%esp
  8010c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8010cf:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010d4:	39 08                	cmp    %ecx,(%eax)
  8010d6:	74 38                	je     801110 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8010d8:	83 c2 01             	add    $0x1,%edx
  8010db:	8b 04 95 08 2b 80 00 	mov    0x802b08(,%edx,4),%eax
  8010e2:	85 c0                	test   %eax,%eax
  8010e4:	75 ee                	jne    8010d4 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010e6:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8010eb:	8b 40 48             	mov    0x48(%eax),%eax
  8010ee:	83 ec 04             	sub    $0x4,%esp
  8010f1:	51                   	push   %ecx
  8010f2:	50                   	push   %eax
  8010f3:	68 8c 2a 80 00       	push   $0x802a8c
  8010f8:	e8 db f1 ff ff       	call   8002d8 <cprintf>
	*dev = 0;
  8010fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801100:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801106:	83 c4 10             	add    $0x10,%esp
  801109:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80110e:	c9                   	leave  
  80110f:	c3                   	ret    
			*dev = devtab[i];
  801110:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801113:	89 01                	mov    %eax,(%ecx)
			return 0;
  801115:	b8 00 00 00 00       	mov    $0x0,%eax
  80111a:	eb f2                	jmp    80110e <dev_lookup+0x51>

0080111c <fd_close>:
{
  80111c:	f3 0f 1e fb          	endbr32 
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	57                   	push   %edi
  801124:	56                   	push   %esi
  801125:	53                   	push   %ebx
  801126:	83 ec 24             	sub    $0x24,%esp
  801129:	8b 75 08             	mov    0x8(%ebp),%esi
  80112c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80112f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801132:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801133:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801139:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80113c:	50                   	push   %eax
  80113d:	e8 27 ff ff ff       	call   801069 <fd_lookup>
  801142:	89 c3                	mov    %eax,%ebx
  801144:	83 c4 10             	add    $0x10,%esp
  801147:	85 c0                	test   %eax,%eax
  801149:	78 05                	js     801150 <fd_close+0x34>
	    || fd != fd2)
  80114b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80114e:	74 16                	je     801166 <fd_close+0x4a>
		return (must_exist ? r : 0);
  801150:	89 f8                	mov    %edi,%eax
  801152:	84 c0                	test   %al,%al
  801154:	b8 00 00 00 00       	mov    $0x0,%eax
  801159:	0f 44 d8             	cmove  %eax,%ebx
}
  80115c:	89 d8                	mov    %ebx,%eax
  80115e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801161:	5b                   	pop    %ebx
  801162:	5e                   	pop    %esi
  801163:	5f                   	pop    %edi
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801166:	83 ec 08             	sub    $0x8,%esp
  801169:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80116c:	50                   	push   %eax
  80116d:	ff 36                	pushl  (%esi)
  80116f:	e8 49 ff ff ff       	call   8010bd <dev_lookup>
  801174:	89 c3                	mov    %eax,%ebx
  801176:	83 c4 10             	add    $0x10,%esp
  801179:	85 c0                	test   %eax,%eax
  80117b:	78 1a                	js     801197 <fd_close+0x7b>
		if (dev->dev_close)
  80117d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801180:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801183:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801188:	85 c0                	test   %eax,%eax
  80118a:	74 0b                	je     801197 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80118c:	83 ec 0c             	sub    $0xc,%esp
  80118f:	56                   	push   %esi
  801190:	ff d0                	call   *%eax
  801192:	89 c3                	mov    %eax,%ebx
  801194:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801197:	83 ec 08             	sub    $0x8,%esp
  80119a:	56                   	push   %esi
  80119b:	6a 00                	push   $0x0
  80119d:	e8 0f fc ff ff       	call   800db1 <sys_page_unmap>
	return r;
  8011a2:	83 c4 10             	add    $0x10,%esp
  8011a5:	eb b5                	jmp    80115c <fd_close+0x40>

008011a7 <close>:

int
close(int fdnum)
{
  8011a7:	f3 0f 1e fb          	endbr32 
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011b4:	50                   	push   %eax
  8011b5:	ff 75 08             	pushl  0x8(%ebp)
  8011b8:	e8 ac fe ff ff       	call   801069 <fd_lookup>
  8011bd:	83 c4 10             	add    $0x10,%esp
  8011c0:	85 c0                	test   %eax,%eax
  8011c2:	79 02                	jns    8011c6 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8011c4:	c9                   	leave  
  8011c5:	c3                   	ret    
		return fd_close(fd, 1);
  8011c6:	83 ec 08             	sub    $0x8,%esp
  8011c9:	6a 01                	push   $0x1
  8011cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8011ce:	e8 49 ff ff ff       	call   80111c <fd_close>
  8011d3:	83 c4 10             	add    $0x10,%esp
  8011d6:	eb ec                	jmp    8011c4 <close+0x1d>

008011d8 <close_all>:

void
close_all(void)
{
  8011d8:	f3 0f 1e fb          	endbr32 
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	53                   	push   %ebx
  8011e0:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011e3:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011e8:	83 ec 0c             	sub    $0xc,%esp
  8011eb:	53                   	push   %ebx
  8011ec:	e8 b6 ff ff ff       	call   8011a7 <close>
	for (i = 0; i < MAXFD; i++)
  8011f1:	83 c3 01             	add    $0x1,%ebx
  8011f4:	83 c4 10             	add    $0x10,%esp
  8011f7:	83 fb 20             	cmp    $0x20,%ebx
  8011fa:	75 ec                	jne    8011e8 <close_all+0x10>
}
  8011fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011ff:	c9                   	leave  
  801200:	c3                   	ret    

00801201 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801201:	f3 0f 1e fb          	endbr32 
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	57                   	push   %edi
  801209:	56                   	push   %esi
  80120a:	53                   	push   %ebx
  80120b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80120e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801211:	50                   	push   %eax
  801212:	ff 75 08             	pushl  0x8(%ebp)
  801215:	e8 4f fe ff ff       	call   801069 <fd_lookup>
  80121a:	89 c3                	mov    %eax,%ebx
  80121c:	83 c4 10             	add    $0x10,%esp
  80121f:	85 c0                	test   %eax,%eax
  801221:	0f 88 81 00 00 00    	js     8012a8 <dup+0xa7>
		return r;
	close(newfdnum);
  801227:	83 ec 0c             	sub    $0xc,%esp
  80122a:	ff 75 0c             	pushl  0xc(%ebp)
  80122d:	e8 75 ff ff ff       	call   8011a7 <close>

	newfd = INDEX2FD(newfdnum);
  801232:	8b 75 0c             	mov    0xc(%ebp),%esi
  801235:	c1 e6 0c             	shl    $0xc,%esi
  801238:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80123e:	83 c4 04             	add    $0x4,%esp
  801241:	ff 75 e4             	pushl  -0x1c(%ebp)
  801244:	e8 af fd ff ff       	call   800ff8 <fd2data>
  801249:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80124b:	89 34 24             	mov    %esi,(%esp)
  80124e:	e8 a5 fd ff ff       	call   800ff8 <fd2data>
  801253:	83 c4 10             	add    $0x10,%esp
  801256:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801258:	89 d8                	mov    %ebx,%eax
  80125a:	c1 e8 16             	shr    $0x16,%eax
  80125d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801264:	a8 01                	test   $0x1,%al
  801266:	74 11                	je     801279 <dup+0x78>
  801268:	89 d8                	mov    %ebx,%eax
  80126a:	c1 e8 0c             	shr    $0xc,%eax
  80126d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801274:	f6 c2 01             	test   $0x1,%dl
  801277:	75 39                	jne    8012b2 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801279:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80127c:	89 d0                	mov    %edx,%eax
  80127e:	c1 e8 0c             	shr    $0xc,%eax
  801281:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801288:	83 ec 0c             	sub    $0xc,%esp
  80128b:	25 07 0e 00 00       	and    $0xe07,%eax
  801290:	50                   	push   %eax
  801291:	56                   	push   %esi
  801292:	6a 00                	push   $0x0
  801294:	52                   	push   %edx
  801295:	6a 00                	push   $0x0
  801297:	e8 cf fa ff ff       	call   800d6b <sys_page_map>
  80129c:	89 c3                	mov    %eax,%ebx
  80129e:	83 c4 20             	add    $0x20,%esp
  8012a1:	85 c0                	test   %eax,%eax
  8012a3:	78 31                	js     8012d6 <dup+0xd5>
		goto err;

	return newfdnum;
  8012a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012a8:	89 d8                	mov    %ebx,%eax
  8012aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ad:	5b                   	pop    %ebx
  8012ae:	5e                   	pop    %esi
  8012af:	5f                   	pop    %edi
  8012b0:	5d                   	pop    %ebp
  8012b1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012b2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012b9:	83 ec 0c             	sub    $0xc,%esp
  8012bc:	25 07 0e 00 00       	and    $0xe07,%eax
  8012c1:	50                   	push   %eax
  8012c2:	57                   	push   %edi
  8012c3:	6a 00                	push   $0x0
  8012c5:	53                   	push   %ebx
  8012c6:	6a 00                	push   $0x0
  8012c8:	e8 9e fa ff ff       	call   800d6b <sys_page_map>
  8012cd:	89 c3                	mov    %eax,%ebx
  8012cf:	83 c4 20             	add    $0x20,%esp
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	79 a3                	jns    801279 <dup+0x78>
	sys_page_unmap(0, newfd);
  8012d6:	83 ec 08             	sub    $0x8,%esp
  8012d9:	56                   	push   %esi
  8012da:	6a 00                	push   $0x0
  8012dc:	e8 d0 fa ff ff       	call   800db1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012e1:	83 c4 08             	add    $0x8,%esp
  8012e4:	57                   	push   %edi
  8012e5:	6a 00                	push   $0x0
  8012e7:	e8 c5 fa ff ff       	call   800db1 <sys_page_unmap>
	return r;
  8012ec:	83 c4 10             	add    $0x10,%esp
  8012ef:	eb b7                	jmp    8012a8 <dup+0xa7>

008012f1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012f1:	f3 0f 1e fb          	endbr32 
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
  8012f8:	53                   	push   %ebx
  8012f9:	83 ec 1c             	sub    $0x1c,%esp
  8012fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801302:	50                   	push   %eax
  801303:	53                   	push   %ebx
  801304:	e8 60 fd ff ff       	call   801069 <fd_lookup>
  801309:	83 c4 10             	add    $0x10,%esp
  80130c:	85 c0                	test   %eax,%eax
  80130e:	78 3f                	js     80134f <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801310:	83 ec 08             	sub    $0x8,%esp
  801313:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801316:	50                   	push   %eax
  801317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80131a:	ff 30                	pushl  (%eax)
  80131c:	e8 9c fd ff ff       	call   8010bd <dev_lookup>
  801321:	83 c4 10             	add    $0x10,%esp
  801324:	85 c0                	test   %eax,%eax
  801326:	78 27                	js     80134f <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801328:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80132b:	8b 42 08             	mov    0x8(%edx),%eax
  80132e:	83 e0 03             	and    $0x3,%eax
  801331:	83 f8 01             	cmp    $0x1,%eax
  801334:	74 1e                	je     801354 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801339:	8b 40 08             	mov    0x8(%eax),%eax
  80133c:	85 c0                	test   %eax,%eax
  80133e:	74 35                	je     801375 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801340:	83 ec 04             	sub    $0x4,%esp
  801343:	ff 75 10             	pushl  0x10(%ebp)
  801346:	ff 75 0c             	pushl  0xc(%ebp)
  801349:	52                   	push   %edx
  80134a:	ff d0                	call   *%eax
  80134c:	83 c4 10             	add    $0x10,%esp
}
  80134f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801352:	c9                   	leave  
  801353:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801354:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801359:	8b 40 48             	mov    0x48(%eax),%eax
  80135c:	83 ec 04             	sub    $0x4,%esp
  80135f:	53                   	push   %ebx
  801360:	50                   	push   %eax
  801361:	68 cd 2a 80 00       	push   $0x802acd
  801366:	e8 6d ef ff ff       	call   8002d8 <cprintf>
		return -E_INVAL;
  80136b:	83 c4 10             	add    $0x10,%esp
  80136e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801373:	eb da                	jmp    80134f <read+0x5e>
		return -E_NOT_SUPP;
  801375:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80137a:	eb d3                	jmp    80134f <read+0x5e>

0080137c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80137c:	f3 0f 1e fb          	endbr32 
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	57                   	push   %edi
  801384:	56                   	push   %esi
  801385:	53                   	push   %ebx
  801386:	83 ec 0c             	sub    $0xc,%esp
  801389:	8b 7d 08             	mov    0x8(%ebp),%edi
  80138c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80138f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801394:	eb 02                	jmp    801398 <readn+0x1c>
  801396:	01 c3                	add    %eax,%ebx
  801398:	39 f3                	cmp    %esi,%ebx
  80139a:	73 21                	jae    8013bd <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80139c:	83 ec 04             	sub    $0x4,%esp
  80139f:	89 f0                	mov    %esi,%eax
  8013a1:	29 d8                	sub    %ebx,%eax
  8013a3:	50                   	push   %eax
  8013a4:	89 d8                	mov    %ebx,%eax
  8013a6:	03 45 0c             	add    0xc(%ebp),%eax
  8013a9:	50                   	push   %eax
  8013aa:	57                   	push   %edi
  8013ab:	e8 41 ff ff ff       	call   8012f1 <read>
		if (m < 0)
  8013b0:	83 c4 10             	add    $0x10,%esp
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	78 04                	js     8013bb <readn+0x3f>
			return m;
		if (m == 0)
  8013b7:	75 dd                	jne    801396 <readn+0x1a>
  8013b9:	eb 02                	jmp    8013bd <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013bb:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013bd:	89 d8                	mov    %ebx,%eax
  8013bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c2:	5b                   	pop    %ebx
  8013c3:	5e                   	pop    %esi
  8013c4:	5f                   	pop    %edi
  8013c5:	5d                   	pop    %ebp
  8013c6:	c3                   	ret    

008013c7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013c7:	f3 0f 1e fb          	endbr32 
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	53                   	push   %ebx
  8013cf:	83 ec 1c             	sub    $0x1c,%esp
  8013d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d8:	50                   	push   %eax
  8013d9:	53                   	push   %ebx
  8013da:	e8 8a fc ff ff       	call   801069 <fd_lookup>
  8013df:	83 c4 10             	add    $0x10,%esp
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	78 3a                	js     801420 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e6:	83 ec 08             	sub    $0x8,%esp
  8013e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ec:	50                   	push   %eax
  8013ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f0:	ff 30                	pushl  (%eax)
  8013f2:	e8 c6 fc ff ff       	call   8010bd <dev_lookup>
  8013f7:	83 c4 10             	add    $0x10,%esp
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	78 22                	js     801420 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801401:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801405:	74 1e                	je     801425 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801407:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80140a:	8b 52 0c             	mov    0xc(%edx),%edx
  80140d:	85 d2                	test   %edx,%edx
  80140f:	74 35                	je     801446 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801411:	83 ec 04             	sub    $0x4,%esp
  801414:	ff 75 10             	pushl  0x10(%ebp)
  801417:	ff 75 0c             	pushl  0xc(%ebp)
  80141a:	50                   	push   %eax
  80141b:	ff d2                	call   *%edx
  80141d:	83 c4 10             	add    $0x10,%esp
}
  801420:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801423:	c9                   	leave  
  801424:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801425:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80142a:	8b 40 48             	mov    0x48(%eax),%eax
  80142d:	83 ec 04             	sub    $0x4,%esp
  801430:	53                   	push   %ebx
  801431:	50                   	push   %eax
  801432:	68 e9 2a 80 00       	push   $0x802ae9
  801437:	e8 9c ee ff ff       	call   8002d8 <cprintf>
		return -E_INVAL;
  80143c:	83 c4 10             	add    $0x10,%esp
  80143f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801444:	eb da                	jmp    801420 <write+0x59>
		return -E_NOT_SUPP;
  801446:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80144b:	eb d3                	jmp    801420 <write+0x59>

0080144d <seek>:

int
seek(int fdnum, off_t offset)
{
  80144d:	f3 0f 1e fb          	endbr32 
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
  801454:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801457:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80145a:	50                   	push   %eax
  80145b:	ff 75 08             	pushl  0x8(%ebp)
  80145e:	e8 06 fc ff ff       	call   801069 <fd_lookup>
  801463:	83 c4 10             	add    $0x10,%esp
  801466:	85 c0                	test   %eax,%eax
  801468:	78 0e                	js     801478 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80146a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801470:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801473:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801478:	c9                   	leave  
  801479:	c3                   	ret    

0080147a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80147a:	f3 0f 1e fb          	endbr32 
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	53                   	push   %ebx
  801482:	83 ec 1c             	sub    $0x1c,%esp
  801485:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801488:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80148b:	50                   	push   %eax
  80148c:	53                   	push   %ebx
  80148d:	e8 d7 fb ff ff       	call   801069 <fd_lookup>
  801492:	83 c4 10             	add    $0x10,%esp
  801495:	85 c0                	test   %eax,%eax
  801497:	78 37                	js     8014d0 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801499:	83 ec 08             	sub    $0x8,%esp
  80149c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80149f:	50                   	push   %eax
  8014a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a3:	ff 30                	pushl  (%eax)
  8014a5:	e8 13 fc ff ff       	call   8010bd <dev_lookup>
  8014aa:	83 c4 10             	add    $0x10,%esp
  8014ad:	85 c0                	test   %eax,%eax
  8014af:	78 1f                	js     8014d0 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014b8:	74 1b                	je     8014d5 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014bd:	8b 52 18             	mov    0x18(%edx),%edx
  8014c0:	85 d2                	test   %edx,%edx
  8014c2:	74 32                	je     8014f6 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014c4:	83 ec 08             	sub    $0x8,%esp
  8014c7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ca:	50                   	push   %eax
  8014cb:	ff d2                	call   *%edx
  8014cd:	83 c4 10             	add    $0x10,%esp
}
  8014d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014d5:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014da:	8b 40 48             	mov    0x48(%eax),%eax
  8014dd:	83 ec 04             	sub    $0x4,%esp
  8014e0:	53                   	push   %ebx
  8014e1:	50                   	push   %eax
  8014e2:	68 ac 2a 80 00       	push   $0x802aac
  8014e7:	e8 ec ed ff ff       	call   8002d8 <cprintf>
		return -E_INVAL;
  8014ec:	83 c4 10             	add    $0x10,%esp
  8014ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f4:	eb da                	jmp    8014d0 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8014f6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014fb:	eb d3                	jmp    8014d0 <ftruncate+0x56>

008014fd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014fd:	f3 0f 1e fb          	endbr32 
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	53                   	push   %ebx
  801505:	83 ec 1c             	sub    $0x1c,%esp
  801508:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80150b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80150e:	50                   	push   %eax
  80150f:	ff 75 08             	pushl  0x8(%ebp)
  801512:	e8 52 fb ff ff       	call   801069 <fd_lookup>
  801517:	83 c4 10             	add    $0x10,%esp
  80151a:	85 c0                	test   %eax,%eax
  80151c:	78 4b                	js     801569 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80151e:	83 ec 08             	sub    $0x8,%esp
  801521:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801524:	50                   	push   %eax
  801525:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801528:	ff 30                	pushl  (%eax)
  80152a:	e8 8e fb ff ff       	call   8010bd <dev_lookup>
  80152f:	83 c4 10             	add    $0x10,%esp
  801532:	85 c0                	test   %eax,%eax
  801534:	78 33                	js     801569 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801539:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80153d:	74 2f                	je     80156e <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80153f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801542:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801549:	00 00 00 
	stat->st_isdir = 0;
  80154c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801553:	00 00 00 
	stat->st_dev = dev;
  801556:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80155c:	83 ec 08             	sub    $0x8,%esp
  80155f:	53                   	push   %ebx
  801560:	ff 75 f0             	pushl  -0x10(%ebp)
  801563:	ff 50 14             	call   *0x14(%eax)
  801566:	83 c4 10             	add    $0x10,%esp
}
  801569:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    
		return -E_NOT_SUPP;
  80156e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801573:	eb f4                	jmp    801569 <fstat+0x6c>

00801575 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801575:	f3 0f 1e fb          	endbr32 
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	56                   	push   %esi
  80157d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80157e:	83 ec 08             	sub    $0x8,%esp
  801581:	6a 00                	push   $0x0
  801583:	ff 75 08             	pushl  0x8(%ebp)
  801586:	e8 fb 01 00 00       	call   801786 <open>
  80158b:	89 c3                	mov    %eax,%ebx
  80158d:	83 c4 10             	add    $0x10,%esp
  801590:	85 c0                	test   %eax,%eax
  801592:	78 1b                	js     8015af <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801594:	83 ec 08             	sub    $0x8,%esp
  801597:	ff 75 0c             	pushl  0xc(%ebp)
  80159a:	50                   	push   %eax
  80159b:	e8 5d ff ff ff       	call   8014fd <fstat>
  8015a0:	89 c6                	mov    %eax,%esi
	close(fd);
  8015a2:	89 1c 24             	mov    %ebx,(%esp)
  8015a5:	e8 fd fb ff ff       	call   8011a7 <close>
	return r;
  8015aa:	83 c4 10             	add    $0x10,%esp
  8015ad:	89 f3                	mov    %esi,%ebx
}
  8015af:	89 d8                	mov    %ebx,%eax
  8015b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b4:	5b                   	pop    %ebx
  8015b5:	5e                   	pop    %esi
  8015b6:	5d                   	pop    %ebp
  8015b7:	c3                   	ret    

008015b8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	56                   	push   %esi
  8015bc:	53                   	push   %ebx
  8015bd:	89 c6                	mov    %eax,%esi
  8015bf:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015c1:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8015c8:	74 27                	je     8015f1 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015ca:	6a 07                	push   $0x7
  8015cc:	68 00 50 80 00       	push   $0x805000
  8015d1:	56                   	push   %esi
  8015d2:	ff 35 04 40 80 00    	pushl  0x804004
  8015d8:	e8 b2 0d 00 00       	call   80238f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015dd:	83 c4 0c             	add    $0xc,%esp
  8015e0:	6a 00                	push   $0x0
  8015e2:	53                   	push   %ebx
  8015e3:	6a 00                	push   $0x0
  8015e5:	e8 20 0d 00 00       	call   80230a <ipc_recv>
}
  8015ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ed:	5b                   	pop    %ebx
  8015ee:	5e                   	pop    %esi
  8015ef:	5d                   	pop    %ebp
  8015f0:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015f1:	83 ec 0c             	sub    $0xc,%esp
  8015f4:	6a 01                	push   $0x1
  8015f6:	e8 ec 0d 00 00       	call   8023e7 <ipc_find_env>
  8015fb:	a3 04 40 80 00       	mov    %eax,0x804004
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	eb c5                	jmp    8015ca <fsipc+0x12>

00801605 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801605:	f3 0f 1e fb          	endbr32 
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	8b 40 0c             	mov    0xc(%eax),%eax
  801615:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80161a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801622:	ba 00 00 00 00       	mov    $0x0,%edx
  801627:	b8 02 00 00 00       	mov    $0x2,%eax
  80162c:	e8 87 ff ff ff       	call   8015b8 <fsipc>
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <devfile_flush>:
{
  801633:	f3 0f 1e fb          	endbr32 
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	8b 40 0c             	mov    0xc(%eax),%eax
  801643:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801648:	ba 00 00 00 00       	mov    $0x0,%edx
  80164d:	b8 06 00 00 00       	mov    $0x6,%eax
  801652:	e8 61 ff ff ff       	call   8015b8 <fsipc>
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <devfile_stat>:
{
  801659:	f3 0f 1e fb          	endbr32 
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	53                   	push   %ebx
  801661:	83 ec 04             	sub    $0x4,%esp
  801664:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	8b 40 0c             	mov    0xc(%eax),%eax
  80166d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801672:	ba 00 00 00 00       	mov    $0x0,%edx
  801677:	b8 05 00 00 00       	mov    $0x5,%eax
  80167c:	e8 37 ff ff ff       	call   8015b8 <fsipc>
  801681:	85 c0                	test   %eax,%eax
  801683:	78 2c                	js     8016b1 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801685:	83 ec 08             	sub    $0x8,%esp
  801688:	68 00 50 80 00       	push   $0x805000
  80168d:	53                   	push   %ebx
  80168e:	e8 4f f2 ff ff       	call   8008e2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801693:	a1 80 50 80 00       	mov    0x805080,%eax
  801698:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80169e:	a1 84 50 80 00       	mov    0x805084,%eax
  8016a3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016a9:	83 c4 10             	add    $0x10,%esp
  8016ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <devfile_write>:
{
  8016b6:	f3 0f 1e fb          	endbr32 
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	83 ec 0c             	sub    $0xc,%esp
  8016c0:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c6:	8b 52 0c             	mov    0xc(%edx),%edx
  8016c9:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8016cf:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8016d4:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8016d9:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8016dc:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8016e1:	50                   	push   %eax
  8016e2:	ff 75 0c             	pushl  0xc(%ebp)
  8016e5:	68 08 50 80 00       	push   $0x805008
  8016ea:	e8 a9 f3 ff ff       	call   800a98 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8016ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f4:	b8 04 00 00 00       	mov    $0x4,%eax
  8016f9:	e8 ba fe ff ff       	call   8015b8 <fsipc>
}
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    

00801700 <devfile_read>:
{
  801700:	f3 0f 1e fb          	endbr32 
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
  801707:	56                   	push   %esi
  801708:	53                   	push   %ebx
  801709:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	8b 40 0c             	mov    0xc(%eax),%eax
  801712:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801717:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80171d:	ba 00 00 00 00       	mov    $0x0,%edx
  801722:	b8 03 00 00 00       	mov    $0x3,%eax
  801727:	e8 8c fe ff ff       	call   8015b8 <fsipc>
  80172c:	89 c3                	mov    %eax,%ebx
  80172e:	85 c0                	test   %eax,%eax
  801730:	78 1f                	js     801751 <devfile_read+0x51>
	assert(r <= n);
  801732:	39 f0                	cmp    %esi,%eax
  801734:	77 24                	ja     80175a <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801736:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80173b:	7f 33                	jg     801770 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80173d:	83 ec 04             	sub    $0x4,%esp
  801740:	50                   	push   %eax
  801741:	68 00 50 80 00       	push   $0x805000
  801746:	ff 75 0c             	pushl  0xc(%ebp)
  801749:	e8 4a f3 ff ff       	call   800a98 <memmove>
	return r;
  80174e:	83 c4 10             	add    $0x10,%esp
}
  801751:	89 d8                	mov    %ebx,%eax
  801753:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801756:	5b                   	pop    %ebx
  801757:	5e                   	pop    %esi
  801758:	5d                   	pop    %ebp
  801759:	c3                   	ret    
	assert(r <= n);
  80175a:	68 1c 2b 80 00       	push   $0x802b1c
  80175f:	68 23 2b 80 00       	push   $0x802b23
  801764:	6a 7c                	push   $0x7c
  801766:	68 38 2b 80 00       	push   $0x802b38
  80176b:	e8 81 ea ff ff       	call   8001f1 <_panic>
	assert(r <= PGSIZE);
  801770:	68 43 2b 80 00       	push   $0x802b43
  801775:	68 23 2b 80 00       	push   $0x802b23
  80177a:	6a 7d                	push   $0x7d
  80177c:	68 38 2b 80 00       	push   $0x802b38
  801781:	e8 6b ea ff ff       	call   8001f1 <_panic>

00801786 <open>:
{
  801786:	f3 0f 1e fb          	endbr32 
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	56                   	push   %esi
  80178e:	53                   	push   %ebx
  80178f:	83 ec 1c             	sub    $0x1c,%esp
  801792:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801795:	56                   	push   %esi
  801796:	e8 04 f1 ff ff       	call   80089f <strlen>
  80179b:	83 c4 10             	add    $0x10,%esp
  80179e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017a3:	7f 6c                	jg     801811 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8017a5:	83 ec 0c             	sub    $0xc,%esp
  8017a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ab:	50                   	push   %eax
  8017ac:	e8 62 f8 ff ff       	call   801013 <fd_alloc>
  8017b1:	89 c3                	mov    %eax,%ebx
  8017b3:	83 c4 10             	add    $0x10,%esp
  8017b6:	85 c0                	test   %eax,%eax
  8017b8:	78 3c                	js     8017f6 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8017ba:	83 ec 08             	sub    $0x8,%esp
  8017bd:	56                   	push   %esi
  8017be:	68 00 50 80 00       	push   $0x805000
  8017c3:	e8 1a f1 ff ff       	call   8008e2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cb:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d8:	e8 db fd ff ff       	call   8015b8 <fsipc>
  8017dd:	89 c3                	mov    %eax,%ebx
  8017df:	83 c4 10             	add    $0x10,%esp
  8017e2:	85 c0                	test   %eax,%eax
  8017e4:	78 19                	js     8017ff <open+0x79>
	return fd2num(fd);
  8017e6:	83 ec 0c             	sub    $0xc,%esp
  8017e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ec:	e8 f3 f7 ff ff       	call   800fe4 <fd2num>
  8017f1:	89 c3                	mov    %eax,%ebx
  8017f3:	83 c4 10             	add    $0x10,%esp
}
  8017f6:	89 d8                	mov    %ebx,%eax
  8017f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017fb:	5b                   	pop    %ebx
  8017fc:	5e                   	pop    %esi
  8017fd:	5d                   	pop    %ebp
  8017fe:	c3                   	ret    
		fd_close(fd, 0);
  8017ff:	83 ec 08             	sub    $0x8,%esp
  801802:	6a 00                	push   $0x0
  801804:	ff 75 f4             	pushl  -0xc(%ebp)
  801807:	e8 10 f9 ff ff       	call   80111c <fd_close>
		return r;
  80180c:	83 c4 10             	add    $0x10,%esp
  80180f:	eb e5                	jmp    8017f6 <open+0x70>
		return -E_BAD_PATH;
  801811:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801816:	eb de                	jmp    8017f6 <open+0x70>

00801818 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801818:	f3 0f 1e fb          	endbr32 
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801822:	ba 00 00 00 00       	mov    $0x0,%edx
  801827:	b8 08 00 00 00       	mov    $0x8,%eax
  80182c:	e8 87 fd ff ff       	call   8015b8 <fsipc>
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801833:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801837:	7f 01                	jg     80183a <writebuf+0x7>
  801839:	c3                   	ret    
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	53                   	push   %ebx
  80183e:	83 ec 08             	sub    $0x8,%esp
  801841:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801843:	ff 70 04             	pushl  0x4(%eax)
  801846:	8d 40 10             	lea    0x10(%eax),%eax
  801849:	50                   	push   %eax
  80184a:	ff 33                	pushl  (%ebx)
  80184c:	e8 76 fb ff ff       	call   8013c7 <write>
		if (result > 0)
  801851:	83 c4 10             	add    $0x10,%esp
  801854:	85 c0                	test   %eax,%eax
  801856:	7e 03                	jle    80185b <writebuf+0x28>
			b->result += result;
  801858:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80185b:	39 43 04             	cmp    %eax,0x4(%ebx)
  80185e:	74 0d                	je     80186d <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801860:	85 c0                	test   %eax,%eax
  801862:	ba 00 00 00 00       	mov    $0x0,%edx
  801867:	0f 4f c2             	cmovg  %edx,%eax
  80186a:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80186d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <putch>:

static void
putch(int ch, void *thunk)
{
  801872:	f3 0f 1e fb          	endbr32 
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	53                   	push   %ebx
  80187a:	83 ec 04             	sub    $0x4,%esp
  80187d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801880:	8b 53 04             	mov    0x4(%ebx),%edx
  801883:	8d 42 01             	lea    0x1(%edx),%eax
  801886:	89 43 04             	mov    %eax,0x4(%ebx)
  801889:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80188c:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801890:	3d 00 01 00 00       	cmp    $0x100,%eax
  801895:	74 06                	je     80189d <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  801897:	83 c4 04             	add    $0x4,%esp
  80189a:	5b                   	pop    %ebx
  80189b:	5d                   	pop    %ebp
  80189c:	c3                   	ret    
		writebuf(b);
  80189d:	89 d8                	mov    %ebx,%eax
  80189f:	e8 8f ff ff ff       	call   801833 <writebuf>
		b->idx = 0;
  8018a4:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8018ab:	eb ea                	jmp    801897 <putch+0x25>

008018ad <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8018ad:	f3 0f 1e fb          	endbr32 
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8018c3:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8018ca:	00 00 00 
	b.result = 0;
  8018cd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8018d4:	00 00 00 
	b.error = 1;
  8018d7:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8018de:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8018e1:	ff 75 10             	pushl  0x10(%ebp)
  8018e4:	ff 75 0c             	pushl  0xc(%ebp)
  8018e7:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8018ed:	50                   	push   %eax
  8018ee:	68 72 18 80 00       	push   $0x801872
  8018f3:	e8 e3 ea ff ff       	call   8003db <vprintfmt>
	if (b.idx > 0)
  8018f8:	83 c4 10             	add    $0x10,%esp
  8018fb:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801902:	7f 11                	jg     801915 <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801904:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80190a:	85 c0                	test   %eax,%eax
  80190c:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801913:	c9                   	leave  
  801914:	c3                   	ret    
		writebuf(&b);
  801915:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80191b:	e8 13 ff ff ff       	call   801833 <writebuf>
  801920:	eb e2                	jmp    801904 <vfprintf+0x57>

00801922 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801922:	f3 0f 1e fb          	endbr32 
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
  801929:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80192c:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  80192f:	50                   	push   %eax
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	ff 75 08             	pushl  0x8(%ebp)
  801936:	e8 72 ff ff ff       	call   8018ad <vfprintf>
	va_end(ap);

	return cnt;
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <printf>:

int
printf(const char *fmt, ...)
{
  80193d:	f3 0f 1e fb          	endbr32 
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801947:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  80194a:	50                   	push   %eax
  80194b:	ff 75 08             	pushl  0x8(%ebp)
  80194e:	6a 01                	push   $0x1
  801950:	e8 58 ff ff ff       	call   8018ad <vfprintf>
	va_end(ap);

	return cnt;
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801957:	f3 0f 1e fb          	endbr32 
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801961:	68 4f 2b 80 00       	push   $0x802b4f
  801966:	ff 75 0c             	pushl  0xc(%ebp)
  801969:	e8 74 ef ff ff       	call   8008e2 <strcpy>
	return 0;
}
  80196e:	b8 00 00 00 00       	mov    $0x0,%eax
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <devsock_close>:
{
  801975:	f3 0f 1e fb          	endbr32 
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	53                   	push   %ebx
  80197d:	83 ec 10             	sub    $0x10,%esp
  801980:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801983:	53                   	push   %ebx
  801984:	e8 9b 0a 00 00       	call   802424 <pageref>
  801989:	89 c2                	mov    %eax,%edx
  80198b:	83 c4 10             	add    $0x10,%esp
		return 0;
  80198e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801993:	83 fa 01             	cmp    $0x1,%edx
  801996:	74 05                	je     80199d <devsock_close+0x28>
}
  801998:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80199d:	83 ec 0c             	sub    $0xc,%esp
  8019a0:	ff 73 0c             	pushl  0xc(%ebx)
  8019a3:	e8 e3 02 00 00       	call   801c8b <nsipc_close>
  8019a8:	83 c4 10             	add    $0x10,%esp
  8019ab:	eb eb                	jmp    801998 <devsock_close+0x23>

008019ad <devsock_write>:
{
  8019ad:	f3 0f 1e fb          	endbr32 
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019b7:	6a 00                	push   $0x0
  8019b9:	ff 75 10             	pushl  0x10(%ebp)
  8019bc:	ff 75 0c             	pushl  0xc(%ebp)
  8019bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c2:	ff 70 0c             	pushl  0xc(%eax)
  8019c5:	e8 b5 03 00 00       	call   801d7f <nsipc_send>
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <devsock_read>:
{
  8019cc:	f3 0f 1e fb          	endbr32 
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019d6:	6a 00                	push   $0x0
  8019d8:	ff 75 10             	pushl  0x10(%ebp)
  8019db:	ff 75 0c             	pushl  0xc(%ebp)
  8019de:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e1:	ff 70 0c             	pushl  0xc(%eax)
  8019e4:	e8 1f 03 00 00       	call   801d08 <nsipc_recv>
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <fd2sockid>:
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019f1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019f4:	52                   	push   %edx
  8019f5:	50                   	push   %eax
  8019f6:	e8 6e f6 ff ff       	call   801069 <fd_lookup>
  8019fb:	83 c4 10             	add    $0x10,%esp
  8019fe:	85 c0                	test   %eax,%eax
  801a00:	78 10                	js     801a12 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a05:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  801a0b:	39 08                	cmp    %ecx,(%eax)
  801a0d:	75 05                	jne    801a14 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a0f:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    
		return -E_NOT_SUPP;
  801a14:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a19:	eb f7                	jmp    801a12 <fd2sockid+0x27>

00801a1b <alloc_sockfd>:
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
  801a1e:	56                   	push   %esi
  801a1f:	53                   	push   %ebx
  801a20:	83 ec 1c             	sub    $0x1c,%esp
  801a23:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a25:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a28:	50                   	push   %eax
  801a29:	e8 e5 f5 ff ff       	call   801013 <fd_alloc>
  801a2e:	89 c3                	mov    %eax,%ebx
  801a30:	83 c4 10             	add    $0x10,%esp
  801a33:	85 c0                	test   %eax,%eax
  801a35:	78 43                	js     801a7a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a37:	83 ec 04             	sub    $0x4,%esp
  801a3a:	68 07 04 00 00       	push   $0x407
  801a3f:	ff 75 f4             	pushl  -0xc(%ebp)
  801a42:	6a 00                	push   $0x0
  801a44:	e8 db f2 ff ff       	call   800d24 <sys_page_alloc>
  801a49:	89 c3                	mov    %eax,%ebx
  801a4b:	83 c4 10             	add    $0x10,%esp
  801a4e:	85 c0                	test   %eax,%eax
  801a50:	78 28                	js     801a7a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a55:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801a5b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a60:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a67:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a6a:	83 ec 0c             	sub    $0xc,%esp
  801a6d:	50                   	push   %eax
  801a6e:	e8 71 f5 ff ff       	call   800fe4 <fd2num>
  801a73:	89 c3                	mov    %eax,%ebx
  801a75:	83 c4 10             	add    $0x10,%esp
  801a78:	eb 0c                	jmp    801a86 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a7a:	83 ec 0c             	sub    $0xc,%esp
  801a7d:	56                   	push   %esi
  801a7e:	e8 08 02 00 00       	call   801c8b <nsipc_close>
		return r;
  801a83:	83 c4 10             	add    $0x10,%esp
}
  801a86:	89 d8                	mov    %ebx,%eax
  801a88:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a8b:	5b                   	pop    %ebx
  801a8c:	5e                   	pop    %esi
  801a8d:	5d                   	pop    %ebp
  801a8e:	c3                   	ret    

00801a8f <accept>:
{
  801a8f:	f3 0f 1e fb          	endbr32 
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	e8 4a ff ff ff       	call   8019eb <fd2sockid>
  801aa1:	85 c0                	test   %eax,%eax
  801aa3:	78 1b                	js     801ac0 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801aa5:	83 ec 04             	sub    $0x4,%esp
  801aa8:	ff 75 10             	pushl  0x10(%ebp)
  801aab:	ff 75 0c             	pushl  0xc(%ebp)
  801aae:	50                   	push   %eax
  801aaf:	e8 22 01 00 00       	call   801bd6 <nsipc_accept>
  801ab4:	83 c4 10             	add    $0x10,%esp
  801ab7:	85 c0                	test   %eax,%eax
  801ab9:	78 05                	js     801ac0 <accept+0x31>
	return alloc_sockfd(r);
  801abb:	e8 5b ff ff ff       	call   801a1b <alloc_sockfd>
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <bind>:
{
  801ac2:	f3 0f 1e fb          	endbr32 
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	e8 17 ff ff ff       	call   8019eb <fd2sockid>
  801ad4:	85 c0                	test   %eax,%eax
  801ad6:	78 12                	js     801aea <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801ad8:	83 ec 04             	sub    $0x4,%esp
  801adb:	ff 75 10             	pushl  0x10(%ebp)
  801ade:	ff 75 0c             	pushl  0xc(%ebp)
  801ae1:	50                   	push   %eax
  801ae2:	e8 45 01 00 00       	call   801c2c <nsipc_bind>
  801ae7:	83 c4 10             	add    $0x10,%esp
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <shutdown>:
{
  801aec:	f3 0f 1e fb          	endbr32 
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	e8 ed fe ff ff       	call   8019eb <fd2sockid>
  801afe:	85 c0                	test   %eax,%eax
  801b00:	78 0f                	js     801b11 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801b02:	83 ec 08             	sub    $0x8,%esp
  801b05:	ff 75 0c             	pushl  0xc(%ebp)
  801b08:	50                   	push   %eax
  801b09:	e8 57 01 00 00       	call   801c65 <nsipc_shutdown>
  801b0e:	83 c4 10             	add    $0x10,%esp
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <connect>:
{
  801b13:	f3 0f 1e fb          	endbr32 
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
  801b1a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	e8 c6 fe ff ff       	call   8019eb <fd2sockid>
  801b25:	85 c0                	test   %eax,%eax
  801b27:	78 12                	js     801b3b <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801b29:	83 ec 04             	sub    $0x4,%esp
  801b2c:	ff 75 10             	pushl  0x10(%ebp)
  801b2f:	ff 75 0c             	pushl  0xc(%ebp)
  801b32:	50                   	push   %eax
  801b33:	e8 71 01 00 00       	call   801ca9 <nsipc_connect>
  801b38:	83 c4 10             	add    $0x10,%esp
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <listen>:
{
  801b3d:	f3 0f 1e fb          	endbr32 
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	e8 9c fe ff ff       	call   8019eb <fd2sockid>
  801b4f:	85 c0                	test   %eax,%eax
  801b51:	78 0f                	js     801b62 <listen+0x25>
	return nsipc_listen(r, backlog);
  801b53:	83 ec 08             	sub    $0x8,%esp
  801b56:	ff 75 0c             	pushl  0xc(%ebp)
  801b59:	50                   	push   %eax
  801b5a:	e8 83 01 00 00       	call   801ce2 <nsipc_listen>
  801b5f:	83 c4 10             	add    $0x10,%esp
}
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <socket>:

int
socket(int domain, int type, int protocol)
{
  801b64:	f3 0f 1e fb          	endbr32 
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b6e:	ff 75 10             	pushl  0x10(%ebp)
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	ff 75 08             	pushl  0x8(%ebp)
  801b77:	e8 65 02 00 00       	call   801de1 <nsipc_socket>
  801b7c:	83 c4 10             	add    $0x10,%esp
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	78 05                	js     801b88 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801b83:	e8 93 fe ff ff       	call   801a1b <alloc_sockfd>
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
  801b8d:	53                   	push   %ebx
  801b8e:	83 ec 04             	sub    $0x4,%esp
  801b91:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b93:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  801b9a:	74 26                	je     801bc2 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b9c:	6a 07                	push   $0x7
  801b9e:	68 00 60 80 00       	push   $0x806000
  801ba3:	53                   	push   %ebx
  801ba4:	ff 35 08 40 80 00    	pushl  0x804008
  801baa:	e8 e0 07 00 00       	call   80238f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801baf:	83 c4 0c             	add    $0xc,%esp
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	e8 4d 07 00 00       	call   80230a <ipc_recv>
}
  801bbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bc2:	83 ec 0c             	sub    $0xc,%esp
  801bc5:	6a 02                	push   $0x2
  801bc7:	e8 1b 08 00 00       	call   8023e7 <ipc_find_env>
  801bcc:	a3 08 40 80 00       	mov    %eax,0x804008
  801bd1:	83 c4 10             	add    $0x10,%esp
  801bd4:	eb c6                	jmp    801b9c <nsipc+0x12>

00801bd6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bd6:	f3 0f 1e fb          	endbr32 
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	56                   	push   %esi
  801bde:	53                   	push   %ebx
  801bdf:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801be2:	8b 45 08             	mov    0x8(%ebp),%eax
  801be5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801bea:	8b 06                	mov    (%esi),%eax
  801bec:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801bf1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf6:	e8 8f ff ff ff       	call   801b8a <nsipc>
  801bfb:	89 c3                	mov    %eax,%ebx
  801bfd:	85 c0                	test   %eax,%eax
  801bff:	79 09                	jns    801c0a <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801c01:	89 d8                	mov    %ebx,%eax
  801c03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c06:	5b                   	pop    %ebx
  801c07:	5e                   	pop    %esi
  801c08:	5d                   	pop    %ebp
  801c09:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c0a:	83 ec 04             	sub    $0x4,%esp
  801c0d:	ff 35 10 60 80 00    	pushl  0x806010
  801c13:	68 00 60 80 00       	push   $0x806000
  801c18:	ff 75 0c             	pushl  0xc(%ebp)
  801c1b:	e8 78 ee ff ff       	call   800a98 <memmove>
		*addrlen = ret->ret_addrlen;
  801c20:	a1 10 60 80 00       	mov    0x806010,%eax
  801c25:	89 06                	mov    %eax,(%esi)
  801c27:	83 c4 10             	add    $0x10,%esp
	return r;
  801c2a:	eb d5                	jmp    801c01 <nsipc_accept+0x2b>

00801c2c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c2c:	f3 0f 1e fb          	endbr32 
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	53                   	push   %ebx
  801c34:	83 ec 08             	sub    $0x8,%esp
  801c37:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c42:	53                   	push   %ebx
  801c43:	ff 75 0c             	pushl  0xc(%ebp)
  801c46:	68 04 60 80 00       	push   $0x806004
  801c4b:	e8 48 ee ff ff       	call   800a98 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c50:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c56:	b8 02 00 00 00       	mov    $0x2,%eax
  801c5b:	e8 2a ff ff ff       	call   801b8a <nsipc>
}
  801c60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c65:	f3 0f 1e fb          	endbr32 
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c72:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c77:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c7a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c7f:	b8 03 00 00 00       	mov    $0x3,%eax
  801c84:	e8 01 ff ff ff       	call   801b8a <nsipc>
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <nsipc_close>:

int
nsipc_close(int s)
{
  801c8b:	f3 0f 1e fb          	endbr32 
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c95:	8b 45 08             	mov    0x8(%ebp),%eax
  801c98:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c9d:	b8 04 00 00 00       	mov    $0x4,%eax
  801ca2:	e8 e3 fe ff ff       	call   801b8a <nsipc>
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ca9:	f3 0f 1e fb          	endbr32 
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	53                   	push   %ebx
  801cb1:	83 ec 08             	sub    $0x8,%esp
  801cb4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801cbf:	53                   	push   %ebx
  801cc0:	ff 75 0c             	pushl  0xc(%ebp)
  801cc3:	68 04 60 80 00       	push   $0x806004
  801cc8:	e8 cb ed ff ff       	call   800a98 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ccd:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801cd3:	b8 05 00 00 00       	mov    $0x5,%eax
  801cd8:	e8 ad fe ff ff       	call   801b8a <nsipc>
}
  801cdd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ce2:	f3 0f 1e fb          	endbr32 
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801cec:	8b 45 08             	mov    0x8(%ebp),%eax
  801cef:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801cf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf7:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801cfc:	b8 06 00 00 00       	mov    $0x6,%eax
  801d01:	e8 84 fe ff ff       	call   801b8a <nsipc>
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d08:	f3 0f 1e fb          	endbr32 
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	56                   	push   %esi
  801d10:	53                   	push   %ebx
  801d11:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d1c:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d22:	8b 45 14             	mov    0x14(%ebp),%eax
  801d25:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d2a:	b8 07 00 00 00       	mov    $0x7,%eax
  801d2f:	e8 56 fe ff ff       	call   801b8a <nsipc>
  801d34:	89 c3                	mov    %eax,%ebx
  801d36:	85 c0                	test   %eax,%eax
  801d38:	78 26                	js     801d60 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801d3a:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801d40:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801d45:	0f 4e c6             	cmovle %esi,%eax
  801d48:	39 c3                	cmp    %eax,%ebx
  801d4a:	7f 1d                	jg     801d69 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d4c:	83 ec 04             	sub    $0x4,%esp
  801d4f:	53                   	push   %ebx
  801d50:	68 00 60 80 00       	push   $0x806000
  801d55:	ff 75 0c             	pushl  0xc(%ebp)
  801d58:	e8 3b ed ff ff       	call   800a98 <memmove>
  801d5d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d60:	89 d8                	mov    %ebx,%eax
  801d62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d65:	5b                   	pop    %ebx
  801d66:	5e                   	pop    %esi
  801d67:	5d                   	pop    %ebp
  801d68:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d69:	68 5b 2b 80 00       	push   $0x802b5b
  801d6e:	68 23 2b 80 00       	push   $0x802b23
  801d73:	6a 62                	push   $0x62
  801d75:	68 70 2b 80 00       	push   $0x802b70
  801d7a:	e8 72 e4 ff ff       	call   8001f1 <_panic>

00801d7f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d7f:	f3 0f 1e fb          	endbr32 
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	53                   	push   %ebx
  801d87:	83 ec 04             	sub    $0x4,%esp
  801d8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d90:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d95:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d9b:	7f 2e                	jg     801dcb <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d9d:	83 ec 04             	sub    $0x4,%esp
  801da0:	53                   	push   %ebx
  801da1:	ff 75 0c             	pushl  0xc(%ebp)
  801da4:	68 0c 60 80 00       	push   $0x80600c
  801da9:	e8 ea ec ff ff       	call   800a98 <memmove>
	nsipcbuf.send.req_size = size;
  801dae:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801db4:	8b 45 14             	mov    0x14(%ebp),%eax
  801db7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801dbc:	b8 08 00 00 00       	mov    $0x8,%eax
  801dc1:	e8 c4 fd ff ff       	call   801b8a <nsipc>
}
  801dc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    
	assert(size < 1600);
  801dcb:	68 7c 2b 80 00       	push   $0x802b7c
  801dd0:	68 23 2b 80 00       	push   $0x802b23
  801dd5:	6a 6d                	push   $0x6d
  801dd7:	68 70 2b 80 00       	push   $0x802b70
  801ddc:	e8 10 e4 ff ff       	call   8001f1 <_panic>

00801de1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801de1:	f3 0f 1e fb          	endbr32 
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801deb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dee:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801df3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df6:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801dfb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dfe:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e03:	b8 09 00 00 00       	mov    $0x9,%eax
  801e08:	e8 7d fd ff ff       	call   801b8a <nsipc>
}
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    

00801e0f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e0f:	f3 0f 1e fb          	endbr32 
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	56                   	push   %esi
  801e17:	53                   	push   %ebx
  801e18:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e1b:	83 ec 0c             	sub    $0xc,%esp
  801e1e:	ff 75 08             	pushl  0x8(%ebp)
  801e21:	e8 d2 f1 ff ff       	call   800ff8 <fd2data>
  801e26:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e28:	83 c4 08             	add    $0x8,%esp
  801e2b:	68 88 2b 80 00       	push   $0x802b88
  801e30:	53                   	push   %ebx
  801e31:	e8 ac ea ff ff       	call   8008e2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e36:	8b 46 04             	mov    0x4(%esi),%eax
  801e39:	2b 06                	sub    (%esi),%eax
  801e3b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e41:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e48:	00 00 00 
	stat->st_dev = &devpipe;
  801e4b:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  801e52:	30 80 00 
	return 0;
}
  801e55:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e5d:	5b                   	pop    %ebx
  801e5e:	5e                   	pop    %esi
  801e5f:	5d                   	pop    %ebp
  801e60:	c3                   	ret    

00801e61 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e61:	f3 0f 1e fb          	endbr32 
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
  801e68:	53                   	push   %ebx
  801e69:	83 ec 0c             	sub    $0xc,%esp
  801e6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e6f:	53                   	push   %ebx
  801e70:	6a 00                	push   $0x0
  801e72:	e8 3a ef ff ff       	call   800db1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e77:	89 1c 24             	mov    %ebx,(%esp)
  801e7a:	e8 79 f1 ff ff       	call   800ff8 <fd2data>
  801e7f:	83 c4 08             	add    $0x8,%esp
  801e82:	50                   	push   %eax
  801e83:	6a 00                	push   $0x0
  801e85:	e8 27 ef ff ff       	call   800db1 <sys_page_unmap>
}
  801e8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <_pipeisclosed>:
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	57                   	push   %edi
  801e93:	56                   	push   %esi
  801e94:	53                   	push   %ebx
  801e95:	83 ec 1c             	sub    $0x1c,%esp
  801e98:	89 c7                	mov    %eax,%edi
  801e9a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e9c:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801ea1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ea4:	83 ec 0c             	sub    $0xc,%esp
  801ea7:	57                   	push   %edi
  801ea8:	e8 77 05 00 00       	call   802424 <pageref>
  801ead:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801eb0:	89 34 24             	mov    %esi,(%esp)
  801eb3:	e8 6c 05 00 00       	call   802424 <pageref>
		nn = thisenv->env_runs;
  801eb8:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801ebe:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ec1:	83 c4 10             	add    $0x10,%esp
  801ec4:	39 cb                	cmp    %ecx,%ebx
  801ec6:	74 1b                	je     801ee3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ec8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ecb:	75 cf                	jne    801e9c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ecd:	8b 42 58             	mov    0x58(%edx),%eax
  801ed0:	6a 01                	push   $0x1
  801ed2:	50                   	push   %eax
  801ed3:	53                   	push   %ebx
  801ed4:	68 8f 2b 80 00       	push   $0x802b8f
  801ed9:	e8 fa e3 ff ff       	call   8002d8 <cprintf>
  801ede:	83 c4 10             	add    $0x10,%esp
  801ee1:	eb b9                	jmp    801e9c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801ee3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ee6:	0f 94 c0             	sete   %al
  801ee9:	0f b6 c0             	movzbl %al,%eax
}
  801eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eef:	5b                   	pop    %ebx
  801ef0:	5e                   	pop    %esi
  801ef1:	5f                   	pop    %edi
  801ef2:	5d                   	pop    %ebp
  801ef3:	c3                   	ret    

00801ef4 <devpipe_write>:
{
  801ef4:	f3 0f 1e fb          	endbr32 
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	57                   	push   %edi
  801efc:	56                   	push   %esi
  801efd:	53                   	push   %ebx
  801efe:	83 ec 28             	sub    $0x28,%esp
  801f01:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f04:	56                   	push   %esi
  801f05:	e8 ee f0 ff ff       	call   800ff8 <fd2data>
  801f0a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f0c:	83 c4 10             	add    $0x10,%esp
  801f0f:	bf 00 00 00 00       	mov    $0x0,%edi
  801f14:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f17:	74 4f                	je     801f68 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f19:	8b 43 04             	mov    0x4(%ebx),%eax
  801f1c:	8b 0b                	mov    (%ebx),%ecx
  801f1e:	8d 51 20             	lea    0x20(%ecx),%edx
  801f21:	39 d0                	cmp    %edx,%eax
  801f23:	72 14                	jb     801f39 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801f25:	89 da                	mov    %ebx,%edx
  801f27:	89 f0                	mov    %esi,%eax
  801f29:	e8 61 ff ff ff       	call   801e8f <_pipeisclosed>
  801f2e:	85 c0                	test   %eax,%eax
  801f30:	75 3b                	jne    801f6d <devpipe_write+0x79>
			sys_yield();
  801f32:	e8 ca ed ff ff       	call   800d01 <sys_yield>
  801f37:	eb e0                	jmp    801f19 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f3c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f40:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f43:	89 c2                	mov    %eax,%edx
  801f45:	c1 fa 1f             	sar    $0x1f,%edx
  801f48:	89 d1                	mov    %edx,%ecx
  801f4a:	c1 e9 1b             	shr    $0x1b,%ecx
  801f4d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f50:	83 e2 1f             	and    $0x1f,%edx
  801f53:	29 ca                	sub    %ecx,%edx
  801f55:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f59:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f5d:	83 c0 01             	add    $0x1,%eax
  801f60:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f63:	83 c7 01             	add    $0x1,%edi
  801f66:	eb ac                	jmp    801f14 <devpipe_write+0x20>
	return i;
  801f68:	8b 45 10             	mov    0x10(%ebp),%eax
  801f6b:	eb 05                	jmp    801f72 <devpipe_write+0x7e>
				return 0;
  801f6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f75:	5b                   	pop    %ebx
  801f76:	5e                   	pop    %esi
  801f77:	5f                   	pop    %edi
  801f78:	5d                   	pop    %ebp
  801f79:	c3                   	ret    

00801f7a <devpipe_read>:
{
  801f7a:	f3 0f 1e fb          	endbr32 
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
  801f81:	57                   	push   %edi
  801f82:	56                   	push   %esi
  801f83:	53                   	push   %ebx
  801f84:	83 ec 18             	sub    $0x18,%esp
  801f87:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f8a:	57                   	push   %edi
  801f8b:	e8 68 f0 ff ff       	call   800ff8 <fd2data>
  801f90:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f92:	83 c4 10             	add    $0x10,%esp
  801f95:	be 00 00 00 00       	mov    $0x0,%esi
  801f9a:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f9d:	75 14                	jne    801fb3 <devpipe_read+0x39>
	return i;
  801f9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa2:	eb 02                	jmp    801fa6 <devpipe_read+0x2c>
				return i;
  801fa4:	89 f0                	mov    %esi,%eax
}
  801fa6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fa9:	5b                   	pop    %ebx
  801faa:	5e                   	pop    %esi
  801fab:	5f                   	pop    %edi
  801fac:	5d                   	pop    %ebp
  801fad:	c3                   	ret    
			sys_yield();
  801fae:	e8 4e ed ff ff       	call   800d01 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801fb3:	8b 03                	mov    (%ebx),%eax
  801fb5:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fb8:	75 18                	jne    801fd2 <devpipe_read+0x58>
			if (i > 0)
  801fba:	85 f6                	test   %esi,%esi
  801fbc:	75 e6                	jne    801fa4 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801fbe:	89 da                	mov    %ebx,%edx
  801fc0:	89 f8                	mov    %edi,%eax
  801fc2:	e8 c8 fe ff ff       	call   801e8f <_pipeisclosed>
  801fc7:	85 c0                	test   %eax,%eax
  801fc9:	74 e3                	je     801fae <devpipe_read+0x34>
				return 0;
  801fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd0:	eb d4                	jmp    801fa6 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801fd2:	99                   	cltd   
  801fd3:	c1 ea 1b             	shr    $0x1b,%edx
  801fd6:	01 d0                	add    %edx,%eax
  801fd8:	83 e0 1f             	and    $0x1f,%eax
  801fdb:	29 d0                	sub    %edx,%eax
  801fdd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801fe2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fe5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801fe8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801feb:	83 c6 01             	add    $0x1,%esi
  801fee:	eb aa                	jmp    801f9a <devpipe_read+0x20>

00801ff0 <pipe>:
{
  801ff0:	f3 0f 1e fb          	endbr32 
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	56                   	push   %esi
  801ff8:	53                   	push   %ebx
  801ff9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ffc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fff:	50                   	push   %eax
  802000:	e8 0e f0 ff ff       	call   801013 <fd_alloc>
  802005:	89 c3                	mov    %eax,%ebx
  802007:	83 c4 10             	add    $0x10,%esp
  80200a:	85 c0                	test   %eax,%eax
  80200c:	0f 88 23 01 00 00    	js     802135 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802012:	83 ec 04             	sub    $0x4,%esp
  802015:	68 07 04 00 00       	push   $0x407
  80201a:	ff 75 f4             	pushl  -0xc(%ebp)
  80201d:	6a 00                	push   $0x0
  80201f:	e8 00 ed ff ff       	call   800d24 <sys_page_alloc>
  802024:	89 c3                	mov    %eax,%ebx
  802026:	83 c4 10             	add    $0x10,%esp
  802029:	85 c0                	test   %eax,%eax
  80202b:	0f 88 04 01 00 00    	js     802135 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802031:	83 ec 0c             	sub    $0xc,%esp
  802034:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802037:	50                   	push   %eax
  802038:	e8 d6 ef ff ff       	call   801013 <fd_alloc>
  80203d:	89 c3                	mov    %eax,%ebx
  80203f:	83 c4 10             	add    $0x10,%esp
  802042:	85 c0                	test   %eax,%eax
  802044:	0f 88 db 00 00 00    	js     802125 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80204a:	83 ec 04             	sub    $0x4,%esp
  80204d:	68 07 04 00 00       	push   $0x407
  802052:	ff 75 f0             	pushl  -0x10(%ebp)
  802055:	6a 00                	push   $0x0
  802057:	e8 c8 ec ff ff       	call   800d24 <sys_page_alloc>
  80205c:	89 c3                	mov    %eax,%ebx
  80205e:	83 c4 10             	add    $0x10,%esp
  802061:	85 c0                	test   %eax,%eax
  802063:	0f 88 bc 00 00 00    	js     802125 <pipe+0x135>
	va = fd2data(fd0);
  802069:	83 ec 0c             	sub    $0xc,%esp
  80206c:	ff 75 f4             	pushl  -0xc(%ebp)
  80206f:	e8 84 ef ff ff       	call   800ff8 <fd2data>
  802074:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802076:	83 c4 0c             	add    $0xc,%esp
  802079:	68 07 04 00 00       	push   $0x407
  80207e:	50                   	push   %eax
  80207f:	6a 00                	push   $0x0
  802081:	e8 9e ec ff ff       	call   800d24 <sys_page_alloc>
  802086:	89 c3                	mov    %eax,%ebx
  802088:	83 c4 10             	add    $0x10,%esp
  80208b:	85 c0                	test   %eax,%eax
  80208d:	0f 88 82 00 00 00    	js     802115 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802093:	83 ec 0c             	sub    $0xc,%esp
  802096:	ff 75 f0             	pushl  -0x10(%ebp)
  802099:	e8 5a ef ff ff       	call   800ff8 <fd2data>
  80209e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8020a5:	50                   	push   %eax
  8020a6:	6a 00                	push   $0x0
  8020a8:	56                   	push   %esi
  8020a9:	6a 00                	push   $0x0
  8020ab:	e8 bb ec ff ff       	call   800d6b <sys_page_map>
  8020b0:	89 c3                	mov    %eax,%ebx
  8020b2:	83 c4 20             	add    $0x20,%esp
  8020b5:	85 c0                	test   %eax,%eax
  8020b7:	78 4e                	js     802107 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8020b9:	a1 40 30 80 00       	mov    0x803040,%eax
  8020be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c1:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8020c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c6:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8020cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020d0:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8020d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8020dc:	83 ec 0c             	sub    $0xc,%esp
  8020df:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e2:	e8 fd ee ff ff       	call   800fe4 <fd2num>
  8020e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020ea:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8020ec:	83 c4 04             	add    $0x4,%esp
  8020ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8020f2:	e8 ed ee ff ff       	call   800fe4 <fd2num>
  8020f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020fa:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020fd:	83 c4 10             	add    $0x10,%esp
  802100:	bb 00 00 00 00       	mov    $0x0,%ebx
  802105:	eb 2e                	jmp    802135 <pipe+0x145>
	sys_page_unmap(0, va);
  802107:	83 ec 08             	sub    $0x8,%esp
  80210a:	56                   	push   %esi
  80210b:	6a 00                	push   $0x0
  80210d:	e8 9f ec ff ff       	call   800db1 <sys_page_unmap>
  802112:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802115:	83 ec 08             	sub    $0x8,%esp
  802118:	ff 75 f0             	pushl  -0x10(%ebp)
  80211b:	6a 00                	push   $0x0
  80211d:	e8 8f ec ff ff       	call   800db1 <sys_page_unmap>
  802122:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802125:	83 ec 08             	sub    $0x8,%esp
  802128:	ff 75 f4             	pushl  -0xc(%ebp)
  80212b:	6a 00                	push   $0x0
  80212d:	e8 7f ec ff ff       	call   800db1 <sys_page_unmap>
  802132:	83 c4 10             	add    $0x10,%esp
}
  802135:	89 d8                	mov    %ebx,%eax
  802137:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80213a:	5b                   	pop    %ebx
  80213b:	5e                   	pop    %esi
  80213c:	5d                   	pop    %ebp
  80213d:	c3                   	ret    

0080213e <pipeisclosed>:
{
  80213e:	f3 0f 1e fb          	endbr32 
  802142:	55                   	push   %ebp
  802143:	89 e5                	mov    %esp,%ebp
  802145:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802148:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80214b:	50                   	push   %eax
  80214c:	ff 75 08             	pushl  0x8(%ebp)
  80214f:	e8 15 ef ff ff       	call   801069 <fd_lookup>
  802154:	83 c4 10             	add    $0x10,%esp
  802157:	85 c0                	test   %eax,%eax
  802159:	78 18                	js     802173 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80215b:	83 ec 0c             	sub    $0xc,%esp
  80215e:	ff 75 f4             	pushl  -0xc(%ebp)
  802161:	e8 92 ee ff ff       	call   800ff8 <fd2data>
  802166:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	e8 1f fd ff ff       	call   801e8f <_pipeisclosed>
  802170:	83 c4 10             	add    $0x10,%esp
}
  802173:	c9                   	leave  
  802174:	c3                   	ret    

00802175 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802175:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802179:	b8 00 00 00 00       	mov    $0x0,%eax
  80217e:	c3                   	ret    

0080217f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80217f:	f3 0f 1e fb          	endbr32 
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
  802186:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802189:	68 a7 2b 80 00       	push   $0x802ba7
  80218e:	ff 75 0c             	pushl  0xc(%ebp)
  802191:	e8 4c e7 ff ff       	call   8008e2 <strcpy>
	return 0;
}
  802196:	b8 00 00 00 00       	mov    $0x0,%eax
  80219b:	c9                   	leave  
  80219c:	c3                   	ret    

0080219d <devcons_write>:
{
  80219d:	f3 0f 1e fb          	endbr32 
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
  8021a4:	57                   	push   %edi
  8021a5:	56                   	push   %esi
  8021a6:	53                   	push   %ebx
  8021a7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8021ad:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8021b2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8021b8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021bb:	73 31                	jae    8021ee <devcons_write+0x51>
		m = n - tot;
  8021bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021c0:	29 f3                	sub    %esi,%ebx
  8021c2:	83 fb 7f             	cmp    $0x7f,%ebx
  8021c5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8021ca:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021cd:	83 ec 04             	sub    $0x4,%esp
  8021d0:	53                   	push   %ebx
  8021d1:	89 f0                	mov    %esi,%eax
  8021d3:	03 45 0c             	add    0xc(%ebp),%eax
  8021d6:	50                   	push   %eax
  8021d7:	57                   	push   %edi
  8021d8:	e8 bb e8 ff ff       	call   800a98 <memmove>
		sys_cputs(buf, m);
  8021dd:	83 c4 08             	add    $0x8,%esp
  8021e0:	53                   	push   %ebx
  8021e1:	57                   	push   %edi
  8021e2:	e8 6d ea ff ff       	call   800c54 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8021e7:	01 de                	add    %ebx,%esi
  8021e9:	83 c4 10             	add    $0x10,%esp
  8021ec:	eb ca                	jmp    8021b8 <devcons_write+0x1b>
}
  8021ee:	89 f0                	mov    %esi,%eax
  8021f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021f3:	5b                   	pop    %ebx
  8021f4:	5e                   	pop    %esi
  8021f5:	5f                   	pop    %edi
  8021f6:	5d                   	pop    %ebp
  8021f7:	c3                   	ret    

008021f8 <devcons_read>:
{
  8021f8:	f3 0f 1e fb          	endbr32 
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
  8021ff:	83 ec 08             	sub    $0x8,%esp
  802202:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802207:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80220b:	74 21                	je     80222e <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80220d:	e8 64 ea ff ff       	call   800c76 <sys_cgetc>
  802212:	85 c0                	test   %eax,%eax
  802214:	75 07                	jne    80221d <devcons_read+0x25>
		sys_yield();
  802216:	e8 e6 ea ff ff       	call   800d01 <sys_yield>
  80221b:	eb f0                	jmp    80220d <devcons_read+0x15>
	if (c < 0)
  80221d:	78 0f                	js     80222e <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80221f:	83 f8 04             	cmp    $0x4,%eax
  802222:	74 0c                	je     802230 <devcons_read+0x38>
	*(char*)vbuf = c;
  802224:	8b 55 0c             	mov    0xc(%ebp),%edx
  802227:	88 02                	mov    %al,(%edx)
	return 1;
  802229:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80222e:	c9                   	leave  
  80222f:	c3                   	ret    
		return 0;
  802230:	b8 00 00 00 00       	mov    $0x0,%eax
  802235:	eb f7                	jmp    80222e <devcons_read+0x36>

00802237 <cputchar>:
{
  802237:	f3 0f 1e fb          	endbr32 
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
  80223e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802241:	8b 45 08             	mov    0x8(%ebp),%eax
  802244:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802247:	6a 01                	push   $0x1
  802249:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80224c:	50                   	push   %eax
  80224d:	e8 02 ea ff ff       	call   800c54 <sys_cputs>
}
  802252:	83 c4 10             	add    $0x10,%esp
  802255:	c9                   	leave  
  802256:	c3                   	ret    

00802257 <getchar>:
{
  802257:	f3 0f 1e fb          	endbr32 
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802261:	6a 01                	push   $0x1
  802263:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802266:	50                   	push   %eax
  802267:	6a 00                	push   $0x0
  802269:	e8 83 f0 ff ff       	call   8012f1 <read>
	if (r < 0)
  80226e:	83 c4 10             	add    $0x10,%esp
  802271:	85 c0                	test   %eax,%eax
  802273:	78 06                	js     80227b <getchar+0x24>
	if (r < 1)
  802275:	74 06                	je     80227d <getchar+0x26>
	return c;
  802277:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    
		return -E_EOF;
  80227d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802282:	eb f7                	jmp    80227b <getchar+0x24>

00802284 <iscons>:
{
  802284:	f3 0f 1e fb          	endbr32 
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80228e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802291:	50                   	push   %eax
  802292:	ff 75 08             	pushl  0x8(%ebp)
  802295:	e8 cf ed ff ff       	call   801069 <fd_lookup>
  80229a:	83 c4 10             	add    $0x10,%esp
  80229d:	85 c0                	test   %eax,%eax
  80229f:	78 11                	js     8022b2 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8022a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a4:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8022aa:	39 10                	cmp    %edx,(%eax)
  8022ac:	0f 94 c0             	sete   %al
  8022af:	0f b6 c0             	movzbl %al,%eax
}
  8022b2:	c9                   	leave  
  8022b3:	c3                   	ret    

008022b4 <opencons>:
{
  8022b4:	f3 0f 1e fb          	endbr32 
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8022be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022c1:	50                   	push   %eax
  8022c2:	e8 4c ed ff ff       	call   801013 <fd_alloc>
  8022c7:	83 c4 10             	add    $0x10,%esp
  8022ca:	85 c0                	test   %eax,%eax
  8022cc:	78 3a                	js     802308 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022ce:	83 ec 04             	sub    $0x4,%esp
  8022d1:	68 07 04 00 00       	push   $0x407
  8022d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8022d9:	6a 00                	push   $0x0
  8022db:	e8 44 ea ff ff       	call   800d24 <sys_page_alloc>
  8022e0:	83 c4 10             	add    $0x10,%esp
  8022e3:	85 c0                	test   %eax,%eax
  8022e5:	78 21                	js     802308 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8022f0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022fc:	83 ec 0c             	sub    $0xc,%esp
  8022ff:	50                   	push   %eax
  802300:	e8 df ec ff ff       	call   800fe4 <fd2num>
  802305:	83 c4 10             	add    $0x10,%esp
}
  802308:	c9                   	leave  
  802309:	c3                   	ret    

0080230a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80230a:	f3 0f 1e fb          	endbr32 
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
  802311:	56                   	push   %esi
  802312:	53                   	push   %ebx
  802313:	8b 75 08             	mov    0x8(%ebp),%esi
  802316:	8b 45 0c             	mov    0xc(%ebp),%eax
  802319:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  80231c:	85 c0                	test   %eax,%eax
  80231e:	74 3d                	je     80235d <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  802320:	83 ec 0c             	sub    $0xc,%esp
  802323:	50                   	push   %eax
  802324:	e8 c7 eb ff ff       	call   800ef0 <sys_ipc_recv>
  802329:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  80232c:	85 f6                	test   %esi,%esi
  80232e:	74 0b                	je     80233b <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802330:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  802336:	8b 52 74             	mov    0x74(%edx),%edx
  802339:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  80233b:	85 db                	test   %ebx,%ebx
  80233d:	74 0b                	je     80234a <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  80233f:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  802345:	8b 52 78             	mov    0x78(%edx),%edx
  802348:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  80234a:	85 c0                	test   %eax,%eax
  80234c:	78 21                	js     80236f <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  80234e:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802353:	8b 40 70             	mov    0x70(%eax),%eax
}
  802356:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802359:	5b                   	pop    %ebx
  80235a:	5e                   	pop    %esi
  80235b:	5d                   	pop    %ebp
  80235c:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  80235d:	83 ec 0c             	sub    $0xc,%esp
  802360:	68 00 00 c0 ee       	push   $0xeec00000
  802365:	e8 86 eb ff ff       	call   800ef0 <sys_ipc_recv>
  80236a:	83 c4 10             	add    $0x10,%esp
  80236d:	eb bd                	jmp    80232c <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  80236f:	85 f6                	test   %esi,%esi
  802371:	74 10                	je     802383 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802373:	85 db                	test   %ebx,%ebx
  802375:	75 df                	jne    802356 <ipc_recv+0x4c>
  802377:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80237e:	00 00 00 
  802381:	eb d3                	jmp    802356 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802383:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80238a:	00 00 00 
  80238d:	eb e4                	jmp    802373 <ipc_recv+0x69>

0080238f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80238f:	f3 0f 1e fb          	endbr32 
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
  802396:	57                   	push   %edi
  802397:	56                   	push   %esi
  802398:	53                   	push   %ebx
  802399:	83 ec 0c             	sub    $0xc,%esp
  80239c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80239f:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  8023a5:	85 db                	test   %ebx,%ebx
  8023a7:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8023ac:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8023af:	ff 75 14             	pushl  0x14(%ebp)
  8023b2:	53                   	push   %ebx
  8023b3:	56                   	push   %esi
  8023b4:	57                   	push   %edi
  8023b5:	e8 0f eb ff ff       	call   800ec9 <sys_ipc_try_send>
  8023ba:	83 c4 10             	add    $0x10,%esp
  8023bd:	85 c0                	test   %eax,%eax
  8023bf:	79 1e                	jns    8023df <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  8023c1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023c4:	75 07                	jne    8023cd <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  8023c6:	e8 36 e9 ff ff       	call   800d01 <sys_yield>
  8023cb:	eb e2                	jmp    8023af <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  8023cd:	50                   	push   %eax
  8023ce:	68 b3 2b 80 00       	push   $0x802bb3
  8023d3:	6a 59                	push   $0x59
  8023d5:	68 ce 2b 80 00       	push   $0x802bce
  8023da:	e8 12 de ff ff       	call   8001f1 <_panic>
	}
}
  8023df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023e2:	5b                   	pop    %ebx
  8023e3:	5e                   	pop    %esi
  8023e4:	5f                   	pop    %edi
  8023e5:	5d                   	pop    %ebp
  8023e6:	c3                   	ret    

008023e7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023e7:	f3 0f 1e fb          	endbr32 
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
  8023ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023f1:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023f6:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8023f9:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023ff:	8b 52 50             	mov    0x50(%edx),%edx
  802402:	39 ca                	cmp    %ecx,%edx
  802404:	74 11                	je     802417 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802406:	83 c0 01             	add    $0x1,%eax
  802409:	3d 00 04 00 00       	cmp    $0x400,%eax
  80240e:	75 e6                	jne    8023f6 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802410:	b8 00 00 00 00       	mov    $0x0,%eax
  802415:	eb 0b                	jmp    802422 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802417:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80241a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80241f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802422:	5d                   	pop    %ebp
  802423:	c3                   	ret    

00802424 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802424:	f3 0f 1e fb          	endbr32 
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80242e:	89 c2                	mov    %eax,%edx
  802430:	c1 ea 16             	shr    $0x16,%edx
  802433:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80243a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80243f:	f6 c1 01             	test   $0x1,%cl
  802442:	74 1c                	je     802460 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802444:	c1 e8 0c             	shr    $0xc,%eax
  802447:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80244e:	a8 01                	test   $0x1,%al
  802450:	74 0e                	je     802460 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802452:	c1 e8 0c             	shr    $0xc,%eax
  802455:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80245c:	ef 
  80245d:	0f b7 d2             	movzwl %dx,%edx
}
  802460:	89 d0                	mov    %edx,%eax
  802462:	5d                   	pop    %ebp
  802463:	c3                   	ret    
  802464:	66 90                	xchg   %ax,%ax
  802466:	66 90                	xchg   %ax,%ax
  802468:	66 90                	xchg   %ax,%ax
  80246a:	66 90                	xchg   %ax,%ax
  80246c:	66 90                	xchg   %ax,%ax
  80246e:	66 90                	xchg   %ax,%ax

00802470 <__udivdi3>:
  802470:	f3 0f 1e fb          	endbr32 
  802474:	55                   	push   %ebp
  802475:	57                   	push   %edi
  802476:	56                   	push   %esi
  802477:	53                   	push   %ebx
  802478:	83 ec 1c             	sub    $0x1c,%esp
  80247b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80247f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802483:	8b 74 24 34          	mov    0x34(%esp),%esi
  802487:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80248b:	85 d2                	test   %edx,%edx
  80248d:	75 19                	jne    8024a8 <__udivdi3+0x38>
  80248f:	39 f3                	cmp    %esi,%ebx
  802491:	76 4d                	jbe    8024e0 <__udivdi3+0x70>
  802493:	31 ff                	xor    %edi,%edi
  802495:	89 e8                	mov    %ebp,%eax
  802497:	89 f2                	mov    %esi,%edx
  802499:	f7 f3                	div    %ebx
  80249b:	89 fa                	mov    %edi,%edx
  80249d:	83 c4 1c             	add    $0x1c,%esp
  8024a0:	5b                   	pop    %ebx
  8024a1:	5e                   	pop    %esi
  8024a2:	5f                   	pop    %edi
  8024a3:	5d                   	pop    %ebp
  8024a4:	c3                   	ret    
  8024a5:	8d 76 00             	lea    0x0(%esi),%esi
  8024a8:	39 f2                	cmp    %esi,%edx
  8024aa:	76 14                	jbe    8024c0 <__udivdi3+0x50>
  8024ac:	31 ff                	xor    %edi,%edi
  8024ae:	31 c0                	xor    %eax,%eax
  8024b0:	89 fa                	mov    %edi,%edx
  8024b2:	83 c4 1c             	add    $0x1c,%esp
  8024b5:	5b                   	pop    %ebx
  8024b6:	5e                   	pop    %esi
  8024b7:	5f                   	pop    %edi
  8024b8:	5d                   	pop    %ebp
  8024b9:	c3                   	ret    
  8024ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024c0:	0f bd fa             	bsr    %edx,%edi
  8024c3:	83 f7 1f             	xor    $0x1f,%edi
  8024c6:	75 48                	jne    802510 <__udivdi3+0xa0>
  8024c8:	39 f2                	cmp    %esi,%edx
  8024ca:	72 06                	jb     8024d2 <__udivdi3+0x62>
  8024cc:	31 c0                	xor    %eax,%eax
  8024ce:	39 eb                	cmp    %ebp,%ebx
  8024d0:	77 de                	ja     8024b0 <__udivdi3+0x40>
  8024d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8024d7:	eb d7                	jmp    8024b0 <__udivdi3+0x40>
  8024d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024e0:	89 d9                	mov    %ebx,%ecx
  8024e2:	85 db                	test   %ebx,%ebx
  8024e4:	75 0b                	jne    8024f1 <__udivdi3+0x81>
  8024e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8024eb:	31 d2                	xor    %edx,%edx
  8024ed:	f7 f3                	div    %ebx
  8024ef:	89 c1                	mov    %eax,%ecx
  8024f1:	31 d2                	xor    %edx,%edx
  8024f3:	89 f0                	mov    %esi,%eax
  8024f5:	f7 f1                	div    %ecx
  8024f7:	89 c6                	mov    %eax,%esi
  8024f9:	89 e8                	mov    %ebp,%eax
  8024fb:	89 f7                	mov    %esi,%edi
  8024fd:	f7 f1                	div    %ecx
  8024ff:	89 fa                	mov    %edi,%edx
  802501:	83 c4 1c             	add    $0x1c,%esp
  802504:	5b                   	pop    %ebx
  802505:	5e                   	pop    %esi
  802506:	5f                   	pop    %edi
  802507:	5d                   	pop    %ebp
  802508:	c3                   	ret    
  802509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802510:	89 f9                	mov    %edi,%ecx
  802512:	b8 20 00 00 00       	mov    $0x20,%eax
  802517:	29 f8                	sub    %edi,%eax
  802519:	d3 e2                	shl    %cl,%edx
  80251b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80251f:	89 c1                	mov    %eax,%ecx
  802521:	89 da                	mov    %ebx,%edx
  802523:	d3 ea                	shr    %cl,%edx
  802525:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802529:	09 d1                	or     %edx,%ecx
  80252b:	89 f2                	mov    %esi,%edx
  80252d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802531:	89 f9                	mov    %edi,%ecx
  802533:	d3 e3                	shl    %cl,%ebx
  802535:	89 c1                	mov    %eax,%ecx
  802537:	d3 ea                	shr    %cl,%edx
  802539:	89 f9                	mov    %edi,%ecx
  80253b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80253f:	89 eb                	mov    %ebp,%ebx
  802541:	d3 e6                	shl    %cl,%esi
  802543:	89 c1                	mov    %eax,%ecx
  802545:	d3 eb                	shr    %cl,%ebx
  802547:	09 de                	or     %ebx,%esi
  802549:	89 f0                	mov    %esi,%eax
  80254b:	f7 74 24 08          	divl   0x8(%esp)
  80254f:	89 d6                	mov    %edx,%esi
  802551:	89 c3                	mov    %eax,%ebx
  802553:	f7 64 24 0c          	mull   0xc(%esp)
  802557:	39 d6                	cmp    %edx,%esi
  802559:	72 15                	jb     802570 <__udivdi3+0x100>
  80255b:	89 f9                	mov    %edi,%ecx
  80255d:	d3 e5                	shl    %cl,%ebp
  80255f:	39 c5                	cmp    %eax,%ebp
  802561:	73 04                	jae    802567 <__udivdi3+0xf7>
  802563:	39 d6                	cmp    %edx,%esi
  802565:	74 09                	je     802570 <__udivdi3+0x100>
  802567:	89 d8                	mov    %ebx,%eax
  802569:	31 ff                	xor    %edi,%edi
  80256b:	e9 40 ff ff ff       	jmp    8024b0 <__udivdi3+0x40>
  802570:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802573:	31 ff                	xor    %edi,%edi
  802575:	e9 36 ff ff ff       	jmp    8024b0 <__udivdi3+0x40>
  80257a:	66 90                	xchg   %ax,%ax
  80257c:	66 90                	xchg   %ax,%ax
  80257e:	66 90                	xchg   %ax,%ax

00802580 <__umoddi3>:
  802580:	f3 0f 1e fb          	endbr32 
  802584:	55                   	push   %ebp
  802585:	57                   	push   %edi
  802586:	56                   	push   %esi
  802587:	53                   	push   %ebx
  802588:	83 ec 1c             	sub    $0x1c,%esp
  80258b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80258f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802593:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802597:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80259b:	85 c0                	test   %eax,%eax
  80259d:	75 19                	jne    8025b8 <__umoddi3+0x38>
  80259f:	39 df                	cmp    %ebx,%edi
  8025a1:	76 5d                	jbe    802600 <__umoddi3+0x80>
  8025a3:	89 f0                	mov    %esi,%eax
  8025a5:	89 da                	mov    %ebx,%edx
  8025a7:	f7 f7                	div    %edi
  8025a9:	89 d0                	mov    %edx,%eax
  8025ab:	31 d2                	xor    %edx,%edx
  8025ad:	83 c4 1c             	add    $0x1c,%esp
  8025b0:	5b                   	pop    %ebx
  8025b1:	5e                   	pop    %esi
  8025b2:	5f                   	pop    %edi
  8025b3:	5d                   	pop    %ebp
  8025b4:	c3                   	ret    
  8025b5:	8d 76 00             	lea    0x0(%esi),%esi
  8025b8:	89 f2                	mov    %esi,%edx
  8025ba:	39 d8                	cmp    %ebx,%eax
  8025bc:	76 12                	jbe    8025d0 <__umoddi3+0x50>
  8025be:	89 f0                	mov    %esi,%eax
  8025c0:	89 da                	mov    %ebx,%edx
  8025c2:	83 c4 1c             	add    $0x1c,%esp
  8025c5:	5b                   	pop    %ebx
  8025c6:	5e                   	pop    %esi
  8025c7:	5f                   	pop    %edi
  8025c8:	5d                   	pop    %ebp
  8025c9:	c3                   	ret    
  8025ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025d0:	0f bd e8             	bsr    %eax,%ebp
  8025d3:	83 f5 1f             	xor    $0x1f,%ebp
  8025d6:	75 50                	jne    802628 <__umoddi3+0xa8>
  8025d8:	39 d8                	cmp    %ebx,%eax
  8025da:	0f 82 e0 00 00 00    	jb     8026c0 <__umoddi3+0x140>
  8025e0:	89 d9                	mov    %ebx,%ecx
  8025e2:	39 f7                	cmp    %esi,%edi
  8025e4:	0f 86 d6 00 00 00    	jbe    8026c0 <__umoddi3+0x140>
  8025ea:	89 d0                	mov    %edx,%eax
  8025ec:	89 ca                	mov    %ecx,%edx
  8025ee:	83 c4 1c             	add    $0x1c,%esp
  8025f1:	5b                   	pop    %ebx
  8025f2:	5e                   	pop    %esi
  8025f3:	5f                   	pop    %edi
  8025f4:	5d                   	pop    %ebp
  8025f5:	c3                   	ret    
  8025f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025fd:	8d 76 00             	lea    0x0(%esi),%esi
  802600:	89 fd                	mov    %edi,%ebp
  802602:	85 ff                	test   %edi,%edi
  802604:	75 0b                	jne    802611 <__umoddi3+0x91>
  802606:	b8 01 00 00 00       	mov    $0x1,%eax
  80260b:	31 d2                	xor    %edx,%edx
  80260d:	f7 f7                	div    %edi
  80260f:	89 c5                	mov    %eax,%ebp
  802611:	89 d8                	mov    %ebx,%eax
  802613:	31 d2                	xor    %edx,%edx
  802615:	f7 f5                	div    %ebp
  802617:	89 f0                	mov    %esi,%eax
  802619:	f7 f5                	div    %ebp
  80261b:	89 d0                	mov    %edx,%eax
  80261d:	31 d2                	xor    %edx,%edx
  80261f:	eb 8c                	jmp    8025ad <__umoddi3+0x2d>
  802621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802628:	89 e9                	mov    %ebp,%ecx
  80262a:	ba 20 00 00 00       	mov    $0x20,%edx
  80262f:	29 ea                	sub    %ebp,%edx
  802631:	d3 e0                	shl    %cl,%eax
  802633:	89 44 24 08          	mov    %eax,0x8(%esp)
  802637:	89 d1                	mov    %edx,%ecx
  802639:	89 f8                	mov    %edi,%eax
  80263b:	d3 e8                	shr    %cl,%eax
  80263d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802641:	89 54 24 04          	mov    %edx,0x4(%esp)
  802645:	8b 54 24 04          	mov    0x4(%esp),%edx
  802649:	09 c1                	or     %eax,%ecx
  80264b:	89 d8                	mov    %ebx,%eax
  80264d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802651:	89 e9                	mov    %ebp,%ecx
  802653:	d3 e7                	shl    %cl,%edi
  802655:	89 d1                	mov    %edx,%ecx
  802657:	d3 e8                	shr    %cl,%eax
  802659:	89 e9                	mov    %ebp,%ecx
  80265b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80265f:	d3 e3                	shl    %cl,%ebx
  802661:	89 c7                	mov    %eax,%edi
  802663:	89 d1                	mov    %edx,%ecx
  802665:	89 f0                	mov    %esi,%eax
  802667:	d3 e8                	shr    %cl,%eax
  802669:	89 e9                	mov    %ebp,%ecx
  80266b:	89 fa                	mov    %edi,%edx
  80266d:	d3 e6                	shl    %cl,%esi
  80266f:	09 d8                	or     %ebx,%eax
  802671:	f7 74 24 08          	divl   0x8(%esp)
  802675:	89 d1                	mov    %edx,%ecx
  802677:	89 f3                	mov    %esi,%ebx
  802679:	f7 64 24 0c          	mull   0xc(%esp)
  80267d:	89 c6                	mov    %eax,%esi
  80267f:	89 d7                	mov    %edx,%edi
  802681:	39 d1                	cmp    %edx,%ecx
  802683:	72 06                	jb     80268b <__umoddi3+0x10b>
  802685:	75 10                	jne    802697 <__umoddi3+0x117>
  802687:	39 c3                	cmp    %eax,%ebx
  802689:	73 0c                	jae    802697 <__umoddi3+0x117>
  80268b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80268f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802693:	89 d7                	mov    %edx,%edi
  802695:	89 c6                	mov    %eax,%esi
  802697:	89 ca                	mov    %ecx,%edx
  802699:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80269e:	29 f3                	sub    %esi,%ebx
  8026a0:	19 fa                	sbb    %edi,%edx
  8026a2:	89 d0                	mov    %edx,%eax
  8026a4:	d3 e0                	shl    %cl,%eax
  8026a6:	89 e9                	mov    %ebp,%ecx
  8026a8:	d3 eb                	shr    %cl,%ebx
  8026aa:	d3 ea                	shr    %cl,%edx
  8026ac:	09 d8                	or     %ebx,%eax
  8026ae:	83 c4 1c             	add    $0x1c,%esp
  8026b1:	5b                   	pop    %ebx
  8026b2:	5e                   	pop    %esi
  8026b3:	5f                   	pop    %edi
  8026b4:	5d                   	pop    %ebp
  8026b5:	c3                   	ret    
  8026b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026bd:	8d 76 00             	lea    0x0(%esi),%esi
  8026c0:	29 fe                	sub    %edi,%esi
  8026c2:	19 c3                	sbb    %eax,%ebx
  8026c4:	89 f2                	mov    %esi,%edx
  8026c6:	89 d9                	mov    %ebx,%ecx
  8026c8:	e9 1d ff ff ff       	jmp    8025ea <__umoddi3+0x6a>
