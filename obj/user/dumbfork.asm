
obj/user/dumbfork.debug:     file format elf32-i386


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
  80002c:	e8 ad 01 00 00       	call   8001de <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <duppage>:
	}
}

void
duppage(envid_t dstenv, void *addr)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	8b 75 08             	mov    0x8(%ebp),%esi
  80003f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  800042:	83 ec 04             	sub    $0x4,%esp
  800045:	6a 07                	push   $0x7
  800047:	53                   	push   %ebx
  800048:	56                   	push   %esi
  800049:	e8 2b 0d 00 00       	call   800d79 <sys_page_alloc>
  80004e:	83 c4 10             	add    $0x10,%esp
  800051:	85 c0                	test   %eax,%eax
  800053:	78 4a                	js     80009f <duppage+0x6c>
		panic("sys_page_alloc: %e", r);
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800055:	83 ec 0c             	sub    $0xc,%esp
  800058:	6a 07                	push   $0x7
  80005a:	68 00 00 40 00       	push   $0x400000
  80005f:	6a 00                	push   $0x0
  800061:	53                   	push   %ebx
  800062:	56                   	push   %esi
  800063:	e8 58 0d 00 00       	call   800dc0 <sys_page_map>
  800068:	83 c4 20             	add    $0x20,%esp
  80006b:	85 c0                	test   %eax,%eax
  80006d:	78 42                	js     8000b1 <duppage+0x7e>
		panic("sys_page_map: %e", r);
	memmove(UTEMP, addr, PGSIZE);
  80006f:	83 ec 04             	sub    $0x4,%esp
  800072:	68 00 10 00 00       	push   $0x1000
  800077:	53                   	push   %ebx
  800078:	68 00 00 40 00       	push   $0x400000
  80007d:	e8 6b 0a 00 00       	call   800aed <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  800082:	83 c4 08             	add    $0x8,%esp
  800085:	68 00 00 40 00       	push   $0x400000
  80008a:	6a 00                	push   $0x0
  80008c:	e8 75 0d 00 00       	call   800e06 <sys_page_unmap>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	78 2b                	js     8000c3 <duppage+0x90>
		panic("sys_page_unmap: %e", r);
}
  800098:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80009b:	5b                   	pop    %ebx
  80009c:	5e                   	pop    %esi
  80009d:	5d                   	pop    %ebp
  80009e:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80009f:	50                   	push   %eax
  8000a0:	68 a0 20 80 00       	push   $0x8020a0
  8000a5:	6a 20                	push   $0x20
  8000a7:	68 b3 20 80 00       	push   $0x8020b3
  8000ac:	e8 95 01 00 00       	call   800246 <_panic>
		panic("sys_page_map: %e", r);
  8000b1:	50                   	push   %eax
  8000b2:	68 c3 20 80 00       	push   $0x8020c3
  8000b7:	6a 22                	push   $0x22
  8000b9:	68 b3 20 80 00       	push   $0x8020b3
  8000be:	e8 83 01 00 00       	call   800246 <_panic>
		panic("sys_page_unmap: %e", r);
  8000c3:	50                   	push   %eax
  8000c4:	68 d4 20 80 00       	push   $0x8020d4
  8000c9:	6a 25                	push   $0x25
  8000cb:	68 b3 20 80 00       	push   $0x8020b3
  8000d0:	e8 71 01 00 00       	call   800246 <_panic>

008000d5 <dumbfork>:

envid_t
dumbfork(void)
{
  8000d5:	f3 0f 1e fb          	endbr32 
  8000d9:	55                   	push   %ebp
  8000da:	89 e5                	mov    %esp,%ebp
  8000dc:	56                   	push   %esi
  8000dd:	53                   	push   %ebx
  8000de:	83 ec 10             	sub    $0x10,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8000e1:	b8 07 00 00 00       	mov    $0x7,%eax
  8000e6:	cd 30                	int    $0x30
  8000e8:	89 c3                	mov    %eax,%ebx
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  8000ea:	85 c0                	test   %eax,%eax
  8000ec:	78 0d                	js     8000fb <dumbfork+0x26>
  8000ee:	89 c6                	mov    %eax,%esi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  8000f0:	74 1b                	je     80010d <dumbfork+0x38>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  8000f2:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8000f9:	eb 3f                	jmp    80013a <dumbfork+0x65>
		panic("sys_exofork: %e", envid);
  8000fb:	50                   	push   %eax
  8000fc:	68 e7 20 80 00       	push   $0x8020e7
  800101:	6a 37                	push   $0x37
  800103:	68 b3 20 80 00       	push   $0x8020b3
  800108:	e8 39 01 00 00       	call   800246 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  80010d:	e8 21 0c 00 00       	call   800d33 <sys_getenvid>
  800112:	25 ff 03 00 00       	and    $0x3ff,%eax
  800117:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80011a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011f:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800124:	eb 43                	jmp    800169 <dumbfork+0x94>
		duppage(envid, addr);
  800126:	83 ec 08             	sub    $0x8,%esp
  800129:	52                   	push   %edx
  80012a:	56                   	push   %esi
  80012b:	e8 03 ff ff ff       	call   800033 <duppage>
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  800130:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  800137:	83 c4 10             	add    $0x10,%esp
  80013a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80013d:	81 fa 00 60 80 00    	cmp    $0x806000,%edx
  800143:	72 e1                	jb     800126 <dumbfork+0x51>

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80014b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800150:	50                   	push   %eax
  800151:	53                   	push   %ebx
  800152:	e8 dc fe ff ff       	call   800033 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  800157:	83 c4 08             	add    $0x8,%esp
  80015a:	6a 02                	push   $0x2
  80015c:	53                   	push   %ebx
  80015d:	e8 ea 0c 00 00       	call   800e4c <sys_env_set_status>
  800162:	83 c4 10             	add    $0x10,%esp
  800165:	85 c0                	test   %eax,%eax
  800167:	78 09                	js     800172 <dumbfork+0x9d>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  800169:	89 d8                	mov    %ebx,%eax
  80016b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80016e:	5b                   	pop    %ebx
  80016f:	5e                   	pop    %esi
  800170:	5d                   	pop    %ebp
  800171:	c3                   	ret    
		panic("sys_env_set_status: %e", r);
  800172:	50                   	push   %eax
  800173:	68 f7 20 80 00       	push   $0x8020f7
  800178:	6a 4c                	push   $0x4c
  80017a:	68 b3 20 80 00       	push   $0x8020b3
  80017f:	e8 c2 00 00 00       	call   800246 <_panic>

00800184 <umain>:
{
  800184:	f3 0f 1e fb          	endbr32 
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	57                   	push   %edi
  80018c:	56                   	push   %esi
  80018d:	53                   	push   %ebx
  80018e:	83 ec 0c             	sub    $0xc,%esp
	who = dumbfork();
  800191:	e8 3f ff ff ff       	call   8000d5 <dumbfork>
  800196:	89 c6                	mov    %eax,%esi
  800198:	85 c0                	test   %eax,%eax
  80019a:	bf 0e 21 80 00       	mov    $0x80210e,%edi
  80019f:	b8 15 21 80 00       	mov    $0x802115,%eax
  8001a4:	0f 44 f8             	cmove  %eax,%edi
	for (i = 0; i < (who ? 10 : 20); i++) {
  8001a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ac:	eb 1f                	jmp    8001cd <umain+0x49>
  8001ae:	83 fb 13             	cmp    $0x13,%ebx
  8001b1:	7f 23                	jg     8001d6 <umain+0x52>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  8001b3:	83 ec 04             	sub    $0x4,%esp
  8001b6:	57                   	push   %edi
  8001b7:	53                   	push   %ebx
  8001b8:	68 1b 21 80 00       	push   $0x80211b
  8001bd:	e8 6b 01 00 00       	call   80032d <cprintf>
		sys_yield();
  8001c2:	e8 8f 0b 00 00       	call   800d56 <sys_yield>
	for (i = 0; i < (who ? 10 : 20); i++) {
  8001c7:	83 c3 01             	add    $0x1,%ebx
  8001ca:	83 c4 10             	add    $0x10,%esp
  8001cd:	85 f6                	test   %esi,%esi
  8001cf:	74 dd                	je     8001ae <umain+0x2a>
  8001d1:	83 fb 09             	cmp    $0x9,%ebx
  8001d4:	7e dd                	jle    8001b3 <umain+0x2f>
}
  8001d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d9:	5b                   	pop    %ebx
  8001da:	5e                   	pop    %esi
  8001db:	5f                   	pop    %edi
  8001dc:	5d                   	pop    %ebp
  8001dd:	c3                   	ret    

008001de <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001de:	f3 0f 1e fb          	endbr32 
  8001e2:	55                   	push   %ebp
  8001e3:	89 e5                	mov    %esp,%ebp
  8001e5:	56                   	push   %esi
  8001e6:	53                   	push   %ebx
  8001e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001ea:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001ed:	e8 41 0b 00 00       	call   800d33 <sys_getenvid>
  8001f2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001f7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001fa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ff:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800204:	85 db                	test   %ebx,%ebx
  800206:	7e 07                	jle    80020f <libmain+0x31>
		binaryname = argv[0];
  800208:	8b 06                	mov    (%esi),%eax
  80020a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80020f:	83 ec 08             	sub    $0x8,%esp
  800212:	56                   	push   %esi
  800213:	53                   	push   %ebx
  800214:	e8 6b ff ff ff       	call   800184 <umain>

	// exit gracefully
	exit();
  800219:	e8 0a 00 00 00       	call   800228 <exit>
}
  80021e:	83 c4 10             	add    $0x10,%esp
  800221:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800224:	5b                   	pop    %ebx
  800225:	5e                   	pop    %esi
  800226:	5d                   	pop    %ebp
  800227:	c3                   	ret    

00800228 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800228:	f3 0f 1e fb          	endbr32 
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800232:	e8 42 0f 00 00       	call   801179 <close_all>
	sys_env_destroy(0);
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	6a 00                	push   $0x0
  80023c:	e8 ad 0a 00 00       	call   800cee <sys_env_destroy>
}
  800241:	83 c4 10             	add    $0x10,%esp
  800244:	c9                   	leave  
  800245:	c3                   	ret    

00800246 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800246:	f3 0f 1e fb          	endbr32 
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	56                   	push   %esi
  80024e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80024f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800252:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800258:	e8 d6 0a 00 00       	call   800d33 <sys_getenvid>
  80025d:	83 ec 0c             	sub    $0xc,%esp
  800260:	ff 75 0c             	pushl  0xc(%ebp)
  800263:	ff 75 08             	pushl  0x8(%ebp)
  800266:	56                   	push   %esi
  800267:	50                   	push   %eax
  800268:	68 38 21 80 00       	push   $0x802138
  80026d:	e8 bb 00 00 00       	call   80032d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800272:	83 c4 18             	add    $0x18,%esp
  800275:	53                   	push   %ebx
  800276:	ff 75 10             	pushl  0x10(%ebp)
  800279:	e8 5a 00 00 00       	call   8002d8 <vcprintf>
	cprintf("\n");
  80027e:	c7 04 24 2b 21 80 00 	movl   $0x80212b,(%esp)
  800285:	e8 a3 00 00 00       	call   80032d <cprintf>
  80028a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80028d:	cc                   	int3   
  80028e:	eb fd                	jmp    80028d <_panic+0x47>

00800290 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800290:	f3 0f 1e fb          	endbr32 
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	53                   	push   %ebx
  800298:	83 ec 04             	sub    $0x4,%esp
  80029b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80029e:	8b 13                	mov    (%ebx),%edx
  8002a0:	8d 42 01             	lea    0x1(%edx),%eax
  8002a3:	89 03                	mov    %eax,(%ebx)
  8002a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002a8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002ac:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002b1:	74 09                	je     8002bc <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002b3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002bc:	83 ec 08             	sub    $0x8,%esp
  8002bf:	68 ff 00 00 00       	push   $0xff
  8002c4:	8d 43 08             	lea    0x8(%ebx),%eax
  8002c7:	50                   	push   %eax
  8002c8:	e8 dc 09 00 00       	call   800ca9 <sys_cputs>
		b->idx = 0;
  8002cd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002d3:	83 c4 10             	add    $0x10,%esp
  8002d6:	eb db                	jmp    8002b3 <putch+0x23>

008002d8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002d8:	f3 0f 1e fb          	endbr32 
  8002dc:	55                   	push   %ebp
  8002dd:	89 e5                	mov    %esp,%ebp
  8002df:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ec:	00 00 00 
	b.cnt = 0;
  8002ef:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002f9:	ff 75 0c             	pushl  0xc(%ebp)
  8002fc:	ff 75 08             	pushl  0x8(%ebp)
  8002ff:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800305:	50                   	push   %eax
  800306:	68 90 02 80 00       	push   $0x800290
  80030b:	e8 20 01 00 00       	call   800430 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800310:	83 c4 08             	add    $0x8,%esp
  800313:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800319:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80031f:	50                   	push   %eax
  800320:	e8 84 09 00 00       	call   800ca9 <sys_cputs>

	return b.cnt;
}
  800325:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80032b:	c9                   	leave  
  80032c:	c3                   	ret    

0080032d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80032d:	f3 0f 1e fb          	endbr32 
  800331:	55                   	push   %ebp
  800332:	89 e5                	mov    %esp,%ebp
  800334:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800337:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80033a:	50                   	push   %eax
  80033b:	ff 75 08             	pushl  0x8(%ebp)
  80033e:	e8 95 ff ff ff       	call   8002d8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800343:	c9                   	leave  
  800344:	c3                   	ret    

00800345 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800345:	55                   	push   %ebp
  800346:	89 e5                	mov    %esp,%ebp
  800348:	57                   	push   %edi
  800349:	56                   	push   %esi
  80034a:	53                   	push   %ebx
  80034b:	83 ec 1c             	sub    $0x1c,%esp
  80034e:	89 c7                	mov    %eax,%edi
  800350:	89 d6                	mov    %edx,%esi
  800352:	8b 45 08             	mov    0x8(%ebp),%eax
  800355:	8b 55 0c             	mov    0xc(%ebp),%edx
  800358:	89 d1                	mov    %edx,%ecx
  80035a:	89 c2                	mov    %eax,%edx
  80035c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80035f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800362:	8b 45 10             	mov    0x10(%ebp),%eax
  800365:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800368:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80036b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800372:	39 c2                	cmp    %eax,%edx
  800374:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800377:	72 3e                	jb     8003b7 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800379:	83 ec 0c             	sub    $0xc,%esp
  80037c:	ff 75 18             	pushl  0x18(%ebp)
  80037f:	83 eb 01             	sub    $0x1,%ebx
  800382:	53                   	push   %ebx
  800383:	50                   	push   %eax
  800384:	83 ec 08             	sub    $0x8,%esp
  800387:	ff 75 e4             	pushl  -0x1c(%ebp)
  80038a:	ff 75 e0             	pushl  -0x20(%ebp)
  80038d:	ff 75 dc             	pushl  -0x24(%ebp)
  800390:	ff 75 d8             	pushl  -0x28(%ebp)
  800393:	e8 98 1a 00 00       	call   801e30 <__udivdi3>
  800398:	83 c4 18             	add    $0x18,%esp
  80039b:	52                   	push   %edx
  80039c:	50                   	push   %eax
  80039d:	89 f2                	mov    %esi,%edx
  80039f:	89 f8                	mov    %edi,%eax
  8003a1:	e8 9f ff ff ff       	call   800345 <printnum>
  8003a6:	83 c4 20             	add    $0x20,%esp
  8003a9:	eb 13                	jmp    8003be <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003ab:	83 ec 08             	sub    $0x8,%esp
  8003ae:	56                   	push   %esi
  8003af:	ff 75 18             	pushl  0x18(%ebp)
  8003b2:	ff d7                	call   *%edi
  8003b4:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003b7:	83 eb 01             	sub    $0x1,%ebx
  8003ba:	85 db                	test   %ebx,%ebx
  8003bc:	7f ed                	jg     8003ab <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003be:	83 ec 08             	sub    $0x8,%esp
  8003c1:	56                   	push   %esi
  8003c2:	83 ec 04             	sub    $0x4,%esp
  8003c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003c8:	ff 75 e0             	pushl  -0x20(%ebp)
  8003cb:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ce:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d1:	e8 6a 1b 00 00       	call   801f40 <__umoddi3>
  8003d6:	83 c4 14             	add    $0x14,%esp
  8003d9:	0f be 80 5b 21 80 00 	movsbl 0x80215b(%eax),%eax
  8003e0:	50                   	push   %eax
  8003e1:	ff d7                	call   *%edi
}
  8003e3:	83 c4 10             	add    $0x10,%esp
  8003e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003e9:	5b                   	pop    %ebx
  8003ea:	5e                   	pop    %esi
  8003eb:	5f                   	pop    %edi
  8003ec:	5d                   	pop    %ebp
  8003ed:	c3                   	ret    

008003ee <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003ee:	f3 0f 1e fb          	endbr32 
  8003f2:	55                   	push   %ebp
  8003f3:	89 e5                	mov    %esp,%ebp
  8003f5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003f8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003fc:	8b 10                	mov    (%eax),%edx
  8003fe:	3b 50 04             	cmp    0x4(%eax),%edx
  800401:	73 0a                	jae    80040d <sprintputch+0x1f>
		*b->buf++ = ch;
  800403:	8d 4a 01             	lea    0x1(%edx),%ecx
  800406:	89 08                	mov    %ecx,(%eax)
  800408:	8b 45 08             	mov    0x8(%ebp),%eax
  80040b:	88 02                	mov    %al,(%edx)
}
  80040d:	5d                   	pop    %ebp
  80040e:	c3                   	ret    

0080040f <printfmt>:
{
  80040f:	f3 0f 1e fb          	endbr32 
  800413:	55                   	push   %ebp
  800414:	89 e5                	mov    %esp,%ebp
  800416:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800419:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80041c:	50                   	push   %eax
  80041d:	ff 75 10             	pushl  0x10(%ebp)
  800420:	ff 75 0c             	pushl  0xc(%ebp)
  800423:	ff 75 08             	pushl  0x8(%ebp)
  800426:	e8 05 00 00 00       	call   800430 <vprintfmt>
}
  80042b:	83 c4 10             	add    $0x10,%esp
  80042e:	c9                   	leave  
  80042f:	c3                   	ret    

00800430 <vprintfmt>:
{
  800430:	f3 0f 1e fb          	endbr32 
  800434:	55                   	push   %ebp
  800435:	89 e5                	mov    %esp,%ebp
  800437:	57                   	push   %edi
  800438:	56                   	push   %esi
  800439:	53                   	push   %ebx
  80043a:	83 ec 3c             	sub    $0x3c,%esp
  80043d:	8b 75 08             	mov    0x8(%ebp),%esi
  800440:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800443:	8b 7d 10             	mov    0x10(%ebp),%edi
  800446:	e9 8e 03 00 00       	jmp    8007d9 <vprintfmt+0x3a9>
		padc = ' ';
  80044b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80044f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800456:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80045d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800464:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800469:	8d 47 01             	lea    0x1(%edi),%eax
  80046c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80046f:	0f b6 17             	movzbl (%edi),%edx
  800472:	8d 42 dd             	lea    -0x23(%edx),%eax
  800475:	3c 55                	cmp    $0x55,%al
  800477:	0f 87 df 03 00 00    	ja     80085c <vprintfmt+0x42c>
  80047d:	0f b6 c0             	movzbl %al,%eax
  800480:	3e ff 24 85 a0 22 80 	notrack jmp *0x8022a0(,%eax,4)
  800487:	00 
  800488:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80048b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80048f:	eb d8                	jmp    800469 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800491:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800494:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800498:	eb cf                	jmp    800469 <vprintfmt+0x39>
  80049a:	0f b6 d2             	movzbl %dl,%edx
  80049d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8004a8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004ab:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004af:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004b2:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004b5:	83 f9 09             	cmp    $0x9,%ecx
  8004b8:	77 55                	ja     80050f <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8004ba:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004bd:	eb e9                	jmp    8004a8 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8004bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ca:	8d 40 04             	lea    0x4(%eax),%eax
  8004cd:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004d7:	79 90                	jns    800469 <vprintfmt+0x39>
				width = precision, precision = -1;
  8004d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004df:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004e6:	eb 81                	jmp    800469 <vprintfmt+0x39>
  8004e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004eb:	85 c0                	test   %eax,%eax
  8004ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f2:	0f 49 d0             	cmovns %eax,%edx
  8004f5:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004fb:	e9 69 ff ff ff       	jmp    800469 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800500:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800503:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80050a:	e9 5a ff ff ff       	jmp    800469 <vprintfmt+0x39>
  80050f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800512:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800515:	eb bc                	jmp    8004d3 <vprintfmt+0xa3>
			lflag++;
  800517:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80051a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80051d:	e9 47 ff ff ff       	jmp    800469 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800522:	8b 45 14             	mov    0x14(%ebp),%eax
  800525:	8d 78 04             	lea    0x4(%eax),%edi
  800528:	83 ec 08             	sub    $0x8,%esp
  80052b:	53                   	push   %ebx
  80052c:	ff 30                	pushl  (%eax)
  80052e:	ff d6                	call   *%esi
			break;
  800530:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800533:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800536:	e9 9b 02 00 00       	jmp    8007d6 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	8d 78 04             	lea    0x4(%eax),%edi
  800541:	8b 00                	mov    (%eax),%eax
  800543:	99                   	cltd   
  800544:	31 d0                	xor    %edx,%eax
  800546:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800548:	83 f8 0f             	cmp    $0xf,%eax
  80054b:	7f 23                	jg     800570 <vprintfmt+0x140>
  80054d:	8b 14 85 00 24 80 00 	mov    0x802400(,%eax,4),%edx
  800554:	85 d2                	test   %edx,%edx
  800556:	74 18                	je     800570 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800558:	52                   	push   %edx
  800559:	68 31 25 80 00       	push   $0x802531
  80055e:	53                   	push   %ebx
  80055f:	56                   	push   %esi
  800560:	e8 aa fe ff ff       	call   80040f <printfmt>
  800565:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800568:	89 7d 14             	mov    %edi,0x14(%ebp)
  80056b:	e9 66 02 00 00       	jmp    8007d6 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800570:	50                   	push   %eax
  800571:	68 73 21 80 00       	push   $0x802173
  800576:	53                   	push   %ebx
  800577:	56                   	push   %esi
  800578:	e8 92 fe ff ff       	call   80040f <printfmt>
  80057d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800580:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800583:	e9 4e 02 00 00       	jmp    8007d6 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800588:	8b 45 14             	mov    0x14(%ebp),%eax
  80058b:	83 c0 04             	add    $0x4,%eax
  80058e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800596:	85 d2                	test   %edx,%edx
  800598:	b8 6c 21 80 00       	mov    $0x80216c,%eax
  80059d:	0f 45 c2             	cmovne %edx,%eax
  8005a0:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005a3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005a7:	7e 06                	jle    8005af <vprintfmt+0x17f>
  8005a9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005ad:	75 0d                	jne    8005bc <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005af:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005b2:	89 c7                	mov    %eax,%edi
  8005b4:	03 45 e0             	add    -0x20(%ebp),%eax
  8005b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ba:	eb 55                	jmp    800611 <vprintfmt+0x1e1>
  8005bc:	83 ec 08             	sub    $0x8,%esp
  8005bf:	ff 75 d8             	pushl  -0x28(%ebp)
  8005c2:	ff 75 cc             	pushl  -0x34(%ebp)
  8005c5:	e8 46 03 00 00       	call   800910 <strnlen>
  8005ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005cd:	29 c2                	sub    %eax,%edx
  8005cf:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005d2:	83 c4 10             	add    $0x10,%esp
  8005d5:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005d7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005db:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005de:	85 ff                	test   %edi,%edi
  8005e0:	7e 11                	jle    8005f3 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8005e2:	83 ec 08             	sub    $0x8,%esp
  8005e5:	53                   	push   %ebx
  8005e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8005e9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005eb:	83 ef 01             	sub    $0x1,%edi
  8005ee:	83 c4 10             	add    $0x10,%esp
  8005f1:	eb eb                	jmp    8005de <vprintfmt+0x1ae>
  8005f3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005f6:	85 d2                	test   %edx,%edx
  8005f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005fd:	0f 49 c2             	cmovns %edx,%eax
  800600:	29 c2                	sub    %eax,%edx
  800602:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800605:	eb a8                	jmp    8005af <vprintfmt+0x17f>
					putch(ch, putdat);
  800607:	83 ec 08             	sub    $0x8,%esp
  80060a:	53                   	push   %ebx
  80060b:	52                   	push   %edx
  80060c:	ff d6                	call   *%esi
  80060e:	83 c4 10             	add    $0x10,%esp
  800611:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800614:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800616:	83 c7 01             	add    $0x1,%edi
  800619:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80061d:	0f be d0             	movsbl %al,%edx
  800620:	85 d2                	test   %edx,%edx
  800622:	74 4b                	je     80066f <vprintfmt+0x23f>
  800624:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800628:	78 06                	js     800630 <vprintfmt+0x200>
  80062a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80062e:	78 1e                	js     80064e <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800630:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800634:	74 d1                	je     800607 <vprintfmt+0x1d7>
  800636:	0f be c0             	movsbl %al,%eax
  800639:	83 e8 20             	sub    $0x20,%eax
  80063c:	83 f8 5e             	cmp    $0x5e,%eax
  80063f:	76 c6                	jbe    800607 <vprintfmt+0x1d7>
					putch('?', putdat);
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	53                   	push   %ebx
  800645:	6a 3f                	push   $0x3f
  800647:	ff d6                	call   *%esi
  800649:	83 c4 10             	add    $0x10,%esp
  80064c:	eb c3                	jmp    800611 <vprintfmt+0x1e1>
  80064e:	89 cf                	mov    %ecx,%edi
  800650:	eb 0e                	jmp    800660 <vprintfmt+0x230>
				putch(' ', putdat);
  800652:	83 ec 08             	sub    $0x8,%esp
  800655:	53                   	push   %ebx
  800656:	6a 20                	push   $0x20
  800658:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80065a:	83 ef 01             	sub    $0x1,%edi
  80065d:	83 c4 10             	add    $0x10,%esp
  800660:	85 ff                	test   %edi,%edi
  800662:	7f ee                	jg     800652 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800664:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
  80066a:	e9 67 01 00 00       	jmp    8007d6 <vprintfmt+0x3a6>
  80066f:	89 cf                	mov    %ecx,%edi
  800671:	eb ed                	jmp    800660 <vprintfmt+0x230>
	if (lflag >= 2)
  800673:	83 f9 01             	cmp    $0x1,%ecx
  800676:	7f 1b                	jg     800693 <vprintfmt+0x263>
	else if (lflag)
  800678:	85 c9                	test   %ecx,%ecx
  80067a:	74 63                	je     8006df <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800684:	99                   	cltd   
  800685:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	8d 40 04             	lea    0x4(%eax),%eax
  80068e:	89 45 14             	mov    %eax,0x14(%ebp)
  800691:	eb 17                	jmp    8006aa <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8b 50 04             	mov    0x4(%eax),%edx
  800699:	8b 00                	mov    (%eax),%eax
  80069b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8d 40 08             	lea    0x8(%eax),%eax
  8006a7:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006aa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006ad:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006b0:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006b5:	85 c9                	test   %ecx,%ecx
  8006b7:	0f 89 ff 00 00 00    	jns    8007bc <vprintfmt+0x38c>
				putch('-', putdat);
  8006bd:	83 ec 08             	sub    $0x8,%esp
  8006c0:	53                   	push   %ebx
  8006c1:	6a 2d                	push   $0x2d
  8006c3:	ff d6                	call   *%esi
				num = -(long long) num;
  8006c5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006c8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006cb:	f7 da                	neg    %edx
  8006cd:	83 d1 00             	adc    $0x0,%ecx
  8006d0:	f7 d9                	neg    %ecx
  8006d2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006d5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006da:	e9 dd 00 00 00       	jmp    8007bc <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e7:	99                   	cltd   
  8006e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8d 40 04             	lea    0x4(%eax),%eax
  8006f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f4:	eb b4                	jmp    8006aa <vprintfmt+0x27a>
	if (lflag >= 2)
  8006f6:	83 f9 01             	cmp    $0x1,%ecx
  8006f9:	7f 1e                	jg     800719 <vprintfmt+0x2e9>
	else if (lflag)
  8006fb:	85 c9                	test   %ecx,%ecx
  8006fd:	74 32                	je     800731 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8b 10                	mov    (%eax),%edx
  800704:	b9 00 00 00 00       	mov    $0x0,%ecx
  800709:	8d 40 04             	lea    0x4(%eax),%eax
  80070c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80070f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800714:	e9 a3 00 00 00       	jmp    8007bc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800719:	8b 45 14             	mov    0x14(%ebp),%eax
  80071c:	8b 10                	mov    (%eax),%edx
  80071e:	8b 48 04             	mov    0x4(%eax),%ecx
  800721:	8d 40 08             	lea    0x8(%eax),%eax
  800724:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800727:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80072c:	e9 8b 00 00 00       	jmp    8007bc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800731:	8b 45 14             	mov    0x14(%ebp),%eax
  800734:	8b 10                	mov    (%eax),%edx
  800736:	b9 00 00 00 00       	mov    $0x0,%ecx
  80073b:	8d 40 04             	lea    0x4(%eax),%eax
  80073e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800741:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800746:	eb 74                	jmp    8007bc <vprintfmt+0x38c>
	if (lflag >= 2)
  800748:	83 f9 01             	cmp    $0x1,%ecx
  80074b:	7f 1b                	jg     800768 <vprintfmt+0x338>
	else if (lflag)
  80074d:	85 c9                	test   %ecx,%ecx
  80074f:	74 2c                	je     80077d <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8b 10                	mov    (%eax),%edx
  800756:	b9 00 00 00 00       	mov    $0x0,%ecx
  80075b:	8d 40 04             	lea    0x4(%eax),%eax
  80075e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800761:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800766:	eb 54                	jmp    8007bc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	8b 10                	mov    (%eax),%edx
  80076d:	8b 48 04             	mov    0x4(%eax),%ecx
  800770:	8d 40 08             	lea    0x8(%eax),%eax
  800773:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800776:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80077b:	eb 3f                	jmp    8007bc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8b 10                	mov    (%eax),%edx
  800782:	b9 00 00 00 00       	mov    $0x0,%ecx
  800787:	8d 40 04             	lea    0x4(%eax),%eax
  80078a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80078d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800792:	eb 28                	jmp    8007bc <vprintfmt+0x38c>
			putch('0', putdat);
  800794:	83 ec 08             	sub    $0x8,%esp
  800797:	53                   	push   %ebx
  800798:	6a 30                	push   $0x30
  80079a:	ff d6                	call   *%esi
			putch('x', putdat);
  80079c:	83 c4 08             	add    $0x8,%esp
  80079f:	53                   	push   %ebx
  8007a0:	6a 78                	push   $0x78
  8007a2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8b 10                	mov    (%eax),%edx
  8007a9:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007ae:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007b1:	8d 40 04             	lea    0x4(%eax),%eax
  8007b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007bc:	83 ec 0c             	sub    $0xc,%esp
  8007bf:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8007c3:	57                   	push   %edi
  8007c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8007c7:	50                   	push   %eax
  8007c8:	51                   	push   %ecx
  8007c9:	52                   	push   %edx
  8007ca:	89 da                	mov    %ebx,%edx
  8007cc:	89 f0                	mov    %esi,%eax
  8007ce:	e8 72 fb ff ff       	call   800345 <printnum>
			break;
  8007d3:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d9:	83 c7 01             	add    $0x1,%edi
  8007dc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007e0:	83 f8 25             	cmp    $0x25,%eax
  8007e3:	0f 84 62 fc ff ff    	je     80044b <vprintfmt+0x1b>
			if (ch == '\0')
  8007e9:	85 c0                	test   %eax,%eax
  8007eb:	0f 84 8b 00 00 00    	je     80087c <vprintfmt+0x44c>
			putch(ch, putdat);
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	53                   	push   %ebx
  8007f5:	50                   	push   %eax
  8007f6:	ff d6                	call   *%esi
  8007f8:	83 c4 10             	add    $0x10,%esp
  8007fb:	eb dc                	jmp    8007d9 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8007fd:	83 f9 01             	cmp    $0x1,%ecx
  800800:	7f 1b                	jg     80081d <vprintfmt+0x3ed>
	else if (lflag)
  800802:	85 c9                	test   %ecx,%ecx
  800804:	74 2c                	je     800832 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	8b 10                	mov    (%eax),%edx
  80080b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800810:	8d 40 04             	lea    0x4(%eax),%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800816:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80081b:	eb 9f                	jmp    8007bc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	8b 10                	mov    (%eax),%edx
  800822:	8b 48 04             	mov    0x4(%eax),%ecx
  800825:	8d 40 08             	lea    0x8(%eax),%eax
  800828:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800830:	eb 8a                	jmp    8007bc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	8b 10                	mov    (%eax),%edx
  800837:	b9 00 00 00 00       	mov    $0x0,%ecx
  80083c:	8d 40 04             	lea    0x4(%eax),%eax
  80083f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800842:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800847:	e9 70 ff ff ff       	jmp    8007bc <vprintfmt+0x38c>
			putch(ch, putdat);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	53                   	push   %ebx
  800850:	6a 25                	push   $0x25
  800852:	ff d6                	call   *%esi
			break;
  800854:	83 c4 10             	add    $0x10,%esp
  800857:	e9 7a ff ff ff       	jmp    8007d6 <vprintfmt+0x3a6>
			putch('%', putdat);
  80085c:	83 ec 08             	sub    $0x8,%esp
  80085f:	53                   	push   %ebx
  800860:	6a 25                	push   $0x25
  800862:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800864:	83 c4 10             	add    $0x10,%esp
  800867:	89 f8                	mov    %edi,%eax
  800869:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80086d:	74 05                	je     800874 <vprintfmt+0x444>
  80086f:	83 e8 01             	sub    $0x1,%eax
  800872:	eb f5                	jmp    800869 <vprintfmt+0x439>
  800874:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800877:	e9 5a ff ff ff       	jmp    8007d6 <vprintfmt+0x3a6>
}
  80087c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80087f:	5b                   	pop    %ebx
  800880:	5e                   	pop    %esi
  800881:	5f                   	pop    %edi
  800882:	5d                   	pop    %ebp
  800883:	c3                   	ret    

00800884 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800884:	f3 0f 1e fb          	endbr32 
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	83 ec 18             	sub    $0x18,%esp
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800894:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800897:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80089b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80089e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008a5:	85 c0                	test   %eax,%eax
  8008a7:	74 26                	je     8008cf <vsnprintf+0x4b>
  8008a9:	85 d2                	test   %edx,%edx
  8008ab:	7e 22                	jle    8008cf <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008ad:	ff 75 14             	pushl  0x14(%ebp)
  8008b0:	ff 75 10             	pushl  0x10(%ebp)
  8008b3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b6:	50                   	push   %eax
  8008b7:	68 ee 03 80 00       	push   $0x8003ee
  8008bc:	e8 6f fb ff ff       	call   800430 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ca:	83 c4 10             	add    $0x10,%esp
}
  8008cd:	c9                   	leave  
  8008ce:	c3                   	ret    
		return -E_INVAL;
  8008cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d4:	eb f7                	jmp    8008cd <vsnprintf+0x49>

008008d6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008d6:	f3 0f 1e fb          	endbr32 
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008e0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008e3:	50                   	push   %eax
  8008e4:	ff 75 10             	pushl  0x10(%ebp)
  8008e7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ea:	ff 75 08             	pushl  0x8(%ebp)
  8008ed:	e8 92 ff ff ff       	call   800884 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008f2:	c9                   	leave  
  8008f3:	c3                   	ret    

008008f4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008f4:	f3 0f 1e fb          	endbr32 
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800903:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800907:	74 05                	je     80090e <strlen+0x1a>
		n++;
  800909:	83 c0 01             	add    $0x1,%eax
  80090c:	eb f5                	jmp    800903 <strlen+0xf>
	return n;
}
  80090e:	5d                   	pop    %ebp
  80090f:	c3                   	ret    

00800910 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800910:	f3 0f 1e fb          	endbr32 
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
  800917:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80091d:	b8 00 00 00 00       	mov    $0x0,%eax
  800922:	39 d0                	cmp    %edx,%eax
  800924:	74 0d                	je     800933 <strnlen+0x23>
  800926:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80092a:	74 05                	je     800931 <strnlen+0x21>
		n++;
  80092c:	83 c0 01             	add    $0x1,%eax
  80092f:	eb f1                	jmp    800922 <strnlen+0x12>
  800931:	89 c2                	mov    %eax,%edx
	return n;
}
  800933:	89 d0                	mov    %edx,%eax
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800937:	f3 0f 1e fb          	endbr32 
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	53                   	push   %ebx
  80093f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800942:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800945:	b8 00 00 00 00       	mov    $0x0,%eax
  80094a:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80094e:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800951:	83 c0 01             	add    $0x1,%eax
  800954:	84 d2                	test   %dl,%dl
  800956:	75 f2                	jne    80094a <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800958:	89 c8                	mov    %ecx,%eax
  80095a:	5b                   	pop    %ebx
  80095b:	5d                   	pop    %ebp
  80095c:	c3                   	ret    

0080095d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80095d:	f3 0f 1e fb          	endbr32 
  800961:	55                   	push   %ebp
  800962:	89 e5                	mov    %esp,%ebp
  800964:	53                   	push   %ebx
  800965:	83 ec 10             	sub    $0x10,%esp
  800968:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80096b:	53                   	push   %ebx
  80096c:	e8 83 ff ff ff       	call   8008f4 <strlen>
  800971:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800974:	ff 75 0c             	pushl  0xc(%ebp)
  800977:	01 d8                	add    %ebx,%eax
  800979:	50                   	push   %eax
  80097a:	e8 b8 ff ff ff       	call   800937 <strcpy>
	return dst;
}
  80097f:	89 d8                	mov    %ebx,%eax
  800981:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800984:	c9                   	leave  
  800985:	c3                   	ret    

00800986 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800986:	f3 0f 1e fb          	endbr32 
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	56                   	push   %esi
  80098e:	53                   	push   %ebx
  80098f:	8b 75 08             	mov    0x8(%ebp),%esi
  800992:	8b 55 0c             	mov    0xc(%ebp),%edx
  800995:	89 f3                	mov    %esi,%ebx
  800997:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80099a:	89 f0                	mov    %esi,%eax
  80099c:	39 d8                	cmp    %ebx,%eax
  80099e:	74 11                	je     8009b1 <strncpy+0x2b>
		*dst++ = *src;
  8009a0:	83 c0 01             	add    $0x1,%eax
  8009a3:	0f b6 0a             	movzbl (%edx),%ecx
  8009a6:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009a9:	80 f9 01             	cmp    $0x1,%cl
  8009ac:	83 da ff             	sbb    $0xffffffff,%edx
  8009af:	eb eb                	jmp    80099c <strncpy+0x16>
	}
	return ret;
}
  8009b1:	89 f0                	mov    %esi,%eax
  8009b3:	5b                   	pop    %ebx
  8009b4:	5e                   	pop    %esi
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009b7:	f3 0f 1e fb          	endbr32 
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	56                   	push   %esi
  8009bf:	53                   	push   %ebx
  8009c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c6:	8b 55 10             	mov    0x10(%ebp),%edx
  8009c9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009cb:	85 d2                	test   %edx,%edx
  8009cd:	74 21                	je     8009f0 <strlcpy+0x39>
  8009cf:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009d3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009d5:	39 c2                	cmp    %eax,%edx
  8009d7:	74 14                	je     8009ed <strlcpy+0x36>
  8009d9:	0f b6 19             	movzbl (%ecx),%ebx
  8009dc:	84 db                	test   %bl,%bl
  8009de:	74 0b                	je     8009eb <strlcpy+0x34>
			*dst++ = *src++;
  8009e0:	83 c1 01             	add    $0x1,%ecx
  8009e3:	83 c2 01             	add    $0x1,%edx
  8009e6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009e9:	eb ea                	jmp    8009d5 <strlcpy+0x1e>
  8009eb:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ed:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f0:	29 f0                	sub    %esi,%eax
}
  8009f2:	5b                   	pop    %ebx
  8009f3:	5e                   	pop    %esi
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    

008009f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009f6:	f3 0f 1e fb          	endbr32 
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a00:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a03:	0f b6 01             	movzbl (%ecx),%eax
  800a06:	84 c0                	test   %al,%al
  800a08:	74 0c                	je     800a16 <strcmp+0x20>
  800a0a:	3a 02                	cmp    (%edx),%al
  800a0c:	75 08                	jne    800a16 <strcmp+0x20>
		p++, q++;
  800a0e:	83 c1 01             	add    $0x1,%ecx
  800a11:	83 c2 01             	add    $0x1,%edx
  800a14:	eb ed                	jmp    800a03 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a16:	0f b6 c0             	movzbl %al,%eax
  800a19:	0f b6 12             	movzbl (%edx),%edx
  800a1c:	29 d0                	sub    %edx,%eax
}
  800a1e:	5d                   	pop    %ebp
  800a1f:	c3                   	ret    

00800a20 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a20:	f3 0f 1e fb          	endbr32 
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	53                   	push   %ebx
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2e:	89 c3                	mov    %eax,%ebx
  800a30:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a33:	eb 06                	jmp    800a3b <strncmp+0x1b>
		n--, p++, q++;
  800a35:	83 c0 01             	add    $0x1,%eax
  800a38:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a3b:	39 d8                	cmp    %ebx,%eax
  800a3d:	74 16                	je     800a55 <strncmp+0x35>
  800a3f:	0f b6 08             	movzbl (%eax),%ecx
  800a42:	84 c9                	test   %cl,%cl
  800a44:	74 04                	je     800a4a <strncmp+0x2a>
  800a46:	3a 0a                	cmp    (%edx),%cl
  800a48:	74 eb                	je     800a35 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a4a:	0f b6 00             	movzbl (%eax),%eax
  800a4d:	0f b6 12             	movzbl (%edx),%edx
  800a50:	29 d0                	sub    %edx,%eax
}
  800a52:	5b                   	pop    %ebx
  800a53:	5d                   	pop    %ebp
  800a54:	c3                   	ret    
		return 0;
  800a55:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5a:	eb f6                	jmp    800a52 <strncmp+0x32>

00800a5c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a5c:	f3 0f 1e fb          	endbr32 
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a6a:	0f b6 10             	movzbl (%eax),%edx
  800a6d:	84 d2                	test   %dl,%dl
  800a6f:	74 09                	je     800a7a <strchr+0x1e>
		if (*s == c)
  800a71:	38 ca                	cmp    %cl,%dl
  800a73:	74 0a                	je     800a7f <strchr+0x23>
	for (; *s; s++)
  800a75:	83 c0 01             	add    $0x1,%eax
  800a78:	eb f0                	jmp    800a6a <strchr+0xe>
			return (char *) s;
	return 0;
  800a7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a7f:	5d                   	pop    %ebp
  800a80:	c3                   	ret    

00800a81 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a81:	f3 0f 1e fb          	endbr32 
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a8f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a92:	38 ca                	cmp    %cl,%dl
  800a94:	74 09                	je     800a9f <strfind+0x1e>
  800a96:	84 d2                	test   %dl,%dl
  800a98:	74 05                	je     800a9f <strfind+0x1e>
	for (; *s; s++)
  800a9a:	83 c0 01             	add    $0x1,%eax
  800a9d:	eb f0                	jmp    800a8f <strfind+0xe>
			break;
	return (char *) s;
}
  800a9f:	5d                   	pop    %ebp
  800aa0:	c3                   	ret    

00800aa1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aa1:	f3 0f 1e fb          	endbr32 
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	57                   	push   %edi
  800aa9:	56                   	push   %esi
  800aaa:	53                   	push   %ebx
  800aab:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aae:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ab1:	85 c9                	test   %ecx,%ecx
  800ab3:	74 31                	je     800ae6 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ab5:	89 f8                	mov    %edi,%eax
  800ab7:	09 c8                	or     %ecx,%eax
  800ab9:	a8 03                	test   $0x3,%al
  800abb:	75 23                	jne    800ae0 <memset+0x3f>
		c &= 0xFF;
  800abd:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ac1:	89 d3                	mov    %edx,%ebx
  800ac3:	c1 e3 08             	shl    $0x8,%ebx
  800ac6:	89 d0                	mov    %edx,%eax
  800ac8:	c1 e0 18             	shl    $0x18,%eax
  800acb:	89 d6                	mov    %edx,%esi
  800acd:	c1 e6 10             	shl    $0x10,%esi
  800ad0:	09 f0                	or     %esi,%eax
  800ad2:	09 c2                	or     %eax,%edx
  800ad4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ad6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ad9:	89 d0                	mov    %edx,%eax
  800adb:	fc                   	cld    
  800adc:	f3 ab                	rep stos %eax,%es:(%edi)
  800ade:	eb 06                	jmp    800ae6 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae3:	fc                   	cld    
  800ae4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ae6:	89 f8                	mov    %edi,%eax
  800ae8:	5b                   	pop    %ebx
  800ae9:	5e                   	pop    %esi
  800aea:	5f                   	pop    %edi
  800aeb:	5d                   	pop    %ebp
  800aec:	c3                   	ret    

00800aed <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aed:	f3 0f 1e fb          	endbr32 
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
  800af4:	57                   	push   %edi
  800af5:	56                   	push   %esi
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800afc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aff:	39 c6                	cmp    %eax,%esi
  800b01:	73 32                	jae    800b35 <memmove+0x48>
  800b03:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b06:	39 c2                	cmp    %eax,%edx
  800b08:	76 2b                	jbe    800b35 <memmove+0x48>
		s += n;
		d += n;
  800b0a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0d:	89 fe                	mov    %edi,%esi
  800b0f:	09 ce                	or     %ecx,%esi
  800b11:	09 d6                	or     %edx,%esi
  800b13:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b19:	75 0e                	jne    800b29 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b1b:	83 ef 04             	sub    $0x4,%edi
  800b1e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b21:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b24:	fd                   	std    
  800b25:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b27:	eb 09                	jmp    800b32 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b29:	83 ef 01             	sub    $0x1,%edi
  800b2c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b2f:	fd                   	std    
  800b30:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b32:	fc                   	cld    
  800b33:	eb 1a                	jmp    800b4f <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b35:	89 c2                	mov    %eax,%edx
  800b37:	09 ca                	or     %ecx,%edx
  800b39:	09 f2                	or     %esi,%edx
  800b3b:	f6 c2 03             	test   $0x3,%dl
  800b3e:	75 0a                	jne    800b4a <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b40:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b43:	89 c7                	mov    %eax,%edi
  800b45:	fc                   	cld    
  800b46:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b48:	eb 05                	jmp    800b4f <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b4a:	89 c7                	mov    %eax,%edi
  800b4c:	fc                   	cld    
  800b4d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b4f:	5e                   	pop    %esi
  800b50:	5f                   	pop    %edi
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b53:	f3 0f 1e fb          	endbr32 
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b5d:	ff 75 10             	pushl  0x10(%ebp)
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	ff 75 08             	pushl  0x8(%ebp)
  800b66:	e8 82 ff ff ff       	call   800aed <memmove>
}
  800b6b:	c9                   	leave  
  800b6c:	c3                   	ret    

00800b6d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b6d:	f3 0f 1e fb          	endbr32 
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	56                   	push   %esi
  800b75:	53                   	push   %ebx
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7c:	89 c6                	mov    %eax,%esi
  800b7e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b81:	39 f0                	cmp    %esi,%eax
  800b83:	74 1c                	je     800ba1 <memcmp+0x34>
		if (*s1 != *s2)
  800b85:	0f b6 08             	movzbl (%eax),%ecx
  800b88:	0f b6 1a             	movzbl (%edx),%ebx
  800b8b:	38 d9                	cmp    %bl,%cl
  800b8d:	75 08                	jne    800b97 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b8f:	83 c0 01             	add    $0x1,%eax
  800b92:	83 c2 01             	add    $0x1,%edx
  800b95:	eb ea                	jmp    800b81 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b97:	0f b6 c1             	movzbl %cl,%eax
  800b9a:	0f b6 db             	movzbl %bl,%ebx
  800b9d:	29 d8                	sub    %ebx,%eax
  800b9f:	eb 05                	jmp    800ba6 <memcmp+0x39>
	}

	return 0;
  800ba1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba6:	5b                   	pop    %ebx
  800ba7:	5e                   	pop    %esi
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    

00800baa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800baa:	f3 0f 1e fb          	endbr32 
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bb7:	89 c2                	mov    %eax,%edx
  800bb9:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bbc:	39 d0                	cmp    %edx,%eax
  800bbe:	73 09                	jae    800bc9 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bc0:	38 08                	cmp    %cl,(%eax)
  800bc2:	74 05                	je     800bc9 <memfind+0x1f>
	for (; s < ends; s++)
  800bc4:	83 c0 01             	add    $0x1,%eax
  800bc7:	eb f3                	jmp    800bbc <memfind+0x12>
			break;
	return (void *) s;
}
  800bc9:	5d                   	pop    %ebp
  800bca:	c3                   	ret    

00800bcb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bcb:	f3 0f 1e fb          	endbr32 
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	57                   	push   %edi
  800bd3:	56                   	push   %esi
  800bd4:	53                   	push   %ebx
  800bd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bdb:	eb 03                	jmp    800be0 <strtol+0x15>
		s++;
  800bdd:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800be0:	0f b6 01             	movzbl (%ecx),%eax
  800be3:	3c 20                	cmp    $0x20,%al
  800be5:	74 f6                	je     800bdd <strtol+0x12>
  800be7:	3c 09                	cmp    $0x9,%al
  800be9:	74 f2                	je     800bdd <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800beb:	3c 2b                	cmp    $0x2b,%al
  800bed:	74 2a                	je     800c19 <strtol+0x4e>
	int neg = 0;
  800bef:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bf4:	3c 2d                	cmp    $0x2d,%al
  800bf6:	74 2b                	je     800c23 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bfe:	75 0f                	jne    800c0f <strtol+0x44>
  800c00:	80 39 30             	cmpb   $0x30,(%ecx)
  800c03:	74 28                	je     800c2d <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c05:	85 db                	test   %ebx,%ebx
  800c07:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c0c:	0f 44 d8             	cmove  %eax,%ebx
  800c0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c14:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c17:	eb 46                	jmp    800c5f <strtol+0x94>
		s++;
  800c19:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c1c:	bf 00 00 00 00       	mov    $0x0,%edi
  800c21:	eb d5                	jmp    800bf8 <strtol+0x2d>
		s++, neg = 1;
  800c23:	83 c1 01             	add    $0x1,%ecx
  800c26:	bf 01 00 00 00       	mov    $0x1,%edi
  800c2b:	eb cb                	jmp    800bf8 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c2d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c31:	74 0e                	je     800c41 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c33:	85 db                	test   %ebx,%ebx
  800c35:	75 d8                	jne    800c0f <strtol+0x44>
		s++, base = 8;
  800c37:	83 c1 01             	add    $0x1,%ecx
  800c3a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c3f:	eb ce                	jmp    800c0f <strtol+0x44>
		s += 2, base = 16;
  800c41:	83 c1 02             	add    $0x2,%ecx
  800c44:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c49:	eb c4                	jmp    800c0f <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c4b:	0f be d2             	movsbl %dl,%edx
  800c4e:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c51:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c54:	7d 3a                	jge    800c90 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c56:	83 c1 01             	add    $0x1,%ecx
  800c59:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c5d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c5f:	0f b6 11             	movzbl (%ecx),%edx
  800c62:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c65:	89 f3                	mov    %esi,%ebx
  800c67:	80 fb 09             	cmp    $0x9,%bl
  800c6a:	76 df                	jbe    800c4b <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c6c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c6f:	89 f3                	mov    %esi,%ebx
  800c71:	80 fb 19             	cmp    $0x19,%bl
  800c74:	77 08                	ja     800c7e <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c76:	0f be d2             	movsbl %dl,%edx
  800c79:	83 ea 57             	sub    $0x57,%edx
  800c7c:	eb d3                	jmp    800c51 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c7e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c81:	89 f3                	mov    %esi,%ebx
  800c83:	80 fb 19             	cmp    $0x19,%bl
  800c86:	77 08                	ja     800c90 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c88:	0f be d2             	movsbl %dl,%edx
  800c8b:	83 ea 37             	sub    $0x37,%edx
  800c8e:	eb c1                	jmp    800c51 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c94:	74 05                	je     800c9b <strtol+0xd0>
		*endptr = (char *) s;
  800c96:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c99:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c9b:	89 c2                	mov    %eax,%edx
  800c9d:	f7 da                	neg    %edx
  800c9f:	85 ff                	test   %edi,%edi
  800ca1:	0f 45 c2             	cmovne %edx,%eax
}
  800ca4:	5b                   	pop    %ebx
  800ca5:	5e                   	pop    %esi
  800ca6:	5f                   	pop    %edi
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ca9:	f3 0f 1e fb          	endbr32 
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	57                   	push   %edi
  800cb1:	56                   	push   %esi
  800cb2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb3:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbe:	89 c3                	mov    %eax,%ebx
  800cc0:	89 c7                	mov    %eax,%edi
  800cc2:	89 c6                	mov    %eax,%esi
  800cc4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cc6:	5b                   	pop    %ebx
  800cc7:	5e                   	pop    %esi
  800cc8:	5f                   	pop    %edi
  800cc9:	5d                   	pop    %ebp
  800cca:	c3                   	ret    

00800ccb <sys_cgetc>:

int
sys_cgetc(void)
{
  800ccb:	f3 0f 1e fb          	endbr32 
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
  800cd2:	57                   	push   %edi
  800cd3:	56                   	push   %esi
  800cd4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cda:	b8 01 00 00 00       	mov    $0x1,%eax
  800cdf:	89 d1                	mov    %edx,%ecx
  800ce1:	89 d3                	mov    %edx,%ebx
  800ce3:	89 d7                	mov    %edx,%edi
  800ce5:	89 d6                	mov    %edx,%esi
  800ce7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ce9:	5b                   	pop    %ebx
  800cea:	5e                   	pop    %esi
  800ceb:	5f                   	pop    %edi
  800cec:	5d                   	pop    %ebp
  800ced:	c3                   	ret    

00800cee <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cee:	f3 0f 1e fb          	endbr32 
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	57                   	push   %edi
  800cf6:	56                   	push   %esi
  800cf7:	53                   	push   %ebx
  800cf8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d00:	8b 55 08             	mov    0x8(%ebp),%edx
  800d03:	b8 03 00 00 00       	mov    $0x3,%eax
  800d08:	89 cb                	mov    %ecx,%ebx
  800d0a:	89 cf                	mov    %ecx,%edi
  800d0c:	89 ce                	mov    %ecx,%esi
  800d0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d10:	85 c0                	test   %eax,%eax
  800d12:	7f 08                	jg     800d1c <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d17:	5b                   	pop    %ebx
  800d18:	5e                   	pop    %esi
  800d19:	5f                   	pop    %edi
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1c:	83 ec 0c             	sub    $0xc,%esp
  800d1f:	50                   	push   %eax
  800d20:	6a 03                	push   $0x3
  800d22:	68 5f 24 80 00       	push   $0x80245f
  800d27:	6a 23                	push   $0x23
  800d29:	68 7c 24 80 00       	push   $0x80247c
  800d2e:	e8 13 f5 ff ff       	call   800246 <_panic>

00800d33 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d33:	f3 0f 1e fb          	endbr32 
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	57                   	push   %edi
  800d3b:	56                   	push   %esi
  800d3c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d42:	b8 02 00 00 00       	mov    $0x2,%eax
  800d47:	89 d1                	mov    %edx,%ecx
  800d49:	89 d3                	mov    %edx,%ebx
  800d4b:	89 d7                	mov    %edx,%edi
  800d4d:	89 d6                	mov    %edx,%esi
  800d4f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d51:	5b                   	pop    %ebx
  800d52:	5e                   	pop    %esi
  800d53:	5f                   	pop    %edi
  800d54:	5d                   	pop    %ebp
  800d55:	c3                   	ret    

00800d56 <sys_yield>:

void
sys_yield(void)
{
  800d56:	f3 0f 1e fb          	endbr32 
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	57                   	push   %edi
  800d5e:	56                   	push   %esi
  800d5f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d60:	ba 00 00 00 00       	mov    $0x0,%edx
  800d65:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d6a:	89 d1                	mov    %edx,%ecx
  800d6c:	89 d3                	mov    %edx,%ebx
  800d6e:	89 d7                	mov    %edx,%edi
  800d70:	89 d6                	mov    %edx,%esi
  800d72:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d74:	5b                   	pop    %ebx
  800d75:	5e                   	pop    %esi
  800d76:	5f                   	pop    %edi
  800d77:	5d                   	pop    %ebp
  800d78:	c3                   	ret    

00800d79 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d79:	f3 0f 1e fb          	endbr32 
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	57                   	push   %edi
  800d81:	56                   	push   %esi
  800d82:	53                   	push   %ebx
  800d83:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d86:	be 00 00 00 00       	mov    $0x0,%esi
  800d8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d91:	b8 04 00 00 00       	mov    $0x4,%eax
  800d96:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d99:	89 f7                	mov    %esi,%edi
  800d9b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9d:	85 c0                	test   %eax,%eax
  800d9f:	7f 08                	jg     800da9 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da4:	5b                   	pop    %ebx
  800da5:	5e                   	pop    %esi
  800da6:	5f                   	pop    %edi
  800da7:	5d                   	pop    %ebp
  800da8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da9:	83 ec 0c             	sub    $0xc,%esp
  800dac:	50                   	push   %eax
  800dad:	6a 04                	push   $0x4
  800daf:	68 5f 24 80 00       	push   $0x80245f
  800db4:	6a 23                	push   $0x23
  800db6:	68 7c 24 80 00       	push   $0x80247c
  800dbb:	e8 86 f4 ff ff       	call   800246 <_panic>

00800dc0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dc0:	f3 0f 1e fb          	endbr32 
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	57                   	push   %edi
  800dc8:	56                   	push   %esi
  800dc9:	53                   	push   %ebx
  800dca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd3:	b8 05 00 00 00       	mov    $0x5,%eax
  800dd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ddb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dde:	8b 75 18             	mov    0x18(%ebp),%esi
  800de1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de3:	85 c0                	test   %eax,%eax
  800de5:	7f 08                	jg     800def <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800de7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dea:	5b                   	pop    %ebx
  800deb:	5e                   	pop    %esi
  800dec:	5f                   	pop    %edi
  800ded:	5d                   	pop    %ebp
  800dee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800def:	83 ec 0c             	sub    $0xc,%esp
  800df2:	50                   	push   %eax
  800df3:	6a 05                	push   $0x5
  800df5:	68 5f 24 80 00       	push   $0x80245f
  800dfa:	6a 23                	push   $0x23
  800dfc:	68 7c 24 80 00       	push   $0x80247c
  800e01:	e8 40 f4 ff ff       	call   800246 <_panic>

00800e06 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e06:	f3 0f 1e fb          	endbr32 
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	57                   	push   %edi
  800e0e:	56                   	push   %esi
  800e0f:	53                   	push   %ebx
  800e10:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e13:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e18:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1e:	b8 06 00 00 00       	mov    $0x6,%eax
  800e23:	89 df                	mov    %ebx,%edi
  800e25:	89 de                	mov    %ebx,%esi
  800e27:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e29:	85 c0                	test   %eax,%eax
  800e2b:	7f 08                	jg     800e35 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e30:	5b                   	pop    %ebx
  800e31:	5e                   	pop    %esi
  800e32:	5f                   	pop    %edi
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e35:	83 ec 0c             	sub    $0xc,%esp
  800e38:	50                   	push   %eax
  800e39:	6a 06                	push   $0x6
  800e3b:	68 5f 24 80 00       	push   $0x80245f
  800e40:	6a 23                	push   $0x23
  800e42:	68 7c 24 80 00       	push   $0x80247c
  800e47:	e8 fa f3 ff ff       	call   800246 <_panic>

00800e4c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e4c:	f3 0f 1e fb          	endbr32 
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	57                   	push   %edi
  800e54:	56                   	push   %esi
  800e55:	53                   	push   %ebx
  800e56:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e59:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e64:	b8 08 00 00 00       	mov    $0x8,%eax
  800e69:	89 df                	mov    %ebx,%edi
  800e6b:	89 de                	mov    %ebx,%esi
  800e6d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	7f 08                	jg     800e7b <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e76:	5b                   	pop    %ebx
  800e77:	5e                   	pop    %esi
  800e78:	5f                   	pop    %edi
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7b:	83 ec 0c             	sub    $0xc,%esp
  800e7e:	50                   	push   %eax
  800e7f:	6a 08                	push   $0x8
  800e81:	68 5f 24 80 00       	push   $0x80245f
  800e86:	6a 23                	push   $0x23
  800e88:	68 7c 24 80 00       	push   $0x80247c
  800e8d:	e8 b4 f3 ff ff       	call   800246 <_panic>

00800e92 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e92:	f3 0f 1e fb          	endbr32 
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	57                   	push   %edi
  800e9a:	56                   	push   %esi
  800e9b:	53                   	push   %ebx
  800e9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eaa:	b8 09 00 00 00       	mov    $0x9,%eax
  800eaf:	89 df                	mov    %ebx,%edi
  800eb1:	89 de                	mov    %ebx,%esi
  800eb3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	7f 08                	jg     800ec1 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebc:	5b                   	pop    %ebx
  800ebd:	5e                   	pop    %esi
  800ebe:	5f                   	pop    %edi
  800ebf:	5d                   	pop    %ebp
  800ec0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec1:	83 ec 0c             	sub    $0xc,%esp
  800ec4:	50                   	push   %eax
  800ec5:	6a 09                	push   $0x9
  800ec7:	68 5f 24 80 00       	push   $0x80245f
  800ecc:	6a 23                	push   $0x23
  800ece:	68 7c 24 80 00       	push   $0x80247c
  800ed3:	e8 6e f3 ff ff       	call   800246 <_panic>

00800ed8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ed8:	f3 0f 1e fb          	endbr32 
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	57                   	push   %edi
  800ee0:	56                   	push   %esi
  800ee1:	53                   	push   %ebx
  800ee2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eea:	8b 55 08             	mov    0x8(%ebp),%edx
  800eed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ef5:	89 df                	mov    %ebx,%edi
  800ef7:	89 de                	mov    %ebx,%esi
  800ef9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800efb:	85 c0                	test   %eax,%eax
  800efd:	7f 08                	jg     800f07 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f02:	5b                   	pop    %ebx
  800f03:	5e                   	pop    %esi
  800f04:	5f                   	pop    %edi
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f07:	83 ec 0c             	sub    $0xc,%esp
  800f0a:	50                   	push   %eax
  800f0b:	6a 0a                	push   $0xa
  800f0d:	68 5f 24 80 00       	push   $0x80245f
  800f12:	6a 23                	push   $0x23
  800f14:	68 7c 24 80 00       	push   $0x80247c
  800f19:	e8 28 f3 ff ff       	call   800246 <_panic>

00800f1e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f1e:	f3 0f 1e fb          	endbr32 
  800f22:	55                   	push   %ebp
  800f23:	89 e5                	mov    %esp,%ebp
  800f25:	57                   	push   %edi
  800f26:	56                   	push   %esi
  800f27:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f28:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f33:	be 00 00 00 00       	mov    $0x0,%esi
  800f38:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f3b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f3e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f40:	5b                   	pop    %ebx
  800f41:	5e                   	pop    %esi
  800f42:	5f                   	pop    %edi
  800f43:	5d                   	pop    %ebp
  800f44:	c3                   	ret    

00800f45 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f45:	f3 0f 1e fb          	endbr32 
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
  800f4c:	57                   	push   %edi
  800f4d:	56                   	push   %esi
  800f4e:	53                   	push   %ebx
  800f4f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f52:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f57:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f5f:	89 cb                	mov    %ecx,%ebx
  800f61:	89 cf                	mov    %ecx,%edi
  800f63:	89 ce                	mov    %ecx,%esi
  800f65:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f67:	85 c0                	test   %eax,%eax
  800f69:	7f 08                	jg     800f73 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
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
  800f77:	6a 0d                	push   $0xd
  800f79:	68 5f 24 80 00       	push   $0x80245f
  800f7e:	6a 23                	push   $0x23
  800f80:	68 7c 24 80 00       	push   $0x80247c
  800f85:	e8 bc f2 ff ff       	call   800246 <_panic>

00800f8a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f8a:	f3 0f 1e fb          	endbr32 
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	05 00 00 00 30       	add    $0x30000000,%eax
  800f99:	c1 e8 0c             	shr    $0xc,%eax
}
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    

00800f9e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f9e:	f3 0f 1e fb          	endbr32 
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fb2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fb7:	5d                   	pop    %ebp
  800fb8:	c3                   	ret    

00800fb9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fb9:	f3 0f 1e fb          	endbr32 
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fc5:	89 c2                	mov    %eax,%edx
  800fc7:	c1 ea 16             	shr    $0x16,%edx
  800fca:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fd1:	f6 c2 01             	test   $0x1,%dl
  800fd4:	74 2d                	je     801003 <fd_alloc+0x4a>
  800fd6:	89 c2                	mov    %eax,%edx
  800fd8:	c1 ea 0c             	shr    $0xc,%edx
  800fdb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fe2:	f6 c2 01             	test   $0x1,%dl
  800fe5:	74 1c                	je     801003 <fd_alloc+0x4a>
  800fe7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800fec:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ff1:	75 d2                	jne    800fc5 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800ffc:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801001:	eb 0a                	jmp    80100d <fd_alloc+0x54>
			*fd_store = fd;
  801003:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801006:	89 01                	mov    %eax,(%ecx)
			return 0;
  801008:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80100d:	5d                   	pop    %ebp
  80100e:	c3                   	ret    

0080100f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80100f:	f3 0f 1e fb          	endbr32 
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801019:	83 f8 1f             	cmp    $0x1f,%eax
  80101c:	77 30                	ja     80104e <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80101e:	c1 e0 0c             	shl    $0xc,%eax
  801021:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801026:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80102c:	f6 c2 01             	test   $0x1,%dl
  80102f:	74 24                	je     801055 <fd_lookup+0x46>
  801031:	89 c2                	mov    %eax,%edx
  801033:	c1 ea 0c             	shr    $0xc,%edx
  801036:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80103d:	f6 c2 01             	test   $0x1,%dl
  801040:	74 1a                	je     80105c <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801042:	8b 55 0c             	mov    0xc(%ebp),%edx
  801045:	89 02                	mov    %eax,(%edx)
	return 0;
  801047:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80104c:	5d                   	pop    %ebp
  80104d:	c3                   	ret    
		return -E_INVAL;
  80104e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801053:	eb f7                	jmp    80104c <fd_lookup+0x3d>
		return -E_INVAL;
  801055:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80105a:	eb f0                	jmp    80104c <fd_lookup+0x3d>
  80105c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801061:	eb e9                	jmp    80104c <fd_lookup+0x3d>

00801063 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801063:	f3 0f 1e fb          	endbr32 
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	83 ec 08             	sub    $0x8,%esp
  80106d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801070:	ba 08 25 80 00       	mov    $0x802508,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801075:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80107a:	39 08                	cmp    %ecx,(%eax)
  80107c:	74 33                	je     8010b1 <dev_lookup+0x4e>
  80107e:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801081:	8b 02                	mov    (%edx),%eax
  801083:	85 c0                	test   %eax,%eax
  801085:	75 f3                	jne    80107a <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801087:	a1 04 40 80 00       	mov    0x804004,%eax
  80108c:	8b 40 48             	mov    0x48(%eax),%eax
  80108f:	83 ec 04             	sub    $0x4,%esp
  801092:	51                   	push   %ecx
  801093:	50                   	push   %eax
  801094:	68 8c 24 80 00       	push   $0x80248c
  801099:	e8 8f f2 ff ff       	call   80032d <cprintf>
	*dev = 0;
  80109e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010a7:	83 c4 10             	add    $0x10,%esp
  8010aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010af:	c9                   	leave  
  8010b0:	c3                   	ret    
			*dev = devtab[i];
  8010b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010bb:	eb f2                	jmp    8010af <dev_lookup+0x4c>

008010bd <fd_close>:
{
  8010bd:	f3 0f 1e fb          	endbr32 
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	57                   	push   %edi
  8010c5:	56                   	push   %esi
  8010c6:	53                   	push   %ebx
  8010c7:	83 ec 24             	sub    $0x24,%esp
  8010ca:	8b 75 08             	mov    0x8(%ebp),%esi
  8010cd:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010d3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010d4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010da:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010dd:	50                   	push   %eax
  8010de:	e8 2c ff ff ff       	call   80100f <fd_lookup>
  8010e3:	89 c3                	mov    %eax,%ebx
  8010e5:	83 c4 10             	add    $0x10,%esp
  8010e8:	85 c0                	test   %eax,%eax
  8010ea:	78 05                	js     8010f1 <fd_close+0x34>
	    || fd != fd2)
  8010ec:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8010ef:	74 16                	je     801107 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8010f1:	89 f8                	mov    %edi,%eax
  8010f3:	84 c0                	test   %al,%al
  8010f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fa:	0f 44 d8             	cmove  %eax,%ebx
}
  8010fd:	89 d8                	mov    %ebx,%eax
  8010ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801102:	5b                   	pop    %ebx
  801103:	5e                   	pop    %esi
  801104:	5f                   	pop    %edi
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801107:	83 ec 08             	sub    $0x8,%esp
  80110a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80110d:	50                   	push   %eax
  80110e:	ff 36                	pushl  (%esi)
  801110:	e8 4e ff ff ff       	call   801063 <dev_lookup>
  801115:	89 c3                	mov    %eax,%ebx
  801117:	83 c4 10             	add    $0x10,%esp
  80111a:	85 c0                	test   %eax,%eax
  80111c:	78 1a                	js     801138 <fd_close+0x7b>
		if (dev->dev_close)
  80111e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801121:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801124:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801129:	85 c0                	test   %eax,%eax
  80112b:	74 0b                	je     801138 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80112d:	83 ec 0c             	sub    $0xc,%esp
  801130:	56                   	push   %esi
  801131:	ff d0                	call   *%eax
  801133:	89 c3                	mov    %eax,%ebx
  801135:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801138:	83 ec 08             	sub    $0x8,%esp
  80113b:	56                   	push   %esi
  80113c:	6a 00                	push   $0x0
  80113e:	e8 c3 fc ff ff       	call   800e06 <sys_page_unmap>
	return r;
  801143:	83 c4 10             	add    $0x10,%esp
  801146:	eb b5                	jmp    8010fd <fd_close+0x40>

00801148 <close>:

int
close(int fdnum)
{
  801148:	f3 0f 1e fb          	endbr32 
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801152:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801155:	50                   	push   %eax
  801156:	ff 75 08             	pushl  0x8(%ebp)
  801159:	e8 b1 fe ff ff       	call   80100f <fd_lookup>
  80115e:	83 c4 10             	add    $0x10,%esp
  801161:	85 c0                	test   %eax,%eax
  801163:	79 02                	jns    801167 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801165:	c9                   	leave  
  801166:	c3                   	ret    
		return fd_close(fd, 1);
  801167:	83 ec 08             	sub    $0x8,%esp
  80116a:	6a 01                	push   $0x1
  80116c:	ff 75 f4             	pushl  -0xc(%ebp)
  80116f:	e8 49 ff ff ff       	call   8010bd <fd_close>
  801174:	83 c4 10             	add    $0x10,%esp
  801177:	eb ec                	jmp    801165 <close+0x1d>

00801179 <close_all>:

void
close_all(void)
{
  801179:	f3 0f 1e fb          	endbr32 
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	53                   	push   %ebx
  801181:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801184:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801189:	83 ec 0c             	sub    $0xc,%esp
  80118c:	53                   	push   %ebx
  80118d:	e8 b6 ff ff ff       	call   801148 <close>
	for (i = 0; i < MAXFD; i++)
  801192:	83 c3 01             	add    $0x1,%ebx
  801195:	83 c4 10             	add    $0x10,%esp
  801198:	83 fb 20             	cmp    $0x20,%ebx
  80119b:	75 ec                	jne    801189 <close_all+0x10>
}
  80119d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    

008011a2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011a2:	f3 0f 1e fb          	endbr32 
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	57                   	push   %edi
  8011aa:	56                   	push   %esi
  8011ab:	53                   	push   %ebx
  8011ac:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011af:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011b2:	50                   	push   %eax
  8011b3:	ff 75 08             	pushl  0x8(%ebp)
  8011b6:	e8 54 fe ff ff       	call   80100f <fd_lookup>
  8011bb:	89 c3                	mov    %eax,%ebx
  8011bd:	83 c4 10             	add    $0x10,%esp
  8011c0:	85 c0                	test   %eax,%eax
  8011c2:	0f 88 81 00 00 00    	js     801249 <dup+0xa7>
		return r;
	close(newfdnum);
  8011c8:	83 ec 0c             	sub    $0xc,%esp
  8011cb:	ff 75 0c             	pushl  0xc(%ebp)
  8011ce:	e8 75 ff ff ff       	call   801148 <close>

	newfd = INDEX2FD(newfdnum);
  8011d3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011d6:	c1 e6 0c             	shl    $0xc,%esi
  8011d9:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011df:	83 c4 04             	add    $0x4,%esp
  8011e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011e5:	e8 b4 fd ff ff       	call   800f9e <fd2data>
  8011ea:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011ec:	89 34 24             	mov    %esi,(%esp)
  8011ef:	e8 aa fd ff ff       	call   800f9e <fd2data>
  8011f4:	83 c4 10             	add    $0x10,%esp
  8011f7:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011f9:	89 d8                	mov    %ebx,%eax
  8011fb:	c1 e8 16             	shr    $0x16,%eax
  8011fe:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801205:	a8 01                	test   $0x1,%al
  801207:	74 11                	je     80121a <dup+0x78>
  801209:	89 d8                	mov    %ebx,%eax
  80120b:	c1 e8 0c             	shr    $0xc,%eax
  80120e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801215:	f6 c2 01             	test   $0x1,%dl
  801218:	75 39                	jne    801253 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80121a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80121d:	89 d0                	mov    %edx,%eax
  80121f:	c1 e8 0c             	shr    $0xc,%eax
  801222:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801229:	83 ec 0c             	sub    $0xc,%esp
  80122c:	25 07 0e 00 00       	and    $0xe07,%eax
  801231:	50                   	push   %eax
  801232:	56                   	push   %esi
  801233:	6a 00                	push   $0x0
  801235:	52                   	push   %edx
  801236:	6a 00                	push   $0x0
  801238:	e8 83 fb ff ff       	call   800dc0 <sys_page_map>
  80123d:	89 c3                	mov    %eax,%ebx
  80123f:	83 c4 20             	add    $0x20,%esp
  801242:	85 c0                	test   %eax,%eax
  801244:	78 31                	js     801277 <dup+0xd5>
		goto err;

	return newfdnum;
  801246:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801249:	89 d8                	mov    %ebx,%eax
  80124b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124e:	5b                   	pop    %ebx
  80124f:	5e                   	pop    %esi
  801250:	5f                   	pop    %edi
  801251:	5d                   	pop    %ebp
  801252:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801253:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80125a:	83 ec 0c             	sub    $0xc,%esp
  80125d:	25 07 0e 00 00       	and    $0xe07,%eax
  801262:	50                   	push   %eax
  801263:	57                   	push   %edi
  801264:	6a 00                	push   $0x0
  801266:	53                   	push   %ebx
  801267:	6a 00                	push   $0x0
  801269:	e8 52 fb ff ff       	call   800dc0 <sys_page_map>
  80126e:	89 c3                	mov    %eax,%ebx
  801270:	83 c4 20             	add    $0x20,%esp
  801273:	85 c0                	test   %eax,%eax
  801275:	79 a3                	jns    80121a <dup+0x78>
	sys_page_unmap(0, newfd);
  801277:	83 ec 08             	sub    $0x8,%esp
  80127a:	56                   	push   %esi
  80127b:	6a 00                	push   $0x0
  80127d:	e8 84 fb ff ff       	call   800e06 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801282:	83 c4 08             	add    $0x8,%esp
  801285:	57                   	push   %edi
  801286:	6a 00                	push   $0x0
  801288:	e8 79 fb ff ff       	call   800e06 <sys_page_unmap>
	return r;
  80128d:	83 c4 10             	add    $0x10,%esp
  801290:	eb b7                	jmp    801249 <dup+0xa7>

00801292 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801292:	f3 0f 1e fb          	endbr32 
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	53                   	push   %ebx
  80129a:	83 ec 1c             	sub    $0x1c,%esp
  80129d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a3:	50                   	push   %eax
  8012a4:	53                   	push   %ebx
  8012a5:	e8 65 fd ff ff       	call   80100f <fd_lookup>
  8012aa:	83 c4 10             	add    $0x10,%esp
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	78 3f                	js     8012f0 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b1:	83 ec 08             	sub    $0x8,%esp
  8012b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b7:	50                   	push   %eax
  8012b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012bb:	ff 30                	pushl  (%eax)
  8012bd:	e8 a1 fd ff ff       	call   801063 <dev_lookup>
  8012c2:	83 c4 10             	add    $0x10,%esp
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	78 27                	js     8012f0 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012cc:	8b 42 08             	mov    0x8(%edx),%eax
  8012cf:	83 e0 03             	and    $0x3,%eax
  8012d2:	83 f8 01             	cmp    $0x1,%eax
  8012d5:	74 1e                	je     8012f5 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012da:	8b 40 08             	mov    0x8(%eax),%eax
  8012dd:	85 c0                	test   %eax,%eax
  8012df:	74 35                	je     801316 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012e1:	83 ec 04             	sub    $0x4,%esp
  8012e4:	ff 75 10             	pushl  0x10(%ebp)
  8012e7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ea:	52                   	push   %edx
  8012eb:	ff d0                	call   *%eax
  8012ed:	83 c4 10             	add    $0x10,%esp
}
  8012f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012f5:	a1 04 40 80 00       	mov    0x804004,%eax
  8012fa:	8b 40 48             	mov    0x48(%eax),%eax
  8012fd:	83 ec 04             	sub    $0x4,%esp
  801300:	53                   	push   %ebx
  801301:	50                   	push   %eax
  801302:	68 cd 24 80 00       	push   $0x8024cd
  801307:	e8 21 f0 ff ff       	call   80032d <cprintf>
		return -E_INVAL;
  80130c:	83 c4 10             	add    $0x10,%esp
  80130f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801314:	eb da                	jmp    8012f0 <read+0x5e>
		return -E_NOT_SUPP;
  801316:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80131b:	eb d3                	jmp    8012f0 <read+0x5e>

0080131d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80131d:	f3 0f 1e fb          	endbr32 
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	57                   	push   %edi
  801325:	56                   	push   %esi
  801326:	53                   	push   %ebx
  801327:	83 ec 0c             	sub    $0xc,%esp
  80132a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80132d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801330:	bb 00 00 00 00       	mov    $0x0,%ebx
  801335:	eb 02                	jmp    801339 <readn+0x1c>
  801337:	01 c3                	add    %eax,%ebx
  801339:	39 f3                	cmp    %esi,%ebx
  80133b:	73 21                	jae    80135e <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80133d:	83 ec 04             	sub    $0x4,%esp
  801340:	89 f0                	mov    %esi,%eax
  801342:	29 d8                	sub    %ebx,%eax
  801344:	50                   	push   %eax
  801345:	89 d8                	mov    %ebx,%eax
  801347:	03 45 0c             	add    0xc(%ebp),%eax
  80134a:	50                   	push   %eax
  80134b:	57                   	push   %edi
  80134c:	e8 41 ff ff ff       	call   801292 <read>
		if (m < 0)
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	85 c0                	test   %eax,%eax
  801356:	78 04                	js     80135c <readn+0x3f>
			return m;
		if (m == 0)
  801358:	75 dd                	jne    801337 <readn+0x1a>
  80135a:	eb 02                	jmp    80135e <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80135c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80135e:	89 d8                	mov    %ebx,%eax
  801360:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801363:	5b                   	pop    %ebx
  801364:	5e                   	pop    %esi
  801365:	5f                   	pop    %edi
  801366:	5d                   	pop    %ebp
  801367:	c3                   	ret    

00801368 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801368:	f3 0f 1e fb          	endbr32 
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	53                   	push   %ebx
  801370:	83 ec 1c             	sub    $0x1c,%esp
  801373:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801376:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801379:	50                   	push   %eax
  80137a:	53                   	push   %ebx
  80137b:	e8 8f fc ff ff       	call   80100f <fd_lookup>
  801380:	83 c4 10             	add    $0x10,%esp
  801383:	85 c0                	test   %eax,%eax
  801385:	78 3a                	js     8013c1 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801387:	83 ec 08             	sub    $0x8,%esp
  80138a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80138d:	50                   	push   %eax
  80138e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801391:	ff 30                	pushl  (%eax)
  801393:	e8 cb fc ff ff       	call   801063 <dev_lookup>
  801398:	83 c4 10             	add    $0x10,%esp
  80139b:	85 c0                	test   %eax,%eax
  80139d:	78 22                	js     8013c1 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80139f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013a6:	74 1e                	je     8013c6 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ab:	8b 52 0c             	mov    0xc(%edx),%edx
  8013ae:	85 d2                	test   %edx,%edx
  8013b0:	74 35                	je     8013e7 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013b2:	83 ec 04             	sub    $0x4,%esp
  8013b5:	ff 75 10             	pushl  0x10(%ebp)
  8013b8:	ff 75 0c             	pushl  0xc(%ebp)
  8013bb:	50                   	push   %eax
  8013bc:	ff d2                	call   *%edx
  8013be:	83 c4 10             	add    $0x10,%esp
}
  8013c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013c6:	a1 04 40 80 00       	mov    0x804004,%eax
  8013cb:	8b 40 48             	mov    0x48(%eax),%eax
  8013ce:	83 ec 04             	sub    $0x4,%esp
  8013d1:	53                   	push   %ebx
  8013d2:	50                   	push   %eax
  8013d3:	68 e9 24 80 00       	push   $0x8024e9
  8013d8:	e8 50 ef ff ff       	call   80032d <cprintf>
		return -E_INVAL;
  8013dd:	83 c4 10             	add    $0x10,%esp
  8013e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e5:	eb da                	jmp    8013c1 <write+0x59>
		return -E_NOT_SUPP;
  8013e7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013ec:	eb d3                	jmp    8013c1 <write+0x59>

008013ee <seek>:

int
seek(int fdnum, off_t offset)
{
  8013ee:	f3 0f 1e fb          	endbr32 
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
  8013f5:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013fb:	50                   	push   %eax
  8013fc:	ff 75 08             	pushl  0x8(%ebp)
  8013ff:	e8 0b fc ff ff       	call   80100f <fd_lookup>
  801404:	83 c4 10             	add    $0x10,%esp
  801407:	85 c0                	test   %eax,%eax
  801409:	78 0e                	js     801419 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80140b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80140e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801411:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801414:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80141b:	f3 0f 1e fb          	endbr32 
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	53                   	push   %ebx
  801423:	83 ec 1c             	sub    $0x1c,%esp
  801426:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801429:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80142c:	50                   	push   %eax
  80142d:	53                   	push   %ebx
  80142e:	e8 dc fb ff ff       	call   80100f <fd_lookup>
  801433:	83 c4 10             	add    $0x10,%esp
  801436:	85 c0                	test   %eax,%eax
  801438:	78 37                	js     801471 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80143a:	83 ec 08             	sub    $0x8,%esp
  80143d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801440:	50                   	push   %eax
  801441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801444:	ff 30                	pushl  (%eax)
  801446:	e8 18 fc ff ff       	call   801063 <dev_lookup>
  80144b:	83 c4 10             	add    $0x10,%esp
  80144e:	85 c0                	test   %eax,%eax
  801450:	78 1f                	js     801471 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801455:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801459:	74 1b                	je     801476 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80145b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80145e:	8b 52 18             	mov    0x18(%edx),%edx
  801461:	85 d2                	test   %edx,%edx
  801463:	74 32                	je     801497 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801465:	83 ec 08             	sub    $0x8,%esp
  801468:	ff 75 0c             	pushl  0xc(%ebp)
  80146b:	50                   	push   %eax
  80146c:	ff d2                	call   *%edx
  80146e:	83 c4 10             	add    $0x10,%esp
}
  801471:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801474:	c9                   	leave  
  801475:	c3                   	ret    
			thisenv->env_id, fdnum);
  801476:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80147b:	8b 40 48             	mov    0x48(%eax),%eax
  80147e:	83 ec 04             	sub    $0x4,%esp
  801481:	53                   	push   %ebx
  801482:	50                   	push   %eax
  801483:	68 ac 24 80 00       	push   $0x8024ac
  801488:	e8 a0 ee ff ff       	call   80032d <cprintf>
		return -E_INVAL;
  80148d:	83 c4 10             	add    $0x10,%esp
  801490:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801495:	eb da                	jmp    801471 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801497:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80149c:	eb d3                	jmp    801471 <ftruncate+0x56>

0080149e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80149e:	f3 0f 1e fb          	endbr32 
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	53                   	push   %ebx
  8014a6:	83 ec 1c             	sub    $0x1c,%esp
  8014a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014af:	50                   	push   %eax
  8014b0:	ff 75 08             	pushl  0x8(%ebp)
  8014b3:	e8 57 fb ff ff       	call   80100f <fd_lookup>
  8014b8:	83 c4 10             	add    $0x10,%esp
  8014bb:	85 c0                	test   %eax,%eax
  8014bd:	78 4b                	js     80150a <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014bf:	83 ec 08             	sub    $0x8,%esp
  8014c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c5:	50                   	push   %eax
  8014c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c9:	ff 30                	pushl  (%eax)
  8014cb:	e8 93 fb ff ff       	call   801063 <dev_lookup>
  8014d0:	83 c4 10             	add    $0x10,%esp
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	78 33                	js     80150a <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8014d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014da:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014de:	74 2f                	je     80150f <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014e0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014e3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014ea:	00 00 00 
	stat->st_isdir = 0;
  8014ed:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014f4:	00 00 00 
	stat->st_dev = dev;
  8014f7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014fd:	83 ec 08             	sub    $0x8,%esp
  801500:	53                   	push   %ebx
  801501:	ff 75 f0             	pushl  -0x10(%ebp)
  801504:	ff 50 14             	call   *0x14(%eax)
  801507:	83 c4 10             	add    $0x10,%esp
}
  80150a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    
		return -E_NOT_SUPP;
  80150f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801514:	eb f4                	jmp    80150a <fstat+0x6c>

00801516 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801516:	f3 0f 1e fb          	endbr32 
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	56                   	push   %esi
  80151e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80151f:	83 ec 08             	sub    $0x8,%esp
  801522:	6a 00                	push   $0x0
  801524:	ff 75 08             	pushl  0x8(%ebp)
  801527:	e8 fb 01 00 00       	call   801727 <open>
  80152c:	89 c3                	mov    %eax,%ebx
  80152e:	83 c4 10             	add    $0x10,%esp
  801531:	85 c0                	test   %eax,%eax
  801533:	78 1b                	js     801550 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801535:	83 ec 08             	sub    $0x8,%esp
  801538:	ff 75 0c             	pushl  0xc(%ebp)
  80153b:	50                   	push   %eax
  80153c:	e8 5d ff ff ff       	call   80149e <fstat>
  801541:	89 c6                	mov    %eax,%esi
	close(fd);
  801543:	89 1c 24             	mov    %ebx,(%esp)
  801546:	e8 fd fb ff ff       	call   801148 <close>
	return r;
  80154b:	83 c4 10             	add    $0x10,%esp
  80154e:	89 f3                	mov    %esi,%ebx
}
  801550:	89 d8                	mov    %ebx,%eax
  801552:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801555:	5b                   	pop    %ebx
  801556:	5e                   	pop    %esi
  801557:	5d                   	pop    %ebp
  801558:	c3                   	ret    

00801559 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
  80155c:	56                   	push   %esi
  80155d:	53                   	push   %ebx
  80155e:	89 c6                	mov    %eax,%esi
  801560:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801562:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801569:	74 27                	je     801592 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80156b:	6a 07                	push   $0x7
  80156d:	68 00 50 80 00       	push   $0x805000
  801572:	56                   	push   %esi
  801573:	ff 35 00 40 80 00    	pushl  0x804000
  801579:	e8 d6 07 00 00       	call   801d54 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80157e:	83 c4 0c             	add    $0xc,%esp
  801581:	6a 00                	push   $0x0
  801583:	53                   	push   %ebx
  801584:	6a 00                	push   $0x0
  801586:	e8 44 07 00 00       	call   801ccf <ipc_recv>
}
  80158b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80158e:	5b                   	pop    %ebx
  80158f:	5e                   	pop    %esi
  801590:	5d                   	pop    %ebp
  801591:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801592:	83 ec 0c             	sub    $0xc,%esp
  801595:	6a 01                	push   $0x1
  801597:	e8 10 08 00 00       	call   801dac <ipc_find_env>
  80159c:	a3 00 40 80 00       	mov    %eax,0x804000
  8015a1:	83 c4 10             	add    $0x10,%esp
  8015a4:	eb c5                	jmp    80156b <fsipc+0x12>

008015a6 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015a6:	f3 0f 1e fb          	endbr32 
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8015b6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015be:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c8:	b8 02 00 00 00       	mov    $0x2,%eax
  8015cd:	e8 87 ff ff ff       	call   801559 <fsipc>
}
  8015d2:	c9                   	leave  
  8015d3:	c3                   	ret    

008015d4 <devfile_flush>:
{
  8015d4:	f3 0f 1e fb          	endbr32 
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e4:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ee:	b8 06 00 00 00       	mov    $0x6,%eax
  8015f3:	e8 61 ff ff ff       	call   801559 <fsipc>
}
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <devfile_stat>:
{
  8015fa:	f3 0f 1e fb          	endbr32 
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	53                   	push   %ebx
  801602:	83 ec 04             	sub    $0x4,%esp
  801605:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	8b 40 0c             	mov    0xc(%eax),%eax
  80160e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801613:	ba 00 00 00 00       	mov    $0x0,%edx
  801618:	b8 05 00 00 00       	mov    $0x5,%eax
  80161d:	e8 37 ff ff ff       	call   801559 <fsipc>
  801622:	85 c0                	test   %eax,%eax
  801624:	78 2c                	js     801652 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801626:	83 ec 08             	sub    $0x8,%esp
  801629:	68 00 50 80 00       	push   $0x805000
  80162e:	53                   	push   %ebx
  80162f:	e8 03 f3 ff ff       	call   800937 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801634:	a1 80 50 80 00       	mov    0x805080,%eax
  801639:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80163f:	a1 84 50 80 00       	mov    0x805084,%eax
  801644:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80164a:	83 c4 10             	add    $0x10,%esp
  80164d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801652:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <devfile_write>:
{
  801657:	f3 0f 1e fb          	endbr32 
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	83 ec 0c             	sub    $0xc,%esp
  801661:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801664:	8b 55 08             	mov    0x8(%ebp),%edx
  801667:	8b 52 0c             	mov    0xc(%edx),%edx
  80166a:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801670:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801675:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80167a:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  80167d:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801682:	50                   	push   %eax
  801683:	ff 75 0c             	pushl  0xc(%ebp)
  801686:	68 08 50 80 00       	push   $0x805008
  80168b:	e8 5d f4 ff ff       	call   800aed <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801690:	ba 00 00 00 00       	mov    $0x0,%edx
  801695:	b8 04 00 00 00       	mov    $0x4,%eax
  80169a:	e8 ba fe ff ff       	call   801559 <fsipc>
}
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    

008016a1 <devfile_read>:
{
  8016a1:	f3 0f 1e fb          	endbr32 
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	56                   	push   %esi
  8016a9:	53                   	push   %ebx
  8016aa:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016b8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016be:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c3:	b8 03 00 00 00       	mov    $0x3,%eax
  8016c8:	e8 8c fe ff ff       	call   801559 <fsipc>
  8016cd:	89 c3                	mov    %eax,%ebx
  8016cf:	85 c0                	test   %eax,%eax
  8016d1:	78 1f                	js     8016f2 <devfile_read+0x51>
	assert(r <= n);
  8016d3:	39 f0                	cmp    %esi,%eax
  8016d5:	77 24                	ja     8016fb <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8016d7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016dc:	7f 33                	jg     801711 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016de:	83 ec 04             	sub    $0x4,%esp
  8016e1:	50                   	push   %eax
  8016e2:	68 00 50 80 00       	push   $0x805000
  8016e7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ea:	e8 fe f3 ff ff       	call   800aed <memmove>
	return r;
  8016ef:	83 c4 10             	add    $0x10,%esp
}
  8016f2:	89 d8                	mov    %ebx,%eax
  8016f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f7:	5b                   	pop    %ebx
  8016f8:	5e                   	pop    %esi
  8016f9:	5d                   	pop    %ebp
  8016fa:	c3                   	ret    
	assert(r <= n);
  8016fb:	68 18 25 80 00       	push   $0x802518
  801700:	68 1f 25 80 00       	push   $0x80251f
  801705:	6a 7c                	push   $0x7c
  801707:	68 34 25 80 00       	push   $0x802534
  80170c:	e8 35 eb ff ff       	call   800246 <_panic>
	assert(r <= PGSIZE);
  801711:	68 3f 25 80 00       	push   $0x80253f
  801716:	68 1f 25 80 00       	push   $0x80251f
  80171b:	6a 7d                	push   $0x7d
  80171d:	68 34 25 80 00       	push   $0x802534
  801722:	e8 1f eb ff ff       	call   800246 <_panic>

00801727 <open>:
{
  801727:	f3 0f 1e fb          	endbr32 
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	56                   	push   %esi
  80172f:	53                   	push   %ebx
  801730:	83 ec 1c             	sub    $0x1c,%esp
  801733:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801736:	56                   	push   %esi
  801737:	e8 b8 f1 ff ff       	call   8008f4 <strlen>
  80173c:	83 c4 10             	add    $0x10,%esp
  80173f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801744:	7f 6c                	jg     8017b2 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801746:	83 ec 0c             	sub    $0xc,%esp
  801749:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80174c:	50                   	push   %eax
  80174d:	e8 67 f8 ff ff       	call   800fb9 <fd_alloc>
  801752:	89 c3                	mov    %eax,%ebx
  801754:	83 c4 10             	add    $0x10,%esp
  801757:	85 c0                	test   %eax,%eax
  801759:	78 3c                	js     801797 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  80175b:	83 ec 08             	sub    $0x8,%esp
  80175e:	56                   	push   %esi
  80175f:	68 00 50 80 00       	push   $0x805000
  801764:	e8 ce f1 ff ff       	call   800937 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801769:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801771:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801774:	b8 01 00 00 00       	mov    $0x1,%eax
  801779:	e8 db fd ff ff       	call   801559 <fsipc>
  80177e:	89 c3                	mov    %eax,%ebx
  801780:	83 c4 10             	add    $0x10,%esp
  801783:	85 c0                	test   %eax,%eax
  801785:	78 19                	js     8017a0 <open+0x79>
	return fd2num(fd);
  801787:	83 ec 0c             	sub    $0xc,%esp
  80178a:	ff 75 f4             	pushl  -0xc(%ebp)
  80178d:	e8 f8 f7 ff ff       	call   800f8a <fd2num>
  801792:	89 c3                	mov    %eax,%ebx
  801794:	83 c4 10             	add    $0x10,%esp
}
  801797:	89 d8                	mov    %ebx,%eax
  801799:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80179c:	5b                   	pop    %ebx
  80179d:	5e                   	pop    %esi
  80179e:	5d                   	pop    %ebp
  80179f:	c3                   	ret    
		fd_close(fd, 0);
  8017a0:	83 ec 08             	sub    $0x8,%esp
  8017a3:	6a 00                	push   $0x0
  8017a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a8:	e8 10 f9 ff ff       	call   8010bd <fd_close>
		return r;
  8017ad:	83 c4 10             	add    $0x10,%esp
  8017b0:	eb e5                	jmp    801797 <open+0x70>
		return -E_BAD_PATH;
  8017b2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017b7:	eb de                	jmp    801797 <open+0x70>

008017b9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017b9:	f3 0f 1e fb          	endbr32 
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
  8017c0:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c8:	b8 08 00 00 00       	mov    $0x8,%eax
  8017cd:	e8 87 fd ff ff       	call   801559 <fsipc>
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8017d4:	f3 0f 1e fb          	endbr32 
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	56                   	push   %esi
  8017dc:	53                   	push   %ebx
  8017dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8017e0:	83 ec 0c             	sub    $0xc,%esp
  8017e3:	ff 75 08             	pushl  0x8(%ebp)
  8017e6:	e8 b3 f7 ff ff       	call   800f9e <fd2data>
  8017eb:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8017ed:	83 c4 08             	add    $0x8,%esp
  8017f0:	68 4b 25 80 00       	push   $0x80254b
  8017f5:	53                   	push   %ebx
  8017f6:	e8 3c f1 ff ff       	call   800937 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8017fb:	8b 46 04             	mov    0x4(%esi),%eax
  8017fe:	2b 06                	sub    (%esi),%eax
  801800:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801806:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80180d:	00 00 00 
	stat->st_dev = &devpipe;
  801810:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801817:	30 80 00 
	return 0;
}
  80181a:	b8 00 00 00 00       	mov    $0x0,%eax
  80181f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801822:	5b                   	pop    %ebx
  801823:	5e                   	pop    %esi
  801824:	5d                   	pop    %ebp
  801825:	c3                   	ret    

00801826 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801826:	f3 0f 1e fb          	endbr32 
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	53                   	push   %ebx
  80182e:	83 ec 0c             	sub    $0xc,%esp
  801831:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801834:	53                   	push   %ebx
  801835:	6a 00                	push   $0x0
  801837:	e8 ca f5 ff ff       	call   800e06 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80183c:	89 1c 24             	mov    %ebx,(%esp)
  80183f:	e8 5a f7 ff ff       	call   800f9e <fd2data>
  801844:	83 c4 08             	add    $0x8,%esp
  801847:	50                   	push   %eax
  801848:	6a 00                	push   $0x0
  80184a:	e8 b7 f5 ff ff       	call   800e06 <sys_page_unmap>
}
  80184f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <_pipeisclosed>:
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	57                   	push   %edi
  801858:	56                   	push   %esi
  801859:	53                   	push   %ebx
  80185a:	83 ec 1c             	sub    $0x1c,%esp
  80185d:	89 c7                	mov    %eax,%edi
  80185f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801861:	a1 04 40 80 00       	mov    0x804004,%eax
  801866:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801869:	83 ec 0c             	sub    $0xc,%esp
  80186c:	57                   	push   %edi
  80186d:	e8 77 05 00 00       	call   801de9 <pageref>
  801872:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801875:	89 34 24             	mov    %esi,(%esp)
  801878:	e8 6c 05 00 00       	call   801de9 <pageref>
		nn = thisenv->env_runs;
  80187d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801883:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801886:	83 c4 10             	add    $0x10,%esp
  801889:	39 cb                	cmp    %ecx,%ebx
  80188b:	74 1b                	je     8018a8 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80188d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801890:	75 cf                	jne    801861 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801892:	8b 42 58             	mov    0x58(%edx),%eax
  801895:	6a 01                	push   $0x1
  801897:	50                   	push   %eax
  801898:	53                   	push   %ebx
  801899:	68 52 25 80 00       	push   $0x802552
  80189e:	e8 8a ea ff ff       	call   80032d <cprintf>
  8018a3:	83 c4 10             	add    $0x10,%esp
  8018a6:	eb b9                	jmp    801861 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8018a8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8018ab:	0f 94 c0             	sete   %al
  8018ae:	0f b6 c0             	movzbl %al,%eax
}
  8018b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018b4:	5b                   	pop    %ebx
  8018b5:	5e                   	pop    %esi
  8018b6:	5f                   	pop    %edi
  8018b7:	5d                   	pop    %ebp
  8018b8:	c3                   	ret    

008018b9 <devpipe_write>:
{
  8018b9:	f3 0f 1e fb          	endbr32 
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
  8018c0:	57                   	push   %edi
  8018c1:	56                   	push   %esi
  8018c2:	53                   	push   %ebx
  8018c3:	83 ec 28             	sub    $0x28,%esp
  8018c6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8018c9:	56                   	push   %esi
  8018ca:	e8 cf f6 ff ff       	call   800f9e <fd2data>
  8018cf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8018d1:	83 c4 10             	add    $0x10,%esp
  8018d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8018d9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8018dc:	74 4f                	je     80192d <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8018de:	8b 43 04             	mov    0x4(%ebx),%eax
  8018e1:	8b 0b                	mov    (%ebx),%ecx
  8018e3:	8d 51 20             	lea    0x20(%ecx),%edx
  8018e6:	39 d0                	cmp    %edx,%eax
  8018e8:	72 14                	jb     8018fe <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8018ea:	89 da                	mov    %ebx,%edx
  8018ec:	89 f0                	mov    %esi,%eax
  8018ee:	e8 61 ff ff ff       	call   801854 <_pipeisclosed>
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	75 3b                	jne    801932 <devpipe_write+0x79>
			sys_yield();
  8018f7:	e8 5a f4 ff ff       	call   800d56 <sys_yield>
  8018fc:	eb e0                	jmp    8018de <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8018fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801901:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801905:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801908:	89 c2                	mov    %eax,%edx
  80190a:	c1 fa 1f             	sar    $0x1f,%edx
  80190d:	89 d1                	mov    %edx,%ecx
  80190f:	c1 e9 1b             	shr    $0x1b,%ecx
  801912:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801915:	83 e2 1f             	and    $0x1f,%edx
  801918:	29 ca                	sub    %ecx,%edx
  80191a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80191e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801922:	83 c0 01             	add    $0x1,%eax
  801925:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801928:	83 c7 01             	add    $0x1,%edi
  80192b:	eb ac                	jmp    8018d9 <devpipe_write+0x20>
	return i;
  80192d:	8b 45 10             	mov    0x10(%ebp),%eax
  801930:	eb 05                	jmp    801937 <devpipe_write+0x7e>
				return 0;
  801932:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801937:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80193a:	5b                   	pop    %ebx
  80193b:	5e                   	pop    %esi
  80193c:	5f                   	pop    %edi
  80193d:	5d                   	pop    %ebp
  80193e:	c3                   	ret    

0080193f <devpipe_read>:
{
  80193f:	f3 0f 1e fb          	endbr32 
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	57                   	push   %edi
  801947:	56                   	push   %esi
  801948:	53                   	push   %ebx
  801949:	83 ec 18             	sub    $0x18,%esp
  80194c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80194f:	57                   	push   %edi
  801950:	e8 49 f6 ff ff       	call   800f9e <fd2data>
  801955:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801957:	83 c4 10             	add    $0x10,%esp
  80195a:	be 00 00 00 00       	mov    $0x0,%esi
  80195f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801962:	75 14                	jne    801978 <devpipe_read+0x39>
	return i;
  801964:	8b 45 10             	mov    0x10(%ebp),%eax
  801967:	eb 02                	jmp    80196b <devpipe_read+0x2c>
				return i;
  801969:	89 f0                	mov    %esi,%eax
}
  80196b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80196e:	5b                   	pop    %ebx
  80196f:	5e                   	pop    %esi
  801970:	5f                   	pop    %edi
  801971:	5d                   	pop    %ebp
  801972:	c3                   	ret    
			sys_yield();
  801973:	e8 de f3 ff ff       	call   800d56 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801978:	8b 03                	mov    (%ebx),%eax
  80197a:	3b 43 04             	cmp    0x4(%ebx),%eax
  80197d:	75 18                	jne    801997 <devpipe_read+0x58>
			if (i > 0)
  80197f:	85 f6                	test   %esi,%esi
  801981:	75 e6                	jne    801969 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801983:	89 da                	mov    %ebx,%edx
  801985:	89 f8                	mov    %edi,%eax
  801987:	e8 c8 fe ff ff       	call   801854 <_pipeisclosed>
  80198c:	85 c0                	test   %eax,%eax
  80198e:	74 e3                	je     801973 <devpipe_read+0x34>
				return 0;
  801990:	b8 00 00 00 00       	mov    $0x0,%eax
  801995:	eb d4                	jmp    80196b <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801997:	99                   	cltd   
  801998:	c1 ea 1b             	shr    $0x1b,%edx
  80199b:	01 d0                	add    %edx,%eax
  80199d:	83 e0 1f             	and    $0x1f,%eax
  8019a0:	29 d0                	sub    %edx,%eax
  8019a2:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8019a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019aa:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8019ad:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8019b0:	83 c6 01             	add    $0x1,%esi
  8019b3:	eb aa                	jmp    80195f <devpipe_read+0x20>

008019b5 <pipe>:
{
  8019b5:	f3 0f 1e fb          	endbr32 
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	56                   	push   %esi
  8019bd:	53                   	push   %ebx
  8019be:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8019c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c4:	50                   	push   %eax
  8019c5:	e8 ef f5 ff ff       	call   800fb9 <fd_alloc>
  8019ca:	89 c3                	mov    %eax,%ebx
  8019cc:	83 c4 10             	add    $0x10,%esp
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	0f 88 23 01 00 00    	js     801afa <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019d7:	83 ec 04             	sub    $0x4,%esp
  8019da:	68 07 04 00 00       	push   $0x407
  8019df:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e2:	6a 00                	push   $0x0
  8019e4:	e8 90 f3 ff ff       	call   800d79 <sys_page_alloc>
  8019e9:	89 c3                	mov    %eax,%ebx
  8019eb:	83 c4 10             	add    $0x10,%esp
  8019ee:	85 c0                	test   %eax,%eax
  8019f0:	0f 88 04 01 00 00    	js     801afa <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8019f6:	83 ec 0c             	sub    $0xc,%esp
  8019f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019fc:	50                   	push   %eax
  8019fd:	e8 b7 f5 ff ff       	call   800fb9 <fd_alloc>
  801a02:	89 c3                	mov    %eax,%ebx
  801a04:	83 c4 10             	add    $0x10,%esp
  801a07:	85 c0                	test   %eax,%eax
  801a09:	0f 88 db 00 00 00    	js     801aea <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a0f:	83 ec 04             	sub    $0x4,%esp
  801a12:	68 07 04 00 00       	push   $0x407
  801a17:	ff 75 f0             	pushl  -0x10(%ebp)
  801a1a:	6a 00                	push   $0x0
  801a1c:	e8 58 f3 ff ff       	call   800d79 <sys_page_alloc>
  801a21:	89 c3                	mov    %eax,%ebx
  801a23:	83 c4 10             	add    $0x10,%esp
  801a26:	85 c0                	test   %eax,%eax
  801a28:	0f 88 bc 00 00 00    	js     801aea <pipe+0x135>
	va = fd2data(fd0);
  801a2e:	83 ec 0c             	sub    $0xc,%esp
  801a31:	ff 75 f4             	pushl  -0xc(%ebp)
  801a34:	e8 65 f5 ff ff       	call   800f9e <fd2data>
  801a39:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a3b:	83 c4 0c             	add    $0xc,%esp
  801a3e:	68 07 04 00 00       	push   $0x407
  801a43:	50                   	push   %eax
  801a44:	6a 00                	push   $0x0
  801a46:	e8 2e f3 ff ff       	call   800d79 <sys_page_alloc>
  801a4b:	89 c3                	mov    %eax,%ebx
  801a4d:	83 c4 10             	add    $0x10,%esp
  801a50:	85 c0                	test   %eax,%eax
  801a52:	0f 88 82 00 00 00    	js     801ada <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a58:	83 ec 0c             	sub    $0xc,%esp
  801a5b:	ff 75 f0             	pushl  -0x10(%ebp)
  801a5e:	e8 3b f5 ff ff       	call   800f9e <fd2data>
  801a63:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801a6a:	50                   	push   %eax
  801a6b:	6a 00                	push   $0x0
  801a6d:	56                   	push   %esi
  801a6e:	6a 00                	push   $0x0
  801a70:	e8 4b f3 ff ff       	call   800dc0 <sys_page_map>
  801a75:	89 c3                	mov    %eax,%ebx
  801a77:	83 c4 20             	add    $0x20,%esp
  801a7a:	85 c0                	test   %eax,%eax
  801a7c:	78 4e                	js     801acc <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801a7e:	a1 20 30 80 00       	mov    0x803020,%eax
  801a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a86:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801a88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a8b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801a92:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a95:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801aa1:	83 ec 0c             	sub    $0xc,%esp
  801aa4:	ff 75 f4             	pushl  -0xc(%ebp)
  801aa7:	e8 de f4 ff ff       	call   800f8a <fd2num>
  801aac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aaf:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ab1:	83 c4 04             	add    $0x4,%esp
  801ab4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ab7:	e8 ce f4 ff ff       	call   800f8a <fd2num>
  801abc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801abf:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ac2:	83 c4 10             	add    $0x10,%esp
  801ac5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aca:	eb 2e                	jmp    801afa <pipe+0x145>
	sys_page_unmap(0, va);
  801acc:	83 ec 08             	sub    $0x8,%esp
  801acf:	56                   	push   %esi
  801ad0:	6a 00                	push   $0x0
  801ad2:	e8 2f f3 ff ff       	call   800e06 <sys_page_unmap>
  801ad7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ada:	83 ec 08             	sub    $0x8,%esp
  801add:	ff 75 f0             	pushl  -0x10(%ebp)
  801ae0:	6a 00                	push   $0x0
  801ae2:	e8 1f f3 ff ff       	call   800e06 <sys_page_unmap>
  801ae7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801aea:	83 ec 08             	sub    $0x8,%esp
  801aed:	ff 75 f4             	pushl  -0xc(%ebp)
  801af0:	6a 00                	push   $0x0
  801af2:	e8 0f f3 ff ff       	call   800e06 <sys_page_unmap>
  801af7:	83 c4 10             	add    $0x10,%esp
}
  801afa:	89 d8                	mov    %ebx,%eax
  801afc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aff:	5b                   	pop    %ebx
  801b00:	5e                   	pop    %esi
  801b01:	5d                   	pop    %ebp
  801b02:	c3                   	ret    

00801b03 <pipeisclosed>:
{
  801b03:	f3 0f 1e fb          	endbr32 
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
  801b0a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b10:	50                   	push   %eax
  801b11:	ff 75 08             	pushl  0x8(%ebp)
  801b14:	e8 f6 f4 ff ff       	call   80100f <fd_lookup>
  801b19:	83 c4 10             	add    $0x10,%esp
  801b1c:	85 c0                	test   %eax,%eax
  801b1e:	78 18                	js     801b38 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801b20:	83 ec 0c             	sub    $0xc,%esp
  801b23:	ff 75 f4             	pushl  -0xc(%ebp)
  801b26:	e8 73 f4 ff ff       	call   800f9e <fd2data>
  801b2b:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b30:	e8 1f fd ff ff       	call   801854 <_pipeisclosed>
  801b35:	83 c4 10             	add    $0x10,%esp
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801b3a:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801b3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b43:	c3                   	ret    

00801b44 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801b44:	f3 0f 1e fb          	endbr32 
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801b4e:	68 6a 25 80 00       	push   $0x80256a
  801b53:	ff 75 0c             	pushl  0xc(%ebp)
  801b56:	e8 dc ed ff ff       	call   800937 <strcpy>
	return 0;
}
  801b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <devcons_write>:
{
  801b62:	f3 0f 1e fb          	endbr32 
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	57                   	push   %edi
  801b6a:	56                   	push   %esi
  801b6b:	53                   	push   %ebx
  801b6c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801b72:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801b77:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801b7d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b80:	73 31                	jae    801bb3 <devcons_write+0x51>
		m = n - tot;
  801b82:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b85:	29 f3                	sub    %esi,%ebx
  801b87:	83 fb 7f             	cmp    $0x7f,%ebx
  801b8a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801b8f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801b92:	83 ec 04             	sub    $0x4,%esp
  801b95:	53                   	push   %ebx
  801b96:	89 f0                	mov    %esi,%eax
  801b98:	03 45 0c             	add    0xc(%ebp),%eax
  801b9b:	50                   	push   %eax
  801b9c:	57                   	push   %edi
  801b9d:	e8 4b ef ff ff       	call   800aed <memmove>
		sys_cputs(buf, m);
  801ba2:	83 c4 08             	add    $0x8,%esp
  801ba5:	53                   	push   %ebx
  801ba6:	57                   	push   %edi
  801ba7:	e8 fd f0 ff ff       	call   800ca9 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801bac:	01 de                	add    %ebx,%esi
  801bae:	83 c4 10             	add    $0x10,%esp
  801bb1:	eb ca                	jmp    801b7d <devcons_write+0x1b>
}
  801bb3:	89 f0                	mov    %esi,%eax
  801bb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bb8:	5b                   	pop    %ebx
  801bb9:	5e                   	pop    %esi
  801bba:	5f                   	pop    %edi
  801bbb:	5d                   	pop    %ebp
  801bbc:	c3                   	ret    

00801bbd <devcons_read>:
{
  801bbd:	f3 0f 1e fb          	endbr32 
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	83 ec 08             	sub    $0x8,%esp
  801bc7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801bcc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bd0:	74 21                	je     801bf3 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801bd2:	e8 f4 f0 ff ff       	call   800ccb <sys_cgetc>
  801bd7:	85 c0                	test   %eax,%eax
  801bd9:	75 07                	jne    801be2 <devcons_read+0x25>
		sys_yield();
  801bdb:	e8 76 f1 ff ff       	call   800d56 <sys_yield>
  801be0:	eb f0                	jmp    801bd2 <devcons_read+0x15>
	if (c < 0)
  801be2:	78 0f                	js     801bf3 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801be4:	83 f8 04             	cmp    $0x4,%eax
  801be7:	74 0c                	je     801bf5 <devcons_read+0x38>
	*(char*)vbuf = c;
  801be9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bec:	88 02                	mov    %al,(%edx)
	return 1;
  801bee:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    
		return 0;
  801bf5:	b8 00 00 00 00       	mov    $0x0,%eax
  801bfa:	eb f7                	jmp    801bf3 <devcons_read+0x36>

00801bfc <cputchar>:
{
  801bfc:	f3 0f 1e fb          	endbr32 
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801c0c:	6a 01                	push   $0x1
  801c0e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c11:	50                   	push   %eax
  801c12:	e8 92 f0 ff ff       	call   800ca9 <sys_cputs>
}
  801c17:	83 c4 10             	add    $0x10,%esp
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <getchar>:
{
  801c1c:	f3 0f 1e fb          	endbr32 
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801c26:	6a 01                	push   $0x1
  801c28:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c2b:	50                   	push   %eax
  801c2c:	6a 00                	push   $0x0
  801c2e:	e8 5f f6 ff ff       	call   801292 <read>
	if (r < 0)
  801c33:	83 c4 10             	add    $0x10,%esp
  801c36:	85 c0                	test   %eax,%eax
  801c38:	78 06                	js     801c40 <getchar+0x24>
	if (r < 1)
  801c3a:	74 06                	je     801c42 <getchar+0x26>
	return c;
  801c3c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    
		return -E_EOF;
  801c42:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801c47:	eb f7                	jmp    801c40 <getchar+0x24>

00801c49 <iscons>:
{
  801c49:	f3 0f 1e fb          	endbr32 
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c53:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c56:	50                   	push   %eax
  801c57:	ff 75 08             	pushl  0x8(%ebp)
  801c5a:	e8 b0 f3 ff ff       	call   80100f <fd_lookup>
  801c5f:	83 c4 10             	add    $0x10,%esp
  801c62:	85 c0                	test   %eax,%eax
  801c64:	78 11                	js     801c77 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c69:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c6f:	39 10                	cmp    %edx,(%eax)
  801c71:	0f 94 c0             	sete   %al
  801c74:	0f b6 c0             	movzbl %al,%eax
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <opencons>:
{
  801c79:	f3 0f 1e fb          	endbr32 
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
  801c80:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801c83:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c86:	50                   	push   %eax
  801c87:	e8 2d f3 ff ff       	call   800fb9 <fd_alloc>
  801c8c:	83 c4 10             	add    $0x10,%esp
  801c8f:	85 c0                	test   %eax,%eax
  801c91:	78 3a                	js     801ccd <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c93:	83 ec 04             	sub    $0x4,%esp
  801c96:	68 07 04 00 00       	push   $0x407
  801c9b:	ff 75 f4             	pushl  -0xc(%ebp)
  801c9e:	6a 00                	push   $0x0
  801ca0:	e8 d4 f0 ff ff       	call   800d79 <sys_page_alloc>
  801ca5:	83 c4 10             	add    $0x10,%esp
  801ca8:	85 c0                	test   %eax,%eax
  801caa:	78 21                	js     801ccd <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801caf:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801cb5:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cba:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801cc1:	83 ec 0c             	sub    $0xc,%esp
  801cc4:	50                   	push   %eax
  801cc5:	e8 c0 f2 ff ff       	call   800f8a <fd2num>
  801cca:	83 c4 10             	add    $0x10,%esp
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ccf:	f3 0f 1e fb          	endbr32 
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	56                   	push   %esi
  801cd7:	53                   	push   %ebx
  801cd8:	8b 75 08             	mov    0x8(%ebp),%esi
  801cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cde:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801ce1:	85 c0                	test   %eax,%eax
  801ce3:	74 3d                	je     801d22 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801ce5:	83 ec 0c             	sub    $0xc,%esp
  801ce8:	50                   	push   %eax
  801ce9:	e8 57 f2 ff ff       	call   800f45 <sys_ipc_recv>
  801cee:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801cf1:	85 f6                	test   %esi,%esi
  801cf3:	74 0b                	je     801d00 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801cf5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801cfb:	8b 52 74             	mov    0x74(%edx),%edx
  801cfe:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801d00:	85 db                	test   %ebx,%ebx
  801d02:	74 0b                	je     801d0f <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801d04:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801d0a:	8b 52 78             	mov    0x78(%edx),%edx
  801d0d:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801d0f:	85 c0                	test   %eax,%eax
  801d11:	78 21                	js     801d34 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801d13:	a1 04 40 80 00       	mov    0x804004,%eax
  801d18:	8b 40 70             	mov    0x70(%eax),%eax
}
  801d1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d1e:	5b                   	pop    %ebx
  801d1f:	5e                   	pop    %esi
  801d20:	5d                   	pop    %ebp
  801d21:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801d22:	83 ec 0c             	sub    $0xc,%esp
  801d25:	68 00 00 c0 ee       	push   $0xeec00000
  801d2a:	e8 16 f2 ff ff       	call   800f45 <sys_ipc_recv>
  801d2f:	83 c4 10             	add    $0x10,%esp
  801d32:	eb bd                	jmp    801cf1 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801d34:	85 f6                	test   %esi,%esi
  801d36:	74 10                	je     801d48 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801d38:	85 db                	test   %ebx,%ebx
  801d3a:	75 df                	jne    801d1b <ipc_recv+0x4c>
  801d3c:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801d43:	00 00 00 
  801d46:	eb d3                	jmp    801d1b <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801d48:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801d4f:	00 00 00 
  801d52:	eb e4                	jmp    801d38 <ipc_recv+0x69>

00801d54 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801d54:	f3 0f 1e fb          	endbr32 
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	57                   	push   %edi
  801d5c:	56                   	push   %esi
  801d5d:	53                   	push   %ebx
  801d5e:	83 ec 0c             	sub    $0xc,%esp
  801d61:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d64:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d67:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801d6a:	85 db                	test   %ebx,%ebx
  801d6c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801d71:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801d74:	ff 75 14             	pushl  0x14(%ebp)
  801d77:	53                   	push   %ebx
  801d78:	56                   	push   %esi
  801d79:	57                   	push   %edi
  801d7a:	e8 9f f1 ff ff       	call   800f1e <sys_ipc_try_send>
  801d7f:	83 c4 10             	add    $0x10,%esp
  801d82:	85 c0                	test   %eax,%eax
  801d84:	79 1e                	jns    801da4 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801d86:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d89:	75 07                	jne    801d92 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801d8b:	e8 c6 ef ff ff       	call   800d56 <sys_yield>
  801d90:	eb e2                	jmp    801d74 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801d92:	50                   	push   %eax
  801d93:	68 76 25 80 00       	push   $0x802576
  801d98:	6a 59                	push   $0x59
  801d9a:	68 91 25 80 00       	push   $0x802591
  801d9f:	e8 a2 e4 ff ff       	call   800246 <_panic>
	}
}
  801da4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801da7:	5b                   	pop    %ebx
  801da8:	5e                   	pop    %esi
  801da9:	5f                   	pop    %edi
  801daa:	5d                   	pop    %ebp
  801dab:	c3                   	ret    

00801dac <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801dac:	f3 0f 1e fb          	endbr32 
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801db6:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801dbb:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801dbe:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801dc4:	8b 52 50             	mov    0x50(%edx),%edx
  801dc7:	39 ca                	cmp    %ecx,%edx
  801dc9:	74 11                	je     801ddc <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801dcb:	83 c0 01             	add    $0x1,%eax
  801dce:	3d 00 04 00 00       	cmp    $0x400,%eax
  801dd3:	75 e6                	jne    801dbb <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801dd5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dda:	eb 0b                	jmp    801de7 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801ddc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ddf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801de4:	8b 40 48             	mov    0x48(%eax),%eax
}
  801de7:	5d                   	pop    %ebp
  801de8:	c3                   	ret    

00801de9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801de9:	f3 0f 1e fb          	endbr32 
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801df3:	89 c2                	mov    %eax,%edx
  801df5:	c1 ea 16             	shr    $0x16,%edx
  801df8:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801dff:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801e04:	f6 c1 01             	test   $0x1,%cl
  801e07:	74 1c                	je     801e25 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801e09:	c1 e8 0c             	shr    $0xc,%eax
  801e0c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801e13:	a8 01                	test   $0x1,%al
  801e15:	74 0e                	je     801e25 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e17:	c1 e8 0c             	shr    $0xc,%eax
  801e1a:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801e21:	ef 
  801e22:	0f b7 d2             	movzwl %dx,%edx
}
  801e25:	89 d0                	mov    %edx,%eax
  801e27:	5d                   	pop    %ebp
  801e28:	c3                   	ret    
  801e29:	66 90                	xchg   %ax,%ax
  801e2b:	66 90                	xchg   %ax,%ax
  801e2d:	66 90                	xchg   %ax,%ax
  801e2f:	90                   	nop

00801e30 <__udivdi3>:
  801e30:	f3 0f 1e fb          	endbr32 
  801e34:	55                   	push   %ebp
  801e35:	57                   	push   %edi
  801e36:	56                   	push   %esi
  801e37:	53                   	push   %ebx
  801e38:	83 ec 1c             	sub    $0x1c,%esp
  801e3b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801e3f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801e43:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e47:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801e4b:	85 d2                	test   %edx,%edx
  801e4d:	75 19                	jne    801e68 <__udivdi3+0x38>
  801e4f:	39 f3                	cmp    %esi,%ebx
  801e51:	76 4d                	jbe    801ea0 <__udivdi3+0x70>
  801e53:	31 ff                	xor    %edi,%edi
  801e55:	89 e8                	mov    %ebp,%eax
  801e57:	89 f2                	mov    %esi,%edx
  801e59:	f7 f3                	div    %ebx
  801e5b:	89 fa                	mov    %edi,%edx
  801e5d:	83 c4 1c             	add    $0x1c,%esp
  801e60:	5b                   	pop    %ebx
  801e61:	5e                   	pop    %esi
  801e62:	5f                   	pop    %edi
  801e63:	5d                   	pop    %ebp
  801e64:	c3                   	ret    
  801e65:	8d 76 00             	lea    0x0(%esi),%esi
  801e68:	39 f2                	cmp    %esi,%edx
  801e6a:	76 14                	jbe    801e80 <__udivdi3+0x50>
  801e6c:	31 ff                	xor    %edi,%edi
  801e6e:	31 c0                	xor    %eax,%eax
  801e70:	89 fa                	mov    %edi,%edx
  801e72:	83 c4 1c             	add    $0x1c,%esp
  801e75:	5b                   	pop    %ebx
  801e76:	5e                   	pop    %esi
  801e77:	5f                   	pop    %edi
  801e78:	5d                   	pop    %ebp
  801e79:	c3                   	ret    
  801e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e80:	0f bd fa             	bsr    %edx,%edi
  801e83:	83 f7 1f             	xor    $0x1f,%edi
  801e86:	75 48                	jne    801ed0 <__udivdi3+0xa0>
  801e88:	39 f2                	cmp    %esi,%edx
  801e8a:	72 06                	jb     801e92 <__udivdi3+0x62>
  801e8c:	31 c0                	xor    %eax,%eax
  801e8e:	39 eb                	cmp    %ebp,%ebx
  801e90:	77 de                	ja     801e70 <__udivdi3+0x40>
  801e92:	b8 01 00 00 00       	mov    $0x1,%eax
  801e97:	eb d7                	jmp    801e70 <__udivdi3+0x40>
  801e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ea0:	89 d9                	mov    %ebx,%ecx
  801ea2:	85 db                	test   %ebx,%ebx
  801ea4:	75 0b                	jne    801eb1 <__udivdi3+0x81>
  801ea6:	b8 01 00 00 00       	mov    $0x1,%eax
  801eab:	31 d2                	xor    %edx,%edx
  801ead:	f7 f3                	div    %ebx
  801eaf:	89 c1                	mov    %eax,%ecx
  801eb1:	31 d2                	xor    %edx,%edx
  801eb3:	89 f0                	mov    %esi,%eax
  801eb5:	f7 f1                	div    %ecx
  801eb7:	89 c6                	mov    %eax,%esi
  801eb9:	89 e8                	mov    %ebp,%eax
  801ebb:	89 f7                	mov    %esi,%edi
  801ebd:	f7 f1                	div    %ecx
  801ebf:	89 fa                	mov    %edi,%edx
  801ec1:	83 c4 1c             	add    $0x1c,%esp
  801ec4:	5b                   	pop    %ebx
  801ec5:	5e                   	pop    %esi
  801ec6:	5f                   	pop    %edi
  801ec7:	5d                   	pop    %ebp
  801ec8:	c3                   	ret    
  801ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ed0:	89 f9                	mov    %edi,%ecx
  801ed2:	b8 20 00 00 00       	mov    $0x20,%eax
  801ed7:	29 f8                	sub    %edi,%eax
  801ed9:	d3 e2                	shl    %cl,%edx
  801edb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801edf:	89 c1                	mov    %eax,%ecx
  801ee1:	89 da                	mov    %ebx,%edx
  801ee3:	d3 ea                	shr    %cl,%edx
  801ee5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801ee9:	09 d1                	or     %edx,%ecx
  801eeb:	89 f2                	mov    %esi,%edx
  801eed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ef1:	89 f9                	mov    %edi,%ecx
  801ef3:	d3 e3                	shl    %cl,%ebx
  801ef5:	89 c1                	mov    %eax,%ecx
  801ef7:	d3 ea                	shr    %cl,%edx
  801ef9:	89 f9                	mov    %edi,%ecx
  801efb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801eff:	89 eb                	mov    %ebp,%ebx
  801f01:	d3 e6                	shl    %cl,%esi
  801f03:	89 c1                	mov    %eax,%ecx
  801f05:	d3 eb                	shr    %cl,%ebx
  801f07:	09 de                	or     %ebx,%esi
  801f09:	89 f0                	mov    %esi,%eax
  801f0b:	f7 74 24 08          	divl   0x8(%esp)
  801f0f:	89 d6                	mov    %edx,%esi
  801f11:	89 c3                	mov    %eax,%ebx
  801f13:	f7 64 24 0c          	mull   0xc(%esp)
  801f17:	39 d6                	cmp    %edx,%esi
  801f19:	72 15                	jb     801f30 <__udivdi3+0x100>
  801f1b:	89 f9                	mov    %edi,%ecx
  801f1d:	d3 e5                	shl    %cl,%ebp
  801f1f:	39 c5                	cmp    %eax,%ebp
  801f21:	73 04                	jae    801f27 <__udivdi3+0xf7>
  801f23:	39 d6                	cmp    %edx,%esi
  801f25:	74 09                	je     801f30 <__udivdi3+0x100>
  801f27:	89 d8                	mov    %ebx,%eax
  801f29:	31 ff                	xor    %edi,%edi
  801f2b:	e9 40 ff ff ff       	jmp    801e70 <__udivdi3+0x40>
  801f30:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f33:	31 ff                	xor    %edi,%edi
  801f35:	e9 36 ff ff ff       	jmp    801e70 <__udivdi3+0x40>
  801f3a:	66 90                	xchg   %ax,%ax
  801f3c:	66 90                	xchg   %ax,%ax
  801f3e:	66 90                	xchg   %ax,%ax

00801f40 <__umoddi3>:
  801f40:	f3 0f 1e fb          	endbr32 
  801f44:	55                   	push   %ebp
  801f45:	57                   	push   %edi
  801f46:	56                   	push   %esi
  801f47:	53                   	push   %ebx
  801f48:	83 ec 1c             	sub    $0x1c,%esp
  801f4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f4f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801f53:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801f57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f5b:	85 c0                	test   %eax,%eax
  801f5d:	75 19                	jne    801f78 <__umoddi3+0x38>
  801f5f:	39 df                	cmp    %ebx,%edi
  801f61:	76 5d                	jbe    801fc0 <__umoddi3+0x80>
  801f63:	89 f0                	mov    %esi,%eax
  801f65:	89 da                	mov    %ebx,%edx
  801f67:	f7 f7                	div    %edi
  801f69:	89 d0                	mov    %edx,%eax
  801f6b:	31 d2                	xor    %edx,%edx
  801f6d:	83 c4 1c             	add    $0x1c,%esp
  801f70:	5b                   	pop    %ebx
  801f71:	5e                   	pop    %esi
  801f72:	5f                   	pop    %edi
  801f73:	5d                   	pop    %ebp
  801f74:	c3                   	ret    
  801f75:	8d 76 00             	lea    0x0(%esi),%esi
  801f78:	89 f2                	mov    %esi,%edx
  801f7a:	39 d8                	cmp    %ebx,%eax
  801f7c:	76 12                	jbe    801f90 <__umoddi3+0x50>
  801f7e:	89 f0                	mov    %esi,%eax
  801f80:	89 da                	mov    %ebx,%edx
  801f82:	83 c4 1c             	add    $0x1c,%esp
  801f85:	5b                   	pop    %ebx
  801f86:	5e                   	pop    %esi
  801f87:	5f                   	pop    %edi
  801f88:	5d                   	pop    %ebp
  801f89:	c3                   	ret    
  801f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f90:	0f bd e8             	bsr    %eax,%ebp
  801f93:	83 f5 1f             	xor    $0x1f,%ebp
  801f96:	75 50                	jne    801fe8 <__umoddi3+0xa8>
  801f98:	39 d8                	cmp    %ebx,%eax
  801f9a:	0f 82 e0 00 00 00    	jb     802080 <__umoddi3+0x140>
  801fa0:	89 d9                	mov    %ebx,%ecx
  801fa2:	39 f7                	cmp    %esi,%edi
  801fa4:	0f 86 d6 00 00 00    	jbe    802080 <__umoddi3+0x140>
  801faa:	89 d0                	mov    %edx,%eax
  801fac:	89 ca                	mov    %ecx,%edx
  801fae:	83 c4 1c             	add    $0x1c,%esp
  801fb1:	5b                   	pop    %ebx
  801fb2:	5e                   	pop    %esi
  801fb3:	5f                   	pop    %edi
  801fb4:	5d                   	pop    %ebp
  801fb5:	c3                   	ret    
  801fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fbd:	8d 76 00             	lea    0x0(%esi),%esi
  801fc0:	89 fd                	mov    %edi,%ebp
  801fc2:	85 ff                	test   %edi,%edi
  801fc4:	75 0b                	jne    801fd1 <__umoddi3+0x91>
  801fc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801fcb:	31 d2                	xor    %edx,%edx
  801fcd:	f7 f7                	div    %edi
  801fcf:	89 c5                	mov    %eax,%ebp
  801fd1:	89 d8                	mov    %ebx,%eax
  801fd3:	31 d2                	xor    %edx,%edx
  801fd5:	f7 f5                	div    %ebp
  801fd7:	89 f0                	mov    %esi,%eax
  801fd9:	f7 f5                	div    %ebp
  801fdb:	89 d0                	mov    %edx,%eax
  801fdd:	31 d2                	xor    %edx,%edx
  801fdf:	eb 8c                	jmp    801f6d <__umoddi3+0x2d>
  801fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fe8:	89 e9                	mov    %ebp,%ecx
  801fea:	ba 20 00 00 00       	mov    $0x20,%edx
  801fef:	29 ea                	sub    %ebp,%edx
  801ff1:	d3 e0                	shl    %cl,%eax
  801ff3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ff7:	89 d1                	mov    %edx,%ecx
  801ff9:	89 f8                	mov    %edi,%eax
  801ffb:	d3 e8                	shr    %cl,%eax
  801ffd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802001:	89 54 24 04          	mov    %edx,0x4(%esp)
  802005:	8b 54 24 04          	mov    0x4(%esp),%edx
  802009:	09 c1                	or     %eax,%ecx
  80200b:	89 d8                	mov    %ebx,%eax
  80200d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802011:	89 e9                	mov    %ebp,%ecx
  802013:	d3 e7                	shl    %cl,%edi
  802015:	89 d1                	mov    %edx,%ecx
  802017:	d3 e8                	shr    %cl,%eax
  802019:	89 e9                	mov    %ebp,%ecx
  80201b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80201f:	d3 e3                	shl    %cl,%ebx
  802021:	89 c7                	mov    %eax,%edi
  802023:	89 d1                	mov    %edx,%ecx
  802025:	89 f0                	mov    %esi,%eax
  802027:	d3 e8                	shr    %cl,%eax
  802029:	89 e9                	mov    %ebp,%ecx
  80202b:	89 fa                	mov    %edi,%edx
  80202d:	d3 e6                	shl    %cl,%esi
  80202f:	09 d8                	or     %ebx,%eax
  802031:	f7 74 24 08          	divl   0x8(%esp)
  802035:	89 d1                	mov    %edx,%ecx
  802037:	89 f3                	mov    %esi,%ebx
  802039:	f7 64 24 0c          	mull   0xc(%esp)
  80203d:	89 c6                	mov    %eax,%esi
  80203f:	89 d7                	mov    %edx,%edi
  802041:	39 d1                	cmp    %edx,%ecx
  802043:	72 06                	jb     80204b <__umoddi3+0x10b>
  802045:	75 10                	jne    802057 <__umoddi3+0x117>
  802047:	39 c3                	cmp    %eax,%ebx
  802049:	73 0c                	jae    802057 <__umoddi3+0x117>
  80204b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80204f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802053:	89 d7                	mov    %edx,%edi
  802055:	89 c6                	mov    %eax,%esi
  802057:	89 ca                	mov    %ecx,%edx
  802059:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80205e:	29 f3                	sub    %esi,%ebx
  802060:	19 fa                	sbb    %edi,%edx
  802062:	89 d0                	mov    %edx,%eax
  802064:	d3 e0                	shl    %cl,%eax
  802066:	89 e9                	mov    %ebp,%ecx
  802068:	d3 eb                	shr    %cl,%ebx
  80206a:	d3 ea                	shr    %cl,%edx
  80206c:	09 d8                	or     %ebx,%eax
  80206e:	83 c4 1c             	add    $0x1c,%esp
  802071:	5b                   	pop    %ebx
  802072:	5e                   	pop    %esi
  802073:	5f                   	pop    %edi
  802074:	5d                   	pop    %ebp
  802075:	c3                   	ret    
  802076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80207d:	8d 76 00             	lea    0x0(%esi),%esi
  802080:	29 fe                	sub    %edi,%esi
  802082:	19 c3                	sbb    %eax,%ebx
  802084:	89 f2                	mov    %esi,%edx
  802086:	89 d9                	mov    %ebx,%ecx
  802088:	e9 1d ff ff ff       	jmp    801faa <__umoddi3+0x6a>
