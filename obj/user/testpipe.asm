
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
  80003f:	c7 05 04 30 80 00 80 	movl   $0x802580,0x803004
  800046:	25 80 00 

	if ((i = pipe(p)) < 0)
  800049:	8d 45 8c             	lea    -0x74(%ebp),%eax
  80004c:	50                   	push   %eax
  80004d:	e8 54 1d 00 00       	call   801da6 <pipe>
  800052:	89 c6                	mov    %eax,%esi
  800054:	83 c4 10             	add    $0x10,%esp
  800057:	85 c0                	test   %eax,%eax
  800059:	0f 88 1b 01 00 00    	js     80017a <umain+0x147>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80005f:	e8 fe 10 00 00       	call   801162 <fork>
  800064:	89 c3                	mov    %eax,%ebx
  800066:	85 c0                	test   %eax,%eax
  800068:	0f 88 1e 01 00 00    	js     80018c <umain+0x159>
		panic("fork: %e", i);

	if (pid == 0) {
  80006e:	0f 85 56 01 00 00    	jne    8001ca <umain+0x197>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800074:	a1 04 40 80 00       	mov    0x804004,%eax
  800079:	8b 40 48             	mov    0x48(%eax),%eax
  80007c:	83 ec 04             	sub    $0x4,%esp
  80007f:	ff 75 90             	pushl  -0x70(%ebp)
  800082:	50                   	push   %eax
  800083:	68 a5 25 80 00       	push   $0x8025a5
  800088:	e8 98 03 00 00       	call   800425 <cprintf>
		close(p[1]);
  80008d:	83 c4 04             	add    $0x4,%esp
  800090:	ff 75 90             	pushl  -0x70(%ebp)
  800093:	e8 a1 14 00 00       	call   801539 <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800098:	a1 04 40 80 00       	mov    0x804004,%eax
  80009d:	8b 40 48             	mov    0x48(%eax),%eax
  8000a0:	83 c4 0c             	add    $0xc,%esp
  8000a3:	ff 75 8c             	pushl  -0x74(%ebp)
  8000a6:	50                   	push   %eax
  8000a7:	68 c2 25 80 00       	push   $0x8025c2
  8000ac:	e8 74 03 00 00       	call   800425 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000b1:	83 c4 0c             	add    $0xc,%esp
  8000b4:	6a 63                	push   $0x63
  8000b6:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000b9:	50                   	push   %eax
  8000ba:	ff 75 8c             	pushl  -0x74(%ebp)
  8000bd:	e8 4c 16 00 00       	call   80170e <readn>
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
  8000d7:	ff 35 00 30 80 00    	pushl  0x803000
  8000dd:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000e0:	50                   	push   %eax
  8000e1:	e8 08 0a 00 00       	call   800aee <strcmp>
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	85 c0                	test   %eax,%eax
  8000eb:	0f 85 bf 00 00 00    	jne    8001b0 <umain+0x17d>
			cprintf("\npipe read closed properly\n");
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	68 e8 25 80 00       	push   $0x8025e8
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
  80010a:	e8 1c 1e 00 00       	call   801f2b <wait>

	binaryname = "pipewriteeof";
  80010f:	c7 05 04 30 80 00 3e 	movl   $0x80263e,0x803004
  800116:	26 80 00 
	if ((i = pipe(p)) < 0)
  800119:	8d 45 8c             	lea    -0x74(%ebp),%eax
  80011c:	89 04 24             	mov    %eax,(%esp)
  80011f:	e8 82 1c 00 00       	call   801da6 <pipe>
  800124:	89 c6                	mov    %eax,%esi
  800126:	83 c4 10             	add    $0x10,%esp
  800129:	85 c0                	test   %eax,%eax
  80012b:	0f 88 32 01 00 00    	js     800263 <umain+0x230>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  800131:	e8 2c 10 00 00       	call   801162 <fork>
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
  80014c:	e8 e8 13 00 00       	call   801539 <close>
	close(p[1]);
  800151:	83 c4 04             	add    $0x4,%esp
  800154:	ff 75 90             	pushl  -0x70(%ebp)
  800157:	e8 dd 13 00 00       	call   801539 <close>
	wait(pid);
  80015c:	89 1c 24             	mov    %ebx,(%esp)
  80015f:	e8 c7 1d 00 00       	call   801f2b <wait>

	cprintf("pipe tests passed\n");
  800164:	c7 04 24 6c 26 80 00 	movl   $0x80266c,(%esp)
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
  80017b:	68 8c 25 80 00       	push   $0x80258c
  800180:	6a 0e                	push   $0xe
  800182:	68 95 25 80 00       	push   $0x802595
  800187:	e8 b2 01 00 00       	call   80033e <_panic>
		panic("fork: %e", i);
  80018c:	56                   	push   %esi
  80018d:	68 65 2a 80 00       	push   $0x802a65
  800192:	6a 11                	push   $0x11
  800194:	68 95 25 80 00       	push   $0x802595
  800199:	e8 a0 01 00 00       	call   80033e <_panic>
			panic("read: %e", i);
  80019e:	50                   	push   %eax
  80019f:	68 df 25 80 00       	push   $0x8025df
  8001a4:	6a 19                	push   $0x19
  8001a6:	68 95 25 80 00       	push   $0x802595
  8001ab:	e8 8e 01 00 00       	call   80033e <_panic>
			cprintf("\ngot %d bytes: %s\n", i, buf);
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b6:	50                   	push   %eax
  8001b7:	56                   	push   %esi
  8001b8:	68 04 26 80 00       	push   $0x802604
  8001bd:	e8 63 02 00 00       	call   800425 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
  8001c5:	e9 37 ff ff ff       	jmp    800101 <umain+0xce>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8001ca:	a1 04 40 80 00       	mov    0x804004,%eax
  8001cf:	8b 40 48             	mov    0x48(%eax),%eax
  8001d2:	83 ec 04             	sub    $0x4,%esp
  8001d5:	ff 75 8c             	pushl  -0x74(%ebp)
  8001d8:	50                   	push   %eax
  8001d9:	68 a5 25 80 00       	push   $0x8025a5
  8001de:	e8 42 02 00 00       	call   800425 <cprintf>
		close(p[0]);
  8001e3:	83 c4 04             	add    $0x4,%esp
  8001e6:	ff 75 8c             	pushl  -0x74(%ebp)
  8001e9:	e8 4b 13 00 00       	call   801539 <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001ee:	a1 04 40 80 00       	mov    0x804004,%eax
  8001f3:	8b 40 48             	mov    0x48(%eax),%eax
  8001f6:	83 c4 0c             	add    $0xc,%esp
  8001f9:	ff 75 90             	pushl  -0x70(%ebp)
  8001fc:	50                   	push   %eax
  8001fd:	68 17 26 80 00       	push   $0x802617
  800202:	e8 1e 02 00 00       	call   800425 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800207:	83 c4 04             	add    $0x4,%esp
  80020a:	ff 35 00 30 80 00    	pushl  0x803000
  800210:	e8 d7 07 00 00       	call   8009ec <strlen>
  800215:	83 c4 0c             	add    $0xc,%esp
  800218:	50                   	push   %eax
  800219:	ff 35 00 30 80 00    	pushl  0x803000
  80021f:	ff 75 90             	pushl  -0x70(%ebp)
  800222:	e8 32 15 00 00       	call   801759 <write>
  800227:	89 c6                	mov    %eax,%esi
  800229:	83 c4 04             	add    $0x4,%esp
  80022c:	ff 35 00 30 80 00    	pushl  0x803000
  800232:	e8 b5 07 00 00       	call   8009ec <strlen>
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	39 f0                	cmp    %esi,%eax
  80023c:	75 13                	jne    800251 <umain+0x21e>
		close(p[1]);
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	ff 75 90             	pushl  -0x70(%ebp)
  800244:	e8 f0 12 00 00       	call   801539 <close>
  800249:	83 c4 10             	add    $0x10,%esp
  80024c:	e9 b5 fe ff ff       	jmp    800106 <umain+0xd3>
			panic("write: %e", i);
  800251:	56                   	push   %esi
  800252:	68 34 26 80 00       	push   $0x802634
  800257:	6a 25                	push   $0x25
  800259:	68 95 25 80 00       	push   $0x802595
  80025e:	e8 db 00 00 00       	call   80033e <_panic>
		panic("pipe: %e", i);
  800263:	50                   	push   %eax
  800264:	68 8c 25 80 00       	push   $0x80258c
  800269:	6a 2c                	push   $0x2c
  80026b:	68 95 25 80 00       	push   $0x802595
  800270:	e8 c9 00 00 00       	call   80033e <_panic>
		panic("fork: %e", i);
  800275:	56                   	push   %esi
  800276:	68 65 2a 80 00       	push   $0x802a65
  80027b:	6a 2f                	push   $0x2f
  80027d:	68 95 25 80 00       	push   $0x802595
  800282:	e8 b7 00 00 00       	call   80033e <_panic>
		close(p[0]);
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	ff 75 8c             	pushl  -0x74(%ebp)
  80028d:	e8 a7 12 00 00       	call   801539 <close>
  800292:	83 c4 10             	add    $0x10,%esp
			cprintf(".");
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	68 4b 26 80 00       	push   $0x80264b
  80029d:	e8 83 01 00 00       	call   800425 <cprintf>
			if (write(p[1], "x", 1) != 1)
  8002a2:	83 c4 0c             	add    $0xc,%esp
  8002a5:	6a 01                	push   $0x1
  8002a7:	68 4d 26 80 00       	push   $0x80264d
  8002ac:	ff 75 90             	pushl  -0x70(%ebp)
  8002af:	e8 a5 14 00 00       	call   801759 <write>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	83 f8 01             	cmp    $0x1,%eax
  8002ba:	74 d9                	je     800295 <umain+0x262>
		cprintf("\npipe write closed properly\n");
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 4f 26 80 00       	push   $0x80264f
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
  8002f7:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002fc:	85 db                	test   %ebx,%ebx
  8002fe:	7e 07                	jle    800307 <libmain+0x31>
		binaryname = argv[0];
  800300:	8b 06                	mov    (%esi),%eax
  800302:	a3 04 30 80 00       	mov    %eax,0x803004

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
  80032a:	e8 3b 12 00 00       	call   80156a <close_all>
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
  80034a:	8b 35 04 30 80 00    	mov    0x803004,%esi
  800350:	e8 d6 0a 00 00       	call   800e2b <sys_getenvid>
  800355:	83 ec 0c             	sub    $0xc,%esp
  800358:	ff 75 0c             	pushl  0xc(%ebp)
  80035b:	ff 75 08             	pushl  0x8(%ebp)
  80035e:	56                   	push   %esi
  80035f:	50                   	push   %eax
  800360:	68 d0 26 80 00       	push   $0x8026d0
  800365:	e8 bb 00 00 00       	call   800425 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80036a:	83 c4 18             	add    $0x18,%esp
  80036d:	53                   	push   %ebx
  80036e:	ff 75 10             	pushl  0x10(%ebp)
  800371:	e8 5a 00 00 00       	call   8003d0 <vcprintf>
	cprintf("\n");
  800376:	c7 04 24 c0 25 80 00 	movl   $0x8025c0,(%esp)
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
  80048b:	e8 80 1e 00 00       	call   802310 <__udivdi3>
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
  8004c9:	e8 52 1f 00 00       	call   802420 <__umoddi3>
  8004ce:	83 c4 14             	add    $0x14,%esp
  8004d1:	0f be 80 f3 26 80 00 	movsbl 0x8026f3(%eax),%eax
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
  800578:	3e ff 24 85 40 28 80 	notrack jmp *0x802840(,%eax,4)
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
  800645:	8b 14 85 a0 29 80 00 	mov    0x8029a0(,%eax,4),%edx
  80064c:	85 d2                	test   %edx,%edx
  80064e:	74 18                	je     800668 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800650:	52                   	push   %edx
  800651:	68 61 2b 80 00       	push   $0x802b61
  800656:	53                   	push   %ebx
  800657:	56                   	push   %esi
  800658:	e8 aa fe ff ff       	call   800507 <printfmt>
  80065d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800660:	89 7d 14             	mov    %edi,0x14(%ebp)
  800663:	e9 66 02 00 00       	jmp    8008ce <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800668:	50                   	push   %eax
  800669:	68 0b 27 80 00       	push   $0x80270b
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
  800690:	b8 04 27 80 00       	mov    $0x802704,%eax
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
  800e1a:	68 ff 29 80 00       	push   $0x8029ff
  800e1f:	6a 23                	push   $0x23
  800e21:	68 1c 2a 80 00       	push   $0x802a1c
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
  800ea7:	68 ff 29 80 00       	push   $0x8029ff
  800eac:	6a 23                	push   $0x23
  800eae:	68 1c 2a 80 00       	push   $0x802a1c
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
  800eed:	68 ff 29 80 00       	push   $0x8029ff
  800ef2:	6a 23                	push   $0x23
  800ef4:	68 1c 2a 80 00       	push   $0x802a1c
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
  800f33:	68 ff 29 80 00       	push   $0x8029ff
  800f38:	6a 23                	push   $0x23
  800f3a:	68 1c 2a 80 00       	push   $0x802a1c
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
  800f79:	68 ff 29 80 00       	push   $0x8029ff
  800f7e:	6a 23                	push   $0x23
  800f80:	68 1c 2a 80 00       	push   $0x802a1c
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
  800fbf:	68 ff 29 80 00       	push   $0x8029ff
  800fc4:	6a 23                	push   $0x23
  800fc6:	68 1c 2a 80 00       	push   $0x802a1c
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
  801005:	68 ff 29 80 00       	push   $0x8029ff
  80100a:	6a 23                	push   $0x23
  80100c:	68 1c 2a 80 00       	push   $0x802a1c
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
  801071:	68 ff 29 80 00       	push   $0x8029ff
  801076:	6a 23                	push   $0x23
  801078:	68 1c 2a 80 00       	push   $0x802a1c
  80107d:	e8 bc f2 ff ff       	call   80033e <_panic>

00801082 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801082:	f3 0f 1e fb          	endbr32 
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	53                   	push   %ebx
  80108a:	83 ec 04             	sub    $0x4,%esp
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801090:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  801092:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801096:	74 74                	je     80110c <pgfault+0x8a>
  801098:	89 d8                	mov    %ebx,%eax
  80109a:	c1 e8 0c             	shr    $0xc,%eax
  80109d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010a4:	f6 c4 08             	test   $0x8,%ah
  8010a7:	74 63                	je     80110c <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  8010a9:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  8010af:	83 ec 0c             	sub    $0xc,%esp
  8010b2:	6a 05                	push   $0x5
  8010b4:	68 00 f0 7f 00       	push   $0x7ff000
  8010b9:	6a 00                	push   $0x0
  8010bb:	53                   	push   %ebx
  8010bc:	6a 00                	push   $0x0
  8010be:	e8 f5 fd ff ff       	call   800eb8 <sys_page_map>
  8010c3:	83 c4 20             	add    $0x20,%esp
  8010c6:	85 c0                	test   %eax,%eax
  8010c8:	78 59                	js     801123 <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  8010ca:	83 ec 04             	sub    $0x4,%esp
  8010cd:	6a 07                	push   $0x7
  8010cf:	53                   	push   %ebx
  8010d0:	6a 00                	push   $0x0
  8010d2:	e8 9a fd ff ff       	call   800e71 <sys_page_alloc>
  8010d7:	83 c4 10             	add    $0x10,%esp
  8010da:	85 c0                	test   %eax,%eax
  8010dc:	78 5a                	js     801138 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  8010de:	83 ec 04             	sub    $0x4,%esp
  8010e1:	68 00 10 00 00       	push   $0x1000
  8010e6:	68 00 f0 7f 00       	push   $0x7ff000
  8010eb:	53                   	push   %ebx
  8010ec:	e8 f4 fa ff ff       	call   800be5 <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  8010f1:	83 c4 08             	add    $0x8,%esp
  8010f4:	68 00 f0 7f 00       	push   $0x7ff000
  8010f9:	6a 00                	push   $0x0
  8010fb:	e8 fe fd ff ff       	call   800efe <sys_page_unmap>
  801100:	83 c4 10             	add    $0x10,%esp
  801103:	85 c0                	test   %eax,%eax
  801105:	78 46                	js     80114d <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  801107:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  80110c:	83 ec 04             	sub    $0x4,%esp
  80110f:	68 2a 2a 80 00       	push   $0x802a2a
  801114:	68 d3 00 00 00       	push   $0xd3
  801119:	68 46 2a 80 00       	push   $0x802a46
  80111e:	e8 1b f2 ff ff       	call   80033e <_panic>
		panic("pgfault: %e\n", r);
  801123:	50                   	push   %eax
  801124:	68 51 2a 80 00       	push   $0x802a51
  801129:	68 df 00 00 00       	push   $0xdf
  80112e:	68 46 2a 80 00       	push   $0x802a46
  801133:	e8 06 f2 ff ff       	call   80033e <_panic>
		panic("pgfault: %e\n", r);
  801138:	50                   	push   %eax
  801139:	68 51 2a 80 00       	push   $0x802a51
  80113e:	68 e3 00 00 00       	push   $0xe3
  801143:	68 46 2a 80 00       	push   $0x802a46
  801148:	e8 f1 f1 ff ff       	call   80033e <_panic>
		panic("pgfault: %e\n", r);
  80114d:	50                   	push   %eax
  80114e:	68 51 2a 80 00       	push   $0x802a51
  801153:	68 e9 00 00 00       	push   $0xe9
  801158:	68 46 2a 80 00       	push   $0x802a46
  80115d:	e8 dc f1 ff ff       	call   80033e <_panic>

00801162 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801162:	f3 0f 1e fb          	endbr32 
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	57                   	push   %edi
  80116a:	56                   	push   %esi
  80116b:	53                   	push   %ebx
  80116c:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  80116f:	68 82 10 80 00       	push   $0x801082
  801174:	e8 9a 0f 00 00       	call   802113 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801179:	b8 07 00 00 00       	mov    $0x7,%eax
  80117e:	cd 30                	int    $0x30
  801180:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  801183:	83 c4 10             	add    $0x10,%esp
  801186:	85 c0                	test   %eax,%eax
  801188:	78 2d                	js     8011b7 <fork+0x55>
  80118a:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80118c:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801191:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801195:	0f 85 9b 00 00 00    	jne    801236 <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  80119b:	e8 8b fc ff ff       	call   800e2b <sys_getenvid>
  8011a0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011a5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011ad:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8011b2:	e9 71 01 00 00       	jmp    801328 <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  8011b7:	50                   	push   %eax
  8011b8:	68 5e 2a 80 00       	push   $0x802a5e
  8011bd:	68 2a 01 00 00       	push   $0x12a
  8011c2:	68 46 2a 80 00       	push   $0x802a46
  8011c7:	e8 72 f1 ff ff       	call   80033e <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  8011cc:	c1 e6 0c             	shl    $0xc,%esi
  8011cf:	83 ec 0c             	sub    $0xc,%esp
  8011d2:	68 07 0e 00 00       	push   $0xe07
  8011d7:	56                   	push   %esi
  8011d8:	57                   	push   %edi
  8011d9:	56                   	push   %esi
  8011da:	6a 00                	push   $0x0
  8011dc:	e8 d7 fc ff ff       	call   800eb8 <sys_page_map>
  8011e1:	83 c4 20             	add    $0x20,%esp
  8011e4:	eb 3e                	jmp    801224 <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  8011e6:	c1 e6 0c             	shl    $0xc,%esi
  8011e9:	83 ec 0c             	sub    $0xc,%esp
  8011ec:	68 05 08 00 00       	push   $0x805
  8011f1:	56                   	push   %esi
  8011f2:	57                   	push   %edi
  8011f3:	56                   	push   %esi
  8011f4:	6a 00                	push   $0x0
  8011f6:	e8 bd fc ff ff       	call   800eb8 <sys_page_map>
  8011fb:	83 c4 20             	add    $0x20,%esp
  8011fe:	85 c0                	test   %eax,%eax
  801200:	0f 88 bc 00 00 00    	js     8012c2 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  801206:	83 ec 0c             	sub    $0xc,%esp
  801209:	68 05 08 00 00       	push   $0x805
  80120e:	56                   	push   %esi
  80120f:	6a 00                	push   $0x0
  801211:	56                   	push   %esi
  801212:	6a 00                	push   $0x0
  801214:	e8 9f fc ff ff       	call   800eb8 <sys_page_map>
  801219:	83 c4 20             	add    $0x20,%esp
  80121c:	85 c0                	test   %eax,%eax
  80121e:	0f 88 b3 00 00 00    	js     8012d7 <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801224:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80122a:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801230:	0f 84 b6 00 00 00    	je     8012ec <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  801236:	89 d8                	mov    %ebx,%eax
  801238:	c1 e8 16             	shr    $0x16,%eax
  80123b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801242:	a8 01                	test   $0x1,%al
  801244:	74 de                	je     801224 <fork+0xc2>
  801246:	89 de                	mov    %ebx,%esi
  801248:	c1 ee 0c             	shr    $0xc,%esi
  80124b:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801252:	a8 01                	test   $0x1,%al
  801254:	74 ce                	je     801224 <fork+0xc2>
  801256:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80125d:	a8 04                	test   $0x4,%al
  80125f:	74 c3                	je     801224 <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  801261:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801268:	f6 c4 04             	test   $0x4,%ah
  80126b:	0f 85 5b ff ff ff    	jne    8011cc <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  801271:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801278:	a8 02                	test   $0x2,%al
  80127a:	0f 85 66 ff ff ff    	jne    8011e6 <fork+0x84>
  801280:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801287:	f6 c4 08             	test   $0x8,%ah
  80128a:	0f 85 56 ff ff ff    	jne    8011e6 <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801290:	c1 e6 0c             	shl    $0xc,%esi
  801293:	83 ec 0c             	sub    $0xc,%esp
  801296:	6a 05                	push   $0x5
  801298:	56                   	push   %esi
  801299:	57                   	push   %edi
  80129a:	56                   	push   %esi
  80129b:	6a 00                	push   $0x0
  80129d:	e8 16 fc ff ff       	call   800eb8 <sys_page_map>
  8012a2:	83 c4 20             	add    $0x20,%esp
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	0f 89 77 ff ff ff    	jns    801224 <fork+0xc2>
		panic("duppage: %e\n", r);
  8012ad:	50                   	push   %eax
  8012ae:	68 6e 2a 80 00       	push   $0x802a6e
  8012b3:	68 0c 01 00 00       	push   $0x10c
  8012b8:	68 46 2a 80 00       	push   $0x802a46
  8012bd:	e8 7c f0 ff ff       	call   80033e <_panic>
			panic("duppage: %e\n", r);
  8012c2:	50                   	push   %eax
  8012c3:	68 6e 2a 80 00       	push   $0x802a6e
  8012c8:	68 05 01 00 00       	push   $0x105
  8012cd:	68 46 2a 80 00       	push   $0x802a46
  8012d2:	e8 67 f0 ff ff       	call   80033e <_panic>
			panic("duppage: %e\n", r);
  8012d7:	50                   	push   %eax
  8012d8:	68 6e 2a 80 00       	push   $0x802a6e
  8012dd:	68 09 01 00 00       	push   $0x109
  8012e2:	68 46 2a 80 00       	push   $0x802a46
  8012e7:	e8 52 f0 ff ff       	call   80033e <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  8012ec:	83 ec 04             	sub    $0x4,%esp
  8012ef:	6a 07                	push   $0x7
  8012f1:	68 00 f0 bf ee       	push   $0xeebff000
  8012f6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012f9:	e8 73 fb ff ff       	call   800e71 <sys_page_alloc>
  8012fe:	83 c4 10             	add    $0x10,%esp
  801301:	85 c0                	test   %eax,%eax
  801303:	78 2e                	js     801333 <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801305:	83 ec 08             	sub    $0x8,%esp
  801308:	68 86 21 80 00       	push   $0x802186
  80130d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801310:	57                   	push   %edi
  801311:	e8 ba fc ff ff       	call   800fd0 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801316:	83 c4 08             	add    $0x8,%esp
  801319:	6a 02                	push   $0x2
  80131b:	57                   	push   %edi
  80131c:	e8 23 fc ff ff       	call   800f44 <sys_env_set_status>
  801321:	83 c4 10             	add    $0x10,%esp
  801324:	85 c0                	test   %eax,%eax
  801326:	78 20                	js     801348 <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  801328:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80132b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80132e:	5b                   	pop    %ebx
  80132f:	5e                   	pop    %esi
  801330:	5f                   	pop    %edi
  801331:	5d                   	pop    %ebp
  801332:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801333:	50                   	push   %eax
  801334:	68 7b 2a 80 00       	push   $0x802a7b
  801339:	68 3e 01 00 00       	push   $0x13e
  80133e:	68 46 2a 80 00       	push   $0x802a46
  801343:	e8 f6 ef ff ff       	call   80033e <_panic>
		panic("sys_env_set_status: %e", r);
  801348:	50                   	push   %eax
  801349:	68 8e 2a 80 00       	push   $0x802a8e
  80134e:	68 43 01 00 00       	push   $0x143
  801353:	68 46 2a 80 00       	push   $0x802a46
  801358:	e8 e1 ef ff ff       	call   80033e <_panic>

0080135d <sfork>:

// Challenge!
int
sfork(void)
{
  80135d:	f3 0f 1e fb          	endbr32 
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
  801364:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801367:	68 a5 2a 80 00       	push   $0x802aa5
  80136c:	68 4c 01 00 00       	push   $0x14c
  801371:	68 46 2a 80 00       	push   $0x802a46
  801376:	e8 c3 ef ff ff       	call   80033e <_panic>

0080137b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80137b:	f3 0f 1e fb          	endbr32 
  80137f:	55                   	push   %ebp
  801380:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	05 00 00 00 30       	add    $0x30000000,%eax
  80138a:	c1 e8 0c             	shr    $0xc,%eax
}
  80138d:	5d                   	pop    %ebp
  80138e:	c3                   	ret    

0080138f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80138f:	f3 0f 1e fb          	endbr32 
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80139e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013a3:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013a8:	5d                   	pop    %ebp
  8013a9:	c3                   	ret    

008013aa <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013aa:	f3 0f 1e fb          	endbr32 
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
  8013b1:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013b6:	89 c2                	mov    %eax,%edx
  8013b8:	c1 ea 16             	shr    $0x16,%edx
  8013bb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013c2:	f6 c2 01             	test   $0x1,%dl
  8013c5:	74 2d                	je     8013f4 <fd_alloc+0x4a>
  8013c7:	89 c2                	mov    %eax,%edx
  8013c9:	c1 ea 0c             	shr    $0xc,%edx
  8013cc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013d3:	f6 c2 01             	test   $0x1,%dl
  8013d6:	74 1c                	je     8013f4 <fd_alloc+0x4a>
  8013d8:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8013dd:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013e2:	75 d2                	jne    8013b6 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8013ed:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8013f2:	eb 0a                	jmp    8013fe <fd_alloc+0x54>
			*fd_store = fd;
  8013f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013f7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013fe:	5d                   	pop    %ebp
  8013ff:	c3                   	ret    

00801400 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801400:	f3 0f 1e fb          	endbr32 
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80140a:	83 f8 1f             	cmp    $0x1f,%eax
  80140d:	77 30                	ja     80143f <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80140f:	c1 e0 0c             	shl    $0xc,%eax
  801412:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801417:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80141d:	f6 c2 01             	test   $0x1,%dl
  801420:	74 24                	je     801446 <fd_lookup+0x46>
  801422:	89 c2                	mov    %eax,%edx
  801424:	c1 ea 0c             	shr    $0xc,%edx
  801427:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80142e:	f6 c2 01             	test   $0x1,%dl
  801431:	74 1a                	je     80144d <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801433:	8b 55 0c             	mov    0xc(%ebp),%edx
  801436:	89 02                	mov    %eax,(%edx)
	return 0;
  801438:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80143d:	5d                   	pop    %ebp
  80143e:	c3                   	ret    
		return -E_INVAL;
  80143f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801444:	eb f7                	jmp    80143d <fd_lookup+0x3d>
		return -E_INVAL;
  801446:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80144b:	eb f0                	jmp    80143d <fd_lookup+0x3d>
  80144d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801452:	eb e9                	jmp    80143d <fd_lookup+0x3d>

00801454 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801454:	f3 0f 1e fb          	endbr32 
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
  80145b:	83 ec 08             	sub    $0x8,%esp
  80145e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801461:	ba 38 2b 80 00       	mov    $0x802b38,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801466:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  80146b:	39 08                	cmp    %ecx,(%eax)
  80146d:	74 33                	je     8014a2 <dev_lookup+0x4e>
  80146f:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801472:	8b 02                	mov    (%edx),%eax
  801474:	85 c0                	test   %eax,%eax
  801476:	75 f3                	jne    80146b <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801478:	a1 04 40 80 00       	mov    0x804004,%eax
  80147d:	8b 40 48             	mov    0x48(%eax),%eax
  801480:	83 ec 04             	sub    $0x4,%esp
  801483:	51                   	push   %ecx
  801484:	50                   	push   %eax
  801485:	68 bc 2a 80 00       	push   $0x802abc
  80148a:	e8 96 ef ff ff       	call   800425 <cprintf>
	*dev = 0;
  80148f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801492:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801498:	83 c4 10             	add    $0x10,%esp
  80149b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014a0:	c9                   	leave  
  8014a1:	c3                   	ret    
			*dev = devtab[i];
  8014a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014a5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ac:	eb f2                	jmp    8014a0 <dev_lookup+0x4c>

008014ae <fd_close>:
{
  8014ae:	f3 0f 1e fb          	endbr32 
  8014b2:	55                   	push   %ebp
  8014b3:	89 e5                	mov    %esp,%ebp
  8014b5:	57                   	push   %edi
  8014b6:	56                   	push   %esi
  8014b7:	53                   	push   %ebx
  8014b8:	83 ec 24             	sub    $0x24,%esp
  8014bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8014be:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014c1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014c4:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014c5:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014cb:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014ce:	50                   	push   %eax
  8014cf:	e8 2c ff ff ff       	call   801400 <fd_lookup>
  8014d4:	89 c3                	mov    %eax,%ebx
  8014d6:	83 c4 10             	add    $0x10,%esp
  8014d9:	85 c0                	test   %eax,%eax
  8014db:	78 05                	js     8014e2 <fd_close+0x34>
	    || fd != fd2)
  8014dd:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8014e0:	74 16                	je     8014f8 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8014e2:	89 f8                	mov    %edi,%eax
  8014e4:	84 c0                	test   %al,%al
  8014e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014eb:	0f 44 d8             	cmove  %eax,%ebx
}
  8014ee:	89 d8                	mov    %ebx,%eax
  8014f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014f3:	5b                   	pop    %ebx
  8014f4:	5e                   	pop    %esi
  8014f5:	5f                   	pop    %edi
  8014f6:	5d                   	pop    %ebp
  8014f7:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014f8:	83 ec 08             	sub    $0x8,%esp
  8014fb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014fe:	50                   	push   %eax
  8014ff:	ff 36                	pushl  (%esi)
  801501:	e8 4e ff ff ff       	call   801454 <dev_lookup>
  801506:	89 c3                	mov    %eax,%ebx
  801508:	83 c4 10             	add    $0x10,%esp
  80150b:	85 c0                	test   %eax,%eax
  80150d:	78 1a                	js     801529 <fd_close+0x7b>
		if (dev->dev_close)
  80150f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801512:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801515:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80151a:	85 c0                	test   %eax,%eax
  80151c:	74 0b                	je     801529 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80151e:	83 ec 0c             	sub    $0xc,%esp
  801521:	56                   	push   %esi
  801522:	ff d0                	call   *%eax
  801524:	89 c3                	mov    %eax,%ebx
  801526:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801529:	83 ec 08             	sub    $0x8,%esp
  80152c:	56                   	push   %esi
  80152d:	6a 00                	push   $0x0
  80152f:	e8 ca f9 ff ff       	call   800efe <sys_page_unmap>
	return r;
  801534:	83 c4 10             	add    $0x10,%esp
  801537:	eb b5                	jmp    8014ee <fd_close+0x40>

00801539 <close>:

int
close(int fdnum)
{
  801539:	f3 0f 1e fb          	endbr32 
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
  801540:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801543:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801546:	50                   	push   %eax
  801547:	ff 75 08             	pushl  0x8(%ebp)
  80154a:	e8 b1 fe ff ff       	call   801400 <fd_lookup>
  80154f:	83 c4 10             	add    $0x10,%esp
  801552:	85 c0                	test   %eax,%eax
  801554:	79 02                	jns    801558 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801556:	c9                   	leave  
  801557:	c3                   	ret    
		return fd_close(fd, 1);
  801558:	83 ec 08             	sub    $0x8,%esp
  80155b:	6a 01                	push   $0x1
  80155d:	ff 75 f4             	pushl  -0xc(%ebp)
  801560:	e8 49 ff ff ff       	call   8014ae <fd_close>
  801565:	83 c4 10             	add    $0x10,%esp
  801568:	eb ec                	jmp    801556 <close+0x1d>

0080156a <close_all>:

void
close_all(void)
{
  80156a:	f3 0f 1e fb          	endbr32 
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	53                   	push   %ebx
  801572:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801575:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80157a:	83 ec 0c             	sub    $0xc,%esp
  80157d:	53                   	push   %ebx
  80157e:	e8 b6 ff ff ff       	call   801539 <close>
	for (i = 0; i < MAXFD; i++)
  801583:	83 c3 01             	add    $0x1,%ebx
  801586:	83 c4 10             	add    $0x10,%esp
  801589:	83 fb 20             	cmp    $0x20,%ebx
  80158c:	75 ec                	jne    80157a <close_all+0x10>
}
  80158e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801591:	c9                   	leave  
  801592:	c3                   	ret    

00801593 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801593:	f3 0f 1e fb          	endbr32 
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	57                   	push   %edi
  80159b:	56                   	push   %esi
  80159c:	53                   	push   %ebx
  80159d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015a0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015a3:	50                   	push   %eax
  8015a4:	ff 75 08             	pushl  0x8(%ebp)
  8015a7:	e8 54 fe ff ff       	call   801400 <fd_lookup>
  8015ac:	89 c3                	mov    %eax,%ebx
  8015ae:	83 c4 10             	add    $0x10,%esp
  8015b1:	85 c0                	test   %eax,%eax
  8015b3:	0f 88 81 00 00 00    	js     80163a <dup+0xa7>
		return r;
	close(newfdnum);
  8015b9:	83 ec 0c             	sub    $0xc,%esp
  8015bc:	ff 75 0c             	pushl  0xc(%ebp)
  8015bf:	e8 75 ff ff ff       	call   801539 <close>

	newfd = INDEX2FD(newfdnum);
  8015c4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015c7:	c1 e6 0c             	shl    $0xc,%esi
  8015ca:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015d0:	83 c4 04             	add    $0x4,%esp
  8015d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015d6:	e8 b4 fd ff ff       	call   80138f <fd2data>
  8015db:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015dd:	89 34 24             	mov    %esi,(%esp)
  8015e0:	e8 aa fd ff ff       	call   80138f <fd2data>
  8015e5:	83 c4 10             	add    $0x10,%esp
  8015e8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015ea:	89 d8                	mov    %ebx,%eax
  8015ec:	c1 e8 16             	shr    $0x16,%eax
  8015ef:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015f6:	a8 01                	test   $0x1,%al
  8015f8:	74 11                	je     80160b <dup+0x78>
  8015fa:	89 d8                	mov    %ebx,%eax
  8015fc:	c1 e8 0c             	shr    $0xc,%eax
  8015ff:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801606:	f6 c2 01             	test   $0x1,%dl
  801609:	75 39                	jne    801644 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80160b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80160e:	89 d0                	mov    %edx,%eax
  801610:	c1 e8 0c             	shr    $0xc,%eax
  801613:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80161a:	83 ec 0c             	sub    $0xc,%esp
  80161d:	25 07 0e 00 00       	and    $0xe07,%eax
  801622:	50                   	push   %eax
  801623:	56                   	push   %esi
  801624:	6a 00                	push   $0x0
  801626:	52                   	push   %edx
  801627:	6a 00                	push   $0x0
  801629:	e8 8a f8 ff ff       	call   800eb8 <sys_page_map>
  80162e:	89 c3                	mov    %eax,%ebx
  801630:	83 c4 20             	add    $0x20,%esp
  801633:	85 c0                	test   %eax,%eax
  801635:	78 31                	js     801668 <dup+0xd5>
		goto err;

	return newfdnum;
  801637:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80163a:	89 d8                	mov    %ebx,%eax
  80163c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80163f:	5b                   	pop    %ebx
  801640:	5e                   	pop    %esi
  801641:	5f                   	pop    %edi
  801642:	5d                   	pop    %ebp
  801643:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801644:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80164b:	83 ec 0c             	sub    $0xc,%esp
  80164e:	25 07 0e 00 00       	and    $0xe07,%eax
  801653:	50                   	push   %eax
  801654:	57                   	push   %edi
  801655:	6a 00                	push   $0x0
  801657:	53                   	push   %ebx
  801658:	6a 00                	push   $0x0
  80165a:	e8 59 f8 ff ff       	call   800eb8 <sys_page_map>
  80165f:	89 c3                	mov    %eax,%ebx
  801661:	83 c4 20             	add    $0x20,%esp
  801664:	85 c0                	test   %eax,%eax
  801666:	79 a3                	jns    80160b <dup+0x78>
	sys_page_unmap(0, newfd);
  801668:	83 ec 08             	sub    $0x8,%esp
  80166b:	56                   	push   %esi
  80166c:	6a 00                	push   $0x0
  80166e:	e8 8b f8 ff ff       	call   800efe <sys_page_unmap>
	sys_page_unmap(0, nva);
  801673:	83 c4 08             	add    $0x8,%esp
  801676:	57                   	push   %edi
  801677:	6a 00                	push   $0x0
  801679:	e8 80 f8 ff ff       	call   800efe <sys_page_unmap>
	return r;
  80167e:	83 c4 10             	add    $0x10,%esp
  801681:	eb b7                	jmp    80163a <dup+0xa7>

00801683 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801683:	f3 0f 1e fb          	endbr32 
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	53                   	push   %ebx
  80168b:	83 ec 1c             	sub    $0x1c,%esp
  80168e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801691:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801694:	50                   	push   %eax
  801695:	53                   	push   %ebx
  801696:	e8 65 fd ff ff       	call   801400 <fd_lookup>
  80169b:	83 c4 10             	add    $0x10,%esp
  80169e:	85 c0                	test   %eax,%eax
  8016a0:	78 3f                	js     8016e1 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a2:	83 ec 08             	sub    $0x8,%esp
  8016a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a8:	50                   	push   %eax
  8016a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ac:	ff 30                	pushl  (%eax)
  8016ae:	e8 a1 fd ff ff       	call   801454 <dev_lookup>
  8016b3:	83 c4 10             	add    $0x10,%esp
  8016b6:	85 c0                	test   %eax,%eax
  8016b8:	78 27                	js     8016e1 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016bd:	8b 42 08             	mov    0x8(%edx),%eax
  8016c0:	83 e0 03             	and    $0x3,%eax
  8016c3:	83 f8 01             	cmp    $0x1,%eax
  8016c6:	74 1e                	je     8016e6 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016cb:	8b 40 08             	mov    0x8(%eax),%eax
  8016ce:	85 c0                	test   %eax,%eax
  8016d0:	74 35                	je     801707 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016d2:	83 ec 04             	sub    $0x4,%esp
  8016d5:	ff 75 10             	pushl  0x10(%ebp)
  8016d8:	ff 75 0c             	pushl  0xc(%ebp)
  8016db:	52                   	push   %edx
  8016dc:	ff d0                	call   *%eax
  8016de:	83 c4 10             	add    $0x10,%esp
}
  8016e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016e6:	a1 04 40 80 00       	mov    0x804004,%eax
  8016eb:	8b 40 48             	mov    0x48(%eax),%eax
  8016ee:	83 ec 04             	sub    $0x4,%esp
  8016f1:	53                   	push   %ebx
  8016f2:	50                   	push   %eax
  8016f3:	68 fd 2a 80 00       	push   $0x802afd
  8016f8:	e8 28 ed ff ff       	call   800425 <cprintf>
		return -E_INVAL;
  8016fd:	83 c4 10             	add    $0x10,%esp
  801700:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801705:	eb da                	jmp    8016e1 <read+0x5e>
		return -E_NOT_SUPP;
  801707:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80170c:	eb d3                	jmp    8016e1 <read+0x5e>

0080170e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80170e:	f3 0f 1e fb          	endbr32 
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	57                   	push   %edi
  801716:	56                   	push   %esi
  801717:	53                   	push   %ebx
  801718:	83 ec 0c             	sub    $0xc,%esp
  80171b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80171e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801721:	bb 00 00 00 00       	mov    $0x0,%ebx
  801726:	eb 02                	jmp    80172a <readn+0x1c>
  801728:	01 c3                	add    %eax,%ebx
  80172a:	39 f3                	cmp    %esi,%ebx
  80172c:	73 21                	jae    80174f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80172e:	83 ec 04             	sub    $0x4,%esp
  801731:	89 f0                	mov    %esi,%eax
  801733:	29 d8                	sub    %ebx,%eax
  801735:	50                   	push   %eax
  801736:	89 d8                	mov    %ebx,%eax
  801738:	03 45 0c             	add    0xc(%ebp),%eax
  80173b:	50                   	push   %eax
  80173c:	57                   	push   %edi
  80173d:	e8 41 ff ff ff       	call   801683 <read>
		if (m < 0)
  801742:	83 c4 10             	add    $0x10,%esp
  801745:	85 c0                	test   %eax,%eax
  801747:	78 04                	js     80174d <readn+0x3f>
			return m;
		if (m == 0)
  801749:	75 dd                	jne    801728 <readn+0x1a>
  80174b:	eb 02                	jmp    80174f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80174d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80174f:	89 d8                	mov    %ebx,%eax
  801751:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801754:	5b                   	pop    %ebx
  801755:	5e                   	pop    %esi
  801756:	5f                   	pop    %edi
  801757:	5d                   	pop    %ebp
  801758:	c3                   	ret    

00801759 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801759:	f3 0f 1e fb          	endbr32 
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	53                   	push   %ebx
  801761:	83 ec 1c             	sub    $0x1c,%esp
  801764:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801767:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80176a:	50                   	push   %eax
  80176b:	53                   	push   %ebx
  80176c:	e8 8f fc ff ff       	call   801400 <fd_lookup>
  801771:	83 c4 10             	add    $0x10,%esp
  801774:	85 c0                	test   %eax,%eax
  801776:	78 3a                	js     8017b2 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801778:	83 ec 08             	sub    $0x8,%esp
  80177b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80177e:	50                   	push   %eax
  80177f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801782:	ff 30                	pushl  (%eax)
  801784:	e8 cb fc ff ff       	call   801454 <dev_lookup>
  801789:	83 c4 10             	add    $0x10,%esp
  80178c:	85 c0                	test   %eax,%eax
  80178e:	78 22                	js     8017b2 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801793:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801797:	74 1e                	je     8017b7 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801799:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80179c:	8b 52 0c             	mov    0xc(%edx),%edx
  80179f:	85 d2                	test   %edx,%edx
  8017a1:	74 35                	je     8017d8 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017a3:	83 ec 04             	sub    $0x4,%esp
  8017a6:	ff 75 10             	pushl  0x10(%ebp)
  8017a9:	ff 75 0c             	pushl  0xc(%ebp)
  8017ac:	50                   	push   %eax
  8017ad:	ff d2                	call   *%edx
  8017af:	83 c4 10             	add    $0x10,%esp
}
  8017b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017b7:	a1 04 40 80 00       	mov    0x804004,%eax
  8017bc:	8b 40 48             	mov    0x48(%eax),%eax
  8017bf:	83 ec 04             	sub    $0x4,%esp
  8017c2:	53                   	push   %ebx
  8017c3:	50                   	push   %eax
  8017c4:	68 19 2b 80 00       	push   $0x802b19
  8017c9:	e8 57 ec ff ff       	call   800425 <cprintf>
		return -E_INVAL;
  8017ce:	83 c4 10             	add    $0x10,%esp
  8017d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d6:	eb da                	jmp    8017b2 <write+0x59>
		return -E_NOT_SUPP;
  8017d8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017dd:	eb d3                	jmp    8017b2 <write+0x59>

008017df <seek>:

int
seek(int fdnum, off_t offset)
{
  8017df:	f3 0f 1e fb          	endbr32 
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
  8017e6:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ec:	50                   	push   %eax
  8017ed:	ff 75 08             	pushl  0x8(%ebp)
  8017f0:	e8 0b fc ff ff       	call   801400 <fd_lookup>
  8017f5:	83 c4 10             	add    $0x10,%esp
  8017f8:	85 c0                	test   %eax,%eax
  8017fa:	78 0e                	js     80180a <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8017fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801802:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801805:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80180c:	f3 0f 1e fb          	endbr32 
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	53                   	push   %ebx
  801814:	83 ec 1c             	sub    $0x1c,%esp
  801817:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80181a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80181d:	50                   	push   %eax
  80181e:	53                   	push   %ebx
  80181f:	e8 dc fb ff ff       	call   801400 <fd_lookup>
  801824:	83 c4 10             	add    $0x10,%esp
  801827:	85 c0                	test   %eax,%eax
  801829:	78 37                	js     801862 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80182b:	83 ec 08             	sub    $0x8,%esp
  80182e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801831:	50                   	push   %eax
  801832:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801835:	ff 30                	pushl  (%eax)
  801837:	e8 18 fc ff ff       	call   801454 <dev_lookup>
  80183c:	83 c4 10             	add    $0x10,%esp
  80183f:	85 c0                	test   %eax,%eax
  801841:	78 1f                	js     801862 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801843:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801846:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80184a:	74 1b                	je     801867 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80184c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80184f:	8b 52 18             	mov    0x18(%edx),%edx
  801852:	85 d2                	test   %edx,%edx
  801854:	74 32                	je     801888 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801856:	83 ec 08             	sub    $0x8,%esp
  801859:	ff 75 0c             	pushl  0xc(%ebp)
  80185c:	50                   	push   %eax
  80185d:	ff d2                	call   *%edx
  80185f:	83 c4 10             	add    $0x10,%esp
}
  801862:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801865:	c9                   	leave  
  801866:	c3                   	ret    
			thisenv->env_id, fdnum);
  801867:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80186c:	8b 40 48             	mov    0x48(%eax),%eax
  80186f:	83 ec 04             	sub    $0x4,%esp
  801872:	53                   	push   %ebx
  801873:	50                   	push   %eax
  801874:	68 dc 2a 80 00       	push   $0x802adc
  801879:	e8 a7 eb ff ff       	call   800425 <cprintf>
		return -E_INVAL;
  80187e:	83 c4 10             	add    $0x10,%esp
  801881:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801886:	eb da                	jmp    801862 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801888:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80188d:	eb d3                	jmp    801862 <ftruncate+0x56>

0080188f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80188f:	f3 0f 1e fb          	endbr32 
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	53                   	push   %ebx
  801897:	83 ec 1c             	sub    $0x1c,%esp
  80189a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80189d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018a0:	50                   	push   %eax
  8018a1:	ff 75 08             	pushl  0x8(%ebp)
  8018a4:	e8 57 fb ff ff       	call   801400 <fd_lookup>
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	78 4b                	js     8018fb <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018b0:	83 ec 08             	sub    $0x8,%esp
  8018b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b6:	50                   	push   %eax
  8018b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ba:	ff 30                	pushl  (%eax)
  8018bc:	e8 93 fb ff ff       	call   801454 <dev_lookup>
  8018c1:	83 c4 10             	add    $0x10,%esp
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	78 33                	js     8018fb <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8018c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018cb:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018cf:	74 2f                	je     801900 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018d1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018d4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018db:	00 00 00 
	stat->st_isdir = 0;
  8018de:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018e5:	00 00 00 
	stat->st_dev = dev;
  8018e8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018ee:	83 ec 08             	sub    $0x8,%esp
  8018f1:	53                   	push   %ebx
  8018f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8018f5:	ff 50 14             	call   *0x14(%eax)
  8018f8:	83 c4 10             	add    $0x10,%esp
}
  8018fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    
		return -E_NOT_SUPP;
  801900:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801905:	eb f4                	jmp    8018fb <fstat+0x6c>

00801907 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801907:	f3 0f 1e fb          	endbr32 
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	56                   	push   %esi
  80190f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801910:	83 ec 08             	sub    $0x8,%esp
  801913:	6a 00                	push   $0x0
  801915:	ff 75 08             	pushl  0x8(%ebp)
  801918:	e8 fb 01 00 00       	call   801b18 <open>
  80191d:	89 c3                	mov    %eax,%ebx
  80191f:	83 c4 10             	add    $0x10,%esp
  801922:	85 c0                	test   %eax,%eax
  801924:	78 1b                	js     801941 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801926:	83 ec 08             	sub    $0x8,%esp
  801929:	ff 75 0c             	pushl  0xc(%ebp)
  80192c:	50                   	push   %eax
  80192d:	e8 5d ff ff ff       	call   80188f <fstat>
  801932:	89 c6                	mov    %eax,%esi
	close(fd);
  801934:	89 1c 24             	mov    %ebx,(%esp)
  801937:	e8 fd fb ff ff       	call   801539 <close>
	return r;
  80193c:	83 c4 10             	add    $0x10,%esp
  80193f:	89 f3                	mov    %esi,%ebx
}
  801941:	89 d8                	mov    %ebx,%eax
  801943:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801946:	5b                   	pop    %ebx
  801947:	5e                   	pop    %esi
  801948:	5d                   	pop    %ebp
  801949:	c3                   	ret    

0080194a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	56                   	push   %esi
  80194e:	53                   	push   %ebx
  80194f:	89 c6                	mov    %eax,%esi
  801951:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801953:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80195a:	74 27                	je     801983 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80195c:	6a 07                	push   $0x7
  80195e:	68 00 50 80 00       	push   $0x805000
  801963:	56                   	push   %esi
  801964:	ff 35 00 40 80 00    	pushl  0x804000
  80196a:	e8 c2 08 00 00       	call   802231 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80196f:	83 c4 0c             	add    $0xc,%esp
  801972:	6a 00                	push   $0x0
  801974:	53                   	push   %ebx
  801975:	6a 00                	push   $0x0
  801977:	e8 30 08 00 00       	call   8021ac <ipc_recv>
}
  80197c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80197f:	5b                   	pop    %ebx
  801980:	5e                   	pop    %esi
  801981:	5d                   	pop    %ebp
  801982:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801983:	83 ec 0c             	sub    $0xc,%esp
  801986:	6a 01                	push   $0x1
  801988:	e8 fc 08 00 00       	call   802289 <ipc_find_env>
  80198d:	a3 00 40 80 00       	mov    %eax,0x804000
  801992:	83 c4 10             	add    $0x10,%esp
  801995:	eb c5                	jmp    80195c <fsipc+0x12>

00801997 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801997:	f3 0f 1e fb          	endbr32 
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8019ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019af:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b9:	b8 02 00 00 00       	mov    $0x2,%eax
  8019be:	e8 87 ff ff ff       	call   80194a <fsipc>
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <devfile_flush>:
{
  8019c5:	f3 0f 1e fb          	endbr32 
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
  8019cc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d5:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8019da:	ba 00 00 00 00       	mov    $0x0,%edx
  8019df:	b8 06 00 00 00       	mov    $0x6,%eax
  8019e4:	e8 61 ff ff ff       	call   80194a <fsipc>
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <devfile_stat>:
{
  8019eb:	f3 0f 1e fb          	endbr32 
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
  8019f2:	53                   	push   %ebx
  8019f3:	83 ec 04             	sub    $0x4,%esp
  8019f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ff:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a04:	ba 00 00 00 00       	mov    $0x0,%edx
  801a09:	b8 05 00 00 00       	mov    $0x5,%eax
  801a0e:	e8 37 ff ff ff       	call   80194a <fsipc>
  801a13:	85 c0                	test   %eax,%eax
  801a15:	78 2c                	js     801a43 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a17:	83 ec 08             	sub    $0x8,%esp
  801a1a:	68 00 50 80 00       	push   $0x805000
  801a1f:	53                   	push   %ebx
  801a20:	e8 0a f0 ff ff       	call   800a2f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a25:	a1 80 50 80 00       	mov    0x805080,%eax
  801a2a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a30:	a1 84 50 80 00       	mov    0x805084,%eax
  801a35:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a3b:	83 c4 10             	add    $0x10,%esp
  801a3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <devfile_write>:
{
  801a48:	f3 0f 1e fb          	endbr32 
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	83 ec 0c             	sub    $0xc,%esp
  801a52:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a55:	8b 55 08             	mov    0x8(%ebp),%edx
  801a58:	8b 52 0c             	mov    0xc(%edx),%edx
  801a5b:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801a61:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a66:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801a6b:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801a6e:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801a73:	50                   	push   %eax
  801a74:	ff 75 0c             	pushl  0xc(%ebp)
  801a77:	68 08 50 80 00       	push   $0x805008
  801a7c:	e8 64 f1 ff ff       	call   800be5 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801a81:	ba 00 00 00 00       	mov    $0x0,%edx
  801a86:	b8 04 00 00 00       	mov    $0x4,%eax
  801a8b:	e8 ba fe ff ff       	call   80194a <fsipc>
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <devfile_read>:
{
  801a92:	f3 0f 1e fb          	endbr32 
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	56                   	push   %esi
  801a9a:	53                   	push   %ebx
  801a9b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa1:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801aa9:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801aaf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab4:	b8 03 00 00 00       	mov    $0x3,%eax
  801ab9:	e8 8c fe ff ff       	call   80194a <fsipc>
  801abe:	89 c3                	mov    %eax,%ebx
  801ac0:	85 c0                	test   %eax,%eax
  801ac2:	78 1f                	js     801ae3 <devfile_read+0x51>
	assert(r <= n);
  801ac4:	39 f0                	cmp    %esi,%eax
  801ac6:	77 24                	ja     801aec <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801ac8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801acd:	7f 33                	jg     801b02 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801acf:	83 ec 04             	sub    $0x4,%esp
  801ad2:	50                   	push   %eax
  801ad3:	68 00 50 80 00       	push   $0x805000
  801ad8:	ff 75 0c             	pushl  0xc(%ebp)
  801adb:	e8 05 f1 ff ff       	call   800be5 <memmove>
	return r;
  801ae0:	83 c4 10             	add    $0x10,%esp
}
  801ae3:	89 d8                	mov    %ebx,%eax
  801ae5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae8:	5b                   	pop    %ebx
  801ae9:	5e                   	pop    %esi
  801aea:	5d                   	pop    %ebp
  801aeb:	c3                   	ret    
	assert(r <= n);
  801aec:	68 48 2b 80 00       	push   $0x802b48
  801af1:	68 4f 2b 80 00       	push   $0x802b4f
  801af6:	6a 7c                	push   $0x7c
  801af8:	68 64 2b 80 00       	push   $0x802b64
  801afd:	e8 3c e8 ff ff       	call   80033e <_panic>
	assert(r <= PGSIZE);
  801b02:	68 6f 2b 80 00       	push   $0x802b6f
  801b07:	68 4f 2b 80 00       	push   $0x802b4f
  801b0c:	6a 7d                	push   $0x7d
  801b0e:	68 64 2b 80 00       	push   $0x802b64
  801b13:	e8 26 e8 ff ff       	call   80033e <_panic>

00801b18 <open>:
{
  801b18:	f3 0f 1e fb          	endbr32 
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	56                   	push   %esi
  801b20:	53                   	push   %ebx
  801b21:	83 ec 1c             	sub    $0x1c,%esp
  801b24:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b27:	56                   	push   %esi
  801b28:	e8 bf ee ff ff       	call   8009ec <strlen>
  801b2d:	83 c4 10             	add    $0x10,%esp
  801b30:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b35:	7f 6c                	jg     801ba3 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801b37:	83 ec 0c             	sub    $0xc,%esp
  801b3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b3d:	50                   	push   %eax
  801b3e:	e8 67 f8 ff ff       	call   8013aa <fd_alloc>
  801b43:	89 c3                	mov    %eax,%ebx
  801b45:	83 c4 10             	add    $0x10,%esp
  801b48:	85 c0                	test   %eax,%eax
  801b4a:	78 3c                	js     801b88 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801b4c:	83 ec 08             	sub    $0x8,%esp
  801b4f:	56                   	push   %esi
  801b50:	68 00 50 80 00       	push   $0x805000
  801b55:	e8 d5 ee ff ff       	call   800a2f <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b65:	b8 01 00 00 00       	mov    $0x1,%eax
  801b6a:	e8 db fd ff ff       	call   80194a <fsipc>
  801b6f:	89 c3                	mov    %eax,%ebx
  801b71:	83 c4 10             	add    $0x10,%esp
  801b74:	85 c0                	test   %eax,%eax
  801b76:	78 19                	js     801b91 <open+0x79>
	return fd2num(fd);
  801b78:	83 ec 0c             	sub    $0xc,%esp
  801b7b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b7e:	e8 f8 f7 ff ff       	call   80137b <fd2num>
  801b83:	89 c3                	mov    %eax,%ebx
  801b85:	83 c4 10             	add    $0x10,%esp
}
  801b88:	89 d8                	mov    %ebx,%eax
  801b8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b8d:	5b                   	pop    %ebx
  801b8e:	5e                   	pop    %esi
  801b8f:	5d                   	pop    %ebp
  801b90:	c3                   	ret    
		fd_close(fd, 0);
  801b91:	83 ec 08             	sub    $0x8,%esp
  801b94:	6a 00                	push   $0x0
  801b96:	ff 75 f4             	pushl  -0xc(%ebp)
  801b99:	e8 10 f9 ff ff       	call   8014ae <fd_close>
		return r;
  801b9e:	83 c4 10             	add    $0x10,%esp
  801ba1:	eb e5                	jmp    801b88 <open+0x70>
		return -E_BAD_PATH;
  801ba3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ba8:	eb de                	jmp    801b88 <open+0x70>

00801baa <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801baa:	f3 0f 1e fb          	endbr32 
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
  801bb1:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bb4:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb9:	b8 08 00 00 00       	mov    $0x8,%eax
  801bbe:	e8 87 fd ff ff       	call   80194a <fsipc>
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801bc5:	f3 0f 1e fb          	endbr32 
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	56                   	push   %esi
  801bcd:	53                   	push   %ebx
  801bce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801bd1:	83 ec 0c             	sub    $0xc,%esp
  801bd4:	ff 75 08             	pushl  0x8(%ebp)
  801bd7:	e8 b3 f7 ff ff       	call   80138f <fd2data>
  801bdc:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801bde:	83 c4 08             	add    $0x8,%esp
  801be1:	68 7b 2b 80 00       	push   $0x802b7b
  801be6:	53                   	push   %ebx
  801be7:	e8 43 ee ff ff       	call   800a2f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bec:	8b 46 04             	mov    0x4(%esi),%eax
  801bef:	2b 06                	sub    (%esi),%eax
  801bf1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801bf7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bfe:	00 00 00 
	stat->st_dev = &devpipe;
  801c01:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801c08:	30 80 00 
	return 0;
}
  801c0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c10:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c13:	5b                   	pop    %ebx
  801c14:	5e                   	pop    %esi
  801c15:	5d                   	pop    %ebp
  801c16:	c3                   	ret    

00801c17 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c17:	f3 0f 1e fb          	endbr32 
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	53                   	push   %ebx
  801c1f:	83 ec 0c             	sub    $0xc,%esp
  801c22:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c25:	53                   	push   %ebx
  801c26:	6a 00                	push   $0x0
  801c28:	e8 d1 f2 ff ff       	call   800efe <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c2d:	89 1c 24             	mov    %ebx,(%esp)
  801c30:	e8 5a f7 ff ff       	call   80138f <fd2data>
  801c35:	83 c4 08             	add    $0x8,%esp
  801c38:	50                   	push   %eax
  801c39:	6a 00                	push   $0x0
  801c3b:	e8 be f2 ff ff       	call   800efe <sys_page_unmap>
}
  801c40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <_pipeisclosed>:
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	57                   	push   %edi
  801c49:	56                   	push   %esi
  801c4a:	53                   	push   %ebx
  801c4b:	83 ec 1c             	sub    $0x1c,%esp
  801c4e:	89 c7                	mov    %eax,%edi
  801c50:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c52:	a1 04 40 80 00       	mov    0x804004,%eax
  801c57:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c5a:	83 ec 0c             	sub    $0xc,%esp
  801c5d:	57                   	push   %edi
  801c5e:	e8 63 06 00 00       	call   8022c6 <pageref>
  801c63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c66:	89 34 24             	mov    %esi,(%esp)
  801c69:	e8 58 06 00 00       	call   8022c6 <pageref>
		nn = thisenv->env_runs;
  801c6e:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c74:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c77:	83 c4 10             	add    $0x10,%esp
  801c7a:	39 cb                	cmp    %ecx,%ebx
  801c7c:	74 1b                	je     801c99 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c7e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c81:	75 cf                	jne    801c52 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c83:	8b 42 58             	mov    0x58(%edx),%eax
  801c86:	6a 01                	push   $0x1
  801c88:	50                   	push   %eax
  801c89:	53                   	push   %ebx
  801c8a:	68 82 2b 80 00       	push   $0x802b82
  801c8f:	e8 91 e7 ff ff       	call   800425 <cprintf>
  801c94:	83 c4 10             	add    $0x10,%esp
  801c97:	eb b9                	jmp    801c52 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c99:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c9c:	0f 94 c0             	sete   %al
  801c9f:	0f b6 c0             	movzbl %al,%eax
}
  801ca2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ca5:	5b                   	pop    %ebx
  801ca6:	5e                   	pop    %esi
  801ca7:	5f                   	pop    %edi
  801ca8:	5d                   	pop    %ebp
  801ca9:	c3                   	ret    

00801caa <devpipe_write>:
{
  801caa:	f3 0f 1e fb          	endbr32 
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	57                   	push   %edi
  801cb2:	56                   	push   %esi
  801cb3:	53                   	push   %ebx
  801cb4:	83 ec 28             	sub    $0x28,%esp
  801cb7:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801cba:	56                   	push   %esi
  801cbb:	e8 cf f6 ff ff       	call   80138f <fd2data>
  801cc0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cc2:	83 c4 10             	add    $0x10,%esp
  801cc5:	bf 00 00 00 00       	mov    $0x0,%edi
  801cca:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ccd:	74 4f                	je     801d1e <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ccf:	8b 43 04             	mov    0x4(%ebx),%eax
  801cd2:	8b 0b                	mov    (%ebx),%ecx
  801cd4:	8d 51 20             	lea    0x20(%ecx),%edx
  801cd7:	39 d0                	cmp    %edx,%eax
  801cd9:	72 14                	jb     801cef <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801cdb:	89 da                	mov    %ebx,%edx
  801cdd:	89 f0                	mov    %esi,%eax
  801cdf:	e8 61 ff ff ff       	call   801c45 <_pipeisclosed>
  801ce4:	85 c0                	test   %eax,%eax
  801ce6:	75 3b                	jne    801d23 <devpipe_write+0x79>
			sys_yield();
  801ce8:	e8 61 f1 ff ff       	call   800e4e <sys_yield>
  801ced:	eb e0                	jmp    801ccf <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801cef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cf2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801cf6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801cf9:	89 c2                	mov    %eax,%edx
  801cfb:	c1 fa 1f             	sar    $0x1f,%edx
  801cfe:	89 d1                	mov    %edx,%ecx
  801d00:	c1 e9 1b             	shr    $0x1b,%ecx
  801d03:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d06:	83 e2 1f             	and    $0x1f,%edx
  801d09:	29 ca                	sub    %ecx,%edx
  801d0b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d0f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d13:	83 c0 01             	add    $0x1,%eax
  801d16:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d19:	83 c7 01             	add    $0x1,%edi
  801d1c:	eb ac                	jmp    801cca <devpipe_write+0x20>
	return i;
  801d1e:	8b 45 10             	mov    0x10(%ebp),%eax
  801d21:	eb 05                	jmp    801d28 <devpipe_write+0x7e>
				return 0;
  801d23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d2b:	5b                   	pop    %ebx
  801d2c:	5e                   	pop    %esi
  801d2d:	5f                   	pop    %edi
  801d2e:	5d                   	pop    %ebp
  801d2f:	c3                   	ret    

00801d30 <devpipe_read>:
{
  801d30:	f3 0f 1e fb          	endbr32 
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	57                   	push   %edi
  801d38:	56                   	push   %esi
  801d39:	53                   	push   %ebx
  801d3a:	83 ec 18             	sub    $0x18,%esp
  801d3d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d40:	57                   	push   %edi
  801d41:	e8 49 f6 ff ff       	call   80138f <fd2data>
  801d46:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d48:	83 c4 10             	add    $0x10,%esp
  801d4b:	be 00 00 00 00       	mov    $0x0,%esi
  801d50:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d53:	75 14                	jne    801d69 <devpipe_read+0x39>
	return i;
  801d55:	8b 45 10             	mov    0x10(%ebp),%eax
  801d58:	eb 02                	jmp    801d5c <devpipe_read+0x2c>
				return i;
  801d5a:	89 f0                	mov    %esi,%eax
}
  801d5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d5f:	5b                   	pop    %ebx
  801d60:	5e                   	pop    %esi
  801d61:	5f                   	pop    %edi
  801d62:	5d                   	pop    %ebp
  801d63:	c3                   	ret    
			sys_yield();
  801d64:	e8 e5 f0 ff ff       	call   800e4e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d69:	8b 03                	mov    (%ebx),%eax
  801d6b:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d6e:	75 18                	jne    801d88 <devpipe_read+0x58>
			if (i > 0)
  801d70:	85 f6                	test   %esi,%esi
  801d72:	75 e6                	jne    801d5a <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801d74:	89 da                	mov    %ebx,%edx
  801d76:	89 f8                	mov    %edi,%eax
  801d78:	e8 c8 fe ff ff       	call   801c45 <_pipeisclosed>
  801d7d:	85 c0                	test   %eax,%eax
  801d7f:	74 e3                	je     801d64 <devpipe_read+0x34>
				return 0;
  801d81:	b8 00 00 00 00       	mov    $0x0,%eax
  801d86:	eb d4                	jmp    801d5c <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d88:	99                   	cltd   
  801d89:	c1 ea 1b             	shr    $0x1b,%edx
  801d8c:	01 d0                	add    %edx,%eax
  801d8e:	83 e0 1f             	and    $0x1f,%eax
  801d91:	29 d0                	sub    %edx,%eax
  801d93:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d9b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d9e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801da1:	83 c6 01             	add    $0x1,%esi
  801da4:	eb aa                	jmp    801d50 <devpipe_read+0x20>

00801da6 <pipe>:
{
  801da6:	f3 0f 1e fb          	endbr32 
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	56                   	push   %esi
  801dae:	53                   	push   %ebx
  801daf:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801db2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801db5:	50                   	push   %eax
  801db6:	e8 ef f5 ff ff       	call   8013aa <fd_alloc>
  801dbb:	89 c3                	mov    %eax,%ebx
  801dbd:	83 c4 10             	add    $0x10,%esp
  801dc0:	85 c0                	test   %eax,%eax
  801dc2:	0f 88 23 01 00 00    	js     801eeb <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dc8:	83 ec 04             	sub    $0x4,%esp
  801dcb:	68 07 04 00 00       	push   $0x407
  801dd0:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd3:	6a 00                	push   $0x0
  801dd5:	e8 97 f0 ff ff       	call   800e71 <sys_page_alloc>
  801dda:	89 c3                	mov    %eax,%ebx
  801ddc:	83 c4 10             	add    $0x10,%esp
  801ddf:	85 c0                	test   %eax,%eax
  801de1:	0f 88 04 01 00 00    	js     801eeb <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801de7:	83 ec 0c             	sub    $0xc,%esp
  801dea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ded:	50                   	push   %eax
  801dee:	e8 b7 f5 ff ff       	call   8013aa <fd_alloc>
  801df3:	89 c3                	mov    %eax,%ebx
  801df5:	83 c4 10             	add    $0x10,%esp
  801df8:	85 c0                	test   %eax,%eax
  801dfa:	0f 88 db 00 00 00    	js     801edb <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e00:	83 ec 04             	sub    $0x4,%esp
  801e03:	68 07 04 00 00       	push   $0x407
  801e08:	ff 75 f0             	pushl  -0x10(%ebp)
  801e0b:	6a 00                	push   $0x0
  801e0d:	e8 5f f0 ff ff       	call   800e71 <sys_page_alloc>
  801e12:	89 c3                	mov    %eax,%ebx
  801e14:	83 c4 10             	add    $0x10,%esp
  801e17:	85 c0                	test   %eax,%eax
  801e19:	0f 88 bc 00 00 00    	js     801edb <pipe+0x135>
	va = fd2data(fd0);
  801e1f:	83 ec 0c             	sub    $0xc,%esp
  801e22:	ff 75 f4             	pushl  -0xc(%ebp)
  801e25:	e8 65 f5 ff ff       	call   80138f <fd2data>
  801e2a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e2c:	83 c4 0c             	add    $0xc,%esp
  801e2f:	68 07 04 00 00       	push   $0x407
  801e34:	50                   	push   %eax
  801e35:	6a 00                	push   $0x0
  801e37:	e8 35 f0 ff ff       	call   800e71 <sys_page_alloc>
  801e3c:	89 c3                	mov    %eax,%ebx
  801e3e:	83 c4 10             	add    $0x10,%esp
  801e41:	85 c0                	test   %eax,%eax
  801e43:	0f 88 82 00 00 00    	js     801ecb <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e49:	83 ec 0c             	sub    $0xc,%esp
  801e4c:	ff 75 f0             	pushl  -0x10(%ebp)
  801e4f:	e8 3b f5 ff ff       	call   80138f <fd2data>
  801e54:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e5b:	50                   	push   %eax
  801e5c:	6a 00                	push   $0x0
  801e5e:	56                   	push   %esi
  801e5f:	6a 00                	push   $0x0
  801e61:	e8 52 f0 ff ff       	call   800eb8 <sys_page_map>
  801e66:	89 c3                	mov    %eax,%ebx
  801e68:	83 c4 20             	add    $0x20,%esp
  801e6b:	85 c0                	test   %eax,%eax
  801e6d:	78 4e                	js     801ebd <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801e6f:	a1 24 30 80 00       	mov    0x803024,%eax
  801e74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e77:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e7c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e86:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e92:	83 ec 0c             	sub    $0xc,%esp
  801e95:	ff 75 f4             	pushl  -0xc(%ebp)
  801e98:	e8 de f4 ff ff       	call   80137b <fd2num>
  801e9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ea0:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ea2:	83 c4 04             	add    $0x4,%esp
  801ea5:	ff 75 f0             	pushl  -0x10(%ebp)
  801ea8:	e8 ce f4 ff ff       	call   80137b <fd2num>
  801ead:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eb0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801eb3:	83 c4 10             	add    $0x10,%esp
  801eb6:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ebb:	eb 2e                	jmp    801eeb <pipe+0x145>
	sys_page_unmap(0, va);
  801ebd:	83 ec 08             	sub    $0x8,%esp
  801ec0:	56                   	push   %esi
  801ec1:	6a 00                	push   $0x0
  801ec3:	e8 36 f0 ff ff       	call   800efe <sys_page_unmap>
  801ec8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ecb:	83 ec 08             	sub    $0x8,%esp
  801ece:	ff 75 f0             	pushl  -0x10(%ebp)
  801ed1:	6a 00                	push   $0x0
  801ed3:	e8 26 f0 ff ff       	call   800efe <sys_page_unmap>
  801ed8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801edb:	83 ec 08             	sub    $0x8,%esp
  801ede:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee1:	6a 00                	push   $0x0
  801ee3:	e8 16 f0 ff ff       	call   800efe <sys_page_unmap>
  801ee8:	83 c4 10             	add    $0x10,%esp
}
  801eeb:	89 d8                	mov    %ebx,%eax
  801eed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ef0:	5b                   	pop    %ebx
  801ef1:	5e                   	pop    %esi
  801ef2:	5d                   	pop    %ebp
  801ef3:	c3                   	ret    

00801ef4 <pipeisclosed>:
{
  801ef4:	f3 0f 1e fb          	endbr32 
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801efe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f01:	50                   	push   %eax
  801f02:	ff 75 08             	pushl  0x8(%ebp)
  801f05:	e8 f6 f4 ff ff       	call   801400 <fd_lookup>
  801f0a:	83 c4 10             	add    $0x10,%esp
  801f0d:	85 c0                	test   %eax,%eax
  801f0f:	78 18                	js     801f29 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801f11:	83 ec 0c             	sub    $0xc,%esp
  801f14:	ff 75 f4             	pushl  -0xc(%ebp)
  801f17:	e8 73 f4 ff ff       	call   80138f <fd2data>
  801f1c:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f21:	e8 1f fd ff ff       	call   801c45 <_pipeisclosed>
  801f26:	83 c4 10             	add    $0x10,%esp
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801f2b:	f3 0f 1e fb          	endbr32 
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
  801f32:	56                   	push   %esi
  801f33:	53                   	push   %ebx
  801f34:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801f37:	85 f6                	test   %esi,%esi
  801f39:	74 13                	je     801f4e <wait+0x23>
	e = &envs[ENVX(envid)];
  801f3b:	89 f3                	mov    %esi,%ebx
  801f3d:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801f43:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  801f46:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801f4c:	eb 1b                	jmp    801f69 <wait+0x3e>
	assert(envid != 0);
  801f4e:	68 9a 2b 80 00       	push   $0x802b9a
  801f53:	68 4f 2b 80 00       	push   $0x802b4f
  801f58:	6a 09                	push   $0x9
  801f5a:	68 a5 2b 80 00       	push   $0x802ba5
  801f5f:	e8 da e3 ff ff       	call   80033e <_panic>
		sys_yield();
  801f64:	e8 e5 ee ff ff       	call   800e4e <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801f69:	8b 43 48             	mov    0x48(%ebx),%eax
  801f6c:	39 f0                	cmp    %esi,%eax
  801f6e:	75 07                	jne    801f77 <wait+0x4c>
  801f70:	8b 43 54             	mov    0x54(%ebx),%eax
  801f73:	85 c0                	test   %eax,%eax
  801f75:	75 ed                	jne    801f64 <wait+0x39>
}
  801f77:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f7a:	5b                   	pop    %ebx
  801f7b:	5e                   	pop    %esi
  801f7c:	5d                   	pop    %ebp
  801f7d:	c3                   	ret    

00801f7e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f7e:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801f82:	b8 00 00 00 00       	mov    $0x0,%eax
  801f87:	c3                   	ret    

00801f88 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f88:	f3 0f 1e fb          	endbr32 
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
  801f8f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f92:	68 b0 2b 80 00       	push   $0x802bb0
  801f97:	ff 75 0c             	pushl  0xc(%ebp)
  801f9a:	e8 90 ea ff ff       	call   800a2f <strcpy>
	return 0;
}
  801f9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <devcons_write>:
{
  801fa6:	f3 0f 1e fb          	endbr32 
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
  801fad:	57                   	push   %edi
  801fae:	56                   	push   %esi
  801faf:	53                   	push   %ebx
  801fb0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fb6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fbb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fc1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fc4:	73 31                	jae    801ff7 <devcons_write+0x51>
		m = n - tot;
  801fc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fc9:	29 f3                	sub    %esi,%ebx
  801fcb:	83 fb 7f             	cmp    $0x7f,%ebx
  801fce:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fd3:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fd6:	83 ec 04             	sub    $0x4,%esp
  801fd9:	53                   	push   %ebx
  801fda:	89 f0                	mov    %esi,%eax
  801fdc:	03 45 0c             	add    0xc(%ebp),%eax
  801fdf:	50                   	push   %eax
  801fe0:	57                   	push   %edi
  801fe1:	e8 ff eb ff ff       	call   800be5 <memmove>
		sys_cputs(buf, m);
  801fe6:	83 c4 08             	add    $0x8,%esp
  801fe9:	53                   	push   %ebx
  801fea:	57                   	push   %edi
  801feb:	e8 b1 ed ff ff       	call   800da1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ff0:	01 de                	add    %ebx,%esi
  801ff2:	83 c4 10             	add    $0x10,%esp
  801ff5:	eb ca                	jmp    801fc1 <devcons_write+0x1b>
}
  801ff7:	89 f0                	mov    %esi,%eax
  801ff9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ffc:	5b                   	pop    %ebx
  801ffd:	5e                   	pop    %esi
  801ffe:	5f                   	pop    %edi
  801fff:	5d                   	pop    %ebp
  802000:	c3                   	ret    

00802001 <devcons_read>:
{
  802001:	f3 0f 1e fb          	endbr32 
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	83 ec 08             	sub    $0x8,%esp
  80200b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802010:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802014:	74 21                	je     802037 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802016:	e8 a8 ed ff ff       	call   800dc3 <sys_cgetc>
  80201b:	85 c0                	test   %eax,%eax
  80201d:	75 07                	jne    802026 <devcons_read+0x25>
		sys_yield();
  80201f:	e8 2a ee ff ff       	call   800e4e <sys_yield>
  802024:	eb f0                	jmp    802016 <devcons_read+0x15>
	if (c < 0)
  802026:	78 0f                	js     802037 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802028:	83 f8 04             	cmp    $0x4,%eax
  80202b:	74 0c                	je     802039 <devcons_read+0x38>
	*(char*)vbuf = c;
  80202d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802030:	88 02                	mov    %al,(%edx)
	return 1;
  802032:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    
		return 0;
  802039:	b8 00 00 00 00       	mov    $0x0,%eax
  80203e:	eb f7                	jmp    802037 <devcons_read+0x36>

00802040 <cputchar>:
{
  802040:	f3 0f 1e fb          	endbr32 
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802050:	6a 01                	push   $0x1
  802052:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802055:	50                   	push   %eax
  802056:	e8 46 ed ff ff       	call   800da1 <sys_cputs>
}
  80205b:	83 c4 10             	add    $0x10,%esp
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <getchar>:
{
  802060:	f3 0f 1e fb          	endbr32 
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
  802067:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80206a:	6a 01                	push   $0x1
  80206c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80206f:	50                   	push   %eax
  802070:	6a 00                	push   $0x0
  802072:	e8 0c f6 ff ff       	call   801683 <read>
	if (r < 0)
  802077:	83 c4 10             	add    $0x10,%esp
  80207a:	85 c0                	test   %eax,%eax
  80207c:	78 06                	js     802084 <getchar+0x24>
	if (r < 1)
  80207e:	74 06                	je     802086 <getchar+0x26>
	return c;
  802080:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    
		return -E_EOF;
  802086:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80208b:	eb f7                	jmp    802084 <getchar+0x24>

0080208d <iscons>:
{
  80208d:	f3 0f 1e fb          	endbr32 
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
  802094:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802097:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80209a:	50                   	push   %eax
  80209b:	ff 75 08             	pushl  0x8(%ebp)
  80209e:	e8 5d f3 ff ff       	call   801400 <fd_lookup>
  8020a3:	83 c4 10             	add    $0x10,%esp
  8020a6:	85 c0                	test   %eax,%eax
  8020a8:	78 11                	js     8020bb <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8020aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ad:	8b 15 40 30 80 00    	mov    0x803040,%edx
  8020b3:	39 10                	cmp    %edx,(%eax)
  8020b5:	0f 94 c0             	sete   %al
  8020b8:	0f b6 c0             	movzbl %al,%eax
}
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <opencons>:
{
  8020bd:	f3 0f 1e fb          	endbr32 
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
  8020c4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ca:	50                   	push   %eax
  8020cb:	e8 da f2 ff ff       	call   8013aa <fd_alloc>
  8020d0:	83 c4 10             	add    $0x10,%esp
  8020d3:	85 c0                	test   %eax,%eax
  8020d5:	78 3a                	js     802111 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020d7:	83 ec 04             	sub    $0x4,%esp
  8020da:	68 07 04 00 00       	push   $0x407
  8020df:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e2:	6a 00                	push   $0x0
  8020e4:	e8 88 ed ff ff       	call   800e71 <sys_page_alloc>
  8020e9:	83 c4 10             	add    $0x10,%esp
  8020ec:	85 c0                	test   %eax,%eax
  8020ee:	78 21                	js     802111 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8020f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f3:	8b 15 40 30 80 00    	mov    0x803040,%edx
  8020f9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fe:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802105:	83 ec 0c             	sub    $0xc,%esp
  802108:	50                   	push   %eax
  802109:	e8 6d f2 ff ff       	call   80137b <fd2num>
  80210e:	83 c4 10             	add    $0x10,%esp
}
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802113:	f3 0f 1e fb          	endbr32 
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
  80211a:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80211d:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802124:	74 0a                	je     802130 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	a3 00 60 80 00       	mov    %eax,0x806000
}
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  802130:	83 ec 04             	sub    $0x4,%esp
  802133:	6a 07                	push   $0x7
  802135:	68 00 f0 bf ee       	push   $0xeebff000
  80213a:	6a 00                	push   $0x0
  80213c:	e8 30 ed ff ff       	call   800e71 <sys_page_alloc>
  802141:	83 c4 10             	add    $0x10,%esp
  802144:	85 c0                	test   %eax,%eax
  802146:	78 2a                	js     802172 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  802148:	83 ec 08             	sub    $0x8,%esp
  80214b:	68 86 21 80 00       	push   $0x802186
  802150:	6a 00                	push   $0x0
  802152:	e8 79 ee ff ff       	call   800fd0 <sys_env_set_pgfault_upcall>
  802157:	83 c4 10             	add    $0x10,%esp
  80215a:	85 c0                	test   %eax,%eax
  80215c:	79 c8                	jns    802126 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  80215e:	83 ec 04             	sub    $0x4,%esp
  802161:	68 e8 2b 80 00       	push   $0x802be8
  802166:	6a 25                	push   $0x25
  802168:	68 20 2c 80 00       	push   $0x802c20
  80216d:	e8 cc e1 ff ff       	call   80033e <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  802172:	83 ec 04             	sub    $0x4,%esp
  802175:	68 bc 2b 80 00       	push   $0x802bbc
  80217a:	6a 22                	push   $0x22
  80217c:	68 20 2c 80 00       	push   $0x802c20
  802181:	e8 b8 e1 ff ff       	call   80033e <_panic>

00802186 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802186:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802187:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  80218c:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80218e:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  802191:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  802195:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802199:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80219c:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  80219e:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  8021a2:	83 c4 08             	add    $0x8,%esp
	popal
  8021a5:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  8021a6:	83 c4 04             	add    $0x4,%esp
	popfl
  8021a9:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  8021aa:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  8021ab:	c3                   	ret    

008021ac <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021ac:	f3 0f 1e fb          	endbr32 
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	56                   	push   %esi
  8021b4:	53                   	push   %ebx
  8021b5:	8b 75 08             	mov    0x8(%ebp),%esi
  8021b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	74 3d                	je     8021ff <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8021c2:	83 ec 0c             	sub    $0xc,%esp
  8021c5:	50                   	push   %eax
  8021c6:	e8 72 ee ff ff       	call   80103d <sys_ipc_recv>
  8021cb:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8021ce:	85 f6                	test   %esi,%esi
  8021d0:	74 0b                	je     8021dd <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8021d2:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8021d8:	8b 52 74             	mov    0x74(%edx),%edx
  8021db:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8021dd:	85 db                	test   %ebx,%ebx
  8021df:	74 0b                	je     8021ec <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8021e1:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8021e7:	8b 52 78             	mov    0x78(%edx),%edx
  8021ea:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8021ec:	85 c0                	test   %eax,%eax
  8021ee:	78 21                	js     802211 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8021f0:	a1 04 40 80 00       	mov    0x804004,%eax
  8021f5:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021fb:	5b                   	pop    %ebx
  8021fc:	5e                   	pop    %esi
  8021fd:	5d                   	pop    %ebp
  8021fe:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8021ff:	83 ec 0c             	sub    $0xc,%esp
  802202:	68 00 00 c0 ee       	push   $0xeec00000
  802207:	e8 31 ee ff ff       	call   80103d <sys_ipc_recv>
  80220c:	83 c4 10             	add    $0x10,%esp
  80220f:	eb bd                	jmp    8021ce <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802211:	85 f6                	test   %esi,%esi
  802213:	74 10                	je     802225 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802215:	85 db                	test   %ebx,%ebx
  802217:	75 df                	jne    8021f8 <ipc_recv+0x4c>
  802219:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802220:	00 00 00 
  802223:	eb d3                	jmp    8021f8 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802225:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80222c:	00 00 00 
  80222f:	eb e4                	jmp    802215 <ipc_recv+0x69>

00802231 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802231:	f3 0f 1e fb          	endbr32 
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	57                   	push   %edi
  802239:	56                   	push   %esi
  80223a:	53                   	push   %ebx
  80223b:	83 ec 0c             	sub    $0xc,%esp
  80223e:	8b 7d 08             	mov    0x8(%ebp),%edi
  802241:	8b 75 0c             	mov    0xc(%ebp),%esi
  802244:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802247:	85 db                	test   %ebx,%ebx
  802249:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80224e:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802251:	ff 75 14             	pushl  0x14(%ebp)
  802254:	53                   	push   %ebx
  802255:	56                   	push   %esi
  802256:	57                   	push   %edi
  802257:	e8 ba ed ff ff       	call   801016 <sys_ipc_try_send>
  80225c:	83 c4 10             	add    $0x10,%esp
  80225f:	85 c0                	test   %eax,%eax
  802261:	79 1e                	jns    802281 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802263:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802266:	75 07                	jne    80226f <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802268:	e8 e1 eb ff ff       	call   800e4e <sys_yield>
  80226d:	eb e2                	jmp    802251 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  80226f:	50                   	push   %eax
  802270:	68 2e 2c 80 00       	push   $0x802c2e
  802275:	6a 59                	push   $0x59
  802277:	68 49 2c 80 00       	push   $0x802c49
  80227c:	e8 bd e0 ff ff       	call   80033e <_panic>
	}
}
  802281:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802284:	5b                   	pop    %ebx
  802285:	5e                   	pop    %esi
  802286:	5f                   	pop    %edi
  802287:	5d                   	pop    %ebp
  802288:	c3                   	ret    

00802289 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802289:	f3 0f 1e fb          	endbr32 
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802293:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802298:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80229b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022a1:	8b 52 50             	mov    0x50(%edx),%edx
  8022a4:	39 ca                	cmp    %ecx,%edx
  8022a6:	74 11                	je     8022b9 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8022a8:	83 c0 01             	add    $0x1,%eax
  8022ab:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022b0:	75 e6                	jne    802298 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8022b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b7:	eb 0b                	jmp    8022c4 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8022b9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8022bc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022c1:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022c4:	5d                   	pop    %ebp
  8022c5:	c3                   	ret    

008022c6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022c6:	f3 0f 1e fb          	endbr32 
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022d0:	89 c2                	mov    %eax,%edx
  8022d2:	c1 ea 16             	shr    $0x16,%edx
  8022d5:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8022dc:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8022e1:	f6 c1 01             	test   $0x1,%cl
  8022e4:	74 1c                	je     802302 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8022e6:	c1 e8 0c             	shr    $0xc,%eax
  8022e9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8022f0:	a8 01                	test   $0x1,%al
  8022f2:	74 0e                	je     802302 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022f4:	c1 e8 0c             	shr    $0xc,%eax
  8022f7:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8022fe:	ef 
  8022ff:	0f b7 d2             	movzwl %dx,%edx
}
  802302:	89 d0                	mov    %edx,%eax
  802304:	5d                   	pop    %ebp
  802305:	c3                   	ret    
  802306:	66 90                	xchg   %ax,%ax
  802308:	66 90                	xchg   %ax,%ax
  80230a:	66 90                	xchg   %ax,%ax
  80230c:	66 90                	xchg   %ax,%ax
  80230e:	66 90                	xchg   %ax,%ax

00802310 <__udivdi3>:
  802310:	f3 0f 1e fb          	endbr32 
  802314:	55                   	push   %ebp
  802315:	57                   	push   %edi
  802316:	56                   	push   %esi
  802317:	53                   	push   %ebx
  802318:	83 ec 1c             	sub    $0x1c,%esp
  80231b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80231f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802323:	8b 74 24 34          	mov    0x34(%esp),%esi
  802327:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80232b:	85 d2                	test   %edx,%edx
  80232d:	75 19                	jne    802348 <__udivdi3+0x38>
  80232f:	39 f3                	cmp    %esi,%ebx
  802331:	76 4d                	jbe    802380 <__udivdi3+0x70>
  802333:	31 ff                	xor    %edi,%edi
  802335:	89 e8                	mov    %ebp,%eax
  802337:	89 f2                	mov    %esi,%edx
  802339:	f7 f3                	div    %ebx
  80233b:	89 fa                	mov    %edi,%edx
  80233d:	83 c4 1c             	add    $0x1c,%esp
  802340:	5b                   	pop    %ebx
  802341:	5e                   	pop    %esi
  802342:	5f                   	pop    %edi
  802343:	5d                   	pop    %ebp
  802344:	c3                   	ret    
  802345:	8d 76 00             	lea    0x0(%esi),%esi
  802348:	39 f2                	cmp    %esi,%edx
  80234a:	76 14                	jbe    802360 <__udivdi3+0x50>
  80234c:	31 ff                	xor    %edi,%edi
  80234e:	31 c0                	xor    %eax,%eax
  802350:	89 fa                	mov    %edi,%edx
  802352:	83 c4 1c             	add    $0x1c,%esp
  802355:	5b                   	pop    %ebx
  802356:	5e                   	pop    %esi
  802357:	5f                   	pop    %edi
  802358:	5d                   	pop    %ebp
  802359:	c3                   	ret    
  80235a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802360:	0f bd fa             	bsr    %edx,%edi
  802363:	83 f7 1f             	xor    $0x1f,%edi
  802366:	75 48                	jne    8023b0 <__udivdi3+0xa0>
  802368:	39 f2                	cmp    %esi,%edx
  80236a:	72 06                	jb     802372 <__udivdi3+0x62>
  80236c:	31 c0                	xor    %eax,%eax
  80236e:	39 eb                	cmp    %ebp,%ebx
  802370:	77 de                	ja     802350 <__udivdi3+0x40>
  802372:	b8 01 00 00 00       	mov    $0x1,%eax
  802377:	eb d7                	jmp    802350 <__udivdi3+0x40>
  802379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802380:	89 d9                	mov    %ebx,%ecx
  802382:	85 db                	test   %ebx,%ebx
  802384:	75 0b                	jne    802391 <__udivdi3+0x81>
  802386:	b8 01 00 00 00       	mov    $0x1,%eax
  80238b:	31 d2                	xor    %edx,%edx
  80238d:	f7 f3                	div    %ebx
  80238f:	89 c1                	mov    %eax,%ecx
  802391:	31 d2                	xor    %edx,%edx
  802393:	89 f0                	mov    %esi,%eax
  802395:	f7 f1                	div    %ecx
  802397:	89 c6                	mov    %eax,%esi
  802399:	89 e8                	mov    %ebp,%eax
  80239b:	89 f7                	mov    %esi,%edi
  80239d:	f7 f1                	div    %ecx
  80239f:	89 fa                	mov    %edi,%edx
  8023a1:	83 c4 1c             	add    $0x1c,%esp
  8023a4:	5b                   	pop    %ebx
  8023a5:	5e                   	pop    %esi
  8023a6:	5f                   	pop    %edi
  8023a7:	5d                   	pop    %ebp
  8023a8:	c3                   	ret    
  8023a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023b0:	89 f9                	mov    %edi,%ecx
  8023b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023b7:	29 f8                	sub    %edi,%eax
  8023b9:	d3 e2                	shl    %cl,%edx
  8023bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023bf:	89 c1                	mov    %eax,%ecx
  8023c1:	89 da                	mov    %ebx,%edx
  8023c3:	d3 ea                	shr    %cl,%edx
  8023c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023c9:	09 d1                	or     %edx,%ecx
  8023cb:	89 f2                	mov    %esi,%edx
  8023cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023d1:	89 f9                	mov    %edi,%ecx
  8023d3:	d3 e3                	shl    %cl,%ebx
  8023d5:	89 c1                	mov    %eax,%ecx
  8023d7:	d3 ea                	shr    %cl,%edx
  8023d9:	89 f9                	mov    %edi,%ecx
  8023db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023df:	89 eb                	mov    %ebp,%ebx
  8023e1:	d3 e6                	shl    %cl,%esi
  8023e3:	89 c1                	mov    %eax,%ecx
  8023e5:	d3 eb                	shr    %cl,%ebx
  8023e7:	09 de                	or     %ebx,%esi
  8023e9:	89 f0                	mov    %esi,%eax
  8023eb:	f7 74 24 08          	divl   0x8(%esp)
  8023ef:	89 d6                	mov    %edx,%esi
  8023f1:	89 c3                	mov    %eax,%ebx
  8023f3:	f7 64 24 0c          	mull   0xc(%esp)
  8023f7:	39 d6                	cmp    %edx,%esi
  8023f9:	72 15                	jb     802410 <__udivdi3+0x100>
  8023fb:	89 f9                	mov    %edi,%ecx
  8023fd:	d3 e5                	shl    %cl,%ebp
  8023ff:	39 c5                	cmp    %eax,%ebp
  802401:	73 04                	jae    802407 <__udivdi3+0xf7>
  802403:	39 d6                	cmp    %edx,%esi
  802405:	74 09                	je     802410 <__udivdi3+0x100>
  802407:	89 d8                	mov    %ebx,%eax
  802409:	31 ff                	xor    %edi,%edi
  80240b:	e9 40 ff ff ff       	jmp    802350 <__udivdi3+0x40>
  802410:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802413:	31 ff                	xor    %edi,%edi
  802415:	e9 36 ff ff ff       	jmp    802350 <__udivdi3+0x40>
  80241a:	66 90                	xchg   %ax,%ax
  80241c:	66 90                	xchg   %ax,%ax
  80241e:	66 90                	xchg   %ax,%ax

00802420 <__umoddi3>:
  802420:	f3 0f 1e fb          	endbr32 
  802424:	55                   	push   %ebp
  802425:	57                   	push   %edi
  802426:	56                   	push   %esi
  802427:	53                   	push   %ebx
  802428:	83 ec 1c             	sub    $0x1c,%esp
  80242b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80242f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802433:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802437:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80243b:	85 c0                	test   %eax,%eax
  80243d:	75 19                	jne    802458 <__umoddi3+0x38>
  80243f:	39 df                	cmp    %ebx,%edi
  802441:	76 5d                	jbe    8024a0 <__umoddi3+0x80>
  802443:	89 f0                	mov    %esi,%eax
  802445:	89 da                	mov    %ebx,%edx
  802447:	f7 f7                	div    %edi
  802449:	89 d0                	mov    %edx,%eax
  80244b:	31 d2                	xor    %edx,%edx
  80244d:	83 c4 1c             	add    $0x1c,%esp
  802450:	5b                   	pop    %ebx
  802451:	5e                   	pop    %esi
  802452:	5f                   	pop    %edi
  802453:	5d                   	pop    %ebp
  802454:	c3                   	ret    
  802455:	8d 76 00             	lea    0x0(%esi),%esi
  802458:	89 f2                	mov    %esi,%edx
  80245a:	39 d8                	cmp    %ebx,%eax
  80245c:	76 12                	jbe    802470 <__umoddi3+0x50>
  80245e:	89 f0                	mov    %esi,%eax
  802460:	89 da                	mov    %ebx,%edx
  802462:	83 c4 1c             	add    $0x1c,%esp
  802465:	5b                   	pop    %ebx
  802466:	5e                   	pop    %esi
  802467:	5f                   	pop    %edi
  802468:	5d                   	pop    %ebp
  802469:	c3                   	ret    
  80246a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802470:	0f bd e8             	bsr    %eax,%ebp
  802473:	83 f5 1f             	xor    $0x1f,%ebp
  802476:	75 50                	jne    8024c8 <__umoddi3+0xa8>
  802478:	39 d8                	cmp    %ebx,%eax
  80247a:	0f 82 e0 00 00 00    	jb     802560 <__umoddi3+0x140>
  802480:	89 d9                	mov    %ebx,%ecx
  802482:	39 f7                	cmp    %esi,%edi
  802484:	0f 86 d6 00 00 00    	jbe    802560 <__umoddi3+0x140>
  80248a:	89 d0                	mov    %edx,%eax
  80248c:	89 ca                	mov    %ecx,%edx
  80248e:	83 c4 1c             	add    $0x1c,%esp
  802491:	5b                   	pop    %ebx
  802492:	5e                   	pop    %esi
  802493:	5f                   	pop    %edi
  802494:	5d                   	pop    %ebp
  802495:	c3                   	ret    
  802496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80249d:	8d 76 00             	lea    0x0(%esi),%esi
  8024a0:	89 fd                	mov    %edi,%ebp
  8024a2:	85 ff                	test   %edi,%edi
  8024a4:	75 0b                	jne    8024b1 <__umoddi3+0x91>
  8024a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ab:	31 d2                	xor    %edx,%edx
  8024ad:	f7 f7                	div    %edi
  8024af:	89 c5                	mov    %eax,%ebp
  8024b1:	89 d8                	mov    %ebx,%eax
  8024b3:	31 d2                	xor    %edx,%edx
  8024b5:	f7 f5                	div    %ebp
  8024b7:	89 f0                	mov    %esi,%eax
  8024b9:	f7 f5                	div    %ebp
  8024bb:	89 d0                	mov    %edx,%eax
  8024bd:	31 d2                	xor    %edx,%edx
  8024bf:	eb 8c                	jmp    80244d <__umoddi3+0x2d>
  8024c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024c8:	89 e9                	mov    %ebp,%ecx
  8024ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8024cf:	29 ea                	sub    %ebp,%edx
  8024d1:	d3 e0                	shl    %cl,%eax
  8024d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024d7:	89 d1                	mov    %edx,%ecx
  8024d9:	89 f8                	mov    %edi,%eax
  8024db:	d3 e8                	shr    %cl,%eax
  8024dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024e9:	09 c1                	or     %eax,%ecx
  8024eb:	89 d8                	mov    %ebx,%eax
  8024ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024f1:	89 e9                	mov    %ebp,%ecx
  8024f3:	d3 e7                	shl    %cl,%edi
  8024f5:	89 d1                	mov    %edx,%ecx
  8024f7:	d3 e8                	shr    %cl,%eax
  8024f9:	89 e9                	mov    %ebp,%ecx
  8024fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024ff:	d3 e3                	shl    %cl,%ebx
  802501:	89 c7                	mov    %eax,%edi
  802503:	89 d1                	mov    %edx,%ecx
  802505:	89 f0                	mov    %esi,%eax
  802507:	d3 e8                	shr    %cl,%eax
  802509:	89 e9                	mov    %ebp,%ecx
  80250b:	89 fa                	mov    %edi,%edx
  80250d:	d3 e6                	shl    %cl,%esi
  80250f:	09 d8                	or     %ebx,%eax
  802511:	f7 74 24 08          	divl   0x8(%esp)
  802515:	89 d1                	mov    %edx,%ecx
  802517:	89 f3                	mov    %esi,%ebx
  802519:	f7 64 24 0c          	mull   0xc(%esp)
  80251d:	89 c6                	mov    %eax,%esi
  80251f:	89 d7                	mov    %edx,%edi
  802521:	39 d1                	cmp    %edx,%ecx
  802523:	72 06                	jb     80252b <__umoddi3+0x10b>
  802525:	75 10                	jne    802537 <__umoddi3+0x117>
  802527:	39 c3                	cmp    %eax,%ebx
  802529:	73 0c                	jae    802537 <__umoddi3+0x117>
  80252b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80252f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802533:	89 d7                	mov    %edx,%edi
  802535:	89 c6                	mov    %eax,%esi
  802537:	89 ca                	mov    %ecx,%edx
  802539:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80253e:	29 f3                	sub    %esi,%ebx
  802540:	19 fa                	sbb    %edi,%edx
  802542:	89 d0                	mov    %edx,%eax
  802544:	d3 e0                	shl    %cl,%eax
  802546:	89 e9                	mov    %ebp,%ecx
  802548:	d3 eb                	shr    %cl,%ebx
  80254a:	d3 ea                	shr    %cl,%edx
  80254c:	09 d8                	or     %ebx,%eax
  80254e:	83 c4 1c             	add    $0x1c,%esp
  802551:	5b                   	pop    %ebx
  802552:	5e                   	pop    %esi
  802553:	5f                   	pop    %edi
  802554:	5d                   	pop    %ebp
  802555:	c3                   	ret    
  802556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80255d:	8d 76 00             	lea    0x0(%esi),%esi
  802560:	29 fe                	sub    %edi,%esi
  802562:	19 c3                	sbb    %eax,%ebx
  802564:	89 f2                	mov    %esi,%edx
  802566:	89 d9                	mov    %ebx,%ecx
  802568:	e9 1d ff ff ff       	jmp    80248a <__umoddi3+0x6a>
