
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
  80005a:	68 80 24 80 00       	push   $0x802480
  80005f:	6a 15                	push   $0x15
  800061:	68 af 24 80 00       	push   $0x8024af
  800066:	e8 36 02 00 00       	call   8002a1 <_panic>
		panic("pipe: %e", i);
  80006b:	50                   	push   %eax
  80006c:	68 c1 24 80 00       	push   $0x8024c1
  800071:	6a 1b                	push   $0x1b
  800073:	68 af 24 80 00       	push   $0x8024af
  800078:	e8 24 02 00 00       	call   8002a1 <_panic>
	if ((id = fork()) < 0)
		panic("fork: %e", id);
  80007d:	50                   	push   %eax
  80007e:	68 c5 28 80 00       	push   $0x8028c5
  800083:	6a 1d                	push   $0x1d
  800085:	68 af 24 80 00       	push   $0x8024af
  80008a:	e8 12 02 00 00       	call   8002a1 <_panic>
	if (id == 0) {
		close(fd);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	53                   	push   %ebx
  800093:	e8 04 14 00 00       	call   80149c <close>
		close(pfd[1]);
  800098:	83 c4 04             	add    $0x4,%esp
  80009b:	ff 75 dc             	pushl  -0x24(%ebp)
  80009e:	e8 f9 13 00 00       	call   80149c <close>
		fd = pfd[0];
  8000a3:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  8000a6:	83 c4 10             	add    $0x10,%esp
	if ((r = readn(fd, &p, 4)) != 4)
  8000a9:	83 ec 04             	sub    $0x4,%esp
  8000ac:	6a 04                	push   $0x4
  8000ae:	56                   	push   %esi
  8000af:	53                   	push   %ebx
  8000b0:	e8 bc 15 00 00       	call   801671 <readn>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	83 f8 04             	cmp    $0x4,%eax
  8000bb:	75 8e                	jne    80004b <primeproc+0x18>
	cprintf("%d\n", p);
  8000bd:	83 ec 08             	sub    $0x8,%esp
  8000c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8000c3:	68 8d 2a 80 00       	push   $0x802a8d
  8000c8:	e8 bb 02 00 00       	call   800388 <cprintf>
	if ((i=pipe(pfd)) < 0)
  8000cd:	89 3c 24             	mov    %edi,(%esp)
  8000d0:	e8 34 1c 00 00       	call   801d09 <pipe>
  8000d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	85 c0                	test   %eax,%eax
  8000dd:	78 8c                	js     80006b <primeproc+0x38>
	if ((id = fork()) < 0)
  8000df:	e8 e1 0f 00 00       	call   8010c5 <fork>
  8000e4:	85 c0                	test   %eax,%eax
  8000e6:	78 95                	js     80007d <primeproc+0x4a>
	if (id == 0) {
  8000e8:	74 a5                	je     80008f <primeproc+0x5c>
	}

	close(pfd[0]);
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	ff 75 d8             	pushl  -0x28(%ebp)
  8000f0:	e8 a7 13 00 00       	call   80149c <close>
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
  800105:	e8 67 15 00 00       	call   801671 <readn>
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
  800124:	e8 93 15 00 00       	call   8016bc <write>
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
  800143:	68 e6 24 80 00       	push   $0x8024e6
  800148:	6a 2e                	push   $0x2e
  80014a:	68 af 24 80 00       	push   $0x8024af
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
  800167:	68 ca 24 80 00       	push   $0x8024ca
  80016c:	6a 2b                	push   $0x2b
  80016e:	68 af 24 80 00       	push   $0x8024af
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
  800183:	c7 05 00 30 80 00 00 	movl   $0x802500,0x803000
  80018a:	25 80 00 

	if ((i=pipe(p)) < 0)
  80018d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800190:	50                   	push   %eax
  800191:	e8 73 1b 00 00       	call   801d09 <pipe>
  800196:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800199:	83 c4 10             	add    $0x10,%esp
  80019c:	85 c0                	test   %eax,%eax
  80019e:	78 21                	js     8001c1 <umain+0x49>
		panic("pipe: %e", i);

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  8001a0:	e8 20 0f 00 00       	call   8010c5 <fork>
  8001a5:	85 c0                	test   %eax,%eax
  8001a7:	78 2a                	js     8001d3 <umain+0x5b>
		panic("fork: %e", id);

	if (id == 0) {
  8001a9:	75 3a                	jne    8001e5 <umain+0x6d>
		close(p[1]);
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b1:	e8 e6 12 00 00       	call   80149c <close>
		primeproc(p[0]);
  8001b6:	83 c4 04             	add    $0x4,%esp
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 72 fe ff ff       	call   800033 <primeproc>
		panic("pipe: %e", i);
  8001c1:	50                   	push   %eax
  8001c2:	68 c1 24 80 00       	push   $0x8024c1
  8001c7:	6a 3a                	push   $0x3a
  8001c9:	68 af 24 80 00       	push   $0x8024af
  8001ce:	e8 ce 00 00 00       	call   8002a1 <_panic>
		panic("fork: %e", id);
  8001d3:	50                   	push   %eax
  8001d4:	68 c5 28 80 00       	push   $0x8028c5
  8001d9:	6a 3e                	push   $0x3e
  8001db:	68 af 24 80 00       	push   $0x8024af
  8001e0:	e8 bc 00 00 00       	call   8002a1 <_panic>
	}

	close(p[0]);
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	ff 75 ec             	pushl  -0x14(%ebp)
  8001eb:	e8 ac 12 00 00       	call   80149c <close>

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
  800206:	e8 b1 14 00 00       	call   8016bc <write>
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
  800228:	68 0b 25 80 00       	push   $0x80250b
  80022d:	6a 4a                	push   $0x4a
  80022f:	68 af 24 80 00       	push   $0x8024af
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
  80025a:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80025f:	85 db                	test   %ebx,%ebx
  800261:	7e 07                	jle    80026a <libmain+0x31>
		binaryname = argv[0];
  800263:	8b 06                	mov    (%esi),%eax
  800265:	a3 00 30 80 00       	mov    %eax,0x803000

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
  80028d:	e8 3b 12 00 00       	call   8014cd <close_all>
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
  8002ad:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8002b3:	e8 d6 0a 00 00       	call   800d8e <sys_getenvid>
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	ff 75 0c             	pushl  0xc(%ebp)
  8002be:	ff 75 08             	pushl  0x8(%ebp)
  8002c1:	56                   	push   %esi
  8002c2:	50                   	push   %eax
  8002c3:	68 30 25 80 00       	push   $0x802530
  8002c8:	e8 bb 00 00 00       	call   800388 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002cd:	83 c4 18             	add    $0x18,%esp
  8002d0:	53                   	push   %ebx
  8002d1:	ff 75 10             	pushl  0x10(%ebp)
  8002d4:	e8 5a 00 00 00       	call   800333 <vcprintf>
	cprintf("\n");
  8002d9:	c7 04 24 8f 2a 80 00 	movl   $0x802a8f,(%esp)
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
  8003ee:	e8 2d 1e 00 00       	call   802220 <__udivdi3>
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
  80042c:	e8 ff 1e 00 00       	call   802330 <__umoddi3>
  800431:	83 c4 14             	add    $0x14,%esp
  800434:	0f be 80 53 25 80 00 	movsbl 0x802553(%eax),%eax
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
  8004db:	3e ff 24 85 a0 26 80 	notrack jmp *0x8026a0(,%eax,4)
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
  8005a8:	8b 14 85 00 28 80 00 	mov    0x802800(,%eax,4),%edx
  8005af:	85 d2                	test   %edx,%edx
  8005b1:	74 18                	je     8005cb <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8005b3:	52                   	push   %edx
  8005b4:	68 c1 29 80 00       	push   $0x8029c1
  8005b9:	53                   	push   %ebx
  8005ba:	56                   	push   %esi
  8005bb:	e8 aa fe ff ff       	call   80046a <printfmt>
  8005c0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005c3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005c6:	e9 66 02 00 00       	jmp    800831 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8005cb:	50                   	push   %eax
  8005cc:	68 6b 25 80 00       	push   $0x80256b
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
  8005f3:	b8 64 25 80 00       	mov    $0x802564,%eax
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
  800d7d:	68 5f 28 80 00       	push   $0x80285f
  800d82:	6a 23                	push   $0x23
  800d84:	68 7c 28 80 00       	push   $0x80287c
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
  800e0a:	68 5f 28 80 00       	push   $0x80285f
  800e0f:	6a 23                	push   $0x23
  800e11:	68 7c 28 80 00       	push   $0x80287c
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
  800e50:	68 5f 28 80 00       	push   $0x80285f
  800e55:	6a 23                	push   $0x23
  800e57:	68 7c 28 80 00       	push   $0x80287c
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
  800e96:	68 5f 28 80 00       	push   $0x80285f
  800e9b:	6a 23                	push   $0x23
  800e9d:	68 7c 28 80 00       	push   $0x80287c
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
  800edc:	68 5f 28 80 00       	push   $0x80285f
  800ee1:	6a 23                	push   $0x23
  800ee3:	68 7c 28 80 00       	push   $0x80287c
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
  800f22:	68 5f 28 80 00       	push   $0x80285f
  800f27:	6a 23                	push   $0x23
  800f29:	68 7c 28 80 00       	push   $0x80287c
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
  800f68:	68 5f 28 80 00       	push   $0x80285f
  800f6d:	6a 23                	push   $0x23
  800f6f:	68 7c 28 80 00       	push   $0x80287c
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
  800fd4:	68 5f 28 80 00       	push   $0x80285f
  800fd9:	6a 23                	push   $0x23
  800fdb:	68 7c 28 80 00       	push   $0x80287c
  800fe0:	e8 bc f2 ff ff       	call   8002a1 <_panic>

00800fe5 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fe5:	f3 0f 1e fb          	endbr32 
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	53                   	push   %ebx
  800fed:	83 ec 04             	sub    $0x4,%esp
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ff3:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  800ff5:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800ff9:	74 74                	je     80106f <pgfault+0x8a>
  800ffb:	89 d8                	mov    %ebx,%eax
  800ffd:	c1 e8 0c             	shr    $0xc,%eax
  801000:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801007:	f6 c4 08             	test   $0x8,%ah
  80100a:	74 63                	je     80106f <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  80100c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  801012:	83 ec 0c             	sub    $0xc,%esp
  801015:	6a 05                	push   $0x5
  801017:	68 00 f0 7f 00       	push   $0x7ff000
  80101c:	6a 00                	push   $0x0
  80101e:	53                   	push   %ebx
  80101f:	6a 00                	push   $0x0
  801021:	e8 f5 fd ff ff       	call   800e1b <sys_page_map>
  801026:	83 c4 20             	add    $0x20,%esp
  801029:	85 c0                	test   %eax,%eax
  80102b:	78 59                	js     801086 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  80102d:	83 ec 04             	sub    $0x4,%esp
  801030:	6a 07                	push   $0x7
  801032:	53                   	push   %ebx
  801033:	6a 00                	push   $0x0
  801035:	e8 9a fd ff ff       	call   800dd4 <sys_page_alloc>
  80103a:	83 c4 10             	add    $0x10,%esp
  80103d:	85 c0                	test   %eax,%eax
  80103f:	78 5a                	js     80109b <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  801041:	83 ec 04             	sub    $0x4,%esp
  801044:	68 00 10 00 00       	push   $0x1000
  801049:	68 00 f0 7f 00       	push   $0x7ff000
  80104e:	53                   	push   %ebx
  80104f:	e8 f4 fa ff ff       	call   800b48 <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  801054:	83 c4 08             	add    $0x8,%esp
  801057:	68 00 f0 7f 00       	push   $0x7ff000
  80105c:	6a 00                	push   $0x0
  80105e:	e8 fe fd ff ff       	call   800e61 <sys_page_unmap>
  801063:	83 c4 10             	add    $0x10,%esp
  801066:	85 c0                	test   %eax,%eax
  801068:	78 46                	js     8010b0 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  80106a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80106d:	c9                   	leave  
  80106e:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  80106f:	83 ec 04             	sub    $0x4,%esp
  801072:	68 8a 28 80 00       	push   $0x80288a
  801077:	68 d3 00 00 00       	push   $0xd3
  80107c:	68 a6 28 80 00       	push   $0x8028a6
  801081:	e8 1b f2 ff ff       	call   8002a1 <_panic>
		panic("pgfault: %e\n", r);
  801086:	50                   	push   %eax
  801087:	68 b1 28 80 00       	push   $0x8028b1
  80108c:	68 df 00 00 00       	push   $0xdf
  801091:	68 a6 28 80 00       	push   $0x8028a6
  801096:	e8 06 f2 ff ff       	call   8002a1 <_panic>
		panic("pgfault: %e\n", r);
  80109b:	50                   	push   %eax
  80109c:	68 b1 28 80 00       	push   $0x8028b1
  8010a1:	68 e3 00 00 00       	push   $0xe3
  8010a6:	68 a6 28 80 00       	push   $0x8028a6
  8010ab:	e8 f1 f1 ff ff       	call   8002a1 <_panic>
		panic("pgfault: %e\n", r);
  8010b0:	50                   	push   %eax
  8010b1:	68 b1 28 80 00       	push   $0x8028b1
  8010b6:	68 e9 00 00 00       	push   $0xe9
  8010bb:	68 a6 28 80 00       	push   $0x8028a6
  8010c0:	e8 dc f1 ff ff       	call   8002a1 <_panic>

008010c5 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010c5:	f3 0f 1e fb          	endbr32 
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
  8010cc:	57                   	push   %edi
  8010cd:	56                   	push   %esi
  8010ce:	53                   	push   %ebx
  8010cf:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  8010d2:	68 e5 0f 80 00       	push   $0x800fe5
  8010d7:	e8 47 0f 00 00       	call   802023 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010dc:	b8 07 00 00 00       	mov    $0x7,%eax
  8010e1:	cd 30                	int    $0x30
  8010e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	85 c0                	test   %eax,%eax
  8010eb:	78 2d                	js     80111a <fork+0x55>
  8010ed:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8010ef:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  8010f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010f8:	0f 85 9b 00 00 00    	jne    801199 <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010fe:	e8 8b fc ff ff       	call   800d8e <sys_getenvid>
  801103:	25 ff 03 00 00       	and    $0x3ff,%eax
  801108:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80110b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801110:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801115:	e9 71 01 00 00       	jmp    80128b <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  80111a:	50                   	push   %eax
  80111b:	68 be 28 80 00       	push   $0x8028be
  801120:	68 2a 01 00 00       	push   $0x12a
  801125:	68 a6 28 80 00       	push   $0x8028a6
  80112a:	e8 72 f1 ff ff       	call   8002a1 <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  80112f:	c1 e6 0c             	shl    $0xc,%esi
  801132:	83 ec 0c             	sub    $0xc,%esp
  801135:	68 07 0e 00 00       	push   $0xe07
  80113a:	56                   	push   %esi
  80113b:	57                   	push   %edi
  80113c:	56                   	push   %esi
  80113d:	6a 00                	push   $0x0
  80113f:	e8 d7 fc ff ff       	call   800e1b <sys_page_map>
  801144:	83 c4 20             	add    $0x20,%esp
  801147:	eb 3e                	jmp    801187 <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801149:	c1 e6 0c             	shl    $0xc,%esi
  80114c:	83 ec 0c             	sub    $0xc,%esp
  80114f:	68 05 08 00 00       	push   $0x805
  801154:	56                   	push   %esi
  801155:	57                   	push   %edi
  801156:	56                   	push   %esi
  801157:	6a 00                	push   $0x0
  801159:	e8 bd fc ff ff       	call   800e1b <sys_page_map>
  80115e:	83 c4 20             	add    $0x20,%esp
  801161:	85 c0                	test   %eax,%eax
  801163:	0f 88 bc 00 00 00    	js     801225 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  801169:	83 ec 0c             	sub    $0xc,%esp
  80116c:	68 05 08 00 00       	push   $0x805
  801171:	56                   	push   %esi
  801172:	6a 00                	push   $0x0
  801174:	56                   	push   %esi
  801175:	6a 00                	push   $0x0
  801177:	e8 9f fc ff ff       	call   800e1b <sys_page_map>
  80117c:	83 c4 20             	add    $0x20,%esp
  80117f:	85 c0                	test   %eax,%eax
  801181:	0f 88 b3 00 00 00    	js     80123a <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801187:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80118d:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801193:	0f 84 b6 00 00 00    	je     80124f <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  801199:	89 d8                	mov    %ebx,%eax
  80119b:	c1 e8 16             	shr    $0x16,%eax
  80119e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011a5:	a8 01                	test   $0x1,%al
  8011a7:	74 de                	je     801187 <fork+0xc2>
  8011a9:	89 de                	mov    %ebx,%esi
  8011ab:	c1 ee 0c             	shr    $0xc,%esi
  8011ae:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011b5:	a8 01                	test   $0x1,%al
  8011b7:	74 ce                	je     801187 <fork+0xc2>
  8011b9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011c0:	a8 04                	test   $0x4,%al
  8011c2:	74 c3                	je     801187 <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  8011c4:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011cb:	f6 c4 04             	test   $0x4,%ah
  8011ce:	0f 85 5b ff ff ff    	jne    80112f <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  8011d4:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011db:	a8 02                	test   $0x2,%al
  8011dd:	0f 85 66 ff ff ff    	jne    801149 <fork+0x84>
  8011e3:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011ea:	f6 c4 08             	test   $0x8,%ah
  8011ed:	0f 85 56 ff ff ff    	jne    801149 <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  8011f3:	c1 e6 0c             	shl    $0xc,%esi
  8011f6:	83 ec 0c             	sub    $0xc,%esp
  8011f9:	6a 05                	push   $0x5
  8011fb:	56                   	push   %esi
  8011fc:	57                   	push   %edi
  8011fd:	56                   	push   %esi
  8011fe:	6a 00                	push   $0x0
  801200:	e8 16 fc ff ff       	call   800e1b <sys_page_map>
  801205:	83 c4 20             	add    $0x20,%esp
  801208:	85 c0                	test   %eax,%eax
  80120a:	0f 89 77 ff ff ff    	jns    801187 <fork+0xc2>
		panic("duppage: %e\n", r);
  801210:	50                   	push   %eax
  801211:	68 ce 28 80 00       	push   $0x8028ce
  801216:	68 0c 01 00 00       	push   $0x10c
  80121b:	68 a6 28 80 00       	push   $0x8028a6
  801220:	e8 7c f0 ff ff       	call   8002a1 <_panic>
			panic("duppage: %e\n", r);
  801225:	50                   	push   %eax
  801226:	68 ce 28 80 00       	push   $0x8028ce
  80122b:	68 05 01 00 00       	push   $0x105
  801230:	68 a6 28 80 00       	push   $0x8028a6
  801235:	e8 67 f0 ff ff       	call   8002a1 <_panic>
			panic("duppage: %e\n", r);
  80123a:	50                   	push   %eax
  80123b:	68 ce 28 80 00       	push   $0x8028ce
  801240:	68 09 01 00 00       	push   $0x109
  801245:	68 a6 28 80 00       	push   $0x8028a6
  80124a:	e8 52 f0 ff ff       	call   8002a1 <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  80124f:	83 ec 04             	sub    $0x4,%esp
  801252:	6a 07                	push   $0x7
  801254:	68 00 f0 bf ee       	push   $0xeebff000
  801259:	ff 75 e4             	pushl  -0x1c(%ebp)
  80125c:	e8 73 fb ff ff       	call   800dd4 <sys_page_alloc>
  801261:	83 c4 10             	add    $0x10,%esp
  801264:	85 c0                	test   %eax,%eax
  801266:	78 2e                	js     801296 <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801268:	83 ec 08             	sub    $0x8,%esp
  80126b:	68 96 20 80 00       	push   $0x802096
  801270:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801273:	57                   	push   %edi
  801274:	e8 ba fc ff ff       	call   800f33 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801279:	83 c4 08             	add    $0x8,%esp
  80127c:	6a 02                	push   $0x2
  80127e:	57                   	push   %edi
  80127f:	e8 23 fc ff ff       	call   800ea7 <sys_env_set_status>
  801284:	83 c4 10             	add    $0x10,%esp
  801287:	85 c0                	test   %eax,%eax
  801289:	78 20                	js     8012ab <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  80128b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80128e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801291:	5b                   	pop    %ebx
  801292:	5e                   	pop    %esi
  801293:	5f                   	pop    %edi
  801294:	5d                   	pop    %ebp
  801295:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801296:	50                   	push   %eax
  801297:	68 db 28 80 00       	push   $0x8028db
  80129c:	68 3e 01 00 00       	push   $0x13e
  8012a1:	68 a6 28 80 00       	push   $0x8028a6
  8012a6:	e8 f6 ef ff ff       	call   8002a1 <_panic>
		panic("sys_env_set_status: %e", r);
  8012ab:	50                   	push   %eax
  8012ac:	68 ee 28 80 00       	push   $0x8028ee
  8012b1:	68 43 01 00 00       	push   $0x143
  8012b6:	68 a6 28 80 00       	push   $0x8028a6
  8012bb:	e8 e1 ef ff ff       	call   8002a1 <_panic>

008012c0 <sfork>:

// Challenge!
int
sfork(void)
{
  8012c0:	f3 0f 1e fb          	endbr32 
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
  8012c7:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8012ca:	68 05 29 80 00       	push   $0x802905
  8012cf:	68 4c 01 00 00       	push   $0x14c
  8012d4:	68 a6 28 80 00       	push   $0x8028a6
  8012d9:	e8 c3 ef ff ff       	call   8002a1 <_panic>

008012de <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012de:	f3 0f 1e fb          	endbr32 
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	05 00 00 00 30       	add    $0x30000000,%eax
  8012ed:	c1 e8 0c             	shr    $0xc,%eax
}
  8012f0:	5d                   	pop    %ebp
  8012f1:	c3                   	ret    

008012f2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012f2:	f3 0f 1e fb          	endbr32 
  8012f6:	55                   	push   %ebp
  8012f7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fc:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801301:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801306:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80130b:	5d                   	pop    %ebp
  80130c:	c3                   	ret    

0080130d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80130d:	f3 0f 1e fb          	endbr32 
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801319:	89 c2                	mov    %eax,%edx
  80131b:	c1 ea 16             	shr    $0x16,%edx
  80131e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801325:	f6 c2 01             	test   $0x1,%dl
  801328:	74 2d                	je     801357 <fd_alloc+0x4a>
  80132a:	89 c2                	mov    %eax,%edx
  80132c:	c1 ea 0c             	shr    $0xc,%edx
  80132f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801336:	f6 c2 01             	test   $0x1,%dl
  801339:	74 1c                	je     801357 <fd_alloc+0x4a>
  80133b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801340:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801345:	75 d2                	jne    801319 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
  80134a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801350:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801355:	eb 0a                	jmp    801361 <fd_alloc+0x54>
			*fd_store = fd;
  801357:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80135a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80135c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801361:	5d                   	pop    %ebp
  801362:	c3                   	ret    

00801363 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801363:	f3 0f 1e fb          	endbr32 
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80136d:	83 f8 1f             	cmp    $0x1f,%eax
  801370:	77 30                	ja     8013a2 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801372:	c1 e0 0c             	shl    $0xc,%eax
  801375:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80137a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801380:	f6 c2 01             	test   $0x1,%dl
  801383:	74 24                	je     8013a9 <fd_lookup+0x46>
  801385:	89 c2                	mov    %eax,%edx
  801387:	c1 ea 0c             	shr    $0xc,%edx
  80138a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801391:	f6 c2 01             	test   $0x1,%dl
  801394:	74 1a                	je     8013b0 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801396:	8b 55 0c             	mov    0xc(%ebp),%edx
  801399:	89 02                	mov    %eax,(%edx)
	return 0;
  80139b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a0:	5d                   	pop    %ebp
  8013a1:	c3                   	ret    
		return -E_INVAL;
  8013a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a7:	eb f7                	jmp    8013a0 <fd_lookup+0x3d>
		return -E_INVAL;
  8013a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ae:	eb f0                	jmp    8013a0 <fd_lookup+0x3d>
  8013b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b5:	eb e9                	jmp    8013a0 <fd_lookup+0x3d>

008013b7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013b7:	f3 0f 1e fb          	endbr32 
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	83 ec 08             	sub    $0x8,%esp
  8013c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013c4:	ba 98 29 80 00       	mov    $0x802998,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8013c9:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013ce:	39 08                	cmp    %ecx,(%eax)
  8013d0:	74 33                	je     801405 <dev_lookup+0x4e>
  8013d2:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8013d5:	8b 02                	mov    (%edx),%eax
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	75 f3                	jne    8013ce <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013db:	a1 04 40 80 00       	mov    0x804004,%eax
  8013e0:	8b 40 48             	mov    0x48(%eax),%eax
  8013e3:	83 ec 04             	sub    $0x4,%esp
  8013e6:	51                   	push   %ecx
  8013e7:	50                   	push   %eax
  8013e8:	68 1c 29 80 00       	push   $0x80291c
  8013ed:	e8 96 ef ff ff       	call   800388 <cprintf>
	*dev = 0;
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013fb:	83 c4 10             	add    $0x10,%esp
  8013fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801403:	c9                   	leave  
  801404:	c3                   	ret    
			*dev = devtab[i];
  801405:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801408:	89 01                	mov    %eax,(%ecx)
			return 0;
  80140a:	b8 00 00 00 00       	mov    $0x0,%eax
  80140f:	eb f2                	jmp    801403 <dev_lookup+0x4c>

00801411 <fd_close>:
{
  801411:	f3 0f 1e fb          	endbr32 
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
  801418:	57                   	push   %edi
  801419:	56                   	push   %esi
  80141a:	53                   	push   %ebx
  80141b:	83 ec 24             	sub    $0x24,%esp
  80141e:	8b 75 08             	mov    0x8(%ebp),%esi
  801421:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801424:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801427:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801428:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80142e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801431:	50                   	push   %eax
  801432:	e8 2c ff ff ff       	call   801363 <fd_lookup>
  801437:	89 c3                	mov    %eax,%ebx
  801439:	83 c4 10             	add    $0x10,%esp
  80143c:	85 c0                	test   %eax,%eax
  80143e:	78 05                	js     801445 <fd_close+0x34>
	    || fd != fd2)
  801440:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801443:	74 16                	je     80145b <fd_close+0x4a>
		return (must_exist ? r : 0);
  801445:	89 f8                	mov    %edi,%eax
  801447:	84 c0                	test   %al,%al
  801449:	b8 00 00 00 00       	mov    $0x0,%eax
  80144e:	0f 44 d8             	cmove  %eax,%ebx
}
  801451:	89 d8                	mov    %ebx,%eax
  801453:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801456:	5b                   	pop    %ebx
  801457:	5e                   	pop    %esi
  801458:	5f                   	pop    %edi
  801459:	5d                   	pop    %ebp
  80145a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80145b:	83 ec 08             	sub    $0x8,%esp
  80145e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801461:	50                   	push   %eax
  801462:	ff 36                	pushl  (%esi)
  801464:	e8 4e ff ff ff       	call   8013b7 <dev_lookup>
  801469:	89 c3                	mov    %eax,%ebx
  80146b:	83 c4 10             	add    $0x10,%esp
  80146e:	85 c0                	test   %eax,%eax
  801470:	78 1a                	js     80148c <fd_close+0x7b>
		if (dev->dev_close)
  801472:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801475:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801478:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80147d:	85 c0                	test   %eax,%eax
  80147f:	74 0b                	je     80148c <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801481:	83 ec 0c             	sub    $0xc,%esp
  801484:	56                   	push   %esi
  801485:	ff d0                	call   *%eax
  801487:	89 c3                	mov    %eax,%ebx
  801489:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80148c:	83 ec 08             	sub    $0x8,%esp
  80148f:	56                   	push   %esi
  801490:	6a 00                	push   $0x0
  801492:	e8 ca f9 ff ff       	call   800e61 <sys_page_unmap>
	return r;
  801497:	83 c4 10             	add    $0x10,%esp
  80149a:	eb b5                	jmp    801451 <fd_close+0x40>

0080149c <close>:

int
close(int fdnum)
{
  80149c:	f3 0f 1e fb          	endbr32 
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a9:	50                   	push   %eax
  8014aa:	ff 75 08             	pushl  0x8(%ebp)
  8014ad:	e8 b1 fe ff ff       	call   801363 <fd_lookup>
  8014b2:	83 c4 10             	add    $0x10,%esp
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	79 02                	jns    8014bb <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    
		return fd_close(fd, 1);
  8014bb:	83 ec 08             	sub    $0x8,%esp
  8014be:	6a 01                	push   $0x1
  8014c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8014c3:	e8 49 ff ff ff       	call   801411 <fd_close>
  8014c8:	83 c4 10             	add    $0x10,%esp
  8014cb:	eb ec                	jmp    8014b9 <close+0x1d>

008014cd <close_all>:

void
close_all(void)
{
  8014cd:	f3 0f 1e fb          	endbr32 
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	53                   	push   %ebx
  8014d5:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014d8:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014dd:	83 ec 0c             	sub    $0xc,%esp
  8014e0:	53                   	push   %ebx
  8014e1:	e8 b6 ff ff ff       	call   80149c <close>
	for (i = 0; i < MAXFD; i++)
  8014e6:	83 c3 01             	add    $0x1,%ebx
  8014e9:	83 c4 10             	add    $0x10,%esp
  8014ec:	83 fb 20             	cmp    $0x20,%ebx
  8014ef:	75 ec                	jne    8014dd <close_all+0x10>
}
  8014f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014f6:	f3 0f 1e fb          	endbr32 
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	57                   	push   %edi
  8014fe:	56                   	push   %esi
  8014ff:	53                   	push   %ebx
  801500:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801503:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801506:	50                   	push   %eax
  801507:	ff 75 08             	pushl  0x8(%ebp)
  80150a:	e8 54 fe ff ff       	call   801363 <fd_lookup>
  80150f:	89 c3                	mov    %eax,%ebx
  801511:	83 c4 10             	add    $0x10,%esp
  801514:	85 c0                	test   %eax,%eax
  801516:	0f 88 81 00 00 00    	js     80159d <dup+0xa7>
		return r;
	close(newfdnum);
  80151c:	83 ec 0c             	sub    $0xc,%esp
  80151f:	ff 75 0c             	pushl  0xc(%ebp)
  801522:	e8 75 ff ff ff       	call   80149c <close>

	newfd = INDEX2FD(newfdnum);
  801527:	8b 75 0c             	mov    0xc(%ebp),%esi
  80152a:	c1 e6 0c             	shl    $0xc,%esi
  80152d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801533:	83 c4 04             	add    $0x4,%esp
  801536:	ff 75 e4             	pushl  -0x1c(%ebp)
  801539:	e8 b4 fd ff ff       	call   8012f2 <fd2data>
  80153e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801540:	89 34 24             	mov    %esi,(%esp)
  801543:	e8 aa fd ff ff       	call   8012f2 <fd2data>
  801548:	83 c4 10             	add    $0x10,%esp
  80154b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80154d:	89 d8                	mov    %ebx,%eax
  80154f:	c1 e8 16             	shr    $0x16,%eax
  801552:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801559:	a8 01                	test   $0x1,%al
  80155b:	74 11                	je     80156e <dup+0x78>
  80155d:	89 d8                	mov    %ebx,%eax
  80155f:	c1 e8 0c             	shr    $0xc,%eax
  801562:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801569:	f6 c2 01             	test   $0x1,%dl
  80156c:	75 39                	jne    8015a7 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80156e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801571:	89 d0                	mov    %edx,%eax
  801573:	c1 e8 0c             	shr    $0xc,%eax
  801576:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80157d:	83 ec 0c             	sub    $0xc,%esp
  801580:	25 07 0e 00 00       	and    $0xe07,%eax
  801585:	50                   	push   %eax
  801586:	56                   	push   %esi
  801587:	6a 00                	push   $0x0
  801589:	52                   	push   %edx
  80158a:	6a 00                	push   $0x0
  80158c:	e8 8a f8 ff ff       	call   800e1b <sys_page_map>
  801591:	89 c3                	mov    %eax,%ebx
  801593:	83 c4 20             	add    $0x20,%esp
  801596:	85 c0                	test   %eax,%eax
  801598:	78 31                	js     8015cb <dup+0xd5>
		goto err;

	return newfdnum;
  80159a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80159d:	89 d8                	mov    %ebx,%eax
  80159f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015a2:	5b                   	pop    %ebx
  8015a3:	5e                   	pop    %esi
  8015a4:	5f                   	pop    %edi
  8015a5:	5d                   	pop    %ebp
  8015a6:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015a7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015ae:	83 ec 0c             	sub    $0xc,%esp
  8015b1:	25 07 0e 00 00       	and    $0xe07,%eax
  8015b6:	50                   	push   %eax
  8015b7:	57                   	push   %edi
  8015b8:	6a 00                	push   $0x0
  8015ba:	53                   	push   %ebx
  8015bb:	6a 00                	push   $0x0
  8015bd:	e8 59 f8 ff ff       	call   800e1b <sys_page_map>
  8015c2:	89 c3                	mov    %eax,%ebx
  8015c4:	83 c4 20             	add    $0x20,%esp
  8015c7:	85 c0                	test   %eax,%eax
  8015c9:	79 a3                	jns    80156e <dup+0x78>
	sys_page_unmap(0, newfd);
  8015cb:	83 ec 08             	sub    $0x8,%esp
  8015ce:	56                   	push   %esi
  8015cf:	6a 00                	push   $0x0
  8015d1:	e8 8b f8 ff ff       	call   800e61 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015d6:	83 c4 08             	add    $0x8,%esp
  8015d9:	57                   	push   %edi
  8015da:	6a 00                	push   $0x0
  8015dc:	e8 80 f8 ff ff       	call   800e61 <sys_page_unmap>
	return r;
  8015e1:	83 c4 10             	add    $0x10,%esp
  8015e4:	eb b7                	jmp    80159d <dup+0xa7>

008015e6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015e6:	f3 0f 1e fb          	endbr32 
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	53                   	push   %ebx
  8015ee:	83 ec 1c             	sub    $0x1c,%esp
  8015f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f7:	50                   	push   %eax
  8015f8:	53                   	push   %ebx
  8015f9:	e8 65 fd ff ff       	call   801363 <fd_lookup>
  8015fe:	83 c4 10             	add    $0x10,%esp
  801601:	85 c0                	test   %eax,%eax
  801603:	78 3f                	js     801644 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801605:	83 ec 08             	sub    $0x8,%esp
  801608:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160b:	50                   	push   %eax
  80160c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160f:	ff 30                	pushl  (%eax)
  801611:	e8 a1 fd ff ff       	call   8013b7 <dev_lookup>
  801616:	83 c4 10             	add    $0x10,%esp
  801619:	85 c0                	test   %eax,%eax
  80161b:	78 27                	js     801644 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80161d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801620:	8b 42 08             	mov    0x8(%edx),%eax
  801623:	83 e0 03             	and    $0x3,%eax
  801626:	83 f8 01             	cmp    $0x1,%eax
  801629:	74 1e                	je     801649 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80162b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162e:	8b 40 08             	mov    0x8(%eax),%eax
  801631:	85 c0                	test   %eax,%eax
  801633:	74 35                	je     80166a <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801635:	83 ec 04             	sub    $0x4,%esp
  801638:	ff 75 10             	pushl  0x10(%ebp)
  80163b:	ff 75 0c             	pushl  0xc(%ebp)
  80163e:	52                   	push   %edx
  80163f:	ff d0                	call   *%eax
  801641:	83 c4 10             	add    $0x10,%esp
}
  801644:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801647:	c9                   	leave  
  801648:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801649:	a1 04 40 80 00       	mov    0x804004,%eax
  80164e:	8b 40 48             	mov    0x48(%eax),%eax
  801651:	83 ec 04             	sub    $0x4,%esp
  801654:	53                   	push   %ebx
  801655:	50                   	push   %eax
  801656:	68 5d 29 80 00       	push   $0x80295d
  80165b:	e8 28 ed ff ff       	call   800388 <cprintf>
		return -E_INVAL;
  801660:	83 c4 10             	add    $0x10,%esp
  801663:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801668:	eb da                	jmp    801644 <read+0x5e>
		return -E_NOT_SUPP;
  80166a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80166f:	eb d3                	jmp    801644 <read+0x5e>

00801671 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801671:	f3 0f 1e fb          	endbr32 
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	57                   	push   %edi
  801679:	56                   	push   %esi
  80167a:	53                   	push   %ebx
  80167b:	83 ec 0c             	sub    $0xc,%esp
  80167e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801681:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801684:	bb 00 00 00 00       	mov    $0x0,%ebx
  801689:	eb 02                	jmp    80168d <readn+0x1c>
  80168b:	01 c3                	add    %eax,%ebx
  80168d:	39 f3                	cmp    %esi,%ebx
  80168f:	73 21                	jae    8016b2 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801691:	83 ec 04             	sub    $0x4,%esp
  801694:	89 f0                	mov    %esi,%eax
  801696:	29 d8                	sub    %ebx,%eax
  801698:	50                   	push   %eax
  801699:	89 d8                	mov    %ebx,%eax
  80169b:	03 45 0c             	add    0xc(%ebp),%eax
  80169e:	50                   	push   %eax
  80169f:	57                   	push   %edi
  8016a0:	e8 41 ff ff ff       	call   8015e6 <read>
		if (m < 0)
  8016a5:	83 c4 10             	add    $0x10,%esp
  8016a8:	85 c0                	test   %eax,%eax
  8016aa:	78 04                	js     8016b0 <readn+0x3f>
			return m;
		if (m == 0)
  8016ac:	75 dd                	jne    80168b <readn+0x1a>
  8016ae:	eb 02                	jmp    8016b2 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016b0:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016b2:	89 d8                	mov    %ebx,%eax
  8016b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016b7:	5b                   	pop    %ebx
  8016b8:	5e                   	pop    %esi
  8016b9:	5f                   	pop    %edi
  8016ba:	5d                   	pop    %ebp
  8016bb:	c3                   	ret    

008016bc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016bc:	f3 0f 1e fb          	endbr32 
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	53                   	push   %ebx
  8016c4:	83 ec 1c             	sub    $0x1c,%esp
  8016c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016cd:	50                   	push   %eax
  8016ce:	53                   	push   %ebx
  8016cf:	e8 8f fc ff ff       	call   801363 <fd_lookup>
  8016d4:	83 c4 10             	add    $0x10,%esp
  8016d7:	85 c0                	test   %eax,%eax
  8016d9:	78 3a                	js     801715 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016db:	83 ec 08             	sub    $0x8,%esp
  8016de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e1:	50                   	push   %eax
  8016e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e5:	ff 30                	pushl  (%eax)
  8016e7:	e8 cb fc ff ff       	call   8013b7 <dev_lookup>
  8016ec:	83 c4 10             	add    $0x10,%esp
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	78 22                	js     801715 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016fa:	74 1e                	je     80171a <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ff:	8b 52 0c             	mov    0xc(%edx),%edx
  801702:	85 d2                	test   %edx,%edx
  801704:	74 35                	je     80173b <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801706:	83 ec 04             	sub    $0x4,%esp
  801709:	ff 75 10             	pushl  0x10(%ebp)
  80170c:	ff 75 0c             	pushl  0xc(%ebp)
  80170f:	50                   	push   %eax
  801710:	ff d2                	call   *%edx
  801712:	83 c4 10             	add    $0x10,%esp
}
  801715:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801718:	c9                   	leave  
  801719:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80171a:	a1 04 40 80 00       	mov    0x804004,%eax
  80171f:	8b 40 48             	mov    0x48(%eax),%eax
  801722:	83 ec 04             	sub    $0x4,%esp
  801725:	53                   	push   %ebx
  801726:	50                   	push   %eax
  801727:	68 79 29 80 00       	push   $0x802979
  80172c:	e8 57 ec ff ff       	call   800388 <cprintf>
		return -E_INVAL;
  801731:	83 c4 10             	add    $0x10,%esp
  801734:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801739:	eb da                	jmp    801715 <write+0x59>
		return -E_NOT_SUPP;
  80173b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801740:	eb d3                	jmp    801715 <write+0x59>

00801742 <seek>:

int
seek(int fdnum, off_t offset)
{
  801742:	f3 0f 1e fb          	endbr32 
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80174c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80174f:	50                   	push   %eax
  801750:	ff 75 08             	pushl  0x8(%ebp)
  801753:	e8 0b fc ff ff       	call   801363 <fd_lookup>
  801758:	83 c4 10             	add    $0x10,%esp
  80175b:	85 c0                	test   %eax,%eax
  80175d:	78 0e                	js     80176d <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80175f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801765:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801768:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80176f:	f3 0f 1e fb          	endbr32 
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	53                   	push   %ebx
  801777:	83 ec 1c             	sub    $0x1c,%esp
  80177a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80177d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801780:	50                   	push   %eax
  801781:	53                   	push   %ebx
  801782:	e8 dc fb ff ff       	call   801363 <fd_lookup>
  801787:	83 c4 10             	add    $0x10,%esp
  80178a:	85 c0                	test   %eax,%eax
  80178c:	78 37                	js     8017c5 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80178e:	83 ec 08             	sub    $0x8,%esp
  801791:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801794:	50                   	push   %eax
  801795:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801798:	ff 30                	pushl  (%eax)
  80179a:	e8 18 fc ff ff       	call   8013b7 <dev_lookup>
  80179f:	83 c4 10             	add    $0x10,%esp
  8017a2:	85 c0                	test   %eax,%eax
  8017a4:	78 1f                	js     8017c5 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017ad:	74 1b                	je     8017ca <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b2:	8b 52 18             	mov    0x18(%edx),%edx
  8017b5:	85 d2                	test   %edx,%edx
  8017b7:	74 32                	je     8017eb <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017b9:	83 ec 08             	sub    $0x8,%esp
  8017bc:	ff 75 0c             	pushl  0xc(%ebp)
  8017bf:	50                   	push   %eax
  8017c0:	ff d2                	call   *%edx
  8017c2:	83 c4 10             	add    $0x10,%esp
}
  8017c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017ca:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017cf:	8b 40 48             	mov    0x48(%eax),%eax
  8017d2:	83 ec 04             	sub    $0x4,%esp
  8017d5:	53                   	push   %ebx
  8017d6:	50                   	push   %eax
  8017d7:	68 3c 29 80 00       	push   $0x80293c
  8017dc:	e8 a7 eb ff ff       	call   800388 <cprintf>
		return -E_INVAL;
  8017e1:	83 c4 10             	add    $0x10,%esp
  8017e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017e9:	eb da                	jmp    8017c5 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8017eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017f0:	eb d3                	jmp    8017c5 <ftruncate+0x56>

008017f2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017f2:	f3 0f 1e fb          	endbr32 
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	53                   	push   %ebx
  8017fa:	83 ec 1c             	sub    $0x1c,%esp
  8017fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801800:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801803:	50                   	push   %eax
  801804:	ff 75 08             	pushl  0x8(%ebp)
  801807:	e8 57 fb ff ff       	call   801363 <fd_lookup>
  80180c:	83 c4 10             	add    $0x10,%esp
  80180f:	85 c0                	test   %eax,%eax
  801811:	78 4b                	js     80185e <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801813:	83 ec 08             	sub    $0x8,%esp
  801816:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801819:	50                   	push   %eax
  80181a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181d:	ff 30                	pushl  (%eax)
  80181f:	e8 93 fb ff ff       	call   8013b7 <dev_lookup>
  801824:	83 c4 10             	add    $0x10,%esp
  801827:	85 c0                	test   %eax,%eax
  801829:	78 33                	js     80185e <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80182b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801832:	74 2f                	je     801863 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801834:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801837:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80183e:	00 00 00 
	stat->st_isdir = 0;
  801841:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801848:	00 00 00 
	stat->st_dev = dev;
  80184b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801851:	83 ec 08             	sub    $0x8,%esp
  801854:	53                   	push   %ebx
  801855:	ff 75 f0             	pushl  -0x10(%ebp)
  801858:	ff 50 14             	call   *0x14(%eax)
  80185b:	83 c4 10             	add    $0x10,%esp
}
  80185e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801861:	c9                   	leave  
  801862:	c3                   	ret    
		return -E_NOT_SUPP;
  801863:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801868:	eb f4                	jmp    80185e <fstat+0x6c>

0080186a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80186a:	f3 0f 1e fb          	endbr32 
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	56                   	push   %esi
  801872:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801873:	83 ec 08             	sub    $0x8,%esp
  801876:	6a 00                	push   $0x0
  801878:	ff 75 08             	pushl  0x8(%ebp)
  80187b:	e8 fb 01 00 00       	call   801a7b <open>
  801880:	89 c3                	mov    %eax,%ebx
  801882:	83 c4 10             	add    $0x10,%esp
  801885:	85 c0                	test   %eax,%eax
  801887:	78 1b                	js     8018a4 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801889:	83 ec 08             	sub    $0x8,%esp
  80188c:	ff 75 0c             	pushl  0xc(%ebp)
  80188f:	50                   	push   %eax
  801890:	e8 5d ff ff ff       	call   8017f2 <fstat>
  801895:	89 c6                	mov    %eax,%esi
	close(fd);
  801897:	89 1c 24             	mov    %ebx,(%esp)
  80189a:	e8 fd fb ff ff       	call   80149c <close>
	return r;
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	89 f3                	mov    %esi,%ebx
}
  8018a4:	89 d8                	mov    %ebx,%eax
  8018a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a9:	5b                   	pop    %ebx
  8018aa:	5e                   	pop    %esi
  8018ab:	5d                   	pop    %ebp
  8018ac:	c3                   	ret    

008018ad <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	56                   	push   %esi
  8018b1:	53                   	push   %ebx
  8018b2:	89 c6                	mov    %eax,%esi
  8018b4:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018b6:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8018bd:	74 27                	je     8018e6 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018bf:	6a 07                	push   $0x7
  8018c1:	68 00 50 80 00       	push   $0x805000
  8018c6:	56                   	push   %esi
  8018c7:	ff 35 00 40 80 00    	pushl  0x804000
  8018cd:	e8 6f 08 00 00       	call   802141 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018d2:	83 c4 0c             	add    $0xc,%esp
  8018d5:	6a 00                	push   $0x0
  8018d7:	53                   	push   %ebx
  8018d8:	6a 00                	push   $0x0
  8018da:	e8 dd 07 00 00       	call   8020bc <ipc_recv>
}
  8018df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e2:	5b                   	pop    %ebx
  8018e3:	5e                   	pop    %esi
  8018e4:	5d                   	pop    %ebp
  8018e5:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018e6:	83 ec 0c             	sub    $0xc,%esp
  8018e9:	6a 01                	push   $0x1
  8018eb:	e8 a9 08 00 00       	call   802199 <ipc_find_env>
  8018f0:	a3 00 40 80 00       	mov    %eax,0x804000
  8018f5:	83 c4 10             	add    $0x10,%esp
  8018f8:	eb c5                	jmp    8018bf <fsipc+0x12>

008018fa <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018fa:	f3 0f 1e fb          	endbr32 
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	8b 40 0c             	mov    0xc(%eax),%eax
  80190a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80190f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801912:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801917:	ba 00 00 00 00       	mov    $0x0,%edx
  80191c:	b8 02 00 00 00       	mov    $0x2,%eax
  801921:	e8 87 ff ff ff       	call   8018ad <fsipc>
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <devfile_flush>:
{
  801928:	f3 0f 1e fb          	endbr32 
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
  80192f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8b 40 0c             	mov    0xc(%eax),%eax
  801938:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80193d:	ba 00 00 00 00       	mov    $0x0,%edx
  801942:	b8 06 00 00 00       	mov    $0x6,%eax
  801947:	e8 61 ff ff ff       	call   8018ad <fsipc>
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <devfile_stat>:
{
  80194e:	f3 0f 1e fb          	endbr32 
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	53                   	push   %ebx
  801956:	83 ec 04             	sub    $0x4,%esp
  801959:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	8b 40 0c             	mov    0xc(%eax),%eax
  801962:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801967:	ba 00 00 00 00       	mov    $0x0,%edx
  80196c:	b8 05 00 00 00       	mov    $0x5,%eax
  801971:	e8 37 ff ff ff       	call   8018ad <fsipc>
  801976:	85 c0                	test   %eax,%eax
  801978:	78 2c                	js     8019a6 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80197a:	83 ec 08             	sub    $0x8,%esp
  80197d:	68 00 50 80 00       	push   $0x805000
  801982:	53                   	push   %ebx
  801983:	e8 0a f0 ff ff       	call   800992 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801988:	a1 80 50 80 00       	mov    0x805080,%eax
  80198d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801993:	a1 84 50 80 00       	mov    0x805084,%eax
  801998:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80199e:	83 c4 10             	add    $0x10,%esp
  8019a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <devfile_write>:
{
  8019ab:	f3 0f 1e fb          	endbr32 
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
  8019b2:	83 ec 0c             	sub    $0xc,%esp
  8019b5:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8019bb:	8b 52 0c             	mov    0xc(%edx),%edx
  8019be:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  8019c4:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8019c9:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8019ce:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  8019d1:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8019d6:	50                   	push   %eax
  8019d7:	ff 75 0c             	pushl  0xc(%ebp)
  8019da:	68 08 50 80 00       	push   $0x805008
  8019df:	e8 64 f1 ff ff       	call   800b48 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8019e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e9:	b8 04 00 00 00       	mov    $0x4,%eax
  8019ee:	e8 ba fe ff ff       	call   8018ad <fsipc>
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <devfile_read>:
{
  8019f5:	f3 0f 1e fb          	endbr32 
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	56                   	push   %esi
  8019fd:	53                   	push   %ebx
  8019fe:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8b 40 0c             	mov    0xc(%eax),%eax
  801a07:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a0c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a12:	ba 00 00 00 00       	mov    $0x0,%edx
  801a17:	b8 03 00 00 00       	mov    $0x3,%eax
  801a1c:	e8 8c fe ff ff       	call   8018ad <fsipc>
  801a21:	89 c3                	mov    %eax,%ebx
  801a23:	85 c0                	test   %eax,%eax
  801a25:	78 1f                	js     801a46 <devfile_read+0x51>
	assert(r <= n);
  801a27:	39 f0                	cmp    %esi,%eax
  801a29:	77 24                	ja     801a4f <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801a2b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a30:	7f 33                	jg     801a65 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a32:	83 ec 04             	sub    $0x4,%esp
  801a35:	50                   	push   %eax
  801a36:	68 00 50 80 00       	push   $0x805000
  801a3b:	ff 75 0c             	pushl  0xc(%ebp)
  801a3e:	e8 05 f1 ff ff       	call   800b48 <memmove>
	return r;
  801a43:	83 c4 10             	add    $0x10,%esp
}
  801a46:	89 d8                	mov    %ebx,%eax
  801a48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a4b:	5b                   	pop    %ebx
  801a4c:	5e                   	pop    %esi
  801a4d:	5d                   	pop    %ebp
  801a4e:	c3                   	ret    
	assert(r <= n);
  801a4f:	68 a8 29 80 00       	push   $0x8029a8
  801a54:	68 af 29 80 00       	push   $0x8029af
  801a59:	6a 7c                	push   $0x7c
  801a5b:	68 c4 29 80 00       	push   $0x8029c4
  801a60:	e8 3c e8 ff ff       	call   8002a1 <_panic>
	assert(r <= PGSIZE);
  801a65:	68 cf 29 80 00       	push   $0x8029cf
  801a6a:	68 af 29 80 00       	push   $0x8029af
  801a6f:	6a 7d                	push   $0x7d
  801a71:	68 c4 29 80 00       	push   $0x8029c4
  801a76:	e8 26 e8 ff ff       	call   8002a1 <_panic>

00801a7b <open>:
{
  801a7b:	f3 0f 1e fb          	endbr32 
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	56                   	push   %esi
  801a83:	53                   	push   %ebx
  801a84:	83 ec 1c             	sub    $0x1c,%esp
  801a87:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a8a:	56                   	push   %esi
  801a8b:	e8 bf ee ff ff       	call   80094f <strlen>
  801a90:	83 c4 10             	add    $0x10,%esp
  801a93:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a98:	7f 6c                	jg     801b06 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801a9a:	83 ec 0c             	sub    $0xc,%esp
  801a9d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa0:	50                   	push   %eax
  801aa1:	e8 67 f8 ff ff       	call   80130d <fd_alloc>
  801aa6:	89 c3                	mov    %eax,%ebx
  801aa8:	83 c4 10             	add    $0x10,%esp
  801aab:	85 c0                	test   %eax,%eax
  801aad:	78 3c                	js     801aeb <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801aaf:	83 ec 08             	sub    $0x8,%esp
  801ab2:	56                   	push   %esi
  801ab3:	68 00 50 80 00       	push   $0x805000
  801ab8:	e8 d5 ee ff ff       	call   800992 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801abd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac0:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ac5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ac8:	b8 01 00 00 00       	mov    $0x1,%eax
  801acd:	e8 db fd ff ff       	call   8018ad <fsipc>
  801ad2:	89 c3                	mov    %eax,%ebx
  801ad4:	83 c4 10             	add    $0x10,%esp
  801ad7:	85 c0                	test   %eax,%eax
  801ad9:	78 19                	js     801af4 <open+0x79>
	return fd2num(fd);
  801adb:	83 ec 0c             	sub    $0xc,%esp
  801ade:	ff 75 f4             	pushl  -0xc(%ebp)
  801ae1:	e8 f8 f7 ff ff       	call   8012de <fd2num>
  801ae6:	89 c3                	mov    %eax,%ebx
  801ae8:	83 c4 10             	add    $0x10,%esp
}
  801aeb:	89 d8                	mov    %ebx,%eax
  801aed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801af0:	5b                   	pop    %ebx
  801af1:	5e                   	pop    %esi
  801af2:	5d                   	pop    %ebp
  801af3:	c3                   	ret    
		fd_close(fd, 0);
  801af4:	83 ec 08             	sub    $0x8,%esp
  801af7:	6a 00                	push   $0x0
  801af9:	ff 75 f4             	pushl  -0xc(%ebp)
  801afc:	e8 10 f9 ff ff       	call   801411 <fd_close>
		return r;
  801b01:	83 c4 10             	add    $0x10,%esp
  801b04:	eb e5                	jmp    801aeb <open+0x70>
		return -E_BAD_PATH;
  801b06:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b0b:	eb de                	jmp    801aeb <open+0x70>

00801b0d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b0d:	f3 0f 1e fb          	endbr32 
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b17:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1c:	b8 08 00 00 00       	mov    $0x8,%eax
  801b21:	e8 87 fd ff ff       	call   8018ad <fsipc>
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b28:	f3 0f 1e fb          	endbr32 
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	56                   	push   %esi
  801b30:	53                   	push   %ebx
  801b31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b34:	83 ec 0c             	sub    $0xc,%esp
  801b37:	ff 75 08             	pushl  0x8(%ebp)
  801b3a:	e8 b3 f7 ff ff       	call   8012f2 <fd2data>
  801b3f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b41:	83 c4 08             	add    $0x8,%esp
  801b44:	68 db 29 80 00       	push   $0x8029db
  801b49:	53                   	push   %ebx
  801b4a:	e8 43 ee ff ff       	call   800992 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b4f:	8b 46 04             	mov    0x4(%esi),%eax
  801b52:	2b 06                	sub    (%esi),%eax
  801b54:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b5a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b61:	00 00 00 
	stat->st_dev = &devpipe;
  801b64:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b6b:	30 80 00 
	return 0;
}
  801b6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b73:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b76:	5b                   	pop    %ebx
  801b77:	5e                   	pop    %esi
  801b78:	5d                   	pop    %ebp
  801b79:	c3                   	ret    

00801b7a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b7a:	f3 0f 1e fb          	endbr32 
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	53                   	push   %ebx
  801b82:	83 ec 0c             	sub    $0xc,%esp
  801b85:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b88:	53                   	push   %ebx
  801b89:	6a 00                	push   $0x0
  801b8b:	e8 d1 f2 ff ff       	call   800e61 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b90:	89 1c 24             	mov    %ebx,(%esp)
  801b93:	e8 5a f7 ff ff       	call   8012f2 <fd2data>
  801b98:	83 c4 08             	add    $0x8,%esp
  801b9b:	50                   	push   %eax
  801b9c:	6a 00                	push   $0x0
  801b9e:	e8 be f2 ff ff       	call   800e61 <sys_page_unmap>
}
  801ba3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <_pipeisclosed>:
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
  801bab:	57                   	push   %edi
  801bac:	56                   	push   %esi
  801bad:	53                   	push   %ebx
  801bae:	83 ec 1c             	sub    $0x1c,%esp
  801bb1:	89 c7                	mov    %eax,%edi
  801bb3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801bb5:	a1 04 40 80 00       	mov    0x804004,%eax
  801bba:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801bbd:	83 ec 0c             	sub    $0xc,%esp
  801bc0:	57                   	push   %edi
  801bc1:	e8 10 06 00 00       	call   8021d6 <pageref>
  801bc6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bc9:	89 34 24             	mov    %esi,(%esp)
  801bcc:	e8 05 06 00 00       	call   8021d6 <pageref>
		nn = thisenv->env_runs;
  801bd1:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bd7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801bda:	83 c4 10             	add    $0x10,%esp
  801bdd:	39 cb                	cmp    %ecx,%ebx
  801bdf:	74 1b                	je     801bfc <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801be1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801be4:	75 cf                	jne    801bb5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801be6:	8b 42 58             	mov    0x58(%edx),%eax
  801be9:	6a 01                	push   $0x1
  801beb:	50                   	push   %eax
  801bec:	53                   	push   %ebx
  801bed:	68 e2 29 80 00       	push   $0x8029e2
  801bf2:	e8 91 e7 ff ff       	call   800388 <cprintf>
  801bf7:	83 c4 10             	add    $0x10,%esp
  801bfa:	eb b9                	jmp    801bb5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bfc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bff:	0f 94 c0             	sete   %al
  801c02:	0f b6 c0             	movzbl %al,%eax
}
  801c05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c08:	5b                   	pop    %ebx
  801c09:	5e                   	pop    %esi
  801c0a:	5f                   	pop    %edi
  801c0b:	5d                   	pop    %ebp
  801c0c:	c3                   	ret    

00801c0d <devpipe_write>:
{
  801c0d:	f3 0f 1e fb          	endbr32 
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	57                   	push   %edi
  801c15:	56                   	push   %esi
  801c16:	53                   	push   %ebx
  801c17:	83 ec 28             	sub    $0x28,%esp
  801c1a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c1d:	56                   	push   %esi
  801c1e:	e8 cf f6 ff ff       	call   8012f2 <fd2data>
  801c23:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c25:	83 c4 10             	add    $0x10,%esp
  801c28:	bf 00 00 00 00       	mov    $0x0,%edi
  801c2d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c30:	74 4f                	je     801c81 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c32:	8b 43 04             	mov    0x4(%ebx),%eax
  801c35:	8b 0b                	mov    (%ebx),%ecx
  801c37:	8d 51 20             	lea    0x20(%ecx),%edx
  801c3a:	39 d0                	cmp    %edx,%eax
  801c3c:	72 14                	jb     801c52 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801c3e:	89 da                	mov    %ebx,%edx
  801c40:	89 f0                	mov    %esi,%eax
  801c42:	e8 61 ff ff ff       	call   801ba8 <_pipeisclosed>
  801c47:	85 c0                	test   %eax,%eax
  801c49:	75 3b                	jne    801c86 <devpipe_write+0x79>
			sys_yield();
  801c4b:	e8 61 f1 ff ff       	call   800db1 <sys_yield>
  801c50:	eb e0                	jmp    801c32 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c55:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c59:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c5c:	89 c2                	mov    %eax,%edx
  801c5e:	c1 fa 1f             	sar    $0x1f,%edx
  801c61:	89 d1                	mov    %edx,%ecx
  801c63:	c1 e9 1b             	shr    $0x1b,%ecx
  801c66:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c69:	83 e2 1f             	and    $0x1f,%edx
  801c6c:	29 ca                	sub    %ecx,%edx
  801c6e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c72:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c76:	83 c0 01             	add    $0x1,%eax
  801c79:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c7c:	83 c7 01             	add    $0x1,%edi
  801c7f:	eb ac                	jmp    801c2d <devpipe_write+0x20>
	return i;
  801c81:	8b 45 10             	mov    0x10(%ebp),%eax
  801c84:	eb 05                	jmp    801c8b <devpipe_write+0x7e>
				return 0;
  801c86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c8e:	5b                   	pop    %ebx
  801c8f:	5e                   	pop    %esi
  801c90:	5f                   	pop    %edi
  801c91:	5d                   	pop    %ebp
  801c92:	c3                   	ret    

00801c93 <devpipe_read>:
{
  801c93:	f3 0f 1e fb          	endbr32 
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
  801c9a:	57                   	push   %edi
  801c9b:	56                   	push   %esi
  801c9c:	53                   	push   %ebx
  801c9d:	83 ec 18             	sub    $0x18,%esp
  801ca0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ca3:	57                   	push   %edi
  801ca4:	e8 49 f6 ff ff       	call   8012f2 <fd2data>
  801ca9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cab:	83 c4 10             	add    $0x10,%esp
  801cae:	be 00 00 00 00       	mov    $0x0,%esi
  801cb3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cb6:	75 14                	jne    801ccc <devpipe_read+0x39>
	return i;
  801cb8:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbb:	eb 02                	jmp    801cbf <devpipe_read+0x2c>
				return i;
  801cbd:	89 f0                	mov    %esi,%eax
}
  801cbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cc2:	5b                   	pop    %ebx
  801cc3:	5e                   	pop    %esi
  801cc4:	5f                   	pop    %edi
  801cc5:	5d                   	pop    %ebp
  801cc6:	c3                   	ret    
			sys_yield();
  801cc7:	e8 e5 f0 ff ff       	call   800db1 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ccc:	8b 03                	mov    (%ebx),%eax
  801cce:	3b 43 04             	cmp    0x4(%ebx),%eax
  801cd1:	75 18                	jne    801ceb <devpipe_read+0x58>
			if (i > 0)
  801cd3:	85 f6                	test   %esi,%esi
  801cd5:	75 e6                	jne    801cbd <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801cd7:	89 da                	mov    %ebx,%edx
  801cd9:	89 f8                	mov    %edi,%eax
  801cdb:	e8 c8 fe ff ff       	call   801ba8 <_pipeisclosed>
  801ce0:	85 c0                	test   %eax,%eax
  801ce2:	74 e3                	je     801cc7 <devpipe_read+0x34>
				return 0;
  801ce4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce9:	eb d4                	jmp    801cbf <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ceb:	99                   	cltd   
  801cec:	c1 ea 1b             	shr    $0x1b,%edx
  801cef:	01 d0                	add    %edx,%eax
  801cf1:	83 e0 1f             	and    $0x1f,%eax
  801cf4:	29 d0                	sub    %edx,%eax
  801cf6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801cfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cfe:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d01:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d04:	83 c6 01             	add    $0x1,%esi
  801d07:	eb aa                	jmp    801cb3 <devpipe_read+0x20>

00801d09 <pipe>:
{
  801d09:	f3 0f 1e fb          	endbr32 
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
  801d10:	56                   	push   %esi
  801d11:	53                   	push   %ebx
  801d12:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d18:	50                   	push   %eax
  801d19:	e8 ef f5 ff ff       	call   80130d <fd_alloc>
  801d1e:	89 c3                	mov    %eax,%ebx
  801d20:	83 c4 10             	add    $0x10,%esp
  801d23:	85 c0                	test   %eax,%eax
  801d25:	0f 88 23 01 00 00    	js     801e4e <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d2b:	83 ec 04             	sub    $0x4,%esp
  801d2e:	68 07 04 00 00       	push   $0x407
  801d33:	ff 75 f4             	pushl  -0xc(%ebp)
  801d36:	6a 00                	push   $0x0
  801d38:	e8 97 f0 ff ff       	call   800dd4 <sys_page_alloc>
  801d3d:	89 c3                	mov    %eax,%ebx
  801d3f:	83 c4 10             	add    $0x10,%esp
  801d42:	85 c0                	test   %eax,%eax
  801d44:	0f 88 04 01 00 00    	js     801e4e <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801d4a:	83 ec 0c             	sub    $0xc,%esp
  801d4d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d50:	50                   	push   %eax
  801d51:	e8 b7 f5 ff ff       	call   80130d <fd_alloc>
  801d56:	89 c3                	mov    %eax,%ebx
  801d58:	83 c4 10             	add    $0x10,%esp
  801d5b:	85 c0                	test   %eax,%eax
  801d5d:	0f 88 db 00 00 00    	js     801e3e <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d63:	83 ec 04             	sub    $0x4,%esp
  801d66:	68 07 04 00 00       	push   $0x407
  801d6b:	ff 75 f0             	pushl  -0x10(%ebp)
  801d6e:	6a 00                	push   $0x0
  801d70:	e8 5f f0 ff ff       	call   800dd4 <sys_page_alloc>
  801d75:	89 c3                	mov    %eax,%ebx
  801d77:	83 c4 10             	add    $0x10,%esp
  801d7a:	85 c0                	test   %eax,%eax
  801d7c:	0f 88 bc 00 00 00    	js     801e3e <pipe+0x135>
	va = fd2data(fd0);
  801d82:	83 ec 0c             	sub    $0xc,%esp
  801d85:	ff 75 f4             	pushl  -0xc(%ebp)
  801d88:	e8 65 f5 ff ff       	call   8012f2 <fd2data>
  801d8d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d8f:	83 c4 0c             	add    $0xc,%esp
  801d92:	68 07 04 00 00       	push   $0x407
  801d97:	50                   	push   %eax
  801d98:	6a 00                	push   $0x0
  801d9a:	e8 35 f0 ff ff       	call   800dd4 <sys_page_alloc>
  801d9f:	89 c3                	mov    %eax,%ebx
  801da1:	83 c4 10             	add    $0x10,%esp
  801da4:	85 c0                	test   %eax,%eax
  801da6:	0f 88 82 00 00 00    	js     801e2e <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dac:	83 ec 0c             	sub    $0xc,%esp
  801daf:	ff 75 f0             	pushl  -0x10(%ebp)
  801db2:	e8 3b f5 ff ff       	call   8012f2 <fd2data>
  801db7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801dbe:	50                   	push   %eax
  801dbf:	6a 00                	push   $0x0
  801dc1:	56                   	push   %esi
  801dc2:	6a 00                	push   $0x0
  801dc4:	e8 52 f0 ff ff       	call   800e1b <sys_page_map>
  801dc9:	89 c3                	mov    %eax,%ebx
  801dcb:	83 c4 20             	add    $0x20,%esp
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	78 4e                	js     801e20 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801dd2:	a1 20 30 80 00       	mov    0x803020,%eax
  801dd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dda:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ddc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ddf:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801de6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801de9:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dee:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801df5:	83 ec 0c             	sub    $0xc,%esp
  801df8:	ff 75 f4             	pushl  -0xc(%ebp)
  801dfb:	e8 de f4 ff ff       	call   8012de <fd2num>
  801e00:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e03:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e05:	83 c4 04             	add    $0x4,%esp
  801e08:	ff 75 f0             	pushl  -0x10(%ebp)
  801e0b:	e8 ce f4 ff ff       	call   8012de <fd2num>
  801e10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e13:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e16:	83 c4 10             	add    $0x10,%esp
  801e19:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e1e:	eb 2e                	jmp    801e4e <pipe+0x145>
	sys_page_unmap(0, va);
  801e20:	83 ec 08             	sub    $0x8,%esp
  801e23:	56                   	push   %esi
  801e24:	6a 00                	push   $0x0
  801e26:	e8 36 f0 ff ff       	call   800e61 <sys_page_unmap>
  801e2b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e2e:	83 ec 08             	sub    $0x8,%esp
  801e31:	ff 75 f0             	pushl  -0x10(%ebp)
  801e34:	6a 00                	push   $0x0
  801e36:	e8 26 f0 ff ff       	call   800e61 <sys_page_unmap>
  801e3b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e3e:	83 ec 08             	sub    $0x8,%esp
  801e41:	ff 75 f4             	pushl  -0xc(%ebp)
  801e44:	6a 00                	push   $0x0
  801e46:	e8 16 f0 ff ff       	call   800e61 <sys_page_unmap>
  801e4b:	83 c4 10             	add    $0x10,%esp
}
  801e4e:	89 d8                	mov    %ebx,%eax
  801e50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e53:	5b                   	pop    %ebx
  801e54:	5e                   	pop    %esi
  801e55:	5d                   	pop    %ebp
  801e56:	c3                   	ret    

00801e57 <pipeisclosed>:
{
  801e57:	f3 0f 1e fb          	endbr32 
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e61:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e64:	50                   	push   %eax
  801e65:	ff 75 08             	pushl  0x8(%ebp)
  801e68:	e8 f6 f4 ff ff       	call   801363 <fd_lookup>
  801e6d:	83 c4 10             	add    $0x10,%esp
  801e70:	85 c0                	test   %eax,%eax
  801e72:	78 18                	js     801e8c <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801e74:	83 ec 0c             	sub    $0xc,%esp
  801e77:	ff 75 f4             	pushl  -0xc(%ebp)
  801e7a:	e8 73 f4 ff ff       	call   8012f2 <fd2data>
  801e7f:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e84:	e8 1f fd ff ff       	call   801ba8 <_pipeisclosed>
  801e89:	83 c4 10             	add    $0x10,%esp
}
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e8e:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801e92:	b8 00 00 00 00       	mov    $0x0,%eax
  801e97:	c3                   	ret    

00801e98 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e98:	f3 0f 1e fb          	endbr32 
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ea2:	68 f5 29 80 00       	push   $0x8029f5
  801ea7:	ff 75 0c             	pushl  0xc(%ebp)
  801eaa:	e8 e3 ea ff ff       	call   800992 <strcpy>
	return 0;
}
  801eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <devcons_write>:
{
  801eb6:	f3 0f 1e fb          	endbr32 
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	57                   	push   %edi
  801ebe:	56                   	push   %esi
  801ebf:	53                   	push   %ebx
  801ec0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ec6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ecb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ed1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ed4:	73 31                	jae    801f07 <devcons_write+0x51>
		m = n - tot;
  801ed6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ed9:	29 f3                	sub    %esi,%ebx
  801edb:	83 fb 7f             	cmp    $0x7f,%ebx
  801ede:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ee3:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ee6:	83 ec 04             	sub    $0x4,%esp
  801ee9:	53                   	push   %ebx
  801eea:	89 f0                	mov    %esi,%eax
  801eec:	03 45 0c             	add    0xc(%ebp),%eax
  801eef:	50                   	push   %eax
  801ef0:	57                   	push   %edi
  801ef1:	e8 52 ec ff ff       	call   800b48 <memmove>
		sys_cputs(buf, m);
  801ef6:	83 c4 08             	add    $0x8,%esp
  801ef9:	53                   	push   %ebx
  801efa:	57                   	push   %edi
  801efb:	e8 04 ee ff ff       	call   800d04 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f00:	01 de                	add    %ebx,%esi
  801f02:	83 c4 10             	add    $0x10,%esp
  801f05:	eb ca                	jmp    801ed1 <devcons_write+0x1b>
}
  801f07:	89 f0                	mov    %esi,%eax
  801f09:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f0c:	5b                   	pop    %ebx
  801f0d:	5e                   	pop    %esi
  801f0e:	5f                   	pop    %edi
  801f0f:	5d                   	pop    %ebp
  801f10:	c3                   	ret    

00801f11 <devcons_read>:
{
  801f11:	f3 0f 1e fb          	endbr32 
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	83 ec 08             	sub    $0x8,%esp
  801f1b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f24:	74 21                	je     801f47 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801f26:	e8 fb ed ff ff       	call   800d26 <sys_cgetc>
  801f2b:	85 c0                	test   %eax,%eax
  801f2d:	75 07                	jne    801f36 <devcons_read+0x25>
		sys_yield();
  801f2f:	e8 7d ee ff ff       	call   800db1 <sys_yield>
  801f34:	eb f0                	jmp    801f26 <devcons_read+0x15>
	if (c < 0)
  801f36:	78 0f                	js     801f47 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801f38:	83 f8 04             	cmp    $0x4,%eax
  801f3b:	74 0c                	je     801f49 <devcons_read+0x38>
	*(char*)vbuf = c;
  801f3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f40:	88 02                	mov    %al,(%edx)
	return 1;
  801f42:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    
		return 0;
  801f49:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4e:	eb f7                	jmp    801f47 <devcons_read+0x36>

00801f50 <cputchar>:
{
  801f50:	f3 0f 1e fb          	endbr32 
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
  801f57:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f60:	6a 01                	push   $0x1
  801f62:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f65:	50                   	push   %eax
  801f66:	e8 99 ed ff ff       	call   800d04 <sys_cputs>
}
  801f6b:	83 c4 10             	add    $0x10,%esp
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <getchar>:
{
  801f70:	f3 0f 1e fb          	endbr32 
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f7a:	6a 01                	push   $0x1
  801f7c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f7f:	50                   	push   %eax
  801f80:	6a 00                	push   $0x0
  801f82:	e8 5f f6 ff ff       	call   8015e6 <read>
	if (r < 0)
  801f87:	83 c4 10             	add    $0x10,%esp
  801f8a:	85 c0                	test   %eax,%eax
  801f8c:	78 06                	js     801f94 <getchar+0x24>
	if (r < 1)
  801f8e:	74 06                	je     801f96 <getchar+0x26>
	return c;
  801f90:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    
		return -E_EOF;
  801f96:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f9b:	eb f7                	jmp    801f94 <getchar+0x24>

00801f9d <iscons>:
{
  801f9d:	f3 0f 1e fb          	endbr32 
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
  801fa4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fa7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801faa:	50                   	push   %eax
  801fab:	ff 75 08             	pushl  0x8(%ebp)
  801fae:	e8 b0 f3 ff ff       	call   801363 <fd_lookup>
  801fb3:	83 c4 10             	add    $0x10,%esp
  801fb6:	85 c0                	test   %eax,%eax
  801fb8:	78 11                	js     801fcb <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbd:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fc3:	39 10                	cmp    %edx,(%eax)
  801fc5:	0f 94 c0             	sete   %al
  801fc8:	0f b6 c0             	movzbl %al,%eax
}
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    

00801fcd <opencons>:
{
  801fcd:	f3 0f 1e fb          	endbr32 
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801fd7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fda:	50                   	push   %eax
  801fdb:	e8 2d f3 ff ff       	call   80130d <fd_alloc>
  801fe0:	83 c4 10             	add    $0x10,%esp
  801fe3:	85 c0                	test   %eax,%eax
  801fe5:	78 3a                	js     802021 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fe7:	83 ec 04             	sub    $0x4,%esp
  801fea:	68 07 04 00 00       	push   $0x407
  801fef:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff2:	6a 00                	push   $0x0
  801ff4:	e8 db ed ff ff       	call   800dd4 <sys_page_alloc>
  801ff9:	83 c4 10             	add    $0x10,%esp
  801ffc:	85 c0                	test   %eax,%eax
  801ffe:	78 21                	js     802021 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802003:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802009:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80200b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802015:	83 ec 0c             	sub    $0xc,%esp
  802018:	50                   	push   %eax
  802019:	e8 c0 f2 ff ff       	call   8012de <fd2num>
  80201e:	83 c4 10             	add    $0x10,%esp
}
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802023:	f3 0f 1e fb          	endbr32 
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80202d:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802034:	74 0a                	je     802040 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	a3 00 60 80 00       	mov    %eax,0x806000
}
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  802040:	83 ec 04             	sub    $0x4,%esp
  802043:	6a 07                	push   $0x7
  802045:	68 00 f0 bf ee       	push   $0xeebff000
  80204a:	6a 00                	push   $0x0
  80204c:	e8 83 ed ff ff       	call   800dd4 <sys_page_alloc>
  802051:	83 c4 10             	add    $0x10,%esp
  802054:	85 c0                	test   %eax,%eax
  802056:	78 2a                	js     802082 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  802058:	83 ec 08             	sub    $0x8,%esp
  80205b:	68 96 20 80 00       	push   $0x802096
  802060:	6a 00                	push   $0x0
  802062:	e8 cc ee ff ff       	call   800f33 <sys_env_set_pgfault_upcall>
  802067:	83 c4 10             	add    $0x10,%esp
  80206a:	85 c0                	test   %eax,%eax
  80206c:	79 c8                	jns    802036 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  80206e:	83 ec 04             	sub    $0x4,%esp
  802071:	68 30 2a 80 00       	push   $0x802a30
  802076:	6a 25                	push   $0x25
  802078:	68 68 2a 80 00       	push   $0x802a68
  80207d:	e8 1f e2 ff ff       	call   8002a1 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  802082:	83 ec 04             	sub    $0x4,%esp
  802085:	68 04 2a 80 00       	push   $0x802a04
  80208a:	6a 22                	push   $0x22
  80208c:	68 68 2a 80 00       	push   $0x802a68
  802091:	e8 0b e2 ff ff       	call   8002a1 <_panic>

00802096 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802096:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802097:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  80209c:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80209e:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  8020a1:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  8020a5:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8020a9:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8020ac:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  8020ae:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  8020b2:	83 c4 08             	add    $0x8,%esp
	popal
  8020b5:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  8020b6:	83 c4 04             	add    $0x4,%esp
	popfl
  8020b9:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  8020ba:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  8020bb:	c3                   	ret    

008020bc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020bc:	f3 0f 1e fb          	endbr32 
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	56                   	push   %esi
  8020c4:	53                   	push   %ebx
  8020c5:	8b 75 08             	mov    0x8(%ebp),%esi
  8020c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	74 3d                	je     80210f <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8020d2:	83 ec 0c             	sub    $0xc,%esp
  8020d5:	50                   	push   %eax
  8020d6:	e8 c5 ee ff ff       	call   800fa0 <sys_ipc_recv>
  8020db:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8020de:	85 f6                	test   %esi,%esi
  8020e0:	74 0b                	je     8020ed <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8020e2:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8020e8:	8b 52 74             	mov    0x74(%edx),%edx
  8020eb:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8020ed:	85 db                	test   %ebx,%ebx
  8020ef:	74 0b                	je     8020fc <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8020f1:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8020f7:	8b 52 78             	mov    0x78(%edx),%edx
  8020fa:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	78 21                	js     802121 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  802100:	a1 04 40 80 00       	mov    0x804004,%eax
  802105:	8b 40 70             	mov    0x70(%eax),%eax
}
  802108:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80210b:	5b                   	pop    %ebx
  80210c:	5e                   	pop    %esi
  80210d:	5d                   	pop    %ebp
  80210e:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  80210f:	83 ec 0c             	sub    $0xc,%esp
  802112:	68 00 00 c0 ee       	push   $0xeec00000
  802117:	e8 84 ee ff ff       	call   800fa0 <sys_ipc_recv>
  80211c:	83 c4 10             	add    $0x10,%esp
  80211f:	eb bd                	jmp    8020de <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802121:	85 f6                	test   %esi,%esi
  802123:	74 10                	je     802135 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802125:	85 db                	test   %ebx,%ebx
  802127:	75 df                	jne    802108 <ipc_recv+0x4c>
  802129:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802130:	00 00 00 
  802133:	eb d3                	jmp    802108 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802135:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80213c:	00 00 00 
  80213f:	eb e4                	jmp    802125 <ipc_recv+0x69>

00802141 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802141:	f3 0f 1e fb          	endbr32 
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
  802148:	57                   	push   %edi
  802149:	56                   	push   %esi
  80214a:	53                   	push   %ebx
  80214b:	83 ec 0c             	sub    $0xc,%esp
  80214e:	8b 7d 08             	mov    0x8(%ebp),%edi
  802151:	8b 75 0c             	mov    0xc(%ebp),%esi
  802154:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802157:	85 db                	test   %ebx,%ebx
  802159:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80215e:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802161:	ff 75 14             	pushl  0x14(%ebp)
  802164:	53                   	push   %ebx
  802165:	56                   	push   %esi
  802166:	57                   	push   %edi
  802167:	e8 0d ee ff ff       	call   800f79 <sys_ipc_try_send>
  80216c:	83 c4 10             	add    $0x10,%esp
  80216f:	85 c0                	test   %eax,%eax
  802171:	79 1e                	jns    802191 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802173:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802176:	75 07                	jne    80217f <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802178:	e8 34 ec ff ff       	call   800db1 <sys_yield>
  80217d:	eb e2                	jmp    802161 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  80217f:	50                   	push   %eax
  802180:	68 76 2a 80 00       	push   $0x802a76
  802185:	6a 59                	push   $0x59
  802187:	68 91 2a 80 00       	push   $0x802a91
  80218c:	e8 10 e1 ff ff       	call   8002a1 <_panic>
	}
}
  802191:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802194:	5b                   	pop    %ebx
  802195:	5e                   	pop    %esi
  802196:	5f                   	pop    %edi
  802197:	5d                   	pop    %ebp
  802198:	c3                   	ret    

00802199 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802199:	f3 0f 1e fb          	endbr32 
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
  8021a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021a3:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8021a8:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8021ab:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021b1:	8b 52 50             	mov    0x50(%edx),%edx
  8021b4:	39 ca                	cmp    %ecx,%edx
  8021b6:	74 11                	je     8021c9 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8021b8:	83 c0 01             	add    $0x1,%eax
  8021bb:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021c0:	75 e6                	jne    8021a8 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8021c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c7:	eb 0b                	jmp    8021d4 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8021c9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021cc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021d1:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021d4:	5d                   	pop    %ebp
  8021d5:	c3                   	ret    

008021d6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021d6:	f3 0f 1e fb          	endbr32 
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021e0:	89 c2                	mov    %eax,%edx
  8021e2:	c1 ea 16             	shr    $0x16,%edx
  8021e5:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8021ec:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021f1:	f6 c1 01             	test   $0x1,%cl
  8021f4:	74 1c                	je     802212 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8021f6:	c1 e8 0c             	shr    $0xc,%eax
  8021f9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802200:	a8 01                	test   $0x1,%al
  802202:	74 0e                	je     802212 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802204:	c1 e8 0c             	shr    $0xc,%eax
  802207:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80220e:	ef 
  80220f:	0f b7 d2             	movzwl %dx,%edx
}
  802212:	89 d0                	mov    %edx,%eax
  802214:	5d                   	pop    %ebp
  802215:	c3                   	ret    
  802216:	66 90                	xchg   %ax,%ax
  802218:	66 90                	xchg   %ax,%ax
  80221a:	66 90                	xchg   %ax,%ax
  80221c:	66 90                	xchg   %ax,%ax
  80221e:	66 90                	xchg   %ax,%ax

00802220 <__udivdi3>:
  802220:	f3 0f 1e fb          	endbr32 
  802224:	55                   	push   %ebp
  802225:	57                   	push   %edi
  802226:	56                   	push   %esi
  802227:	53                   	push   %ebx
  802228:	83 ec 1c             	sub    $0x1c,%esp
  80222b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80222f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802233:	8b 74 24 34          	mov    0x34(%esp),%esi
  802237:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80223b:	85 d2                	test   %edx,%edx
  80223d:	75 19                	jne    802258 <__udivdi3+0x38>
  80223f:	39 f3                	cmp    %esi,%ebx
  802241:	76 4d                	jbe    802290 <__udivdi3+0x70>
  802243:	31 ff                	xor    %edi,%edi
  802245:	89 e8                	mov    %ebp,%eax
  802247:	89 f2                	mov    %esi,%edx
  802249:	f7 f3                	div    %ebx
  80224b:	89 fa                	mov    %edi,%edx
  80224d:	83 c4 1c             	add    $0x1c,%esp
  802250:	5b                   	pop    %ebx
  802251:	5e                   	pop    %esi
  802252:	5f                   	pop    %edi
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    
  802255:	8d 76 00             	lea    0x0(%esi),%esi
  802258:	39 f2                	cmp    %esi,%edx
  80225a:	76 14                	jbe    802270 <__udivdi3+0x50>
  80225c:	31 ff                	xor    %edi,%edi
  80225e:	31 c0                	xor    %eax,%eax
  802260:	89 fa                	mov    %edi,%edx
  802262:	83 c4 1c             	add    $0x1c,%esp
  802265:	5b                   	pop    %ebx
  802266:	5e                   	pop    %esi
  802267:	5f                   	pop    %edi
  802268:	5d                   	pop    %ebp
  802269:	c3                   	ret    
  80226a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802270:	0f bd fa             	bsr    %edx,%edi
  802273:	83 f7 1f             	xor    $0x1f,%edi
  802276:	75 48                	jne    8022c0 <__udivdi3+0xa0>
  802278:	39 f2                	cmp    %esi,%edx
  80227a:	72 06                	jb     802282 <__udivdi3+0x62>
  80227c:	31 c0                	xor    %eax,%eax
  80227e:	39 eb                	cmp    %ebp,%ebx
  802280:	77 de                	ja     802260 <__udivdi3+0x40>
  802282:	b8 01 00 00 00       	mov    $0x1,%eax
  802287:	eb d7                	jmp    802260 <__udivdi3+0x40>
  802289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802290:	89 d9                	mov    %ebx,%ecx
  802292:	85 db                	test   %ebx,%ebx
  802294:	75 0b                	jne    8022a1 <__udivdi3+0x81>
  802296:	b8 01 00 00 00       	mov    $0x1,%eax
  80229b:	31 d2                	xor    %edx,%edx
  80229d:	f7 f3                	div    %ebx
  80229f:	89 c1                	mov    %eax,%ecx
  8022a1:	31 d2                	xor    %edx,%edx
  8022a3:	89 f0                	mov    %esi,%eax
  8022a5:	f7 f1                	div    %ecx
  8022a7:	89 c6                	mov    %eax,%esi
  8022a9:	89 e8                	mov    %ebp,%eax
  8022ab:	89 f7                	mov    %esi,%edi
  8022ad:	f7 f1                	div    %ecx
  8022af:	89 fa                	mov    %edi,%edx
  8022b1:	83 c4 1c             	add    $0x1c,%esp
  8022b4:	5b                   	pop    %ebx
  8022b5:	5e                   	pop    %esi
  8022b6:	5f                   	pop    %edi
  8022b7:	5d                   	pop    %ebp
  8022b8:	c3                   	ret    
  8022b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022c0:	89 f9                	mov    %edi,%ecx
  8022c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022c7:	29 f8                	sub    %edi,%eax
  8022c9:	d3 e2                	shl    %cl,%edx
  8022cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022cf:	89 c1                	mov    %eax,%ecx
  8022d1:	89 da                	mov    %ebx,%edx
  8022d3:	d3 ea                	shr    %cl,%edx
  8022d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022d9:	09 d1                	or     %edx,%ecx
  8022db:	89 f2                	mov    %esi,%edx
  8022dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022e1:	89 f9                	mov    %edi,%ecx
  8022e3:	d3 e3                	shl    %cl,%ebx
  8022e5:	89 c1                	mov    %eax,%ecx
  8022e7:	d3 ea                	shr    %cl,%edx
  8022e9:	89 f9                	mov    %edi,%ecx
  8022eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022ef:	89 eb                	mov    %ebp,%ebx
  8022f1:	d3 e6                	shl    %cl,%esi
  8022f3:	89 c1                	mov    %eax,%ecx
  8022f5:	d3 eb                	shr    %cl,%ebx
  8022f7:	09 de                	or     %ebx,%esi
  8022f9:	89 f0                	mov    %esi,%eax
  8022fb:	f7 74 24 08          	divl   0x8(%esp)
  8022ff:	89 d6                	mov    %edx,%esi
  802301:	89 c3                	mov    %eax,%ebx
  802303:	f7 64 24 0c          	mull   0xc(%esp)
  802307:	39 d6                	cmp    %edx,%esi
  802309:	72 15                	jb     802320 <__udivdi3+0x100>
  80230b:	89 f9                	mov    %edi,%ecx
  80230d:	d3 e5                	shl    %cl,%ebp
  80230f:	39 c5                	cmp    %eax,%ebp
  802311:	73 04                	jae    802317 <__udivdi3+0xf7>
  802313:	39 d6                	cmp    %edx,%esi
  802315:	74 09                	je     802320 <__udivdi3+0x100>
  802317:	89 d8                	mov    %ebx,%eax
  802319:	31 ff                	xor    %edi,%edi
  80231b:	e9 40 ff ff ff       	jmp    802260 <__udivdi3+0x40>
  802320:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802323:	31 ff                	xor    %edi,%edi
  802325:	e9 36 ff ff ff       	jmp    802260 <__udivdi3+0x40>
  80232a:	66 90                	xchg   %ax,%ax
  80232c:	66 90                	xchg   %ax,%ax
  80232e:	66 90                	xchg   %ax,%ax

00802330 <__umoddi3>:
  802330:	f3 0f 1e fb          	endbr32 
  802334:	55                   	push   %ebp
  802335:	57                   	push   %edi
  802336:	56                   	push   %esi
  802337:	53                   	push   %ebx
  802338:	83 ec 1c             	sub    $0x1c,%esp
  80233b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80233f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802343:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802347:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80234b:	85 c0                	test   %eax,%eax
  80234d:	75 19                	jne    802368 <__umoddi3+0x38>
  80234f:	39 df                	cmp    %ebx,%edi
  802351:	76 5d                	jbe    8023b0 <__umoddi3+0x80>
  802353:	89 f0                	mov    %esi,%eax
  802355:	89 da                	mov    %ebx,%edx
  802357:	f7 f7                	div    %edi
  802359:	89 d0                	mov    %edx,%eax
  80235b:	31 d2                	xor    %edx,%edx
  80235d:	83 c4 1c             	add    $0x1c,%esp
  802360:	5b                   	pop    %ebx
  802361:	5e                   	pop    %esi
  802362:	5f                   	pop    %edi
  802363:	5d                   	pop    %ebp
  802364:	c3                   	ret    
  802365:	8d 76 00             	lea    0x0(%esi),%esi
  802368:	89 f2                	mov    %esi,%edx
  80236a:	39 d8                	cmp    %ebx,%eax
  80236c:	76 12                	jbe    802380 <__umoddi3+0x50>
  80236e:	89 f0                	mov    %esi,%eax
  802370:	89 da                	mov    %ebx,%edx
  802372:	83 c4 1c             	add    $0x1c,%esp
  802375:	5b                   	pop    %ebx
  802376:	5e                   	pop    %esi
  802377:	5f                   	pop    %edi
  802378:	5d                   	pop    %ebp
  802379:	c3                   	ret    
  80237a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802380:	0f bd e8             	bsr    %eax,%ebp
  802383:	83 f5 1f             	xor    $0x1f,%ebp
  802386:	75 50                	jne    8023d8 <__umoddi3+0xa8>
  802388:	39 d8                	cmp    %ebx,%eax
  80238a:	0f 82 e0 00 00 00    	jb     802470 <__umoddi3+0x140>
  802390:	89 d9                	mov    %ebx,%ecx
  802392:	39 f7                	cmp    %esi,%edi
  802394:	0f 86 d6 00 00 00    	jbe    802470 <__umoddi3+0x140>
  80239a:	89 d0                	mov    %edx,%eax
  80239c:	89 ca                	mov    %ecx,%edx
  80239e:	83 c4 1c             	add    $0x1c,%esp
  8023a1:	5b                   	pop    %ebx
  8023a2:	5e                   	pop    %esi
  8023a3:	5f                   	pop    %edi
  8023a4:	5d                   	pop    %ebp
  8023a5:	c3                   	ret    
  8023a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ad:	8d 76 00             	lea    0x0(%esi),%esi
  8023b0:	89 fd                	mov    %edi,%ebp
  8023b2:	85 ff                	test   %edi,%edi
  8023b4:	75 0b                	jne    8023c1 <__umoddi3+0x91>
  8023b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023bb:	31 d2                	xor    %edx,%edx
  8023bd:	f7 f7                	div    %edi
  8023bf:	89 c5                	mov    %eax,%ebp
  8023c1:	89 d8                	mov    %ebx,%eax
  8023c3:	31 d2                	xor    %edx,%edx
  8023c5:	f7 f5                	div    %ebp
  8023c7:	89 f0                	mov    %esi,%eax
  8023c9:	f7 f5                	div    %ebp
  8023cb:	89 d0                	mov    %edx,%eax
  8023cd:	31 d2                	xor    %edx,%edx
  8023cf:	eb 8c                	jmp    80235d <__umoddi3+0x2d>
  8023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023d8:	89 e9                	mov    %ebp,%ecx
  8023da:	ba 20 00 00 00       	mov    $0x20,%edx
  8023df:	29 ea                	sub    %ebp,%edx
  8023e1:	d3 e0                	shl    %cl,%eax
  8023e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023e7:	89 d1                	mov    %edx,%ecx
  8023e9:	89 f8                	mov    %edi,%eax
  8023eb:	d3 e8                	shr    %cl,%eax
  8023ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023f9:	09 c1                	or     %eax,%ecx
  8023fb:	89 d8                	mov    %ebx,%eax
  8023fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802401:	89 e9                	mov    %ebp,%ecx
  802403:	d3 e7                	shl    %cl,%edi
  802405:	89 d1                	mov    %edx,%ecx
  802407:	d3 e8                	shr    %cl,%eax
  802409:	89 e9                	mov    %ebp,%ecx
  80240b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80240f:	d3 e3                	shl    %cl,%ebx
  802411:	89 c7                	mov    %eax,%edi
  802413:	89 d1                	mov    %edx,%ecx
  802415:	89 f0                	mov    %esi,%eax
  802417:	d3 e8                	shr    %cl,%eax
  802419:	89 e9                	mov    %ebp,%ecx
  80241b:	89 fa                	mov    %edi,%edx
  80241d:	d3 e6                	shl    %cl,%esi
  80241f:	09 d8                	or     %ebx,%eax
  802421:	f7 74 24 08          	divl   0x8(%esp)
  802425:	89 d1                	mov    %edx,%ecx
  802427:	89 f3                	mov    %esi,%ebx
  802429:	f7 64 24 0c          	mull   0xc(%esp)
  80242d:	89 c6                	mov    %eax,%esi
  80242f:	89 d7                	mov    %edx,%edi
  802431:	39 d1                	cmp    %edx,%ecx
  802433:	72 06                	jb     80243b <__umoddi3+0x10b>
  802435:	75 10                	jne    802447 <__umoddi3+0x117>
  802437:	39 c3                	cmp    %eax,%ebx
  802439:	73 0c                	jae    802447 <__umoddi3+0x117>
  80243b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80243f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802443:	89 d7                	mov    %edx,%edi
  802445:	89 c6                	mov    %eax,%esi
  802447:	89 ca                	mov    %ecx,%edx
  802449:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80244e:	29 f3                	sub    %esi,%ebx
  802450:	19 fa                	sbb    %edi,%edx
  802452:	89 d0                	mov    %edx,%eax
  802454:	d3 e0                	shl    %cl,%eax
  802456:	89 e9                	mov    %ebp,%ecx
  802458:	d3 eb                	shr    %cl,%ebx
  80245a:	d3 ea                	shr    %cl,%edx
  80245c:	09 d8                	or     %ebx,%eax
  80245e:	83 c4 1c             	add    $0x1c,%esp
  802461:	5b                   	pop    %ebx
  802462:	5e                   	pop    %esi
  802463:	5f                   	pop    %edi
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    
  802466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80246d:	8d 76 00             	lea    0x0(%esi),%esi
  802470:	29 fe                	sub    %edi,%esi
  802472:	19 c3                	sbb    %eax,%ebx
  802474:	89 f2                	mov    %esi,%edx
  802476:	89 d9                	mov    %ebx,%ecx
  802478:	e9 1d ff ff ff       	jmp    80239a <__umoddi3+0x6a>
