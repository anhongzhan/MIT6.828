
obj/user/primespipe.debug:     file format elf32-i386


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
  80002c:	e8 08 02 00 00       	call   800239 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 1c             	sub    $0x1c,%esp
  800040:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  800043:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800046:	8d 7d d8             	lea    -0x28(%ebp),%edi
  800049:	eb 5e                	jmp    8000a9 <primeproc+0x76>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  80004b:	83 ec 0c             	sub    $0xc,%esp
  80004e:	85 c0                	test   %eax,%eax
  800050:	ba 00 00 00 00       	mov    $0x0,%edx
  800055:	0f 4e d0             	cmovle %eax,%edx
  800058:	52                   	push   %edx
  800059:	50                   	push   %eax
  80005a:	68 00 2a 80 00       	push   $0x802a00
  80005f:	6a 15                	push   $0x15
  800061:	68 2f 2a 80 00       	push   $0x802a2f
  800066:	e8 36 02 00 00       	call   8002a1 <_panic>
		panic("pipe: %e", i);
  80006b:	50                   	push   %eax
  80006c:	68 41 2a 80 00       	push   $0x802a41
  800071:	6a 1b                	push   $0x1b
  800073:	68 2f 2a 80 00       	push   $0x802a2f
  800078:	e8 24 02 00 00       	call   8002a1 <_panic>
	if ((id = fork()) < 0)
		panic("fork: %e", id);
  80007d:	50                   	push   %eax
  80007e:	68 45 2e 80 00       	push   $0x802e45
  800083:	6a 1d                	push   $0x1d
  800085:	68 2f 2a 80 00       	push   $0x802a2f
  80008a:	e8 12 02 00 00       	call   8002a1 <_panic>
	if (id == 0) {
		close(fd);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	53                   	push   %ebx
  800093:	e8 b8 14 00 00       	call   801550 <close>
		close(pfd[1]);
  800098:	83 c4 04             	add    $0x4,%esp
  80009b:	ff 75 dc             	pushl  -0x24(%ebp)
  80009e:	e8 ad 14 00 00       	call   801550 <close>
		fd = pfd[0];
  8000a3:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  8000a6:	83 c4 10             	add    $0x10,%esp
	if ((r = readn(fd, &p, 4)) != 4)
  8000a9:	83 ec 04             	sub    $0x4,%esp
  8000ac:	6a 04                	push   $0x4
  8000ae:	56                   	push   %esi
  8000af:	53                   	push   %ebx
  8000b0:	e8 70 16 00 00       	call   801725 <readn>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	83 f8 04             	cmp    $0x4,%eax
  8000bb:	75 8e                	jne    80004b <primeproc+0x18>
	cprintf("%d\n", p);
  8000bd:	83 ec 08             	sub    $0x8,%esp
  8000c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8000c3:	68 49 30 80 00       	push   $0x803049
  8000c8:	e8 bb 02 00 00       	call   800388 <cprintf>
	if ((i=pipe(pfd)) < 0)
  8000cd:	89 3c 24             	mov    %edi,(%esp)
  8000d0:	e8 a0 21 00 00       	call   802275 <pipe>
  8000d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	85 c0                	test   %eax,%eax
  8000dd:	78 8c                	js     80006b <primeproc+0x38>
	if ((id = fork()) < 0)
  8000df:	e8 90 10 00 00       	call   801174 <fork>
  8000e4:	85 c0                	test   %eax,%eax
  8000e6:	78 95                	js     80007d <primeproc+0x4a>
	if (id == 0) {
  8000e8:	74 a5                	je     80008f <primeproc+0x5c>
	}

	close(pfd[0]);
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	ff 75 d8             	pushl  -0x28(%ebp)
  8000f0:	e8 5b 14 00 00       	call   801550 <close>
	wfd = pfd[1];
  8000f5:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8000f8:	83 c4 10             	add    $0x10,%esp

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8000fb:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	6a 04                	push   $0x4
  800103:	56                   	push   %esi
  800104:	53                   	push   %ebx
  800105:	e8 1b 16 00 00       	call   801725 <readn>
  80010a:	83 c4 10             	add    $0x10,%esp
  80010d:	83 f8 04             	cmp    $0x4,%eax
  800110:	75 42                	jne    800154 <primeproc+0x121>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
		if (i%p)
  800112:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800115:	99                   	cltd   
  800116:	f7 7d e0             	idivl  -0x20(%ebp)
  800119:	85 d2                	test   %edx,%edx
  80011b:	74 e1                	je     8000fe <primeproc+0xcb>
			if ((r=write(wfd, &i, 4)) != 4)
  80011d:	83 ec 04             	sub    $0x4,%esp
  800120:	6a 04                	push   $0x4
  800122:	56                   	push   %esi
  800123:	57                   	push   %edi
  800124:	e8 47 16 00 00       	call   801770 <write>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	83 f8 04             	cmp    $0x4,%eax
  80012f:	74 cd                	je     8000fe <primeproc+0xcb>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  800131:	83 ec 08             	sub    $0x8,%esp
  800134:	85 c0                	test   %eax,%eax
  800136:	ba 00 00 00 00       	mov    $0x0,%edx
  80013b:	0f 4e d0             	cmovle %eax,%edx
  80013e:	52                   	push   %edx
  80013f:	50                   	push   %eax
  800140:	ff 75 e0             	pushl  -0x20(%ebp)
  800143:	68 66 2a 80 00       	push   $0x802a66
  800148:	6a 2e                	push   $0x2e
  80014a:	68 2f 2a 80 00       	push   $0x802a2f
  80014f:	e8 4d 01 00 00       	call   8002a1 <_panic>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800154:	83 ec 04             	sub    $0x4,%esp
  800157:	85 c0                	test   %eax,%eax
  800159:	ba 00 00 00 00       	mov    $0x0,%edx
  80015e:	0f 4e d0             	cmovle %eax,%edx
  800161:	52                   	push   %edx
  800162:	50                   	push   %eax
  800163:	53                   	push   %ebx
  800164:	ff 75 e0             	pushl  -0x20(%ebp)
  800167:	68 4a 2a 80 00       	push   $0x802a4a
  80016c:	6a 2b                	push   $0x2b
  80016e:	68 2f 2a 80 00       	push   $0x802a2f
  800173:	e8 29 01 00 00       	call   8002a1 <_panic>

00800178 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800178:	f3 0f 1e fb          	endbr32 
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	53                   	push   %ebx
  800180:	83 ec 20             	sub    $0x20,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  800183:	c7 05 00 40 80 00 80 	movl   $0x802a80,0x804000
  80018a:	2a 80 00 

	if ((i=pipe(p)) < 0)
  80018d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800190:	50                   	push   %eax
  800191:	e8 df 20 00 00       	call   802275 <pipe>
  800196:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800199:	83 c4 10             	add    $0x10,%esp
  80019c:	85 c0                	test   %eax,%eax
  80019e:	78 21                	js     8001c1 <umain+0x49>
		panic("pipe: %e", i);

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  8001a0:	e8 cf 0f 00 00       	call   801174 <fork>
  8001a5:	85 c0                	test   %eax,%eax
  8001a7:	78 2a                	js     8001d3 <umain+0x5b>
		panic("fork: %e", id);

	if (id == 0) {
  8001a9:	75 3a                	jne    8001e5 <umain+0x6d>
		close(p[1]);
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b1:	e8 9a 13 00 00       	call   801550 <close>
		primeproc(p[0]);
  8001b6:	83 c4 04             	add    $0x4,%esp
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 72 fe ff ff       	call   800033 <primeproc>
		panic("pipe: %e", i);
  8001c1:	50                   	push   %eax
  8001c2:	68 41 2a 80 00       	push   $0x802a41
  8001c7:	6a 3a                	push   $0x3a
  8001c9:	68 2f 2a 80 00       	push   $0x802a2f
  8001ce:	e8 ce 00 00 00       	call   8002a1 <_panic>
		panic("fork: %e", id);
  8001d3:	50                   	push   %eax
  8001d4:	68 45 2e 80 00       	push   $0x802e45
  8001d9:	6a 3e                	push   $0x3e
  8001db:	68 2f 2a 80 00       	push   $0x802a2f
  8001e0:	e8 bc 00 00 00       	call   8002a1 <_panic>
	}

	close(p[0]);
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	ff 75 ec             	pushl  -0x14(%ebp)
  8001eb:	e8 60 13 00 00       	call   801550 <close>

	// feed all the integers through
	for (i=2;; i++)
  8001f0:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
  8001f7:	83 c4 10             	add    $0x10,%esp
		if ((r=write(p[1], &i, 4)) != 4)
  8001fa:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  8001fd:	83 ec 04             	sub    $0x4,%esp
  800200:	6a 04                	push   $0x4
  800202:	53                   	push   %ebx
  800203:	ff 75 f0             	pushl  -0x10(%ebp)
  800206:	e8 65 15 00 00       	call   801770 <write>
  80020b:	83 c4 10             	add    $0x10,%esp
  80020e:	83 f8 04             	cmp    $0x4,%eax
  800211:	75 06                	jne    800219 <umain+0xa1>
	for (i=2;; i++)
  800213:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  800217:	eb e4                	jmp    8001fd <umain+0x85>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	85 c0                	test   %eax,%eax
  80021e:	ba 00 00 00 00       	mov    $0x0,%edx
  800223:	0f 4e d0             	cmovle %eax,%edx
  800226:	52                   	push   %edx
  800227:	50                   	push   %eax
  800228:	68 8b 2a 80 00       	push   $0x802a8b
  80022d:	6a 4a                	push   $0x4a
  80022f:	68 2f 2a 80 00       	push   $0x802a2f
  800234:	e8 68 00 00 00       	call   8002a1 <_panic>

00800239 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800239:	f3 0f 1e fb          	endbr32 
  80023d:	55                   	push   %ebp
  80023e:	89 e5                	mov    %esp,%ebp
  800240:	56                   	push   %esi
  800241:	53                   	push   %ebx
  800242:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800245:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800248:	e8 41 0b 00 00       	call   800d8e <sys_getenvid>
  80024d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800252:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800255:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80025a:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80025f:	85 db                	test   %ebx,%ebx
  800261:	7e 07                	jle    80026a <libmain+0x31>
		binaryname = argv[0];
  800263:	8b 06                	mov    (%esi),%eax
  800265:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	56                   	push   %esi
  80026e:	53                   	push   %ebx
  80026f:	e8 04 ff ff ff       	call   800178 <umain>

	// exit gracefully
	exit();
  800274:	e8 0a 00 00 00       	call   800283 <exit>
}
  800279:	83 c4 10             	add    $0x10,%esp
  80027c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80027f:	5b                   	pop    %ebx
  800280:	5e                   	pop    %esi
  800281:	5d                   	pop    %ebp
  800282:	c3                   	ret    

00800283 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800283:	f3 0f 1e fb          	endbr32 
  800287:	55                   	push   %ebp
  800288:	89 e5                	mov    %esp,%ebp
  80028a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80028d:	e8 ef 12 00 00       	call   801581 <close_all>
	sys_env_destroy(0);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	6a 00                	push   $0x0
  800297:	e8 ad 0a 00 00       	call   800d49 <sys_env_destroy>
}
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	c9                   	leave  
  8002a0:	c3                   	ret    

008002a1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002a1:	f3 0f 1e fb          	endbr32 
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	56                   	push   %esi
  8002a9:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8002aa:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002ad:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8002b3:	e8 d6 0a 00 00       	call   800d8e <sys_getenvid>
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	ff 75 0c             	pushl  0xc(%ebp)
  8002be:	ff 75 08             	pushl  0x8(%ebp)
  8002c1:	56                   	push   %esi
  8002c2:	50                   	push   %eax
  8002c3:	68 b0 2a 80 00       	push   $0x802ab0
  8002c8:	e8 bb 00 00 00       	call   800388 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002cd:	83 c4 18             	add    $0x18,%esp
  8002d0:	53                   	push   %ebx
  8002d1:	ff 75 10             	pushl  0x10(%ebp)
  8002d4:	e8 5a 00 00 00       	call   800333 <vcprintf>
	cprintf("\n");
  8002d9:	c7 04 24 4b 30 80 00 	movl   $0x80304b,(%esp)
  8002e0:	e8 a3 00 00 00       	call   800388 <cprintf>
  8002e5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002e8:	cc                   	int3   
  8002e9:	eb fd                	jmp    8002e8 <_panic+0x47>

008002eb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002eb:	f3 0f 1e fb          	endbr32 
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	53                   	push   %ebx
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002f9:	8b 13                	mov    (%ebx),%edx
  8002fb:	8d 42 01             	lea    0x1(%edx),%eax
  8002fe:	89 03                	mov    %eax,(%ebx)
  800300:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800303:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800307:	3d ff 00 00 00       	cmp    $0xff,%eax
  80030c:	74 09                	je     800317 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80030e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800312:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800315:	c9                   	leave  
  800316:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800317:	83 ec 08             	sub    $0x8,%esp
  80031a:	68 ff 00 00 00       	push   $0xff
  80031f:	8d 43 08             	lea    0x8(%ebx),%eax
  800322:	50                   	push   %eax
  800323:	e8 dc 09 00 00       	call   800d04 <sys_cputs>
		b->idx = 0;
  800328:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80032e:	83 c4 10             	add    $0x10,%esp
  800331:	eb db                	jmp    80030e <putch+0x23>

00800333 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800333:	f3 0f 1e fb          	endbr32 
  800337:	55                   	push   %ebp
  800338:	89 e5                	mov    %esp,%ebp
  80033a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800340:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800347:	00 00 00 
	b.cnt = 0;
  80034a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800351:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800354:	ff 75 0c             	pushl  0xc(%ebp)
  800357:	ff 75 08             	pushl  0x8(%ebp)
  80035a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800360:	50                   	push   %eax
  800361:	68 eb 02 80 00       	push   $0x8002eb
  800366:	e8 20 01 00 00       	call   80048b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80036b:	83 c4 08             	add    $0x8,%esp
  80036e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800374:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80037a:	50                   	push   %eax
  80037b:	e8 84 09 00 00       	call   800d04 <sys_cputs>

	return b.cnt;
}
  800380:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800386:	c9                   	leave  
  800387:	c3                   	ret    

00800388 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800388:	f3 0f 1e fb          	endbr32 
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800392:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800395:	50                   	push   %eax
  800396:	ff 75 08             	pushl  0x8(%ebp)
  800399:	e8 95 ff ff ff       	call   800333 <vcprintf>
	va_end(ap);

	return cnt;
}
  80039e:	c9                   	leave  
  80039f:	c3                   	ret    

008003a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	57                   	push   %edi
  8003a4:	56                   	push   %esi
  8003a5:	53                   	push   %ebx
  8003a6:	83 ec 1c             	sub    $0x1c,%esp
  8003a9:	89 c7                	mov    %eax,%edi
  8003ab:	89 d6                	mov    %edx,%esi
  8003ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b3:	89 d1                	mov    %edx,%ecx
  8003b5:	89 c2                	mov    %eax,%edx
  8003b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8003bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c0:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003c6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8003cd:	39 c2                	cmp    %eax,%edx
  8003cf:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8003d2:	72 3e                	jb     800412 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d4:	83 ec 0c             	sub    $0xc,%esp
  8003d7:	ff 75 18             	pushl  0x18(%ebp)
  8003da:	83 eb 01             	sub    $0x1,%ebx
  8003dd:	53                   	push   %ebx
  8003de:	50                   	push   %eax
  8003df:	83 ec 08             	sub    $0x8,%esp
  8003e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003e5:	ff 75 e0             	pushl  -0x20(%ebp)
  8003e8:	ff 75 dc             	pushl  -0x24(%ebp)
  8003eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8003ee:	e8 9d 23 00 00       	call   802790 <__udivdi3>
  8003f3:	83 c4 18             	add    $0x18,%esp
  8003f6:	52                   	push   %edx
  8003f7:	50                   	push   %eax
  8003f8:	89 f2                	mov    %esi,%edx
  8003fa:	89 f8                	mov    %edi,%eax
  8003fc:	e8 9f ff ff ff       	call   8003a0 <printnum>
  800401:	83 c4 20             	add    $0x20,%esp
  800404:	eb 13                	jmp    800419 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800406:	83 ec 08             	sub    $0x8,%esp
  800409:	56                   	push   %esi
  80040a:	ff 75 18             	pushl  0x18(%ebp)
  80040d:	ff d7                	call   *%edi
  80040f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800412:	83 eb 01             	sub    $0x1,%ebx
  800415:	85 db                	test   %ebx,%ebx
  800417:	7f ed                	jg     800406 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	56                   	push   %esi
  80041d:	83 ec 04             	sub    $0x4,%esp
  800420:	ff 75 e4             	pushl  -0x1c(%ebp)
  800423:	ff 75 e0             	pushl  -0x20(%ebp)
  800426:	ff 75 dc             	pushl  -0x24(%ebp)
  800429:	ff 75 d8             	pushl  -0x28(%ebp)
  80042c:	e8 6f 24 00 00       	call   8028a0 <__umoddi3>
  800431:	83 c4 14             	add    $0x14,%esp
  800434:	0f be 80 d3 2a 80 00 	movsbl 0x802ad3(%eax),%eax
  80043b:	50                   	push   %eax
  80043c:	ff d7                	call   *%edi
}
  80043e:	83 c4 10             	add    $0x10,%esp
  800441:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800444:	5b                   	pop    %ebx
  800445:	5e                   	pop    %esi
  800446:	5f                   	pop    %edi
  800447:	5d                   	pop    %ebp
  800448:	c3                   	ret    

00800449 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800449:	f3 0f 1e fb          	endbr32 
  80044d:	55                   	push   %ebp
  80044e:	89 e5                	mov    %esp,%ebp
  800450:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800453:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800457:	8b 10                	mov    (%eax),%edx
  800459:	3b 50 04             	cmp    0x4(%eax),%edx
  80045c:	73 0a                	jae    800468 <sprintputch+0x1f>
		*b->buf++ = ch;
  80045e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800461:	89 08                	mov    %ecx,(%eax)
  800463:	8b 45 08             	mov    0x8(%ebp),%eax
  800466:	88 02                	mov    %al,(%edx)
}
  800468:	5d                   	pop    %ebp
  800469:	c3                   	ret    

0080046a <printfmt>:
{
  80046a:	f3 0f 1e fb          	endbr32 
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800474:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800477:	50                   	push   %eax
  800478:	ff 75 10             	pushl  0x10(%ebp)
  80047b:	ff 75 0c             	pushl  0xc(%ebp)
  80047e:	ff 75 08             	pushl  0x8(%ebp)
  800481:	e8 05 00 00 00       	call   80048b <vprintfmt>
}
  800486:	83 c4 10             	add    $0x10,%esp
  800489:	c9                   	leave  
  80048a:	c3                   	ret    

0080048b <vprintfmt>:
{
  80048b:	f3 0f 1e fb          	endbr32 
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
  800492:	57                   	push   %edi
  800493:	56                   	push   %esi
  800494:	53                   	push   %ebx
  800495:	83 ec 3c             	sub    $0x3c,%esp
  800498:	8b 75 08             	mov    0x8(%ebp),%esi
  80049b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80049e:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004a1:	e9 8e 03 00 00       	jmp    800834 <vprintfmt+0x3a9>
		padc = ' ';
  8004a6:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8004aa:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8004b1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004b8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004bf:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004c4:	8d 47 01             	lea    0x1(%edi),%eax
  8004c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ca:	0f b6 17             	movzbl (%edi),%edx
  8004cd:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004d0:	3c 55                	cmp    $0x55,%al
  8004d2:	0f 87 df 03 00 00    	ja     8008b7 <vprintfmt+0x42c>
  8004d8:	0f b6 c0             	movzbl %al,%eax
  8004db:	3e ff 24 85 20 2c 80 	notrack jmp *0x802c20(,%eax,4)
  8004e2:	00 
  8004e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004e6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8004ea:	eb d8                	jmp    8004c4 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ef:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8004f3:	eb cf                	jmp    8004c4 <vprintfmt+0x39>
  8004f5:	0f b6 d2             	movzbl %dl,%edx
  8004f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800500:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800503:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800506:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80050a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80050d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800510:	83 f9 09             	cmp    $0x9,%ecx
  800513:	77 55                	ja     80056a <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800515:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800518:	eb e9                	jmp    800503 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80051a:	8b 45 14             	mov    0x14(%ebp),%eax
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800522:	8b 45 14             	mov    0x14(%ebp),%eax
  800525:	8d 40 04             	lea    0x4(%eax),%eax
  800528:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80052b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80052e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800532:	79 90                	jns    8004c4 <vprintfmt+0x39>
				width = precision, precision = -1;
  800534:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800537:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80053a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800541:	eb 81                	jmp    8004c4 <vprintfmt+0x39>
  800543:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800546:	85 c0                	test   %eax,%eax
  800548:	ba 00 00 00 00       	mov    $0x0,%edx
  80054d:	0f 49 d0             	cmovns %eax,%edx
  800550:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800553:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800556:	e9 69 ff ff ff       	jmp    8004c4 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80055b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80055e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800565:	e9 5a ff ff ff       	jmp    8004c4 <vprintfmt+0x39>
  80056a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80056d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800570:	eb bc                	jmp    80052e <vprintfmt+0xa3>
			lflag++;
  800572:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800575:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800578:	e9 47 ff ff ff       	jmp    8004c4 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	8d 78 04             	lea    0x4(%eax),%edi
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	53                   	push   %ebx
  800587:	ff 30                	pushl  (%eax)
  800589:	ff d6                	call   *%esi
			break;
  80058b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80058e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800591:	e9 9b 02 00 00       	jmp    800831 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	8d 78 04             	lea    0x4(%eax),%edi
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	99                   	cltd   
  80059f:	31 d0                	xor    %edx,%eax
  8005a1:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005a3:	83 f8 0f             	cmp    $0xf,%eax
  8005a6:	7f 23                	jg     8005cb <vprintfmt+0x140>
  8005a8:	8b 14 85 80 2d 80 00 	mov    0x802d80(,%eax,4),%edx
  8005af:	85 d2                	test   %edx,%edx
  8005b1:	74 18                	je     8005cb <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8005b3:	52                   	push   %edx
  8005b4:	68 45 2f 80 00       	push   $0x802f45
  8005b9:	53                   	push   %ebx
  8005ba:	56                   	push   %esi
  8005bb:	e8 aa fe ff ff       	call   80046a <printfmt>
  8005c0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005c3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005c6:	e9 66 02 00 00       	jmp    800831 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8005cb:	50                   	push   %eax
  8005cc:	68 eb 2a 80 00       	push   $0x802aeb
  8005d1:	53                   	push   %ebx
  8005d2:	56                   	push   %esi
  8005d3:	e8 92 fe ff ff       	call   80046a <printfmt>
  8005d8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005db:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005de:	e9 4e 02 00 00       	jmp    800831 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	83 c0 04             	add    $0x4,%eax
  8005e9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8005f1:	85 d2                	test   %edx,%edx
  8005f3:	b8 e4 2a 80 00       	mov    $0x802ae4,%eax
  8005f8:	0f 45 c2             	cmovne %edx,%eax
  8005fb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800602:	7e 06                	jle    80060a <vprintfmt+0x17f>
  800604:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800608:	75 0d                	jne    800617 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80060a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80060d:	89 c7                	mov    %eax,%edi
  80060f:	03 45 e0             	add    -0x20(%ebp),%eax
  800612:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800615:	eb 55                	jmp    80066c <vprintfmt+0x1e1>
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	ff 75 d8             	pushl  -0x28(%ebp)
  80061d:	ff 75 cc             	pushl  -0x34(%ebp)
  800620:	e8 46 03 00 00       	call   80096b <strnlen>
  800625:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800628:	29 c2                	sub    %eax,%edx
  80062a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80062d:	83 c4 10             	add    $0x10,%esp
  800630:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800632:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800636:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800639:	85 ff                	test   %edi,%edi
  80063b:	7e 11                	jle    80064e <vprintfmt+0x1c3>
					putch(padc, putdat);
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	53                   	push   %ebx
  800641:	ff 75 e0             	pushl  -0x20(%ebp)
  800644:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800646:	83 ef 01             	sub    $0x1,%edi
  800649:	83 c4 10             	add    $0x10,%esp
  80064c:	eb eb                	jmp    800639 <vprintfmt+0x1ae>
  80064e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800651:	85 d2                	test   %edx,%edx
  800653:	b8 00 00 00 00       	mov    $0x0,%eax
  800658:	0f 49 c2             	cmovns %edx,%eax
  80065b:	29 c2                	sub    %eax,%edx
  80065d:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800660:	eb a8                	jmp    80060a <vprintfmt+0x17f>
					putch(ch, putdat);
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	53                   	push   %ebx
  800666:	52                   	push   %edx
  800667:	ff d6                	call   *%esi
  800669:	83 c4 10             	add    $0x10,%esp
  80066c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80066f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800671:	83 c7 01             	add    $0x1,%edi
  800674:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800678:	0f be d0             	movsbl %al,%edx
  80067b:	85 d2                	test   %edx,%edx
  80067d:	74 4b                	je     8006ca <vprintfmt+0x23f>
  80067f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800683:	78 06                	js     80068b <vprintfmt+0x200>
  800685:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800689:	78 1e                	js     8006a9 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80068b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80068f:	74 d1                	je     800662 <vprintfmt+0x1d7>
  800691:	0f be c0             	movsbl %al,%eax
  800694:	83 e8 20             	sub    $0x20,%eax
  800697:	83 f8 5e             	cmp    $0x5e,%eax
  80069a:	76 c6                	jbe    800662 <vprintfmt+0x1d7>
					putch('?', putdat);
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	53                   	push   %ebx
  8006a0:	6a 3f                	push   $0x3f
  8006a2:	ff d6                	call   *%esi
  8006a4:	83 c4 10             	add    $0x10,%esp
  8006a7:	eb c3                	jmp    80066c <vprintfmt+0x1e1>
  8006a9:	89 cf                	mov    %ecx,%edi
  8006ab:	eb 0e                	jmp    8006bb <vprintfmt+0x230>
				putch(' ', putdat);
  8006ad:	83 ec 08             	sub    $0x8,%esp
  8006b0:	53                   	push   %ebx
  8006b1:	6a 20                	push   $0x20
  8006b3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006b5:	83 ef 01             	sub    $0x1,%edi
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	85 ff                	test   %edi,%edi
  8006bd:	7f ee                	jg     8006ad <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8006bf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c5:	e9 67 01 00 00       	jmp    800831 <vprintfmt+0x3a6>
  8006ca:	89 cf                	mov    %ecx,%edi
  8006cc:	eb ed                	jmp    8006bb <vprintfmt+0x230>
	if (lflag >= 2)
  8006ce:	83 f9 01             	cmp    $0x1,%ecx
  8006d1:	7f 1b                	jg     8006ee <vprintfmt+0x263>
	else if (lflag)
  8006d3:	85 c9                	test   %ecx,%ecx
  8006d5:	74 63                	je     80073a <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006df:	99                   	cltd   
  8006e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	8d 40 04             	lea    0x4(%eax),%eax
  8006e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ec:	eb 17                	jmp    800705 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8006ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f1:	8b 50 04             	mov    0x4(%eax),%edx
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8d 40 08             	lea    0x8(%eax),%eax
  800702:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800705:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800708:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80070b:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800710:	85 c9                	test   %ecx,%ecx
  800712:	0f 89 ff 00 00 00    	jns    800817 <vprintfmt+0x38c>
				putch('-', putdat);
  800718:	83 ec 08             	sub    $0x8,%esp
  80071b:	53                   	push   %ebx
  80071c:	6a 2d                	push   $0x2d
  80071e:	ff d6                	call   *%esi
				num = -(long long) num;
  800720:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800723:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800726:	f7 da                	neg    %edx
  800728:	83 d1 00             	adc    $0x0,%ecx
  80072b:	f7 d9                	neg    %ecx
  80072d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800730:	b8 0a 00 00 00       	mov    $0xa,%eax
  800735:	e9 dd 00 00 00       	jmp    800817 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800742:	99                   	cltd   
  800743:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800746:	8b 45 14             	mov    0x14(%ebp),%eax
  800749:	8d 40 04             	lea    0x4(%eax),%eax
  80074c:	89 45 14             	mov    %eax,0x14(%ebp)
  80074f:	eb b4                	jmp    800705 <vprintfmt+0x27a>
	if (lflag >= 2)
  800751:	83 f9 01             	cmp    $0x1,%ecx
  800754:	7f 1e                	jg     800774 <vprintfmt+0x2e9>
	else if (lflag)
  800756:	85 c9                	test   %ecx,%ecx
  800758:	74 32                	je     80078c <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8b 10                	mov    (%eax),%edx
  80075f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800764:	8d 40 04             	lea    0x4(%eax),%eax
  800767:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80076a:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80076f:	e9 a3 00 00 00       	jmp    800817 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8b 10                	mov    (%eax),%edx
  800779:	8b 48 04             	mov    0x4(%eax),%ecx
  80077c:	8d 40 08             	lea    0x8(%eax),%eax
  80077f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800782:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800787:	e9 8b 00 00 00       	jmp    800817 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	8b 10                	mov    (%eax),%edx
  800791:	b9 00 00 00 00       	mov    $0x0,%ecx
  800796:	8d 40 04             	lea    0x4(%eax),%eax
  800799:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80079c:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8007a1:	eb 74                	jmp    800817 <vprintfmt+0x38c>
	if (lflag >= 2)
  8007a3:	83 f9 01             	cmp    $0x1,%ecx
  8007a6:	7f 1b                	jg     8007c3 <vprintfmt+0x338>
	else if (lflag)
  8007a8:	85 c9                	test   %ecx,%ecx
  8007aa:	74 2c                	je     8007d8 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8007ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8007af:	8b 10                	mov    (%eax),%edx
  8007b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007b6:	8d 40 04             	lea    0x4(%eax),%eax
  8007b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007bc:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8007c1:	eb 54                	jmp    800817 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	8b 10                	mov    (%eax),%edx
  8007c8:	8b 48 04             	mov    0x4(%eax),%ecx
  8007cb:	8d 40 08             	lea    0x8(%eax),%eax
  8007ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007d1:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8007d6:	eb 3f                	jmp    800817 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8007d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007db:	8b 10                	mov    (%eax),%edx
  8007dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007e2:	8d 40 04             	lea    0x4(%eax),%eax
  8007e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007e8:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8007ed:	eb 28                	jmp    800817 <vprintfmt+0x38c>
			putch('0', putdat);
  8007ef:	83 ec 08             	sub    $0x8,%esp
  8007f2:	53                   	push   %ebx
  8007f3:	6a 30                	push   $0x30
  8007f5:	ff d6                	call   *%esi
			putch('x', putdat);
  8007f7:	83 c4 08             	add    $0x8,%esp
  8007fa:	53                   	push   %ebx
  8007fb:	6a 78                	push   $0x78
  8007fd:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8b 10                	mov    (%eax),%edx
  800804:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800809:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80080c:	8d 40 04             	lea    0x4(%eax),%eax
  80080f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800812:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800817:	83 ec 0c             	sub    $0xc,%esp
  80081a:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80081e:	57                   	push   %edi
  80081f:	ff 75 e0             	pushl  -0x20(%ebp)
  800822:	50                   	push   %eax
  800823:	51                   	push   %ecx
  800824:	52                   	push   %edx
  800825:	89 da                	mov    %ebx,%edx
  800827:	89 f0                	mov    %esi,%eax
  800829:	e8 72 fb ff ff       	call   8003a0 <printnum>
			break;
  80082e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800831:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800834:	83 c7 01             	add    $0x1,%edi
  800837:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80083b:	83 f8 25             	cmp    $0x25,%eax
  80083e:	0f 84 62 fc ff ff    	je     8004a6 <vprintfmt+0x1b>
			if (ch == '\0')
  800844:	85 c0                	test   %eax,%eax
  800846:	0f 84 8b 00 00 00    	je     8008d7 <vprintfmt+0x44c>
			putch(ch, putdat);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	53                   	push   %ebx
  800850:	50                   	push   %eax
  800851:	ff d6                	call   *%esi
  800853:	83 c4 10             	add    $0x10,%esp
  800856:	eb dc                	jmp    800834 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800858:	83 f9 01             	cmp    $0x1,%ecx
  80085b:	7f 1b                	jg     800878 <vprintfmt+0x3ed>
	else if (lflag)
  80085d:	85 c9                	test   %ecx,%ecx
  80085f:	74 2c                	je     80088d <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	8b 10                	mov    (%eax),%edx
  800866:	b9 00 00 00 00       	mov    $0x0,%ecx
  80086b:	8d 40 04             	lea    0x4(%eax),%eax
  80086e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800871:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800876:	eb 9f                	jmp    800817 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	8b 10                	mov    (%eax),%edx
  80087d:	8b 48 04             	mov    0x4(%eax),%ecx
  800880:	8d 40 08             	lea    0x8(%eax),%eax
  800883:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800886:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80088b:	eb 8a                	jmp    800817 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	8b 10                	mov    (%eax),%edx
  800892:	b9 00 00 00 00       	mov    $0x0,%ecx
  800897:	8d 40 04             	lea    0x4(%eax),%eax
  80089a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80089d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8008a2:	e9 70 ff ff ff       	jmp    800817 <vprintfmt+0x38c>
			putch(ch, putdat);
  8008a7:	83 ec 08             	sub    $0x8,%esp
  8008aa:	53                   	push   %ebx
  8008ab:	6a 25                	push   $0x25
  8008ad:	ff d6                	call   *%esi
			break;
  8008af:	83 c4 10             	add    $0x10,%esp
  8008b2:	e9 7a ff ff ff       	jmp    800831 <vprintfmt+0x3a6>
			putch('%', putdat);
  8008b7:	83 ec 08             	sub    $0x8,%esp
  8008ba:	53                   	push   %ebx
  8008bb:	6a 25                	push   $0x25
  8008bd:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008bf:	83 c4 10             	add    $0x10,%esp
  8008c2:	89 f8                	mov    %edi,%eax
  8008c4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008c8:	74 05                	je     8008cf <vprintfmt+0x444>
  8008ca:	83 e8 01             	sub    $0x1,%eax
  8008cd:	eb f5                	jmp    8008c4 <vprintfmt+0x439>
  8008cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008d2:	e9 5a ff ff ff       	jmp    800831 <vprintfmt+0x3a6>
}
  8008d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008da:	5b                   	pop    %ebx
  8008db:	5e                   	pop    %esi
  8008dc:	5f                   	pop    %edi
  8008dd:	5d                   	pop    %ebp
  8008de:	c3                   	ret    

008008df <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008df:	f3 0f 1e fb          	endbr32 
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
  8008e6:	83 ec 18             	sub    $0x18,%esp
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008f6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800900:	85 c0                	test   %eax,%eax
  800902:	74 26                	je     80092a <vsnprintf+0x4b>
  800904:	85 d2                	test   %edx,%edx
  800906:	7e 22                	jle    80092a <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800908:	ff 75 14             	pushl  0x14(%ebp)
  80090b:	ff 75 10             	pushl  0x10(%ebp)
  80090e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800911:	50                   	push   %eax
  800912:	68 49 04 80 00       	push   $0x800449
  800917:	e8 6f fb ff ff       	call   80048b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80091c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80091f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800925:	83 c4 10             	add    $0x10,%esp
}
  800928:	c9                   	leave  
  800929:	c3                   	ret    
		return -E_INVAL;
  80092a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80092f:	eb f7                	jmp    800928 <vsnprintf+0x49>

00800931 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800931:	f3 0f 1e fb          	endbr32 
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80093b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80093e:	50                   	push   %eax
  80093f:	ff 75 10             	pushl  0x10(%ebp)
  800942:	ff 75 0c             	pushl  0xc(%ebp)
  800945:	ff 75 08             	pushl  0x8(%ebp)
  800948:	e8 92 ff ff ff       	call   8008df <vsnprintf>
	va_end(ap);

	return rc;
}
  80094d:	c9                   	leave  
  80094e:	c3                   	ret    

0080094f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80094f:	f3 0f 1e fb          	endbr32 
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800959:	b8 00 00 00 00       	mov    $0x0,%eax
  80095e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800962:	74 05                	je     800969 <strlen+0x1a>
		n++;
  800964:	83 c0 01             	add    $0x1,%eax
  800967:	eb f5                	jmp    80095e <strlen+0xf>
	return n;
}
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80096b:	f3 0f 1e fb          	endbr32 
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800975:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800978:	b8 00 00 00 00       	mov    $0x0,%eax
  80097d:	39 d0                	cmp    %edx,%eax
  80097f:	74 0d                	je     80098e <strnlen+0x23>
  800981:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800985:	74 05                	je     80098c <strnlen+0x21>
		n++;
  800987:	83 c0 01             	add    $0x1,%eax
  80098a:	eb f1                	jmp    80097d <strnlen+0x12>
  80098c:	89 c2                	mov    %eax,%edx
	return n;
}
  80098e:	89 d0                	mov    %edx,%eax
  800990:	5d                   	pop    %ebp
  800991:	c3                   	ret    

00800992 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800992:	f3 0f 1e fb          	endbr32 
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	53                   	push   %ebx
  80099a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a5:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8009a9:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8009ac:	83 c0 01             	add    $0x1,%eax
  8009af:	84 d2                	test   %dl,%dl
  8009b1:	75 f2                	jne    8009a5 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8009b3:	89 c8                	mov    %ecx,%eax
  8009b5:	5b                   	pop    %ebx
  8009b6:	5d                   	pop    %ebp
  8009b7:	c3                   	ret    

008009b8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009b8:	f3 0f 1e fb          	endbr32 
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	53                   	push   %ebx
  8009c0:	83 ec 10             	sub    $0x10,%esp
  8009c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009c6:	53                   	push   %ebx
  8009c7:	e8 83 ff ff ff       	call   80094f <strlen>
  8009cc:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009cf:	ff 75 0c             	pushl  0xc(%ebp)
  8009d2:	01 d8                	add    %ebx,%eax
  8009d4:	50                   	push   %eax
  8009d5:	e8 b8 ff ff ff       	call   800992 <strcpy>
	return dst;
}
  8009da:	89 d8                	mov    %ebx,%eax
  8009dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009df:	c9                   	leave  
  8009e0:	c3                   	ret    

008009e1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009e1:	f3 0f 1e fb          	endbr32 
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	56                   	push   %esi
  8009e9:	53                   	push   %ebx
  8009ea:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f0:	89 f3                	mov    %esi,%ebx
  8009f2:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f5:	89 f0                	mov    %esi,%eax
  8009f7:	39 d8                	cmp    %ebx,%eax
  8009f9:	74 11                	je     800a0c <strncpy+0x2b>
		*dst++ = *src;
  8009fb:	83 c0 01             	add    $0x1,%eax
  8009fe:	0f b6 0a             	movzbl (%edx),%ecx
  800a01:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a04:	80 f9 01             	cmp    $0x1,%cl
  800a07:	83 da ff             	sbb    $0xffffffff,%edx
  800a0a:	eb eb                	jmp    8009f7 <strncpy+0x16>
	}
	return ret;
}
  800a0c:	89 f0                	mov    %esi,%eax
  800a0e:	5b                   	pop    %ebx
  800a0f:	5e                   	pop    %esi
  800a10:	5d                   	pop    %ebp
  800a11:	c3                   	ret    

00800a12 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a12:	f3 0f 1e fb          	endbr32 
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	56                   	push   %esi
  800a1a:	53                   	push   %ebx
  800a1b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a21:	8b 55 10             	mov    0x10(%ebp),%edx
  800a24:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a26:	85 d2                	test   %edx,%edx
  800a28:	74 21                	je     800a4b <strlcpy+0x39>
  800a2a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a2e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a30:	39 c2                	cmp    %eax,%edx
  800a32:	74 14                	je     800a48 <strlcpy+0x36>
  800a34:	0f b6 19             	movzbl (%ecx),%ebx
  800a37:	84 db                	test   %bl,%bl
  800a39:	74 0b                	je     800a46 <strlcpy+0x34>
			*dst++ = *src++;
  800a3b:	83 c1 01             	add    $0x1,%ecx
  800a3e:	83 c2 01             	add    $0x1,%edx
  800a41:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a44:	eb ea                	jmp    800a30 <strlcpy+0x1e>
  800a46:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a48:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a4b:	29 f0                	sub    %esi,%eax
}
  800a4d:	5b                   	pop    %ebx
  800a4e:	5e                   	pop    %esi
  800a4f:	5d                   	pop    %ebp
  800a50:	c3                   	ret    

00800a51 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a51:	f3 0f 1e fb          	endbr32 
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a5b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a5e:	0f b6 01             	movzbl (%ecx),%eax
  800a61:	84 c0                	test   %al,%al
  800a63:	74 0c                	je     800a71 <strcmp+0x20>
  800a65:	3a 02                	cmp    (%edx),%al
  800a67:	75 08                	jne    800a71 <strcmp+0x20>
		p++, q++;
  800a69:	83 c1 01             	add    $0x1,%ecx
  800a6c:	83 c2 01             	add    $0x1,%edx
  800a6f:	eb ed                	jmp    800a5e <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a71:	0f b6 c0             	movzbl %al,%eax
  800a74:	0f b6 12             	movzbl (%edx),%edx
  800a77:	29 d0                	sub    %edx,%eax
}
  800a79:	5d                   	pop    %ebp
  800a7a:	c3                   	ret    

00800a7b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a7b:	f3 0f 1e fb          	endbr32 
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
  800a82:	53                   	push   %ebx
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a89:	89 c3                	mov    %eax,%ebx
  800a8b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a8e:	eb 06                	jmp    800a96 <strncmp+0x1b>
		n--, p++, q++;
  800a90:	83 c0 01             	add    $0x1,%eax
  800a93:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a96:	39 d8                	cmp    %ebx,%eax
  800a98:	74 16                	je     800ab0 <strncmp+0x35>
  800a9a:	0f b6 08             	movzbl (%eax),%ecx
  800a9d:	84 c9                	test   %cl,%cl
  800a9f:	74 04                	je     800aa5 <strncmp+0x2a>
  800aa1:	3a 0a                	cmp    (%edx),%cl
  800aa3:	74 eb                	je     800a90 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa5:	0f b6 00             	movzbl (%eax),%eax
  800aa8:	0f b6 12             	movzbl (%edx),%edx
  800aab:	29 d0                	sub    %edx,%eax
}
  800aad:	5b                   	pop    %ebx
  800aae:	5d                   	pop    %ebp
  800aaf:	c3                   	ret    
		return 0;
  800ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab5:	eb f6                	jmp    800aad <strncmp+0x32>

00800ab7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ab7:	f3 0f 1e fb          	endbr32 
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ac5:	0f b6 10             	movzbl (%eax),%edx
  800ac8:	84 d2                	test   %dl,%dl
  800aca:	74 09                	je     800ad5 <strchr+0x1e>
		if (*s == c)
  800acc:	38 ca                	cmp    %cl,%dl
  800ace:	74 0a                	je     800ada <strchr+0x23>
	for (; *s; s++)
  800ad0:	83 c0 01             	add    $0x1,%eax
  800ad3:	eb f0                	jmp    800ac5 <strchr+0xe>
			return (char *) s;
	return 0;
  800ad5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    

00800adc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800adc:	f3 0f 1e fb          	endbr32 
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aea:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800aed:	38 ca                	cmp    %cl,%dl
  800aef:	74 09                	je     800afa <strfind+0x1e>
  800af1:	84 d2                	test   %dl,%dl
  800af3:	74 05                	je     800afa <strfind+0x1e>
	for (; *s; s++)
  800af5:	83 c0 01             	add    $0x1,%eax
  800af8:	eb f0                	jmp    800aea <strfind+0xe>
			break;
	return (char *) s;
}
  800afa:	5d                   	pop    %ebp
  800afb:	c3                   	ret    

00800afc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800afc:	f3 0f 1e fb          	endbr32 
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	57                   	push   %edi
  800b04:	56                   	push   %esi
  800b05:	53                   	push   %ebx
  800b06:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b09:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b0c:	85 c9                	test   %ecx,%ecx
  800b0e:	74 31                	je     800b41 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b10:	89 f8                	mov    %edi,%eax
  800b12:	09 c8                	or     %ecx,%eax
  800b14:	a8 03                	test   $0x3,%al
  800b16:	75 23                	jne    800b3b <memset+0x3f>
		c &= 0xFF;
  800b18:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b1c:	89 d3                	mov    %edx,%ebx
  800b1e:	c1 e3 08             	shl    $0x8,%ebx
  800b21:	89 d0                	mov    %edx,%eax
  800b23:	c1 e0 18             	shl    $0x18,%eax
  800b26:	89 d6                	mov    %edx,%esi
  800b28:	c1 e6 10             	shl    $0x10,%esi
  800b2b:	09 f0                	or     %esi,%eax
  800b2d:	09 c2                	or     %eax,%edx
  800b2f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b31:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b34:	89 d0                	mov    %edx,%eax
  800b36:	fc                   	cld    
  800b37:	f3 ab                	rep stos %eax,%es:(%edi)
  800b39:	eb 06                	jmp    800b41 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3e:	fc                   	cld    
  800b3f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b41:	89 f8                	mov    %edi,%eax
  800b43:	5b                   	pop    %ebx
  800b44:	5e                   	pop    %esi
  800b45:	5f                   	pop    %edi
  800b46:	5d                   	pop    %ebp
  800b47:	c3                   	ret    

00800b48 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b48:	f3 0f 1e fb          	endbr32 
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	57                   	push   %edi
  800b50:	56                   	push   %esi
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b57:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b5a:	39 c6                	cmp    %eax,%esi
  800b5c:	73 32                	jae    800b90 <memmove+0x48>
  800b5e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b61:	39 c2                	cmp    %eax,%edx
  800b63:	76 2b                	jbe    800b90 <memmove+0x48>
		s += n;
		d += n;
  800b65:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b68:	89 fe                	mov    %edi,%esi
  800b6a:	09 ce                	or     %ecx,%esi
  800b6c:	09 d6                	or     %edx,%esi
  800b6e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b74:	75 0e                	jne    800b84 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b76:	83 ef 04             	sub    $0x4,%edi
  800b79:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b7c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b7f:	fd                   	std    
  800b80:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b82:	eb 09                	jmp    800b8d <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b84:	83 ef 01             	sub    $0x1,%edi
  800b87:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b8a:	fd                   	std    
  800b8b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b8d:	fc                   	cld    
  800b8e:	eb 1a                	jmp    800baa <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b90:	89 c2                	mov    %eax,%edx
  800b92:	09 ca                	or     %ecx,%edx
  800b94:	09 f2                	or     %esi,%edx
  800b96:	f6 c2 03             	test   $0x3,%dl
  800b99:	75 0a                	jne    800ba5 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b9b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b9e:	89 c7                	mov    %eax,%edi
  800ba0:	fc                   	cld    
  800ba1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba3:	eb 05                	jmp    800baa <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800ba5:	89 c7                	mov    %eax,%edi
  800ba7:	fc                   	cld    
  800ba8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800baa:	5e                   	pop    %esi
  800bab:	5f                   	pop    %edi
  800bac:	5d                   	pop    %ebp
  800bad:	c3                   	ret    

00800bae <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bae:	f3 0f 1e fb          	endbr32 
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bb8:	ff 75 10             	pushl  0x10(%ebp)
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	ff 75 08             	pushl  0x8(%ebp)
  800bc1:	e8 82 ff ff ff       	call   800b48 <memmove>
}
  800bc6:	c9                   	leave  
  800bc7:	c3                   	ret    

00800bc8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bc8:	f3 0f 1e fb          	endbr32 
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	56                   	push   %esi
  800bd0:	53                   	push   %ebx
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd7:	89 c6                	mov    %eax,%esi
  800bd9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bdc:	39 f0                	cmp    %esi,%eax
  800bde:	74 1c                	je     800bfc <memcmp+0x34>
		if (*s1 != *s2)
  800be0:	0f b6 08             	movzbl (%eax),%ecx
  800be3:	0f b6 1a             	movzbl (%edx),%ebx
  800be6:	38 d9                	cmp    %bl,%cl
  800be8:	75 08                	jne    800bf2 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bea:	83 c0 01             	add    $0x1,%eax
  800bed:	83 c2 01             	add    $0x1,%edx
  800bf0:	eb ea                	jmp    800bdc <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800bf2:	0f b6 c1             	movzbl %cl,%eax
  800bf5:	0f b6 db             	movzbl %bl,%ebx
  800bf8:	29 d8                	sub    %ebx,%eax
  800bfa:	eb 05                	jmp    800c01 <memcmp+0x39>
	}

	return 0;
  800bfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c01:	5b                   	pop    %ebx
  800c02:	5e                   	pop    %esi
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c05:	f3 0f 1e fb          	endbr32 
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c12:	89 c2                	mov    %eax,%edx
  800c14:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c17:	39 d0                	cmp    %edx,%eax
  800c19:	73 09                	jae    800c24 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c1b:	38 08                	cmp    %cl,(%eax)
  800c1d:	74 05                	je     800c24 <memfind+0x1f>
	for (; s < ends; s++)
  800c1f:	83 c0 01             	add    $0x1,%eax
  800c22:	eb f3                	jmp    800c17 <memfind+0x12>
			break;
	return (void *) s;
}
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c26:	f3 0f 1e fb          	endbr32 
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	57                   	push   %edi
  800c2e:	56                   	push   %esi
  800c2f:	53                   	push   %ebx
  800c30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c33:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c36:	eb 03                	jmp    800c3b <strtol+0x15>
		s++;
  800c38:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c3b:	0f b6 01             	movzbl (%ecx),%eax
  800c3e:	3c 20                	cmp    $0x20,%al
  800c40:	74 f6                	je     800c38 <strtol+0x12>
  800c42:	3c 09                	cmp    $0x9,%al
  800c44:	74 f2                	je     800c38 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800c46:	3c 2b                	cmp    $0x2b,%al
  800c48:	74 2a                	je     800c74 <strtol+0x4e>
	int neg = 0;
  800c4a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c4f:	3c 2d                	cmp    $0x2d,%al
  800c51:	74 2b                	je     800c7e <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c53:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c59:	75 0f                	jne    800c6a <strtol+0x44>
  800c5b:	80 39 30             	cmpb   $0x30,(%ecx)
  800c5e:	74 28                	je     800c88 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c60:	85 db                	test   %ebx,%ebx
  800c62:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c67:	0f 44 d8             	cmove  %eax,%ebx
  800c6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c72:	eb 46                	jmp    800cba <strtol+0x94>
		s++;
  800c74:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c77:	bf 00 00 00 00       	mov    $0x0,%edi
  800c7c:	eb d5                	jmp    800c53 <strtol+0x2d>
		s++, neg = 1;
  800c7e:	83 c1 01             	add    $0x1,%ecx
  800c81:	bf 01 00 00 00       	mov    $0x1,%edi
  800c86:	eb cb                	jmp    800c53 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c88:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c8c:	74 0e                	je     800c9c <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c8e:	85 db                	test   %ebx,%ebx
  800c90:	75 d8                	jne    800c6a <strtol+0x44>
		s++, base = 8;
  800c92:	83 c1 01             	add    $0x1,%ecx
  800c95:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c9a:	eb ce                	jmp    800c6a <strtol+0x44>
		s += 2, base = 16;
  800c9c:	83 c1 02             	add    $0x2,%ecx
  800c9f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ca4:	eb c4                	jmp    800c6a <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ca6:	0f be d2             	movsbl %dl,%edx
  800ca9:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cac:	3b 55 10             	cmp    0x10(%ebp),%edx
  800caf:	7d 3a                	jge    800ceb <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800cb1:	83 c1 01             	add    $0x1,%ecx
  800cb4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cb8:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cba:	0f b6 11             	movzbl (%ecx),%edx
  800cbd:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cc0:	89 f3                	mov    %esi,%ebx
  800cc2:	80 fb 09             	cmp    $0x9,%bl
  800cc5:	76 df                	jbe    800ca6 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800cc7:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cca:	89 f3                	mov    %esi,%ebx
  800ccc:	80 fb 19             	cmp    $0x19,%bl
  800ccf:	77 08                	ja     800cd9 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800cd1:	0f be d2             	movsbl %dl,%edx
  800cd4:	83 ea 57             	sub    $0x57,%edx
  800cd7:	eb d3                	jmp    800cac <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800cd9:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cdc:	89 f3                	mov    %esi,%ebx
  800cde:	80 fb 19             	cmp    $0x19,%bl
  800ce1:	77 08                	ja     800ceb <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ce3:	0f be d2             	movsbl %dl,%edx
  800ce6:	83 ea 37             	sub    $0x37,%edx
  800ce9:	eb c1                	jmp    800cac <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ceb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cef:	74 05                	je     800cf6 <strtol+0xd0>
		*endptr = (char *) s;
  800cf1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cf4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cf6:	89 c2                	mov    %eax,%edx
  800cf8:	f7 da                	neg    %edx
  800cfa:	85 ff                	test   %edi,%edi
  800cfc:	0f 45 c2             	cmovne %edx,%eax
}
  800cff:	5b                   	pop    %ebx
  800d00:	5e                   	pop    %esi
  800d01:	5f                   	pop    %edi
  800d02:	5d                   	pop    %ebp
  800d03:	c3                   	ret    

00800d04 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d04:	f3 0f 1e fb          	endbr32 
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	57                   	push   %edi
  800d0c:	56                   	push   %esi
  800d0d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d13:	8b 55 08             	mov    0x8(%ebp),%edx
  800d16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d19:	89 c3                	mov    %eax,%ebx
  800d1b:	89 c7                	mov    %eax,%edi
  800d1d:	89 c6                	mov    %eax,%esi
  800d1f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d21:	5b                   	pop    %ebx
  800d22:	5e                   	pop    %esi
  800d23:	5f                   	pop    %edi
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d26:	f3 0f 1e fb          	endbr32 
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	57                   	push   %edi
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d30:	ba 00 00 00 00       	mov    $0x0,%edx
  800d35:	b8 01 00 00 00       	mov    $0x1,%eax
  800d3a:	89 d1                	mov    %edx,%ecx
  800d3c:	89 d3                	mov    %edx,%ebx
  800d3e:	89 d7                	mov    %edx,%edi
  800d40:	89 d6                	mov    %edx,%esi
  800d42:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d49:	f3 0f 1e fb          	endbr32 
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	57                   	push   %edi
  800d51:	56                   	push   %esi
  800d52:	53                   	push   %ebx
  800d53:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d56:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5e:	b8 03 00 00 00       	mov    $0x3,%eax
  800d63:	89 cb                	mov    %ecx,%ebx
  800d65:	89 cf                	mov    %ecx,%edi
  800d67:	89 ce                	mov    %ecx,%esi
  800d69:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d6b:	85 c0                	test   %eax,%eax
  800d6d:	7f 08                	jg     800d77 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d72:	5b                   	pop    %ebx
  800d73:	5e                   	pop    %esi
  800d74:	5f                   	pop    %edi
  800d75:	5d                   	pop    %ebp
  800d76:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d77:	83 ec 0c             	sub    $0xc,%esp
  800d7a:	50                   	push   %eax
  800d7b:	6a 03                	push   $0x3
  800d7d:	68 df 2d 80 00       	push   $0x802ddf
  800d82:	6a 23                	push   $0x23
  800d84:	68 fc 2d 80 00       	push   $0x802dfc
  800d89:	e8 13 f5 ff ff       	call   8002a1 <_panic>

00800d8e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d8e:	f3 0f 1e fb          	endbr32 
  800d92:	55                   	push   %ebp
  800d93:	89 e5                	mov    %esp,%ebp
  800d95:	57                   	push   %edi
  800d96:	56                   	push   %esi
  800d97:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d98:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9d:	b8 02 00 00 00       	mov    $0x2,%eax
  800da2:	89 d1                	mov    %edx,%ecx
  800da4:	89 d3                	mov    %edx,%ebx
  800da6:	89 d7                	mov    %edx,%edi
  800da8:	89 d6                	mov    %edx,%esi
  800daa:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dac:	5b                   	pop    %ebx
  800dad:	5e                   	pop    %esi
  800dae:	5f                   	pop    %edi
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    

00800db1 <sys_yield>:

void
sys_yield(void)
{
  800db1:	f3 0f 1e fb          	endbr32 
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	57                   	push   %edi
  800db9:	56                   	push   %esi
  800dba:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dc5:	89 d1                	mov    %edx,%ecx
  800dc7:	89 d3                	mov    %edx,%ebx
  800dc9:	89 d7                	mov    %edx,%edi
  800dcb:	89 d6                	mov    %edx,%esi
  800dcd:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dcf:	5b                   	pop    %ebx
  800dd0:	5e                   	pop    %esi
  800dd1:	5f                   	pop    %edi
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    

00800dd4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dd4:	f3 0f 1e fb          	endbr32 
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	57                   	push   %edi
  800ddc:	56                   	push   %esi
  800ddd:	53                   	push   %ebx
  800dde:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de1:	be 00 00 00 00       	mov    $0x0,%esi
  800de6:	8b 55 08             	mov    0x8(%ebp),%edx
  800de9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dec:	b8 04 00 00 00       	mov    $0x4,%eax
  800df1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df4:	89 f7                	mov    %esi,%edi
  800df6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	7f 08                	jg     800e04 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800e08:	6a 04                	push   $0x4
  800e0a:	68 df 2d 80 00       	push   $0x802ddf
  800e0f:	6a 23                	push   $0x23
  800e11:	68 fc 2d 80 00       	push   $0x802dfc
  800e16:	e8 86 f4 ff ff       	call   8002a1 <_panic>

00800e1b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e1b:	f3 0f 1e fb          	endbr32 
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	57                   	push   %edi
  800e23:	56                   	push   %esi
  800e24:	53                   	push   %ebx
  800e25:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e28:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2e:	b8 05 00 00 00       	mov    $0x5,%eax
  800e33:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e36:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e39:	8b 75 18             	mov    0x18(%ebp),%esi
  800e3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3e:	85 c0                	test   %eax,%eax
  800e40:	7f 08                	jg     800e4a <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e45:	5b                   	pop    %ebx
  800e46:	5e                   	pop    %esi
  800e47:	5f                   	pop    %edi
  800e48:	5d                   	pop    %ebp
  800e49:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4a:	83 ec 0c             	sub    $0xc,%esp
  800e4d:	50                   	push   %eax
  800e4e:	6a 05                	push   $0x5
  800e50:	68 df 2d 80 00       	push   $0x802ddf
  800e55:	6a 23                	push   $0x23
  800e57:	68 fc 2d 80 00       	push   $0x802dfc
  800e5c:	e8 40 f4 ff ff       	call   8002a1 <_panic>

00800e61 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e61:	f3 0f 1e fb          	endbr32 
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	57                   	push   %edi
  800e69:	56                   	push   %esi
  800e6a:	53                   	push   %ebx
  800e6b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e73:	8b 55 08             	mov    0x8(%ebp),%edx
  800e76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e79:	b8 06 00 00 00       	mov    $0x6,%eax
  800e7e:	89 df                	mov    %ebx,%edi
  800e80:	89 de                	mov    %ebx,%esi
  800e82:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e84:	85 c0                	test   %eax,%eax
  800e86:	7f 08                	jg     800e90 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8b:	5b                   	pop    %ebx
  800e8c:	5e                   	pop    %esi
  800e8d:	5f                   	pop    %edi
  800e8e:	5d                   	pop    %ebp
  800e8f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e90:	83 ec 0c             	sub    $0xc,%esp
  800e93:	50                   	push   %eax
  800e94:	6a 06                	push   $0x6
  800e96:	68 df 2d 80 00       	push   $0x802ddf
  800e9b:	6a 23                	push   $0x23
  800e9d:	68 fc 2d 80 00       	push   $0x802dfc
  800ea2:	e8 fa f3 ff ff       	call   8002a1 <_panic>

00800ea7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ea7:	f3 0f 1e fb          	endbr32 
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	57                   	push   %edi
  800eaf:	56                   	push   %esi
  800eb0:	53                   	push   %ebx
  800eb1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebf:	b8 08 00 00 00       	mov    $0x8,%eax
  800ec4:	89 df                	mov    %ebx,%edi
  800ec6:	89 de                	mov    %ebx,%esi
  800ec8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	7f 08                	jg     800ed6 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ece:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed1:	5b                   	pop    %ebx
  800ed2:	5e                   	pop    %esi
  800ed3:	5f                   	pop    %edi
  800ed4:	5d                   	pop    %ebp
  800ed5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed6:	83 ec 0c             	sub    $0xc,%esp
  800ed9:	50                   	push   %eax
  800eda:	6a 08                	push   $0x8
  800edc:	68 df 2d 80 00       	push   $0x802ddf
  800ee1:	6a 23                	push   $0x23
  800ee3:	68 fc 2d 80 00       	push   $0x802dfc
  800ee8:	e8 b4 f3 ff ff       	call   8002a1 <_panic>

00800eed <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eed:	f3 0f 1e fb          	endbr32 
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	57                   	push   %edi
  800ef5:	56                   	push   %esi
  800ef6:	53                   	push   %ebx
  800ef7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eff:	8b 55 08             	mov    0x8(%ebp),%edx
  800f02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f05:	b8 09 00 00 00       	mov    $0x9,%eax
  800f0a:	89 df                	mov    %ebx,%edi
  800f0c:	89 de                	mov    %ebx,%esi
  800f0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f10:	85 c0                	test   %eax,%eax
  800f12:	7f 08                	jg     800f1c <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f17:	5b                   	pop    %ebx
  800f18:	5e                   	pop    %esi
  800f19:	5f                   	pop    %edi
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1c:	83 ec 0c             	sub    $0xc,%esp
  800f1f:	50                   	push   %eax
  800f20:	6a 09                	push   $0x9
  800f22:	68 df 2d 80 00       	push   $0x802ddf
  800f27:	6a 23                	push   $0x23
  800f29:	68 fc 2d 80 00       	push   $0x802dfc
  800f2e:	e8 6e f3 ff ff       	call   8002a1 <_panic>

00800f33 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f33:	f3 0f 1e fb          	endbr32 
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	57                   	push   %edi
  800f3b:	56                   	push   %esi
  800f3c:	53                   	push   %ebx
  800f3d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f40:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f45:	8b 55 08             	mov    0x8(%ebp),%edx
  800f48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f50:	89 df                	mov    %ebx,%edi
  800f52:	89 de                	mov    %ebx,%esi
  800f54:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f56:	85 c0                	test   %eax,%eax
  800f58:	7f 08                	jg     800f62 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5d:	5b                   	pop    %ebx
  800f5e:	5e                   	pop    %esi
  800f5f:	5f                   	pop    %edi
  800f60:	5d                   	pop    %ebp
  800f61:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f62:	83 ec 0c             	sub    $0xc,%esp
  800f65:	50                   	push   %eax
  800f66:	6a 0a                	push   $0xa
  800f68:	68 df 2d 80 00       	push   $0x802ddf
  800f6d:	6a 23                	push   $0x23
  800f6f:	68 fc 2d 80 00       	push   $0x802dfc
  800f74:	e8 28 f3 ff ff       	call   8002a1 <_panic>

00800f79 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f79:	f3 0f 1e fb          	endbr32 
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	57                   	push   %edi
  800f81:	56                   	push   %esi
  800f82:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f83:	8b 55 08             	mov    0x8(%ebp),%edx
  800f86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f89:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f8e:	be 00 00 00 00       	mov    $0x0,%esi
  800f93:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f96:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f99:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f9b:	5b                   	pop    %ebx
  800f9c:	5e                   	pop    %esi
  800f9d:	5f                   	pop    %edi
  800f9e:	5d                   	pop    %ebp
  800f9f:	c3                   	ret    

00800fa0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fa0:	f3 0f 1e fb          	endbr32 
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	57                   	push   %edi
  800fa8:	56                   	push   %esi
  800fa9:	53                   	push   %ebx
  800faa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fad:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb5:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fba:	89 cb                	mov    %ecx,%ebx
  800fbc:	89 cf                	mov    %ecx,%edi
  800fbe:	89 ce                	mov    %ecx,%esi
  800fc0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc2:	85 c0                	test   %eax,%eax
  800fc4:	7f 08                	jg     800fce <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc9:	5b                   	pop    %ebx
  800fca:	5e                   	pop    %esi
  800fcb:	5f                   	pop    %edi
  800fcc:	5d                   	pop    %ebp
  800fcd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fce:	83 ec 0c             	sub    $0xc,%esp
  800fd1:	50                   	push   %eax
  800fd2:	6a 0d                	push   $0xd
  800fd4:	68 df 2d 80 00       	push   $0x802ddf
  800fd9:	6a 23                	push   $0x23
  800fdb:	68 fc 2d 80 00       	push   $0x802dfc
  800fe0:	e8 bc f2 ff ff       	call   8002a1 <_panic>

00800fe5 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fe5:	f3 0f 1e fb          	endbr32 
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	57                   	push   %edi
  800fed:	56                   	push   %esi
  800fee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fef:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff4:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ff9:	89 d1                	mov    %edx,%ecx
  800ffb:	89 d3                	mov    %edx,%ebx
  800ffd:	89 d7                	mov    %edx,%edi
  800fff:	89 d6                	mov    %edx,%esi
  801001:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801003:	5b                   	pop    %ebx
  801004:	5e                   	pop    %esi
  801005:	5f                   	pop    %edi
  801006:	5d                   	pop    %ebp
  801007:	c3                   	ret    

00801008 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  801008:	f3 0f 1e fb          	endbr32 
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	57                   	push   %edi
  801010:	56                   	push   %esi
  801011:	53                   	push   %ebx
  801012:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801015:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101a:	8b 55 08             	mov    0x8(%ebp),%edx
  80101d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801020:	b8 0f 00 00 00       	mov    $0xf,%eax
  801025:	89 df                	mov    %ebx,%edi
  801027:	89 de                	mov    %ebx,%esi
  801029:	cd 30                	int    $0x30
	if(check && ret > 0)
  80102b:	85 c0                	test   %eax,%eax
  80102d:	7f 08                	jg     801037 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  80102f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801032:	5b                   	pop    %ebx
  801033:	5e                   	pop    %esi
  801034:	5f                   	pop    %edi
  801035:	5d                   	pop    %ebp
  801036:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801037:	83 ec 0c             	sub    $0xc,%esp
  80103a:	50                   	push   %eax
  80103b:	6a 0f                	push   $0xf
  80103d:	68 df 2d 80 00       	push   $0x802ddf
  801042:	6a 23                	push   $0x23
  801044:	68 fc 2d 80 00       	push   $0x802dfc
  801049:	e8 53 f2 ff ff       	call   8002a1 <_panic>

0080104e <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  80104e:	f3 0f 1e fb          	endbr32 
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	57                   	push   %edi
  801056:	56                   	push   %esi
  801057:	53                   	push   %ebx
  801058:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80105b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801060:	8b 55 08             	mov    0x8(%ebp),%edx
  801063:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801066:	b8 10 00 00 00       	mov    $0x10,%eax
  80106b:	89 df                	mov    %ebx,%edi
  80106d:	89 de                	mov    %ebx,%esi
  80106f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801071:	85 c0                	test   %eax,%eax
  801073:	7f 08                	jg     80107d <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  801075:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801078:	5b                   	pop    %ebx
  801079:	5e                   	pop    %esi
  80107a:	5f                   	pop    %edi
  80107b:	5d                   	pop    %ebp
  80107c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80107d:	83 ec 0c             	sub    $0xc,%esp
  801080:	50                   	push   %eax
  801081:	6a 10                	push   $0x10
  801083:	68 df 2d 80 00       	push   $0x802ddf
  801088:	6a 23                	push   $0x23
  80108a:	68 fc 2d 80 00       	push   $0x802dfc
  80108f:	e8 0d f2 ff ff       	call   8002a1 <_panic>

00801094 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801094:	f3 0f 1e fb          	endbr32 
  801098:	55                   	push   %ebp
  801099:	89 e5                	mov    %esp,%ebp
  80109b:	53                   	push   %ebx
  80109c:	83 ec 04             	sub    $0x4,%esp
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8010a2:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  8010a4:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8010a8:	74 74                	je     80111e <pgfault+0x8a>
  8010aa:	89 d8                	mov    %ebx,%eax
  8010ac:	c1 e8 0c             	shr    $0xc,%eax
  8010af:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010b6:	f6 c4 08             	test   $0x8,%ah
  8010b9:	74 63                	je     80111e <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  8010bb:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  8010c1:	83 ec 0c             	sub    $0xc,%esp
  8010c4:	6a 05                	push   $0x5
  8010c6:	68 00 f0 7f 00       	push   $0x7ff000
  8010cb:	6a 00                	push   $0x0
  8010cd:	53                   	push   %ebx
  8010ce:	6a 00                	push   $0x0
  8010d0:	e8 46 fd ff ff       	call   800e1b <sys_page_map>
  8010d5:	83 c4 20             	add    $0x20,%esp
  8010d8:	85 c0                	test   %eax,%eax
  8010da:	78 59                	js     801135 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  8010dc:	83 ec 04             	sub    $0x4,%esp
  8010df:	6a 07                	push   $0x7
  8010e1:	53                   	push   %ebx
  8010e2:	6a 00                	push   $0x0
  8010e4:	e8 eb fc ff ff       	call   800dd4 <sys_page_alloc>
  8010e9:	83 c4 10             	add    $0x10,%esp
  8010ec:	85 c0                	test   %eax,%eax
  8010ee:	78 5a                	js     80114a <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  8010f0:	83 ec 04             	sub    $0x4,%esp
  8010f3:	68 00 10 00 00       	push   $0x1000
  8010f8:	68 00 f0 7f 00       	push   $0x7ff000
  8010fd:	53                   	push   %ebx
  8010fe:	e8 45 fa ff ff       	call   800b48 <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  801103:	83 c4 08             	add    $0x8,%esp
  801106:	68 00 f0 7f 00       	push   $0x7ff000
  80110b:	6a 00                	push   $0x0
  80110d:	e8 4f fd ff ff       	call   800e61 <sys_page_unmap>
  801112:	83 c4 10             	add    $0x10,%esp
  801115:	85 c0                	test   %eax,%eax
  801117:	78 46                	js     80115f <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  801119:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80111c:	c9                   	leave  
  80111d:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  80111e:	83 ec 04             	sub    $0x4,%esp
  801121:	68 0a 2e 80 00       	push   $0x802e0a
  801126:	68 d3 00 00 00       	push   $0xd3
  80112b:	68 26 2e 80 00       	push   $0x802e26
  801130:	e8 6c f1 ff ff       	call   8002a1 <_panic>
		panic("pgfault: %e\n", r);
  801135:	50                   	push   %eax
  801136:	68 31 2e 80 00       	push   $0x802e31
  80113b:	68 df 00 00 00       	push   $0xdf
  801140:	68 26 2e 80 00       	push   $0x802e26
  801145:	e8 57 f1 ff ff       	call   8002a1 <_panic>
		panic("pgfault: %e\n", r);
  80114a:	50                   	push   %eax
  80114b:	68 31 2e 80 00       	push   $0x802e31
  801150:	68 e3 00 00 00       	push   $0xe3
  801155:	68 26 2e 80 00       	push   $0x802e26
  80115a:	e8 42 f1 ff ff       	call   8002a1 <_panic>
		panic("pgfault: %e\n", r);
  80115f:	50                   	push   %eax
  801160:	68 31 2e 80 00       	push   $0x802e31
  801165:	68 e9 00 00 00       	push   $0xe9
  80116a:	68 26 2e 80 00       	push   $0x802e26
  80116f:	e8 2d f1 ff ff       	call   8002a1 <_panic>

00801174 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801174:	f3 0f 1e fb          	endbr32 
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	57                   	push   %edi
  80117c:	56                   	push   %esi
  80117d:	53                   	push   %ebx
  80117e:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  801181:	68 94 10 80 00       	push   $0x801094
  801186:	e8 04 14 00 00       	call   80258f <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80118b:	b8 07 00 00 00       	mov    $0x7,%eax
  801190:	cd 30                	int    $0x30
  801192:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  801195:	83 c4 10             	add    $0x10,%esp
  801198:	85 c0                	test   %eax,%eax
  80119a:	78 2d                	js     8011c9 <fork+0x55>
  80119c:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80119e:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  8011a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011a7:	0f 85 9b 00 00 00    	jne    801248 <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011ad:	e8 dc fb ff ff       	call   800d8e <sys_getenvid>
  8011b2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011b7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011bf:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8011c4:	e9 71 01 00 00       	jmp    80133a <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  8011c9:	50                   	push   %eax
  8011ca:	68 3e 2e 80 00       	push   $0x802e3e
  8011cf:	68 2a 01 00 00       	push   $0x12a
  8011d4:	68 26 2e 80 00       	push   $0x802e26
  8011d9:	e8 c3 f0 ff ff       	call   8002a1 <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  8011de:	c1 e6 0c             	shl    $0xc,%esi
  8011e1:	83 ec 0c             	sub    $0xc,%esp
  8011e4:	68 07 0e 00 00       	push   $0xe07
  8011e9:	56                   	push   %esi
  8011ea:	57                   	push   %edi
  8011eb:	56                   	push   %esi
  8011ec:	6a 00                	push   $0x0
  8011ee:	e8 28 fc ff ff       	call   800e1b <sys_page_map>
  8011f3:	83 c4 20             	add    $0x20,%esp
  8011f6:	eb 3e                	jmp    801236 <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  8011f8:	c1 e6 0c             	shl    $0xc,%esi
  8011fb:	83 ec 0c             	sub    $0xc,%esp
  8011fe:	68 05 08 00 00       	push   $0x805
  801203:	56                   	push   %esi
  801204:	57                   	push   %edi
  801205:	56                   	push   %esi
  801206:	6a 00                	push   $0x0
  801208:	e8 0e fc ff ff       	call   800e1b <sys_page_map>
  80120d:	83 c4 20             	add    $0x20,%esp
  801210:	85 c0                	test   %eax,%eax
  801212:	0f 88 bc 00 00 00    	js     8012d4 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  801218:	83 ec 0c             	sub    $0xc,%esp
  80121b:	68 05 08 00 00       	push   $0x805
  801220:	56                   	push   %esi
  801221:	6a 00                	push   $0x0
  801223:	56                   	push   %esi
  801224:	6a 00                	push   $0x0
  801226:	e8 f0 fb ff ff       	call   800e1b <sys_page_map>
  80122b:	83 c4 20             	add    $0x20,%esp
  80122e:	85 c0                	test   %eax,%eax
  801230:	0f 88 b3 00 00 00    	js     8012e9 <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801236:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80123c:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801242:	0f 84 b6 00 00 00    	je     8012fe <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  801248:	89 d8                	mov    %ebx,%eax
  80124a:	c1 e8 16             	shr    $0x16,%eax
  80124d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801254:	a8 01                	test   $0x1,%al
  801256:	74 de                	je     801236 <fork+0xc2>
  801258:	89 de                	mov    %ebx,%esi
  80125a:	c1 ee 0c             	shr    $0xc,%esi
  80125d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801264:	a8 01                	test   $0x1,%al
  801266:	74 ce                	je     801236 <fork+0xc2>
  801268:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80126f:	a8 04                	test   $0x4,%al
  801271:	74 c3                	je     801236 <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  801273:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80127a:	f6 c4 04             	test   $0x4,%ah
  80127d:	0f 85 5b ff ff ff    	jne    8011de <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  801283:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80128a:	a8 02                	test   $0x2,%al
  80128c:	0f 85 66 ff ff ff    	jne    8011f8 <fork+0x84>
  801292:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801299:	f6 c4 08             	test   $0x8,%ah
  80129c:	0f 85 56 ff ff ff    	jne    8011f8 <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  8012a2:	c1 e6 0c             	shl    $0xc,%esi
  8012a5:	83 ec 0c             	sub    $0xc,%esp
  8012a8:	6a 05                	push   $0x5
  8012aa:	56                   	push   %esi
  8012ab:	57                   	push   %edi
  8012ac:	56                   	push   %esi
  8012ad:	6a 00                	push   $0x0
  8012af:	e8 67 fb ff ff       	call   800e1b <sys_page_map>
  8012b4:	83 c4 20             	add    $0x20,%esp
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	0f 89 77 ff ff ff    	jns    801236 <fork+0xc2>
		panic("duppage: %e\n", r);
  8012bf:	50                   	push   %eax
  8012c0:	68 4e 2e 80 00       	push   $0x802e4e
  8012c5:	68 0c 01 00 00       	push   $0x10c
  8012ca:	68 26 2e 80 00       	push   $0x802e26
  8012cf:	e8 cd ef ff ff       	call   8002a1 <_panic>
			panic("duppage: %e\n", r);
  8012d4:	50                   	push   %eax
  8012d5:	68 4e 2e 80 00       	push   $0x802e4e
  8012da:	68 05 01 00 00       	push   $0x105
  8012df:	68 26 2e 80 00       	push   $0x802e26
  8012e4:	e8 b8 ef ff ff       	call   8002a1 <_panic>
			panic("duppage: %e\n", r);
  8012e9:	50                   	push   %eax
  8012ea:	68 4e 2e 80 00       	push   $0x802e4e
  8012ef:	68 09 01 00 00       	push   $0x109
  8012f4:	68 26 2e 80 00       	push   $0x802e26
  8012f9:	e8 a3 ef ff ff       	call   8002a1 <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  8012fe:	83 ec 04             	sub    $0x4,%esp
  801301:	6a 07                	push   $0x7
  801303:	68 00 f0 bf ee       	push   $0xeebff000
  801308:	ff 75 e4             	pushl  -0x1c(%ebp)
  80130b:	e8 c4 fa ff ff       	call   800dd4 <sys_page_alloc>
  801310:	83 c4 10             	add    $0x10,%esp
  801313:	85 c0                	test   %eax,%eax
  801315:	78 2e                	js     801345 <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801317:	83 ec 08             	sub    $0x8,%esp
  80131a:	68 02 26 80 00       	push   $0x802602
  80131f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801322:	57                   	push   %edi
  801323:	e8 0b fc ff ff       	call   800f33 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801328:	83 c4 08             	add    $0x8,%esp
  80132b:	6a 02                	push   $0x2
  80132d:	57                   	push   %edi
  80132e:	e8 74 fb ff ff       	call   800ea7 <sys_env_set_status>
  801333:	83 c4 10             	add    $0x10,%esp
  801336:	85 c0                	test   %eax,%eax
  801338:	78 20                	js     80135a <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  80133a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80133d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801340:	5b                   	pop    %ebx
  801341:	5e                   	pop    %esi
  801342:	5f                   	pop    %edi
  801343:	5d                   	pop    %ebp
  801344:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801345:	50                   	push   %eax
  801346:	68 5b 2e 80 00       	push   $0x802e5b
  80134b:	68 3e 01 00 00       	push   $0x13e
  801350:	68 26 2e 80 00       	push   $0x802e26
  801355:	e8 47 ef ff ff       	call   8002a1 <_panic>
		panic("sys_env_set_status: %e", r);
  80135a:	50                   	push   %eax
  80135b:	68 6e 2e 80 00       	push   $0x802e6e
  801360:	68 43 01 00 00       	push   $0x143
  801365:	68 26 2e 80 00       	push   $0x802e26
  80136a:	e8 32 ef ff ff       	call   8002a1 <_panic>

0080136f <sfork>:

// Challenge!
int
sfork(void)
{
  80136f:	f3 0f 1e fb          	endbr32 
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801379:	68 85 2e 80 00       	push   $0x802e85
  80137e:	68 4c 01 00 00       	push   $0x14c
  801383:	68 26 2e 80 00       	push   $0x802e26
  801388:	e8 14 ef ff ff       	call   8002a1 <_panic>

0080138d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80138d:	f3 0f 1e fb          	endbr32 
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801394:	8b 45 08             	mov    0x8(%ebp),%eax
  801397:	05 00 00 00 30       	add    $0x30000000,%eax
  80139c:	c1 e8 0c             	shr    $0xc,%eax
}
  80139f:	5d                   	pop    %ebp
  8013a0:	c3                   	ret    

008013a1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013a1:	f3 0f 1e fb          	endbr32 
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013ba:	5d                   	pop    %ebp
  8013bb:	c3                   	ret    

008013bc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013bc:	f3 0f 1e fb          	endbr32 
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
  8013c3:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013c8:	89 c2                	mov    %eax,%edx
  8013ca:	c1 ea 16             	shr    $0x16,%edx
  8013cd:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013d4:	f6 c2 01             	test   $0x1,%dl
  8013d7:	74 2d                	je     801406 <fd_alloc+0x4a>
  8013d9:	89 c2                	mov    %eax,%edx
  8013db:	c1 ea 0c             	shr    $0xc,%edx
  8013de:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013e5:	f6 c2 01             	test   $0x1,%dl
  8013e8:	74 1c                	je     801406 <fd_alloc+0x4a>
  8013ea:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8013ef:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013f4:	75 d2                	jne    8013c8 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8013ff:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801404:	eb 0a                	jmp    801410 <fd_alloc+0x54>
			*fd_store = fd;
  801406:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801409:	89 01                	mov    %eax,(%ecx)
			return 0;
  80140b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801410:	5d                   	pop    %ebp
  801411:	c3                   	ret    

00801412 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801412:	f3 0f 1e fb          	endbr32 
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80141c:	83 f8 1f             	cmp    $0x1f,%eax
  80141f:	77 30                	ja     801451 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801421:	c1 e0 0c             	shl    $0xc,%eax
  801424:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801429:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80142f:	f6 c2 01             	test   $0x1,%dl
  801432:	74 24                	je     801458 <fd_lookup+0x46>
  801434:	89 c2                	mov    %eax,%edx
  801436:	c1 ea 0c             	shr    $0xc,%edx
  801439:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801440:	f6 c2 01             	test   $0x1,%dl
  801443:	74 1a                	je     80145f <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801445:	8b 55 0c             	mov    0xc(%ebp),%edx
  801448:	89 02                	mov    %eax,(%edx)
	return 0;
  80144a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80144f:	5d                   	pop    %ebp
  801450:	c3                   	ret    
		return -E_INVAL;
  801451:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801456:	eb f7                	jmp    80144f <fd_lookup+0x3d>
		return -E_INVAL;
  801458:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80145d:	eb f0                	jmp    80144f <fd_lookup+0x3d>
  80145f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801464:	eb e9                	jmp    80144f <fd_lookup+0x3d>

00801466 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801466:	f3 0f 1e fb          	endbr32 
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
  80146d:	83 ec 08             	sub    $0x8,%esp
  801470:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801473:	ba 00 00 00 00       	mov    $0x0,%edx
  801478:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80147d:	39 08                	cmp    %ecx,(%eax)
  80147f:	74 38                	je     8014b9 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801481:	83 c2 01             	add    $0x1,%edx
  801484:	8b 04 95 18 2f 80 00 	mov    0x802f18(,%edx,4),%eax
  80148b:	85 c0                	test   %eax,%eax
  80148d:	75 ee                	jne    80147d <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80148f:	a1 08 50 80 00       	mov    0x805008,%eax
  801494:	8b 40 48             	mov    0x48(%eax),%eax
  801497:	83 ec 04             	sub    $0x4,%esp
  80149a:	51                   	push   %ecx
  80149b:	50                   	push   %eax
  80149c:	68 9c 2e 80 00       	push   $0x802e9c
  8014a1:	e8 e2 ee ff ff       	call   800388 <cprintf>
	*dev = 0;
  8014a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014af:	83 c4 10             	add    $0x10,%esp
  8014b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    
			*dev = devtab[i];
  8014b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014bc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014be:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c3:	eb f2                	jmp    8014b7 <dev_lookup+0x51>

008014c5 <fd_close>:
{
  8014c5:	f3 0f 1e fb          	endbr32 
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	57                   	push   %edi
  8014cd:	56                   	push   %esi
  8014ce:	53                   	push   %ebx
  8014cf:	83 ec 24             	sub    $0x24,%esp
  8014d2:	8b 75 08             	mov    0x8(%ebp),%esi
  8014d5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014d8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014db:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014dc:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014e2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014e5:	50                   	push   %eax
  8014e6:	e8 27 ff ff ff       	call   801412 <fd_lookup>
  8014eb:	89 c3                	mov    %eax,%ebx
  8014ed:	83 c4 10             	add    $0x10,%esp
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	78 05                	js     8014f9 <fd_close+0x34>
	    || fd != fd2)
  8014f4:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8014f7:	74 16                	je     80150f <fd_close+0x4a>
		return (must_exist ? r : 0);
  8014f9:	89 f8                	mov    %edi,%eax
  8014fb:	84 c0                	test   %al,%al
  8014fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801502:	0f 44 d8             	cmove  %eax,%ebx
}
  801505:	89 d8                	mov    %ebx,%eax
  801507:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80150a:	5b                   	pop    %ebx
  80150b:	5e                   	pop    %esi
  80150c:	5f                   	pop    %edi
  80150d:	5d                   	pop    %ebp
  80150e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80150f:	83 ec 08             	sub    $0x8,%esp
  801512:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801515:	50                   	push   %eax
  801516:	ff 36                	pushl  (%esi)
  801518:	e8 49 ff ff ff       	call   801466 <dev_lookup>
  80151d:	89 c3                	mov    %eax,%ebx
  80151f:	83 c4 10             	add    $0x10,%esp
  801522:	85 c0                	test   %eax,%eax
  801524:	78 1a                	js     801540 <fd_close+0x7b>
		if (dev->dev_close)
  801526:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801529:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80152c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801531:	85 c0                	test   %eax,%eax
  801533:	74 0b                	je     801540 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801535:	83 ec 0c             	sub    $0xc,%esp
  801538:	56                   	push   %esi
  801539:	ff d0                	call   *%eax
  80153b:	89 c3                	mov    %eax,%ebx
  80153d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801540:	83 ec 08             	sub    $0x8,%esp
  801543:	56                   	push   %esi
  801544:	6a 00                	push   $0x0
  801546:	e8 16 f9 ff ff       	call   800e61 <sys_page_unmap>
	return r;
  80154b:	83 c4 10             	add    $0x10,%esp
  80154e:	eb b5                	jmp    801505 <fd_close+0x40>

00801550 <close>:

int
close(int fdnum)
{
  801550:	f3 0f 1e fb          	endbr32 
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
  801557:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80155a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80155d:	50                   	push   %eax
  80155e:	ff 75 08             	pushl  0x8(%ebp)
  801561:	e8 ac fe ff ff       	call   801412 <fd_lookup>
  801566:	83 c4 10             	add    $0x10,%esp
  801569:	85 c0                	test   %eax,%eax
  80156b:	79 02                	jns    80156f <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    
		return fd_close(fd, 1);
  80156f:	83 ec 08             	sub    $0x8,%esp
  801572:	6a 01                	push   $0x1
  801574:	ff 75 f4             	pushl  -0xc(%ebp)
  801577:	e8 49 ff ff ff       	call   8014c5 <fd_close>
  80157c:	83 c4 10             	add    $0x10,%esp
  80157f:	eb ec                	jmp    80156d <close+0x1d>

00801581 <close_all>:

void
close_all(void)
{
  801581:	f3 0f 1e fb          	endbr32 
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	53                   	push   %ebx
  801589:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80158c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801591:	83 ec 0c             	sub    $0xc,%esp
  801594:	53                   	push   %ebx
  801595:	e8 b6 ff ff ff       	call   801550 <close>
	for (i = 0; i < MAXFD; i++)
  80159a:	83 c3 01             	add    $0x1,%ebx
  80159d:	83 c4 10             	add    $0x10,%esp
  8015a0:	83 fb 20             	cmp    $0x20,%ebx
  8015a3:	75 ec                	jne    801591 <close_all+0x10>
}
  8015a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015a8:	c9                   	leave  
  8015a9:	c3                   	ret    

008015aa <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015aa:	f3 0f 1e fb          	endbr32 
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	57                   	push   %edi
  8015b2:	56                   	push   %esi
  8015b3:	53                   	push   %ebx
  8015b4:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015b7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015ba:	50                   	push   %eax
  8015bb:	ff 75 08             	pushl  0x8(%ebp)
  8015be:	e8 4f fe ff ff       	call   801412 <fd_lookup>
  8015c3:	89 c3                	mov    %eax,%ebx
  8015c5:	83 c4 10             	add    $0x10,%esp
  8015c8:	85 c0                	test   %eax,%eax
  8015ca:	0f 88 81 00 00 00    	js     801651 <dup+0xa7>
		return r;
	close(newfdnum);
  8015d0:	83 ec 0c             	sub    $0xc,%esp
  8015d3:	ff 75 0c             	pushl  0xc(%ebp)
  8015d6:	e8 75 ff ff ff       	call   801550 <close>

	newfd = INDEX2FD(newfdnum);
  8015db:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015de:	c1 e6 0c             	shl    $0xc,%esi
  8015e1:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015e7:	83 c4 04             	add    $0x4,%esp
  8015ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015ed:	e8 af fd ff ff       	call   8013a1 <fd2data>
  8015f2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015f4:	89 34 24             	mov    %esi,(%esp)
  8015f7:	e8 a5 fd ff ff       	call   8013a1 <fd2data>
  8015fc:	83 c4 10             	add    $0x10,%esp
  8015ff:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801601:	89 d8                	mov    %ebx,%eax
  801603:	c1 e8 16             	shr    $0x16,%eax
  801606:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80160d:	a8 01                	test   $0x1,%al
  80160f:	74 11                	je     801622 <dup+0x78>
  801611:	89 d8                	mov    %ebx,%eax
  801613:	c1 e8 0c             	shr    $0xc,%eax
  801616:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80161d:	f6 c2 01             	test   $0x1,%dl
  801620:	75 39                	jne    80165b <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801622:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801625:	89 d0                	mov    %edx,%eax
  801627:	c1 e8 0c             	shr    $0xc,%eax
  80162a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801631:	83 ec 0c             	sub    $0xc,%esp
  801634:	25 07 0e 00 00       	and    $0xe07,%eax
  801639:	50                   	push   %eax
  80163a:	56                   	push   %esi
  80163b:	6a 00                	push   $0x0
  80163d:	52                   	push   %edx
  80163e:	6a 00                	push   $0x0
  801640:	e8 d6 f7 ff ff       	call   800e1b <sys_page_map>
  801645:	89 c3                	mov    %eax,%ebx
  801647:	83 c4 20             	add    $0x20,%esp
  80164a:	85 c0                	test   %eax,%eax
  80164c:	78 31                	js     80167f <dup+0xd5>
		goto err;

	return newfdnum;
  80164e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801651:	89 d8                	mov    %ebx,%eax
  801653:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801656:	5b                   	pop    %ebx
  801657:	5e                   	pop    %esi
  801658:	5f                   	pop    %edi
  801659:	5d                   	pop    %ebp
  80165a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80165b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801662:	83 ec 0c             	sub    $0xc,%esp
  801665:	25 07 0e 00 00       	and    $0xe07,%eax
  80166a:	50                   	push   %eax
  80166b:	57                   	push   %edi
  80166c:	6a 00                	push   $0x0
  80166e:	53                   	push   %ebx
  80166f:	6a 00                	push   $0x0
  801671:	e8 a5 f7 ff ff       	call   800e1b <sys_page_map>
  801676:	89 c3                	mov    %eax,%ebx
  801678:	83 c4 20             	add    $0x20,%esp
  80167b:	85 c0                	test   %eax,%eax
  80167d:	79 a3                	jns    801622 <dup+0x78>
	sys_page_unmap(0, newfd);
  80167f:	83 ec 08             	sub    $0x8,%esp
  801682:	56                   	push   %esi
  801683:	6a 00                	push   $0x0
  801685:	e8 d7 f7 ff ff       	call   800e61 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80168a:	83 c4 08             	add    $0x8,%esp
  80168d:	57                   	push   %edi
  80168e:	6a 00                	push   $0x0
  801690:	e8 cc f7 ff ff       	call   800e61 <sys_page_unmap>
	return r;
  801695:	83 c4 10             	add    $0x10,%esp
  801698:	eb b7                	jmp    801651 <dup+0xa7>

0080169a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80169a:	f3 0f 1e fb          	endbr32 
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	53                   	push   %ebx
  8016a2:	83 ec 1c             	sub    $0x1c,%esp
  8016a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016ab:	50                   	push   %eax
  8016ac:	53                   	push   %ebx
  8016ad:	e8 60 fd ff ff       	call   801412 <fd_lookup>
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	85 c0                	test   %eax,%eax
  8016b7:	78 3f                	js     8016f8 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016b9:	83 ec 08             	sub    $0x8,%esp
  8016bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016bf:	50                   	push   %eax
  8016c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c3:	ff 30                	pushl  (%eax)
  8016c5:	e8 9c fd ff ff       	call   801466 <dev_lookup>
  8016ca:	83 c4 10             	add    $0x10,%esp
  8016cd:	85 c0                	test   %eax,%eax
  8016cf:	78 27                	js     8016f8 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016d4:	8b 42 08             	mov    0x8(%edx),%eax
  8016d7:	83 e0 03             	and    $0x3,%eax
  8016da:	83 f8 01             	cmp    $0x1,%eax
  8016dd:	74 1e                	je     8016fd <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e2:	8b 40 08             	mov    0x8(%eax),%eax
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	74 35                	je     80171e <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016e9:	83 ec 04             	sub    $0x4,%esp
  8016ec:	ff 75 10             	pushl  0x10(%ebp)
  8016ef:	ff 75 0c             	pushl  0xc(%ebp)
  8016f2:	52                   	push   %edx
  8016f3:	ff d0                	call   *%eax
  8016f5:	83 c4 10             	add    $0x10,%esp
}
  8016f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016fd:	a1 08 50 80 00       	mov    0x805008,%eax
  801702:	8b 40 48             	mov    0x48(%eax),%eax
  801705:	83 ec 04             	sub    $0x4,%esp
  801708:	53                   	push   %ebx
  801709:	50                   	push   %eax
  80170a:	68 dd 2e 80 00       	push   $0x802edd
  80170f:	e8 74 ec ff ff       	call   800388 <cprintf>
		return -E_INVAL;
  801714:	83 c4 10             	add    $0x10,%esp
  801717:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80171c:	eb da                	jmp    8016f8 <read+0x5e>
		return -E_NOT_SUPP;
  80171e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801723:	eb d3                	jmp    8016f8 <read+0x5e>

00801725 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801725:	f3 0f 1e fb          	endbr32 
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	57                   	push   %edi
  80172d:	56                   	push   %esi
  80172e:	53                   	push   %ebx
  80172f:	83 ec 0c             	sub    $0xc,%esp
  801732:	8b 7d 08             	mov    0x8(%ebp),%edi
  801735:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801738:	bb 00 00 00 00       	mov    $0x0,%ebx
  80173d:	eb 02                	jmp    801741 <readn+0x1c>
  80173f:	01 c3                	add    %eax,%ebx
  801741:	39 f3                	cmp    %esi,%ebx
  801743:	73 21                	jae    801766 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801745:	83 ec 04             	sub    $0x4,%esp
  801748:	89 f0                	mov    %esi,%eax
  80174a:	29 d8                	sub    %ebx,%eax
  80174c:	50                   	push   %eax
  80174d:	89 d8                	mov    %ebx,%eax
  80174f:	03 45 0c             	add    0xc(%ebp),%eax
  801752:	50                   	push   %eax
  801753:	57                   	push   %edi
  801754:	e8 41 ff ff ff       	call   80169a <read>
		if (m < 0)
  801759:	83 c4 10             	add    $0x10,%esp
  80175c:	85 c0                	test   %eax,%eax
  80175e:	78 04                	js     801764 <readn+0x3f>
			return m;
		if (m == 0)
  801760:	75 dd                	jne    80173f <readn+0x1a>
  801762:	eb 02                	jmp    801766 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801764:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801766:	89 d8                	mov    %ebx,%eax
  801768:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80176b:	5b                   	pop    %ebx
  80176c:	5e                   	pop    %esi
  80176d:	5f                   	pop    %edi
  80176e:	5d                   	pop    %ebp
  80176f:	c3                   	ret    

00801770 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801770:	f3 0f 1e fb          	endbr32 
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	53                   	push   %ebx
  801778:	83 ec 1c             	sub    $0x1c,%esp
  80177b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80177e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801781:	50                   	push   %eax
  801782:	53                   	push   %ebx
  801783:	e8 8a fc ff ff       	call   801412 <fd_lookup>
  801788:	83 c4 10             	add    $0x10,%esp
  80178b:	85 c0                	test   %eax,%eax
  80178d:	78 3a                	js     8017c9 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80178f:	83 ec 08             	sub    $0x8,%esp
  801792:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801795:	50                   	push   %eax
  801796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801799:	ff 30                	pushl  (%eax)
  80179b:	e8 c6 fc ff ff       	call   801466 <dev_lookup>
  8017a0:	83 c4 10             	add    $0x10,%esp
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	78 22                	js     8017c9 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017aa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017ae:	74 1e                	je     8017ce <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b3:	8b 52 0c             	mov    0xc(%edx),%edx
  8017b6:	85 d2                	test   %edx,%edx
  8017b8:	74 35                	je     8017ef <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017ba:	83 ec 04             	sub    $0x4,%esp
  8017bd:	ff 75 10             	pushl  0x10(%ebp)
  8017c0:	ff 75 0c             	pushl  0xc(%ebp)
  8017c3:	50                   	push   %eax
  8017c4:	ff d2                	call   *%edx
  8017c6:	83 c4 10             	add    $0x10,%esp
}
  8017c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017ce:	a1 08 50 80 00       	mov    0x805008,%eax
  8017d3:	8b 40 48             	mov    0x48(%eax),%eax
  8017d6:	83 ec 04             	sub    $0x4,%esp
  8017d9:	53                   	push   %ebx
  8017da:	50                   	push   %eax
  8017db:	68 f9 2e 80 00       	push   $0x802ef9
  8017e0:	e8 a3 eb ff ff       	call   800388 <cprintf>
		return -E_INVAL;
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017ed:	eb da                	jmp    8017c9 <write+0x59>
		return -E_NOT_SUPP;
  8017ef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017f4:	eb d3                	jmp    8017c9 <write+0x59>

008017f6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017f6:	f3 0f 1e fb          	endbr32 
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801800:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801803:	50                   	push   %eax
  801804:	ff 75 08             	pushl  0x8(%ebp)
  801807:	e8 06 fc ff ff       	call   801412 <fd_lookup>
  80180c:	83 c4 10             	add    $0x10,%esp
  80180f:	85 c0                	test   %eax,%eax
  801811:	78 0e                	js     801821 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801813:	8b 55 0c             	mov    0xc(%ebp),%edx
  801816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801819:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80181c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801823:	f3 0f 1e fb          	endbr32 
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	53                   	push   %ebx
  80182b:	83 ec 1c             	sub    $0x1c,%esp
  80182e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801831:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801834:	50                   	push   %eax
  801835:	53                   	push   %ebx
  801836:	e8 d7 fb ff ff       	call   801412 <fd_lookup>
  80183b:	83 c4 10             	add    $0x10,%esp
  80183e:	85 c0                	test   %eax,%eax
  801840:	78 37                	js     801879 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801842:	83 ec 08             	sub    $0x8,%esp
  801845:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801848:	50                   	push   %eax
  801849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184c:	ff 30                	pushl  (%eax)
  80184e:	e8 13 fc ff ff       	call   801466 <dev_lookup>
  801853:	83 c4 10             	add    $0x10,%esp
  801856:	85 c0                	test   %eax,%eax
  801858:	78 1f                	js     801879 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80185a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801861:	74 1b                	je     80187e <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801863:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801866:	8b 52 18             	mov    0x18(%edx),%edx
  801869:	85 d2                	test   %edx,%edx
  80186b:	74 32                	je     80189f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80186d:	83 ec 08             	sub    $0x8,%esp
  801870:	ff 75 0c             	pushl  0xc(%ebp)
  801873:	50                   	push   %eax
  801874:	ff d2                	call   *%edx
  801876:	83 c4 10             	add    $0x10,%esp
}
  801879:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80187e:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801883:	8b 40 48             	mov    0x48(%eax),%eax
  801886:	83 ec 04             	sub    $0x4,%esp
  801889:	53                   	push   %ebx
  80188a:	50                   	push   %eax
  80188b:	68 bc 2e 80 00       	push   $0x802ebc
  801890:	e8 f3 ea ff ff       	call   800388 <cprintf>
		return -E_INVAL;
  801895:	83 c4 10             	add    $0x10,%esp
  801898:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80189d:	eb da                	jmp    801879 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80189f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018a4:	eb d3                	jmp    801879 <ftruncate+0x56>

008018a6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018a6:	f3 0f 1e fb          	endbr32 
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	53                   	push   %ebx
  8018ae:	83 ec 1c             	sub    $0x1c,%esp
  8018b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018b7:	50                   	push   %eax
  8018b8:	ff 75 08             	pushl  0x8(%ebp)
  8018bb:	e8 52 fb ff ff       	call   801412 <fd_lookup>
  8018c0:	83 c4 10             	add    $0x10,%esp
  8018c3:	85 c0                	test   %eax,%eax
  8018c5:	78 4b                	js     801912 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018c7:	83 ec 08             	sub    $0x8,%esp
  8018ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018cd:	50                   	push   %eax
  8018ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d1:	ff 30                	pushl  (%eax)
  8018d3:	e8 8e fb ff ff       	call   801466 <dev_lookup>
  8018d8:	83 c4 10             	add    $0x10,%esp
  8018db:	85 c0                	test   %eax,%eax
  8018dd:	78 33                	js     801912 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8018df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e2:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018e6:	74 2f                	je     801917 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018e8:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018eb:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018f2:	00 00 00 
	stat->st_isdir = 0;
  8018f5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018fc:	00 00 00 
	stat->st_dev = dev;
  8018ff:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801905:	83 ec 08             	sub    $0x8,%esp
  801908:	53                   	push   %ebx
  801909:	ff 75 f0             	pushl  -0x10(%ebp)
  80190c:	ff 50 14             	call   *0x14(%eax)
  80190f:	83 c4 10             	add    $0x10,%esp
}
  801912:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801915:	c9                   	leave  
  801916:	c3                   	ret    
		return -E_NOT_SUPP;
  801917:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80191c:	eb f4                	jmp    801912 <fstat+0x6c>

0080191e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80191e:	f3 0f 1e fb          	endbr32 
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	56                   	push   %esi
  801926:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801927:	83 ec 08             	sub    $0x8,%esp
  80192a:	6a 00                	push   $0x0
  80192c:	ff 75 08             	pushl  0x8(%ebp)
  80192f:	e8 fb 01 00 00       	call   801b2f <open>
  801934:	89 c3                	mov    %eax,%ebx
  801936:	83 c4 10             	add    $0x10,%esp
  801939:	85 c0                	test   %eax,%eax
  80193b:	78 1b                	js     801958 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80193d:	83 ec 08             	sub    $0x8,%esp
  801940:	ff 75 0c             	pushl  0xc(%ebp)
  801943:	50                   	push   %eax
  801944:	e8 5d ff ff ff       	call   8018a6 <fstat>
  801949:	89 c6                	mov    %eax,%esi
	close(fd);
  80194b:	89 1c 24             	mov    %ebx,(%esp)
  80194e:	e8 fd fb ff ff       	call   801550 <close>
	return r;
  801953:	83 c4 10             	add    $0x10,%esp
  801956:	89 f3                	mov    %esi,%ebx
}
  801958:	89 d8                	mov    %ebx,%eax
  80195a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80195d:	5b                   	pop    %ebx
  80195e:	5e                   	pop    %esi
  80195f:	5d                   	pop    %ebp
  801960:	c3                   	ret    

00801961 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
  801964:	56                   	push   %esi
  801965:	53                   	push   %ebx
  801966:	89 c6                	mov    %eax,%esi
  801968:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80196a:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801971:	74 27                	je     80199a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801973:	6a 07                	push   $0x7
  801975:	68 00 60 80 00       	push   $0x806000
  80197a:	56                   	push   %esi
  80197b:	ff 35 00 50 80 00    	pushl  0x805000
  801981:	e8 27 0d 00 00       	call   8026ad <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801986:	83 c4 0c             	add    $0xc,%esp
  801989:	6a 00                	push   $0x0
  80198b:	53                   	push   %ebx
  80198c:	6a 00                	push   $0x0
  80198e:	e8 95 0c 00 00       	call   802628 <ipc_recv>
}
  801993:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801996:	5b                   	pop    %ebx
  801997:	5e                   	pop    %esi
  801998:	5d                   	pop    %ebp
  801999:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80199a:	83 ec 0c             	sub    $0xc,%esp
  80199d:	6a 01                	push   $0x1
  80199f:	e8 61 0d 00 00       	call   802705 <ipc_find_env>
  8019a4:	a3 00 50 80 00       	mov    %eax,0x805000
  8019a9:	83 c4 10             	add    $0x10,%esp
  8019ac:	eb c5                	jmp    801973 <fsipc+0x12>

008019ae <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019ae:	f3 0f 1e fb          	endbr32 
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
  8019b5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8019be:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8019c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c6:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d0:	b8 02 00 00 00       	mov    $0x2,%eax
  8019d5:	e8 87 ff ff ff       	call   801961 <fsipc>
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <devfile_flush>:
{
  8019dc:	f3 0f 1e fb          	endbr32 
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ec:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8019f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f6:	b8 06 00 00 00       	mov    $0x6,%eax
  8019fb:	e8 61 ff ff ff       	call   801961 <fsipc>
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <devfile_stat>:
{
  801a02:	f3 0f 1e fb          	endbr32 
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	53                   	push   %ebx
  801a0a:	83 ec 04             	sub    $0x4,%esp
  801a0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	8b 40 0c             	mov    0xc(%eax),%eax
  801a16:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a1b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a20:	b8 05 00 00 00       	mov    $0x5,%eax
  801a25:	e8 37 ff ff ff       	call   801961 <fsipc>
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	78 2c                	js     801a5a <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a2e:	83 ec 08             	sub    $0x8,%esp
  801a31:	68 00 60 80 00       	push   $0x806000
  801a36:	53                   	push   %ebx
  801a37:	e8 56 ef ff ff       	call   800992 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a3c:	a1 80 60 80 00       	mov    0x806080,%eax
  801a41:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a47:	a1 84 60 80 00       	mov    0x806084,%eax
  801a4c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a52:	83 c4 10             	add    $0x10,%esp
  801a55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <devfile_write>:
{
  801a5f:	f3 0f 1e fb          	endbr32 
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 0c             	sub    $0xc,%esp
  801a69:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a6c:	8b 55 08             	mov    0x8(%ebp),%edx
  801a6f:	8b 52 0c             	mov    0xc(%edx),%edx
  801a72:	89 15 00 60 80 00    	mov    %edx,0x806000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801a78:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a7d:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801a82:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801a85:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801a8a:	50                   	push   %eax
  801a8b:	ff 75 0c             	pushl  0xc(%ebp)
  801a8e:	68 08 60 80 00       	push   $0x806008
  801a93:	e8 b0 f0 ff ff       	call   800b48 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801a98:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9d:	b8 04 00 00 00       	mov    $0x4,%eax
  801aa2:	e8 ba fe ff ff       	call   801961 <fsipc>
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <devfile_read>:
{
  801aa9:	f3 0f 1e fb          	endbr32 
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
  801ab0:	56                   	push   %esi
  801ab1:	53                   	push   %ebx
  801ab2:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	8b 40 0c             	mov    0xc(%eax),%eax
  801abb:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ac0:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ac6:	ba 00 00 00 00       	mov    $0x0,%edx
  801acb:	b8 03 00 00 00       	mov    $0x3,%eax
  801ad0:	e8 8c fe ff ff       	call   801961 <fsipc>
  801ad5:	89 c3                	mov    %eax,%ebx
  801ad7:	85 c0                	test   %eax,%eax
  801ad9:	78 1f                	js     801afa <devfile_read+0x51>
	assert(r <= n);
  801adb:	39 f0                	cmp    %esi,%eax
  801add:	77 24                	ja     801b03 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801adf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ae4:	7f 33                	jg     801b19 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ae6:	83 ec 04             	sub    $0x4,%esp
  801ae9:	50                   	push   %eax
  801aea:	68 00 60 80 00       	push   $0x806000
  801aef:	ff 75 0c             	pushl  0xc(%ebp)
  801af2:	e8 51 f0 ff ff       	call   800b48 <memmove>
	return r;
  801af7:	83 c4 10             	add    $0x10,%esp
}
  801afa:	89 d8                	mov    %ebx,%eax
  801afc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aff:	5b                   	pop    %ebx
  801b00:	5e                   	pop    %esi
  801b01:	5d                   	pop    %ebp
  801b02:	c3                   	ret    
	assert(r <= n);
  801b03:	68 2c 2f 80 00       	push   $0x802f2c
  801b08:	68 33 2f 80 00       	push   $0x802f33
  801b0d:	6a 7c                	push   $0x7c
  801b0f:	68 48 2f 80 00       	push   $0x802f48
  801b14:	e8 88 e7 ff ff       	call   8002a1 <_panic>
	assert(r <= PGSIZE);
  801b19:	68 53 2f 80 00       	push   $0x802f53
  801b1e:	68 33 2f 80 00       	push   $0x802f33
  801b23:	6a 7d                	push   $0x7d
  801b25:	68 48 2f 80 00       	push   $0x802f48
  801b2a:	e8 72 e7 ff ff       	call   8002a1 <_panic>

00801b2f <open>:
{
  801b2f:	f3 0f 1e fb          	endbr32 
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
  801b36:	56                   	push   %esi
  801b37:	53                   	push   %ebx
  801b38:	83 ec 1c             	sub    $0x1c,%esp
  801b3b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b3e:	56                   	push   %esi
  801b3f:	e8 0b ee ff ff       	call   80094f <strlen>
  801b44:	83 c4 10             	add    $0x10,%esp
  801b47:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b4c:	7f 6c                	jg     801bba <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801b4e:	83 ec 0c             	sub    $0xc,%esp
  801b51:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b54:	50                   	push   %eax
  801b55:	e8 62 f8 ff ff       	call   8013bc <fd_alloc>
  801b5a:	89 c3                	mov    %eax,%ebx
  801b5c:	83 c4 10             	add    $0x10,%esp
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	78 3c                	js     801b9f <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801b63:	83 ec 08             	sub    $0x8,%esp
  801b66:	56                   	push   %esi
  801b67:	68 00 60 80 00       	push   $0x806000
  801b6c:	e8 21 ee ff ff       	call   800992 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b74:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b7c:	b8 01 00 00 00       	mov    $0x1,%eax
  801b81:	e8 db fd ff ff       	call   801961 <fsipc>
  801b86:	89 c3                	mov    %eax,%ebx
  801b88:	83 c4 10             	add    $0x10,%esp
  801b8b:	85 c0                	test   %eax,%eax
  801b8d:	78 19                	js     801ba8 <open+0x79>
	return fd2num(fd);
  801b8f:	83 ec 0c             	sub    $0xc,%esp
  801b92:	ff 75 f4             	pushl  -0xc(%ebp)
  801b95:	e8 f3 f7 ff ff       	call   80138d <fd2num>
  801b9a:	89 c3                	mov    %eax,%ebx
  801b9c:	83 c4 10             	add    $0x10,%esp
}
  801b9f:	89 d8                	mov    %ebx,%eax
  801ba1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba4:	5b                   	pop    %ebx
  801ba5:	5e                   	pop    %esi
  801ba6:	5d                   	pop    %ebp
  801ba7:	c3                   	ret    
		fd_close(fd, 0);
  801ba8:	83 ec 08             	sub    $0x8,%esp
  801bab:	6a 00                	push   $0x0
  801bad:	ff 75 f4             	pushl  -0xc(%ebp)
  801bb0:	e8 10 f9 ff ff       	call   8014c5 <fd_close>
		return r;
  801bb5:	83 c4 10             	add    $0x10,%esp
  801bb8:	eb e5                	jmp    801b9f <open+0x70>
		return -E_BAD_PATH;
  801bba:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bbf:	eb de                	jmp    801b9f <open+0x70>

00801bc1 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bc1:	f3 0f 1e fb          	endbr32 
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
  801bc8:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bcb:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd0:	b8 08 00 00 00       	mov    $0x8,%eax
  801bd5:	e8 87 fd ff ff       	call   801961 <fsipc>
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801bdc:	f3 0f 1e fb          	endbr32 
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801be6:	68 5f 2f 80 00       	push   $0x802f5f
  801beb:	ff 75 0c             	pushl  0xc(%ebp)
  801bee:	e8 9f ed ff ff       	call   800992 <strcpy>
	return 0;
}
  801bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <devsock_close>:
{
  801bfa:	f3 0f 1e fb          	endbr32 
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	53                   	push   %ebx
  801c02:	83 ec 10             	sub    $0x10,%esp
  801c05:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801c08:	53                   	push   %ebx
  801c09:	e8 34 0b 00 00       	call   802742 <pageref>
  801c0e:	89 c2                	mov    %eax,%edx
  801c10:	83 c4 10             	add    $0x10,%esp
		return 0;
  801c13:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801c18:	83 fa 01             	cmp    $0x1,%edx
  801c1b:	74 05                	je     801c22 <devsock_close+0x28>
}
  801c1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801c22:	83 ec 0c             	sub    $0xc,%esp
  801c25:	ff 73 0c             	pushl  0xc(%ebx)
  801c28:	e8 e3 02 00 00       	call   801f10 <nsipc_close>
  801c2d:	83 c4 10             	add    $0x10,%esp
  801c30:	eb eb                	jmp    801c1d <devsock_close+0x23>

00801c32 <devsock_write>:
{
  801c32:	f3 0f 1e fb          	endbr32 
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c3c:	6a 00                	push   $0x0
  801c3e:	ff 75 10             	pushl  0x10(%ebp)
  801c41:	ff 75 0c             	pushl  0xc(%ebp)
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	ff 70 0c             	pushl  0xc(%eax)
  801c4a:	e8 b5 03 00 00       	call   802004 <nsipc_send>
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <devsock_read>:
{
  801c51:	f3 0f 1e fb          	endbr32 
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801c5b:	6a 00                	push   $0x0
  801c5d:	ff 75 10             	pushl  0x10(%ebp)
  801c60:	ff 75 0c             	pushl  0xc(%ebp)
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	ff 70 0c             	pushl  0xc(%eax)
  801c69:	e8 1f 03 00 00       	call   801f8d <nsipc_recv>
}
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <fd2sockid>:
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c76:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c79:	52                   	push   %edx
  801c7a:	50                   	push   %eax
  801c7b:	e8 92 f7 ff ff       	call   801412 <fd_lookup>
  801c80:	83 c4 10             	add    $0x10,%esp
  801c83:	85 c0                	test   %eax,%eax
  801c85:	78 10                	js     801c97 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8a:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801c90:	39 08                	cmp    %ecx,(%eax)
  801c92:	75 05                	jne    801c99 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801c94:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    
		return -E_NOT_SUPP;
  801c99:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c9e:	eb f7                	jmp    801c97 <fd2sockid+0x27>

00801ca0 <alloc_sockfd>:
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	56                   	push   %esi
  801ca4:	53                   	push   %ebx
  801ca5:	83 ec 1c             	sub    $0x1c,%esp
  801ca8:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801caa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cad:	50                   	push   %eax
  801cae:	e8 09 f7 ff ff       	call   8013bc <fd_alloc>
  801cb3:	89 c3                	mov    %eax,%ebx
  801cb5:	83 c4 10             	add    $0x10,%esp
  801cb8:	85 c0                	test   %eax,%eax
  801cba:	78 43                	js     801cff <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801cbc:	83 ec 04             	sub    $0x4,%esp
  801cbf:	68 07 04 00 00       	push   $0x407
  801cc4:	ff 75 f4             	pushl  -0xc(%ebp)
  801cc7:	6a 00                	push   $0x0
  801cc9:	e8 06 f1 ff ff       	call   800dd4 <sys_page_alloc>
  801cce:	89 c3                	mov    %eax,%ebx
  801cd0:	83 c4 10             	add    $0x10,%esp
  801cd3:	85 c0                	test   %eax,%eax
  801cd5:	78 28                	js     801cff <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cda:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801ce0:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801cec:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801cef:	83 ec 0c             	sub    $0xc,%esp
  801cf2:	50                   	push   %eax
  801cf3:	e8 95 f6 ff ff       	call   80138d <fd2num>
  801cf8:	89 c3                	mov    %eax,%ebx
  801cfa:	83 c4 10             	add    $0x10,%esp
  801cfd:	eb 0c                	jmp    801d0b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801cff:	83 ec 0c             	sub    $0xc,%esp
  801d02:	56                   	push   %esi
  801d03:	e8 08 02 00 00       	call   801f10 <nsipc_close>
		return r;
  801d08:	83 c4 10             	add    $0x10,%esp
}
  801d0b:	89 d8                	mov    %ebx,%eax
  801d0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d10:	5b                   	pop    %ebx
  801d11:	5e                   	pop    %esi
  801d12:	5d                   	pop    %ebp
  801d13:	c3                   	ret    

00801d14 <accept>:
{
  801d14:	f3 0f 1e fb          	endbr32 
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d21:	e8 4a ff ff ff       	call   801c70 <fd2sockid>
  801d26:	85 c0                	test   %eax,%eax
  801d28:	78 1b                	js     801d45 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d2a:	83 ec 04             	sub    $0x4,%esp
  801d2d:	ff 75 10             	pushl  0x10(%ebp)
  801d30:	ff 75 0c             	pushl  0xc(%ebp)
  801d33:	50                   	push   %eax
  801d34:	e8 22 01 00 00       	call   801e5b <nsipc_accept>
  801d39:	83 c4 10             	add    $0x10,%esp
  801d3c:	85 c0                	test   %eax,%eax
  801d3e:	78 05                	js     801d45 <accept+0x31>
	return alloc_sockfd(r);
  801d40:	e8 5b ff ff ff       	call   801ca0 <alloc_sockfd>
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <bind>:
{
  801d47:	f3 0f 1e fb          	endbr32 
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	e8 17 ff ff ff       	call   801c70 <fd2sockid>
  801d59:	85 c0                	test   %eax,%eax
  801d5b:	78 12                	js     801d6f <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801d5d:	83 ec 04             	sub    $0x4,%esp
  801d60:	ff 75 10             	pushl  0x10(%ebp)
  801d63:	ff 75 0c             	pushl  0xc(%ebp)
  801d66:	50                   	push   %eax
  801d67:	e8 45 01 00 00       	call   801eb1 <nsipc_bind>
  801d6c:	83 c4 10             	add    $0x10,%esp
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <shutdown>:
{
  801d71:	f3 0f 1e fb          	endbr32 
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	e8 ed fe ff ff       	call   801c70 <fd2sockid>
  801d83:	85 c0                	test   %eax,%eax
  801d85:	78 0f                	js     801d96 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801d87:	83 ec 08             	sub    $0x8,%esp
  801d8a:	ff 75 0c             	pushl  0xc(%ebp)
  801d8d:	50                   	push   %eax
  801d8e:	e8 57 01 00 00       	call   801eea <nsipc_shutdown>
  801d93:	83 c4 10             	add    $0x10,%esp
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <connect>:
{
  801d98:	f3 0f 1e fb          	endbr32 
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	e8 c6 fe ff ff       	call   801c70 <fd2sockid>
  801daa:	85 c0                	test   %eax,%eax
  801dac:	78 12                	js     801dc0 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801dae:	83 ec 04             	sub    $0x4,%esp
  801db1:	ff 75 10             	pushl  0x10(%ebp)
  801db4:	ff 75 0c             	pushl  0xc(%ebp)
  801db7:	50                   	push   %eax
  801db8:	e8 71 01 00 00       	call   801f2e <nsipc_connect>
  801dbd:	83 c4 10             	add    $0x10,%esp
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <listen>:
{
  801dc2:	f3 0f 1e fb          	endbr32 
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
  801dc9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	e8 9c fe ff ff       	call   801c70 <fd2sockid>
  801dd4:	85 c0                	test   %eax,%eax
  801dd6:	78 0f                	js     801de7 <listen+0x25>
	return nsipc_listen(r, backlog);
  801dd8:	83 ec 08             	sub    $0x8,%esp
  801ddb:	ff 75 0c             	pushl  0xc(%ebp)
  801dde:	50                   	push   %eax
  801ddf:	e8 83 01 00 00       	call   801f67 <nsipc_listen>
  801de4:	83 c4 10             	add    $0x10,%esp
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <socket>:

int
socket(int domain, int type, int protocol)
{
  801de9:	f3 0f 1e fb          	endbr32 
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801df3:	ff 75 10             	pushl  0x10(%ebp)
  801df6:	ff 75 0c             	pushl  0xc(%ebp)
  801df9:	ff 75 08             	pushl  0x8(%ebp)
  801dfc:	e8 65 02 00 00       	call   802066 <nsipc_socket>
  801e01:	83 c4 10             	add    $0x10,%esp
  801e04:	85 c0                	test   %eax,%eax
  801e06:	78 05                	js     801e0d <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801e08:	e8 93 fe ff ff       	call   801ca0 <alloc_sockfd>
}
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    

00801e0f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
  801e12:	53                   	push   %ebx
  801e13:	83 ec 04             	sub    $0x4,%esp
  801e16:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e18:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801e1f:	74 26                	je     801e47 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e21:	6a 07                	push   $0x7
  801e23:	68 00 70 80 00       	push   $0x807000
  801e28:	53                   	push   %ebx
  801e29:	ff 35 04 50 80 00    	pushl  0x805004
  801e2f:	e8 79 08 00 00       	call   8026ad <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801e34:	83 c4 0c             	add    $0xc,%esp
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	e8 e6 07 00 00       	call   802628 <ipc_recv>
}
  801e42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e47:	83 ec 0c             	sub    $0xc,%esp
  801e4a:	6a 02                	push   $0x2
  801e4c:	e8 b4 08 00 00       	call   802705 <ipc_find_env>
  801e51:	a3 04 50 80 00       	mov    %eax,0x805004
  801e56:	83 c4 10             	add    $0x10,%esp
  801e59:	eb c6                	jmp    801e21 <nsipc+0x12>

00801e5b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e5b:	f3 0f 1e fb          	endbr32 
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	56                   	push   %esi
  801e63:	53                   	push   %ebx
  801e64:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801e67:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801e6f:	8b 06                	mov    (%esi),%eax
  801e71:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e76:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7b:	e8 8f ff ff ff       	call   801e0f <nsipc>
  801e80:	89 c3                	mov    %eax,%ebx
  801e82:	85 c0                	test   %eax,%eax
  801e84:	79 09                	jns    801e8f <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801e86:	89 d8                	mov    %ebx,%eax
  801e88:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e8b:	5b                   	pop    %ebx
  801e8c:	5e                   	pop    %esi
  801e8d:	5d                   	pop    %ebp
  801e8e:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e8f:	83 ec 04             	sub    $0x4,%esp
  801e92:	ff 35 10 70 80 00    	pushl  0x807010
  801e98:	68 00 70 80 00       	push   $0x807000
  801e9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ea0:	e8 a3 ec ff ff       	call   800b48 <memmove>
		*addrlen = ret->ret_addrlen;
  801ea5:	a1 10 70 80 00       	mov    0x807010,%eax
  801eaa:	89 06                	mov    %eax,(%esi)
  801eac:	83 c4 10             	add    $0x10,%esp
	return r;
  801eaf:	eb d5                	jmp    801e86 <nsipc_accept+0x2b>

00801eb1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801eb1:	f3 0f 1e fb          	endbr32 
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	53                   	push   %ebx
  801eb9:	83 ec 08             	sub    $0x8,%esp
  801ebc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ec7:	53                   	push   %ebx
  801ec8:	ff 75 0c             	pushl  0xc(%ebp)
  801ecb:	68 04 70 80 00       	push   $0x807004
  801ed0:	e8 73 ec ff ff       	call   800b48 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ed5:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801edb:	b8 02 00 00 00       	mov    $0x2,%eax
  801ee0:	e8 2a ff ff ff       	call   801e0f <nsipc>
}
  801ee5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801eea:	f3 0f 1e fb          	endbr32 
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
  801ef1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eff:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801f04:	b8 03 00 00 00       	mov    $0x3,%eax
  801f09:	e8 01 ff ff ff       	call   801e0f <nsipc>
}
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    

00801f10 <nsipc_close>:

int
nsipc_close(int s)
{
  801f10:	f3 0f 1e fb          	endbr32 
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801f22:	b8 04 00 00 00       	mov    $0x4,%eax
  801f27:	e8 e3 fe ff ff       	call   801e0f <nsipc>
}
  801f2c:	c9                   	leave  
  801f2d:	c3                   	ret    

00801f2e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f2e:	f3 0f 1e fb          	endbr32 
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
  801f35:	53                   	push   %ebx
  801f36:	83 ec 08             	sub    $0x8,%esp
  801f39:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801f44:	53                   	push   %ebx
  801f45:	ff 75 0c             	pushl  0xc(%ebp)
  801f48:	68 04 70 80 00       	push   $0x807004
  801f4d:	e8 f6 eb ff ff       	call   800b48 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f52:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801f58:	b8 05 00 00 00       	mov    $0x5,%eax
  801f5d:	e8 ad fe ff ff       	call   801e0f <nsipc>
}
  801f62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801f67:	f3 0f 1e fb          	endbr32 
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f71:	8b 45 08             	mov    0x8(%ebp),%eax
  801f74:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  801f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f7c:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  801f81:	b8 06 00 00 00       	mov    $0x6,%eax
  801f86:	e8 84 fe ff ff       	call   801e0f <nsipc>
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f8d:	f3 0f 1e fb          	endbr32 
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	56                   	push   %esi
  801f95:	53                   	push   %ebx
  801f96:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  801fa1:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  801fa7:	8b 45 14             	mov    0x14(%ebp),%eax
  801faa:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801faf:	b8 07 00 00 00       	mov    $0x7,%eax
  801fb4:	e8 56 fe ff ff       	call   801e0f <nsipc>
  801fb9:	89 c3                	mov    %eax,%ebx
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	78 26                	js     801fe5 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801fbf:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801fc5:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801fca:	0f 4e c6             	cmovle %esi,%eax
  801fcd:	39 c3                	cmp    %eax,%ebx
  801fcf:	7f 1d                	jg     801fee <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801fd1:	83 ec 04             	sub    $0x4,%esp
  801fd4:	53                   	push   %ebx
  801fd5:	68 00 70 80 00       	push   $0x807000
  801fda:	ff 75 0c             	pushl  0xc(%ebp)
  801fdd:	e8 66 eb ff ff       	call   800b48 <memmove>
  801fe2:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801fe5:	89 d8                	mov    %ebx,%eax
  801fe7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fea:	5b                   	pop    %ebx
  801feb:	5e                   	pop    %esi
  801fec:	5d                   	pop    %ebp
  801fed:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801fee:	68 6b 2f 80 00       	push   $0x802f6b
  801ff3:	68 33 2f 80 00       	push   $0x802f33
  801ff8:	6a 62                	push   $0x62
  801ffa:	68 80 2f 80 00       	push   $0x802f80
  801fff:	e8 9d e2 ff ff       	call   8002a1 <_panic>

00802004 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802004:	f3 0f 1e fb          	endbr32 
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	53                   	push   %ebx
  80200c:	83 ec 04             	sub    $0x4,%esp
  80200f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802012:	8b 45 08             	mov    0x8(%ebp),%eax
  802015:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80201a:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802020:	7f 2e                	jg     802050 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802022:	83 ec 04             	sub    $0x4,%esp
  802025:	53                   	push   %ebx
  802026:	ff 75 0c             	pushl  0xc(%ebp)
  802029:	68 0c 70 80 00       	push   $0x80700c
  80202e:	e8 15 eb ff ff       	call   800b48 <memmove>
	nsipcbuf.send.req_size = size;
  802033:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802039:	8b 45 14             	mov    0x14(%ebp),%eax
  80203c:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802041:	b8 08 00 00 00       	mov    $0x8,%eax
  802046:	e8 c4 fd ff ff       	call   801e0f <nsipc>
}
  80204b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    
	assert(size < 1600);
  802050:	68 8c 2f 80 00       	push   $0x802f8c
  802055:	68 33 2f 80 00       	push   $0x802f33
  80205a:	6a 6d                	push   $0x6d
  80205c:	68 80 2f 80 00       	push   $0x802f80
  802061:	e8 3b e2 ff ff       	call   8002a1 <_panic>

00802066 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802066:	f3 0f 1e fb          	endbr32 
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207b:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802080:	8b 45 10             	mov    0x10(%ebp),%eax
  802083:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802088:	b8 09 00 00 00       	mov    $0x9,%eax
  80208d:	e8 7d fd ff ff       	call   801e0f <nsipc>
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802094:	f3 0f 1e fb          	endbr32 
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	56                   	push   %esi
  80209c:	53                   	push   %ebx
  80209d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8020a0:	83 ec 0c             	sub    $0xc,%esp
  8020a3:	ff 75 08             	pushl  0x8(%ebp)
  8020a6:	e8 f6 f2 ff ff       	call   8013a1 <fd2data>
  8020ab:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8020ad:	83 c4 08             	add    $0x8,%esp
  8020b0:	68 98 2f 80 00       	push   $0x802f98
  8020b5:	53                   	push   %ebx
  8020b6:	e8 d7 e8 ff ff       	call   800992 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8020bb:	8b 46 04             	mov    0x4(%esi),%eax
  8020be:	2b 06                	sub    (%esi),%eax
  8020c0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8020c6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8020cd:	00 00 00 
	stat->st_dev = &devpipe;
  8020d0:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8020d7:	40 80 00 
	return 0;
}
  8020da:	b8 00 00 00 00       	mov    $0x0,%eax
  8020df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e2:	5b                   	pop    %ebx
  8020e3:	5e                   	pop    %esi
  8020e4:	5d                   	pop    %ebp
  8020e5:	c3                   	ret    

008020e6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8020e6:	f3 0f 1e fb          	endbr32 
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
  8020ed:	53                   	push   %ebx
  8020ee:	83 ec 0c             	sub    $0xc,%esp
  8020f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8020f4:	53                   	push   %ebx
  8020f5:	6a 00                	push   $0x0
  8020f7:	e8 65 ed ff ff       	call   800e61 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8020fc:	89 1c 24             	mov    %ebx,(%esp)
  8020ff:	e8 9d f2 ff ff       	call   8013a1 <fd2data>
  802104:	83 c4 08             	add    $0x8,%esp
  802107:	50                   	push   %eax
  802108:	6a 00                	push   $0x0
  80210a:	e8 52 ed ff ff       	call   800e61 <sys_page_unmap>
}
  80210f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802112:	c9                   	leave  
  802113:	c3                   	ret    

00802114 <_pipeisclosed>:
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
  802117:	57                   	push   %edi
  802118:	56                   	push   %esi
  802119:	53                   	push   %ebx
  80211a:	83 ec 1c             	sub    $0x1c,%esp
  80211d:	89 c7                	mov    %eax,%edi
  80211f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802121:	a1 08 50 80 00       	mov    0x805008,%eax
  802126:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802129:	83 ec 0c             	sub    $0xc,%esp
  80212c:	57                   	push   %edi
  80212d:	e8 10 06 00 00       	call   802742 <pageref>
  802132:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802135:	89 34 24             	mov    %esi,(%esp)
  802138:	e8 05 06 00 00       	call   802742 <pageref>
		nn = thisenv->env_runs;
  80213d:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802143:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802146:	83 c4 10             	add    $0x10,%esp
  802149:	39 cb                	cmp    %ecx,%ebx
  80214b:	74 1b                	je     802168 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80214d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802150:	75 cf                	jne    802121 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802152:	8b 42 58             	mov    0x58(%edx),%eax
  802155:	6a 01                	push   $0x1
  802157:	50                   	push   %eax
  802158:	53                   	push   %ebx
  802159:	68 9f 2f 80 00       	push   $0x802f9f
  80215e:	e8 25 e2 ff ff       	call   800388 <cprintf>
  802163:	83 c4 10             	add    $0x10,%esp
  802166:	eb b9                	jmp    802121 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802168:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80216b:	0f 94 c0             	sete   %al
  80216e:	0f b6 c0             	movzbl %al,%eax
}
  802171:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802174:	5b                   	pop    %ebx
  802175:	5e                   	pop    %esi
  802176:	5f                   	pop    %edi
  802177:	5d                   	pop    %ebp
  802178:	c3                   	ret    

00802179 <devpipe_write>:
{
  802179:	f3 0f 1e fb          	endbr32 
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
  802180:	57                   	push   %edi
  802181:	56                   	push   %esi
  802182:	53                   	push   %ebx
  802183:	83 ec 28             	sub    $0x28,%esp
  802186:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802189:	56                   	push   %esi
  80218a:	e8 12 f2 ff ff       	call   8013a1 <fd2data>
  80218f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802191:	83 c4 10             	add    $0x10,%esp
  802194:	bf 00 00 00 00       	mov    $0x0,%edi
  802199:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80219c:	74 4f                	je     8021ed <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80219e:	8b 43 04             	mov    0x4(%ebx),%eax
  8021a1:	8b 0b                	mov    (%ebx),%ecx
  8021a3:	8d 51 20             	lea    0x20(%ecx),%edx
  8021a6:	39 d0                	cmp    %edx,%eax
  8021a8:	72 14                	jb     8021be <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8021aa:	89 da                	mov    %ebx,%edx
  8021ac:	89 f0                	mov    %esi,%eax
  8021ae:	e8 61 ff ff ff       	call   802114 <_pipeisclosed>
  8021b3:	85 c0                	test   %eax,%eax
  8021b5:	75 3b                	jne    8021f2 <devpipe_write+0x79>
			sys_yield();
  8021b7:	e8 f5 eb ff ff       	call   800db1 <sys_yield>
  8021bc:	eb e0                	jmp    80219e <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021c1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8021c5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8021c8:	89 c2                	mov    %eax,%edx
  8021ca:	c1 fa 1f             	sar    $0x1f,%edx
  8021cd:	89 d1                	mov    %edx,%ecx
  8021cf:	c1 e9 1b             	shr    $0x1b,%ecx
  8021d2:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8021d5:	83 e2 1f             	and    $0x1f,%edx
  8021d8:	29 ca                	sub    %ecx,%edx
  8021da:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8021de:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8021e2:	83 c0 01             	add    $0x1,%eax
  8021e5:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8021e8:	83 c7 01             	add    $0x1,%edi
  8021eb:	eb ac                	jmp    802199 <devpipe_write+0x20>
	return i;
  8021ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f0:	eb 05                	jmp    8021f7 <devpipe_write+0x7e>
				return 0;
  8021f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021fa:	5b                   	pop    %ebx
  8021fb:	5e                   	pop    %esi
  8021fc:	5f                   	pop    %edi
  8021fd:	5d                   	pop    %ebp
  8021fe:	c3                   	ret    

008021ff <devpipe_read>:
{
  8021ff:	f3 0f 1e fb          	endbr32 
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	57                   	push   %edi
  802207:	56                   	push   %esi
  802208:	53                   	push   %ebx
  802209:	83 ec 18             	sub    $0x18,%esp
  80220c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80220f:	57                   	push   %edi
  802210:	e8 8c f1 ff ff       	call   8013a1 <fd2data>
  802215:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802217:	83 c4 10             	add    $0x10,%esp
  80221a:	be 00 00 00 00       	mov    $0x0,%esi
  80221f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802222:	75 14                	jne    802238 <devpipe_read+0x39>
	return i;
  802224:	8b 45 10             	mov    0x10(%ebp),%eax
  802227:	eb 02                	jmp    80222b <devpipe_read+0x2c>
				return i;
  802229:	89 f0                	mov    %esi,%eax
}
  80222b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80222e:	5b                   	pop    %ebx
  80222f:	5e                   	pop    %esi
  802230:	5f                   	pop    %edi
  802231:	5d                   	pop    %ebp
  802232:	c3                   	ret    
			sys_yield();
  802233:	e8 79 eb ff ff       	call   800db1 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802238:	8b 03                	mov    (%ebx),%eax
  80223a:	3b 43 04             	cmp    0x4(%ebx),%eax
  80223d:	75 18                	jne    802257 <devpipe_read+0x58>
			if (i > 0)
  80223f:	85 f6                	test   %esi,%esi
  802241:	75 e6                	jne    802229 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802243:	89 da                	mov    %ebx,%edx
  802245:	89 f8                	mov    %edi,%eax
  802247:	e8 c8 fe ff ff       	call   802114 <_pipeisclosed>
  80224c:	85 c0                	test   %eax,%eax
  80224e:	74 e3                	je     802233 <devpipe_read+0x34>
				return 0;
  802250:	b8 00 00 00 00       	mov    $0x0,%eax
  802255:	eb d4                	jmp    80222b <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802257:	99                   	cltd   
  802258:	c1 ea 1b             	shr    $0x1b,%edx
  80225b:	01 d0                	add    %edx,%eax
  80225d:	83 e0 1f             	and    $0x1f,%eax
  802260:	29 d0                	sub    %edx,%eax
  802262:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802267:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80226a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80226d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802270:	83 c6 01             	add    $0x1,%esi
  802273:	eb aa                	jmp    80221f <devpipe_read+0x20>

00802275 <pipe>:
{
  802275:	f3 0f 1e fb          	endbr32 
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
  80227c:	56                   	push   %esi
  80227d:	53                   	push   %ebx
  80227e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802281:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802284:	50                   	push   %eax
  802285:	e8 32 f1 ff ff       	call   8013bc <fd_alloc>
  80228a:	89 c3                	mov    %eax,%ebx
  80228c:	83 c4 10             	add    $0x10,%esp
  80228f:	85 c0                	test   %eax,%eax
  802291:	0f 88 23 01 00 00    	js     8023ba <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802297:	83 ec 04             	sub    $0x4,%esp
  80229a:	68 07 04 00 00       	push   $0x407
  80229f:	ff 75 f4             	pushl  -0xc(%ebp)
  8022a2:	6a 00                	push   $0x0
  8022a4:	e8 2b eb ff ff       	call   800dd4 <sys_page_alloc>
  8022a9:	89 c3                	mov    %eax,%ebx
  8022ab:	83 c4 10             	add    $0x10,%esp
  8022ae:	85 c0                	test   %eax,%eax
  8022b0:	0f 88 04 01 00 00    	js     8023ba <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8022b6:	83 ec 0c             	sub    $0xc,%esp
  8022b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022bc:	50                   	push   %eax
  8022bd:	e8 fa f0 ff ff       	call   8013bc <fd_alloc>
  8022c2:	89 c3                	mov    %eax,%ebx
  8022c4:	83 c4 10             	add    $0x10,%esp
  8022c7:	85 c0                	test   %eax,%eax
  8022c9:	0f 88 db 00 00 00    	js     8023aa <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022cf:	83 ec 04             	sub    $0x4,%esp
  8022d2:	68 07 04 00 00       	push   $0x407
  8022d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8022da:	6a 00                	push   $0x0
  8022dc:	e8 f3 ea ff ff       	call   800dd4 <sys_page_alloc>
  8022e1:	89 c3                	mov    %eax,%ebx
  8022e3:	83 c4 10             	add    $0x10,%esp
  8022e6:	85 c0                	test   %eax,%eax
  8022e8:	0f 88 bc 00 00 00    	js     8023aa <pipe+0x135>
	va = fd2data(fd0);
  8022ee:	83 ec 0c             	sub    $0xc,%esp
  8022f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8022f4:	e8 a8 f0 ff ff       	call   8013a1 <fd2data>
  8022f9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022fb:	83 c4 0c             	add    $0xc,%esp
  8022fe:	68 07 04 00 00       	push   $0x407
  802303:	50                   	push   %eax
  802304:	6a 00                	push   $0x0
  802306:	e8 c9 ea ff ff       	call   800dd4 <sys_page_alloc>
  80230b:	89 c3                	mov    %eax,%ebx
  80230d:	83 c4 10             	add    $0x10,%esp
  802310:	85 c0                	test   %eax,%eax
  802312:	0f 88 82 00 00 00    	js     80239a <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802318:	83 ec 0c             	sub    $0xc,%esp
  80231b:	ff 75 f0             	pushl  -0x10(%ebp)
  80231e:	e8 7e f0 ff ff       	call   8013a1 <fd2data>
  802323:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80232a:	50                   	push   %eax
  80232b:	6a 00                	push   $0x0
  80232d:	56                   	push   %esi
  80232e:	6a 00                	push   $0x0
  802330:	e8 e6 ea ff ff       	call   800e1b <sys_page_map>
  802335:	89 c3                	mov    %eax,%ebx
  802337:	83 c4 20             	add    $0x20,%esp
  80233a:	85 c0                	test   %eax,%eax
  80233c:	78 4e                	js     80238c <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  80233e:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802343:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802346:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802348:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802352:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802355:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802361:	83 ec 0c             	sub    $0xc,%esp
  802364:	ff 75 f4             	pushl  -0xc(%ebp)
  802367:	e8 21 f0 ff ff       	call   80138d <fd2num>
  80236c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80236f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802371:	83 c4 04             	add    $0x4,%esp
  802374:	ff 75 f0             	pushl  -0x10(%ebp)
  802377:	e8 11 f0 ff ff       	call   80138d <fd2num>
  80237c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80237f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802382:	83 c4 10             	add    $0x10,%esp
  802385:	bb 00 00 00 00       	mov    $0x0,%ebx
  80238a:	eb 2e                	jmp    8023ba <pipe+0x145>
	sys_page_unmap(0, va);
  80238c:	83 ec 08             	sub    $0x8,%esp
  80238f:	56                   	push   %esi
  802390:	6a 00                	push   $0x0
  802392:	e8 ca ea ff ff       	call   800e61 <sys_page_unmap>
  802397:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80239a:	83 ec 08             	sub    $0x8,%esp
  80239d:	ff 75 f0             	pushl  -0x10(%ebp)
  8023a0:	6a 00                	push   $0x0
  8023a2:	e8 ba ea ff ff       	call   800e61 <sys_page_unmap>
  8023a7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8023aa:	83 ec 08             	sub    $0x8,%esp
  8023ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8023b0:	6a 00                	push   $0x0
  8023b2:	e8 aa ea ff ff       	call   800e61 <sys_page_unmap>
  8023b7:	83 c4 10             	add    $0x10,%esp
}
  8023ba:	89 d8                	mov    %ebx,%eax
  8023bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023bf:	5b                   	pop    %ebx
  8023c0:	5e                   	pop    %esi
  8023c1:	5d                   	pop    %ebp
  8023c2:	c3                   	ret    

008023c3 <pipeisclosed>:
{
  8023c3:	f3 0f 1e fb          	endbr32 
  8023c7:	55                   	push   %ebp
  8023c8:	89 e5                	mov    %esp,%ebp
  8023ca:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023d0:	50                   	push   %eax
  8023d1:	ff 75 08             	pushl  0x8(%ebp)
  8023d4:	e8 39 f0 ff ff       	call   801412 <fd_lookup>
  8023d9:	83 c4 10             	add    $0x10,%esp
  8023dc:	85 c0                	test   %eax,%eax
  8023de:	78 18                	js     8023f8 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8023e0:	83 ec 0c             	sub    $0xc,%esp
  8023e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8023e6:	e8 b6 ef ff ff       	call   8013a1 <fd2data>
  8023eb:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f0:	e8 1f fd ff ff       	call   802114 <_pipeisclosed>
  8023f5:	83 c4 10             	add    $0x10,%esp
}
  8023f8:	c9                   	leave  
  8023f9:	c3                   	ret    

008023fa <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8023fa:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8023fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802403:	c3                   	ret    

00802404 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802404:	f3 0f 1e fb          	endbr32 
  802408:	55                   	push   %ebp
  802409:	89 e5                	mov    %esp,%ebp
  80240b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80240e:	68 b2 2f 80 00       	push   $0x802fb2
  802413:	ff 75 0c             	pushl  0xc(%ebp)
  802416:	e8 77 e5 ff ff       	call   800992 <strcpy>
	return 0;
}
  80241b:	b8 00 00 00 00       	mov    $0x0,%eax
  802420:	c9                   	leave  
  802421:	c3                   	ret    

00802422 <devcons_write>:
{
  802422:	f3 0f 1e fb          	endbr32 
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
  802429:	57                   	push   %edi
  80242a:	56                   	push   %esi
  80242b:	53                   	push   %ebx
  80242c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802432:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802437:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80243d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802440:	73 31                	jae    802473 <devcons_write+0x51>
		m = n - tot;
  802442:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802445:	29 f3                	sub    %esi,%ebx
  802447:	83 fb 7f             	cmp    $0x7f,%ebx
  80244a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80244f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802452:	83 ec 04             	sub    $0x4,%esp
  802455:	53                   	push   %ebx
  802456:	89 f0                	mov    %esi,%eax
  802458:	03 45 0c             	add    0xc(%ebp),%eax
  80245b:	50                   	push   %eax
  80245c:	57                   	push   %edi
  80245d:	e8 e6 e6 ff ff       	call   800b48 <memmove>
		sys_cputs(buf, m);
  802462:	83 c4 08             	add    $0x8,%esp
  802465:	53                   	push   %ebx
  802466:	57                   	push   %edi
  802467:	e8 98 e8 ff ff       	call   800d04 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80246c:	01 de                	add    %ebx,%esi
  80246e:	83 c4 10             	add    $0x10,%esp
  802471:	eb ca                	jmp    80243d <devcons_write+0x1b>
}
  802473:	89 f0                	mov    %esi,%eax
  802475:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802478:	5b                   	pop    %ebx
  802479:	5e                   	pop    %esi
  80247a:	5f                   	pop    %edi
  80247b:	5d                   	pop    %ebp
  80247c:	c3                   	ret    

0080247d <devcons_read>:
{
  80247d:	f3 0f 1e fb          	endbr32 
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
  802484:	83 ec 08             	sub    $0x8,%esp
  802487:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80248c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802490:	74 21                	je     8024b3 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802492:	e8 8f e8 ff ff       	call   800d26 <sys_cgetc>
  802497:	85 c0                	test   %eax,%eax
  802499:	75 07                	jne    8024a2 <devcons_read+0x25>
		sys_yield();
  80249b:	e8 11 e9 ff ff       	call   800db1 <sys_yield>
  8024a0:	eb f0                	jmp    802492 <devcons_read+0x15>
	if (c < 0)
  8024a2:	78 0f                	js     8024b3 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8024a4:	83 f8 04             	cmp    $0x4,%eax
  8024a7:	74 0c                	je     8024b5 <devcons_read+0x38>
	*(char*)vbuf = c;
  8024a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ac:	88 02                	mov    %al,(%edx)
	return 1;
  8024ae:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8024b3:	c9                   	leave  
  8024b4:	c3                   	ret    
		return 0;
  8024b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ba:	eb f7                	jmp    8024b3 <devcons_read+0x36>

008024bc <cputchar>:
{
  8024bc:	f3 0f 1e fb          	endbr32 
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
  8024c3:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8024cc:	6a 01                	push   $0x1
  8024ce:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024d1:	50                   	push   %eax
  8024d2:	e8 2d e8 ff ff       	call   800d04 <sys_cputs>
}
  8024d7:	83 c4 10             	add    $0x10,%esp
  8024da:	c9                   	leave  
  8024db:	c3                   	ret    

008024dc <getchar>:
{
  8024dc:	f3 0f 1e fb          	endbr32 
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
  8024e3:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8024e6:	6a 01                	push   $0x1
  8024e8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024eb:	50                   	push   %eax
  8024ec:	6a 00                	push   $0x0
  8024ee:	e8 a7 f1 ff ff       	call   80169a <read>
	if (r < 0)
  8024f3:	83 c4 10             	add    $0x10,%esp
  8024f6:	85 c0                	test   %eax,%eax
  8024f8:	78 06                	js     802500 <getchar+0x24>
	if (r < 1)
  8024fa:	74 06                	je     802502 <getchar+0x26>
	return c;
  8024fc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802500:	c9                   	leave  
  802501:	c3                   	ret    
		return -E_EOF;
  802502:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802507:	eb f7                	jmp    802500 <getchar+0x24>

00802509 <iscons>:
{
  802509:	f3 0f 1e fb          	endbr32 
  80250d:	55                   	push   %ebp
  80250e:	89 e5                	mov    %esp,%ebp
  802510:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802513:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802516:	50                   	push   %eax
  802517:	ff 75 08             	pushl  0x8(%ebp)
  80251a:	e8 f3 ee ff ff       	call   801412 <fd_lookup>
  80251f:	83 c4 10             	add    $0x10,%esp
  802522:	85 c0                	test   %eax,%eax
  802524:	78 11                	js     802537 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802529:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80252f:	39 10                	cmp    %edx,(%eax)
  802531:	0f 94 c0             	sete   %al
  802534:	0f b6 c0             	movzbl %al,%eax
}
  802537:	c9                   	leave  
  802538:	c3                   	ret    

00802539 <opencons>:
{
  802539:	f3 0f 1e fb          	endbr32 
  80253d:	55                   	push   %ebp
  80253e:	89 e5                	mov    %esp,%ebp
  802540:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802543:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802546:	50                   	push   %eax
  802547:	e8 70 ee ff ff       	call   8013bc <fd_alloc>
  80254c:	83 c4 10             	add    $0x10,%esp
  80254f:	85 c0                	test   %eax,%eax
  802551:	78 3a                	js     80258d <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802553:	83 ec 04             	sub    $0x4,%esp
  802556:	68 07 04 00 00       	push   $0x407
  80255b:	ff 75 f4             	pushl  -0xc(%ebp)
  80255e:	6a 00                	push   $0x0
  802560:	e8 6f e8 ff ff       	call   800dd4 <sys_page_alloc>
  802565:	83 c4 10             	add    $0x10,%esp
  802568:	85 c0                	test   %eax,%eax
  80256a:	78 21                	js     80258d <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256f:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802575:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802581:	83 ec 0c             	sub    $0xc,%esp
  802584:	50                   	push   %eax
  802585:	e8 03 ee ff ff       	call   80138d <fd2num>
  80258a:	83 c4 10             	add    $0x10,%esp
}
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80258f:	f3 0f 1e fb          	endbr32 
  802593:	55                   	push   %ebp
  802594:	89 e5                	mov    %esp,%ebp
  802596:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802599:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8025a0:	74 0a                	je     8025ac <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8025a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a5:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8025aa:	c9                   	leave  
  8025ab:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  8025ac:	83 ec 04             	sub    $0x4,%esp
  8025af:	6a 07                	push   $0x7
  8025b1:	68 00 f0 bf ee       	push   $0xeebff000
  8025b6:	6a 00                	push   $0x0
  8025b8:	e8 17 e8 ff ff       	call   800dd4 <sys_page_alloc>
  8025bd:	83 c4 10             	add    $0x10,%esp
  8025c0:	85 c0                	test   %eax,%eax
  8025c2:	78 2a                	js     8025ee <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  8025c4:	83 ec 08             	sub    $0x8,%esp
  8025c7:	68 02 26 80 00       	push   $0x802602
  8025cc:	6a 00                	push   $0x0
  8025ce:	e8 60 e9 ff ff       	call   800f33 <sys_env_set_pgfault_upcall>
  8025d3:	83 c4 10             	add    $0x10,%esp
  8025d6:	85 c0                	test   %eax,%eax
  8025d8:	79 c8                	jns    8025a2 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  8025da:	83 ec 04             	sub    $0x4,%esp
  8025dd:	68 ec 2f 80 00       	push   $0x802fec
  8025e2:	6a 25                	push   $0x25
  8025e4:	68 24 30 80 00       	push   $0x803024
  8025e9:	e8 b3 dc ff ff       	call   8002a1 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  8025ee:	83 ec 04             	sub    $0x4,%esp
  8025f1:	68 c0 2f 80 00       	push   $0x802fc0
  8025f6:	6a 22                	push   $0x22
  8025f8:	68 24 30 80 00       	push   $0x803024
  8025fd:	e8 9f dc ff ff       	call   8002a1 <_panic>

00802602 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802602:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802603:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802608:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80260a:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  80260d:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  802611:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802615:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802618:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  80261a:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  80261e:	83 c4 08             	add    $0x8,%esp
	popal
  802621:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  802622:	83 c4 04             	add    $0x4,%esp
	popfl
  802625:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  802626:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  802627:	c3                   	ret    

00802628 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802628:	f3 0f 1e fb          	endbr32 
  80262c:	55                   	push   %ebp
  80262d:	89 e5                	mov    %esp,%ebp
  80262f:	56                   	push   %esi
  802630:	53                   	push   %ebx
  802631:	8b 75 08             	mov    0x8(%ebp),%esi
  802634:	8b 45 0c             	mov    0xc(%ebp),%eax
  802637:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  80263a:	85 c0                	test   %eax,%eax
  80263c:	74 3d                	je     80267b <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  80263e:	83 ec 0c             	sub    $0xc,%esp
  802641:	50                   	push   %eax
  802642:	e8 59 e9 ff ff       	call   800fa0 <sys_ipc_recv>
  802647:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  80264a:	85 f6                	test   %esi,%esi
  80264c:	74 0b                	je     802659 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  80264e:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802654:	8b 52 74             	mov    0x74(%edx),%edx
  802657:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  802659:	85 db                	test   %ebx,%ebx
  80265b:	74 0b                	je     802668 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  80265d:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802663:	8b 52 78             	mov    0x78(%edx),%edx
  802666:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  802668:	85 c0                	test   %eax,%eax
  80266a:	78 21                	js     80268d <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  80266c:	a1 08 50 80 00       	mov    0x805008,%eax
  802671:	8b 40 70             	mov    0x70(%eax),%eax
}
  802674:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802677:	5b                   	pop    %ebx
  802678:	5e                   	pop    %esi
  802679:	5d                   	pop    %ebp
  80267a:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  80267b:	83 ec 0c             	sub    $0xc,%esp
  80267e:	68 00 00 c0 ee       	push   $0xeec00000
  802683:	e8 18 e9 ff ff       	call   800fa0 <sys_ipc_recv>
  802688:	83 c4 10             	add    $0x10,%esp
  80268b:	eb bd                	jmp    80264a <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  80268d:	85 f6                	test   %esi,%esi
  80268f:	74 10                	je     8026a1 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802691:	85 db                	test   %ebx,%ebx
  802693:	75 df                	jne    802674 <ipc_recv+0x4c>
  802695:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80269c:	00 00 00 
  80269f:	eb d3                	jmp    802674 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  8026a1:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8026a8:	00 00 00 
  8026ab:	eb e4                	jmp    802691 <ipc_recv+0x69>

008026ad <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8026ad:	f3 0f 1e fb          	endbr32 
  8026b1:	55                   	push   %ebp
  8026b2:	89 e5                	mov    %esp,%ebp
  8026b4:	57                   	push   %edi
  8026b5:	56                   	push   %esi
  8026b6:	53                   	push   %ebx
  8026b7:	83 ec 0c             	sub    $0xc,%esp
  8026ba:	8b 7d 08             	mov    0x8(%ebp),%edi
  8026bd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  8026c3:	85 db                	test   %ebx,%ebx
  8026c5:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8026ca:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8026cd:	ff 75 14             	pushl  0x14(%ebp)
  8026d0:	53                   	push   %ebx
  8026d1:	56                   	push   %esi
  8026d2:	57                   	push   %edi
  8026d3:	e8 a1 e8 ff ff       	call   800f79 <sys_ipc_try_send>
  8026d8:	83 c4 10             	add    $0x10,%esp
  8026db:	85 c0                	test   %eax,%eax
  8026dd:	79 1e                	jns    8026fd <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  8026df:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8026e2:	75 07                	jne    8026eb <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  8026e4:	e8 c8 e6 ff ff       	call   800db1 <sys_yield>
  8026e9:	eb e2                	jmp    8026cd <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  8026eb:	50                   	push   %eax
  8026ec:	68 32 30 80 00       	push   $0x803032
  8026f1:	6a 59                	push   $0x59
  8026f3:	68 4d 30 80 00       	push   $0x80304d
  8026f8:	e8 a4 db ff ff       	call   8002a1 <_panic>
	}
}
  8026fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802700:	5b                   	pop    %ebx
  802701:	5e                   	pop    %esi
  802702:	5f                   	pop    %edi
  802703:	5d                   	pop    %ebp
  802704:	c3                   	ret    

00802705 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802705:	f3 0f 1e fb          	endbr32 
  802709:	55                   	push   %ebp
  80270a:	89 e5                	mov    %esp,%ebp
  80270c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80270f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802714:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802717:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80271d:	8b 52 50             	mov    0x50(%edx),%edx
  802720:	39 ca                	cmp    %ecx,%edx
  802722:	74 11                	je     802735 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802724:	83 c0 01             	add    $0x1,%eax
  802727:	3d 00 04 00 00       	cmp    $0x400,%eax
  80272c:	75 e6                	jne    802714 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80272e:	b8 00 00 00 00       	mov    $0x0,%eax
  802733:	eb 0b                	jmp    802740 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802735:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802738:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80273d:	8b 40 48             	mov    0x48(%eax),%eax
}
  802740:	5d                   	pop    %ebp
  802741:	c3                   	ret    

00802742 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802742:	f3 0f 1e fb          	endbr32 
  802746:	55                   	push   %ebp
  802747:	89 e5                	mov    %esp,%ebp
  802749:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80274c:	89 c2                	mov    %eax,%edx
  80274e:	c1 ea 16             	shr    $0x16,%edx
  802751:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802758:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80275d:	f6 c1 01             	test   $0x1,%cl
  802760:	74 1c                	je     80277e <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802762:	c1 e8 0c             	shr    $0xc,%eax
  802765:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80276c:	a8 01                	test   $0x1,%al
  80276e:	74 0e                	je     80277e <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802770:	c1 e8 0c             	shr    $0xc,%eax
  802773:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80277a:	ef 
  80277b:	0f b7 d2             	movzwl %dx,%edx
}
  80277e:	89 d0                	mov    %edx,%eax
  802780:	5d                   	pop    %ebp
  802781:	c3                   	ret    
  802782:	66 90                	xchg   %ax,%ax
  802784:	66 90                	xchg   %ax,%ax
  802786:	66 90                	xchg   %ax,%ax
  802788:	66 90                	xchg   %ax,%ax
  80278a:	66 90                	xchg   %ax,%ax
  80278c:	66 90                	xchg   %ax,%ax
  80278e:	66 90                	xchg   %ax,%ax

00802790 <__udivdi3>:
  802790:	f3 0f 1e fb          	endbr32 
  802794:	55                   	push   %ebp
  802795:	57                   	push   %edi
  802796:	56                   	push   %esi
  802797:	53                   	push   %ebx
  802798:	83 ec 1c             	sub    $0x1c,%esp
  80279b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80279f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8027a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8027a7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8027ab:	85 d2                	test   %edx,%edx
  8027ad:	75 19                	jne    8027c8 <__udivdi3+0x38>
  8027af:	39 f3                	cmp    %esi,%ebx
  8027b1:	76 4d                	jbe    802800 <__udivdi3+0x70>
  8027b3:	31 ff                	xor    %edi,%edi
  8027b5:	89 e8                	mov    %ebp,%eax
  8027b7:	89 f2                	mov    %esi,%edx
  8027b9:	f7 f3                	div    %ebx
  8027bb:	89 fa                	mov    %edi,%edx
  8027bd:	83 c4 1c             	add    $0x1c,%esp
  8027c0:	5b                   	pop    %ebx
  8027c1:	5e                   	pop    %esi
  8027c2:	5f                   	pop    %edi
  8027c3:	5d                   	pop    %ebp
  8027c4:	c3                   	ret    
  8027c5:	8d 76 00             	lea    0x0(%esi),%esi
  8027c8:	39 f2                	cmp    %esi,%edx
  8027ca:	76 14                	jbe    8027e0 <__udivdi3+0x50>
  8027cc:	31 ff                	xor    %edi,%edi
  8027ce:	31 c0                	xor    %eax,%eax
  8027d0:	89 fa                	mov    %edi,%edx
  8027d2:	83 c4 1c             	add    $0x1c,%esp
  8027d5:	5b                   	pop    %ebx
  8027d6:	5e                   	pop    %esi
  8027d7:	5f                   	pop    %edi
  8027d8:	5d                   	pop    %ebp
  8027d9:	c3                   	ret    
  8027da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027e0:	0f bd fa             	bsr    %edx,%edi
  8027e3:	83 f7 1f             	xor    $0x1f,%edi
  8027e6:	75 48                	jne    802830 <__udivdi3+0xa0>
  8027e8:	39 f2                	cmp    %esi,%edx
  8027ea:	72 06                	jb     8027f2 <__udivdi3+0x62>
  8027ec:	31 c0                	xor    %eax,%eax
  8027ee:	39 eb                	cmp    %ebp,%ebx
  8027f0:	77 de                	ja     8027d0 <__udivdi3+0x40>
  8027f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8027f7:	eb d7                	jmp    8027d0 <__udivdi3+0x40>
  8027f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802800:	89 d9                	mov    %ebx,%ecx
  802802:	85 db                	test   %ebx,%ebx
  802804:	75 0b                	jne    802811 <__udivdi3+0x81>
  802806:	b8 01 00 00 00       	mov    $0x1,%eax
  80280b:	31 d2                	xor    %edx,%edx
  80280d:	f7 f3                	div    %ebx
  80280f:	89 c1                	mov    %eax,%ecx
  802811:	31 d2                	xor    %edx,%edx
  802813:	89 f0                	mov    %esi,%eax
  802815:	f7 f1                	div    %ecx
  802817:	89 c6                	mov    %eax,%esi
  802819:	89 e8                	mov    %ebp,%eax
  80281b:	89 f7                	mov    %esi,%edi
  80281d:	f7 f1                	div    %ecx
  80281f:	89 fa                	mov    %edi,%edx
  802821:	83 c4 1c             	add    $0x1c,%esp
  802824:	5b                   	pop    %ebx
  802825:	5e                   	pop    %esi
  802826:	5f                   	pop    %edi
  802827:	5d                   	pop    %ebp
  802828:	c3                   	ret    
  802829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802830:	89 f9                	mov    %edi,%ecx
  802832:	b8 20 00 00 00       	mov    $0x20,%eax
  802837:	29 f8                	sub    %edi,%eax
  802839:	d3 e2                	shl    %cl,%edx
  80283b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80283f:	89 c1                	mov    %eax,%ecx
  802841:	89 da                	mov    %ebx,%edx
  802843:	d3 ea                	shr    %cl,%edx
  802845:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802849:	09 d1                	or     %edx,%ecx
  80284b:	89 f2                	mov    %esi,%edx
  80284d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802851:	89 f9                	mov    %edi,%ecx
  802853:	d3 e3                	shl    %cl,%ebx
  802855:	89 c1                	mov    %eax,%ecx
  802857:	d3 ea                	shr    %cl,%edx
  802859:	89 f9                	mov    %edi,%ecx
  80285b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80285f:	89 eb                	mov    %ebp,%ebx
  802861:	d3 e6                	shl    %cl,%esi
  802863:	89 c1                	mov    %eax,%ecx
  802865:	d3 eb                	shr    %cl,%ebx
  802867:	09 de                	or     %ebx,%esi
  802869:	89 f0                	mov    %esi,%eax
  80286b:	f7 74 24 08          	divl   0x8(%esp)
  80286f:	89 d6                	mov    %edx,%esi
  802871:	89 c3                	mov    %eax,%ebx
  802873:	f7 64 24 0c          	mull   0xc(%esp)
  802877:	39 d6                	cmp    %edx,%esi
  802879:	72 15                	jb     802890 <__udivdi3+0x100>
  80287b:	89 f9                	mov    %edi,%ecx
  80287d:	d3 e5                	shl    %cl,%ebp
  80287f:	39 c5                	cmp    %eax,%ebp
  802881:	73 04                	jae    802887 <__udivdi3+0xf7>
  802883:	39 d6                	cmp    %edx,%esi
  802885:	74 09                	je     802890 <__udivdi3+0x100>
  802887:	89 d8                	mov    %ebx,%eax
  802889:	31 ff                	xor    %edi,%edi
  80288b:	e9 40 ff ff ff       	jmp    8027d0 <__udivdi3+0x40>
  802890:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802893:	31 ff                	xor    %edi,%edi
  802895:	e9 36 ff ff ff       	jmp    8027d0 <__udivdi3+0x40>
  80289a:	66 90                	xchg   %ax,%ax
  80289c:	66 90                	xchg   %ax,%ax
  80289e:	66 90                	xchg   %ax,%ax

008028a0 <__umoddi3>:
  8028a0:	f3 0f 1e fb          	endbr32 
  8028a4:	55                   	push   %ebp
  8028a5:	57                   	push   %edi
  8028a6:	56                   	push   %esi
  8028a7:	53                   	push   %ebx
  8028a8:	83 ec 1c             	sub    $0x1c,%esp
  8028ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8028af:	8b 74 24 30          	mov    0x30(%esp),%esi
  8028b3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8028b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028bb:	85 c0                	test   %eax,%eax
  8028bd:	75 19                	jne    8028d8 <__umoddi3+0x38>
  8028bf:	39 df                	cmp    %ebx,%edi
  8028c1:	76 5d                	jbe    802920 <__umoddi3+0x80>
  8028c3:	89 f0                	mov    %esi,%eax
  8028c5:	89 da                	mov    %ebx,%edx
  8028c7:	f7 f7                	div    %edi
  8028c9:	89 d0                	mov    %edx,%eax
  8028cb:	31 d2                	xor    %edx,%edx
  8028cd:	83 c4 1c             	add    $0x1c,%esp
  8028d0:	5b                   	pop    %ebx
  8028d1:	5e                   	pop    %esi
  8028d2:	5f                   	pop    %edi
  8028d3:	5d                   	pop    %ebp
  8028d4:	c3                   	ret    
  8028d5:	8d 76 00             	lea    0x0(%esi),%esi
  8028d8:	89 f2                	mov    %esi,%edx
  8028da:	39 d8                	cmp    %ebx,%eax
  8028dc:	76 12                	jbe    8028f0 <__umoddi3+0x50>
  8028de:	89 f0                	mov    %esi,%eax
  8028e0:	89 da                	mov    %ebx,%edx
  8028e2:	83 c4 1c             	add    $0x1c,%esp
  8028e5:	5b                   	pop    %ebx
  8028e6:	5e                   	pop    %esi
  8028e7:	5f                   	pop    %edi
  8028e8:	5d                   	pop    %ebp
  8028e9:	c3                   	ret    
  8028ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028f0:	0f bd e8             	bsr    %eax,%ebp
  8028f3:	83 f5 1f             	xor    $0x1f,%ebp
  8028f6:	75 50                	jne    802948 <__umoddi3+0xa8>
  8028f8:	39 d8                	cmp    %ebx,%eax
  8028fa:	0f 82 e0 00 00 00    	jb     8029e0 <__umoddi3+0x140>
  802900:	89 d9                	mov    %ebx,%ecx
  802902:	39 f7                	cmp    %esi,%edi
  802904:	0f 86 d6 00 00 00    	jbe    8029e0 <__umoddi3+0x140>
  80290a:	89 d0                	mov    %edx,%eax
  80290c:	89 ca                	mov    %ecx,%edx
  80290e:	83 c4 1c             	add    $0x1c,%esp
  802911:	5b                   	pop    %ebx
  802912:	5e                   	pop    %esi
  802913:	5f                   	pop    %edi
  802914:	5d                   	pop    %ebp
  802915:	c3                   	ret    
  802916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80291d:	8d 76 00             	lea    0x0(%esi),%esi
  802920:	89 fd                	mov    %edi,%ebp
  802922:	85 ff                	test   %edi,%edi
  802924:	75 0b                	jne    802931 <__umoddi3+0x91>
  802926:	b8 01 00 00 00       	mov    $0x1,%eax
  80292b:	31 d2                	xor    %edx,%edx
  80292d:	f7 f7                	div    %edi
  80292f:	89 c5                	mov    %eax,%ebp
  802931:	89 d8                	mov    %ebx,%eax
  802933:	31 d2                	xor    %edx,%edx
  802935:	f7 f5                	div    %ebp
  802937:	89 f0                	mov    %esi,%eax
  802939:	f7 f5                	div    %ebp
  80293b:	89 d0                	mov    %edx,%eax
  80293d:	31 d2                	xor    %edx,%edx
  80293f:	eb 8c                	jmp    8028cd <__umoddi3+0x2d>
  802941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802948:	89 e9                	mov    %ebp,%ecx
  80294a:	ba 20 00 00 00       	mov    $0x20,%edx
  80294f:	29 ea                	sub    %ebp,%edx
  802951:	d3 e0                	shl    %cl,%eax
  802953:	89 44 24 08          	mov    %eax,0x8(%esp)
  802957:	89 d1                	mov    %edx,%ecx
  802959:	89 f8                	mov    %edi,%eax
  80295b:	d3 e8                	shr    %cl,%eax
  80295d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802961:	89 54 24 04          	mov    %edx,0x4(%esp)
  802965:	8b 54 24 04          	mov    0x4(%esp),%edx
  802969:	09 c1                	or     %eax,%ecx
  80296b:	89 d8                	mov    %ebx,%eax
  80296d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802971:	89 e9                	mov    %ebp,%ecx
  802973:	d3 e7                	shl    %cl,%edi
  802975:	89 d1                	mov    %edx,%ecx
  802977:	d3 e8                	shr    %cl,%eax
  802979:	89 e9                	mov    %ebp,%ecx
  80297b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80297f:	d3 e3                	shl    %cl,%ebx
  802981:	89 c7                	mov    %eax,%edi
  802983:	89 d1                	mov    %edx,%ecx
  802985:	89 f0                	mov    %esi,%eax
  802987:	d3 e8                	shr    %cl,%eax
  802989:	89 e9                	mov    %ebp,%ecx
  80298b:	89 fa                	mov    %edi,%edx
  80298d:	d3 e6                	shl    %cl,%esi
  80298f:	09 d8                	or     %ebx,%eax
  802991:	f7 74 24 08          	divl   0x8(%esp)
  802995:	89 d1                	mov    %edx,%ecx
  802997:	89 f3                	mov    %esi,%ebx
  802999:	f7 64 24 0c          	mull   0xc(%esp)
  80299d:	89 c6                	mov    %eax,%esi
  80299f:	89 d7                	mov    %edx,%edi
  8029a1:	39 d1                	cmp    %edx,%ecx
  8029a3:	72 06                	jb     8029ab <__umoddi3+0x10b>
  8029a5:	75 10                	jne    8029b7 <__umoddi3+0x117>
  8029a7:	39 c3                	cmp    %eax,%ebx
  8029a9:	73 0c                	jae    8029b7 <__umoddi3+0x117>
  8029ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8029af:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8029b3:	89 d7                	mov    %edx,%edi
  8029b5:	89 c6                	mov    %eax,%esi
  8029b7:	89 ca                	mov    %ecx,%edx
  8029b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8029be:	29 f3                	sub    %esi,%ebx
  8029c0:	19 fa                	sbb    %edi,%edx
  8029c2:	89 d0                	mov    %edx,%eax
  8029c4:	d3 e0                	shl    %cl,%eax
  8029c6:	89 e9                	mov    %ebp,%ecx
  8029c8:	d3 eb                	shr    %cl,%ebx
  8029ca:	d3 ea                	shr    %cl,%edx
  8029cc:	09 d8                	or     %ebx,%eax
  8029ce:	83 c4 1c             	add    $0x1c,%esp
  8029d1:	5b                   	pop    %ebx
  8029d2:	5e                   	pop    %esi
  8029d3:	5f                   	pop    %edi
  8029d4:	5d                   	pop    %ebp
  8029d5:	c3                   	ret    
  8029d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029dd:	8d 76 00             	lea    0x0(%esi),%esi
  8029e0:	29 fe                	sub    %edi,%esi
  8029e2:	19 c3                	sbb    %eax,%ebx
  8029e4:	89 f2                	mov    %esi,%edx
  8029e6:	89 d9                	mov    %ebx,%ecx
  8029e8:	e9 1d ff ff ff       	jmp    80290a <__umoddi3+0x6a>
