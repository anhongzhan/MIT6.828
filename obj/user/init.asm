
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
  800077:	68 c0 2c 80 00       	push   $0x802cc0
  80007c:	e8 8e 04 00 00       	call   80050f <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800081:	83 c4 08             	add    $0x8,%esp
  800084:	68 70 17 00 00       	push   $0x1770
  800089:	68 00 40 80 00       	push   $0x804000
  80008e:	e8 a0 ff ff ff       	call   800033 <sum>
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  80009b:	0f 84 99 00 00 00    	je     80013a <umain+0xd6>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000a1:	83 ec 04             	sub    $0x4,%esp
  8000a4:	68 9e 98 0f 00       	push   $0xf989e
  8000a9:	50                   	push   %eax
  8000aa:	68 88 2d 80 00       	push   $0x802d88
  8000af:	e8 5b 04 00 00       	call   80050f <cprintf>
  8000b4:	83 c4 10             	add    $0x10,%esp
			x, want);
	else
		cprintf("init: data seems okay\n");
	if ((x = sum(bss, sizeof bss)) != 0)
  8000b7:	83 ec 08             	sub    $0x8,%esp
  8000ba:	68 70 17 00 00       	push   $0x1770
  8000bf:	68 20 60 80 00       	push   $0x806020
  8000c4:	e8 6a ff ff ff       	call   800033 <sum>
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	85 c0                	test   %eax,%eax
  8000ce:	74 7f                	je     80014f <umain+0xeb>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000d0:	83 ec 08             	sub    $0x8,%esp
  8000d3:	50                   	push   %eax
  8000d4:	68 c4 2d 80 00       	push   $0x802dc4
  8000d9:	e8 31 04 00 00       	call   80050f <cprintf>
  8000de:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000e1:	83 ec 08             	sub    $0x8,%esp
  8000e4:	68 fc 2c 80 00       	push   $0x802cfc
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
  80010a:	68 08 2d 80 00       	push   $0x802d08
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
  800127:	68 09 2d 80 00       	push   $0x802d09
  80012c:	56                   	push   %esi
  80012d:	e8 0d 0a 00 00       	call   800b3f <strcat>
	for (i = 0; i < argc; i++) {
  800132:	83 c3 01             	add    $0x1,%ebx
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	eb c9                	jmp    800103 <umain+0x9f>
		cprintf("init: data seems okay\n");
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 cf 2c 80 00       	push   $0x802ccf
  800142:	e8 c8 03 00 00       	call   80050f <cprintf>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	e9 68 ff ff ff       	jmp    8000b7 <umain+0x53>
		cprintf("init: bss seems okay\n");
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	68 e6 2c 80 00       	push   $0x802ce6
  800157:	e8 b3 03 00 00       	call   80050f <cprintf>
  80015c:	83 c4 10             	add    $0x10,%esp
  80015f:	eb 80                	jmp    8000e1 <umain+0x7d>
	}
	cprintf("%s\n", args);
  800161:	83 ec 08             	sub    $0x8,%esp
  800164:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80016a:	50                   	push   %eax
  80016b:	68 0b 2d 80 00       	push   $0x802d0b
  800170:	e8 9a 03 00 00       	call   80050f <cprintf>

	cprintf("init: running sh\n");
  800175:	c7 04 24 0f 2d 80 00 	movl   $0x802d0f,(%esp)
  80017c:	e8 8e 03 00 00       	call   80050f <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800181:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800188:	e8 51 12 00 00       	call   8013de <close>
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
  80019c:	68 3a 2d 80 00       	push   $0x802d3a
  8001a1:	6a 39                	push   $0x39
  8001a3:	68 2e 2d 80 00       	push   $0x802d2e
  8001a8:	e8 7b 02 00 00       	call   800428 <_panic>
		panic("opencons: %e", r);
  8001ad:	50                   	push   %eax
  8001ae:	68 21 2d 80 00       	push   $0x802d21
  8001b3:	6a 37                	push   $0x37
  8001b5:	68 2e 2d 80 00       	push   $0x802d2e
  8001ba:	e8 69 02 00 00       	call   800428 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001bf:	83 ec 08             	sub    $0x8,%esp
  8001c2:	6a 01                	push   $0x1
  8001c4:	6a 00                	push   $0x0
  8001c6:	e8 6d 12 00 00       	call   801438 <dup>
  8001cb:	83 c4 10             	add    $0x10,%esp
  8001ce:	85 c0                	test   %eax,%eax
  8001d0:	79 23                	jns    8001f5 <umain+0x191>
		panic("dup: %e", r);
  8001d2:	50                   	push   %eax
  8001d3:	68 54 2d 80 00       	push   $0x802d54
  8001d8:	6a 3b                	push   $0x3b
  8001da:	68 2e 2d 80 00       	push   $0x802d2e
  8001df:	e8 44 02 00 00       	call   800428 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
		r = spawnl("/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
  8001e4:	83 ec 08             	sub    $0x8,%esp
  8001e7:	50                   	push   %eax
  8001e8:	68 73 2d 80 00       	push   $0x802d73
  8001ed:	e8 1d 03 00 00       	call   80050f <cprintf>
			continue;
  8001f2:	83 c4 10             	add    $0x10,%esp
		cprintf("init: starting sh\n");
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 5c 2d 80 00       	push   $0x802d5c
  8001fd:	e8 0d 03 00 00       	call   80050f <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  800202:	83 c4 0c             	add    $0xc,%esp
  800205:	6a 00                	push   $0x0
  800207:	68 70 2d 80 00       	push   $0x802d70
  80020c:	68 6f 2d 80 00       	push   $0x802d6f
  800211:	e8 b0 1d 00 00       	call   801fc6 <spawnl>
		if (r < 0) {
  800216:	83 c4 10             	add    $0x10,%esp
  800219:	85 c0                	test   %eax,%eax
  80021b:	78 c7                	js     8001e4 <umain+0x180>
		}
		wait(r);
  80021d:	83 ec 0c             	sub    $0xc,%esp
  800220:	50                   	push   %eax
  800221:	e8 70 26 00 00       	call   802896 <wait>
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
  80023f:	68 f3 2d 80 00       	push   $0x802df3
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
  80031f:	e8 04 12 00 00       	call   801528 <read>
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
  80034b:	e8 50 0f 00 00       	call   8012a0 <fd_lookup>
  800350:	83 c4 10             	add    $0x10,%esp
  800353:	85 c0                	test   %eax,%eax
  800355:	78 11                	js     800368 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  800357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80035a:	8b 15 70 57 80 00    	mov    0x805770,%edx
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
  800378:	e8 cd 0e 00 00       	call   80124a <fd_alloc>
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
  8003a0:	8b 15 70 57 80 00    	mov    0x805770,%edx
  8003a6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8003a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8003b2:	83 ec 0c             	sub    $0xc,%esp
  8003b5:	50                   	push   %eax
  8003b6:	e8 60 0e 00 00       	call   80121b <fd2num>
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
  8003e1:	a3 90 77 80 00       	mov    %eax,0x807790

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003e6:	85 db                	test   %ebx,%ebx
  8003e8:	7e 07                	jle    8003f1 <libmain+0x31>
		binaryname = argv[0];
  8003ea:	8b 06                	mov    (%esi),%eax
  8003ec:	a3 8c 57 80 00       	mov    %eax,0x80578c

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
  800414:	e8 f6 0f 00 00       	call   80140f <close_all>
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
  800434:	8b 35 8c 57 80 00    	mov    0x80578c,%esi
  80043a:	e8 d6 0a 00 00       	call   800f15 <sys_getenvid>
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	ff 75 0c             	pushl  0xc(%ebp)
  800445:	ff 75 08             	pushl  0x8(%ebp)
  800448:	56                   	push   %esi
  800449:	50                   	push   %eax
  80044a:	68 0c 2e 80 00       	push   $0x802e0c
  80044f:	e8 bb 00 00 00       	call   80050f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800454:	83 c4 18             	add    $0x18,%esp
  800457:	53                   	push   %ebx
  800458:	ff 75 10             	pushl  0x10(%ebp)
  80045b:	e8 5a 00 00 00       	call   8004ba <vcprintf>
	cprintf("\n");
  800460:	c7 04 24 51 33 80 00 	movl   $0x803351,(%esp)
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
  800575:	e8 d6 24 00 00       	call   802a50 <__udivdi3>
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
  8005b3:	e8 a8 25 00 00       	call   802b60 <__umoddi3>
  8005b8:	83 c4 14             	add    $0x14,%esp
  8005bb:	0f be 80 2f 2e 80 00 	movsbl 0x802e2f(%eax),%eax
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
  800662:	3e ff 24 85 80 2f 80 	notrack jmp *0x802f80(,%eax,4)
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
  80072f:	8b 14 85 e0 30 80 00 	mov    0x8030e0(,%eax,4),%edx
  800736:	85 d2                	test   %edx,%edx
  800738:	74 18                	je     800752 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80073a:	52                   	push   %edx
  80073b:	68 15 32 80 00       	push   $0x803215
  800740:	53                   	push   %ebx
  800741:	56                   	push   %esi
  800742:	e8 aa fe ff ff       	call   8005f1 <printfmt>
  800747:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80074a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80074d:	e9 66 02 00 00       	jmp    8009b8 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800752:	50                   	push   %eax
  800753:	68 47 2e 80 00       	push   $0x802e47
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
  80077a:	b8 40 2e 80 00       	mov    $0x802e40,%eax
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
  800f04:	68 3f 31 80 00       	push   $0x80313f
  800f09:	6a 23                	push   $0x23
  800f0b:	68 5c 31 80 00       	push   $0x80315c
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
  800f91:	68 3f 31 80 00       	push   $0x80313f
  800f96:	6a 23                	push   $0x23
  800f98:	68 5c 31 80 00       	push   $0x80315c
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
  800fd7:	68 3f 31 80 00       	push   $0x80313f
  800fdc:	6a 23                	push   $0x23
  800fde:	68 5c 31 80 00       	push   $0x80315c
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
  80101d:	68 3f 31 80 00       	push   $0x80313f
  801022:	6a 23                	push   $0x23
  801024:	68 5c 31 80 00       	push   $0x80315c
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
  801063:	68 3f 31 80 00       	push   $0x80313f
  801068:	6a 23                	push   $0x23
  80106a:	68 5c 31 80 00       	push   $0x80315c
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
  8010a9:	68 3f 31 80 00       	push   $0x80313f
  8010ae:	6a 23                	push   $0x23
  8010b0:	68 5c 31 80 00       	push   $0x80315c
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
  8010ef:	68 3f 31 80 00       	push   $0x80313f
  8010f4:	6a 23                	push   $0x23
  8010f6:	68 5c 31 80 00       	push   $0x80315c
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
  80115b:	68 3f 31 80 00       	push   $0x80313f
  801160:	6a 23                	push   $0x23
  801162:	68 5c 31 80 00       	push   $0x80315c
  801167:	e8 bc f2 ff ff       	call   800428 <_panic>

0080116c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80116c:	f3 0f 1e fb          	endbr32 
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	57                   	push   %edi
  801174:	56                   	push   %esi
  801175:	53                   	push   %ebx
	asm volatile("int %1\n"
  801176:	ba 00 00 00 00       	mov    $0x0,%edx
  80117b:	b8 0e 00 00 00       	mov    $0xe,%eax
  801180:	89 d1                	mov    %edx,%ecx
  801182:	89 d3                	mov    %edx,%ebx
  801184:	89 d7                	mov    %edx,%edi
  801186:	89 d6                	mov    %edx,%esi
  801188:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80118a:	5b                   	pop    %ebx
  80118b:	5e                   	pop    %esi
  80118c:	5f                   	pop    %edi
  80118d:	5d                   	pop    %ebp
  80118e:	c3                   	ret    

0080118f <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  80118f:	f3 0f 1e fb          	endbr32 
  801193:	55                   	push   %ebp
  801194:	89 e5                	mov    %esp,%ebp
  801196:	57                   	push   %edi
  801197:	56                   	push   %esi
  801198:	53                   	push   %ebx
  801199:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80119c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a7:	b8 0f 00 00 00       	mov    $0xf,%eax
  8011ac:	89 df                	mov    %ebx,%edi
  8011ae:	89 de                	mov    %ebx,%esi
  8011b0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011b2:	85 c0                	test   %eax,%eax
  8011b4:	7f 08                	jg     8011be <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  8011b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011b9:	5b                   	pop    %ebx
  8011ba:	5e                   	pop    %esi
  8011bb:	5f                   	pop    %edi
  8011bc:	5d                   	pop    %ebp
  8011bd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011be:	83 ec 0c             	sub    $0xc,%esp
  8011c1:	50                   	push   %eax
  8011c2:	6a 0f                	push   $0xf
  8011c4:	68 3f 31 80 00       	push   $0x80313f
  8011c9:	6a 23                	push   $0x23
  8011cb:	68 5c 31 80 00       	push   $0x80315c
  8011d0:	e8 53 f2 ff ff       	call   800428 <_panic>

008011d5 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  8011d5:	f3 0f 1e fb          	endbr32 
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	57                   	push   %edi
  8011dd:	56                   	push   %esi
  8011de:	53                   	push   %ebx
  8011df:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ed:	b8 10 00 00 00       	mov    $0x10,%eax
  8011f2:	89 df                	mov    %ebx,%edi
  8011f4:	89 de                	mov    %ebx,%esi
  8011f6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011f8:	85 c0                	test   %eax,%eax
  8011fa:	7f 08                	jg     801204 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  8011fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ff:	5b                   	pop    %ebx
  801200:	5e                   	pop    %esi
  801201:	5f                   	pop    %edi
  801202:	5d                   	pop    %ebp
  801203:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801204:	83 ec 0c             	sub    $0xc,%esp
  801207:	50                   	push   %eax
  801208:	6a 10                	push   $0x10
  80120a:	68 3f 31 80 00       	push   $0x80313f
  80120f:	6a 23                	push   $0x23
  801211:	68 5c 31 80 00       	push   $0x80315c
  801216:	e8 0d f2 ff ff       	call   800428 <_panic>

0080121b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80121b:	f3 0f 1e fb          	endbr32 
  80121f:	55                   	push   %ebp
  801220:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	05 00 00 00 30       	add    $0x30000000,%eax
  80122a:	c1 e8 0c             	shr    $0xc,%eax
}
  80122d:	5d                   	pop    %ebp
  80122e:	c3                   	ret    

0080122f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80122f:	f3 0f 1e fb          	endbr32 
  801233:	55                   	push   %ebp
  801234:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80123e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801243:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801248:	5d                   	pop    %ebp
  801249:	c3                   	ret    

0080124a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80124a:	f3 0f 1e fb          	endbr32 
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801256:	89 c2                	mov    %eax,%edx
  801258:	c1 ea 16             	shr    $0x16,%edx
  80125b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801262:	f6 c2 01             	test   $0x1,%dl
  801265:	74 2d                	je     801294 <fd_alloc+0x4a>
  801267:	89 c2                	mov    %eax,%edx
  801269:	c1 ea 0c             	shr    $0xc,%edx
  80126c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801273:	f6 c2 01             	test   $0x1,%dl
  801276:	74 1c                	je     801294 <fd_alloc+0x4a>
  801278:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80127d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801282:	75 d2                	jne    801256 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80128d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801292:	eb 0a                	jmp    80129e <fd_alloc+0x54>
			*fd_store = fd;
  801294:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801297:	89 01                	mov    %eax,(%ecx)
			return 0;
  801299:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80129e:	5d                   	pop    %ebp
  80129f:	c3                   	ret    

008012a0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012a0:	f3 0f 1e fb          	endbr32 
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012aa:	83 f8 1f             	cmp    $0x1f,%eax
  8012ad:	77 30                	ja     8012df <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012af:	c1 e0 0c             	shl    $0xc,%eax
  8012b2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012b7:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8012bd:	f6 c2 01             	test   $0x1,%dl
  8012c0:	74 24                	je     8012e6 <fd_lookup+0x46>
  8012c2:	89 c2                	mov    %eax,%edx
  8012c4:	c1 ea 0c             	shr    $0xc,%edx
  8012c7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012ce:	f6 c2 01             	test   $0x1,%dl
  8012d1:	74 1a                	je     8012ed <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d6:	89 02                	mov    %eax,(%edx)
	return 0;
  8012d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012dd:	5d                   	pop    %ebp
  8012de:	c3                   	ret    
		return -E_INVAL;
  8012df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e4:	eb f7                	jmp    8012dd <fd_lookup+0x3d>
		return -E_INVAL;
  8012e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012eb:	eb f0                	jmp    8012dd <fd_lookup+0x3d>
  8012ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012f2:	eb e9                	jmp    8012dd <fd_lookup+0x3d>

008012f4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012f4:	f3 0f 1e fb          	endbr32 
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
  8012fb:	83 ec 08             	sub    $0x8,%esp
  8012fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801301:	ba 00 00 00 00       	mov    $0x0,%edx
  801306:	b8 90 57 80 00       	mov    $0x805790,%eax
		if (devtab[i]->dev_id == dev_id) {
  80130b:	39 08                	cmp    %ecx,(%eax)
  80130d:	74 38                	je     801347 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80130f:	83 c2 01             	add    $0x1,%edx
  801312:	8b 04 95 e8 31 80 00 	mov    0x8031e8(,%edx,4),%eax
  801319:	85 c0                	test   %eax,%eax
  80131b:	75 ee                	jne    80130b <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80131d:	a1 90 77 80 00       	mov    0x807790,%eax
  801322:	8b 40 48             	mov    0x48(%eax),%eax
  801325:	83 ec 04             	sub    $0x4,%esp
  801328:	51                   	push   %ecx
  801329:	50                   	push   %eax
  80132a:	68 6c 31 80 00       	push   $0x80316c
  80132f:	e8 db f1 ff ff       	call   80050f <cprintf>
	*dev = 0;
  801334:	8b 45 0c             	mov    0xc(%ebp),%eax
  801337:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80133d:	83 c4 10             	add    $0x10,%esp
  801340:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801345:	c9                   	leave  
  801346:	c3                   	ret    
			*dev = devtab[i];
  801347:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80134a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80134c:	b8 00 00 00 00       	mov    $0x0,%eax
  801351:	eb f2                	jmp    801345 <dev_lookup+0x51>

00801353 <fd_close>:
{
  801353:	f3 0f 1e fb          	endbr32 
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	57                   	push   %edi
  80135b:	56                   	push   %esi
  80135c:	53                   	push   %ebx
  80135d:	83 ec 24             	sub    $0x24,%esp
  801360:	8b 75 08             	mov    0x8(%ebp),%esi
  801363:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801366:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801369:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80136a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801370:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801373:	50                   	push   %eax
  801374:	e8 27 ff ff ff       	call   8012a0 <fd_lookup>
  801379:	89 c3                	mov    %eax,%ebx
  80137b:	83 c4 10             	add    $0x10,%esp
  80137e:	85 c0                	test   %eax,%eax
  801380:	78 05                	js     801387 <fd_close+0x34>
	    || fd != fd2)
  801382:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801385:	74 16                	je     80139d <fd_close+0x4a>
		return (must_exist ? r : 0);
  801387:	89 f8                	mov    %edi,%eax
  801389:	84 c0                	test   %al,%al
  80138b:	b8 00 00 00 00       	mov    $0x0,%eax
  801390:	0f 44 d8             	cmove  %eax,%ebx
}
  801393:	89 d8                	mov    %ebx,%eax
  801395:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801398:	5b                   	pop    %ebx
  801399:	5e                   	pop    %esi
  80139a:	5f                   	pop    %edi
  80139b:	5d                   	pop    %ebp
  80139c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80139d:	83 ec 08             	sub    $0x8,%esp
  8013a0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013a3:	50                   	push   %eax
  8013a4:	ff 36                	pushl  (%esi)
  8013a6:	e8 49 ff ff ff       	call   8012f4 <dev_lookup>
  8013ab:	89 c3                	mov    %eax,%ebx
  8013ad:	83 c4 10             	add    $0x10,%esp
  8013b0:	85 c0                	test   %eax,%eax
  8013b2:	78 1a                	js     8013ce <fd_close+0x7b>
		if (dev->dev_close)
  8013b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013b7:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8013ba:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	74 0b                	je     8013ce <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8013c3:	83 ec 0c             	sub    $0xc,%esp
  8013c6:	56                   	push   %esi
  8013c7:	ff d0                	call   *%eax
  8013c9:	89 c3                	mov    %eax,%ebx
  8013cb:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013ce:	83 ec 08             	sub    $0x8,%esp
  8013d1:	56                   	push   %esi
  8013d2:	6a 00                	push   $0x0
  8013d4:	e8 0f fc ff ff       	call   800fe8 <sys_page_unmap>
	return r;
  8013d9:	83 c4 10             	add    $0x10,%esp
  8013dc:	eb b5                	jmp    801393 <fd_close+0x40>

008013de <close>:

int
close(int fdnum)
{
  8013de:	f3 0f 1e fb          	endbr32 
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
  8013e5:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013eb:	50                   	push   %eax
  8013ec:	ff 75 08             	pushl  0x8(%ebp)
  8013ef:	e8 ac fe ff ff       	call   8012a0 <fd_lookup>
  8013f4:	83 c4 10             	add    $0x10,%esp
  8013f7:	85 c0                	test   %eax,%eax
  8013f9:	79 02                	jns    8013fd <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    
		return fd_close(fd, 1);
  8013fd:	83 ec 08             	sub    $0x8,%esp
  801400:	6a 01                	push   $0x1
  801402:	ff 75 f4             	pushl  -0xc(%ebp)
  801405:	e8 49 ff ff ff       	call   801353 <fd_close>
  80140a:	83 c4 10             	add    $0x10,%esp
  80140d:	eb ec                	jmp    8013fb <close+0x1d>

0080140f <close_all>:

void
close_all(void)
{
  80140f:	f3 0f 1e fb          	endbr32 
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	53                   	push   %ebx
  801417:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80141a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80141f:	83 ec 0c             	sub    $0xc,%esp
  801422:	53                   	push   %ebx
  801423:	e8 b6 ff ff ff       	call   8013de <close>
	for (i = 0; i < MAXFD; i++)
  801428:	83 c3 01             	add    $0x1,%ebx
  80142b:	83 c4 10             	add    $0x10,%esp
  80142e:	83 fb 20             	cmp    $0x20,%ebx
  801431:	75 ec                	jne    80141f <close_all+0x10>
}
  801433:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801436:	c9                   	leave  
  801437:	c3                   	ret    

00801438 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801438:	f3 0f 1e fb          	endbr32 
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	57                   	push   %edi
  801440:	56                   	push   %esi
  801441:	53                   	push   %ebx
  801442:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801445:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801448:	50                   	push   %eax
  801449:	ff 75 08             	pushl  0x8(%ebp)
  80144c:	e8 4f fe ff ff       	call   8012a0 <fd_lookup>
  801451:	89 c3                	mov    %eax,%ebx
  801453:	83 c4 10             	add    $0x10,%esp
  801456:	85 c0                	test   %eax,%eax
  801458:	0f 88 81 00 00 00    	js     8014df <dup+0xa7>
		return r;
	close(newfdnum);
  80145e:	83 ec 0c             	sub    $0xc,%esp
  801461:	ff 75 0c             	pushl  0xc(%ebp)
  801464:	e8 75 ff ff ff       	call   8013de <close>

	newfd = INDEX2FD(newfdnum);
  801469:	8b 75 0c             	mov    0xc(%ebp),%esi
  80146c:	c1 e6 0c             	shl    $0xc,%esi
  80146f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801475:	83 c4 04             	add    $0x4,%esp
  801478:	ff 75 e4             	pushl  -0x1c(%ebp)
  80147b:	e8 af fd ff ff       	call   80122f <fd2data>
  801480:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801482:	89 34 24             	mov    %esi,(%esp)
  801485:	e8 a5 fd ff ff       	call   80122f <fd2data>
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80148f:	89 d8                	mov    %ebx,%eax
  801491:	c1 e8 16             	shr    $0x16,%eax
  801494:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80149b:	a8 01                	test   $0x1,%al
  80149d:	74 11                	je     8014b0 <dup+0x78>
  80149f:	89 d8                	mov    %ebx,%eax
  8014a1:	c1 e8 0c             	shr    $0xc,%eax
  8014a4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014ab:	f6 c2 01             	test   $0x1,%dl
  8014ae:	75 39                	jne    8014e9 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014b3:	89 d0                	mov    %edx,%eax
  8014b5:	c1 e8 0c             	shr    $0xc,%eax
  8014b8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014bf:	83 ec 0c             	sub    $0xc,%esp
  8014c2:	25 07 0e 00 00       	and    $0xe07,%eax
  8014c7:	50                   	push   %eax
  8014c8:	56                   	push   %esi
  8014c9:	6a 00                	push   $0x0
  8014cb:	52                   	push   %edx
  8014cc:	6a 00                	push   $0x0
  8014ce:	e8 cf fa ff ff       	call   800fa2 <sys_page_map>
  8014d3:	89 c3                	mov    %eax,%ebx
  8014d5:	83 c4 20             	add    $0x20,%esp
  8014d8:	85 c0                	test   %eax,%eax
  8014da:	78 31                	js     80150d <dup+0xd5>
		goto err;

	return newfdnum;
  8014dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014df:	89 d8                	mov    %ebx,%eax
  8014e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014e4:	5b                   	pop    %ebx
  8014e5:	5e                   	pop    %esi
  8014e6:	5f                   	pop    %edi
  8014e7:	5d                   	pop    %ebp
  8014e8:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014e9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014f0:	83 ec 0c             	sub    $0xc,%esp
  8014f3:	25 07 0e 00 00       	and    $0xe07,%eax
  8014f8:	50                   	push   %eax
  8014f9:	57                   	push   %edi
  8014fa:	6a 00                	push   $0x0
  8014fc:	53                   	push   %ebx
  8014fd:	6a 00                	push   $0x0
  8014ff:	e8 9e fa ff ff       	call   800fa2 <sys_page_map>
  801504:	89 c3                	mov    %eax,%ebx
  801506:	83 c4 20             	add    $0x20,%esp
  801509:	85 c0                	test   %eax,%eax
  80150b:	79 a3                	jns    8014b0 <dup+0x78>
	sys_page_unmap(0, newfd);
  80150d:	83 ec 08             	sub    $0x8,%esp
  801510:	56                   	push   %esi
  801511:	6a 00                	push   $0x0
  801513:	e8 d0 fa ff ff       	call   800fe8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801518:	83 c4 08             	add    $0x8,%esp
  80151b:	57                   	push   %edi
  80151c:	6a 00                	push   $0x0
  80151e:	e8 c5 fa ff ff       	call   800fe8 <sys_page_unmap>
	return r;
  801523:	83 c4 10             	add    $0x10,%esp
  801526:	eb b7                	jmp    8014df <dup+0xa7>

00801528 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801528:	f3 0f 1e fb          	endbr32 
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	53                   	push   %ebx
  801530:	83 ec 1c             	sub    $0x1c,%esp
  801533:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801536:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801539:	50                   	push   %eax
  80153a:	53                   	push   %ebx
  80153b:	e8 60 fd ff ff       	call   8012a0 <fd_lookup>
  801540:	83 c4 10             	add    $0x10,%esp
  801543:	85 c0                	test   %eax,%eax
  801545:	78 3f                	js     801586 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801547:	83 ec 08             	sub    $0x8,%esp
  80154a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80154d:	50                   	push   %eax
  80154e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801551:	ff 30                	pushl  (%eax)
  801553:	e8 9c fd ff ff       	call   8012f4 <dev_lookup>
  801558:	83 c4 10             	add    $0x10,%esp
  80155b:	85 c0                	test   %eax,%eax
  80155d:	78 27                	js     801586 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80155f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801562:	8b 42 08             	mov    0x8(%edx),%eax
  801565:	83 e0 03             	and    $0x3,%eax
  801568:	83 f8 01             	cmp    $0x1,%eax
  80156b:	74 1e                	je     80158b <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80156d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801570:	8b 40 08             	mov    0x8(%eax),%eax
  801573:	85 c0                	test   %eax,%eax
  801575:	74 35                	je     8015ac <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801577:	83 ec 04             	sub    $0x4,%esp
  80157a:	ff 75 10             	pushl  0x10(%ebp)
  80157d:	ff 75 0c             	pushl  0xc(%ebp)
  801580:	52                   	push   %edx
  801581:	ff d0                	call   *%eax
  801583:	83 c4 10             	add    $0x10,%esp
}
  801586:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801589:	c9                   	leave  
  80158a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80158b:	a1 90 77 80 00       	mov    0x807790,%eax
  801590:	8b 40 48             	mov    0x48(%eax),%eax
  801593:	83 ec 04             	sub    $0x4,%esp
  801596:	53                   	push   %ebx
  801597:	50                   	push   %eax
  801598:	68 ad 31 80 00       	push   $0x8031ad
  80159d:	e8 6d ef ff ff       	call   80050f <cprintf>
		return -E_INVAL;
  8015a2:	83 c4 10             	add    $0x10,%esp
  8015a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015aa:	eb da                	jmp    801586 <read+0x5e>
		return -E_NOT_SUPP;
  8015ac:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015b1:	eb d3                	jmp    801586 <read+0x5e>

008015b3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015b3:	f3 0f 1e fb          	endbr32 
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	57                   	push   %edi
  8015bb:	56                   	push   %esi
  8015bc:	53                   	push   %ebx
  8015bd:	83 ec 0c             	sub    $0xc,%esp
  8015c0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015c3:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015cb:	eb 02                	jmp    8015cf <readn+0x1c>
  8015cd:	01 c3                	add    %eax,%ebx
  8015cf:	39 f3                	cmp    %esi,%ebx
  8015d1:	73 21                	jae    8015f4 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015d3:	83 ec 04             	sub    $0x4,%esp
  8015d6:	89 f0                	mov    %esi,%eax
  8015d8:	29 d8                	sub    %ebx,%eax
  8015da:	50                   	push   %eax
  8015db:	89 d8                	mov    %ebx,%eax
  8015dd:	03 45 0c             	add    0xc(%ebp),%eax
  8015e0:	50                   	push   %eax
  8015e1:	57                   	push   %edi
  8015e2:	e8 41 ff ff ff       	call   801528 <read>
		if (m < 0)
  8015e7:	83 c4 10             	add    $0x10,%esp
  8015ea:	85 c0                	test   %eax,%eax
  8015ec:	78 04                	js     8015f2 <readn+0x3f>
			return m;
		if (m == 0)
  8015ee:	75 dd                	jne    8015cd <readn+0x1a>
  8015f0:	eb 02                	jmp    8015f4 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015f2:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015f4:	89 d8                	mov    %ebx,%eax
  8015f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015f9:	5b                   	pop    %ebx
  8015fa:	5e                   	pop    %esi
  8015fb:	5f                   	pop    %edi
  8015fc:	5d                   	pop    %ebp
  8015fd:	c3                   	ret    

008015fe <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015fe:	f3 0f 1e fb          	endbr32 
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	53                   	push   %ebx
  801606:	83 ec 1c             	sub    $0x1c,%esp
  801609:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80160c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80160f:	50                   	push   %eax
  801610:	53                   	push   %ebx
  801611:	e8 8a fc ff ff       	call   8012a0 <fd_lookup>
  801616:	83 c4 10             	add    $0x10,%esp
  801619:	85 c0                	test   %eax,%eax
  80161b:	78 3a                	js     801657 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80161d:	83 ec 08             	sub    $0x8,%esp
  801620:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801623:	50                   	push   %eax
  801624:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801627:	ff 30                	pushl  (%eax)
  801629:	e8 c6 fc ff ff       	call   8012f4 <dev_lookup>
  80162e:	83 c4 10             	add    $0x10,%esp
  801631:	85 c0                	test   %eax,%eax
  801633:	78 22                	js     801657 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801635:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801638:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80163c:	74 1e                	je     80165c <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80163e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801641:	8b 52 0c             	mov    0xc(%edx),%edx
  801644:	85 d2                	test   %edx,%edx
  801646:	74 35                	je     80167d <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801648:	83 ec 04             	sub    $0x4,%esp
  80164b:	ff 75 10             	pushl  0x10(%ebp)
  80164e:	ff 75 0c             	pushl  0xc(%ebp)
  801651:	50                   	push   %eax
  801652:	ff d2                	call   *%edx
  801654:	83 c4 10             	add    $0x10,%esp
}
  801657:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80165c:	a1 90 77 80 00       	mov    0x807790,%eax
  801661:	8b 40 48             	mov    0x48(%eax),%eax
  801664:	83 ec 04             	sub    $0x4,%esp
  801667:	53                   	push   %ebx
  801668:	50                   	push   %eax
  801669:	68 c9 31 80 00       	push   $0x8031c9
  80166e:	e8 9c ee ff ff       	call   80050f <cprintf>
		return -E_INVAL;
  801673:	83 c4 10             	add    $0x10,%esp
  801676:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80167b:	eb da                	jmp    801657 <write+0x59>
		return -E_NOT_SUPP;
  80167d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801682:	eb d3                	jmp    801657 <write+0x59>

00801684 <seek>:

int
seek(int fdnum, off_t offset)
{
  801684:	f3 0f 1e fb          	endbr32 
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80168e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801691:	50                   	push   %eax
  801692:	ff 75 08             	pushl  0x8(%ebp)
  801695:	e8 06 fc ff ff       	call   8012a0 <fd_lookup>
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	85 c0                	test   %eax,%eax
  80169f:	78 0e                	js     8016af <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8016a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016b1:	f3 0f 1e fb          	endbr32 
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	53                   	push   %ebx
  8016b9:	83 ec 1c             	sub    $0x1c,%esp
  8016bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016c2:	50                   	push   %eax
  8016c3:	53                   	push   %ebx
  8016c4:	e8 d7 fb ff ff       	call   8012a0 <fd_lookup>
  8016c9:	83 c4 10             	add    $0x10,%esp
  8016cc:	85 c0                	test   %eax,%eax
  8016ce:	78 37                	js     801707 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016d0:	83 ec 08             	sub    $0x8,%esp
  8016d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d6:	50                   	push   %eax
  8016d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016da:	ff 30                	pushl  (%eax)
  8016dc:	e8 13 fc ff ff       	call   8012f4 <dev_lookup>
  8016e1:	83 c4 10             	add    $0x10,%esp
  8016e4:	85 c0                	test   %eax,%eax
  8016e6:	78 1f                	js     801707 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016eb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016ef:	74 1b                	je     80170c <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016f4:	8b 52 18             	mov    0x18(%edx),%edx
  8016f7:	85 d2                	test   %edx,%edx
  8016f9:	74 32                	je     80172d <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016fb:	83 ec 08             	sub    $0x8,%esp
  8016fe:	ff 75 0c             	pushl  0xc(%ebp)
  801701:	50                   	push   %eax
  801702:	ff d2                	call   *%edx
  801704:	83 c4 10             	add    $0x10,%esp
}
  801707:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80170c:	a1 90 77 80 00       	mov    0x807790,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801711:	8b 40 48             	mov    0x48(%eax),%eax
  801714:	83 ec 04             	sub    $0x4,%esp
  801717:	53                   	push   %ebx
  801718:	50                   	push   %eax
  801719:	68 8c 31 80 00       	push   $0x80318c
  80171e:	e8 ec ed ff ff       	call   80050f <cprintf>
		return -E_INVAL;
  801723:	83 c4 10             	add    $0x10,%esp
  801726:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80172b:	eb da                	jmp    801707 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80172d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801732:	eb d3                	jmp    801707 <ftruncate+0x56>

00801734 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801734:	f3 0f 1e fb          	endbr32 
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	53                   	push   %ebx
  80173c:	83 ec 1c             	sub    $0x1c,%esp
  80173f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801742:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801745:	50                   	push   %eax
  801746:	ff 75 08             	pushl  0x8(%ebp)
  801749:	e8 52 fb ff ff       	call   8012a0 <fd_lookup>
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	85 c0                	test   %eax,%eax
  801753:	78 4b                	js     8017a0 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801755:	83 ec 08             	sub    $0x8,%esp
  801758:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80175b:	50                   	push   %eax
  80175c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175f:	ff 30                	pushl  (%eax)
  801761:	e8 8e fb ff ff       	call   8012f4 <dev_lookup>
  801766:	83 c4 10             	add    $0x10,%esp
  801769:	85 c0                	test   %eax,%eax
  80176b:	78 33                	js     8017a0 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80176d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801770:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801774:	74 2f                	je     8017a5 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801776:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801779:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801780:	00 00 00 
	stat->st_isdir = 0;
  801783:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80178a:	00 00 00 
	stat->st_dev = dev;
  80178d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801793:	83 ec 08             	sub    $0x8,%esp
  801796:	53                   	push   %ebx
  801797:	ff 75 f0             	pushl  -0x10(%ebp)
  80179a:	ff 50 14             	call   *0x14(%eax)
  80179d:	83 c4 10             	add    $0x10,%esp
}
  8017a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    
		return -E_NOT_SUPP;
  8017a5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017aa:	eb f4                	jmp    8017a0 <fstat+0x6c>

008017ac <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017ac:	f3 0f 1e fb          	endbr32 
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	56                   	push   %esi
  8017b4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017b5:	83 ec 08             	sub    $0x8,%esp
  8017b8:	6a 00                	push   $0x0
  8017ba:	ff 75 08             	pushl  0x8(%ebp)
  8017bd:	e8 fb 01 00 00       	call   8019bd <open>
  8017c2:	89 c3                	mov    %eax,%ebx
  8017c4:	83 c4 10             	add    $0x10,%esp
  8017c7:	85 c0                	test   %eax,%eax
  8017c9:	78 1b                	js     8017e6 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8017cb:	83 ec 08             	sub    $0x8,%esp
  8017ce:	ff 75 0c             	pushl  0xc(%ebp)
  8017d1:	50                   	push   %eax
  8017d2:	e8 5d ff ff ff       	call   801734 <fstat>
  8017d7:	89 c6                	mov    %eax,%esi
	close(fd);
  8017d9:	89 1c 24             	mov    %ebx,(%esp)
  8017dc:	e8 fd fb ff ff       	call   8013de <close>
	return r;
  8017e1:	83 c4 10             	add    $0x10,%esp
  8017e4:	89 f3                	mov    %esi,%ebx
}
  8017e6:	89 d8                	mov    %ebx,%eax
  8017e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017eb:	5b                   	pop    %ebx
  8017ec:	5e                   	pop    %esi
  8017ed:	5d                   	pop    %ebp
  8017ee:	c3                   	ret    

008017ef <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	56                   	push   %esi
  8017f3:	53                   	push   %ebx
  8017f4:	89 c6                	mov    %eax,%esi
  8017f6:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017f8:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8017ff:	74 27                	je     801828 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801801:	6a 07                	push   $0x7
  801803:	68 00 80 80 00       	push   $0x808000
  801808:	56                   	push   %esi
  801809:	ff 35 00 60 80 00    	pushl  0x806000
  80180f:	e8 5a 11 00 00       	call   80296e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801814:	83 c4 0c             	add    $0xc,%esp
  801817:	6a 00                	push   $0x0
  801819:	53                   	push   %ebx
  80181a:	6a 00                	push   $0x0
  80181c:	e8 c8 10 00 00       	call   8028e9 <ipc_recv>
}
  801821:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801824:	5b                   	pop    %ebx
  801825:	5e                   	pop    %esi
  801826:	5d                   	pop    %ebp
  801827:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801828:	83 ec 0c             	sub    $0xc,%esp
  80182b:	6a 01                	push   $0x1
  80182d:	e8 94 11 00 00       	call   8029c6 <ipc_find_env>
  801832:	a3 00 60 80 00       	mov    %eax,0x806000
  801837:	83 c4 10             	add    $0x10,%esp
  80183a:	eb c5                	jmp    801801 <fsipc+0x12>

0080183c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80183c:	f3 0f 1e fb          	endbr32 
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8b 40 0c             	mov    0xc(%eax),%eax
  80184c:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.set_size.req_size = newsize;
  801851:	8b 45 0c             	mov    0xc(%ebp),%eax
  801854:	a3 04 80 80 00       	mov    %eax,0x808004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801859:	ba 00 00 00 00       	mov    $0x0,%edx
  80185e:	b8 02 00 00 00       	mov    $0x2,%eax
  801863:	e8 87 ff ff ff       	call   8017ef <fsipc>
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <devfile_flush>:
{
  80186a:	f3 0f 1e fb          	endbr32 
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801874:	8b 45 08             	mov    0x8(%ebp),%eax
  801877:	8b 40 0c             	mov    0xc(%eax),%eax
  80187a:	a3 00 80 80 00       	mov    %eax,0x808000
	return fsipc(FSREQ_FLUSH, NULL);
  80187f:	ba 00 00 00 00       	mov    $0x0,%edx
  801884:	b8 06 00 00 00       	mov    $0x6,%eax
  801889:	e8 61 ff ff ff       	call   8017ef <fsipc>
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <devfile_stat>:
{
  801890:	f3 0f 1e fb          	endbr32 
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	53                   	push   %ebx
  801898:	83 ec 04             	sub    $0x4,%esp
  80189b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a4:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ae:	b8 05 00 00 00       	mov    $0x5,%eax
  8018b3:	e8 37 ff ff ff       	call   8017ef <fsipc>
  8018b8:	85 c0                	test   %eax,%eax
  8018ba:	78 2c                	js     8018e8 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018bc:	83 ec 08             	sub    $0x8,%esp
  8018bf:	68 00 80 80 00       	push   $0x808000
  8018c4:	53                   	push   %ebx
  8018c5:	e8 4f f2 ff ff       	call   800b19 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018ca:	a1 80 80 80 00       	mov    0x808080,%eax
  8018cf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018d5:	a1 84 80 80 00       	mov    0x808084,%eax
  8018da:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018e0:	83 c4 10             	add    $0x10,%esp
  8018e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <devfile_write>:
{
  8018ed:	f3 0f 1e fb          	endbr32 
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	83 ec 0c             	sub    $0xc,%esp
  8018f7:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8018fd:	8b 52 0c             	mov    0xc(%edx),%edx
  801900:	89 15 00 80 80 00    	mov    %edx,0x808000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801906:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80190b:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801910:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801913:	a3 04 80 80 00       	mov    %eax,0x808004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801918:	50                   	push   %eax
  801919:	ff 75 0c             	pushl  0xc(%ebp)
  80191c:	68 08 80 80 00       	push   $0x808008
  801921:	e8 a9 f3 ff ff       	call   800ccf <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801926:	ba 00 00 00 00       	mov    $0x0,%edx
  80192b:	b8 04 00 00 00       	mov    $0x4,%eax
  801930:	e8 ba fe ff ff       	call   8017ef <fsipc>
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <devfile_read>:
{
  801937:	f3 0f 1e fb          	endbr32 
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	56                   	push   %esi
  80193f:	53                   	push   %ebx
  801940:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	8b 40 0c             	mov    0xc(%eax),%eax
  801949:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.read.req_n = n;
  80194e:	89 35 04 80 80 00    	mov    %esi,0x808004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801954:	ba 00 00 00 00       	mov    $0x0,%edx
  801959:	b8 03 00 00 00       	mov    $0x3,%eax
  80195e:	e8 8c fe ff ff       	call   8017ef <fsipc>
  801963:	89 c3                	mov    %eax,%ebx
  801965:	85 c0                	test   %eax,%eax
  801967:	78 1f                	js     801988 <devfile_read+0x51>
	assert(r <= n);
  801969:	39 f0                	cmp    %esi,%eax
  80196b:	77 24                	ja     801991 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80196d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801972:	7f 33                	jg     8019a7 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801974:	83 ec 04             	sub    $0x4,%esp
  801977:	50                   	push   %eax
  801978:	68 00 80 80 00       	push   $0x808000
  80197d:	ff 75 0c             	pushl  0xc(%ebp)
  801980:	e8 4a f3 ff ff       	call   800ccf <memmove>
	return r;
  801985:	83 c4 10             	add    $0x10,%esp
}
  801988:	89 d8                	mov    %ebx,%eax
  80198a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80198d:	5b                   	pop    %ebx
  80198e:	5e                   	pop    %esi
  80198f:	5d                   	pop    %ebp
  801990:	c3                   	ret    
	assert(r <= n);
  801991:	68 fc 31 80 00       	push   $0x8031fc
  801996:	68 03 32 80 00       	push   $0x803203
  80199b:	6a 7c                	push   $0x7c
  80199d:	68 18 32 80 00       	push   $0x803218
  8019a2:	e8 81 ea ff ff       	call   800428 <_panic>
	assert(r <= PGSIZE);
  8019a7:	68 23 32 80 00       	push   $0x803223
  8019ac:	68 03 32 80 00       	push   $0x803203
  8019b1:	6a 7d                	push   $0x7d
  8019b3:	68 18 32 80 00       	push   $0x803218
  8019b8:	e8 6b ea ff ff       	call   800428 <_panic>

008019bd <open>:
{
  8019bd:	f3 0f 1e fb          	endbr32 
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
  8019c4:	56                   	push   %esi
  8019c5:	53                   	push   %ebx
  8019c6:	83 ec 1c             	sub    $0x1c,%esp
  8019c9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019cc:	56                   	push   %esi
  8019cd:	e8 04 f1 ff ff       	call   800ad6 <strlen>
  8019d2:	83 c4 10             	add    $0x10,%esp
  8019d5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019da:	7f 6c                	jg     801a48 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8019dc:	83 ec 0c             	sub    $0xc,%esp
  8019df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e2:	50                   	push   %eax
  8019e3:	e8 62 f8 ff ff       	call   80124a <fd_alloc>
  8019e8:	89 c3                	mov    %eax,%ebx
  8019ea:	83 c4 10             	add    $0x10,%esp
  8019ed:	85 c0                	test   %eax,%eax
  8019ef:	78 3c                	js     801a2d <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8019f1:	83 ec 08             	sub    $0x8,%esp
  8019f4:	56                   	push   %esi
  8019f5:	68 00 80 80 00       	push   $0x808000
  8019fa:	e8 1a f1 ff ff       	call   800b19 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a02:	a3 00 84 80 00       	mov    %eax,0x808400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a0f:	e8 db fd ff ff       	call   8017ef <fsipc>
  801a14:	89 c3                	mov    %eax,%ebx
  801a16:	83 c4 10             	add    $0x10,%esp
  801a19:	85 c0                	test   %eax,%eax
  801a1b:	78 19                	js     801a36 <open+0x79>
	return fd2num(fd);
  801a1d:	83 ec 0c             	sub    $0xc,%esp
  801a20:	ff 75 f4             	pushl  -0xc(%ebp)
  801a23:	e8 f3 f7 ff ff       	call   80121b <fd2num>
  801a28:	89 c3                	mov    %eax,%ebx
  801a2a:	83 c4 10             	add    $0x10,%esp
}
  801a2d:	89 d8                	mov    %ebx,%eax
  801a2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a32:	5b                   	pop    %ebx
  801a33:	5e                   	pop    %esi
  801a34:	5d                   	pop    %ebp
  801a35:	c3                   	ret    
		fd_close(fd, 0);
  801a36:	83 ec 08             	sub    $0x8,%esp
  801a39:	6a 00                	push   $0x0
  801a3b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a3e:	e8 10 f9 ff ff       	call   801353 <fd_close>
		return r;
  801a43:	83 c4 10             	add    $0x10,%esp
  801a46:	eb e5                	jmp    801a2d <open+0x70>
		return -E_BAD_PATH;
  801a48:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a4d:	eb de                	jmp    801a2d <open+0x70>

00801a4f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a4f:	f3 0f 1e fb          	endbr32 
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a59:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5e:	b8 08 00 00 00       	mov    $0x8,%eax
  801a63:	e8 87 fd ff ff       	call   8017ef <fsipc>
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801a6a:	f3 0f 1e fb          	endbr32 
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	57                   	push   %edi
  801a72:	56                   	push   %esi
  801a73:	53                   	push   %ebx
  801a74:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801a7a:	6a 00                	push   $0x0
  801a7c:	ff 75 08             	pushl  0x8(%ebp)
  801a7f:	e8 39 ff ff ff       	call   8019bd <open>
  801a84:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801a8a:	83 c4 10             	add    $0x10,%esp
  801a8d:	85 c0                	test   %eax,%eax
  801a8f:	0f 88 e7 04 00 00    	js     801f7c <spawn+0x512>
  801a95:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801a97:	83 ec 04             	sub    $0x4,%esp
  801a9a:	68 00 02 00 00       	push   $0x200
  801a9f:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801aa5:	50                   	push   %eax
  801aa6:	52                   	push   %edx
  801aa7:	e8 07 fb ff ff       	call   8015b3 <readn>
  801aac:	83 c4 10             	add    $0x10,%esp
  801aaf:	3d 00 02 00 00       	cmp    $0x200,%eax
  801ab4:	75 7e                	jne    801b34 <spawn+0xca>
	    || elf->e_magic != ELF_MAGIC) {
  801ab6:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801abd:	45 4c 46 
  801ac0:	75 72                	jne    801b34 <spawn+0xca>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801ac2:	b8 07 00 00 00       	mov    $0x7,%eax
  801ac7:	cd 30                	int    $0x30
  801ac9:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801acf:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801ad5:	85 c0                	test   %eax,%eax
  801ad7:	0f 88 93 04 00 00    	js     801f70 <spawn+0x506>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801add:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ae2:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801ae5:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801aeb:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801af1:	b9 11 00 00 00       	mov    $0x11,%ecx
  801af6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801af8:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801afe:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801b04:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801b09:	be 00 00 00 00       	mov    $0x0,%esi
  801b0e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b11:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  801b18:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801b1b:	85 c0                	test   %eax,%eax
  801b1d:	74 4d                	je     801b6c <spawn+0x102>
		string_size += strlen(argv[argc]) + 1;
  801b1f:	83 ec 0c             	sub    $0xc,%esp
  801b22:	50                   	push   %eax
  801b23:	e8 ae ef ff ff       	call   800ad6 <strlen>
  801b28:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801b2c:	83 c3 01             	add    $0x1,%ebx
  801b2f:	83 c4 10             	add    $0x10,%esp
  801b32:	eb dd                	jmp    801b11 <spawn+0xa7>
		close(fd);
  801b34:	83 ec 0c             	sub    $0xc,%esp
  801b37:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801b3d:	e8 9c f8 ff ff       	call   8013de <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801b42:	83 c4 0c             	add    $0xc,%esp
  801b45:	68 7f 45 4c 46       	push   $0x464c457f
  801b4a:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801b50:	68 2f 32 80 00       	push   $0x80322f
  801b55:	e8 b5 e9 ff ff       	call   80050f <cprintf>
		return -E_NOT_EXEC;
  801b5a:	83 c4 10             	add    $0x10,%esp
  801b5d:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801b64:	ff ff ff 
  801b67:	e9 10 04 00 00       	jmp    801f7c <spawn+0x512>
  801b6c:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801b72:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801b78:	bf 00 10 40 00       	mov    $0x401000,%edi
  801b7d:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801b7f:	89 fa                	mov    %edi,%edx
  801b81:	83 e2 fc             	and    $0xfffffffc,%edx
  801b84:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801b8b:	29 c2                	sub    %eax,%edx
  801b8d:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801b93:	8d 42 f8             	lea    -0x8(%edx),%eax
  801b96:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801b9b:	0f 86 fe 03 00 00    	jbe    801f9f <spawn+0x535>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801ba1:	83 ec 04             	sub    $0x4,%esp
  801ba4:	6a 07                	push   $0x7
  801ba6:	68 00 00 40 00       	push   $0x400000
  801bab:	6a 00                	push   $0x0
  801bad:	e8 a9 f3 ff ff       	call   800f5b <sys_page_alloc>
  801bb2:	83 c4 10             	add    $0x10,%esp
  801bb5:	85 c0                	test   %eax,%eax
  801bb7:	0f 88 e7 03 00 00    	js     801fa4 <spawn+0x53a>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801bbd:	be 00 00 00 00       	mov    $0x0,%esi
  801bc2:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801bc8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801bcb:	eb 30                	jmp    801bfd <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  801bcd:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801bd3:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801bd9:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801bdc:	83 ec 08             	sub    $0x8,%esp
  801bdf:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801be2:	57                   	push   %edi
  801be3:	e8 31 ef ff ff       	call   800b19 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801be8:	83 c4 04             	add    $0x4,%esp
  801beb:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801bee:	e8 e3 ee ff ff       	call   800ad6 <strlen>
  801bf3:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801bf7:	83 c6 01             	add    $0x1,%esi
  801bfa:	83 c4 10             	add    $0x10,%esp
  801bfd:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801c03:	7f c8                	jg     801bcd <spawn+0x163>
	}
	argv_store[argc] = 0;
  801c05:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c0b:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801c11:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801c18:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801c1e:	0f 85 86 00 00 00    	jne    801caa <spawn+0x240>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801c24:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801c2a:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  801c30:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801c33:	89 c8                	mov    %ecx,%eax
  801c35:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801c3b:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801c3e:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801c43:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801c49:	83 ec 0c             	sub    $0xc,%esp
  801c4c:	6a 07                	push   $0x7
  801c4e:	68 00 d0 bf ee       	push   $0xeebfd000
  801c53:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c59:	68 00 00 40 00       	push   $0x400000
  801c5e:	6a 00                	push   $0x0
  801c60:	e8 3d f3 ff ff       	call   800fa2 <sys_page_map>
  801c65:	89 c3                	mov    %eax,%ebx
  801c67:	83 c4 20             	add    $0x20,%esp
  801c6a:	85 c0                	test   %eax,%eax
  801c6c:	0f 88 3a 03 00 00    	js     801fac <spawn+0x542>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801c72:	83 ec 08             	sub    $0x8,%esp
  801c75:	68 00 00 40 00       	push   $0x400000
  801c7a:	6a 00                	push   $0x0
  801c7c:	e8 67 f3 ff ff       	call   800fe8 <sys_page_unmap>
  801c81:	89 c3                	mov    %eax,%ebx
  801c83:	83 c4 10             	add    $0x10,%esp
  801c86:	85 c0                	test   %eax,%eax
  801c88:	0f 88 1e 03 00 00    	js     801fac <spawn+0x542>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801c8e:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801c94:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c9b:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801ca2:	00 00 00 
  801ca5:	e9 4f 01 00 00       	jmp    801df9 <spawn+0x38f>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801caa:	68 a4 32 80 00       	push   $0x8032a4
  801caf:	68 03 32 80 00       	push   $0x803203
  801cb4:	68 f2 00 00 00       	push   $0xf2
  801cb9:	68 49 32 80 00       	push   $0x803249
  801cbe:	e8 65 e7 ff ff       	call   800428 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801cc3:	83 ec 04             	sub    $0x4,%esp
  801cc6:	6a 07                	push   $0x7
  801cc8:	68 00 00 40 00       	push   $0x400000
  801ccd:	6a 00                	push   $0x0
  801ccf:	e8 87 f2 ff ff       	call   800f5b <sys_page_alloc>
  801cd4:	83 c4 10             	add    $0x10,%esp
  801cd7:	85 c0                	test   %eax,%eax
  801cd9:	0f 88 ab 02 00 00    	js     801f8a <spawn+0x520>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801cdf:	83 ec 08             	sub    $0x8,%esp
  801ce2:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801ce8:	01 f0                	add    %esi,%eax
  801cea:	50                   	push   %eax
  801ceb:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801cf1:	e8 8e f9 ff ff       	call   801684 <seek>
  801cf6:	83 c4 10             	add    $0x10,%esp
  801cf9:	85 c0                	test   %eax,%eax
  801cfb:	0f 88 90 02 00 00    	js     801f91 <spawn+0x527>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801d01:	83 ec 04             	sub    $0x4,%esp
  801d04:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801d0a:	29 f0                	sub    %esi,%eax
  801d0c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d11:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801d16:	0f 47 c1             	cmova  %ecx,%eax
  801d19:	50                   	push   %eax
  801d1a:	68 00 00 40 00       	push   $0x400000
  801d1f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d25:	e8 89 f8 ff ff       	call   8015b3 <readn>
  801d2a:	83 c4 10             	add    $0x10,%esp
  801d2d:	85 c0                	test   %eax,%eax
  801d2f:	0f 88 63 02 00 00    	js     801f98 <spawn+0x52e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801d35:	83 ec 0c             	sub    $0xc,%esp
  801d38:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801d3e:	53                   	push   %ebx
  801d3f:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801d45:	68 00 00 40 00       	push   $0x400000
  801d4a:	6a 00                	push   $0x0
  801d4c:	e8 51 f2 ff ff       	call   800fa2 <sys_page_map>
  801d51:	83 c4 20             	add    $0x20,%esp
  801d54:	85 c0                	test   %eax,%eax
  801d56:	78 7c                	js     801dd4 <spawn+0x36a>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801d58:	83 ec 08             	sub    $0x8,%esp
  801d5b:	68 00 00 40 00       	push   $0x400000
  801d60:	6a 00                	push   $0x0
  801d62:	e8 81 f2 ff ff       	call   800fe8 <sys_page_unmap>
  801d67:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801d6a:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801d70:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d76:	89 fe                	mov    %edi,%esi
  801d78:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801d7e:	76 69                	jbe    801de9 <spawn+0x37f>
		if (i >= filesz) {
  801d80:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801d86:	0f 87 37 ff ff ff    	ja     801cc3 <spawn+0x259>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801d8c:	83 ec 04             	sub    $0x4,%esp
  801d8f:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801d95:	53                   	push   %ebx
  801d96:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801d9c:	e8 ba f1 ff ff       	call   800f5b <sys_page_alloc>
  801da1:	83 c4 10             	add    $0x10,%esp
  801da4:	85 c0                	test   %eax,%eax
  801da6:	79 c2                	jns    801d6a <spawn+0x300>
  801da8:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801daa:	83 ec 0c             	sub    $0xc,%esp
  801dad:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801db3:	e8 18 f1 ff ff       	call   800ed0 <sys_env_destroy>
	close(fd);
  801db8:	83 c4 04             	add    $0x4,%esp
  801dbb:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801dc1:	e8 18 f6 ff ff       	call   8013de <close>
	return r;
  801dc6:	83 c4 10             	add    $0x10,%esp
  801dc9:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801dcf:	e9 a8 01 00 00       	jmp    801f7c <spawn+0x512>
				panic("spawn: sys_page_map data: %e", r);
  801dd4:	50                   	push   %eax
  801dd5:	68 55 32 80 00       	push   $0x803255
  801dda:	68 25 01 00 00       	push   $0x125
  801ddf:	68 49 32 80 00       	push   $0x803249
  801de4:	e8 3f e6 ff ff       	call   800428 <_panic>
  801de9:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801def:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801df6:	83 c6 20             	add    $0x20,%esi
  801df9:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801e00:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801e06:	7e 6d                	jle    801e75 <spawn+0x40b>
		if (ph->p_type != ELF_PROG_LOAD)
  801e08:	83 3e 01             	cmpl   $0x1,(%esi)
  801e0b:	75 e2                	jne    801def <spawn+0x385>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801e0d:	8b 46 18             	mov    0x18(%esi),%eax
  801e10:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801e13:	83 f8 01             	cmp    $0x1,%eax
  801e16:	19 c0                	sbb    %eax,%eax
  801e18:	83 e0 fe             	and    $0xfffffffe,%eax
  801e1b:	83 c0 07             	add    $0x7,%eax
  801e1e:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801e24:	8b 4e 04             	mov    0x4(%esi),%ecx
  801e27:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801e2d:	8b 56 10             	mov    0x10(%esi),%edx
  801e30:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801e36:	8b 7e 14             	mov    0x14(%esi),%edi
  801e39:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801e3f:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801e42:	89 d8                	mov    %ebx,%eax
  801e44:	25 ff 0f 00 00       	and    $0xfff,%eax
  801e49:	74 1a                	je     801e65 <spawn+0x3fb>
		va -= i;
  801e4b:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801e4d:	01 c7                	add    %eax,%edi
  801e4f:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801e55:	01 c2                	add    %eax,%edx
  801e57:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801e5d:	29 c1                	sub    %eax,%ecx
  801e5f:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801e65:	bf 00 00 00 00       	mov    $0x0,%edi
  801e6a:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801e70:	e9 01 ff ff ff       	jmp    801d76 <spawn+0x30c>
	close(fd);
  801e75:	83 ec 0c             	sub    $0xc,%esp
  801e78:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801e7e:	e8 5b f5 ff ff       	call   8013de <close>
  801e83:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  801e86:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e8b:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801e91:	eb 0e                	jmp    801ea1 <spawn+0x437>
  801e93:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801e99:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801e9f:	74 5a                	je     801efb <spawn+0x491>
		if((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)){
  801ea1:	89 d8                	mov    %ebx,%eax
  801ea3:	c1 e8 16             	shr    $0x16,%eax
  801ea6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ead:	a8 01                	test   $0x1,%al
  801eaf:	74 e2                	je     801e93 <spawn+0x429>
  801eb1:	89 d8                	mov    %ebx,%eax
  801eb3:	c1 e8 0c             	shr    $0xc,%eax
  801eb6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ebd:	f6 c2 01             	test   $0x1,%dl
  801ec0:	74 d1                	je     801e93 <spawn+0x429>
  801ec2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ec9:	f6 c2 04             	test   $0x4,%dl
  801ecc:	74 c5                	je     801e93 <spawn+0x429>
  801ece:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ed5:	f6 c6 04             	test   $0x4,%dh
  801ed8:	74 b9                	je     801e93 <spawn+0x429>
			if(r = sys_page_map(0, (void*)addr, child, (void*)addr, (uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  801eda:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ee1:	83 ec 0c             	sub    $0xc,%esp
  801ee4:	25 07 0e 00 00       	and    $0xe07,%eax
  801ee9:	50                   	push   %eax
  801eea:	53                   	push   %ebx
  801eeb:	56                   	push   %esi
  801eec:	53                   	push   %ebx
  801eed:	6a 00                	push   $0x0
  801eef:	e8 ae f0 ff ff       	call   800fa2 <sys_page_map>
  801ef4:	83 c4 20             	add    $0x20,%esp
  801ef7:	85 c0                	test   %eax,%eax
  801ef9:	79 98                	jns    801e93 <spawn+0x429>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801efb:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801f02:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801f05:	83 ec 08             	sub    $0x8,%esp
  801f08:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801f0e:	50                   	push   %eax
  801f0f:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801f15:	e8 5a f1 ff ff       	call   801074 <sys_env_set_trapframe>
  801f1a:	83 c4 10             	add    $0x10,%esp
  801f1d:	85 c0                	test   %eax,%eax
  801f1f:	78 25                	js     801f46 <spawn+0x4dc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801f21:	83 ec 08             	sub    $0x8,%esp
  801f24:	6a 02                	push   $0x2
  801f26:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801f2c:	e8 fd f0 ff ff       	call   80102e <sys_env_set_status>
  801f31:	83 c4 10             	add    $0x10,%esp
  801f34:	85 c0                	test   %eax,%eax
  801f36:	78 23                	js     801f5b <spawn+0x4f1>
	return child;
  801f38:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801f3e:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801f44:	eb 36                	jmp    801f7c <spawn+0x512>
		panic("sys_env_set_trapframe: %e", r);
  801f46:	50                   	push   %eax
  801f47:	68 72 32 80 00       	push   $0x803272
  801f4c:	68 86 00 00 00       	push   $0x86
  801f51:	68 49 32 80 00       	push   $0x803249
  801f56:	e8 cd e4 ff ff       	call   800428 <_panic>
		panic("sys_env_set_status: %e", r);
  801f5b:	50                   	push   %eax
  801f5c:	68 8c 32 80 00       	push   $0x80328c
  801f61:	68 89 00 00 00       	push   $0x89
  801f66:	68 49 32 80 00       	push   $0x803249
  801f6b:	e8 b8 e4 ff ff       	call   800428 <_panic>
		return r;
  801f70:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801f76:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801f7c:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801f82:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f85:	5b                   	pop    %ebx
  801f86:	5e                   	pop    %esi
  801f87:	5f                   	pop    %edi
  801f88:	5d                   	pop    %ebp
  801f89:	c3                   	ret    
  801f8a:	89 c7                	mov    %eax,%edi
  801f8c:	e9 19 fe ff ff       	jmp    801daa <spawn+0x340>
  801f91:	89 c7                	mov    %eax,%edi
  801f93:	e9 12 fe ff ff       	jmp    801daa <spawn+0x340>
  801f98:	89 c7                	mov    %eax,%edi
  801f9a:	e9 0b fe ff ff       	jmp    801daa <spawn+0x340>
		return -E_NO_MEM;
  801f9f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(addr = 0; addr < USTACKTOP; addr += PGSIZE){
  801fa4:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801faa:	eb d0                	jmp    801f7c <spawn+0x512>
	sys_page_unmap(0, UTEMP);
  801fac:	83 ec 08             	sub    $0x8,%esp
  801faf:	68 00 00 40 00       	push   $0x400000
  801fb4:	6a 00                	push   $0x0
  801fb6:	e8 2d f0 ff ff       	call   800fe8 <sys_page_unmap>
  801fbb:	83 c4 10             	add    $0x10,%esp
  801fbe:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801fc4:	eb b6                	jmp    801f7c <spawn+0x512>

00801fc6 <spawnl>:
{
  801fc6:	f3 0f 1e fb          	endbr32 
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
  801fcd:	57                   	push   %edi
  801fce:	56                   	push   %esi
  801fcf:	53                   	push   %ebx
  801fd0:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801fd3:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801fd6:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801fdb:	8d 4a 04             	lea    0x4(%edx),%ecx
  801fde:	83 3a 00             	cmpl   $0x0,(%edx)
  801fe1:	74 07                	je     801fea <spawnl+0x24>
		argc++;
  801fe3:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801fe6:	89 ca                	mov    %ecx,%edx
  801fe8:	eb f1                	jmp    801fdb <spawnl+0x15>
	const char *argv[argc+2];
  801fea:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801ff1:	89 d1                	mov    %edx,%ecx
  801ff3:	83 e1 f0             	and    $0xfffffff0,%ecx
  801ff6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801ffc:	89 e6                	mov    %esp,%esi
  801ffe:	29 d6                	sub    %edx,%esi
  802000:	89 f2                	mov    %esi,%edx
  802002:	39 d4                	cmp    %edx,%esp
  802004:	74 10                	je     802016 <spawnl+0x50>
  802006:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  80200c:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  802013:	00 
  802014:	eb ec                	jmp    802002 <spawnl+0x3c>
  802016:	89 ca                	mov    %ecx,%edx
  802018:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  80201e:	29 d4                	sub    %edx,%esp
  802020:	85 d2                	test   %edx,%edx
  802022:	74 05                	je     802029 <spawnl+0x63>
  802024:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  802029:	8d 74 24 03          	lea    0x3(%esp),%esi
  80202d:	89 f2                	mov    %esi,%edx
  80202f:	c1 ea 02             	shr    $0x2,%edx
  802032:	83 e6 fc             	and    $0xfffffffc,%esi
  802035:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802037:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80203a:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802041:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802048:	00 
	va_start(vl, arg0);
  802049:	8d 4d 10             	lea    0x10(%ebp),%ecx
  80204c:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  80204e:	b8 00 00 00 00       	mov    $0x0,%eax
  802053:	eb 0b                	jmp    802060 <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  802055:	83 c0 01             	add    $0x1,%eax
  802058:	8b 39                	mov    (%ecx),%edi
  80205a:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  80205d:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802060:	39 d0                	cmp    %edx,%eax
  802062:	75 f1                	jne    802055 <spawnl+0x8f>
	return spawn(prog, argv);
  802064:	83 ec 08             	sub    $0x8,%esp
  802067:	56                   	push   %esi
  802068:	ff 75 08             	pushl  0x8(%ebp)
  80206b:	e8 fa f9 ff ff       	call   801a6a <spawn>
}
  802070:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802073:	5b                   	pop    %ebx
  802074:	5e                   	pop    %esi
  802075:	5f                   	pop    %edi
  802076:	5d                   	pop    %ebp
  802077:	c3                   	ret    

00802078 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802078:	f3 0f 1e fb          	endbr32 
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802082:	68 ca 32 80 00       	push   $0x8032ca
  802087:	ff 75 0c             	pushl  0xc(%ebp)
  80208a:	e8 8a ea ff ff       	call   800b19 <strcpy>
	return 0;
}
  80208f:	b8 00 00 00 00       	mov    $0x0,%eax
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <devsock_close>:
{
  802096:	f3 0f 1e fb          	endbr32 
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	53                   	push   %ebx
  80209e:	83 ec 10             	sub    $0x10,%esp
  8020a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8020a4:	53                   	push   %ebx
  8020a5:	e8 59 09 00 00       	call   802a03 <pageref>
  8020aa:	89 c2                	mov    %eax,%edx
  8020ac:	83 c4 10             	add    $0x10,%esp
		return 0;
  8020af:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  8020b4:	83 fa 01             	cmp    $0x1,%edx
  8020b7:	74 05                	je     8020be <devsock_close+0x28>
}
  8020b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8020be:	83 ec 0c             	sub    $0xc,%esp
  8020c1:	ff 73 0c             	pushl  0xc(%ebx)
  8020c4:	e8 e3 02 00 00       	call   8023ac <nsipc_close>
  8020c9:	83 c4 10             	add    $0x10,%esp
  8020cc:	eb eb                	jmp    8020b9 <devsock_close+0x23>

008020ce <devsock_write>:
{
  8020ce:	f3 0f 1e fb          	endbr32 
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020d8:	6a 00                	push   $0x0
  8020da:	ff 75 10             	pushl  0x10(%ebp)
  8020dd:	ff 75 0c             	pushl  0xc(%ebp)
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	ff 70 0c             	pushl  0xc(%eax)
  8020e6:	e8 b5 03 00 00       	call   8024a0 <nsipc_send>
}
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <devsock_read>:
{
  8020ed:	f3 0f 1e fb          	endbr32 
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
  8020f4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8020f7:	6a 00                	push   $0x0
  8020f9:	ff 75 10             	pushl  0x10(%ebp)
  8020fc:	ff 75 0c             	pushl  0xc(%ebp)
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	ff 70 0c             	pushl  0xc(%eax)
  802105:	e8 1f 03 00 00       	call   802429 <nsipc_recv>
}
  80210a:	c9                   	leave  
  80210b:	c3                   	ret    

0080210c <fd2sockid>:
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802112:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802115:	52                   	push   %edx
  802116:	50                   	push   %eax
  802117:	e8 84 f1 ff ff       	call   8012a0 <fd_lookup>
  80211c:	83 c4 10             	add    $0x10,%esp
  80211f:	85 c0                	test   %eax,%eax
  802121:	78 10                	js     802133 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802126:	8b 0d ac 57 80 00    	mov    0x8057ac,%ecx
  80212c:	39 08                	cmp    %ecx,(%eax)
  80212e:	75 05                	jne    802135 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802130:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802133:	c9                   	leave  
  802134:	c3                   	ret    
		return -E_NOT_SUPP;
  802135:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80213a:	eb f7                	jmp    802133 <fd2sockid+0x27>

0080213c <alloc_sockfd>:
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	56                   	push   %esi
  802140:	53                   	push   %ebx
  802141:	83 ec 1c             	sub    $0x1c,%esp
  802144:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802146:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802149:	50                   	push   %eax
  80214a:	e8 fb f0 ff ff       	call   80124a <fd_alloc>
  80214f:	89 c3                	mov    %eax,%ebx
  802151:	83 c4 10             	add    $0x10,%esp
  802154:	85 c0                	test   %eax,%eax
  802156:	78 43                	js     80219b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802158:	83 ec 04             	sub    $0x4,%esp
  80215b:	68 07 04 00 00       	push   $0x407
  802160:	ff 75 f4             	pushl  -0xc(%ebp)
  802163:	6a 00                	push   $0x0
  802165:	e8 f1 ed ff ff       	call   800f5b <sys_page_alloc>
  80216a:	89 c3                	mov    %eax,%ebx
  80216c:	83 c4 10             	add    $0x10,%esp
  80216f:	85 c0                	test   %eax,%eax
  802171:	78 28                	js     80219b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802176:	8b 15 ac 57 80 00    	mov    0x8057ac,%edx
  80217c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80217e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802181:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802188:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80218b:	83 ec 0c             	sub    $0xc,%esp
  80218e:	50                   	push   %eax
  80218f:	e8 87 f0 ff ff       	call   80121b <fd2num>
  802194:	89 c3                	mov    %eax,%ebx
  802196:	83 c4 10             	add    $0x10,%esp
  802199:	eb 0c                	jmp    8021a7 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80219b:	83 ec 0c             	sub    $0xc,%esp
  80219e:	56                   	push   %esi
  80219f:	e8 08 02 00 00       	call   8023ac <nsipc_close>
		return r;
  8021a4:	83 c4 10             	add    $0x10,%esp
}
  8021a7:	89 d8                	mov    %ebx,%eax
  8021a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021ac:	5b                   	pop    %ebx
  8021ad:	5e                   	pop    %esi
  8021ae:	5d                   	pop    %ebp
  8021af:	c3                   	ret    

008021b0 <accept>:
{
  8021b0:	f3 0f 1e fb          	endbr32 
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	e8 4a ff ff ff       	call   80210c <fd2sockid>
  8021c2:	85 c0                	test   %eax,%eax
  8021c4:	78 1b                	js     8021e1 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021c6:	83 ec 04             	sub    $0x4,%esp
  8021c9:	ff 75 10             	pushl  0x10(%ebp)
  8021cc:	ff 75 0c             	pushl  0xc(%ebp)
  8021cf:	50                   	push   %eax
  8021d0:	e8 22 01 00 00       	call   8022f7 <nsipc_accept>
  8021d5:	83 c4 10             	add    $0x10,%esp
  8021d8:	85 c0                	test   %eax,%eax
  8021da:	78 05                	js     8021e1 <accept+0x31>
	return alloc_sockfd(r);
  8021dc:	e8 5b ff ff ff       	call   80213c <alloc_sockfd>
}
  8021e1:	c9                   	leave  
  8021e2:	c3                   	ret    

008021e3 <bind>:
{
  8021e3:	f3 0f 1e fb          	endbr32 
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
  8021ea:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	e8 17 ff ff ff       	call   80210c <fd2sockid>
  8021f5:	85 c0                	test   %eax,%eax
  8021f7:	78 12                	js     80220b <bind+0x28>
	return nsipc_bind(r, name, namelen);
  8021f9:	83 ec 04             	sub    $0x4,%esp
  8021fc:	ff 75 10             	pushl  0x10(%ebp)
  8021ff:	ff 75 0c             	pushl  0xc(%ebp)
  802202:	50                   	push   %eax
  802203:	e8 45 01 00 00       	call   80234d <nsipc_bind>
  802208:	83 c4 10             	add    $0x10,%esp
}
  80220b:	c9                   	leave  
  80220c:	c3                   	ret    

0080220d <shutdown>:
{
  80220d:	f3 0f 1e fb          	endbr32 
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
  802214:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	e8 ed fe ff ff       	call   80210c <fd2sockid>
  80221f:	85 c0                	test   %eax,%eax
  802221:	78 0f                	js     802232 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  802223:	83 ec 08             	sub    $0x8,%esp
  802226:	ff 75 0c             	pushl  0xc(%ebp)
  802229:	50                   	push   %eax
  80222a:	e8 57 01 00 00       	call   802386 <nsipc_shutdown>
  80222f:	83 c4 10             	add    $0x10,%esp
}
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <connect>:
{
  802234:	f3 0f 1e fb          	endbr32 
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
  80223b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	e8 c6 fe ff ff       	call   80210c <fd2sockid>
  802246:	85 c0                	test   %eax,%eax
  802248:	78 12                	js     80225c <connect+0x28>
	return nsipc_connect(r, name, namelen);
  80224a:	83 ec 04             	sub    $0x4,%esp
  80224d:	ff 75 10             	pushl  0x10(%ebp)
  802250:	ff 75 0c             	pushl  0xc(%ebp)
  802253:	50                   	push   %eax
  802254:	e8 71 01 00 00       	call   8023ca <nsipc_connect>
  802259:	83 c4 10             	add    $0x10,%esp
}
  80225c:	c9                   	leave  
  80225d:	c3                   	ret    

0080225e <listen>:
{
  80225e:	f3 0f 1e fb          	endbr32 
  802262:	55                   	push   %ebp
  802263:	89 e5                	mov    %esp,%ebp
  802265:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802268:	8b 45 08             	mov    0x8(%ebp),%eax
  80226b:	e8 9c fe ff ff       	call   80210c <fd2sockid>
  802270:	85 c0                	test   %eax,%eax
  802272:	78 0f                	js     802283 <listen+0x25>
	return nsipc_listen(r, backlog);
  802274:	83 ec 08             	sub    $0x8,%esp
  802277:	ff 75 0c             	pushl  0xc(%ebp)
  80227a:	50                   	push   %eax
  80227b:	e8 83 01 00 00       	call   802403 <nsipc_listen>
  802280:	83 c4 10             	add    $0x10,%esp
}
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <socket>:

int
socket(int domain, int type, int protocol)
{
  802285:	f3 0f 1e fb          	endbr32 
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
  80228c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80228f:	ff 75 10             	pushl  0x10(%ebp)
  802292:	ff 75 0c             	pushl  0xc(%ebp)
  802295:	ff 75 08             	pushl  0x8(%ebp)
  802298:	e8 65 02 00 00       	call   802502 <nsipc_socket>
  80229d:	83 c4 10             	add    $0x10,%esp
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	78 05                	js     8022a9 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  8022a4:	e8 93 fe ff ff       	call   80213c <alloc_sockfd>
}
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
  8022ae:	53                   	push   %ebx
  8022af:	83 ec 04             	sub    $0x4,%esp
  8022b2:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8022b4:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  8022bb:	74 26                	je     8022e3 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022bd:	6a 07                	push   $0x7
  8022bf:	68 00 90 80 00       	push   $0x809000
  8022c4:	53                   	push   %ebx
  8022c5:	ff 35 04 60 80 00    	pushl  0x806004
  8022cb:	e8 9e 06 00 00       	call   80296e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8022d0:	83 c4 0c             	add    $0xc,%esp
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	e8 0b 06 00 00       	call   8028e9 <ipc_recv>
}
  8022de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022e1:	c9                   	leave  
  8022e2:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8022e3:	83 ec 0c             	sub    $0xc,%esp
  8022e6:	6a 02                	push   $0x2
  8022e8:	e8 d9 06 00 00       	call   8029c6 <ipc_find_env>
  8022ed:	a3 04 60 80 00       	mov    %eax,0x806004
  8022f2:	83 c4 10             	add    $0x10,%esp
  8022f5:	eb c6                	jmp    8022bd <nsipc+0x12>

008022f7 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8022f7:	f3 0f 1e fb          	endbr32 
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
  8022fe:	56                   	push   %esi
  8022ff:	53                   	push   %ebx
  802300:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802303:	8b 45 08             	mov    0x8(%ebp),%eax
  802306:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80230b:	8b 06                	mov    (%esi),%eax
  80230d:	a3 04 90 80 00       	mov    %eax,0x809004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802312:	b8 01 00 00 00       	mov    $0x1,%eax
  802317:	e8 8f ff ff ff       	call   8022ab <nsipc>
  80231c:	89 c3                	mov    %eax,%ebx
  80231e:	85 c0                	test   %eax,%eax
  802320:	79 09                	jns    80232b <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802322:	89 d8                	mov    %ebx,%eax
  802324:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802327:	5b                   	pop    %ebx
  802328:	5e                   	pop    %esi
  802329:	5d                   	pop    %ebp
  80232a:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80232b:	83 ec 04             	sub    $0x4,%esp
  80232e:	ff 35 10 90 80 00    	pushl  0x809010
  802334:	68 00 90 80 00       	push   $0x809000
  802339:	ff 75 0c             	pushl  0xc(%ebp)
  80233c:	e8 8e e9 ff ff       	call   800ccf <memmove>
		*addrlen = ret->ret_addrlen;
  802341:	a1 10 90 80 00       	mov    0x809010,%eax
  802346:	89 06                	mov    %eax,(%esi)
  802348:	83 c4 10             	add    $0x10,%esp
	return r;
  80234b:	eb d5                	jmp    802322 <nsipc_accept+0x2b>

0080234d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80234d:	f3 0f 1e fb          	endbr32 
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
  802354:	53                   	push   %ebx
  802355:	83 ec 08             	sub    $0x8,%esp
  802358:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80235b:	8b 45 08             	mov    0x8(%ebp),%eax
  80235e:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802363:	53                   	push   %ebx
  802364:	ff 75 0c             	pushl  0xc(%ebp)
  802367:	68 04 90 80 00       	push   $0x809004
  80236c:	e8 5e e9 ff ff       	call   800ccf <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802371:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_BIND);
  802377:	b8 02 00 00 00       	mov    $0x2,%eax
  80237c:	e8 2a ff ff ff       	call   8022ab <nsipc>
}
  802381:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802386:	f3 0f 1e fb          	endbr32 
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
  80238d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802390:	8b 45 08             	mov    0x8(%ebp),%eax
  802393:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.shutdown.req_how = how;
  802398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80239b:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_SHUTDOWN);
  8023a0:	b8 03 00 00 00       	mov    $0x3,%eax
  8023a5:	e8 01 ff ff ff       	call   8022ab <nsipc>
}
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <nsipc_close>:

int
nsipc_close(int s)
{
  8023ac:	f3 0f 1e fb          	endbr32 
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	a3 00 90 80 00       	mov    %eax,0x809000
	return nsipc(NSREQ_CLOSE);
  8023be:	b8 04 00 00 00       	mov    $0x4,%eax
  8023c3:	e8 e3 fe ff ff       	call   8022ab <nsipc>
}
  8023c8:	c9                   	leave  
  8023c9:	c3                   	ret    

008023ca <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8023ca:	f3 0f 1e fb          	endbr32 
  8023ce:	55                   	push   %ebp
  8023cf:	89 e5                	mov    %esp,%ebp
  8023d1:	53                   	push   %ebx
  8023d2:	83 ec 08             	sub    $0x8,%esp
  8023d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8023e0:	53                   	push   %ebx
  8023e1:	ff 75 0c             	pushl  0xc(%ebp)
  8023e4:	68 04 90 80 00       	push   $0x809004
  8023e9:	e8 e1 e8 ff ff       	call   800ccf <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8023ee:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_CONNECT);
  8023f4:	b8 05 00 00 00       	mov    $0x5,%eax
  8023f9:	e8 ad fe ff ff       	call   8022ab <nsipc>
}
  8023fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802401:	c9                   	leave  
  802402:	c3                   	ret    

00802403 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802403:	f3 0f 1e fb          	endbr32 
  802407:	55                   	push   %ebp
  802408:	89 e5                	mov    %esp,%ebp
  80240a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80240d:	8b 45 08             	mov    0x8(%ebp),%eax
  802410:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.listen.req_backlog = backlog;
  802415:	8b 45 0c             	mov    0xc(%ebp),%eax
  802418:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_LISTEN);
  80241d:	b8 06 00 00 00       	mov    $0x6,%eax
  802422:	e8 84 fe ff ff       	call   8022ab <nsipc>
}
  802427:	c9                   	leave  
  802428:	c3                   	ret    

00802429 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802429:	f3 0f 1e fb          	endbr32 
  80242d:	55                   	push   %ebp
  80242e:	89 e5                	mov    %esp,%ebp
  802430:	56                   	push   %esi
  802431:	53                   	push   %ebx
  802432:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802435:	8b 45 08             	mov    0x8(%ebp),%eax
  802438:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.recv.req_len = len;
  80243d:	89 35 04 90 80 00    	mov    %esi,0x809004
	nsipcbuf.recv.req_flags = flags;
  802443:	8b 45 14             	mov    0x14(%ebp),%eax
  802446:	a3 08 90 80 00       	mov    %eax,0x809008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80244b:	b8 07 00 00 00       	mov    $0x7,%eax
  802450:	e8 56 fe ff ff       	call   8022ab <nsipc>
  802455:	89 c3                	mov    %eax,%ebx
  802457:	85 c0                	test   %eax,%eax
  802459:	78 26                	js     802481 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  80245b:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  802461:	b8 3f 06 00 00       	mov    $0x63f,%eax
  802466:	0f 4e c6             	cmovle %esi,%eax
  802469:	39 c3                	cmp    %eax,%ebx
  80246b:	7f 1d                	jg     80248a <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80246d:	83 ec 04             	sub    $0x4,%esp
  802470:	53                   	push   %ebx
  802471:	68 00 90 80 00       	push   $0x809000
  802476:	ff 75 0c             	pushl  0xc(%ebp)
  802479:	e8 51 e8 ff ff       	call   800ccf <memmove>
  80247e:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802481:	89 d8                	mov    %ebx,%eax
  802483:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802486:	5b                   	pop    %ebx
  802487:	5e                   	pop    %esi
  802488:	5d                   	pop    %ebp
  802489:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80248a:	68 d6 32 80 00       	push   $0x8032d6
  80248f:	68 03 32 80 00       	push   $0x803203
  802494:	6a 62                	push   $0x62
  802496:	68 eb 32 80 00       	push   $0x8032eb
  80249b:	e8 88 df ff ff       	call   800428 <_panic>

008024a0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8024a0:	f3 0f 1e fb          	endbr32 
  8024a4:	55                   	push   %ebp
  8024a5:	89 e5                	mov    %esp,%ebp
  8024a7:	53                   	push   %ebx
  8024a8:	83 ec 04             	sub    $0x4,%esp
  8024ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8024ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b1:	a3 00 90 80 00       	mov    %eax,0x809000
	assert(size < 1600);
  8024b6:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8024bc:	7f 2e                	jg     8024ec <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8024be:	83 ec 04             	sub    $0x4,%esp
  8024c1:	53                   	push   %ebx
  8024c2:	ff 75 0c             	pushl  0xc(%ebp)
  8024c5:	68 0c 90 80 00       	push   $0x80900c
  8024ca:	e8 00 e8 ff ff       	call   800ccf <memmove>
	nsipcbuf.send.req_size = size;
  8024cf:	89 1d 04 90 80 00    	mov    %ebx,0x809004
	nsipcbuf.send.req_flags = flags;
  8024d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8024d8:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SEND);
  8024dd:	b8 08 00 00 00       	mov    $0x8,%eax
  8024e2:	e8 c4 fd ff ff       	call   8022ab <nsipc>
}
  8024e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024ea:	c9                   	leave  
  8024eb:	c3                   	ret    
	assert(size < 1600);
  8024ec:	68 f7 32 80 00       	push   $0x8032f7
  8024f1:	68 03 32 80 00       	push   $0x803203
  8024f6:	6a 6d                	push   $0x6d
  8024f8:	68 eb 32 80 00       	push   $0x8032eb
  8024fd:	e8 26 df ff ff       	call   800428 <_panic>

00802502 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802502:	f3 0f 1e fb          	endbr32 
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
  802509:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80250c:	8b 45 08             	mov    0x8(%ebp),%eax
  80250f:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.socket.req_type = type;
  802514:	8b 45 0c             	mov    0xc(%ebp),%eax
  802517:	a3 04 90 80 00       	mov    %eax,0x809004
	nsipcbuf.socket.req_protocol = protocol;
  80251c:	8b 45 10             	mov    0x10(%ebp),%eax
  80251f:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SOCKET);
  802524:	b8 09 00 00 00       	mov    $0x9,%eax
  802529:	e8 7d fd ff ff       	call   8022ab <nsipc>
}
  80252e:	c9                   	leave  
  80252f:	c3                   	ret    

00802530 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802530:	f3 0f 1e fb          	endbr32 
  802534:	55                   	push   %ebp
  802535:	89 e5                	mov    %esp,%ebp
  802537:	56                   	push   %esi
  802538:	53                   	push   %ebx
  802539:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80253c:	83 ec 0c             	sub    $0xc,%esp
  80253f:	ff 75 08             	pushl  0x8(%ebp)
  802542:	e8 e8 ec ff ff       	call   80122f <fd2data>
  802547:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802549:	83 c4 08             	add    $0x8,%esp
  80254c:	68 03 33 80 00       	push   $0x803303
  802551:	53                   	push   %ebx
  802552:	e8 c2 e5 ff ff       	call   800b19 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802557:	8b 46 04             	mov    0x4(%esi),%eax
  80255a:	2b 06                	sub    (%esi),%eax
  80255c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802562:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802569:	00 00 00 
	stat->st_dev = &devpipe;
  80256c:	c7 83 88 00 00 00 c8 	movl   $0x8057c8,0x88(%ebx)
  802573:	57 80 00 
	return 0;
}
  802576:	b8 00 00 00 00       	mov    $0x0,%eax
  80257b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80257e:	5b                   	pop    %ebx
  80257f:	5e                   	pop    %esi
  802580:	5d                   	pop    %ebp
  802581:	c3                   	ret    

00802582 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802582:	f3 0f 1e fb          	endbr32 
  802586:	55                   	push   %ebp
  802587:	89 e5                	mov    %esp,%ebp
  802589:	53                   	push   %ebx
  80258a:	83 ec 0c             	sub    $0xc,%esp
  80258d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802590:	53                   	push   %ebx
  802591:	6a 00                	push   $0x0
  802593:	e8 50 ea ff ff       	call   800fe8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802598:	89 1c 24             	mov    %ebx,(%esp)
  80259b:	e8 8f ec ff ff       	call   80122f <fd2data>
  8025a0:	83 c4 08             	add    $0x8,%esp
  8025a3:	50                   	push   %eax
  8025a4:	6a 00                	push   $0x0
  8025a6:	e8 3d ea ff ff       	call   800fe8 <sys_page_unmap>
}
  8025ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025ae:	c9                   	leave  
  8025af:	c3                   	ret    

008025b0 <_pipeisclosed>:
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
  8025b3:	57                   	push   %edi
  8025b4:	56                   	push   %esi
  8025b5:	53                   	push   %ebx
  8025b6:	83 ec 1c             	sub    $0x1c,%esp
  8025b9:	89 c7                	mov    %eax,%edi
  8025bb:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8025bd:	a1 90 77 80 00       	mov    0x807790,%eax
  8025c2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8025c5:	83 ec 0c             	sub    $0xc,%esp
  8025c8:	57                   	push   %edi
  8025c9:	e8 35 04 00 00       	call   802a03 <pageref>
  8025ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8025d1:	89 34 24             	mov    %esi,(%esp)
  8025d4:	e8 2a 04 00 00       	call   802a03 <pageref>
		nn = thisenv->env_runs;
  8025d9:	8b 15 90 77 80 00    	mov    0x807790,%edx
  8025df:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8025e2:	83 c4 10             	add    $0x10,%esp
  8025e5:	39 cb                	cmp    %ecx,%ebx
  8025e7:	74 1b                	je     802604 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8025e9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8025ec:	75 cf                	jne    8025bd <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8025ee:	8b 42 58             	mov    0x58(%edx),%eax
  8025f1:	6a 01                	push   $0x1
  8025f3:	50                   	push   %eax
  8025f4:	53                   	push   %ebx
  8025f5:	68 0a 33 80 00       	push   $0x80330a
  8025fa:	e8 10 df ff ff       	call   80050f <cprintf>
  8025ff:	83 c4 10             	add    $0x10,%esp
  802602:	eb b9                	jmp    8025bd <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802604:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802607:	0f 94 c0             	sete   %al
  80260a:	0f b6 c0             	movzbl %al,%eax
}
  80260d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802610:	5b                   	pop    %ebx
  802611:	5e                   	pop    %esi
  802612:	5f                   	pop    %edi
  802613:	5d                   	pop    %ebp
  802614:	c3                   	ret    

00802615 <devpipe_write>:
{
  802615:	f3 0f 1e fb          	endbr32 
  802619:	55                   	push   %ebp
  80261a:	89 e5                	mov    %esp,%ebp
  80261c:	57                   	push   %edi
  80261d:	56                   	push   %esi
  80261e:	53                   	push   %ebx
  80261f:	83 ec 28             	sub    $0x28,%esp
  802622:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802625:	56                   	push   %esi
  802626:	e8 04 ec ff ff       	call   80122f <fd2data>
  80262b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80262d:	83 c4 10             	add    $0x10,%esp
  802630:	bf 00 00 00 00       	mov    $0x0,%edi
  802635:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802638:	74 4f                	je     802689 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80263a:	8b 43 04             	mov    0x4(%ebx),%eax
  80263d:	8b 0b                	mov    (%ebx),%ecx
  80263f:	8d 51 20             	lea    0x20(%ecx),%edx
  802642:	39 d0                	cmp    %edx,%eax
  802644:	72 14                	jb     80265a <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802646:	89 da                	mov    %ebx,%edx
  802648:	89 f0                	mov    %esi,%eax
  80264a:	e8 61 ff ff ff       	call   8025b0 <_pipeisclosed>
  80264f:	85 c0                	test   %eax,%eax
  802651:	75 3b                	jne    80268e <devpipe_write+0x79>
			sys_yield();
  802653:	e8 e0 e8 ff ff       	call   800f38 <sys_yield>
  802658:	eb e0                	jmp    80263a <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80265a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80265d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802661:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802664:	89 c2                	mov    %eax,%edx
  802666:	c1 fa 1f             	sar    $0x1f,%edx
  802669:	89 d1                	mov    %edx,%ecx
  80266b:	c1 e9 1b             	shr    $0x1b,%ecx
  80266e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802671:	83 e2 1f             	and    $0x1f,%edx
  802674:	29 ca                	sub    %ecx,%edx
  802676:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80267a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80267e:	83 c0 01             	add    $0x1,%eax
  802681:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802684:	83 c7 01             	add    $0x1,%edi
  802687:	eb ac                	jmp    802635 <devpipe_write+0x20>
	return i;
  802689:	8b 45 10             	mov    0x10(%ebp),%eax
  80268c:	eb 05                	jmp    802693 <devpipe_write+0x7e>
				return 0;
  80268e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802693:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802696:	5b                   	pop    %ebx
  802697:	5e                   	pop    %esi
  802698:	5f                   	pop    %edi
  802699:	5d                   	pop    %ebp
  80269a:	c3                   	ret    

0080269b <devpipe_read>:
{
  80269b:	f3 0f 1e fb          	endbr32 
  80269f:	55                   	push   %ebp
  8026a0:	89 e5                	mov    %esp,%ebp
  8026a2:	57                   	push   %edi
  8026a3:	56                   	push   %esi
  8026a4:	53                   	push   %ebx
  8026a5:	83 ec 18             	sub    $0x18,%esp
  8026a8:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8026ab:	57                   	push   %edi
  8026ac:	e8 7e eb ff ff       	call   80122f <fd2data>
  8026b1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8026b3:	83 c4 10             	add    $0x10,%esp
  8026b6:	be 00 00 00 00       	mov    $0x0,%esi
  8026bb:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026be:	75 14                	jne    8026d4 <devpipe_read+0x39>
	return i;
  8026c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8026c3:	eb 02                	jmp    8026c7 <devpipe_read+0x2c>
				return i;
  8026c5:	89 f0                	mov    %esi,%eax
}
  8026c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026ca:	5b                   	pop    %ebx
  8026cb:	5e                   	pop    %esi
  8026cc:	5f                   	pop    %edi
  8026cd:	5d                   	pop    %ebp
  8026ce:	c3                   	ret    
			sys_yield();
  8026cf:	e8 64 e8 ff ff       	call   800f38 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8026d4:	8b 03                	mov    (%ebx),%eax
  8026d6:	3b 43 04             	cmp    0x4(%ebx),%eax
  8026d9:	75 18                	jne    8026f3 <devpipe_read+0x58>
			if (i > 0)
  8026db:	85 f6                	test   %esi,%esi
  8026dd:	75 e6                	jne    8026c5 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8026df:	89 da                	mov    %ebx,%edx
  8026e1:	89 f8                	mov    %edi,%eax
  8026e3:	e8 c8 fe ff ff       	call   8025b0 <_pipeisclosed>
  8026e8:	85 c0                	test   %eax,%eax
  8026ea:	74 e3                	je     8026cf <devpipe_read+0x34>
				return 0;
  8026ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f1:	eb d4                	jmp    8026c7 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8026f3:	99                   	cltd   
  8026f4:	c1 ea 1b             	shr    $0x1b,%edx
  8026f7:	01 d0                	add    %edx,%eax
  8026f9:	83 e0 1f             	and    $0x1f,%eax
  8026fc:	29 d0                	sub    %edx,%eax
  8026fe:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802703:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802706:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802709:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80270c:	83 c6 01             	add    $0x1,%esi
  80270f:	eb aa                	jmp    8026bb <devpipe_read+0x20>

00802711 <pipe>:
{
  802711:	f3 0f 1e fb          	endbr32 
  802715:	55                   	push   %ebp
  802716:	89 e5                	mov    %esp,%ebp
  802718:	56                   	push   %esi
  802719:	53                   	push   %ebx
  80271a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80271d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802720:	50                   	push   %eax
  802721:	e8 24 eb ff ff       	call   80124a <fd_alloc>
  802726:	89 c3                	mov    %eax,%ebx
  802728:	83 c4 10             	add    $0x10,%esp
  80272b:	85 c0                	test   %eax,%eax
  80272d:	0f 88 23 01 00 00    	js     802856 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802733:	83 ec 04             	sub    $0x4,%esp
  802736:	68 07 04 00 00       	push   $0x407
  80273b:	ff 75 f4             	pushl  -0xc(%ebp)
  80273e:	6a 00                	push   $0x0
  802740:	e8 16 e8 ff ff       	call   800f5b <sys_page_alloc>
  802745:	89 c3                	mov    %eax,%ebx
  802747:	83 c4 10             	add    $0x10,%esp
  80274a:	85 c0                	test   %eax,%eax
  80274c:	0f 88 04 01 00 00    	js     802856 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802752:	83 ec 0c             	sub    $0xc,%esp
  802755:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802758:	50                   	push   %eax
  802759:	e8 ec ea ff ff       	call   80124a <fd_alloc>
  80275e:	89 c3                	mov    %eax,%ebx
  802760:	83 c4 10             	add    $0x10,%esp
  802763:	85 c0                	test   %eax,%eax
  802765:	0f 88 db 00 00 00    	js     802846 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80276b:	83 ec 04             	sub    $0x4,%esp
  80276e:	68 07 04 00 00       	push   $0x407
  802773:	ff 75 f0             	pushl  -0x10(%ebp)
  802776:	6a 00                	push   $0x0
  802778:	e8 de e7 ff ff       	call   800f5b <sys_page_alloc>
  80277d:	89 c3                	mov    %eax,%ebx
  80277f:	83 c4 10             	add    $0x10,%esp
  802782:	85 c0                	test   %eax,%eax
  802784:	0f 88 bc 00 00 00    	js     802846 <pipe+0x135>
	va = fd2data(fd0);
  80278a:	83 ec 0c             	sub    $0xc,%esp
  80278d:	ff 75 f4             	pushl  -0xc(%ebp)
  802790:	e8 9a ea ff ff       	call   80122f <fd2data>
  802795:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802797:	83 c4 0c             	add    $0xc,%esp
  80279a:	68 07 04 00 00       	push   $0x407
  80279f:	50                   	push   %eax
  8027a0:	6a 00                	push   $0x0
  8027a2:	e8 b4 e7 ff ff       	call   800f5b <sys_page_alloc>
  8027a7:	89 c3                	mov    %eax,%ebx
  8027a9:	83 c4 10             	add    $0x10,%esp
  8027ac:	85 c0                	test   %eax,%eax
  8027ae:	0f 88 82 00 00 00    	js     802836 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027b4:	83 ec 0c             	sub    $0xc,%esp
  8027b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8027ba:	e8 70 ea ff ff       	call   80122f <fd2data>
  8027bf:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8027c6:	50                   	push   %eax
  8027c7:	6a 00                	push   $0x0
  8027c9:	56                   	push   %esi
  8027ca:	6a 00                	push   $0x0
  8027cc:	e8 d1 e7 ff ff       	call   800fa2 <sys_page_map>
  8027d1:	89 c3                	mov    %eax,%ebx
  8027d3:	83 c4 20             	add    $0x20,%esp
  8027d6:	85 c0                	test   %eax,%eax
  8027d8:	78 4e                	js     802828 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8027da:	a1 c8 57 80 00       	mov    0x8057c8,%eax
  8027df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e2:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8027e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8027ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027f1:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8027f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8027fd:	83 ec 0c             	sub    $0xc,%esp
  802800:	ff 75 f4             	pushl  -0xc(%ebp)
  802803:	e8 13 ea ff ff       	call   80121b <fd2num>
  802808:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80280b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80280d:	83 c4 04             	add    $0x4,%esp
  802810:	ff 75 f0             	pushl  -0x10(%ebp)
  802813:	e8 03 ea ff ff       	call   80121b <fd2num>
  802818:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80281b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80281e:	83 c4 10             	add    $0x10,%esp
  802821:	bb 00 00 00 00       	mov    $0x0,%ebx
  802826:	eb 2e                	jmp    802856 <pipe+0x145>
	sys_page_unmap(0, va);
  802828:	83 ec 08             	sub    $0x8,%esp
  80282b:	56                   	push   %esi
  80282c:	6a 00                	push   $0x0
  80282e:	e8 b5 e7 ff ff       	call   800fe8 <sys_page_unmap>
  802833:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802836:	83 ec 08             	sub    $0x8,%esp
  802839:	ff 75 f0             	pushl  -0x10(%ebp)
  80283c:	6a 00                	push   $0x0
  80283e:	e8 a5 e7 ff ff       	call   800fe8 <sys_page_unmap>
  802843:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802846:	83 ec 08             	sub    $0x8,%esp
  802849:	ff 75 f4             	pushl  -0xc(%ebp)
  80284c:	6a 00                	push   $0x0
  80284e:	e8 95 e7 ff ff       	call   800fe8 <sys_page_unmap>
  802853:	83 c4 10             	add    $0x10,%esp
}
  802856:	89 d8                	mov    %ebx,%eax
  802858:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80285b:	5b                   	pop    %ebx
  80285c:	5e                   	pop    %esi
  80285d:	5d                   	pop    %ebp
  80285e:	c3                   	ret    

0080285f <pipeisclosed>:
{
  80285f:	f3 0f 1e fb          	endbr32 
  802863:	55                   	push   %ebp
  802864:	89 e5                	mov    %esp,%ebp
  802866:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802869:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80286c:	50                   	push   %eax
  80286d:	ff 75 08             	pushl  0x8(%ebp)
  802870:	e8 2b ea ff ff       	call   8012a0 <fd_lookup>
  802875:	83 c4 10             	add    $0x10,%esp
  802878:	85 c0                	test   %eax,%eax
  80287a:	78 18                	js     802894 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80287c:	83 ec 0c             	sub    $0xc,%esp
  80287f:	ff 75 f4             	pushl  -0xc(%ebp)
  802882:	e8 a8 e9 ff ff       	call   80122f <fd2data>
  802887:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	e8 1f fd ff ff       	call   8025b0 <_pipeisclosed>
  802891:	83 c4 10             	add    $0x10,%esp
}
  802894:	c9                   	leave  
  802895:	c3                   	ret    

00802896 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802896:	f3 0f 1e fb          	endbr32 
  80289a:	55                   	push   %ebp
  80289b:	89 e5                	mov    %esp,%ebp
  80289d:	56                   	push   %esi
  80289e:	53                   	push   %ebx
  80289f:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8028a2:	85 f6                	test   %esi,%esi
  8028a4:	74 13                	je     8028b9 <wait+0x23>
	e = &envs[ENVX(envid)];
  8028a6:	89 f3                	mov    %esi,%ebx
  8028a8:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8028ae:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  8028b1:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8028b7:	eb 1b                	jmp    8028d4 <wait+0x3e>
	assert(envid != 0);
  8028b9:	68 22 33 80 00       	push   $0x803322
  8028be:	68 03 32 80 00       	push   $0x803203
  8028c3:	6a 09                	push   $0x9
  8028c5:	68 2d 33 80 00       	push   $0x80332d
  8028ca:	e8 59 db ff ff       	call   800428 <_panic>
		sys_yield();
  8028cf:	e8 64 e6 ff ff       	call   800f38 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8028d4:	8b 43 48             	mov    0x48(%ebx),%eax
  8028d7:	39 f0                	cmp    %esi,%eax
  8028d9:	75 07                	jne    8028e2 <wait+0x4c>
  8028db:	8b 43 54             	mov    0x54(%ebx),%eax
  8028de:	85 c0                	test   %eax,%eax
  8028e0:	75 ed                	jne    8028cf <wait+0x39>
}
  8028e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028e5:	5b                   	pop    %ebx
  8028e6:	5e                   	pop    %esi
  8028e7:	5d                   	pop    %ebp
  8028e8:	c3                   	ret    

008028e9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8028e9:	f3 0f 1e fb          	endbr32 
  8028ed:	55                   	push   %ebp
  8028ee:	89 e5                	mov    %esp,%ebp
  8028f0:	56                   	push   %esi
  8028f1:	53                   	push   %ebx
  8028f2:	8b 75 08             	mov    0x8(%ebp),%esi
  8028f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8028fb:	85 c0                	test   %eax,%eax
  8028fd:	74 3d                	je     80293c <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8028ff:	83 ec 0c             	sub    $0xc,%esp
  802902:	50                   	push   %eax
  802903:	e8 1f e8 ff ff       	call   801127 <sys_ipc_recv>
  802908:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  80290b:	85 f6                	test   %esi,%esi
  80290d:	74 0b                	je     80291a <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  80290f:	8b 15 90 77 80 00    	mov    0x807790,%edx
  802915:	8b 52 74             	mov    0x74(%edx),%edx
  802918:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  80291a:	85 db                	test   %ebx,%ebx
  80291c:	74 0b                	je     802929 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  80291e:	8b 15 90 77 80 00    	mov    0x807790,%edx
  802924:	8b 52 78             	mov    0x78(%edx),%edx
  802927:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  802929:	85 c0                	test   %eax,%eax
  80292b:	78 21                	js     80294e <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  80292d:	a1 90 77 80 00       	mov    0x807790,%eax
  802932:	8b 40 70             	mov    0x70(%eax),%eax
}
  802935:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802938:	5b                   	pop    %ebx
  802939:	5e                   	pop    %esi
  80293a:	5d                   	pop    %ebp
  80293b:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  80293c:	83 ec 0c             	sub    $0xc,%esp
  80293f:	68 00 00 c0 ee       	push   $0xeec00000
  802944:	e8 de e7 ff ff       	call   801127 <sys_ipc_recv>
  802949:	83 c4 10             	add    $0x10,%esp
  80294c:	eb bd                	jmp    80290b <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  80294e:	85 f6                	test   %esi,%esi
  802950:	74 10                	je     802962 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802952:	85 db                	test   %ebx,%ebx
  802954:	75 df                	jne    802935 <ipc_recv+0x4c>
  802956:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80295d:	00 00 00 
  802960:	eb d3                	jmp    802935 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802962:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802969:	00 00 00 
  80296c:	eb e4                	jmp    802952 <ipc_recv+0x69>

0080296e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80296e:	f3 0f 1e fb          	endbr32 
  802972:	55                   	push   %ebp
  802973:	89 e5                	mov    %esp,%ebp
  802975:	57                   	push   %edi
  802976:	56                   	push   %esi
  802977:	53                   	push   %ebx
  802978:	83 ec 0c             	sub    $0xc,%esp
  80297b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80297e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802981:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802984:	85 db                	test   %ebx,%ebx
  802986:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80298b:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  80298e:	ff 75 14             	pushl  0x14(%ebp)
  802991:	53                   	push   %ebx
  802992:	56                   	push   %esi
  802993:	57                   	push   %edi
  802994:	e8 67 e7 ff ff       	call   801100 <sys_ipc_try_send>
  802999:	83 c4 10             	add    $0x10,%esp
  80299c:	85 c0                	test   %eax,%eax
  80299e:	79 1e                	jns    8029be <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  8029a0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8029a3:	75 07                	jne    8029ac <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  8029a5:	e8 8e e5 ff ff       	call   800f38 <sys_yield>
  8029aa:	eb e2                	jmp    80298e <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  8029ac:	50                   	push   %eax
  8029ad:	68 38 33 80 00       	push   $0x803338
  8029b2:	6a 59                	push   $0x59
  8029b4:	68 53 33 80 00       	push   $0x803353
  8029b9:	e8 6a da ff ff       	call   800428 <_panic>
	}
}
  8029be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029c1:	5b                   	pop    %ebx
  8029c2:	5e                   	pop    %esi
  8029c3:	5f                   	pop    %edi
  8029c4:	5d                   	pop    %ebp
  8029c5:	c3                   	ret    

008029c6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8029c6:	f3 0f 1e fb          	endbr32 
  8029ca:	55                   	push   %ebp
  8029cb:	89 e5                	mov    %esp,%ebp
  8029cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8029d0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8029d5:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8029d8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8029de:	8b 52 50             	mov    0x50(%edx),%edx
  8029e1:	39 ca                	cmp    %ecx,%edx
  8029e3:	74 11                	je     8029f6 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8029e5:	83 c0 01             	add    $0x1,%eax
  8029e8:	3d 00 04 00 00       	cmp    $0x400,%eax
  8029ed:	75 e6                	jne    8029d5 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8029ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f4:	eb 0b                	jmp    802a01 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8029f6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8029f9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8029fe:	8b 40 48             	mov    0x48(%eax),%eax
}
  802a01:	5d                   	pop    %ebp
  802a02:	c3                   	ret    

00802a03 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a03:	f3 0f 1e fb          	endbr32 
  802a07:	55                   	push   %ebp
  802a08:	89 e5                	mov    %esp,%ebp
  802a0a:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a0d:	89 c2                	mov    %eax,%edx
  802a0f:	c1 ea 16             	shr    $0x16,%edx
  802a12:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802a19:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802a1e:	f6 c1 01             	test   $0x1,%cl
  802a21:	74 1c                	je     802a3f <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802a23:	c1 e8 0c             	shr    $0xc,%eax
  802a26:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802a2d:	a8 01                	test   $0x1,%al
  802a2f:	74 0e                	je     802a3f <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a31:	c1 e8 0c             	shr    $0xc,%eax
  802a34:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802a3b:	ef 
  802a3c:	0f b7 d2             	movzwl %dx,%edx
}
  802a3f:	89 d0                	mov    %edx,%eax
  802a41:	5d                   	pop    %ebp
  802a42:	c3                   	ret    
  802a43:	66 90                	xchg   %ax,%ax
  802a45:	66 90                	xchg   %ax,%ax
  802a47:	66 90                	xchg   %ax,%ax
  802a49:	66 90                	xchg   %ax,%ax
  802a4b:	66 90                	xchg   %ax,%ax
  802a4d:	66 90                	xchg   %ax,%ax
  802a4f:	90                   	nop

00802a50 <__udivdi3>:
  802a50:	f3 0f 1e fb          	endbr32 
  802a54:	55                   	push   %ebp
  802a55:	57                   	push   %edi
  802a56:	56                   	push   %esi
  802a57:	53                   	push   %ebx
  802a58:	83 ec 1c             	sub    $0x1c,%esp
  802a5b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802a5f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802a63:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a67:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802a6b:	85 d2                	test   %edx,%edx
  802a6d:	75 19                	jne    802a88 <__udivdi3+0x38>
  802a6f:	39 f3                	cmp    %esi,%ebx
  802a71:	76 4d                	jbe    802ac0 <__udivdi3+0x70>
  802a73:	31 ff                	xor    %edi,%edi
  802a75:	89 e8                	mov    %ebp,%eax
  802a77:	89 f2                	mov    %esi,%edx
  802a79:	f7 f3                	div    %ebx
  802a7b:	89 fa                	mov    %edi,%edx
  802a7d:	83 c4 1c             	add    $0x1c,%esp
  802a80:	5b                   	pop    %ebx
  802a81:	5e                   	pop    %esi
  802a82:	5f                   	pop    %edi
  802a83:	5d                   	pop    %ebp
  802a84:	c3                   	ret    
  802a85:	8d 76 00             	lea    0x0(%esi),%esi
  802a88:	39 f2                	cmp    %esi,%edx
  802a8a:	76 14                	jbe    802aa0 <__udivdi3+0x50>
  802a8c:	31 ff                	xor    %edi,%edi
  802a8e:	31 c0                	xor    %eax,%eax
  802a90:	89 fa                	mov    %edi,%edx
  802a92:	83 c4 1c             	add    $0x1c,%esp
  802a95:	5b                   	pop    %ebx
  802a96:	5e                   	pop    %esi
  802a97:	5f                   	pop    %edi
  802a98:	5d                   	pop    %ebp
  802a99:	c3                   	ret    
  802a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802aa0:	0f bd fa             	bsr    %edx,%edi
  802aa3:	83 f7 1f             	xor    $0x1f,%edi
  802aa6:	75 48                	jne    802af0 <__udivdi3+0xa0>
  802aa8:	39 f2                	cmp    %esi,%edx
  802aaa:	72 06                	jb     802ab2 <__udivdi3+0x62>
  802aac:	31 c0                	xor    %eax,%eax
  802aae:	39 eb                	cmp    %ebp,%ebx
  802ab0:	77 de                	ja     802a90 <__udivdi3+0x40>
  802ab2:	b8 01 00 00 00       	mov    $0x1,%eax
  802ab7:	eb d7                	jmp    802a90 <__udivdi3+0x40>
  802ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ac0:	89 d9                	mov    %ebx,%ecx
  802ac2:	85 db                	test   %ebx,%ebx
  802ac4:	75 0b                	jne    802ad1 <__udivdi3+0x81>
  802ac6:	b8 01 00 00 00       	mov    $0x1,%eax
  802acb:	31 d2                	xor    %edx,%edx
  802acd:	f7 f3                	div    %ebx
  802acf:	89 c1                	mov    %eax,%ecx
  802ad1:	31 d2                	xor    %edx,%edx
  802ad3:	89 f0                	mov    %esi,%eax
  802ad5:	f7 f1                	div    %ecx
  802ad7:	89 c6                	mov    %eax,%esi
  802ad9:	89 e8                	mov    %ebp,%eax
  802adb:	89 f7                	mov    %esi,%edi
  802add:	f7 f1                	div    %ecx
  802adf:	89 fa                	mov    %edi,%edx
  802ae1:	83 c4 1c             	add    $0x1c,%esp
  802ae4:	5b                   	pop    %ebx
  802ae5:	5e                   	pop    %esi
  802ae6:	5f                   	pop    %edi
  802ae7:	5d                   	pop    %ebp
  802ae8:	c3                   	ret    
  802ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802af0:	89 f9                	mov    %edi,%ecx
  802af2:	b8 20 00 00 00       	mov    $0x20,%eax
  802af7:	29 f8                	sub    %edi,%eax
  802af9:	d3 e2                	shl    %cl,%edx
  802afb:	89 54 24 08          	mov    %edx,0x8(%esp)
  802aff:	89 c1                	mov    %eax,%ecx
  802b01:	89 da                	mov    %ebx,%edx
  802b03:	d3 ea                	shr    %cl,%edx
  802b05:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b09:	09 d1                	or     %edx,%ecx
  802b0b:	89 f2                	mov    %esi,%edx
  802b0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b11:	89 f9                	mov    %edi,%ecx
  802b13:	d3 e3                	shl    %cl,%ebx
  802b15:	89 c1                	mov    %eax,%ecx
  802b17:	d3 ea                	shr    %cl,%edx
  802b19:	89 f9                	mov    %edi,%ecx
  802b1b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802b1f:	89 eb                	mov    %ebp,%ebx
  802b21:	d3 e6                	shl    %cl,%esi
  802b23:	89 c1                	mov    %eax,%ecx
  802b25:	d3 eb                	shr    %cl,%ebx
  802b27:	09 de                	or     %ebx,%esi
  802b29:	89 f0                	mov    %esi,%eax
  802b2b:	f7 74 24 08          	divl   0x8(%esp)
  802b2f:	89 d6                	mov    %edx,%esi
  802b31:	89 c3                	mov    %eax,%ebx
  802b33:	f7 64 24 0c          	mull   0xc(%esp)
  802b37:	39 d6                	cmp    %edx,%esi
  802b39:	72 15                	jb     802b50 <__udivdi3+0x100>
  802b3b:	89 f9                	mov    %edi,%ecx
  802b3d:	d3 e5                	shl    %cl,%ebp
  802b3f:	39 c5                	cmp    %eax,%ebp
  802b41:	73 04                	jae    802b47 <__udivdi3+0xf7>
  802b43:	39 d6                	cmp    %edx,%esi
  802b45:	74 09                	je     802b50 <__udivdi3+0x100>
  802b47:	89 d8                	mov    %ebx,%eax
  802b49:	31 ff                	xor    %edi,%edi
  802b4b:	e9 40 ff ff ff       	jmp    802a90 <__udivdi3+0x40>
  802b50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b53:	31 ff                	xor    %edi,%edi
  802b55:	e9 36 ff ff ff       	jmp    802a90 <__udivdi3+0x40>
  802b5a:	66 90                	xchg   %ax,%ax
  802b5c:	66 90                	xchg   %ax,%ax
  802b5e:	66 90                	xchg   %ax,%ax

00802b60 <__umoddi3>:
  802b60:	f3 0f 1e fb          	endbr32 
  802b64:	55                   	push   %ebp
  802b65:	57                   	push   %edi
  802b66:	56                   	push   %esi
  802b67:	53                   	push   %ebx
  802b68:	83 ec 1c             	sub    $0x1c,%esp
  802b6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b6f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802b73:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802b77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b7b:	85 c0                	test   %eax,%eax
  802b7d:	75 19                	jne    802b98 <__umoddi3+0x38>
  802b7f:	39 df                	cmp    %ebx,%edi
  802b81:	76 5d                	jbe    802be0 <__umoddi3+0x80>
  802b83:	89 f0                	mov    %esi,%eax
  802b85:	89 da                	mov    %ebx,%edx
  802b87:	f7 f7                	div    %edi
  802b89:	89 d0                	mov    %edx,%eax
  802b8b:	31 d2                	xor    %edx,%edx
  802b8d:	83 c4 1c             	add    $0x1c,%esp
  802b90:	5b                   	pop    %ebx
  802b91:	5e                   	pop    %esi
  802b92:	5f                   	pop    %edi
  802b93:	5d                   	pop    %ebp
  802b94:	c3                   	ret    
  802b95:	8d 76 00             	lea    0x0(%esi),%esi
  802b98:	89 f2                	mov    %esi,%edx
  802b9a:	39 d8                	cmp    %ebx,%eax
  802b9c:	76 12                	jbe    802bb0 <__umoddi3+0x50>
  802b9e:	89 f0                	mov    %esi,%eax
  802ba0:	89 da                	mov    %ebx,%edx
  802ba2:	83 c4 1c             	add    $0x1c,%esp
  802ba5:	5b                   	pop    %ebx
  802ba6:	5e                   	pop    %esi
  802ba7:	5f                   	pop    %edi
  802ba8:	5d                   	pop    %ebp
  802ba9:	c3                   	ret    
  802baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802bb0:	0f bd e8             	bsr    %eax,%ebp
  802bb3:	83 f5 1f             	xor    $0x1f,%ebp
  802bb6:	75 50                	jne    802c08 <__umoddi3+0xa8>
  802bb8:	39 d8                	cmp    %ebx,%eax
  802bba:	0f 82 e0 00 00 00    	jb     802ca0 <__umoddi3+0x140>
  802bc0:	89 d9                	mov    %ebx,%ecx
  802bc2:	39 f7                	cmp    %esi,%edi
  802bc4:	0f 86 d6 00 00 00    	jbe    802ca0 <__umoddi3+0x140>
  802bca:	89 d0                	mov    %edx,%eax
  802bcc:	89 ca                	mov    %ecx,%edx
  802bce:	83 c4 1c             	add    $0x1c,%esp
  802bd1:	5b                   	pop    %ebx
  802bd2:	5e                   	pop    %esi
  802bd3:	5f                   	pop    %edi
  802bd4:	5d                   	pop    %ebp
  802bd5:	c3                   	ret    
  802bd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bdd:	8d 76 00             	lea    0x0(%esi),%esi
  802be0:	89 fd                	mov    %edi,%ebp
  802be2:	85 ff                	test   %edi,%edi
  802be4:	75 0b                	jne    802bf1 <__umoddi3+0x91>
  802be6:	b8 01 00 00 00       	mov    $0x1,%eax
  802beb:	31 d2                	xor    %edx,%edx
  802bed:	f7 f7                	div    %edi
  802bef:	89 c5                	mov    %eax,%ebp
  802bf1:	89 d8                	mov    %ebx,%eax
  802bf3:	31 d2                	xor    %edx,%edx
  802bf5:	f7 f5                	div    %ebp
  802bf7:	89 f0                	mov    %esi,%eax
  802bf9:	f7 f5                	div    %ebp
  802bfb:	89 d0                	mov    %edx,%eax
  802bfd:	31 d2                	xor    %edx,%edx
  802bff:	eb 8c                	jmp    802b8d <__umoddi3+0x2d>
  802c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c08:	89 e9                	mov    %ebp,%ecx
  802c0a:	ba 20 00 00 00       	mov    $0x20,%edx
  802c0f:	29 ea                	sub    %ebp,%edx
  802c11:	d3 e0                	shl    %cl,%eax
  802c13:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c17:	89 d1                	mov    %edx,%ecx
  802c19:	89 f8                	mov    %edi,%eax
  802c1b:	d3 e8                	shr    %cl,%eax
  802c1d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802c21:	89 54 24 04          	mov    %edx,0x4(%esp)
  802c25:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c29:	09 c1                	or     %eax,%ecx
  802c2b:	89 d8                	mov    %ebx,%eax
  802c2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c31:	89 e9                	mov    %ebp,%ecx
  802c33:	d3 e7                	shl    %cl,%edi
  802c35:	89 d1                	mov    %edx,%ecx
  802c37:	d3 e8                	shr    %cl,%eax
  802c39:	89 e9                	mov    %ebp,%ecx
  802c3b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c3f:	d3 e3                	shl    %cl,%ebx
  802c41:	89 c7                	mov    %eax,%edi
  802c43:	89 d1                	mov    %edx,%ecx
  802c45:	89 f0                	mov    %esi,%eax
  802c47:	d3 e8                	shr    %cl,%eax
  802c49:	89 e9                	mov    %ebp,%ecx
  802c4b:	89 fa                	mov    %edi,%edx
  802c4d:	d3 e6                	shl    %cl,%esi
  802c4f:	09 d8                	or     %ebx,%eax
  802c51:	f7 74 24 08          	divl   0x8(%esp)
  802c55:	89 d1                	mov    %edx,%ecx
  802c57:	89 f3                	mov    %esi,%ebx
  802c59:	f7 64 24 0c          	mull   0xc(%esp)
  802c5d:	89 c6                	mov    %eax,%esi
  802c5f:	89 d7                	mov    %edx,%edi
  802c61:	39 d1                	cmp    %edx,%ecx
  802c63:	72 06                	jb     802c6b <__umoddi3+0x10b>
  802c65:	75 10                	jne    802c77 <__umoddi3+0x117>
  802c67:	39 c3                	cmp    %eax,%ebx
  802c69:	73 0c                	jae    802c77 <__umoddi3+0x117>
  802c6b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802c6f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802c73:	89 d7                	mov    %edx,%edi
  802c75:	89 c6                	mov    %eax,%esi
  802c77:	89 ca                	mov    %ecx,%edx
  802c79:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c7e:	29 f3                	sub    %esi,%ebx
  802c80:	19 fa                	sbb    %edi,%edx
  802c82:	89 d0                	mov    %edx,%eax
  802c84:	d3 e0                	shl    %cl,%eax
  802c86:	89 e9                	mov    %ebp,%ecx
  802c88:	d3 eb                	shr    %cl,%ebx
  802c8a:	d3 ea                	shr    %cl,%edx
  802c8c:	09 d8                	or     %ebx,%eax
  802c8e:	83 c4 1c             	add    $0x1c,%esp
  802c91:	5b                   	pop    %ebx
  802c92:	5e                   	pop    %esi
  802c93:	5f                   	pop    %edi
  802c94:	5d                   	pop    %ebp
  802c95:	c3                   	ret    
  802c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c9d:	8d 76 00             	lea    0x0(%esi),%esi
  802ca0:	29 fe                	sub    %edi,%esi
  802ca2:	19 c3                	sbb    %eax,%ebx
  802ca4:	89 f2                	mov    %esi,%edx
  802ca6:	89 d9                	mov    %ebx,%ecx
  802ca8:	e9 1d ff ff ff       	jmp    802bca <__umoddi3+0x6a>
