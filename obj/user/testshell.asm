
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
  80004e:	e8 18 1a 00 00       	call   801a6b <seek>
	seek(kfd, off);
  800053:	83 c4 08             	add    $0x8,%esp
  800056:	53                   	push   %ebx
  800057:	57                   	push   %edi
  800058:	e8 0e 1a 00 00       	call   801a6b <seek>

	cprintf("shell produced incorrect output.\n");
  80005d:	c7 04 24 40 31 80 00 	movl   $0x803140,(%esp)
  800064:	e8 94 05 00 00       	call   8005fd <cprintf>
	cprintf("expected:\n===\n");
  800069:	c7 04 24 ab 31 80 00 	movl   $0x8031ab,(%esp)
  800070:	e8 88 05 00 00       	call   8005fd <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  80007b:	83 ec 04             	sub    $0x4,%esp
  80007e:	6a 63                	push   $0x63
  800080:	53                   	push   %ebx
  800081:	57                   	push   %edi
  800082:	e8 88 18 00 00       	call   80190f <read>
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
  8000a0:	68 ba 31 80 00       	push   $0x8031ba
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
  8000c6:	e8 44 18 00 00       	call   80190f <read>
  8000cb:	83 c4 10             	add    $0x10,%esp
  8000ce:	85 c0                	test   %eax,%eax
  8000d0:	7f e0                	jg     8000b2 <wrong+0x7f>
	cprintf("===\n");
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 b5 31 80 00       	push   $0x8031b5
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
  8000fe:	e8 c2 16 00 00       	call   8017c5 <close>
	close(1);
  800103:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80010a:	e8 b6 16 00 00       	call   8017c5 <close>
	opencons();
  80010f:	e8 44 03 00 00       	call   800458 <opencons>
	opencons();
  800114:	e8 3f 03 00 00       	call   800458 <opencons>
	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800119:	83 c4 08             	add    $0x8,%esp
  80011c:	6a 00                	push   $0x0
  80011e:	68 c8 31 80 00       	push   $0x8031c8
  800123:	e8 7c 1c 00 00       	call   801da4 <open>
  800128:	89 c3                	mov    %eax,%ebx
  80012a:	83 c4 10             	add    $0x10,%esp
  80012d:	85 c0                	test   %eax,%eax
  80012f:	0f 88 e7 00 00 00    	js     80021c <umain+0x12d>
	if ((wfd = pipe(pfds)) < 0)
  800135:	83 ec 0c             	sub    $0xc,%esp
  800138:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80013b:	50                   	push   %eax
  80013c:	e8 b7 29 00 00       	call   802af8 <pipe>
  800141:	83 c4 10             	add    $0x10,%esp
  800144:	85 c0                	test   %eax,%eax
  800146:	0f 88 e2 00 00 00    	js     80022e <umain+0x13f>
	wfd = pfds[1];
  80014c:	8b 75 e0             	mov    -0x20(%ebp),%esi
	cprintf("running sh -x < testshell.sh | cat\n");
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	68 64 31 80 00       	push   $0x803164
  800157:	e8 a1 04 00 00       	call   8005fd <cprintf>
	if ((r = fork()) < 0)
  80015c:	e8 88 12 00 00       	call   8013e9 <fork>
  800161:	83 c4 10             	add    $0x10,%esp
  800164:	85 c0                	test   %eax,%eax
  800166:	0f 88 d4 00 00 00    	js     800240 <umain+0x151>
	if (r == 0) {
  80016c:	75 6f                	jne    8001dd <umain+0xee>
		dup(rfd, 0);
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	6a 00                	push   $0x0
  800173:	53                   	push   %ebx
  800174:	e8 a6 16 00 00       	call   80181f <dup>
		dup(wfd, 1);
  800179:	83 c4 08             	add    $0x8,%esp
  80017c:	6a 01                	push   $0x1
  80017e:	56                   	push   %esi
  80017f:	e8 9b 16 00 00       	call   80181f <dup>
		close(rfd);
  800184:	89 1c 24             	mov    %ebx,(%esp)
  800187:	e8 39 16 00 00       	call   8017c5 <close>
		close(wfd);
  80018c:	89 34 24             	mov    %esi,(%esp)
  80018f:	e8 31 16 00 00       	call   8017c5 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  800194:	6a 00                	push   $0x0
  800196:	68 05 32 80 00       	push   $0x803205
  80019b:	68 d2 31 80 00       	push   $0x8031d2
  8001a0:	68 08 32 80 00       	push   $0x803208
  8001a5:	e8 03 22 00 00       	call   8023ad <spawnl>
  8001aa:	89 c7                	mov    %eax,%edi
  8001ac:	83 c4 20             	add    $0x20,%esp
  8001af:	85 c0                	test   %eax,%eax
  8001b1:	0f 88 9b 00 00 00    	js     800252 <umain+0x163>
		close(0);
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	6a 00                	push   $0x0
  8001bc:	e8 04 16 00 00       	call   8017c5 <close>
		close(1);
  8001c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001c8:	e8 f8 15 00 00       	call   8017c5 <close>
		wait(r);
  8001cd:	89 3c 24             	mov    %edi,(%esp)
  8001d0:	e8 a8 2a 00 00       	call   802c7d <wait>
		exit();
  8001d5:	e8 1e 03 00 00       	call   8004f8 <exit>
  8001da:	83 c4 10             	add    $0x10,%esp
	close(rfd);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	53                   	push   %ebx
  8001e1:	e8 df 15 00 00       	call   8017c5 <close>
	close(wfd);
  8001e6:	89 34 24             	mov    %esi,(%esp)
  8001e9:	e8 d7 15 00 00       	call   8017c5 <close>
	rfd = pfds[0];
  8001ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8001f4:	83 c4 08             	add    $0x8,%esp
  8001f7:	6a 00                	push   $0x0
  8001f9:	68 16 32 80 00       	push   $0x803216
  8001fe:	e8 a1 1b 00 00       	call   801da4 <open>
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
  80021d:	68 d5 31 80 00       	push   $0x8031d5
  800222:	6a 13                	push   $0x13
  800224:	68 eb 31 80 00       	push   $0x8031eb
  800229:	e8 e8 02 00 00       	call   800516 <_panic>
		panic("pipe: %e", wfd);
  80022e:	50                   	push   %eax
  80022f:	68 fc 31 80 00       	push   $0x8031fc
  800234:	6a 15                	push   $0x15
  800236:	68 eb 31 80 00       	push   $0x8031eb
  80023b:	e8 d6 02 00 00       	call   800516 <_panic>
		panic("fork: %e", r);
  800240:	50                   	push   %eax
  800241:	68 05 36 80 00       	push   $0x803605
  800246:	6a 1a                	push   $0x1a
  800248:	68 eb 31 80 00       	push   $0x8031eb
  80024d:	e8 c4 02 00 00       	call   800516 <_panic>
			panic("spawn: %e", r);
  800252:	50                   	push   %eax
  800253:	68 0c 32 80 00       	push   $0x80320c
  800258:	6a 21                	push   $0x21
  80025a:	68 eb 31 80 00       	push   $0x8031eb
  80025f:	e8 b2 02 00 00       	call   800516 <_panic>
		panic("open testshell.key for reading: %e", kfd);
  800264:	50                   	push   %eax
  800265:	68 88 31 80 00       	push   $0x803188
  80026a:	6a 2c                	push   $0x2c
  80026c:	68 eb 31 80 00       	push   $0x8031eb
  800271:	e8 a0 02 00 00       	call   800516 <_panic>
			panic("reading testshell.out: %e", n1);
  800276:	53                   	push   %ebx
  800277:	68 24 32 80 00       	push   $0x803224
  80027c:	6a 33                	push   $0x33
  80027e:	68 eb 31 80 00       	push   $0x8031eb
  800283:	e8 8e 02 00 00       	call   800516 <_panic>
			panic("reading testshell.key: %e", n2);
  800288:	50                   	push   %eax
  800289:	68 3e 32 80 00       	push   $0x80323e
  80028e:	6a 35                	push   $0x35
  800290:	68 eb 31 80 00       	push   $0x8031eb
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
  8002c2:	e8 48 16 00 00       	call   80190f <read>
  8002c7:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002c9:	83 c4 0c             	add    $0xc,%esp
  8002cc:	6a 01                	push   $0x1
  8002ce:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002d1:	50                   	push   %eax
  8002d2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002d5:	e8 35 16 00 00       	call   80190f <read>
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
  800303:	68 58 32 80 00       	push   $0x803258
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
  80032d:	68 6d 32 80 00       	push   $0x80326d
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
  80040d:	e8 fd 14 00 00       	call   80190f <read>
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
  800439:	e8 49 12 00 00       	call   801687 <fd_lookup>
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
  800466:	e8 c6 11 00 00       	call   801631 <fd_alloc>
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
  8004a4:	e8 59 11 00 00       	call   801602 <fd2num>
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
  8004cf:	a3 08 50 80 00       	mov    %eax,0x805008

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
  800502:	e8 ef 12 00 00       	call   8017f6 <close_all>
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
  800538:	68 84 32 80 00       	push   $0x803284
  80053d:	e8 bb 00 00 00       	call   8005fd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800542:	83 c4 18             	add    $0x18,%esp
  800545:	53                   	push   %ebx
  800546:	ff 75 10             	pushl  0x10(%ebp)
  800549:	e8 5a 00 00 00       	call   8005a8 <vcprintf>
	cprintf("\n");
  80054e:	c7 04 24 b8 31 80 00 	movl   $0x8031b8,(%esp)
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
  800663:	e8 68 28 00 00       	call   802ed0 <__udivdi3>
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
  8006a1:	e8 3a 29 00 00       	call   802fe0 <__umoddi3>
  8006a6:	83 c4 14             	add    $0x14,%esp
  8006a9:	0f be 80 a7 32 80 00 	movsbl 0x8032a7(%eax),%eax
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
  800750:	3e ff 24 85 e0 33 80 	notrack jmp *0x8033e0(,%eax,4)
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
  80081d:	8b 14 85 40 35 80 00 	mov    0x803540(,%eax,4),%edx
  800824:	85 d2                	test   %edx,%edx
  800826:	74 18                	je     800840 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800828:	52                   	push   %edx
  800829:	68 05 37 80 00       	push   $0x803705
  80082e:	53                   	push   %ebx
  80082f:	56                   	push   %esi
  800830:	e8 aa fe ff ff       	call   8006df <printfmt>
  800835:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800838:	89 7d 14             	mov    %edi,0x14(%ebp)
  80083b:	e9 66 02 00 00       	jmp    800aa6 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800840:	50                   	push   %eax
  800841:	68 bf 32 80 00       	push   $0x8032bf
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
  800868:	b8 b8 32 80 00       	mov    $0x8032b8,%eax
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
  800ff2:	68 9f 35 80 00       	push   $0x80359f
  800ff7:	6a 23                	push   $0x23
  800ff9:	68 bc 35 80 00       	push   $0x8035bc
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
  80107f:	68 9f 35 80 00       	push   $0x80359f
  801084:	6a 23                	push   $0x23
  801086:	68 bc 35 80 00       	push   $0x8035bc
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
  8010c5:	68 9f 35 80 00       	push   $0x80359f
  8010ca:	6a 23                	push   $0x23
  8010cc:	68 bc 35 80 00       	push   $0x8035bc
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
  80110b:	68 9f 35 80 00       	push   $0x80359f
  801110:	6a 23                	push   $0x23
  801112:	68 bc 35 80 00       	push   $0x8035bc
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
  801151:	68 9f 35 80 00       	push   $0x80359f
  801156:	6a 23                	push   $0x23
  801158:	68 bc 35 80 00       	push   $0x8035bc
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
  801197:	68 9f 35 80 00       	push   $0x80359f
  80119c:	6a 23                	push   $0x23
  80119e:	68 bc 35 80 00       	push   $0x8035bc
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
  8011dd:	68 9f 35 80 00       	push   $0x80359f
  8011e2:	6a 23                	push   $0x23
  8011e4:	68 bc 35 80 00       	push   $0x8035bc
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
  801249:	68 9f 35 80 00       	push   $0x80359f
  80124e:	6a 23                	push   $0x23
  801250:	68 bc 35 80 00       	push   $0x8035bc
  801255:	e8 bc f2 ff ff       	call   800516 <_panic>

0080125a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80125a:	f3 0f 1e fb          	endbr32 
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
  801261:	57                   	push   %edi
  801262:	56                   	push   %esi
  801263:	53                   	push   %ebx
	asm volatile("int %1\n"
  801264:	ba 00 00 00 00       	mov    $0x0,%edx
  801269:	b8 0e 00 00 00       	mov    $0xe,%eax
  80126e:	89 d1                	mov    %edx,%ecx
  801270:	89 d3                	mov    %edx,%ebx
  801272:	89 d7                	mov    %edx,%edi
  801274:	89 d6                	mov    %edx,%esi
  801276:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801278:	5b                   	pop    %ebx
  801279:	5e                   	pop    %esi
  80127a:	5f                   	pop    %edi
  80127b:	5d                   	pop    %ebp
  80127c:	c3                   	ret    

0080127d <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  80127d:	f3 0f 1e fb          	endbr32 
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	57                   	push   %edi
  801285:	56                   	push   %esi
  801286:	53                   	push   %ebx
  801287:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80128a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80128f:	8b 55 08             	mov    0x8(%ebp),%edx
  801292:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801295:	b8 0f 00 00 00       	mov    $0xf,%eax
  80129a:	89 df                	mov    %ebx,%edi
  80129c:	89 de                	mov    %ebx,%esi
  80129e:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012a0:	85 c0                	test   %eax,%eax
  8012a2:	7f 08                	jg     8012ac <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  8012a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a7:	5b                   	pop    %ebx
  8012a8:	5e                   	pop    %esi
  8012a9:	5f                   	pop    %edi
  8012aa:	5d                   	pop    %ebp
  8012ab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012ac:	83 ec 0c             	sub    $0xc,%esp
  8012af:	50                   	push   %eax
  8012b0:	6a 0f                	push   $0xf
  8012b2:	68 9f 35 80 00       	push   $0x80359f
  8012b7:	6a 23                	push   $0x23
  8012b9:	68 bc 35 80 00       	push   $0x8035bc
  8012be:	e8 53 f2 ff ff       	call   800516 <_panic>

008012c3 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  8012c3:	f3 0f 1e fb          	endbr32 
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	57                   	push   %edi
  8012cb:	56                   	push   %esi
  8012cc:	53                   	push   %ebx
  8012cd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012db:	b8 10 00 00 00       	mov    $0x10,%eax
  8012e0:	89 df                	mov    %ebx,%edi
  8012e2:	89 de                	mov    %ebx,%esi
  8012e4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012e6:	85 c0                	test   %eax,%eax
  8012e8:	7f 08                	jg     8012f2 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  8012ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ed:	5b                   	pop    %ebx
  8012ee:	5e                   	pop    %esi
  8012ef:	5f                   	pop    %edi
  8012f0:	5d                   	pop    %ebp
  8012f1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012f2:	83 ec 0c             	sub    $0xc,%esp
  8012f5:	50                   	push   %eax
  8012f6:	6a 10                	push   $0x10
  8012f8:	68 9f 35 80 00       	push   $0x80359f
  8012fd:	6a 23                	push   $0x23
  8012ff:	68 bc 35 80 00       	push   $0x8035bc
  801304:	e8 0d f2 ff ff       	call   800516 <_panic>

00801309 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801309:	f3 0f 1e fb          	endbr32 
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
  801310:	53                   	push   %ebx
  801311:	83 ec 04             	sub    $0x4,%esp
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801317:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) {
  801319:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80131d:	74 74                	je     801393 <pgfault+0x8a>
  80131f:	89 d8                	mov    %ebx,%eax
  801321:	c1 e8 0c             	shr    $0xc,%eax
  801324:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80132b:	f6 c4 08             	test   $0x8,%ah
  80132e:	74 63                	je     801393 <pgfault+0x8a>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  801330:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, (void *) PFTEMP, PTE_U | PTE_P)) < 0) {
  801336:	83 ec 0c             	sub    $0xc,%esp
  801339:	6a 05                	push   $0x5
  80133b:	68 00 f0 7f 00       	push   $0x7ff000
  801340:	6a 00                	push   $0x0
  801342:	53                   	push   %ebx
  801343:	6a 00                	push   $0x0
  801345:	e8 46 fd ff ff       	call   801090 <sys_page_map>
  80134a:	83 c4 20             	add    $0x20,%esp
  80134d:	85 c0                	test   %eax,%eax
  80134f:	78 59                	js     8013aa <pgfault+0xa1>
		panic("pgfault: %e\n", r);
	}

	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0) {
  801351:	83 ec 04             	sub    $0x4,%esp
  801354:	6a 07                	push   $0x7
  801356:	53                   	push   %ebx
  801357:	6a 00                	push   $0x0
  801359:	e8 eb fc ff ff       	call   801049 <sys_page_alloc>
  80135e:	83 c4 10             	add    $0x10,%esp
  801361:	85 c0                	test   %eax,%eax
  801363:	78 5a                	js     8013bf <pgfault+0xb6>
		panic("pgfault: %e\n", r);
	}

	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  801365:	83 ec 04             	sub    $0x4,%esp
  801368:	68 00 10 00 00       	push   $0x1000
  80136d:	68 00 f0 7f 00       	push   $0x7ff000
  801372:	53                   	push   %ebx
  801373:	e8 45 fa ff ff       	call   800dbd <memmove>

	if ((r = sys_page_unmap(0, (void *) PFTEMP)) < 0) {
  801378:	83 c4 08             	add    $0x8,%esp
  80137b:	68 00 f0 7f 00       	push   $0x7ff000
  801380:	6a 00                	push   $0x0
  801382:	e8 4f fd ff ff       	call   8010d6 <sys_page_unmap>
  801387:	83 c4 10             	add    $0x10,%esp
  80138a:	85 c0                	test   %eax,%eax
  80138c:	78 46                	js     8013d4 <pgfault+0xcb>
		panic("pgfault: %e\n", r);
	}
}
  80138e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801391:	c9                   	leave  
  801392:	c3                   	ret    
        panic("pgfault: not copy-on-write\n");
  801393:	83 ec 04             	sub    $0x4,%esp
  801396:	68 ca 35 80 00       	push   $0x8035ca
  80139b:	68 d3 00 00 00       	push   $0xd3
  8013a0:	68 e6 35 80 00       	push   $0x8035e6
  8013a5:	e8 6c f1 ff ff       	call   800516 <_panic>
		panic("pgfault: %e\n", r);
  8013aa:	50                   	push   %eax
  8013ab:	68 f1 35 80 00       	push   $0x8035f1
  8013b0:	68 df 00 00 00       	push   $0xdf
  8013b5:	68 e6 35 80 00       	push   $0x8035e6
  8013ba:	e8 57 f1 ff ff       	call   800516 <_panic>
		panic("pgfault: %e\n", r);
  8013bf:	50                   	push   %eax
  8013c0:	68 f1 35 80 00       	push   $0x8035f1
  8013c5:	68 e3 00 00 00       	push   $0xe3
  8013ca:	68 e6 35 80 00       	push   $0x8035e6
  8013cf:	e8 42 f1 ff ff       	call   800516 <_panic>
		panic("pgfault: %e\n", r);
  8013d4:	50                   	push   %eax
  8013d5:	68 f1 35 80 00       	push   $0x8035f1
  8013da:	68 e9 00 00 00       	push   $0xe9
  8013df:	68 e6 35 80 00       	push   $0x8035e6
  8013e4:	e8 2d f1 ff ff       	call   800516 <_panic>

008013e9 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8013e9:	f3 0f 1e fb          	endbr32 
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	57                   	push   %edi
  8013f1:	56                   	push   %esi
  8013f2:	53                   	push   %ebx
  8013f3:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  8013f6:	68 09 13 80 00       	push   $0x801309
  8013fb:	e8 d0 18 00 00       	call   802cd0 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801400:	b8 07 00 00 00       	mov    $0x7,%eax
  801405:	cd 30                	int    $0x30
  801407:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0)
  80140a:	83 c4 10             	add    $0x10,%esp
  80140d:	85 c0                	test   %eax,%eax
  80140f:	78 2d                	js     80143e <fork+0x55>
  801411:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801413:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801418:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80141c:	0f 85 9b 00 00 00    	jne    8014bd <fork+0xd4>
		thisenv = &envs[ENVX(sys_getenvid())];
  801422:	e8 dc fb ff ff       	call   801003 <sys_getenvid>
  801427:	25 ff 03 00 00       	and    $0x3ff,%eax
  80142c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80142f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801434:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801439:	e9 71 01 00 00       	jmp    8015af <fork+0x1c6>
		panic("sys_exofork: %e", envid);
  80143e:	50                   	push   %eax
  80143f:	68 fe 35 80 00       	push   $0x8035fe
  801444:	68 2a 01 00 00       	push   $0x12a
  801449:	68 e6 35 80 00       	push   $0x8035e6
  80144e:	e8 c3 f0 ff ff       	call   800516 <_panic>
		sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_SYSCALL);
  801453:	c1 e6 0c             	shl    $0xc,%esi
  801456:	83 ec 0c             	sub    $0xc,%esp
  801459:	68 07 0e 00 00       	push   $0xe07
  80145e:	56                   	push   %esi
  80145f:	57                   	push   %edi
  801460:	56                   	push   %esi
  801461:	6a 00                	push   $0x0
  801463:	e8 28 fc ff ff       	call   801090 <sys_page_map>
  801468:	83 c4 20             	add    $0x20,%esp
  80146b:	eb 3e                	jmp    8014ab <fork+0xc2>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  80146d:	c1 e6 0c             	shl    $0xc,%esi
  801470:	83 ec 0c             	sub    $0xc,%esp
  801473:	68 05 08 00 00       	push   $0x805
  801478:	56                   	push   %esi
  801479:	57                   	push   %edi
  80147a:	56                   	push   %esi
  80147b:	6a 00                	push   $0x0
  80147d:	e8 0e fc ff ff       	call   801090 <sys_page_map>
  801482:	83 c4 20             	add    $0x20,%esp
  801485:	85 c0                	test   %eax,%eax
  801487:	0f 88 bc 00 00 00    	js     801549 <fork+0x160>
		if ((r = sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), perm)) < 0) {
  80148d:	83 ec 0c             	sub    $0xc,%esp
  801490:	68 05 08 00 00       	push   $0x805
  801495:	56                   	push   %esi
  801496:	6a 00                	push   $0x0
  801498:	56                   	push   %esi
  801499:	6a 00                	push   $0x0
  80149b:	e8 f0 fb ff ff       	call   801090 <sys_page_map>
  8014a0:	83 c4 20             	add    $0x20,%esp
  8014a3:	85 c0                	test   %eax,%eax
  8014a5:	0f 88 b3 00 00 00    	js     80155e <fork+0x175>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8014ab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014b1:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8014b7:	0f 84 b6 00 00 00    	je     801573 <fork+0x18a>
		// uvpd是有1024个pde的一维数组，而uvpt是有2^20个pte的一维数组,与物理页号刚好一一对应
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U)) {
  8014bd:	89 d8                	mov    %ebx,%eax
  8014bf:	c1 e8 16             	shr    $0x16,%eax
  8014c2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014c9:	a8 01                	test   $0x1,%al
  8014cb:	74 de                	je     8014ab <fork+0xc2>
  8014cd:	89 de                	mov    %ebx,%esi
  8014cf:	c1 ee 0c             	shr    $0xc,%esi
  8014d2:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8014d9:	a8 01                	test   $0x1,%al
  8014db:	74 ce                	je     8014ab <fork+0xc2>
  8014dd:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8014e4:	a8 04                	test   $0x4,%al
  8014e6:	74 c3                	je     8014ab <fork+0xc2>
	if ((uvpt[pn] & PTE_SHARE)){
  8014e8:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8014ef:	f6 c4 04             	test   $0x4,%ah
  8014f2:	0f 85 5b ff ff ff    	jne    801453 <fork+0x6a>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  8014f8:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8014ff:	a8 02                	test   $0x2,%al
  801501:	0f 85 66 ff ff ff    	jne    80146d <fork+0x84>
  801507:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80150e:	f6 c4 08             	test   $0x8,%ah
  801511:	0f 85 56 ff ff ff    	jne    80146d <fork+0x84>
	} else if ((r = sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), perm)) < 0) {
  801517:	c1 e6 0c             	shl    $0xc,%esi
  80151a:	83 ec 0c             	sub    $0xc,%esp
  80151d:	6a 05                	push   $0x5
  80151f:	56                   	push   %esi
  801520:	57                   	push   %edi
  801521:	56                   	push   %esi
  801522:	6a 00                	push   $0x0
  801524:	e8 67 fb ff ff       	call   801090 <sys_page_map>
  801529:	83 c4 20             	add    $0x20,%esp
  80152c:	85 c0                	test   %eax,%eax
  80152e:	0f 89 77 ff ff ff    	jns    8014ab <fork+0xc2>
		panic("duppage: %e\n", r);
  801534:	50                   	push   %eax
  801535:	68 0e 36 80 00       	push   $0x80360e
  80153a:	68 0c 01 00 00       	push   $0x10c
  80153f:	68 e6 35 80 00       	push   $0x8035e6
  801544:	e8 cd ef ff ff       	call   800516 <_panic>
			panic("duppage: %e\n", r);
  801549:	50                   	push   %eax
  80154a:	68 0e 36 80 00       	push   $0x80360e
  80154f:	68 05 01 00 00       	push   $0x105
  801554:	68 e6 35 80 00       	push   $0x8035e6
  801559:	e8 b8 ef ff ff       	call   800516 <_panic>
			panic("duppage: %e\n", r);
  80155e:	50                   	push   %eax
  80155f:	68 0e 36 80 00       	push   $0x80360e
  801564:	68 09 01 00 00       	push   $0x109
  801569:	68 e6 35 80 00       	push   $0x8035e6
  80156e:	e8 a3 ef ff ff       	call   800516 <_panic>
            duppage(envid, PGNUM(addr)); 
        }
	}

	int r;
	if ((r = sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0)
  801573:	83 ec 04             	sub    $0x4,%esp
  801576:	6a 07                	push   $0x7
  801578:	68 00 f0 bf ee       	push   $0xeebff000
  80157d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801580:	e8 c4 fa ff ff       	call   801049 <sys_page_alloc>
  801585:	83 c4 10             	add    $0x10,%esp
  801588:	85 c0                	test   %eax,%eax
  80158a:	78 2e                	js     8015ba <fork+0x1d1>
		panic("sys_page_alloc: %e", r);

	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80158c:	83 ec 08             	sub    $0x8,%esp
  80158f:	68 43 2d 80 00       	push   $0x802d43
  801594:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801597:	57                   	push   %edi
  801598:	e8 0b fc ff ff       	call   8011a8 <sys_env_set_pgfault_upcall>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80159d:	83 c4 08             	add    $0x8,%esp
  8015a0:	6a 02                	push   $0x2
  8015a2:	57                   	push   %edi
  8015a3:	e8 74 fb ff ff       	call   80111c <sys_env_set_status>
  8015a8:	83 c4 10             	add    $0x10,%esp
  8015ab:	85 c0                	test   %eax,%eax
  8015ad:	78 20                	js     8015cf <fork+0x1e6>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8015af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015b5:	5b                   	pop    %ebx
  8015b6:	5e                   	pop    %esi
  8015b7:	5f                   	pop    %edi
  8015b8:	5d                   	pop    %ebp
  8015b9:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8015ba:	50                   	push   %eax
  8015bb:	68 1b 36 80 00       	push   $0x80361b
  8015c0:	68 3e 01 00 00       	push   $0x13e
  8015c5:	68 e6 35 80 00       	push   $0x8035e6
  8015ca:	e8 47 ef ff ff       	call   800516 <_panic>
		panic("sys_env_set_status: %e", r);
  8015cf:	50                   	push   %eax
  8015d0:	68 2e 36 80 00       	push   $0x80362e
  8015d5:	68 43 01 00 00       	push   $0x143
  8015da:	68 e6 35 80 00       	push   $0x8035e6
  8015df:	e8 32 ef ff ff       	call   800516 <_panic>

008015e4 <sfork>:

// Challenge!
int
sfork(void)
{
  8015e4:	f3 0f 1e fb          	endbr32 
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8015ee:	68 45 36 80 00       	push   $0x803645
  8015f3:	68 4c 01 00 00       	push   $0x14c
  8015f8:	68 e6 35 80 00       	push   $0x8035e6
  8015fd:	e8 14 ef ff ff       	call   800516 <_panic>

00801602 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801602:	f3 0f 1e fb          	endbr32 
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	05 00 00 00 30       	add    $0x30000000,%eax
  801611:	c1 e8 0c             	shr    $0xc,%eax
}
  801614:	5d                   	pop    %ebp
  801615:	c3                   	ret    

00801616 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801616:	f3 0f 1e fb          	endbr32 
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801625:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80162a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80162f:	5d                   	pop    %ebp
  801630:	c3                   	ret    

00801631 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801631:	f3 0f 1e fb          	endbr32 
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80163d:	89 c2                	mov    %eax,%edx
  80163f:	c1 ea 16             	shr    $0x16,%edx
  801642:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801649:	f6 c2 01             	test   $0x1,%dl
  80164c:	74 2d                	je     80167b <fd_alloc+0x4a>
  80164e:	89 c2                	mov    %eax,%edx
  801650:	c1 ea 0c             	shr    $0xc,%edx
  801653:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80165a:	f6 c2 01             	test   $0x1,%dl
  80165d:	74 1c                	je     80167b <fd_alloc+0x4a>
  80165f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801664:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801669:	75 d2                	jne    80163d <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801674:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801679:	eb 0a                	jmp    801685 <fd_alloc+0x54>
			*fd_store = fd;
  80167b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80167e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801680:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801685:	5d                   	pop    %ebp
  801686:	c3                   	ret    

00801687 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801687:	f3 0f 1e fb          	endbr32 
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801691:	83 f8 1f             	cmp    $0x1f,%eax
  801694:	77 30                	ja     8016c6 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801696:	c1 e0 0c             	shl    $0xc,%eax
  801699:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80169e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8016a4:	f6 c2 01             	test   $0x1,%dl
  8016a7:	74 24                	je     8016cd <fd_lookup+0x46>
  8016a9:	89 c2                	mov    %eax,%edx
  8016ab:	c1 ea 0c             	shr    $0xc,%edx
  8016ae:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016b5:	f6 c2 01             	test   $0x1,%dl
  8016b8:	74 1a                	je     8016d4 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bd:	89 02                	mov    %eax,(%edx)
	return 0;
  8016bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c4:	5d                   	pop    %ebp
  8016c5:	c3                   	ret    
		return -E_INVAL;
  8016c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016cb:	eb f7                	jmp    8016c4 <fd_lookup+0x3d>
		return -E_INVAL;
  8016cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d2:	eb f0                	jmp    8016c4 <fd_lookup+0x3d>
  8016d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d9:	eb e9                	jmp    8016c4 <fd_lookup+0x3d>

008016db <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016db:	f3 0f 1e fb          	endbr32 
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	83 ec 08             	sub    $0x8,%esp
  8016e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8016e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ed:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  8016f2:	39 08                	cmp    %ecx,(%eax)
  8016f4:	74 38                	je     80172e <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8016f6:	83 c2 01             	add    $0x1,%edx
  8016f9:	8b 04 95 d8 36 80 00 	mov    0x8036d8(,%edx,4),%eax
  801700:	85 c0                	test   %eax,%eax
  801702:	75 ee                	jne    8016f2 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801704:	a1 08 50 80 00       	mov    0x805008,%eax
  801709:	8b 40 48             	mov    0x48(%eax),%eax
  80170c:	83 ec 04             	sub    $0x4,%esp
  80170f:	51                   	push   %ecx
  801710:	50                   	push   %eax
  801711:	68 5c 36 80 00       	push   $0x80365c
  801716:	e8 e2 ee ff ff       	call   8005fd <cprintf>
	*dev = 0;
  80171b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801724:	83 c4 10             	add    $0x10,%esp
  801727:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    
			*dev = devtab[i];
  80172e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801731:	89 01                	mov    %eax,(%ecx)
			return 0;
  801733:	b8 00 00 00 00       	mov    $0x0,%eax
  801738:	eb f2                	jmp    80172c <dev_lookup+0x51>

0080173a <fd_close>:
{
  80173a:	f3 0f 1e fb          	endbr32 
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	57                   	push   %edi
  801742:	56                   	push   %esi
  801743:	53                   	push   %ebx
  801744:	83 ec 24             	sub    $0x24,%esp
  801747:	8b 75 08             	mov    0x8(%ebp),%esi
  80174a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80174d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801750:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801751:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801757:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80175a:	50                   	push   %eax
  80175b:	e8 27 ff ff ff       	call   801687 <fd_lookup>
  801760:	89 c3                	mov    %eax,%ebx
  801762:	83 c4 10             	add    $0x10,%esp
  801765:	85 c0                	test   %eax,%eax
  801767:	78 05                	js     80176e <fd_close+0x34>
	    || fd != fd2)
  801769:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80176c:	74 16                	je     801784 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80176e:	89 f8                	mov    %edi,%eax
  801770:	84 c0                	test   %al,%al
  801772:	b8 00 00 00 00       	mov    $0x0,%eax
  801777:	0f 44 d8             	cmove  %eax,%ebx
}
  80177a:	89 d8                	mov    %ebx,%eax
  80177c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80177f:	5b                   	pop    %ebx
  801780:	5e                   	pop    %esi
  801781:	5f                   	pop    %edi
  801782:	5d                   	pop    %ebp
  801783:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801784:	83 ec 08             	sub    $0x8,%esp
  801787:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80178a:	50                   	push   %eax
  80178b:	ff 36                	pushl  (%esi)
  80178d:	e8 49 ff ff ff       	call   8016db <dev_lookup>
  801792:	89 c3                	mov    %eax,%ebx
  801794:	83 c4 10             	add    $0x10,%esp
  801797:	85 c0                	test   %eax,%eax
  801799:	78 1a                	js     8017b5 <fd_close+0x7b>
		if (dev->dev_close)
  80179b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80179e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8017a1:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8017a6:	85 c0                	test   %eax,%eax
  8017a8:	74 0b                	je     8017b5 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8017aa:	83 ec 0c             	sub    $0xc,%esp
  8017ad:	56                   	push   %esi
  8017ae:	ff d0                	call   *%eax
  8017b0:	89 c3                	mov    %eax,%ebx
  8017b2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8017b5:	83 ec 08             	sub    $0x8,%esp
  8017b8:	56                   	push   %esi
  8017b9:	6a 00                	push   $0x0
  8017bb:	e8 16 f9 ff ff       	call   8010d6 <sys_page_unmap>
	return r;
  8017c0:	83 c4 10             	add    $0x10,%esp
  8017c3:	eb b5                	jmp    80177a <fd_close+0x40>

008017c5 <close>:

int
close(int fdnum)
{
  8017c5:	f3 0f 1e fb          	endbr32 
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d2:	50                   	push   %eax
  8017d3:	ff 75 08             	pushl  0x8(%ebp)
  8017d6:	e8 ac fe ff ff       	call   801687 <fd_lookup>
  8017db:	83 c4 10             	add    $0x10,%esp
  8017de:	85 c0                	test   %eax,%eax
  8017e0:	79 02                	jns    8017e4 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    
		return fd_close(fd, 1);
  8017e4:	83 ec 08             	sub    $0x8,%esp
  8017e7:	6a 01                	push   $0x1
  8017e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ec:	e8 49 ff ff ff       	call   80173a <fd_close>
  8017f1:	83 c4 10             	add    $0x10,%esp
  8017f4:	eb ec                	jmp    8017e2 <close+0x1d>

008017f6 <close_all>:

void
close_all(void)
{
  8017f6:	f3 0f 1e fb          	endbr32 
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	53                   	push   %ebx
  8017fe:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801801:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801806:	83 ec 0c             	sub    $0xc,%esp
  801809:	53                   	push   %ebx
  80180a:	e8 b6 ff ff ff       	call   8017c5 <close>
	for (i = 0; i < MAXFD; i++)
  80180f:	83 c3 01             	add    $0x1,%ebx
  801812:	83 c4 10             	add    $0x10,%esp
  801815:	83 fb 20             	cmp    $0x20,%ebx
  801818:	75 ec                	jne    801806 <close_all+0x10>
}
  80181a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80181f:	f3 0f 1e fb          	endbr32 
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	57                   	push   %edi
  801827:	56                   	push   %esi
  801828:	53                   	push   %ebx
  801829:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80182c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80182f:	50                   	push   %eax
  801830:	ff 75 08             	pushl  0x8(%ebp)
  801833:	e8 4f fe ff ff       	call   801687 <fd_lookup>
  801838:	89 c3                	mov    %eax,%ebx
  80183a:	83 c4 10             	add    $0x10,%esp
  80183d:	85 c0                	test   %eax,%eax
  80183f:	0f 88 81 00 00 00    	js     8018c6 <dup+0xa7>
		return r;
	close(newfdnum);
  801845:	83 ec 0c             	sub    $0xc,%esp
  801848:	ff 75 0c             	pushl  0xc(%ebp)
  80184b:	e8 75 ff ff ff       	call   8017c5 <close>

	newfd = INDEX2FD(newfdnum);
  801850:	8b 75 0c             	mov    0xc(%ebp),%esi
  801853:	c1 e6 0c             	shl    $0xc,%esi
  801856:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80185c:	83 c4 04             	add    $0x4,%esp
  80185f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801862:	e8 af fd ff ff       	call   801616 <fd2data>
  801867:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801869:	89 34 24             	mov    %esi,(%esp)
  80186c:	e8 a5 fd ff ff       	call   801616 <fd2data>
  801871:	83 c4 10             	add    $0x10,%esp
  801874:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801876:	89 d8                	mov    %ebx,%eax
  801878:	c1 e8 16             	shr    $0x16,%eax
  80187b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801882:	a8 01                	test   $0x1,%al
  801884:	74 11                	je     801897 <dup+0x78>
  801886:	89 d8                	mov    %ebx,%eax
  801888:	c1 e8 0c             	shr    $0xc,%eax
  80188b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801892:	f6 c2 01             	test   $0x1,%dl
  801895:	75 39                	jne    8018d0 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801897:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80189a:	89 d0                	mov    %edx,%eax
  80189c:	c1 e8 0c             	shr    $0xc,%eax
  80189f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018a6:	83 ec 0c             	sub    $0xc,%esp
  8018a9:	25 07 0e 00 00       	and    $0xe07,%eax
  8018ae:	50                   	push   %eax
  8018af:	56                   	push   %esi
  8018b0:	6a 00                	push   $0x0
  8018b2:	52                   	push   %edx
  8018b3:	6a 00                	push   $0x0
  8018b5:	e8 d6 f7 ff ff       	call   801090 <sys_page_map>
  8018ba:	89 c3                	mov    %eax,%ebx
  8018bc:	83 c4 20             	add    $0x20,%esp
  8018bf:	85 c0                	test   %eax,%eax
  8018c1:	78 31                	js     8018f4 <dup+0xd5>
		goto err;

	return newfdnum;
  8018c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8018c6:	89 d8                	mov    %ebx,%eax
  8018c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018cb:	5b                   	pop    %ebx
  8018cc:	5e                   	pop    %esi
  8018cd:	5f                   	pop    %edi
  8018ce:	5d                   	pop    %ebp
  8018cf:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018d0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018d7:	83 ec 0c             	sub    $0xc,%esp
  8018da:	25 07 0e 00 00       	and    $0xe07,%eax
  8018df:	50                   	push   %eax
  8018e0:	57                   	push   %edi
  8018e1:	6a 00                	push   $0x0
  8018e3:	53                   	push   %ebx
  8018e4:	6a 00                	push   $0x0
  8018e6:	e8 a5 f7 ff ff       	call   801090 <sys_page_map>
  8018eb:	89 c3                	mov    %eax,%ebx
  8018ed:	83 c4 20             	add    $0x20,%esp
  8018f0:	85 c0                	test   %eax,%eax
  8018f2:	79 a3                	jns    801897 <dup+0x78>
	sys_page_unmap(0, newfd);
  8018f4:	83 ec 08             	sub    $0x8,%esp
  8018f7:	56                   	push   %esi
  8018f8:	6a 00                	push   $0x0
  8018fa:	e8 d7 f7 ff ff       	call   8010d6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018ff:	83 c4 08             	add    $0x8,%esp
  801902:	57                   	push   %edi
  801903:	6a 00                	push   $0x0
  801905:	e8 cc f7 ff ff       	call   8010d6 <sys_page_unmap>
	return r;
  80190a:	83 c4 10             	add    $0x10,%esp
  80190d:	eb b7                	jmp    8018c6 <dup+0xa7>

0080190f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80190f:	f3 0f 1e fb          	endbr32 
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	53                   	push   %ebx
  801917:	83 ec 1c             	sub    $0x1c,%esp
  80191a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80191d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801920:	50                   	push   %eax
  801921:	53                   	push   %ebx
  801922:	e8 60 fd ff ff       	call   801687 <fd_lookup>
  801927:	83 c4 10             	add    $0x10,%esp
  80192a:	85 c0                	test   %eax,%eax
  80192c:	78 3f                	js     80196d <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80192e:	83 ec 08             	sub    $0x8,%esp
  801931:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801934:	50                   	push   %eax
  801935:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801938:	ff 30                	pushl  (%eax)
  80193a:	e8 9c fd ff ff       	call   8016db <dev_lookup>
  80193f:	83 c4 10             	add    $0x10,%esp
  801942:	85 c0                	test   %eax,%eax
  801944:	78 27                	js     80196d <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801946:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801949:	8b 42 08             	mov    0x8(%edx),%eax
  80194c:	83 e0 03             	and    $0x3,%eax
  80194f:	83 f8 01             	cmp    $0x1,%eax
  801952:	74 1e                	je     801972 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801957:	8b 40 08             	mov    0x8(%eax),%eax
  80195a:	85 c0                	test   %eax,%eax
  80195c:	74 35                	je     801993 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80195e:	83 ec 04             	sub    $0x4,%esp
  801961:	ff 75 10             	pushl  0x10(%ebp)
  801964:	ff 75 0c             	pushl  0xc(%ebp)
  801967:	52                   	push   %edx
  801968:	ff d0                	call   *%eax
  80196a:	83 c4 10             	add    $0x10,%esp
}
  80196d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801970:	c9                   	leave  
  801971:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801972:	a1 08 50 80 00       	mov    0x805008,%eax
  801977:	8b 40 48             	mov    0x48(%eax),%eax
  80197a:	83 ec 04             	sub    $0x4,%esp
  80197d:	53                   	push   %ebx
  80197e:	50                   	push   %eax
  80197f:	68 9d 36 80 00       	push   $0x80369d
  801984:	e8 74 ec ff ff       	call   8005fd <cprintf>
		return -E_INVAL;
  801989:	83 c4 10             	add    $0x10,%esp
  80198c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801991:	eb da                	jmp    80196d <read+0x5e>
		return -E_NOT_SUPP;
  801993:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801998:	eb d3                	jmp    80196d <read+0x5e>

0080199a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80199a:	f3 0f 1e fb          	endbr32 
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
  8019a1:	57                   	push   %edi
  8019a2:	56                   	push   %esi
  8019a3:	53                   	push   %ebx
  8019a4:	83 ec 0c             	sub    $0xc,%esp
  8019a7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019aa:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019b2:	eb 02                	jmp    8019b6 <readn+0x1c>
  8019b4:	01 c3                	add    %eax,%ebx
  8019b6:	39 f3                	cmp    %esi,%ebx
  8019b8:	73 21                	jae    8019db <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019ba:	83 ec 04             	sub    $0x4,%esp
  8019bd:	89 f0                	mov    %esi,%eax
  8019bf:	29 d8                	sub    %ebx,%eax
  8019c1:	50                   	push   %eax
  8019c2:	89 d8                	mov    %ebx,%eax
  8019c4:	03 45 0c             	add    0xc(%ebp),%eax
  8019c7:	50                   	push   %eax
  8019c8:	57                   	push   %edi
  8019c9:	e8 41 ff ff ff       	call   80190f <read>
		if (m < 0)
  8019ce:	83 c4 10             	add    $0x10,%esp
  8019d1:	85 c0                	test   %eax,%eax
  8019d3:	78 04                	js     8019d9 <readn+0x3f>
			return m;
		if (m == 0)
  8019d5:	75 dd                	jne    8019b4 <readn+0x1a>
  8019d7:	eb 02                	jmp    8019db <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019d9:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8019db:	89 d8                	mov    %ebx,%eax
  8019dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019e0:	5b                   	pop    %ebx
  8019e1:	5e                   	pop    %esi
  8019e2:	5f                   	pop    %edi
  8019e3:	5d                   	pop    %ebp
  8019e4:	c3                   	ret    

008019e5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019e5:	f3 0f 1e fb          	endbr32 
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
  8019ec:	53                   	push   %ebx
  8019ed:	83 ec 1c             	sub    $0x1c,%esp
  8019f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019f6:	50                   	push   %eax
  8019f7:	53                   	push   %ebx
  8019f8:	e8 8a fc ff ff       	call   801687 <fd_lookup>
  8019fd:	83 c4 10             	add    $0x10,%esp
  801a00:	85 c0                	test   %eax,%eax
  801a02:	78 3a                	js     801a3e <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a04:	83 ec 08             	sub    $0x8,%esp
  801a07:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a0a:	50                   	push   %eax
  801a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a0e:	ff 30                	pushl  (%eax)
  801a10:	e8 c6 fc ff ff       	call   8016db <dev_lookup>
  801a15:	83 c4 10             	add    $0x10,%esp
  801a18:	85 c0                	test   %eax,%eax
  801a1a:	78 22                	js     801a3e <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a1f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a23:	74 1e                	je     801a43 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a28:	8b 52 0c             	mov    0xc(%edx),%edx
  801a2b:	85 d2                	test   %edx,%edx
  801a2d:	74 35                	je     801a64 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a2f:	83 ec 04             	sub    $0x4,%esp
  801a32:	ff 75 10             	pushl  0x10(%ebp)
  801a35:	ff 75 0c             	pushl  0xc(%ebp)
  801a38:	50                   	push   %eax
  801a39:	ff d2                	call   *%edx
  801a3b:	83 c4 10             	add    $0x10,%esp
}
  801a3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a43:	a1 08 50 80 00       	mov    0x805008,%eax
  801a48:	8b 40 48             	mov    0x48(%eax),%eax
  801a4b:	83 ec 04             	sub    $0x4,%esp
  801a4e:	53                   	push   %ebx
  801a4f:	50                   	push   %eax
  801a50:	68 b9 36 80 00       	push   $0x8036b9
  801a55:	e8 a3 eb ff ff       	call   8005fd <cprintf>
		return -E_INVAL;
  801a5a:	83 c4 10             	add    $0x10,%esp
  801a5d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a62:	eb da                	jmp    801a3e <write+0x59>
		return -E_NOT_SUPP;
  801a64:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a69:	eb d3                	jmp    801a3e <write+0x59>

00801a6b <seek>:

int
seek(int fdnum, off_t offset)
{
  801a6b:	f3 0f 1e fb          	endbr32 
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
  801a72:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a78:	50                   	push   %eax
  801a79:	ff 75 08             	pushl  0x8(%ebp)
  801a7c:	e8 06 fc ff ff       	call   801687 <fd_lookup>
  801a81:	83 c4 10             	add    $0x10,%esp
  801a84:	85 c0                	test   %eax,%eax
  801a86:	78 0e                	js     801a96 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801a88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a98:	f3 0f 1e fb          	endbr32 
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	53                   	push   %ebx
  801aa0:	83 ec 1c             	sub    $0x1c,%esp
  801aa3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aa6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aa9:	50                   	push   %eax
  801aaa:	53                   	push   %ebx
  801aab:	e8 d7 fb ff ff       	call   801687 <fd_lookup>
  801ab0:	83 c4 10             	add    $0x10,%esp
  801ab3:	85 c0                	test   %eax,%eax
  801ab5:	78 37                	js     801aee <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ab7:	83 ec 08             	sub    $0x8,%esp
  801aba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801abd:	50                   	push   %eax
  801abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac1:	ff 30                	pushl  (%eax)
  801ac3:	e8 13 fc ff ff       	call   8016db <dev_lookup>
  801ac8:	83 c4 10             	add    $0x10,%esp
  801acb:	85 c0                	test   %eax,%eax
  801acd:	78 1f                	js     801aee <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801acf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ad6:	74 1b                	je     801af3 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801ad8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801adb:	8b 52 18             	mov    0x18(%edx),%edx
  801ade:	85 d2                	test   %edx,%edx
  801ae0:	74 32                	je     801b14 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ae2:	83 ec 08             	sub    $0x8,%esp
  801ae5:	ff 75 0c             	pushl  0xc(%ebp)
  801ae8:	50                   	push   %eax
  801ae9:	ff d2                	call   *%edx
  801aeb:	83 c4 10             	add    $0x10,%esp
}
  801aee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    
			thisenv->env_id, fdnum);
  801af3:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801af8:	8b 40 48             	mov    0x48(%eax),%eax
  801afb:	83 ec 04             	sub    $0x4,%esp
  801afe:	53                   	push   %ebx
  801aff:	50                   	push   %eax
  801b00:	68 7c 36 80 00       	push   $0x80367c
  801b05:	e8 f3 ea ff ff       	call   8005fd <cprintf>
		return -E_INVAL;
  801b0a:	83 c4 10             	add    $0x10,%esp
  801b0d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b12:	eb da                	jmp    801aee <ftruncate+0x56>
		return -E_NOT_SUPP;
  801b14:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b19:	eb d3                	jmp    801aee <ftruncate+0x56>

00801b1b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b1b:	f3 0f 1e fb          	endbr32 
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	53                   	push   %ebx
  801b23:	83 ec 1c             	sub    $0x1c,%esp
  801b26:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b29:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b2c:	50                   	push   %eax
  801b2d:	ff 75 08             	pushl  0x8(%ebp)
  801b30:	e8 52 fb ff ff       	call   801687 <fd_lookup>
  801b35:	83 c4 10             	add    $0x10,%esp
  801b38:	85 c0                	test   %eax,%eax
  801b3a:	78 4b                	js     801b87 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b3c:	83 ec 08             	sub    $0x8,%esp
  801b3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b42:	50                   	push   %eax
  801b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b46:	ff 30                	pushl  (%eax)
  801b48:	e8 8e fb ff ff       	call   8016db <dev_lookup>
  801b4d:	83 c4 10             	add    $0x10,%esp
  801b50:	85 c0                	test   %eax,%eax
  801b52:	78 33                	js     801b87 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b57:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b5b:	74 2f                	je     801b8c <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b5d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b60:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b67:	00 00 00 
	stat->st_isdir = 0;
  801b6a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b71:	00 00 00 
	stat->st_dev = dev;
  801b74:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b7a:	83 ec 08             	sub    $0x8,%esp
  801b7d:	53                   	push   %ebx
  801b7e:	ff 75 f0             	pushl  -0x10(%ebp)
  801b81:	ff 50 14             	call   *0x14(%eax)
  801b84:	83 c4 10             	add    $0x10,%esp
}
  801b87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    
		return -E_NOT_SUPP;
  801b8c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b91:	eb f4                	jmp    801b87 <fstat+0x6c>

00801b93 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b93:	f3 0f 1e fb          	endbr32 
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	56                   	push   %esi
  801b9b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b9c:	83 ec 08             	sub    $0x8,%esp
  801b9f:	6a 00                	push   $0x0
  801ba1:	ff 75 08             	pushl  0x8(%ebp)
  801ba4:	e8 fb 01 00 00       	call   801da4 <open>
  801ba9:	89 c3                	mov    %eax,%ebx
  801bab:	83 c4 10             	add    $0x10,%esp
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	78 1b                	js     801bcd <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801bb2:	83 ec 08             	sub    $0x8,%esp
  801bb5:	ff 75 0c             	pushl  0xc(%ebp)
  801bb8:	50                   	push   %eax
  801bb9:	e8 5d ff ff ff       	call   801b1b <fstat>
  801bbe:	89 c6                	mov    %eax,%esi
	close(fd);
  801bc0:	89 1c 24             	mov    %ebx,(%esp)
  801bc3:	e8 fd fb ff ff       	call   8017c5 <close>
	return r;
  801bc8:	83 c4 10             	add    $0x10,%esp
  801bcb:	89 f3                	mov    %esi,%ebx
}
  801bcd:	89 d8                	mov    %ebx,%eax
  801bcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd2:	5b                   	pop    %ebx
  801bd3:	5e                   	pop    %esi
  801bd4:	5d                   	pop    %ebp
  801bd5:	c3                   	ret    

00801bd6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	56                   	push   %esi
  801bda:	53                   	push   %ebx
  801bdb:	89 c6                	mov    %eax,%esi
  801bdd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801bdf:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801be6:	74 27                	je     801c0f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801be8:	6a 07                	push   $0x7
  801bea:	68 00 60 80 00       	push   $0x806000
  801bef:	56                   	push   %esi
  801bf0:	ff 35 00 50 80 00    	pushl  0x805000
  801bf6:	e8 f3 11 00 00       	call   802dee <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bfb:	83 c4 0c             	add    $0xc,%esp
  801bfe:	6a 00                	push   $0x0
  801c00:	53                   	push   %ebx
  801c01:	6a 00                	push   $0x0
  801c03:	e8 61 11 00 00       	call   802d69 <ipc_recv>
}
  801c08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c0b:	5b                   	pop    %ebx
  801c0c:	5e                   	pop    %esi
  801c0d:	5d                   	pop    %ebp
  801c0e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c0f:	83 ec 0c             	sub    $0xc,%esp
  801c12:	6a 01                	push   $0x1
  801c14:	e8 2d 12 00 00       	call   802e46 <ipc_find_env>
  801c19:	a3 00 50 80 00       	mov    %eax,0x805000
  801c1e:	83 c4 10             	add    $0x10,%esp
  801c21:	eb c5                	jmp    801be8 <fsipc+0x12>

00801c23 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c23:	f3 0f 1e fb          	endbr32 
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
  801c2a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	8b 40 0c             	mov    0xc(%eax),%eax
  801c33:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3b:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c40:	ba 00 00 00 00       	mov    $0x0,%edx
  801c45:	b8 02 00 00 00       	mov    $0x2,%eax
  801c4a:	e8 87 ff ff ff       	call   801bd6 <fsipc>
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <devfile_flush>:
{
  801c51:	f3 0f 1e fb          	endbr32 
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	8b 40 0c             	mov    0xc(%eax),%eax
  801c61:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c66:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6b:	b8 06 00 00 00       	mov    $0x6,%eax
  801c70:	e8 61 ff ff ff       	call   801bd6 <fsipc>
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <devfile_stat>:
{
  801c77:	f3 0f 1e fb          	endbr32 
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	53                   	push   %ebx
  801c7f:	83 ec 04             	sub    $0x4,%esp
  801c82:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	8b 40 0c             	mov    0xc(%eax),%eax
  801c8b:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c90:	ba 00 00 00 00       	mov    $0x0,%edx
  801c95:	b8 05 00 00 00       	mov    $0x5,%eax
  801c9a:	e8 37 ff ff ff       	call   801bd6 <fsipc>
  801c9f:	85 c0                	test   %eax,%eax
  801ca1:	78 2c                	js     801ccf <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ca3:	83 ec 08             	sub    $0x8,%esp
  801ca6:	68 00 60 80 00       	push   $0x806000
  801cab:	53                   	push   %ebx
  801cac:	e8 56 ef ff ff       	call   800c07 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cb1:	a1 80 60 80 00       	mov    0x806080,%eax
  801cb6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cbc:	a1 84 60 80 00       	mov    0x806084,%eax
  801cc1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801cc7:	83 c4 10             	add    $0x10,%esp
  801cca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ccf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <devfile_write>:
{
  801cd4:	f3 0f 1e fb          	endbr32 
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
  801cdb:	83 ec 0c             	sub    $0xc,%esp
  801cde:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ce1:	8b 55 08             	mov    0x8(%ebp),%edx
  801ce4:	8b 52 0c             	mov    0xc(%edx),%edx
  801ce7:	89 15 00 60 80 00    	mov    %edx,0x806000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801ced:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801cf2:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801cf7:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801cfa:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801cff:	50                   	push   %eax
  801d00:	ff 75 0c             	pushl  0xc(%ebp)
  801d03:	68 08 60 80 00       	push   $0x806008
  801d08:	e8 b0 f0 ff ff       	call   800dbd <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801d0d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d12:	b8 04 00 00 00       	mov    $0x4,%eax
  801d17:	e8 ba fe ff ff       	call   801bd6 <fsipc>
}
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <devfile_read>:
{
  801d1e:	f3 0f 1e fb          	endbr32 
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
  801d25:	56                   	push   %esi
  801d26:	53                   	push   %ebx
  801d27:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801d30:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d35:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d3b:	ba 00 00 00 00       	mov    $0x0,%edx
  801d40:	b8 03 00 00 00       	mov    $0x3,%eax
  801d45:	e8 8c fe ff ff       	call   801bd6 <fsipc>
  801d4a:	89 c3                	mov    %eax,%ebx
  801d4c:	85 c0                	test   %eax,%eax
  801d4e:	78 1f                	js     801d6f <devfile_read+0x51>
	assert(r <= n);
  801d50:	39 f0                	cmp    %esi,%eax
  801d52:	77 24                	ja     801d78 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801d54:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d59:	7f 33                	jg     801d8e <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d5b:	83 ec 04             	sub    $0x4,%esp
  801d5e:	50                   	push   %eax
  801d5f:	68 00 60 80 00       	push   $0x806000
  801d64:	ff 75 0c             	pushl  0xc(%ebp)
  801d67:	e8 51 f0 ff ff       	call   800dbd <memmove>
	return r;
  801d6c:	83 c4 10             	add    $0x10,%esp
}
  801d6f:	89 d8                	mov    %ebx,%eax
  801d71:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d74:	5b                   	pop    %ebx
  801d75:	5e                   	pop    %esi
  801d76:	5d                   	pop    %ebp
  801d77:	c3                   	ret    
	assert(r <= n);
  801d78:	68 ec 36 80 00       	push   $0x8036ec
  801d7d:	68 f3 36 80 00       	push   $0x8036f3
  801d82:	6a 7c                	push   $0x7c
  801d84:	68 08 37 80 00       	push   $0x803708
  801d89:	e8 88 e7 ff ff       	call   800516 <_panic>
	assert(r <= PGSIZE);
  801d8e:	68 13 37 80 00       	push   $0x803713
  801d93:	68 f3 36 80 00       	push   $0x8036f3
  801d98:	6a 7d                	push   $0x7d
  801d9a:	68 08 37 80 00       	push   $0x803708
  801d9f:	e8 72 e7 ff ff       	call   800516 <_panic>

00801da4 <open>:
{
  801da4:	f3 0f 1e fb          	endbr32 
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	56                   	push   %esi
  801dac:	53                   	push   %ebx
  801dad:	83 ec 1c             	sub    $0x1c,%esp
  801db0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801db3:	56                   	push   %esi
  801db4:	e8 0b ee ff ff       	call   800bc4 <strlen>
  801db9:	83 c4 10             	add    $0x10,%esp
  801dbc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801dc1:	7f 6c                	jg     801e2f <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801dc3:	83 ec 0c             	sub    $0xc,%esp
  801dc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dc9:	50                   	push   %eax
  801dca:	e8 62 f8 ff ff       	call   801631 <fd_alloc>
  801dcf:	89 c3                	mov    %eax,%ebx
  801dd1:	83 c4 10             	add    $0x10,%esp
  801dd4:	85 c0                	test   %eax,%eax
  801dd6:	78 3c                	js     801e14 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801dd8:	83 ec 08             	sub    $0x8,%esp
  801ddb:	56                   	push   %esi
  801ddc:	68 00 60 80 00       	push   $0x806000
  801de1:	e8 21 ee ff ff       	call   800c07 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801de6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de9:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801dee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df1:	b8 01 00 00 00       	mov    $0x1,%eax
  801df6:	e8 db fd ff ff       	call   801bd6 <fsipc>
  801dfb:	89 c3                	mov    %eax,%ebx
  801dfd:	83 c4 10             	add    $0x10,%esp
  801e00:	85 c0                	test   %eax,%eax
  801e02:	78 19                	js     801e1d <open+0x79>
	return fd2num(fd);
  801e04:	83 ec 0c             	sub    $0xc,%esp
  801e07:	ff 75 f4             	pushl  -0xc(%ebp)
  801e0a:	e8 f3 f7 ff ff       	call   801602 <fd2num>
  801e0f:	89 c3                	mov    %eax,%ebx
  801e11:	83 c4 10             	add    $0x10,%esp
}
  801e14:	89 d8                	mov    %ebx,%eax
  801e16:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e19:	5b                   	pop    %ebx
  801e1a:	5e                   	pop    %esi
  801e1b:	5d                   	pop    %ebp
  801e1c:	c3                   	ret    
		fd_close(fd, 0);
  801e1d:	83 ec 08             	sub    $0x8,%esp
  801e20:	6a 00                	push   $0x0
  801e22:	ff 75 f4             	pushl  -0xc(%ebp)
  801e25:	e8 10 f9 ff ff       	call   80173a <fd_close>
		return r;
  801e2a:	83 c4 10             	add    $0x10,%esp
  801e2d:	eb e5                	jmp    801e14 <open+0x70>
		return -E_BAD_PATH;
  801e2f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e34:	eb de                	jmp    801e14 <open+0x70>

00801e36 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e36:	f3 0f 1e fb          	endbr32 
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e40:	ba 00 00 00 00       	mov    $0x0,%edx
  801e45:	b8 08 00 00 00       	mov    $0x8,%eax
  801e4a:	e8 87 fd ff ff       	call   801bd6 <fsipc>
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801e51:	f3 0f 1e fb          	endbr32 
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
  801e58:	57                   	push   %edi
  801e59:	56                   	push   %esi
  801e5a:	53                   	push   %ebx
  801e5b:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801e61:	6a 00                	push   $0x0
  801e63:	ff 75 08             	pushl  0x8(%ebp)
  801e66:	e8 39 ff ff ff       	call   801da4 <open>
  801e6b:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801e71:	83 c4 10             	add    $0x10,%esp
  801e74:	85 c0                	test   %eax,%eax
  801e76:	0f 88 e7 04 00 00    	js     802363 <spawn+0x512>
  801e7c:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801e7e:	83 ec 04             	sub    $0x4,%esp
  801e81:	68 00 02 00 00       	push   $0x200
  801e86:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801e8c:	50                   	push   %eax
  801e8d:	52                   	push   %edx
  801e8e:	e8 07 fb ff ff       	call   80199a <readn>
  801e93:	83 c4 10             	add    $0x10,%esp
  801e96:	3d 00 02 00 00       	cmp    $0x200,%eax
  801e9b:	75 7e                	jne    801f1b <spawn+0xca>
	    || elf->e_magic != ELF_MAGIC) {
  801e9d:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801ea4:	45 4c 46 
  801ea7:	75 72                	jne    801f1b <spawn+0xca>
  801ea9:	b8 07 00 00 00       	mov    $0x7,%eax
  801eae:	cd 30                	int    $0x30
  801eb0:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801eb6:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801ebc:	85 c0                	test   %eax,%eax
  801ebe:	0f 88 93 04 00 00    	js     802357 <spawn+0x506>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801ec4:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ec9:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801ecc:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801ed2:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801ed8:	b9 11 00 00 00       	mov    $0x11,%ecx
  801edd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801edf:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801ee5:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801eeb:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801ef0:	be 00 00 00 00       	mov    $0x0,%esi
  801ef5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801ef8:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  801eff:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801f02:	85 c0                	test   %eax,%eax
  801f04:	74 4d                	je     801f53 <spawn+0x102>
		string_size += strlen(argv[argc]) + 1;
  801f06:	83 ec 0c             	sub    $0xc,%esp
  801f09:	50                   	push   %eax
  801f0a:	e8 b5 ec ff ff       	call   800bc4 <strlen>
  801f0f:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801f13:	83 c3 01             	add    $0x1,%ebx
  801f16:	83 c4 10             	add    $0x10,%esp
  801f19:	eb dd                	jmp    801ef8 <spawn+0xa7>
		close(fd);
  801f1b:	83 ec 0c             	sub    $0xc,%esp
  801f1e:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801f24:	e8 9c f8 ff ff       	call   8017c5 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801f29:	83 c4 0c             	add    $0xc,%esp
  801f2c:	68 7f 45 4c 46       	push   $0x464c457f
  801f31:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801f37:	68 1f 37 80 00       	push   $0x80371f
  801f3c:	e8 bc e6 ff ff       	call   8005fd <cprintf>
		return -E_NOT_EXEC;
  801f41:	83 c4 10             	add    $0x10,%esp
  801f44:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801f4b:	ff ff ff 
  801f4e:	e9 10 04 00 00       	jmp    802363 <spawn+0x512>
  801f53:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801f59:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801f5f:	bf 00 10 40 00       	mov    $0x401000,%edi
  801f64:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801f66:	89 fa                	mov    %edi,%edx
  801f68:	83 e2 fc             	and    $0xfffffffc,%edx
  801f6b:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801f72:	29 c2                	sub    %eax,%edx
  801f74:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801f7a:	8d 42 f8             	lea    -0x8(%edx),%eax
  801f7d:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801f82:	0f 86 fe 03 00 00    	jbe    802386 <spawn+0x535>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801f88:	83 ec 04             	sub    $0x4,%esp
  801f8b:	6a 07                	push   $0x7
  801f8d:	68 00 00 40 00       	push   $0x400000
  801f92:	6a 00                	push   $0x0
  801f94:	e8 b0 f0 ff ff       	call   801049 <sys_page_alloc>
  801f99:	83 c4 10             	add    $0x10,%esp
  801f9c:	85 c0                	test   %eax,%eax
  801f9e:	0f 88 e7 03 00 00    	js     80238b <spawn+0x53a>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801fa4:	be 00 00 00 00       	mov    $0x0,%esi
  801fa9:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801faf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801fb2:	eb 30                	jmp    801fe4 <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  801fb4:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801fba:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801fc0:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801fc3:	83 ec 08             	sub    $0x8,%esp
  801fc6:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801fc9:	57                   	push   %edi
  801fca:	e8 38 ec ff ff       	call   800c07 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801fcf:	83 c4 04             	add    $0x4,%esp
  801fd2:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801fd5:	e8 ea eb ff ff       	call   800bc4 <strlen>
  801fda:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801fde:	83 c6 01             	add    $0x1,%esi
  801fe1:	83 c4 10             	add    $0x10,%esp
  801fe4:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801fea:	7f c8                	jg     801fb4 <spawn+0x163>
	}
	argv_store[argc] = 0;
  801fec:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801ff2:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801ff8:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801fff:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802005:	0f 85 86 00 00 00    	jne    802091 <spawn+0x240>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80200b:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  802011:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  802017:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  80201a:	89 c8                	mov    %ecx,%eax
  80201c:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  802022:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802025:	2d 08 30 80 11       	sub    $0x11803008,%eax
  80202a:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802030:	83 ec 0c             	sub    $0xc,%esp
  802033:	6a 07                	push   $0x7
  802035:	68 00 d0 bf ee       	push   $0xeebfd000
  80203a:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802040:	68 00 00 40 00       	push   $0x400000
  802045:	6a 00                	push   $0x0
  802047:	e8 44 f0 ff ff       	call   801090 <sys_page_map>
  80204c:	89 c3                	mov    %eax,%ebx
  80204e:	83 c4 20             	add    $0x20,%esp
  802051:	85 c0                	test   %eax,%eax
  802053:	0f 88 3a 03 00 00    	js     802393 <spawn+0x542>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802059:	83 ec 08             	sub    $0x8,%esp
  80205c:	68 00 00 40 00       	push   $0x400000
  802061:	6a 00                	push   $0x0
  802063:	e8 6e f0 ff ff       	call   8010d6 <sys_page_unmap>
  802068:	89 c3                	mov    %eax,%ebx
  80206a:	83 c4 10             	add    $0x10,%esp
  80206d:	85 c0                	test   %eax,%eax
  80206f:	0f 88 1e 03 00 00    	js     802393 <spawn+0x542>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802075:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  80207b:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802082:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  802089:	00 00 00 
  80208c:	e9 4f 01 00 00       	jmp    8021e0 <spawn+0x38f>
	assert(string_store == (char*)UTEMP + PGSIZE);
  802091:	68 7c 37 80 00       	push   $0x80377c
  802096:	68 f3 36 80 00       	push   $0x8036f3
  80209b:	68 f2 00 00 00       	push   $0xf2
  8020a0:	68 39 37 80 00       	push   $0x803739
  8020a5:	e8 6c e4 ff ff       	call   800516 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8020aa:	83 ec 04             	sub    $0x4,%esp
  8020ad:	6a 07                	push   $0x7
  8020af:	68 00 00 40 00       	push   $0x400000
  8020b4:	6a 00                	push   $0x0
  8020b6:	e8 8e ef ff ff       	call   801049 <sys_page_alloc>
  8020bb:	83 c4 10             	add    $0x10,%esp
  8020be:	85 c0                	test   %eax,%eax
  8020c0:	0f 88 ab 02 00 00    	js     802371 <spawn+0x520>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8020c6:	83 ec 08             	sub    $0x8,%esp
  8020c9:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8020cf:	01 f0                	add    %esi,%eax
  8020d1:	50                   	push   %eax
  8020d2:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8020d8:	e8 8e f9 ff ff       	call   801a6b <seek>
  8020dd:	83 c4 10             	add    $0x10,%esp
  8020e0:	85 c0                	test   %eax,%eax
  8020e2:	0f 88 90 02 00 00    	js     802378 <spawn+0x527>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8020e8:	83 ec 04             	sub    $0x4,%esp
  8020eb:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8020f1:	29 f0                	sub    %esi,%eax
  8020f3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8020f8:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8020fd:	0f 47 c1             	cmova  %ecx,%eax
  802100:	50                   	push   %eax
  802101:	68 00 00 40 00       	push   $0x400000
  802106:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80210c:	e8 89 f8 ff ff       	call   80199a <readn>
  802111:	83 c4 10             	add    $0x10,%esp
  802114:	85 c0                	test   %eax,%eax
  802116:	0f 88 63 02 00 00    	js     80237f <spawn+0x52e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80211c:	83 ec 0c             	sub    $0xc,%esp
  80211f:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802125:	53                   	push   %ebx
  802126:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  80212c:	68 00 00 40 00       	push   $0x400000
  802131:	6a 00                	push   $0x0
  802133:	e8 58 ef ff ff       	call   801090 <sys_page_map>
  802138:	83 c4 20             	add    $0x20,%esp
  80213b:	85 c0                	test   %eax,%eax
  80213d:	78 7c                	js     8021bb <spawn+0x36a>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  80213f:	83 ec 08             	sub    $0x8,%esp
  802142:	68 00 00 40 00       	push   $0x400000
  802147:	6a 00                	push   $0x0
  802149:	e8 88 ef ff ff       	call   8010d6 <sys_page_unmap>
  80214e:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  802151:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802157:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80215d:	89 fe                	mov    %edi,%esi
  80215f:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  802165:	76 69                	jbe    8021d0 <spawn+0x37f>
		if (i >= filesz) {
  802167:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  80216d:	0f 87 37 ff ff ff    	ja     8020aa <spawn+0x259>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802173:	83 ec 04             	sub    $0x4,%esp
  802176:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  80217c:	53                   	push   %ebx
  80217d:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802183:	e8 c1 ee ff ff       	call   801049 <sys_page_alloc>
  802188:	83 c4 10             	add    $0x10,%esp
  80218b:	85 c0                	test   %eax,%eax
  80218d:	79 c2                	jns    802151 <spawn+0x300>
  80218f:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802191:	83 ec 0c             	sub    $0xc,%esp
  802194:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80219a:	e8 1f ee ff ff       	call   800fbe <sys_env_destroy>
	close(fd);
  80219f:	83 c4 04             	add    $0x4,%esp
  8021a2:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8021a8:	e8 18 f6 ff ff       	call   8017c5 <close>
	return r;
  8021ad:	83 c4 10             	add    $0x10,%esp
  8021b0:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  8021b6:	e9 a8 01 00 00       	jmp    802363 <spawn+0x512>
				panic("spawn: sys_page_map data: %e", r);
  8021bb:	50                   	push   %eax
  8021bc:	68 45 37 80 00       	push   $0x803745
  8021c1:	68 25 01 00 00       	push   $0x125
  8021c6:	68 39 37 80 00       	push   $0x803739
  8021cb:	e8 46 e3 ff ff       	call   800516 <_panic>
  8021d0:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8021d6:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  8021dd:	83 c6 20             	add    $0x20,%esi
  8021e0:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8021e7:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  8021ed:	7e 6d                	jle    80225c <spawn+0x40b>
		if (ph->p_type != ELF_PROG_LOAD)
  8021ef:	83 3e 01             	cmpl   $0x1,(%esi)
  8021f2:	75 e2                	jne    8021d6 <spawn+0x385>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8021f4:	8b 46 18             	mov    0x18(%esi),%eax
  8021f7:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  8021fa:	83 f8 01             	cmp    $0x1,%eax
  8021fd:	19 c0                	sbb    %eax,%eax
  8021ff:	83 e0 fe             	and    $0xfffffffe,%eax
  802202:	83 c0 07             	add    $0x7,%eax
  802205:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80220b:	8b 4e 04             	mov    0x4(%esi),%ecx
  80220e:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802214:	8b 56 10             	mov    0x10(%esi),%edx
  802217:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  80221d:	8b 7e 14             	mov    0x14(%esi),%edi
  802220:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802226:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802229:	89 d8                	mov    %ebx,%eax
  80222b:	25 ff 0f 00 00       	and    $0xfff,%eax
  802230:	74 1a                	je     80224c <spawn+0x3fb>
		va -= i;
  802232:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802234:	01 c7                	add    %eax,%edi
  802236:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  80223c:	01 c2                	add    %eax,%edx
  80223e:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802244:	29 c1                	sub    %eax,%ecx
  802246:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  80224c:	bf 00 00 00 00       	mov    $0x0,%edi
  802251:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802257:	e9 01 ff ff ff       	jmp    80215d <spawn+0x30c>
	close(fd);
  80225c:	83 ec 0c             	sub    $0xc,%esp
  80225f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802265:	e8 5b f5 ff ff       	call   8017c5 <close>
  80226a:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  80226d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802272:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  802278:	eb 0e                	jmp    802288 <spawn+0x437>
  80227a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802280:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  802286:	74 5a                	je     8022e2 <spawn+0x491>
		if((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)){
  802288:	89 d8                	mov    %ebx,%eax
  80228a:	c1 e8 16             	shr    $0x16,%eax
  80228d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802294:	a8 01                	test   $0x1,%al
  802296:	74 e2                	je     80227a <spawn+0x429>
  802298:	89 d8                	mov    %ebx,%eax
  80229a:	c1 e8 0c             	shr    $0xc,%eax
  80229d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8022a4:	f6 c2 01             	test   $0x1,%dl
  8022a7:	74 d1                	je     80227a <spawn+0x429>
  8022a9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8022b0:	f6 c2 04             	test   $0x4,%dl
  8022b3:	74 c5                	je     80227a <spawn+0x429>
  8022b5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8022bc:	f6 c6 04             	test   $0x4,%dh
  8022bf:	74 b9                	je     80227a <spawn+0x429>
			if(r = sys_page_map(0, (void*)addr, child, (void*)addr, (uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8022c1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8022c8:	83 ec 0c             	sub    $0xc,%esp
  8022cb:	25 07 0e 00 00       	and    $0xe07,%eax
  8022d0:	50                   	push   %eax
  8022d1:	53                   	push   %ebx
  8022d2:	56                   	push   %esi
  8022d3:	53                   	push   %ebx
  8022d4:	6a 00                	push   $0x0
  8022d6:	e8 b5 ed ff ff       	call   801090 <sys_page_map>
  8022db:	83 c4 20             	add    $0x20,%esp
  8022de:	85 c0                	test   %eax,%eax
  8022e0:	79 98                	jns    80227a <spawn+0x429>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  8022e2:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  8022e9:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8022ec:	83 ec 08             	sub    $0x8,%esp
  8022ef:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8022f5:	50                   	push   %eax
  8022f6:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8022fc:	e8 61 ee ff ff       	call   801162 <sys_env_set_trapframe>
  802301:	83 c4 10             	add    $0x10,%esp
  802304:	85 c0                	test   %eax,%eax
  802306:	78 25                	js     80232d <spawn+0x4dc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802308:	83 ec 08             	sub    $0x8,%esp
  80230b:	6a 02                	push   $0x2
  80230d:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802313:	e8 04 ee ff ff       	call   80111c <sys_env_set_status>
  802318:	83 c4 10             	add    $0x10,%esp
  80231b:	85 c0                	test   %eax,%eax
  80231d:	78 23                	js     802342 <spawn+0x4f1>
	return child;
  80231f:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802325:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80232b:	eb 36                	jmp    802363 <spawn+0x512>
		panic("sys_env_set_trapframe: %e", r);
  80232d:	50                   	push   %eax
  80232e:	68 62 37 80 00       	push   $0x803762
  802333:	68 86 00 00 00       	push   $0x86
  802338:	68 39 37 80 00       	push   $0x803739
  80233d:	e8 d4 e1 ff ff       	call   800516 <_panic>
		panic("sys_env_set_status: %e", r);
  802342:	50                   	push   %eax
  802343:	68 2e 36 80 00       	push   $0x80362e
  802348:	68 89 00 00 00       	push   $0x89
  80234d:	68 39 37 80 00       	push   $0x803739
  802352:	e8 bf e1 ff ff       	call   800516 <_panic>
		return r;
  802357:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80235d:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802363:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802369:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80236c:	5b                   	pop    %ebx
  80236d:	5e                   	pop    %esi
  80236e:	5f                   	pop    %edi
  80236f:	5d                   	pop    %ebp
  802370:	c3                   	ret    
  802371:	89 c7                	mov    %eax,%edi
  802373:	e9 19 fe ff ff       	jmp    802191 <spawn+0x340>
  802378:	89 c7                	mov    %eax,%edi
  80237a:	e9 12 fe ff ff       	jmp    802191 <spawn+0x340>
  80237f:	89 c7                	mov    %eax,%edi
  802381:	e9 0b fe ff ff       	jmp    802191 <spawn+0x340>
		return -E_NO_MEM;
  802386:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  80238b:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802391:	eb d0                	jmp    802363 <spawn+0x512>
	sys_page_unmap(0, UTEMP);
  802393:	83 ec 08             	sub    $0x8,%esp
  802396:	68 00 00 40 00       	push   $0x400000
  80239b:	6a 00                	push   $0x0
  80239d:	e8 34 ed ff ff       	call   8010d6 <sys_page_unmap>
  8023a2:	83 c4 10             	add    $0x10,%esp
  8023a5:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  8023ab:	eb b6                	jmp    802363 <spawn+0x512>

008023ad <spawnl>:
{
  8023ad:	f3 0f 1e fb          	endbr32 
  8023b1:	55                   	push   %ebp
  8023b2:	89 e5                	mov    %esp,%ebp
  8023b4:	57                   	push   %edi
  8023b5:	56                   	push   %esi
  8023b6:	53                   	push   %ebx
  8023b7:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  8023ba:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  8023bd:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  8023c2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8023c5:	83 3a 00             	cmpl   $0x0,(%edx)
  8023c8:	74 07                	je     8023d1 <spawnl+0x24>
		argc++;
  8023ca:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  8023cd:	89 ca                	mov    %ecx,%edx
  8023cf:	eb f1                	jmp    8023c2 <spawnl+0x15>
	const char *argv[argc+2];
  8023d1:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  8023d8:	89 d1                	mov    %edx,%ecx
  8023da:	83 e1 f0             	and    $0xfffffff0,%ecx
  8023dd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8023e3:	89 e6                	mov    %esp,%esi
  8023e5:	29 d6                	sub    %edx,%esi
  8023e7:	89 f2                	mov    %esi,%edx
  8023e9:	39 d4                	cmp    %edx,%esp
  8023eb:	74 10                	je     8023fd <spawnl+0x50>
  8023ed:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  8023f3:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  8023fa:	00 
  8023fb:	eb ec                	jmp    8023e9 <spawnl+0x3c>
  8023fd:	89 ca                	mov    %ecx,%edx
  8023ff:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802405:	29 d4                	sub    %edx,%esp
  802407:	85 d2                	test   %edx,%edx
  802409:	74 05                	je     802410 <spawnl+0x63>
  80240b:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  802410:	8d 74 24 03          	lea    0x3(%esp),%esi
  802414:	89 f2                	mov    %esi,%edx
  802416:	c1 ea 02             	shr    $0x2,%edx
  802419:	83 e6 fc             	and    $0xfffffffc,%esi
  80241c:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80241e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802421:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802428:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  80242f:	00 
	va_start(vl, arg0);
  802430:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802433:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802435:	b8 00 00 00 00       	mov    $0x0,%eax
  80243a:	eb 0b                	jmp    802447 <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  80243c:	83 c0 01             	add    $0x1,%eax
  80243f:	8b 39                	mov    (%ecx),%edi
  802441:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802444:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802447:	39 d0                	cmp    %edx,%eax
  802449:	75 f1                	jne    80243c <spawnl+0x8f>
	return spawn(prog, argv);
  80244b:	83 ec 08             	sub    $0x8,%esp
  80244e:	56                   	push   %esi
  80244f:	ff 75 08             	pushl  0x8(%ebp)
  802452:	e8 fa f9 ff ff       	call   801e51 <spawn>
}
  802457:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80245a:	5b                   	pop    %ebx
  80245b:	5e                   	pop    %esi
  80245c:	5f                   	pop    %edi
  80245d:	5d                   	pop    %ebp
  80245e:	c3                   	ret    

0080245f <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80245f:	f3 0f 1e fb          	endbr32 
  802463:	55                   	push   %ebp
  802464:	89 e5                	mov    %esp,%ebp
  802466:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802469:	68 a2 37 80 00       	push   $0x8037a2
  80246e:	ff 75 0c             	pushl  0xc(%ebp)
  802471:	e8 91 e7 ff ff       	call   800c07 <strcpy>
	return 0;
}
  802476:	b8 00 00 00 00       	mov    $0x0,%eax
  80247b:	c9                   	leave  
  80247c:	c3                   	ret    

0080247d <devsock_close>:
{
  80247d:	f3 0f 1e fb          	endbr32 
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
  802484:	53                   	push   %ebx
  802485:	83 ec 10             	sub    $0x10,%esp
  802488:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80248b:	53                   	push   %ebx
  80248c:	e8 f2 09 00 00       	call   802e83 <pageref>
  802491:	89 c2                	mov    %eax,%edx
  802493:	83 c4 10             	add    $0x10,%esp
		return 0;
  802496:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  80249b:	83 fa 01             	cmp    $0x1,%edx
  80249e:	74 05                	je     8024a5 <devsock_close+0x28>
}
  8024a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024a3:	c9                   	leave  
  8024a4:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8024a5:	83 ec 0c             	sub    $0xc,%esp
  8024a8:	ff 73 0c             	pushl  0xc(%ebx)
  8024ab:	e8 e3 02 00 00       	call   802793 <nsipc_close>
  8024b0:	83 c4 10             	add    $0x10,%esp
  8024b3:	eb eb                	jmp    8024a0 <devsock_close+0x23>

008024b5 <devsock_write>:
{
  8024b5:	f3 0f 1e fb          	endbr32 
  8024b9:	55                   	push   %ebp
  8024ba:	89 e5                	mov    %esp,%ebp
  8024bc:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8024bf:	6a 00                	push   $0x0
  8024c1:	ff 75 10             	pushl  0x10(%ebp)
  8024c4:	ff 75 0c             	pushl  0xc(%ebp)
  8024c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ca:	ff 70 0c             	pushl  0xc(%eax)
  8024cd:	e8 b5 03 00 00       	call   802887 <nsipc_send>
}
  8024d2:	c9                   	leave  
  8024d3:	c3                   	ret    

008024d4 <devsock_read>:
{
  8024d4:	f3 0f 1e fb          	endbr32 
  8024d8:	55                   	push   %ebp
  8024d9:	89 e5                	mov    %esp,%ebp
  8024db:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8024de:	6a 00                	push   $0x0
  8024e0:	ff 75 10             	pushl  0x10(%ebp)
  8024e3:	ff 75 0c             	pushl  0xc(%ebp)
  8024e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e9:	ff 70 0c             	pushl  0xc(%eax)
  8024ec:	e8 1f 03 00 00       	call   802810 <nsipc_recv>
}
  8024f1:	c9                   	leave  
  8024f2:	c3                   	ret    

008024f3 <fd2sockid>:
{
  8024f3:	55                   	push   %ebp
  8024f4:	89 e5                	mov    %esp,%ebp
  8024f6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8024f9:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8024fc:	52                   	push   %edx
  8024fd:	50                   	push   %eax
  8024fe:	e8 84 f1 ff ff       	call   801687 <fd_lookup>
  802503:	83 c4 10             	add    $0x10,%esp
  802506:	85 c0                	test   %eax,%eax
  802508:	78 10                	js     80251a <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	8b 0d 3c 40 80 00    	mov    0x80403c,%ecx
  802513:	39 08                	cmp    %ecx,(%eax)
  802515:	75 05                	jne    80251c <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802517:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80251a:	c9                   	leave  
  80251b:	c3                   	ret    
		return -E_NOT_SUPP;
  80251c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802521:	eb f7                	jmp    80251a <fd2sockid+0x27>

00802523 <alloc_sockfd>:
{
  802523:	55                   	push   %ebp
  802524:	89 e5                	mov    %esp,%ebp
  802526:	56                   	push   %esi
  802527:	53                   	push   %ebx
  802528:	83 ec 1c             	sub    $0x1c,%esp
  80252b:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80252d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802530:	50                   	push   %eax
  802531:	e8 fb f0 ff ff       	call   801631 <fd_alloc>
  802536:	89 c3                	mov    %eax,%ebx
  802538:	83 c4 10             	add    $0x10,%esp
  80253b:	85 c0                	test   %eax,%eax
  80253d:	78 43                	js     802582 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80253f:	83 ec 04             	sub    $0x4,%esp
  802542:	68 07 04 00 00       	push   $0x407
  802547:	ff 75 f4             	pushl  -0xc(%ebp)
  80254a:	6a 00                	push   $0x0
  80254c:	e8 f8 ea ff ff       	call   801049 <sys_page_alloc>
  802551:	89 c3                	mov    %eax,%ebx
  802553:	83 c4 10             	add    $0x10,%esp
  802556:	85 c0                	test   %eax,%eax
  802558:	78 28                	js     802582 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802563:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802568:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80256f:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802572:	83 ec 0c             	sub    $0xc,%esp
  802575:	50                   	push   %eax
  802576:	e8 87 f0 ff ff       	call   801602 <fd2num>
  80257b:	89 c3                	mov    %eax,%ebx
  80257d:	83 c4 10             	add    $0x10,%esp
  802580:	eb 0c                	jmp    80258e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802582:	83 ec 0c             	sub    $0xc,%esp
  802585:	56                   	push   %esi
  802586:	e8 08 02 00 00       	call   802793 <nsipc_close>
		return r;
  80258b:	83 c4 10             	add    $0x10,%esp
}
  80258e:	89 d8                	mov    %ebx,%eax
  802590:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802593:	5b                   	pop    %ebx
  802594:	5e                   	pop    %esi
  802595:	5d                   	pop    %ebp
  802596:	c3                   	ret    

00802597 <accept>:
{
  802597:	f3 0f 1e fb          	endbr32 
  80259b:	55                   	push   %ebp
  80259c:	89 e5                	mov    %esp,%ebp
  80259e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8025a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a4:	e8 4a ff ff ff       	call   8024f3 <fd2sockid>
  8025a9:	85 c0                	test   %eax,%eax
  8025ab:	78 1b                	js     8025c8 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8025ad:	83 ec 04             	sub    $0x4,%esp
  8025b0:	ff 75 10             	pushl  0x10(%ebp)
  8025b3:	ff 75 0c             	pushl  0xc(%ebp)
  8025b6:	50                   	push   %eax
  8025b7:	e8 22 01 00 00       	call   8026de <nsipc_accept>
  8025bc:	83 c4 10             	add    $0x10,%esp
  8025bf:	85 c0                	test   %eax,%eax
  8025c1:	78 05                	js     8025c8 <accept+0x31>
	return alloc_sockfd(r);
  8025c3:	e8 5b ff ff ff       	call   802523 <alloc_sockfd>
}
  8025c8:	c9                   	leave  
  8025c9:	c3                   	ret    

008025ca <bind>:
{
  8025ca:	f3 0f 1e fb          	endbr32 
  8025ce:	55                   	push   %ebp
  8025cf:	89 e5                	mov    %esp,%ebp
  8025d1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8025d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d7:	e8 17 ff ff ff       	call   8024f3 <fd2sockid>
  8025dc:	85 c0                	test   %eax,%eax
  8025de:	78 12                	js     8025f2 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  8025e0:	83 ec 04             	sub    $0x4,%esp
  8025e3:	ff 75 10             	pushl  0x10(%ebp)
  8025e6:	ff 75 0c             	pushl  0xc(%ebp)
  8025e9:	50                   	push   %eax
  8025ea:	e8 45 01 00 00       	call   802734 <nsipc_bind>
  8025ef:	83 c4 10             	add    $0x10,%esp
}
  8025f2:	c9                   	leave  
  8025f3:	c3                   	ret    

008025f4 <shutdown>:
{
  8025f4:	f3 0f 1e fb          	endbr32 
  8025f8:	55                   	push   %ebp
  8025f9:	89 e5                	mov    %esp,%ebp
  8025fb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8025fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802601:	e8 ed fe ff ff       	call   8024f3 <fd2sockid>
  802606:	85 c0                	test   %eax,%eax
  802608:	78 0f                	js     802619 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  80260a:	83 ec 08             	sub    $0x8,%esp
  80260d:	ff 75 0c             	pushl  0xc(%ebp)
  802610:	50                   	push   %eax
  802611:	e8 57 01 00 00       	call   80276d <nsipc_shutdown>
  802616:	83 c4 10             	add    $0x10,%esp
}
  802619:	c9                   	leave  
  80261a:	c3                   	ret    

0080261b <connect>:
{
  80261b:	f3 0f 1e fb          	endbr32 
  80261f:	55                   	push   %ebp
  802620:	89 e5                	mov    %esp,%ebp
  802622:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802625:	8b 45 08             	mov    0x8(%ebp),%eax
  802628:	e8 c6 fe ff ff       	call   8024f3 <fd2sockid>
  80262d:	85 c0                	test   %eax,%eax
  80262f:	78 12                	js     802643 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  802631:	83 ec 04             	sub    $0x4,%esp
  802634:	ff 75 10             	pushl  0x10(%ebp)
  802637:	ff 75 0c             	pushl  0xc(%ebp)
  80263a:	50                   	push   %eax
  80263b:	e8 71 01 00 00       	call   8027b1 <nsipc_connect>
  802640:	83 c4 10             	add    $0x10,%esp
}
  802643:	c9                   	leave  
  802644:	c3                   	ret    

00802645 <listen>:
{
  802645:	f3 0f 1e fb          	endbr32 
  802649:	55                   	push   %ebp
  80264a:	89 e5                	mov    %esp,%ebp
  80264c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80264f:	8b 45 08             	mov    0x8(%ebp),%eax
  802652:	e8 9c fe ff ff       	call   8024f3 <fd2sockid>
  802657:	85 c0                	test   %eax,%eax
  802659:	78 0f                	js     80266a <listen+0x25>
	return nsipc_listen(r, backlog);
  80265b:	83 ec 08             	sub    $0x8,%esp
  80265e:	ff 75 0c             	pushl  0xc(%ebp)
  802661:	50                   	push   %eax
  802662:	e8 83 01 00 00       	call   8027ea <nsipc_listen>
  802667:	83 c4 10             	add    $0x10,%esp
}
  80266a:	c9                   	leave  
  80266b:	c3                   	ret    

0080266c <socket>:

int
socket(int domain, int type, int protocol)
{
  80266c:	f3 0f 1e fb          	endbr32 
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
  802673:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802676:	ff 75 10             	pushl  0x10(%ebp)
  802679:	ff 75 0c             	pushl  0xc(%ebp)
  80267c:	ff 75 08             	pushl  0x8(%ebp)
  80267f:	e8 65 02 00 00       	call   8028e9 <nsipc_socket>
  802684:	83 c4 10             	add    $0x10,%esp
  802687:	85 c0                	test   %eax,%eax
  802689:	78 05                	js     802690 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  80268b:	e8 93 fe ff ff       	call   802523 <alloc_sockfd>
}
  802690:	c9                   	leave  
  802691:	c3                   	ret    

00802692 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802692:	55                   	push   %ebp
  802693:	89 e5                	mov    %esp,%ebp
  802695:	53                   	push   %ebx
  802696:	83 ec 04             	sub    $0x4,%esp
  802699:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80269b:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8026a2:	74 26                	je     8026ca <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8026a4:	6a 07                	push   $0x7
  8026a6:	68 00 70 80 00       	push   $0x807000
  8026ab:	53                   	push   %ebx
  8026ac:	ff 35 04 50 80 00    	pushl  0x805004
  8026b2:	e8 37 07 00 00       	call   802dee <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8026b7:	83 c4 0c             	add    $0xc,%esp
  8026ba:	6a 00                	push   $0x0
  8026bc:	6a 00                	push   $0x0
  8026be:	6a 00                	push   $0x0
  8026c0:	e8 a4 06 00 00       	call   802d69 <ipc_recv>
}
  8026c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026c8:	c9                   	leave  
  8026c9:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8026ca:	83 ec 0c             	sub    $0xc,%esp
  8026cd:	6a 02                	push   $0x2
  8026cf:	e8 72 07 00 00       	call   802e46 <ipc_find_env>
  8026d4:	a3 04 50 80 00       	mov    %eax,0x805004
  8026d9:	83 c4 10             	add    $0x10,%esp
  8026dc:	eb c6                	jmp    8026a4 <nsipc+0x12>

008026de <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8026de:	f3 0f 1e fb          	endbr32 
  8026e2:	55                   	push   %ebp
  8026e3:	89 e5                	mov    %esp,%ebp
  8026e5:	56                   	push   %esi
  8026e6:	53                   	push   %ebx
  8026e7:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8026ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ed:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8026f2:	8b 06                	mov    (%esi),%eax
  8026f4:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8026f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8026fe:	e8 8f ff ff ff       	call   802692 <nsipc>
  802703:	89 c3                	mov    %eax,%ebx
  802705:	85 c0                	test   %eax,%eax
  802707:	79 09                	jns    802712 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802709:	89 d8                	mov    %ebx,%eax
  80270b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80270e:	5b                   	pop    %ebx
  80270f:	5e                   	pop    %esi
  802710:	5d                   	pop    %ebp
  802711:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802712:	83 ec 04             	sub    $0x4,%esp
  802715:	ff 35 10 70 80 00    	pushl  0x807010
  80271b:	68 00 70 80 00       	push   $0x807000
  802720:	ff 75 0c             	pushl  0xc(%ebp)
  802723:	e8 95 e6 ff ff       	call   800dbd <memmove>
		*addrlen = ret->ret_addrlen;
  802728:	a1 10 70 80 00       	mov    0x807010,%eax
  80272d:	89 06                	mov    %eax,(%esi)
  80272f:	83 c4 10             	add    $0x10,%esp
	return r;
  802732:	eb d5                	jmp    802709 <nsipc_accept+0x2b>

00802734 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802734:	f3 0f 1e fb          	endbr32 
  802738:	55                   	push   %ebp
  802739:	89 e5                	mov    %esp,%ebp
  80273b:	53                   	push   %ebx
  80273c:	83 ec 08             	sub    $0x8,%esp
  80273f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802742:	8b 45 08             	mov    0x8(%ebp),%eax
  802745:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80274a:	53                   	push   %ebx
  80274b:	ff 75 0c             	pushl  0xc(%ebp)
  80274e:	68 04 70 80 00       	push   $0x807004
  802753:	e8 65 e6 ff ff       	call   800dbd <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802758:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80275e:	b8 02 00 00 00       	mov    $0x2,%eax
  802763:	e8 2a ff ff ff       	call   802692 <nsipc>
}
  802768:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80276b:	c9                   	leave  
  80276c:	c3                   	ret    

0080276d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80276d:	f3 0f 1e fb          	endbr32 
  802771:	55                   	push   %ebp
  802772:	89 e5                	mov    %esp,%ebp
  802774:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802777:	8b 45 08             	mov    0x8(%ebp),%eax
  80277a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80277f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802782:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802787:	b8 03 00 00 00       	mov    $0x3,%eax
  80278c:	e8 01 ff ff ff       	call   802692 <nsipc>
}
  802791:	c9                   	leave  
  802792:	c3                   	ret    

00802793 <nsipc_close>:

int
nsipc_close(int s)
{
  802793:	f3 0f 1e fb          	endbr32 
  802797:	55                   	push   %ebp
  802798:	89 e5                	mov    %esp,%ebp
  80279a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80279d:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a0:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8027a5:	b8 04 00 00 00       	mov    $0x4,%eax
  8027aa:	e8 e3 fe ff ff       	call   802692 <nsipc>
}
  8027af:	c9                   	leave  
  8027b0:	c3                   	ret    

008027b1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8027b1:	f3 0f 1e fb          	endbr32 
  8027b5:	55                   	push   %ebp
  8027b6:	89 e5                	mov    %esp,%ebp
  8027b8:	53                   	push   %ebx
  8027b9:	83 ec 08             	sub    $0x8,%esp
  8027bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8027bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c2:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8027c7:	53                   	push   %ebx
  8027c8:	ff 75 0c             	pushl  0xc(%ebp)
  8027cb:	68 04 70 80 00       	push   $0x807004
  8027d0:	e8 e8 e5 ff ff       	call   800dbd <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8027d5:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8027db:	b8 05 00 00 00       	mov    $0x5,%eax
  8027e0:	e8 ad fe ff ff       	call   802692 <nsipc>
}
  8027e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027e8:	c9                   	leave  
  8027e9:	c3                   	ret    

008027ea <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8027ea:	f3 0f 1e fb          	endbr32 
  8027ee:	55                   	push   %ebp
  8027ef:	89 e5                	mov    %esp,%ebp
  8027f1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8027f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8027fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027ff:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802804:	b8 06 00 00 00       	mov    $0x6,%eax
  802809:	e8 84 fe ff ff       	call   802692 <nsipc>
}
  80280e:	c9                   	leave  
  80280f:	c3                   	ret    

00802810 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802810:	f3 0f 1e fb          	endbr32 
  802814:	55                   	push   %ebp
  802815:	89 e5                	mov    %esp,%ebp
  802817:	56                   	push   %esi
  802818:	53                   	push   %ebx
  802819:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80281c:	8b 45 08             	mov    0x8(%ebp),%eax
  80281f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802824:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80282a:	8b 45 14             	mov    0x14(%ebp),%eax
  80282d:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802832:	b8 07 00 00 00       	mov    $0x7,%eax
  802837:	e8 56 fe ff ff       	call   802692 <nsipc>
  80283c:	89 c3                	mov    %eax,%ebx
  80283e:	85 c0                	test   %eax,%eax
  802840:	78 26                	js     802868 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  802842:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  802848:	b8 3f 06 00 00       	mov    $0x63f,%eax
  80284d:	0f 4e c6             	cmovle %esi,%eax
  802850:	39 c3                	cmp    %eax,%ebx
  802852:	7f 1d                	jg     802871 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802854:	83 ec 04             	sub    $0x4,%esp
  802857:	53                   	push   %ebx
  802858:	68 00 70 80 00       	push   $0x807000
  80285d:	ff 75 0c             	pushl  0xc(%ebp)
  802860:	e8 58 e5 ff ff       	call   800dbd <memmove>
  802865:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802868:	89 d8                	mov    %ebx,%eax
  80286a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80286d:	5b                   	pop    %ebx
  80286e:	5e                   	pop    %esi
  80286f:	5d                   	pop    %ebp
  802870:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802871:	68 ae 37 80 00       	push   $0x8037ae
  802876:	68 f3 36 80 00       	push   $0x8036f3
  80287b:	6a 62                	push   $0x62
  80287d:	68 c3 37 80 00       	push   $0x8037c3
  802882:	e8 8f dc ff ff       	call   800516 <_panic>

00802887 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802887:	f3 0f 1e fb          	endbr32 
  80288b:	55                   	push   %ebp
  80288c:	89 e5                	mov    %esp,%ebp
  80288e:	53                   	push   %ebx
  80288f:	83 ec 04             	sub    $0x4,%esp
  802892:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802895:	8b 45 08             	mov    0x8(%ebp),%eax
  802898:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80289d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8028a3:	7f 2e                	jg     8028d3 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8028a5:	83 ec 04             	sub    $0x4,%esp
  8028a8:	53                   	push   %ebx
  8028a9:	ff 75 0c             	pushl  0xc(%ebp)
  8028ac:	68 0c 70 80 00       	push   $0x80700c
  8028b1:	e8 07 e5 ff ff       	call   800dbd <memmove>
	nsipcbuf.send.req_size = size;
  8028b6:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8028bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8028bf:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8028c4:	b8 08 00 00 00       	mov    $0x8,%eax
  8028c9:	e8 c4 fd ff ff       	call   802692 <nsipc>
}
  8028ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028d1:	c9                   	leave  
  8028d2:	c3                   	ret    
	assert(size < 1600);
  8028d3:	68 cf 37 80 00       	push   $0x8037cf
  8028d8:	68 f3 36 80 00       	push   $0x8036f3
  8028dd:	6a 6d                	push   $0x6d
  8028df:	68 c3 37 80 00       	push   $0x8037c3
  8028e4:	e8 2d dc ff ff       	call   800516 <_panic>

008028e9 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8028e9:	f3 0f 1e fb          	endbr32 
  8028ed:	55                   	push   %ebp
  8028ee:	89 e5                	mov    %esp,%ebp
  8028f0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8028f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f6:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8028fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028fe:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802903:	8b 45 10             	mov    0x10(%ebp),%eax
  802906:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80290b:	b8 09 00 00 00       	mov    $0x9,%eax
  802910:	e8 7d fd ff ff       	call   802692 <nsipc>
}
  802915:	c9                   	leave  
  802916:	c3                   	ret    

00802917 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802917:	f3 0f 1e fb          	endbr32 
  80291b:	55                   	push   %ebp
  80291c:	89 e5                	mov    %esp,%ebp
  80291e:	56                   	push   %esi
  80291f:	53                   	push   %ebx
  802920:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802923:	83 ec 0c             	sub    $0xc,%esp
  802926:	ff 75 08             	pushl  0x8(%ebp)
  802929:	e8 e8 ec ff ff       	call   801616 <fd2data>
  80292e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802930:	83 c4 08             	add    $0x8,%esp
  802933:	68 db 37 80 00       	push   $0x8037db
  802938:	53                   	push   %ebx
  802939:	e8 c9 e2 ff ff       	call   800c07 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80293e:	8b 46 04             	mov    0x4(%esi),%eax
  802941:	2b 06                	sub    (%esi),%eax
  802943:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802949:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802950:	00 00 00 
	stat->st_dev = &devpipe;
  802953:	c7 83 88 00 00 00 58 	movl   $0x804058,0x88(%ebx)
  80295a:	40 80 00 
	return 0;
}
  80295d:	b8 00 00 00 00       	mov    $0x0,%eax
  802962:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802965:	5b                   	pop    %ebx
  802966:	5e                   	pop    %esi
  802967:	5d                   	pop    %ebp
  802968:	c3                   	ret    

00802969 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802969:	f3 0f 1e fb          	endbr32 
  80296d:	55                   	push   %ebp
  80296e:	89 e5                	mov    %esp,%ebp
  802970:	53                   	push   %ebx
  802971:	83 ec 0c             	sub    $0xc,%esp
  802974:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802977:	53                   	push   %ebx
  802978:	6a 00                	push   $0x0
  80297a:	e8 57 e7 ff ff       	call   8010d6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80297f:	89 1c 24             	mov    %ebx,(%esp)
  802982:	e8 8f ec ff ff       	call   801616 <fd2data>
  802987:	83 c4 08             	add    $0x8,%esp
  80298a:	50                   	push   %eax
  80298b:	6a 00                	push   $0x0
  80298d:	e8 44 e7 ff ff       	call   8010d6 <sys_page_unmap>
}
  802992:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802995:	c9                   	leave  
  802996:	c3                   	ret    

00802997 <_pipeisclosed>:
{
  802997:	55                   	push   %ebp
  802998:	89 e5                	mov    %esp,%ebp
  80299a:	57                   	push   %edi
  80299b:	56                   	push   %esi
  80299c:	53                   	push   %ebx
  80299d:	83 ec 1c             	sub    $0x1c,%esp
  8029a0:	89 c7                	mov    %eax,%edi
  8029a2:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8029a4:	a1 08 50 80 00       	mov    0x805008,%eax
  8029a9:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8029ac:	83 ec 0c             	sub    $0xc,%esp
  8029af:	57                   	push   %edi
  8029b0:	e8 ce 04 00 00       	call   802e83 <pageref>
  8029b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8029b8:	89 34 24             	mov    %esi,(%esp)
  8029bb:	e8 c3 04 00 00       	call   802e83 <pageref>
		nn = thisenv->env_runs;
  8029c0:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8029c6:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8029c9:	83 c4 10             	add    $0x10,%esp
  8029cc:	39 cb                	cmp    %ecx,%ebx
  8029ce:	74 1b                	je     8029eb <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8029d0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8029d3:	75 cf                	jne    8029a4 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8029d5:	8b 42 58             	mov    0x58(%edx),%eax
  8029d8:	6a 01                	push   $0x1
  8029da:	50                   	push   %eax
  8029db:	53                   	push   %ebx
  8029dc:	68 e2 37 80 00       	push   $0x8037e2
  8029e1:	e8 17 dc ff ff       	call   8005fd <cprintf>
  8029e6:	83 c4 10             	add    $0x10,%esp
  8029e9:	eb b9                	jmp    8029a4 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8029eb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8029ee:	0f 94 c0             	sete   %al
  8029f1:	0f b6 c0             	movzbl %al,%eax
}
  8029f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029f7:	5b                   	pop    %ebx
  8029f8:	5e                   	pop    %esi
  8029f9:	5f                   	pop    %edi
  8029fa:	5d                   	pop    %ebp
  8029fb:	c3                   	ret    

008029fc <devpipe_write>:
{
  8029fc:	f3 0f 1e fb          	endbr32 
  802a00:	55                   	push   %ebp
  802a01:	89 e5                	mov    %esp,%ebp
  802a03:	57                   	push   %edi
  802a04:	56                   	push   %esi
  802a05:	53                   	push   %ebx
  802a06:	83 ec 28             	sub    $0x28,%esp
  802a09:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802a0c:	56                   	push   %esi
  802a0d:	e8 04 ec ff ff       	call   801616 <fd2data>
  802a12:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802a14:	83 c4 10             	add    $0x10,%esp
  802a17:	bf 00 00 00 00       	mov    $0x0,%edi
  802a1c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802a1f:	74 4f                	je     802a70 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802a21:	8b 43 04             	mov    0x4(%ebx),%eax
  802a24:	8b 0b                	mov    (%ebx),%ecx
  802a26:	8d 51 20             	lea    0x20(%ecx),%edx
  802a29:	39 d0                	cmp    %edx,%eax
  802a2b:	72 14                	jb     802a41 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802a2d:	89 da                	mov    %ebx,%edx
  802a2f:	89 f0                	mov    %esi,%eax
  802a31:	e8 61 ff ff ff       	call   802997 <_pipeisclosed>
  802a36:	85 c0                	test   %eax,%eax
  802a38:	75 3b                	jne    802a75 <devpipe_write+0x79>
			sys_yield();
  802a3a:	e8 e7 e5 ff ff       	call   801026 <sys_yield>
  802a3f:	eb e0                	jmp    802a21 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802a41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a44:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802a48:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802a4b:	89 c2                	mov    %eax,%edx
  802a4d:	c1 fa 1f             	sar    $0x1f,%edx
  802a50:	89 d1                	mov    %edx,%ecx
  802a52:	c1 e9 1b             	shr    $0x1b,%ecx
  802a55:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802a58:	83 e2 1f             	and    $0x1f,%edx
  802a5b:	29 ca                	sub    %ecx,%edx
  802a5d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802a61:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802a65:	83 c0 01             	add    $0x1,%eax
  802a68:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802a6b:	83 c7 01             	add    $0x1,%edi
  802a6e:	eb ac                	jmp    802a1c <devpipe_write+0x20>
	return i;
  802a70:	8b 45 10             	mov    0x10(%ebp),%eax
  802a73:	eb 05                	jmp    802a7a <devpipe_write+0x7e>
				return 0;
  802a75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a7d:	5b                   	pop    %ebx
  802a7e:	5e                   	pop    %esi
  802a7f:	5f                   	pop    %edi
  802a80:	5d                   	pop    %ebp
  802a81:	c3                   	ret    

00802a82 <devpipe_read>:
{
  802a82:	f3 0f 1e fb          	endbr32 
  802a86:	55                   	push   %ebp
  802a87:	89 e5                	mov    %esp,%ebp
  802a89:	57                   	push   %edi
  802a8a:	56                   	push   %esi
  802a8b:	53                   	push   %ebx
  802a8c:	83 ec 18             	sub    $0x18,%esp
  802a8f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802a92:	57                   	push   %edi
  802a93:	e8 7e eb ff ff       	call   801616 <fd2data>
  802a98:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802a9a:	83 c4 10             	add    $0x10,%esp
  802a9d:	be 00 00 00 00       	mov    $0x0,%esi
  802aa2:	3b 75 10             	cmp    0x10(%ebp),%esi
  802aa5:	75 14                	jne    802abb <devpipe_read+0x39>
	return i;
  802aa7:	8b 45 10             	mov    0x10(%ebp),%eax
  802aaa:	eb 02                	jmp    802aae <devpipe_read+0x2c>
				return i;
  802aac:	89 f0                	mov    %esi,%eax
}
  802aae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ab1:	5b                   	pop    %ebx
  802ab2:	5e                   	pop    %esi
  802ab3:	5f                   	pop    %edi
  802ab4:	5d                   	pop    %ebp
  802ab5:	c3                   	ret    
			sys_yield();
  802ab6:	e8 6b e5 ff ff       	call   801026 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802abb:	8b 03                	mov    (%ebx),%eax
  802abd:	3b 43 04             	cmp    0x4(%ebx),%eax
  802ac0:	75 18                	jne    802ada <devpipe_read+0x58>
			if (i > 0)
  802ac2:	85 f6                	test   %esi,%esi
  802ac4:	75 e6                	jne    802aac <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802ac6:	89 da                	mov    %ebx,%edx
  802ac8:	89 f8                	mov    %edi,%eax
  802aca:	e8 c8 fe ff ff       	call   802997 <_pipeisclosed>
  802acf:	85 c0                	test   %eax,%eax
  802ad1:	74 e3                	je     802ab6 <devpipe_read+0x34>
				return 0;
  802ad3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad8:	eb d4                	jmp    802aae <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802ada:	99                   	cltd   
  802adb:	c1 ea 1b             	shr    $0x1b,%edx
  802ade:	01 d0                	add    %edx,%eax
  802ae0:	83 e0 1f             	and    $0x1f,%eax
  802ae3:	29 d0                	sub    %edx,%eax
  802ae5:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802aea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802aed:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802af0:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802af3:	83 c6 01             	add    $0x1,%esi
  802af6:	eb aa                	jmp    802aa2 <devpipe_read+0x20>

00802af8 <pipe>:
{
  802af8:	f3 0f 1e fb          	endbr32 
  802afc:	55                   	push   %ebp
  802afd:	89 e5                	mov    %esp,%ebp
  802aff:	56                   	push   %esi
  802b00:	53                   	push   %ebx
  802b01:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802b04:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b07:	50                   	push   %eax
  802b08:	e8 24 eb ff ff       	call   801631 <fd_alloc>
  802b0d:	89 c3                	mov    %eax,%ebx
  802b0f:	83 c4 10             	add    $0x10,%esp
  802b12:	85 c0                	test   %eax,%eax
  802b14:	0f 88 23 01 00 00    	js     802c3d <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b1a:	83 ec 04             	sub    $0x4,%esp
  802b1d:	68 07 04 00 00       	push   $0x407
  802b22:	ff 75 f4             	pushl  -0xc(%ebp)
  802b25:	6a 00                	push   $0x0
  802b27:	e8 1d e5 ff ff       	call   801049 <sys_page_alloc>
  802b2c:	89 c3                	mov    %eax,%ebx
  802b2e:	83 c4 10             	add    $0x10,%esp
  802b31:	85 c0                	test   %eax,%eax
  802b33:	0f 88 04 01 00 00    	js     802c3d <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802b39:	83 ec 0c             	sub    $0xc,%esp
  802b3c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802b3f:	50                   	push   %eax
  802b40:	e8 ec ea ff ff       	call   801631 <fd_alloc>
  802b45:	89 c3                	mov    %eax,%ebx
  802b47:	83 c4 10             	add    $0x10,%esp
  802b4a:	85 c0                	test   %eax,%eax
  802b4c:	0f 88 db 00 00 00    	js     802c2d <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b52:	83 ec 04             	sub    $0x4,%esp
  802b55:	68 07 04 00 00       	push   $0x407
  802b5a:	ff 75 f0             	pushl  -0x10(%ebp)
  802b5d:	6a 00                	push   $0x0
  802b5f:	e8 e5 e4 ff ff       	call   801049 <sys_page_alloc>
  802b64:	89 c3                	mov    %eax,%ebx
  802b66:	83 c4 10             	add    $0x10,%esp
  802b69:	85 c0                	test   %eax,%eax
  802b6b:	0f 88 bc 00 00 00    	js     802c2d <pipe+0x135>
	va = fd2data(fd0);
  802b71:	83 ec 0c             	sub    $0xc,%esp
  802b74:	ff 75 f4             	pushl  -0xc(%ebp)
  802b77:	e8 9a ea ff ff       	call   801616 <fd2data>
  802b7c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b7e:	83 c4 0c             	add    $0xc,%esp
  802b81:	68 07 04 00 00       	push   $0x407
  802b86:	50                   	push   %eax
  802b87:	6a 00                	push   $0x0
  802b89:	e8 bb e4 ff ff       	call   801049 <sys_page_alloc>
  802b8e:	89 c3                	mov    %eax,%ebx
  802b90:	83 c4 10             	add    $0x10,%esp
  802b93:	85 c0                	test   %eax,%eax
  802b95:	0f 88 82 00 00 00    	js     802c1d <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b9b:	83 ec 0c             	sub    $0xc,%esp
  802b9e:	ff 75 f0             	pushl  -0x10(%ebp)
  802ba1:	e8 70 ea ff ff       	call   801616 <fd2data>
  802ba6:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802bad:	50                   	push   %eax
  802bae:	6a 00                	push   $0x0
  802bb0:	56                   	push   %esi
  802bb1:	6a 00                	push   $0x0
  802bb3:	e8 d8 e4 ff ff       	call   801090 <sys_page_map>
  802bb8:	89 c3                	mov    %eax,%ebx
  802bba:	83 c4 20             	add    $0x20,%esp
  802bbd:	85 c0                	test   %eax,%eax
  802bbf:	78 4e                	js     802c0f <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802bc1:	a1 58 40 80 00       	mov    0x804058,%eax
  802bc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc9:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802bcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bce:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802bd5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bd8:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802bda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802be4:	83 ec 0c             	sub    $0xc,%esp
  802be7:	ff 75 f4             	pushl  -0xc(%ebp)
  802bea:	e8 13 ea ff ff       	call   801602 <fd2num>
  802bef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bf2:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802bf4:	83 c4 04             	add    $0x4,%esp
  802bf7:	ff 75 f0             	pushl  -0x10(%ebp)
  802bfa:	e8 03 ea ff ff       	call   801602 <fd2num>
  802bff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c02:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802c05:	83 c4 10             	add    $0x10,%esp
  802c08:	bb 00 00 00 00       	mov    $0x0,%ebx
  802c0d:	eb 2e                	jmp    802c3d <pipe+0x145>
	sys_page_unmap(0, va);
  802c0f:	83 ec 08             	sub    $0x8,%esp
  802c12:	56                   	push   %esi
  802c13:	6a 00                	push   $0x0
  802c15:	e8 bc e4 ff ff       	call   8010d6 <sys_page_unmap>
  802c1a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802c1d:	83 ec 08             	sub    $0x8,%esp
  802c20:	ff 75 f0             	pushl  -0x10(%ebp)
  802c23:	6a 00                	push   $0x0
  802c25:	e8 ac e4 ff ff       	call   8010d6 <sys_page_unmap>
  802c2a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802c2d:	83 ec 08             	sub    $0x8,%esp
  802c30:	ff 75 f4             	pushl  -0xc(%ebp)
  802c33:	6a 00                	push   $0x0
  802c35:	e8 9c e4 ff ff       	call   8010d6 <sys_page_unmap>
  802c3a:	83 c4 10             	add    $0x10,%esp
}
  802c3d:	89 d8                	mov    %ebx,%eax
  802c3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c42:	5b                   	pop    %ebx
  802c43:	5e                   	pop    %esi
  802c44:	5d                   	pop    %ebp
  802c45:	c3                   	ret    

00802c46 <pipeisclosed>:
{
  802c46:	f3 0f 1e fb          	endbr32 
  802c4a:	55                   	push   %ebp
  802c4b:	89 e5                	mov    %esp,%ebp
  802c4d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c50:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c53:	50                   	push   %eax
  802c54:	ff 75 08             	pushl  0x8(%ebp)
  802c57:	e8 2b ea ff ff       	call   801687 <fd_lookup>
  802c5c:	83 c4 10             	add    $0x10,%esp
  802c5f:	85 c0                	test   %eax,%eax
  802c61:	78 18                	js     802c7b <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802c63:	83 ec 0c             	sub    $0xc,%esp
  802c66:	ff 75 f4             	pushl  -0xc(%ebp)
  802c69:	e8 a8 e9 ff ff       	call   801616 <fd2data>
  802c6e:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	e8 1f fd ff ff       	call   802997 <_pipeisclosed>
  802c78:	83 c4 10             	add    $0x10,%esp
}
  802c7b:	c9                   	leave  
  802c7c:	c3                   	ret    

00802c7d <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802c7d:	f3 0f 1e fb          	endbr32 
  802c81:	55                   	push   %ebp
  802c82:	89 e5                	mov    %esp,%ebp
  802c84:	56                   	push   %esi
  802c85:	53                   	push   %ebx
  802c86:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802c89:	85 f6                	test   %esi,%esi
  802c8b:	74 13                	je     802ca0 <wait+0x23>
	e = &envs[ENVX(envid)];
  802c8d:	89 f3                	mov    %esi,%ebx
  802c8f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802c95:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802c98:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802c9e:	eb 1b                	jmp    802cbb <wait+0x3e>
	assert(envid != 0);
  802ca0:	68 fa 37 80 00       	push   $0x8037fa
  802ca5:	68 f3 36 80 00       	push   $0x8036f3
  802caa:	6a 09                	push   $0x9
  802cac:	68 05 38 80 00       	push   $0x803805
  802cb1:	e8 60 d8 ff ff       	call   800516 <_panic>
		sys_yield();
  802cb6:	e8 6b e3 ff ff       	call   801026 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802cbb:	8b 43 48             	mov    0x48(%ebx),%eax
  802cbe:	39 f0                	cmp    %esi,%eax
  802cc0:	75 07                	jne    802cc9 <wait+0x4c>
  802cc2:	8b 43 54             	mov    0x54(%ebx),%eax
  802cc5:	85 c0                	test   %eax,%eax
  802cc7:	75 ed                	jne    802cb6 <wait+0x39>
}
  802cc9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ccc:	5b                   	pop    %ebx
  802ccd:	5e                   	pop    %esi
  802cce:	5d                   	pop    %ebp
  802ccf:	c3                   	ret    

00802cd0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802cd0:	f3 0f 1e fb          	endbr32 
  802cd4:	55                   	push   %ebp
  802cd5:	89 e5                	mov    %esp,%ebp
  802cd7:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802cda:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802ce1:	74 0a                	je     802ced <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce6:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802ceb:	c9                   	leave  
  802cec:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  802ced:	83 ec 04             	sub    $0x4,%esp
  802cf0:	6a 07                	push   $0x7
  802cf2:	68 00 f0 bf ee       	push   $0xeebff000
  802cf7:	6a 00                	push   $0x0
  802cf9:	e8 4b e3 ff ff       	call   801049 <sys_page_alloc>
  802cfe:	83 c4 10             	add    $0x10,%esp
  802d01:	85 c0                	test   %eax,%eax
  802d03:	78 2a                	js     802d2f <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  802d05:	83 ec 08             	sub    $0x8,%esp
  802d08:	68 43 2d 80 00       	push   $0x802d43
  802d0d:	6a 00                	push   $0x0
  802d0f:	e8 94 e4 ff ff       	call   8011a8 <sys_env_set_pgfault_upcall>
  802d14:	83 c4 10             	add    $0x10,%esp
  802d17:	85 c0                	test   %eax,%eax
  802d19:	79 c8                	jns    802ce3 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  802d1b:	83 ec 04             	sub    $0x4,%esp
  802d1e:	68 3c 38 80 00       	push   $0x80383c
  802d23:	6a 25                	push   $0x25
  802d25:	68 74 38 80 00       	push   $0x803874
  802d2a:	e8 e7 d7 ff ff       	call   800516 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  802d2f:	83 ec 04             	sub    $0x4,%esp
  802d32:	68 10 38 80 00       	push   $0x803810
  802d37:	6a 22                	push   $0x22
  802d39:	68 74 38 80 00       	push   $0x803874
  802d3e:	e8 d3 d7 ff ff       	call   800516 <_panic>

00802d43 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802d43:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802d44:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802d49:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802d4b:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  802d4e:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  802d52:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802d56:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802d59:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  802d5b:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  802d5f:	83 c4 08             	add    $0x8,%esp
	popal
  802d62:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  802d63:	83 c4 04             	add    $0x4,%esp
	popfl
  802d66:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  802d67:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  802d68:	c3                   	ret    

00802d69 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802d69:	f3 0f 1e fb          	endbr32 
  802d6d:	55                   	push   %ebp
  802d6e:	89 e5                	mov    %esp,%ebp
  802d70:	56                   	push   %esi
  802d71:	53                   	push   %ebx
  802d72:	8b 75 08             	mov    0x8(%ebp),%esi
  802d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d78:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  802d7b:	85 c0                	test   %eax,%eax
  802d7d:	74 3d                	je     802dbc <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  802d7f:	83 ec 0c             	sub    $0xc,%esp
  802d82:	50                   	push   %eax
  802d83:	e8 8d e4 ff ff       	call   801215 <sys_ipc_recv>
  802d88:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  802d8b:	85 f6                	test   %esi,%esi
  802d8d:	74 0b                	je     802d9a <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802d8f:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802d95:	8b 52 74             	mov    0x74(%edx),%edx
  802d98:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  802d9a:	85 db                	test   %ebx,%ebx
  802d9c:	74 0b                	je     802da9 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  802d9e:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802da4:	8b 52 78             	mov    0x78(%edx),%edx
  802da7:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  802da9:	85 c0                	test   %eax,%eax
  802dab:	78 21                	js     802dce <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  802dad:	a1 08 50 80 00       	mov    0x805008,%eax
  802db2:	8b 40 70             	mov    0x70(%eax),%eax
}
  802db5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802db8:	5b                   	pop    %ebx
  802db9:	5e                   	pop    %esi
  802dba:	5d                   	pop    %ebp
  802dbb:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802dbc:	83 ec 0c             	sub    $0xc,%esp
  802dbf:	68 00 00 c0 ee       	push   $0xeec00000
  802dc4:	e8 4c e4 ff ff       	call   801215 <sys_ipc_recv>
  802dc9:	83 c4 10             	add    $0x10,%esp
  802dcc:	eb bd                	jmp    802d8b <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802dce:	85 f6                	test   %esi,%esi
  802dd0:	74 10                	je     802de2 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802dd2:	85 db                	test   %ebx,%ebx
  802dd4:	75 df                	jne    802db5 <ipc_recv+0x4c>
  802dd6:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802ddd:	00 00 00 
  802de0:	eb d3                	jmp    802db5 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802de2:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802de9:	00 00 00 
  802dec:	eb e4                	jmp    802dd2 <ipc_recv+0x69>

00802dee <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802dee:	f3 0f 1e fb          	endbr32 
  802df2:	55                   	push   %ebp
  802df3:	89 e5                	mov    %esp,%ebp
  802df5:	57                   	push   %edi
  802df6:	56                   	push   %esi
  802df7:	53                   	push   %ebx
  802df8:	83 ec 0c             	sub    $0xc,%esp
  802dfb:	8b 7d 08             	mov    0x8(%ebp),%edi
  802dfe:	8b 75 0c             	mov    0xc(%ebp),%esi
  802e01:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802e04:	85 db                	test   %ebx,%ebx
  802e06:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802e0b:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802e0e:	ff 75 14             	pushl  0x14(%ebp)
  802e11:	53                   	push   %ebx
  802e12:	56                   	push   %esi
  802e13:	57                   	push   %edi
  802e14:	e8 d5 e3 ff ff       	call   8011ee <sys_ipc_try_send>
  802e19:	83 c4 10             	add    $0x10,%esp
  802e1c:	85 c0                	test   %eax,%eax
  802e1e:	79 1e                	jns    802e3e <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802e20:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802e23:	75 07                	jne    802e2c <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802e25:	e8 fc e1 ff ff       	call   801026 <sys_yield>
  802e2a:	eb e2                	jmp    802e0e <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802e2c:	50                   	push   %eax
  802e2d:	68 82 38 80 00       	push   $0x803882
  802e32:	6a 59                	push   $0x59
  802e34:	68 9d 38 80 00       	push   $0x80389d
  802e39:	e8 d8 d6 ff ff       	call   800516 <_panic>
	}
}
  802e3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802e41:	5b                   	pop    %ebx
  802e42:	5e                   	pop    %esi
  802e43:	5f                   	pop    %edi
  802e44:	5d                   	pop    %ebp
  802e45:	c3                   	ret    

00802e46 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802e46:	f3 0f 1e fb          	endbr32 
  802e4a:	55                   	push   %ebp
  802e4b:	89 e5                	mov    %esp,%ebp
  802e4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802e50:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802e55:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802e58:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802e5e:	8b 52 50             	mov    0x50(%edx),%edx
  802e61:	39 ca                	cmp    %ecx,%edx
  802e63:	74 11                	je     802e76 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802e65:	83 c0 01             	add    $0x1,%eax
  802e68:	3d 00 04 00 00       	cmp    $0x400,%eax
  802e6d:	75 e6                	jne    802e55 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802e6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e74:	eb 0b                	jmp    802e81 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802e76:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802e79:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802e7e:	8b 40 48             	mov    0x48(%eax),%eax
}
  802e81:	5d                   	pop    %ebp
  802e82:	c3                   	ret    

00802e83 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802e83:	f3 0f 1e fb          	endbr32 
  802e87:	55                   	push   %ebp
  802e88:	89 e5                	mov    %esp,%ebp
  802e8a:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802e8d:	89 c2                	mov    %eax,%edx
  802e8f:	c1 ea 16             	shr    $0x16,%edx
  802e92:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802e99:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802e9e:	f6 c1 01             	test   $0x1,%cl
  802ea1:	74 1c                	je     802ebf <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802ea3:	c1 e8 0c             	shr    $0xc,%eax
  802ea6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802ead:	a8 01                	test   $0x1,%al
  802eaf:	74 0e                	je     802ebf <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802eb1:	c1 e8 0c             	shr    $0xc,%eax
  802eb4:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802ebb:	ef 
  802ebc:	0f b7 d2             	movzwl %dx,%edx
}
  802ebf:	89 d0                	mov    %edx,%eax
  802ec1:	5d                   	pop    %ebp
  802ec2:	c3                   	ret    
  802ec3:	66 90                	xchg   %ax,%ax
  802ec5:	66 90                	xchg   %ax,%ax
  802ec7:	66 90                	xchg   %ax,%ax
  802ec9:	66 90                	xchg   %ax,%ax
  802ecb:	66 90                	xchg   %ax,%ax
  802ecd:	66 90                	xchg   %ax,%ax
  802ecf:	90                   	nop

00802ed0 <__udivdi3>:
  802ed0:	f3 0f 1e fb          	endbr32 
  802ed4:	55                   	push   %ebp
  802ed5:	57                   	push   %edi
  802ed6:	56                   	push   %esi
  802ed7:	53                   	push   %ebx
  802ed8:	83 ec 1c             	sub    $0x1c,%esp
  802edb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802edf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802ee3:	8b 74 24 34          	mov    0x34(%esp),%esi
  802ee7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802eeb:	85 d2                	test   %edx,%edx
  802eed:	75 19                	jne    802f08 <__udivdi3+0x38>
  802eef:	39 f3                	cmp    %esi,%ebx
  802ef1:	76 4d                	jbe    802f40 <__udivdi3+0x70>
  802ef3:	31 ff                	xor    %edi,%edi
  802ef5:	89 e8                	mov    %ebp,%eax
  802ef7:	89 f2                	mov    %esi,%edx
  802ef9:	f7 f3                	div    %ebx
  802efb:	89 fa                	mov    %edi,%edx
  802efd:	83 c4 1c             	add    $0x1c,%esp
  802f00:	5b                   	pop    %ebx
  802f01:	5e                   	pop    %esi
  802f02:	5f                   	pop    %edi
  802f03:	5d                   	pop    %ebp
  802f04:	c3                   	ret    
  802f05:	8d 76 00             	lea    0x0(%esi),%esi
  802f08:	39 f2                	cmp    %esi,%edx
  802f0a:	76 14                	jbe    802f20 <__udivdi3+0x50>
  802f0c:	31 ff                	xor    %edi,%edi
  802f0e:	31 c0                	xor    %eax,%eax
  802f10:	89 fa                	mov    %edi,%edx
  802f12:	83 c4 1c             	add    $0x1c,%esp
  802f15:	5b                   	pop    %ebx
  802f16:	5e                   	pop    %esi
  802f17:	5f                   	pop    %edi
  802f18:	5d                   	pop    %ebp
  802f19:	c3                   	ret    
  802f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802f20:	0f bd fa             	bsr    %edx,%edi
  802f23:	83 f7 1f             	xor    $0x1f,%edi
  802f26:	75 48                	jne    802f70 <__udivdi3+0xa0>
  802f28:	39 f2                	cmp    %esi,%edx
  802f2a:	72 06                	jb     802f32 <__udivdi3+0x62>
  802f2c:	31 c0                	xor    %eax,%eax
  802f2e:	39 eb                	cmp    %ebp,%ebx
  802f30:	77 de                	ja     802f10 <__udivdi3+0x40>
  802f32:	b8 01 00 00 00       	mov    $0x1,%eax
  802f37:	eb d7                	jmp    802f10 <__udivdi3+0x40>
  802f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802f40:	89 d9                	mov    %ebx,%ecx
  802f42:	85 db                	test   %ebx,%ebx
  802f44:	75 0b                	jne    802f51 <__udivdi3+0x81>
  802f46:	b8 01 00 00 00       	mov    $0x1,%eax
  802f4b:	31 d2                	xor    %edx,%edx
  802f4d:	f7 f3                	div    %ebx
  802f4f:	89 c1                	mov    %eax,%ecx
  802f51:	31 d2                	xor    %edx,%edx
  802f53:	89 f0                	mov    %esi,%eax
  802f55:	f7 f1                	div    %ecx
  802f57:	89 c6                	mov    %eax,%esi
  802f59:	89 e8                	mov    %ebp,%eax
  802f5b:	89 f7                	mov    %esi,%edi
  802f5d:	f7 f1                	div    %ecx
  802f5f:	89 fa                	mov    %edi,%edx
  802f61:	83 c4 1c             	add    $0x1c,%esp
  802f64:	5b                   	pop    %ebx
  802f65:	5e                   	pop    %esi
  802f66:	5f                   	pop    %edi
  802f67:	5d                   	pop    %ebp
  802f68:	c3                   	ret    
  802f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802f70:	89 f9                	mov    %edi,%ecx
  802f72:	b8 20 00 00 00       	mov    $0x20,%eax
  802f77:	29 f8                	sub    %edi,%eax
  802f79:	d3 e2                	shl    %cl,%edx
  802f7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802f7f:	89 c1                	mov    %eax,%ecx
  802f81:	89 da                	mov    %ebx,%edx
  802f83:	d3 ea                	shr    %cl,%edx
  802f85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802f89:	09 d1                	or     %edx,%ecx
  802f8b:	89 f2                	mov    %esi,%edx
  802f8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f91:	89 f9                	mov    %edi,%ecx
  802f93:	d3 e3                	shl    %cl,%ebx
  802f95:	89 c1                	mov    %eax,%ecx
  802f97:	d3 ea                	shr    %cl,%edx
  802f99:	89 f9                	mov    %edi,%ecx
  802f9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802f9f:	89 eb                	mov    %ebp,%ebx
  802fa1:	d3 e6                	shl    %cl,%esi
  802fa3:	89 c1                	mov    %eax,%ecx
  802fa5:	d3 eb                	shr    %cl,%ebx
  802fa7:	09 de                	or     %ebx,%esi
  802fa9:	89 f0                	mov    %esi,%eax
  802fab:	f7 74 24 08          	divl   0x8(%esp)
  802faf:	89 d6                	mov    %edx,%esi
  802fb1:	89 c3                	mov    %eax,%ebx
  802fb3:	f7 64 24 0c          	mull   0xc(%esp)
  802fb7:	39 d6                	cmp    %edx,%esi
  802fb9:	72 15                	jb     802fd0 <__udivdi3+0x100>
  802fbb:	89 f9                	mov    %edi,%ecx
  802fbd:	d3 e5                	shl    %cl,%ebp
  802fbf:	39 c5                	cmp    %eax,%ebp
  802fc1:	73 04                	jae    802fc7 <__udivdi3+0xf7>
  802fc3:	39 d6                	cmp    %edx,%esi
  802fc5:	74 09                	je     802fd0 <__udivdi3+0x100>
  802fc7:	89 d8                	mov    %ebx,%eax
  802fc9:	31 ff                	xor    %edi,%edi
  802fcb:	e9 40 ff ff ff       	jmp    802f10 <__udivdi3+0x40>
  802fd0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802fd3:	31 ff                	xor    %edi,%edi
  802fd5:	e9 36 ff ff ff       	jmp    802f10 <__udivdi3+0x40>
  802fda:	66 90                	xchg   %ax,%ax
  802fdc:	66 90                	xchg   %ax,%ax
  802fde:	66 90                	xchg   %ax,%ax

00802fe0 <__umoddi3>:
  802fe0:	f3 0f 1e fb          	endbr32 
  802fe4:	55                   	push   %ebp
  802fe5:	57                   	push   %edi
  802fe6:	56                   	push   %esi
  802fe7:	53                   	push   %ebx
  802fe8:	83 ec 1c             	sub    $0x1c,%esp
  802feb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802fef:	8b 74 24 30          	mov    0x30(%esp),%esi
  802ff3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802ff7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ffb:	85 c0                	test   %eax,%eax
  802ffd:	75 19                	jne    803018 <__umoddi3+0x38>
  802fff:	39 df                	cmp    %ebx,%edi
  803001:	76 5d                	jbe    803060 <__umoddi3+0x80>
  803003:	89 f0                	mov    %esi,%eax
  803005:	89 da                	mov    %ebx,%edx
  803007:	f7 f7                	div    %edi
  803009:	89 d0                	mov    %edx,%eax
  80300b:	31 d2                	xor    %edx,%edx
  80300d:	83 c4 1c             	add    $0x1c,%esp
  803010:	5b                   	pop    %ebx
  803011:	5e                   	pop    %esi
  803012:	5f                   	pop    %edi
  803013:	5d                   	pop    %ebp
  803014:	c3                   	ret    
  803015:	8d 76 00             	lea    0x0(%esi),%esi
  803018:	89 f2                	mov    %esi,%edx
  80301a:	39 d8                	cmp    %ebx,%eax
  80301c:	76 12                	jbe    803030 <__umoddi3+0x50>
  80301e:	89 f0                	mov    %esi,%eax
  803020:	89 da                	mov    %ebx,%edx
  803022:	83 c4 1c             	add    $0x1c,%esp
  803025:	5b                   	pop    %ebx
  803026:	5e                   	pop    %esi
  803027:	5f                   	pop    %edi
  803028:	5d                   	pop    %ebp
  803029:	c3                   	ret    
  80302a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803030:	0f bd e8             	bsr    %eax,%ebp
  803033:	83 f5 1f             	xor    $0x1f,%ebp
  803036:	75 50                	jne    803088 <__umoddi3+0xa8>
  803038:	39 d8                	cmp    %ebx,%eax
  80303a:	0f 82 e0 00 00 00    	jb     803120 <__umoddi3+0x140>
  803040:	89 d9                	mov    %ebx,%ecx
  803042:	39 f7                	cmp    %esi,%edi
  803044:	0f 86 d6 00 00 00    	jbe    803120 <__umoddi3+0x140>
  80304a:	89 d0                	mov    %edx,%eax
  80304c:	89 ca                	mov    %ecx,%edx
  80304e:	83 c4 1c             	add    $0x1c,%esp
  803051:	5b                   	pop    %ebx
  803052:	5e                   	pop    %esi
  803053:	5f                   	pop    %edi
  803054:	5d                   	pop    %ebp
  803055:	c3                   	ret    
  803056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80305d:	8d 76 00             	lea    0x0(%esi),%esi
  803060:	89 fd                	mov    %edi,%ebp
  803062:	85 ff                	test   %edi,%edi
  803064:	75 0b                	jne    803071 <__umoddi3+0x91>
  803066:	b8 01 00 00 00       	mov    $0x1,%eax
  80306b:	31 d2                	xor    %edx,%edx
  80306d:	f7 f7                	div    %edi
  80306f:	89 c5                	mov    %eax,%ebp
  803071:	89 d8                	mov    %ebx,%eax
  803073:	31 d2                	xor    %edx,%edx
  803075:	f7 f5                	div    %ebp
  803077:	89 f0                	mov    %esi,%eax
  803079:	f7 f5                	div    %ebp
  80307b:	89 d0                	mov    %edx,%eax
  80307d:	31 d2                	xor    %edx,%edx
  80307f:	eb 8c                	jmp    80300d <__umoddi3+0x2d>
  803081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803088:	89 e9                	mov    %ebp,%ecx
  80308a:	ba 20 00 00 00       	mov    $0x20,%edx
  80308f:	29 ea                	sub    %ebp,%edx
  803091:	d3 e0                	shl    %cl,%eax
  803093:	89 44 24 08          	mov    %eax,0x8(%esp)
  803097:	89 d1                	mov    %edx,%ecx
  803099:	89 f8                	mov    %edi,%eax
  80309b:	d3 e8                	shr    %cl,%eax
  80309d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8030a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8030a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8030a9:	09 c1                	or     %eax,%ecx
  8030ab:	89 d8                	mov    %ebx,%eax
  8030ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030b1:	89 e9                	mov    %ebp,%ecx
  8030b3:	d3 e7                	shl    %cl,%edi
  8030b5:	89 d1                	mov    %edx,%ecx
  8030b7:	d3 e8                	shr    %cl,%eax
  8030b9:	89 e9                	mov    %ebp,%ecx
  8030bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030bf:	d3 e3                	shl    %cl,%ebx
  8030c1:	89 c7                	mov    %eax,%edi
  8030c3:	89 d1                	mov    %edx,%ecx
  8030c5:	89 f0                	mov    %esi,%eax
  8030c7:	d3 e8                	shr    %cl,%eax
  8030c9:	89 e9                	mov    %ebp,%ecx
  8030cb:	89 fa                	mov    %edi,%edx
  8030cd:	d3 e6                	shl    %cl,%esi
  8030cf:	09 d8                	or     %ebx,%eax
  8030d1:	f7 74 24 08          	divl   0x8(%esp)
  8030d5:	89 d1                	mov    %edx,%ecx
  8030d7:	89 f3                	mov    %esi,%ebx
  8030d9:	f7 64 24 0c          	mull   0xc(%esp)
  8030dd:	89 c6                	mov    %eax,%esi
  8030df:	89 d7                	mov    %edx,%edi
  8030e1:	39 d1                	cmp    %edx,%ecx
  8030e3:	72 06                	jb     8030eb <__umoddi3+0x10b>
  8030e5:	75 10                	jne    8030f7 <__umoddi3+0x117>
  8030e7:	39 c3                	cmp    %eax,%ebx
  8030e9:	73 0c                	jae    8030f7 <__umoddi3+0x117>
  8030eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8030ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8030f3:	89 d7                	mov    %edx,%edi
  8030f5:	89 c6                	mov    %eax,%esi
  8030f7:	89 ca                	mov    %ecx,%edx
  8030f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8030fe:	29 f3                	sub    %esi,%ebx
  803100:	19 fa                	sbb    %edi,%edx
  803102:	89 d0                	mov    %edx,%eax
  803104:	d3 e0                	shl    %cl,%eax
  803106:	89 e9                	mov    %ebp,%ecx
  803108:	d3 eb                	shr    %cl,%ebx
  80310a:	d3 ea                	shr    %cl,%edx
  80310c:	09 d8                	or     %ebx,%eax
  80310e:	83 c4 1c             	add    $0x1c,%esp
  803111:	5b                   	pop    %ebx
  803112:	5e                   	pop    %esi
  803113:	5f                   	pop    %edi
  803114:	5d                   	pop    %ebp
  803115:	c3                   	ret    
  803116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80311d:	8d 76 00             	lea    0x0(%esi),%esi
  803120:	29 fe                	sub    %edi,%esi
  803122:	19 c3                	sbb    %eax,%ebx
  803124:	89 f2                	mov    %esi,%edx
  803126:	89 d9                	mov    %ebx,%ecx
  803128:	e9 1d ff ff ff       	jmp    80304a <__umoddi3+0x6a>
