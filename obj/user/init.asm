
obj/user/init.debug:     file format elf32-i386


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
  80002c:	e8 8f 03 00 00       	call   8003c0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	8b 75 08             	mov    0x8(%ebp),%esi
  80003f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
  800042:	b9 00 00 00 00       	mov    $0x0,%ecx
	for (i = 0; i < n; i++)
  800047:	b8 00 00 00 00       	mov    $0x0,%eax
  80004c:	39 d8                	cmp    %ebx,%eax
  80004e:	7d 0e                	jge    80005e <sum+0x2b>
		tot ^= i * s[i];
  800050:	0f be 14 06          	movsbl (%esi,%eax,1),%edx
  800054:	0f af d0             	imul   %eax,%edx
  800057:	31 d1                	xor    %edx,%ecx
	for (i = 0; i < n; i++)
  800059:	83 c0 01             	add    $0x1,%eax
  80005c:	eb ee                	jmp    80004c <sum+0x19>
	return tot;
}
  80005e:	89 c8                	mov    %ecx,%eax
  800060:	5b                   	pop    %ebx
  800061:	5e                   	pop    %esi
  800062:	5d                   	pop    %ebp
  800063:	c3                   	ret    

00800064 <umain>:

void
umain(int argc, char **argv)
{
  800064:	f3 0f 1e fb          	endbr32 
  800068:	55                   	push   %ebp
  800069:	89 e5                	mov    %esp,%ebp
  80006b:	57                   	push   %edi
  80006c:	56                   	push   %esi
  80006d:	53                   	push   %ebx
  80006e:	81 ec 18 01 00 00    	sub    $0x118,%esp
  800074:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  800077:	68 40 27 80 00       	push   $0x802740
  80007c:	e8 8e 04 00 00       	call   80050f <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800081:	83 c4 08             	add    $0x8,%esp
  800084:	68 70 17 00 00       	push   $0x1770
  800089:	68 00 30 80 00       	push   $0x803000
  80008e:	e8 a0 ff ff ff       	call   800033 <sum>
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  80009b:	0f 84 99 00 00 00    	je     80013a <umain+0xd6>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000a1:	83 ec 04             	sub    $0x4,%esp
  8000a4:	68 9e 98 0f 00       	push   $0xf989e
  8000a9:	50                   	push   %eax
  8000aa:	68 08 28 80 00       	push   $0x802808
  8000af:	e8 5b 04 00 00       	call   80050f <cprintf>
  8000b4:	83 c4 10             	add    $0x10,%esp
			x, want);
	else
		cprintf("init: data seems okay\n");
	if ((x = sum(bss, sizeof bss)) != 0)
  8000b7:	83 ec 08             	sub    $0x8,%esp
  8000ba:	68 70 17 00 00       	push   $0x1770
  8000bf:	68 20 50 80 00       	push   $0x805020
  8000c4:	e8 6a ff ff ff       	call   800033 <sum>
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	85 c0                	test   %eax,%eax
  8000ce:	74 7f                	je     80014f <umain+0xeb>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000d0:	83 ec 08             	sub    $0x8,%esp
  8000d3:	50                   	push   %eax
  8000d4:	68 44 28 80 00       	push   $0x802844
  8000d9:	e8 31 04 00 00       	call   80050f <cprintf>
  8000de:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000e1:	83 ec 08             	sub    $0x8,%esp
  8000e4:	68 7c 27 80 00       	push   $0x80277c
  8000e9:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8000ef:	50                   	push   %eax
  8000f0:	e8 4a 0a 00 00       	call   800b3f <strcat>
	for (i = 0; i < argc; i++) {
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	bb 00 00 00 00       	mov    $0x0,%ebx
		strcat(args, " '");
  8000fd:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
	for (i = 0; i < argc; i++) {
  800103:	39 fb                	cmp    %edi,%ebx
  800105:	7d 5a                	jge    800161 <umain+0xfd>
		strcat(args, " '");
  800107:	83 ec 08             	sub    $0x8,%esp
  80010a:	68 88 27 80 00       	push   $0x802788
  80010f:	56                   	push   %esi
  800110:	e8 2a 0a 00 00       	call   800b3f <strcat>
		strcat(args, argv[i]);
  800115:	83 c4 08             	add    $0x8,%esp
  800118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80011b:	ff 34 98             	pushl  (%eax,%ebx,4)
  80011e:	56                   	push   %esi
  80011f:	e8 1b 0a 00 00       	call   800b3f <strcat>
		strcat(args, "'");
  800124:	83 c4 08             	add    $0x8,%esp
  800127:	68 89 27 80 00       	push   $0x802789
  80012c:	56                   	push   %esi
  80012d:	e8 0d 0a 00 00       	call   800b3f <strcat>
	for (i = 0; i < argc; i++) {
  800132:	83 c3 01             	add    $0x1,%ebx
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	eb c9                	jmp    800103 <umain+0x9f>
		cprintf("init: data seems okay\n");
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 4f 27 80 00       	push   $0x80274f
  800142:	e8 c8 03 00 00       	call   80050f <cprintf>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	e9 68 ff ff ff       	jmp    8000b7 <umain+0x53>
		cprintf("init: bss seems okay\n");
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	68 66 27 80 00       	push   $0x802766
  800157:	e8 b3 03 00 00       	call   80050f <cprintf>
  80015c:	83 c4 10             	add    $0x10,%esp
  80015f:	eb 80                	jmp    8000e1 <umain+0x7d>
	}
	cprintf("%s\n", args);
  800161:	83 ec 08             	sub    $0x8,%esp
  800164:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80016a:	50                   	push   %eax
  80016b:	68 8b 27 80 00       	push   $0x80278b
  800170:	e8 9a 03 00 00       	call   80050f <cprintf>

	cprintf("init: running sh\n");
  800175:	c7 04 24 8f 27 80 00 	movl   $0x80278f,(%esp)
  80017c:	e8 8e 03 00 00       	call   80050f <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800181:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800188:	e8 9d 11 00 00       	call   80132a <close>
	if ((r = opencons()) < 0)
  80018d:	e8 d8 01 00 00       	call   80036a <opencons>
  800192:	83 c4 10             	add    $0x10,%esp
  800195:	85 c0                	test   %eax,%eax
  800197:	78 14                	js     8001ad <umain+0x149>
		panic("opencons: %e", r);
	if (r != 0)
  800199:	74 24                	je     8001bf <umain+0x15b>
		panic("first opencons used fd %d", r);
  80019b:	50                   	push   %eax
  80019c:	68 ba 27 80 00       	push   $0x8027ba
  8001a1:	6a 39                	push   $0x39
  8001a3:	68 ae 27 80 00       	push   $0x8027ae
  8001a8:	e8 7b 02 00 00       	call   800428 <_panic>
		panic("opencons: %e", r);
  8001ad:	50                   	push   %eax
  8001ae:	68 a1 27 80 00       	push   $0x8027a1
  8001b3:	6a 37                	push   $0x37
  8001b5:	68 ae 27 80 00       	push   $0x8027ae
  8001ba:	e8 69 02 00 00       	call   800428 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001bf:	83 ec 08             	sub    $0x8,%esp
  8001c2:	6a 01                	push   $0x1
  8001c4:	6a 00                	push   $0x0
  8001c6:	e8 b9 11 00 00       	call   801384 <dup>
  8001cb:	83 c4 10             	add    $0x10,%esp
  8001ce:	85 c0                	test   %eax,%eax
  8001d0:	79 23                	jns    8001f5 <umain+0x191>
		panic("dup: %e", r);
  8001d2:	50                   	push   %eax
  8001d3:	68 d4 27 80 00       	push   $0x8027d4
  8001d8:	6a 3b                	push   $0x3b
  8001da:	68 ae 27 80 00       	push   $0x8027ae
  8001df:	e8 44 02 00 00       	call   800428 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
		r = spawnl("/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
  8001e4:	83 ec 08             	sub    $0x8,%esp
  8001e7:	50                   	push   %eax
  8001e8:	68 f3 27 80 00       	push   $0x8027f3
  8001ed:	e8 1d 03 00 00       	call   80050f <cprintf>
			continue;
  8001f2:	83 c4 10             	add    $0x10,%esp
		cprintf("init: starting sh\n");
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 dc 27 80 00       	push   $0x8027dc
  8001fd:	e8 0d 03 00 00       	call   80050f <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  800202:	83 c4 0c             	add    $0xc,%esp
  800205:	6a 00                	push   $0x0
  800207:	68 f0 27 80 00       	push   $0x8027f0
  80020c:	68 ef 27 80 00       	push   $0x8027ef
  800211:	e8 fc 1c 00 00       	call   801f12 <spawnl>
		if (r < 0) {
  800216:	83 c4 10             	add    $0x10,%esp
  800219:	85 c0                	test   %eax,%eax
  80021b:	78 c7                	js     8001e4 <umain+0x180>
		}
		wait(r);
  80021d:	83 ec 0c             	sub    $0xc,%esp
  800220:	50                   	push   %eax
  800221:	e8 04 21 00 00       	call   80232a <wait>
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	eb ca                	jmp    8001f5 <umain+0x191>

0080022b <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80022b:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80022f:	b8 00 00 00 00       	mov    $0x0,%eax
  800234:	c3                   	ret    

00800235 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800235:	f3 0f 1e fb          	endbr32 
  800239:	55                   	push   %ebp
  80023a:	89 e5                	mov    %esp,%ebp
  80023c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80023f:	68 73 28 80 00       	push   $0x802873
  800244:	ff 75 0c             	pushl  0xc(%ebp)
  800247:	e8 cd 08 00 00       	call   800b19 <strcpy>
	return 0;
}
  80024c:	b8 00 00 00 00       	mov    $0x0,%eax
  800251:	c9                   	leave  
  800252:	c3                   	ret    

00800253 <devcons_write>:
{
  800253:	f3 0f 1e fb          	endbr32 
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	57                   	push   %edi
  80025b:	56                   	push   %esi
  80025c:	53                   	push   %ebx
  80025d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800263:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800268:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80026e:	3b 75 10             	cmp    0x10(%ebp),%esi
  800271:	73 31                	jae    8002a4 <devcons_write+0x51>
		m = n - tot;
  800273:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800276:	29 f3                	sub    %esi,%ebx
  800278:	83 fb 7f             	cmp    $0x7f,%ebx
  80027b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800280:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800283:	83 ec 04             	sub    $0x4,%esp
  800286:	53                   	push   %ebx
  800287:	89 f0                	mov    %esi,%eax
  800289:	03 45 0c             	add    0xc(%ebp),%eax
  80028c:	50                   	push   %eax
  80028d:	57                   	push   %edi
  80028e:	e8 3c 0a 00 00       	call   800ccf <memmove>
		sys_cputs(buf, m);
  800293:	83 c4 08             	add    $0x8,%esp
  800296:	53                   	push   %ebx
  800297:	57                   	push   %edi
  800298:	e8 ee 0b 00 00       	call   800e8b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80029d:	01 de                	add    %ebx,%esi
  80029f:	83 c4 10             	add    $0x10,%esp
  8002a2:	eb ca                	jmp    80026e <devcons_write+0x1b>
}
  8002a4:	89 f0                	mov    %esi,%eax
  8002a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a9:	5b                   	pop    %ebx
  8002aa:	5e                   	pop    %esi
  8002ab:	5f                   	pop    %edi
  8002ac:	5d                   	pop    %ebp
  8002ad:	c3                   	ret    

008002ae <devcons_read>:
{
  8002ae:	f3 0f 1e fb          	endbr32 
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	83 ec 08             	sub    $0x8,%esp
  8002b8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8002bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002c1:	74 21                	je     8002e4 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8002c3:	e8 e5 0b 00 00       	call   800ead <sys_cgetc>
  8002c8:	85 c0                	test   %eax,%eax
  8002ca:	75 07                	jne    8002d3 <devcons_read+0x25>
		sys_yield();
  8002cc:	e8 67 0c 00 00       	call   800f38 <sys_yield>
  8002d1:	eb f0                	jmp    8002c3 <devcons_read+0x15>
	if (c < 0)
  8002d3:	78 0f                	js     8002e4 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8002d5:	83 f8 04             	cmp    $0x4,%eax
  8002d8:	74 0c                	je     8002e6 <devcons_read+0x38>
	*(char*)vbuf = c;
  8002da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002dd:	88 02                	mov    %al,(%edx)
	return 1;
  8002df:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8002e4:	c9                   	leave  
  8002e5:	c3                   	ret    
		return 0;
  8002e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8002eb:	eb f7                	jmp    8002e4 <devcons_read+0x36>

008002ed <cputchar>:
{
  8002ed:	f3 0f 1e fb          	endbr32 
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8002f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fa:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8002fd:	6a 01                	push   $0x1
  8002ff:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800302:	50                   	push   %eax
  800303:	e8 83 0b 00 00       	call   800e8b <sys_cputs>
}
  800308:	83 c4 10             	add    $0x10,%esp
  80030b:	c9                   	leave  
  80030c:	c3                   	ret    

0080030d <getchar>:
{
  80030d:	f3 0f 1e fb          	endbr32 
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800317:	6a 01                	push   $0x1
  800319:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80031c:	50                   	push   %eax
  80031d:	6a 00                	push   $0x0
  80031f:	e8 50 11 00 00       	call   801474 <read>
	if (r < 0)
  800324:	83 c4 10             	add    $0x10,%esp
  800327:	85 c0                	test   %eax,%eax
  800329:	78 06                	js     800331 <getchar+0x24>
	if (r < 1)
  80032b:	74 06                	je     800333 <getchar+0x26>
	return c;
  80032d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800331:	c9                   	leave  
  800332:	c3                   	ret    
		return -E_EOF;
  800333:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800338:	eb f7                	jmp    800331 <getchar+0x24>

0080033a <iscons>:
{
  80033a:	f3 0f 1e fb          	endbr32 
  80033e:	55                   	push   %ebp
  80033f:	89 e5                	mov    %esp,%ebp
  800341:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800344:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800347:	50                   	push   %eax
  800348:	ff 75 08             	pushl  0x8(%ebp)
  80034b:	e8 a1 0e 00 00       	call   8011f1 <fd_lookup>
  800350:	83 c4 10             	add    $0x10,%esp
  800353:	85 c0                	test   %eax,%eax
  800355:	78 11                	js     800368 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  800357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80035a:	8b 15 70 47 80 00    	mov    0x804770,%edx
  800360:	39 10                	cmp    %edx,(%eax)
  800362:	0f 94 c0             	sete   %al
  800365:	0f b6 c0             	movzbl %al,%eax
}
  800368:	c9                   	leave  
  800369:	c3                   	ret    

0080036a <opencons>:
{
  80036a:	f3 0f 1e fb          	endbr32 
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800374:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800377:	50                   	push   %eax
  800378:	e8 1e 0e 00 00       	call   80119b <fd_alloc>
  80037d:	83 c4 10             	add    $0x10,%esp
  800380:	85 c0                	test   %eax,%eax
  800382:	78 3a                	js     8003be <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800384:	83 ec 04             	sub    $0x4,%esp
  800387:	68 07 04 00 00       	push   $0x407
  80038c:	ff 75 f4             	pushl  -0xc(%ebp)
  80038f:	6a 00                	push   $0x0
  800391:	e8 c5 0b 00 00       	call   800f5b <sys_page_alloc>
  800396:	83 c4 10             	add    $0x10,%esp
  800399:	85 c0                	test   %eax,%eax
  80039b:	78 21                	js     8003be <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80039d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003a0:	8b 15 70 47 80 00    	mov    0x804770,%edx
  8003a6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8003a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8003b2:	83 ec 0c             	sub    $0xc,%esp
  8003b5:	50                   	push   %eax
  8003b6:	e8 b1 0d 00 00       	call   80116c <fd2num>
  8003bb:	83 c4 10             	add    $0x10,%esp
}
  8003be:	c9                   	leave  
  8003bf:	c3                   	ret    

008003c0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8003c0:	f3 0f 1e fb          	endbr32 
  8003c4:	55                   	push   %ebp
  8003c5:	89 e5                	mov    %esp,%ebp
  8003c7:	56                   	push   %esi
  8003c8:	53                   	push   %ebx
  8003c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8003cc:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8003cf:	e8 41 0b 00 00       	call   800f15 <sys_getenvid>
  8003d4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003d9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8003dc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003e1:	a3 90 67 80 00       	mov    %eax,0x806790

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003e6:	85 db                	test   %ebx,%ebx
  8003e8:	7e 07                	jle    8003f1 <libmain+0x31>
		binaryname = argv[0];
  8003ea:	8b 06                	mov    (%esi),%eax
  8003ec:	a3 8c 47 80 00       	mov    %eax,0x80478c

	// call user main routine
	umain(argc, argv);
  8003f1:	83 ec 08             	sub    $0x8,%esp
  8003f4:	56                   	push   %esi
  8003f5:	53                   	push   %ebx
  8003f6:	e8 69 fc ff ff       	call   800064 <umain>

	// exit gracefully
	exit();
  8003fb:	e8 0a 00 00 00       	call   80040a <exit>
}
  800400:	83 c4 10             	add    $0x10,%esp
  800403:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800406:	5b                   	pop    %ebx
  800407:	5e                   	pop    %esi
  800408:	5d                   	pop    %ebp
  800409:	c3                   	ret    

0080040a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80040a:	f3 0f 1e fb          	endbr32 
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800414:	e8 42 0f 00 00       	call   80135b <close_all>
	sys_env_destroy(0);
  800419:	83 ec 0c             	sub    $0xc,%esp
  80041c:	6a 00                	push   $0x0
  80041e:	e8 ad 0a 00 00       	call   800ed0 <sys_env_destroy>
}
  800423:	83 c4 10             	add    $0x10,%esp
  800426:	c9                   	leave  
  800427:	c3                   	ret    

00800428 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800428:	f3 0f 1e fb          	endbr32 
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	56                   	push   %esi
  800430:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800431:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800434:	8b 35 8c 47 80 00    	mov    0x80478c,%esi
  80043a:	e8 d6 0a 00 00       	call   800f15 <sys_getenvid>
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	ff 75 0c             	pushl  0xc(%ebp)
  800445:	ff 75 08             	pushl  0x8(%ebp)
  800448:	56                   	push   %esi
  800449:	50                   	push   %eax
  80044a:	68 8c 28 80 00       	push   $0x80288c
  80044f:	e8 bb 00 00 00       	call   80050f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800454:	83 c4 18             	add    $0x18,%esp
  800457:	53                   	push   %ebx
  800458:	ff 75 10             	pushl  0x10(%ebp)
  80045b:	e8 5a 00 00 00       	call   8004ba <vcprintf>
	cprintf("\n");
  800460:	c7 04 24 94 2d 80 00 	movl   $0x802d94,(%esp)
  800467:	e8 a3 00 00 00       	call   80050f <cprintf>
  80046c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80046f:	cc                   	int3   
  800470:	eb fd                	jmp    80046f <_panic+0x47>

00800472 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800472:	f3 0f 1e fb          	endbr32 
  800476:	55                   	push   %ebp
  800477:	89 e5                	mov    %esp,%ebp
  800479:	53                   	push   %ebx
  80047a:	83 ec 04             	sub    $0x4,%esp
  80047d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800480:	8b 13                	mov    (%ebx),%edx
  800482:	8d 42 01             	lea    0x1(%edx),%eax
  800485:	89 03                	mov    %eax,(%ebx)
  800487:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80048a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80048e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800493:	74 09                	je     80049e <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800495:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800499:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80049c:	c9                   	leave  
  80049d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80049e:	83 ec 08             	sub    $0x8,%esp
  8004a1:	68 ff 00 00 00       	push   $0xff
  8004a6:	8d 43 08             	lea    0x8(%ebx),%eax
  8004a9:	50                   	push   %eax
  8004aa:	e8 dc 09 00 00       	call   800e8b <sys_cputs>
		b->idx = 0;
  8004af:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8004b5:	83 c4 10             	add    $0x10,%esp
  8004b8:	eb db                	jmp    800495 <putch+0x23>

008004ba <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8004ba:	f3 0f 1e fb          	endbr32 
  8004be:	55                   	push   %ebp
  8004bf:	89 e5                	mov    %esp,%ebp
  8004c1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004ce:	00 00 00 
	b.cnt = 0;
  8004d1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004d8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004db:	ff 75 0c             	pushl  0xc(%ebp)
  8004de:	ff 75 08             	pushl  0x8(%ebp)
  8004e1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e7:	50                   	push   %eax
  8004e8:	68 72 04 80 00       	push   $0x800472
  8004ed:	e8 20 01 00 00       	call   800612 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004f2:	83 c4 08             	add    $0x8,%esp
  8004f5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004fb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800501:	50                   	push   %eax
  800502:	e8 84 09 00 00       	call   800e8b <sys_cputs>

	return b.cnt;
}
  800507:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80050d:	c9                   	leave  
  80050e:	c3                   	ret    

0080050f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80050f:	f3 0f 1e fb          	endbr32 
  800513:	55                   	push   %ebp
  800514:	89 e5                	mov    %esp,%ebp
  800516:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800519:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80051c:	50                   	push   %eax
  80051d:	ff 75 08             	pushl  0x8(%ebp)
  800520:	e8 95 ff ff ff       	call   8004ba <vcprintf>
	va_end(ap);

	return cnt;
}
  800525:	c9                   	leave  
  800526:	c3                   	ret    

00800527 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800527:	55                   	push   %ebp
  800528:	89 e5                	mov    %esp,%ebp
  80052a:	57                   	push   %edi
  80052b:	56                   	push   %esi
  80052c:	53                   	push   %ebx
  80052d:	83 ec 1c             	sub    $0x1c,%esp
  800530:	89 c7                	mov    %eax,%edi
  800532:	89 d6                	mov    %edx,%esi
  800534:	8b 45 08             	mov    0x8(%ebp),%eax
  800537:	8b 55 0c             	mov    0xc(%ebp),%edx
  80053a:	89 d1                	mov    %edx,%ecx
  80053c:	89 c2                	mov    %eax,%edx
  80053e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800541:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800544:	8b 45 10             	mov    0x10(%ebp),%eax
  800547:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80054a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80054d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800554:	39 c2                	cmp    %eax,%edx
  800556:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800559:	72 3e                	jb     800599 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	ff 75 18             	pushl  0x18(%ebp)
  800561:	83 eb 01             	sub    $0x1,%ebx
  800564:	53                   	push   %ebx
  800565:	50                   	push   %eax
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056c:	ff 75 e0             	pushl  -0x20(%ebp)
  80056f:	ff 75 dc             	pushl  -0x24(%ebp)
  800572:	ff 75 d8             	pushl  -0x28(%ebp)
  800575:	e8 66 1f 00 00       	call   8024e0 <__udivdi3>
  80057a:	83 c4 18             	add    $0x18,%esp
  80057d:	52                   	push   %edx
  80057e:	50                   	push   %eax
  80057f:	89 f2                	mov    %esi,%edx
  800581:	89 f8                	mov    %edi,%eax
  800583:	e8 9f ff ff ff       	call   800527 <printnum>
  800588:	83 c4 20             	add    $0x20,%esp
  80058b:	eb 13                	jmp    8005a0 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	56                   	push   %esi
  800591:	ff 75 18             	pushl  0x18(%ebp)
  800594:	ff d7                	call   *%edi
  800596:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800599:	83 eb 01             	sub    $0x1,%ebx
  80059c:	85 db                	test   %ebx,%ebx
  80059e:	7f ed                	jg     80058d <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005a0:	83 ec 08             	sub    $0x8,%esp
  8005a3:	56                   	push   %esi
  8005a4:	83 ec 04             	sub    $0x4,%esp
  8005a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005aa:	ff 75 e0             	pushl  -0x20(%ebp)
  8005ad:	ff 75 dc             	pushl  -0x24(%ebp)
  8005b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8005b3:	e8 38 20 00 00       	call   8025f0 <__umoddi3>
  8005b8:	83 c4 14             	add    $0x14,%esp
  8005bb:	0f be 80 af 28 80 00 	movsbl 0x8028af(%eax),%eax
  8005c2:	50                   	push   %eax
  8005c3:	ff d7                	call   *%edi
}
  8005c5:	83 c4 10             	add    $0x10,%esp
  8005c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005cb:	5b                   	pop    %ebx
  8005cc:	5e                   	pop    %esi
  8005cd:	5f                   	pop    %edi
  8005ce:	5d                   	pop    %ebp
  8005cf:	c3                   	ret    

008005d0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005d0:	f3 0f 1e fb          	endbr32 
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005da:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005de:	8b 10                	mov    (%eax),%edx
  8005e0:	3b 50 04             	cmp    0x4(%eax),%edx
  8005e3:	73 0a                	jae    8005ef <sprintputch+0x1f>
		*b->buf++ = ch;
  8005e5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005e8:	89 08                	mov    %ecx,(%eax)
  8005ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ed:	88 02                	mov    %al,(%edx)
}
  8005ef:	5d                   	pop    %ebp
  8005f0:	c3                   	ret    

008005f1 <printfmt>:
{
  8005f1:	f3 0f 1e fb          	endbr32 
  8005f5:	55                   	push   %ebp
  8005f6:	89 e5                	mov    %esp,%ebp
  8005f8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005fb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005fe:	50                   	push   %eax
  8005ff:	ff 75 10             	pushl  0x10(%ebp)
  800602:	ff 75 0c             	pushl  0xc(%ebp)
  800605:	ff 75 08             	pushl  0x8(%ebp)
  800608:	e8 05 00 00 00       	call   800612 <vprintfmt>
}
  80060d:	83 c4 10             	add    $0x10,%esp
  800610:	c9                   	leave  
  800611:	c3                   	ret    

00800612 <vprintfmt>:
{
  800612:	f3 0f 1e fb          	endbr32 
  800616:	55                   	push   %ebp
  800617:	89 e5                	mov    %esp,%ebp
  800619:	57                   	push   %edi
  80061a:	56                   	push   %esi
  80061b:	53                   	push   %ebx
  80061c:	83 ec 3c             	sub    $0x3c,%esp
  80061f:	8b 75 08             	mov    0x8(%ebp),%esi
  800622:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800625:	8b 7d 10             	mov    0x10(%ebp),%edi
  800628:	e9 8e 03 00 00       	jmp    8009bb <vprintfmt+0x3a9>
		padc = ' ';
  80062d:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800631:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800638:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80063f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800646:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80064b:	8d 47 01             	lea    0x1(%edi),%eax
  80064e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800651:	0f b6 17             	movzbl (%edi),%edx
  800654:	8d 42 dd             	lea    -0x23(%edx),%eax
  800657:	3c 55                	cmp    $0x55,%al
  800659:	0f 87 df 03 00 00    	ja     800a3e <vprintfmt+0x42c>
  80065f:	0f b6 c0             	movzbl %al,%eax
  800662:	3e ff 24 85 00 2a 80 	notrack jmp *0x802a00(,%eax,4)
  800669:	00 
  80066a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80066d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800671:	eb d8                	jmp    80064b <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800673:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800676:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80067a:	eb cf                	jmp    80064b <vprintfmt+0x39>
  80067c:	0f b6 d2             	movzbl %dl,%edx
  80067f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800682:	b8 00 00 00 00       	mov    $0x0,%eax
  800687:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80068a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80068d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800691:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800694:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800697:	83 f9 09             	cmp    $0x9,%ecx
  80069a:	77 55                	ja     8006f1 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80069c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80069f:	eb e9                	jmp    80068a <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8d 40 04             	lea    0x4(%eax),%eax
  8006af:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006b9:	79 90                	jns    80064b <vprintfmt+0x39>
				width = precision, precision = -1;
  8006bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006c1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006c8:	eb 81                	jmp    80064b <vprintfmt+0x39>
  8006ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006cd:	85 c0                	test   %eax,%eax
  8006cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d4:	0f 49 d0             	cmovns %eax,%edx
  8006d7:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006dd:	e9 69 ff ff ff       	jmp    80064b <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8006e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006e5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8006ec:	e9 5a ff ff ff       	jmp    80064b <vprintfmt+0x39>
  8006f1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f7:	eb bc                	jmp    8006b5 <vprintfmt+0xa3>
			lflag++;
  8006f9:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006ff:	e9 47 ff ff ff       	jmp    80064b <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	8d 78 04             	lea    0x4(%eax),%edi
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	53                   	push   %ebx
  80070e:	ff 30                	pushl  (%eax)
  800710:	ff d6                	call   *%esi
			break;
  800712:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800715:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800718:	e9 9b 02 00 00       	jmp    8009b8 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8d 78 04             	lea    0x4(%eax),%edi
  800723:	8b 00                	mov    (%eax),%eax
  800725:	99                   	cltd   
  800726:	31 d0                	xor    %edx,%eax
  800728:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80072a:	83 f8 0f             	cmp    $0xf,%eax
  80072d:	7f 23                	jg     800752 <vprintfmt+0x140>
  80072f:	8b 14 85 60 2b 80 00 	mov    0x802b60(,%eax,4),%edx
  800736:	85 d2                	test   %edx,%edx
  800738:	74 18                	je     800752 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80073a:	52                   	push   %edx
  80073b:	68 91 2c 80 00       	push   $0x802c91
  800740:	53                   	push   %ebx
  800741:	56                   	push   %esi
  800742:	e8 aa fe ff ff       	call   8005f1 <printfmt>
  800747:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80074a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80074d:	e9 66 02 00 00       	jmp    8009b8 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800752:	50                   	push   %eax
  800753:	68 c7 28 80 00       	push   $0x8028c7
  800758:	53                   	push   %ebx
  800759:	56                   	push   %esi
  80075a:	e8 92 fe ff ff       	call   8005f1 <printfmt>
  80075f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800762:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800765:	e9 4e 02 00 00       	jmp    8009b8 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	83 c0 04             	add    $0x4,%eax
  800770:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800778:	85 d2                	test   %edx,%edx
  80077a:	b8 c0 28 80 00       	mov    $0x8028c0,%eax
  80077f:	0f 45 c2             	cmovne %edx,%eax
  800782:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800785:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800789:	7e 06                	jle    800791 <vprintfmt+0x17f>
  80078b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80078f:	75 0d                	jne    80079e <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800791:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800794:	89 c7                	mov    %eax,%edi
  800796:	03 45 e0             	add    -0x20(%ebp),%eax
  800799:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80079c:	eb 55                	jmp    8007f3 <vprintfmt+0x1e1>
  80079e:	83 ec 08             	sub    $0x8,%esp
  8007a1:	ff 75 d8             	pushl  -0x28(%ebp)
  8007a4:	ff 75 cc             	pushl  -0x34(%ebp)
  8007a7:	e8 46 03 00 00       	call   800af2 <strnlen>
  8007ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007af:	29 c2                	sub    %eax,%edx
  8007b1:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8007b4:	83 c4 10             	add    $0x10,%esp
  8007b7:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8007b9:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007c0:	85 ff                	test   %edi,%edi
  8007c2:	7e 11                	jle    8007d5 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	53                   	push   %ebx
  8007c8:	ff 75 e0             	pushl  -0x20(%ebp)
  8007cb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007cd:	83 ef 01             	sub    $0x1,%edi
  8007d0:	83 c4 10             	add    $0x10,%esp
  8007d3:	eb eb                	jmp    8007c0 <vprintfmt+0x1ae>
  8007d5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007d8:	85 d2                	test   %edx,%edx
  8007da:	b8 00 00 00 00       	mov    $0x0,%eax
  8007df:	0f 49 c2             	cmovns %edx,%eax
  8007e2:	29 c2                	sub    %eax,%edx
  8007e4:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8007e7:	eb a8                	jmp    800791 <vprintfmt+0x17f>
					putch(ch, putdat);
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	53                   	push   %ebx
  8007ed:	52                   	push   %edx
  8007ee:	ff d6                	call   *%esi
  8007f0:	83 c4 10             	add    $0x10,%esp
  8007f3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007f6:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007f8:	83 c7 01             	add    $0x1,%edi
  8007fb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007ff:	0f be d0             	movsbl %al,%edx
  800802:	85 d2                	test   %edx,%edx
  800804:	74 4b                	je     800851 <vprintfmt+0x23f>
  800806:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80080a:	78 06                	js     800812 <vprintfmt+0x200>
  80080c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800810:	78 1e                	js     800830 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800812:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800816:	74 d1                	je     8007e9 <vprintfmt+0x1d7>
  800818:	0f be c0             	movsbl %al,%eax
  80081b:	83 e8 20             	sub    $0x20,%eax
  80081e:	83 f8 5e             	cmp    $0x5e,%eax
  800821:	76 c6                	jbe    8007e9 <vprintfmt+0x1d7>
					putch('?', putdat);
  800823:	83 ec 08             	sub    $0x8,%esp
  800826:	53                   	push   %ebx
  800827:	6a 3f                	push   $0x3f
  800829:	ff d6                	call   *%esi
  80082b:	83 c4 10             	add    $0x10,%esp
  80082e:	eb c3                	jmp    8007f3 <vprintfmt+0x1e1>
  800830:	89 cf                	mov    %ecx,%edi
  800832:	eb 0e                	jmp    800842 <vprintfmt+0x230>
				putch(' ', putdat);
  800834:	83 ec 08             	sub    $0x8,%esp
  800837:	53                   	push   %ebx
  800838:	6a 20                	push   $0x20
  80083a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80083c:	83 ef 01             	sub    $0x1,%edi
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	85 ff                	test   %edi,%edi
  800844:	7f ee                	jg     800834 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800846:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800849:	89 45 14             	mov    %eax,0x14(%ebp)
  80084c:	e9 67 01 00 00       	jmp    8009b8 <vprintfmt+0x3a6>
  800851:	89 cf                	mov    %ecx,%edi
  800853:	eb ed                	jmp    800842 <vprintfmt+0x230>
	if (lflag >= 2)
  800855:	83 f9 01             	cmp    $0x1,%ecx
  800858:	7f 1b                	jg     800875 <vprintfmt+0x263>
	else if (lflag)
  80085a:	85 c9                	test   %ecx,%ecx
  80085c:	74 63                	je     8008c1 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80085e:	8b 45 14             	mov    0x14(%ebp),%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800866:	99                   	cltd   
  800867:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	8d 40 04             	lea    0x4(%eax),%eax
  800870:	89 45 14             	mov    %eax,0x14(%ebp)
  800873:	eb 17                	jmp    80088c <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	8b 50 04             	mov    0x4(%eax),%edx
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800880:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800883:	8b 45 14             	mov    0x14(%ebp),%eax
  800886:	8d 40 08             	lea    0x8(%eax),%eax
  800889:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80088c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80088f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800892:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800897:	85 c9                	test   %ecx,%ecx
  800899:	0f 89 ff 00 00 00    	jns    80099e <vprintfmt+0x38c>
				putch('-', putdat);
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	53                   	push   %ebx
  8008a3:	6a 2d                	push   $0x2d
  8008a5:	ff d6                	call   *%esi
				num = -(long long) num;
  8008a7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8008aa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8008ad:	f7 da                	neg    %edx
  8008af:	83 d1 00             	adc    $0x0,%ecx
  8008b2:	f7 d9                	neg    %ecx
  8008b4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008b7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008bc:	e9 dd 00 00 00       	jmp    80099e <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c9:	99                   	cltd   
  8008ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	8d 40 04             	lea    0x4(%eax),%eax
  8008d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d6:	eb b4                	jmp    80088c <vprintfmt+0x27a>
	if (lflag >= 2)
  8008d8:	83 f9 01             	cmp    $0x1,%ecx
  8008db:	7f 1e                	jg     8008fb <vprintfmt+0x2e9>
	else if (lflag)
  8008dd:	85 c9                	test   %ecx,%ecx
  8008df:	74 32                	je     800913 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8008e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e4:	8b 10                	mov    (%eax),%edx
  8008e6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008eb:	8d 40 04             	lea    0x4(%eax),%eax
  8008ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008f1:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8008f6:	e9 a3 00 00 00       	jmp    80099e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8008fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fe:	8b 10                	mov    (%eax),%edx
  800900:	8b 48 04             	mov    0x4(%eax),%ecx
  800903:	8d 40 08             	lea    0x8(%eax),%eax
  800906:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800909:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80090e:	e9 8b 00 00 00       	jmp    80099e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800913:	8b 45 14             	mov    0x14(%ebp),%eax
  800916:	8b 10                	mov    (%eax),%edx
  800918:	b9 00 00 00 00       	mov    $0x0,%ecx
  80091d:	8d 40 04             	lea    0x4(%eax),%eax
  800920:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800923:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800928:	eb 74                	jmp    80099e <vprintfmt+0x38c>
	if (lflag >= 2)
  80092a:	83 f9 01             	cmp    $0x1,%ecx
  80092d:	7f 1b                	jg     80094a <vprintfmt+0x338>
	else if (lflag)
  80092f:	85 c9                	test   %ecx,%ecx
  800931:	74 2c                	je     80095f <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800933:	8b 45 14             	mov    0x14(%ebp),%eax
  800936:	8b 10                	mov    (%eax),%edx
  800938:	b9 00 00 00 00       	mov    $0x0,%ecx
  80093d:	8d 40 04             	lea    0x4(%eax),%eax
  800940:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800943:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800948:	eb 54                	jmp    80099e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80094a:	8b 45 14             	mov    0x14(%ebp),%eax
  80094d:	8b 10                	mov    (%eax),%edx
  80094f:	8b 48 04             	mov    0x4(%eax),%ecx
  800952:	8d 40 08             	lea    0x8(%eax),%eax
  800955:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800958:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80095d:	eb 3f                	jmp    80099e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80095f:	8b 45 14             	mov    0x14(%ebp),%eax
  800962:	8b 10                	mov    (%eax),%edx
  800964:	b9 00 00 00 00       	mov    $0x0,%ecx
  800969:	8d 40 04             	lea    0x4(%eax),%eax
  80096c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80096f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800974:	eb 28                	jmp    80099e <vprintfmt+0x38c>
			putch('0', putdat);
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	53                   	push   %ebx
  80097a:	6a 30                	push   $0x30
  80097c:	ff d6                	call   *%esi
			putch('x', putdat);
  80097e:	83 c4 08             	add    $0x8,%esp
  800981:	53                   	push   %ebx
  800982:	6a 78                	push   $0x78
  800984:	ff d6                	call   *%esi
			num = (unsigned long long)
  800986:	8b 45 14             	mov    0x14(%ebp),%eax
  800989:	8b 10                	mov    (%eax),%edx
  80098b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800990:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800993:	8d 40 04             	lea    0x4(%eax),%eax
  800996:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800999:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80099e:	83 ec 0c             	sub    $0xc,%esp
  8009a1:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8009a5:	57                   	push   %edi
  8009a6:	ff 75 e0             	pushl  -0x20(%ebp)
  8009a9:	50                   	push   %eax
  8009aa:	51                   	push   %ecx
  8009ab:	52                   	push   %edx
  8009ac:	89 da                	mov    %ebx,%edx
  8009ae:	89 f0                	mov    %esi,%eax
  8009b0:	e8 72 fb ff ff       	call   800527 <printnum>
			break;
  8009b5:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009bb:	83 c7 01             	add    $0x1,%edi
  8009be:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009c2:	83 f8 25             	cmp    $0x25,%eax
  8009c5:	0f 84 62 fc ff ff    	je     80062d <vprintfmt+0x1b>
			if (ch == '\0')
  8009cb:	85 c0                	test   %eax,%eax
  8009cd:	0f 84 8b 00 00 00    	je     800a5e <vprintfmt+0x44c>
			putch(ch, putdat);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	53                   	push   %ebx
  8009d7:	50                   	push   %eax
  8009d8:	ff d6                	call   *%esi
  8009da:	83 c4 10             	add    $0x10,%esp
  8009dd:	eb dc                	jmp    8009bb <vprintfmt+0x3a9>
	if (lflag >= 2)
  8009df:	83 f9 01             	cmp    $0x1,%ecx
  8009e2:	7f 1b                	jg     8009ff <vprintfmt+0x3ed>
	else if (lflag)
  8009e4:	85 c9                	test   %ecx,%ecx
  8009e6:	74 2c                	je     800a14 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8009e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009eb:	8b 10                	mov    (%eax),%edx
  8009ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009f2:	8d 40 04             	lea    0x4(%eax),%eax
  8009f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009f8:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8009fd:	eb 9f                	jmp    80099e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8009ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800a02:	8b 10                	mov    (%eax),%edx
  800a04:	8b 48 04             	mov    0x4(%eax),%ecx
  800a07:	8d 40 08             	lea    0x8(%eax),%eax
  800a0a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a0d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800a12:	eb 8a                	jmp    80099e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800a14:	8b 45 14             	mov    0x14(%ebp),%eax
  800a17:	8b 10                	mov    (%eax),%edx
  800a19:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a1e:	8d 40 04             	lea    0x4(%eax),%eax
  800a21:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a24:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800a29:	e9 70 ff ff ff       	jmp    80099e <vprintfmt+0x38c>
			putch(ch, putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	53                   	push   %ebx
  800a32:	6a 25                	push   $0x25
  800a34:	ff d6                	call   *%esi
			break;
  800a36:	83 c4 10             	add    $0x10,%esp
  800a39:	e9 7a ff ff ff       	jmp    8009b8 <vprintfmt+0x3a6>
			putch('%', putdat);
  800a3e:	83 ec 08             	sub    $0x8,%esp
  800a41:	53                   	push   %ebx
  800a42:	6a 25                	push   $0x25
  800a44:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a46:	83 c4 10             	add    $0x10,%esp
  800a49:	89 f8                	mov    %edi,%eax
  800a4b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a4f:	74 05                	je     800a56 <vprintfmt+0x444>
  800a51:	83 e8 01             	sub    $0x1,%eax
  800a54:	eb f5                	jmp    800a4b <vprintfmt+0x439>
  800a56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a59:	e9 5a ff ff ff       	jmp    8009b8 <vprintfmt+0x3a6>
}
  800a5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a61:	5b                   	pop    %ebx
  800a62:	5e                   	pop    %esi
  800a63:	5f                   	pop    %edi
  800a64:	5d                   	pop    %ebp
  800a65:	c3                   	ret    

00800a66 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a66:	f3 0f 1e fb          	endbr32 
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	83 ec 18             	sub    $0x18,%esp
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a76:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a79:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a7d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a87:	85 c0                	test   %eax,%eax
  800a89:	74 26                	je     800ab1 <vsnprintf+0x4b>
  800a8b:	85 d2                	test   %edx,%edx
  800a8d:	7e 22                	jle    800ab1 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a8f:	ff 75 14             	pushl  0x14(%ebp)
  800a92:	ff 75 10             	pushl  0x10(%ebp)
  800a95:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a98:	50                   	push   %eax
  800a99:	68 d0 05 80 00       	push   $0x8005d0
  800a9e:	e8 6f fb ff ff       	call   800612 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800aac:	83 c4 10             	add    $0x10,%esp
}
  800aaf:	c9                   	leave  
  800ab0:	c3                   	ret    
		return -E_INVAL;
  800ab1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ab6:	eb f7                	jmp    800aaf <vsnprintf+0x49>

00800ab8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab8:	f3 0f 1e fb          	endbr32 
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ac2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ac5:	50                   	push   %eax
  800ac6:	ff 75 10             	pushl  0x10(%ebp)
  800ac9:	ff 75 0c             	pushl  0xc(%ebp)
  800acc:	ff 75 08             	pushl  0x8(%ebp)
  800acf:	e8 92 ff ff ff       	call   800a66 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    

00800ad6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ad6:	f3 0f 1e fb          	endbr32 
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ae9:	74 05                	je     800af0 <strlen+0x1a>
		n++;
  800aeb:	83 c0 01             	add    $0x1,%eax
  800aee:	eb f5                	jmp    800ae5 <strlen+0xf>
	return n;
}
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    

00800af2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800af2:	f3 0f 1e fb          	endbr32 
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800afc:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aff:	b8 00 00 00 00       	mov    $0x0,%eax
  800b04:	39 d0                	cmp    %edx,%eax
  800b06:	74 0d                	je     800b15 <strnlen+0x23>
  800b08:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800b0c:	74 05                	je     800b13 <strnlen+0x21>
		n++;
  800b0e:	83 c0 01             	add    $0x1,%eax
  800b11:	eb f1                	jmp    800b04 <strnlen+0x12>
  800b13:	89 c2                	mov    %eax,%edx
	return n;
}
  800b15:	89 d0                	mov    %edx,%eax
  800b17:	5d                   	pop    %ebp
  800b18:	c3                   	ret    

00800b19 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b19:	f3 0f 1e fb          	endbr32 
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	53                   	push   %ebx
  800b21:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b24:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b27:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2c:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800b30:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800b33:	83 c0 01             	add    $0x1,%eax
  800b36:	84 d2                	test   %dl,%dl
  800b38:	75 f2                	jne    800b2c <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800b3a:	89 c8                	mov    %ecx,%eax
  800b3c:	5b                   	pop    %ebx
  800b3d:	5d                   	pop    %ebp
  800b3e:	c3                   	ret    

00800b3f <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b3f:	f3 0f 1e fb          	endbr32 
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	53                   	push   %ebx
  800b47:	83 ec 10             	sub    $0x10,%esp
  800b4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b4d:	53                   	push   %ebx
  800b4e:	e8 83 ff ff ff       	call   800ad6 <strlen>
  800b53:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	01 d8                	add    %ebx,%eax
  800b5b:	50                   	push   %eax
  800b5c:	e8 b8 ff ff ff       	call   800b19 <strcpy>
	return dst;
}
  800b61:	89 d8                	mov    %ebx,%eax
  800b63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b66:	c9                   	leave  
  800b67:	c3                   	ret    

00800b68 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b68:	f3 0f 1e fb          	endbr32 
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	56                   	push   %esi
  800b70:	53                   	push   %ebx
  800b71:	8b 75 08             	mov    0x8(%ebp),%esi
  800b74:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b77:	89 f3                	mov    %esi,%ebx
  800b79:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b7c:	89 f0                	mov    %esi,%eax
  800b7e:	39 d8                	cmp    %ebx,%eax
  800b80:	74 11                	je     800b93 <strncpy+0x2b>
		*dst++ = *src;
  800b82:	83 c0 01             	add    $0x1,%eax
  800b85:	0f b6 0a             	movzbl (%edx),%ecx
  800b88:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b8b:	80 f9 01             	cmp    $0x1,%cl
  800b8e:	83 da ff             	sbb    $0xffffffff,%edx
  800b91:	eb eb                	jmp    800b7e <strncpy+0x16>
	}
	return ret;
}
  800b93:	89 f0                	mov    %esi,%eax
  800b95:	5b                   	pop    %ebx
  800b96:	5e                   	pop    %esi
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    

00800b99 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b99:	f3 0f 1e fb          	endbr32 
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	56                   	push   %esi
  800ba1:	53                   	push   %ebx
  800ba2:	8b 75 08             	mov    0x8(%ebp),%esi
  800ba5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba8:	8b 55 10             	mov    0x10(%ebp),%edx
  800bab:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800bad:	85 d2                	test   %edx,%edx
  800baf:	74 21                	je     800bd2 <strlcpy+0x39>
  800bb1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800bb5:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800bb7:	39 c2                	cmp    %eax,%edx
  800bb9:	74 14                	je     800bcf <strlcpy+0x36>
  800bbb:	0f b6 19             	movzbl (%ecx),%ebx
  800bbe:	84 db                	test   %bl,%bl
  800bc0:	74 0b                	je     800bcd <strlcpy+0x34>
			*dst++ = *src++;
  800bc2:	83 c1 01             	add    $0x1,%ecx
  800bc5:	83 c2 01             	add    $0x1,%edx
  800bc8:	88 5a ff             	mov    %bl,-0x1(%edx)
  800bcb:	eb ea                	jmp    800bb7 <strlcpy+0x1e>
  800bcd:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800bcf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bd2:	29 f0                	sub    %esi,%eax
}
  800bd4:	5b                   	pop    %ebx
  800bd5:	5e                   	pop    %esi
  800bd6:	5d                   	pop    %ebp
  800bd7:	c3                   	ret    

00800bd8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bd8:	f3 0f 1e fb          	endbr32 
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800be2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800be5:	0f b6 01             	movzbl (%ecx),%eax
  800be8:	84 c0                	test   %al,%al
  800bea:	74 0c                	je     800bf8 <strcmp+0x20>
  800bec:	3a 02                	cmp    (%edx),%al
  800bee:	75 08                	jne    800bf8 <strcmp+0x20>
		p++, q++;
  800bf0:	83 c1 01             	add    $0x1,%ecx
  800bf3:	83 c2 01             	add    $0x1,%edx
  800bf6:	eb ed                	jmp    800be5 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bf8:	0f b6 c0             	movzbl %al,%eax
  800bfb:	0f b6 12             	movzbl (%edx),%edx
  800bfe:	29 d0                	sub    %edx,%eax
}
  800c00:	5d                   	pop    %ebp
  800c01:	c3                   	ret    

00800c02 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c02:	f3 0f 1e fb          	endbr32 
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	53                   	push   %ebx
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c10:	89 c3                	mov    %eax,%ebx
  800c12:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c15:	eb 06                	jmp    800c1d <strncmp+0x1b>
		n--, p++, q++;
  800c17:	83 c0 01             	add    $0x1,%eax
  800c1a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c1d:	39 d8                	cmp    %ebx,%eax
  800c1f:	74 16                	je     800c37 <strncmp+0x35>
  800c21:	0f b6 08             	movzbl (%eax),%ecx
  800c24:	84 c9                	test   %cl,%cl
  800c26:	74 04                	je     800c2c <strncmp+0x2a>
  800c28:	3a 0a                	cmp    (%edx),%cl
  800c2a:	74 eb                	je     800c17 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c2c:	0f b6 00             	movzbl (%eax),%eax
  800c2f:	0f b6 12             	movzbl (%edx),%edx
  800c32:	29 d0                	sub    %edx,%eax
}
  800c34:	5b                   	pop    %ebx
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    
		return 0;
  800c37:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3c:	eb f6                	jmp    800c34 <strncmp+0x32>

00800c3e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c3e:	f3 0f 1e fb          	endbr32 
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c4c:	0f b6 10             	movzbl (%eax),%edx
  800c4f:	84 d2                	test   %dl,%dl
  800c51:	74 09                	je     800c5c <strchr+0x1e>
		if (*s == c)
  800c53:	38 ca                	cmp    %cl,%dl
  800c55:	74 0a                	je     800c61 <strchr+0x23>
	for (; *s; s++)
  800c57:	83 c0 01             	add    $0x1,%eax
  800c5a:	eb f0                	jmp    800c4c <strchr+0xe>
			return (char *) s;
	return 0;
  800c5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c63:	f3 0f 1e fb          	endbr32 
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c71:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c74:	38 ca                	cmp    %cl,%dl
  800c76:	74 09                	je     800c81 <strfind+0x1e>
  800c78:	84 d2                	test   %dl,%dl
  800c7a:	74 05                	je     800c81 <strfind+0x1e>
	for (; *s; s++)
  800c7c:	83 c0 01             	add    $0x1,%eax
  800c7f:	eb f0                	jmp    800c71 <strfind+0xe>
			break;
	return (char *) s;
}
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c83:	f3 0f 1e fb          	endbr32 
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	57                   	push   %edi
  800c8b:	56                   	push   %esi
  800c8c:	53                   	push   %ebx
  800c8d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c90:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c93:	85 c9                	test   %ecx,%ecx
  800c95:	74 31                	je     800cc8 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c97:	89 f8                	mov    %edi,%eax
  800c99:	09 c8                	or     %ecx,%eax
  800c9b:	a8 03                	test   $0x3,%al
  800c9d:	75 23                	jne    800cc2 <memset+0x3f>
		c &= 0xFF;
  800c9f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ca3:	89 d3                	mov    %edx,%ebx
  800ca5:	c1 e3 08             	shl    $0x8,%ebx
  800ca8:	89 d0                	mov    %edx,%eax
  800caa:	c1 e0 18             	shl    $0x18,%eax
  800cad:	89 d6                	mov    %edx,%esi
  800caf:	c1 e6 10             	shl    $0x10,%esi
  800cb2:	09 f0                	or     %esi,%eax
  800cb4:	09 c2                	or     %eax,%edx
  800cb6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800cb8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800cbb:	89 d0                	mov    %edx,%eax
  800cbd:	fc                   	cld    
  800cbe:	f3 ab                	rep stos %eax,%es:(%edi)
  800cc0:	eb 06                	jmp    800cc8 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc5:	fc                   	cld    
  800cc6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cc8:	89 f8                	mov    %edi,%eax
  800cca:	5b                   	pop    %ebx
  800ccb:	5e                   	pop    %esi
  800ccc:	5f                   	pop    %edi
  800ccd:	5d                   	pop    %ebp
  800cce:	c3                   	ret    

00800ccf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ccf:	f3 0f 1e fb          	endbr32 
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	57                   	push   %edi
  800cd7:	56                   	push   %esi
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cde:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ce1:	39 c6                	cmp    %eax,%esi
  800ce3:	73 32                	jae    800d17 <memmove+0x48>
  800ce5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ce8:	39 c2                	cmp    %eax,%edx
  800cea:	76 2b                	jbe    800d17 <memmove+0x48>
		s += n;
		d += n;
  800cec:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cef:	89 fe                	mov    %edi,%esi
  800cf1:	09 ce                	or     %ecx,%esi
  800cf3:	09 d6                	or     %edx,%esi
  800cf5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cfb:	75 0e                	jne    800d0b <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cfd:	83 ef 04             	sub    $0x4,%edi
  800d00:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d03:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d06:	fd                   	std    
  800d07:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d09:	eb 09                	jmp    800d14 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d0b:	83 ef 01             	sub    $0x1,%edi
  800d0e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d11:	fd                   	std    
  800d12:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d14:	fc                   	cld    
  800d15:	eb 1a                	jmp    800d31 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d17:	89 c2                	mov    %eax,%edx
  800d19:	09 ca                	or     %ecx,%edx
  800d1b:	09 f2                	or     %esi,%edx
  800d1d:	f6 c2 03             	test   $0x3,%dl
  800d20:	75 0a                	jne    800d2c <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d22:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d25:	89 c7                	mov    %eax,%edi
  800d27:	fc                   	cld    
  800d28:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d2a:	eb 05                	jmp    800d31 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800d2c:	89 c7                	mov    %eax,%edi
  800d2e:	fc                   	cld    
  800d2f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d31:	5e                   	pop    %esi
  800d32:	5f                   	pop    %edi
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d35:	f3 0f 1e fb          	endbr32 
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d3f:	ff 75 10             	pushl  0x10(%ebp)
  800d42:	ff 75 0c             	pushl  0xc(%ebp)
  800d45:	ff 75 08             	pushl  0x8(%ebp)
  800d48:	e8 82 ff ff ff       	call   800ccf <memmove>
}
  800d4d:	c9                   	leave  
  800d4e:	c3                   	ret    

00800d4f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d4f:	f3 0f 1e fb          	endbr32 
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	56                   	push   %esi
  800d57:	53                   	push   %ebx
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d5e:	89 c6                	mov    %eax,%esi
  800d60:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d63:	39 f0                	cmp    %esi,%eax
  800d65:	74 1c                	je     800d83 <memcmp+0x34>
		if (*s1 != *s2)
  800d67:	0f b6 08             	movzbl (%eax),%ecx
  800d6a:	0f b6 1a             	movzbl (%edx),%ebx
  800d6d:	38 d9                	cmp    %bl,%cl
  800d6f:	75 08                	jne    800d79 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d71:	83 c0 01             	add    $0x1,%eax
  800d74:	83 c2 01             	add    $0x1,%edx
  800d77:	eb ea                	jmp    800d63 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800d79:	0f b6 c1             	movzbl %cl,%eax
  800d7c:	0f b6 db             	movzbl %bl,%ebx
  800d7f:	29 d8                	sub    %ebx,%eax
  800d81:	eb 05                	jmp    800d88 <memcmp+0x39>
	}

	return 0;
  800d83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    

00800d8c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d8c:	f3 0f 1e fb          	endbr32 
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d99:	89 c2                	mov    %eax,%edx
  800d9b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d9e:	39 d0                	cmp    %edx,%eax
  800da0:	73 09                	jae    800dab <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800da2:	38 08                	cmp    %cl,(%eax)
  800da4:	74 05                	je     800dab <memfind+0x1f>
	for (; s < ends; s++)
  800da6:	83 c0 01             	add    $0x1,%eax
  800da9:	eb f3                	jmp    800d9e <memfind+0x12>
			break;
	return (void *) s;
}
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    

00800dad <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dad:	f3 0f 1e fb          	endbr32 
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	57                   	push   %edi
  800db5:	56                   	push   %esi
  800db6:	53                   	push   %ebx
  800db7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dba:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dbd:	eb 03                	jmp    800dc2 <strtol+0x15>
		s++;
  800dbf:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800dc2:	0f b6 01             	movzbl (%ecx),%eax
  800dc5:	3c 20                	cmp    $0x20,%al
  800dc7:	74 f6                	je     800dbf <strtol+0x12>
  800dc9:	3c 09                	cmp    $0x9,%al
  800dcb:	74 f2                	je     800dbf <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800dcd:	3c 2b                	cmp    $0x2b,%al
  800dcf:	74 2a                	je     800dfb <strtol+0x4e>
	int neg = 0;
  800dd1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800dd6:	3c 2d                	cmp    $0x2d,%al
  800dd8:	74 2b                	je     800e05 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dda:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800de0:	75 0f                	jne    800df1 <strtol+0x44>
  800de2:	80 39 30             	cmpb   $0x30,(%ecx)
  800de5:	74 28                	je     800e0f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800de7:	85 db                	test   %ebx,%ebx
  800de9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dee:	0f 44 d8             	cmove  %eax,%ebx
  800df1:	b8 00 00 00 00       	mov    $0x0,%eax
  800df6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800df9:	eb 46                	jmp    800e41 <strtol+0x94>
		s++;
  800dfb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800dfe:	bf 00 00 00 00       	mov    $0x0,%edi
  800e03:	eb d5                	jmp    800dda <strtol+0x2d>
		s++, neg = 1;
  800e05:	83 c1 01             	add    $0x1,%ecx
  800e08:	bf 01 00 00 00       	mov    $0x1,%edi
  800e0d:	eb cb                	jmp    800dda <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e0f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e13:	74 0e                	je     800e23 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800e15:	85 db                	test   %ebx,%ebx
  800e17:	75 d8                	jne    800df1 <strtol+0x44>
		s++, base = 8;
  800e19:	83 c1 01             	add    $0x1,%ecx
  800e1c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e21:	eb ce                	jmp    800df1 <strtol+0x44>
		s += 2, base = 16;
  800e23:	83 c1 02             	add    $0x2,%ecx
  800e26:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e2b:	eb c4                	jmp    800df1 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800e2d:	0f be d2             	movsbl %dl,%edx
  800e30:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e33:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e36:	7d 3a                	jge    800e72 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800e38:	83 c1 01             	add    $0x1,%ecx
  800e3b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e3f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e41:	0f b6 11             	movzbl (%ecx),%edx
  800e44:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e47:	89 f3                	mov    %esi,%ebx
  800e49:	80 fb 09             	cmp    $0x9,%bl
  800e4c:	76 df                	jbe    800e2d <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800e4e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e51:	89 f3                	mov    %esi,%ebx
  800e53:	80 fb 19             	cmp    $0x19,%bl
  800e56:	77 08                	ja     800e60 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800e58:	0f be d2             	movsbl %dl,%edx
  800e5b:	83 ea 57             	sub    $0x57,%edx
  800e5e:	eb d3                	jmp    800e33 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800e60:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e63:	89 f3                	mov    %esi,%ebx
  800e65:	80 fb 19             	cmp    $0x19,%bl
  800e68:	77 08                	ja     800e72 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800e6a:	0f be d2             	movsbl %dl,%edx
  800e6d:	83 ea 37             	sub    $0x37,%edx
  800e70:	eb c1                	jmp    800e33 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e76:	74 05                	je     800e7d <strtol+0xd0>
		*endptr = (char *) s;
  800e78:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e7b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e7d:	89 c2                	mov    %eax,%edx
  800e7f:	f7 da                	neg    %edx
  800e81:	85 ff                	test   %edi,%edi
  800e83:	0f 45 c2             	cmovne %edx,%eax
}
  800e86:	5b                   	pop    %ebx
  800e87:	5e                   	pop    %esi
  800e88:	5f                   	pop    %edi
  800e89:	5d                   	pop    %ebp
  800e8a:	c3                   	ret    

00800e8b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e8b:	f3 0f 1e fb          	endbr32 
  800e8f:	55                   	push   %ebp
  800e90:	89 e5                	mov    %esp,%ebp
  800e92:	57                   	push   %edi
  800e93:	56                   	push   %esi
  800e94:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e95:	b8 00 00 00 00       	mov    $0x0,%eax
  800e9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea0:	89 c3                	mov    %eax,%ebx
  800ea2:	89 c7                	mov    %eax,%edi
  800ea4:	89 c6                	mov    %eax,%esi
  800ea6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ea8:	5b                   	pop    %ebx
  800ea9:	5e                   	pop    %esi
  800eaa:	5f                   	pop    %edi
  800eab:	5d                   	pop    %ebp
  800eac:	c3                   	ret    

00800ead <sys_cgetc>:

int
sys_cgetc(void)
{
  800ead:	f3 0f 1e fb          	endbr32 
  800eb1:	55                   	push   %ebp
  800eb2:	89 e5                	mov    %esp,%ebp
  800eb4:	57                   	push   %edi
  800eb5:	56                   	push   %esi
  800eb6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb7:	ba 00 00 00 00       	mov    $0x0,%edx
  800ebc:	b8 01 00 00 00       	mov    $0x1,%eax
  800ec1:	89 d1                	mov    %edx,%ecx
  800ec3:	89 d3                	mov    %edx,%ebx
  800ec5:	89 d7                	mov    %edx,%edi
  800ec7:	89 d6                	mov    %edx,%esi
  800ec9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ecb:	5b                   	pop    %ebx
  800ecc:	5e                   	pop    %esi
  800ecd:	5f                   	pop    %edi
  800ece:	5d                   	pop    %ebp
  800ecf:	c3                   	ret    

00800ed0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ed0:	f3 0f 1e fb          	endbr32 
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
  800ed7:	57                   	push   %edi
  800ed8:	56                   	push   %esi
  800ed9:	53                   	push   %ebx
  800eda:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800edd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee5:	b8 03 00 00 00       	mov    $0x3,%eax
  800eea:	89 cb                	mov    %ecx,%ebx
  800eec:	89 cf                	mov    %ecx,%edi
  800eee:	89 ce                	mov    %ecx,%esi
  800ef0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef2:	85 c0                	test   %eax,%eax
  800ef4:	7f 08                	jg     800efe <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ef6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef9:	5b                   	pop    %ebx
  800efa:	5e                   	pop    %esi
  800efb:	5f                   	pop    %edi
  800efc:	5d                   	pop    %ebp
  800efd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efe:	83 ec 0c             	sub    $0xc,%esp
  800f01:	50                   	push   %eax
  800f02:	6a 03                	push   $0x3
  800f04:	68 bf 2b 80 00       	push   $0x802bbf
  800f09:	6a 23                	push   $0x23
  800f0b:	68 dc 2b 80 00       	push   $0x802bdc
  800f10:	e8 13 f5 ff ff       	call   800428 <_panic>

00800f15 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f15:	f3 0f 1e fb          	endbr32 
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	57                   	push   %edi
  800f1d:	56                   	push   %esi
  800f1e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f24:	b8 02 00 00 00       	mov    $0x2,%eax
  800f29:	89 d1                	mov    %edx,%ecx
  800f2b:	89 d3                	mov    %edx,%ebx
  800f2d:	89 d7                	mov    %edx,%edi
  800f2f:	89 d6                	mov    %edx,%esi
  800f31:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f33:	5b                   	pop    %ebx
  800f34:	5e                   	pop    %esi
  800f35:	5f                   	pop    %edi
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    

00800f38 <sys_yield>:

void
sys_yield(void)
{
  800f38:	f3 0f 1e fb          	endbr32 
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	57                   	push   %edi
  800f40:	56                   	push   %esi
  800f41:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f42:	ba 00 00 00 00       	mov    $0x0,%edx
  800f47:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f4c:	89 d1                	mov    %edx,%ecx
  800f4e:	89 d3                	mov    %edx,%ebx
  800f50:	89 d7                	mov    %edx,%edi
  800f52:	89 d6                	mov    %edx,%esi
  800f54:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f56:	5b                   	pop    %ebx
  800f57:	5e                   	pop    %esi
  800f58:	5f                   	pop    %edi
  800f59:	5d                   	pop    %ebp
  800f5a:	c3                   	ret    

00800f5b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f5b:	f3 0f 1e fb          	endbr32 
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	57                   	push   %edi
  800f63:	56                   	push   %esi
  800f64:	53                   	push   %ebx
  800f65:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f68:	be 00 00 00 00       	mov    $0x0,%esi
  800f6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f73:	b8 04 00 00 00       	mov    $0x4,%eax
  800f78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7b:	89 f7                	mov    %esi,%edi
  800f7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7f:	85 c0                	test   %eax,%eax
  800f81:	7f 08                	jg     800f8b <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f86:	5b                   	pop    %ebx
  800f87:	5e                   	pop    %esi
  800f88:	5f                   	pop    %edi
  800f89:	5d                   	pop    %ebp
  800f8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8b:	83 ec 0c             	sub    $0xc,%esp
  800f8e:	50                   	push   %eax
  800f8f:	6a 04                	push   $0x4
  800f91:	68 bf 2b 80 00       	push   $0x802bbf
  800f96:	6a 23                	push   $0x23
  800f98:	68 dc 2b 80 00       	push   $0x802bdc
  800f9d:	e8 86 f4 ff ff       	call   800428 <_panic>

00800fa2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fa2:	f3 0f 1e fb          	endbr32 
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	57                   	push   %edi
  800faa:	56                   	push   %esi
  800fab:	53                   	push   %ebx
  800fac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800faf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb5:	b8 05 00 00 00       	mov    $0x5,%eax
  800fba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fbd:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fc0:	8b 75 18             	mov    0x18(%ebp),%esi
  800fc3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc5:	85 c0                	test   %eax,%eax
  800fc7:	7f 08                	jg     800fd1 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fcc:	5b                   	pop    %ebx
  800fcd:	5e                   	pop    %esi
  800fce:	5f                   	pop    %edi
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd1:	83 ec 0c             	sub    $0xc,%esp
  800fd4:	50                   	push   %eax
  800fd5:	6a 05                	push   $0x5
  800fd7:	68 bf 2b 80 00       	push   $0x802bbf
  800fdc:	6a 23                	push   $0x23
  800fde:	68 dc 2b 80 00       	push   $0x802bdc
  800fe3:	e8 40 f4 ff ff       	call   800428 <_panic>

00800fe8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800fe8:	f3 0f 1e fb          	endbr32 
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	57                   	push   %edi
  800ff0:	56                   	push   %esi
  800ff1:	53                   	push   %ebx
  800ff2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ffa:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801000:	b8 06 00 00 00       	mov    $0x6,%eax
  801005:	89 df                	mov    %ebx,%edi
  801007:	89 de                	mov    %ebx,%esi
  801009:	cd 30                	int    $0x30
	if(check && ret > 0)
  80100b:	85 c0                	test   %eax,%eax
  80100d:	7f 08                	jg     801017 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80100f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801012:	5b                   	pop    %ebx
  801013:	5e                   	pop    %esi
  801014:	5f                   	pop    %edi
  801015:	5d                   	pop    %ebp
  801016:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801017:	83 ec 0c             	sub    $0xc,%esp
  80101a:	50                   	push   %eax
  80101b:	6a 06                	push   $0x6
  80101d:	68 bf 2b 80 00       	push   $0x802bbf
  801022:	6a 23                	push   $0x23
  801024:	68 dc 2b 80 00       	push   $0x802bdc
  801029:	e8 fa f3 ff ff       	call   800428 <_panic>

0080102e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80102e:	f3 0f 1e fb          	endbr32 
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	57                   	push   %edi
  801036:	56                   	push   %esi
  801037:	53                   	push   %ebx
  801038:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80103b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801040:	8b 55 08             	mov    0x8(%ebp),%edx
  801043:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801046:	b8 08 00 00 00       	mov    $0x8,%eax
  80104b:	89 df                	mov    %ebx,%edi
  80104d:	89 de                	mov    %ebx,%esi
  80104f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801051:	85 c0                	test   %eax,%eax
  801053:	7f 08                	jg     80105d <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801055:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801058:	5b                   	pop    %ebx
  801059:	5e                   	pop    %esi
  80105a:	5f                   	pop    %edi
  80105b:	5d                   	pop    %ebp
  80105c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80105d:	83 ec 0c             	sub    $0xc,%esp
  801060:	50                   	push   %eax
  801061:	6a 08                	push   $0x8
  801063:	68 bf 2b 80 00       	push   $0x802bbf
  801068:	6a 23                	push   $0x23
  80106a:	68 dc 2b 80 00       	push   $0x802bdc
  80106f:	e8 b4 f3 ff ff       	call   800428 <_panic>

00801074 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801074:	f3 0f 1e fb          	endbr32 
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	57                   	push   %edi
  80107c:	56                   	push   %esi
  80107d:	53                   	push   %ebx
  80107e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801081:	bb 00 00 00 00       	mov    $0x0,%ebx
  801086:	8b 55 08             	mov    0x8(%ebp),%edx
  801089:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108c:	b8 09 00 00 00       	mov    $0x9,%eax
  801091:	89 df                	mov    %ebx,%edi
  801093:	89 de                	mov    %ebx,%esi
  801095:	cd 30                	int    $0x30
	if(check && ret > 0)
  801097:	85 c0                	test   %eax,%eax
  801099:	7f 08                	jg     8010a3 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80109b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80109e:	5b                   	pop    %ebx
  80109f:	5e                   	pop    %esi
  8010a0:	5f                   	pop    %edi
  8010a1:	5d                   	pop    %ebp
  8010a2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a3:	83 ec 0c             	sub    $0xc,%esp
  8010a6:	50                   	push   %eax
  8010a7:	6a 09                	push   $0x9
  8010a9:	68 bf 2b 80 00       	push   $0x802bbf
  8010ae:	6a 23                	push   $0x23
  8010b0:	68 dc 2b 80 00       	push   $0x802bdc
  8010b5:	e8 6e f3 ff ff       	call   800428 <_panic>

008010ba <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010ba:	f3 0f 1e fb          	endbr32 
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
  8010c1:	57                   	push   %edi
  8010c2:	56                   	push   %esi
  8010c3:	53                   	push   %ebx
  8010c4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010d7:	89 df                	mov    %ebx,%edi
  8010d9:	89 de                	mov    %ebx,%esi
  8010db:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	7f 08                	jg     8010e9 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010e4:	5b                   	pop    %ebx
  8010e5:	5e                   	pop    %esi
  8010e6:	5f                   	pop    %edi
  8010e7:	5d                   	pop    %ebp
  8010e8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e9:	83 ec 0c             	sub    $0xc,%esp
  8010ec:	50                   	push   %eax
  8010ed:	6a 0a                	push   $0xa
  8010ef:	68 bf 2b 80 00       	push   $0x802bbf
  8010f4:	6a 23                	push   $0x23
  8010f6:	68 dc 2b 80 00       	push   $0x802bdc
  8010fb:	e8 28 f3 ff ff       	call   800428 <_panic>

00801100 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801100:	f3 0f 1e fb          	endbr32 
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	57                   	push   %edi
  801108:	56                   	push   %esi
  801109:	53                   	push   %ebx
	asm volatile("int %1\n"
  80110a:	8b 55 08             	mov    0x8(%ebp),%edx
  80110d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801110:	b8 0c 00 00 00       	mov    $0xc,%eax
  801115:	be 00 00 00 00       	mov    $0x0,%esi
  80111a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80111d:	8b 7d 14             	mov    0x14(%ebp),%edi
  801120:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801122:	5b                   	pop    %ebx
  801123:	5e                   	pop    %esi
  801124:	5f                   	pop    %edi
  801125:	5d                   	pop    %ebp
  801126:	c3                   	ret    

00801127 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801127:	f3 0f 1e fb          	endbr32 
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	57                   	push   %edi
  80112f:	56                   	push   %esi
  801130:	53                   	push   %ebx
  801131:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801134:	b9 00 00 00 00       	mov    $0x0,%ecx
  801139:	8b 55 08             	mov    0x8(%ebp),%edx
  80113c:	b8 0d 00 00 00       	mov    $0xd,%eax
  801141:	89 cb                	mov    %ecx,%ebx
  801143:	89 cf                	mov    %ecx,%edi
  801145:	89 ce                	mov    %ecx,%esi
  801147:	cd 30                	int    $0x30
	if(check && ret > 0)
  801149:	85 c0                	test   %eax,%eax
  80114b:	7f 08                	jg     801155 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80114d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801150:	5b                   	pop    %ebx
  801151:	5e                   	pop    %esi
  801152:	5f                   	pop    %edi
  801153:	5d                   	pop    %ebp
  801154:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801155:	83 ec 0c             	sub    $0xc,%esp
  801158:	50                   	push   %eax
  801159:	6a 0d                	push   $0xd
  80115b:	68 bf 2b 80 00       	push   $0x802bbf
  801160:	6a 23                	push   $0x23
  801162:	68 dc 2b 80 00       	push   $0x802bdc
  801167:	e8 bc f2 ff ff       	call   800428 <_panic>

0080116c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80116c:	f3 0f 1e fb          	endbr32 
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	05 00 00 00 30       	add    $0x30000000,%eax
  80117b:	c1 e8 0c             	shr    $0xc,%eax
}
  80117e:	5d                   	pop    %ebp
  80117f:	c3                   	ret    

00801180 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801180:	f3 0f 1e fb          	endbr32 
  801184:	55                   	push   %ebp
  801185:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80118f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801194:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801199:	5d                   	pop    %ebp
  80119a:	c3                   	ret    

0080119b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80119b:	f3 0f 1e fb          	endbr32 
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
  8011a2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011a7:	89 c2                	mov    %eax,%edx
  8011a9:	c1 ea 16             	shr    $0x16,%edx
  8011ac:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011b3:	f6 c2 01             	test   $0x1,%dl
  8011b6:	74 2d                	je     8011e5 <fd_alloc+0x4a>
  8011b8:	89 c2                	mov    %eax,%edx
  8011ba:	c1 ea 0c             	shr    $0xc,%edx
  8011bd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011c4:	f6 c2 01             	test   $0x1,%dl
  8011c7:	74 1c                	je     8011e5 <fd_alloc+0x4a>
  8011c9:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011ce:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011d3:	75 d2                	jne    8011a7 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011de:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011e3:	eb 0a                	jmp    8011ef <fd_alloc+0x54>
			*fd_store = fd;
  8011e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ef:	5d                   	pop    %ebp
  8011f0:	c3                   	ret    

008011f1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011f1:	f3 0f 1e fb          	endbr32 
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011fb:	83 f8 1f             	cmp    $0x1f,%eax
  8011fe:	77 30                	ja     801230 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801200:	c1 e0 0c             	shl    $0xc,%eax
  801203:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801208:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80120e:	f6 c2 01             	test   $0x1,%dl
  801211:	74 24                	je     801237 <fd_lookup+0x46>
  801213:	89 c2                	mov    %eax,%edx
  801215:	c1 ea 0c             	shr    $0xc,%edx
  801218:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80121f:	f6 c2 01             	test   $0x1,%dl
  801222:	74 1a                	je     80123e <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801224:	8b 55 0c             	mov    0xc(%ebp),%edx
  801227:	89 02                	mov    %eax,(%edx)
	return 0;
  801229:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80122e:	5d                   	pop    %ebp
  80122f:	c3                   	ret    
		return -E_INVAL;
  801230:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801235:	eb f7                	jmp    80122e <fd_lookup+0x3d>
		return -E_INVAL;
  801237:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80123c:	eb f0                	jmp    80122e <fd_lookup+0x3d>
  80123e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801243:	eb e9                	jmp    80122e <fd_lookup+0x3d>

00801245 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801245:	f3 0f 1e fb          	endbr32 
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 08             	sub    $0x8,%esp
  80124f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801252:	ba 68 2c 80 00       	mov    $0x802c68,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801257:	b8 90 47 80 00       	mov    $0x804790,%eax
		if (devtab[i]->dev_id == dev_id) {
  80125c:	39 08                	cmp    %ecx,(%eax)
  80125e:	74 33                	je     801293 <dev_lookup+0x4e>
  801260:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801263:	8b 02                	mov    (%edx),%eax
  801265:	85 c0                	test   %eax,%eax
  801267:	75 f3                	jne    80125c <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801269:	a1 90 67 80 00       	mov    0x806790,%eax
  80126e:	8b 40 48             	mov    0x48(%eax),%eax
  801271:	83 ec 04             	sub    $0x4,%esp
  801274:	51                   	push   %ecx
  801275:	50                   	push   %eax
  801276:	68 ec 2b 80 00       	push   $0x802bec
  80127b:	e8 8f f2 ff ff       	call   80050f <cprintf>
	*dev = 0;
  801280:	8b 45 0c             	mov    0xc(%ebp),%eax
  801283:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801289:	83 c4 10             	add    $0x10,%esp
  80128c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801291:	c9                   	leave  
  801292:	c3                   	ret    
			*dev = devtab[i];
  801293:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801296:	89 01                	mov    %eax,(%ecx)
			return 0;
  801298:	b8 00 00 00 00       	mov    $0x0,%eax
  80129d:	eb f2                	jmp    801291 <dev_lookup+0x4c>

0080129f <fd_close>:
{
  80129f:	f3 0f 1e fb          	endbr32 
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	57                   	push   %edi
  8012a7:	56                   	push   %esi
  8012a8:	53                   	push   %ebx
  8012a9:	83 ec 24             	sub    $0x24,%esp
  8012ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8012af:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012b5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012b6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012bc:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012bf:	50                   	push   %eax
  8012c0:	e8 2c ff ff ff       	call   8011f1 <fd_lookup>
  8012c5:	89 c3                	mov    %eax,%ebx
  8012c7:	83 c4 10             	add    $0x10,%esp
  8012ca:	85 c0                	test   %eax,%eax
  8012cc:	78 05                	js     8012d3 <fd_close+0x34>
	    || fd != fd2)
  8012ce:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012d1:	74 16                	je     8012e9 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8012d3:	89 f8                	mov    %edi,%eax
  8012d5:	84 c0                	test   %al,%al
  8012d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012dc:	0f 44 d8             	cmove  %eax,%ebx
}
  8012df:	89 d8                	mov    %ebx,%eax
  8012e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e4:	5b                   	pop    %ebx
  8012e5:	5e                   	pop    %esi
  8012e6:	5f                   	pop    %edi
  8012e7:	5d                   	pop    %ebp
  8012e8:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012e9:	83 ec 08             	sub    $0x8,%esp
  8012ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012ef:	50                   	push   %eax
  8012f0:	ff 36                	pushl  (%esi)
  8012f2:	e8 4e ff ff ff       	call   801245 <dev_lookup>
  8012f7:	89 c3                	mov    %eax,%ebx
  8012f9:	83 c4 10             	add    $0x10,%esp
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	78 1a                	js     80131a <fd_close+0x7b>
		if (dev->dev_close)
  801300:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801303:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801306:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80130b:	85 c0                	test   %eax,%eax
  80130d:	74 0b                	je     80131a <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80130f:	83 ec 0c             	sub    $0xc,%esp
  801312:	56                   	push   %esi
  801313:	ff d0                	call   *%eax
  801315:	89 c3                	mov    %eax,%ebx
  801317:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80131a:	83 ec 08             	sub    $0x8,%esp
  80131d:	56                   	push   %esi
  80131e:	6a 00                	push   $0x0
  801320:	e8 c3 fc ff ff       	call   800fe8 <sys_page_unmap>
	return r;
  801325:	83 c4 10             	add    $0x10,%esp
  801328:	eb b5                	jmp    8012df <fd_close+0x40>

0080132a <close>:

int
close(int fdnum)
{
  80132a:	f3 0f 1e fb          	endbr32 
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
  801331:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801334:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801337:	50                   	push   %eax
  801338:	ff 75 08             	pushl  0x8(%ebp)
  80133b:	e8 b1 fe ff ff       	call   8011f1 <fd_lookup>
  801340:	83 c4 10             	add    $0x10,%esp
  801343:	85 c0                	test   %eax,%eax
  801345:	79 02                	jns    801349 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801347:	c9                   	leave  
  801348:	c3                   	ret    
		return fd_close(fd, 1);
  801349:	83 ec 08             	sub    $0x8,%esp
  80134c:	6a 01                	push   $0x1
  80134e:	ff 75 f4             	pushl  -0xc(%ebp)
  801351:	e8 49 ff ff ff       	call   80129f <fd_close>
  801356:	83 c4 10             	add    $0x10,%esp
  801359:	eb ec                	jmp    801347 <close+0x1d>

0080135b <close_all>:

void
close_all(void)
{
  80135b:	f3 0f 1e fb          	endbr32 
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
  801362:	53                   	push   %ebx
  801363:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801366:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80136b:	83 ec 0c             	sub    $0xc,%esp
  80136e:	53                   	push   %ebx
  80136f:	e8 b6 ff ff ff       	call   80132a <close>
	for (i = 0; i < MAXFD; i++)
  801374:	83 c3 01             	add    $0x1,%ebx
  801377:	83 c4 10             	add    $0x10,%esp
  80137a:	83 fb 20             	cmp    $0x20,%ebx
  80137d:	75 ec                	jne    80136b <close_all+0x10>
}
  80137f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801384:	f3 0f 1e fb          	endbr32 
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
  80138b:	57                   	push   %edi
  80138c:	56                   	push   %esi
  80138d:	53                   	push   %ebx
  80138e:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801391:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801394:	50                   	push   %eax
  801395:	ff 75 08             	pushl  0x8(%ebp)
  801398:	e8 54 fe ff ff       	call   8011f1 <fd_lookup>
  80139d:	89 c3                	mov    %eax,%ebx
  80139f:	83 c4 10             	add    $0x10,%esp
  8013a2:	85 c0                	test   %eax,%eax
  8013a4:	0f 88 81 00 00 00    	js     80142b <dup+0xa7>
		return r;
	close(newfdnum);
  8013aa:	83 ec 0c             	sub    $0xc,%esp
  8013ad:	ff 75 0c             	pushl  0xc(%ebp)
  8013b0:	e8 75 ff ff ff       	call   80132a <close>

	newfd = INDEX2FD(newfdnum);
  8013b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013b8:	c1 e6 0c             	shl    $0xc,%esi
  8013bb:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013c1:	83 c4 04             	add    $0x4,%esp
  8013c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013c7:	e8 b4 fd ff ff       	call   801180 <fd2data>
  8013cc:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013ce:	89 34 24             	mov    %esi,(%esp)
  8013d1:	e8 aa fd ff ff       	call   801180 <fd2data>
  8013d6:	83 c4 10             	add    $0x10,%esp
  8013d9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013db:	89 d8                	mov    %ebx,%eax
  8013dd:	c1 e8 16             	shr    $0x16,%eax
  8013e0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013e7:	a8 01                	test   $0x1,%al
  8013e9:	74 11                	je     8013fc <dup+0x78>
  8013eb:	89 d8                	mov    %ebx,%eax
  8013ed:	c1 e8 0c             	shr    $0xc,%eax
  8013f0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013f7:	f6 c2 01             	test   $0x1,%dl
  8013fa:	75 39                	jne    801435 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013ff:	89 d0                	mov    %edx,%eax
  801401:	c1 e8 0c             	shr    $0xc,%eax
  801404:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80140b:	83 ec 0c             	sub    $0xc,%esp
  80140e:	25 07 0e 00 00       	and    $0xe07,%eax
  801413:	50                   	push   %eax
  801414:	56                   	push   %esi
  801415:	6a 00                	push   $0x0
  801417:	52                   	push   %edx
  801418:	6a 00                	push   $0x0
  80141a:	e8 83 fb ff ff       	call   800fa2 <sys_page_map>
  80141f:	89 c3                	mov    %eax,%ebx
  801421:	83 c4 20             	add    $0x20,%esp
  801424:	85 c0                	test   %eax,%eax
  801426:	78 31                	js     801459 <dup+0xd5>
		goto err;

	return newfdnum;
  801428:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80142b:	89 d8                	mov    %ebx,%eax
  80142d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801430:	5b                   	pop    %ebx
  801431:	5e                   	pop    %esi
  801432:	5f                   	pop    %edi
  801433:	5d                   	pop    %ebp
  801434:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801435:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80143c:	83 ec 0c             	sub    $0xc,%esp
  80143f:	25 07 0e 00 00       	and    $0xe07,%eax
  801444:	50                   	push   %eax
  801445:	57                   	push   %edi
  801446:	6a 00                	push   $0x0
  801448:	53                   	push   %ebx
  801449:	6a 00                	push   $0x0
  80144b:	e8 52 fb ff ff       	call   800fa2 <sys_page_map>
  801450:	89 c3                	mov    %eax,%ebx
  801452:	83 c4 20             	add    $0x20,%esp
  801455:	85 c0                	test   %eax,%eax
  801457:	79 a3                	jns    8013fc <dup+0x78>
	sys_page_unmap(0, newfd);
  801459:	83 ec 08             	sub    $0x8,%esp
  80145c:	56                   	push   %esi
  80145d:	6a 00                	push   $0x0
  80145f:	e8 84 fb ff ff       	call   800fe8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801464:	83 c4 08             	add    $0x8,%esp
  801467:	57                   	push   %edi
  801468:	6a 00                	push   $0x0
  80146a:	e8 79 fb ff ff       	call   800fe8 <sys_page_unmap>
	return r;
  80146f:	83 c4 10             	add    $0x10,%esp
  801472:	eb b7                	jmp    80142b <dup+0xa7>

00801474 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801474:	f3 0f 1e fb          	endbr32 
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
  80147b:	53                   	push   %ebx
  80147c:	83 ec 1c             	sub    $0x1c,%esp
  80147f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801482:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801485:	50                   	push   %eax
  801486:	53                   	push   %ebx
  801487:	e8 65 fd ff ff       	call   8011f1 <fd_lookup>
  80148c:	83 c4 10             	add    $0x10,%esp
  80148f:	85 c0                	test   %eax,%eax
  801491:	78 3f                	js     8014d2 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801493:	83 ec 08             	sub    $0x8,%esp
  801496:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801499:	50                   	push   %eax
  80149a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149d:	ff 30                	pushl  (%eax)
  80149f:	e8 a1 fd ff ff       	call   801245 <dev_lookup>
  8014a4:	83 c4 10             	add    $0x10,%esp
  8014a7:	85 c0                	test   %eax,%eax
  8014a9:	78 27                	js     8014d2 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014ae:	8b 42 08             	mov    0x8(%edx),%eax
  8014b1:	83 e0 03             	and    $0x3,%eax
  8014b4:	83 f8 01             	cmp    $0x1,%eax
  8014b7:	74 1e                	je     8014d7 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bc:	8b 40 08             	mov    0x8(%eax),%eax
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	74 35                	je     8014f8 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014c3:	83 ec 04             	sub    $0x4,%esp
  8014c6:	ff 75 10             	pushl  0x10(%ebp)
  8014c9:	ff 75 0c             	pushl  0xc(%ebp)
  8014cc:	52                   	push   %edx
  8014cd:	ff d0                	call   *%eax
  8014cf:	83 c4 10             	add    $0x10,%esp
}
  8014d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014d7:	a1 90 67 80 00       	mov    0x806790,%eax
  8014dc:	8b 40 48             	mov    0x48(%eax),%eax
  8014df:	83 ec 04             	sub    $0x4,%esp
  8014e2:	53                   	push   %ebx
  8014e3:	50                   	push   %eax
  8014e4:	68 2d 2c 80 00       	push   $0x802c2d
  8014e9:	e8 21 f0 ff ff       	call   80050f <cprintf>
		return -E_INVAL;
  8014ee:	83 c4 10             	add    $0x10,%esp
  8014f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f6:	eb da                	jmp    8014d2 <read+0x5e>
		return -E_NOT_SUPP;
  8014f8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014fd:	eb d3                	jmp    8014d2 <read+0x5e>

008014ff <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014ff:	f3 0f 1e fb          	endbr32 
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	57                   	push   %edi
  801507:	56                   	push   %esi
  801508:	53                   	push   %ebx
  801509:	83 ec 0c             	sub    $0xc,%esp
  80150c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80150f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801512:	bb 00 00 00 00       	mov    $0x0,%ebx
  801517:	eb 02                	jmp    80151b <readn+0x1c>
  801519:	01 c3                	add    %eax,%ebx
  80151b:	39 f3                	cmp    %esi,%ebx
  80151d:	73 21                	jae    801540 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80151f:	83 ec 04             	sub    $0x4,%esp
  801522:	89 f0                	mov    %esi,%eax
  801524:	29 d8                	sub    %ebx,%eax
  801526:	50                   	push   %eax
  801527:	89 d8                	mov    %ebx,%eax
  801529:	03 45 0c             	add    0xc(%ebp),%eax
  80152c:	50                   	push   %eax
  80152d:	57                   	push   %edi
  80152e:	e8 41 ff ff ff       	call   801474 <read>
		if (m < 0)
  801533:	83 c4 10             	add    $0x10,%esp
  801536:	85 c0                	test   %eax,%eax
  801538:	78 04                	js     80153e <readn+0x3f>
			return m;
		if (m == 0)
  80153a:	75 dd                	jne    801519 <readn+0x1a>
  80153c:	eb 02                	jmp    801540 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80153e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801540:	89 d8                	mov    %ebx,%eax
  801542:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801545:	5b                   	pop    %ebx
  801546:	5e                   	pop    %esi
  801547:	5f                   	pop    %edi
  801548:	5d                   	pop    %ebp
  801549:	c3                   	ret    

0080154a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80154a:	f3 0f 1e fb          	endbr32 
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	53                   	push   %ebx
  801552:	83 ec 1c             	sub    $0x1c,%esp
  801555:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801558:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80155b:	50                   	push   %eax
  80155c:	53                   	push   %ebx
  80155d:	e8 8f fc ff ff       	call   8011f1 <fd_lookup>
  801562:	83 c4 10             	add    $0x10,%esp
  801565:	85 c0                	test   %eax,%eax
  801567:	78 3a                	js     8015a3 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801569:	83 ec 08             	sub    $0x8,%esp
  80156c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80156f:	50                   	push   %eax
  801570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801573:	ff 30                	pushl  (%eax)
  801575:	e8 cb fc ff ff       	call   801245 <dev_lookup>
  80157a:	83 c4 10             	add    $0x10,%esp
  80157d:	85 c0                	test   %eax,%eax
  80157f:	78 22                	js     8015a3 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801581:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801584:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801588:	74 1e                	je     8015a8 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80158a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158d:	8b 52 0c             	mov    0xc(%edx),%edx
  801590:	85 d2                	test   %edx,%edx
  801592:	74 35                	je     8015c9 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801594:	83 ec 04             	sub    $0x4,%esp
  801597:	ff 75 10             	pushl  0x10(%ebp)
  80159a:	ff 75 0c             	pushl  0xc(%ebp)
  80159d:	50                   	push   %eax
  80159e:	ff d2                	call   *%edx
  8015a0:	83 c4 10             	add    $0x10,%esp
}
  8015a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015a8:	a1 90 67 80 00       	mov    0x806790,%eax
  8015ad:	8b 40 48             	mov    0x48(%eax),%eax
  8015b0:	83 ec 04             	sub    $0x4,%esp
  8015b3:	53                   	push   %ebx
  8015b4:	50                   	push   %eax
  8015b5:	68 49 2c 80 00       	push   $0x802c49
  8015ba:	e8 50 ef ff ff       	call   80050f <cprintf>
		return -E_INVAL;
  8015bf:	83 c4 10             	add    $0x10,%esp
  8015c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015c7:	eb da                	jmp    8015a3 <write+0x59>
		return -E_NOT_SUPP;
  8015c9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ce:	eb d3                	jmp    8015a3 <write+0x59>

008015d0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015d0:	f3 0f 1e fb          	endbr32 
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
  8015d7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015dd:	50                   	push   %eax
  8015de:	ff 75 08             	pushl  0x8(%ebp)
  8015e1:	e8 0b fc ff ff       	call   8011f1 <fd_lookup>
  8015e6:	83 c4 10             	add    $0x10,%esp
  8015e9:	85 c0                	test   %eax,%eax
  8015eb:	78 0e                	js     8015fb <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8015ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f3:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    

008015fd <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015fd:	f3 0f 1e fb          	endbr32 
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	53                   	push   %ebx
  801605:	83 ec 1c             	sub    $0x1c,%esp
  801608:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80160b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80160e:	50                   	push   %eax
  80160f:	53                   	push   %ebx
  801610:	e8 dc fb ff ff       	call   8011f1 <fd_lookup>
  801615:	83 c4 10             	add    $0x10,%esp
  801618:	85 c0                	test   %eax,%eax
  80161a:	78 37                	js     801653 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80161c:	83 ec 08             	sub    $0x8,%esp
  80161f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801622:	50                   	push   %eax
  801623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801626:	ff 30                	pushl  (%eax)
  801628:	e8 18 fc ff ff       	call   801245 <dev_lookup>
  80162d:	83 c4 10             	add    $0x10,%esp
  801630:	85 c0                	test   %eax,%eax
  801632:	78 1f                	js     801653 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801637:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80163b:	74 1b                	je     801658 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80163d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801640:	8b 52 18             	mov    0x18(%edx),%edx
  801643:	85 d2                	test   %edx,%edx
  801645:	74 32                	je     801679 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801647:	83 ec 08             	sub    $0x8,%esp
  80164a:	ff 75 0c             	pushl  0xc(%ebp)
  80164d:	50                   	push   %eax
  80164e:	ff d2                	call   *%edx
  801650:	83 c4 10             	add    $0x10,%esp
}
  801653:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801656:	c9                   	leave  
  801657:	c3                   	ret    
			thisenv->env_id, fdnum);
  801658:	a1 90 67 80 00       	mov    0x806790,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80165d:	8b 40 48             	mov    0x48(%eax),%eax
  801660:	83 ec 04             	sub    $0x4,%esp
  801663:	53                   	push   %ebx
  801664:	50                   	push   %eax
  801665:	68 0c 2c 80 00       	push   $0x802c0c
  80166a:	e8 a0 ee ff ff       	call   80050f <cprintf>
		return -E_INVAL;
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801677:	eb da                	jmp    801653 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801679:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80167e:	eb d3                	jmp    801653 <ftruncate+0x56>

00801680 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801680:	f3 0f 1e fb          	endbr32 
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	53                   	push   %ebx
  801688:	83 ec 1c             	sub    $0x1c,%esp
  80168b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80168e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801691:	50                   	push   %eax
  801692:	ff 75 08             	pushl  0x8(%ebp)
  801695:	e8 57 fb ff ff       	call   8011f1 <fd_lookup>
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	85 c0                	test   %eax,%eax
  80169f:	78 4b                	js     8016ec <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a1:	83 ec 08             	sub    $0x8,%esp
  8016a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a7:	50                   	push   %eax
  8016a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ab:	ff 30                	pushl  (%eax)
  8016ad:	e8 93 fb ff ff       	call   801245 <dev_lookup>
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	85 c0                	test   %eax,%eax
  8016b7:	78 33                	js     8016ec <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8016b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bc:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016c0:	74 2f                	je     8016f1 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016c2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016c5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016cc:	00 00 00 
	stat->st_isdir = 0;
  8016cf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016d6:	00 00 00 
	stat->st_dev = dev;
  8016d9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016df:	83 ec 08             	sub    $0x8,%esp
  8016e2:	53                   	push   %ebx
  8016e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8016e6:	ff 50 14             	call   *0x14(%eax)
  8016e9:	83 c4 10             	add    $0x10,%esp
}
  8016ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    
		return -E_NOT_SUPP;
  8016f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016f6:	eb f4                	jmp    8016ec <fstat+0x6c>

008016f8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016f8:	f3 0f 1e fb          	endbr32 
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	56                   	push   %esi
  801700:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801701:	83 ec 08             	sub    $0x8,%esp
  801704:	6a 00                	push   $0x0
  801706:	ff 75 08             	pushl  0x8(%ebp)
  801709:	e8 fb 01 00 00       	call   801909 <open>
  80170e:	89 c3                	mov    %eax,%ebx
  801710:	83 c4 10             	add    $0x10,%esp
  801713:	85 c0                	test   %eax,%eax
  801715:	78 1b                	js     801732 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801717:	83 ec 08             	sub    $0x8,%esp
  80171a:	ff 75 0c             	pushl  0xc(%ebp)
  80171d:	50                   	push   %eax
  80171e:	e8 5d ff ff ff       	call   801680 <fstat>
  801723:	89 c6                	mov    %eax,%esi
	close(fd);
  801725:	89 1c 24             	mov    %ebx,(%esp)
  801728:	e8 fd fb ff ff       	call   80132a <close>
	return r;
  80172d:	83 c4 10             	add    $0x10,%esp
  801730:	89 f3                	mov    %esi,%ebx
}
  801732:	89 d8                	mov    %ebx,%eax
  801734:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801737:	5b                   	pop    %ebx
  801738:	5e                   	pop    %esi
  801739:	5d                   	pop    %ebp
  80173a:	c3                   	ret    

0080173b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	56                   	push   %esi
  80173f:	53                   	push   %ebx
  801740:	89 c6                	mov    %eax,%esi
  801742:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801744:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80174b:	74 27                	je     801774 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80174d:	6a 07                	push   $0x7
  80174f:	68 00 70 80 00       	push   $0x807000
  801754:	56                   	push   %esi
  801755:	ff 35 00 50 80 00    	pushl  0x805000
  80175b:	e8 a2 0c 00 00       	call   802402 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801760:	83 c4 0c             	add    $0xc,%esp
  801763:	6a 00                	push   $0x0
  801765:	53                   	push   %ebx
  801766:	6a 00                	push   $0x0
  801768:	e8 10 0c 00 00       	call   80237d <ipc_recv>
}
  80176d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801770:	5b                   	pop    %ebx
  801771:	5e                   	pop    %esi
  801772:	5d                   	pop    %ebp
  801773:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801774:	83 ec 0c             	sub    $0xc,%esp
  801777:	6a 01                	push   $0x1
  801779:	e8 dc 0c 00 00       	call   80245a <ipc_find_env>
  80177e:	a3 00 50 80 00       	mov    %eax,0x805000
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	eb c5                	jmp    80174d <fsipc+0x12>

00801788 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801788:	f3 0f 1e fb          	endbr32 
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	8b 40 0c             	mov    0xc(%eax),%eax
  801798:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  80179d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a0:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017aa:	b8 02 00 00 00       	mov    $0x2,%eax
  8017af:	e8 87 ff ff ff       	call   80173b <fsipc>
}
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <devfile_flush>:
{
  8017b6:	f3 0f 1e fb          	endbr32 
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c6:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  8017cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d0:	b8 06 00 00 00       	mov    $0x6,%eax
  8017d5:	e8 61 ff ff ff       	call   80173b <fsipc>
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <devfile_stat>:
{
  8017dc:	f3 0f 1e fb          	endbr32 
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	53                   	push   %ebx
  8017e4:	83 ec 04             	sub    $0x4,%esp
  8017e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8017f0:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017fa:	b8 05 00 00 00       	mov    $0x5,%eax
  8017ff:	e8 37 ff ff ff       	call   80173b <fsipc>
  801804:	85 c0                	test   %eax,%eax
  801806:	78 2c                	js     801834 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801808:	83 ec 08             	sub    $0x8,%esp
  80180b:	68 00 70 80 00       	push   $0x807000
  801810:	53                   	push   %ebx
  801811:	e8 03 f3 ff ff       	call   800b19 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801816:	a1 80 70 80 00       	mov    0x807080,%eax
  80181b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801821:	a1 84 70 80 00       	mov    0x807084,%eax
  801826:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801834:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <devfile_write>:
{
  801839:	f3 0f 1e fb          	endbr32 
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	83 ec 0c             	sub    $0xc,%esp
  801843:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801846:	8b 55 08             	mov    0x8(%ebp),%edx
  801849:	8b 52 0c             	mov    0xc(%edx),%edx
  80184c:	89 15 00 70 80 00    	mov    %edx,0x807000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801852:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801857:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80185c:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  80185f:	a3 04 70 80 00       	mov    %eax,0x807004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801864:	50                   	push   %eax
  801865:	ff 75 0c             	pushl  0xc(%ebp)
  801868:	68 08 70 80 00       	push   $0x807008
  80186d:	e8 5d f4 ff ff       	call   800ccf <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801872:	ba 00 00 00 00       	mov    $0x0,%edx
  801877:	b8 04 00 00 00       	mov    $0x4,%eax
  80187c:	e8 ba fe ff ff       	call   80173b <fsipc>
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <devfile_read>:
{
  801883:	f3 0f 1e fb          	endbr32 
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
  80188a:	56                   	push   %esi
  80188b:	53                   	push   %ebx
  80188c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	8b 40 0c             	mov    0xc(%eax),%eax
  801895:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  80189a:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a5:	b8 03 00 00 00       	mov    $0x3,%eax
  8018aa:	e8 8c fe ff ff       	call   80173b <fsipc>
  8018af:	89 c3                	mov    %eax,%ebx
  8018b1:	85 c0                	test   %eax,%eax
  8018b3:	78 1f                	js     8018d4 <devfile_read+0x51>
	assert(r <= n);
  8018b5:	39 f0                	cmp    %esi,%eax
  8018b7:	77 24                	ja     8018dd <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8018b9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018be:	7f 33                	jg     8018f3 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018c0:	83 ec 04             	sub    $0x4,%esp
  8018c3:	50                   	push   %eax
  8018c4:	68 00 70 80 00       	push   $0x807000
  8018c9:	ff 75 0c             	pushl  0xc(%ebp)
  8018cc:	e8 fe f3 ff ff       	call   800ccf <memmove>
	return r;
  8018d1:	83 c4 10             	add    $0x10,%esp
}
  8018d4:	89 d8                	mov    %ebx,%eax
  8018d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d9:	5b                   	pop    %ebx
  8018da:	5e                   	pop    %esi
  8018db:	5d                   	pop    %ebp
  8018dc:	c3                   	ret    
	assert(r <= n);
  8018dd:	68 78 2c 80 00       	push   $0x802c78
  8018e2:	68 7f 2c 80 00       	push   $0x802c7f
  8018e7:	6a 7c                	push   $0x7c
  8018e9:	68 94 2c 80 00       	push   $0x802c94
  8018ee:	e8 35 eb ff ff       	call   800428 <_panic>
	assert(r <= PGSIZE);
  8018f3:	68 9f 2c 80 00       	push   $0x802c9f
  8018f8:	68 7f 2c 80 00       	push   $0x802c7f
  8018fd:	6a 7d                	push   $0x7d
  8018ff:	68 94 2c 80 00       	push   $0x802c94
  801904:	e8 1f eb ff ff       	call   800428 <_panic>

00801909 <open>:
{
  801909:	f3 0f 1e fb          	endbr32 
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	56                   	push   %esi
  801911:	53                   	push   %ebx
  801912:	83 ec 1c             	sub    $0x1c,%esp
  801915:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801918:	56                   	push   %esi
  801919:	e8 b8 f1 ff ff       	call   800ad6 <strlen>
  80191e:	83 c4 10             	add    $0x10,%esp
  801921:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801926:	7f 6c                	jg     801994 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801928:	83 ec 0c             	sub    $0xc,%esp
  80192b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80192e:	50                   	push   %eax
  80192f:	e8 67 f8 ff ff       	call   80119b <fd_alloc>
  801934:	89 c3                	mov    %eax,%ebx
  801936:	83 c4 10             	add    $0x10,%esp
  801939:	85 c0                	test   %eax,%eax
  80193b:	78 3c                	js     801979 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  80193d:	83 ec 08             	sub    $0x8,%esp
  801940:	56                   	push   %esi
  801941:	68 00 70 80 00       	push   $0x807000
  801946:	e8 ce f1 ff ff       	call   800b19 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80194b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194e:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801953:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801956:	b8 01 00 00 00       	mov    $0x1,%eax
  80195b:	e8 db fd ff ff       	call   80173b <fsipc>
  801960:	89 c3                	mov    %eax,%ebx
  801962:	83 c4 10             	add    $0x10,%esp
  801965:	85 c0                	test   %eax,%eax
  801967:	78 19                	js     801982 <open+0x79>
	return fd2num(fd);
  801969:	83 ec 0c             	sub    $0xc,%esp
  80196c:	ff 75 f4             	pushl  -0xc(%ebp)
  80196f:	e8 f8 f7 ff ff       	call   80116c <fd2num>
  801974:	89 c3                	mov    %eax,%ebx
  801976:	83 c4 10             	add    $0x10,%esp
}
  801979:	89 d8                	mov    %ebx,%eax
  80197b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80197e:	5b                   	pop    %ebx
  80197f:	5e                   	pop    %esi
  801980:	5d                   	pop    %ebp
  801981:	c3                   	ret    
		fd_close(fd, 0);
  801982:	83 ec 08             	sub    $0x8,%esp
  801985:	6a 00                	push   $0x0
  801987:	ff 75 f4             	pushl  -0xc(%ebp)
  80198a:	e8 10 f9 ff ff       	call   80129f <fd_close>
		return r;
  80198f:	83 c4 10             	add    $0x10,%esp
  801992:	eb e5                	jmp    801979 <open+0x70>
		return -E_BAD_PATH;
  801994:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801999:	eb de                	jmp    801979 <open+0x70>

0080199b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80199b:	f3 0f 1e fb          	endbr32 
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019aa:	b8 08 00 00 00       	mov    $0x8,%eax
  8019af:	e8 87 fd ff ff       	call   80173b <fsipc>
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8019b6:	f3 0f 1e fb          	endbr32 
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	57                   	push   %edi
  8019be:	56                   	push   %esi
  8019bf:	53                   	push   %ebx
  8019c0:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8019c6:	6a 00                	push   $0x0
  8019c8:	ff 75 08             	pushl  0x8(%ebp)
  8019cb:	e8 39 ff ff ff       	call   801909 <open>
  8019d0:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8019d6:	83 c4 10             	add    $0x10,%esp
  8019d9:	85 c0                	test   %eax,%eax
  8019db:	0f 88 e7 04 00 00    	js     801ec8 <spawn+0x512>
  8019e1:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8019e3:	83 ec 04             	sub    $0x4,%esp
  8019e6:	68 00 02 00 00       	push   $0x200
  8019eb:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8019f1:	50                   	push   %eax
  8019f2:	52                   	push   %edx
  8019f3:	e8 07 fb ff ff       	call   8014ff <readn>
  8019f8:	83 c4 10             	add    $0x10,%esp
  8019fb:	3d 00 02 00 00       	cmp    $0x200,%eax
  801a00:	75 7e                	jne    801a80 <spawn+0xca>
	    || elf->e_magic != ELF_MAGIC) {
  801a02:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801a09:	45 4c 46 
  801a0c:	75 72                	jne    801a80 <spawn+0xca>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801a0e:	b8 07 00 00 00       	mov    $0x7,%eax
  801a13:	cd 30                	int    $0x30
  801a15:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801a1b:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801a21:	85 c0                	test   %eax,%eax
  801a23:	0f 88 93 04 00 00    	js     801ebc <spawn+0x506>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801a29:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a2e:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801a31:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801a37:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801a3d:	b9 11 00 00 00       	mov    $0x11,%ecx
  801a42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801a44:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801a4a:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801a50:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801a55:	be 00 00 00 00       	mov    $0x0,%esi
  801a5a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801a5d:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  801a64:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801a67:	85 c0                	test   %eax,%eax
  801a69:	74 4d                	je     801ab8 <spawn+0x102>
		string_size += strlen(argv[argc]) + 1;
  801a6b:	83 ec 0c             	sub    $0xc,%esp
  801a6e:	50                   	push   %eax
  801a6f:	e8 62 f0 ff ff       	call   800ad6 <strlen>
  801a74:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801a78:	83 c3 01             	add    $0x1,%ebx
  801a7b:	83 c4 10             	add    $0x10,%esp
  801a7e:	eb dd                	jmp    801a5d <spawn+0xa7>
		close(fd);
  801a80:	83 ec 0c             	sub    $0xc,%esp
  801a83:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a89:	e8 9c f8 ff ff       	call   80132a <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801a8e:	83 c4 0c             	add    $0xc,%esp
  801a91:	68 7f 45 4c 46       	push   $0x464c457f
  801a96:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801a9c:	68 ab 2c 80 00       	push   $0x802cab
  801aa1:	e8 69 ea ff ff       	call   80050f <cprintf>
		return -E_NOT_EXEC;
  801aa6:	83 c4 10             	add    $0x10,%esp
  801aa9:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801ab0:	ff ff ff 
  801ab3:	e9 10 04 00 00       	jmp    801ec8 <spawn+0x512>
  801ab8:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801abe:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801ac4:	bf 00 10 40 00       	mov    $0x401000,%edi
  801ac9:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801acb:	89 fa                	mov    %edi,%edx
  801acd:	83 e2 fc             	and    $0xfffffffc,%edx
  801ad0:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801ad7:	29 c2                	sub    %eax,%edx
  801ad9:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801adf:	8d 42 f8             	lea    -0x8(%edx),%eax
  801ae2:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801ae7:	0f 86 fe 03 00 00    	jbe    801eeb <spawn+0x535>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801aed:	83 ec 04             	sub    $0x4,%esp
  801af0:	6a 07                	push   $0x7
  801af2:	68 00 00 40 00       	push   $0x400000
  801af7:	6a 00                	push   $0x0
  801af9:	e8 5d f4 ff ff       	call   800f5b <sys_page_alloc>
  801afe:	83 c4 10             	add    $0x10,%esp
  801b01:	85 c0                	test   %eax,%eax
  801b03:	0f 88 e7 03 00 00    	js     801ef0 <spawn+0x53a>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801b09:	be 00 00 00 00       	mov    $0x0,%esi
  801b0e:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801b14:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801b17:	eb 30                	jmp    801b49 <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  801b19:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801b1f:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801b25:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801b28:	83 ec 08             	sub    $0x8,%esp
  801b2b:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801b2e:	57                   	push   %edi
  801b2f:	e8 e5 ef ff ff       	call   800b19 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801b34:	83 c4 04             	add    $0x4,%esp
  801b37:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801b3a:	e8 97 ef ff ff       	call   800ad6 <strlen>
  801b3f:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801b43:	83 c6 01             	add    $0x1,%esi
  801b46:	83 c4 10             	add    $0x10,%esp
  801b49:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801b4f:	7f c8                	jg     801b19 <spawn+0x163>
	}
	argv_store[argc] = 0;
  801b51:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801b57:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801b5d:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801b64:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801b6a:	0f 85 86 00 00 00    	jne    801bf6 <spawn+0x240>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801b70:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801b76:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  801b7c:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801b7f:	89 c8                	mov    %ecx,%eax
  801b81:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801b87:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801b8a:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801b8f:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801b95:	83 ec 0c             	sub    $0xc,%esp
  801b98:	6a 07                	push   $0x7
  801b9a:	68 00 d0 bf ee       	push   $0xeebfd000
  801b9f:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801ba5:	68 00 00 40 00       	push   $0x400000
  801baa:	6a 00                	push   $0x0
  801bac:	e8 f1 f3 ff ff       	call   800fa2 <sys_page_map>
  801bb1:	89 c3                	mov    %eax,%ebx
  801bb3:	83 c4 20             	add    $0x20,%esp
  801bb6:	85 c0                	test   %eax,%eax
  801bb8:	0f 88 3a 03 00 00    	js     801ef8 <spawn+0x542>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801bbe:	83 ec 08             	sub    $0x8,%esp
  801bc1:	68 00 00 40 00       	push   $0x400000
  801bc6:	6a 00                	push   $0x0
  801bc8:	e8 1b f4 ff ff       	call   800fe8 <sys_page_unmap>
  801bcd:	89 c3                	mov    %eax,%ebx
  801bcf:	83 c4 10             	add    $0x10,%esp
  801bd2:	85 c0                	test   %eax,%eax
  801bd4:	0f 88 1e 03 00 00    	js     801ef8 <spawn+0x542>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801bda:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801be0:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801be7:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801bee:	00 00 00 
  801bf1:	e9 4f 01 00 00       	jmp    801d45 <spawn+0x38f>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801bf6:	68 20 2d 80 00       	push   $0x802d20
  801bfb:	68 7f 2c 80 00       	push   $0x802c7f
  801c00:	68 f2 00 00 00       	push   $0xf2
  801c05:	68 c5 2c 80 00       	push   $0x802cc5
  801c0a:	e8 19 e8 ff ff       	call   800428 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c0f:	83 ec 04             	sub    $0x4,%esp
  801c12:	6a 07                	push   $0x7
  801c14:	68 00 00 40 00       	push   $0x400000
  801c19:	6a 00                	push   $0x0
  801c1b:	e8 3b f3 ff ff       	call   800f5b <sys_page_alloc>
  801c20:	83 c4 10             	add    $0x10,%esp
  801c23:	85 c0                	test   %eax,%eax
  801c25:	0f 88 ab 02 00 00    	js     801ed6 <spawn+0x520>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801c2b:	83 ec 08             	sub    $0x8,%esp
  801c2e:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801c34:	01 f0                	add    %esi,%eax
  801c36:	50                   	push   %eax
  801c37:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c3d:	e8 8e f9 ff ff       	call   8015d0 <seek>
  801c42:	83 c4 10             	add    $0x10,%esp
  801c45:	85 c0                	test   %eax,%eax
  801c47:	0f 88 90 02 00 00    	js     801edd <spawn+0x527>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801c4d:	83 ec 04             	sub    $0x4,%esp
  801c50:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c56:	29 f0                	sub    %esi,%eax
  801c58:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c5d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801c62:	0f 47 c1             	cmova  %ecx,%eax
  801c65:	50                   	push   %eax
  801c66:	68 00 00 40 00       	push   $0x400000
  801c6b:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c71:	e8 89 f8 ff ff       	call   8014ff <readn>
  801c76:	83 c4 10             	add    $0x10,%esp
  801c79:	85 c0                	test   %eax,%eax
  801c7b:	0f 88 63 02 00 00    	js     801ee4 <spawn+0x52e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801c81:	83 ec 0c             	sub    $0xc,%esp
  801c84:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801c8a:	53                   	push   %ebx
  801c8b:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801c91:	68 00 00 40 00       	push   $0x400000
  801c96:	6a 00                	push   $0x0
  801c98:	e8 05 f3 ff ff       	call   800fa2 <sys_page_map>
  801c9d:	83 c4 20             	add    $0x20,%esp
  801ca0:	85 c0                	test   %eax,%eax
  801ca2:	78 7c                	js     801d20 <spawn+0x36a>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801ca4:	83 ec 08             	sub    $0x8,%esp
  801ca7:	68 00 00 40 00       	push   $0x400000
  801cac:	6a 00                	push   $0x0
  801cae:	e8 35 f3 ff ff       	call   800fe8 <sys_page_unmap>
  801cb3:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801cb6:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801cbc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801cc2:	89 fe                	mov    %edi,%esi
  801cc4:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801cca:	76 69                	jbe    801d35 <spawn+0x37f>
		if (i >= filesz) {
  801ccc:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801cd2:	0f 87 37 ff ff ff    	ja     801c0f <spawn+0x259>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801cd8:	83 ec 04             	sub    $0x4,%esp
  801cdb:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801ce1:	53                   	push   %ebx
  801ce2:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801ce8:	e8 6e f2 ff ff       	call   800f5b <sys_page_alloc>
  801ced:	83 c4 10             	add    $0x10,%esp
  801cf0:	85 c0                	test   %eax,%eax
  801cf2:	79 c2                	jns    801cb6 <spawn+0x300>
  801cf4:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801cf6:	83 ec 0c             	sub    $0xc,%esp
  801cf9:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801cff:	e8 cc f1 ff ff       	call   800ed0 <sys_env_destroy>
	close(fd);
  801d04:	83 c4 04             	add    $0x4,%esp
  801d07:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d0d:	e8 18 f6 ff ff       	call   80132a <close>
	return r;
  801d12:	83 c4 10             	add    $0x10,%esp
  801d15:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801d1b:	e9 a8 01 00 00       	jmp    801ec8 <spawn+0x512>
				panic("spawn: sys_page_map data: %e", r);
  801d20:	50                   	push   %eax
  801d21:	68 d1 2c 80 00       	push   $0x802cd1
  801d26:	68 25 01 00 00       	push   $0x125
  801d2b:	68 c5 2c 80 00       	push   $0x802cc5
  801d30:	e8 f3 e6 ff ff       	call   800428 <_panic>
  801d35:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801d3b:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801d42:	83 c6 20             	add    $0x20,%esi
  801d45:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801d4c:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801d52:	7e 6d                	jle    801dc1 <spawn+0x40b>
		if (ph->p_type != ELF_PROG_LOAD)
  801d54:	83 3e 01             	cmpl   $0x1,(%esi)
  801d57:	75 e2                	jne    801d3b <spawn+0x385>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801d59:	8b 46 18             	mov    0x18(%esi),%eax
  801d5c:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801d5f:	83 f8 01             	cmp    $0x1,%eax
  801d62:	19 c0                	sbb    %eax,%eax
  801d64:	83 e0 fe             	and    $0xfffffffe,%eax
  801d67:	83 c0 07             	add    $0x7,%eax
  801d6a:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801d70:	8b 4e 04             	mov    0x4(%esi),%ecx
  801d73:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801d79:	8b 56 10             	mov    0x10(%esi),%edx
  801d7c:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801d82:	8b 7e 14             	mov    0x14(%esi),%edi
  801d85:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801d8b:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801d8e:	89 d8                	mov    %ebx,%eax
  801d90:	25 ff 0f 00 00       	and    $0xfff,%eax
  801d95:	74 1a                	je     801db1 <spawn+0x3fb>
		va -= i;
  801d97:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801d99:	01 c7                	add    %eax,%edi
  801d9b:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801da1:	01 c2                	add    %eax,%edx
  801da3:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801da9:	29 c1                	sub    %eax,%ecx
  801dab:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801db1:	bf 00 00 00 00       	mov    $0x0,%edi
  801db6:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801dbc:	e9 01 ff ff ff       	jmp    801cc2 <spawn+0x30c>
	close(fd);
  801dc1:	83 ec 0c             	sub    $0xc,%esp
  801dc4:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801dca:	e8 5b f5 ff ff       	call   80132a <close>
  801dcf:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  801dd2:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dd7:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801ddd:	eb 0e                	jmp    801ded <spawn+0x437>
  801ddf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801de5:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801deb:	74 5a                	je     801e47 <spawn+0x491>
		if((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)){
  801ded:	89 d8                	mov    %ebx,%eax
  801def:	c1 e8 16             	shr    $0x16,%eax
  801df2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801df9:	a8 01                	test   $0x1,%al
  801dfb:	74 e2                	je     801ddf <spawn+0x429>
  801dfd:	89 d8                	mov    %ebx,%eax
  801dff:	c1 e8 0c             	shr    $0xc,%eax
  801e02:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e09:	f6 c2 01             	test   $0x1,%dl
  801e0c:	74 d1                	je     801ddf <spawn+0x429>
  801e0e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e15:	f6 c2 04             	test   $0x4,%dl
  801e18:	74 c5                	je     801ddf <spawn+0x429>
  801e1a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e21:	f6 c6 04             	test   $0x4,%dh
  801e24:	74 b9                	je     801ddf <spawn+0x429>
			if(r = sys_page_map(0, (void*)addr, child, (void*)addr, (uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  801e26:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801e2d:	83 ec 0c             	sub    $0xc,%esp
  801e30:	25 07 0e 00 00       	and    $0xe07,%eax
  801e35:	50                   	push   %eax
  801e36:	53                   	push   %ebx
  801e37:	56                   	push   %esi
  801e38:	53                   	push   %ebx
  801e39:	6a 00                	push   $0x0
  801e3b:	e8 62 f1 ff ff       	call   800fa2 <sys_page_map>
  801e40:	83 c4 20             	add    $0x20,%esp
  801e43:	85 c0                	test   %eax,%eax
  801e45:	79 98                	jns    801ddf <spawn+0x429>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801e47:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801e4e:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801e51:	83 ec 08             	sub    $0x8,%esp
  801e54:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801e5a:	50                   	push   %eax
  801e5b:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e61:	e8 0e f2 ff ff       	call   801074 <sys_env_set_trapframe>
  801e66:	83 c4 10             	add    $0x10,%esp
  801e69:	85 c0                	test   %eax,%eax
  801e6b:	78 25                	js     801e92 <spawn+0x4dc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801e6d:	83 ec 08             	sub    $0x8,%esp
  801e70:	6a 02                	push   $0x2
  801e72:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e78:	e8 b1 f1 ff ff       	call   80102e <sys_env_set_status>
  801e7d:	83 c4 10             	add    $0x10,%esp
  801e80:	85 c0                	test   %eax,%eax
  801e82:	78 23                	js     801ea7 <spawn+0x4f1>
	return child;
  801e84:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e8a:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801e90:	eb 36                	jmp    801ec8 <spawn+0x512>
		panic("sys_env_set_trapframe: %e", r);
  801e92:	50                   	push   %eax
  801e93:	68 ee 2c 80 00       	push   $0x802cee
  801e98:	68 86 00 00 00       	push   $0x86
  801e9d:	68 c5 2c 80 00       	push   $0x802cc5
  801ea2:	e8 81 e5 ff ff       	call   800428 <_panic>
		panic("sys_env_set_status: %e", r);
  801ea7:	50                   	push   %eax
  801ea8:	68 08 2d 80 00       	push   $0x802d08
  801ead:	68 89 00 00 00       	push   $0x89
  801eb2:	68 c5 2c 80 00       	push   $0x802cc5
  801eb7:	e8 6c e5 ff ff       	call   800428 <_panic>
		return r;
  801ebc:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801ec2:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801ec8:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801ece:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ed1:	5b                   	pop    %ebx
  801ed2:	5e                   	pop    %esi
  801ed3:	5f                   	pop    %edi
  801ed4:	5d                   	pop    %ebp
  801ed5:	c3                   	ret    
  801ed6:	89 c7                	mov    %eax,%edi
  801ed8:	e9 19 fe ff ff       	jmp    801cf6 <spawn+0x340>
  801edd:	89 c7                	mov    %eax,%edi
  801edf:	e9 12 fe ff ff       	jmp    801cf6 <spawn+0x340>
  801ee4:	89 c7                	mov    %eax,%edi
  801ee6:	e9 0b fe ff ff       	jmp    801cf6 <spawn+0x340>
		return -E_NO_MEM;
  801eeb:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  801ef0:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801ef6:	eb d0                	jmp    801ec8 <spawn+0x512>
	sys_page_unmap(0, UTEMP);
  801ef8:	83 ec 08             	sub    $0x8,%esp
  801efb:	68 00 00 40 00       	push   $0x400000
  801f00:	6a 00                	push   $0x0
  801f02:	e8 e1 f0 ff ff       	call   800fe8 <sys_page_unmap>
  801f07:	83 c4 10             	add    $0x10,%esp
  801f0a:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801f10:	eb b6                	jmp    801ec8 <spawn+0x512>

00801f12 <spawnl>:
{
  801f12:	f3 0f 1e fb          	endbr32 
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	57                   	push   %edi
  801f1a:	56                   	push   %esi
  801f1b:	53                   	push   %ebx
  801f1c:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801f1f:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801f22:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801f27:	8d 4a 04             	lea    0x4(%edx),%ecx
  801f2a:	83 3a 00             	cmpl   $0x0,(%edx)
  801f2d:	74 07                	je     801f36 <spawnl+0x24>
		argc++;
  801f2f:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801f32:	89 ca                	mov    %ecx,%edx
  801f34:	eb f1                	jmp    801f27 <spawnl+0x15>
	const char *argv[argc+2];
  801f36:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801f3d:	89 d1                	mov    %edx,%ecx
  801f3f:	83 e1 f0             	and    $0xfffffff0,%ecx
  801f42:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801f48:	89 e6                	mov    %esp,%esi
  801f4a:	29 d6                	sub    %edx,%esi
  801f4c:	89 f2                	mov    %esi,%edx
  801f4e:	39 d4                	cmp    %edx,%esp
  801f50:	74 10                	je     801f62 <spawnl+0x50>
  801f52:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  801f58:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  801f5f:	00 
  801f60:	eb ec                	jmp    801f4e <spawnl+0x3c>
  801f62:	89 ca                	mov    %ecx,%edx
  801f64:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801f6a:	29 d4                	sub    %edx,%esp
  801f6c:	85 d2                	test   %edx,%edx
  801f6e:	74 05                	je     801f75 <spawnl+0x63>
  801f70:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  801f75:	8d 74 24 03          	lea    0x3(%esp),%esi
  801f79:	89 f2                	mov    %esi,%edx
  801f7b:	c1 ea 02             	shr    $0x2,%edx
  801f7e:	83 e6 fc             	and    $0xfffffffc,%esi
  801f81:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801f83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f86:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801f8d:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801f94:	00 
	va_start(vl, arg0);
  801f95:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801f98:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801f9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9f:	eb 0b                	jmp    801fac <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  801fa1:	83 c0 01             	add    $0x1,%eax
  801fa4:	8b 39                	mov    (%ecx),%edi
  801fa6:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801fa9:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801fac:	39 d0                	cmp    %edx,%eax
  801fae:	75 f1                	jne    801fa1 <spawnl+0x8f>
	return spawn(prog, argv);
  801fb0:	83 ec 08             	sub    $0x8,%esp
  801fb3:	56                   	push   %esi
  801fb4:	ff 75 08             	pushl  0x8(%ebp)
  801fb7:	e8 fa f9 ff ff       	call   8019b6 <spawn>
}
  801fbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fbf:	5b                   	pop    %ebx
  801fc0:	5e                   	pop    %esi
  801fc1:	5f                   	pop    %edi
  801fc2:	5d                   	pop    %ebp
  801fc3:	c3                   	ret    

00801fc4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801fc4:	f3 0f 1e fb          	endbr32 
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	56                   	push   %esi
  801fcc:	53                   	push   %ebx
  801fcd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801fd0:	83 ec 0c             	sub    $0xc,%esp
  801fd3:	ff 75 08             	pushl  0x8(%ebp)
  801fd6:	e8 a5 f1 ff ff       	call   801180 <fd2data>
  801fdb:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801fdd:	83 c4 08             	add    $0x8,%esp
  801fe0:	68 46 2d 80 00       	push   $0x802d46
  801fe5:	53                   	push   %ebx
  801fe6:	e8 2e eb ff ff       	call   800b19 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801feb:	8b 46 04             	mov    0x4(%esi),%eax
  801fee:	2b 06                	sub    (%esi),%eax
  801ff0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ff6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ffd:	00 00 00 
	stat->st_dev = &devpipe;
  802000:	c7 83 88 00 00 00 ac 	movl   $0x8047ac,0x88(%ebx)
  802007:	47 80 00 
	return 0;
}
  80200a:	b8 00 00 00 00       	mov    $0x0,%eax
  80200f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802012:	5b                   	pop    %ebx
  802013:	5e                   	pop    %esi
  802014:	5d                   	pop    %ebp
  802015:	c3                   	ret    

00802016 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802016:	f3 0f 1e fb          	endbr32 
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
  80201d:	53                   	push   %ebx
  80201e:	83 ec 0c             	sub    $0xc,%esp
  802021:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802024:	53                   	push   %ebx
  802025:	6a 00                	push   $0x0
  802027:	e8 bc ef ff ff       	call   800fe8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80202c:	89 1c 24             	mov    %ebx,(%esp)
  80202f:	e8 4c f1 ff ff       	call   801180 <fd2data>
  802034:	83 c4 08             	add    $0x8,%esp
  802037:	50                   	push   %eax
  802038:	6a 00                	push   $0x0
  80203a:	e8 a9 ef ff ff       	call   800fe8 <sys_page_unmap>
}
  80203f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <_pipeisclosed>:
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	57                   	push   %edi
  802048:	56                   	push   %esi
  802049:	53                   	push   %ebx
  80204a:	83 ec 1c             	sub    $0x1c,%esp
  80204d:	89 c7                	mov    %eax,%edi
  80204f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802051:	a1 90 67 80 00       	mov    0x806790,%eax
  802056:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802059:	83 ec 0c             	sub    $0xc,%esp
  80205c:	57                   	push   %edi
  80205d:	e8 35 04 00 00       	call   802497 <pageref>
  802062:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802065:	89 34 24             	mov    %esi,(%esp)
  802068:	e8 2a 04 00 00       	call   802497 <pageref>
		nn = thisenv->env_runs;
  80206d:	8b 15 90 67 80 00    	mov    0x806790,%edx
  802073:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802076:	83 c4 10             	add    $0x10,%esp
  802079:	39 cb                	cmp    %ecx,%ebx
  80207b:	74 1b                	je     802098 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80207d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802080:	75 cf                	jne    802051 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802082:	8b 42 58             	mov    0x58(%edx),%eax
  802085:	6a 01                	push   $0x1
  802087:	50                   	push   %eax
  802088:	53                   	push   %ebx
  802089:	68 4d 2d 80 00       	push   $0x802d4d
  80208e:	e8 7c e4 ff ff       	call   80050f <cprintf>
  802093:	83 c4 10             	add    $0x10,%esp
  802096:	eb b9                	jmp    802051 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802098:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80209b:	0f 94 c0             	sete   %al
  80209e:	0f b6 c0             	movzbl %al,%eax
}
  8020a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020a4:	5b                   	pop    %ebx
  8020a5:	5e                   	pop    %esi
  8020a6:	5f                   	pop    %edi
  8020a7:	5d                   	pop    %ebp
  8020a8:	c3                   	ret    

008020a9 <devpipe_write>:
{
  8020a9:	f3 0f 1e fb          	endbr32 
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	57                   	push   %edi
  8020b1:	56                   	push   %esi
  8020b2:	53                   	push   %ebx
  8020b3:	83 ec 28             	sub    $0x28,%esp
  8020b6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8020b9:	56                   	push   %esi
  8020ba:	e8 c1 f0 ff ff       	call   801180 <fd2data>
  8020bf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020c1:	83 c4 10             	add    $0x10,%esp
  8020c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8020c9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8020cc:	74 4f                	je     80211d <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8020ce:	8b 43 04             	mov    0x4(%ebx),%eax
  8020d1:	8b 0b                	mov    (%ebx),%ecx
  8020d3:	8d 51 20             	lea    0x20(%ecx),%edx
  8020d6:	39 d0                	cmp    %edx,%eax
  8020d8:	72 14                	jb     8020ee <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8020da:	89 da                	mov    %ebx,%edx
  8020dc:	89 f0                	mov    %esi,%eax
  8020de:	e8 61 ff ff ff       	call   802044 <_pipeisclosed>
  8020e3:	85 c0                	test   %eax,%eax
  8020e5:	75 3b                	jne    802122 <devpipe_write+0x79>
			sys_yield();
  8020e7:	e8 4c ee ff ff       	call   800f38 <sys_yield>
  8020ec:	eb e0                	jmp    8020ce <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8020ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020f1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8020f5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8020f8:	89 c2                	mov    %eax,%edx
  8020fa:	c1 fa 1f             	sar    $0x1f,%edx
  8020fd:	89 d1                	mov    %edx,%ecx
  8020ff:	c1 e9 1b             	shr    $0x1b,%ecx
  802102:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802105:	83 e2 1f             	and    $0x1f,%edx
  802108:	29 ca                	sub    %ecx,%edx
  80210a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80210e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802112:	83 c0 01             	add    $0x1,%eax
  802115:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802118:	83 c7 01             	add    $0x1,%edi
  80211b:	eb ac                	jmp    8020c9 <devpipe_write+0x20>
	return i;
  80211d:	8b 45 10             	mov    0x10(%ebp),%eax
  802120:	eb 05                	jmp    802127 <devpipe_write+0x7e>
				return 0;
  802122:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802127:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80212a:	5b                   	pop    %ebx
  80212b:	5e                   	pop    %esi
  80212c:	5f                   	pop    %edi
  80212d:	5d                   	pop    %ebp
  80212e:	c3                   	ret    

0080212f <devpipe_read>:
{
  80212f:	f3 0f 1e fb          	endbr32 
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	57                   	push   %edi
  802137:	56                   	push   %esi
  802138:	53                   	push   %ebx
  802139:	83 ec 18             	sub    $0x18,%esp
  80213c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80213f:	57                   	push   %edi
  802140:	e8 3b f0 ff ff       	call   801180 <fd2data>
  802145:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802147:	83 c4 10             	add    $0x10,%esp
  80214a:	be 00 00 00 00       	mov    $0x0,%esi
  80214f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802152:	75 14                	jne    802168 <devpipe_read+0x39>
	return i;
  802154:	8b 45 10             	mov    0x10(%ebp),%eax
  802157:	eb 02                	jmp    80215b <devpipe_read+0x2c>
				return i;
  802159:	89 f0                	mov    %esi,%eax
}
  80215b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80215e:	5b                   	pop    %ebx
  80215f:	5e                   	pop    %esi
  802160:	5f                   	pop    %edi
  802161:	5d                   	pop    %ebp
  802162:	c3                   	ret    
			sys_yield();
  802163:	e8 d0 ed ff ff       	call   800f38 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802168:	8b 03                	mov    (%ebx),%eax
  80216a:	3b 43 04             	cmp    0x4(%ebx),%eax
  80216d:	75 18                	jne    802187 <devpipe_read+0x58>
			if (i > 0)
  80216f:	85 f6                	test   %esi,%esi
  802171:	75 e6                	jne    802159 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802173:	89 da                	mov    %ebx,%edx
  802175:	89 f8                	mov    %edi,%eax
  802177:	e8 c8 fe ff ff       	call   802044 <_pipeisclosed>
  80217c:	85 c0                	test   %eax,%eax
  80217e:	74 e3                	je     802163 <devpipe_read+0x34>
				return 0;
  802180:	b8 00 00 00 00       	mov    $0x0,%eax
  802185:	eb d4                	jmp    80215b <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802187:	99                   	cltd   
  802188:	c1 ea 1b             	shr    $0x1b,%edx
  80218b:	01 d0                	add    %edx,%eax
  80218d:	83 e0 1f             	and    $0x1f,%eax
  802190:	29 d0                	sub    %edx,%eax
  802192:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802197:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80219a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80219d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8021a0:	83 c6 01             	add    $0x1,%esi
  8021a3:	eb aa                	jmp    80214f <devpipe_read+0x20>

008021a5 <pipe>:
{
  8021a5:	f3 0f 1e fb          	endbr32 
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	56                   	push   %esi
  8021ad:	53                   	push   %ebx
  8021ae:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8021b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021b4:	50                   	push   %eax
  8021b5:	e8 e1 ef ff ff       	call   80119b <fd_alloc>
  8021ba:	89 c3                	mov    %eax,%ebx
  8021bc:	83 c4 10             	add    $0x10,%esp
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	0f 88 23 01 00 00    	js     8022ea <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021c7:	83 ec 04             	sub    $0x4,%esp
  8021ca:	68 07 04 00 00       	push   $0x407
  8021cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8021d2:	6a 00                	push   $0x0
  8021d4:	e8 82 ed ff ff       	call   800f5b <sys_page_alloc>
  8021d9:	89 c3                	mov    %eax,%ebx
  8021db:	83 c4 10             	add    $0x10,%esp
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	0f 88 04 01 00 00    	js     8022ea <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8021e6:	83 ec 0c             	sub    $0xc,%esp
  8021e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021ec:	50                   	push   %eax
  8021ed:	e8 a9 ef ff ff       	call   80119b <fd_alloc>
  8021f2:	89 c3                	mov    %eax,%ebx
  8021f4:	83 c4 10             	add    $0x10,%esp
  8021f7:	85 c0                	test   %eax,%eax
  8021f9:	0f 88 db 00 00 00    	js     8022da <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021ff:	83 ec 04             	sub    $0x4,%esp
  802202:	68 07 04 00 00       	push   $0x407
  802207:	ff 75 f0             	pushl  -0x10(%ebp)
  80220a:	6a 00                	push   $0x0
  80220c:	e8 4a ed ff ff       	call   800f5b <sys_page_alloc>
  802211:	89 c3                	mov    %eax,%ebx
  802213:	83 c4 10             	add    $0x10,%esp
  802216:	85 c0                	test   %eax,%eax
  802218:	0f 88 bc 00 00 00    	js     8022da <pipe+0x135>
	va = fd2data(fd0);
  80221e:	83 ec 0c             	sub    $0xc,%esp
  802221:	ff 75 f4             	pushl  -0xc(%ebp)
  802224:	e8 57 ef ff ff       	call   801180 <fd2data>
  802229:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80222b:	83 c4 0c             	add    $0xc,%esp
  80222e:	68 07 04 00 00       	push   $0x407
  802233:	50                   	push   %eax
  802234:	6a 00                	push   $0x0
  802236:	e8 20 ed ff ff       	call   800f5b <sys_page_alloc>
  80223b:	89 c3                	mov    %eax,%ebx
  80223d:	83 c4 10             	add    $0x10,%esp
  802240:	85 c0                	test   %eax,%eax
  802242:	0f 88 82 00 00 00    	js     8022ca <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802248:	83 ec 0c             	sub    $0xc,%esp
  80224b:	ff 75 f0             	pushl  -0x10(%ebp)
  80224e:	e8 2d ef ff ff       	call   801180 <fd2data>
  802253:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80225a:	50                   	push   %eax
  80225b:	6a 00                	push   $0x0
  80225d:	56                   	push   %esi
  80225e:	6a 00                	push   $0x0
  802260:	e8 3d ed ff ff       	call   800fa2 <sys_page_map>
  802265:	89 c3                	mov    %eax,%ebx
  802267:	83 c4 20             	add    $0x20,%esp
  80226a:	85 c0                	test   %eax,%eax
  80226c:	78 4e                	js     8022bc <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  80226e:	a1 ac 47 80 00       	mov    0x8047ac,%eax
  802273:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802276:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802278:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802282:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802285:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802287:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802291:	83 ec 0c             	sub    $0xc,%esp
  802294:	ff 75 f4             	pushl  -0xc(%ebp)
  802297:	e8 d0 ee ff ff       	call   80116c <fd2num>
  80229c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80229f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8022a1:	83 c4 04             	add    $0x4,%esp
  8022a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8022a7:	e8 c0 ee ff ff       	call   80116c <fd2num>
  8022ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022af:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8022b2:	83 c4 10             	add    $0x10,%esp
  8022b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022ba:	eb 2e                	jmp    8022ea <pipe+0x145>
	sys_page_unmap(0, va);
  8022bc:	83 ec 08             	sub    $0x8,%esp
  8022bf:	56                   	push   %esi
  8022c0:	6a 00                	push   $0x0
  8022c2:	e8 21 ed ff ff       	call   800fe8 <sys_page_unmap>
  8022c7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8022ca:	83 ec 08             	sub    $0x8,%esp
  8022cd:	ff 75 f0             	pushl  -0x10(%ebp)
  8022d0:	6a 00                	push   $0x0
  8022d2:	e8 11 ed ff ff       	call   800fe8 <sys_page_unmap>
  8022d7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8022da:	83 ec 08             	sub    $0x8,%esp
  8022dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8022e0:	6a 00                	push   $0x0
  8022e2:	e8 01 ed ff ff       	call   800fe8 <sys_page_unmap>
  8022e7:	83 c4 10             	add    $0x10,%esp
}
  8022ea:	89 d8                	mov    %ebx,%eax
  8022ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022ef:	5b                   	pop    %ebx
  8022f0:	5e                   	pop    %esi
  8022f1:	5d                   	pop    %ebp
  8022f2:	c3                   	ret    

008022f3 <pipeisclosed>:
{
  8022f3:	f3 0f 1e fb          	endbr32 
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
  8022fa:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802300:	50                   	push   %eax
  802301:	ff 75 08             	pushl  0x8(%ebp)
  802304:	e8 e8 ee ff ff       	call   8011f1 <fd_lookup>
  802309:	83 c4 10             	add    $0x10,%esp
  80230c:	85 c0                	test   %eax,%eax
  80230e:	78 18                	js     802328 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802310:	83 ec 0c             	sub    $0xc,%esp
  802313:	ff 75 f4             	pushl  -0xc(%ebp)
  802316:	e8 65 ee ff ff       	call   801180 <fd2data>
  80231b:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	e8 1f fd ff ff       	call   802044 <_pipeisclosed>
  802325:	83 c4 10             	add    $0x10,%esp
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80232a:	f3 0f 1e fb          	endbr32 
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
  802331:	56                   	push   %esi
  802332:	53                   	push   %ebx
  802333:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802336:	85 f6                	test   %esi,%esi
  802338:	74 13                	je     80234d <wait+0x23>
	e = &envs[ENVX(envid)];
  80233a:	89 f3                	mov    %esi,%ebx
  80233c:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802342:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802345:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80234b:	eb 1b                	jmp    802368 <wait+0x3e>
	assert(envid != 0);
  80234d:	68 65 2d 80 00       	push   $0x802d65
  802352:	68 7f 2c 80 00       	push   $0x802c7f
  802357:	6a 09                	push   $0x9
  802359:	68 70 2d 80 00       	push   $0x802d70
  80235e:	e8 c5 e0 ff ff       	call   800428 <_panic>
		sys_yield();
  802363:	e8 d0 eb ff ff       	call   800f38 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802368:	8b 43 48             	mov    0x48(%ebx),%eax
  80236b:	39 f0                	cmp    %esi,%eax
  80236d:	75 07                	jne    802376 <wait+0x4c>
  80236f:	8b 43 54             	mov    0x54(%ebx),%eax
  802372:	85 c0                	test   %eax,%eax
  802374:	75 ed                	jne    802363 <wait+0x39>
}
  802376:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802379:	5b                   	pop    %ebx
  80237a:	5e                   	pop    %esi
  80237b:	5d                   	pop    %ebp
  80237c:	c3                   	ret    

0080237d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80237d:	f3 0f 1e fb          	endbr32 
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
  802384:	56                   	push   %esi
  802385:	53                   	push   %ebx
  802386:	8b 75 08             	mov    0x8(%ebp),%esi
  802389:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  80238f:	85 c0                	test   %eax,%eax
  802391:	74 3d                	je     8023d0 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  802393:	83 ec 0c             	sub    $0xc,%esp
  802396:	50                   	push   %eax
  802397:	e8 8b ed ff ff       	call   801127 <sys_ipc_recv>
  80239c:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  80239f:	85 f6                	test   %esi,%esi
  8023a1:	74 0b                	je     8023ae <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8023a3:	8b 15 90 67 80 00    	mov    0x806790,%edx
  8023a9:	8b 52 74             	mov    0x74(%edx),%edx
  8023ac:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8023ae:	85 db                	test   %ebx,%ebx
  8023b0:	74 0b                	je     8023bd <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8023b2:	8b 15 90 67 80 00    	mov    0x806790,%edx
  8023b8:	8b 52 78             	mov    0x78(%edx),%edx
  8023bb:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8023bd:	85 c0                	test   %eax,%eax
  8023bf:	78 21                	js     8023e2 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8023c1:	a1 90 67 80 00       	mov    0x806790,%eax
  8023c6:	8b 40 70             	mov    0x70(%eax),%eax
}
  8023c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023cc:	5b                   	pop    %ebx
  8023cd:	5e                   	pop    %esi
  8023ce:	5d                   	pop    %ebp
  8023cf:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8023d0:	83 ec 0c             	sub    $0xc,%esp
  8023d3:	68 00 00 c0 ee       	push   $0xeec00000
  8023d8:	e8 4a ed ff ff       	call   801127 <sys_ipc_recv>
  8023dd:	83 c4 10             	add    $0x10,%esp
  8023e0:	eb bd                	jmp    80239f <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  8023e2:	85 f6                	test   %esi,%esi
  8023e4:	74 10                	je     8023f6 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  8023e6:	85 db                	test   %ebx,%ebx
  8023e8:	75 df                	jne    8023c9 <ipc_recv+0x4c>
  8023ea:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8023f1:	00 00 00 
  8023f4:	eb d3                	jmp    8023c9 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  8023f6:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8023fd:	00 00 00 
  802400:	eb e4                	jmp    8023e6 <ipc_recv+0x69>

00802402 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802402:	f3 0f 1e fb          	endbr32 
  802406:	55                   	push   %ebp
  802407:	89 e5                	mov    %esp,%ebp
  802409:	57                   	push   %edi
  80240a:	56                   	push   %esi
  80240b:	53                   	push   %ebx
  80240c:	83 ec 0c             	sub    $0xc,%esp
  80240f:	8b 7d 08             	mov    0x8(%ebp),%edi
  802412:	8b 75 0c             	mov    0xc(%ebp),%esi
  802415:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802418:	85 db                	test   %ebx,%ebx
  80241a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80241f:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802422:	ff 75 14             	pushl  0x14(%ebp)
  802425:	53                   	push   %ebx
  802426:	56                   	push   %esi
  802427:	57                   	push   %edi
  802428:	e8 d3 ec ff ff       	call   801100 <sys_ipc_try_send>
  80242d:	83 c4 10             	add    $0x10,%esp
  802430:	85 c0                	test   %eax,%eax
  802432:	79 1e                	jns    802452 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802434:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802437:	75 07                	jne    802440 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802439:	e8 fa ea ff ff       	call   800f38 <sys_yield>
  80243e:	eb e2                	jmp    802422 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802440:	50                   	push   %eax
  802441:	68 7b 2d 80 00       	push   $0x802d7b
  802446:	6a 59                	push   $0x59
  802448:	68 96 2d 80 00       	push   $0x802d96
  80244d:	e8 d6 df ff ff       	call   800428 <_panic>
	}
}
  802452:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802455:	5b                   	pop    %ebx
  802456:	5e                   	pop    %esi
  802457:	5f                   	pop    %edi
  802458:	5d                   	pop    %ebp
  802459:	c3                   	ret    

0080245a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80245a:	f3 0f 1e fb          	endbr32 
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
  802461:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802464:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802469:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80246c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802472:	8b 52 50             	mov    0x50(%edx),%edx
  802475:	39 ca                	cmp    %ecx,%edx
  802477:	74 11                	je     80248a <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802479:	83 c0 01             	add    $0x1,%eax
  80247c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802481:	75 e6                	jne    802469 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802483:	b8 00 00 00 00       	mov    $0x0,%eax
  802488:	eb 0b                	jmp    802495 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80248a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80248d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802492:	8b 40 48             	mov    0x48(%eax),%eax
}
  802495:	5d                   	pop    %ebp
  802496:	c3                   	ret    

00802497 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802497:	f3 0f 1e fb          	endbr32 
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
  80249e:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024a1:	89 c2                	mov    %eax,%edx
  8024a3:	c1 ea 16             	shr    $0x16,%edx
  8024a6:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8024ad:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8024b2:	f6 c1 01             	test   $0x1,%cl
  8024b5:	74 1c                	je     8024d3 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8024b7:	c1 e8 0c             	shr    $0xc,%eax
  8024ba:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8024c1:	a8 01                	test   $0x1,%al
  8024c3:	74 0e                	je     8024d3 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024c5:	c1 e8 0c             	shr    $0xc,%eax
  8024c8:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8024cf:	ef 
  8024d0:	0f b7 d2             	movzwl %dx,%edx
}
  8024d3:	89 d0                	mov    %edx,%eax
  8024d5:	5d                   	pop    %ebp
  8024d6:	c3                   	ret    
  8024d7:	66 90                	xchg   %ax,%ax
  8024d9:	66 90                	xchg   %ax,%ax
  8024db:	66 90                	xchg   %ax,%ax
  8024dd:	66 90                	xchg   %ax,%ax
  8024df:	90                   	nop

008024e0 <__udivdi3>:
  8024e0:	f3 0f 1e fb          	endbr32 
  8024e4:	55                   	push   %ebp
  8024e5:	57                   	push   %edi
  8024e6:	56                   	push   %esi
  8024e7:	53                   	push   %ebx
  8024e8:	83 ec 1c             	sub    $0x1c,%esp
  8024eb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8024ef:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8024f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024f7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8024fb:	85 d2                	test   %edx,%edx
  8024fd:	75 19                	jne    802518 <__udivdi3+0x38>
  8024ff:	39 f3                	cmp    %esi,%ebx
  802501:	76 4d                	jbe    802550 <__udivdi3+0x70>
  802503:	31 ff                	xor    %edi,%edi
  802505:	89 e8                	mov    %ebp,%eax
  802507:	89 f2                	mov    %esi,%edx
  802509:	f7 f3                	div    %ebx
  80250b:	89 fa                	mov    %edi,%edx
  80250d:	83 c4 1c             	add    $0x1c,%esp
  802510:	5b                   	pop    %ebx
  802511:	5e                   	pop    %esi
  802512:	5f                   	pop    %edi
  802513:	5d                   	pop    %ebp
  802514:	c3                   	ret    
  802515:	8d 76 00             	lea    0x0(%esi),%esi
  802518:	39 f2                	cmp    %esi,%edx
  80251a:	76 14                	jbe    802530 <__udivdi3+0x50>
  80251c:	31 ff                	xor    %edi,%edi
  80251e:	31 c0                	xor    %eax,%eax
  802520:	89 fa                	mov    %edi,%edx
  802522:	83 c4 1c             	add    $0x1c,%esp
  802525:	5b                   	pop    %ebx
  802526:	5e                   	pop    %esi
  802527:	5f                   	pop    %edi
  802528:	5d                   	pop    %ebp
  802529:	c3                   	ret    
  80252a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802530:	0f bd fa             	bsr    %edx,%edi
  802533:	83 f7 1f             	xor    $0x1f,%edi
  802536:	75 48                	jne    802580 <__udivdi3+0xa0>
  802538:	39 f2                	cmp    %esi,%edx
  80253a:	72 06                	jb     802542 <__udivdi3+0x62>
  80253c:	31 c0                	xor    %eax,%eax
  80253e:	39 eb                	cmp    %ebp,%ebx
  802540:	77 de                	ja     802520 <__udivdi3+0x40>
  802542:	b8 01 00 00 00       	mov    $0x1,%eax
  802547:	eb d7                	jmp    802520 <__udivdi3+0x40>
  802549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802550:	89 d9                	mov    %ebx,%ecx
  802552:	85 db                	test   %ebx,%ebx
  802554:	75 0b                	jne    802561 <__udivdi3+0x81>
  802556:	b8 01 00 00 00       	mov    $0x1,%eax
  80255b:	31 d2                	xor    %edx,%edx
  80255d:	f7 f3                	div    %ebx
  80255f:	89 c1                	mov    %eax,%ecx
  802561:	31 d2                	xor    %edx,%edx
  802563:	89 f0                	mov    %esi,%eax
  802565:	f7 f1                	div    %ecx
  802567:	89 c6                	mov    %eax,%esi
  802569:	89 e8                	mov    %ebp,%eax
  80256b:	89 f7                	mov    %esi,%edi
  80256d:	f7 f1                	div    %ecx
  80256f:	89 fa                	mov    %edi,%edx
  802571:	83 c4 1c             	add    $0x1c,%esp
  802574:	5b                   	pop    %ebx
  802575:	5e                   	pop    %esi
  802576:	5f                   	pop    %edi
  802577:	5d                   	pop    %ebp
  802578:	c3                   	ret    
  802579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802580:	89 f9                	mov    %edi,%ecx
  802582:	b8 20 00 00 00       	mov    $0x20,%eax
  802587:	29 f8                	sub    %edi,%eax
  802589:	d3 e2                	shl    %cl,%edx
  80258b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80258f:	89 c1                	mov    %eax,%ecx
  802591:	89 da                	mov    %ebx,%edx
  802593:	d3 ea                	shr    %cl,%edx
  802595:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802599:	09 d1                	or     %edx,%ecx
  80259b:	89 f2                	mov    %esi,%edx
  80259d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025a1:	89 f9                	mov    %edi,%ecx
  8025a3:	d3 e3                	shl    %cl,%ebx
  8025a5:	89 c1                	mov    %eax,%ecx
  8025a7:	d3 ea                	shr    %cl,%edx
  8025a9:	89 f9                	mov    %edi,%ecx
  8025ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8025af:	89 eb                	mov    %ebp,%ebx
  8025b1:	d3 e6                	shl    %cl,%esi
  8025b3:	89 c1                	mov    %eax,%ecx
  8025b5:	d3 eb                	shr    %cl,%ebx
  8025b7:	09 de                	or     %ebx,%esi
  8025b9:	89 f0                	mov    %esi,%eax
  8025bb:	f7 74 24 08          	divl   0x8(%esp)
  8025bf:	89 d6                	mov    %edx,%esi
  8025c1:	89 c3                	mov    %eax,%ebx
  8025c3:	f7 64 24 0c          	mull   0xc(%esp)
  8025c7:	39 d6                	cmp    %edx,%esi
  8025c9:	72 15                	jb     8025e0 <__udivdi3+0x100>
  8025cb:	89 f9                	mov    %edi,%ecx
  8025cd:	d3 e5                	shl    %cl,%ebp
  8025cf:	39 c5                	cmp    %eax,%ebp
  8025d1:	73 04                	jae    8025d7 <__udivdi3+0xf7>
  8025d3:	39 d6                	cmp    %edx,%esi
  8025d5:	74 09                	je     8025e0 <__udivdi3+0x100>
  8025d7:	89 d8                	mov    %ebx,%eax
  8025d9:	31 ff                	xor    %edi,%edi
  8025db:	e9 40 ff ff ff       	jmp    802520 <__udivdi3+0x40>
  8025e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025e3:	31 ff                	xor    %edi,%edi
  8025e5:	e9 36 ff ff ff       	jmp    802520 <__udivdi3+0x40>
  8025ea:	66 90                	xchg   %ax,%ax
  8025ec:	66 90                	xchg   %ax,%ax
  8025ee:	66 90                	xchg   %ax,%ax

008025f0 <__umoddi3>:
  8025f0:	f3 0f 1e fb          	endbr32 
  8025f4:	55                   	push   %ebp
  8025f5:	57                   	push   %edi
  8025f6:	56                   	push   %esi
  8025f7:	53                   	push   %ebx
  8025f8:	83 ec 1c             	sub    $0x1c,%esp
  8025fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8025ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  802603:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802607:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80260b:	85 c0                	test   %eax,%eax
  80260d:	75 19                	jne    802628 <__umoddi3+0x38>
  80260f:	39 df                	cmp    %ebx,%edi
  802611:	76 5d                	jbe    802670 <__umoddi3+0x80>
  802613:	89 f0                	mov    %esi,%eax
  802615:	89 da                	mov    %ebx,%edx
  802617:	f7 f7                	div    %edi
  802619:	89 d0                	mov    %edx,%eax
  80261b:	31 d2                	xor    %edx,%edx
  80261d:	83 c4 1c             	add    $0x1c,%esp
  802620:	5b                   	pop    %ebx
  802621:	5e                   	pop    %esi
  802622:	5f                   	pop    %edi
  802623:	5d                   	pop    %ebp
  802624:	c3                   	ret    
  802625:	8d 76 00             	lea    0x0(%esi),%esi
  802628:	89 f2                	mov    %esi,%edx
  80262a:	39 d8                	cmp    %ebx,%eax
  80262c:	76 12                	jbe    802640 <__umoddi3+0x50>
  80262e:	89 f0                	mov    %esi,%eax
  802630:	89 da                	mov    %ebx,%edx
  802632:	83 c4 1c             	add    $0x1c,%esp
  802635:	5b                   	pop    %ebx
  802636:	5e                   	pop    %esi
  802637:	5f                   	pop    %edi
  802638:	5d                   	pop    %ebp
  802639:	c3                   	ret    
  80263a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802640:	0f bd e8             	bsr    %eax,%ebp
  802643:	83 f5 1f             	xor    $0x1f,%ebp
  802646:	75 50                	jne    802698 <__umoddi3+0xa8>
  802648:	39 d8                	cmp    %ebx,%eax
  80264a:	0f 82 e0 00 00 00    	jb     802730 <__umoddi3+0x140>
  802650:	89 d9                	mov    %ebx,%ecx
  802652:	39 f7                	cmp    %esi,%edi
  802654:	0f 86 d6 00 00 00    	jbe    802730 <__umoddi3+0x140>
  80265a:	89 d0                	mov    %edx,%eax
  80265c:	89 ca                	mov    %ecx,%edx
  80265e:	83 c4 1c             	add    $0x1c,%esp
  802661:	5b                   	pop    %ebx
  802662:	5e                   	pop    %esi
  802663:	5f                   	pop    %edi
  802664:	5d                   	pop    %ebp
  802665:	c3                   	ret    
  802666:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80266d:	8d 76 00             	lea    0x0(%esi),%esi
  802670:	89 fd                	mov    %edi,%ebp
  802672:	85 ff                	test   %edi,%edi
  802674:	75 0b                	jne    802681 <__umoddi3+0x91>
  802676:	b8 01 00 00 00       	mov    $0x1,%eax
  80267b:	31 d2                	xor    %edx,%edx
  80267d:	f7 f7                	div    %edi
  80267f:	89 c5                	mov    %eax,%ebp
  802681:	89 d8                	mov    %ebx,%eax
  802683:	31 d2                	xor    %edx,%edx
  802685:	f7 f5                	div    %ebp
  802687:	89 f0                	mov    %esi,%eax
  802689:	f7 f5                	div    %ebp
  80268b:	89 d0                	mov    %edx,%eax
  80268d:	31 d2                	xor    %edx,%edx
  80268f:	eb 8c                	jmp    80261d <__umoddi3+0x2d>
  802691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802698:	89 e9                	mov    %ebp,%ecx
  80269a:	ba 20 00 00 00       	mov    $0x20,%edx
  80269f:	29 ea                	sub    %ebp,%edx
  8026a1:	d3 e0                	shl    %cl,%eax
  8026a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026a7:	89 d1                	mov    %edx,%ecx
  8026a9:	89 f8                	mov    %edi,%eax
  8026ab:	d3 e8                	shr    %cl,%eax
  8026ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026b9:	09 c1                	or     %eax,%ecx
  8026bb:	89 d8                	mov    %ebx,%eax
  8026bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026c1:	89 e9                	mov    %ebp,%ecx
  8026c3:	d3 e7                	shl    %cl,%edi
  8026c5:	89 d1                	mov    %edx,%ecx
  8026c7:	d3 e8                	shr    %cl,%eax
  8026c9:	89 e9                	mov    %ebp,%ecx
  8026cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026cf:	d3 e3                	shl    %cl,%ebx
  8026d1:	89 c7                	mov    %eax,%edi
  8026d3:	89 d1                	mov    %edx,%ecx
  8026d5:	89 f0                	mov    %esi,%eax
  8026d7:	d3 e8                	shr    %cl,%eax
  8026d9:	89 e9                	mov    %ebp,%ecx
  8026db:	89 fa                	mov    %edi,%edx
  8026dd:	d3 e6                	shl    %cl,%esi
  8026df:	09 d8                	or     %ebx,%eax
  8026e1:	f7 74 24 08          	divl   0x8(%esp)
  8026e5:	89 d1                	mov    %edx,%ecx
  8026e7:	89 f3                	mov    %esi,%ebx
  8026e9:	f7 64 24 0c          	mull   0xc(%esp)
  8026ed:	89 c6                	mov    %eax,%esi
  8026ef:	89 d7                	mov    %edx,%edi
  8026f1:	39 d1                	cmp    %edx,%ecx
  8026f3:	72 06                	jb     8026fb <__umoddi3+0x10b>
  8026f5:	75 10                	jne    802707 <__umoddi3+0x117>
  8026f7:	39 c3                	cmp    %eax,%ebx
  8026f9:	73 0c                	jae    802707 <__umoddi3+0x117>
  8026fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8026ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802703:	89 d7                	mov    %edx,%edi
  802705:	89 c6                	mov    %eax,%esi
  802707:	89 ca                	mov    %ecx,%edx
  802709:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80270e:	29 f3                	sub    %esi,%ebx
  802710:	19 fa                	sbb    %edi,%edx
  802712:	89 d0                	mov    %edx,%eax
  802714:	d3 e0                	shl    %cl,%eax
  802716:	89 e9                	mov    %ebp,%ecx
  802718:	d3 eb                	shr    %cl,%ebx
  80271a:	d3 ea                	shr    %cl,%edx
  80271c:	09 d8                	or     %ebx,%eax
  80271e:	83 c4 1c             	add    $0x1c,%esp
  802721:	5b                   	pop    %ebx
  802722:	5e                   	pop    %esi
  802723:	5f                   	pop    %edi
  802724:	5d                   	pop    %ebp
  802725:	c3                   	ret    
  802726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80272d:	8d 76 00             	lea    0x0(%esi),%esi
  802730:	29 fe                	sub    %edi,%esi
  802732:	19 c3                	sbb    %eax,%ebx
  802734:	89 f2                	mov    %esi,%edx
  802736:	89 d9                	mov    %ebx,%ecx
  802738:	e9 1d ff ff ff       	jmp    80265a <__umoddi3+0x6a>
