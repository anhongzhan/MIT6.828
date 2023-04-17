
obj/user/testkbd.debug:     file format elf32-i386


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
  80002c:	e8 4d 02 00 00       	call   80027e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	53                   	push   %ebx
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	bb 0a 00 00 00       	mov    $0xa,%ebx
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
		sys_yield();
  800043:	e8 a2 0e 00 00       	call   800eea <sys_yield>
	for (i = 0; i < 10; ++i)
  800048:	83 eb 01             	sub    $0x1,%ebx
  80004b:	75 f6                	jne    800043 <umain+0x10>

	close(0);
  80004d:	83 ec 0c             	sub    $0xc,%esp
  800050:	6a 00                	push   $0x0
  800052:	e8 85 12 00 00       	call   8012dc <close>
	if ((r = opencons()) < 0)
  800057:	e8 cc 01 00 00       	call   800228 <opencons>
  80005c:	83 c4 10             	add    $0x10,%esp
  80005f:	85 c0                	test   %eax,%eax
  800061:	78 14                	js     800077 <umain+0x44>
		panic("opencons: %e", r);
	if (r != 0)
  800063:	74 24                	je     800089 <umain+0x56>
		panic("first opencons used fd %d", r);
  800065:	50                   	push   %eax
  800066:	68 dc 21 80 00       	push   $0x8021dc
  80006b:	6a 11                	push   $0x11
  80006d:	68 cd 21 80 00       	push   $0x8021cd
  800072:	e8 6f 02 00 00       	call   8002e6 <_panic>
		panic("opencons: %e", r);
  800077:	50                   	push   %eax
  800078:	68 c0 21 80 00       	push   $0x8021c0
  80007d:	6a 0f                	push   $0xf
  80007f:	68 cd 21 80 00       	push   $0x8021cd
  800084:	e8 5d 02 00 00       	call   8002e6 <_panic>
	if ((r = dup(0, 1)) < 0)
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	6a 01                	push   $0x1
  80008e:	6a 00                	push   $0x0
  800090:	e8 a1 12 00 00       	call   801336 <dup>
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	85 c0                	test   %eax,%eax
  80009a:	79 25                	jns    8000c1 <umain+0x8e>
		panic("dup: %e", r);
  80009c:	50                   	push   %eax
  80009d:	68 f6 21 80 00       	push   $0x8021f6
  8000a2:	6a 13                	push   $0x13
  8000a4:	68 cd 21 80 00       	push   $0x8021cd
  8000a9:	e8 38 02 00 00       	call   8002e6 <_panic>
	for(;;){
		char *buf;

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
  8000ae:	83 ec 04             	sub    $0x4,%esp
  8000b1:	50                   	push   %eax
  8000b2:	68 0c 22 80 00       	push   $0x80220c
  8000b7:	6a 01                	push   $0x1
  8000b9:	e8 99 19 00 00       	call   801a57 <fprintf>
  8000be:	83 c4 10             	add    $0x10,%esp
		buf = readline("Type a line: ");
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	68 fe 21 80 00       	push   $0x8021fe
  8000c9:	e8 c6 08 00 00       	call   800994 <readline>
		if (buf != NULL)
  8000ce:	83 c4 10             	add    $0x10,%esp
  8000d1:	85 c0                	test   %eax,%eax
  8000d3:	75 d9                	jne    8000ae <umain+0x7b>
		else
			fprintf(1, "(end of file received)\n");
  8000d5:	83 ec 08             	sub    $0x8,%esp
  8000d8:	68 10 22 80 00       	push   $0x802210
  8000dd:	6a 01                	push   $0x1
  8000df:	e8 73 19 00 00       	call   801a57 <fprintf>
  8000e4:	83 c4 10             	add    $0x10,%esp
  8000e7:	eb d8                	jmp    8000c1 <umain+0x8e>

008000e9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8000e9:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8000ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f2:	c3                   	ret    

008000f3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8000f3:	f3 0f 1e fb          	endbr32 
  8000f7:	55                   	push   %ebp
  8000f8:	89 e5                	mov    %esp,%ebp
  8000fa:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8000fd:	68 28 22 80 00       	push   $0x802228
  800102:	ff 75 0c             	pushl  0xc(%ebp)
  800105:	e8 c1 09 00 00       	call   800acb <strcpy>
	return 0;
}
  80010a:	b8 00 00 00 00       	mov    $0x0,%eax
  80010f:	c9                   	leave  
  800110:	c3                   	ret    

00800111 <devcons_write>:
{
  800111:	f3 0f 1e fb          	endbr32 
  800115:	55                   	push   %ebp
  800116:	89 e5                	mov    %esp,%ebp
  800118:	57                   	push   %edi
  800119:	56                   	push   %esi
  80011a:	53                   	push   %ebx
  80011b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800121:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800126:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80012c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80012f:	73 31                	jae    800162 <devcons_write+0x51>
		m = n - tot;
  800131:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800134:	29 f3                	sub    %esi,%ebx
  800136:	83 fb 7f             	cmp    $0x7f,%ebx
  800139:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80013e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800141:	83 ec 04             	sub    $0x4,%esp
  800144:	53                   	push   %ebx
  800145:	89 f0                	mov    %esi,%eax
  800147:	03 45 0c             	add    0xc(%ebp),%eax
  80014a:	50                   	push   %eax
  80014b:	57                   	push   %edi
  80014c:	e8 30 0b 00 00       	call   800c81 <memmove>
		sys_cputs(buf, m);
  800151:	83 c4 08             	add    $0x8,%esp
  800154:	53                   	push   %ebx
  800155:	57                   	push   %edi
  800156:	e8 e2 0c 00 00       	call   800e3d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80015b:	01 de                	add    %ebx,%esi
  80015d:	83 c4 10             	add    $0x10,%esp
  800160:	eb ca                	jmp    80012c <devcons_write+0x1b>
}
  800162:	89 f0                	mov    %esi,%eax
  800164:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800167:	5b                   	pop    %ebx
  800168:	5e                   	pop    %esi
  800169:	5f                   	pop    %edi
  80016a:	5d                   	pop    %ebp
  80016b:	c3                   	ret    

0080016c <devcons_read>:
{
  80016c:	f3 0f 1e fb          	endbr32 
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	83 ec 08             	sub    $0x8,%esp
  800176:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80017b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80017f:	74 21                	je     8001a2 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800181:	e8 d9 0c 00 00       	call   800e5f <sys_cgetc>
  800186:	85 c0                	test   %eax,%eax
  800188:	75 07                	jne    800191 <devcons_read+0x25>
		sys_yield();
  80018a:	e8 5b 0d 00 00       	call   800eea <sys_yield>
  80018f:	eb f0                	jmp    800181 <devcons_read+0x15>
	if (c < 0)
  800191:	78 0f                	js     8001a2 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  800193:	83 f8 04             	cmp    $0x4,%eax
  800196:	74 0c                	je     8001a4 <devcons_read+0x38>
	*(char*)vbuf = c;
  800198:	8b 55 0c             	mov    0xc(%ebp),%edx
  80019b:	88 02                	mov    %al,(%edx)
	return 1;
  80019d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8001a2:	c9                   	leave  
  8001a3:	c3                   	ret    
		return 0;
  8001a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a9:	eb f7                	jmp    8001a2 <devcons_read+0x36>

008001ab <cputchar>:
{
  8001ab:	f3 0f 1e fb          	endbr32 
  8001af:	55                   	push   %ebp
  8001b0:	89 e5                	mov    %esp,%ebp
  8001b2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8001b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8001bb:	6a 01                	push   $0x1
  8001bd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001c0:	50                   	push   %eax
  8001c1:	e8 77 0c 00 00       	call   800e3d <sys_cputs>
}
  8001c6:	83 c4 10             	add    $0x10,%esp
  8001c9:	c9                   	leave  
  8001ca:	c3                   	ret    

008001cb <getchar>:
{
  8001cb:	f3 0f 1e fb          	endbr32 
  8001cf:	55                   	push   %ebp
  8001d0:	89 e5                	mov    %esp,%ebp
  8001d2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8001d5:	6a 01                	push   $0x1
  8001d7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001da:	50                   	push   %eax
  8001db:	6a 00                	push   $0x0
  8001dd:	e8 44 12 00 00       	call   801426 <read>
	if (r < 0)
  8001e2:	83 c4 10             	add    $0x10,%esp
  8001e5:	85 c0                	test   %eax,%eax
  8001e7:	78 06                	js     8001ef <getchar+0x24>
	if (r < 1)
  8001e9:	74 06                	je     8001f1 <getchar+0x26>
	return c;
  8001eb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8001ef:	c9                   	leave  
  8001f0:	c3                   	ret    
		return -E_EOF;
  8001f1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8001f6:	eb f7                	jmp    8001ef <getchar+0x24>

008001f8 <iscons>:
{
  8001f8:	f3 0f 1e fb          	endbr32 
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800202:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800205:	50                   	push   %eax
  800206:	ff 75 08             	pushl  0x8(%ebp)
  800209:	e8 95 0f 00 00       	call   8011a3 <fd_lookup>
  80020e:	83 c4 10             	add    $0x10,%esp
  800211:	85 c0                	test   %eax,%eax
  800213:	78 11                	js     800226 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  800215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800218:	8b 15 00 30 80 00    	mov    0x803000,%edx
  80021e:	39 10                	cmp    %edx,(%eax)
  800220:	0f 94 c0             	sete   %al
  800223:	0f b6 c0             	movzbl %al,%eax
}
  800226:	c9                   	leave  
  800227:	c3                   	ret    

00800228 <opencons>:
{
  800228:	f3 0f 1e fb          	endbr32 
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800232:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800235:	50                   	push   %eax
  800236:	e8 12 0f 00 00       	call   80114d <fd_alloc>
  80023b:	83 c4 10             	add    $0x10,%esp
  80023e:	85 c0                	test   %eax,%eax
  800240:	78 3a                	js     80027c <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	68 07 04 00 00       	push   $0x407
  80024a:	ff 75 f4             	pushl  -0xc(%ebp)
  80024d:	6a 00                	push   $0x0
  80024f:	e8 b9 0c 00 00       	call   800f0d <sys_page_alloc>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	85 c0                	test   %eax,%eax
  800259:	78 21                	js     80027c <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80025b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80025e:	8b 15 00 30 80 00    	mov    0x803000,%edx
  800264:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800269:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	50                   	push   %eax
  800274:	e8 a5 0e 00 00       	call   80111e <fd2num>
  800279:	83 c4 10             	add    $0x10,%esp
}
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80027e:	f3 0f 1e fb          	endbr32 
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	56                   	push   %esi
  800286:	53                   	push   %ebx
  800287:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80028a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80028d:	e8 35 0c 00 00       	call   800ec7 <sys_getenvid>
  800292:	25 ff 03 00 00       	and    $0x3ff,%eax
  800297:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80029a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80029f:	a3 04 44 80 00       	mov    %eax,0x804404

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002a4:	85 db                	test   %ebx,%ebx
  8002a6:	7e 07                	jle    8002af <libmain+0x31>
		binaryname = argv[0];
  8002a8:	8b 06                	mov    (%esi),%eax
  8002aa:	a3 1c 30 80 00       	mov    %eax,0x80301c

	// call user main routine
	umain(argc, argv);
  8002af:	83 ec 08             	sub    $0x8,%esp
  8002b2:	56                   	push   %esi
  8002b3:	53                   	push   %ebx
  8002b4:	e8 7a fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8002b9:	e8 0a 00 00 00       	call   8002c8 <exit>
}
  8002be:	83 c4 10             	add    $0x10,%esp
  8002c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002c4:	5b                   	pop    %ebx
  8002c5:	5e                   	pop    %esi
  8002c6:	5d                   	pop    %ebp
  8002c7:	c3                   	ret    

008002c8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002c8:	f3 0f 1e fb          	endbr32 
  8002cc:	55                   	push   %ebp
  8002cd:	89 e5                	mov    %esp,%ebp
  8002cf:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8002d2:	e8 36 10 00 00       	call   80130d <close_all>
	sys_env_destroy(0);
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	6a 00                	push   $0x0
  8002dc:	e8 a1 0b 00 00       	call   800e82 <sys_env_destroy>
}
  8002e1:	83 c4 10             	add    $0x10,%esp
  8002e4:	c9                   	leave  
  8002e5:	c3                   	ret    

008002e6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002e6:	f3 0f 1e fb          	endbr32 
  8002ea:	55                   	push   %ebp
  8002eb:	89 e5                	mov    %esp,%ebp
  8002ed:	56                   	push   %esi
  8002ee:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8002ef:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002f2:	8b 35 1c 30 80 00    	mov    0x80301c,%esi
  8002f8:	e8 ca 0b 00 00       	call   800ec7 <sys_getenvid>
  8002fd:	83 ec 0c             	sub    $0xc,%esp
  800300:	ff 75 0c             	pushl  0xc(%ebp)
  800303:	ff 75 08             	pushl  0x8(%ebp)
  800306:	56                   	push   %esi
  800307:	50                   	push   %eax
  800308:	68 40 22 80 00       	push   $0x802240
  80030d:	e8 bb 00 00 00       	call   8003cd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800312:	83 c4 18             	add    $0x18,%esp
  800315:	53                   	push   %ebx
  800316:	ff 75 10             	pushl  0x10(%ebp)
  800319:	e8 5a 00 00 00       	call   800378 <vcprintf>
	cprintf("\n");
  80031e:	c7 04 24 26 22 80 00 	movl   $0x802226,(%esp)
  800325:	e8 a3 00 00 00       	call   8003cd <cprintf>
  80032a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80032d:	cc                   	int3   
  80032e:	eb fd                	jmp    80032d <_panic+0x47>

00800330 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800330:	f3 0f 1e fb          	endbr32 
  800334:	55                   	push   %ebp
  800335:	89 e5                	mov    %esp,%ebp
  800337:	53                   	push   %ebx
  800338:	83 ec 04             	sub    $0x4,%esp
  80033b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80033e:	8b 13                	mov    (%ebx),%edx
  800340:	8d 42 01             	lea    0x1(%edx),%eax
  800343:	89 03                	mov    %eax,(%ebx)
  800345:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800348:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80034c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800351:	74 09                	je     80035c <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800353:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800357:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80035a:	c9                   	leave  
  80035b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80035c:	83 ec 08             	sub    $0x8,%esp
  80035f:	68 ff 00 00 00       	push   $0xff
  800364:	8d 43 08             	lea    0x8(%ebx),%eax
  800367:	50                   	push   %eax
  800368:	e8 d0 0a 00 00       	call   800e3d <sys_cputs>
		b->idx = 0;
  80036d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	eb db                	jmp    800353 <putch+0x23>

00800378 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800378:	f3 0f 1e fb          	endbr32 
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800385:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80038c:	00 00 00 
	b.cnt = 0;
  80038f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800396:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800399:	ff 75 0c             	pushl  0xc(%ebp)
  80039c:	ff 75 08             	pushl  0x8(%ebp)
  80039f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003a5:	50                   	push   %eax
  8003a6:	68 30 03 80 00       	push   $0x800330
  8003ab:	e8 20 01 00 00       	call   8004d0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003b0:	83 c4 08             	add    $0x8,%esp
  8003b3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003b9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003bf:	50                   	push   %eax
  8003c0:	e8 78 0a 00 00       	call   800e3d <sys_cputs>

	return b.cnt;
}
  8003c5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003cb:	c9                   	leave  
  8003cc:	c3                   	ret    

008003cd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003cd:	f3 0f 1e fb          	endbr32 
  8003d1:	55                   	push   %ebp
  8003d2:	89 e5                	mov    %esp,%ebp
  8003d4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003d7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003da:	50                   	push   %eax
  8003db:	ff 75 08             	pushl  0x8(%ebp)
  8003de:	e8 95 ff ff ff       	call   800378 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003e3:	c9                   	leave  
  8003e4:	c3                   	ret    

008003e5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003e5:	55                   	push   %ebp
  8003e6:	89 e5                	mov    %esp,%ebp
  8003e8:	57                   	push   %edi
  8003e9:	56                   	push   %esi
  8003ea:	53                   	push   %ebx
  8003eb:	83 ec 1c             	sub    $0x1c,%esp
  8003ee:	89 c7                	mov    %eax,%edi
  8003f0:	89 d6                	mov    %edx,%esi
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f8:	89 d1                	mov    %edx,%ecx
  8003fa:	89 c2                	mov    %eax,%edx
  8003fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ff:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800402:	8b 45 10             	mov    0x10(%ebp),%eax
  800405:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800408:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80040b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800412:	39 c2                	cmp    %eax,%edx
  800414:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800417:	72 3e                	jb     800457 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800419:	83 ec 0c             	sub    $0xc,%esp
  80041c:	ff 75 18             	pushl  0x18(%ebp)
  80041f:	83 eb 01             	sub    $0x1,%ebx
  800422:	53                   	push   %ebx
  800423:	50                   	push   %eax
  800424:	83 ec 08             	sub    $0x8,%esp
  800427:	ff 75 e4             	pushl  -0x1c(%ebp)
  80042a:	ff 75 e0             	pushl  -0x20(%ebp)
  80042d:	ff 75 dc             	pushl  -0x24(%ebp)
  800430:	ff 75 d8             	pushl  -0x28(%ebp)
  800433:	e8 18 1b 00 00       	call   801f50 <__udivdi3>
  800438:	83 c4 18             	add    $0x18,%esp
  80043b:	52                   	push   %edx
  80043c:	50                   	push   %eax
  80043d:	89 f2                	mov    %esi,%edx
  80043f:	89 f8                	mov    %edi,%eax
  800441:	e8 9f ff ff ff       	call   8003e5 <printnum>
  800446:	83 c4 20             	add    $0x20,%esp
  800449:	eb 13                	jmp    80045e <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	56                   	push   %esi
  80044f:	ff 75 18             	pushl  0x18(%ebp)
  800452:	ff d7                	call   *%edi
  800454:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800457:	83 eb 01             	sub    $0x1,%ebx
  80045a:	85 db                	test   %ebx,%ebx
  80045c:	7f ed                	jg     80044b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80045e:	83 ec 08             	sub    $0x8,%esp
  800461:	56                   	push   %esi
  800462:	83 ec 04             	sub    $0x4,%esp
  800465:	ff 75 e4             	pushl  -0x1c(%ebp)
  800468:	ff 75 e0             	pushl  -0x20(%ebp)
  80046b:	ff 75 dc             	pushl  -0x24(%ebp)
  80046e:	ff 75 d8             	pushl  -0x28(%ebp)
  800471:	e8 ea 1b 00 00       	call   802060 <__umoddi3>
  800476:	83 c4 14             	add    $0x14,%esp
  800479:	0f be 80 63 22 80 00 	movsbl 0x802263(%eax),%eax
  800480:	50                   	push   %eax
  800481:	ff d7                	call   *%edi
}
  800483:	83 c4 10             	add    $0x10,%esp
  800486:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800489:	5b                   	pop    %ebx
  80048a:	5e                   	pop    %esi
  80048b:	5f                   	pop    %edi
  80048c:	5d                   	pop    %ebp
  80048d:	c3                   	ret    

0080048e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80048e:	f3 0f 1e fb          	endbr32 
  800492:	55                   	push   %ebp
  800493:	89 e5                	mov    %esp,%ebp
  800495:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800498:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80049c:	8b 10                	mov    (%eax),%edx
  80049e:	3b 50 04             	cmp    0x4(%eax),%edx
  8004a1:	73 0a                	jae    8004ad <sprintputch+0x1f>
		*b->buf++ = ch;
  8004a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004a6:	89 08                	mov    %ecx,(%eax)
  8004a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ab:	88 02                	mov    %al,(%edx)
}
  8004ad:	5d                   	pop    %ebp
  8004ae:	c3                   	ret    

008004af <printfmt>:
{
  8004af:	f3 0f 1e fb          	endbr32 
  8004b3:	55                   	push   %ebp
  8004b4:	89 e5                	mov    %esp,%ebp
  8004b6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004b9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004bc:	50                   	push   %eax
  8004bd:	ff 75 10             	pushl  0x10(%ebp)
  8004c0:	ff 75 0c             	pushl  0xc(%ebp)
  8004c3:	ff 75 08             	pushl  0x8(%ebp)
  8004c6:	e8 05 00 00 00       	call   8004d0 <vprintfmt>
}
  8004cb:	83 c4 10             	add    $0x10,%esp
  8004ce:	c9                   	leave  
  8004cf:	c3                   	ret    

008004d0 <vprintfmt>:
{
  8004d0:	f3 0f 1e fb          	endbr32 
  8004d4:	55                   	push   %ebp
  8004d5:	89 e5                	mov    %esp,%ebp
  8004d7:	57                   	push   %edi
  8004d8:	56                   	push   %esi
  8004d9:	53                   	push   %ebx
  8004da:	83 ec 3c             	sub    $0x3c,%esp
  8004dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8004e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004e3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004e6:	e9 8e 03 00 00       	jmp    800879 <vprintfmt+0x3a9>
		padc = ' ';
  8004eb:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8004ef:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8004f6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004fd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800504:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800509:	8d 47 01             	lea    0x1(%edi),%eax
  80050c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80050f:	0f b6 17             	movzbl (%edi),%edx
  800512:	8d 42 dd             	lea    -0x23(%edx),%eax
  800515:	3c 55                	cmp    $0x55,%al
  800517:	0f 87 df 03 00 00    	ja     8008fc <vprintfmt+0x42c>
  80051d:	0f b6 c0             	movzbl %al,%eax
  800520:	3e ff 24 85 a0 23 80 	notrack jmp *0x8023a0(,%eax,4)
  800527:	00 
  800528:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80052b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80052f:	eb d8                	jmp    800509 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800531:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800534:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800538:	eb cf                	jmp    800509 <vprintfmt+0x39>
  80053a:	0f b6 d2             	movzbl %dl,%edx
  80053d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800540:	b8 00 00 00 00       	mov    $0x0,%eax
  800545:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800548:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80054b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80054f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800552:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800555:	83 f9 09             	cmp    $0x9,%ecx
  800558:	77 55                	ja     8005af <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80055a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80055d:	eb e9                	jmp    800548 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	8b 00                	mov    (%eax),%eax
  800564:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8d 40 04             	lea    0x4(%eax),%eax
  80056d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800570:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800573:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800577:	79 90                	jns    800509 <vprintfmt+0x39>
				width = precision, precision = -1;
  800579:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80057c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80057f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800586:	eb 81                	jmp    800509 <vprintfmt+0x39>
  800588:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80058b:	85 c0                	test   %eax,%eax
  80058d:	ba 00 00 00 00       	mov    $0x0,%edx
  800592:	0f 49 d0             	cmovns %eax,%edx
  800595:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800598:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80059b:	e9 69 ff ff ff       	jmp    800509 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8005a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005a3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8005aa:	e9 5a ff ff ff       	jmp    800509 <vprintfmt+0x39>
  8005af:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b5:	eb bc                	jmp    800573 <vprintfmt+0xa3>
			lflag++;
  8005b7:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005bd:	e9 47 ff ff ff       	jmp    800509 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	8d 78 04             	lea    0x4(%eax),%edi
  8005c8:	83 ec 08             	sub    $0x8,%esp
  8005cb:	53                   	push   %ebx
  8005cc:	ff 30                	pushl  (%eax)
  8005ce:	ff d6                	call   *%esi
			break;
  8005d0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005d3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005d6:	e9 9b 02 00 00       	jmp    800876 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	8d 78 04             	lea    0x4(%eax),%edi
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	99                   	cltd   
  8005e4:	31 d0                	xor    %edx,%eax
  8005e6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005e8:	83 f8 0f             	cmp    $0xf,%eax
  8005eb:	7f 23                	jg     800610 <vprintfmt+0x140>
  8005ed:	8b 14 85 00 25 80 00 	mov    0x802500(,%eax,4),%edx
  8005f4:	85 d2                	test   %edx,%edx
  8005f6:	74 18                	je     800610 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8005f8:	52                   	push   %edx
  8005f9:	68 41 26 80 00       	push   $0x802641
  8005fe:	53                   	push   %ebx
  8005ff:	56                   	push   %esi
  800600:	e8 aa fe ff ff       	call   8004af <printfmt>
  800605:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800608:	89 7d 14             	mov    %edi,0x14(%ebp)
  80060b:	e9 66 02 00 00       	jmp    800876 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800610:	50                   	push   %eax
  800611:	68 7b 22 80 00       	push   $0x80227b
  800616:	53                   	push   %ebx
  800617:	56                   	push   %esi
  800618:	e8 92 fe ff ff       	call   8004af <printfmt>
  80061d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800620:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800623:	e9 4e 02 00 00       	jmp    800876 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	83 c0 04             	add    $0x4,%eax
  80062e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800636:	85 d2                	test   %edx,%edx
  800638:	b8 74 22 80 00       	mov    $0x802274,%eax
  80063d:	0f 45 c2             	cmovne %edx,%eax
  800640:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800643:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800647:	7e 06                	jle    80064f <vprintfmt+0x17f>
  800649:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80064d:	75 0d                	jne    80065c <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80064f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800652:	89 c7                	mov    %eax,%edi
  800654:	03 45 e0             	add    -0x20(%ebp),%eax
  800657:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80065a:	eb 55                	jmp    8006b1 <vprintfmt+0x1e1>
  80065c:	83 ec 08             	sub    $0x8,%esp
  80065f:	ff 75 d8             	pushl  -0x28(%ebp)
  800662:	ff 75 cc             	pushl  -0x34(%ebp)
  800665:	e8 3a 04 00 00       	call   800aa4 <strnlen>
  80066a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80066d:	29 c2                	sub    %eax,%edx
  80066f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800672:	83 c4 10             	add    $0x10,%esp
  800675:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800677:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80067e:	85 ff                	test   %edi,%edi
  800680:	7e 11                	jle    800693 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800682:	83 ec 08             	sub    $0x8,%esp
  800685:	53                   	push   %ebx
  800686:	ff 75 e0             	pushl  -0x20(%ebp)
  800689:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80068b:	83 ef 01             	sub    $0x1,%edi
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	eb eb                	jmp    80067e <vprintfmt+0x1ae>
  800693:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800696:	85 d2                	test   %edx,%edx
  800698:	b8 00 00 00 00       	mov    $0x0,%eax
  80069d:	0f 49 c2             	cmovns %edx,%eax
  8006a0:	29 c2                	sub    %eax,%edx
  8006a2:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8006a5:	eb a8                	jmp    80064f <vprintfmt+0x17f>
					putch(ch, putdat);
  8006a7:	83 ec 08             	sub    $0x8,%esp
  8006aa:	53                   	push   %ebx
  8006ab:	52                   	push   %edx
  8006ac:	ff d6                	call   *%esi
  8006ae:	83 c4 10             	add    $0x10,%esp
  8006b1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006b4:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b6:	83 c7 01             	add    $0x1,%edi
  8006b9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006bd:	0f be d0             	movsbl %al,%edx
  8006c0:	85 d2                	test   %edx,%edx
  8006c2:	74 4b                	je     80070f <vprintfmt+0x23f>
  8006c4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006c8:	78 06                	js     8006d0 <vprintfmt+0x200>
  8006ca:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006ce:	78 1e                	js     8006ee <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8006d0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006d4:	74 d1                	je     8006a7 <vprintfmt+0x1d7>
  8006d6:	0f be c0             	movsbl %al,%eax
  8006d9:	83 e8 20             	sub    $0x20,%eax
  8006dc:	83 f8 5e             	cmp    $0x5e,%eax
  8006df:	76 c6                	jbe    8006a7 <vprintfmt+0x1d7>
					putch('?', putdat);
  8006e1:	83 ec 08             	sub    $0x8,%esp
  8006e4:	53                   	push   %ebx
  8006e5:	6a 3f                	push   $0x3f
  8006e7:	ff d6                	call   *%esi
  8006e9:	83 c4 10             	add    $0x10,%esp
  8006ec:	eb c3                	jmp    8006b1 <vprintfmt+0x1e1>
  8006ee:	89 cf                	mov    %ecx,%edi
  8006f0:	eb 0e                	jmp    800700 <vprintfmt+0x230>
				putch(' ', putdat);
  8006f2:	83 ec 08             	sub    $0x8,%esp
  8006f5:	53                   	push   %ebx
  8006f6:	6a 20                	push   $0x20
  8006f8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006fa:	83 ef 01             	sub    $0x1,%edi
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	85 ff                	test   %edi,%edi
  800702:	7f ee                	jg     8006f2 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800704:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
  80070a:	e9 67 01 00 00       	jmp    800876 <vprintfmt+0x3a6>
  80070f:	89 cf                	mov    %ecx,%edi
  800711:	eb ed                	jmp    800700 <vprintfmt+0x230>
	if (lflag >= 2)
  800713:	83 f9 01             	cmp    $0x1,%ecx
  800716:	7f 1b                	jg     800733 <vprintfmt+0x263>
	else if (lflag)
  800718:	85 c9                	test   %ecx,%ecx
  80071a:	74 63                	je     80077f <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800724:	99                   	cltd   
  800725:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	8d 40 04             	lea    0x4(%eax),%eax
  80072e:	89 45 14             	mov    %eax,0x14(%ebp)
  800731:	eb 17                	jmp    80074a <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8b 50 04             	mov    0x4(%eax),%edx
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8d 40 08             	lea    0x8(%eax),%eax
  800747:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80074a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80074d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800750:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800755:	85 c9                	test   %ecx,%ecx
  800757:	0f 89 ff 00 00 00    	jns    80085c <vprintfmt+0x38c>
				putch('-', putdat);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	53                   	push   %ebx
  800761:	6a 2d                	push   $0x2d
  800763:	ff d6                	call   *%esi
				num = -(long long) num;
  800765:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800768:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80076b:	f7 da                	neg    %edx
  80076d:	83 d1 00             	adc    $0x0,%ecx
  800770:	f7 d9                	neg    %ecx
  800772:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800775:	b8 0a 00 00 00       	mov    $0xa,%eax
  80077a:	e9 dd 00 00 00       	jmp    80085c <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80077f:	8b 45 14             	mov    0x14(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800787:	99                   	cltd   
  800788:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8d 40 04             	lea    0x4(%eax),%eax
  800791:	89 45 14             	mov    %eax,0x14(%ebp)
  800794:	eb b4                	jmp    80074a <vprintfmt+0x27a>
	if (lflag >= 2)
  800796:	83 f9 01             	cmp    $0x1,%ecx
  800799:	7f 1e                	jg     8007b9 <vprintfmt+0x2e9>
	else if (lflag)
  80079b:	85 c9                	test   %ecx,%ecx
  80079d:	74 32                	je     8007d1 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80079f:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a2:	8b 10                	mov    (%eax),%edx
  8007a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007a9:	8d 40 04             	lea    0x4(%eax),%eax
  8007ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007af:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8007b4:	e9 a3 00 00 00       	jmp    80085c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	8b 10                	mov    (%eax),%edx
  8007be:	8b 48 04             	mov    0x4(%eax),%ecx
  8007c1:	8d 40 08             	lea    0x8(%eax),%eax
  8007c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007c7:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8007cc:	e9 8b 00 00 00       	jmp    80085c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8007d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d4:	8b 10                	mov    (%eax),%edx
  8007d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007db:	8d 40 04             	lea    0x4(%eax),%eax
  8007de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007e1:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8007e6:	eb 74                	jmp    80085c <vprintfmt+0x38c>
	if (lflag >= 2)
  8007e8:	83 f9 01             	cmp    $0x1,%ecx
  8007eb:	7f 1b                	jg     800808 <vprintfmt+0x338>
	else if (lflag)
  8007ed:	85 c9                	test   %ecx,%ecx
  8007ef:	74 2c                	je     80081d <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8007f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f4:	8b 10                	mov    (%eax),%edx
  8007f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007fb:	8d 40 04             	lea    0x4(%eax),%eax
  8007fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800801:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800806:	eb 54                	jmp    80085c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8b 10                	mov    (%eax),%edx
  80080d:	8b 48 04             	mov    0x4(%eax),%ecx
  800810:	8d 40 08             	lea    0x8(%eax),%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800816:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80081b:	eb 3f                	jmp    80085c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	8b 10                	mov    (%eax),%edx
  800822:	b9 00 00 00 00       	mov    $0x0,%ecx
  800827:	8d 40 04             	lea    0x4(%eax),%eax
  80082a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80082d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800832:	eb 28                	jmp    80085c <vprintfmt+0x38c>
			putch('0', putdat);
  800834:	83 ec 08             	sub    $0x8,%esp
  800837:	53                   	push   %ebx
  800838:	6a 30                	push   $0x30
  80083a:	ff d6                	call   *%esi
			putch('x', putdat);
  80083c:	83 c4 08             	add    $0x8,%esp
  80083f:	53                   	push   %ebx
  800840:	6a 78                	push   $0x78
  800842:	ff d6                	call   *%esi
			num = (unsigned long long)
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	8b 10                	mov    (%eax),%edx
  800849:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80084e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800851:	8d 40 04             	lea    0x4(%eax),%eax
  800854:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800857:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80085c:	83 ec 0c             	sub    $0xc,%esp
  80085f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800863:	57                   	push   %edi
  800864:	ff 75 e0             	pushl  -0x20(%ebp)
  800867:	50                   	push   %eax
  800868:	51                   	push   %ecx
  800869:	52                   	push   %edx
  80086a:	89 da                	mov    %ebx,%edx
  80086c:	89 f0                	mov    %esi,%eax
  80086e:	e8 72 fb ff ff       	call   8003e5 <printnum>
			break;
  800873:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800879:	83 c7 01             	add    $0x1,%edi
  80087c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800880:	83 f8 25             	cmp    $0x25,%eax
  800883:	0f 84 62 fc ff ff    	je     8004eb <vprintfmt+0x1b>
			if (ch == '\0')
  800889:	85 c0                	test   %eax,%eax
  80088b:	0f 84 8b 00 00 00    	je     80091c <vprintfmt+0x44c>
			putch(ch, putdat);
  800891:	83 ec 08             	sub    $0x8,%esp
  800894:	53                   	push   %ebx
  800895:	50                   	push   %eax
  800896:	ff d6                	call   *%esi
  800898:	83 c4 10             	add    $0x10,%esp
  80089b:	eb dc                	jmp    800879 <vprintfmt+0x3a9>
	if (lflag >= 2)
  80089d:	83 f9 01             	cmp    $0x1,%ecx
  8008a0:	7f 1b                	jg     8008bd <vprintfmt+0x3ed>
	else if (lflag)
  8008a2:	85 c9                	test   %ecx,%ecx
  8008a4:	74 2c                	je     8008d2 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8008a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a9:	8b 10                	mov    (%eax),%edx
  8008ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008b0:	8d 40 04             	lea    0x4(%eax),%eax
  8008b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b6:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8008bb:	eb 9f                	jmp    80085c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8008bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c0:	8b 10                	mov    (%eax),%edx
  8008c2:	8b 48 04             	mov    0x4(%eax),%ecx
  8008c5:	8d 40 08             	lea    0x8(%eax),%eax
  8008c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008cb:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8008d0:	eb 8a                	jmp    80085c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	8b 10                	mov    (%eax),%edx
  8008d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008dc:	8d 40 04             	lea    0x4(%eax),%eax
  8008df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008e2:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8008e7:	e9 70 ff ff ff       	jmp    80085c <vprintfmt+0x38c>
			putch(ch, putdat);
  8008ec:	83 ec 08             	sub    $0x8,%esp
  8008ef:	53                   	push   %ebx
  8008f0:	6a 25                	push   $0x25
  8008f2:	ff d6                	call   *%esi
			break;
  8008f4:	83 c4 10             	add    $0x10,%esp
  8008f7:	e9 7a ff ff ff       	jmp    800876 <vprintfmt+0x3a6>
			putch('%', putdat);
  8008fc:	83 ec 08             	sub    $0x8,%esp
  8008ff:	53                   	push   %ebx
  800900:	6a 25                	push   $0x25
  800902:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800904:	83 c4 10             	add    $0x10,%esp
  800907:	89 f8                	mov    %edi,%eax
  800909:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80090d:	74 05                	je     800914 <vprintfmt+0x444>
  80090f:	83 e8 01             	sub    $0x1,%eax
  800912:	eb f5                	jmp    800909 <vprintfmt+0x439>
  800914:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800917:	e9 5a ff ff ff       	jmp    800876 <vprintfmt+0x3a6>
}
  80091c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80091f:	5b                   	pop    %ebx
  800920:	5e                   	pop    %esi
  800921:	5f                   	pop    %edi
  800922:	5d                   	pop    %ebp
  800923:	c3                   	ret    

00800924 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800924:	f3 0f 1e fb          	endbr32 
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	83 ec 18             	sub    $0x18,%esp
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800934:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800937:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80093b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80093e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800945:	85 c0                	test   %eax,%eax
  800947:	74 26                	je     80096f <vsnprintf+0x4b>
  800949:	85 d2                	test   %edx,%edx
  80094b:	7e 22                	jle    80096f <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80094d:	ff 75 14             	pushl  0x14(%ebp)
  800950:	ff 75 10             	pushl  0x10(%ebp)
  800953:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800956:	50                   	push   %eax
  800957:	68 8e 04 80 00       	push   $0x80048e
  80095c:	e8 6f fb ff ff       	call   8004d0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800961:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800964:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80096a:	83 c4 10             	add    $0x10,%esp
}
  80096d:	c9                   	leave  
  80096e:	c3                   	ret    
		return -E_INVAL;
  80096f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800974:	eb f7                	jmp    80096d <vsnprintf+0x49>

00800976 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800976:	f3 0f 1e fb          	endbr32 
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800980:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800983:	50                   	push   %eax
  800984:	ff 75 10             	pushl  0x10(%ebp)
  800987:	ff 75 0c             	pushl  0xc(%ebp)
  80098a:	ff 75 08             	pushl  0x8(%ebp)
  80098d:	e8 92 ff ff ff       	call   800924 <vsnprintf>
	va_end(ap);

	return rc;
}
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800994:	f3 0f 1e fb          	endbr32 
  800998:	55                   	push   %ebp
  800999:	89 e5                	mov    %esp,%ebp
  80099b:	57                   	push   %edi
  80099c:	56                   	push   %esi
  80099d:	53                   	push   %ebx
  80099e:	83 ec 0c             	sub    $0xc,%esp
  8009a1:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  8009a4:	85 c0                	test   %eax,%eax
  8009a6:	74 13                	je     8009bb <readline+0x27>
		fprintf(1, "%s", prompt);
  8009a8:	83 ec 04             	sub    $0x4,%esp
  8009ab:	50                   	push   %eax
  8009ac:	68 41 26 80 00       	push   $0x802641
  8009b1:	6a 01                	push   $0x1
  8009b3:	e8 9f 10 00 00       	call   801a57 <fprintf>
  8009b8:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  8009bb:	83 ec 0c             	sub    $0xc,%esp
  8009be:	6a 00                	push   $0x0
  8009c0:	e8 33 f8 ff ff       	call   8001f8 <iscons>
  8009c5:	89 c7                	mov    %eax,%edi
  8009c7:	83 c4 10             	add    $0x10,%esp
	i = 0;
  8009ca:	be 00 00 00 00       	mov    $0x0,%esi
  8009cf:	eb 57                	jmp    800a28 <readline+0x94>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  8009d1:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  8009d6:	83 fb f8             	cmp    $0xfffffff8,%ebx
  8009d9:	75 08                	jne    8009e3 <readline+0x4f>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  8009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009de:	5b                   	pop    %ebx
  8009df:	5e                   	pop    %esi
  8009e0:	5f                   	pop    %edi
  8009e1:	5d                   	pop    %ebp
  8009e2:	c3                   	ret    
				cprintf("read error: %e\n", c);
  8009e3:	83 ec 08             	sub    $0x8,%esp
  8009e6:	53                   	push   %ebx
  8009e7:	68 5f 25 80 00       	push   $0x80255f
  8009ec:	e8 dc f9 ff ff       	call   8003cd <cprintf>
  8009f1:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8009f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f9:	eb e0                	jmp    8009db <readline+0x47>
			if (echoing)
  8009fb:	85 ff                	test   %edi,%edi
  8009fd:	75 05                	jne    800a04 <readline+0x70>
			i--;
  8009ff:	83 ee 01             	sub    $0x1,%esi
  800a02:	eb 24                	jmp    800a28 <readline+0x94>
				cputchar('\b');
  800a04:	83 ec 0c             	sub    $0xc,%esp
  800a07:	6a 08                	push   $0x8
  800a09:	e8 9d f7 ff ff       	call   8001ab <cputchar>
  800a0e:	83 c4 10             	add    $0x10,%esp
  800a11:	eb ec                	jmp    8009ff <readline+0x6b>
				cputchar(c);
  800a13:	83 ec 0c             	sub    $0xc,%esp
  800a16:	53                   	push   %ebx
  800a17:	e8 8f f7 ff ff       	call   8001ab <cputchar>
  800a1c:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800a1f:	88 9e 00 40 80 00    	mov    %bl,0x804000(%esi)
  800a25:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  800a28:	e8 9e f7 ff ff       	call   8001cb <getchar>
  800a2d:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800a2f:	85 c0                	test   %eax,%eax
  800a31:	78 9e                	js     8009d1 <readline+0x3d>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800a33:	83 f8 08             	cmp    $0x8,%eax
  800a36:	0f 94 c2             	sete   %dl
  800a39:	83 f8 7f             	cmp    $0x7f,%eax
  800a3c:	0f 94 c0             	sete   %al
  800a3f:	08 c2                	or     %al,%dl
  800a41:	74 04                	je     800a47 <readline+0xb3>
  800a43:	85 f6                	test   %esi,%esi
  800a45:	7f b4                	jg     8009fb <readline+0x67>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800a47:	83 fb 1f             	cmp    $0x1f,%ebx
  800a4a:	7e 0e                	jle    800a5a <readline+0xc6>
  800a4c:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800a52:	7f 06                	jg     800a5a <readline+0xc6>
			if (echoing)
  800a54:	85 ff                	test   %edi,%edi
  800a56:	74 c7                	je     800a1f <readline+0x8b>
  800a58:	eb b9                	jmp    800a13 <readline+0x7f>
		} else if (c == '\n' || c == '\r') {
  800a5a:	83 fb 0a             	cmp    $0xa,%ebx
  800a5d:	74 05                	je     800a64 <readline+0xd0>
  800a5f:	83 fb 0d             	cmp    $0xd,%ebx
  800a62:	75 c4                	jne    800a28 <readline+0x94>
			if (echoing)
  800a64:	85 ff                	test   %edi,%edi
  800a66:	75 11                	jne    800a79 <readline+0xe5>
			buf[i] = 0;
  800a68:	c6 86 00 40 80 00 00 	movb   $0x0,0x804000(%esi)
			return buf;
  800a6f:	b8 00 40 80 00       	mov    $0x804000,%eax
  800a74:	e9 62 ff ff ff       	jmp    8009db <readline+0x47>
				cputchar('\n');
  800a79:	83 ec 0c             	sub    $0xc,%esp
  800a7c:	6a 0a                	push   $0xa
  800a7e:	e8 28 f7 ff ff       	call   8001ab <cputchar>
  800a83:	83 c4 10             	add    $0x10,%esp
  800a86:	eb e0                	jmp    800a68 <readline+0xd4>

00800a88 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a88:	f3 0f 1e fb          	endbr32 
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a92:	b8 00 00 00 00       	mov    $0x0,%eax
  800a97:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a9b:	74 05                	je     800aa2 <strlen+0x1a>
		n++;
  800a9d:	83 c0 01             	add    $0x1,%eax
  800aa0:	eb f5                	jmp    800a97 <strlen+0xf>
	return n;
}
  800aa2:	5d                   	pop    %ebp
  800aa3:	c3                   	ret    

00800aa4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800aa4:	f3 0f 1e fb          	endbr32 
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aae:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ab1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab6:	39 d0                	cmp    %edx,%eax
  800ab8:	74 0d                	je     800ac7 <strnlen+0x23>
  800aba:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800abe:	74 05                	je     800ac5 <strnlen+0x21>
		n++;
  800ac0:	83 c0 01             	add    $0x1,%eax
  800ac3:	eb f1                	jmp    800ab6 <strnlen+0x12>
  800ac5:	89 c2                	mov    %eax,%edx
	return n;
}
  800ac7:	89 d0                	mov    %edx,%eax
  800ac9:	5d                   	pop    %ebp
  800aca:	c3                   	ret    

00800acb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800acb:	f3 0f 1e fb          	endbr32 
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	53                   	push   %ebx
  800ad3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ad9:	b8 00 00 00 00       	mov    $0x0,%eax
  800ade:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800ae2:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800ae5:	83 c0 01             	add    $0x1,%eax
  800ae8:	84 d2                	test   %dl,%dl
  800aea:	75 f2                	jne    800ade <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800aec:	89 c8                	mov    %ecx,%eax
  800aee:	5b                   	pop    %ebx
  800aef:	5d                   	pop    %ebp
  800af0:	c3                   	ret    

00800af1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800af1:	f3 0f 1e fb          	endbr32 
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	53                   	push   %ebx
  800af9:	83 ec 10             	sub    $0x10,%esp
  800afc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800aff:	53                   	push   %ebx
  800b00:	e8 83 ff ff ff       	call   800a88 <strlen>
  800b05:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b08:	ff 75 0c             	pushl  0xc(%ebp)
  800b0b:	01 d8                	add    %ebx,%eax
  800b0d:	50                   	push   %eax
  800b0e:	e8 b8 ff ff ff       	call   800acb <strcpy>
	return dst;
}
  800b13:	89 d8                	mov    %ebx,%eax
  800b15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b18:	c9                   	leave  
  800b19:	c3                   	ret    

00800b1a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b1a:	f3 0f 1e fb          	endbr32 
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	56                   	push   %esi
  800b22:	53                   	push   %ebx
  800b23:	8b 75 08             	mov    0x8(%ebp),%esi
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	89 f3                	mov    %esi,%ebx
  800b2b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b2e:	89 f0                	mov    %esi,%eax
  800b30:	39 d8                	cmp    %ebx,%eax
  800b32:	74 11                	je     800b45 <strncpy+0x2b>
		*dst++ = *src;
  800b34:	83 c0 01             	add    $0x1,%eax
  800b37:	0f b6 0a             	movzbl (%edx),%ecx
  800b3a:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b3d:	80 f9 01             	cmp    $0x1,%cl
  800b40:	83 da ff             	sbb    $0xffffffff,%edx
  800b43:	eb eb                	jmp    800b30 <strncpy+0x16>
	}
	return ret;
}
  800b45:	89 f0                	mov    %esi,%eax
  800b47:	5b                   	pop    %ebx
  800b48:	5e                   	pop    %esi
  800b49:	5d                   	pop    %ebp
  800b4a:	c3                   	ret    

00800b4b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b4b:	f3 0f 1e fb          	endbr32 
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	56                   	push   %esi
  800b53:	53                   	push   %ebx
  800b54:	8b 75 08             	mov    0x8(%ebp),%esi
  800b57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b5a:	8b 55 10             	mov    0x10(%ebp),%edx
  800b5d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b5f:	85 d2                	test   %edx,%edx
  800b61:	74 21                	je     800b84 <strlcpy+0x39>
  800b63:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b67:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b69:	39 c2                	cmp    %eax,%edx
  800b6b:	74 14                	je     800b81 <strlcpy+0x36>
  800b6d:	0f b6 19             	movzbl (%ecx),%ebx
  800b70:	84 db                	test   %bl,%bl
  800b72:	74 0b                	je     800b7f <strlcpy+0x34>
			*dst++ = *src++;
  800b74:	83 c1 01             	add    $0x1,%ecx
  800b77:	83 c2 01             	add    $0x1,%edx
  800b7a:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b7d:	eb ea                	jmp    800b69 <strlcpy+0x1e>
  800b7f:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b81:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b84:	29 f0                	sub    %esi,%eax
}
  800b86:	5b                   	pop    %ebx
  800b87:	5e                   	pop    %esi
  800b88:	5d                   	pop    %ebp
  800b89:	c3                   	ret    

00800b8a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b8a:	f3 0f 1e fb          	endbr32 
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b94:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b97:	0f b6 01             	movzbl (%ecx),%eax
  800b9a:	84 c0                	test   %al,%al
  800b9c:	74 0c                	je     800baa <strcmp+0x20>
  800b9e:	3a 02                	cmp    (%edx),%al
  800ba0:	75 08                	jne    800baa <strcmp+0x20>
		p++, q++;
  800ba2:	83 c1 01             	add    $0x1,%ecx
  800ba5:	83 c2 01             	add    $0x1,%edx
  800ba8:	eb ed                	jmp    800b97 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800baa:	0f b6 c0             	movzbl %al,%eax
  800bad:	0f b6 12             	movzbl (%edx),%edx
  800bb0:	29 d0                	sub    %edx,%eax
}
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bb4:	f3 0f 1e fb          	endbr32 
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	53                   	push   %ebx
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc2:	89 c3                	mov    %eax,%ebx
  800bc4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bc7:	eb 06                	jmp    800bcf <strncmp+0x1b>
		n--, p++, q++;
  800bc9:	83 c0 01             	add    $0x1,%eax
  800bcc:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bcf:	39 d8                	cmp    %ebx,%eax
  800bd1:	74 16                	je     800be9 <strncmp+0x35>
  800bd3:	0f b6 08             	movzbl (%eax),%ecx
  800bd6:	84 c9                	test   %cl,%cl
  800bd8:	74 04                	je     800bde <strncmp+0x2a>
  800bda:	3a 0a                	cmp    (%edx),%cl
  800bdc:	74 eb                	je     800bc9 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bde:	0f b6 00             	movzbl (%eax),%eax
  800be1:	0f b6 12             	movzbl (%edx),%edx
  800be4:	29 d0                	sub    %edx,%eax
}
  800be6:	5b                   	pop    %ebx
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    
		return 0;
  800be9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bee:	eb f6                	jmp    800be6 <strncmp+0x32>

00800bf0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bf0:	f3 0f 1e fb          	endbr32 
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bfe:	0f b6 10             	movzbl (%eax),%edx
  800c01:	84 d2                	test   %dl,%dl
  800c03:	74 09                	je     800c0e <strchr+0x1e>
		if (*s == c)
  800c05:	38 ca                	cmp    %cl,%dl
  800c07:	74 0a                	je     800c13 <strchr+0x23>
	for (; *s; s++)
  800c09:	83 c0 01             	add    $0x1,%eax
  800c0c:	eb f0                	jmp    800bfe <strchr+0xe>
			return (char *) s;
	return 0;
  800c0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    

00800c15 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c15:	f3 0f 1e fb          	endbr32 
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c23:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c26:	38 ca                	cmp    %cl,%dl
  800c28:	74 09                	je     800c33 <strfind+0x1e>
  800c2a:	84 d2                	test   %dl,%dl
  800c2c:	74 05                	je     800c33 <strfind+0x1e>
	for (; *s; s++)
  800c2e:	83 c0 01             	add    $0x1,%eax
  800c31:	eb f0                	jmp    800c23 <strfind+0xe>
			break;
	return (char *) s;
}
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c35:	f3 0f 1e fb          	endbr32 
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	57                   	push   %edi
  800c3d:	56                   	push   %esi
  800c3e:	53                   	push   %ebx
  800c3f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c42:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c45:	85 c9                	test   %ecx,%ecx
  800c47:	74 31                	je     800c7a <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c49:	89 f8                	mov    %edi,%eax
  800c4b:	09 c8                	or     %ecx,%eax
  800c4d:	a8 03                	test   $0x3,%al
  800c4f:	75 23                	jne    800c74 <memset+0x3f>
		c &= 0xFF;
  800c51:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c55:	89 d3                	mov    %edx,%ebx
  800c57:	c1 e3 08             	shl    $0x8,%ebx
  800c5a:	89 d0                	mov    %edx,%eax
  800c5c:	c1 e0 18             	shl    $0x18,%eax
  800c5f:	89 d6                	mov    %edx,%esi
  800c61:	c1 e6 10             	shl    $0x10,%esi
  800c64:	09 f0                	or     %esi,%eax
  800c66:	09 c2                	or     %eax,%edx
  800c68:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c6a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c6d:	89 d0                	mov    %edx,%eax
  800c6f:	fc                   	cld    
  800c70:	f3 ab                	rep stos %eax,%es:(%edi)
  800c72:	eb 06                	jmp    800c7a <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c77:	fc                   	cld    
  800c78:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c7a:	89 f8                	mov    %edi,%eax
  800c7c:	5b                   	pop    %ebx
  800c7d:	5e                   	pop    %esi
  800c7e:	5f                   	pop    %edi
  800c7f:	5d                   	pop    %ebp
  800c80:	c3                   	ret    

00800c81 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c81:	f3 0f 1e fb          	endbr32 
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	57                   	push   %edi
  800c89:	56                   	push   %esi
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c90:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c93:	39 c6                	cmp    %eax,%esi
  800c95:	73 32                	jae    800cc9 <memmove+0x48>
  800c97:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c9a:	39 c2                	cmp    %eax,%edx
  800c9c:	76 2b                	jbe    800cc9 <memmove+0x48>
		s += n;
		d += n;
  800c9e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ca1:	89 fe                	mov    %edi,%esi
  800ca3:	09 ce                	or     %ecx,%esi
  800ca5:	09 d6                	or     %edx,%esi
  800ca7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cad:	75 0e                	jne    800cbd <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800caf:	83 ef 04             	sub    $0x4,%edi
  800cb2:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cb5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800cb8:	fd                   	std    
  800cb9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cbb:	eb 09                	jmp    800cc6 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cbd:	83 ef 01             	sub    $0x1,%edi
  800cc0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cc3:	fd                   	std    
  800cc4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cc6:	fc                   	cld    
  800cc7:	eb 1a                	jmp    800ce3 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cc9:	89 c2                	mov    %eax,%edx
  800ccb:	09 ca                	or     %ecx,%edx
  800ccd:	09 f2                	or     %esi,%edx
  800ccf:	f6 c2 03             	test   $0x3,%dl
  800cd2:	75 0a                	jne    800cde <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cd4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cd7:	89 c7                	mov    %eax,%edi
  800cd9:	fc                   	cld    
  800cda:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cdc:	eb 05                	jmp    800ce3 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800cde:	89 c7                	mov    %eax,%edi
  800ce0:	fc                   	cld    
  800ce1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ce3:	5e                   	pop    %esi
  800ce4:	5f                   	pop    %edi
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    

00800ce7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ce7:	f3 0f 1e fb          	endbr32 
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cf1:	ff 75 10             	pushl  0x10(%ebp)
  800cf4:	ff 75 0c             	pushl  0xc(%ebp)
  800cf7:	ff 75 08             	pushl  0x8(%ebp)
  800cfa:	e8 82 ff ff ff       	call   800c81 <memmove>
}
  800cff:	c9                   	leave  
  800d00:	c3                   	ret    

00800d01 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d01:	f3 0f 1e fb          	endbr32 
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	56                   	push   %esi
  800d09:	53                   	push   %ebx
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d10:	89 c6                	mov    %eax,%esi
  800d12:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d15:	39 f0                	cmp    %esi,%eax
  800d17:	74 1c                	je     800d35 <memcmp+0x34>
		if (*s1 != *s2)
  800d19:	0f b6 08             	movzbl (%eax),%ecx
  800d1c:	0f b6 1a             	movzbl (%edx),%ebx
  800d1f:	38 d9                	cmp    %bl,%cl
  800d21:	75 08                	jne    800d2b <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d23:	83 c0 01             	add    $0x1,%eax
  800d26:	83 c2 01             	add    $0x1,%edx
  800d29:	eb ea                	jmp    800d15 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800d2b:	0f b6 c1             	movzbl %cl,%eax
  800d2e:	0f b6 db             	movzbl %bl,%ebx
  800d31:	29 d8                	sub    %ebx,%eax
  800d33:	eb 05                	jmp    800d3a <memcmp+0x39>
	}

	return 0;
  800d35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d3a:	5b                   	pop    %ebx
  800d3b:	5e                   	pop    %esi
  800d3c:	5d                   	pop    %ebp
  800d3d:	c3                   	ret    

00800d3e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d3e:	f3 0f 1e fb          	endbr32 
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d4b:	89 c2                	mov    %eax,%edx
  800d4d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d50:	39 d0                	cmp    %edx,%eax
  800d52:	73 09                	jae    800d5d <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d54:	38 08                	cmp    %cl,(%eax)
  800d56:	74 05                	je     800d5d <memfind+0x1f>
	for (; s < ends; s++)
  800d58:	83 c0 01             	add    $0x1,%eax
  800d5b:	eb f3                	jmp    800d50 <memfind+0x12>
			break;
	return (void *) s;
}
  800d5d:	5d                   	pop    %ebp
  800d5e:	c3                   	ret    

00800d5f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d5f:	f3 0f 1e fb          	endbr32 
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	57                   	push   %edi
  800d67:	56                   	push   %esi
  800d68:	53                   	push   %ebx
  800d69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d6f:	eb 03                	jmp    800d74 <strtol+0x15>
		s++;
  800d71:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d74:	0f b6 01             	movzbl (%ecx),%eax
  800d77:	3c 20                	cmp    $0x20,%al
  800d79:	74 f6                	je     800d71 <strtol+0x12>
  800d7b:	3c 09                	cmp    $0x9,%al
  800d7d:	74 f2                	je     800d71 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800d7f:	3c 2b                	cmp    $0x2b,%al
  800d81:	74 2a                	je     800dad <strtol+0x4e>
	int neg = 0;
  800d83:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d88:	3c 2d                	cmp    $0x2d,%al
  800d8a:	74 2b                	je     800db7 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d8c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d92:	75 0f                	jne    800da3 <strtol+0x44>
  800d94:	80 39 30             	cmpb   $0x30,(%ecx)
  800d97:	74 28                	je     800dc1 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d99:	85 db                	test   %ebx,%ebx
  800d9b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800da0:	0f 44 d8             	cmove  %eax,%ebx
  800da3:	b8 00 00 00 00       	mov    $0x0,%eax
  800da8:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800dab:	eb 46                	jmp    800df3 <strtol+0x94>
		s++;
  800dad:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800db0:	bf 00 00 00 00       	mov    $0x0,%edi
  800db5:	eb d5                	jmp    800d8c <strtol+0x2d>
		s++, neg = 1;
  800db7:	83 c1 01             	add    $0x1,%ecx
  800dba:	bf 01 00 00 00       	mov    $0x1,%edi
  800dbf:	eb cb                	jmp    800d8c <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dc1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800dc5:	74 0e                	je     800dd5 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800dc7:	85 db                	test   %ebx,%ebx
  800dc9:	75 d8                	jne    800da3 <strtol+0x44>
		s++, base = 8;
  800dcb:	83 c1 01             	add    $0x1,%ecx
  800dce:	bb 08 00 00 00       	mov    $0x8,%ebx
  800dd3:	eb ce                	jmp    800da3 <strtol+0x44>
		s += 2, base = 16;
  800dd5:	83 c1 02             	add    $0x2,%ecx
  800dd8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ddd:	eb c4                	jmp    800da3 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ddf:	0f be d2             	movsbl %dl,%edx
  800de2:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800de5:	3b 55 10             	cmp    0x10(%ebp),%edx
  800de8:	7d 3a                	jge    800e24 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800dea:	83 c1 01             	add    $0x1,%ecx
  800ded:	0f af 45 10          	imul   0x10(%ebp),%eax
  800df1:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800df3:	0f b6 11             	movzbl (%ecx),%edx
  800df6:	8d 72 d0             	lea    -0x30(%edx),%esi
  800df9:	89 f3                	mov    %esi,%ebx
  800dfb:	80 fb 09             	cmp    $0x9,%bl
  800dfe:	76 df                	jbe    800ddf <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800e00:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e03:	89 f3                	mov    %esi,%ebx
  800e05:	80 fb 19             	cmp    $0x19,%bl
  800e08:	77 08                	ja     800e12 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800e0a:	0f be d2             	movsbl %dl,%edx
  800e0d:	83 ea 57             	sub    $0x57,%edx
  800e10:	eb d3                	jmp    800de5 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800e12:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e15:	89 f3                	mov    %esi,%ebx
  800e17:	80 fb 19             	cmp    $0x19,%bl
  800e1a:	77 08                	ja     800e24 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800e1c:	0f be d2             	movsbl %dl,%edx
  800e1f:	83 ea 37             	sub    $0x37,%edx
  800e22:	eb c1                	jmp    800de5 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e28:	74 05                	je     800e2f <strtol+0xd0>
		*endptr = (char *) s;
  800e2a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e2d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e2f:	89 c2                	mov    %eax,%edx
  800e31:	f7 da                	neg    %edx
  800e33:	85 ff                	test   %edi,%edi
  800e35:	0f 45 c2             	cmovne %edx,%eax
}
  800e38:	5b                   	pop    %ebx
  800e39:	5e                   	pop    %esi
  800e3a:	5f                   	pop    %edi
  800e3b:	5d                   	pop    %ebp
  800e3c:	c3                   	ret    

00800e3d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e3d:	f3 0f 1e fb          	endbr32 
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	57                   	push   %edi
  800e45:	56                   	push   %esi
  800e46:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e47:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e52:	89 c3                	mov    %eax,%ebx
  800e54:	89 c7                	mov    %eax,%edi
  800e56:	89 c6                	mov    %eax,%esi
  800e58:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e5a:	5b                   	pop    %ebx
  800e5b:	5e                   	pop    %esi
  800e5c:	5f                   	pop    %edi
  800e5d:	5d                   	pop    %ebp
  800e5e:	c3                   	ret    

00800e5f <sys_cgetc>:

int
sys_cgetc(void)
{
  800e5f:	f3 0f 1e fb          	endbr32 
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	57                   	push   %edi
  800e67:	56                   	push   %esi
  800e68:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e69:	ba 00 00 00 00       	mov    $0x0,%edx
  800e6e:	b8 01 00 00 00       	mov    $0x1,%eax
  800e73:	89 d1                	mov    %edx,%ecx
  800e75:	89 d3                	mov    %edx,%ebx
  800e77:	89 d7                	mov    %edx,%edi
  800e79:	89 d6                	mov    %edx,%esi
  800e7b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e7d:	5b                   	pop    %ebx
  800e7e:	5e                   	pop    %esi
  800e7f:	5f                   	pop    %edi
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    

00800e82 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e82:	f3 0f 1e fb          	endbr32 
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	57                   	push   %edi
  800e8a:	56                   	push   %esi
  800e8b:	53                   	push   %ebx
  800e8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e94:	8b 55 08             	mov    0x8(%ebp),%edx
  800e97:	b8 03 00 00 00       	mov    $0x3,%eax
  800e9c:	89 cb                	mov    %ecx,%ebx
  800e9e:	89 cf                	mov    %ecx,%edi
  800ea0:	89 ce                	mov    %ecx,%esi
  800ea2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	7f 08                	jg     800eb0 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ea8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eab:	5b                   	pop    %ebx
  800eac:	5e                   	pop    %esi
  800ead:	5f                   	pop    %edi
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb0:	83 ec 0c             	sub    $0xc,%esp
  800eb3:	50                   	push   %eax
  800eb4:	6a 03                	push   $0x3
  800eb6:	68 6f 25 80 00       	push   $0x80256f
  800ebb:	6a 23                	push   $0x23
  800ebd:	68 8c 25 80 00       	push   $0x80258c
  800ec2:	e8 1f f4 ff ff       	call   8002e6 <_panic>

00800ec7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ec7:	f3 0f 1e fb          	endbr32 
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	57                   	push   %edi
  800ecf:	56                   	push   %esi
  800ed0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed6:	b8 02 00 00 00       	mov    $0x2,%eax
  800edb:	89 d1                	mov    %edx,%ecx
  800edd:	89 d3                	mov    %edx,%ebx
  800edf:	89 d7                	mov    %edx,%edi
  800ee1:	89 d6                	mov    %edx,%esi
  800ee3:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ee5:	5b                   	pop    %ebx
  800ee6:	5e                   	pop    %esi
  800ee7:	5f                   	pop    %edi
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    

00800eea <sys_yield>:

void
sys_yield(void)
{
  800eea:	f3 0f 1e fb          	endbr32 
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	57                   	push   %edi
  800ef2:	56                   	push   %esi
  800ef3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800efe:	89 d1                	mov    %edx,%ecx
  800f00:	89 d3                	mov    %edx,%ebx
  800f02:	89 d7                	mov    %edx,%edi
  800f04:	89 d6                	mov    %edx,%esi
  800f06:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f08:	5b                   	pop    %ebx
  800f09:	5e                   	pop    %esi
  800f0a:	5f                   	pop    %edi
  800f0b:	5d                   	pop    %ebp
  800f0c:	c3                   	ret    

00800f0d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f0d:	f3 0f 1e fb          	endbr32 
  800f11:	55                   	push   %ebp
  800f12:	89 e5                	mov    %esp,%ebp
  800f14:	57                   	push   %edi
  800f15:	56                   	push   %esi
  800f16:	53                   	push   %ebx
  800f17:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f1a:	be 00 00 00 00       	mov    $0x0,%esi
  800f1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f25:	b8 04 00 00 00       	mov    $0x4,%eax
  800f2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f2d:	89 f7                	mov    %esi,%edi
  800f2f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f31:	85 c0                	test   %eax,%eax
  800f33:	7f 08                	jg     800f3d <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f38:	5b                   	pop    %ebx
  800f39:	5e                   	pop    %esi
  800f3a:	5f                   	pop    %edi
  800f3b:	5d                   	pop    %ebp
  800f3c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3d:	83 ec 0c             	sub    $0xc,%esp
  800f40:	50                   	push   %eax
  800f41:	6a 04                	push   $0x4
  800f43:	68 6f 25 80 00       	push   $0x80256f
  800f48:	6a 23                	push   $0x23
  800f4a:	68 8c 25 80 00       	push   $0x80258c
  800f4f:	e8 92 f3 ff ff       	call   8002e6 <_panic>

00800f54 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f54:	f3 0f 1e fb          	endbr32 
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	57                   	push   %edi
  800f5c:	56                   	push   %esi
  800f5d:	53                   	push   %ebx
  800f5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f61:	8b 55 08             	mov    0x8(%ebp),%edx
  800f64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f67:	b8 05 00 00 00       	mov    $0x5,%eax
  800f6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f72:	8b 75 18             	mov    0x18(%ebp),%esi
  800f75:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f77:	85 c0                	test   %eax,%eax
  800f79:	7f 08                	jg     800f83 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f7e:	5b                   	pop    %ebx
  800f7f:	5e                   	pop    %esi
  800f80:	5f                   	pop    %edi
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f83:	83 ec 0c             	sub    $0xc,%esp
  800f86:	50                   	push   %eax
  800f87:	6a 05                	push   $0x5
  800f89:	68 6f 25 80 00       	push   $0x80256f
  800f8e:	6a 23                	push   $0x23
  800f90:	68 8c 25 80 00       	push   $0x80258c
  800f95:	e8 4c f3 ff ff       	call   8002e6 <_panic>

00800f9a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f9a:	f3 0f 1e fb          	endbr32 
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	57                   	push   %edi
  800fa2:	56                   	push   %esi
  800fa3:	53                   	push   %ebx
  800fa4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fac:	8b 55 08             	mov    0x8(%ebp),%edx
  800faf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb2:	b8 06 00 00 00       	mov    $0x6,%eax
  800fb7:	89 df                	mov    %ebx,%edi
  800fb9:	89 de                	mov    %ebx,%esi
  800fbb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fbd:	85 c0                	test   %eax,%eax
  800fbf:	7f 08                	jg     800fc9 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc4:	5b                   	pop    %ebx
  800fc5:	5e                   	pop    %esi
  800fc6:	5f                   	pop    %edi
  800fc7:	5d                   	pop    %ebp
  800fc8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc9:	83 ec 0c             	sub    $0xc,%esp
  800fcc:	50                   	push   %eax
  800fcd:	6a 06                	push   $0x6
  800fcf:	68 6f 25 80 00       	push   $0x80256f
  800fd4:	6a 23                	push   $0x23
  800fd6:	68 8c 25 80 00       	push   $0x80258c
  800fdb:	e8 06 f3 ff ff       	call   8002e6 <_panic>

00800fe0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fe0:	f3 0f 1e fb          	endbr32 
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	57                   	push   %edi
  800fe8:	56                   	push   %esi
  800fe9:	53                   	push   %ebx
  800fea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fed:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff8:	b8 08 00 00 00       	mov    $0x8,%eax
  800ffd:	89 df                	mov    %ebx,%edi
  800fff:	89 de                	mov    %ebx,%esi
  801001:	cd 30                	int    $0x30
	if(check && ret > 0)
  801003:	85 c0                	test   %eax,%eax
  801005:	7f 08                	jg     80100f <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801007:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80100a:	5b                   	pop    %ebx
  80100b:	5e                   	pop    %esi
  80100c:	5f                   	pop    %edi
  80100d:	5d                   	pop    %ebp
  80100e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80100f:	83 ec 0c             	sub    $0xc,%esp
  801012:	50                   	push   %eax
  801013:	6a 08                	push   $0x8
  801015:	68 6f 25 80 00       	push   $0x80256f
  80101a:	6a 23                	push   $0x23
  80101c:	68 8c 25 80 00       	push   $0x80258c
  801021:	e8 c0 f2 ff ff       	call   8002e6 <_panic>

00801026 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801026:	f3 0f 1e fb          	endbr32 
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	57                   	push   %edi
  80102e:	56                   	push   %esi
  80102f:	53                   	push   %ebx
  801030:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801033:	bb 00 00 00 00       	mov    $0x0,%ebx
  801038:	8b 55 08             	mov    0x8(%ebp),%edx
  80103b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103e:	b8 09 00 00 00       	mov    $0x9,%eax
  801043:	89 df                	mov    %ebx,%edi
  801045:	89 de                	mov    %ebx,%esi
  801047:	cd 30                	int    $0x30
	if(check && ret > 0)
  801049:	85 c0                	test   %eax,%eax
  80104b:	7f 08                	jg     801055 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80104d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801050:	5b                   	pop    %ebx
  801051:	5e                   	pop    %esi
  801052:	5f                   	pop    %edi
  801053:	5d                   	pop    %ebp
  801054:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801055:	83 ec 0c             	sub    $0xc,%esp
  801058:	50                   	push   %eax
  801059:	6a 09                	push   $0x9
  80105b:	68 6f 25 80 00       	push   $0x80256f
  801060:	6a 23                	push   $0x23
  801062:	68 8c 25 80 00       	push   $0x80258c
  801067:	e8 7a f2 ff ff       	call   8002e6 <_panic>

0080106c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80106c:	f3 0f 1e fb          	endbr32 
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	57                   	push   %edi
  801074:	56                   	push   %esi
  801075:	53                   	push   %ebx
  801076:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801079:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107e:	8b 55 08             	mov    0x8(%ebp),%edx
  801081:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801084:	b8 0a 00 00 00       	mov    $0xa,%eax
  801089:	89 df                	mov    %ebx,%edi
  80108b:	89 de                	mov    %ebx,%esi
  80108d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80108f:	85 c0                	test   %eax,%eax
  801091:	7f 08                	jg     80109b <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801093:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801096:	5b                   	pop    %ebx
  801097:	5e                   	pop    %esi
  801098:	5f                   	pop    %edi
  801099:	5d                   	pop    %ebp
  80109a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80109b:	83 ec 0c             	sub    $0xc,%esp
  80109e:	50                   	push   %eax
  80109f:	6a 0a                	push   $0xa
  8010a1:	68 6f 25 80 00       	push   $0x80256f
  8010a6:	6a 23                	push   $0x23
  8010a8:	68 8c 25 80 00       	push   $0x80258c
  8010ad:	e8 34 f2 ff ff       	call   8002e6 <_panic>

008010b2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010b2:	f3 0f 1e fb          	endbr32 
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	57                   	push   %edi
  8010ba:	56                   	push   %esi
  8010bb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c2:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010c7:	be 00 00 00 00       	mov    $0x0,%esi
  8010cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010cf:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010d2:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010d4:	5b                   	pop    %ebx
  8010d5:	5e                   	pop    %esi
  8010d6:	5f                   	pop    %edi
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010d9:	f3 0f 1e fb          	endbr32 
  8010dd:	55                   	push   %ebp
  8010de:	89 e5                	mov    %esp,%ebp
  8010e0:	57                   	push   %edi
  8010e1:	56                   	push   %esi
  8010e2:	53                   	push   %ebx
  8010e3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010e6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ee:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010f3:	89 cb                	mov    %ecx,%ebx
  8010f5:	89 cf                	mov    %ecx,%edi
  8010f7:	89 ce                	mov    %ecx,%esi
  8010f9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010fb:	85 c0                	test   %eax,%eax
  8010fd:	7f 08                	jg     801107 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801102:	5b                   	pop    %ebx
  801103:	5e                   	pop    %esi
  801104:	5f                   	pop    %edi
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801107:	83 ec 0c             	sub    $0xc,%esp
  80110a:	50                   	push   %eax
  80110b:	6a 0d                	push   $0xd
  80110d:	68 6f 25 80 00       	push   $0x80256f
  801112:	6a 23                	push   $0x23
  801114:	68 8c 25 80 00       	push   $0x80258c
  801119:	e8 c8 f1 ff ff       	call   8002e6 <_panic>

0080111e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80111e:	f3 0f 1e fb          	endbr32 
  801122:	55                   	push   %ebp
  801123:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	05 00 00 00 30       	add    $0x30000000,%eax
  80112d:	c1 e8 0c             	shr    $0xc,%eax
}
  801130:	5d                   	pop    %ebp
  801131:	c3                   	ret    

00801132 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801132:	f3 0f 1e fb          	endbr32 
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801141:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801146:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80114b:	5d                   	pop    %ebp
  80114c:	c3                   	ret    

0080114d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80114d:	f3 0f 1e fb          	endbr32 
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801159:	89 c2                	mov    %eax,%edx
  80115b:	c1 ea 16             	shr    $0x16,%edx
  80115e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801165:	f6 c2 01             	test   $0x1,%dl
  801168:	74 2d                	je     801197 <fd_alloc+0x4a>
  80116a:	89 c2                	mov    %eax,%edx
  80116c:	c1 ea 0c             	shr    $0xc,%edx
  80116f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801176:	f6 c2 01             	test   $0x1,%dl
  801179:	74 1c                	je     801197 <fd_alloc+0x4a>
  80117b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801180:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801185:	75 d2                	jne    801159 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801190:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801195:	eb 0a                	jmp    8011a1 <fd_alloc+0x54>
			*fd_store = fd;
  801197:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80119a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80119c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a1:	5d                   	pop    %ebp
  8011a2:	c3                   	ret    

008011a3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011a3:	f3 0f 1e fb          	endbr32 
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011ad:	83 f8 1f             	cmp    $0x1f,%eax
  8011b0:	77 30                	ja     8011e2 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011b2:	c1 e0 0c             	shl    $0xc,%eax
  8011b5:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011ba:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011c0:	f6 c2 01             	test   $0x1,%dl
  8011c3:	74 24                	je     8011e9 <fd_lookup+0x46>
  8011c5:	89 c2                	mov    %eax,%edx
  8011c7:	c1 ea 0c             	shr    $0xc,%edx
  8011ca:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011d1:	f6 c2 01             	test   $0x1,%dl
  8011d4:	74 1a                	je     8011f0 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d9:	89 02                	mov    %eax,(%edx)
	return 0;
  8011db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e0:	5d                   	pop    %ebp
  8011e1:	c3                   	ret    
		return -E_INVAL;
  8011e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011e7:	eb f7                	jmp    8011e0 <fd_lookup+0x3d>
		return -E_INVAL;
  8011e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ee:	eb f0                	jmp    8011e0 <fd_lookup+0x3d>
  8011f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f5:	eb e9                	jmp    8011e0 <fd_lookup+0x3d>

008011f7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011f7:	f3 0f 1e fb          	endbr32 
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	83 ec 08             	sub    $0x8,%esp
  801201:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801204:	ba 18 26 80 00       	mov    $0x802618,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801209:	b8 20 30 80 00       	mov    $0x803020,%eax
		if (devtab[i]->dev_id == dev_id) {
  80120e:	39 08                	cmp    %ecx,(%eax)
  801210:	74 33                	je     801245 <dev_lookup+0x4e>
  801212:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801215:	8b 02                	mov    (%edx),%eax
  801217:	85 c0                	test   %eax,%eax
  801219:	75 f3                	jne    80120e <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80121b:	a1 04 44 80 00       	mov    0x804404,%eax
  801220:	8b 40 48             	mov    0x48(%eax),%eax
  801223:	83 ec 04             	sub    $0x4,%esp
  801226:	51                   	push   %ecx
  801227:	50                   	push   %eax
  801228:	68 9c 25 80 00       	push   $0x80259c
  80122d:	e8 9b f1 ff ff       	call   8003cd <cprintf>
	*dev = 0;
  801232:	8b 45 0c             	mov    0xc(%ebp),%eax
  801235:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80123b:	83 c4 10             	add    $0x10,%esp
  80123e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801243:	c9                   	leave  
  801244:	c3                   	ret    
			*dev = devtab[i];
  801245:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801248:	89 01                	mov    %eax,(%ecx)
			return 0;
  80124a:	b8 00 00 00 00       	mov    $0x0,%eax
  80124f:	eb f2                	jmp    801243 <dev_lookup+0x4c>

00801251 <fd_close>:
{
  801251:	f3 0f 1e fb          	endbr32 
  801255:	55                   	push   %ebp
  801256:	89 e5                	mov    %esp,%ebp
  801258:	57                   	push   %edi
  801259:	56                   	push   %esi
  80125a:	53                   	push   %ebx
  80125b:	83 ec 24             	sub    $0x24,%esp
  80125e:	8b 75 08             	mov    0x8(%ebp),%esi
  801261:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801264:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801267:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801268:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80126e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801271:	50                   	push   %eax
  801272:	e8 2c ff ff ff       	call   8011a3 <fd_lookup>
  801277:	89 c3                	mov    %eax,%ebx
  801279:	83 c4 10             	add    $0x10,%esp
  80127c:	85 c0                	test   %eax,%eax
  80127e:	78 05                	js     801285 <fd_close+0x34>
	    || fd != fd2)
  801280:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801283:	74 16                	je     80129b <fd_close+0x4a>
		return (must_exist ? r : 0);
  801285:	89 f8                	mov    %edi,%eax
  801287:	84 c0                	test   %al,%al
  801289:	b8 00 00 00 00       	mov    $0x0,%eax
  80128e:	0f 44 d8             	cmove  %eax,%ebx
}
  801291:	89 d8                	mov    %ebx,%eax
  801293:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801296:	5b                   	pop    %ebx
  801297:	5e                   	pop    %esi
  801298:	5f                   	pop    %edi
  801299:	5d                   	pop    %ebp
  80129a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80129b:	83 ec 08             	sub    $0x8,%esp
  80129e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012a1:	50                   	push   %eax
  8012a2:	ff 36                	pushl  (%esi)
  8012a4:	e8 4e ff ff ff       	call   8011f7 <dev_lookup>
  8012a9:	89 c3                	mov    %eax,%ebx
  8012ab:	83 c4 10             	add    $0x10,%esp
  8012ae:	85 c0                	test   %eax,%eax
  8012b0:	78 1a                	js     8012cc <fd_close+0x7b>
		if (dev->dev_close)
  8012b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012b5:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012b8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012bd:	85 c0                	test   %eax,%eax
  8012bf:	74 0b                	je     8012cc <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8012c1:	83 ec 0c             	sub    $0xc,%esp
  8012c4:	56                   	push   %esi
  8012c5:	ff d0                	call   *%eax
  8012c7:	89 c3                	mov    %eax,%ebx
  8012c9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012cc:	83 ec 08             	sub    $0x8,%esp
  8012cf:	56                   	push   %esi
  8012d0:	6a 00                	push   $0x0
  8012d2:	e8 c3 fc ff ff       	call   800f9a <sys_page_unmap>
	return r;
  8012d7:	83 c4 10             	add    $0x10,%esp
  8012da:	eb b5                	jmp    801291 <fd_close+0x40>

008012dc <close>:

int
close(int fdnum)
{
  8012dc:	f3 0f 1e fb          	endbr32 
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e9:	50                   	push   %eax
  8012ea:	ff 75 08             	pushl  0x8(%ebp)
  8012ed:	e8 b1 fe ff ff       	call   8011a3 <fd_lookup>
  8012f2:	83 c4 10             	add    $0x10,%esp
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	79 02                	jns    8012fb <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    
		return fd_close(fd, 1);
  8012fb:	83 ec 08             	sub    $0x8,%esp
  8012fe:	6a 01                	push   $0x1
  801300:	ff 75 f4             	pushl  -0xc(%ebp)
  801303:	e8 49 ff ff ff       	call   801251 <fd_close>
  801308:	83 c4 10             	add    $0x10,%esp
  80130b:	eb ec                	jmp    8012f9 <close+0x1d>

0080130d <close_all>:

void
close_all(void)
{
  80130d:	f3 0f 1e fb          	endbr32 
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	53                   	push   %ebx
  801315:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801318:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80131d:	83 ec 0c             	sub    $0xc,%esp
  801320:	53                   	push   %ebx
  801321:	e8 b6 ff ff ff       	call   8012dc <close>
	for (i = 0; i < MAXFD; i++)
  801326:	83 c3 01             	add    $0x1,%ebx
  801329:	83 c4 10             	add    $0x10,%esp
  80132c:	83 fb 20             	cmp    $0x20,%ebx
  80132f:	75 ec                	jne    80131d <close_all+0x10>
}
  801331:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801334:	c9                   	leave  
  801335:	c3                   	ret    

00801336 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801336:	f3 0f 1e fb          	endbr32 
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	57                   	push   %edi
  80133e:	56                   	push   %esi
  80133f:	53                   	push   %ebx
  801340:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801343:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801346:	50                   	push   %eax
  801347:	ff 75 08             	pushl  0x8(%ebp)
  80134a:	e8 54 fe ff ff       	call   8011a3 <fd_lookup>
  80134f:	89 c3                	mov    %eax,%ebx
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	85 c0                	test   %eax,%eax
  801356:	0f 88 81 00 00 00    	js     8013dd <dup+0xa7>
		return r;
	close(newfdnum);
  80135c:	83 ec 0c             	sub    $0xc,%esp
  80135f:	ff 75 0c             	pushl  0xc(%ebp)
  801362:	e8 75 ff ff ff       	call   8012dc <close>

	newfd = INDEX2FD(newfdnum);
  801367:	8b 75 0c             	mov    0xc(%ebp),%esi
  80136a:	c1 e6 0c             	shl    $0xc,%esi
  80136d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801373:	83 c4 04             	add    $0x4,%esp
  801376:	ff 75 e4             	pushl  -0x1c(%ebp)
  801379:	e8 b4 fd ff ff       	call   801132 <fd2data>
  80137e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801380:	89 34 24             	mov    %esi,(%esp)
  801383:	e8 aa fd ff ff       	call   801132 <fd2data>
  801388:	83 c4 10             	add    $0x10,%esp
  80138b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80138d:	89 d8                	mov    %ebx,%eax
  80138f:	c1 e8 16             	shr    $0x16,%eax
  801392:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801399:	a8 01                	test   $0x1,%al
  80139b:	74 11                	je     8013ae <dup+0x78>
  80139d:	89 d8                	mov    %ebx,%eax
  80139f:	c1 e8 0c             	shr    $0xc,%eax
  8013a2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013a9:	f6 c2 01             	test   $0x1,%dl
  8013ac:	75 39                	jne    8013e7 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013b1:	89 d0                	mov    %edx,%eax
  8013b3:	c1 e8 0c             	shr    $0xc,%eax
  8013b6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013bd:	83 ec 0c             	sub    $0xc,%esp
  8013c0:	25 07 0e 00 00       	and    $0xe07,%eax
  8013c5:	50                   	push   %eax
  8013c6:	56                   	push   %esi
  8013c7:	6a 00                	push   $0x0
  8013c9:	52                   	push   %edx
  8013ca:	6a 00                	push   $0x0
  8013cc:	e8 83 fb ff ff       	call   800f54 <sys_page_map>
  8013d1:	89 c3                	mov    %eax,%ebx
  8013d3:	83 c4 20             	add    $0x20,%esp
  8013d6:	85 c0                	test   %eax,%eax
  8013d8:	78 31                	js     80140b <dup+0xd5>
		goto err;

	return newfdnum;
  8013da:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013dd:	89 d8                	mov    %ebx,%eax
  8013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013e2:	5b                   	pop    %ebx
  8013e3:	5e                   	pop    %esi
  8013e4:	5f                   	pop    %edi
  8013e5:	5d                   	pop    %ebp
  8013e6:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013e7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013ee:	83 ec 0c             	sub    $0xc,%esp
  8013f1:	25 07 0e 00 00       	and    $0xe07,%eax
  8013f6:	50                   	push   %eax
  8013f7:	57                   	push   %edi
  8013f8:	6a 00                	push   $0x0
  8013fa:	53                   	push   %ebx
  8013fb:	6a 00                	push   $0x0
  8013fd:	e8 52 fb ff ff       	call   800f54 <sys_page_map>
  801402:	89 c3                	mov    %eax,%ebx
  801404:	83 c4 20             	add    $0x20,%esp
  801407:	85 c0                	test   %eax,%eax
  801409:	79 a3                	jns    8013ae <dup+0x78>
	sys_page_unmap(0, newfd);
  80140b:	83 ec 08             	sub    $0x8,%esp
  80140e:	56                   	push   %esi
  80140f:	6a 00                	push   $0x0
  801411:	e8 84 fb ff ff       	call   800f9a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801416:	83 c4 08             	add    $0x8,%esp
  801419:	57                   	push   %edi
  80141a:	6a 00                	push   $0x0
  80141c:	e8 79 fb ff ff       	call   800f9a <sys_page_unmap>
	return r;
  801421:	83 c4 10             	add    $0x10,%esp
  801424:	eb b7                	jmp    8013dd <dup+0xa7>

00801426 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801426:	f3 0f 1e fb          	endbr32 
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	53                   	push   %ebx
  80142e:	83 ec 1c             	sub    $0x1c,%esp
  801431:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801434:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801437:	50                   	push   %eax
  801438:	53                   	push   %ebx
  801439:	e8 65 fd ff ff       	call   8011a3 <fd_lookup>
  80143e:	83 c4 10             	add    $0x10,%esp
  801441:	85 c0                	test   %eax,%eax
  801443:	78 3f                	js     801484 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801445:	83 ec 08             	sub    $0x8,%esp
  801448:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80144b:	50                   	push   %eax
  80144c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144f:	ff 30                	pushl  (%eax)
  801451:	e8 a1 fd ff ff       	call   8011f7 <dev_lookup>
  801456:	83 c4 10             	add    $0x10,%esp
  801459:	85 c0                	test   %eax,%eax
  80145b:	78 27                	js     801484 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80145d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801460:	8b 42 08             	mov    0x8(%edx),%eax
  801463:	83 e0 03             	and    $0x3,%eax
  801466:	83 f8 01             	cmp    $0x1,%eax
  801469:	74 1e                	je     801489 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80146b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146e:	8b 40 08             	mov    0x8(%eax),%eax
  801471:	85 c0                	test   %eax,%eax
  801473:	74 35                	je     8014aa <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801475:	83 ec 04             	sub    $0x4,%esp
  801478:	ff 75 10             	pushl  0x10(%ebp)
  80147b:	ff 75 0c             	pushl  0xc(%ebp)
  80147e:	52                   	push   %edx
  80147f:	ff d0                	call   *%eax
  801481:	83 c4 10             	add    $0x10,%esp
}
  801484:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801487:	c9                   	leave  
  801488:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801489:	a1 04 44 80 00       	mov    0x804404,%eax
  80148e:	8b 40 48             	mov    0x48(%eax),%eax
  801491:	83 ec 04             	sub    $0x4,%esp
  801494:	53                   	push   %ebx
  801495:	50                   	push   %eax
  801496:	68 dd 25 80 00       	push   $0x8025dd
  80149b:	e8 2d ef ff ff       	call   8003cd <cprintf>
		return -E_INVAL;
  8014a0:	83 c4 10             	add    $0x10,%esp
  8014a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a8:	eb da                	jmp    801484 <read+0x5e>
		return -E_NOT_SUPP;
  8014aa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014af:	eb d3                	jmp    801484 <read+0x5e>

008014b1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014b1:	f3 0f 1e fb          	endbr32 
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	57                   	push   %edi
  8014b9:	56                   	push   %esi
  8014ba:	53                   	push   %ebx
  8014bb:	83 ec 0c             	sub    $0xc,%esp
  8014be:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014c1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014c9:	eb 02                	jmp    8014cd <readn+0x1c>
  8014cb:	01 c3                	add    %eax,%ebx
  8014cd:	39 f3                	cmp    %esi,%ebx
  8014cf:	73 21                	jae    8014f2 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014d1:	83 ec 04             	sub    $0x4,%esp
  8014d4:	89 f0                	mov    %esi,%eax
  8014d6:	29 d8                	sub    %ebx,%eax
  8014d8:	50                   	push   %eax
  8014d9:	89 d8                	mov    %ebx,%eax
  8014db:	03 45 0c             	add    0xc(%ebp),%eax
  8014de:	50                   	push   %eax
  8014df:	57                   	push   %edi
  8014e0:	e8 41 ff ff ff       	call   801426 <read>
		if (m < 0)
  8014e5:	83 c4 10             	add    $0x10,%esp
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	78 04                	js     8014f0 <readn+0x3f>
			return m;
		if (m == 0)
  8014ec:	75 dd                	jne    8014cb <readn+0x1a>
  8014ee:	eb 02                	jmp    8014f2 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014f0:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014f2:	89 d8                	mov    %ebx,%eax
  8014f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014f7:	5b                   	pop    %ebx
  8014f8:	5e                   	pop    %esi
  8014f9:	5f                   	pop    %edi
  8014fa:	5d                   	pop    %ebp
  8014fb:	c3                   	ret    

008014fc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014fc:	f3 0f 1e fb          	endbr32 
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	53                   	push   %ebx
  801504:	83 ec 1c             	sub    $0x1c,%esp
  801507:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80150a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80150d:	50                   	push   %eax
  80150e:	53                   	push   %ebx
  80150f:	e8 8f fc ff ff       	call   8011a3 <fd_lookup>
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	85 c0                	test   %eax,%eax
  801519:	78 3a                	js     801555 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80151b:	83 ec 08             	sub    $0x8,%esp
  80151e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801521:	50                   	push   %eax
  801522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801525:	ff 30                	pushl  (%eax)
  801527:	e8 cb fc ff ff       	call   8011f7 <dev_lookup>
  80152c:	83 c4 10             	add    $0x10,%esp
  80152f:	85 c0                	test   %eax,%eax
  801531:	78 22                	js     801555 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801536:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80153a:	74 1e                	je     80155a <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80153c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80153f:	8b 52 0c             	mov    0xc(%edx),%edx
  801542:	85 d2                	test   %edx,%edx
  801544:	74 35                	je     80157b <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801546:	83 ec 04             	sub    $0x4,%esp
  801549:	ff 75 10             	pushl  0x10(%ebp)
  80154c:	ff 75 0c             	pushl  0xc(%ebp)
  80154f:	50                   	push   %eax
  801550:	ff d2                	call   *%edx
  801552:	83 c4 10             	add    $0x10,%esp
}
  801555:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801558:	c9                   	leave  
  801559:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80155a:	a1 04 44 80 00       	mov    0x804404,%eax
  80155f:	8b 40 48             	mov    0x48(%eax),%eax
  801562:	83 ec 04             	sub    $0x4,%esp
  801565:	53                   	push   %ebx
  801566:	50                   	push   %eax
  801567:	68 f9 25 80 00       	push   $0x8025f9
  80156c:	e8 5c ee ff ff       	call   8003cd <cprintf>
		return -E_INVAL;
  801571:	83 c4 10             	add    $0x10,%esp
  801574:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801579:	eb da                	jmp    801555 <write+0x59>
		return -E_NOT_SUPP;
  80157b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801580:	eb d3                	jmp    801555 <write+0x59>

00801582 <seek>:

int
seek(int fdnum, off_t offset)
{
  801582:	f3 0f 1e fb          	endbr32 
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80158c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80158f:	50                   	push   %eax
  801590:	ff 75 08             	pushl  0x8(%ebp)
  801593:	e8 0b fc ff ff       	call   8011a3 <fd_lookup>
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	85 c0                	test   %eax,%eax
  80159d:	78 0e                	js     8015ad <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80159f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    

008015af <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015af:	f3 0f 1e fb          	endbr32 
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	53                   	push   %ebx
  8015b7:	83 ec 1c             	sub    $0x1c,%esp
  8015ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015c0:	50                   	push   %eax
  8015c1:	53                   	push   %ebx
  8015c2:	e8 dc fb ff ff       	call   8011a3 <fd_lookup>
  8015c7:	83 c4 10             	add    $0x10,%esp
  8015ca:	85 c0                	test   %eax,%eax
  8015cc:	78 37                	js     801605 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ce:	83 ec 08             	sub    $0x8,%esp
  8015d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d4:	50                   	push   %eax
  8015d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d8:	ff 30                	pushl  (%eax)
  8015da:	e8 18 fc ff ff       	call   8011f7 <dev_lookup>
  8015df:	83 c4 10             	add    $0x10,%esp
  8015e2:	85 c0                	test   %eax,%eax
  8015e4:	78 1f                	js     801605 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015ed:	74 1b                	je     80160a <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f2:	8b 52 18             	mov    0x18(%edx),%edx
  8015f5:	85 d2                	test   %edx,%edx
  8015f7:	74 32                	je     80162b <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015f9:	83 ec 08             	sub    $0x8,%esp
  8015fc:	ff 75 0c             	pushl  0xc(%ebp)
  8015ff:	50                   	push   %eax
  801600:	ff d2                	call   *%edx
  801602:	83 c4 10             	add    $0x10,%esp
}
  801605:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801608:	c9                   	leave  
  801609:	c3                   	ret    
			thisenv->env_id, fdnum);
  80160a:	a1 04 44 80 00       	mov    0x804404,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80160f:	8b 40 48             	mov    0x48(%eax),%eax
  801612:	83 ec 04             	sub    $0x4,%esp
  801615:	53                   	push   %ebx
  801616:	50                   	push   %eax
  801617:	68 bc 25 80 00       	push   $0x8025bc
  80161c:	e8 ac ed ff ff       	call   8003cd <cprintf>
		return -E_INVAL;
  801621:	83 c4 10             	add    $0x10,%esp
  801624:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801629:	eb da                	jmp    801605 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80162b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801630:	eb d3                	jmp    801605 <ftruncate+0x56>

00801632 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801632:	f3 0f 1e fb          	endbr32 
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	53                   	push   %ebx
  80163a:	83 ec 1c             	sub    $0x1c,%esp
  80163d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801640:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801643:	50                   	push   %eax
  801644:	ff 75 08             	pushl  0x8(%ebp)
  801647:	e8 57 fb ff ff       	call   8011a3 <fd_lookup>
  80164c:	83 c4 10             	add    $0x10,%esp
  80164f:	85 c0                	test   %eax,%eax
  801651:	78 4b                	js     80169e <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801653:	83 ec 08             	sub    $0x8,%esp
  801656:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801659:	50                   	push   %eax
  80165a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165d:	ff 30                	pushl  (%eax)
  80165f:	e8 93 fb ff ff       	call   8011f7 <dev_lookup>
  801664:	83 c4 10             	add    $0x10,%esp
  801667:	85 c0                	test   %eax,%eax
  801669:	78 33                	js     80169e <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80166b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801672:	74 2f                	je     8016a3 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801674:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801677:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80167e:	00 00 00 
	stat->st_isdir = 0;
  801681:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801688:	00 00 00 
	stat->st_dev = dev;
  80168b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801691:	83 ec 08             	sub    $0x8,%esp
  801694:	53                   	push   %ebx
  801695:	ff 75 f0             	pushl  -0x10(%ebp)
  801698:	ff 50 14             	call   *0x14(%eax)
  80169b:	83 c4 10             	add    $0x10,%esp
}
  80169e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    
		return -E_NOT_SUPP;
  8016a3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016a8:	eb f4                	jmp    80169e <fstat+0x6c>

008016aa <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016aa:	f3 0f 1e fb          	endbr32 
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	56                   	push   %esi
  8016b2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016b3:	83 ec 08             	sub    $0x8,%esp
  8016b6:	6a 00                	push   $0x0
  8016b8:	ff 75 08             	pushl  0x8(%ebp)
  8016bb:	e8 fb 01 00 00       	call   8018bb <open>
  8016c0:	89 c3                	mov    %eax,%ebx
  8016c2:	83 c4 10             	add    $0x10,%esp
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	78 1b                	js     8016e4 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8016c9:	83 ec 08             	sub    $0x8,%esp
  8016cc:	ff 75 0c             	pushl  0xc(%ebp)
  8016cf:	50                   	push   %eax
  8016d0:	e8 5d ff ff ff       	call   801632 <fstat>
  8016d5:	89 c6                	mov    %eax,%esi
	close(fd);
  8016d7:	89 1c 24             	mov    %ebx,(%esp)
  8016da:	e8 fd fb ff ff       	call   8012dc <close>
	return r;
  8016df:	83 c4 10             	add    $0x10,%esp
  8016e2:	89 f3                	mov    %esi,%ebx
}
  8016e4:	89 d8                	mov    %ebx,%eax
  8016e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e9:	5b                   	pop    %ebx
  8016ea:	5e                   	pop    %esi
  8016eb:	5d                   	pop    %ebp
  8016ec:	c3                   	ret    

008016ed <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	56                   	push   %esi
  8016f1:	53                   	push   %ebx
  8016f2:	89 c6                	mov    %eax,%esi
  8016f4:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016f6:	83 3d 00 44 80 00 00 	cmpl   $0x0,0x804400
  8016fd:	74 27                	je     801726 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016ff:	6a 07                	push   $0x7
  801701:	68 00 50 80 00       	push   $0x805000
  801706:	56                   	push   %esi
  801707:	ff 35 00 44 80 00    	pushl  0x804400
  80170d:	e8 65 07 00 00       	call   801e77 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801712:	83 c4 0c             	add    $0xc,%esp
  801715:	6a 00                	push   $0x0
  801717:	53                   	push   %ebx
  801718:	6a 00                	push   $0x0
  80171a:	e8 d3 06 00 00       	call   801df2 <ipc_recv>
}
  80171f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801722:	5b                   	pop    %ebx
  801723:	5e                   	pop    %esi
  801724:	5d                   	pop    %ebp
  801725:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801726:	83 ec 0c             	sub    $0xc,%esp
  801729:	6a 01                	push   $0x1
  80172b:	e8 9f 07 00 00       	call   801ecf <ipc_find_env>
  801730:	a3 00 44 80 00       	mov    %eax,0x804400
  801735:	83 c4 10             	add    $0x10,%esp
  801738:	eb c5                	jmp    8016ff <fsipc+0x12>

0080173a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80173a:	f3 0f 1e fb          	endbr32 
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	8b 40 0c             	mov    0xc(%eax),%eax
  80174a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80174f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801752:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801757:	ba 00 00 00 00       	mov    $0x0,%edx
  80175c:	b8 02 00 00 00       	mov    $0x2,%eax
  801761:	e8 87 ff ff ff       	call   8016ed <fsipc>
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <devfile_flush>:
{
  801768:	f3 0f 1e fb          	endbr32 
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	8b 40 0c             	mov    0xc(%eax),%eax
  801778:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80177d:	ba 00 00 00 00       	mov    $0x0,%edx
  801782:	b8 06 00 00 00       	mov    $0x6,%eax
  801787:	e8 61 ff ff ff       	call   8016ed <fsipc>
}
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    

0080178e <devfile_stat>:
{
  80178e:	f3 0f 1e fb          	endbr32 
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
  801795:	53                   	push   %ebx
  801796:	83 ec 04             	sub    $0x4,%esp
  801799:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80179c:	8b 45 08             	mov    0x8(%ebp),%eax
  80179f:	8b 40 0c             	mov    0xc(%eax),%eax
  8017a2:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ac:	b8 05 00 00 00       	mov    $0x5,%eax
  8017b1:	e8 37 ff ff ff       	call   8016ed <fsipc>
  8017b6:	85 c0                	test   %eax,%eax
  8017b8:	78 2c                	js     8017e6 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017ba:	83 ec 08             	sub    $0x8,%esp
  8017bd:	68 00 50 80 00       	push   $0x805000
  8017c2:	53                   	push   %ebx
  8017c3:	e8 03 f3 ff ff       	call   800acb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017c8:	a1 80 50 80 00       	mov    0x805080,%eax
  8017cd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017d3:	a1 84 50 80 00       	mov    0x805084,%eax
  8017d8:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017de:	83 c4 10             	add    $0x10,%esp
  8017e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <devfile_write>:
{
  8017eb:	f3 0f 1e fb          	endbr32 
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	83 ec 0c             	sub    $0xc,%esp
  8017f5:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8017fb:	8b 52 0c             	mov    0xc(%edx),%edx
  8017fe:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801804:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801809:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80180e:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801811:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801816:	50                   	push   %eax
  801817:	ff 75 0c             	pushl  0xc(%ebp)
  80181a:	68 08 50 80 00       	push   $0x805008
  80181f:	e8 5d f4 ff ff       	call   800c81 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801824:	ba 00 00 00 00       	mov    $0x0,%edx
  801829:	b8 04 00 00 00       	mov    $0x4,%eax
  80182e:	e8 ba fe ff ff       	call   8016ed <fsipc>
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <devfile_read>:
{
  801835:	f3 0f 1e fb          	endbr32 
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	56                   	push   %esi
  80183d:	53                   	push   %ebx
  80183e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	8b 40 0c             	mov    0xc(%eax),%eax
  801847:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80184c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801852:	ba 00 00 00 00       	mov    $0x0,%edx
  801857:	b8 03 00 00 00       	mov    $0x3,%eax
  80185c:	e8 8c fe ff ff       	call   8016ed <fsipc>
  801861:	89 c3                	mov    %eax,%ebx
  801863:	85 c0                	test   %eax,%eax
  801865:	78 1f                	js     801886 <devfile_read+0x51>
	assert(r <= n);
  801867:	39 f0                	cmp    %esi,%eax
  801869:	77 24                	ja     80188f <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80186b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801870:	7f 33                	jg     8018a5 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801872:	83 ec 04             	sub    $0x4,%esp
  801875:	50                   	push   %eax
  801876:	68 00 50 80 00       	push   $0x805000
  80187b:	ff 75 0c             	pushl  0xc(%ebp)
  80187e:	e8 fe f3 ff ff       	call   800c81 <memmove>
	return r;
  801883:	83 c4 10             	add    $0x10,%esp
}
  801886:	89 d8                	mov    %ebx,%eax
  801888:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80188b:	5b                   	pop    %ebx
  80188c:	5e                   	pop    %esi
  80188d:	5d                   	pop    %ebp
  80188e:	c3                   	ret    
	assert(r <= n);
  80188f:	68 28 26 80 00       	push   $0x802628
  801894:	68 2f 26 80 00       	push   $0x80262f
  801899:	6a 7c                	push   $0x7c
  80189b:	68 44 26 80 00       	push   $0x802644
  8018a0:	e8 41 ea ff ff       	call   8002e6 <_panic>
	assert(r <= PGSIZE);
  8018a5:	68 4f 26 80 00       	push   $0x80264f
  8018aa:	68 2f 26 80 00       	push   $0x80262f
  8018af:	6a 7d                	push   $0x7d
  8018b1:	68 44 26 80 00       	push   $0x802644
  8018b6:	e8 2b ea ff ff       	call   8002e6 <_panic>

008018bb <open>:
{
  8018bb:	f3 0f 1e fb          	endbr32 
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	56                   	push   %esi
  8018c3:	53                   	push   %ebx
  8018c4:	83 ec 1c             	sub    $0x1c,%esp
  8018c7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018ca:	56                   	push   %esi
  8018cb:	e8 b8 f1 ff ff       	call   800a88 <strlen>
  8018d0:	83 c4 10             	add    $0x10,%esp
  8018d3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018d8:	7f 6c                	jg     801946 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8018da:	83 ec 0c             	sub    $0xc,%esp
  8018dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e0:	50                   	push   %eax
  8018e1:	e8 67 f8 ff ff       	call   80114d <fd_alloc>
  8018e6:	89 c3                	mov    %eax,%ebx
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	85 c0                	test   %eax,%eax
  8018ed:	78 3c                	js     80192b <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8018ef:	83 ec 08             	sub    $0x8,%esp
  8018f2:	56                   	push   %esi
  8018f3:	68 00 50 80 00       	push   $0x805000
  8018f8:	e8 ce f1 ff ff       	call   800acb <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801900:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801905:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801908:	b8 01 00 00 00       	mov    $0x1,%eax
  80190d:	e8 db fd ff ff       	call   8016ed <fsipc>
  801912:	89 c3                	mov    %eax,%ebx
  801914:	83 c4 10             	add    $0x10,%esp
  801917:	85 c0                	test   %eax,%eax
  801919:	78 19                	js     801934 <open+0x79>
	return fd2num(fd);
  80191b:	83 ec 0c             	sub    $0xc,%esp
  80191e:	ff 75 f4             	pushl  -0xc(%ebp)
  801921:	e8 f8 f7 ff ff       	call   80111e <fd2num>
  801926:	89 c3                	mov    %eax,%ebx
  801928:	83 c4 10             	add    $0x10,%esp
}
  80192b:	89 d8                	mov    %ebx,%eax
  80192d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801930:	5b                   	pop    %ebx
  801931:	5e                   	pop    %esi
  801932:	5d                   	pop    %ebp
  801933:	c3                   	ret    
		fd_close(fd, 0);
  801934:	83 ec 08             	sub    $0x8,%esp
  801937:	6a 00                	push   $0x0
  801939:	ff 75 f4             	pushl  -0xc(%ebp)
  80193c:	e8 10 f9 ff ff       	call   801251 <fd_close>
		return r;
  801941:	83 c4 10             	add    $0x10,%esp
  801944:	eb e5                	jmp    80192b <open+0x70>
		return -E_BAD_PATH;
  801946:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80194b:	eb de                	jmp    80192b <open+0x70>

0080194d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80194d:	f3 0f 1e fb          	endbr32 
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801957:	ba 00 00 00 00       	mov    $0x0,%edx
  80195c:	b8 08 00 00 00       	mov    $0x8,%eax
  801961:	e8 87 fd ff ff       	call   8016ed <fsipc>
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801968:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  80196c:	7f 01                	jg     80196f <writebuf+0x7>
  80196e:	c3                   	ret    
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
  801972:	53                   	push   %ebx
  801973:	83 ec 08             	sub    $0x8,%esp
  801976:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801978:	ff 70 04             	pushl  0x4(%eax)
  80197b:	8d 40 10             	lea    0x10(%eax),%eax
  80197e:	50                   	push   %eax
  80197f:	ff 33                	pushl  (%ebx)
  801981:	e8 76 fb ff ff       	call   8014fc <write>
		if (result > 0)
  801986:	83 c4 10             	add    $0x10,%esp
  801989:	85 c0                	test   %eax,%eax
  80198b:	7e 03                	jle    801990 <writebuf+0x28>
			b->result += result;
  80198d:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801990:	39 43 04             	cmp    %eax,0x4(%ebx)
  801993:	74 0d                	je     8019a2 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801995:	85 c0                	test   %eax,%eax
  801997:	ba 00 00 00 00       	mov    $0x0,%edx
  80199c:	0f 4f c2             	cmovg  %edx,%eax
  80199f:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8019a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <putch>:

static void
putch(int ch, void *thunk)
{
  8019a7:	f3 0f 1e fb          	endbr32 
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	53                   	push   %ebx
  8019af:	83 ec 04             	sub    $0x4,%esp
  8019b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8019b5:	8b 53 04             	mov    0x4(%ebx),%edx
  8019b8:	8d 42 01             	lea    0x1(%edx),%eax
  8019bb:	89 43 04             	mov    %eax,0x4(%ebx)
  8019be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019c1:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8019c5:	3d 00 01 00 00       	cmp    $0x100,%eax
  8019ca:	74 06                	je     8019d2 <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  8019cc:	83 c4 04             	add    $0x4,%esp
  8019cf:	5b                   	pop    %ebx
  8019d0:	5d                   	pop    %ebp
  8019d1:	c3                   	ret    
		writebuf(b);
  8019d2:	89 d8                	mov    %ebx,%eax
  8019d4:	e8 8f ff ff ff       	call   801968 <writebuf>
		b->idx = 0;
  8019d9:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8019e0:	eb ea                	jmp    8019cc <putch+0x25>

008019e2 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8019e2:	f3 0f 1e fb          	endbr32 
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8019f8:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8019ff:	00 00 00 
	b.result = 0;
  801a02:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a09:	00 00 00 
	b.error = 1;
  801a0c:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a13:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a16:	ff 75 10             	pushl  0x10(%ebp)
  801a19:	ff 75 0c             	pushl  0xc(%ebp)
  801a1c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a22:	50                   	push   %eax
  801a23:	68 a7 19 80 00       	push   $0x8019a7
  801a28:	e8 a3 ea ff ff       	call   8004d0 <vprintfmt>
	if (b.idx > 0)
  801a2d:	83 c4 10             	add    $0x10,%esp
  801a30:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a37:	7f 11                	jg     801a4a <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801a39:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a3f:	85 c0                	test   %eax,%eax
  801a41:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    
		writebuf(&b);
  801a4a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a50:	e8 13 ff ff ff       	call   801968 <writebuf>
  801a55:	eb e2                	jmp    801a39 <vfprintf+0x57>

00801a57 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a57:	f3 0f 1e fb          	endbr32 
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a61:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a64:	50                   	push   %eax
  801a65:	ff 75 0c             	pushl  0xc(%ebp)
  801a68:	ff 75 08             	pushl  0x8(%ebp)
  801a6b:	e8 72 ff ff ff       	call   8019e2 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <printf>:

int
printf(const char *fmt, ...)
{
  801a72:	f3 0f 1e fb          	endbr32 
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a7c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801a7f:	50                   	push   %eax
  801a80:	ff 75 08             	pushl  0x8(%ebp)
  801a83:	6a 01                	push   $0x1
  801a85:	e8 58 ff ff ff       	call   8019e2 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a8c:	f3 0f 1e fb          	endbr32 
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
  801a93:	56                   	push   %esi
  801a94:	53                   	push   %ebx
  801a95:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a98:	83 ec 0c             	sub    $0xc,%esp
  801a9b:	ff 75 08             	pushl  0x8(%ebp)
  801a9e:	e8 8f f6 ff ff       	call   801132 <fd2data>
  801aa3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801aa5:	83 c4 08             	add    $0x8,%esp
  801aa8:	68 5b 26 80 00       	push   $0x80265b
  801aad:	53                   	push   %ebx
  801aae:	e8 18 f0 ff ff       	call   800acb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ab3:	8b 46 04             	mov    0x4(%esi),%eax
  801ab6:	2b 06                	sub    (%esi),%eax
  801ab8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801abe:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ac5:	00 00 00 
	stat->st_dev = &devpipe;
  801ac8:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801acf:	30 80 00 
	return 0;
}
  801ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ada:	5b                   	pop    %ebx
  801adb:	5e                   	pop    %esi
  801adc:	5d                   	pop    %ebp
  801add:	c3                   	ret    

00801ade <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ade:	f3 0f 1e fb          	endbr32 
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	53                   	push   %ebx
  801ae6:	83 ec 0c             	sub    $0xc,%esp
  801ae9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801aec:	53                   	push   %ebx
  801aed:	6a 00                	push   $0x0
  801aef:	e8 a6 f4 ff ff       	call   800f9a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801af4:	89 1c 24             	mov    %ebx,(%esp)
  801af7:	e8 36 f6 ff ff       	call   801132 <fd2data>
  801afc:	83 c4 08             	add    $0x8,%esp
  801aff:	50                   	push   %eax
  801b00:	6a 00                	push   $0x0
  801b02:	e8 93 f4 ff ff       	call   800f9a <sys_page_unmap>
}
  801b07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <_pipeisclosed>:
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
  801b0f:	57                   	push   %edi
  801b10:	56                   	push   %esi
  801b11:	53                   	push   %ebx
  801b12:	83 ec 1c             	sub    $0x1c,%esp
  801b15:	89 c7                	mov    %eax,%edi
  801b17:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b19:	a1 04 44 80 00       	mov    0x804404,%eax
  801b1e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b21:	83 ec 0c             	sub    $0xc,%esp
  801b24:	57                   	push   %edi
  801b25:	e8 e2 03 00 00       	call   801f0c <pageref>
  801b2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b2d:	89 34 24             	mov    %esi,(%esp)
  801b30:	e8 d7 03 00 00       	call   801f0c <pageref>
		nn = thisenv->env_runs;
  801b35:	8b 15 04 44 80 00    	mov    0x804404,%edx
  801b3b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b3e:	83 c4 10             	add    $0x10,%esp
  801b41:	39 cb                	cmp    %ecx,%ebx
  801b43:	74 1b                	je     801b60 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b45:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b48:	75 cf                	jne    801b19 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b4a:	8b 42 58             	mov    0x58(%edx),%eax
  801b4d:	6a 01                	push   $0x1
  801b4f:	50                   	push   %eax
  801b50:	53                   	push   %ebx
  801b51:	68 62 26 80 00       	push   $0x802662
  801b56:	e8 72 e8 ff ff       	call   8003cd <cprintf>
  801b5b:	83 c4 10             	add    $0x10,%esp
  801b5e:	eb b9                	jmp    801b19 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b60:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b63:	0f 94 c0             	sete   %al
  801b66:	0f b6 c0             	movzbl %al,%eax
}
  801b69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b6c:	5b                   	pop    %ebx
  801b6d:	5e                   	pop    %esi
  801b6e:	5f                   	pop    %edi
  801b6f:	5d                   	pop    %ebp
  801b70:	c3                   	ret    

00801b71 <devpipe_write>:
{
  801b71:	f3 0f 1e fb          	endbr32 
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
  801b78:	57                   	push   %edi
  801b79:	56                   	push   %esi
  801b7a:	53                   	push   %ebx
  801b7b:	83 ec 28             	sub    $0x28,%esp
  801b7e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b81:	56                   	push   %esi
  801b82:	e8 ab f5 ff ff       	call   801132 <fd2data>
  801b87:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b89:	83 c4 10             	add    $0x10,%esp
  801b8c:	bf 00 00 00 00       	mov    $0x0,%edi
  801b91:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b94:	74 4f                	je     801be5 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b96:	8b 43 04             	mov    0x4(%ebx),%eax
  801b99:	8b 0b                	mov    (%ebx),%ecx
  801b9b:	8d 51 20             	lea    0x20(%ecx),%edx
  801b9e:	39 d0                	cmp    %edx,%eax
  801ba0:	72 14                	jb     801bb6 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801ba2:	89 da                	mov    %ebx,%edx
  801ba4:	89 f0                	mov    %esi,%eax
  801ba6:	e8 61 ff ff ff       	call   801b0c <_pipeisclosed>
  801bab:	85 c0                	test   %eax,%eax
  801bad:	75 3b                	jne    801bea <devpipe_write+0x79>
			sys_yield();
  801baf:	e8 36 f3 ff ff       	call   800eea <sys_yield>
  801bb4:	eb e0                	jmp    801b96 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bb9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801bbd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801bc0:	89 c2                	mov    %eax,%edx
  801bc2:	c1 fa 1f             	sar    $0x1f,%edx
  801bc5:	89 d1                	mov    %edx,%ecx
  801bc7:	c1 e9 1b             	shr    $0x1b,%ecx
  801bca:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801bcd:	83 e2 1f             	and    $0x1f,%edx
  801bd0:	29 ca                	sub    %ecx,%edx
  801bd2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801bd6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801bda:	83 c0 01             	add    $0x1,%eax
  801bdd:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801be0:	83 c7 01             	add    $0x1,%edi
  801be3:	eb ac                	jmp    801b91 <devpipe_write+0x20>
	return i;
  801be5:	8b 45 10             	mov    0x10(%ebp),%eax
  801be8:	eb 05                	jmp    801bef <devpipe_write+0x7e>
				return 0;
  801bea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bf2:	5b                   	pop    %ebx
  801bf3:	5e                   	pop    %esi
  801bf4:	5f                   	pop    %edi
  801bf5:	5d                   	pop    %ebp
  801bf6:	c3                   	ret    

00801bf7 <devpipe_read>:
{
  801bf7:	f3 0f 1e fb          	endbr32 
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
  801bfe:	57                   	push   %edi
  801bff:	56                   	push   %esi
  801c00:	53                   	push   %ebx
  801c01:	83 ec 18             	sub    $0x18,%esp
  801c04:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c07:	57                   	push   %edi
  801c08:	e8 25 f5 ff ff       	call   801132 <fd2data>
  801c0d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c0f:	83 c4 10             	add    $0x10,%esp
  801c12:	be 00 00 00 00       	mov    $0x0,%esi
  801c17:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c1a:	75 14                	jne    801c30 <devpipe_read+0x39>
	return i;
  801c1c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c1f:	eb 02                	jmp    801c23 <devpipe_read+0x2c>
				return i;
  801c21:	89 f0                	mov    %esi,%eax
}
  801c23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c26:	5b                   	pop    %ebx
  801c27:	5e                   	pop    %esi
  801c28:	5f                   	pop    %edi
  801c29:	5d                   	pop    %ebp
  801c2a:	c3                   	ret    
			sys_yield();
  801c2b:	e8 ba f2 ff ff       	call   800eea <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c30:	8b 03                	mov    (%ebx),%eax
  801c32:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c35:	75 18                	jne    801c4f <devpipe_read+0x58>
			if (i > 0)
  801c37:	85 f6                	test   %esi,%esi
  801c39:	75 e6                	jne    801c21 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801c3b:	89 da                	mov    %ebx,%edx
  801c3d:	89 f8                	mov    %edi,%eax
  801c3f:	e8 c8 fe ff ff       	call   801b0c <_pipeisclosed>
  801c44:	85 c0                	test   %eax,%eax
  801c46:	74 e3                	je     801c2b <devpipe_read+0x34>
				return 0;
  801c48:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4d:	eb d4                	jmp    801c23 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c4f:	99                   	cltd   
  801c50:	c1 ea 1b             	shr    $0x1b,%edx
  801c53:	01 d0                	add    %edx,%eax
  801c55:	83 e0 1f             	and    $0x1f,%eax
  801c58:	29 d0                	sub    %edx,%eax
  801c5a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c62:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c65:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c68:	83 c6 01             	add    $0x1,%esi
  801c6b:	eb aa                	jmp    801c17 <devpipe_read+0x20>

00801c6d <pipe>:
{
  801c6d:	f3 0f 1e fb          	endbr32 
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
  801c74:	56                   	push   %esi
  801c75:	53                   	push   %ebx
  801c76:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c79:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c7c:	50                   	push   %eax
  801c7d:	e8 cb f4 ff ff       	call   80114d <fd_alloc>
  801c82:	89 c3                	mov    %eax,%ebx
  801c84:	83 c4 10             	add    $0x10,%esp
  801c87:	85 c0                	test   %eax,%eax
  801c89:	0f 88 23 01 00 00    	js     801db2 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c8f:	83 ec 04             	sub    $0x4,%esp
  801c92:	68 07 04 00 00       	push   $0x407
  801c97:	ff 75 f4             	pushl  -0xc(%ebp)
  801c9a:	6a 00                	push   $0x0
  801c9c:	e8 6c f2 ff ff       	call   800f0d <sys_page_alloc>
  801ca1:	89 c3                	mov    %eax,%ebx
  801ca3:	83 c4 10             	add    $0x10,%esp
  801ca6:	85 c0                	test   %eax,%eax
  801ca8:	0f 88 04 01 00 00    	js     801db2 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801cae:	83 ec 0c             	sub    $0xc,%esp
  801cb1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cb4:	50                   	push   %eax
  801cb5:	e8 93 f4 ff ff       	call   80114d <fd_alloc>
  801cba:	89 c3                	mov    %eax,%ebx
  801cbc:	83 c4 10             	add    $0x10,%esp
  801cbf:	85 c0                	test   %eax,%eax
  801cc1:	0f 88 db 00 00 00    	js     801da2 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cc7:	83 ec 04             	sub    $0x4,%esp
  801cca:	68 07 04 00 00       	push   $0x407
  801ccf:	ff 75 f0             	pushl  -0x10(%ebp)
  801cd2:	6a 00                	push   $0x0
  801cd4:	e8 34 f2 ff ff       	call   800f0d <sys_page_alloc>
  801cd9:	89 c3                	mov    %eax,%ebx
  801cdb:	83 c4 10             	add    $0x10,%esp
  801cde:	85 c0                	test   %eax,%eax
  801ce0:	0f 88 bc 00 00 00    	js     801da2 <pipe+0x135>
	va = fd2data(fd0);
  801ce6:	83 ec 0c             	sub    $0xc,%esp
  801ce9:	ff 75 f4             	pushl  -0xc(%ebp)
  801cec:	e8 41 f4 ff ff       	call   801132 <fd2data>
  801cf1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cf3:	83 c4 0c             	add    $0xc,%esp
  801cf6:	68 07 04 00 00       	push   $0x407
  801cfb:	50                   	push   %eax
  801cfc:	6a 00                	push   $0x0
  801cfe:	e8 0a f2 ff ff       	call   800f0d <sys_page_alloc>
  801d03:	89 c3                	mov    %eax,%ebx
  801d05:	83 c4 10             	add    $0x10,%esp
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	0f 88 82 00 00 00    	js     801d92 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d10:	83 ec 0c             	sub    $0xc,%esp
  801d13:	ff 75 f0             	pushl  -0x10(%ebp)
  801d16:	e8 17 f4 ff ff       	call   801132 <fd2data>
  801d1b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d22:	50                   	push   %eax
  801d23:	6a 00                	push   $0x0
  801d25:	56                   	push   %esi
  801d26:	6a 00                	push   $0x0
  801d28:	e8 27 f2 ff ff       	call   800f54 <sys_page_map>
  801d2d:	89 c3                	mov    %eax,%ebx
  801d2f:	83 c4 20             	add    $0x20,%esp
  801d32:	85 c0                	test   %eax,%eax
  801d34:	78 4e                	js     801d84 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801d36:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801d3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d3e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d43:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d4d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d52:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d59:	83 ec 0c             	sub    $0xc,%esp
  801d5c:	ff 75 f4             	pushl  -0xc(%ebp)
  801d5f:	e8 ba f3 ff ff       	call   80111e <fd2num>
  801d64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d67:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d69:	83 c4 04             	add    $0x4,%esp
  801d6c:	ff 75 f0             	pushl  -0x10(%ebp)
  801d6f:	e8 aa f3 ff ff       	call   80111e <fd2num>
  801d74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d77:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d7a:	83 c4 10             	add    $0x10,%esp
  801d7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d82:	eb 2e                	jmp    801db2 <pipe+0x145>
	sys_page_unmap(0, va);
  801d84:	83 ec 08             	sub    $0x8,%esp
  801d87:	56                   	push   %esi
  801d88:	6a 00                	push   $0x0
  801d8a:	e8 0b f2 ff ff       	call   800f9a <sys_page_unmap>
  801d8f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d92:	83 ec 08             	sub    $0x8,%esp
  801d95:	ff 75 f0             	pushl  -0x10(%ebp)
  801d98:	6a 00                	push   $0x0
  801d9a:	e8 fb f1 ff ff       	call   800f9a <sys_page_unmap>
  801d9f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801da2:	83 ec 08             	sub    $0x8,%esp
  801da5:	ff 75 f4             	pushl  -0xc(%ebp)
  801da8:	6a 00                	push   $0x0
  801daa:	e8 eb f1 ff ff       	call   800f9a <sys_page_unmap>
  801daf:	83 c4 10             	add    $0x10,%esp
}
  801db2:	89 d8                	mov    %ebx,%eax
  801db4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801db7:	5b                   	pop    %ebx
  801db8:	5e                   	pop    %esi
  801db9:	5d                   	pop    %ebp
  801dba:	c3                   	ret    

00801dbb <pipeisclosed>:
{
  801dbb:	f3 0f 1e fb          	endbr32 
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dc8:	50                   	push   %eax
  801dc9:	ff 75 08             	pushl  0x8(%ebp)
  801dcc:	e8 d2 f3 ff ff       	call   8011a3 <fd_lookup>
  801dd1:	83 c4 10             	add    $0x10,%esp
  801dd4:	85 c0                	test   %eax,%eax
  801dd6:	78 18                	js     801df0 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801dd8:	83 ec 0c             	sub    $0xc,%esp
  801ddb:	ff 75 f4             	pushl  -0xc(%ebp)
  801dde:	e8 4f f3 ff ff       	call   801132 <fd2data>
  801de3:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de8:	e8 1f fd ff ff       	call   801b0c <_pipeisclosed>
  801ded:	83 c4 10             	add    $0x10,%esp
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801df2:	f3 0f 1e fb          	endbr32 
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
  801df9:	56                   	push   %esi
  801dfa:	53                   	push   %ebx
  801dfb:	8b 75 08             	mov    0x8(%ebp),%esi
  801dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e01:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801e04:	85 c0                	test   %eax,%eax
  801e06:	74 3d                	je     801e45 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801e08:	83 ec 0c             	sub    $0xc,%esp
  801e0b:	50                   	push   %eax
  801e0c:	e8 c8 f2 ff ff       	call   8010d9 <sys_ipc_recv>
  801e11:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801e14:	85 f6                	test   %esi,%esi
  801e16:	74 0b                	je     801e23 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801e18:	8b 15 04 44 80 00    	mov    0x804404,%edx
  801e1e:	8b 52 74             	mov    0x74(%edx),%edx
  801e21:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801e23:	85 db                	test   %ebx,%ebx
  801e25:	74 0b                	je     801e32 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801e27:	8b 15 04 44 80 00    	mov    0x804404,%edx
  801e2d:	8b 52 78             	mov    0x78(%edx),%edx
  801e30:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801e32:	85 c0                	test   %eax,%eax
  801e34:	78 21                	js     801e57 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801e36:	a1 04 44 80 00       	mov    0x804404,%eax
  801e3b:	8b 40 70             	mov    0x70(%eax),%eax
}
  801e3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e41:	5b                   	pop    %ebx
  801e42:	5e                   	pop    %esi
  801e43:	5d                   	pop    %ebp
  801e44:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801e45:	83 ec 0c             	sub    $0xc,%esp
  801e48:	68 00 00 c0 ee       	push   $0xeec00000
  801e4d:	e8 87 f2 ff ff       	call   8010d9 <sys_ipc_recv>
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	eb bd                	jmp    801e14 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801e57:	85 f6                	test   %esi,%esi
  801e59:	74 10                	je     801e6b <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801e5b:	85 db                	test   %ebx,%ebx
  801e5d:	75 df                	jne    801e3e <ipc_recv+0x4c>
  801e5f:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801e66:	00 00 00 
  801e69:	eb d3                	jmp    801e3e <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801e6b:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801e72:	00 00 00 
  801e75:	eb e4                	jmp    801e5b <ipc_recv+0x69>

00801e77 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e77:	f3 0f 1e fb          	endbr32 
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	57                   	push   %edi
  801e7f:	56                   	push   %esi
  801e80:	53                   	push   %ebx
  801e81:	83 ec 0c             	sub    $0xc,%esp
  801e84:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e87:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801e8d:	85 db                	test   %ebx,%ebx
  801e8f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801e94:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801e97:	ff 75 14             	pushl  0x14(%ebp)
  801e9a:	53                   	push   %ebx
  801e9b:	56                   	push   %esi
  801e9c:	57                   	push   %edi
  801e9d:	e8 10 f2 ff ff       	call   8010b2 <sys_ipc_try_send>
  801ea2:	83 c4 10             	add    $0x10,%esp
  801ea5:	85 c0                	test   %eax,%eax
  801ea7:	79 1e                	jns    801ec7 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801ea9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801eac:	75 07                	jne    801eb5 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801eae:	e8 37 f0 ff ff       	call   800eea <sys_yield>
  801eb3:	eb e2                	jmp    801e97 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801eb5:	50                   	push   %eax
  801eb6:	68 7a 26 80 00       	push   $0x80267a
  801ebb:	6a 59                	push   $0x59
  801ebd:	68 95 26 80 00       	push   $0x802695
  801ec2:	e8 1f e4 ff ff       	call   8002e6 <_panic>
	}
}
  801ec7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eca:	5b                   	pop    %ebx
  801ecb:	5e                   	pop    %esi
  801ecc:	5f                   	pop    %edi
  801ecd:	5d                   	pop    %ebp
  801ece:	c3                   	ret    

00801ecf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801ecf:	f3 0f 1e fb          	endbr32 
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
  801ed6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801ede:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801ee1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801ee7:	8b 52 50             	mov    0x50(%edx),%edx
  801eea:	39 ca                	cmp    %ecx,%edx
  801eec:	74 11                	je     801eff <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801eee:	83 c0 01             	add    $0x1,%eax
  801ef1:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ef6:	75 e6                	jne    801ede <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801ef8:	b8 00 00 00 00       	mov    $0x0,%eax
  801efd:	eb 0b                	jmp    801f0a <ipc_find_env+0x3b>
			return envs[i].env_id;
  801eff:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801f02:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801f07:	8b 40 48             	mov    0x48(%eax),%eax
}
  801f0a:	5d                   	pop    %ebp
  801f0b:	c3                   	ret    

00801f0c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f0c:	f3 0f 1e fb          	endbr32 
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f16:	89 c2                	mov    %eax,%edx
  801f18:	c1 ea 16             	shr    $0x16,%edx
  801f1b:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801f22:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801f27:	f6 c1 01             	test   $0x1,%cl
  801f2a:	74 1c                	je     801f48 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801f2c:	c1 e8 0c             	shr    $0xc,%eax
  801f2f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801f36:	a8 01                	test   $0x1,%al
  801f38:	74 0e                	je     801f48 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f3a:	c1 e8 0c             	shr    $0xc,%eax
  801f3d:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801f44:	ef 
  801f45:	0f b7 d2             	movzwl %dx,%edx
}
  801f48:	89 d0                	mov    %edx,%eax
  801f4a:	5d                   	pop    %ebp
  801f4b:	c3                   	ret    
  801f4c:	66 90                	xchg   %ax,%ax
  801f4e:	66 90                	xchg   %ax,%ax

00801f50 <__udivdi3>:
  801f50:	f3 0f 1e fb          	endbr32 
  801f54:	55                   	push   %ebp
  801f55:	57                   	push   %edi
  801f56:	56                   	push   %esi
  801f57:	53                   	push   %ebx
  801f58:	83 ec 1c             	sub    $0x1c,%esp
  801f5b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801f5f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801f63:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f67:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801f6b:	85 d2                	test   %edx,%edx
  801f6d:	75 19                	jne    801f88 <__udivdi3+0x38>
  801f6f:	39 f3                	cmp    %esi,%ebx
  801f71:	76 4d                	jbe    801fc0 <__udivdi3+0x70>
  801f73:	31 ff                	xor    %edi,%edi
  801f75:	89 e8                	mov    %ebp,%eax
  801f77:	89 f2                	mov    %esi,%edx
  801f79:	f7 f3                	div    %ebx
  801f7b:	89 fa                	mov    %edi,%edx
  801f7d:	83 c4 1c             	add    $0x1c,%esp
  801f80:	5b                   	pop    %ebx
  801f81:	5e                   	pop    %esi
  801f82:	5f                   	pop    %edi
  801f83:	5d                   	pop    %ebp
  801f84:	c3                   	ret    
  801f85:	8d 76 00             	lea    0x0(%esi),%esi
  801f88:	39 f2                	cmp    %esi,%edx
  801f8a:	76 14                	jbe    801fa0 <__udivdi3+0x50>
  801f8c:	31 ff                	xor    %edi,%edi
  801f8e:	31 c0                	xor    %eax,%eax
  801f90:	89 fa                	mov    %edi,%edx
  801f92:	83 c4 1c             	add    $0x1c,%esp
  801f95:	5b                   	pop    %ebx
  801f96:	5e                   	pop    %esi
  801f97:	5f                   	pop    %edi
  801f98:	5d                   	pop    %ebp
  801f99:	c3                   	ret    
  801f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801fa0:	0f bd fa             	bsr    %edx,%edi
  801fa3:	83 f7 1f             	xor    $0x1f,%edi
  801fa6:	75 48                	jne    801ff0 <__udivdi3+0xa0>
  801fa8:	39 f2                	cmp    %esi,%edx
  801faa:	72 06                	jb     801fb2 <__udivdi3+0x62>
  801fac:	31 c0                	xor    %eax,%eax
  801fae:	39 eb                	cmp    %ebp,%ebx
  801fb0:	77 de                	ja     801f90 <__udivdi3+0x40>
  801fb2:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb7:	eb d7                	jmp    801f90 <__udivdi3+0x40>
  801fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fc0:	89 d9                	mov    %ebx,%ecx
  801fc2:	85 db                	test   %ebx,%ebx
  801fc4:	75 0b                	jne    801fd1 <__udivdi3+0x81>
  801fc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801fcb:	31 d2                	xor    %edx,%edx
  801fcd:	f7 f3                	div    %ebx
  801fcf:	89 c1                	mov    %eax,%ecx
  801fd1:	31 d2                	xor    %edx,%edx
  801fd3:	89 f0                	mov    %esi,%eax
  801fd5:	f7 f1                	div    %ecx
  801fd7:	89 c6                	mov    %eax,%esi
  801fd9:	89 e8                	mov    %ebp,%eax
  801fdb:	89 f7                	mov    %esi,%edi
  801fdd:	f7 f1                	div    %ecx
  801fdf:	89 fa                	mov    %edi,%edx
  801fe1:	83 c4 1c             	add    $0x1c,%esp
  801fe4:	5b                   	pop    %ebx
  801fe5:	5e                   	pop    %esi
  801fe6:	5f                   	pop    %edi
  801fe7:	5d                   	pop    %ebp
  801fe8:	c3                   	ret    
  801fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ff0:	89 f9                	mov    %edi,%ecx
  801ff2:	b8 20 00 00 00       	mov    $0x20,%eax
  801ff7:	29 f8                	sub    %edi,%eax
  801ff9:	d3 e2                	shl    %cl,%edx
  801ffb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fff:	89 c1                	mov    %eax,%ecx
  802001:	89 da                	mov    %ebx,%edx
  802003:	d3 ea                	shr    %cl,%edx
  802005:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802009:	09 d1                	or     %edx,%ecx
  80200b:	89 f2                	mov    %esi,%edx
  80200d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802011:	89 f9                	mov    %edi,%ecx
  802013:	d3 e3                	shl    %cl,%ebx
  802015:	89 c1                	mov    %eax,%ecx
  802017:	d3 ea                	shr    %cl,%edx
  802019:	89 f9                	mov    %edi,%ecx
  80201b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80201f:	89 eb                	mov    %ebp,%ebx
  802021:	d3 e6                	shl    %cl,%esi
  802023:	89 c1                	mov    %eax,%ecx
  802025:	d3 eb                	shr    %cl,%ebx
  802027:	09 de                	or     %ebx,%esi
  802029:	89 f0                	mov    %esi,%eax
  80202b:	f7 74 24 08          	divl   0x8(%esp)
  80202f:	89 d6                	mov    %edx,%esi
  802031:	89 c3                	mov    %eax,%ebx
  802033:	f7 64 24 0c          	mull   0xc(%esp)
  802037:	39 d6                	cmp    %edx,%esi
  802039:	72 15                	jb     802050 <__udivdi3+0x100>
  80203b:	89 f9                	mov    %edi,%ecx
  80203d:	d3 e5                	shl    %cl,%ebp
  80203f:	39 c5                	cmp    %eax,%ebp
  802041:	73 04                	jae    802047 <__udivdi3+0xf7>
  802043:	39 d6                	cmp    %edx,%esi
  802045:	74 09                	je     802050 <__udivdi3+0x100>
  802047:	89 d8                	mov    %ebx,%eax
  802049:	31 ff                	xor    %edi,%edi
  80204b:	e9 40 ff ff ff       	jmp    801f90 <__udivdi3+0x40>
  802050:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802053:	31 ff                	xor    %edi,%edi
  802055:	e9 36 ff ff ff       	jmp    801f90 <__udivdi3+0x40>
  80205a:	66 90                	xchg   %ax,%ax
  80205c:	66 90                	xchg   %ax,%ax
  80205e:	66 90                	xchg   %ax,%ax

00802060 <__umoddi3>:
  802060:	f3 0f 1e fb          	endbr32 
  802064:	55                   	push   %ebp
  802065:	57                   	push   %edi
  802066:	56                   	push   %esi
  802067:	53                   	push   %ebx
  802068:	83 ec 1c             	sub    $0x1c,%esp
  80206b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80206f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802073:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802077:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80207b:	85 c0                	test   %eax,%eax
  80207d:	75 19                	jne    802098 <__umoddi3+0x38>
  80207f:	39 df                	cmp    %ebx,%edi
  802081:	76 5d                	jbe    8020e0 <__umoddi3+0x80>
  802083:	89 f0                	mov    %esi,%eax
  802085:	89 da                	mov    %ebx,%edx
  802087:	f7 f7                	div    %edi
  802089:	89 d0                	mov    %edx,%eax
  80208b:	31 d2                	xor    %edx,%edx
  80208d:	83 c4 1c             	add    $0x1c,%esp
  802090:	5b                   	pop    %ebx
  802091:	5e                   	pop    %esi
  802092:	5f                   	pop    %edi
  802093:	5d                   	pop    %ebp
  802094:	c3                   	ret    
  802095:	8d 76 00             	lea    0x0(%esi),%esi
  802098:	89 f2                	mov    %esi,%edx
  80209a:	39 d8                	cmp    %ebx,%eax
  80209c:	76 12                	jbe    8020b0 <__umoddi3+0x50>
  80209e:	89 f0                	mov    %esi,%eax
  8020a0:	89 da                	mov    %ebx,%edx
  8020a2:	83 c4 1c             	add    $0x1c,%esp
  8020a5:	5b                   	pop    %ebx
  8020a6:	5e                   	pop    %esi
  8020a7:	5f                   	pop    %edi
  8020a8:	5d                   	pop    %ebp
  8020a9:	c3                   	ret    
  8020aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8020b0:	0f bd e8             	bsr    %eax,%ebp
  8020b3:	83 f5 1f             	xor    $0x1f,%ebp
  8020b6:	75 50                	jne    802108 <__umoddi3+0xa8>
  8020b8:	39 d8                	cmp    %ebx,%eax
  8020ba:	0f 82 e0 00 00 00    	jb     8021a0 <__umoddi3+0x140>
  8020c0:	89 d9                	mov    %ebx,%ecx
  8020c2:	39 f7                	cmp    %esi,%edi
  8020c4:	0f 86 d6 00 00 00    	jbe    8021a0 <__umoddi3+0x140>
  8020ca:	89 d0                	mov    %edx,%eax
  8020cc:	89 ca                	mov    %ecx,%edx
  8020ce:	83 c4 1c             	add    $0x1c,%esp
  8020d1:	5b                   	pop    %ebx
  8020d2:	5e                   	pop    %esi
  8020d3:	5f                   	pop    %edi
  8020d4:	5d                   	pop    %ebp
  8020d5:	c3                   	ret    
  8020d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020dd:	8d 76 00             	lea    0x0(%esi),%esi
  8020e0:	89 fd                	mov    %edi,%ebp
  8020e2:	85 ff                	test   %edi,%edi
  8020e4:	75 0b                	jne    8020f1 <__umoddi3+0x91>
  8020e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020eb:	31 d2                	xor    %edx,%edx
  8020ed:	f7 f7                	div    %edi
  8020ef:	89 c5                	mov    %eax,%ebp
  8020f1:	89 d8                	mov    %ebx,%eax
  8020f3:	31 d2                	xor    %edx,%edx
  8020f5:	f7 f5                	div    %ebp
  8020f7:	89 f0                	mov    %esi,%eax
  8020f9:	f7 f5                	div    %ebp
  8020fb:	89 d0                	mov    %edx,%eax
  8020fd:	31 d2                	xor    %edx,%edx
  8020ff:	eb 8c                	jmp    80208d <__umoddi3+0x2d>
  802101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802108:	89 e9                	mov    %ebp,%ecx
  80210a:	ba 20 00 00 00       	mov    $0x20,%edx
  80210f:	29 ea                	sub    %ebp,%edx
  802111:	d3 e0                	shl    %cl,%eax
  802113:	89 44 24 08          	mov    %eax,0x8(%esp)
  802117:	89 d1                	mov    %edx,%ecx
  802119:	89 f8                	mov    %edi,%eax
  80211b:	d3 e8                	shr    %cl,%eax
  80211d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802121:	89 54 24 04          	mov    %edx,0x4(%esp)
  802125:	8b 54 24 04          	mov    0x4(%esp),%edx
  802129:	09 c1                	or     %eax,%ecx
  80212b:	89 d8                	mov    %ebx,%eax
  80212d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802131:	89 e9                	mov    %ebp,%ecx
  802133:	d3 e7                	shl    %cl,%edi
  802135:	89 d1                	mov    %edx,%ecx
  802137:	d3 e8                	shr    %cl,%eax
  802139:	89 e9                	mov    %ebp,%ecx
  80213b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80213f:	d3 e3                	shl    %cl,%ebx
  802141:	89 c7                	mov    %eax,%edi
  802143:	89 d1                	mov    %edx,%ecx
  802145:	89 f0                	mov    %esi,%eax
  802147:	d3 e8                	shr    %cl,%eax
  802149:	89 e9                	mov    %ebp,%ecx
  80214b:	89 fa                	mov    %edi,%edx
  80214d:	d3 e6                	shl    %cl,%esi
  80214f:	09 d8                	or     %ebx,%eax
  802151:	f7 74 24 08          	divl   0x8(%esp)
  802155:	89 d1                	mov    %edx,%ecx
  802157:	89 f3                	mov    %esi,%ebx
  802159:	f7 64 24 0c          	mull   0xc(%esp)
  80215d:	89 c6                	mov    %eax,%esi
  80215f:	89 d7                	mov    %edx,%edi
  802161:	39 d1                	cmp    %edx,%ecx
  802163:	72 06                	jb     80216b <__umoddi3+0x10b>
  802165:	75 10                	jne    802177 <__umoddi3+0x117>
  802167:	39 c3                	cmp    %eax,%ebx
  802169:	73 0c                	jae    802177 <__umoddi3+0x117>
  80216b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80216f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802173:	89 d7                	mov    %edx,%edi
  802175:	89 c6                	mov    %eax,%esi
  802177:	89 ca                	mov    %ecx,%edx
  802179:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80217e:	29 f3                	sub    %esi,%ebx
  802180:	19 fa                	sbb    %edi,%edx
  802182:	89 d0                	mov    %edx,%eax
  802184:	d3 e0                	shl    %cl,%eax
  802186:	89 e9                	mov    %ebp,%ecx
  802188:	d3 eb                	shr    %cl,%ebx
  80218a:	d3 ea                	shr    %cl,%edx
  80218c:	09 d8                	or     %ebx,%eax
  80218e:	83 c4 1c             	add    $0x1c,%esp
  802191:	5b                   	pop    %ebx
  802192:	5e                   	pop    %esi
  802193:	5f                   	pop    %edi
  802194:	5d                   	pop    %ebp
  802195:	c3                   	ret    
  802196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80219d:	8d 76 00             	lea    0x0(%esi),%esi
  8021a0:	29 fe                	sub    %edi,%esi
  8021a2:	19 c3                	sbb    %eax,%ebx
  8021a4:	89 f2                	mov    %esi,%edx
  8021a6:	89 d9                	mov    %ebx,%ecx
  8021a8:	e9 1d ff ff ff       	jmp    8020ca <__umoddi3+0x6a>
