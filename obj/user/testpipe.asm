
obj/user/testpipe.debug:     file format elf32-i386


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
  80002c:	e8 a5 02 00 00       	call   8002d6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	83 ec 7c             	sub    $0x7c,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003f:	c7 05 04 40 80 00 e0 	movl   $0x802ae0,0x804004
  800046:	2a 80 00 

	if ((i = pipe(p)) < 0)
  800049:	8d 45 8c             	lea    -0x74(%ebp),%eax
  80004c:	50                   	push   %eax
  80004d:	e8 c0 22 00 00       	call   802312 <pipe>
  800052:	89 c6                	mov    %eax,%esi
  800054:	83 c4 10             	add    $0x10,%esp
  800057:	85 c0                	test   %eax,%eax
  800059:	0f 88 1b 01 00 00    	js     80017a <umain+0x147>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80005f:	e8 ad 11 00 00       	call   801211 <fork>
  800064:	89 c3                	mov    %eax,%ebx
  800066:	85 c0                	test   %eax,%eax
  800068:	0f 88 1e 01 00 00    	js     80018c <umain+0x159>
		panic("fork: %e", i);

	if (pid == 0) {
  80006e:	0f 85 56 01 00 00    	jne    8001ca <umain+0x197>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800074:	a1 08 50 80 00       	mov    0x805008,%eax
  800079:	8b 40 48             	mov    0x48(%eax),%eax
  80007c:	83 ec 04             	sub    $0x4,%esp
  80007f:	ff 75 90             	pushl  -0x70(%ebp)
  800082:	50                   	push   %eax
  800083:	68 05 2b 80 00       	push   $0x802b05
  800088:	e8 98 03 00 00       	call   800425 <cprintf>
		close(p[1]);
  80008d:	83 c4 04             	add    $0x4,%esp
  800090:	ff 75 90             	pushl  -0x70(%ebp)
  800093:	e8 55 15 00 00       	call   8015ed <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800098:	a1 08 50 80 00       	mov    0x805008,%eax
  80009d:	8b 40 48             	mov    0x48(%eax),%eax
  8000a0:	83 c4 0c             	add    $0xc,%esp
  8000a3:	ff 75 8c             	pushl  -0x74(%ebp)
  8000a6:	50                   	push   %eax
  8000a7:	68 22 2b 80 00       	push   $0x802b22
  8000ac:	e8 74 03 00 00       	call   800425 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000b1:	83 c4 0c             	add    $0xc,%esp
  8000b4:	6a 63                	push   $0x63
  8000b6:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000b9:	50                   	push   %eax
  8000ba:	ff 75 8c             	pushl  -0x74(%ebp)
  8000bd:	e8 00 17 00 00       	call   8017c2 <readn>
  8000c2:	89 c6                	mov    %eax,%esi
		if (i < 0)
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	85 c0                	test   %eax,%eax
  8000c9:	0f 88 cf 00 00 00    	js     80019e <umain+0x16b>
			panic("read: %e", i);
		buf[i] = 0;
  8000cf:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  8000d4:	83 ec 08             	sub    $0x8,%esp
  8000d7:	ff 35 00 40 80 00    	pushl  0x804000
  8000dd:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000e0:	50                   	push   %eax
  8000e1:	e8 08 0a 00 00       	call   800aee <strcmp>
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	85 c0                	test   %eax,%eax
  8000eb:	0f 85 bf 00 00 00    	jne    8001b0 <umain+0x17d>
			cprintf("\npipe read closed properly\n");
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	68 48 2b 80 00       	push   $0x802b48
  8000f9:	e8 27 03 00 00       	call   800425 <cprintf>
  8000fe:	83 c4 10             	add    $0x10,%esp
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
		exit();
  800101:	e8 1a 02 00 00       	call   800320 <exit>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
			panic("write: %e", i);
		close(p[1]);
	}
	wait(pid);
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	53                   	push   %ebx
  80010a:	e8 88 23 00 00       	call   802497 <wait>

	binaryname = "pipewriteeof";
  80010f:	c7 05 04 40 80 00 9e 	movl   $0x802b9e,0x804004
  800116:	2b 80 00 
	if ((i = pipe(p)) < 0)
  800119:	8d 45 8c             	lea    -0x74(%ebp),%eax
  80011c:	89 04 24             	mov    %eax,(%esp)
  80011f:	e8 ee 21 00 00       	call   802312 <pipe>
  800124:	89 c6                	mov    %eax,%esi
  800126:	83 c4 10             	add    $0x10,%esp
  800129:	85 c0                	test   %eax,%eax
  80012b:	0f 88 32 01 00 00    	js     800263 <umain+0x230>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  800131:	e8 db 10 00 00       	call   801211 <fork>
  800136:	89 c3                	mov    %eax,%ebx
  800138:	85 c0                	test   %eax,%eax
  80013a:	0f 88 35 01 00 00    	js     800275 <umain+0x242>
		panic("fork: %e", i);

	if (pid == 0) {
  800140:	0f 84 41 01 00 00    	je     800287 <umain+0x254>
				break;
		}
		cprintf("\npipe write closed properly\n");
		exit();
	}
	close(p[0]);
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	ff 75 8c             	pushl  -0x74(%ebp)
  80014c:	e8 9c 14 00 00       	call   8015ed <close>
	close(p[1]);
  800151:	83 c4 04             	add    $0x4,%esp
  800154:	ff 75 90             	pushl  -0x70(%ebp)
  800157:	e8 91 14 00 00       	call   8015ed <close>
	wait(pid);
  80015c:	89 1c 24             	mov    %ebx,(%esp)
  80015f:	e8 33 23 00 00       	call   802497 <wait>

	cprintf("pipe tests passed\n");
  800164:	c7 04 24 cc 2b 80 00 	movl   $0x802bcc,(%esp)
  80016b:	e8 b5 02 00 00       	call   800425 <cprintf>
}
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800176:	5b                   	pop    %ebx
  800177:	5e                   	pop    %esi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    
		panic("pipe: %e", i);
  80017a:	50                   	push   %eax
  80017b:	68 ec 2a 80 00       	push   $0x802aec
  800180:	6a 0e                	push   $0xe
  800182:	68 f5 2a 80 00       	push   $0x802af5
  800187:	e8 b2 01 00 00       	call   80033e <_panic>
		panic("fork: %e", i);
  80018c:	56                   	push   %esi
  80018d:	68 c5 2f 80 00       	push   $0x802fc5
  800192:	6a 11                	push   $0x11
  800194:	68 f5 2a 80 00       	push   $0x802af5
  800199:	e8 a0 01 00 00       	call   80033e <_panic>
			panic("read: %e", i);
  80019e:	50                   	push   %eax
  80019f:	68 3f 2b 80 00       	push   $0x802b3f
  8001a4:	6a 19                	push   $0x19
  8001a6:	68 f5 2a 80 00       	push   $0x802af5
  8001ab:	e8 8e 01 00 00       	call   80033e <_panic>
			cprintf("\ngot %d bytes: %s\n", i, buf);
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b6:	50                   	push   %eax
  8001b7:	56                   	push   %esi
  8001b8:	68 64 2b 80 00       	push   $0x802b64
  8001bd:	e8 63 02 00 00       	call   800425 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
  8001c5:	e9 37 ff ff ff       	jmp    800101 <umain+0xce>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8001ca:	a1 08 50 80 00       	mov    0x805008,%eax
  8001cf:	8b 40 48             	mov    0x48(%eax),%eax
  8001d2:	83 ec 04             	sub    $0x4,%esp
  8001d5:	ff 75 8c             	pushl  -0x74(%ebp)
  8001d8:	50                   	push   %eax
  8001d9:	68 05 2b 80 00       	push   $0x802b05
  8001de:	e8 42 02 00 00       	call   800425 <cprintf>
		close(p[0]);
  8001e3:	83 c4 04             	add    $0x4,%esp
  8001e6:	ff 75 8c             	pushl  -0x74(%ebp)
  8001e9:	e8 ff 13 00 00       	call   8015ed <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001ee:	a1 08 50 80 00       	mov    0x805008,%eax
  8001f3:	8b 40 48             	mov    0x48(%eax),%eax
  8001f6:	83 c4 0c             	add    $0xc,%esp
  8001f9:	ff 75 90             	pushl  -0x70(%ebp)
  8001fc:	50                   	push   %eax
  8001fd:	68 77 2b 80 00       	push   $0x802b77
  800202:	e8 1e 02 00 00       	call   800425 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800207:	83 c4 04             	add    $0x4,%esp
  80020a:	ff 35 00 40 80 00    	pushl  0x804000
  800210:	e8 d7 07 00 00       	call   8009ec <strlen>
  800215:	83 c4 0c             	add    $0xc,%esp
  800218:	50                   	push   %eax
  800219:	ff 35 00 40 80 00    	pushl  0x804000
  80021f:	ff 75 90             	pushl  -0x70(%ebp)
  800222:	e8 e6 15 00 00       	call   80180d <write>
  800227:	89 c6                	mov    %eax,%esi
  800229:	83 c4 04             	add    $0x4,%esp
  80022c:	ff 35 00 40 80 00    	pushl  0x804000
  800232:	e8 b5 07 00 00       	call   8009ec <strlen>
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	39 f0                	cmp    %esi,%eax
  80023c:	75 13                	jne    800251 <umain+0x21e>
		close(p[1]);
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	ff 75 90             	pushl  -0x70(%ebp)
  800244:	e8 a4 13 00 00       	call   8015ed <close>
  800249:	83 c4 10             	add    $0x10,%esp
  80024c:	e9 b5 fe ff ff       	jmp    800106 <umain+0xd3>
			panic("write: %e", i);
  800251:	56                   	push   %esi
  800252:	68 94 2b 80 00       	push   $0x802b94
  800257:	6a 25                	push   $0x25
  800259:	68 f5 2a 80 00       	push   $0x802af5
  80025e:	e8 db 00 00 00       	call   80033e <_panic>
		panic("pipe: %e", i);
  800263:	50                   	push   %eax
  800264:	68 ec 2a 80 00       	push   $0x802aec
  800269:	6a 2c                	push   $0x2c
  80026b:	68 f5 2a 80 00       	push   $0x802af5
  800270:	e8 c9 00 00 00       	call   80033e <_panic>
		panic("fork: %e", i);
  800275:	56                   	push   %esi
  800276:	68 c5 2f 80 00       	push   $0x802fc5
  80027b:	6a 2f                	push   $0x2f
  80027d:	68 f5 2a 80 00       	push   $0x802af5
  800282:	e8 b7 00 00 00       	call   80033e <_panic>
		close(p[0]);
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	ff 75 8c             	pushl  -0x74(%ebp)
  80028d:	e8 5b 13 00 00       	call   8015ed <close>
  800292:	83 c4 10             	add    $0x10,%esp
			cprintf(".");
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	68 ab 2b 80 00       	push   $0x802bab
  80029d:	e8 83 01 00 00       	call   800425 <cprintf>
			if (write(p[1], "x", 1) != 1)
  8002a2:	83 c4 0c             	add    $0xc,%esp
  8002a5:	6a 01                	push   $0x1
  8002a7:	68 ad 2b 80 00       	push   $0x802bad
  8002ac:	ff 75 90             	pushl  -0x70(%ebp)
  8002af:	e8 59 15 00 00       	call   80180d <write>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	83 f8 01             	cmp    $0x1,%eax
  8002ba:	74 d9                	je     800295 <umain+0x262>
		cprintf("\npipe write closed properly\n");
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 af 2b 80 00       	push   $0x802baf
  8002c4:	e8 5c 01 00 00       	call   800425 <cprintf>
		exit();
  8002c9:	e8 52 00 00 00       	call   800320 <exit>
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	e9 70 fe ff ff       	jmp    800146 <umain+0x113>

008002d6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d6:	f3 0f 1e fb          	endbr32 
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	56                   	push   %esi
  8002de:	53                   	push   %ebx
  8002df:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002e2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002e5:	e8 41 0b 00 00       	call   800e2b <sys_getenvid>
  8002ea:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002ef:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002f2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f7:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002fc:	85 db                	test   %ebx,%ebx
  8002fe:	7e 07                	jle    800307 <libmain+0x31>
		binaryname = argv[0];
  800300:	8b 06                	mov    (%esi),%eax
  800302:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	56                   	push   %esi
  80030b:	53                   	push   %ebx
  80030c:	e8 22 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800311:	e8 0a 00 00 00       	call   800320 <exit>
}
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80031c:	5b                   	pop    %ebx
  80031d:	5e                   	pop    %esi
  80031e:	5d                   	pop    %ebp
  80031f:	c3                   	ret    

00800320 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800320:	f3 0f 1e fb          	endbr32 
  800324:	55                   	push   %ebp
  800325:	89 e5                	mov    %esp,%ebp
  800327:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80032a:	e8 ef 12 00 00       	call   80161e <close_all>
	sys_env_destroy(0);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	6a 00                	push   $0x0
  800334:	e8 ad 0a 00 00       	call   800de6 <sys_env_destroy>
}
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	c9                   	leave  
  80033d:	c3                   	ret    

0080033e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80033e:	f3 0f 1e fb          	endbr32 
  800342:	55                   	push   %ebp
  800343:	89 e5                	mov    %esp,%ebp
  800345:	56                   	push   %esi
  800346:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800347:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80034a:	8b 35 04 40 80 00    	mov    0x804004,%esi
  800350:	e8 d6 0a 00 00       	call   800e2b <sys_getenvid>
  800355:	83 ec 0c             	sub    $0xc,%esp
  800358:	ff 75 0c             	pushl  0xc(%ebp)
  80035b:	ff 75 08             	pushl  0x8(%ebp)
  80035e:	56                   	push   %esi
  80035f:	50                   	push   %eax
  800360:	68 30 2c 80 00       	push   $0x802c30
  800365:	e8 bb 00 00 00       	call   800425 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80036a:	83 c4 18             	add    $0x18,%esp
  80036d:	53                   	push   %ebx
  80036e:	ff 75 10             	pushl  0x10(%ebp)
  800371:	e8 5a 00 00 00       	call   8003d0 <vcprintf>
	cprintf("\n");
  800376:	c7 04 24 20 2b 80 00 	movl   $0x802b20,(%esp)
  80037d:	e8 a3 00 00 00       	call   800425 <cprintf>
  800382:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800385:	cc                   	int3   
  800386:	eb fd                	jmp    800385 <_panic+0x47>

00800388 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800388:	f3 0f 1e fb          	endbr32 
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	53                   	push   %ebx
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800396:	8b 13                	mov    (%ebx),%edx
  800398:	8d 42 01             	lea    0x1(%edx),%eax
  80039b:	89 03                	mov    %eax,(%ebx)
  80039d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003a4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a9:	74 09                	je     8003b4 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003ab:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003b2:	c9                   	leave  
  8003b3:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003b4:	83 ec 08             	sub    $0x8,%esp
  8003b7:	68 ff 00 00 00       	push   $0xff
  8003bc:	8d 43 08             	lea    0x8(%ebx),%eax
  8003bf:	50                   	push   %eax
  8003c0:	e8 dc 09 00 00       	call   800da1 <sys_cputs>
		b->idx = 0;
  8003c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	eb db                	jmp    8003ab <putch+0x23>

008003d0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003d0:	f3 0f 1e fb          	endbr32 
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003e4:	00 00 00 
	b.cnt = 0;
  8003e7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003ee:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003f1:	ff 75 0c             	pushl  0xc(%ebp)
  8003f4:	ff 75 08             	pushl  0x8(%ebp)
  8003f7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003fd:	50                   	push   %eax
  8003fe:	68 88 03 80 00       	push   $0x800388
  800403:	e8 20 01 00 00       	call   800528 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800408:	83 c4 08             	add    $0x8,%esp
  80040b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800411:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800417:	50                   	push   %eax
  800418:	e8 84 09 00 00       	call   800da1 <sys_cputs>

	return b.cnt;
}
  80041d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800423:	c9                   	leave  
  800424:	c3                   	ret    

00800425 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800425:	f3 0f 1e fb          	endbr32 
  800429:	55                   	push   %ebp
  80042a:	89 e5                	mov    %esp,%ebp
  80042c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80042f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800432:	50                   	push   %eax
  800433:	ff 75 08             	pushl  0x8(%ebp)
  800436:	e8 95 ff ff ff       	call   8003d0 <vcprintf>
	va_end(ap);

	return cnt;
}
  80043b:	c9                   	leave  
  80043c:	c3                   	ret    

0080043d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80043d:	55                   	push   %ebp
  80043e:	89 e5                	mov    %esp,%ebp
  800440:	57                   	push   %edi
  800441:	56                   	push   %esi
  800442:	53                   	push   %ebx
  800443:	83 ec 1c             	sub    $0x1c,%esp
  800446:	89 c7                	mov    %eax,%edi
  800448:	89 d6                	mov    %edx,%esi
  80044a:	8b 45 08             	mov    0x8(%ebp),%eax
  80044d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800450:	89 d1                	mov    %edx,%ecx
  800452:	89 c2                	mov    %eax,%edx
  800454:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800457:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80045a:	8b 45 10             	mov    0x10(%ebp),%eax
  80045d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800460:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800463:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80046a:	39 c2                	cmp    %eax,%edx
  80046c:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80046f:	72 3e                	jb     8004af <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800471:	83 ec 0c             	sub    $0xc,%esp
  800474:	ff 75 18             	pushl  0x18(%ebp)
  800477:	83 eb 01             	sub    $0x1,%ebx
  80047a:	53                   	push   %ebx
  80047b:	50                   	push   %eax
  80047c:	83 ec 08             	sub    $0x8,%esp
  80047f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800482:	ff 75 e0             	pushl  -0x20(%ebp)
  800485:	ff 75 dc             	pushl  -0x24(%ebp)
  800488:	ff 75 d8             	pushl  -0x28(%ebp)
  80048b:	e8 f0 23 00 00       	call   802880 <__udivdi3>
  800490:	83 c4 18             	add    $0x18,%esp
  800493:	52                   	push   %edx
  800494:	50                   	push   %eax
  800495:	89 f2                	mov    %esi,%edx
  800497:	89 f8                	mov    %edi,%eax
  800499:	e8 9f ff ff ff       	call   80043d <printnum>
  80049e:	83 c4 20             	add    $0x20,%esp
  8004a1:	eb 13                	jmp    8004b6 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004a3:	83 ec 08             	sub    $0x8,%esp
  8004a6:	56                   	push   %esi
  8004a7:	ff 75 18             	pushl  0x18(%ebp)
  8004aa:	ff d7                	call   *%edi
  8004ac:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004af:	83 eb 01             	sub    $0x1,%ebx
  8004b2:	85 db                	test   %ebx,%ebx
  8004b4:	7f ed                	jg     8004a3 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	56                   	push   %esi
  8004ba:	83 ec 04             	sub    $0x4,%esp
  8004bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c3:	ff 75 dc             	pushl  -0x24(%ebp)
  8004c6:	ff 75 d8             	pushl  -0x28(%ebp)
  8004c9:	e8 c2 24 00 00       	call   802990 <__umoddi3>
  8004ce:	83 c4 14             	add    $0x14,%esp
  8004d1:	0f be 80 53 2c 80 00 	movsbl 0x802c53(%eax),%eax
  8004d8:	50                   	push   %eax
  8004d9:	ff d7                	call   *%edi
}
  8004db:	83 c4 10             	add    $0x10,%esp
  8004de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004e1:	5b                   	pop    %ebx
  8004e2:	5e                   	pop    %esi
  8004e3:	5f                   	pop    %edi
  8004e4:	5d                   	pop    %ebp
  8004e5:	c3                   	ret    

008004e6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004e6:	f3 0f 1e fb          	endbr32 
  8004ea:	55                   	push   %ebp
  8004eb:	89 e5                	mov    %esp,%ebp
  8004ed:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004f0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004f4:	8b 10                	mov    (%eax),%edx
  8004f6:	3b 50 04             	cmp    0x4(%eax),%edx
  8004f9:	73 0a                	jae    800505 <sprintputch+0x1f>
		*b->buf++ = ch;
  8004fb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004fe:	89 08                	mov    %ecx,(%eax)
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	88 02                	mov    %al,(%edx)
}
  800505:	5d                   	pop    %ebp
  800506:	c3                   	ret    

00800507 <printfmt>:
{
  800507:	f3 0f 1e fb          	endbr32 
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800511:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800514:	50                   	push   %eax
  800515:	ff 75 10             	pushl  0x10(%ebp)
  800518:	ff 75 0c             	pushl  0xc(%ebp)
  80051b:	ff 75 08             	pushl  0x8(%ebp)
  80051e:	e8 05 00 00 00       	call   800528 <vprintfmt>
}
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	c9                   	leave  
  800527:	c3                   	ret    

00800528 <vprintfmt>:
{
  800528:	f3 0f 1e fb          	endbr32 
  80052c:	55                   	push   %ebp
  80052d:	89 e5                	mov    %esp,%ebp
  80052f:	57                   	push   %edi
  800530:	56                   	push   %esi
  800531:	53                   	push   %ebx
  800532:	83 ec 3c             	sub    $0x3c,%esp
  800535:	8b 75 08             	mov    0x8(%ebp),%esi
  800538:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80053b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80053e:	e9 8e 03 00 00       	jmp    8008d1 <vprintfmt+0x3a9>
		padc = ' ';
  800543:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800547:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80054e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800555:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80055c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800561:	8d 47 01             	lea    0x1(%edi),%eax
  800564:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800567:	0f b6 17             	movzbl (%edi),%edx
  80056a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80056d:	3c 55                	cmp    $0x55,%al
  80056f:	0f 87 df 03 00 00    	ja     800954 <vprintfmt+0x42c>
  800575:	0f b6 c0             	movzbl %al,%eax
  800578:	3e ff 24 85 a0 2d 80 	notrack jmp *0x802da0(,%eax,4)
  80057f:	00 
  800580:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800583:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800587:	eb d8                	jmp    800561 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800589:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80058c:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800590:	eb cf                	jmp    800561 <vprintfmt+0x39>
  800592:	0f b6 d2             	movzbl %dl,%edx
  800595:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800598:	b8 00 00 00 00       	mov    $0x0,%eax
  80059d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8005a0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005a3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005a7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005aa:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005ad:	83 f9 09             	cmp    $0x9,%ecx
  8005b0:	77 55                	ja     800607 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8005b2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005b5:	eb e9                	jmp    8005a0 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	8d 40 04             	lea    0x4(%eax),%eax
  8005c5:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005cb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005cf:	79 90                	jns    800561 <vprintfmt+0x39>
				width = precision, precision = -1;
  8005d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005de:	eb 81                	jmp    800561 <vprintfmt+0x39>
  8005e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e3:	85 c0                	test   %eax,%eax
  8005e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ea:	0f 49 d0             	cmovns %eax,%edx
  8005ed:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005f3:	e9 69 ff ff ff       	jmp    800561 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8005f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005fb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800602:	e9 5a ff ff ff       	jmp    800561 <vprintfmt+0x39>
  800607:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80060a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060d:	eb bc                	jmp    8005cb <vprintfmt+0xa3>
			lflag++;
  80060f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800612:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800615:	e9 47 ff ff ff       	jmp    800561 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8d 78 04             	lea    0x4(%eax),%edi
  800620:	83 ec 08             	sub    $0x8,%esp
  800623:	53                   	push   %ebx
  800624:	ff 30                	pushl  (%eax)
  800626:	ff d6                	call   *%esi
			break;
  800628:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80062b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80062e:	e9 9b 02 00 00       	jmp    8008ce <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	8d 78 04             	lea    0x4(%eax),%edi
  800639:	8b 00                	mov    (%eax),%eax
  80063b:	99                   	cltd   
  80063c:	31 d0                	xor    %edx,%eax
  80063e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800640:	83 f8 0f             	cmp    $0xf,%eax
  800643:	7f 23                	jg     800668 <vprintfmt+0x140>
  800645:	8b 14 85 00 2f 80 00 	mov    0x802f00(,%eax,4),%edx
  80064c:	85 d2                	test   %edx,%edx
  80064e:	74 18                	je     800668 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800650:	52                   	push   %edx
  800651:	68 c5 30 80 00       	push   $0x8030c5
  800656:	53                   	push   %ebx
  800657:	56                   	push   %esi
  800658:	e8 aa fe ff ff       	call   800507 <printfmt>
  80065d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800660:	89 7d 14             	mov    %edi,0x14(%ebp)
  800663:	e9 66 02 00 00       	jmp    8008ce <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800668:	50                   	push   %eax
  800669:	68 6b 2c 80 00       	push   $0x802c6b
  80066e:	53                   	push   %ebx
  80066f:	56                   	push   %esi
  800670:	e8 92 fe ff ff       	call   800507 <printfmt>
  800675:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800678:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80067b:	e9 4e 02 00 00       	jmp    8008ce <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	83 c0 04             	add    $0x4,%eax
  800686:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80068e:	85 d2                	test   %edx,%edx
  800690:	b8 64 2c 80 00       	mov    $0x802c64,%eax
  800695:	0f 45 c2             	cmovne %edx,%eax
  800698:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80069b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80069f:	7e 06                	jle    8006a7 <vprintfmt+0x17f>
  8006a1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006a5:	75 0d                	jne    8006b4 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006aa:	89 c7                	mov    %eax,%edi
  8006ac:	03 45 e0             	add    -0x20(%ebp),%eax
  8006af:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b2:	eb 55                	jmp    800709 <vprintfmt+0x1e1>
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	ff 75 d8             	pushl  -0x28(%ebp)
  8006ba:	ff 75 cc             	pushl  -0x34(%ebp)
  8006bd:	e8 46 03 00 00       	call   800a08 <strnlen>
  8006c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c5:	29 c2                	sub    %eax,%edx
  8006c7:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006cf:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d6:	85 ff                	test   %edi,%edi
  8006d8:	7e 11                	jle    8006eb <vprintfmt+0x1c3>
					putch(padc, putdat);
  8006da:	83 ec 08             	sub    $0x8,%esp
  8006dd:	53                   	push   %ebx
  8006de:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e3:	83 ef 01             	sub    $0x1,%edi
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	eb eb                	jmp    8006d6 <vprintfmt+0x1ae>
  8006eb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006ee:	85 d2                	test   %edx,%edx
  8006f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f5:	0f 49 c2             	cmovns %edx,%eax
  8006f8:	29 c2                	sub    %eax,%edx
  8006fa:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8006fd:	eb a8                	jmp    8006a7 <vprintfmt+0x17f>
					putch(ch, putdat);
  8006ff:	83 ec 08             	sub    $0x8,%esp
  800702:	53                   	push   %ebx
  800703:	52                   	push   %edx
  800704:	ff d6                	call   *%esi
  800706:	83 c4 10             	add    $0x10,%esp
  800709:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80070c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80070e:	83 c7 01             	add    $0x1,%edi
  800711:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800715:	0f be d0             	movsbl %al,%edx
  800718:	85 d2                	test   %edx,%edx
  80071a:	74 4b                	je     800767 <vprintfmt+0x23f>
  80071c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800720:	78 06                	js     800728 <vprintfmt+0x200>
  800722:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800726:	78 1e                	js     800746 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800728:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80072c:	74 d1                	je     8006ff <vprintfmt+0x1d7>
  80072e:	0f be c0             	movsbl %al,%eax
  800731:	83 e8 20             	sub    $0x20,%eax
  800734:	83 f8 5e             	cmp    $0x5e,%eax
  800737:	76 c6                	jbe    8006ff <vprintfmt+0x1d7>
					putch('?', putdat);
  800739:	83 ec 08             	sub    $0x8,%esp
  80073c:	53                   	push   %ebx
  80073d:	6a 3f                	push   $0x3f
  80073f:	ff d6                	call   *%esi
  800741:	83 c4 10             	add    $0x10,%esp
  800744:	eb c3                	jmp    800709 <vprintfmt+0x1e1>
  800746:	89 cf                	mov    %ecx,%edi
  800748:	eb 0e                	jmp    800758 <vprintfmt+0x230>
				putch(' ', putdat);
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	53                   	push   %ebx
  80074e:	6a 20                	push   $0x20
  800750:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800752:	83 ef 01             	sub    $0x1,%edi
  800755:	83 c4 10             	add    $0x10,%esp
  800758:	85 ff                	test   %edi,%edi
  80075a:	7f ee                	jg     80074a <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80075c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
  800762:	e9 67 01 00 00       	jmp    8008ce <vprintfmt+0x3a6>
  800767:	89 cf                	mov    %ecx,%edi
  800769:	eb ed                	jmp    800758 <vprintfmt+0x230>
	if (lflag >= 2)
  80076b:	83 f9 01             	cmp    $0x1,%ecx
  80076e:	7f 1b                	jg     80078b <vprintfmt+0x263>
	else if (lflag)
  800770:	85 c9                	test   %ecx,%ecx
  800772:	74 63                	je     8007d7 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077c:	99                   	cltd   
  80077d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	8d 40 04             	lea    0x4(%eax),%eax
  800786:	89 45 14             	mov    %eax,0x14(%ebp)
  800789:	eb 17                	jmp    8007a2 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8b 50 04             	mov    0x4(%eax),%edx
  800791:	8b 00                	mov    (%eax),%eax
  800793:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800796:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800799:	8b 45 14             	mov    0x14(%ebp),%eax
  80079c:	8d 40 08             	lea    0x8(%eax),%eax
  80079f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8007a2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007a5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007a8:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007ad:	85 c9                	test   %ecx,%ecx
  8007af:	0f 89 ff 00 00 00    	jns    8008b4 <vprintfmt+0x38c>
				putch('-', putdat);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	53                   	push   %ebx
  8007b9:	6a 2d                	push   $0x2d
  8007bb:	ff d6                	call   *%esi
				num = -(long long) num;
  8007bd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007c0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007c3:	f7 da                	neg    %edx
  8007c5:	83 d1 00             	adc    $0x0,%ecx
  8007c8:	f7 d9                	neg    %ecx
  8007ca:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007cd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d2:	e9 dd 00 00 00       	jmp    8008b4 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8b 00                	mov    (%eax),%eax
  8007dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007df:	99                   	cltd   
  8007e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	8d 40 04             	lea    0x4(%eax),%eax
  8007e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ec:	eb b4                	jmp    8007a2 <vprintfmt+0x27a>
	if (lflag >= 2)
  8007ee:	83 f9 01             	cmp    $0x1,%ecx
  8007f1:	7f 1e                	jg     800811 <vprintfmt+0x2e9>
	else if (lflag)
  8007f3:	85 c9                	test   %ecx,%ecx
  8007f5:	74 32                	je     800829 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	8b 10                	mov    (%eax),%edx
  8007fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800801:	8d 40 04             	lea    0x4(%eax),%eax
  800804:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800807:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80080c:	e9 a3 00 00 00       	jmp    8008b4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800811:	8b 45 14             	mov    0x14(%ebp),%eax
  800814:	8b 10                	mov    (%eax),%edx
  800816:	8b 48 04             	mov    0x4(%eax),%ecx
  800819:	8d 40 08             	lea    0x8(%eax),%eax
  80081c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80081f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800824:	e9 8b 00 00 00       	jmp    8008b4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800829:	8b 45 14             	mov    0x14(%ebp),%eax
  80082c:	8b 10                	mov    (%eax),%edx
  80082e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800833:	8d 40 04             	lea    0x4(%eax),%eax
  800836:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800839:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80083e:	eb 74                	jmp    8008b4 <vprintfmt+0x38c>
	if (lflag >= 2)
  800840:	83 f9 01             	cmp    $0x1,%ecx
  800843:	7f 1b                	jg     800860 <vprintfmt+0x338>
	else if (lflag)
  800845:	85 c9                	test   %ecx,%ecx
  800847:	74 2c                	je     800875 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	8b 10                	mov    (%eax),%edx
  80084e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800853:	8d 40 04             	lea    0x4(%eax),%eax
  800856:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800859:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80085e:	eb 54                	jmp    8008b4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800860:	8b 45 14             	mov    0x14(%ebp),%eax
  800863:	8b 10                	mov    (%eax),%edx
  800865:	8b 48 04             	mov    0x4(%eax),%ecx
  800868:	8d 40 08             	lea    0x8(%eax),%eax
  80086b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80086e:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800873:	eb 3f                	jmp    8008b4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	8b 10                	mov    (%eax),%edx
  80087a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80087f:	8d 40 04             	lea    0x4(%eax),%eax
  800882:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800885:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80088a:	eb 28                	jmp    8008b4 <vprintfmt+0x38c>
			putch('0', putdat);
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	53                   	push   %ebx
  800890:	6a 30                	push   $0x30
  800892:	ff d6                	call   *%esi
			putch('x', putdat);
  800894:	83 c4 08             	add    $0x8,%esp
  800897:	53                   	push   %ebx
  800898:	6a 78                	push   $0x78
  80089a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	8b 10                	mov    (%eax),%edx
  8008a1:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008a6:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008a9:	8d 40 04             	lea    0x4(%eax),%eax
  8008ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008af:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008b4:	83 ec 0c             	sub    $0xc,%esp
  8008b7:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8008bb:	57                   	push   %edi
  8008bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8008bf:	50                   	push   %eax
  8008c0:	51                   	push   %ecx
  8008c1:	52                   	push   %edx
  8008c2:	89 da                	mov    %ebx,%edx
  8008c4:	89 f0                	mov    %esi,%eax
  8008c6:	e8 72 fb ff ff       	call   80043d <printnum>
			break;
  8008cb:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008d1:	83 c7 01             	add    $0x1,%edi
  8008d4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008d8:	83 f8 25             	cmp    $0x25,%eax
  8008db:	0f 84 62 fc ff ff    	je     800543 <vprintfmt+0x1b>
			if (ch == '\0')
  8008e1:	85 c0                	test   %eax,%eax
  8008e3:	0f 84 8b 00 00 00    	je     800974 <vprintfmt+0x44c>
			putch(ch, putdat);
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	53                   	push   %ebx
  8008ed:	50                   	push   %eax
  8008ee:	ff d6                	call   *%esi
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	eb dc                	jmp    8008d1 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8008f5:	83 f9 01             	cmp    $0x1,%ecx
  8008f8:	7f 1b                	jg     800915 <vprintfmt+0x3ed>
	else if (lflag)
  8008fa:	85 c9                	test   %ecx,%ecx
  8008fc:	74 2c                	je     80092a <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8008fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800901:	8b 10                	mov    (%eax),%edx
  800903:	b9 00 00 00 00       	mov    $0x0,%ecx
  800908:	8d 40 04             	lea    0x4(%eax),%eax
  80090b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80090e:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800913:	eb 9f                	jmp    8008b4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800915:	8b 45 14             	mov    0x14(%ebp),%eax
  800918:	8b 10                	mov    (%eax),%edx
  80091a:	8b 48 04             	mov    0x4(%eax),%ecx
  80091d:	8d 40 08             	lea    0x8(%eax),%eax
  800920:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800923:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800928:	eb 8a                	jmp    8008b4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80092a:	8b 45 14             	mov    0x14(%ebp),%eax
  80092d:	8b 10                	mov    (%eax),%edx
  80092f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800934:	8d 40 04             	lea    0x4(%eax),%eax
  800937:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80093a:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80093f:	e9 70 ff ff ff       	jmp    8008b4 <vprintfmt+0x38c>
			putch(ch, putdat);
  800944:	83 ec 08             	sub    $0x8,%esp
  800947:	53                   	push   %ebx
  800948:	6a 25                	push   $0x25
  80094a:	ff d6                	call   *%esi
			break;
  80094c:	83 c4 10             	add    $0x10,%esp
  80094f:	e9 7a ff ff ff       	jmp    8008ce <vprintfmt+0x3a6>
			putch('%', putdat);
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	53                   	push   %ebx
  800958:	6a 25                	push   $0x25
  80095a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80095c:	83 c4 10             	add    $0x10,%esp
  80095f:	89 f8                	mov    %edi,%eax
  800961:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800965:	74 05                	je     80096c <vprintfmt+0x444>
  800967:	83 e8 01             	sub    $0x1,%eax
  80096a:	eb f5                	jmp    800961 <vprintfmt+0x439>
  80096c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80096f:	e9 5a ff ff ff       	jmp    8008ce <vprintfmt+0x3a6>
}
  800974:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800977:	5b                   	pop    %ebx
  800978:	5e                   	pop    %esi
  800979:	5f                   	pop    %edi
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80097c:	f3 0f 1e fb          	endbr32 
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	83 ec 18             	sub    $0x18,%esp
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80098c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80098f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800993:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800996:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099d:	85 c0                	test   %eax,%eax
  80099f:	74 26                	je     8009c7 <vsnprintf+0x4b>
  8009a1:	85 d2                	test   %edx,%edx
  8009a3:	7e 22                	jle    8009c7 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009a5:	ff 75 14             	pushl  0x14(%ebp)
  8009a8:	ff 75 10             	pushl  0x10(%ebp)
  8009ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009ae:	50                   	push   %eax
  8009af:	68 e6 04 80 00       	push   $0x8004e6
  8009b4:	e8 6f fb ff ff       	call   800528 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009bc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009c2:	83 c4 10             	add    $0x10,%esp
}
  8009c5:	c9                   	leave  
  8009c6:	c3                   	ret    
		return -E_INVAL;
  8009c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009cc:	eb f7                	jmp    8009c5 <vsnprintf+0x49>

008009ce <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009ce:	f3 0f 1e fb          	endbr32 
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d8:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009db:	50                   	push   %eax
  8009dc:	ff 75 10             	pushl  0x10(%ebp)
  8009df:	ff 75 0c             	pushl  0xc(%ebp)
  8009e2:	ff 75 08             	pushl  0x8(%ebp)
  8009e5:	e8 92 ff ff ff       	call   80097c <vsnprintf>
	va_end(ap);

	return rc;
}
  8009ea:	c9                   	leave  
  8009eb:	c3                   	ret    

008009ec <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009ec:	f3 0f 1e fb          	endbr32 
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009ff:	74 05                	je     800a06 <strlen+0x1a>
		n++;
  800a01:	83 c0 01             	add    $0x1,%eax
  800a04:	eb f5                	jmp    8009fb <strlen+0xf>
	return n;
}
  800a06:	5d                   	pop    %ebp
  800a07:	c3                   	ret    

00800a08 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a08:	f3 0f 1e fb          	endbr32 
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a12:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a15:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1a:	39 d0                	cmp    %edx,%eax
  800a1c:	74 0d                	je     800a2b <strnlen+0x23>
  800a1e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a22:	74 05                	je     800a29 <strnlen+0x21>
		n++;
  800a24:	83 c0 01             	add    $0x1,%eax
  800a27:	eb f1                	jmp    800a1a <strnlen+0x12>
  800a29:	89 c2                	mov    %eax,%edx
	return n;
}
  800a2b:	89 d0                	mov    %edx,%eax
  800a2d:	5d                   	pop    %ebp
  800a2e:	c3                   	ret    

00800a2f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a2f:	f3 0f 1e fb          	endbr32 
  800a33:	55                   	push   %ebp
  800a34:	89 e5                	mov    %esp,%ebp
  800a36:	53                   	push   %ebx
  800a37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a3a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a3d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a42:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800a46:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800a49:	83 c0 01             	add    $0x1,%eax
  800a4c:	84 d2                	test   %dl,%dl
  800a4e:	75 f2                	jne    800a42 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800a50:	89 c8                	mov    %ecx,%eax
  800a52:	5b                   	pop    %ebx
  800a53:	5d                   	pop    %ebp
  800a54:	c3                   	ret    

00800a55 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a55:	f3 0f 1e fb          	endbr32 
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	53                   	push   %ebx
  800a5d:	83 ec 10             	sub    $0x10,%esp
  800a60:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a63:	53                   	push   %ebx
  800a64:	e8 83 ff ff ff       	call   8009ec <strlen>
  800a69:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a6c:	ff 75 0c             	pushl  0xc(%ebp)
  800a6f:	01 d8                	add    %ebx,%eax
  800a71:	50                   	push   %eax
  800a72:	e8 b8 ff ff ff       	call   800a2f <strcpy>
	return dst;
}
  800a77:	89 d8                	mov    %ebx,%eax
  800a79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a7c:	c9                   	leave  
  800a7d:	c3                   	ret    

00800a7e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a7e:	f3 0f 1e fb          	endbr32 
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	56                   	push   %esi
  800a86:	53                   	push   %ebx
  800a87:	8b 75 08             	mov    0x8(%ebp),%esi
  800a8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8d:	89 f3                	mov    %esi,%ebx
  800a8f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a92:	89 f0                	mov    %esi,%eax
  800a94:	39 d8                	cmp    %ebx,%eax
  800a96:	74 11                	je     800aa9 <strncpy+0x2b>
		*dst++ = *src;
  800a98:	83 c0 01             	add    $0x1,%eax
  800a9b:	0f b6 0a             	movzbl (%edx),%ecx
  800a9e:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aa1:	80 f9 01             	cmp    $0x1,%cl
  800aa4:	83 da ff             	sbb    $0xffffffff,%edx
  800aa7:	eb eb                	jmp    800a94 <strncpy+0x16>
	}
	return ret;
}
  800aa9:	89 f0                	mov    %esi,%eax
  800aab:	5b                   	pop    %ebx
  800aac:	5e                   	pop    %esi
  800aad:	5d                   	pop    %ebp
  800aae:	c3                   	ret    

00800aaf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aaf:	f3 0f 1e fb          	endbr32 
  800ab3:	55                   	push   %ebp
  800ab4:	89 e5                	mov    %esp,%ebp
  800ab6:	56                   	push   %esi
  800ab7:	53                   	push   %ebx
  800ab8:	8b 75 08             	mov    0x8(%ebp),%esi
  800abb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800abe:	8b 55 10             	mov    0x10(%ebp),%edx
  800ac1:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ac3:	85 d2                	test   %edx,%edx
  800ac5:	74 21                	je     800ae8 <strlcpy+0x39>
  800ac7:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800acb:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800acd:	39 c2                	cmp    %eax,%edx
  800acf:	74 14                	je     800ae5 <strlcpy+0x36>
  800ad1:	0f b6 19             	movzbl (%ecx),%ebx
  800ad4:	84 db                	test   %bl,%bl
  800ad6:	74 0b                	je     800ae3 <strlcpy+0x34>
			*dst++ = *src++;
  800ad8:	83 c1 01             	add    $0x1,%ecx
  800adb:	83 c2 01             	add    $0x1,%edx
  800ade:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ae1:	eb ea                	jmp    800acd <strlcpy+0x1e>
  800ae3:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ae5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ae8:	29 f0                	sub    %esi,%eax
}
  800aea:	5b                   	pop    %ebx
  800aeb:	5e                   	pop    %esi
  800aec:	5d                   	pop    %ebp
  800aed:	c3                   	ret    

00800aee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800aee:	f3 0f 1e fb          	endbr32 
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800afb:	0f b6 01             	movzbl (%ecx),%eax
  800afe:	84 c0                	test   %al,%al
  800b00:	74 0c                	je     800b0e <strcmp+0x20>
  800b02:	3a 02                	cmp    (%edx),%al
  800b04:	75 08                	jne    800b0e <strcmp+0x20>
		p++, q++;
  800b06:	83 c1 01             	add    $0x1,%ecx
  800b09:	83 c2 01             	add    $0x1,%edx
  800b0c:	eb ed                	jmp    800afb <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b0e:	0f b6 c0             	movzbl %al,%eax
  800b11:	0f b6 12             	movzbl (%edx),%edx
  800b14:	29 d0                	sub    %edx,%eax
}
  800b16:	5d                   	pop    %ebp
  800b17:	c3                   	ret    

00800b18 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b18:	f3 0f 1e fb          	endbr32 
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	53                   	push   %ebx
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b26:	89 c3                	mov    %eax,%ebx
  800b28:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b2b:	eb 06                	jmp    800b33 <strncmp+0x1b>
		n--, p++, q++;
  800b2d:	83 c0 01             	add    $0x1,%eax
  800b30:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b33:	39 d8                	cmp    %ebx,%eax
  800b35:	74 16                	je     800b4d <strncmp+0x35>
  800b37:	0f b6 08             	movzbl (%eax),%ecx
  800b3a:	84 c9                	test   %cl,%cl
  800b3c:	74 04                	je     800b42 <strncmp+0x2a>
  800b3e:	3a 0a                	cmp    (%edx),%cl
  800b40:	74 eb                	je     800b2d <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b42:	0f b6 00             	movzbl (%eax),%eax
  800b45:	0f b6 12             	movzbl (%edx),%edx
  800b48:	29 d0                	sub    %edx,%eax
}
  800b4a:	5b                   	pop    %ebx
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    
		return 0;
  800b4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b52:	eb f6                	jmp    800b4a <strncmp+0x32>

00800b54 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b54:	f3 0f 1e fb          	endbr32 
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b62:	0f b6 10             	movzbl (%eax),%edx
  800b65:	84 d2                	test   %dl,%dl
  800b67:	74 09                	je     800b72 <strchr+0x1e>
		if (*s == c)
  800b69:	38 ca                	cmp    %cl,%dl
  800b6b:	74 0a                	je     800b77 <strchr+0x23>
	for (; *s; s++)
  800b6d:	83 c0 01             	add    $0x1,%eax
  800b70:	eb f0                	jmp    800b62 <strchr+0xe>
			return (char *) s;
	return 0;
  800b72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b77:	5d                   	pop    %ebp
  800b78:	c3                   	ret    

00800b79 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b79:	f3 0f 1e fb          	endbr32 
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b87:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b8a:	38 ca                	cmp    %cl,%dl
  800b8c:	74 09                	je     800b97 <strfind+0x1e>
  800b8e:	84 d2                	test   %dl,%dl
  800b90:	74 05                	je     800b97 <strfind+0x1e>
	for (; *s; s++)
  800b92:	83 c0 01             	add    $0x1,%eax
  800b95:	eb f0                	jmp    800b87 <strfind+0xe>
			break;
	return (char *) s;
}
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    

00800b99 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b99:	f3 0f 1e fb          	endbr32 
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	57                   	push   %edi
  800ba1:	56                   	push   %esi
  800ba2:	53                   	push   %ebx
  800ba3:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ba6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ba9:	85 c9                	test   %ecx,%ecx
  800bab:	74 31                	je     800bde <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bad:	89 f8                	mov    %edi,%eax
  800baf:	09 c8                	or     %ecx,%eax
  800bb1:	a8 03                	test   $0x3,%al
  800bb3:	75 23                	jne    800bd8 <memset+0x3f>
		c &= 0xFF;
  800bb5:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bb9:	89 d3                	mov    %edx,%ebx
  800bbb:	c1 e3 08             	shl    $0x8,%ebx
  800bbe:	89 d0                	mov    %edx,%eax
  800bc0:	c1 e0 18             	shl    $0x18,%eax
  800bc3:	89 d6                	mov    %edx,%esi
  800bc5:	c1 e6 10             	shl    $0x10,%esi
  800bc8:	09 f0                	or     %esi,%eax
  800bca:	09 c2                	or     %eax,%edx
  800bcc:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bce:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bd1:	89 d0                	mov    %edx,%eax
  800bd3:	fc                   	cld    
  800bd4:	f3 ab                	rep stos %eax,%es:(%edi)
  800bd6:	eb 06                	jmp    800bde <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdb:	fc                   	cld    
  800bdc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bde:	89 f8                	mov    %edi,%eax
  800be0:	5b                   	pop    %ebx
  800be1:	5e                   	pop    %esi
  800be2:	5f                   	pop    %edi
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800be5:	f3 0f 1e fb          	endbr32 
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	57                   	push   %edi
  800bed:	56                   	push   %esi
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bf7:	39 c6                	cmp    %eax,%esi
  800bf9:	73 32                	jae    800c2d <memmove+0x48>
  800bfb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bfe:	39 c2                	cmp    %eax,%edx
  800c00:	76 2b                	jbe    800c2d <memmove+0x48>
		s += n;
		d += n;
  800c02:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c05:	89 fe                	mov    %edi,%esi
  800c07:	09 ce                	or     %ecx,%esi
  800c09:	09 d6                	or     %edx,%esi
  800c0b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c11:	75 0e                	jne    800c21 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c13:	83 ef 04             	sub    $0x4,%edi
  800c16:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c19:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c1c:	fd                   	std    
  800c1d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c1f:	eb 09                	jmp    800c2a <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c21:	83 ef 01             	sub    $0x1,%edi
  800c24:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c27:	fd                   	std    
  800c28:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c2a:	fc                   	cld    
  800c2b:	eb 1a                	jmp    800c47 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c2d:	89 c2                	mov    %eax,%edx
  800c2f:	09 ca                	or     %ecx,%edx
  800c31:	09 f2                	or     %esi,%edx
  800c33:	f6 c2 03             	test   $0x3,%dl
  800c36:	75 0a                	jne    800c42 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c38:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c3b:	89 c7                	mov    %eax,%edi
  800c3d:	fc                   	cld    
  800c3e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c40:	eb 05                	jmp    800c47 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800c42:	89 c7                	mov    %eax,%edi
  800c44:	fc                   	cld    
  800c45:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c47:	5e                   	pop    %esi
  800c48:	5f                   	pop    %edi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c4b:	f3 0f 1e fb          	endbr32 
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c55:	ff 75 10             	pushl  0x10(%ebp)
  800c58:	ff 75 0c             	pushl  0xc(%ebp)
  800c5b:	ff 75 08             	pushl  0x8(%ebp)
  800c5e:	e8 82 ff ff ff       	call   800be5 <memmove>
}
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c65:	f3 0f 1e fb          	endbr32 
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	56                   	push   %esi
  800c6d:	53                   	push   %ebx
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c74:	89 c6                	mov    %eax,%esi
  800c76:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c79:	39 f0                	cmp    %esi,%eax
  800c7b:	74 1c                	je     800c99 <memcmp+0x34>
		if (*s1 != *s2)
  800c7d:	0f b6 08             	movzbl (%eax),%ecx
  800c80:	0f b6 1a             	movzbl (%edx),%ebx
  800c83:	38 d9                	cmp    %bl,%cl
  800c85:	75 08                	jne    800c8f <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c87:	83 c0 01             	add    $0x1,%eax
  800c8a:	83 c2 01             	add    $0x1,%edx
  800c8d:	eb ea                	jmp    800c79 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800c8f:	0f b6 c1             	movzbl %cl,%eax
  800c92:	0f b6 db             	movzbl %bl,%ebx
  800c95:	29 d8                	sub    %ebx,%eax
  800c97:	eb 05                	jmp    800c9e <memcmp+0x39>
	}

	return 0;
  800c99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9e:	5b                   	pop    %ebx
  800c9f:	5e                   	pop    %esi
  800ca0:	5d                   	pop    %ebp
  800ca1:	c3                   	ret    

00800ca2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ca2:	f3 0f 1e fb          	endbr32 
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800caf:	89 c2                	mov    %eax,%edx
  800cb1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cb4:	39 d0                	cmp    %edx,%eax
  800cb6:	73 09                	jae    800cc1 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cb8:	38 08                	cmp    %cl,(%eax)
  800cba:	74 05                	je     800cc1 <memfind+0x1f>
	for (; s < ends; s++)
  800cbc:	83 c0 01             	add    $0x1,%eax
  800cbf:	eb f3                	jmp    800cb4 <memfind+0x12>
			break;
	return (void *) s;
}
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cc3:	f3 0f 1e fb          	endbr32 
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	57                   	push   %edi
  800ccb:	56                   	push   %esi
  800ccc:	53                   	push   %ebx
  800ccd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cd3:	eb 03                	jmp    800cd8 <strtol+0x15>
		s++;
  800cd5:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cd8:	0f b6 01             	movzbl (%ecx),%eax
  800cdb:	3c 20                	cmp    $0x20,%al
  800cdd:	74 f6                	je     800cd5 <strtol+0x12>
  800cdf:	3c 09                	cmp    $0x9,%al
  800ce1:	74 f2                	je     800cd5 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ce3:	3c 2b                	cmp    $0x2b,%al
  800ce5:	74 2a                	je     800d11 <strtol+0x4e>
	int neg = 0;
  800ce7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cec:	3c 2d                	cmp    $0x2d,%al
  800cee:	74 2b                	je     800d1b <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cf0:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cf6:	75 0f                	jne    800d07 <strtol+0x44>
  800cf8:	80 39 30             	cmpb   $0x30,(%ecx)
  800cfb:	74 28                	je     800d25 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cfd:	85 db                	test   %ebx,%ebx
  800cff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d04:	0f 44 d8             	cmove  %eax,%ebx
  800d07:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d0f:	eb 46                	jmp    800d57 <strtol+0x94>
		s++;
  800d11:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d14:	bf 00 00 00 00       	mov    $0x0,%edi
  800d19:	eb d5                	jmp    800cf0 <strtol+0x2d>
		s++, neg = 1;
  800d1b:	83 c1 01             	add    $0x1,%ecx
  800d1e:	bf 01 00 00 00       	mov    $0x1,%edi
  800d23:	eb cb                	jmp    800cf0 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d25:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d29:	74 0e                	je     800d39 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d2b:	85 db                	test   %ebx,%ebx
  800d2d:	75 d8                	jne    800d07 <strtol+0x44>
		s++, base = 8;
  800d2f:	83 c1 01             	add    $0x1,%ecx
  800d32:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d37:	eb ce                	jmp    800d07 <strtol+0x44>
		s += 2, base = 16;
  800d39:	83 c1 02             	add    $0x2,%ecx
  800d3c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d41:	eb c4                	jmp    800d07 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800d43:	0f be d2             	movsbl %dl,%edx
  800d46:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d49:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d4c:	7d 3a                	jge    800d88 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d4e:	83 c1 01             	add    $0x1,%ecx
  800d51:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d55:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d57:	0f b6 11             	movzbl (%ecx),%edx
  800d5a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d5d:	89 f3                	mov    %esi,%ebx
  800d5f:	80 fb 09             	cmp    $0x9,%bl
  800d62:	76 df                	jbe    800d43 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800d64:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d67:	89 f3                	mov    %esi,%ebx
  800d69:	80 fb 19             	cmp    $0x19,%bl
  800d6c:	77 08                	ja     800d76 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d6e:	0f be d2             	movsbl %dl,%edx
  800d71:	83 ea 57             	sub    $0x57,%edx
  800d74:	eb d3                	jmp    800d49 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800d76:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d79:	89 f3                	mov    %esi,%ebx
  800d7b:	80 fb 19             	cmp    $0x19,%bl
  800d7e:	77 08                	ja     800d88 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d80:	0f be d2             	movsbl %dl,%edx
  800d83:	83 ea 37             	sub    $0x37,%edx
  800d86:	eb c1                	jmp    800d49 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d8c:	74 05                	je     800d93 <strtol+0xd0>
		*endptr = (char *) s;
  800d8e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d91:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d93:	89 c2                	mov    %eax,%edx
  800d95:	f7 da                	neg    %edx
  800d97:	85 ff                	test   %edi,%edi
  800d99:	0f 45 c2             	cmovne %edx,%eax
}
  800d9c:	5b                   	pop    %ebx
  800d9d:	5e                   	pop    %esi
  800d9e:	5f                   	pop    %edi
  800d9f:	5d                   	pop    %ebp
  800da0:	c3                   	ret    

00800da1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800da1:	f3 0f 1e fb          	endbr32 
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
  800da8:	57                   	push   %edi
  800da9:	56                   	push   %esi
  800daa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dab:	b8 00 00 00 00       	mov    $0x0,%eax
  800db0:	8b 55 08             	mov    0x8(%ebp),%edx
  800db3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db6:	89 c3                	mov    %eax,%ebx
  800db8:	89 c7                	mov    %eax,%edi
  800dba:	89 c6                	mov    %eax,%esi
  800dbc:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5f                   	pop    %edi
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <sys_cgetc>:

int
sys_cgetc(void)
{
  800dc3:	f3 0f 1e fb          	endbr32 
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	57                   	push   %edi
  800dcb:	56                   	push   %esi
  800dcc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dcd:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd2:	b8 01 00 00 00       	mov    $0x1,%eax
  800dd7:	89 d1                	mov    %edx,%ecx
  800dd9:	89 d3                	mov    %edx,%ebx
  800ddb:	89 d7                	mov    %edx,%edi
  800ddd:	89 d6                	mov    %edx,%esi
  800ddf:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800de6:	f3 0f 1e fb          	endbr32 
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	57                   	push   %edi
  800dee:	56                   	push   %esi
  800def:	53                   	push   %ebx
  800df0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfb:	b8 03 00 00 00       	mov    $0x3,%eax
  800e00:	89 cb                	mov    %ecx,%ebx
  800e02:	89 cf                	mov    %ecx,%edi
  800e04:	89 ce                	mov    %ecx,%esi
  800e06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e08:	85 c0                	test   %eax,%eax
  800e0a:	7f 08                	jg     800e14 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0f:	5b                   	pop    %ebx
  800e10:	5e                   	pop    %esi
  800e11:	5f                   	pop    %edi
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e14:	83 ec 0c             	sub    $0xc,%esp
  800e17:	50                   	push   %eax
  800e18:	6a 03                	push   $0x3
  800e1a:	68 5f 2f 80 00       	push   $0x802f5f
  800e1f:	6a 23                	push   $0x23
  800e21:	68 7c 2f 80 00       	push   $0x802f7c
  800e26:	e8 13 f5 ff ff       	call   80033e <_panic>

00800e2b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e2b:	f3 0f 1e fb          	endbr32 
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	57                   	push   %edi
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e35:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3a:	b8 02 00 00 00       	mov    $0x2,%eax
  800e3f:	89 d1                	mov    %edx,%ecx
  800e41:	89 d3                	mov    %edx,%ebx
  800e43:	89 d7                	mov    %edx,%edi
  800e45:	89 d6                	mov    %edx,%esi
  800e47:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e49:	5b                   	pop    %ebx
  800e4a:	5e                   	pop    %esi
  800e4b:	5f                   	pop    %edi
  800e4c:	5d                   	pop    %ebp
  800e4d:	c3                   	ret    

00800e4e <sys_yield>:

void
sys_yield(void)
{
  800e4e:	f3 0f 1e fb          	endbr32 
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	57                   	push   %edi
  800e56:	56                   	push   %esi
  800e57:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e58:	ba 00 00 00 00       	mov    $0x0,%edx
  800e5d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e62:	89 d1                	mov    %edx,%ecx
  800e64:	89 d3                	mov    %edx,%ebx
  800e66:	89 d7                	mov    %edx,%edi
  800e68:	89 d6                	mov    %edx,%esi
  800e6a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e6c:	5b                   	pop    %ebx
  800e6d:	5e                   	pop    %esi
  800e6e:	5f                   	pop    %edi
  800e6f:	5d                   	pop    %ebp
  800e70:	c3                   	ret    

00800e71 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e71:	f3 0f 1e fb          	endbr32 
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	57                   	push   %edi
  800e79:	56                   	push   %esi
  800e7a:	53                   	push   %ebx
  800e7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7e:	be 00 00 00 00       	mov    $0x0,%esi
  800e83:	8b 55 08             	mov    0x8(%ebp),%edx
  800e86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e89:	b8 04 00 00 00       	mov    $0x4,%eax
  800e8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e91:	89 f7                	mov    %esi,%edi
  800e93:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e95:	85 c0                	test   %eax,%eax
  800e97:	7f 08                	jg     800ea1 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9c:	5b                   	pop    %ebx
  800e9d:	5e                   	pop    %esi
  800e9e:	5f                   	pop    %edi
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea1:	83 ec 0c             	sub    $0xc,%esp
  800ea4:	50                   	push   %eax
  800ea5:	6a 04                	push   $0x4
  800ea7:	68 5f 2f 80 00       	push   $0x802f5f
  800eac:	6a 23                	push   $0x23
  800eae:	68 7c 2f 80 00       	push   $0x802f7c
  800eb3:	e8 86 f4 ff ff       	call   80033e <_panic>

00800eb8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800eb8:	f3 0f 1e fb          	endbr32 
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	57                   	push   %edi
  800ec0:	56                   	push   %esi
  800ec1:	53                   	push   %ebx
  800ec2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecb:	b8 05 00 00 00       	mov    $0x5,%eax
  800ed0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed6:	8b 75 18             	mov    0x18(%ebp),%esi
  800ed9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800edb:	85 c0                	test   %eax,%eax
  800edd:	7f 08                	jg     800ee7 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800edf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee2:	5b                   	pop    %ebx
  800ee3:	5e                   	pop    %esi
  800ee4:	5f                   	pop    %edi
  800ee5:	5d                   	pop    %ebp
  800ee6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee7:	83 ec 0c             	sub    $0xc,%esp
  800eea:	50                   	push   %eax
  800eeb:	6a 05                	push   $0x5
  800eed:	68 5f 2f 80 00       	push   $0x802f5f
  800ef2:	6a 23                	push   $0x23
  800ef4:	68 7c 2f 80 00       	push   $0x802f7c
  800ef9:	e8 40 f4 ff ff       	call   80033e <_panic>

00800efe <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800efe:	f3 0f 1e fb          	endbr32 
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	57                   	push   %edi
  800f06:	56                   	push   %esi
  800f07:	53                   	push   %ebx
  800f08:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f10:	8b 55 08             	mov    0x8(%ebp),%edx
  800f13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f16:	b8 06 00 00 00       	mov    $0x6,%eax
  800f1b:	89 df                	mov    %ebx,%edi
  800f1d:	89 de                	mov    %ebx,%esi
  800f1f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f21:	85 c0                	test   %eax,%eax
  800f23:	7f 08                	jg     800f2d <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f28:	5b                   	pop    %ebx
  800f29:	5e                   	pop    %esi
  800f2a:	5f                   	pop    %edi
  800f2b:	5d                   	pop    %ebp
  800f2c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2d:	83 ec 0c             	sub    $0xc,%esp
  800f30:	50                   	push   %eax
  800f31:	6a 06                	push   $0x6
  800f33:	68 5f 2f 80 00       	push   $0x802f5f
  800f38:	6a 23                	push   $0x23
  800f3a:	68 7c 2f 80 00       	push   $0x802f7c
  800f3f:	e8 fa f3 ff ff       	call   80033e <_panic>

00800f44 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f44:	f3 0f 1e fb          	endbr32 
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	57                   	push   %edi
  800f4c:	56                   	push   %esi
  800f4d:	53                   	push   %ebx
  800f4e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f51:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f56:	8b 55 08             	mov    0x8(%ebp),%edx
  800f59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5c:	b8 08 00 00 00       	mov    $0x8,%eax
  800f61:	89 df                	mov    %ebx,%edi
  800f63:	89 de                	mov    %ebx,%esi
  800f65:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f67:	85 c0                	test   %eax,%eax
  800f69:	7f 08                	jg     800f73 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f6e:	5b                   	pop    %ebx
  800f6f:	5e                   	pop    %esi
  800f70:	5f                   	pop    %edi
  800f71:	5d                   	pop    %ebp
  800f72:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f73:	83 ec 0c             	sub    $0xc,%esp
  800f76:	50                   	push   %eax
  800f77:	6a 08                	push   $0x8
  800f79:	68 5f 2f 80 00       	push   $0x802f5f
  800f7e:	6a 23                	push   $0x23
  800f80:	68 7c 2f 80 00       	push   $0x802f7c
  800f85:	e8 b4 f3 ff ff       	call   80033e <_panic>

00800f8a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f8a:	f3 0f 1e fb          	endbr32 
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	57                   	push   %edi
  800f92:	56                   	push   %esi
  800f93:	53                   	push   %ebx
  800f94:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f97:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa2:	b8 09 00 00 00       	mov    $0x9,%eax
  800fa7:	89 df                	mov    %ebx,%edi
  800fa9:	89 de                	mov    %ebx,%esi
  800fab:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fad:	85 c0                	test   %eax,%eax
  800faf:	7f 08                	jg     800fb9 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb4:	5b                   	pop    %ebx
  800fb5:	5e                   	pop    %esi
  800fb6:	5f                   	pop    %edi
  800fb7:	5d                   	pop    %ebp
  800fb8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb9:	83 ec 0c             	sub    $0xc,%esp
  800fbc:	50                   	push   %eax
  800fbd:	6a 09                	push   $0x9
  800fbf:	68 5f 2f 80 00       	push   $0x802f5f
  800fc4:	6a 23                	push   $0x23
  800fc6:	68 7c 2f 80 00       	push   $0x802f7c
  800fcb:	e8 6e f3 ff ff       	call   80033e <_panic>

00800fd0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fd0:	f3 0f 1e fb          	endbr32 
  800fd4:	55                   	push   %ebp
  800fd5:	89 e5                	mov    %esp,%ebp
  800fd7:	57                   	push   %edi
  800fd8:	56                   	push   %esi
  800fd9:	53                   	push   %ebx
  800fda:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fdd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fed:	89 df                	mov    %ebx,%edi
  800fef:	89 de                	mov    %ebx,%esi
  800ff1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff3:	85 c0                	test   %eax,%eax
  800ff5:	7f 08                	jg     800fff <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ff7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ffa:	5b                   	pop    %ebx
  800ffb:	5e                   	pop    %esi
  800ffc:	5f                   	pop    %edi
  800ffd:	5d                   	pop    %ebp
  800ffe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fff:	83 ec 0c             	sub    $0xc,%esp
  801002:	50                   	push   %eax
  801003:	6a 0a                	push   $0xa
  801005:	68 5f 2f 80 00       	push   $0x802f5f
  80100a:	6a 23                	push   $0x23
  80100c:	68 7c 2f 80 00       	push   $0x802f7c
  801011:	e8 28 f3 ff ff       	call   80033e <_panic>

00801016 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801016:	f3 0f 1e fb          	endbr32 
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	57                   	push   %edi
  80101e:	56                   	push   %esi
  80101f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801020:	8b 55 08             	mov    0x8(%ebp),%edx
  801023:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801026:	b8 0c 00 00 00       	mov    $0xc,%eax
  80102b:	be 00 00 00 00       	mov    $0x0,%esi
  801030:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801033:	8b 7d 14             	mov    0x14(%ebp),%edi
  801036:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801038:	5b                   	pop    %ebx
  801039:	5e                   	pop    %esi
  80103a:	5f                   	pop    %edi
  80103b:	5d                   	pop    %ebp
  80103c:	c3                   	ret    

0080103d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80103d:	f3 0f 1e fb          	endbr32 
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	57                   	push   %edi
  801045:	56                   	push   %esi
  801046:	53                   	push   %ebx
  801047:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80104a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80104f:	8b 55 08             	mov    0x8(%ebp),%edx
  801052:	b8 0d 00 00 00       	mov    $0xd,%eax
  801057:	89 cb                	mov    %ecx,%ebx
  801059:	89 cf                	mov    %ecx,%edi
  80105b:	89 ce                	mov    %ecx,%esi
  80105d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80105f:	85 c0                	test   %eax,%eax
  801061:	7f 08                	jg     80106b <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801063:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801066:	5b                   	pop    %ebx
  801067:	5e                   	pop    %esi
  801068:	5f                   	pop    %edi
  801069:	5d                   	pop    %ebp
  80106a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80106b:	83 ec 0c             	sub    $0xc,%esp
  80106e:	50                   	push   %eax
  80106f:	6a 0d                	push   $0xd
  801071:	68 5f 2f 80 00       	push   $0x802f5f
  801076:	6a 23                	push   $0x23
  801078:	68 7c 2f 80 00       	push   $0x802f7c
  80107d:	e8 bc f2 ff ff       	call   80033e <_panic>

00801082 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801082:	f3 0f 1e fb          	endbr32 
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	57                   	push   %edi
  80108a:	56                   	push   %esi
  80108b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80108c:	ba 00 00 00 00       	mov    $0x0,%edx
  801091:	b8 0e 00 00 00       	mov    $0xe,%eax
  801096:	89 d1                	mov    %edx,%ecx
  801098:	89 d3                	mov    %edx,%ebx
  80109a:	89 d7                	mov    %edx,%edi
  80109c:	89 d6                	mov    %edx,%esi
  80109e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010a0:	5b                   	pop    %ebx
  8010a1:	5e                   	pop    %esi
  8010a2:	5f                   	pop    %edi
  8010a3:	5d                   	pop    %ebp
  8010a4:	c3                   	ret    

008010a5 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  8010a5:	f3 0f 1e fb          	endbr32 
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
  8010ac:	57                   	push   %edi
  8010ad:	56                   	push   %esi
  8010ae:	53                   	push   %ebx
  8010af:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010bd:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010c2:	89 df                	mov    %ebx,%edi
  8010c4:	89 de                	mov    %ebx,%esi
  8010c6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010c8:	85 c0                	test   %eax,%eax
  8010ca:	7f 08                	jg     8010d4 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  8010cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010cf:	5b                   	pop    %ebx
  8010d0:	5e                   	pop    %esi
  8010d1:	5f                   	pop    %edi
  8010d2:	5d                   	pop    %ebp
  8010d3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d4:	83 ec 0c             	sub    $0xc,%esp
  8010d7:	50                   	push   %eax
  8010d8:	6a 0f                	push   $0xf
  8010da:	68 5f 2f 80 00       	push   $0x802f5f
  8010df:	6a 23                	push   $0x23
  8010e1:	68 7c 2f 80 00       	push   $0x802f7c
  8010e6:	e8 53 f2 ff ff       	call   80033e <_panic>

008010eb <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  8010eb:	f3 0f 1e fb          	endbr32 
  8010ef:	55                   	push   %ebp
  8010f0:	89 e5                	mov    %esp,%ebp
  8010f2:	57                   	push   %edi
  8010f3:	56                   	push   %esi
  8010f4:	53                   	push   %ebx
  8010f5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801100:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801103:	b8 10 00 00 00       	mov    $0x10,%eax
  801108:	89 df                	mov    %ebx,%edi
  80110a:	89 de                	mov    %ebx,%esi
  80110c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80110e:	85 c0                	test   %eax,%eax
  801110:	7f 08                	jg     80111a <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  801112:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801115:	5b                   	pop    %ebx
  801116:	5e                   	pop    %esi
  801117:	5f                   	pop    %edi
  801118:	5d                   	pop    %ebp
  801119:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80111a:	83 ec 0c             	sub    $0xc,%esp
  80111d:	50                   	push   %eax
  80111e:	6a 10                	push   $0x10
  801120:	68 5f 2f 80 00       	push   $0x802f5f
  801125:	6a 23                	push   $0x23
  801127:	68 7c 2f 80 00       	push   $0x802f7c
  80112c:	e8 0d f2 ff ff       	call   80033e <_panic>

00801131 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801131:	f3 0f 1e fb          	endbr32 
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	53                   	push   %ebx
  801139:	83 ec 04             	sub    $0x4,%esp
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80113f:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  801141:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801145:	74 74                	je     8011bb <pgfault+0x8a>
  801147:	89 d8                	mov    %ebx,%eax
  801149:	c1 e8 0c             	shr    $0xc,%eax
  80114c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801153:	f6 c4 08             	test   $0x8,%ah
  801156:	74 63                	je     8011bb <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  801158:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  80115e:	83 ec 0c             	sub    $0xc,%esp
  801161:	6a 05                	push   $0x5
  801163:	68 00 f0 7f 00       	push   $0x7ff000
  801168:	6a 00                	push   $0x0
  80116a:	53                   	push   %ebx
  80116b:	6a 00                	push   $0x0
  80116d:	e8 46 fd ff ff       	call   800eb8 <sys_page_map>
  801172:	83 c4 20             	add    $0x20,%esp
  801175:	85 c0                	test   %eax,%eax
  801177:	78 59                	js     8011d2 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  801179:	83 ec 04             	sub    $0x4,%esp
  80117c:	6a 07                	push   $0x7
  80117e:	53                   	push   %ebx
  80117f:	6a 00                	push   $0x0
  801181:	e8 eb fc ff ff       	call   800e71 <sys_page_alloc>
  801186:	83 c4 10             	add    $0x10,%esp
  801189:	85 c0                	test   %eax,%eax
  80118b:	78 5a                	js     8011e7 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  80118d:	83 ec 04             	sub    $0x4,%esp
  801190:	68 00 10 00 00       	push   $0x1000
  801195:	68 00 f0 7f 00       	push   $0x7ff000
  80119a:	53                   	push   %ebx
  80119b:	e8 45 fa ff ff       	call   800be5 <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  8011a0:	83 c4 08             	add    $0x8,%esp
  8011a3:	68 00 f0 7f 00       	push   $0x7ff000
  8011a8:	6a 00                	push   $0x0
  8011aa:	e8 4f fd ff ff       	call   800efe <sys_page_unmap>
  8011af:	83 c4 10             	add    $0x10,%esp
  8011b2:	85 c0                	test   %eax,%eax
  8011b4:	78 46                	js     8011fc <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  8011b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  8011bb:	83 ec 04             	sub    $0x4,%esp
  8011be:	68 8a 2f 80 00       	push   $0x802f8a
  8011c3:	68 d3 00 00 00       	push   $0xd3
  8011c8:	68 a6 2f 80 00       	push   $0x802fa6
  8011cd:	e8 6c f1 ff ff       	call   80033e <_panic>
		panic("pgfault: %e\n", r);
  8011d2:	50                   	push   %eax
  8011d3:	68 b1 2f 80 00       	push   $0x802fb1
  8011d8:	68 df 00 00 00       	push   $0xdf
  8011dd:	68 a6 2f 80 00       	push   $0x802fa6
  8011e2:	e8 57 f1 ff ff       	call   80033e <_panic>
		panic("pgfault: %e\n", r);
  8011e7:	50                   	push   %eax
  8011e8:	68 b1 2f 80 00       	push   $0x802fb1
  8011ed:	68 e3 00 00 00       	push   $0xe3
  8011f2:	68 a6 2f 80 00       	push   $0x802fa6
  8011f7:	e8 42 f1 ff ff       	call   80033e <_panic>
		panic("pgfault: %e\n", r);
  8011fc:	50                   	push   %eax
  8011fd:	68 b1 2f 80 00       	push   $0x802fb1
  801202:	68 e9 00 00 00       	push   $0xe9
  801207:	68 a6 2f 80 00       	push   $0x802fa6
  80120c:	e8 2d f1 ff ff       	call   80033e <_panic>

00801211 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801211:	f3 0f 1e fb          	endbr32 
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	57                   	push   %edi
  801219:	56                   	push   %esi
  80121a:	53                   	push   %ebx
  80121b:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  80121e:	68 31 11 80 00       	push   $0x801131
  801223:	e8 57 14 00 00       	call   80267f <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801228:	b8 07 00 00 00       	mov    $0x7,%eax
  80122d:	cd 30                	int    $0x30
  80122f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  801232:	83 c4 10             	add    $0x10,%esp
  801235:	85 c0                	test   %eax,%eax
  801237:	78 2d                	js     801266 <fork+0x55>
  801239:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80123b:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801240:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801244:	0f 85 9b 00 00 00    	jne    8012e5 <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  80124a:	e8 dc fb ff ff       	call   800e2b <sys_getenvid>
  80124f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801254:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801257:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80125c:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801261:	e9 71 01 00 00       	jmp    8013d7 <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  801266:	50                   	push   %eax
  801267:	68 be 2f 80 00       	push   $0x802fbe
  80126c:	68 2a 01 00 00       	push   $0x12a
  801271:	68 a6 2f 80 00       	push   $0x802fa6
  801276:	e8 c3 f0 ff ff       	call   80033e <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  80127b:	c1 e6 0c             	shl    $0xc,%esi
  80127e:	83 ec 0c             	sub    $0xc,%esp
  801281:	68 07 0e 00 00       	push   $0xe07
  801286:	56                   	push   %esi
  801287:	57                   	push   %edi
  801288:	56                   	push   %esi
  801289:	6a 00                	push   $0x0
  80128b:	e8 28 fc ff ff       	call   800eb8 <sys_page_map>
  801290:	83 c4 20             	add    $0x20,%esp
  801293:	eb 3e                	jmp    8012d3 <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801295:	c1 e6 0c             	shl    $0xc,%esi
  801298:	83 ec 0c             	sub    $0xc,%esp
  80129b:	68 05 08 00 00       	push   $0x805
  8012a0:	56                   	push   %esi
  8012a1:	57                   	push   %edi
  8012a2:	56                   	push   %esi
  8012a3:	6a 00                	push   $0x0
  8012a5:	e8 0e fc ff ff       	call   800eb8 <sys_page_map>
  8012aa:	83 c4 20             	add    $0x20,%esp
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	0f 88 bc 00 00 00    	js     801371 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  8012b5:	83 ec 0c             	sub    $0xc,%esp
  8012b8:	68 05 08 00 00       	push   $0x805
  8012bd:	56                   	push   %esi
  8012be:	6a 00                	push   $0x0
  8012c0:	56                   	push   %esi
  8012c1:	6a 00                	push   $0x0
  8012c3:	e8 f0 fb ff ff       	call   800eb8 <sys_page_map>
  8012c8:	83 c4 20             	add    $0x20,%esp
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	0f 88 b3 00 00 00    	js     801386 <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8012d3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012d9:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8012df:	0f 84 b6 00 00 00    	je     80139b <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  8012e5:	89 d8                	mov    %ebx,%eax
  8012e7:	c1 e8 16             	shr    $0x16,%eax
  8012ea:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012f1:	a8 01                	test   $0x1,%al
  8012f3:	74 de                	je     8012d3 <fork+0xc2>
  8012f5:	89 de                	mov    %ebx,%esi
  8012f7:	c1 ee 0c             	shr    $0xc,%esi
  8012fa:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801301:	a8 01                	test   $0x1,%al
  801303:	74 ce                	je     8012d3 <fork+0xc2>
  801305:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80130c:	a8 04                	test   $0x4,%al
  80130e:	74 c3                	je     8012d3 <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  801310:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801317:	f6 c4 04             	test   $0x4,%ah
  80131a:	0f 85 5b ff ff ff    	jne    80127b <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  801320:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801327:	a8 02                	test   $0x2,%al
  801329:	0f 85 66 ff ff ff    	jne    801295 <fork+0x84>
  80132f:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801336:	f6 c4 08             	test   $0x8,%ah
  801339:	0f 85 56 ff ff ff    	jne    801295 <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  80133f:	c1 e6 0c             	shl    $0xc,%esi
  801342:	83 ec 0c             	sub    $0xc,%esp
  801345:	6a 05                	push   $0x5
  801347:	56                   	push   %esi
  801348:	57                   	push   %edi
  801349:	56                   	push   %esi
  80134a:	6a 00                	push   $0x0
  80134c:	e8 67 fb ff ff       	call   800eb8 <sys_page_map>
  801351:	83 c4 20             	add    $0x20,%esp
  801354:	85 c0                	test   %eax,%eax
  801356:	0f 89 77 ff ff ff    	jns    8012d3 <fork+0xc2>
		panic("duppage: %e\n", r);
  80135c:	50                   	push   %eax
  80135d:	68 ce 2f 80 00       	push   $0x802fce
  801362:	68 0c 01 00 00       	push   $0x10c
  801367:	68 a6 2f 80 00       	push   $0x802fa6
  80136c:	e8 cd ef ff ff       	call   80033e <_panic>
			panic("duppage: %e\n", r);
  801371:	50                   	push   %eax
  801372:	68 ce 2f 80 00       	push   $0x802fce
  801377:	68 05 01 00 00       	push   $0x105
  80137c:	68 a6 2f 80 00       	push   $0x802fa6
  801381:	e8 b8 ef ff ff       	call   80033e <_panic>
			panic("duppage: %e\n", r);
  801386:	50                   	push   %eax
  801387:	68 ce 2f 80 00       	push   $0x802fce
  80138c:	68 09 01 00 00       	push   $0x109
  801391:	68 a6 2f 80 00       	push   $0x802fa6
  801396:	e8 a3 ef ff ff       	call   80033e <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  80139b:	83 ec 04             	sub    $0x4,%esp
  80139e:	6a 07                	push   $0x7
  8013a0:	68 00 f0 bf ee       	push   $0xeebff000
  8013a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013a8:	e8 c4 fa ff ff       	call   800e71 <sys_page_alloc>
  8013ad:	83 c4 10             	add    $0x10,%esp
  8013b0:	85 c0                	test   %eax,%eax
  8013b2:	78 2e                	js     8013e2 <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8013b4:	83 ec 08             	sub    $0x8,%esp
  8013b7:	68 f2 26 80 00       	push   $0x8026f2
  8013bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8013bf:	57                   	push   %edi
  8013c0:	e8 0b fc ff ff       	call   800fd0 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8013c5:	83 c4 08             	add    $0x8,%esp
  8013c8:	6a 02                	push   $0x2
  8013ca:	57                   	push   %edi
  8013cb:	e8 74 fb ff ff       	call   800f44 <sys_env_set_status>
  8013d0:	83 c4 10             	add    $0x10,%esp
  8013d3:	85 c0                	test   %eax,%eax
  8013d5:	78 20                	js     8013f7 <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8013d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013dd:	5b                   	pop    %ebx
  8013de:	5e                   	pop    %esi
  8013df:	5f                   	pop    %edi
  8013e0:	5d                   	pop    %ebp
  8013e1:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8013e2:	50                   	push   %eax
  8013e3:	68 db 2f 80 00       	push   $0x802fdb
  8013e8:	68 3e 01 00 00       	push   $0x13e
  8013ed:	68 a6 2f 80 00       	push   $0x802fa6
  8013f2:	e8 47 ef ff ff       	call   80033e <_panic>
		panic("sys_env_set_status: %e", r);
  8013f7:	50                   	push   %eax
  8013f8:	68 ee 2f 80 00       	push   $0x802fee
  8013fd:	68 43 01 00 00       	push   $0x143
  801402:	68 a6 2f 80 00       	push   $0x802fa6
  801407:	e8 32 ef ff ff       	call   80033e <_panic>

0080140c <sfork>:

// Challenge!
int
sfork(void)
{
  80140c:	f3 0f 1e fb          	endbr32 
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801416:	68 05 30 80 00       	push   $0x803005
  80141b:	68 4c 01 00 00       	push   $0x14c
  801420:	68 a6 2f 80 00       	push   $0x802fa6
  801425:	e8 14 ef ff ff       	call   80033e <_panic>

0080142a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80142a:	f3 0f 1e fb          	endbr32 
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	05 00 00 00 30       	add    $0x30000000,%eax
  801439:	c1 e8 0c             	shr    $0xc,%eax
}
  80143c:	5d                   	pop    %ebp
  80143d:	c3                   	ret    

0080143e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80143e:	f3 0f 1e fb          	endbr32 
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80144d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801452:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801457:	5d                   	pop    %ebp
  801458:	c3                   	ret    

00801459 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801459:	f3 0f 1e fb          	endbr32 
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801465:	89 c2                	mov    %eax,%edx
  801467:	c1 ea 16             	shr    $0x16,%edx
  80146a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801471:	f6 c2 01             	test   $0x1,%dl
  801474:	74 2d                	je     8014a3 <fd_alloc+0x4a>
  801476:	89 c2                	mov    %eax,%edx
  801478:	c1 ea 0c             	shr    $0xc,%edx
  80147b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801482:	f6 c2 01             	test   $0x1,%dl
  801485:	74 1c                	je     8014a3 <fd_alloc+0x4a>
  801487:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80148c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801491:	75 d2                	jne    801465 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80149c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8014a1:	eb 0a                	jmp    8014ad <fd_alloc+0x54>
			*fd_store = fd;
  8014a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014a6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ad:	5d                   	pop    %ebp
  8014ae:	c3                   	ret    

008014af <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014af:	f3 0f 1e fb          	endbr32 
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014b9:	83 f8 1f             	cmp    $0x1f,%eax
  8014bc:	77 30                	ja     8014ee <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014be:	c1 e0 0c             	shl    $0xc,%eax
  8014c1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014c6:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8014cc:	f6 c2 01             	test   $0x1,%dl
  8014cf:	74 24                	je     8014f5 <fd_lookup+0x46>
  8014d1:	89 c2                	mov    %eax,%edx
  8014d3:	c1 ea 0c             	shr    $0xc,%edx
  8014d6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014dd:	f6 c2 01             	test   $0x1,%dl
  8014e0:	74 1a                	je     8014fc <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e5:	89 02                	mov    %eax,(%edx)
	return 0;
  8014e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ec:	5d                   	pop    %ebp
  8014ed:	c3                   	ret    
		return -E_INVAL;
  8014ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f3:	eb f7                	jmp    8014ec <fd_lookup+0x3d>
		return -E_INVAL;
  8014f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014fa:	eb f0                	jmp    8014ec <fd_lookup+0x3d>
  8014fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801501:	eb e9                	jmp    8014ec <fd_lookup+0x3d>

00801503 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801503:	f3 0f 1e fb          	endbr32 
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	83 ec 08             	sub    $0x8,%esp
  80150d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801510:	ba 00 00 00 00       	mov    $0x0,%edx
  801515:	b8 08 40 80 00       	mov    $0x804008,%eax
		if (devtab[i]->dev_id == dev_id) {
  80151a:	39 08                	cmp    %ecx,(%eax)
  80151c:	74 38                	je     801556 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80151e:	83 c2 01             	add    $0x1,%edx
  801521:	8b 04 95 98 30 80 00 	mov    0x803098(,%edx,4),%eax
  801528:	85 c0                	test   %eax,%eax
  80152a:	75 ee                	jne    80151a <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80152c:	a1 08 50 80 00       	mov    0x805008,%eax
  801531:	8b 40 48             	mov    0x48(%eax),%eax
  801534:	83 ec 04             	sub    $0x4,%esp
  801537:	51                   	push   %ecx
  801538:	50                   	push   %eax
  801539:	68 1c 30 80 00       	push   $0x80301c
  80153e:	e8 e2 ee ff ff       	call   800425 <cprintf>
	*dev = 0;
  801543:	8b 45 0c             	mov    0xc(%ebp),%eax
  801546:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80154c:	83 c4 10             	add    $0x10,%esp
  80154f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801554:	c9                   	leave  
  801555:	c3                   	ret    
			*dev = devtab[i];
  801556:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801559:	89 01                	mov    %eax,(%ecx)
			return 0;
  80155b:	b8 00 00 00 00       	mov    $0x0,%eax
  801560:	eb f2                	jmp    801554 <dev_lookup+0x51>

00801562 <fd_close>:
{
  801562:	f3 0f 1e fb          	endbr32 
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	57                   	push   %edi
  80156a:	56                   	push   %esi
  80156b:	53                   	push   %ebx
  80156c:	83 ec 24             	sub    $0x24,%esp
  80156f:	8b 75 08             	mov    0x8(%ebp),%esi
  801572:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801575:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801578:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801579:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80157f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801582:	50                   	push   %eax
  801583:	e8 27 ff ff ff       	call   8014af <fd_lookup>
  801588:	89 c3                	mov    %eax,%ebx
  80158a:	83 c4 10             	add    $0x10,%esp
  80158d:	85 c0                	test   %eax,%eax
  80158f:	78 05                	js     801596 <fd_close+0x34>
	    || fd != fd2)
  801591:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801594:	74 16                	je     8015ac <fd_close+0x4a>
		return (must_exist ? r : 0);
  801596:	89 f8                	mov    %edi,%eax
  801598:	84 c0                	test   %al,%al
  80159a:	b8 00 00 00 00       	mov    $0x0,%eax
  80159f:	0f 44 d8             	cmove  %eax,%ebx
}
  8015a2:	89 d8                	mov    %ebx,%eax
  8015a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015a7:	5b                   	pop    %ebx
  8015a8:	5e                   	pop    %esi
  8015a9:	5f                   	pop    %edi
  8015aa:	5d                   	pop    %ebp
  8015ab:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015ac:	83 ec 08             	sub    $0x8,%esp
  8015af:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015b2:	50                   	push   %eax
  8015b3:	ff 36                	pushl  (%esi)
  8015b5:	e8 49 ff ff ff       	call   801503 <dev_lookup>
  8015ba:	89 c3                	mov    %eax,%ebx
  8015bc:	83 c4 10             	add    $0x10,%esp
  8015bf:	85 c0                	test   %eax,%eax
  8015c1:	78 1a                	js     8015dd <fd_close+0x7b>
		if (dev->dev_close)
  8015c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015c6:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8015c9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8015ce:	85 c0                	test   %eax,%eax
  8015d0:	74 0b                	je     8015dd <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8015d2:	83 ec 0c             	sub    $0xc,%esp
  8015d5:	56                   	push   %esi
  8015d6:	ff d0                	call   *%eax
  8015d8:	89 c3                	mov    %eax,%ebx
  8015da:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8015dd:	83 ec 08             	sub    $0x8,%esp
  8015e0:	56                   	push   %esi
  8015e1:	6a 00                	push   $0x0
  8015e3:	e8 16 f9 ff ff       	call   800efe <sys_page_unmap>
	return r;
  8015e8:	83 c4 10             	add    $0x10,%esp
  8015eb:	eb b5                	jmp    8015a2 <fd_close+0x40>

008015ed <close>:

int
close(int fdnum)
{
  8015ed:	f3 0f 1e fb          	endbr32 
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
  8015f4:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fa:	50                   	push   %eax
  8015fb:	ff 75 08             	pushl  0x8(%ebp)
  8015fe:	e8 ac fe ff ff       	call   8014af <fd_lookup>
  801603:	83 c4 10             	add    $0x10,%esp
  801606:	85 c0                	test   %eax,%eax
  801608:	79 02                	jns    80160c <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    
		return fd_close(fd, 1);
  80160c:	83 ec 08             	sub    $0x8,%esp
  80160f:	6a 01                	push   $0x1
  801611:	ff 75 f4             	pushl  -0xc(%ebp)
  801614:	e8 49 ff ff ff       	call   801562 <fd_close>
  801619:	83 c4 10             	add    $0x10,%esp
  80161c:	eb ec                	jmp    80160a <close+0x1d>

0080161e <close_all>:

void
close_all(void)
{
  80161e:	f3 0f 1e fb          	endbr32 
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	53                   	push   %ebx
  801626:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801629:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80162e:	83 ec 0c             	sub    $0xc,%esp
  801631:	53                   	push   %ebx
  801632:	e8 b6 ff ff ff       	call   8015ed <close>
	for (i = 0; i < MAXFD; i++)
  801637:	83 c3 01             	add    $0x1,%ebx
  80163a:	83 c4 10             	add    $0x10,%esp
  80163d:	83 fb 20             	cmp    $0x20,%ebx
  801640:	75 ec                	jne    80162e <close_all+0x10>
}
  801642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801647:	f3 0f 1e fb          	endbr32 
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
  80164e:	57                   	push   %edi
  80164f:	56                   	push   %esi
  801650:	53                   	push   %ebx
  801651:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801654:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801657:	50                   	push   %eax
  801658:	ff 75 08             	pushl  0x8(%ebp)
  80165b:	e8 4f fe ff ff       	call   8014af <fd_lookup>
  801660:	89 c3                	mov    %eax,%ebx
  801662:	83 c4 10             	add    $0x10,%esp
  801665:	85 c0                	test   %eax,%eax
  801667:	0f 88 81 00 00 00    	js     8016ee <dup+0xa7>
		return r;
	close(newfdnum);
  80166d:	83 ec 0c             	sub    $0xc,%esp
  801670:	ff 75 0c             	pushl  0xc(%ebp)
  801673:	e8 75 ff ff ff       	call   8015ed <close>

	newfd = INDEX2FD(newfdnum);
  801678:	8b 75 0c             	mov    0xc(%ebp),%esi
  80167b:	c1 e6 0c             	shl    $0xc,%esi
  80167e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801684:	83 c4 04             	add    $0x4,%esp
  801687:	ff 75 e4             	pushl  -0x1c(%ebp)
  80168a:	e8 af fd ff ff       	call   80143e <fd2data>
  80168f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801691:	89 34 24             	mov    %esi,(%esp)
  801694:	e8 a5 fd ff ff       	call   80143e <fd2data>
  801699:	83 c4 10             	add    $0x10,%esp
  80169c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80169e:	89 d8                	mov    %ebx,%eax
  8016a0:	c1 e8 16             	shr    $0x16,%eax
  8016a3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016aa:	a8 01                	test   $0x1,%al
  8016ac:	74 11                	je     8016bf <dup+0x78>
  8016ae:	89 d8                	mov    %ebx,%eax
  8016b0:	c1 e8 0c             	shr    $0xc,%eax
  8016b3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016ba:	f6 c2 01             	test   $0x1,%dl
  8016bd:	75 39                	jne    8016f8 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016c2:	89 d0                	mov    %edx,%eax
  8016c4:	c1 e8 0c             	shr    $0xc,%eax
  8016c7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016ce:	83 ec 0c             	sub    $0xc,%esp
  8016d1:	25 07 0e 00 00       	and    $0xe07,%eax
  8016d6:	50                   	push   %eax
  8016d7:	56                   	push   %esi
  8016d8:	6a 00                	push   $0x0
  8016da:	52                   	push   %edx
  8016db:	6a 00                	push   $0x0
  8016dd:	e8 d6 f7 ff ff       	call   800eb8 <sys_page_map>
  8016e2:	89 c3                	mov    %eax,%ebx
  8016e4:	83 c4 20             	add    $0x20,%esp
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	78 31                	js     80171c <dup+0xd5>
		goto err;

	return newfdnum;
  8016eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8016ee:	89 d8                	mov    %ebx,%eax
  8016f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f3:	5b                   	pop    %ebx
  8016f4:	5e                   	pop    %esi
  8016f5:	5f                   	pop    %edi
  8016f6:	5d                   	pop    %ebp
  8016f7:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016f8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016ff:	83 ec 0c             	sub    $0xc,%esp
  801702:	25 07 0e 00 00       	and    $0xe07,%eax
  801707:	50                   	push   %eax
  801708:	57                   	push   %edi
  801709:	6a 00                	push   $0x0
  80170b:	53                   	push   %ebx
  80170c:	6a 00                	push   $0x0
  80170e:	e8 a5 f7 ff ff       	call   800eb8 <sys_page_map>
  801713:	89 c3                	mov    %eax,%ebx
  801715:	83 c4 20             	add    $0x20,%esp
  801718:	85 c0                	test   %eax,%eax
  80171a:	79 a3                	jns    8016bf <dup+0x78>
	sys_page_unmap(0, newfd);
  80171c:	83 ec 08             	sub    $0x8,%esp
  80171f:	56                   	push   %esi
  801720:	6a 00                	push   $0x0
  801722:	e8 d7 f7 ff ff       	call   800efe <sys_page_unmap>
	sys_page_unmap(0, nva);
  801727:	83 c4 08             	add    $0x8,%esp
  80172a:	57                   	push   %edi
  80172b:	6a 00                	push   $0x0
  80172d:	e8 cc f7 ff ff       	call   800efe <sys_page_unmap>
	return r;
  801732:	83 c4 10             	add    $0x10,%esp
  801735:	eb b7                	jmp    8016ee <dup+0xa7>

00801737 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801737:	f3 0f 1e fb          	endbr32 
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	53                   	push   %ebx
  80173f:	83 ec 1c             	sub    $0x1c,%esp
  801742:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801745:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801748:	50                   	push   %eax
  801749:	53                   	push   %ebx
  80174a:	e8 60 fd ff ff       	call   8014af <fd_lookup>
  80174f:	83 c4 10             	add    $0x10,%esp
  801752:	85 c0                	test   %eax,%eax
  801754:	78 3f                	js     801795 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801756:	83 ec 08             	sub    $0x8,%esp
  801759:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80175c:	50                   	push   %eax
  80175d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801760:	ff 30                	pushl  (%eax)
  801762:	e8 9c fd ff ff       	call   801503 <dev_lookup>
  801767:	83 c4 10             	add    $0x10,%esp
  80176a:	85 c0                	test   %eax,%eax
  80176c:	78 27                	js     801795 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80176e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801771:	8b 42 08             	mov    0x8(%edx),%eax
  801774:	83 e0 03             	and    $0x3,%eax
  801777:	83 f8 01             	cmp    $0x1,%eax
  80177a:	74 1e                	je     80179a <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80177c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177f:	8b 40 08             	mov    0x8(%eax),%eax
  801782:	85 c0                	test   %eax,%eax
  801784:	74 35                	je     8017bb <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801786:	83 ec 04             	sub    $0x4,%esp
  801789:	ff 75 10             	pushl  0x10(%ebp)
  80178c:	ff 75 0c             	pushl  0xc(%ebp)
  80178f:	52                   	push   %edx
  801790:	ff d0                	call   *%eax
  801792:	83 c4 10             	add    $0x10,%esp
}
  801795:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801798:	c9                   	leave  
  801799:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80179a:	a1 08 50 80 00       	mov    0x805008,%eax
  80179f:	8b 40 48             	mov    0x48(%eax),%eax
  8017a2:	83 ec 04             	sub    $0x4,%esp
  8017a5:	53                   	push   %ebx
  8017a6:	50                   	push   %eax
  8017a7:	68 5d 30 80 00       	push   $0x80305d
  8017ac:	e8 74 ec ff ff       	call   800425 <cprintf>
		return -E_INVAL;
  8017b1:	83 c4 10             	add    $0x10,%esp
  8017b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017b9:	eb da                	jmp    801795 <read+0x5e>
		return -E_NOT_SUPP;
  8017bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017c0:	eb d3                	jmp    801795 <read+0x5e>

008017c2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017c2:	f3 0f 1e fb          	endbr32 
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
  8017c9:	57                   	push   %edi
  8017ca:	56                   	push   %esi
  8017cb:	53                   	push   %ebx
  8017cc:	83 ec 0c             	sub    $0xc,%esp
  8017cf:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017d2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017da:	eb 02                	jmp    8017de <readn+0x1c>
  8017dc:	01 c3                	add    %eax,%ebx
  8017de:	39 f3                	cmp    %esi,%ebx
  8017e0:	73 21                	jae    801803 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017e2:	83 ec 04             	sub    $0x4,%esp
  8017e5:	89 f0                	mov    %esi,%eax
  8017e7:	29 d8                	sub    %ebx,%eax
  8017e9:	50                   	push   %eax
  8017ea:	89 d8                	mov    %ebx,%eax
  8017ec:	03 45 0c             	add    0xc(%ebp),%eax
  8017ef:	50                   	push   %eax
  8017f0:	57                   	push   %edi
  8017f1:	e8 41 ff ff ff       	call   801737 <read>
		if (m < 0)
  8017f6:	83 c4 10             	add    $0x10,%esp
  8017f9:	85 c0                	test   %eax,%eax
  8017fb:	78 04                	js     801801 <readn+0x3f>
			return m;
		if (m == 0)
  8017fd:	75 dd                	jne    8017dc <readn+0x1a>
  8017ff:	eb 02                	jmp    801803 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801801:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801803:	89 d8                	mov    %ebx,%eax
  801805:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801808:	5b                   	pop    %ebx
  801809:	5e                   	pop    %esi
  80180a:	5f                   	pop    %edi
  80180b:	5d                   	pop    %ebp
  80180c:	c3                   	ret    

0080180d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80180d:	f3 0f 1e fb          	endbr32 
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	53                   	push   %ebx
  801815:	83 ec 1c             	sub    $0x1c,%esp
  801818:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80181b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80181e:	50                   	push   %eax
  80181f:	53                   	push   %ebx
  801820:	e8 8a fc ff ff       	call   8014af <fd_lookup>
  801825:	83 c4 10             	add    $0x10,%esp
  801828:	85 c0                	test   %eax,%eax
  80182a:	78 3a                	js     801866 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80182c:	83 ec 08             	sub    $0x8,%esp
  80182f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801832:	50                   	push   %eax
  801833:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801836:	ff 30                	pushl  (%eax)
  801838:	e8 c6 fc ff ff       	call   801503 <dev_lookup>
  80183d:	83 c4 10             	add    $0x10,%esp
  801840:	85 c0                	test   %eax,%eax
  801842:	78 22                	js     801866 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801844:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801847:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80184b:	74 1e                	je     80186b <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80184d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801850:	8b 52 0c             	mov    0xc(%edx),%edx
  801853:	85 d2                	test   %edx,%edx
  801855:	74 35                	je     80188c <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801857:	83 ec 04             	sub    $0x4,%esp
  80185a:	ff 75 10             	pushl  0x10(%ebp)
  80185d:	ff 75 0c             	pushl  0xc(%ebp)
  801860:	50                   	push   %eax
  801861:	ff d2                	call   *%edx
  801863:	83 c4 10             	add    $0x10,%esp
}
  801866:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801869:	c9                   	leave  
  80186a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80186b:	a1 08 50 80 00       	mov    0x805008,%eax
  801870:	8b 40 48             	mov    0x48(%eax),%eax
  801873:	83 ec 04             	sub    $0x4,%esp
  801876:	53                   	push   %ebx
  801877:	50                   	push   %eax
  801878:	68 79 30 80 00       	push   $0x803079
  80187d:	e8 a3 eb ff ff       	call   800425 <cprintf>
		return -E_INVAL;
  801882:	83 c4 10             	add    $0x10,%esp
  801885:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80188a:	eb da                	jmp    801866 <write+0x59>
		return -E_NOT_SUPP;
  80188c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801891:	eb d3                	jmp    801866 <write+0x59>

00801893 <seek>:

int
seek(int fdnum, off_t offset)
{
  801893:	f3 0f 1e fb          	endbr32 
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80189d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a0:	50                   	push   %eax
  8018a1:	ff 75 08             	pushl  0x8(%ebp)
  8018a4:	e8 06 fc ff ff       	call   8014af <fd_lookup>
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	78 0e                	js     8018be <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8018b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018c0:	f3 0f 1e fb          	endbr32 
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	53                   	push   %ebx
  8018c8:	83 ec 1c             	sub    $0x1c,%esp
  8018cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018d1:	50                   	push   %eax
  8018d2:	53                   	push   %ebx
  8018d3:	e8 d7 fb ff ff       	call   8014af <fd_lookup>
  8018d8:	83 c4 10             	add    $0x10,%esp
  8018db:	85 c0                	test   %eax,%eax
  8018dd:	78 37                	js     801916 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018df:	83 ec 08             	sub    $0x8,%esp
  8018e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e5:	50                   	push   %eax
  8018e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e9:	ff 30                	pushl  (%eax)
  8018eb:	e8 13 fc ff ff       	call   801503 <dev_lookup>
  8018f0:	83 c4 10             	add    $0x10,%esp
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	78 1f                	js     801916 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018fe:	74 1b                	je     80191b <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801900:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801903:	8b 52 18             	mov    0x18(%edx),%edx
  801906:	85 d2                	test   %edx,%edx
  801908:	74 32                	je     80193c <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80190a:	83 ec 08             	sub    $0x8,%esp
  80190d:	ff 75 0c             	pushl  0xc(%ebp)
  801910:	50                   	push   %eax
  801911:	ff d2                	call   *%edx
  801913:	83 c4 10             	add    $0x10,%esp
}
  801916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801919:	c9                   	leave  
  80191a:	c3                   	ret    
			thisenv->env_id, fdnum);
  80191b:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801920:	8b 40 48             	mov    0x48(%eax),%eax
  801923:	83 ec 04             	sub    $0x4,%esp
  801926:	53                   	push   %ebx
  801927:	50                   	push   %eax
  801928:	68 3c 30 80 00       	push   $0x80303c
  80192d:	e8 f3 ea ff ff       	call   800425 <cprintf>
		return -E_INVAL;
  801932:	83 c4 10             	add    $0x10,%esp
  801935:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80193a:	eb da                	jmp    801916 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80193c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801941:	eb d3                	jmp    801916 <ftruncate+0x56>

00801943 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801943:	f3 0f 1e fb          	endbr32 
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	53                   	push   %ebx
  80194b:	83 ec 1c             	sub    $0x1c,%esp
  80194e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801951:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801954:	50                   	push   %eax
  801955:	ff 75 08             	pushl  0x8(%ebp)
  801958:	e8 52 fb ff ff       	call   8014af <fd_lookup>
  80195d:	83 c4 10             	add    $0x10,%esp
  801960:	85 c0                	test   %eax,%eax
  801962:	78 4b                	js     8019af <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801964:	83 ec 08             	sub    $0x8,%esp
  801967:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80196a:	50                   	push   %eax
  80196b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196e:	ff 30                	pushl  (%eax)
  801970:	e8 8e fb ff ff       	call   801503 <dev_lookup>
  801975:	83 c4 10             	add    $0x10,%esp
  801978:	85 c0                	test   %eax,%eax
  80197a:	78 33                	js     8019af <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80197c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801983:	74 2f                	je     8019b4 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801985:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801988:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80198f:	00 00 00 
	stat->st_isdir = 0;
  801992:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801999:	00 00 00 
	stat->st_dev = dev;
  80199c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019a2:	83 ec 08             	sub    $0x8,%esp
  8019a5:	53                   	push   %ebx
  8019a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8019a9:	ff 50 14             	call   *0x14(%eax)
  8019ac:	83 c4 10             	add    $0x10,%esp
}
  8019af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    
		return -E_NOT_SUPP;
  8019b4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019b9:	eb f4                	jmp    8019af <fstat+0x6c>

008019bb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019bb:	f3 0f 1e fb          	endbr32 
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	56                   	push   %esi
  8019c3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019c4:	83 ec 08             	sub    $0x8,%esp
  8019c7:	6a 00                	push   $0x0
  8019c9:	ff 75 08             	pushl  0x8(%ebp)
  8019cc:	e8 fb 01 00 00       	call   801bcc <open>
  8019d1:	89 c3                	mov    %eax,%ebx
  8019d3:	83 c4 10             	add    $0x10,%esp
  8019d6:	85 c0                	test   %eax,%eax
  8019d8:	78 1b                	js     8019f5 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8019da:	83 ec 08             	sub    $0x8,%esp
  8019dd:	ff 75 0c             	pushl  0xc(%ebp)
  8019e0:	50                   	push   %eax
  8019e1:	e8 5d ff ff ff       	call   801943 <fstat>
  8019e6:	89 c6                	mov    %eax,%esi
	close(fd);
  8019e8:	89 1c 24             	mov    %ebx,(%esp)
  8019eb:	e8 fd fb ff ff       	call   8015ed <close>
	return r;
  8019f0:	83 c4 10             	add    $0x10,%esp
  8019f3:	89 f3                	mov    %esi,%ebx
}
  8019f5:	89 d8                	mov    %ebx,%eax
  8019f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019fa:	5b                   	pop    %ebx
  8019fb:	5e                   	pop    %esi
  8019fc:	5d                   	pop    %ebp
  8019fd:	c3                   	ret    

008019fe <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	56                   	push   %esi
  801a02:	53                   	push   %ebx
  801a03:	89 c6                	mov    %eax,%esi
  801a05:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a07:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801a0e:	74 27                	je     801a37 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a10:	6a 07                	push   $0x7
  801a12:	68 00 60 80 00       	push   $0x806000
  801a17:	56                   	push   %esi
  801a18:	ff 35 00 50 80 00    	pushl  0x805000
  801a1e:	e8 7a 0d 00 00       	call   80279d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a23:	83 c4 0c             	add    $0xc,%esp
  801a26:	6a 00                	push   $0x0
  801a28:	53                   	push   %ebx
  801a29:	6a 00                	push   $0x0
  801a2b:	e8 e8 0c 00 00       	call   802718 <ipc_recv>
}
  801a30:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a33:	5b                   	pop    %ebx
  801a34:	5e                   	pop    %esi
  801a35:	5d                   	pop    %ebp
  801a36:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a37:	83 ec 0c             	sub    $0xc,%esp
  801a3a:	6a 01                	push   $0x1
  801a3c:	e8 b4 0d 00 00       	call   8027f5 <ipc_find_env>
  801a41:	a3 00 50 80 00       	mov    %eax,0x805000
  801a46:	83 c4 10             	add    $0x10,%esp
  801a49:	eb c5                	jmp    801a10 <fsipc+0x12>

00801a4b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a4b:	f3 0f 1e fb          	endbr32 
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
  801a52:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a55:	8b 45 08             	mov    0x8(%ebp),%eax
  801a58:	8b 40 0c             	mov    0xc(%eax),%eax
  801a5b:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a63:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a68:	ba 00 00 00 00       	mov    $0x0,%edx
  801a6d:	b8 02 00 00 00       	mov    $0x2,%eax
  801a72:	e8 87 ff ff ff       	call   8019fe <fsipc>
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <devfile_flush>:
{
  801a79:	f3 0f 1e fb          	endbr32 
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
  801a80:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	8b 40 0c             	mov    0xc(%eax),%eax
  801a89:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801a8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a93:	b8 06 00 00 00       	mov    $0x6,%eax
  801a98:	e8 61 ff ff ff       	call   8019fe <fsipc>
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <devfile_stat>:
{
  801a9f:	f3 0f 1e fb          	endbr32 
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	53                   	push   %ebx
  801aa7:	83 ec 04             	sub    $0x4,%esp
  801aaa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ab3:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ab8:	ba 00 00 00 00       	mov    $0x0,%edx
  801abd:	b8 05 00 00 00       	mov    $0x5,%eax
  801ac2:	e8 37 ff ff ff       	call   8019fe <fsipc>
  801ac7:	85 c0                	test   %eax,%eax
  801ac9:	78 2c                	js     801af7 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801acb:	83 ec 08             	sub    $0x8,%esp
  801ace:	68 00 60 80 00       	push   $0x806000
  801ad3:	53                   	push   %ebx
  801ad4:	e8 56 ef ff ff       	call   800a2f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ad9:	a1 80 60 80 00       	mov    0x806080,%eax
  801ade:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ae4:	a1 84 60 80 00       	mov    0x806084,%eax
  801ae9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801aef:	83 c4 10             	add    $0x10,%esp
  801af2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801af7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <devfile_write>:
{
  801afc:	f3 0f 1e fb          	endbr32 
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	83 ec 0c             	sub    $0xc,%esp
  801b06:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b09:	8b 55 08             	mov    0x8(%ebp),%edx
  801b0c:	8b 52 0c             	mov    0xc(%edx),%edx
  801b0f:	89 15 00 60 80 00    	mov    %edx,0x806000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801b15:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801b1a:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801b1f:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801b22:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801b27:	50                   	push   %eax
  801b28:	ff 75 0c             	pushl  0xc(%ebp)
  801b2b:	68 08 60 80 00       	push   $0x806008
  801b30:	e8 b0 f0 ff ff       	call   800be5 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801b35:	ba 00 00 00 00       	mov    $0x0,%edx
  801b3a:	b8 04 00 00 00       	mov    $0x4,%eax
  801b3f:	e8 ba fe ff ff       	call   8019fe <fsipc>
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <devfile_read>:
{
  801b46:	f3 0f 1e fb          	endbr32 
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	56                   	push   %esi
  801b4e:	53                   	push   %ebx
  801b4f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b52:	8b 45 08             	mov    0x8(%ebp),%eax
  801b55:	8b 40 0c             	mov    0xc(%eax),%eax
  801b58:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b5d:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b63:	ba 00 00 00 00       	mov    $0x0,%edx
  801b68:	b8 03 00 00 00       	mov    $0x3,%eax
  801b6d:	e8 8c fe ff ff       	call   8019fe <fsipc>
  801b72:	89 c3                	mov    %eax,%ebx
  801b74:	85 c0                	test   %eax,%eax
  801b76:	78 1f                	js     801b97 <devfile_read+0x51>
	assert(r <= n);
  801b78:	39 f0                	cmp    %esi,%eax
  801b7a:	77 24                	ja     801ba0 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801b7c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b81:	7f 33                	jg     801bb6 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b83:	83 ec 04             	sub    $0x4,%esp
  801b86:	50                   	push   %eax
  801b87:	68 00 60 80 00       	push   $0x806000
  801b8c:	ff 75 0c             	pushl  0xc(%ebp)
  801b8f:	e8 51 f0 ff ff       	call   800be5 <memmove>
	return r;
  801b94:	83 c4 10             	add    $0x10,%esp
}
  801b97:	89 d8                	mov    %ebx,%eax
  801b99:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b9c:	5b                   	pop    %ebx
  801b9d:	5e                   	pop    %esi
  801b9e:	5d                   	pop    %ebp
  801b9f:	c3                   	ret    
	assert(r <= n);
  801ba0:	68 ac 30 80 00       	push   $0x8030ac
  801ba5:	68 b3 30 80 00       	push   $0x8030b3
  801baa:	6a 7c                	push   $0x7c
  801bac:	68 c8 30 80 00       	push   $0x8030c8
  801bb1:	e8 88 e7 ff ff       	call   80033e <_panic>
	assert(r <= PGSIZE);
  801bb6:	68 d3 30 80 00       	push   $0x8030d3
  801bbb:	68 b3 30 80 00       	push   $0x8030b3
  801bc0:	6a 7d                	push   $0x7d
  801bc2:	68 c8 30 80 00       	push   $0x8030c8
  801bc7:	e8 72 e7 ff ff       	call   80033e <_panic>

00801bcc <open>:
{
  801bcc:	f3 0f 1e fb          	endbr32 
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	56                   	push   %esi
  801bd4:	53                   	push   %ebx
  801bd5:	83 ec 1c             	sub    $0x1c,%esp
  801bd8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801bdb:	56                   	push   %esi
  801bdc:	e8 0b ee ff ff       	call   8009ec <strlen>
  801be1:	83 c4 10             	add    $0x10,%esp
  801be4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801be9:	7f 6c                	jg     801c57 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801beb:	83 ec 0c             	sub    $0xc,%esp
  801bee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bf1:	50                   	push   %eax
  801bf2:	e8 62 f8 ff ff       	call   801459 <fd_alloc>
  801bf7:	89 c3                	mov    %eax,%ebx
  801bf9:	83 c4 10             	add    $0x10,%esp
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	78 3c                	js     801c3c <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801c00:	83 ec 08             	sub    $0x8,%esp
  801c03:	56                   	push   %esi
  801c04:	68 00 60 80 00       	push   $0x806000
  801c09:	e8 21 ee ff ff       	call   800a2f <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c11:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c19:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1e:	e8 db fd ff ff       	call   8019fe <fsipc>
  801c23:	89 c3                	mov    %eax,%ebx
  801c25:	83 c4 10             	add    $0x10,%esp
  801c28:	85 c0                	test   %eax,%eax
  801c2a:	78 19                	js     801c45 <open+0x79>
	return fd2num(fd);
  801c2c:	83 ec 0c             	sub    $0xc,%esp
  801c2f:	ff 75 f4             	pushl  -0xc(%ebp)
  801c32:	e8 f3 f7 ff ff       	call   80142a <fd2num>
  801c37:	89 c3                	mov    %eax,%ebx
  801c39:	83 c4 10             	add    $0x10,%esp
}
  801c3c:	89 d8                	mov    %ebx,%eax
  801c3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c41:	5b                   	pop    %ebx
  801c42:	5e                   	pop    %esi
  801c43:	5d                   	pop    %ebp
  801c44:	c3                   	ret    
		fd_close(fd, 0);
  801c45:	83 ec 08             	sub    $0x8,%esp
  801c48:	6a 00                	push   $0x0
  801c4a:	ff 75 f4             	pushl  -0xc(%ebp)
  801c4d:	e8 10 f9 ff ff       	call   801562 <fd_close>
		return r;
  801c52:	83 c4 10             	add    $0x10,%esp
  801c55:	eb e5                	jmp    801c3c <open+0x70>
		return -E_BAD_PATH;
  801c57:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c5c:	eb de                	jmp    801c3c <open+0x70>

00801c5e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c5e:	f3 0f 1e fb          	endbr32 
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c68:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6d:	b8 08 00 00 00       	mov    $0x8,%eax
  801c72:	e8 87 fd ff ff       	call   8019fe <fsipc>
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c79:	f3 0f 1e fb          	endbr32 
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
  801c80:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801c83:	68 df 30 80 00       	push   $0x8030df
  801c88:	ff 75 0c             	pushl  0xc(%ebp)
  801c8b:	e8 9f ed ff ff       	call   800a2f <strcpy>
	return 0;
}
  801c90:	b8 00 00 00 00       	mov    $0x0,%eax
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <devsock_close>:
{
  801c97:	f3 0f 1e fb          	endbr32 
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	53                   	push   %ebx
  801c9f:	83 ec 10             	sub    $0x10,%esp
  801ca2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ca5:	53                   	push   %ebx
  801ca6:	e8 87 0b 00 00       	call   802832 <pageref>
  801cab:	89 c2                	mov    %eax,%edx
  801cad:	83 c4 10             	add    $0x10,%esp
		return 0;
  801cb0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801cb5:	83 fa 01             	cmp    $0x1,%edx
  801cb8:	74 05                	je     801cbf <devsock_close+0x28>
}
  801cba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801cbf:	83 ec 0c             	sub    $0xc,%esp
  801cc2:	ff 73 0c             	pushl  0xc(%ebx)
  801cc5:	e8 e3 02 00 00       	call   801fad <nsipc_close>
  801cca:	83 c4 10             	add    $0x10,%esp
  801ccd:	eb eb                	jmp    801cba <devsock_close+0x23>

00801ccf <devsock_write>:
{
  801ccf:	f3 0f 1e fb          	endbr32 
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801cd9:	6a 00                	push   $0x0
  801cdb:	ff 75 10             	pushl  0x10(%ebp)
  801cde:	ff 75 0c             	pushl  0xc(%ebp)
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	ff 70 0c             	pushl  0xc(%eax)
  801ce7:	e8 b5 03 00 00       	call   8020a1 <nsipc_send>
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <devsock_read>:
{
  801cee:	f3 0f 1e fb          	endbr32 
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801cf8:	6a 00                	push   $0x0
  801cfa:	ff 75 10             	pushl  0x10(%ebp)
  801cfd:	ff 75 0c             	pushl  0xc(%ebp)
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	ff 70 0c             	pushl  0xc(%eax)
  801d06:	e8 1f 03 00 00       	call   80202a <nsipc_recv>
}
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <fd2sockid>:
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
  801d10:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d13:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d16:	52                   	push   %edx
  801d17:	50                   	push   %eax
  801d18:	e8 92 f7 ff ff       	call   8014af <fd_lookup>
  801d1d:	83 c4 10             	add    $0x10,%esp
  801d20:	85 c0                	test   %eax,%eax
  801d22:	78 10                	js     801d34 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d27:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  801d2d:	39 08                	cmp    %ecx,(%eax)
  801d2f:	75 05                	jne    801d36 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801d31:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    
		return -E_NOT_SUPP;
  801d36:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d3b:	eb f7                	jmp    801d34 <fd2sockid+0x27>

00801d3d <alloc_sockfd>:
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	56                   	push   %esi
  801d41:	53                   	push   %ebx
  801d42:	83 ec 1c             	sub    $0x1c,%esp
  801d45:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801d47:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d4a:	50                   	push   %eax
  801d4b:	e8 09 f7 ff ff       	call   801459 <fd_alloc>
  801d50:	89 c3                	mov    %eax,%ebx
  801d52:	83 c4 10             	add    $0x10,%esp
  801d55:	85 c0                	test   %eax,%eax
  801d57:	78 43                	js     801d9c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d59:	83 ec 04             	sub    $0x4,%esp
  801d5c:	68 07 04 00 00       	push   $0x407
  801d61:	ff 75 f4             	pushl  -0xc(%ebp)
  801d64:	6a 00                	push   $0x0
  801d66:	e8 06 f1 ff ff       	call   800e71 <sys_page_alloc>
  801d6b:	89 c3                	mov    %eax,%ebx
  801d6d:	83 c4 10             	add    $0x10,%esp
  801d70:	85 c0                	test   %eax,%eax
  801d72:	78 28                	js     801d9c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d77:	8b 15 24 40 80 00    	mov    0x804024,%edx
  801d7d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d82:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801d89:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801d8c:	83 ec 0c             	sub    $0xc,%esp
  801d8f:	50                   	push   %eax
  801d90:	e8 95 f6 ff ff       	call   80142a <fd2num>
  801d95:	89 c3                	mov    %eax,%ebx
  801d97:	83 c4 10             	add    $0x10,%esp
  801d9a:	eb 0c                	jmp    801da8 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801d9c:	83 ec 0c             	sub    $0xc,%esp
  801d9f:	56                   	push   %esi
  801da0:	e8 08 02 00 00       	call   801fad <nsipc_close>
		return r;
  801da5:	83 c4 10             	add    $0x10,%esp
}
  801da8:	89 d8                	mov    %ebx,%eax
  801daa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dad:	5b                   	pop    %ebx
  801dae:	5e                   	pop    %esi
  801daf:	5d                   	pop    %ebp
  801db0:	c3                   	ret    

00801db1 <accept>:
{
  801db1:	f3 0f 1e fb          	endbr32 
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	e8 4a ff ff ff       	call   801d0d <fd2sockid>
  801dc3:	85 c0                	test   %eax,%eax
  801dc5:	78 1b                	js     801de2 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801dc7:	83 ec 04             	sub    $0x4,%esp
  801dca:	ff 75 10             	pushl  0x10(%ebp)
  801dcd:	ff 75 0c             	pushl  0xc(%ebp)
  801dd0:	50                   	push   %eax
  801dd1:	e8 22 01 00 00       	call   801ef8 <nsipc_accept>
  801dd6:	83 c4 10             	add    $0x10,%esp
  801dd9:	85 c0                	test   %eax,%eax
  801ddb:	78 05                	js     801de2 <accept+0x31>
	return alloc_sockfd(r);
  801ddd:	e8 5b ff ff ff       	call   801d3d <alloc_sockfd>
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <bind>:
{
  801de4:	f3 0f 1e fb          	endbr32 
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dee:	8b 45 08             	mov    0x8(%ebp),%eax
  801df1:	e8 17 ff ff ff       	call   801d0d <fd2sockid>
  801df6:	85 c0                	test   %eax,%eax
  801df8:	78 12                	js     801e0c <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801dfa:	83 ec 04             	sub    $0x4,%esp
  801dfd:	ff 75 10             	pushl  0x10(%ebp)
  801e00:	ff 75 0c             	pushl  0xc(%ebp)
  801e03:	50                   	push   %eax
  801e04:	e8 45 01 00 00       	call   801f4e <nsipc_bind>
  801e09:	83 c4 10             	add    $0x10,%esp
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <shutdown>:
{
  801e0e:	f3 0f 1e fb          	endbr32 
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e18:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1b:	e8 ed fe ff ff       	call   801d0d <fd2sockid>
  801e20:	85 c0                	test   %eax,%eax
  801e22:	78 0f                	js     801e33 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801e24:	83 ec 08             	sub    $0x8,%esp
  801e27:	ff 75 0c             	pushl  0xc(%ebp)
  801e2a:	50                   	push   %eax
  801e2b:	e8 57 01 00 00       	call   801f87 <nsipc_shutdown>
  801e30:	83 c4 10             	add    $0x10,%esp
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <connect>:
{
  801e35:	f3 0f 1e fb          	endbr32 
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e42:	e8 c6 fe ff ff       	call   801d0d <fd2sockid>
  801e47:	85 c0                	test   %eax,%eax
  801e49:	78 12                	js     801e5d <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801e4b:	83 ec 04             	sub    $0x4,%esp
  801e4e:	ff 75 10             	pushl  0x10(%ebp)
  801e51:	ff 75 0c             	pushl  0xc(%ebp)
  801e54:	50                   	push   %eax
  801e55:	e8 71 01 00 00       	call   801fcb <nsipc_connect>
  801e5a:	83 c4 10             	add    $0x10,%esp
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <listen>:
{
  801e5f:	f3 0f 1e fb          	endbr32 
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
  801e66:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e69:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6c:	e8 9c fe ff ff       	call   801d0d <fd2sockid>
  801e71:	85 c0                	test   %eax,%eax
  801e73:	78 0f                	js     801e84 <listen+0x25>
	return nsipc_listen(r, backlog);
  801e75:	83 ec 08             	sub    $0x8,%esp
  801e78:	ff 75 0c             	pushl  0xc(%ebp)
  801e7b:	50                   	push   %eax
  801e7c:	e8 83 01 00 00       	call   802004 <nsipc_listen>
  801e81:	83 c4 10             	add    $0x10,%esp
}
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <socket>:

int
socket(int domain, int type, int protocol)
{
  801e86:	f3 0f 1e fb          	endbr32 
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801e90:	ff 75 10             	pushl  0x10(%ebp)
  801e93:	ff 75 0c             	pushl  0xc(%ebp)
  801e96:	ff 75 08             	pushl  0x8(%ebp)
  801e99:	e8 65 02 00 00       	call   802103 <nsipc_socket>
  801e9e:	83 c4 10             	add    $0x10,%esp
  801ea1:	85 c0                	test   %eax,%eax
  801ea3:	78 05                	js     801eaa <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801ea5:	e8 93 fe ff ff       	call   801d3d <alloc_sockfd>
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	53                   	push   %ebx
  801eb0:	83 ec 04             	sub    $0x4,%esp
  801eb3:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801eb5:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801ebc:	74 26                	je     801ee4 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ebe:	6a 07                	push   $0x7
  801ec0:	68 00 70 80 00       	push   $0x807000
  801ec5:	53                   	push   %ebx
  801ec6:	ff 35 04 50 80 00    	pushl  0x805004
  801ecc:	e8 cc 08 00 00       	call   80279d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ed1:	83 c4 0c             	add    $0xc,%esp
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	e8 39 08 00 00       	call   802718 <ipc_recv>
}
  801edf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ee4:	83 ec 0c             	sub    $0xc,%esp
  801ee7:	6a 02                	push   $0x2
  801ee9:	e8 07 09 00 00       	call   8027f5 <ipc_find_env>
  801eee:	a3 04 50 80 00       	mov    %eax,0x805004
  801ef3:	83 c4 10             	add    $0x10,%esp
  801ef6:	eb c6                	jmp    801ebe <nsipc+0x12>

00801ef8 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ef8:	f3 0f 1e fb          	endbr32 
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	56                   	push   %esi
  801f00:	53                   	push   %ebx
  801f01:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f04:	8b 45 08             	mov    0x8(%ebp),%eax
  801f07:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f0c:	8b 06                	mov    (%esi),%eax
  801f0e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f13:	b8 01 00 00 00       	mov    $0x1,%eax
  801f18:	e8 8f ff ff ff       	call   801eac <nsipc>
  801f1d:	89 c3                	mov    %eax,%ebx
  801f1f:	85 c0                	test   %eax,%eax
  801f21:	79 09                	jns    801f2c <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801f23:	89 d8                	mov    %ebx,%eax
  801f25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f28:	5b                   	pop    %ebx
  801f29:	5e                   	pop    %esi
  801f2a:	5d                   	pop    %ebp
  801f2b:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f2c:	83 ec 04             	sub    $0x4,%esp
  801f2f:	ff 35 10 70 80 00    	pushl  0x807010
  801f35:	68 00 70 80 00       	push   $0x807000
  801f3a:	ff 75 0c             	pushl  0xc(%ebp)
  801f3d:	e8 a3 ec ff ff       	call   800be5 <memmove>
		*addrlen = ret->ret_addrlen;
  801f42:	a1 10 70 80 00       	mov    0x807010,%eax
  801f47:	89 06                	mov    %eax,(%esi)
  801f49:	83 c4 10             	add    $0x10,%esp
	return r;
  801f4c:	eb d5                	jmp    801f23 <nsipc_accept+0x2b>

00801f4e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f4e:	f3 0f 1e fb          	endbr32 
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	53                   	push   %ebx
  801f56:	83 ec 08             	sub    $0x8,%esp
  801f59:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f64:	53                   	push   %ebx
  801f65:	ff 75 0c             	pushl  0xc(%ebp)
  801f68:	68 04 70 80 00       	push   $0x807004
  801f6d:	e8 73 ec ff ff       	call   800be5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f72:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801f78:	b8 02 00 00 00       	mov    $0x2,%eax
  801f7d:	e8 2a ff ff ff       	call   801eac <nsipc>
}
  801f82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f87:	f3 0f 1e fb          	endbr32 
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801f99:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f9c:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801fa1:	b8 03 00 00 00       	mov    $0x3,%eax
  801fa6:	e8 01 ff ff ff       	call   801eac <nsipc>
}
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <nsipc_close>:

int
nsipc_close(int s)
{
  801fad:	f3 0f 1e fb          	endbr32 
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
  801fb4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fba:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801fbf:	b8 04 00 00 00       	mov    $0x4,%eax
  801fc4:	e8 e3 fe ff ff       	call   801eac <nsipc>
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fcb:	f3 0f 1e fb          	endbr32 
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	53                   	push   %ebx
  801fd3:	83 ec 08             	sub    $0x8,%esp
  801fd6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdc:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801fe1:	53                   	push   %ebx
  801fe2:	ff 75 0c             	pushl  0xc(%ebp)
  801fe5:	68 04 70 80 00       	push   $0x807004
  801fea:	e8 f6 eb ff ff       	call   800be5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801fef:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801ff5:	b8 05 00 00 00       	mov    $0x5,%eax
  801ffa:	e8 ad fe ff ff       	call   801eac <nsipc>
}
  801fff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802002:	c9                   	leave  
  802003:	c3                   	ret    

00802004 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802004:	f3 0f 1e fb          	endbr32 
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802016:	8b 45 0c             	mov    0xc(%ebp),%eax
  802019:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80201e:	b8 06 00 00 00       	mov    $0x6,%eax
  802023:	e8 84 fe ff ff       	call   801eac <nsipc>
}
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80202a:	f3 0f 1e fb          	endbr32 
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
  802031:	56                   	push   %esi
  802032:	53                   	push   %ebx
  802033:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80203e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802044:	8b 45 14             	mov    0x14(%ebp),%eax
  802047:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80204c:	b8 07 00 00 00       	mov    $0x7,%eax
  802051:	e8 56 fe ff ff       	call   801eac <nsipc>
  802056:	89 c3                	mov    %eax,%ebx
  802058:	85 c0                	test   %eax,%eax
  80205a:	78 26                	js     802082 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  80205c:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  802062:	b8 3f 06 00 00       	mov    $0x63f,%eax
  802067:	0f 4e c6             	cmovle %esi,%eax
  80206a:	39 c3                	cmp    %eax,%ebx
  80206c:	7f 1d                	jg     80208b <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80206e:	83 ec 04             	sub    $0x4,%esp
  802071:	53                   	push   %ebx
  802072:	68 00 70 80 00       	push   $0x807000
  802077:	ff 75 0c             	pushl  0xc(%ebp)
  80207a:	e8 66 eb ff ff       	call   800be5 <memmove>
  80207f:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802082:	89 d8                	mov    %ebx,%eax
  802084:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802087:	5b                   	pop    %ebx
  802088:	5e                   	pop    %esi
  802089:	5d                   	pop    %ebp
  80208a:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80208b:	68 eb 30 80 00       	push   $0x8030eb
  802090:	68 b3 30 80 00       	push   $0x8030b3
  802095:	6a 62                	push   $0x62
  802097:	68 00 31 80 00       	push   $0x803100
  80209c:	e8 9d e2 ff ff       	call   80033e <_panic>

008020a1 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8020a1:	f3 0f 1e fb          	endbr32 
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	53                   	push   %ebx
  8020a9:	83 ec 04             	sub    $0x4,%esp
  8020ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8020b7:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8020bd:	7f 2e                	jg     8020ed <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8020bf:	83 ec 04             	sub    $0x4,%esp
  8020c2:	53                   	push   %ebx
  8020c3:	ff 75 0c             	pushl  0xc(%ebp)
  8020c6:	68 0c 70 80 00       	push   $0x80700c
  8020cb:	e8 15 eb ff ff       	call   800be5 <memmove>
	nsipcbuf.send.req_size = size;
  8020d0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8020d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8020d9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8020de:	b8 08 00 00 00       	mov    $0x8,%eax
  8020e3:	e8 c4 fd ff ff       	call   801eac <nsipc>
}
  8020e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    
	assert(size < 1600);
  8020ed:	68 0c 31 80 00       	push   $0x80310c
  8020f2:	68 b3 30 80 00       	push   $0x8030b3
  8020f7:	6a 6d                	push   $0x6d
  8020f9:	68 00 31 80 00       	push   $0x803100
  8020fe:	e8 3b e2 ff ff       	call   80033e <_panic>

00802103 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802103:	f3 0f 1e fb          	endbr32 
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802115:	8b 45 0c             	mov    0xc(%ebp),%eax
  802118:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80211d:	8b 45 10             	mov    0x10(%ebp),%eax
  802120:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802125:	b8 09 00 00 00       	mov    $0x9,%eax
  80212a:	e8 7d fd ff ff       	call   801eac <nsipc>
}
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802131:	f3 0f 1e fb          	endbr32 
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	56                   	push   %esi
  802139:	53                   	push   %ebx
  80213a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80213d:	83 ec 0c             	sub    $0xc,%esp
  802140:	ff 75 08             	pushl  0x8(%ebp)
  802143:	e8 f6 f2 ff ff       	call   80143e <fd2data>
  802148:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80214a:	83 c4 08             	add    $0x8,%esp
  80214d:	68 18 31 80 00       	push   $0x803118
  802152:	53                   	push   %ebx
  802153:	e8 d7 e8 ff ff       	call   800a2f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802158:	8b 46 04             	mov    0x4(%esi),%eax
  80215b:	2b 06                	sub    (%esi),%eax
  80215d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802163:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80216a:	00 00 00 
	stat->st_dev = &devpipe;
  80216d:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  802174:	40 80 00 
	return 0;
}
  802177:	b8 00 00 00 00       	mov    $0x0,%eax
  80217c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80217f:	5b                   	pop    %ebx
  802180:	5e                   	pop    %esi
  802181:	5d                   	pop    %ebp
  802182:	c3                   	ret    

00802183 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802183:	f3 0f 1e fb          	endbr32 
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
  80218a:	53                   	push   %ebx
  80218b:	83 ec 0c             	sub    $0xc,%esp
  80218e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802191:	53                   	push   %ebx
  802192:	6a 00                	push   $0x0
  802194:	e8 65 ed ff ff       	call   800efe <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802199:	89 1c 24             	mov    %ebx,(%esp)
  80219c:	e8 9d f2 ff ff       	call   80143e <fd2data>
  8021a1:	83 c4 08             	add    $0x8,%esp
  8021a4:	50                   	push   %eax
  8021a5:	6a 00                	push   $0x0
  8021a7:	e8 52 ed ff ff       	call   800efe <sys_page_unmap>
}
  8021ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021af:	c9                   	leave  
  8021b0:	c3                   	ret    

008021b1 <_pipeisclosed>:
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
  8021b4:	57                   	push   %edi
  8021b5:	56                   	push   %esi
  8021b6:	53                   	push   %ebx
  8021b7:	83 ec 1c             	sub    $0x1c,%esp
  8021ba:	89 c7                	mov    %eax,%edi
  8021bc:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8021be:	a1 08 50 80 00       	mov    0x805008,%eax
  8021c3:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8021c6:	83 ec 0c             	sub    $0xc,%esp
  8021c9:	57                   	push   %edi
  8021ca:	e8 63 06 00 00       	call   802832 <pageref>
  8021cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8021d2:	89 34 24             	mov    %esi,(%esp)
  8021d5:	e8 58 06 00 00       	call   802832 <pageref>
		nn = thisenv->env_runs;
  8021da:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8021e0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8021e3:	83 c4 10             	add    $0x10,%esp
  8021e6:	39 cb                	cmp    %ecx,%ebx
  8021e8:	74 1b                	je     802205 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8021ea:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021ed:	75 cf                	jne    8021be <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8021ef:	8b 42 58             	mov    0x58(%edx),%eax
  8021f2:	6a 01                	push   $0x1
  8021f4:	50                   	push   %eax
  8021f5:	53                   	push   %ebx
  8021f6:	68 1f 31 80 00       	push   $0x80311f
  8021fb:	e8 25 e2 ff ff       	call   800425 <cprintf>
  802200:	83 c4 10             	add    $0x10,%esp
  802203:	eb b9                	jmp    8021be <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802205:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802208:	0f 94 c0             	sete   %al
  80220b:	0f b6 c0             	movzbl %al,%eax
}
  80220e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802211:	5b                   	pop    %ebx
  802212:	5e                   	pop    %esi
  802213:	5f                   	pop    %edi
  802214:	5d                   	pop    %ebp
  802215:	c3                   	ret    

00802216 <devpipe_write>:
{
  802216:	f3 0f 1e fb          	endbr32 
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
  80221d:	57                   	push   %edi
  80221e:	56                   	push   %esi
  80221f:	53                   	push   %ebx
  802220:	83 ec 28             	sub    $0x28,%esp
  802223:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802226:	56                   	push   %esi
  802227:	e8 12 f2 ff ff       	call   80143e <fd2data>
  80222c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80222e:	83 c4 10             	add    $0x10,%esp
  802231:	bf 00 00 00 00       	mov    $0x0,%edi
  802236:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802239:	74 4f                	je     80228a <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80223b:	8b 43 04             	mov    0x4(%ebx),%eax
  80223e:	8b 0b                	mov    (%ebx),%ecx
  802240:	8d 51 20             	lea    0x20(%ecx),%edx
  802243:	39 d0                	cmp    %edx,%eax
  802245:	72 14                	jb     80225b <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802247:	89 da                	mov    %ebx,%edx
  802249:	89 f0                	mov    %esi,%eax
  80224b:	e8 61 ff ff ff       	call   8021b1 <_pipeisclosed>
  802250:	85 c0                	test   %eax,%eax
  802252:	75 3b                	jne    80228f <devpipe_write+0x79>
			sys_yield();
  802254:	e8 f5 eb ff ff       	call   800e4e <sys_yield>
  802259:	eb e0                	jmp    80223b <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80225b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80225e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802262:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802265:	89 c2                	mov    %eax,%edx
  802267:	c1 fa 1f             	sar    $0x1f,%edx
  80226a:	89 d1                	mov    %edx,%ecx
  80226c:	c1 e9 1b             	shr    $0x1b,%ecx
  80226f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802272:	83 e2 1f             	and    $0x1f,%edx
  802275:	29 ca                	sub    %ecx,%edx
  802277:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80227b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80227f:	83 c0 01             	add    $0x1,%eax
  802282:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802285:	83 c7 01             	add    $0x1,%edi
  802288:	eb ac                	jmp    802236 <devpipe_write+0x20>
	return i;
  80228a:	8b 45 10             	mov    0x10(%ebp),%eax
  80228d:	eb 05                	jmp    802294 <devpipe_write+0x7e>
				return 0;
  80228f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802294:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802297:	5b                   	pop    %ebx
  802298:	5e                   	pop    %esi
  802299:	5f                   	pop    %edi
  80229a:	5d                   	pop    %ebp
  80229b:	c3                   	ret    

0080229c <devpipe_read>:
{
  80229c:	f3 0f 1e fb          	endbr32 
  8022a0:	55                   	push   %ebp
  8022a1:	89 e5                	mov    %esp,%ebp
  8022a3:	57                   	push   %edi
  8022a4:	56                   	push   %esi
  8022a5:	53                   	push   %ebx
  8022a6:	83 ec 18             	sub    $0x18,%esp
  8022a9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8022ac:	57                   	push   %edi
  8022ad:	e8 8c f1 ff ff       	call   80143e <fd2data>
  8022b2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022b4:	83 c4 10             	add    $0x10,%esp
  8022b7:	be 00 00 00 00       	mov    $0x0,%esi
  8022bc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022bf:	75 14                	jne    8022d5 <devpipe_read+0x39>
	return i;
  8022c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c4:	eb 02                	jmp    8022c8 <devpipe_read+0x2c>
				return i;
  8022c6:	89 f0                	mov    %esi,%eax
}
  8022c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022cb:	5b                   	pop    %ebx
  8022cc:	5e                   	pop    %esi
  8022cd:	5f                   	pop    %edi
  8022ce:	5d                   	pop    %ebp
  8022cf:	c3                   	ret    
			sys_yield();
  8022d0:	e8 79 eb ff ff       	call   800e4e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8022d5:	8b 03                	mov    (%ebx),%eax
  8022d7:	3b 43 04             	cmp    0x4(%ebx),%eax
  8022da:	75 18                	jne    8022f4 <devpipe_read+0x58>
			if (i > 0)
  8022dc:	85 f6                	test   %esi,%esi
  8022de:	75 e6                	jne    8022c6 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8022e0:	89 da                	mov    %ebx,%edx
  8022e2:	89 f8                	mov    %edi,%eax
  8022e4:	e8 c8 fe ff ff       	call   8021b1 <_pipeisclosed>
  8022e9:	85 c0                	test   %eax,%eax
  8022eb:	74 e3                	je     8022d0 <devpipe_read+0x34>
				return 0;
  8022ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f2:	eb d4                	jmp    8022c8 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8022f4:	99                   	cltd   
  8022f5:	c1 ea 1b             	shr    $0x1b,%edx
  8022f8:	01 d0                	add    %edx,%eax
  8022fa:	83 e0 1f             	and    $0x1f,%eax
  8022fd:	29 d0                	sub    %edx,%eax
  8022ff:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802304:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802307:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80230a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80230d:	83 c6 01             	add    $0x1,%esi
  802310:	eb aa                	jmp    8022bc <devpipe_read+0x20>

00802312 <pipe>:
{
  802312:	f3 0f 1e fb          	endbr32 
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
  802319:	56                   	push   %esi
  80231a:	53                   	push   %ebx
  80231b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80231e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802321:	50                   	push   %eax
  802322:	e8 32 f1 ff ff       	call   801459 <fd_alloc>
  802327:	89 c3                	mov    %eax,%ebx
  802329:	83 c4 10             	add    $0x10,%esp
  80232c:	85 c0                	test   %eax,%eax
  80232e:	0f 88 23 01 00 00    	js     802457 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802334:	83 ec 04             	sub    $0x4,%esp
  802337:	68 07 04 00 00       	push   $0x407
  80233c:	ff 75 f4             	pushl  -0xc(%ebp)
  80233f:	6a 00                	push   $0x0
  802341:	e8 2b eb ff ff       	call   800e71 <sys_page_alloc>
  802346:	89 c3                	mov    %eax,%ebx
  802348:	83 c4 10             	add    $0x10,%esp
  80234b:	85 c0                	test   %eax,%eax
  80234d:	0f 88 04 01 00 00    	js     802457 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802353:	83 ec 0c             	sub    $0xc,%esp
  802356:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802359:	50                   	push   %eax
  80235a:	e8 fa f0 ff ff       	call   801459 <fd_alloc>
  80235f:	89 c3                	mov    %eax,%ebx
  802361:	83 c4 10             	add    $0x10,%esp
  802364:	85 c0                	test   %eax,%eax
  802366:	0f 88 db 00 00 00    	js     802447 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80236c:	83 ec 04             	sub    $0x4,%esp
  80236f:	68 07 04 00 00       	push   $0x407
  802374:	ff 75 f0             	pushl  -0x10(%ebp)
  802377:	6a 00                	push   $0x0
  802379:	e8 f3 ea ff ff       	call   800e71 <sys_page_alloc>
  80237e:	89 c3                	mov    %eax,%ebx
  802380:	83 c4 10             	add    $0x10,%esp
  802383:	85 c0                	test   %eax,%eax
  802385:	0f 88 bc 00 00 00    	js     802447 <pipe+0x135>
	va = fd2data(fd0);
  80238b:	83 ec 0c             	sub    $0xc,%esp
  80238e:	ff 75 f4             	pushl  -0xc(%ebp)
  802391:	e8 a8 f0 ff ff       	call   80143e <fd2data>
  802396:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802398:	83 c4 0c             	add    $0xc,%esp
  80239b:	68 07 04 00 00       	push   $0x407
  8023a0:	50                   	push   %eax
  8023a1:	6a 00                	push   $0x0
  8023a3:	e8 c9 ea ff ff       	call   800e71 <sys_page_alloc>
  8023a8:	89 c3                	mov    %eax,%ebx
  8023aa:	83 c4 10             	add    $0x10,%esp
  8023ad:	85 c0                	test   %eax,%eax
  8023af:	0f 88 82 00 00 00    	js     802437 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023b5:	83 ec 0c             	sub    $0xc,%esp
  8023b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8023bb:	e8 7e f0 ff ff       	call   80143e <fd2data>
  8023c0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8023c7:	50                   	push   %eax
  8023c8:	6a 00                	push   $0x0
  8023ca:	56                   	push   %esi
  8023cb:	6a 00                	push   $0x0
  8023cd:	e8 e6 ea ff ff       	call   800eb8 <sys_page_map>
  8023d2:	89 c3                	mov    %eax,%ebx
  8023d4:	83 c4 20             	add    $0x20,%esp
  8023d7:	85 c0                	test   %eax,%eax
  8023d9:	78 4e                	js     802429 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8023db:	a1 40 40 80 00       	mov    0x804040,%eax
  8023e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e3:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8023e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e8:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8023ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023f2:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8023f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8023fe:	83 ec 0c             	sub    $0xc,%esp
  802401:	ff 75 f4             	pushl  -0xc(%ebp)
  802404:	e8 21 f0 ff ff       	call   80142a <fd2num>
  802409:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80240c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80240e:	83 c4 04             	add    $0x4,%esp
  802411:	ff 75 f0             	pushl  -0x10(%ebp)
  802414:	e8 11 f0 ff ff       	call   80142a <fd2num>
  802419:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80241c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80241f:	83 c4 10             	add    $0x10,%esp
  802422:	bb 00 00 00 00       	mov    $0x0,%ebx
  802427:	eb 2e                	jmp    802457 <pipe+0x145>
	sys_page_unmap(0, va);
  802429:	83 ec 08             	sub    $0x8,%esp
  80242c:	56                   	push   %esi
  80242d:	6a 00                	push   $0x0
  80242f:	e8 ca ea ff ff       	call   800efe <sys_page_unmap>
  802434:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802437:	83 ec 08             	sub    $0x8,%esp
  80243a:	ff 75 f0             	pushl  -0x10(%ebp)
  80243d:	6a 00                	push   $0x0
  80243f:	e8 ba ea ff ff       	call   800efe <sys_page_unmap>
  802444:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802447:	83 ec 08             	sub    $0x8,%esp
  80244a:	ff 75 f4             	pushl  -0xc(%ebp)
  80244d:	6a 00                	push   $0x0
  80244f:	e8 aa ea ff ff       	call   800efe <sys_page_unmap>
  802454:	83 c4 10             	add    $0x10,%esp
}
  802457:	89 d8                	mov    %ebx,%eax
  802459:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80245c:	5b                   	pop    %ebx
  80245d:	5e                   	pop    %esi
  80245e:	5d                   	pop    %ebp
  80245f:	c3                   	ret    

00802460 <pipeisclosed>:
{
  802460:	f3 0f 1e fb          	endbr32 
  802464:	55                   	push   %ebp
  802465:	89 e5                	mov    %esp,%ebp
  802467:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80246a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80246d:	50                   	push   %eax
  80246e:	ff 75 08             	pushl  0x8(%ebp)
  802471:	e8 39 f0 ff ff       	call   8014af <fd_lookup>
  802476:	83 c4 10             	add    $0x10,%esp
  802479:	85 c0                	test   %eax,%eax
  80247b:	78 18                	js     802495 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80247d:	83 ec 0c             	sub    $0xc,%esp
  802480:	ff 75 f4             	pushl  -0xc(%ebp)
  802483:	e8 b6 ef ff ff       	call   80143e <fd2data>
  802488:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	e8 1f fd ff ff       	call   8021b1 <_pipeisclosed>
  802492:	83 c4 10             	add    $0x10,%esp
}
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802497:	f3 0f 1e fb          	endbr32 
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
  80249e:	56                   	push   %esi
  80249f:	53                   	push   %ebx
  8024a0:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8024a3:	85 f6                	test   %esi,%esi
  8024a5:	74 13                	je     8024ba <wait+0x23>
	e = &envs[ENVX(envid)];
  8024a7:	89 f3                	mov    %esi,%ebx
  8024a9:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8024af:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  8024b2:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8024b8:	eb 1b                	jmp    8024d5 <wait+0x3e>
	assert(envid != 0);
  8024ba:	68 37 31 80 00       	push   $0x803137
  8024bf:	68 b3 30 80 00       	push   $0x8030b3
  8024c4:	6a 09                	push   $0x9
  8024c6:	68 42 31 80 00       	push   $0x803142
  8024cb:	e8 6e de ff ff       	call   80033e <_panic>
		sys_yield();
  8024d0:	e8 79 e9 ff ff       	call   800e4e <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8024d5:	8b 43 48             	mov    0x48(%ebx),%eax
  8024d8:	39 f0                	cmp    %esi,%eax
  8024da:	75 07                	jne    8024e3 <wait+0x4c>
  8024dc:	8b 43 54             	mov    0x54(%ebx),%eax
  8024df:	85 c0                	test   %eax,%eax
  8024e1:	75 ed                	jne    8024d0 <wait+0x39>
}
  8024e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024e6:	5b                   	pop    %ebx
  8024e7:	5e                   	pop    %esi
  8024e8:	5d                   	pop    %ebp
  8024e9:	c3                   	ret    

008024ea <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8024ea:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8024ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f3:	c3                   	ret    

008024f4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024f4:	f3 0f 1e fb          	endbr32 
  8024f8:	55                   	push   %ebp
  8024f9:	89 e5                	mov    %esp,%ebp
  8024fb:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8024fe:	68 4d 31 80 00       	push   $0x80314d
  802503:	ff 75 0c             	pushl  0xc(%ebp)
  802506:	e8 24 e5 ff ff       	call   800a2f <strcpy>
	return 0;
}
  80250b:	b8 00 00 00 00       	mov    $0x0,%eax
  802510:	c9                   	leave  
  802511:	c3                   	ret    

00802512 <devcons_write>:
{
  802512:	f3 0f 1e fb          	endbr32 
  802516:	55                   	push   %ebp
  802517:	89 e5                	mov    %esp,%ebp
  802519:	57                   	push   %edi
  80251a:	56                   	push   %esi
  80251b:	53                   	push   %ebx
  80251c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802522:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802527:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80252d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802530:	73 31                	jae    802563 <devcons_write+0x51>
		m = n - tot;
  802532:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802535:	29 f3                	sub    %esi,%ebx
  802537:	83 fb 7f             	cmp    $0x7f,%ebx
  80253a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80253f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802542:	83 ec 04             	sub    $0x4,%esp
  802545:	53                   	push   %ebx
  802546:	89 f0                	mov    %esi,%eax
  802548:	03 45 0c             	add    0xc(%ebp),%eax
  80254b:	50                   	push   %eax
  80254c:	57                   	push   %edi
  80254d:	e8 93 e6 ff ff       	call   800be5 <memmove>
		sys_cputs(buf, m);
  802552:	83 c4 08             	add    $0x8,%esp
  802555:	53                   	push   %ebx
  802556:	57                   	push   %edi
  802557:	e8 45 e8 ff ff       	call   800da1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80255c:	01 de                	add    %ebx,%esi
  80255e:	83 c4 10             	add    $0x10,%esp
  802561:	eb ca                	jmp    80252d <devcons_write+0x1b>
}
  802563:	89 f0                	mov    %esi,%eax
  802565:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802568:	5b                   	pop    %ebx
  802569:	5e                   	pop    %esi
  80256a:	5f                   	pop    %edi
  80256b:	5d                   	pop    %ebp
  80256c:	c3                   	ret    

0080256d <devcons_read>:
{
  80256d:	f3 0f 1e fb          	endbr32 
  802571:	55                   	push   %ebp
  802572:	89 e5                	mov    %esp,%ebp
  802574:	83 ec 08             	sub    $0x8,%esp
  802577:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80257c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802580:	74 21                	je     8025a3 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802582:	e8 3c e8 ff ff       	call   800dc3 <sys_cgetc>
  802587:	85 c0                	test   %eax,%eax
  802589:	75 07                	jne    802592 <devcons_read+0x25>
		sys_yield();
  80258b:	e8 be e8 ff ff       	call   800e4e <sys_yield>
  802590:	eb f0                	jmp    802582 <devcons_read+0x15>
	if (c < 0)
  802592:	78 0f                	js     8025a3 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802594:	83 f8 04             	cmp    $0x4,%eax
  802597:	74 0c                	je     8025a5 <devcons_read+0x38>
	*(char*)vbuf = c;
  802599:	8b 55 0c             	mov    0xc(%ebp),%edx
  80259c:	88 02                	mov    %al,(%edx)
	return 1;
  80259e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025a3:	c9                   	leave  
  8025a4:	c3                   	ret    
		return 0;
  8025a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025aa:	eb f7                	jmp    8025a3 <devcons_read+0x36>

008025ac <cputchar>:
{
  8025ac:	f3 0f 1e fb          	endbr32 
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
  8025b3:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8025b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b9:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8025bc:	6a 01                	push   $0x1
  8025be:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025c1:	50                   	push   %eax
  8025c2:	e8 da e7 ff ff       	call   800da1 <sys_cputs>
}
  8025c7:	83 c4 10             	add    $0x10,%esp
  8025ca:	c9                   	leave  
  8025cb:	c3                   	ret    

008025cc <getchar>:
{
  8025cc:	f3 0f 1e fb          	endbr32 
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
  8025d3:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8025d6:	6a 01                	push   $0x1
  8025d8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025db:	50                   	push   %eax
  8025dc:	6a 00                	push   $0x0
  8025de:	e8 54 f1 ff ff       	call   801737 <read>
	if (r < 0)
  8025e3:	83 c4 10             	add    $0x10,%esp
  8025e6:	85 c0                	test   %eax,%eax
  8025e8:	78 06                	js     8025f0 <getchar+0x24>
	if (r < 1)
  8025ea:	74 06                	je     8025f2 <getchar+0x26>
	return c;
  8025ec:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8025f0:	c9                   	leave  
  8025f1:	c3                   	ret    
		return -E_EOF;
  8025f2:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8025f7:	eb f7                	jmp    8025f0 <getchar+0x24>

008025f9 <iscons>:
{
  8025f9:	f3 0f 1e fb          	endbr32 
  8025fd:	55                   	push   %ebp
  8025fe:	89 e5                	mov    %esp,%ebp
  802600:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802603:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802606:	50                   	push   %eax
  802607:	ff 75 08             	pushl  0x8(%ebp)
  80260a:	e8 a0 ee ff ff       	call   8014af <fd_lookup>
  80260f:	83 c4 10             	add    $0x10,%esp
  802612:	85 c0                	test   %eax,%eax
  802614:	78 11                	js     802627 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802619:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  80261f:	39 10                	cmp    %edx,(%eax)
  802621:	0f 94 c0             	sete   %al
  802624:	0f b6 c0             	movzbl %al,%eax
}
  802627:	c9                   	leave  
  802628:	c3                   	ret    

00802629 <opencons>:
{
  802629:	f3 0f 1e fb          	endbr32 
  80262d:	55                   	push   %ebp
  80262e:	89 e5                	mov    %esp,%ebp
  802630:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802633:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802636:	50                   	push   %eax
  802637:	e8 1d ee ff ff       	call   801459 <fd_alloc>
  80263c:	83 c4 10             	add    $0x10,%esp
  80263f:	85 c0                	test   %eax,%eax
  802641:	78 3a                	js     80267d <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802643:	83 ec 04             	sub    $0x4,%esp
  802646:	68 07 04 00 00       	push   $0x407
  80264b:	ff 75 f4             	pushl  -0xc(%ebp)
  80264e:	6a 00                	push   $0x0
  802650:	e8 1c e8 ff ff       	call   800e71 <sys_page_alloc>
  802655:	83 c4 10             	add    $0x10,%esp
  802658:	85 c0                	test   %eax,%eax
  80265a:	78 21                	js     80267d <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80265c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265f:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802665:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802671:	83 ec 0c             	sub    $0xc,%esp
  802674:	50                   	push   %eax
  802675:	e8 b0 ed ff ff       	call   80142a <fd2num>
  80267a:	83 c4 10             	add    $0x10,%esp
}
  80267d:	c9                   	leave  
  80267e:	c3                   	ret    

0080267f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80267f:	f3 0f 1e fb          	endbr32 
  802683:	55                   	push   %ebp
  802684:	89 e5                	mov    %esp,%ebp
  802686:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802689:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802690:	74 0a                	je     80269c <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802692:	8b 45 08             	mov    0x8(%ebp),%eax
  802695:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80269a:	c9                   	leave  
  80269b:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  80269c:	83 ec 04             	sub    $0x4,%esp
  80269f:	6a 07                	push   $0x7
  8026a1:	68 00 f0 bf ee       	push   $0xeebff000
  8026a6:	6a 00                	push   $0x0
  8026a8:	e8 c4 e7 ff ff       	call   800e71 <sys_page_alloc>
  8026ad:	83 c4 10             	add    $0x10,%esp
  8026b0:	85 c0                	test   %eax,%eax
  8026b2:	78 2a                	js     8026de <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  8026b4:	83 ec 08             	sub    $0x8,%esp
  8026b7:	68 f2 26 80 00       	push   $0x8026f2
  8026bc:	6a 00                	push   $0x0
  8026be:	e8 0d e9 ff ff       	call   800fd0 <sys_env_set_pgfault_upcall>
  8026c3:	83 c4 10             	add    $0x10,%esp
  8026c6:	85 c0                	test   %eax,%eax
  8026c8:	79 c8                	jns    802692 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  8026ca:	83 ec 04             	sub    $0x4,%esp
  8026cd:	68 88 31 80 00       	push   $0x803188
  8026d2:	6a 25                	push   $0x25
  8026d4:	68 c0 31 80 00       	push   $0x8031c0
  8026d9:	e8 60 dc ff ff       	call   80033e <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  8026de:	83 ec 04             	sub    $0x4,%esp
  8026e1:	68 5c 31 80 00       	push   $0x80315c
  8026e6:	6a 22                	push   $0x22
  8026e8:	68 c0 31 80 00       	push   $0x8031c0
  8026ed:	e8 4c dc ff ff       	call   80033e <_panic>

008026f2 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8026f2:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8026f3:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8026f8:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8026fa:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  8026fd:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  802701:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802705:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802708:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  80270a:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  80270e:	83 c4 08             	add    $0x8,%esp
	popal
  802711:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  802712:	83 c4 04             	add    $0x4,%esp
	popfl
  802715:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  802716:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  802717:	c3                   	ret    

00802718 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802718:	f3 0f 1e fb          	endbr32 
  80271c:	55                   	push   %ebp
  80271d:	89 e5                	mov    %esp,%ebp
  80271f:	56                   	push   %esi
  802720:	53                   	push   %ebx
  802721:	8b 75 08             	mov    0x8(%ebp),%esi
  802724:	8b 45 0c             	mov    0xc(%ebp),%eax
  802727:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  80272a:	85 c0                	test   %eax,%eax
  80272c:	74 3d                	je     80276b <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  80272e:	83 ec 0c             	sub    $0xc,%esp
  802731:	50                   	push   %eax
  802732:	e8 06 e9 ff ff       	call   80103d <sys_ipc_recv>
  802737:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  80273a:	85 f6                	test   %esi,%esi
  80273c:	74 0b                	je     802749 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  80273e:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802744:	8b 52 74             	mov    0x74(%edx),%edx
  802747:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  802749:	85 db                	test   %ebx,%ebx
  80274b:	74 0b                	je     802758 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  80274d:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802753:	8b 52 78             	mov    0x78(%edx),%edx
  802756:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  802758:	85 c0                	test   %eax,%eax
  80275a:	78 21                	js     80277d <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  80275c:	a1 08 50 80 00       	mov    0x805008,%eax
  802761:	8b 40 70             	mov    0x70(%eax),%eax
}
  802764:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802767:	5b                   	pop    %ebx
  802768:	5e                   	pop    %esi
  802769:	5d                   	pop    %ebp
  80276a:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  80276b:	83 ec 0c             	sub    $0xc,%esp
  80276e:	68 00 00 c0 ee       	push   $0xeec00000
  802773:	e8 c5 e8 ff ff       	call   80103d <sys_ipc_recv>
  802778:	83 c4 10             	add    $0x10,%esp
  80277b:	eb bd                	jmp    80273a <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  80277d:	85 f6                	test   %esi,%esi
  80277f:	74 10                	je     802791 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802781:	85 db                	test   %ebx,%ebx
  802783:	75 df                	jne    802764 <ipc_recv+0x4c>
  802785:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80278c:	00 00 00 
  80278f:	eb d3                	jmp    802764 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802791:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802798:	00 00 00 
  80279b:	eb e4                	jmp    802781 <ipc_recv+0x69>

0080279d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80279d:	f3 0f 1e fb          	endbr32 
  8027a1:	55                   	push   %ebp
  8027a2:	89 e5                	mov    %esp,%ebp
  8027a4:	57                   	push   %edi
  8027a5:	56                   	push   %esi
  8027a6:	53                   	push   %ebx
  8027a7:	83 ec 0c             	sub    $0xc,%esp
  8027aa:	8b 7d 08             	mov    0x8(%ebp),%edi
  8027ad:	8b 75 0c             	mov    0xc(%ebp),%esi
  8027b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  8027b3:	85 db                	test   %ebx,%ebx
  8027b5:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8027ba:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8027bd:	ff 75 14             	pushl  0x14(%ebp)
  8027c0:	53                   	push   %ebx
  8027c1:	56                   	push   %esi
  8027c2:	57                   	push   %edi
  8027c3:	e8 4e e8 ff ff       	call   801016 <sys_ipc_try_send>
  8027c8:	83 c4 10             	add    $0x10,%esp
  8027cb:	85 c0                	test   %eax,%eax
  8027cd:	79 1e                	jns    8027ed <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  8027cf:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8027d2:	75 07                	jne    8027db <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  8027d4:	e8 75 e6 ff ff       	call   800e4e <sys_yield>
  8027d9:	eb e2                	jmp    8027bd <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  8027db:	50                   	push   %eax
  8027dc:	68 ce 31 80 00       	push   $0x8031ce
  8027e1:	6a 59                	push   $0x59
  8027e3:	68 e9 31 80 00       	push   $0x8031e9
  8027e8:	e8 51 db ff ff       	call   80033e <_panic>
	}
}
  8027ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027f0:	5b                   	pop    %ebx
  8027f1:	5e                   	pop    %esi
  8027f2:	5f                   	pop    %edi
  8027f3:	5d                   	pop    %ebp
  8027f4:	c3                   	ret    

008027f5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8027f5:	f3 0f 1e fb          	endbr32 
  8027f9:	55                   	push   %ebp
  8027fa:	89 e5                	mov    %esp,%ebp
  8027fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8027ff:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802804:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802807:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80280d:	8b 52 50             	mov    0x50(%edx),%edx
  802810:	39 ca                	cmp    %ecx,%edx
  802812:	74 11                	je     802825 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802814:	83 c0 01             	add    $0x1,%eax
  802817:	3d 00 04 00 00       	cmp    $0x400,%eax
  80281c:	75 e6                	jne    802804 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80281e:	b8 00 00 00 00       	mov    $0x0,%eax
  802823:	eb 0b                	jmp    802830 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802825:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802828:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80282d:	8b 40 48             	mov    0x48(%eax),%eax
}
  802830:	5d                   	pop    %ebp
  802831:	c3                   	ret    

00802832 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802832:	f3 0f 1e fb          	endbr32 
  802836:	55                   	push   %ebp
  802837:	89 e5                	mov    %esp,%ebp
  802839:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80283c:	89 c2                	mov    %eax,%edx
  80283e:	c1 ea 16             	shr    $0x16,%edx
  802841:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802848:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80284d:	f6 c1 01             	test   $0x1,%cl
  802850:	74 1c                	je     80286e <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802852:	c1 e8 0c             	shr    $0xc,%eax
  802855:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80285c:	a8 01                	test   $0x1,%al
  80285e:	74 0e                	je     80286e <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802860:	c1 e8 0c             	shr    $0xc,%eax
  802863:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80286a:	ef 
  80286b:	0f b7 d2             	movzwl %dx,%edx
}
  80286e:	89 d0                	mov    %edx,%eax
  802870:	5d                   	pop    %ebp
  802871:	c3                   	ret    
  802872:	66 90                	xchg   %ax,%ax
  802874:	66 90                	xchg   %ax,%ax
  802876:	66 90                	xchg   %ax,%ax
  802878:	66 90                	xchg   %ax,%ax
  80287a:	66 90                	xchg   %ax,%ax
  80287c:	66 90                	xchg   %ax,%ax
  80287e:	66 90                	xchg   %ax,%ax

00802880 <__udivdi3>:
  802880:	f3 0f 1e fb          	endbr32 
  802884:	55                   	push   %ebp
  802885:	57                   	push   %edi
  802886:	56                   	push   %esi
  802887:	53                   	push   %ebx
  802888:	83 ec 1c             	sub    $0x1c,%esp
  80288b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80288f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802893:	8b 74 24 34          	mov    0x34(%esp),%esi
  802897:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80289b:	85 d2                	test   %edx,%edx
  80289d:	75 19                	jne    8028b8 <__udivdi3+0x38>
  80289f:	39 f3                	cmp    %esi,%ebx
  8028a1:	76 4d                	jbe    8028f0 <__udivdi3+0x70>
  8028a3:	31 ff                	xor    %edi,%edi
  8028a5:	89 e8                	mov    %ebp,%eax
  8028a7:	89 f2                	mov    %esi,%edx
  8028a9:	f7 f3                	div    %ebx
  8028ab:	89 fa                	mov    %edi,%edx
  8028ad:	83 c4 1c             	add    $0x1c,%esp
  8028b0:	5b                   	pop    %ebx
  8028b1:	5e                   	pop    %esi
  8028b2:	5f                   	pop    %edi
  8028b3:	5d                   	pop    %ebp
  8028b4:	c3                   	ret    
  8028b5:	8d 76 00             	lea    0x0(%esi),%esi
  8028b8:	39 f2                	cmp    %esi,%edx
  8028ba:	76 14                	jbe    8028d0 <__udivdi3+0x50>
  8028bc:	31 ff                	xor    %edi,%edi
  8028be:	31 c0                	xor    %eax,%eax
  8028c0:	89 fa                	mov    %edi,%edx
  8028c2:	83 c4 1c             	add    $0x1c,%esp
  8028c5:	5b                   	pop    %ebx
  8028c6:	5e                   	pop    %esi
  8028c7:	5f                   	pop    %edi
  8028c8:	5d                   	pop    %ebp
  8028c9:	c3                   	ret    
  8028ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028d0:	0f bd fa             	bsr    %edx,%edi
  8028d3:	83 f7 1f             	xor    $0x1f,%edi
  8028d6:	75 48                	jne    802920 <__udivdi3+0xa0>
  8028d8:	39 f2                	cmp    %esi,%edx
  8028da:	72 06                	jb     8028e2 <__udivdi3+0x62>
  8028dc:	31 c0                	xor    %eax,%eax
  8028de:	39 eb                	cmp    %ebp,%ebx
  8028e0:	77 de                	ja     8028c0 <__udivdi3+0x40>
  8028e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8028e7:	eb d7                	jmp    8028c0 <__udivdi3+0x40>
  8028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028f0:	89 d9                	mov    %ebx,%ecx
  8028f2:	85 db                	test   %ebx,%ebx
  8028f4:	75 0b                	jne    802901 <__udivdi3+0x81>
  8028f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8028fb:	31 d2                	xor    %edx,%edx
  8028fd:	f7 f3                	div    %ebx
  8028ff:	89 c1                	mov    %eax,%ecx
  802901:	31 d2                	xor    %edx,%edx
  802903:	89 f0                	mov    %esi,%eax
  802905:	f7 f1                	div    %ecx
  802907:	89 c6                	mov    %eax,%esi
  802909:	89 e8                	mov    %ebp,%eax
  80290b:	89 f7                	mov    %esi,%edi
  80290d:	f7 f1                	div    %ecx
  80290f:	89 fa                	mov    %edi,%edx
  802911:	83 c4 1c             	add    $0x1c,%esp
  802914:	5b                   	pop    %ebx
  802915:	5e                   	pop    %esi
  802916:	5f                   	pop    %edi
  802917:	5d                   	pop    %ebp
  802918:	c3                   	ret    
  802919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802920:	89 f9                	mov    %edi,%ecx
  802922:	b8 20 00 00 00       	mov    $0x20,%eax
  802927:	29 f8                	sub    %edi,%eax
  802929:	d3 e2                	shl    %cl,%edx
  80292b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80292f:	89 c1                	mov    %eax,%ecx
  802931:	89 da                	mov    %ebx,%edx
  802933:	d3 ea                	shr    %cl,%edx
  802935:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802939:	09 d1                	or     %edx,%ecx
  80293b:	89 f2                	mov    %esi,%edx
  80293d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802941:	89 f9                	mov    %edi,%ecx
  802943:	d3 e3                	shl    %cl,%ebx
  802945:	89 c1                	mov    %eax,%ecx
  802947:	d3 ea                	shr    %cl,%edx
  802949:	89 f9                	mov    %edi,%ecx
  80294b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80294f:	89 eb                	mov    %ebp,%ebx
  802951:	d3 e6                	shl    %cl,%esi
  802953:	89 c1                	mov    %eax,%ecx
  802955:	d3 eb                	shr    %cl,%ebx
  802957:	09 de                	or     %ebx,%esi
  802959:	89 f0                	mov    %esi,%eax
  80295b:	f7 74 24 08          	divl   0x8(%esp)
  80295f:	89 d6                	mov    %edx,%esi
  802961:	89 c3                	mov    %eax,%ebx
  802963:	f7 64 24 0c          	mull   0xc(%esp)
  802967:	39 d6                	cmp    %edx,%esi
  802969:	72 15                	jb     802980 <__udivdi3+0x100>
  80296b:	89 f9                	mov    %edi,%ecx
  80296d:	d3 e5                	shl    %cl,%ebp
  80296f:	39 c5                	cmp    %eax,%ebp
  802971:	73 04                	jae    802977 <__udivdi3+0xf7>
  802973:	39 d6                	cmp    %edx,%esi
  802975:	74 09                	je     802980 <__udivdi3+0x100>
  802977:	89 d8                	mov    %ebx,%eax
  802979:	31 ff                	xor    %edi,%edi
  80297b:	e9 40 ff ff ff       	jmp    8028c0 <__udivdi3+0x40>
  802980:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802983:	31 ff                	xor    %edi,%edi
  802985:	e9 36 ff ff ff       	jmp    8028c0 <__udivdi3+0x40>
  80298a:	66 90                	xchg   %ax,%ax
  80298c:	66 90                	xchg   %ax,%ax
  80298e:	66 90                	xchg   %ax,%ax

00802990 <__umoddi3>:
  802990:	f3 0f 1e fb          	endbr32 
  802994:	55                   	push   %ebp
  802995:	57                   	push   %edi
  802996:	56                   	push   %esi
  802997:	53                   	push   %ebx
  802998:	83 ec 1c             	sub    $0x1c,%esp
  80299b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80299f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8029a3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8029a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029ab:	85 c0                	test   %eax,%eax
  8029ad:	75 19                	jne    8029c8 <__umoddi3+0x38>
  8029af:	39 df                	cmp    %ebx,%edi
  8029b1:	76 5d                	jbe    802a10 <__umoddi3+0x80>
  8029b3:	89 f0                	mov    %esi,%eax
  8029b5:	89 da                	mov    %ebx,%edx
  8029b7:	f7 f7                	div    %edi
  8029b9:	89 d0                	mov    %edx,%eax
  8029bb:	31 d2                	xor    %edx,%edx
  8029bd:	83 c4 1c             	add    $0x1c,%esp
  8029c0:	5b                   	pop    %ebx
  8029c1:	5e                   	pop    %esi
  8029c2:	5f                   	pop    %edi
  8029c3:	5d                   	pop    %ebp
  8029c4:	c3                   	ret    
  8029c5:	8d 76 00             	lea    0x0(%esi),%esi
  8029c8:	89 f2                	mov    %esi,%edx
  8029ca:	39 d8                	cmp    %ebx,%eax
  8029cc:	76 12                	jbe    8029e0 <__umoddi3+0x50>
  8029ce:	89 f0                	mov    %esi,%eax
  8029d0:	89 da                	mov    %ebx,%edx
  8029d2:	83 c4 1c             	add    $0x1c,%esp
  8029d5:	5b                   	pop    %ebx
  8029d6:	5e                   	pop    %esi
  8029d7:	5f                   	pop    %edi
  8029d8:	5d                   	pop    %ebp
  8029d9:	c3                   	ret    
  8029da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029e0:	0f bd e8             	bsr    %eax,%ebp
  8029e3:	83 f5 1f             	xor    $0x1f,%ebp
  8029e6:	75 50                	jne    802a38 <__umoddi3+0xa8>
  8029e8:	39 d8                	cmp    %ebx,%eax
  8029ea:	0f 82 e0 00 00 00    	jb     802ad0 <__umoddi3+0x140>
  8029f0:	89 d9                	mov    %ebx,%ecx
  8029f2:	39 f7                	cmp    %esi,%edi
  8029f4:	0f 86 d6 00 00 00    	jbe    802ad0 <__umoddi3+0x140>
  8029fa:	89 d0                	mov    %edx,%eax
  8029fc:	89 ca                	mov    %ecx,%edx
  8029fe:	83 c4 1c             	add    $0x1c,%esp
  802a01:	5b                   	pop    %ebx
  802a02:	5e                   	pop    %esi
  802a03:	5f                   	pop    %edi
  802a04:	5d                   	pop    %ebp
  802a05:	c3                   	ret    
  802a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a0d:	8d 76 00             	lea    0x0(%esi),%esi
  802a10:	89 fd                	mov    %edi,%ebp
  802a12:	85 ff                	test   %edi,%edi
  802a14:	75 0b                	jne    802a21 <__umoddi3+0x91>
  802a16:	b8 01 00 00 00       	mov    $0x1,%eax
  802a1b:	31 d2                	xor    %edx,%edx
  802a1d:	f7 f7                	div    %edi
  802a1f:	89 c5                	mov    %eax,%ebp
  802a21:	89 d8                	mov    %ebx,%eax
  802a23:	31 d2                	xor    %edx,%edx
  802a25:	f7 f5                	div    %ebp
  802a27:	89 f0                	mov    %esi,%eax
  802a29:	f7 f5                	div    %ebp
  802a2b:	89 d0                	mov    %edx,%eax
  802a2d:	31 d2                	xor    %edx,%edx
  802a2f:	eb 8c                	jmp    8029bd <__umoddi3+0x2d>
  802a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a38:	89 e9                	mov    %ebp,%ecx
  802a3a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a3f:	29 ea                	sub    %ebp,%edx
  802a41:	d3 e0                	shl    %cl,%eax
  802a43:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a47:	89 d1                	mov    %edx,%ecx
  802a49:	89 f8                	mov    %edi,%eax
  802a4b:	d3 e8                	shr    %cl,%eax
  802a4d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a51:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a55:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a59:	09 c1                	or     %eax,%ecx
  802a5b:	89 d8                	mov    %ebx,%eax
  802a5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a61:	89 e9                	mov    %ebp,%ecx
  802a63:	d3 e7                	shl    %cl,%edi
  802a65:	89 d1                	mov    %edx,%ecx
  802a67:	d3 e8                	shr    %cl,%eax
  802a69:	89 e9                	mov    %ebp,%ecx
  802a6b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a6f:	d3 e3                	shl    %cl,%ebx
  802a71:	89 c7                	mov    %eax,%edi
  802a73:	89 d1                	mov    %edx,%ecx
  802a75:	89 f0                	mov    %esi,%eax
  802a77:	d3 e8                	shr    %cl,%eax
  802a79:	89 e9                	mov    %ebp,%ecx
  802a7b:	89 fa                	mov    %edi,%edx
  802a7d:	d3 e6                	shl    %cl,%esi
  802a7f:	09 d8                	or     %ebx,%eax
  802a81:	f7 74 24 08          	divl   0x8(%esp)
  802a85:	89 d1                	mov    %edx,%ecx
  802a87:	89 f3                	mov    %esi,%ebx
  802a89:	f7 64 24 0c          	mull   0xc(%esp)
  802a8d:	89 c6                	mov    %eax,%esi
  802a8f:	89 d7                	mov    %edx,%edi
  802a91:	39 d1                	cmp    %edx,%ecx
  802a93:	72 06                	jb     802a9b <__umoddi3+0x10b>
  802a95:	75 10                	jne    802aa7 <__umoddi3+0x117>
  802a97:	39 c3                	cmp    %eax,%ebx
  802a99:	73 0c                	jae    802aa7 <__umoddi3+0x117>
  802a9b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802a9f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802aa3:	89 d7                	mov    %edx,%edi
  802aa5:	89 c6                	mov    %eax,%esi
  802aa7:	89 ca                	mov    %ecx,%edx
  802aa9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802aae:	29 f3                	sub    %esi,%ebx
  802ab0:	19 fa                	sbb    %edi,%edx
  802ab2:	89 d0                	mov    %edx,%eax
  802ab4:	d3 e0                	shl    %cl,%eax
  802ab6:	89 e9                	mov    %ebp,%ecx
  802ab8:	d3 eb                	shr    %cl,%ebx
  802aba:	d3 ea                	shr    %cl,%edx
  802abc:	09 d8                	or     %ebx,%eax
  802abe:	83 c4 1c             	add    $0x1c,%esp
  802ac1:	5b                   	pop    %ebx
  802ac2:	5e                   	pop    %esi
  802ac3:	5f                   	pop    %edi
  802ac4:	5d                   	pop    %ebp
  802ac5:	c3                   	ret    
  802ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802acd:	8d 76 00             	lea    0x0(%esi),%esi
  802ad0:	29 fe                	sub    %edi,%esi
  802ad2:	19 c3                	sbb    %eax,%ebx
  802ad4:	89 f2                	mov    %esi,%edx
  802ad6:	89 d9                	mov    %ebx,%ecx
  802ad8:	e9 1d ff ff ff       	jmp    8029fa <__umoddi3+0x6a>
