
obj/user/testshell.debug:     file format elf32-i386


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
  80002c:	e8 7d 04 00 00       	call   8004ae <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 84 00 00 00    	sub    $0x84,%esp
  800043:	8b 75 08             	mov    0x8(%ebp),%esi
  800046:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800049:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  80004c:	53                   	push   %ebx
  80004d:	56                   	push   %esi
  80004e:	e8 64 19 00 00       	call   8019b7 <seek>
	seek(kfd, off);
  800053:	83 c4 08             	add    $0x8,%esp
  800056:	53                   	push   %ebx
  800057:	57                   	push   %edi
  800058:	e8 5a 19 00 00       	call   8019b7 <seek>

	cprintf("shell produced incorrect output.\n");
  80005d:	c7 04 24 c0 2b 80 00 	movl   $0x802bc0,(%esp)
  800064:	e8 94 05 00 00       	call   8005fd <cprintf>
	cprintf("expected:\n===\n");
  800069:	c7 04 24 2b 2c 80 00 	movl   $0x802c2b,(%esp)
  800070:	e8 88 05 00 00       	call   8005fd <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  80007b:	83 ec 04             	sub    $0x4,%esp
  80007e:	6a 63                	push   $0x63
  800080:	53                   	push   %ebx
  800081:	57                   	push   %edi
  800082:	e8 d4 17 00 00       	call   80185b <read>
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	85 c0                	test   %eax,%eax
  80008c:	7e 0f                	jle    80009d <wrong+0x6a>
		sys_cputs(buf, n);
  80008e:	83 ec 08             	sub    $0x8,%esp
  800091:	50                   	push   %eax
  800092:	53                   	push   %ebx
  800093:	e8 e1 0e 00 00       	call   800f79 <sys_cputs>
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	eb de                	jmp    80007b <wrong+0x48>
	cprintf("===\ngot:\n===\n");
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	68 3a 2c 80 00       	push   $0x802c3a
  8000a5:	e8 53 05 00 00       	call   8005fd <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000aa:	83 c4 10             	add    $0x10,%esp
  8000ad:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000b0:	eb 0d                	jmp    8000bf <wrong+0x8c>
		sys_cputs(buf, n);
  8000b2:	83 ec 08             	sub    $0x8,%esp
  8000b5:	50                   	push   %eax
  8000b6:	53                   	push   %ebx
  8000b7:	e8 bd 0e 00 00       	call   800f79 <sys_cputs>
  8000bc:	83 c4 10             	add    $0x10,%esp
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000bf:	83 ec 04             	sub    $0x4,%esp
  8000c2:	6a 63                	push   $0x63
  8000c4:	53                   	push   %ebx
  8000c5:	56                   	push   %esi
  8000c6:	e8 90 17 00 00       	call   80185b <read>
  8000cb:	83 c4 10             	add    $0x10,%esp
  8000ce:	85 c0                	test   %eax,%eax
  8000d0:	7f e0                	jg     8000b2 <wrong+0x7f>
	cprintf("===\n");
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 35 2c 80 00       	push   $0x802c35
  8000da:	e8 1e 05 00 00       	call   8005fd <cprintf>
	exit();
  8000df:	e8 14 04 00 00       	call   8004f8 <exit>
}
  8000e4:	83 c4 10             	add    $0x10,%esp
  8000e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000ea:	5b                   	pop    %ebx
  8000eb:	5e                   	pop    %esi
  8000ec:	5f                   	pop    %edi
  8000ed:	5d                   	pop    %ebp
  8000ee:	c3                   	ret    

008000ef <umain>:
{
  8000ef:	f3 0f 1e fb          	endbr32 
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	57                   	push   %edi
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 38             	sub    $0x38,%esp
	close(0);
  8000fc:	6a 00                	push   $0x0
  8000fe:	e8 0e 16 00 00       	call   801711 <close>
	close(1);
  800103:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80010a:	e8 02 16 00 00       	call   801711 <close>
	opencons();
  80010f:	e8 44 03 00 00       	call   800458 <opencons>
	opencons();
  800114:	e8 3f 03 00 00       	call   800458 <opencons>
	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800119:	83 c4 08             	add    $0x8,%esp
  80011c:	6a 00                	push   $0x0
  80011e:	68 48 2c 80 00       	push   $0x802c48
  800123:	e8 c8 1b 00 00       	call   801cf0 <open>
  800128:	89 c3                	mov    %eax,%ebx
  80012a:	83 c4 10             	add    $0x10,%esp
  80012d:	85 c0                	test   %eax,%eax
  80012f:	0f 88 e7 00 00 00    	js     80021c <umain+0x12d>
	if ((wfd = pipe(pfds)) < 0)
  800135:	83 ec 0c             	sub    $0xc,%esp
  800138:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80013b:	50                   	push   %eax
  80013c:	e8 4b 24 00 00       	call   80258c <pipe>
  800141:	83 c4 10             	add    $0x10,%esp
  800144:	85 c0                	test   %eax,%eax
  800146:	0f 88 e2 00 00 00    	js     80022e <umain+0x13f>
	wfd = pfds[1];
  80014c:	8b 75 e0             	mov    -0x20(%ebp),%esi
	cprintf("running sh -x < testshell.sh | cat\n");
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	68 e4 2b 80 00       	push   $0x802be4
  800157:	e8 a1 04 00 00       	call   8005fd <cprintf>
	if ((r = fork()) < 0)
  80015c:	e8 d9 11 00 00       	call   80133a <fork>
  800161:	83 c4 10             	add    $0x10,%esp
  800164:	85 c0                	test   %eax,%eax
  800166:	0f 88 d4 00 00 00    	js     800240 <umain+0x151>
	if (r == 0) {
  80016c:	75 6f                	jne    8001dd <umain+0xee>
		dup(rfd, 0);
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	6a 00                	push   $0x0
  800173:	53                   	push   %ebx
  800174:	e8 f2 15 00 00       	call   80176b <dup>
		dup(wfd, 1);
  800179:	83 c4 08             	add    $0x8,%esp
  80017c:	6a 01                	push   $0x1
  80017e:	56                   	push   %esi
  80017f:	e8 e7 15 00 00       	call   80176b <dup>
		close(rfd);
  800184:	89 1c 24             	mov    %ebx,(%esp)
  800187:	e8 85 15 00 00       	call   801711 <close>
		close(wfd);
  80018c:	89 34 24             	mov    %esi,(%esp)
  80018f:	e8 7d 15 00 00       	call   801711 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  800194:	6a 00                	push   $0x0
  800196:	68 85 2c 80 00       	push   $0x802c85
  80019b:	68 52 2c 80 00       	push   $0x802c52
  8001a0:	68 88 2c 80 00       	push   $0x802c88
  8001a5:	e8 4f 21 00 00       	call   8022f9 <spawnl>
  8001aa:	89 c7                	mov    %eax,%edi
  8001ac:	83 c4 20             	add    $0x20,%esp
  8001af:	85 c0                	test   %eax,%eax
  8001b1:	0f 88 9b 00 00 00    	js     800252 <umain+0x163>
		close(0);
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	6a 00                	push   $0x0
  8001bc:	e8 50 15 00 00       	call   801711 <close>
		close(1);
  8001c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001c8:	e8 44 15 00 00       	call   801711 <close>
		wait(r);
  8001cd:	89 3c 24             	mov    %edi,(%esp)
  8001d0:	e8 3c 25 00 00       	call   802711 <wait>
		exit();
  8001d5:	e8 1e 03 00 00       	call   8004f8 <exit>
  8001da:	83 c4 10             	add    $0x10,%esp
	close(rfd);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	53                   	push   %ebx
  8001e1:	e8 2b 15 00 00       	call   801711 <close>
	close(wfd);
  8001e6:	89 34 24             	mov    %esi,(%esp)
  8001e9:	e8 23 15 00 00       	call   801711 <close>
	rfd = pfds[0];
  8001ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8001f4:	83 c4 08             	add    $0x8,%esp
  8001f7:	6a 00                	push   $0x0
  8001f9:	68 96 2c 80 00       	push   $0x802c96
  8001fe:	e8 ed 1a 00 00       	call   801cf0 <open>
  800203:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800206:	83 c4 10             	add    $0x10,%esp
  800209:	85 c0                	test   %eax,%eax
  80020b:	78 57                	js     800264 <umain+0x175>
  80020d:	be 01 00 00 00       	mov    $0x1,%esi
	nloff = 0;
  800212:	bf 00 00 00 00       	mov    $0x0,%edi
  800217:	e9 9a 00 00 00       	jmp    8002b6 <umain+0x1c7>
		panic("open testshell.sh: %e", rfd);
  80021c:	50                   	push   %eax
  80021d:	68 55 2c 80 00       	push   $0x802c55
  800222:	6a 13                	push   $0x13
  800224:	68 6b 2c 80 00       	push   $0x802c6b
  800229:	e8 e8 02 00 00       	call   800516 <_panic>
		panic("pipe: %e", wfd);
  80022e:	50                   	push   %eax
  80022f:	68 7c 2c 80 00       	push   $0x802c7c
  800234:	6a 15                	push   $0x15
  800236:	68 6b 2c 80 00       	push   $0x802c6b
  80023b:	e8 d6 02 00 00       	call   800516 <_panic>
		panic("fork: %e", r);
  800240:	50                   	push   %eax
  800241:	68 85 30 80 00       	push   $0x803085
  800246:	6a 1a                	push   $0x1a
  800248:	68 6b 2c 80 00       	push   $0x802c6b
  80024d:	e8 c4 02 00 00       	call   800516 <_panic>
			panic("spawn: %e", r);
  800252:	50                   	push   %eax
  800253:	68 8c 2c 80 00       	push   $0x802c8c
  800258:	6a 21                	push   $0x21
  80025a:	68 6b 2c 80 00       	push   $0x802c6b
  80025f:	e8 b2 02 00 00       	call   800516 <_panic>
		panic("open testshell.key for reading: %e", kfd);
  800264:	50                   	push   %eax
  800265:	68 08 2c 80 00       	push   $0x802c08
  80026a:	6a 2c                	push   $0x2c
  80026c:	68 6b 2c 80 00       	push   $0x802c6b
  800271:	e8 a0 02 00 00       	call   800516 <_panic>
			panic("reading testshell.out: %e", n1);
  800276:	53                   	push   %ebx
  800277:	68 a4 2c 80 00       	push   $0x802ca4
  80027c:	6a 33                	push   $0x33
  80027e:	68 6b 2c 80 00       	push   $0x802c6b
  800283:	e8 8e 02 00 00       	call   800516 <_panic>
			panic("reading testshell.key: %e", n2);
  800288:	50                   	push   %eax
  800289:	68 be 2c 80 00       	push   $0x802cbe
  80028e:	6a 35                	push   $0x35
  800290:	68 6b 2c 80 00       	push   $0x802c6b
  800295:	e8 7c 02 00 00       	call   800516 <_panic>
			wrong(rfd, kfd, nloff);
  80029a:	83 ec 04             	sub    $0x4,%esp
  80029d:	57                   	push   %edi
  80029e:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002a1:	ff 75 d0             	pushl  -0x30(%ebp)
  8002a4:	e8 8a fd ff ff       	call   800033 <wrong>
  8002a9:	83 c4 10             	add    $0x10,%esp
			nloff = off+1;
  8002ac:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8002b0:	0f 44 fe             	cmove  %esi,%edi
  8002b3:	83 c6 01             	add    $0x1,%esi
		n1 = read(rfd, &c1, 1);
  8002b6:	83 ec 04             	sub    $0x4,%esp
  8002b9:	6a 01                	push   $0x1
  8002bb:	8d 45 e7             	lea    -0x19(%ebp),%eax
  8002be:	50                   	push   %eax
  8002bf:	ff 75 d0             	pushl  -0x30(%ebp)
  8002c2:	e8 94 15 00 00       	call   80185b <read>
  8002c7:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002c9:	83 c4 0c             	add    $0xc,%esp
  8002cc:	6a 01                	push   $0x1
  8002ce:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002d1:	50                   	push   %eax
  8002d2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002d5:	e8 81 15 00 00       	call   80185b <read>
		if (n1 < 0)
  8002da:	83 c4 10             	add    $0x10,%esp
  8002dd:	85 db                	test   %ebx,%ebx
  8002df:	78 95                	js     800276 <umain+0x187>
		if (n2 < 0)
  8002e1:	85 c0                	test   %eax,%eax
  8002e3:	78 a3                	js     800288 <umain+0x199>
		if (n1 == 0 && n2 == 0)
  8002e5:	89 da                	mov    %ebx,%edx
  8002e7:	09 c2                	or     %eax,%edx
  8002e9:	74 15                	je     800300 <umain+0x211>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8002eb:	83 fb 01             	cmp    $0x1,%ebx
  8002ee:	75 aa                	jne    80029a <umain+0x1ab>
  8002f0:	83 f8 01             	cmp    $0x1,%eax
  8002f3:	75 a5                	jne    80029a <umain+0x1ab>
  8002f5:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  8002f9:	38 45 e7             	cmp    %al,-0x19(%ebp)
  8002fc:	75 9c                	jne    80029a <umain+0x1ab>
  8002fe:	eb ac                	jmp    8002ac <umain+0x1bd>
	cprintf("shell ran correctly\n");
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	68 d8 2c 80 00       	push   $0x802cd8
  800308:	e8 f0 02 00 00       	call   8005fd <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80030d:	cc                   	int3   
}
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800314:	5b                   	pop    %ebx
  800315:	5e                   	pop    %esi
  800316:	5f                   	pop    %edi
  800317:	5d                   	pop    %ebp
  800318:	c3                   	ret    

00800319 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800319:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80031d:	b8 00 00 00 00       	mov    $0x0,%eax
  800322:	c3                   	ret    

00800323 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800323:	f3 0f 1e fb          	endbr32 
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80032d:	68 ed 2c 80 00       	push   $0x802ced
  800332:	ff 75 0c             	pushl  0xc(%ebp)
  800335:	e8 cd 08 00 00       	call   800c07 <strcpy>
	return 0;
}
  80033a:	b8 00 00 00 00       	mov    $0x0,%eax
  80033f:	c9                   	leave  
  800340:	c3                   	ret    

00800341 <devcons_write>:
{
  800341:	f3 0f 1e fb          	endbr32 
  800345:	55                   	push   %ebp
  800346:	89 e5                	mov    %esp,%ebp
  800348:	57                   	push   %edi
  800349:	56                   	push   %esi
  80034a:	53                   	push   %ebx
  80034b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800351:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800356:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80035c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80035f:	73 31                	jae    800392 <devcons_write+0x51>
		m = n - tot;
  800361:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800364:	29 f3                	sub    %esi,%ebx
  800366:	83 fb 7f             	cmp    $0x7f,%ebx
  800369:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80036e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800371:	83 ec 04             	sub    $0x4,%esp
  800374:	53                   	push   %ebx
  800375:	89 f0                	mov    %esi,%eax
  800377:	03 45 0c             	add    0xc(%ebp),%eax
  80037a:	50                   	push   %eax
  80037b:	57                   	push   %edi
  80037c:	e8 3c 0a 00 00       	call   800dbd <memmove>
		sys_cputs(buf, m);
  800381:	83 c4 08             	add    $0x8,%esp
  800384:	53                   	push   %ebx
  800385:	57                   	push   %edi
  800386:	e8 ee 0b 00 00       	call   800f79 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80038b:	01 de                	add    %ebx,%esi
  80038d:	83 c4 10             	add    $0x10,%esp
  800390:	eb ca                	jmp    80035c <devcons_write+0x1b>
}
  800392:	89 f0                	mov    %esi,%eax
  800394:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800397:	5b                   	pop    %ebx
  800398:	5e                   	pop    %esi
  800399:	5f                   	pop    %edi
  80039a:	5d                   	pop    %ebp
  80039b:	c3                   	ret    

0080039c <devcons_read>:
{
  80039c:	f3 0f 1e fb          	endbr32 
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	83 ec 08             	sub    $0x8,%esp
  8003a6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8003ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8003af:	74 21                	je     8003d2 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8003b1:	e8 e5 0b 00 00       	call   800f9b <sys_cgetc>
  8003b6:	85 c0                	test   %eax,%eax
  8003b8:	75 07                	jne    8003c1 <devcons_read+0x25>
		sys_yield();
  8003ba:	e8 67 0c 00 00       	call   801026 <sys_yield>
  8003bf:	eb f0                	jmp    8003b1 <devcons_read+0x15>
	if (c < 0)
  8003c1:	78 0f                	js     8003d2 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8003c3:	83 f8 04             	cmp    $0x4,%eax
  8003c6:	74 0c                	je     8003d4 <devcons_read+0x38>
	*(char*)vbuf = c;
  8003c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003cb:	88 02                	mov    %al,(%edx)
	return 1;
  8003cd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    
		return 0;
  8003d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d9:	eb f7                	jmp    8003d2 <devcons_read+0x36>

008003db <cputchar>:
{
  8003db:	f3 0f 1e fb          	endbr32 
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8003e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8003eb:	6a 01                	push   $0x1
  8003ed:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003f0:	50                   	push   %eax
  8003f1:	e8 83 0b 00 00       	call   800f79 <sys_cputs>
}
  8003f6:	83 c4 10             	add    $0x10,%esp
  8003f9:	c9                   	leave  
  8003fa:	c3                   	ret    

008003fb <getchar>:
{
  8003fb:	f3 0f 1e fb          	endbr32 
  8003ff:	55                   	push   %ebp
  800400:	89 e5                	mov    %esp,%ebp
  800402:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800405:	6a 01                	push   $0x1
  800407:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80040a:	50                   	push   %eax
  80040b:	6a 00                	push   $0x0
  80040d:	e8 49 14 00 00       	call   80185b <read>
	if (r < 0)
  800412:	83 c4 10             	add    $0x10,%esp
  800415:	85 c0                	test   %eax,%eax
  800417:	78 06                	js     80041f <getchar+0x24>
	if (r < 1)
  800419:	74 06                	je     800421 <getchar+0x26>
	return c;
  80041b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80041f:	c9                   	leave  
  800420:	c3                   	ret    
		return -E_EOF;
  800421:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800426:	eb f7                	jmp    80041f <getchar+0x24>

00800428 <iscons>:
{
  800428:	f3 0f 1e fb          	endbr32 
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800432:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800435:	50                   	push   %eax
  800436:	ff 75 08             	pushl  0x8(%ebp)
  800439:	e8 9a 11 00 00       	call   8015d8 <fd_lookup>
  80043e:	83 c4 10             	add    $0x10,%esp
  800441:	85 c0                	test   %eax,%eax
  800443:	78 11                	js     800456 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  800445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800448:	8b 15 00 40 80 00    	mov    0x804000,%edx
  80044e:	39 10                	cmp    %edx,(%eax)
  800450:	0f 94 c0             	sete   %al
  800453:	0f b6 c0             	movzbl %al,%eax
}
  800456:	c9                   	leave  
  800457:	c3                   	ret    

00800458 <opencons>:
{
  800458:	f3 0f 1e fb          	endbr32 
  80045c:	55                   	push   %ebp
  80045d:	89 e5                	mov    %esp,%ebp
  80045f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800462:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800465:	50                   	push   %eax
  800466:	e8 17 11 00 00       	call   801582 <fd_alloc>
  80046b:	83 c4 10             	add    $0x10,%esp
  80046e:	85 c0                	test   %eax,%eax
  800470:	78 3a                	js     8004ac <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800472:	83 ec 04             	sub    $0x4,%esp
  800475:	68 07 04 00 00       	push   $0x407
  80047a:	ff 75 f4             	pushl  -0xc(%ebp)
  80047d:	6a 00                	push   $0x0
  80047f:	e8 c5 0b 00 00       	call   801049 <sys_page_alloc>
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	85 c0                	test   %eax,%eax
  800489:	78 21                	js     8004ac <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80048b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80048e:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800494:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800499:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8004a0:	83 ec 0c             	sub    $0xc,%esp
  8004a3:	50                   	push   %eax
  8004a4:	e8 aa 10 00 00       	call   801553 <fd2num>
  8004a9:	83 c4 10             	add    $0x10,%esp
}
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8004ae:	f3 0f 1e fb          	endbr32 
  8004b2:	55                   	push   %ebp
  8004b3:	89 e5                	mov    %esp,%ebp
  8004b5:	56                   	push   %esi
  8004b6:	53                   	push   %ebx
  8004b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004ba:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8004bd:	e8 41 0b 00 00       	call   801003 <sys_getenvid>
  8004c2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004c7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8004ca:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004cf:	a3 04 50 80 00       	mov    %eax,0x805004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004d4:	85 db                	test   %ebx,%ebx
  8004d6:	7e 07                	jle    8004df <libmain+0x31>
		binaryname = argv[0];
  8004d8:	8b 06                	mov    (%esi),%eax
  8004da:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  8004df:	83 ec 08             	sub    $0x8,%esp
  8004e2:	56                   	push   %esi
  8004e3:	53                   	push   %ebx
  8004e4:	e8 06 fc ff ff       	call   8000ef <umain>

	// exit gracefully
	exit();
  8004e9:	e8 0a 00 00 00       	call   8004f8 <exit>
}
  8004ee:	83 c4 10             	add    $0x10,%esp
  8004f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8004f4:	5b                   	pop    %ebx
  8004f5:	5e                   	pop    %esi
  8004f6:	5d                   	pop    %ebp
  8004f7:	c3                   	ret    

008004f8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004f8:	f3 0f 1e fb          	endbr32 
  8004fc:	55                   	push   %ebp
  8004fd:	89 e5                	mov    %esp,%ebp
  8004ff:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800502:	e8 3b 12 00 00       	call   801742 <close_all>
	sys_env_destroy(0);
  800507:	83 ec 0c             	sub    $0xc,%esp
  80050a:	6a 00                	push   $0x0
  80050c:	e8 ad 0a 00 00       	call   800fbe <sys_env_destroy>
}
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	c9                   	leave  
  800515:	c3                   	ret    

00800516 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800516:	f3 0f 1e fb          	endbr32 
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
  80051d:	56                   	push   %esi
  80051e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80051f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800522:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  800528:	e8 d6 0a 00 00       	call   801003 <sys_getenvid>
  80052d:	83 ec 0c             	sub    $0xc,%esp
  800530:	ff 75 0c             	pushl  0xc(%ebp)
  800533:	ff 75 08             	pushl  0x8(%ebp)
  800536:	56                   	push   %esi
  800537:	50                   	push   %eax
  800538:	68 04 2d 80 00       	push   $0x802d04
  80053d:	e8 bb 00 00 00       	call   8005fd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800542:	83 c4 18             	add    $0x18,%esp
  800545:	53                   	push   %ebx
  800546:	ff 75 10             	pushl  0x10(%ebp)
  800549:	e8 5a 00 00 00       	call   8005a8 <vcprintf>
	cprintf("\n");
  80054e:	c7 04 24 38 2c 80 00 	movl   $0x802c38,(%esp)
  800555:	e8 a3 00 00 00       	call   8005fd <cprintf>
  80055a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80055d:	cc                   	int3   
  80055e:	eb fd                	jmp    80055d <_panic+0x47>

00800560 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800560:	f3 0f 1e fb          	endbr32 
  800564:	55                   	push   %ebp
  800565:	89 e5                	mov    %esp,%ebp
  800567:	53                   	push   %ebx
  800568:	83 ec 04             	sub    $0x4,%esp
  80056b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80056e:	8b 13                	mov    (%ebx),%edx
  800570:	8d 42 01             	lea    0x1(%edx),%eax
  800573:	89 03                	mov    %eax,(%ebx)
  800575:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800578:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80057c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800581:	74 09                	je     80058c <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800583:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800587:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80058a:	c9                   	leave  
  80058b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80058c:	83 ec 08             	sub    $0x8,%esp
  80058f:	68 ff 00 00 00       	push   $0xff
  800594:	8d 43 08             	lea    0x8(%ebx),%eax
  800597:	50                   	push   %eax
  800598:	e8 dc 09 00 00       	call   800f79 <sys_cputs>
		b->idx = 0;
  80059d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8005a3:	83 c4 10             	add    $0x10,%esp
  8005a6:	eb db                	jmp    800583 <putch+0x23>

008005a8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005a8:	f3 0f 1e fb          	endbr32 
  8005ac:	55                   	push   %ebp
  8005ad:	89 e5                	mov    %esp,%ebp
  8005af:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005b5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005bc:	00 00 00 
	b.cnt = 0;
  8005bf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005c6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005c9:	ff 75 0c             	pushl  0xc(%ebp)
  8005cc:	ff 75 08             	pushl  0x8(%ebp)
  8005cf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005d5:	50                   	push   %eax
  8005d6:	68 60 05 80 00       	push   $0x800560
  8005db:	e8 20 01 00 00       	call   800700 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005e0:	83 c4 08             	add    $0x8,%esp
  8005e3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005e9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005ef:	50                   	push   %eax
  8005f0:	e8 84 09 00 00       	call   800f79 <sys_cputs>

	return b.cnt;
}
  8005f5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005fb:	c9                   	leave  
  8005fc:	c3                   	ret    

008005fd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005fd:	f3 0f 1e fb          	endbr32 
  800601:	55                   	push   %ebp
  800602:	89 e5                	mov    %esp,%ebp
  800604:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800607:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80060a:	50                   	push   %eax
  80060b:	ff 75 08             	pushl  0x8(%ebp)
  80060e:	e8 95 ff ff ff       	call   8005a8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800613:	c9                   	leave  
  800614:	c3                   	ret    

00800615 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800615:	55                   	push   %ebp
  800616:	89 e5                	mov    %esp,%ebp
  800618:	57                   	push   %edi
  800619:	56                   	push   %esi
  80061a:	53                   	push   %ebx
  80061b:	83 ec 1c             	sub    $0x1c,%esp
  80061e:	89 c7                	mov    %eax,%edi
  800620:	89 d6                	mov    %edx,%esi
  800622:	8b 45 08             	mov    0x8(%ebp),%eax
  800625:	8b 55 0c             	mov    0xc(%ebp),%edx
  800628:	89 d1                	mov    %edx,%ecx
  80062a:	89 c2                	mov    %eax,%edx
  80062c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800632:	8b 45 10             	mov    0x10(%ebp),%eax
  800635:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800638:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80063b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800642:	39 c2                	cmp    %eax,%edx
  800644:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800647:	72 3e                	jb     800687 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800649:	83 ec 0c             	sub    $0xc,%esp
  80064c:	ff 75 18             	pushl  0x18(%ebp)
  80064f:	83 eb 01             	sub    $0x1,%ebx
  800652:	53                   	push   %ebx
  800653:	50                   	push   %eax
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	ff 75 e4             	pushl  -0x1c(%ebp)
  80065a:	ff 75 e0             	pushl  -0x20(%ebp)
  80065d:	ff 75 dc             	pushl  -0x24(%ebp)
  800660:	ff 75 d8             	pushl  -0x28(%ebp)
  800663:	e8 f8 22 00 00       	call   802960 <__udivdi3>
  800668:	83 c4 18             	add    $0x18,%esp
  80066b:	52                   	push   %edx
  80066c:	50                   	push   %eax
  80066d:	89 f2                	mov    %esi,%edx
  80066f:	89 f8                	mov    %edi,%eax
  800671:	e8 9f ff ff ff       	call   800615 <printnum>
  800676:	83 c4 20             	add    $0x20,%esp
  800679:	eb 13                	jmp    80068e <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	56                   	push   %esi
  80067f:	ff 75 18             	pushl  0x18(%ebp)
  800682:	ff d7                	call   *%edi
  800684:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800687:	83 eb 01             	sub    $0x1,%ebx
  80068a:	85 db                	test   %ebx,%ebx
  80068c:	7f ed                	jg     80067b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	56                   	push   %esi
  800692:	83 ec 04             	sub    $0x4,%esp
  800695:	ff 75 e4             	pushl  -0x1c(%ebp)
  800698:	ff 75 e0             	pushl  -0x20(%ebp)
  80069b:	ff 75 dc             	pushl  -0x24(%ebp)
  80069e:	ff 75 d8             	pushl  -0x28(%ebp)
  8006a1:	e8 ca 23 00 00       	call   802a70 <__umoddi3>
  8006a6:	83 c4 14             	add    $0x14,%esp
  8006a9:	0f be 80 27 2d 80 00 	movsbl 0x802d27(%eax),%eax
  8006b0:	50                   	push   %eax
  8006b1:	ff d7                	call   *%edi
}
  8006b3:	83 c4 10             	add    $0x10,%esp
  8006b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006b9:	5b                   	pop    %ebx
  8006ba:	5e                   	pop    %esi
  8006bb:	5f                   	pop    %edi
  8006bc:	5d                   	pop    %ebp
  8006bd:	c3                   	ret    

008006be <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006be:	f3 0f 1e fb          	endbr32 
  8006c2:	55                   	push   %ebp
  8006c3:	89 e5                	mov    %esp,%ebp
  8006c5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006c8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006cc:	8b 10                	mov    (%eax),%edx
  8006ce:	3b 50 04             	cmp    0x4(%eax),%edx
  8006d1:	73 0a                	jae    8006dd <sprintputch+0x1f>
		*b->buf++ = ch;
  8006d3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8006d6:	89 08                	mov    %ecx,(%eax)
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	88 02                	mov    %al,(%edx)
}
  8006dd:	5d                   	pop    %ebp
  8006de:	c3                   	ret    

008006df <printfmt>:
{
  8006df:	f3 0f 1e fb          	endbr32 
  8006e3:	55                   	push   %ebp
  8006e4:	89 e5                	mov    %esp,%ebp
  8006e6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006e9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006ec:	50                   	push   %eax
  8006ed:	ff 75 10             	pushl  0x10(%ebp)
  8006f0:	ff 75 0c             	pushl  0xc(%ebp)
  8006f3:	ff 75 08             	pushl  0x8(%ebp)
  8006f6:	e8 05 00 00 00       	call   800700 <vprintfmt>
}
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	c9                   	leave  
  8006ff:	c3                   	ret    

00800700 <vprintfmt>:
{
  800700:	f3 0f 1e fb          	endbr32 
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	57                   	push   %edi
  800708:	56                   	push   %esi
  800709:	53                   	push   %ebx
  80070a:	83 ec 3c             	sub    $0x3c,%esp
  80070d:	8b 75 08             	mov    0x8(%ebp),%esi
  800710:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800713:	8b 7d 10             	mov    0x10(%ebp),%edi
  800716:	e9 8e 03 00 00       	jmp    800aa9 <vprintfmt+0x3a9>
		padc = ' ';
  80071b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80071f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800726:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80072d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800734:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800739:	8d 47 01             	lea    0x1(%edi),%eax
  80073c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80073f:	0f b6 17             	movzbl (%edi),%edx
  800742:	8d 42 dd             	lea    -0x23(%edx),%eax
  800745:	3c 55                	cmp    $0x55,%al
  800747:	0f 87 df 03 00 00    	ja     800b2c <vprintfmt+0x42c>
  80074d:	0f b6 c0             	movzbl %al,%eax
  800750:	3e ff 24 85 60 2e 80 	notrack jmp *0x802e60(,%eax,4)
  800757:	00 
  800758:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80075b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80075f:	eb d8                	jmp    800739 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800761:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800764:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800768:	eb cf                	jmp    800739 <vprintfmt+0x39>
  80076a:	0f b6 d2             	movzbl %dl,%edx
  80076d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800770:	b8 00 00 00 00       	mov    $0x0,%eax
  800775:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800778:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80077b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80077f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800782:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800785:	83 f9 09             	cmp    $0x9,%ecx
  800788:	77 55                	ja     8007df <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80078a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80078d:	eb e9                	jmp    800778 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	8d 40 04             	lea    0x4(%eax),%eax
  80079d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8007a3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007a7:	79 90                	jns    800739 <vprintfmt+0x39>
				width = precision, precision = -1;
  8007a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007af:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8007b6:	eb 81                	jmp    800739 <vprintfmt+0x39>
  8007b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007bb:	85 c0                	test   %eax,%eax
  8007bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c2:	0f 49 d0             	cmovns %eax,%edx
  8007c5:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007cb:	e9 69 ff ff ff       	jmp    800739 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8007d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8007d3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8007da:	e9 5a ff ff ff       	jmp    800739 <vprintfmt+0x39>
  8007df:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8007e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e5:	eb bc                	jmp    8007a3 <vprintfmt+0xa3>
			lflag++;
  8007e7:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007ed:	e9 47 ff ff ff       	jmp    800739 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	8d 78 04             	lea    0x4(%eax),%edi
  8007f8:	83 ec 08             	sub    $0x8,%esp
  8007fb:	53                   	push   %ebx
  8007fc:	ff 30                	pushl  (%eax)
  8007fe:	ff d6                	call   *%esi
			break;
  800800:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800803:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800806:	e9 9b 02 00 00       	jmp    800aa6 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	8d 78 04             	lea    0x4(%eax),%edi
  800811:	8b 00                	mov    (%eax),%eax
  800813:	99                   	cltd   
  800814:	31 d0                	xor    %edx,%eax
  800816:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800818:	83 f8 0f             	cmp    $0xf,%eax
  80081b:	7f 23                	jg     800840 <vprintfmt+0x140>
  80081d:	8b 14 85 c0 2f 80 00 	mov    0x802fc0(,%eax,4),%edx
  800824:	85 d2                	test   %edx,%edx
  800826:	74 18                	je     800840 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800828:	52                   	push   %edx
  800829:	68 81 31 80 00       	push   $0x803181
  80082e:	53                   	push   %ebx
  80082f:	56                   	push   %esi
  800830:	e8 aa fe ff ff       	call   8006df <printfmt>
  800835:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800838:	89 7d 14             	mov    %edi,0x14(%ebp)
  80083b:	e9 66 02 00 00       	jmp    800aa6 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800840:	50                   	push   %eax
  800841:	68 3f 2d 80 00       	push   $0x802d3f
  800846:	53                   	push   %ebx
  800847:	56                   	push   %esi
  800848:	e8 92 fe ff ff       	call   8006df <printfmt>
  80084d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800850:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800853:	e9 4e 02 00 00       	jmp    800aa6 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	83 c0 04             	add    $0x4,%eax
  80085e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800866:	85 d2                	test   %edx,%edx
  800868:	b8 38 2d 80 00       	mov    $0x802d38,%eax
  80086d:	0f 45 c2             	cmovne %edx,%eax
  800870:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800873:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800877:	7e 06                	jle    80087f <vprintfmt+0x17f>
  800879:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80087d:	75 0d                	jne    80088c <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80087f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800882:	89 c7                	mov    %eax,%edi
  800884:	03 45 e0             	add    -0x20(%ebp),%eax
  800887:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80088a:	eb 55                	jmp    8008e1 <vprintfmt+0x1e1>
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	ff 75 d8             	pushl  -0x28(%ebp)
  800892:	ff 75 cc             	pushl  -0x34(%ebp)
  800895:	e8 46 03 00 00       	call   800be0 <strnlen>
  80089a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80089d:	29 c2                	sub    %eax,%edx
  80089f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8008a2:	83 c4 10             	add    $0x10,%esp
  8008a5:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8008a7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8008ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ae:	85 ff                	test   %edi,%edi
  8008b0:	7e 11                	jle    8008c3 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	53                   	push   %ebx
  8008b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8008b9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8008bb:	83 ef 01             	sub    $0x1,%edi
  8008be:	83 c4 10             	add    $0x10,%esp
  8008c1:	eb eb                	jmp    8008ae <vprintfmt+0x1ae>
  8008c3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8008c6:	85 d2                	test   %edx,%edx
  8008c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cd:	0f 49 c2             	cmovns %edx,%eax
  8008d0:	29 c2                	sub    %eax,%edx
  8008d2:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8008d5:	eb a8                	jmp    80087f <vprintfmt+0x17f>
					putch(ch, putdat);
  8008d7:	83 ec 08             	sub    $0x8,%esp
  8008da:	53                   	push   %ebx
  8008db:	52                   	push   %edx
  8008dc:	ff d6                	call   *%esi
  8008de:	83 c4 10             	add    $0x10,%esp
  8008e1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008e4:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e6:	83 c7 01             	add    $0x1,%edi
  8008e9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008ed:	0f be d0             	movsbl %al,%edx
  8008f0:	85 d2                	test   %edx,%edx
  8008f2:	74 4b                	je     80093f <vprintfmt+0x23f>
  8008f4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008f8:	78 06                	js     800900 <vprintfmt+0x200>
  8008fa:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8008fe:	78 1e                	js     80091e <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800900:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800904:	74 d1                	je     8008d7 <vprintfmt+0x1d7>
  800906:	0f be c0             	movsbl %al,%eax
  800909:	83 e8 20             	sub    $0x20,%eax
  80090c:	83 f8 5e             	cmp    $0x5e,%eax
  80090f:	76 c6                	jbe    8008d7 <vprintfmt+0x1d7>
					putch('?', putdat);
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	53                   	push   %ebx
  800915:	6a 3f                	push   $0x3f
  800917:	ff d6                	call   *%esi
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	eb c3                	jmp    8008e1 <vprintfmt+0x1e1>
  80091e:	89 cf                	mov    %ecx,%edi
  800920:	eb 0e                	jmp    800930 <vprintfmt+0x230>
				putch(' ', putdat);
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	53                   	push   %ebx
  800926:	6a 20                	push   $0x20
  800928:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80092a:	83 ef 01             	sub    $0x1,%edi
  80092d:	83 c4 10             	add    $0x10,%esp
  800930:	85 ff                	test   %edi,%edi
  800932:	7f ee                	jg     800922 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800934:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800937:	89 45 14             	mov    %eax,0x14(%ebp)
  80093a:	e9 67 01 00 00       	jmp    800aa6 <vprintfmt+0x3a6>
  80093f:	89 cf                	mov    %ecx,%edi
  800941:	eb ed                	jmp    800930 <vprintfmt+0x230>
	if (lflag >= 2)
  800943:	83 f9 01             	cmp    $0x1,%ecx
  800946:	7f 1b                	jg     800963 <vprintfmt+0x263>
	else if (lflag)
  800948:	85 c9                	test   %ecx,%ecx
  80094a:	74 63                	je     8009af <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80094c:	8b 45 14             	mov    0x14(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800954:	99                   	cltd   
  800955:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800958:	8b 45 14             	mov    0x14(%ebp),%eax
  80095b:	8d 40 04             	lea    0x4(%eax),%eax
  80095e:	89 45 14             	mov    %eax,0x14(%ebp)
  800961:	eb 17                	jmp    80097a <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800963:	8b 45 14             	mov    0x14(%ebp),%eax
  800966:	8b 50 04             	mov    0x4(%eax),%edx
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80096e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800971:	8b 45 14             	mov    0x14(%ebp),%eax
  800974:	8d 40 08             	lea    0x8(%eax),%eax
  800977:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80097a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80097d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800980:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800985:	85 c9                	test   %ecx,%ecx
  800987:	0f 89 ff 00 00 00    	jns    800a8c <vprintfmt+0x38c>
				putch('-', putdat);
  80098d:	83 ec 08             	sub    $0x8,%esp
  800990:	53                   	push   %ebx
  800991:	6a 2d                	push   $0x2d
  800993:	ff d6                	call   *%esi
				num = -(long long) num;
  800995:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800998:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80099b:	f7 da                	neg    %edx
  80099d:	83 d1 00             	adc    $0x0,%ecx
  8009a0:	f7 d9                	neg    %ecx
  8009a2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8009a5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009aa:	e9 dd 00 00 00       	jmp    800a8c <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8009af:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b2:	8b 00                	mov    (%eax),%eax
  8009b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009b7:	99                   	cltd   
  8009b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009be:	8d 40 04             	lea    0x4(%eax),%eax
  8009c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c4:	eb b4                	jmp    80097a <vprintfmt+0x27a>
	if (lflag >= 2)
  8009c6:	83 f9 01             	cmp    $0x1,%ecx
  8009c9:	7f 1e                	jg     8009e9 <vprintfmt+0x2e9>
	else if (lflag)
  8009cb:	85 c9                	test   %ecx,%ecx
  8009cd:	74 32                	je     800a01 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8009cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d2:	8b 10                	mov    (%eax),%edx
  8009d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009d9:	8d 40 04             	lea    0x4(%eax),%eax
  8009dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009df:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8009e4:	e9 a3 00 00 00       	jmp    800a8c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8009e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ec:	8b 10                	mov    (%eax),%edx
  8009ee:	8b 48 04             	mov    0x4(%eax),%ecx
  8009f1:	8d 40 08             	lea    0x8(%eax),%eax
  8009f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009f7:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8009fc:	e9 8b 00 00 00       	jmp    800a8c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800a01:	8b 45 14             	mov    0x14(%ebp),%eax
  800a04:	8b 10                	mov    (%eax),%edx
  800a06:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a0b:	8d 40 04             	lea    0x4(%eax),%eax
  800a0e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a11:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800a16:	eb 74                	jmp    800a8c <vprintfmt+0x38c>
	if (lflag >= 2)
  800a18:	83 f9 01             	cmp    $0x1,%ecx
  800a1b:	7f 1b                	jg     800a38 <vprintfmt+0x338>
	else if (lflag)
  800a1d:	85 c9                	test   %ecx,%ecx
  800a1f:	74 2c                	je     800a4d <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800a21:	8b 45 14             	mov    0x14(%ebp),%eax
  800a24:	8b 10                	mov    (%eax),%edx
  800a26:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a2b:	8d 40 04             	lea    0x4(%eax),%eax
  800a2e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a31:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800a36:	eb 54                	jmp    800a8c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800a38:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3b:	8b 10                	mov    (%eax),%edx
  800a3d:	8b 48 04             	mov    0x4(%eax),%ecx
  800a40:	8d 40 08             	lea    0x8(%eax),%eax
  800a43:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a46:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800a4b:	eb 3f                	jmp    800a8c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800a4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a50:	8b 10                	mov    (%eax),%edx
  800a52:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a57:	8d 40 04             	lea    0x4(%eax),%eax
  800a5a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a5d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800a62:	eb 28                	jmp    800a8c <vprintfmt+0x38c>
			putch('0', putdat);
  800a64:	83 ec 08             	sub    $0x8,%esp
  800a67:	53                   	push   %ebx
  800a68:	6a 30                	push   $0x30
  800a6a:	ff d6                	call   *%esi
			putch('x', putdat);
  800a6c:	83 c4 08             	add    $0x8,%esp
  800a6f:	53                   	push   %ebx
  800a70:	6a 78                	push   $0x78
  800a72:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a74:	8b 45 14             	mov    0x14(%ebp),%eax
  800a77:	8b 10                	mov    (%eax),%edx
  800a79:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800a7e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a81:	8d 40 04             	lea    0x4(%eax),%eax
  800a84:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a87:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a8c:	83 ec 0c             	sub    $0xc,%esp
  800a8f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800a93:	57                   	push   %edi
  800a94:	ff 75 e0             	pushl  -0x20(%ebp)
  800a97:	50                   	push   %eax
  800a98:	51                   	push   %ecx
  800a99:	52                   	push   %edx
  800a9a:	89 da                	mov    %ebx,%edx
  800a9c:	89 f0                	mov    %esi,%eax
  800a9e:	e8 72 fb ff ff       	call   800615 <printnum>
			break;
  800aa3:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800aa6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800aa9:	83 c7 01             	add    $0x1,%edi
  800aac:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ab0:	83 f8 25             	cmp    $0x25,%eax
  800ab3:	0f 84 62 fc ff ff    	je     80071b <vprintfmt+0x1b>
			if (ch == '\0')
  800ab9:	85 c0                	test   %eax,%eax
  800abb:	0f 84 8b 00 00 00    	je     800b4c <vprintfmt+0x44c>
			putch(ch, putdat);
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	53                   	push   %ebx
  800ac5:	50                   	push   %eax
  800ac6:	ff d6                	call   *%esi
  800ac8:	83 c4 10             	add    $0x10,%esp
  800acb:	eb dc                	jmp    800aa9 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800acd:	83 f9 01             	cmp    $0x1,%ecx
  800ad0:	7f 1b                	jg     800aed <vprintfmt+0x3ed>
	else if (lflag)
  800ad2:	85 c9                	test   %ecx,%ecx
  800ad4:	74 2c                	je     800b02 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800ad6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad9:	8b 10                	mov    (%eax),%edx
  800adb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ae0:	8d 40 04             	lea    0x4(%eax),%eax
  800ae3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ae6:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800aeb:	eb 9f                	jmp    800a8c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800aed:	8b 45 14             	mov    0x14(%ebp),%eax
  800af0:	8b 10                	mov    (%eax),%edx
  800af2:	8b 48 04             	mov    0x4(%eax),%ecx
  800af5:	8d 40 08             	lea    0x8(%eax),%eax
  800af8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800afb:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800b00:	eb 8a                	jmp    800a8c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800b02:	8b 45 14             	mov    0x14(%ebp),%eax
  800b05:	8b 10                	mov    (%eax),%edx
  800b07:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b0c:	8d 40 04             	lea    0x4(%eax),%eax
  800b0f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b12:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800b17:	e9 70 ff ff ff       	jmp    800a8c <vprintfmt+0x38c>
			putch(ch, putdat);
  800b1c:	83 ec 08             	sub    $0x8,%esp
  800b1f:	53                   	push   %ebx
  800b20:	6a 25                	push   $0x25
  800b22:	ff d6                	call   *%esi
			break;
  800b24:	83 c4 10             	add    $0x10,%esp
  800b27:	e9 7a ff ff ff       	jmp    800aa6 <vprintfmt+0x3a6>
			putch('%', putdat);
  800b2c:	83 ec 08             	sub    $0x8,%esp
  800b2f:	53                   	push   %ebx
  800b30:	6a 25                	push   $0x25
  800b32:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b34:	83 c4 10             	add    $0x10,%esp
  800b37:	89 f8                	mov    %edi,%eax
  800b39:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b3d:	74 05                	je     800b44 <vprintfmt+0x444>
  800b3f:	83 e8 01             	sub    $0x1,%eax
  800b42:	eb f5                	jmp    800b39 <vprintfmt+0x439>
  800b44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b47:	e9 5a ff ff ff       	jmp    800aa6 <vprintfmt+0x3a6>
}
  800b4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b4f:	5b                   	pop    %ebx
  800b50:	5e                   	pop    %esi
  800b51:	5f                   	pop    %edi
  800b52:	5d                   	pop    %ebp
  800b53:	c3                   	ret    

00800b54 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b54:	f3 0f 1e fb          	endbr32 
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	83 ec 18             	sub    $0x18,%esp
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b67:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b6b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b75:	85 c0                	test   %eax,%eax
  800b77:	74 26                	je     800b9f <vsnprintf+0x4b>
  800b79:	85 d2                	test   %edx,%edx
  800b7b:	7e 22                	jle    800b9f <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b7d:	ff 75 14             	pushl  0x14(%ebp)
  800b80:	ff 75 10             	pushl  0x10(%ebp)
  800b83:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b86:	50                   	push   %eax
  800b87:	68 be 06 80 00       	push   $0x8006be
  800b8c:	e8 6f fb ff ff       	call   800700 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b94:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b9a:	83 c4 10             	add    $0x10,%esp
}
  800b9d:	c9                   	leave  
  800b9e:	c3                   	ret    
		return -E_INVAL;
  800b9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ba4:	eb f7                	jmp    800b9d <vsnprintf+0x49>

00800ba6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ba6:	f3 0f 1e fb          	endbr32 
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bb0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bb3:	50                   	push   %eax
  800bb4:	ff 75 10             	pushl  0x10(%ebp)
  800bb7:	ff 75 0c             	pushl  0xc(%ebp)
  800bba:	ff 75 08             	pushl  0x8(%ebp)
  800bbd:	e8 92 ff ff ff       	call   800b54 <vsnprintf>
	va_end(ap);

	return rc;
}
  800bc2:	c9                   	leave  
  800bc3:	c3                   	ret    

00800bc4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bc4:	f3 0f 1e fb          	endbr32 
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bce:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bd7:	74 05                	je     800bde <strlen+0x1a>
		n++;
  800bd9:	83 c0 01             	add    $0x1,%eax
  800bdc:	eb f5                	jmp    800bd3 <strlen+0xf>
	return n;
}
  800bde:	5d                   	pop    %ebp
  800bdf:	c3                   	ret    

00800be0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800be0:	f3 0f 1e fb          	endbr32 
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bea:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bed:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf2:	39 d0                	cmp    %edx,%eax
  800bf4:	74 0d                	je     800c03 <strnlen+0x23>
  800bf6:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800bfa:	74 05                	je     800c01 <strnlen+0x21>
		n++;
  800bfc:	83 c0 01             	add    $0x1,%eax
  800bff:	eb f1                	jmp    800bf2 <strnlen+0x12>
  800c01:	89 c2                	mov    %eax,%edx
	return n;
}
  800c03:	89 d0                	mov    %edx,%eax
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    

00800c07 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c07:	f3 0f 1e fb          	endbr32 
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	53                   	push   %ebx
  800c0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c12:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c15:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1a:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800c1e:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800c21:	83 c0 01             	add    $0x1,%eax
  800c24:	84 d2                	test   %dl,%dl
  800c26:	75 f2                	jne    800c1a <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800c28:	89 c8                	mov    %ecx,%eax
  800c2a:	5b                   	pop    %ebx
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    

00800c2d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c2d:	f3 0f 1e fb          	endbr32 
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	53                   	push   %ebx
  800c35:	83 ec 10             	sub    $0x10,%esp
  800c38:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c3b:	53                   	push   %ebx
  800c3c:	e8 83 ff ff ff       	call   800bc4 <strlen>
  800c41:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c44:	ff 75 0c             	pushl  0xc(%ebp)
  800c47:	01 d8                	add    %ebx,%eax
  800c49:	50                   	push   %eax
  800c4a:	e8 b8 ff ff ff       	call   800c07 <strcpy>
	return dst;
}
  800c4f:	89 d8                	mov    %ebx,%eax
  800c51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c56:	f3 0f 1e fb          	endbr32 
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	56                   	push   %esi
  800c5e:	53                   	push   %ebx
  800c5f:	8b 75 08             	mov    0x8(%ebp),%esi
  800c62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c65:	89 f3                	mov    %esi,%ebx
  800c67:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c6a:	89 f0                	mov    %esi,%eax
  800c6c:	39 d8                	cmp    %ebx,%eax
  800c6e:	74 11                	je     800c81 <strncpy+0x2b>
		*dst++ = *src;
  800c70:	83 c0 01             	add    $0x1,%eax
  800c73:	0f b6 0a             	movzbl (%edx),%ecx
  800c76:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c79:	80 f9 01             	cmp    $0x1,%cl
  800c7c:	83 da ff             	sbb    $0xffffffff,%edx
  800c7f:	eb eb                	jmp    800c6c <strncpy+0x16>
	}
	return ret;
}
  800c81:	89 f0                	mov    %esi,%eax
  800c83:	5b                   	pop    %ebx
  800c84:	5e                   	pop    %esi
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    

00800c87 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c87:	f3 0f 1e fb          	endbr32 
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
  800c90:	8b 75 08             	mov    0x8(%ebp),%esi
  800c93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c96:	8b 55 10             	mov    0x10(%ebp),%edx
  800c99:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c9b:	85 d2                	test   %edx,%edx
  800c9d:	74 21                	je     800cc0 <strlcpy+0x39>
  800c9f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ca3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ca5:	39 c2                	cmp    %eax,%edx
  800ca7:	74 14                	je     800cbd <strlcpy+0x36>
  800ca9:	0f b6 19             	movzbl (%ecx),%ebx
  800cac:	84 db                	test   %bl,%bl
  800cae:	74 0b                	je     800cbb <strlcpy+0x34>
			*dst++ = *src++;
  800cb0:	83 c1 01             	add    $0x1,%ecx
  800cb3:	83 c2 01             	add    $0x1,%edx
  800cb6:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cb9:	eb ea                	jmp    800ca5 <strlcpy+0x1e>
  800cbb:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800cbd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc0:	29 f0                	sub    %esi,%eax
}
  800cc2:	5b                   	pop    %ebx
  800cc3:	5e                   	pop    %esi
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    

00800cc6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc6:	f3 0f 1e fb          	endbr32 
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cd3:	0f b6 01             	movzbl (%ecx),%eax
  800cd6:	84 c0                	test   %al,%al
  800cd8:	74 0c                	je     800ce6 <strcmp+0x20>
  800cda:	3a 02                	cmp    (%edx),%al
  800cdc:	75 08                	jne    800ce6 <strcmp+0x20>
		p++, q++;
  800cde:	83 c1 01             	add    $0x1,%ecx
  800ce1:	83 c2 01             	add    $0x1,%edx
  800ce4:	eb ed                	jmp    800cd3 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce6:	0f b6 c0             	movzbl %al,%eax
  800ce9:	0f b6 12             	movzbl (%edx),%edx
  800cec:	29 d0                	sub    %edx,%eax
}
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cf0:	f3 0f 1e fb          	endbr32 
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	53                   	push   %ebx
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfe:	89 c3                	mov    %eax,%ebx
  800d00:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d03:	eb 06                	jmp    800d0b <strncmp+0x1b>
		n--, p++, q++;
  800d05:	83 c0 01             	add    $0x1,%eax
  800d08:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d0b:	39 d8                	cmp    %ebx,%eax
  800d0d:	74 16                	je     800d25 <strncmp+0x35>
  800d0f:	0f b6 08             	movzbl (%eax),%ecx
  800d12:	84 c9                	test   %cl,%cl
  800d14:	74 04                	je     800d1a <strncmp+0x2a>
  800d16:	3a 0a                	cmp    (%edx),%cl
  800d18:	74 eb                	je     800d05 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1a:	0f b6 00             	movzbl (%eax),%eax
  800d1d:	0f b6 12             	movzbl (%edx),%edx
  800d20:	29 d0                	sub    %edx,%eax
}
  800d22:	5b                   	pop    %ebx
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    
		return 0;
  800d25:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2a:	eb f6                	jmp    800d22 <strncmp+0x32>

00800d2c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d2c:	f3 0f 1e fb          	endbr32 
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d3a:	0f b6 10             	movzbl (%eax),%edx
  800d3d:	84 d2                	test   %dl,%dl
  800d3f:	74 09                	je     800d4a <strchr+0x1e>
		if (*s == c)
  800d41:	38 ca                	cmp    %cl,%dl
  800d43:	74 0a                	je     800d4f <strchr+0x23>
	for (; *s; s++)
  800d45:	83 c0 01             	add    $0x1,%eax
  800d48:	eb f0                	jmp    800d3a <strchr+0xe>
			return (char *) s;
	return 0;
  800d4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    

00800d51 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d51:	f3 0f 1e fb          	endbr32 
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d5f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d62:	38 ca                	cmp    %cl,%dl
  800d64:	74 09                	je     800d6f <strfind+0x1e>
  800d66:	84 d2                	test   %dl,%dl
  800d68:	74 05                	je     800d6f <strfind+0x1e>
	for (; *s; s++)
  800d6a:	83 c0 01             	add    $0x1,%eax
  800d6d:	eb f0                	jmp    800d5f <strfind+0xe>
			break;
	return (char *) s;
}
  800d6f:	5d                   	pop    %ebp
  800d70:	c3                   	ret    

00800d71 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d71:	f3 0f 1e fb          	endbr32 
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
  800d7b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d81:	85 c9                	test   %ecx,%ecx
  800d83:	74 31                	je     800db6 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d85:	89 f8                	mov    %edi,%eax
  800d87:	09 c8                	or     %ecx,%eax
  800d89:	a8 03                	test   $0x3,%al
  800d8b:	75 23                	jne    800db0 <memset+0x3f>
		c &= 0xFF;
  800d8d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d91:	89 d3                	mov    %edx,%ebx
  800d93:	c1 e3 08             	shl    $0x8,%ebx
  800d96:	89 d0                	mov    %edx,%eax
  800d98:	c1 e0 18             	shl    $0x18,%eax
  800d9b:	89 d6                	mov    %edx,%esi
  800d9d:	c1 e6 10             	shl    $0x10,%esi
  800da0:	09 f0                	or     %esi,%eax
  800da2:	09 c2                	or     %eax,%edx
  800da4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800da6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800da9:	89 d0                	mov    %edx,%eax
  800dab:	fc                   	cld    
  800dac:	f3 ab                	rep stos %eax,%es:(%edi)
  800dae:	eb 06                	jmp    800db6 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	fc                   	cld    
  800db4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800db6:	89 f8                	mov    %edi,%eax
  800db8:	5b                   	pop    %ebx
  800db9:	5e                   	pop    %esi
  800dba:	5f                   	pop    %edi
  800dbb:	5d                   	pop    %ebp
  800dbc:	c3                   	ret    

00800dbd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800dbd:	f3 0f 1e fb          	endbr32 
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	57                   	push   %edi
  800dc5:	56                   	push   %esi
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dcc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dcf:	39 c6                	cmp    %eax,%esi
  800dd1:	73 32                	jae    800e05 <memmove+0x48>
  800dd3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dd6:	39 c2                	cmp    %eax,%edx
  800dd8:	76 2b                	jbe    800e05 <memmove+0x48>
		s += n;
		d += n;
  800dda:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ddd:	89 fe                	mov    %edi,%esi
  800ddf:	09 ce                	or     %ecx,%esi
  800de1:	09 d6                	or     %edx,%esi
  800de3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800de9:	75 0e                	jne    800df9 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800deb:	83 ef 04             	sub    $0x4,%edi
  800dee:	8d 72 fc             	lea    -0x4(%edx),%esi
  800df1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800df4:	fd                   	std    
  800df5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800df7:	eb 09                	jmp    800e02 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800df9:	83 ef 01             	sub    $0x1,%edi
  800dfc:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800dff:	fd                   	std    
  800e00:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e02:	fc                   	cld    
  800e03:	eb 1a                	jmp    800e1f <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e05:	89 c2                	mov    %eax,%edx
  800e07:	09 ca                	or     %ecx,%edx
  800e09:	09 f2                	or     %esi,%edx
  800e0b:	f6 c2 03             	test   $0x3,%dl
  800e0e:	75 0a                	jne    800e1a <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e10:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e13:	89 c7                	mov    %eax,%edi
  800e15:	fc                   	cld    
  800e16:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e18:	eb 05                	jmp    800e1f <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800e1a:	89 c7                	mov    %eax,%edi
  800e1c:	fc                   	cld    
  800e1d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e1f:	5e                   	pop    %esi
  800e20:	5f                   	pop    %edi
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    

00800e23 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e23:	f3 0f 1e fb          	endbr32 
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e2d:	ff 75 10             	pushl  0x10(%ebp)
  800e30:	ff 75 0c             	pushl  0xc(%ebp)
  800e33:	ff 75 08             	pushl  0x8(%ebp)
  800e36:	e8 82 ff ff ff       	call   800dbd <memmove>
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e3d:	f3 0f 1e fb          	endbr32 
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	56                   	push   %esi
  800e45:	53                   	push   %ebx
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e4c:	89 c6                	mov    %eax,%esi
  800e4e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e51:	39 f0                	cmp    %esi,%eax
  800e53:	74 1c                	je     800e71 <memcmp+0x34>
		if (*s1 != *s2)
  800e55:	0f b6 08             	movzbl (%eax),%ecx
  800e58:	0f b6 1a             	movzbl (%edx),%ebx
  800e5b:	38 d9                	cmp    %bl,%cl
  800e5d:	75 08                	jne    800e67 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e5f:	83 c0 01             	add    $0x1,%eax
  800e62:	83 c2 01             	add    $0x1,%edx
  800e65:	eb ea                	jmp    800e51 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800e67:	0f b6 c1             	movzbl %cl,%eax
  800e6a:	0f b6 db             	movzbl %bl,%ebx
  800e6d:	29 d8                	sub    %ebx,%eax
  800e6f:	eb 05                	jmp    800e76 <memcmp+0x39>
	}

	return 0;
  800e71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e76:	5b                   	pop    %ebx
  800e77:	5e                   	pop    %esi
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    

00800e7a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e7a:	f3 0f 1e fb          	endbr32 
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e87:	89 c2                	mov    %eax,%edx
  800e89:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e8c:	39 d0                	cmp    %edx,%eax
  800e8e:	73 09                	jae    800e99 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e90:	38 08                	cmp    %cl,(%eax)
  800e92:	74 05                	je     800e99 <memfind+0x1f>
	for (; s < ends; s++)
  800e94:	83 c0 01             	add    $0x1,%eax
  800e97:	eb f3                	jmp    800e8c <memfind+0x12>
			break;
	return (void *) s;
}
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    

00800e9b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e9b:	f3 0f 1e fb          	endbr32 
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	57                   	push   %edi
  800ea3:	56                   	push   %esi
  800ea4:	53                   	push   %ebx
  800ea5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ea8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eab:	eb 03                	jmp    800eb0 <strtol+0x15>
		s++;
  800ead:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800eb0:	0f b6 01             	movzbl (%ecx),%eax
  800eb3:	3c 20                	cmp    $0x20,%al
  800eb5:	74 f6                	je     800ead <strtol+0x12>
  800eb7:	3c 09                	cmp    $0x9,%al
  800eb9:	74 f2                	je     800ead <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ebb:	3c 2b                	cmp    $0x2b,%al
  800ebd:	74 2a                	je     800ee9 <strtol+0x4e>
	int neg = 0;
  800ebf:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ec4:	3c 2d                	cmp    $0x2d,%al
  800ec6:	74 2b                	je     800ef3 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ec8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ece:	75 0f                	jne    800edf <strtol+0x44>
  800ed0:	80 39 30             	cmpb   $0x30,(%ecx)
  800ed3:	74 28                	je     800efd <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ed5:	85 db                	test   %ebx,%ebx
  800ed7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800edc:	0f 44 d8             	cmove  %eax,%ebx
  800edf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ee7:	eb 46                	jmp    800f2f <strtol+0x94>
		s++;
  800ee9:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800eec:	bf 00 00 00 00       	mov    $0x0,%edi
  800ef1:	eb d5                	jmp    800ec8 <strtol+0x2d>
		s++, neg = 1;
  800ef3:	83 c1 01             	add    $0x1,%ecx
  800ef6:	bf 01 00 00 00       	mov    $0x1,%edi
  800efb:	eb cb                	jmp    800ec8 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800efd:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800f01:	74 0e                	je     800f11 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800f03:	85 db                	test   %ebx,%ebx
  800f05:	75 d8                	jne    800edf <strtol+0x44>
		s++, base = 8;
  800f07:	83 c1 01             	add    $0x1,%ecx
  800f0a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f0f:	eb ce                	jmp    800edf <strtol+0x44>
		s += 2, base = 16;
  800f11:	83 c1 02             	add    $0x2,%ecx
  800f14:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f19:	eb c4                	jmp    800edf <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800f1b:	0f be d2             	movsbl %dl,%edx
  800f1e:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f21:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f24:	7d 3a                	jge    800f60 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800f26:	83 c1 01             	add    $0x1,%ecx
  800f29:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f2d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f2f:	0f b6 11             	movzbl (%ecx),%edx
  800f32:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f35:	89 f3                	mov    %esi,%ebx
  800f37:	80 fb 09             	cmp    $0x9,%bl
  800f3a:	76 df                	jbe    800f1b <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800f3c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f3f:	89 f3                	mov    %esi,%ebx
  800f41:	80 fb 19             	cmp    $0x19,%bl
  800f44:	77 08                	ja     800f4e <strtol+0xb3>
			dig = *s - 'a' + 10;
  800f46:	0f be d2             	movsbl %dl,%edx
  800f49:	83 ea 57             	sub    $0x57,%edx
  800f4c:	eb d3                	jmp    800f21 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800f4e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f51:	89 f3                	mov    %esi,%ebx
  800f53:	80 fb 19             	cmp    $0x19,%bl
  800f56:	77 08                	ja     800f60 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800f58:	0f be d2             	movsbl %dl,%edx
  800f5b:	83 ea 37             	sub    $0x37,%edx
  800f5e:	eb c1                	jmp    800f21 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f64:	74 05                	je     800f6b <strtol+0xd0>
		*endptr = (char *) s;
  800f66:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f69:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f6b:	89 c2                	mov    %eax,%edx
  800f6d:	f7 da                	neg    %edx
  800f6f:	85 ff                	test   %edi,%edi
  800f71:	0f 45 c2             	cmovne %edx,%eax
}
  800f74:	5b                   	pop    %ebx
  800f75:	5e                   	pop    %esi
  800f76:	5f                   	pop    %edi
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    

00800f79 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f79:	f3 0f 1e fb          	endbr32 
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	57                   	push   %edi
  800f81:	56                   	push   %esi
  800f82:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f83:	b8 00 00 00 00       	mov    $0x0,%eax
  800f88:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8e:	89 c3                	mov    %eax,%ebx
  800f90:	89 c7                	mov    %eax,%edi
  800f92:	89 c6                	mov    %eax,%esi
  800f94:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f96:	5b                   	pop    %ebx
  800f97:	5e                   	pop    %esi
  800f98:	5f                   	pop    %edi
  800f99:	5d                   	pop    %ebp
  800f9a:	c3                   	ret    

00800f9b <sys_cgetc>:

int
sys_cgetc(void)
{
  800f9b:	f3 0f 1e fb          	endbr32 
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	57                   	push   %edi
  800fa3:	56                   	push   %esi
  800fa4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa5:	ba 00 00 00 00       	mov    $0x0,%edx
  800faa:	b8 01 00 00 00       	mov    $0x1,%eax
  800faf:	89 d1                	mov    %edx,%ecx
  800fb1:	89 d3                	mov    %edx,%ebx
  800fb3:	89 d7                	mov    %edx,%edi
  800fb5:	89 d6                	mov    %edx,%esi
  800fb7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fb9:	5b                   	pop    %ebx
  800fba:	5e                   	pop    %esi
  800fbb:	5f                   	pop    %edi
  800fbc:	5d                   	pop    %ebp
  800fbd:	c3                   	ret    

00800fbe <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fbe:	f3 0f 1e fb          	endbr32 
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	57                   	push   %edi
  800fc6:	56                   	push   %esi
  800fc7:	53                   	push   %ebx
  800fc8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fcb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800fd8:	89 cb                	mov    %ecx,%ebx
  800fda:	89 cf                	mov    %ecx,%edi
  800fdc:	89 ce                	mov    %ecx,%esi
  800fde:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe0:	85 c0                	test   %eax,%eax
  800fe2:	7f 08                	jg     800fec <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fe4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe7:	5b                   	pop    %ebx
  800fe8:	5e                   	pop    %esi
  800fe9:	5f                   	pop    %edi
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fec:	83 ec 0c             	sub    $0xc,%esp
  800fef:	50                   	push   %eax
  800ff0:	6a 03                	push   $0x3
  800ff2:	68 1f 30 80 00       	push   $0x80301f
  800ff7:	6a 23                	push   $0x23
  800ff9:	68 3c 30 80 00       	push   $0x80303c
  800ffe:	e8 13 f5 ff ff       	call   800516 <_panic>

00801003 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801003:	f3 0f 1e fb          	endbr32 
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	57                   	push   %edi
  80100b:	56                   	push   %esi
  80100c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80100d:	ba 00 00 00 00       	mov    $0x0,%edx
  801012:	b8 02 00 00 00       	mov    $0x2,%eax
  801017:	89 d1                	mov    %edx,%ecx
  801019:	89 d3                	mov    %edx,%ebx
  80101b:	89 d7                	mov    %edx,%edi
  80101d:	89 d6                	mov    %edx,%esi
  80101f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801021:	5b                   	pop    %ebx
  801022:	5e                   	pop    %esi
  801023:	5f                   	pop    %edi
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    

00801026 <sys_yield>:

void
sys_yield(void)
{
  801026:	f3 0f 1e fb          	endbr32 
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	57                   	push   %edi
  80102e:	56                   	push   %esi
  80102f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801030:	ba 00 00 00 00       	mov    $0x0,%edx
  801035:	b8 0b 00 00 00       	mov    $0xb,%eax
  80103a:	89 d1                	mov    %edx,%ecx
  80103c:	89 d3                	mov    %edx,%ebx
  80103e:	89 d7                	mov    %edx,%edi
  801040:	89 d6                	mov    %edx,%esi
  801042:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801044:	5b                   	pop    %ebx
  801045:	5e                   	pop    %esi
  801046:	5f                   	pop    %edi
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    

00801049 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801049:	f3 0f 1e fb          	endbr32 
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	57                   	push   %edi
  801051:	56                   	push   %esi
  801052:	53                   	push   %ebx
  801053:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801056:	be 00 00 00 00       	mov    $0x0,%esi
  80105b:	8b 55 08             	mov    0x8(%ebp),%edx
  80105e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801061:	b8 04 00 00 00       	mov    $0x4,%eax
  801066:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801069:	89 f7                	mov    %esi,%edi
  80106b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80106d:	85 c0                	test   %eax,%eax
  80106f:	7f 08                	jg     801079 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801071:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801074:	5b                   	pop    %ebx
  801075:	5e                   	pop    %esi
  801076:	5f                   	pop    %edi
  801077:	5d                   	pop    %ebp
  801078:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801079:	83 ec 0c             	sub    $0xc,%esp
  80107c:	50                   	push   %eax
  80107d:	6a 04                	push   $0x4
  80107f:	68 1f 30 80 00       	push   $0x80301f
  801084:	6a 23                	push   $0x23
  801086:	68 3c 30 80 00       	push   $0x80303c
  80108b:	e8 86 f4 ff ff       	call   800516 <_panic>

00801090 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801090:	f3 0f 1e fb          	endbr32 
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	57                   	push   %edi
  801098:	56                   	push   %esi
  801099:	53                   	push   %ebx
  80109a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80109d:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a3:	b8 05 00 00 00       	mov    $0x5,%eax
  8010a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010ab:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010ae:	8b 75 18             	mov    0x18(%ebp),%esi
  8010b1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010b3:	85 c0                	test   %eax,%eax
  8010b5:	7f 08                	jg     8010bf <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ba:	5b                   	pop    %ebx
  8010bb:	5e                   	pop    %esi
  8010bc:	5f                   	pop    %edi
  8010bd:	5d                   	pop    %ebp
  8010be:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010bf:	83 ec 0c             	sub    $0xc,%esp
  8010c2:	50                   	push   %eax
  8010c3:	6a 05                	push   $0x5
  8010c5:	68 1f 30 80 00       	push   $0x80301f
  8010ca:	6a 23                	push   $0x23
  8010cc:	68 3c 30 80 00       	push   $0x80303c
  8010d1:	e8 40 f4 ff ff       	call   800516 <_panic>

008010d6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8010d6:	f3 0f 1e fb          	endbr32 
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	57                   	push   %edi
  8010de:	56                   	push   %esi
  8010df:	53                   	push   %ebx
  8010e0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ee:	b8 06 00 00 00       	mov    $0x6,%eax
  8010f3:	89 df                	mov    %ebx,%edi
  8010f5:	89 de                	mov    %ebx,%esi
  8010f7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010f9:	85 c0                	test   %eax,%eax
  8010fb:	7f 08                	jg     801105 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801100:	5b                   	pop    %ebx
  801101:	5e                   	pop    %esi
  801102:	5f                   	pop    %edi
  801103:	5d                   	pop    %ebp
  801104:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801105:	83 ec 0c             	sub    $0xc,%esp
  801108:	50                   	push   %eax
  801109:	6a 06                	push   $0x6
  80110b:	68 1f 30 80 00       	push   $0x80301f
  801110:	6a 23                	push   $0x23
  801112:	68 3c 30 80 00       	push   $0x80303c
  801117:	e8 fa f3 ff ff       	call   800516 <_panic>

0080111c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80111c:	f3 0f 1e fb          	endbr32 
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	57                   	push   %edi
  801124:	56                   	push   %esi
  801125:	53                   	push   %ebx
  801126:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801129:	bb 00 00 00 00       	mov    $0x0,%ebx
  80112e:	8b 55 08             	mov    0x8(%ebp),%edx
  801131:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801134:	b8 08 00 00 00       	mov    $0x8,%eax
  801139:	89 df                	mov    %ebx,%edi
  80113b:	89 de                	mov    %ebx,%esi
  80113d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80113f:	85 c0                	test   %eax,%eax
  801141:	7f 08                	jg     80114b <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801143:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801146:	5b                   	pop    %ebx
  801147:	5e                   	pop    %esi
  801148:	5f                   	pop    %edi
  801149:	5d                   	pop    %ebp
  80114a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80114b:	83 ec 0c             	sub    $0xc,%esp
  80114e:	50                   	push   %eax
  80114f:	6a 08                	push   $0x8
  801151:	68 1f 30 80 00       	push   $0x80301f
  801156:	6a 23                	push   $0x23
  801158:	68 3c 30 80 00       	push   $0x80303c
  80115d:	e8 b4 f3 ff ff       	call   800516 <_panic>

00801162 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801162:	f3 0f 1e fb          	endbr32 
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	57                   	push   %edi
  80116a:	56                   	push   %esi
  80116b:	53                   	push   %ebx
  80116c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80116f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801174:	8b 55 08             	mov    0x8(%ebp),%edx
  801177:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117a:	b8 09 00 00 00       	mov    $0x9,%eax
  80117f:	89 df                	mov    %ebx,%edi
  801181:	89 de                	mov    %ebx,%esi
  801183:	cd 30                	int    $0x30
	if(check && ret > 0)
  801185:	85 c0                	test   %eax,%eax
  801187:	7f 08                	jg     801191 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801189:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118c:	5b                   	pop    %ebx
  80118d:	5e                   	pop    %esi
  80118e:	5f                   	pop    %edi
  80118f:	5d                   	pop    %ebp
  801190:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801191:	83 ec 0c             	sub    $0xc,%esp
  801194:	50                   	push   %eax
  801195:	6a 09                	push   $0x9
  801197:	68 1f 30 80 00       	push   $0x80301f
  80119c:	6a 23                	push   $0x23
  80119e:	68 3c 30 80 00       	push   $0x80303c
  8011a3:	e8 6e f3 ff ff       	call   800516 <_panic>

008011a8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011a8:	f3 0f 1e fb          	endbr32 
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	57                   	push   %edi
  8011b0:	56                   	push   %esi
  8011b1:	53                   	push   %ebx
  8011b2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011c5:	89 df                	mov    %ebx,%edi
  8011c7:	89 de                	mov    %ebx,%esi
  8011c9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011cb:	85 c0                	test   %eax,%eax
  8011cd:	7f 08                	jg     8011d7 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d2:	5b                   	pop    %ebx
  8011d3:	5e                   	pop    %esi
  8011d4:	5f                   	pop    %edi
  8011d5:	5d                   	pop    %ebp
  8011d6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d7:	83 ec 0c             	sub    $0xc,%esp
  8011da:	50                   	push   %eax
  8011db:	6a 0a                	push   $0xa
  8011dd:	68 1f 30 80 00       	push   $0x80301f
  8011e2:	6a 23                	push   $0x23
  8011e4:	68 3c 30 80 00       	push   $0x80303c
  8011e9:	e8 28 f3 ff ff       	call   800516 <_panic>

008011ee <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011ee:	f3 0f 1e fb          	endbr32 
  8011f2:	55                   	push   %ebp
  8011f3:	89 e5                	mov    %esp,%ebp
  8011f5:	57                   	push   %edi
  8011f6:	56                   	push   %esi
  8011f7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011fe:	b8 0c 00 00 00       	mov    $0xc,%eax
  801203:	be 00 00 00 00       	mov    $0x0,%esi
  801208:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80120b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80120e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801210:	5b                   	pop    %ebx
  801211:	5e                   	pop    %esi
  801212:	5f                   	pop    %edi
  801213:	5d                   	pop    %ebp
  801214:	c3                   	ret    

00801215 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801215:	f3 0f 1e fb          	endbr32 
  801219:	55                   	push   %ebp
  80121a:	89 e5                	mov    %esp,%ebp
  80121c:	57                   	push   %edi
  80121d:	56                   	push   %esi
  80121e:	53                   	push   %ebx
  80121f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801222:	b9 00 00 00 00       	mov    $0x0,%ecx
  801227:	8b 55 08             	mov    0x8(%ebp),%edx
  80122a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80122f:	89 cb                	mov    %ecx,%ebx
  801231:	89 cf                	mov    %ecx,%edi
  801233:	89 ce                	mov    %ecx,%esi
  801235:	cd 30                	int    $0x30
	if(check && ret > 0)
  801237:	85 c0                	test   %eax,%eax
  801239:	7f 08                	jg     801243 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80123b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80123e:	5b                   	pop    %ebx
  80123f:	5e                   	pop    %esi
  801240:	5f                   	pop    %edi
  801241:	5d                   	pop    %ebp
  801242:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801243:	83 ec 0c             	sub    $0xc,%esp
  801246:	50                   	push   %eax
  801247:	6a 0d                	push   $0xd
  801249:	68 1f 30 80 00       	push   $0x80301f
  80124e:	6a 23                	push   $0x23
  801250:	68 3c 30 80 00       	push   $0x80303c
  801255:	e8 bc f2 ff ff       	call   800516 <_panic>

0080125a <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80125a:	f3 0f 1e fb          	endbr32 
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
  801261:	53                   	push   %ebx
  801262:	83 ec 04             	sub    $0x4,%esp
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801268:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  80126a:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80126e:	74 74                	je     8012e4 <pgfault+0x8a>
  801270:	89 d8                	mov    %ebx,%eax
  801272:	c1 e8 0c             	shr    $0xc,%eax
  801275:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80127c:	f6 c4 08             	test   $0x8,%ah
  80127f:	74 63                	je     8012e4 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  801281:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  801287:	83 ec 0c             	sub    $0xc,%esp
  80128a:	6a 05                	push   $0x5
  80128c:	68 00 f0 7f 00       	push   $0x7ff000
  801291:	6a 00                	push   $0x0
  801293:	53                   	push   %ebx
  801294:	6a 00                	push   $0x0
  801296:	e8 f5 fd ff ff       	call   801090 <sys_page_map>
  80129b:	83 c4 20             	add    $0x20,%esp
  80129e:	85 c0                	test   %eax,%eax
  8012a0:	78 59                	js     8012fb <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  8012a2:	83 ec 04             	sub    $0x4,%esp
  8012a5:	6a 07                	push   $0x7
  8012a7:	53                   	push   %ebx
  8012a8:	6a 00                	push   $0x0
  8012aa:	e8 9a fd ff ff       	call   801049 <sys_page_alloc>
  8012af:	83 c4 10             	add    $0x10,%esp
  8012b2:	85 c0                	test   %eax,%eax
  8012b4:	78 5a                	js     801310 <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  8012b6:	83 ec 04             	sub    $0x4,%esp
  8012b9:	68 00 10 00 00       	push   $0x1000
  8012be:	68 00 f0 7f 00       	push   $0x7ff000
  8012c3:	53                   	push   %ebx
  8012c4:	e8 f4 fa ff ff       	call   800dbd <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  8012c9:	83 c4 08             	add    $0x8,%esp
  8012cc:	68 00 f0 7f 00       	push   $0x7ff000
  8012d1:	6a 00                	push   $0x0
  8012d3:	e8 fe fd ff ff       	call   8010d6 <sys_page_unmap>
  8012d8:	83 c4 10             	add    $0x10,%esp
  8012db:	85 c0                	test   %eax,%eax
  8012dd:	78 46                	js     801325 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  8012df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012e2:	c9                   	leave  
  8012e3:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  8012e4:	83 ec 04             	sub    $0x4,%esp
  8012e7:	68 4a 30 80 00       	push   $0x80304a
  8012ec:	68 d3 00 00 00       	push   $0xd3
  8012f1:	68 66 30 80 00       	push   $0x803066
  8012f6:	e8 1b f2 ff ff       	call   800516 <_panic>
		panic("pgfault: %e\n", r);
  8012fb:	50                   	push   %eax
  8012fc:	68 71 30 80 00       	push   $0x803071
  801301:	68 df 00 00 00       	push   $0xdf
  801306:	68 66 30 80 00       	push   $0x803066
  80130b:	e8 06 f2 ff ff       	call   800516 <_panic>
		panic("pgfault: %e\n", r);
  801310:	50                   	push   %eax
  801311:	68 71 30 80 00       	push   $0x803071
  801316:	68 e3 00 00 00       	push   $0xe3
  80131b:	68 66 30 80 00       	push   $0x803066
  801320:	e8 f1 f1 ff ff       	call   800516 <_panic>
		panic("pgfault: %e\n", r);
  801325:	50                   	push   %eax
  801326:	68 71 30 80 00       	push   $0x803071
  80132b:	68 e9 00 00 00       	push   $0xe9
  801330:	68 66 30 80 00       	push   $0x803066
  801335:	e8 dc f1 ff ff       	call   800516 <_panic>

0080133a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80133a:	f3 0f 1e fb          	endbr32 
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	57                   	push   %edi
  801342:	56                   	push   %esi
  801343:	53                   	push   %ebx
  801344:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  801347:	68 5a 12 80 00       	push   $0x80125a
  80134c:	e8 13 14 00 00       	call   802764 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801351:	b8 07 00 00 00       	mov    $0x7,%eax
  801356:	cd 30                	int    $0x30
  801358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  80135b:	83 c4 10             	add    $0x10,%esp
  80135e:	85 c0                	test   %eax,%eax
  801360:	78 2d                	js     80138f <fork+0x55>
  801362:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801364:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801369:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80136d:	0f 85 9b 00 00 00    	jne    80140e <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  801373:	e8 8b fc ff ff       	call   801003 <sys_getenvid>
  801378:	25 ff 03 00 00       	and    $0x3ff,%eax
  80137d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801380:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801385:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  80138a:	e9 71 01 00 00       	jmp    801500 <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  80138f:	50                   	push   %eax
  801390:	68 7e 30 80 00       	push   $0x80307e
  801395:	68 2a 01 00 00       	push   $0x12a
  80139a:	68 66 30 80 00       	push   $0x803066
  80139f:	e8 72 f1 ff ff       	call   800516 <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  8013a4:	c1 e6 0c             	shl    $0xc,%esi
  8013a7:	83 ec 0c             	sub    $0xc,%esp
  8013aa:	68 07 0e 00 00       	push   $0xe07
  8013af:	56                   	push   %esi
  8013b0:	57                   	push   %edi
  8013b1:	56                   	push   %esi
  8013b2:	6a 00                	push   $0x0
  8013b4:	e8 d7 fc ff ff       	call   801090 <sys_page_map>
  8013b9:	83 c4 20             	add    $0x20,%esp
  8013bc:	eb 3e                	jmp    8013fc <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  8013be:	c1 e6 0c             	shl    $0xc,%esi
  8013c1:	83 ec 0c             	sub    $0xc,%esp
  8013c4:	68 05 08 00 00       	push   $0x805
  8013c9:	56                   	push   %esi
  8013ca:	57                   	push   %edi
  8013cb:	56                   	push   %esi
  8013cc:	6a 00                	push   $0x0
  8013ce:	e8 bd fc ff ff       	call   801090 <sys_page_map>
  8013d3:	83 c4 20             	add    $0x20,%esp
  8013d6:	85 c0                	test   %eax,%eax
  8013d8:	0f 88 bc 00 00 00    	js     80149a <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  8013de:	83 ec 0c             	sub    $0xc,%esp
  8013e1:	68 05 08 00 00       	push   $0x805
  8013e6:	56                   	push   %esi
  8013e7:	6a 00                	push   $0x0
  8013e9:	56                   	push   %esi
  8013ea:	6a 00                	push   $0x0
  8013ec:	e8 9f fc ff ff       	call   801090 <sys_page_map>
  8013f1:	83 c4 20             	add    $0x20,%esp
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	0f 88 b3 00 00 00    	js     8014af <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8013fc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801402:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801408:	0f 84 b6 00 00 00    	je     8014c4 <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  80140e:	89 d8                	mov    %ebx,%eax
  801410:	c1 e8 16             	shr    $0x16,%eax
  801413:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80141a:	a8 01                	test   $0x1,%al
  80141c:	74 de                	je     8013fc <fork+0xc2>
  80141e:	89 de                	mov    %ebx,%esi
  801420:	c1 ee 0c             	shr    $0xc,%esi
  801423:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80142a:	a8 01                	test   $0x1,%al
  80142c:	74 ce                	je     8013fc <fork+0xc2>
  80142e:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801435:	a8 04                	test   $0x4,%al
  801437:	74 c3                	je     8013fc <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  801439:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801440:	f6 c4 04             	test   $0x4,%ah
  801443:	0f 85 5b ff ff ff    	jne    8013a4 <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  801449:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801450:	a8 02                	test   $0x2,%al
  801452:	0f 85 66 ff ff ff    	jne    8013be <fork+0x84>
  801458:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80145f:	f6 c4 08             	test   $0x8,%ah
  801462:	0f 85 56 ff ff ff    	jne    8013be <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801468:	c1 e6 0c             	shl    $0xc,%esi
  80146b:	83 ec 0c             	sub    $0xc,%esp
  80146e:	6a 05                	push   $0x5
  801470:	56                   	push   %esi
  801471:	57                   	push   %edi
  801472:	56                   	push   %esi
  801473:	6a 00                	push   $0x0
  801475:	e8 16 fc ff ff       	call   801090 <sys_page_map>
  80147a:	83 c4 20             	add    $0x20,%esp
  80147d:	85 c0                	test   %eax,%eax
  80147f:	0f 89 77 ff ff ff    	jns    8013fc <fork+0xc2>
		panic("duppage: %e\n", r);
  801485:	50                   	push   %eax
  801486:	68 8e 30 80 00       	push   $0x80308e
  80148b:	68 0c 01 00 00       	push   $0x10c
  801490:	68 66 30 80 00       	push   $0x803066
  801495:	e8 7c f0 ff ff       	call   800516 <_panic>
			panic("duppage: %e\n", r);
  80149a:	50                   	push   %eax
  80149b:	68 8e 30 80 00       	push   $0x80308e
  8014a0:	68 05 01 00 00       	push   $0x105
  8014a5:	68 66 30 80 00       	push   $0x803066
  8014aa:	e8 67 f0 ff ff       	call   800516 <_panic>
			panic("duppage: %e\n", r);
  8014af:	50                   	push   %eax
  8014b0:	68 8e 30 80 00       	push   $0x80308e
  8014b5:	68 09 01 00 00       	push   $0x109
  8014ba:	68 66 30 80 00       	push   $0x803066
  8014bf:	e8 52 f0 ff ff       	call   800516 <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  8014c4:	83 ec 04             	sub    $0x4,%esp
  8014c7:	6a 07                	push   $0x7
  8014c9:	68 00 f0 bf ee       	push   $0xeebff000
  8014ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014d1:	e8 73 fb ff ff       	call   801049 <sys_page_alloc>
  8014d6:	83 c4 10             	add    $0x10,%esp
  8014d9:	85 c0                	test   %eax,%eax
  8014db:	78 2e                	js     80150b <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8014dd:	83 ec 08             	sub    $0x8,%esp
  8014e0:	68 d7 27 80 00       	push   $0x8027d7
  8014e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8014e8:	57                   	push   %edi
  8014e9:	e8 ba fc ff ff       	call   8011a8 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8014ee:	83 c4 08             	add    $0x8,%esp
  8014f1:	6a 02                	push   $0x2
  8014f3:	57                   	push   %edi
  8014f4:	e8 23 fc ff ff       	call   80111c <sys_env_set_status>
  8014f9:	83 c4 10             	add    $0x10,%esp
  8014fc:	85 c0                	test   %eax,%eax
  8014fe:	78 20                	js     801520 <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  801500:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801503:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801506:	5b                   	pop    %ebx
  801507:	5e                   	pop    %esi
  801508:	5f                   	pop    %edi
  801509:	5d                   	pop    %ebp
  80150a:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80150b:	50                   	push   %eax
  80150c:	68 9b 30 80 00       	push   $0x80309b
  801511:	68 3e 01 00 00       	push   $0x13e
  801516:	68 66 30 80 00       	push   $0x803066
  80151b:	e8 f6 ef ff ff       	call   800516 <_panic>
		panic("sys_env_set_status: %e", r);
  801520:	50                   	push   %eax
  801521:	68 ae 30 80 00       	push   $0x8030ae
  801526:	68 43 01 00 00       	push   $0x143
  80152b:	68 66 30 80 00       	push   $0x803066
  801530:	e8 e1 ef ff ff       	call   800516 <_panic>

00801535 <sfork>:

// Challenge!
int
sfork(void)
{
  801535:	f3 0f 1e fb          	endbr32 
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80153f:	68 c5 30 80 00       	push   $0x8030c5
  801544:	68 4c 01 00 00       	push   $0x14c
  801549:	68 66 30 80 00       	push   $0x803066
  80154e:	e8 c3 ef ff ff       	call   800516 <_panic>

00801553 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801553:	f3 0f 1e fb          	endbr32 
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	05 00 00 00 30       	add    $0x30000000,%eax
  801562:	c1 e8 0c             	shr    $0xc,%eax
}
  801565:	5d                   	pop    %ebp
  801566:	c3                   	ret    

00801567 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801567:	f3 0f 1e fb          	endbr32 
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80156e:	8b 45 08             	mov    0x8(%ebp),%eax
  801571:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801576:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80157b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801580:	5d                   	pop    %ebp
  801581:	c3                   	ret    

00801582 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801582:	f3 0f 1e fb          	endbr32 
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80158e:	89 c2                	mov    %eax,%edx
  801590:	c1 ea 16             	shr    $0x16,%edx
  801593:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80159a:	f6 c2 01             	test   $0x1,%dl
  80159d:	74 2d                	je     8015cc <fd_alloc+0x4a>
  80159f:	89 c2                	mov    %eax,%edx
  8015a1:	c1 ea 0c             	shr    $0xc,%edx
  8015a4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015ab:	f6 c2 01             	test   $0x1,%dl
  8015ae:	74 1c                	je     8015cc <fd_alloc+0x4a>
  8015b0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8015b5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015ba:	75 d2                	jne    80158e <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8015c5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8015ca:	eb 0a                	jmp    8015d6 <fd_alloc+0x54>
			*fd_store = fd;
  8015cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015cf:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d6:	5d                   	pop    %ebp
  8015d7:	c3                   	ret    

008015d8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015d8:	f3 0f 1e fb          	endbr32 
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015e2:	83 f8 1f             	cmp    $0x1f,%eax
  8015e5:	77 30                	ja     801617 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015e7:	c1 e0 0c             	shl    $0xc,%eax
  8015ea:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015ef:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8015f5:	f6 c2 01             	test   $0x1,%dl
  8015f8:	74 24                	je     80161e <fd_lookup+0x46>
  8015fa:	89 c2                	mov    %eax,%edx
  8015fc:	c1 ea 0c             	shr    $0xc,%edx
  8015ff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801606:	f6 c2 01             	test   $0x1,%dl
  801609:	74 1a                	je     801625 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80160b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160e:	89 02                	mov    %eax,(%edx)
	return 0;
  801610:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801615:	5d                   	pop    %ebp
  801616:	c3                   	ret    
		return -E_INVAL;
  801617:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80161c:	eb f7                	jmp    801615 <fd_lookup+0x3d>
		return -E_INVAL;
  80161e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801623:	eb f0                	jmp    801615 <fd_lookup+0x3d>
  801625:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80162a:	eb e9                	jmp    801615 <fd_lookup+0x3d>

0080162c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80162c:	f3 0f 1e fb          	endbr32 
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	83 ec 08             	sub    $0x8,%esp
  801636:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801639:	ba 58 31 80 00       	mov    $0x803158,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80163e:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801643:	39 08                	cmp    %ecx,(%eax)
  801645:	74 33                	je     80167a <dev_lookup+0x4e>
  801647:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80164a:	8b 02                	mov    (%edx),%eax
  80164c:	85 c0                	test   %eax,%eax
  80164e:	75 f3                	jne    801643 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801650:	a1 04 50 80 00       	mov    0x805004,%eax
  801655:	8b 40 48             	mov    0x48(%eax),%eax
  801658:	83 ec 04             	sub    $0x4,%esp
  80165b:	51                   	push   %ecx
  80165c:	50                   	push   %eax
  80165d:	68 dc 30 80 00       	push   $0x8030dc
  801662:	e8 96 ef ff ff       	call   8005fd <cprintf>
	*dev = 0;
  801667:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801670:	83 c4 10             	add    $0x10,%esp
  801673:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801678:	c9                   	leave  
  801679:	c3                   	ret    
			*dev = devtab[i];
  80167a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80167d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80167f:	b8 00 00 00 00       	mov    $0x0,%eax
  801684:	eb f2                	jmp    801678 <dev_lookup+0x4c>

00801686 <fd_close>:
{
  801686:	f3 0f 1e fb          	endbr32 
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	57                   	push   %edi
  80168e:	56                   	push   %esi
  80168f:	53                   	push   %ebx
  801690:	83 ec 24             	sub    $0x24,%esp
  801693:	8b 75 08             	mov    0x8(%ebp),%esi
  801696:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801699:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80169c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80169d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016a3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016a6:	50                   	push   %eax
  8016a7:	e8 2c ff ff ff       	call   8015d8 <fd_lookup>
  8016ac:	89 c3                	mov    %eax,%ebx
  8016ae:	83 c4 10             	add    $0x10,%esp
  8016b1:	85 c0                	test   %eax,%eax
  8016b3:	78 05                	js     8016ba <fd_close+0x34>
	    || fd != fd2)
  8016b5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8016b8:	74 16                	je     8016d0 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8016ba:	89 f8                	mov    %edi,%eax
  8016bc:	84 c0                	test   %al,%al
  8016be:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c3:	0f 44 d8             	cmove  %eax,%ebx
}
  8016c6:	89 d8                	mov    %ebx,%eax
  8016c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016cb:	5b                   	pop    %ebx
  8016cc:	5e                   	pop    %esi
  8016cd:	5f                   	pop    %edi
  8016ce:	5d                   	pop    %ebp
  8016cf:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016d0:	83 ec 08             	sub    $0x8,%esp
  8016d3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016d6:	50                   	push   %eax
  8016d7:	ff 36                	pushl  (%esi)
  8016d9:	e8 4e ff ff ff       	call   80162c <dev_lookup>
  8016de:	89 c3                	mov    %eax,%ebx
  8016e0:	83 c4 10             	add    $0x10,%esp
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	78 1a                	js     801701 <fd_close+0x7b>
		if (dev->dev_close)
  8016e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ea:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8016ed:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8016f2:	85 c0                	test   %eax,%eax
  8016f4:	74 0b                	je     801701 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8016f6:	83 ec 0c             	sub    $0xc,%esp
  8016f9:	56                   	push   %esi
  8016fa:	ff d0                	call   *%eax
  8016fc:	89 c3                	mov    %eax,%ebx
  8016fe:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801701:	83 ec 08             	sub    $0x8,%esp
  801704:	56                   	push   %esi
  801705:	6a 00                	push   $0x0
  801707:	e8 ca f9 ff ff       	call   8010d6 <sys_page_unmap>
	return r;
  80170c:	83 c4 10             	add    $0x10,%esp
  80170f:	eb b5                	jmp    8016c6 <fd_close+0x40>

00801711 <close>:

int
close(int fdnum)
{
  801711:	f3 0f 1e fb          	endbr32 
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80171b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80171e:	50                   	push   %eax
  80171f:	ff 75 08             	pushl  0x8(%ebp)
  801722:	e8 b1 fe ff ff       	call   8015d8 <fd_lookup>
  801727:	83 c4 10             	add    $0x10,%esp
  80172a:	85 c0                	test   %eax,%eax
  80172c:	79 02                	jns    801730 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    
		return fd_close(fd, 1);
  801730:	83 ec 08             	sub    $0x8,%esp
  801733:	6a 01                	push   $0x1
  801735:	ff 75 f4             	pushl  -0xc(%ebp)
  801738:	e8 49 ff ff ff       	call   801686 <fd_close>
  80173d:	83 c4 10             	add    $0x10,%esp
  801740:	eb ec                	jmp    80172e <close+0x1d>

00801742 <close_all>:

void
close_all(void)
{
  801742:	f3 0f 1e fb          	endbr32 
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	53                   	push   %ebx
  80174a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80174d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801752:	83 ec 0c             	sub    $0xc,%esp
  801755:	53                   	push   %ebx
  801756:	e8 b6 ff ff ff       	call   801711 <close>
	for (i = 0; i < MAXFD; i++)
  80175b:	83 c3 01             	add    $0x1,%ebx
  80175e:	83 c4 10             	add    $0x10,%esp
  801761:	83 fb 20             	cmp    $0x20,%ebx
  801764:	75 ec                	jne    801752 <close_all+0x10>
}
  801766:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80176b:	f3 0f 1e fb          	endbr32 
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
  801772:	57                   	push   %edi
  801773:	56                   	push   %esi
  801774:	53                   	push   %ebx
  801775:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801778:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80177b:	50                   	push   %eax
  80177c:	ff 75 08             	pushl  0x8(%ebp)
  80177f:	e8 54 fe ff ff       	call   8015d8 <fd_lookup>
  801784:	89 c3                	mov    %eax,%ebx
  801786:	83 c4 10             	add    $0x10,%esp
  801789:	85 c0                	test   %eax,%eax
  80178b:	0f 88 81 00 00 00    	js     801812 <dup+0xa7>
		return r;
	close(newfdnum);
  801791:	83 ec 0c             	sub    $0xc,%esp
  801794:	ff 75 0c             	pushl  0xc(%ebp)
  801797:	e8 75 ff ff ff       	call   801711 <close>

	newfd = INDEX2FD(newfdnum);
  80179c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80179f:	c1 e6 0c             	shl    $0xc,%esi
  8017a2:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8017a8:	83 c4 04             	add    $0x4,%esp
  8017ab:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017ae:	e8 b4 fd ff ff       	call   801567 <fd2data>
  8017b3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017b5:	89 34 24             	mov    %esi,(%esp)
  8017b8:	e8 aa fd ff ff       	call   801567 <fd2data>
  8017bd:	83 c4 10             	add    $0x10,%esp
  8017c0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017c2:	89 d8                	mov    %ebx,%eax
  8017c4:	c1 e8 16             	shr    $0x16,%eax
  8017c7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017ce:	a8 01                	test   $0x1,%al
  8017d0:	74 11                	je     8017e3 <dup+0x78>
  8017d2:	89 d8                	mov    %ebx,%eax
  8017d4:	c1 e8 0c             	shr    $0xc,%eax
  8017d7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017de:	f6 c2 01             	test   $0x1,%dl
  8017e1:	75 39                	jne    80181c <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017e6:	89 d0                	mov    %edx,%eax
  8017e8:	c1 e8 0c             	shr    $0xc,%eax
  8017eb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017f2:	83 ec 0c             	sub    $0xc,%esp
  8017f5:	25 07 0e 00 00       	and    $0xe07,%eax
  8017fa:	50                   	push   %eax
  8017fb:	56                   	push   %esi
  8017fc:	6a 00                	push   $0x0
  8017fe:	52                   	push   %edx
  8017ff:	6a 00                	push   $0x0
  801801:	e8 8a f8 ff ff       	call   801090 <sys_page_map>
  801806:	89 c3                	mov    %eax,%ebx
  801808:	83 c4 20             	add    $0x20,%esp
  80180b:	85 c0                	test   %eax,%eax
  80180d:	78 31                	js     801840 <dup+0xd5>
		goto err;

	return newfdnum;
  80180f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801812:	89 d8                	mov    %ebx,%eax
  801814:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801817:	5b                   	pop    %ebx
  801818:	5e                   	pop    %esi
  801819:	5f                   	pop    %edi
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80181c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801823:	83 ec 0c             	sub    $0xc,%esp
  801826:	25 07 0e 00 00       	and    $0xe07,%eax
  80182b:	50                   	push   %eax
  80182c:	57                   	push   %edi
  80182d:	6a 00                	push   $0x0
  80182f:	53                   	push   %ebx
  801830:	6a 00                	push   $0x0
  801832:	e8 59 f8 ff ff       	call   801090 <sys_page_map>
  801837:	89 c3                	mov    %eax,%ebx
  801839:	83 c4 20             	add    $0x20,%esp
  80183c:	85 c0                	test   %eax,%eax
  80183e:	79 a3                	jns    8017e3 <dup+0x78>
	sys_page_unmap(0, newfd);
  801840:	83 ec 08             	sub    $0x8,%esp
  801843:	56                   	push   %esi
  801844:	6a 00                	push   $0x0
  801846:	e8 8b f8 ff ff       	call   8010d6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80184b:	83 c4 08             	add    $0x8,%esp
  80184e:	57                   	push   %edi
  80184f:	6a 00                	push   $0x0
  801851:	e8 80 f8 ff ff       	call   8010d6 <sys_page_unmap>
	return r;
  801856:	83 c4 10             	add    $0x10,%esp
  801859:	eb b7                	jmp    801812 <dup+0xa7>

0080185b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80185b:	f3 0f 1e fb          	endbr32 
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	53                   	push   %ebx
  801863:	83 ec 1c             	sub    $0x1c,%esp
  801866:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801869:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80186c:	50                   	push   %eax
  80186d:	53                   	push   %ebx
  80186e:	e8 65 fd ff ff       	call   8015d8 <fd_lookup>
  801873:	83 c4 10             	add    $0x10,%esp
  801876:	85 c0                	test   %eax,%eax
  801878:	78 3f                	js     8018b9 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80187a:	83 ec 08             	sub    $0x8,%esp
  80187d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801880:	50                   	push   %eax
  801881:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801884:	ff 30                	pushl  (%eax)
  801886:	e8 a1 fd ff ff       	call   80162c <dev_lookup>
  80188b:	83 c4 10             	add    $0x10,%esp
  80188e:	85 c0                	test   %eax,%eax
  801890:	78 27                	js     8018b9 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801892:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801895:	8b 42 08             	mov    0x8(%edx),%eax
  801898:	83 e0 03             	and    $0x3,%eax
  80189b:	83 f8 01             	cmp    $0x1,%eax
  80189e:	74 1e                	je     8018be <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8018a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a3:	8b 40 08             	mov    0x8(%eax),%eax
  8018a6:	85 c0                	test   %eax,%eax
  8018a8:	74 35                	je     8018df <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018aa:	83 ec 04             	sub    $0x4,%esp
  8018ad:	ff 75 10             	pushl  0x10(%ebp)
  8018b0:	ff 75 0c             	pushl  0xc(%ebp)
  8018b3:	52                   	push   %edx
  8018b4:	ff d0                	call   *%eax
  8018b6:	83 c4 10             	add    $0x10,%esp
}
  8018b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018be:	a1 04 50 80 00       	mov    0x805004,%eax
  8018c3:	8b 40 48             	mov    0x48(%eax),%eax
  8018c6:	83 ec 04             	sub    $0x4,%esp
  8018c9:	53                   	push   %ebx
  8018ca:	50                   	push   %eax
  8018cb:	68 1d 31 80 00       	push   $0x80311d
  8018d0:	e8 28 ed ff ff       	call   8005fd <cprintf>
		return -E_INVAL;
  8018d5:	83 c4 10             	add    $0x10,%esp
  8018d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018dd:	eb da                	jmp    8018b9 <read+0x5e>
		return -E_NOT_SUPP;
  8018df:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018e4:	eb d3                	jmp    8018b9 <read+0x5e>

008018e6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018e6:	f3 0f 1e fb          	endbr32 
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	57                   	push   %edi
  8018ee:	56                   	push   %esi
  8018ef:	53                   	push   %ebx
  8018f0:	83 ec 0c             	sub    $0xc,%esp
  8018f3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018f6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018fe:	eb 02                	jmp    801902 <readn+0x1c>
  801900:	01 c3                	add    %eax,%ebx
  801902:	39 f3                	cmp    %esi,%ebx
  801904:	73 21                	jae    801927 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801906:	83 ec 04             	sub    $0x4,%esp
  801909:	89 f0                	mov    %esi,%eax
  80190b:	29 d8                	sub    %ebx,%eax
  80190d:	50                   	push   %eax
  80190e:	89 d8                	mov    %ebx,%eax
  801910:	03 45 0c             	add    0xc(%ebp),%eax
  801913:	50                   	push   %eax
  801914:	57                   	push   %edi
  801915:	e8 41 ff ff ff       	call   80185b <read>
		if (m < 0)
  80191a:	83 c4 10             	add    $0x10,%esp
  80191d:	85 c0                	test   %eax,%eax
  80191f:	78 04                	js     801925 <readn+0x3f>
			return m;
		if (m == 0)
  801921:	75 dd                	jne    801900 <readn+0x1a>
  801923:	eb 02                	jmp    801927 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801925:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801927:	89 d8                	mov    %ebx,%eax
  801929:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80192c:	5b                   	pop    %ebx
  80192d:	5e                   	pop    %esi
  80192e:	5f                   	pop    %edi
  80192f:	5d                   	pop    %ebp
  801930:	c3                   	ret    

00801931 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801931:	f3 0f 1e fb          	endbr32 
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	53                   	push   %ebx
  801939:	83 ec 1c             	sub    $0x1c,%esp
  80193c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80193f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801942:	50                   	push   %eax
  801943:	53                   	push   %ebx
  801944:	e8 8f fc ff ff       	call   8015d8 <fd_lookup>
  801949:	83 c4 10             	add    $0x10,%esp
  80194c:	85 c0                	test   %eax,%eax
  80194e:	78 3a                	js     80198a <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801950:	83 ec 08             	sub    $0x8,%esp
  801953:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801956:	50                   	push   %eax
  801957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195a:	ff 30                	pushl  (%eax)
  80195c:	e8 cb fc ff ff       	call   80162c <dev_lookup>
  801961:	83 c4 10             	add    $0x10,%esp
  801964:	85 c0                	test   %eax,%eax
  801966:	78 22                	js     80198a <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80196f:	74 1e                	je     80198f <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801971:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801974:	8b 52 0c             	mov    0xc(%edx),%edx
  801977:	85 d2                	test   %edx,%edx
  801979:	74 35                	je     8019b0 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80197b:	83 ec 04             	sub    $0x4,%esp
  80197e:	ff 75 10             	pushl  0x10(%ebp)
  801981:	ff 75 0c             	pushl  0xc(%ebp)
  801984:	50                   	push   %eax
  801985:	ff d2                	call   *%edx
  801987:	83 c4 10             	add    $0x10,%esp
}
  80198a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80198f:	a1 04 50 80 00       	mov    0x805004,%eax
  801994:	8b 40 48             	mov    0x48(%eax),%eax
  801997:	83 ec 04             	sub    $0x4,%esp
  80199a:	53                   	push   %ebx
  80199b:	50                   	push   %eax
  80199c:	68 39 31 80 00       	push   $0x803139
  8019a1:	e8 57 ec ff ff       	call   8005fd <cprintf>
		return -E_INVAL;
  8019a6:	83 c4 10             	add    $0x10,%esp
  8019a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019ae:	eb da                	jmp    80198a <write+0x59>
		return -E_NOT_SUPP;
  8019b0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019b5:	eb d3                	jmp    80198a <write+0x59>

008019b7 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019b7:	f3 0f 1e fb          	endbr32 
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c4:	50                   	push   %eax
  8019c5:	ff 75 08             	pushl  0x8(%ebp)
  8019c8:	e8 0b fc ff ff       	call   8015d8 <fd_lookup>
  8019cd:	83 c4 10             	add    $0x10,%esp
  8019d0:	85 c0                	test   %eax,%eax
  8019d2:	78 0e                	js     8019e2 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8019d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019da:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019e4:	f3 0f 1e fb          	endbr32 
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	53                   	push   %ebx
  8019ec:	83 ec 1c             	sub    $0x1c,%esp
  8019ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019f5:	50                   	push   %eax
  8019f6:	53                   	push   %ebx
  8019f7:	e8 dc fb ff ff       	call   8015d8 <fd_lookup>
  8019fc:	83 c4 10             	add    $0x10,%esp
  8019ff:	85 c0                	test   %eax,%eax
  801a01:	78 37                	js     801a3a <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a03:	83 ec 08             	sub    $0x8,%esp
  801a06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a09:	50                   	push   %eax
  801a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a0d:	ff 30                	pushl  (%eax)
  801a0f:	e8 18 fc ff ff       	call   80162c <dev_lookup>
  801a14:	83 c4 10             	add    $0x10,%esp
  801a17:	85 c0                	test   %eax,%eax
  801a19:	78 1f                	js     801a3a <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a1e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a22:	74 1b                	je     801a3f <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a27:	8b 52 18             	mov    0x18(%edx),%edx
  801a2a:	85 d2                	test   %edx,%edx
  801a2c:	74 32                	je     801a60 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a2e:	83 ec 08             	sub    $0x8,%esp
  801a31:	ff 75 0c             	pushl  0xc(%ebp)
  801a34:	50                   	push   %eax
  801a35:	ff d2                	call   *%edx
  801a37:	83 c4 10             	add    $0x10,%esp
}
  801a3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a3f:	a1 04 50 80 00       	mov    0x805004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a44:	8b 40 48             	mov    0x48(%eax),%eax
  801a47:	83 ec 04             	sub    $0x4,%esp
  801a4a:	53                   	push   %ebx
  801a4b:	50                   	push   %eax
  801a4c:	68 fc 30 80 00       	push   $0x8030fc
  801a51:	e8 a7 eb ff ff       	call   8005fd <cprintf>
		return -E_INVAL;
  801a56:	83 c4 10             	add    $0x10,%esp
  801a59:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a5e:	eb da                	jmp    801a3a <ftruncate+0x56>
		return -E_NOT_SUPP;
  801a60:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a65:	eb d3                	jmp    801a3a <ftruncate+0x56>

00801a67 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a67:	f3 0f 1e fb          	endbr32 
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	53                   	push   %ebx
  801a6f:	83 ec 1c             	sub    $0x1c,%esp
  801a72:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a75:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a78:	50                   	push   %eax
  801a79:	ff 75 08             	pushl  0x8(%ebp)
  801a7c:	e8 57 fb ff ff       	call   8015d8 <fd_lookup>
  801a81:	83 c4 10             	add    $0x10,%esp
  801a84:	85 c0                	test   %eax,%eax
  801a86:	78 4b                	js     801ad3 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a88:	83 ec 08             	sub    $0x8,%esp
  801a8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a8e:	50                   	push   %eax
  801a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a92:	ff 30                	pushl  (%eax)
  801a94:	e8 93 fb ff ff       	call   80162c <dev_lookup>
  801a99:	83 c4 10             	add    $0x10,%esp
  801a9c:	85 c0                	test   %eax,%eax
  801a9e:	78 33                	js     801ad3 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801aa7:	74 2f                	je     801ad8 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801aa9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801aac:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ab3:	00 00 00 
	stat->st_isdir = 0;
  801ab6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801abd:	00 00 00 
	stat->st_dev = dev;
  801ac0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ac6:	83 ec 08             	sub    $0x8,%esp
  801ac9:	53                   	push   %ebx
  801aca:	ff 75 f0             	pushl  -0x10(%ebp)
  801acd:	ff 50 14             	call   *0x14(%eax)
  801ad0:	83 c4 10             	add    $0x10,%esp
}
  801ad3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    
		return -E_NOT_SUPP;
  801ad8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801add:	eb f4                	jmp    801ad3 <fstat+0x6c>

00801adf <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801adf:	f3 0f 1e fb          	endbr32 
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	56                   	push   %esi
  801ae7:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ae8:	83 ec 08             	sub    $0x8,%esp
  801aeb:	6a 00                	push   $0x0
  801aed:	ff 75 08             	pushl  0x8(%ebp)
  801af0:	e8 fb 01 00 00       	call   801cf0 <open>
  801af5:	89 c3                	mov    %eax,%ebx
  801af7:	83 c4 10             	add    $0x10,%esp
  801afa:	85 c0                	test   %eax,%eax
  801afc:	78 1b                	js     801b19 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801afe:	83 ec 08             	sub    $0x8,%esp
  801b01:	ff 75 0c             	pushl  0xc(%ebp)
  801b04:	50                   	push   %eax
  801b05:	e8 5d ff ff ff       	call   801a67 <fstat>
  801b0a:	89 c6                	mov    %eax,%esi
	close(fd);
  801b0c:	89 1c 24             	mov    %ebx,(%esp)
  801b0f:	e8 fd fb ff ff       	call   801711 <close>
	return r;
  801b14:	83 c4 10             	add    $0x10,%esp
  801b17:	89 f3                	mov    %esi,%ebx
}
  801b19:	89 d8                	mov    %ebx,%eax
  801b1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b1e:	5b                   	pop    %ebx
  801b1f:	5e                   	pop    %esi
  801b20:	5d                   	pop    %ebp
  801b21:	c3                   	ret    

00801b22 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
  801b25:	56                   	push   %esi
  801b26:	53                   	push   %ebx
  801b27:	89 c6                	mov    %eax,%esi
  801b29:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b2b:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b32:	74 27                	je     801b5b <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b34:	6a 07                	push   $0x7
  801b36:	68 00 60 80 00       	push   $0x806000
  801b3b:	56                   	push   %esi
  801b3c:	ff 35 00 50 80 00    	pushl  0x805000
  801b42:	e8 3b 0d 00 00       	call   802882 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b47:	83 c4 0c             	add    $0xc,%esp
  801b4a:	6a 00                	push   $0x0
  801b4c:	53                   	push   %ebx
  801b4d:	6a 00                	push   $0x0
  801b4f:	e8 a9 0c 00 00       	call   8027fd <ipc_recv>
}
  801b54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b57:	5b                   	pop    %ebx
  801b58:	5e                   	pop    %esi
  801b59:	5d                   	pop    %ebp
  801b5a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b5b:	83 ec 0c             	sub    $0xc,%esp
  801b5e:	6a 01                	push   $0x1
  801b60:	e8 75 0d 00 00       	call   8028da <ipc_find_env>
  801b65:	a3 00 50 80 00       	mov    %eax,0x805000
  801b6a:	83 c4 10             	add    $0x10,%esp
  801b6d:	eb c5                	jmp    801b34 <fsipc+0x12>

00801b6f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b6f:	f3 0f 1e fb          	endbr32 
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
  801b76:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b7f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b87:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b91:	b8 02 00 00 00       	mov    $0x2,%eax
  801b96:	e8 87 ff ff ff       	call   801b22 <fsipc>
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <devfile_flush>:
{
  801b9d:	f3 0f 1e fb          	endbr32 
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	8b 40 0c             	mov    0xc(%eax),%eax
  801bad:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801bb2:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb7:	b8 06 00 00 00       	mov    $0x6,%eax
  801bbc:	e8 61 ff ff ff       	call   801b22 <fsipc>
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <devfile_stat>:
{
  801bc3:	f3 0f 1e fb          	endbr32 
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	53                   	push   %ebx
  801bcb:	83 ec 04             	sub    $0x4,%esp
  801bce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	8b 40 0c             	mov    0xc(%eax),%eax
  801bd7:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bdc:	ba 00 00 00 00       	mov    $0x0,%edx
  801be1:	b8 05 00 00 00       	mov    $0x5,%eax
  801be6:	e8 37 ff ff ff       	call   801b22 <fsipc>
  801beb:	85 c0                	test   %eax,%eax
  801bed:	78 2c                	js     801c1b <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bef:	83 ec 08             	sub    $0x8,%esp
  801bf2:	68 00 60 80 00       	push   $0x806000
  801bf7:	53                   	push   %ebx
  801bf8:	e8 0a f0 ff ff       	call   800c07 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bfd:	a1 80 60 80 00       	mov    0x806080,%eax
  801c02:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c08:	a1 84 60 80 00       	mov    0x806084,%eax
  801c0d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c13:	83 c4 10             	add    $0x10,%esp
  801c16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <devfile_write>:
{
  801c20:	f3 0f 1e fb          	endbr32 
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
  801c27:	83 ec 0c             	sub    $0xc,%esp
  801c2a:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c2d:	8b 55 08             	mov    0x8(%ebp),%edx
  801c30:	8b 52 0c             	mov    0xc(%edx),%edx
  801c33:	89 15 00 60 80 00    	mov    %edx,0x806000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801c39:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801c3e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801c43:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801c46:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801c4b:	50                   	push   %eax
  801c4c:	ff 75 0c             	pushl  0xc(%ebp)
  801c4f:	68 08 60 80 00       	push   $0x806008
  801c54:	e8 64 f1 ff ff       	call   800dbd <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801c59:	ba 00 00 00 00       	mov    $0x0,%edx
  801c5e:	b8 04 00 00 00       	mov    $0x4,%eax
  801c63:	e8 ba fe ff ff       	call   801b22 <fsipc>
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <devfile_read>:
{
  801c6a:	f3 0f 1e fb          	endbr32 
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	56                   	push   %esi
  801c72:	53                   	push   %ebx
  801c73:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	8b 40 0c             	mov    0xc(%eax),%eax
  801c7c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c81:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c87:	ba 00 00 00 00       	mov    $0x0,%edx
  801c8c:	b8 03 00 00 00       	mov    $0x3,%eax
  801c91:	e8 8c fe ff ff       	call   801b22 <fsipc>
  801c96:	89 c3                	mov    %eax,%ebx
  801c98:	85 c0                	test   %eax,%eax
  801c9a:	78 1f                	js     801cbb <devfile_read+0x51>
	assert(r <= n);
  801c9c:	39 f0                	cmp    %esi,%eax
  801c9e:	77 24                	ja     801cc4 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801ca0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ca5:	7f 33                	jg     801cda <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ca7:	83 ec 04             	sub    $0x4,%esp
  801caa:	50                   	push   %eax
  801cab:	68 00 60 80 00       	push   $0x806000
  801cb0:	ff 75 0c             	pushl  0xc(%ebp)
  801cb3:	e8 05 f1 ff ff       	call   800dbd <memmove>
	return r;
  801cb8:	83 c4 10             	add    $0x10,%esp
}
  801cbb:	89 d8                	mov    %ebx,%eax
  801cbd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cc0:	5b                   	pop    %ebx
  801cc1:	5e                   	pop    %esi
  801cc2:	5d                   	pop    %ebp
  801cc3:	c3                   	ret    
	assert(r <= n);
  801cc4:	68 68 31 80 00       	push   $0x803168
  801cc9:	68 6f 31 80 00       	push   $0x80316f
  801cce:	6a 7c                	push   $0x7c
  801cd0:	68 84 31 80 00       	push   $0x803184
  801cd5:	e8 3c e8 ff ff       	call   800516 <_panic>
	assert(r <= PGSIZE);
  801cda:	68 8f 31 80 00       	push   $0x80318f
  801cdf:	68 6f 31 80 00       	push   $0x80316f
  801ce4:	6a 7d                	push   $0x7d
  801ce6:	68 84 31 80 00       	push   $0x803184
  801ceb:	e8 26 e8 ff ff       	call   800516 <_panic>

00801cf0 <open>:
{
  801cf0:	f3 0f 1e fb          	endbr32 
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
  801cf7:	56                   	push   %esi
  801cf8:	53                   	push   %ebx
  801cf9:	83 ec 1c             	sub    $0x1c,%esp
  801cfc:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801cff:	56                   	push   %esi
  801d00:	e8 bf ee ff ff       	call   800bc4 <strlen>
  801d05:	83 c4 10             	add    $0x10,%esp
  801d08:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d0d:	7f 6c                	jg     801d7b <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801d0f:	83 ec 0c             	sub    $0xc,%esp
  801d12:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d15:	50                   	push   %eax
  801d16:	e8 67 f8 ff ff       	call   801582 <fd_alloc>
  801d1b:	89 c3                	mov    %eax,%ebx
  801d1d:	83 c4 10             	add    $0x10,%esp
  801d20:	85 c0                	test   %eax,%eax
  801d22:	78 3c                	js     801d60 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801d24:	83 ec 08             	sub    $0x8,%esp
  801d27:	56                   	push   %esi
  801d28:	68 00 60 80 00       	push   $0x806000
  801d2d:	e8 d5 ee ff ff       	call   800c07 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d35:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d42:	e8 db fd ff ff       	call   801b22 <fsipc>
  801d47:	89 c3                	mov    %eax,%ebx
  801d49:	83 c4 10             	add    $0x10,%esp
  801d4c:	85 c0                	test   %eax,%eax
  801d4e:	78 19                	js     801d69 <open+0x79>
	return fd2num(fd);
  801d50:	83 ec 0c             	sub    $0xc,%esp
  801d53:	ff 75 f4             	pushl  -0xc(%ebp)
  801d56:	e8 f8 f7 ff ff       	call   801553 <fd2num>
  801d5b:	89 c3                	mov    %eax,%ebx
  801d5d:	83 c4 10             	add    $0x10,%esp
}
  801d60:	89 d8                	mov    %ebx,%eax
  801d62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d65:	5b                   	pop    %ebx
  801d66:	5e                   	pop    %esi
  801d67:	5d                   	pop    %ebp
  801d68:	c3                   	ret    
		fd_close(fd, 0);
  801d69:	83 ec 08             	sub    $0x8,%esp
  801d6c:	6a 00                	push   $0x0
  801d6e:	ff 75 f4             	pushl  -0xc(%ebp)
  801d71:	e8 10 f9 ff ff       	call   801686 <fd_close>
		return r;
  801d76:	83 c4 10             	add    $0x10,%esp
  801d79:	eb e5                	jmp    801d60 <open+0x70>
		return -E_BAD_PATH;
  801d7b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d80:	eb de                	jmp    801d60 <open+0x70>

00801d82 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d82:	f3 0f 1e fb          	endbr32 
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d91:	b8 08 00 00 00       	mov    $0x8,%eax
  801d96:	e8 87 fd ff ff       	call   801b22 <fsipc>
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801d9d:	f3 0f 1e fb          	endbr32 
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	57                   	push   %edi
  801da5:	56                   	push   %esi
  801da6:	53                   	push   %ebx
  801da7:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801dad:	6a 00                	push   $0x0
  801daf:	ff 75 08             	pushl  0x8(%ebp)
  801db2:	e8 39 ff ff ff       	call   801cf0 <open>
  801db7:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801dbd:	83 c4 10             	add    $0x10,%esp
  801dc0:	85 c0                	test   %eax,%eax
  801dc2:	0f 88 e7 04 00 00    	js     8022af <spawn+0x512>
  801dc8:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801dca:	83 ec 04             	sub    $0x4,%esp
  801dcd:	68 00 02 00 00       	push   $0x200
  801dd2:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801dd8:	50                   	push   %eax
  801dd9:	52                   	push   %edx
  801dda:	e8 07 fb ff ff       	call   8018e6 <readn>
  801ddf:	83 c4 10             	add    $0x10,%esp
  801de2:	3d 00 02 00 00       	cmp    $0x200,%eax
  801de7:	75 7e                	jne    801e67 <spawn+0xca>
	    || elf->e_magic != ELF_MAGIC) {
  801de9:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801df0:	45 4c 46 
  801df3:	75 72                	jne    801e67 <spawn+0xca>
  801df5:	b8 07 00 00 00       	mov    $0x7,%eax
  801dfa:	cd 30                	int    $0x30
  801dfc:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801e02:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801e08:	85 c0                	test   %eax,%eax
  801e0a:	0f 88 93 04 00 00    	js     8022a3 <spawn+0x506>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801e10:	25 ff 03 00 00       	and    $0x3ff,%eax
  801e15:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801e18:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801e1e:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801e24:	b9 11 00 00 00       	mov    $0x11,%ecx
  801e29:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801e2b:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801e31:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801e37:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801e3c:	be 00 00 00 00       	mov    $0x0,%esi
  801e41:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801e44:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  801e4b:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801e4e:	85 c0                	test   %eax,%eax
  801e50:	74 4d                	je     801e9f <spawn+0x102>
		string_size += strlen(argv[argc]) + 1;
  801e52:	83 ec 0c             	sub    $0xc,%esp
  801e55:	50                   	push   %eax
  801e56:	e8 69 ed ff ff       	call   800bc4 <strlen>
  801e5b:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801e5f:	83 c3 01             	add    $0x1,%ebx
  801e62:	83 c4 10             	add    $0x10,%esp
  801e65:	eb dd                	jmp    801e44 <spawn+0xa7>
		close(fd);
  801e67:	83 ec 0c             	sub    $0xc,%esp
  801e6a:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801e70:	e8 9c f8 ff ff       	call   801711 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801e75:	83 c4 0c             	add    $0xc,%esp
  801e78:	68 7f 45 4c 46       	push   $0x464c457f
  801e7d:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801e83:	68 9b 31 80 00       	push   $0x80319b
  801e88:	e8 70 e7 ff ff       	call   8005fd <cprintf>
		return -E_NOT_EXEC;
  801e8d:	83 c4 10             	add    $0x10,%esp
  801e90:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801e97:	ff ff ff 
  801e9a:	e9 10 04 00 00       	jmp    8022af <spawn+0x512>
  801e9f:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801ea5:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801eab:	bf 00 10 40 00       	mov    $0x401000,%edi
  801eb0:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801eb2:	89 fa                	mov    %edi,%edx
  801eb4:	83 e2 fc             	and    $0xfffffffc,%edx
  801eb7:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801ebe:	29 c2                	sub    %eax,%edx
  801ec0:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801ec6:	8d 42 f8             	lea    -0x8(%edx),%eax
  801ec9:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801ece:	0f 86 fe 03 00 00    	jbe    8022d2 <spawn+0x535>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801ed4:	83 ec 04             	sub    $0x4,%esp
  801ed7:	6a 07                	push   $0x7
  801ed9:	68 00 00 40 00       	push   $0x400000
  801ede:	6a 00                	push   $0x0
  801ee0:	e8 64 f1 ff ff       	call   801049 <sys_page_alloc>
  801ee5:	83 c4 10             	add    $0x10,%esp
  801ee8:	85 c0                	test   %eax,%eax
  801eea:	0f 88 e7 03 00 00    	js     8022d7 <spawn+0x53a>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801ef0:	be 00 00 00 00       	mov    $0x0,%esi
  801ef5:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801efb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801efe:	eb 30                	jmp    801f30 <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  801f00:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801f06:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801f0c:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801f0f:	83 ec 08             	sub    $0x8,%esp
  801f12:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801f15:	57                   	push   %edi
  801f16:	e8 ec ec ff ff       	call   800c07 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801f1b:	83 c4 04             	add    $0x4,%esp
  801f1e:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801f21:	e8 9e ec ff ff       	call   800bc4 <strlen>
  801f26:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801f2a:	83 c6 01             	add    $0x1,%esi
  801f2d:	83 c4 10             	add    $0x10,%esp
  801f30:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801f36:	7f c8                	jg     801f00 <spawn+0x163>
	}
	argv_store[argc] = 0;
  801f38:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801f3e:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801f44:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801f4b:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801f51:	0f 85 86 00 00 00    	jne    801fdd <spawn+0x240>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801f57:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801f5d:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  801f63:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801f66:	89 c8                	mov    %ecx,%eax
  801f68:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801f6e:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801f71:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801f76:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801f7c:	83 ec 0c             	sub    $0xc,%esp
  801f7f:	6a 07                	push   $0x7
  801f81:	68 00 d0 bf ee       	push   $0xeebfd000
  801f86:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801f8c:	68 00 00 40 00       	push   $0x400000
  801f91:	6a 00                	push   $0x0
  801f93:	e8 f8 f0 ff ff       	call   801090 <sys_page_map>
  801f98:	89 c3                	mov    %eax,%ebx
  801f9a:	83 c4 20             	add    $0x20,%esp
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	0f 88 3a 03 00 00    	js     8022df <spawn+0x542>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801fa5:	83 ec 08             	sub    $0x8,%esp
  801fa8:	68 00 00 40 00       	push   $0x400000
  801fad:	6a 00                	push   $0x0
  801faf:	e8 22 f1 ff ff       	call   8010d6 <sys_page_unmap>
  801fb4:	89 c3                	mov    %eax,%ebx
  801fb6:	83 c4 10             	add    $0x10,%esp
  801fb9:	85 c0                	test   %eax,%eax
  801fbb:	0f 88 1e 03 00 00    	js     8022df <spawn+0x542>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801fc1:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801fc7:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801fce:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801fd5:	00 00 00 
  801fd8:	e9 4f 01 00 00       	jmp    80212c <spawn+0x38f>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801fdd:	68 f8 31 80 00       	push   $0x8031f8
  801fe2:	68 6f 31 80 00       	push   $0x80316f
  801fe7:	68 f2 00 00 00       	push   $0xf2
  801fec:	68 b5 31 80 00       	push   $0x8031b5
  801ff1:	e8 20 e5 ff ff       	call   800516 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801ff6:	83 ec 04             	sub    $0x4,%esp
  801ff9:	6a 07                	push   $0x7
  801ffb:	68 00 00 40 00       	push   $0x400000
  802000:	6a 00                	push   $0x0
  802002:	e8 42 f0 ff ff       	call   801049 <sys_page_alloc>
  802007:	83 c4 10             	add    $0x10,%esp
  80200a:	85 c0                	test   %eax,%eax
  80200c:	0f 88 ab 02 00 00    	js     8022bd <spawn+0x520>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802012:	83 ec 08             	sub    $0x8,%esp
  802015:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80201b:	01 f0                	add    %esi,%eax
  80201d:	50                   	push   %eax
  80201e:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802024:	e8 8e f9 ff ff       	call   8019b7 <seek>
  802029:	83 c4 10             	add    $0x10,%esp
  80202c:	85 c0                	test   %eax,%eax
  80202e:	0f 88 90 02 00 00    	js     8022c4 <spawn+0x527>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802034:	83 ec 04             	sub    $0x4,%esp
  802037:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80203d:	29 f0                	sub    %esi,%eax
  80203f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802044:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802049:	0f 47 c1             	cmova  %ecx,%eax
  80204c:	50                   	push   %eax
  80204d:	68 00 00 40 00       	push   $0x400000
  802052:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802058:	e8 89 f8 ff ff       	call   8018e6 <readn>
  80205d:	83 c4 10             	add    $0x10,%esp
  802060:	85 c0                	test   %eax,%eax
  802062:	0f 88 63 02 00 00    	js     8022cb <spawn+0x52e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802068:	83 ec 0c             	sub    $0xc,%esp
  80206b:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802071:	53                   	push   %ebx
  802072:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802078:	68 00 00 40 00       	push   $0x400000
  80207d:	6a 00                	push   $0x0
  80207f:	e8 0c f0 ff ff       	call   801090 <sys_page_map>
  802084:	83 c4 20             	add    $0x20,%esp
  802087:	85 c0                	test   %eax,%eax
  802089:	78 7c                	js     802107 <spawn+0x36a>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  80208b:	83 ec 08             	sub    $0x8,%esp
  80208e:	68 00 00 40 00       	push   $0x400000
  802093:	6a 00                	push   $0x0
  802095:	e8 3c f0 ff ff       	call   8010d6 <sys_page_unmap>
  80209a:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  80209d:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8020a3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8020a9:	89 fe                	mov    %edi,%esi
  8020ab:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  8020b1:	76 69                	jbe    80211c <spawn+0x37f>
		if (i >= filesz) {
  8020b3:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  8020b9:	0f 87 37 ff ff ff    	ja     801ff6 <spawn+0x259>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8020bf:	83 ec 04             	sub    $0x4,%esp
  8020c2:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8020c8:	53                   	push   %ebx
  8020c9:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8020cf:	e8 75 ef ff ff       	call   801049 <sys_page_alloc>
  8020d4:	83 c4 10             	add    $0x10,%esp
  8020d7:	85 c0                	test   %eax,%eax
  8020d9:	79 c2                	jns    80209d <spawn+0x300>
  8020db:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8020dd:	83 ec 0c             	sub    $0xc,%esp
  8020e0:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8020e6:	e8 d3 ee ff ff       	call   800fbe <sys_env_destroy>
	close(fd);
  8020eb:	83 c4 04             	add    $0x4,%esp
  8020ee:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8020f4:	e8 18 f6 ff ff       	call   801711 <close>
	return r;
  8020f9:	83 c4 10             	add    $0x10,%esp
  8020fc:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  802102:	e9 a8 01 00 00       	jmp    8022af <spawn+0x512>
				panic("spawn: sys_page_map data: %e", r);
  802107:	50                   	push   %eax
  802108:	68 c1 31 80 00       	push   $0x8031c1
  80210d:	68 25 01 00 00       	push   $0x125
  802112:	68 b5 31 80 00       	push   $0x8031b5
  802117:	e8 fa e3 ff ff       	call   800516 <_panic>
  80211c:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802122:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802129:	83 c6 20             	add    $0x20,%esi
  80212c:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802133:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  802139:	7e 6d                	jle    8021a8 <spawn+0x40b>
		if (ph->p_type != ELF_PROG_LOAD)
  80213b:	83 3e 01             	cmpl   $0x1,(%esi)
  80213e:	75 e2                	jne    802122 <spawn+0x385>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802140:	8b 46 18             	mov    0x18(%esi),%eax
  802143:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802146:	83 f8 01             	cmp    $0x1,%eax
  802149:	19 c0                	sbb    %eax,%eax
  80214b:	83 e0 fe             	and    $0xfffffffe,%eax
  80214e:	83 c0 07             	add    $0x7,%eax
  802151:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802157:	8b 4e 04             	mov    0x4(%esi),%ecx
  80215a:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802160:	8b 56 10             	mov    0x10(%esi),%edx
  802163:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  802169:	8b 7e 14             	mov    0x14(%esi),%edi
  80216c:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802172:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802175:	89 d8                	mov    %ebx,%eax
  802177:	25 ff 0f 00 00       	and    $0xfff,%eax
  80217c:	74 1a                	je     802198 <spawn+0x3fb>
		va -= i;
  80217e:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802180:	01 c7                	add    %eax,%edi
  802182:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802188:	01 c2                	add    %eax,%edx
  80218a:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802190:	29 c1                	sub    %eax,%ecx
  802192:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802198:	bf 00 00 00 00       	mov    $0x0,%edi
  80219d:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  8021a3:	e9 01 ff ff ff       	jmp    8020a9 <spawn+0x30c>
	close(fd);
  8021a8:	83 ec 0c             	sub    $0xc,%esp
  8021ab:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8021b1:	e8 5b f5 ff ff       	call   801711 <close>
  8021b6:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  8021b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021be:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  8021c4:	eb 0e                	jmp    8021d4 <spawn+0x437>
  8021c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8021cc:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8021d2:	74 5a                	je     80222e <spawn+0x491>
		if((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)){
  8021d4:	89 d8                	mov    %ebx,%eax
  8021d6:	c1 e8 16             	shr    $0x16,%eax
  8021d9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8021e0:	a8 01                	test   $0x1,%al
  8021e2:	74 e2                	je     8021c6 <spawn+0x429>
  8021e4:	89 d8                	mov    %ebx,%eax
  8021e6:	c1 e8 0c             	shr    $0xc,%eax
  8021e9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8021f0:	f6 c2 01             	test   $0x1,%dl
  8021f3:	74 d1                	je     8021c6 <spawn+0x429>
  8021f5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8021fc:	f6 c2 04             	test   $0x4,%dl
  8021ff:	74 c5                	je     8021c6 <spawn+0x429>
  802201:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802208:	f6 c6 04             	test   $0x4,%dh
  80220b:	74 b9                	je     8021c6 <spawn+0x429>
			if(r = sys_page_map(0, (void*)addr, child, (void*)addr, (uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  80220d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802214:	83 ec 0c             	sub    $0xc,%esp
  802217:	25 07 0e 00 00       	and    $0xe07,%eax
  80221c:	50                   	push   %eax
  80221d:	53                   	push   %ebx
  80221e:	56                   	push   %esi
  80221f:	53                   	push   %ebx
  802220:	6a 00                	push   $0x0
  802222:	e8 69 ee ff ff       	call   801090 <sys_page_map>
  802227:	83 c4 20             	add    $0x20,%esp
  80222a:	85 c0                	test   %eax,%eax
  80222c:	79 98                	jns    8021c6 <spawn+0x429>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  80222e:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  802235:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802238:	83 ec 08             	sub    $0x8,%esp
  80223b:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802241:	50                   	push   %eax
  802242:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802248:	e8 15 ef ff ff       	call   801162 <sys_env_set_trapframe>
  80224d:	83 c4 10             	add    $0x10,%esp
  802250:	85 c0                	test   %eax,%eax
  802252:	78 25                	js     802279 <spawn+0x4dc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802254:	83 ec 08             	sub    $0x8,%esp
  802257:	6a 02                	push   $0x2
  802259:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80225f:	e8 b8 ee ff ff       	call   80111c <sys_env_set_status>
  802264:	83 c4 10             	add    $0x10,%esp
  802267:	85 c0                	test   %eax,%eax
  802269:	78 23                	js     80228e <spawn+0x4f1>
	return child;
  80226b:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802271:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802277:	eb 36                	jmp    8022af <spawn+0x512>
		panic("sys_env_set_trapframe: %e", r);
  802279:	50                   	push   %eax
  80227a:	68 de 31 80 00       	push   $0x8031de
  80227f:	68 86 00 00 00       	push   $0x86
  802284:	68 b5 31 80 00       	push   $0x8031b5
  802289:	e8 88 e2 ff ff       	call   800516 <_panic>
		panic("sys_env_set_status: %e", r);
  80228e:	50                   	push   %eax
  80228f:	68 ae 30 80 00       	push   $0x8030ae
  802294:	68 89 00 00 00       	push   $0x89
  802299:	68 b5 31 80 00       	push   $0x8031b5
  80229e:	e8 73 e2 ff ff       	call   800516 <_panic>
		return r;
  8022a3:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8022a9:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  8022af:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8022b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022b8:	5b                   	pop    %ebx
  8022b9:	5e                   	pop    %esi
  8022ba:	5f                   	pop    %edi
  8022bb:	5d                   	pop    %ebp
  8022bc:	c3                   	ret    
  8022bd:	89 c7                	mov    %eax,%edi
  8022bf:	e9 19 fe ff ff       	jmp    8020dd <spawn+0x340>
  8022c4:	89 c7                	mov    %eax,%edi
  8022c6:	e9 12 fe ff ff       	jmp    8020dd <spawn+0x340>
  8022cb:	89 c7                	mov    %eax,%edi
  8022cd:	e9 0b fe ff ff       	jmp    8020dd <spawn+0x340>
		return -E_NO_MEM;
  8022d2:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  8022d7:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8022dd:	eb d0                	jmp    8022af <spawn+0x512>
	sys_page_unmap(0, UTEMP);
  8022df:	83 ec 08             	sub    $0x8,%esp
  8022e2:	68 00 00 40 00       	push   $0x400000
  8022e7:	6a 00                	push   $0x0
  8022e9:	e8 e8 ed ff ff       	call   8010d6 <sys_page_unmap>
  8022ee:	83 c4 10             	add    $0x10,%esp
  8022f1:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  8022f7:	eb b6                	jmp    8022af <spawn+0x512>

008022f9 <spawnl>:
{
  8022f9:	f3 0f 1e fb          	endbr32 
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	57                   	push   %edi
  802301:	56                   	push   %esi
  802302:	53                   	push   %ebx
  802303:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802306:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802309:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  80230e:	8d 4a 04             	lea    0x4(%edx),%ecx
  802311:	83 3a 00             	cmpl   $0x0,(%edx)
  802314:	74 07                	je     80231d <spawnl+0x24>
		argc++;
  802316:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802319:	89 ca                	mov    %ecx,%edx
  80231b:	eb f1                	jmp    80230e <spawnl+0x15>
	const char *argv[argc+2];
  80231d:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802324:	89 d1                	mov    %edx,%ecx
  802326:	83 e1 f0             	and    $0xfffffff0,%ecx
  802329:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80232f:	89 e6                	mov    %esp,%esi
  802331:	29 d6                	sub    %edx,%esi
  802333:	89 f2                	mov    %esi,%edx
  802335:	39 d4                	cmp    %edx,%esp
  802337:	74 10                	je     802349 <spawnl+0x50>
  802339:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  80233f:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  802346:	00 
  802347:	eb ec                	jmp    802335 <spawnl+0x3c>
  802349:	89 ca                	mov    %ecx,%edx
  80234b:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802351:	29 d4                	sub    %edx,%esp
  802353:	85 d2                	test   %edx,%edx
  802355:	74 05                	je     80235c <spawnl+0x63>
  802357:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  80235c:	8d 74 24 03          	lea    0x3(%esp),%esi
  802360:	89 f2                	mov    %esi,%edx
  802362:	c1 ea 02             	shr    $0x2,%edx
  802365:	83 e6 fc             	and    $0xfffffffc,%esi
  802368:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80236a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80236d:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802374:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  80237b:	00 
	va_start(vl, arg0);
  80237c:	8d 4d 10             	lea    0x10(%ebp),%ecx
  80237f:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802381:	b8 00 00 00 00       	mov    $0x0,%eax
  802386:	eb 0b                	jmp    802393 <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  802388:	83 c0 01             	add    $0x1,%eax
  80238b:	8b 39                	mov    (%ecx),%edi
  80238d:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802390:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802393:	39 d0                	cmp    %edx,%eax
  802395:	75 f1                	jne    802388 <spawnl+0x8f>
	return spawn(prog, argv);
  802397:	83 ec 08             	sub    $0x8,%esp
  80239a:	56                   	push   %esi
  80239b:	ff 75 08             	pushl  0x8(%ebp)
  80239e:	e8 fa f9 ff ff       	call   801d9d <spawn>
}
  8023a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023a6:	5b                   	pop    %ebx
  8023a7:	5e                   	pop    %esi
  8023a8:	5f                   	pop    %edi
  8023a9:	5d                   	pop    %ebp
  8023aa:	c3                   	ret    

008023ab <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023ab:	f3 0f 1e fb          	endbr32 
  8023af:	55                   	push   %ebp
  8023b0:	89 e5                	mov    %esp,%ebp
  8023b2:	56                   	push   %esi
  8023b3:	53                   	push   %ebx
  8023b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023b7:	83 ec 0c             	sub    $0xc,%esp
  8023ba:	ff 75 08             	pushl  0x8(%ebp)
  8023bd:	e8 a5 f1 ff ff       	call   801567 <fd2data>
  8023c2:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023c4:	83 c4 08             	add    $0x8,%esp
  8023c7:	68 1e 32 80 00       	push   $0x80321e
  8023cc:	53                   	push   %ebx
  8023cd:	e8 35 e8 ff ff       	call   800c07 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023d2:	8b 46 04             	mov    0x4(%esi),%eax
  8023d5:	2b 06                	sub    (%esi),%eax
  8023d7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023dd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023e4:	00 00 00 
	stat->st_dev = &devpipe;
  8023e7:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8023ee:	40 80 00 
	return 0;
}
  8023f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023f9:	5b                   	pop    %ebx
  8023fa:	5e                   	pop    %esi
  8023fb:	5d                   	pop    %ebp
  8023fc:	c3                   	ret    

008023fd <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023fd:	f3 0f 1e fb          	endbr32 
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
  802404:	53                   	push   %ebx
  802405:	83 ec 0c             	sub    $0xc,%esp
  802408:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80240b:	53                   	push   %ebx
  80240c:	6a 00                	push   $0x0
  80240e:	e8 c3 ec ff ff       	call   8010d6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802413:	89 1c 24             	mov    %ebx,(%esp)
  802416:	e8 4c f1 ff ff       	call   801567 <fd2data>
  80241b:	83 c4 08             	add    $0x8,%esp
  80241e:	50                   	push   %eax
  80241f:	6a 00                	push   $0x0
  802421:	e8 b0 ec ff ff       	call   8010d6 <sys_page_unmap>
}
  802426:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802429:	c9                   	leave  
  80242a:	c3                   	ret    

0080242b <_pipeisclosed>:
{
  80242b:	55                   	push   %ebp
  80242c:	89 e5                	mov    %esp,%ebp
  80242e:	57                   	push   %edi
  80242f:	56                   	push   %esi
  802430:	53                   	push   %ebx
  802431:	83 ec 1c             	sub    $0x1c,%esp
  802434:	89 c7                	mov    %eax,%edi
  802436:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802438:	a1 04 50 80 00       	mov    0x805004,%eax
  80243d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802440:	83 ec 0c             	sub    $0xc,%esp
  802443:	57                   	push   %edi
  802444:	e8 ce 04 00 00       	call   802917 <pageref>
  802449:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80244c:	89 34 24             	mov    %esi,(%esp)
  80244f:	e8 c3 04 00 00       	call   802917 <pageref>
		nn = thisenv->env_runs;
  802454:	8b 15 04 50 80 00    	mov    0x805004,%edx
  80245a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80245d:	83 c4 10             	add    $0x10,%esp
  802460:	39 cb                	cmp    %ecx,%ebx
  802462:	74 1b                	je     80247f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802464:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802467:	75 cf                	jne    802438 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802469:	8b 42 58             	mov    0x58(%edx),%eax
  80246c:	6a 01                	push   $0x1
  80246e:	50                   	push   %eax
  80246f:	53                   	push   %ebx
  802470:	68 25 32 80 00       	push   $0x803225
  802475:	e8 83 e1 ff ff       	call   8005fd <cprintf>
  80247a:	83 c4 10             	add    $0x10,%esp
  80247d:	eb b9                	jmp    802438 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80247f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802482:	0f 94 c0             	sete   %al
  802485:	0f b6 c0             	movzbl %al,%eax
}
  802488:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80248b:	5b                   	pop    %ebx
  80248c:	5e                   	pop    %esi
  80248d:	5f                   	pop    %edi
  80248e:	5d                   	pop    %ebp
  80248f:	c3                   	ret    

00802490 <devpipe_write>:
{
  802490:	f3 0f 1e fb          	endbr32 
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
  802497:	57                   	push   %edi
  802498:	56                   	push   %esi
  802499:	53                   	push   %ebx
  80249a:	83 ec 28             	sub    $0x28,%esp
  80249d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8024a0:	56                   	push   %esi
  8024a1:	e8 c1 f0 ff ff       	call   801567 <fd2data>
  8024a6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024a8:	83 c4 10             	add    $0x10,%esp
  8024ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8024b0:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024b3:	74 4f                	je     802504 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024b5:	8b 43 04             	mov    0x4(%ebx),%eax
  8024b8:	8b 0b                	mov    (%ebx),%ecx
  8024ba:	8d 51 20             	lea    0x20(%ecx),%edx
  8024bd:	39 d0                	cmp    %edx,%eax
  8024bf:	72 14                	jb     8024d5 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8024c1:	89 da                	mov    %ebx,%edx
  8024c3:	89 f0                	mov    %esi,%eax
  8024c5:	e8 61 ff ff ff       	call   80242b <_pipeisclosed>
  8024ca:	85 c0                	test   %eax,%eax
  8024cc:	75 3b                	jne    802509 <devpipe_write+0x79>
			sys_yield();
  8024ce:	e8 53 eb ff ff       	call   801026 <sys_yield>
  8024d3:	eb e0                	jmp    8024b5 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024d8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024dc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024df:	89 c2                	mov    %eax,%edx
  8024e1:	c1 fa 1f             	sar    $0x1f,%edx
  8024e4:	89 d1                	mov    %edx,%ecx
  8024e6:	c1 e9 1b             	shr    $0x1b,%ecx
  8024e9:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8024ec:	83 e2 1f             	and    $0x1f,%edx
  8024ef:	29 ca                	sub    %ecx,%edx
  8024f1:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8024f5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024f9:	83 c0 01             	add    $0x1,%eax
  8024fc:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8024ff:	83 c7 01             	add    $0x1,%edi
  802502:	eb ac                	jmp    8024b0 <devpipe_write+0x20>
	return i;
  802504:	8b 45 10             	mov    0x10(%ebp),%eax
  802507:	eb 05                	jmp    80250e <devpipe_write+0x7e>
				return 0;
  802509:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80250e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802511:	5b                   	pop    %ebx
  802512:	5e                   	pop    %esi
  802513:	5f                   	pop    %edi
  802514:	5d                   	pop    %ebp
  802515:	c3                   	ret    

00802516 <devpipe_read>:
{
  802516:	f3 0f 1e fb          	endbr32 
  80251a:	55                   	push   %ebp
  80251b:	89 e5                	mov    %esp,%ebp
  80251d:	57                   	push   %edi
  80251e:	56                   	push   %esi
  80251f:	53                   	push   %ebx
  802520:	83 ec 18             	sub    $0x18,%esp
  802523:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802526:	57                   	push   %edi
  802527:	e8 3b f0 ff ff       	call   801567 <fd2data>
  80252c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80252e:	83 c4 10             	add    $0x10,%esp
  802531:	be 00 00 00 00       	mov    $0x0,%esi
  802536:	3b 75 10             	cmp    0x10(%ebp),%esi
  802539:	75 14                	jne    80254f <devpipe_read+0x39>
	return i;
  80253b:	8b 45 10             	mov    0x10(%ebp),%eax
  80253e:	eb 02                	jmp    802542 <devpipe_read+0x2c>
				return i;
  802540:	89 f0                	mov    %esi,%eax
}
  802542:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802545:	5b                   	pop    %ebx
  802546:	5e                   	pop    %esi
  802547:	5f                   	pop    %edi
  802548:	5d                   	pop    %ebp
  802549:	c3                   	ret    
			sys_yield();
  80254a:	e8 d7 ea ff ff       	call   801026 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80254f:	8b 03                	mov    (%ebx),%eax
  802551:	3b 43 04             	cmp    0x4(%ebx),%eax
  802554:	75 18                	jne    80256e <devpipe_read+0x58>
			if (i > 0)
  802556:	85 f6                	test   %esi,%esi
  802558:	75 e6                	jne    802540 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80255a:	89 da                	mov    %ebx,%edx
  80255c:	89 f8                	mov    %edi,%eax
  80255e:	e8 c8 fe ff ff       	call   80242b <_pipeisclosed>
  802563:	85 c0                	test   %eax,%eax
  802565:	74 e3                	je     80254a <devpipe_read+0x34>
				return 0;
  802567:	b8 00 00 00 00       	mov    $0x0,%eax
  80256c:	eb d4                	jmp    802542 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80256e:	99                   	cltd   
  80256f:	c1 ea 1b             	shr    $0x1b,%edx
  802572:	01 d0                	add    %edx,%eax
  802574:	83 e0 1f             	and    $0x1f,%eax
  802577:	29 d0                	sub    %edx,%eax
  802579:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80257e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802581:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802584:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802587:	83 c6 01             	add    $0x1,%esi
  80258a:	eb aa                	jmp    802536 <devpipe_read+0x20>

0080258c <pipe>:
{
  80258c:	f3 0f 1e fb          	endbr32 
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
  802593:	56                   	push   %esi
  802594:	53                   	push   %ebx
  802595:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802598:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80259b:	50                   	push   %eax
  80259c:	e8 e1 ef ff ff       	call   801582 <fd_alloc>
  8025a1:	89 c3                	mov    %eax,%ebx
  8025a3:	83 c4 10             	add    $0x10,%esp
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	0f 88 23 01 00 00    	js     8026d1 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025ae:	83 ec 04             	sub    $0x4,%esp
  8025b1:	68 07 04 00 00       	push   $0x407
  8025b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8025b9:	6a 00                	push   $0x0
  8025bb:	e8 89 ea ff ff       	call   801049 <sys_page_alloc>
  8025c0:	89 c3                	mov    %eax,%ebx
  8025c2:	83 c4 10             	add    $0x10,%esp
  8025c5:	85 c0                	test   %eax,%eax
  8025c7:	0f 88 04 01 00 00    	js     8026d1 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8025cd:	83 ec 0c             	sub    $0xc,%esp
  8025d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025d3:	50                   	push   %eax
  8025d4:	e8 a9 ef ff ff       	call   801582 <fd_alloc>
  8025d9:	89 c3                	mov    %eax,%ebx
  8025db:	83 c4 10             	add    $0x10,%esp
  8025de:	85 c0                	test   %eax,%eax
  8025e0:	0f 88 db 00 00 00    	js     8026c1 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025e6:	83 ec 04             	sub    $0x4,%esp
  8025e9:	68 07 04 00 00       	push   $0x407
  8025ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8025f1:	6a 00                	push   $0x0
  8025f3:	e8 51 ea ff ff       	call   801049 <sys_page_alloc>
  8025f8:	89 c3                	mov    %eax,%ebx
  8025fa:	83 c4 10             	add    $0x10,%esp
  8025fd:	85 c0                	test   %eax,%eax
  8025ff:	0f 88 bc 00 00 00    	js     8026c1 <pipe+0x135>
	va = fd2data(fd0);
  802605:	83 ec 0c             	sub    $0xc,%esp
  802608:	ff 75 f4             	pushl  -0xc(%ebp)
  80260b:	e8 57 ef ff ff       	call   801567 <fd2data>
  802610:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802612:	83 c4 0c             	add    $0xc,%esp
  802615:	68 07 04 00 00       	push   $0x407
  80261a:	50                   	push   %eax
  80261b:	6a 00                	push   $0x0
  80261d:	e8 27 ea ff ff       	call   801049 <sys_page_alloc>
  802622:	89 c3                	mov    %eax,%ebx
  802624:	83 c4 10             	add    $0x10,%esp
  802627:	85 c0                	test   %eax,%eax
  802629:	0f 88 82 00 00 00    	js     8026b1 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80262f:	83 ec 0c             	sub    $0xc,%esp
  802632:	ff 75 f0             	pushl  -0x10(%ebp)
  802635:	e8 2d ef ff ff       	call   801567 <fd2data>
  80263a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802641:	50                   	push   %eax
  802642:	6a 00                	push   $0x0
  802644:	56                   	push   %esi
  802645:	6a 00                	push   $0x0
  802647:	e8 44 ea ff ff       	call   801090 <sys_page_map>
  80264c:	89 c3                	mov    %eax,%ebx
  80264e:	83 c4 20             	add    $0x20,%esp
  802651:	85 c0                	test   %eax,%eax
  802653:	78 4e                	js     8026a3 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802655:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80265a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265d:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80265f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802662:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802669:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80266c:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80266e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802671:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802678:	83 ec 0c             	sub    $0xc,%esp
  80267b:	ff 75 f4             	pushl  -0xc(%ebp)
  80267e:	e8 d0 ee ff ff       	call   801553 <fd2num>
  802683:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802686:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802688:	83 c4 04             	add    $0x4,%esp
  80268b:	ff 75 f0             	pushl  -0x10(%ebp)
  80268e:	e8 c0 ee ff ff       	call   801553 <fd2num>
  802693:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802696:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802699:	83 c4 10             	add    $0x10,%esp
  80269c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026a1:	eb 2e                	jmp    8026d1 <pipe+0x145>
	sys_page_unmap(0, va);
  8026a3:	83 ec 08             	sub    $0x8,%esp
  8026a6:	56                   	push   %esi
  8026a7:	6a 00                	push   $0x0
  8026a9:	e8 28 ea ff ff       	call   8010d6 <sys_page_unmap>
  8026ae:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8026b1:	83 ec 08             	sub    $0x8,%esp
  8026b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8026b7:	6a 00                	push   $0x0
  8026b9:	e8 18 ea ff ff       	call   8010d6 <sys_page_unmap>
  8026be:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8026c1:	83 ec 08             	sub    $0x8,%esp
  8026c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8026c7:	6a 00                	push   $0x0
  8026c9:	e8 08 ea ff ff       	call   8010d6 <sys_page_unmap>
  8026ce:	83 c4 10             	add    $0x10,%esp
}
  8026d1:	89 d8                	mov    %ebx,%eax
  8026d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026d6:	5b                   	pop    %ebx
  8026d7:	5e                   	pop    %esi
  8026d8:	5d                   	pop    %ebp
  8026d9:	c3                   	ret    

008026da <pipeisclosed>:
{
  8026da:	f3 0f 1e fb          	endbr32 
  8026de:	55                   	push   %ebp
  8026df:	89 e5                	mov    %esp,%ebp
  8026e1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026e7:	50                   	push   %eax
  8026e8:	ff 75 08             	pushl  0x8(%ebp)
  8026eb:	e8 e8 ee ff ff       	call   8015d8 <fd_lookup>
  8026f0:	83 c4 10             	add    $0x10,%esp
  8026f3:	85 c0                	test   %eax,%eax
  8026f5:	78 18                	js     80270f <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8026f7:	83 ec 0c             	sub    $0xc,%esp
  8026fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8026fd:	e8 65 ee ff ff       	call   801567 <fd2data>
  802702:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	e8 1f fd ff ff       	call   80242b <_pipeisclosed>
  80270c:	83 c4 10             	add    $0x10,%esp
}
  80270f:	c9                   	leave  
  802710:	c3                   	ret    

00802711 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802711:	f3 0f 1e fb          	endbr32 
  802715:	55                   	push   %ebp
  802716:	89 e5                	mov    %esp,%ebp
  802718:	56                   	push   %esi
  802719:	53                   	push   %ebx
  80271a:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80271d:	85 f6                	test   %esi,%esi
  80271f:	74 13                	je     802734 <wait+0x23>
	e = &envs[ENVX(envid)];
  802721:	89 f3                	mov    %esi,%ebx
  802723:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802729:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  80272c:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802732:	eb 1b                	jmp    80274f <wait+0x3e>
	assert(envid != 0);
  802734:	68 3d 32 80 00       	push   $0x80323d
  802739:	68 6f 31 80 00       	push   $0x80316f
  80273e:	6a 09                	push   $0x9
  802740:	68 48 32 80 00       	push   $0x803248
  802745:	e8 cc dd ff ff       	call   800516 <_panic>
		sys_yield();
  80274a:	e8 d7 e8 ff ff       	call   801026 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80274f:	8b 43 48             	mov    0x48(%ebx),%eax
  802752:	39 f0                	cmp    %esi,%eax
  802754:	75 07                	jne    80275d <wait+0x4c>
  802756:	8b 43 54             	mov    0x54(%ebx),%eax
  802759:	85 c0                	test   %eax,%eax
  80275b:	75 ed                	jne    80274a <wait+0x39>
}
  80275d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802760:	5b                   	pop    %ebx
  802761:	5e                   	pop    %esi
  802762:	5d                   	pop    %ebp
  802763:	c3                   	ret    

00802764 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802764:	f3 0f 1e fb          	endbr32 
  802768:	55                   	push   %ebp
  802769:	89 e5                	mov    %esp,%ebp
  80276b:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80276e:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802775:	74 0a                	je     802781 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802777:	8b 45 08             	mov    0x8(%ebp),%eax
  80277a:	a3 00 70 80 00       	mov    %eax,0x807000
}
  80277f:	c9                   	leave  
  802780:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  802781:	83 ec 04             	sub    $0x4,%esp
  802784:	6a 07                	push   $0x7
  802786:	68 00 f0 bf ee       	push   $0xeebff000
  80278b:	6a 00                	push   $0x0
  80278d:	e8 b7 e8 ff ff       	call   801049 <sys_page_alloc>
  802792:	83 c4 10             	add    $0x10,%esp
  802795:	85 c0                	test   %eax,%eax
  802797:	78 2a                	js     8027c3 <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  802799:	83 ec 08             	sub    $0x8,%esp
  80279c:	68 d7 27 80 00       	push   $0x8027d7
  8027a1:	6a 00                	push   $0x0
  8027a3:	e8 00 ea ff ff       	call   8011a8 <sys_env_set_pgfault_upcall>
  8027a8:	83 c4 10             	add    $0x10,%esp
  8027ab:	85 c0                	test   %eax,%eax
  8027ad:	79 c8                	jns    802777 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  8027af:	83 ec 04             	sub    $0x4,%esp
  8027b2:	68 80 32 80 00       	push   $0x803280
  8027b7:	6a 25                	push   $0x25
  8027b9:	68 b8 32 80 00       	push   $0x8032b8
  8027be:	e8 53 dd ff ff       	call   800516 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  8027c3:	83 ec 04             	sub    $0x4,%esp
  8027c6:	68 54 32 80 00       	push   $0x803254
  8027cb:	6a 22                	push   $0x22
  8027cd:	68 b8 32 80 00       	push   $0x8032b8
  8027d2:	e8 3f dd ff ff       	call   800516 <_panic>

008027d7 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8027d7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8027d8:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8027dd:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8027df:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  8027e2:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  8027e6:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8027ea:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8027ed:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  8027ef:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  8027f3:	83 c4 08             	add    $0x8,%esp
	popal
  8027f6:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  8027f7:	83 c4 04             	add    $0x4,%esp
	popfl
  8027fa:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  8027fb:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  8027fc:	c3                   	ret    

008027fd <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027fd:	f3 0f 1e fb          	endbr32 
  802801:	55                   	push   %ebp
  802802:	89 e5                	mov    %esp,%ebp
  802804:	56                   	push   %esi
  802805:	53                   	push   %ebx
  802806:	8b 75 08             	mov    0x8(%ebp),%esi
  802809:	8b 45 0c             	mov    0xc(%ebp),%eax
  80280c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  80280f:	85 c0                	test   %eax,%eax
  802811:	74 3d                	je     802850 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  802813:	83 ec 0c             	sub    $0xc,%esp
  802816:	50                   	push   %eax
  802817:	e8 f9 e9 ff ff       	call   801215 <sys_ipc_recv>
  80281c:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  80281f:	85 f6                	test   %esi,%esi
  802821:	74 0b                	je     80282e <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802823:	8b 15 04 50 80 00    	mov    0x805004,%edx
  802829:	8b 52 74             	mov    0x74(%edx),%edx
  80282c:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  80282e:	85 db                	test   %ebx,%ebx
  802830:	74 0b                	je     80283d <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  802832:	8b 15 04 50 80 00    	mov    0x805004,%edx
  802838:	8b 52 78             	mov    0x78(%edx),%edx
  80283b:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  80283d:	85 c0                	test   %eax,%eax
  80283f:	78 21                	js     802862 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  802841:	a1 04 50 80 00       	mov    0x805004,%eax
  802846:	8b 40 70             	mov    0x70(%eax),%eax
}
  802849:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80284c:	5b                   	pop    %ebx
  80284d:	5e                   	pop    %esi
  80284e:	5d                   	pop    %ebp
  80284f:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802850:	83 ec 0c             	sub    $0xc,%esp
  802853:	68 00 00 c0 ee       	push   $0xeec00000
  802858:	e8 b8 e9 ff ff       	call   801215 <sys_ipc_recv>
  80285d:	83 c4 10             	add    $0x10,%esp
  802860:	eb bd                	jmp    80281f <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802862:	85 f6                	test   %esi,%esi
  802864:	74 10                	je     802876 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802866:	85 db                	test   %ebx,%ebx
  802868:	75 df                	jne    802849 <ipc_recv+0x4c>
  80286a:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802871:	00 00 00 
  802874:	eb d3                	jmp    802849 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802876:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80287d:	00 00 00 
  802880:	eb e4                	jmp    802866 <ipc_recv+0x69>

00802882 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802882:	f3 0f 1e fb          	endbr32 
  802886:	55                   	push   %ebp
  802887:	89 e5                	mov    %esp,%ebp
  802889:	57                   	push   %edi
  80288a:	56                   	push   %esi
  80288b:	53                   	push   %ebx
  80288c:	83 ec 0c             	sub    $0xc,%esp
  80288f:	8b 7d 08             	mov    0x8(%ebp),%edi
  802892:	8b 75 0c             	mov    0xc(%ebp),%esi
  802895:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802898:	85 db                	test   %ebx,%ebx
  80289a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80289f:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8028a2:	ff 75 14             	pushl  0x14(%ebp)
  8028a5:	53                   	push   %ebx
  8028a6:	56                   	push   %esi
  8028a7:	57                   	push   %edi
  8028a8:	e8 41 e9 ff ff       	call   8011ee <sys_ipc_try_send>
  8028ad:	83 c4 10             	add    $0x10,%esp
  8028b0:	85 c0                	test   %eax,%eax
  8028b2:	79 1e                	jns    8028d2 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  8028b4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8028b7:	75 07                	jne    8028c0 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  8028b9:	e8 68 e7 ff ff       	call   801026 <sys_yield>
  8028be:	eb e2                	jmp    8028a2 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  8028c0:	50                   	push   %eax
  8028c1:	68 c6 32 80 00       	push   $0x8032c6
  8028c6:	6a 59                	push   $0x59
  8028c8:	68 e1 32 80 00       	push   $0x8032e1
  8028cd:	e8 44 dc ff ff       	call   800516 <_panic>
	}
}
  8028d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028d5:	5b                   	pop    %ebx
  8028d6:	5e                   	pop    %esi
  8028d7:	5f                   	pop    %edi
  8028d8:	5d                   	pop    %ebp
  8028d9:	c3                   	ret    

008028da <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028da:	f3 0f 1e fb          	endbr32 
  8028de:	55                   	push   %ebp
  8028df:	89 e5                	mov    %esp,%ebp
  8028e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8028e4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8028e9:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8028ec:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8028f2:	8b 52 50             	mov    0x50(%edx),%edx
  8028f5:	39 ca                	cmp    %ecx,%edx
  8028f7:	74 11                	je     80290a <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8028f9:	83 c0 01             	add    $0x1,%eax
  8028fc:	3d 00 04 00 00       	cmp    $0x400,%eax
  802901:	75 e6                	jne    8028e9 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802903:	b8 00 00 00 00       	mov    $0x0,%eax
  802908:	eb 0b                	jmp    802915 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80290a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80290d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802912:	8b 40 48             	mov    0x48(%eax),%eax
}
  802915:	5d                   	pop    %ebp
  802916:	c3                   	ret    

00802917 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802917:	f3 0f 1e fb          	endbr32 
  80291b:	55                   	push   %ebp
  80291c:	89 e5                	mov    %esp,%ebp
  80291e:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802921:	89 c2                	mov    %eax,%edx
  802923:	c1 ea 16             	shr    $0x16,%edx
  802926:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80292d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802932:	f6 c1 01             	test   $0x1,%cl
  802935:	74 1c                	je     802953 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802937:	c1 e8 0c             	shr    $0xc,%eax
  80293a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802941:	a8 01                	test   $0x1,%al
  802943:	74 0e                	je     802953 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802945:	c1 e8 0c             	shr    $0xc,%eax
  802948:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80294f:	ef 
  802950:	0f b7 d2             	movzwl %dx,%edx
}
  802953:	89 d0                	mov    %edx,%eax
  802955:	5d                   	pop    %ebp
  802956:	c3                   	ret    
  802957:	66 90                	xchg   %ax,%ax
  802959:	66 90                	xchg   %ax,%ax
  80295b:	66 90                	xchg   %ax,%ax
  80295d:	66 90                	xchg   %ax,%ax
  80295f:	90                   	nop

00802960 <__udivdi3>:
  802960:	f3 0f 1e fb          	endbr32 
  802964:	55                   	push   %ebp
  802965:	57                   	push   %edi
  802966:	56                   	push   %esi
  802967:	53                   	push   %ebx
  802968:	83 ec 1c             	sub    $0x1c,%esp
  80296b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80296f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802973:	8b 74 24 34          	mov    0x34(%esp),%esi
  802977:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80297b:	85 d2                	test   %edx,%edx
  80297d:	75 19                	jne    802998 <__udivdi3+0x38>
  80297f:	39 f3                	cmp    %esi,%ebx
  802981:	76 4d                	jbe    8029d0 <__udivdi3+0x70>
  802983:	31 ff                	xor    %edi,%edi
  802985:	89 e8                	mov    %ebp,%eax
  802987:	89 f2                	mov    %esi,%edx
  802989:	f7 f3                	div    %ebx
  80298b:	89 fa                	mov    %edi,%edx
  80298d:	83 c4 1c             	add    $0x1c,%esp
  802990:	5b                   	pop    %ebx
  802991:	5e                   	pop    %esi
  802992:	5f                   	pop    %edi
  802993:	5d                   	pop    %ebp
  802994:	c3                   	ret    
  802995:	8d 76 00             	lea    0x0(%esi),%esi
  802998:	39 f2                	cmp    %esi,%edx
  80299a:	76 14                	jbe    8029b0 <__udivdi3+0x50>
  80299c:	31 ff                	xor    %edi,%edi
  80299e:	31 c0                	xor    %eax,%eax
  8029a0:	89 fa                	mov    %edi,%edx
  8029a2:	83 c4 1c             	add    $0x1c,%esp
  8029a5:	5b                   	pop    %ebx
  8029a6:	5e                   	pop    %esi
  8029a7:	5f                   	pop    %edi
  8029a8:	5d                   	pop    %ebp
  8029a9:	c3                   	ret    
  8029aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029b0:	0f bd fa             	bsr    %edx,%edi
  8029b3:	83 f7 1f             	xor    $0x1f,%edi
  8029b6:	75 48                	jne    802a00 <__udivdi3+0xa0>
  8029b8:	39 f2                	cmp    %esi,%edx
  8029ba:	72 06                	jb     8029c2 <__udivdi3+0x62>
  8029bc:	31 c0                	xor    %eax,%eax
  8029be:	39 eb                	cmp    %ebp,%ebx
  8029c0:	77 de                	ja     8029a0 <__udivdi3+0x40>
  8029c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8029c7:	eb d7                	jmp    8029a0 <__udivdi3+0x40>
  8029c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029d0:	89 d9                	mov    %ebx,%ecx
  8029d2:	85 db                	test   %ebx,%ebx
  8029d4:	75 0b                	jne    8029e1 <__udivdi3+0x81>
  8029d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8029db:	31 d2                	xor    %edx,%edx
  8029dd:	f7 f3                	div    %ebx
  8029df:	89 c1                	mov    %eax,%ecx
  8029e1:	31 d2                	xor    %edx,%edx
  8029e3:	89 f0                	mov    %esi,%eax
  8029e5:	f7 f1                	div    %ecx
  8029e7:	89 c6                	mov    %eax,%esi
  8029e9:	89 e8                	mov    %ebp,%eax
  8029eb:	89 f7                	mov    %esi,%edi
  8029ed:	f7 f1                	div    %ecx
  8029ef:	89 fa                	mov    %edi,%edx
  8029f1:	83 c4 1c             	add    $0x1c,%esp
  8029f4:	5b                   	pop    %ebx
  8029f5:	5e                   	pop    %esi
  8029f6:	5f                   	pop    %edi
  8029f7:	5d                   	pop    %ebp
  8029f8:	c3                   	ret    
  8029f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a00:	89 f9                	mov    %edi,%ecx
  802a02:	b8 20 00 00 00       	mov    $0x20,%eax
  802a07:	29 f8                	sub    %edi,%eax
  802a09:	d3 e2                	shl    %cl,%edx
  802a0b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a0f:	89 c1                	mov    %eax,%ecx
  802a11:	89 da                	mov    %ebx,%edx
  802a13:	d3 ea                	shr    %cl,%edx
  802a15:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a19:	09 d1                	or     %edx,%ecx
  802a1b:	89 f2                	mov    %esi,%edx
  802a1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a21:	89 f9                	mov    %edi,%ecx
  802a23:	d3 e3                	shl    %cl,%ebx
  802a25:	89 c1                	mov    %eax,%ecx
  802a27:	d3 ea                	shr    %cl,%edx
  802a29:	89 f9                	mov    %edi,%ecx
  802a2b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a2f:	89 eb                	mov    %ebp,%ebx
  802a31:	d3 e6                	shl    %cl,%esi
  802a33:	89 c1                	mov    %eax,%ecx
  802a35:	d3 eb                	shr    %cl,%ebx
  802a37:	09 de                	or     %ebx,%esi
  802a39:	89 f0                	mov    %esi,%eax
  802a3b:	f7 74 24 08          	divl   0x8(%esp)
  802a3f:	89 d6                	mov    %edx,%esi
  802a41:	89 c3                	mov    %eax,%ebx
  802a43:	f7 64 24 0c          	mull   0xc(%esp)
  802a47:	39 d6                	cmp    %edx,%esi
  802a49:	72 15                	jb     802a60 <__udivdi3+0x100>
  802a4b:	89 f9                	mov    %edi,%ecx
  802a4d:	d3 e5                	shl    %cl,%ebp
  802a4f:	39 c5                	cmp    %eax,%ebp
  802a51:	73 04                	jae    802a57 <__udivdi3+0xf7>
  802a53:	39 d6                	cmp    %edx,%esi
  802a55:	74 09                	je     802a60 <__udivdi3+0x100>
  802a57:	89 d8                	mov    %ebx,%eax
  802a59:	31 ff                	xor    %edi,%edi
  802a5b:	e9 40 ff ff ff       	jmp    8029a0 <__udivdi3+0x40>
  802a60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a63:	31 ff                	xor    %edi,%edi
  802a65:	e9 36 ff ff ff       	jmp    8029a0 <__udivdi3+0x40>
  802a6a:	66 90                	xchg   %ax,%ax
  802a6c:	66 90                	xchg   %ax,%ax
  802a6e:	66 90                	xchg   %ax,%ax

00802a70 <__umoddi3>:
  802a70:	f3 0f 1e fb          	endbr32 
  802a74:	55                   	push   %ebp
  802a75:	57                   	push   %edi
  802a76:	56                   	push   %esi
  802a77:	53                   	push   %ebx
  802a78:	83 ec 1c             	sub    $0x1c,%esp
  802a7b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a7f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a83:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a8b:	85 c0                	test   %eax,%eax
  802a8d:	75 19                	jne    802aa8 <__umoddi3+0x38>
  802a8f:	39 df                	cmp    %ebx,%edi
  802a91:	76 5d                	jbe    802af0 <__umoddi3+0x80>
  802a93:	89 f0                	mov    %esi,%eax
  802a95:	89 da                	mov    %ebx,%edx
  802a97:	f7 f7                	div    %edi
  802a99:	89 d0                	mov    %edx,%eax
  802a9b:	31 d2                	xor    %edx,%edx
  802a9d:	83 c4 1c             	add    $0x1c,%esp
  802aa0:	5b                   	pop    %ebx
  802aa1:	5e                   	pop    %esi
  802aa2:	5f                   	pop    %edi
  802aa3:	5d                   	pop    %ebp
  802aa4:	c3                   	ret    
  802aa5:	8d 76 00             	lea    0x0(%esi),%esi
  802aa8:	89 f2                	mov    %esi,%edx
  802aaa:	39 d8                	cmp    %ebx,%eax
  802aac:	76 12                	jbe    802ac0 <__umoddi3+0x50>
  802aae:	89 f0                	mov    %esi,%eax
  802ab0:	89 da                	mov    %ebx,%edx
  802ab2:	83 c4 1c             	add    $0x1c,%esp
  802ab5:	5b                   	pop    %ebx
  802ab6:	5e                   	pop    %esi
  802ab7:	5f                   	pop    %edi
  802ab8:	5d                   	pop    %ebp
  802ab9:	c3                   	ret    
  802aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ac0:	0f bd e8             	bsr    %eax,%ebp
  802ac3:	83 f5 1f             	xor    $0x1f,%ebp
  802ac6:	75 50                	jne    802b18 <__umoddi3+0xa8>
  802ac8:	39 d8                	cmp    %ebx,%eax
  802aca:	0f 82 e0 00 00 00    	jb     802bb0 <__umoddi3+0x140>
  802ad0:	89 d9                	mov    %ebx,%ecx
  802ad2:	39 f7                	cmp    %esi,%edi
  802ad4:	0f 86 d6 00 00 00    	jbe    802bb0 <__umoddi3+0x140>
  802ada:	89 d0                	mov    %edx,%eax
  802adc:	89 ca                	mov    %ecx,%edx
  802ade:	83 c4 1c             	add    $0x1c,%esp
  802ae1:	5b                   	pop    %ebx
  802ae2:	5e                   	pop    %esi
  802ae3:	5f                   	pop    %edi
  802ae4:	5d                   	pop    %ebp
  802ae5:	c3                   	ret    
  802ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802aed:	8d 76 00             	lea    0x0(%esi),%esi
  802af0:	89 fd                	mov    %edi,%ebp
  802af2:	85 ff                	test   %edi,%edi
  802af4:	75 0b                	jne    802b01 <__umoddi3+0x91>
  802af6:	b8 01 00 00 00       	mov    $0x1,%eax
  802afb:	31 d2                	xor    %edx,%edx
  802afd:	f7 f7                	div    %edi
  802aff:	89 c5                	mov    %eax,%ebp
  802b01:	89 d8                	mov    %ebx,%eax
  802b03:	31 d2                	xor    %edx,%edx
  802b05:	f7 f5                	div    %ebp
  802b07:	89 f0                	mov    %esi,%eax
  802b09:	f7 f5                	div    %ebp
  802b0b:	89 d0                	mov    %edx,%eax
  802b0d:	31 d2                	xor    %edx,%edx
  802b0f:	eb 8c                	jmp    802a9d <__umoddi3+0x2d>
  802b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b18:	89 e9                	mov    %ebp,%ecx
  802b1a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b1f:	29 ea                	sub    %ebp,%edx
  802b21:	d3 e0                	shl    %cl,%eax
  802b23:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b27:	89 d1                	mov    %edx,%ecx
  802b29:	89 f8                	mov    %edi,%eax
  802b2b:	d3 e8                	shr    %cl,%eax
  802b2d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b31:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b35:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b39:	09 c1                	or     %eax,%ecx
  802b3b:	89 d8                	mov    %ebx,%eax
  802b3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b41:	89 e9                	mov    %ebp,%ecx
  802b43:	d3 e7                	shl    %cl,%edi
  802b45:	89 d1                	mov    %edx,%ecx
  802b47:	d3 e8                	shr    %cl,%eax
  802b49:	89 e9                	mov    %ebp,%ecx
  802b4b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b4f:	d3 e3                	shl    %cl,%ebx
  802b51:	89 c7                	mov    %eax,%edi
  802b53:	89 d1                	mov    %edx,%ecx
  802b55:	89 f0                	mov    %esi,%eax
  802b57:	d3 e8                	shr    %cl,%eax
  802b59:	89 e9                	mov    %ebp,%ecx
  802b5b:	89 fa                	mov    %edi,%edx
  802b5d:	d3 e6                	shl    %cl,%esi
  802b5f:	09 d8                	or     %ebx,%eax
  802b61:	f7 74 24 08          	divl   0x8(%esp)
  802b65:	89 d1                	mov    %edx,%ecx
  802b67:	89 f3                	mov    %esi,%ebx
  802b69:	f7 64 24 0c          	mull   0xc(%esp)
  802b6d:	89 c6                	mov    %eax,%esi
  802b6f:	89 d7                	mov    %edx,%edi
  802b71:	39 d1                	cmp    %edx,%ecx
  802b73:	72 06                	jb     802b7b <__umoddi3+0x10b>
  802b75:	75 10                	jne    802b87 <__umoddi3+0x117>
  802b77:	39 c3                	cmp    %eax,%ebx
  802b79:	73 0c                	jae    802b87 <__umoddi3+0x117>
  802b7b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b7f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b83:	89 d7                	mov    %edx,%edi
  802b85:	89 c6                	mov    %eax,%esi
  802b87:	89 ca                	mov    %ecx,%edx
  802b89:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b8e:	29 f3                	sub    %esi,%ebx
  802b90:	19 fa                	sbb    %edi,%edx
  802b92:	89 d0                	mov    %edx,%eax
  802b94:	d3 e0                	shl    %cl,%eax
  802b96:	89 e9                	mov    %ebp,%ecx
  802b98:	d3 eb                	shr    %cl,%ebx
  802b9a:	d3 ea                	shr    %cl,%edx
  802b9c:	09 d8                	or     %ebx,%eax
  802b9e:	83 c4 1c             	add    $0x1c,%esp
  802ba1:	5b                   	pop    %ebx
  802ba2:	5e                   	pop    %esi
  802ba3:	5f                   	pop    %edi
  802ba4:	5d                   	pop    %ebp
  802ba5:	c3                   	ret    
  802ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bad:	8d 76 00             	lea    0x0(%esi),%esi
  802bb0:	29 fe                	sub    %edi,%esi
  802bb2:	19 c3                	sbb    %eax,%ebx
  802bb4:	89 f2                	mov    %esi,%edx
  802bb6:	89 d9                	mov    %ebx,%ecx
  802bb8:	e9 1d ff ff ff       	jmp    802ada <__umoddi3+0x6a>
