
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
  8000a0:	68 00 26 80 00       	push   $0x802600
  8000a5:	6a 20                	push   $0x20
  8000a7:	68 13 26 80 00       	push   $0x802613
  8000ac:	e8 95 01 00 00       	call   800246 <_panic>
		panic("sys_page_map: %e", r);
  8000b1:	50                   	push   %eax
  8000b2:	68 23 26 80 00       	push   $0x802623
  8000b7:	6a 22                	push   $0x22
  8000b9:	68 13 26 80 00       	push   $0x802613
  8000be:	e8 83 01 00 00       	call   800246 <_panic>
		panic("sys_page_unmap: %e", r);
  8000c3:	50                   	push   %eax
  8000c4:	68 34 26 80 00       	push   $0x802634
  8000c9:	6a 25                	push   $0x25
  8000cb:	68 13 26 80 00       	push   $0x802613
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
  8000fc:	68 47 26 80 00       	push   $0x802647
  800101:	6a 37                	push   $0x37
  800103:	68 13 26 80 00       	push   $0x802613
  800108:	e8 39 01 00 00       	call   800246 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  80010d:	e8 21 0c 00 00       	call   800d33 <sys_getenvid>
  800112:	25 ff 03 00 00       	and    $0x3ff,%eax
  800117:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80011a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011f:	a3 08 40 80 00       	mov    %eax,0x804008
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
  80013d:	81 fa 00 70 80 00    	cmp    $0x807000,%edx
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
  800173:	68 57 26 80 00       	push   $0x802657
  800178:	6a 4c                	push   $0x4c
  80017a:	68 13 26 80 00       	push   $0x802613
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
  80019a:	bf 6e 26 80 00       	mov    $0x80266e,%edi
  80019f:	b8 75 26 80 00       	mov    $0x802675,%eax
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
  8001b8:	68 7b 26 80 00       	push   $0x80267b
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
  8001ff:	a3 08 40 80 00       	mov    %eax,0x804008

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
  800232:	e8 f6 0f 00 00       	call   80122d <close_all>
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
  800268:	68 98 26 80 00       	push   $0x802698
  80026d:	e8 bb 00 00 00       	call   80032d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800272:	83 c4 18             	add    $0x18,%esp
  800275:	53                   	push   %ebx
  800276:	ff 75 10             	pushl  0x10(%ebp)
  800279:	e8 5a 00 00 00       	call   8002d8 <vcprintf>
	cprintf("\n");
  80027e:	c7 04 24 8b 26 80 00 	movl   $0x80268b,(%esp)
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
  800393:	e8 08 20 00 00       	call   8023a0 <__udivdi3>
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
  8003d1:	e8 da 20 00 00       	call   8024b0 <__umoddi3>
  8003d6:	83 c4 14             	add    $0x14,%esp
  8003d9:	0f be 80 bb 26 80 00 	movsbl 0x8026bb(%eax),%eax
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
  800480:	3e ff 24 85 00 28 80 	notrack jmp *0x802800(,%eax,4)
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
  80054d:	8b 14 85 60 29 80 00 	mov    0x802960(,%eax,4),%edx
  800554:	85 d2                	test   %edx,%edx
  800556:	74 18                	je     800570 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800558:	52                   	push   %edx
  800559:	68 95 2a 80 00       	push   $0x802a95
  80055e:	53                   	push   %ebx
  80055f:	56                   	push   %esi
  800560:	e8 aa fe ff ff       	call   80040f <printfmt>
  800565:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800568:	89 7d 14             	mov    %edi,0x14(%ebp)
  80056b:	e9 66 02 00 00       	jmp    8007d6 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800570:	50                   	push   %eax
  800571:	68 d3 26 80 00       	push   $0x8026d3
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
  800598:	b8 cc 26 80 00       	mov    $0x8026cc,%eax
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
  800d22:	68 bf 29 80 00       	push   $0x8029bf
  800d27:	6a 23                	push   $0x23
  800d29:	68 dc 29 80 00       	push   $0x8029dc
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
  800daf:	68 bf 29 80 00       	push   $0x8029bf
  800db4:	6a 23                	push   $0x23
  800db6:	68 dc 29 80 00       	push   $0x8029dc
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
  800df5:	68 bf 29 80 00       	push   $0x8029bf
  800dfa:	6a 23                	push   $0x23
  800dfc:	68 dc 29 80 00       	push   $0x8029dc
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
  800e3b:	68 bf 29 80 00       	push   $0x8029bf
  800e40:	6a 23                	push   $0x23
  800e42:	68 dc 29 80 00       	push   $0x8029dc
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
  800e81:	68 bf 29 80 00       	push   $0x8029bf
  800e86:	6a 23                	push   $0x23
  800e88:	68 dc 29 80 00       	push   $0x8029dc
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
  800ec7:	68 bf 29 80 00       	push   $0x8029bf
  800ecc:	6a 23                	push   $0x23
  800ece:	68 dc 29 80 00       	push   $0x8029dc
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
  800f0d:	68 bf 29 80 00       	push   $0x8029bf
  800f12:	6a 23                	push   $0x23
  800f14:	68 dc 29 80 00       	push   $0x8029dc
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
  800f79:	68 bf 29 80 00       	push   $0x8029bf
  800f7e:	6a 23                	push   $0x23
  800f80:	68 dc 29 80 00       	push   $0x8029dc
  800f85:	e8 bc f2 ff ff       	call   800246 <_panic>

00800f8a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f8a:	f3 0f 1e fb          	endbr32 
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	57                   	push   %edi
  800f92:	56                   	push   %esi
  800f93:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f94:	ba 00 00 00 00       	mov    $0x0,%edx
  800f99:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f9e:	89 d1                	mov    %edx,%ecx
  800fa0:	89 d3                	mov    %edx,%ebx
  800fa2:	89 d7                	mov    %edx,%edi
  800fa4:	89 d6                	mov    %edx,%esi
  800fa6:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fa8:	5b                   	pop    %ebx
  800fa9:	5e                   	pop    %esi
  800faa:	5f                   	pop    %edi
  800fab:	5d                   	pop    %ebp
  800fac:	c3                   	ret    

00800fad <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  800fad:	f3 0f 1e fb          	endbr32 
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
  800fb4:	57                   	push   %edi
  800fb5:	56                   	push   %esi
  800fb6:	53                   	push   %ebx
  800fb7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fba:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc5:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fca:	89 df                	mov    %ebx,%edi
  800fcc:	89 de                	mov    %ebx,%esi
  800fce:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd0:	85 c0                	test   %eax,%eax
  800fd2:	7f 08                	jg     800fdc <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  800fd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd7:	5b                   	pop    %ebx
  800fd8:	5e                   	pop    %esi
  800fd9:	5f                   	pop    %edi
  800fda:	5d                   	pop    %ebp
  800fdb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fdc:	83 ec 0c             	sub    $0xc,%esp
  800fdf:	50                   	push   %eax
  800fe0:	6a 0f                	push   $0xf
  800fe2:	68 bf 29 80 00       	push   $0x8029bf
  800fe7:	6a 23                	push   $0x23
  800fe9:	68 dc 29 80 00       	push   $0x8029dc
  800fee:	e8 53 f2 ff ff       	call   800246 <_panic>

00800ff3 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  800ff3:	f3 0f 1e fb          	endbr32 
  800ff7:	55                   	push   %ebp
  800ff8:	89 e5                	mov    %esp,%ebp
  800ffa:	57                   	push   %edi
  800ffb:	56                   	push   %esi
  800ffc:	53                   	push   %ebx
  800ffd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801000:	bb 00 00 00 00       	mov    $0x0,%ebx
  801005:	8b 55 08             	mov    0x8(%ebp),%edx
  801008:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100b:	b8 10 00 00 00       	mov    $0x10,%eax
  801010:	89 df                	mov    %ebx,%edi
  801012:	89 de                	mov    %ebx,%esi
  801014:	cd 30                	int    $0x30
	if(check && ret > 0)
  801016:	85 c0                	test   %eax,%eax
  801018:	7f 08                	jg     801022 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  80101a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80101d:	5b                   	pop    %ebx
  80101e:	5e                   	pop    %esi
  80101f:	5f                   	pop    %edi
  801020:	5d                   	pop    %ebp
  801021:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801022:	83 ec 0c             	sub    $0xc,%esp
  801025:	50                   	push   %eax
  801026:	6a 10                	push   $0x10
  801028:	68 bf 29 80 00       	push   $0x8029bf
  80102d:	6a 23                	push   $0x23
  80102f:	68 dc 29 80 00       	push   $0x8029dc
  801034:	e8 0d f2 ff ff       	call   800246 <_panic>

00801039 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801039:	f3 0f 1e fb          	endbr32 
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	05 00 00 00 30       	add    $0x30000000,%eax
  801048:	c1 e8 0c             	shr    $0xc,%eax
}
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    

0080104d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80104d:	f3 0f 1e fb          	endbr32 
  801051:	55                   	push   %ebp
  801052:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80105c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801061:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801066:	5d                   	pop    %ebp
  801067:	c3                   	ret    

00801068 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801068:	f3 0f 1e fb          	endbr32 
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801074:	89 c2                	mov    %eax,%edx
  801076:	c1 ea 16             	shr    $0x16,%edx
  801079:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801080:	f6 c2 01             	test   $0x1,%dl
  801083:	74 2d                	je     8010b2 <fd_alloc+0x4a>
  801085:	89 c2                	mov    %eax,%edx
  801087:	c1 ea 0c             	shr    $0xc,%edx
  80108a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801091:	f6 c2 01             	test   $0x1,%dl
  801094:	74 1c                	je     8010b2 <fd_alloc+0x4a>
  801096:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80109b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010a0:	75 d2                	jne    801074 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010ab:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010b0:	eb 0a                	jmp    8010bc <fd_alloc+0x54>
			*fd_store = fd;
  8010b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010bc:	5d                   	pop    %ebp
  8010bd:	c3                   	ret    

008010be <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010be:	f3 0f 1e fb          	endbr32 
  8010c2:	55                   	push   %ebp
  8010c3:	89 e5                	mov    %esp,%ebp
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010c8:	83 f8 1f             	cmp    $0x1f,%eax
  8010cb:	77 30                	ja     8010fd <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010cd:	c1 e0 0c             	shl    $0xc,%eax
  8010d0:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010d5:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010db:	f6 c2 01             	test   $0x1,%dl
  8010de:	74 24                	je     801104 <fd_lookup+0x46>
  8010e0:	89 c2                	mov    %eax,%edx
  8010e2:	c1 ea 0c             	shr    $0xc,%edx
  8010e5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010ec:	f6 c2 01             	test   $0x1,%dl
  8010ef:	74 1a                	je     80110b <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f4:	89 02                	mov    %eax,(%edx)
	return 0;
  8010f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010fb:	5d                   	pop    %ebp
  8010fc:	c3                   	ret    
		return -E_INVAL;
  8010fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801102:	eb f7                	jmp    8010fb <fd_lookup+0x3d>
		return -E_INVAL;
  801104:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801109:	eb f0                	jmp    8010fb <fd_lookup+0x3d>
  80110b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801110:	eb e9                	jmp    8010fb <fd_lookup+0x3d>

00801112 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801112:	f3 0f 1e fb          	endbr32 
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	83 ec 08             	sub    $0x8,%esp
  80111c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80111f:	ba 00 00 00 00       	mov    $0x0,%edx
  801124:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801129:	39 08                	cmp    %ecx,(%eax)
  80112b:	74 38                	je     801165 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80112d:	83 c2 01             	add    $0x1,%edx
  801130:	8b 04 95 68 2a 80 00 	mov    0x802a68(,%edx,4),%eax
  801137:	85 c0                	test   %eax,%eax
  801139:	75 ee                	jne    801129 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80113b:	a1 08 40 80 00       	mov    0x804008,%eax
  801140:	8b 40 48             	mov    0x48(%eax),%eax
  801143:	83 ec 04             	sub    $0x4,%esp
  801146:	51                   	push   %ecx
  801147:	50                   	push   %eax
  801148:	68 ec 29 80 00       	push   $0x8029ec
  80114d:	e8 db f1 ff ff       	call   80032d <cprintf>
	*dev = 0;
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80115b:	83 c4 10             	add    $0x10,%esp
  80115e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801163:	c9                   	leave  
  801164:	c3                   	ret    
			*dev = devtab[i];
  801165:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801168:	89 01                	mov    %eax,(%ecx)
			return 0;
  80116a:	b8 00 00 00 00       	mov    $0x0,%eax
  80116f:	eb f2                	jmp    801163 <dev_lookup+0x51>

00801171 <fd_close>:
{
  801171:	f3 0f 1e fb          	endbr32 
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
  801178:	57                   	push   %edi
  801179:	56                   	push   %esi
  80117a:	53                   	push   %ebx
  80117b:	83 ec 24             	sub    $0x24,%esp
  80117e:	8b 75 08             	mov    0x8(%ebp),%esi
  801181:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801184:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801187:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801188:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80118e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801191:	50                   	push   %eax
  801192:	e8 27 ff ff ff       	call   8010be <fd_lookup>
  801197:	89 c3                	mov    %eax,%ebx
  801199:	83 c4 10             	add    $0x10,%esp
  80119c:	85 c0                	test   %eax,%eax
  80119e:	78 05                	js     8011a5 <fd_close+0x34>
	    || fd != fd2)
  8011a0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011a3:	74 16                	je     8011bb <fd_close+0x4a>
		return (must_exist ? r : 0);
  8011a5:	89 f8                	mov    %edi,%eax
  8011a7:	84 c0                	test   %al,%al
  8011a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ae:	0f 44 d8             	cmove  %eax,%ebx
}
  8011b1:	89 d8                	mov    %ebx,%eax
  8011b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011b6:	5b                   	pop    %ebx
  8011b7:	5e                   	pop    %esi
  8011b8:	5f                   	pop    %edi
  8011b9:	5d                   	pop    %ebp
  8011ba:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011bb:	83 ec 08             	sub    $0x8,%esp
  8011be:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011c1:	50                   	push   %eax
  8011c2:	ff 36                	pushl  (%esi)
  8011c4:	e8 49 ff ff ff       	call   801112 <dev_lookup>
  8011c9:	89 c3                	mov    %eax,%ebx
  8011cb:	83 c4 10             	add    $0x10,%esp
  8011ce:	85 c0                	test   %eax,%eax
  8011d0:	78 1a                	js     8011ec <fd_close+0x7b>
		if (dev->dev_close)
  8011d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011d5:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011d8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011dd:	85 c0                	test   %eax,%eax
  8011df:	74 0b                	je     8011ec <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8011e1:	83 ec 0c             	sub    $0xc,%esp
  8011e4:	56                   	push   %esi
  8011e5:	ff d0                	call   *%eax
  8011e7:	89 c3                	mov    %eax,%ebx
  8011e9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011ec:	83 ec 08             	sub    $0x8,%esp
  8011ef:	56                   	push   %esi
  8011f0:	6a 00                	push   $0x0
  8011f2:	e8 0f fc ff ff       	call   800e06 <sys_page_unmap>
	return r;
  8011f7:	83 c4 10             	add    $0x10,%esp
  8011fa:	eb b5                	jmp    8011b1 <fd_close+0x40>

008011fc <close>:

int
close(int fdnum)
{
  8011fc:	f3 0f 1e fb          	endbr32 
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801206:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801209:	50                   	push   %eax
  80120a:	ff 75 08             	pushl  0x8(%ebp)
  80120d:	e8 ac fe ff ff       	call   8010be <fd_lookup>
  801212:	83 c4 10             	add    $0x10,%esp
  801215:	85 c0                	test   %eax,%eax
  801217:	79 02                	jns    80121b <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801219:	c9                   	leave  
  80121a:	c3                   	ret    
		return fd_close(fd, 1);
  80121b:	83 ec 08             	sub    $0x8,%esp
  80121e:	6a 01                	push   $0x1
  801220:	ff 75 f4             	pushl  -0xc(%ebp)
  801223:	e8 49 ff ff ff       	call   801171 <fd_close>
  801228:	83 c4 10             	add    $0x10,%esp
  80122b:	eb ec                	jmp    801219 <close+0x1d>

0080122d <close_all>:

void
close_all(void)
{
  80122d:	f3 0f 1e fb          	endbr32 
  801231:	55                   	push   %ebp
  801232:	89 e5                	mov    %esp,%ebp
  801234:	53                   	push   %ebx
  801235:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801238:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80123d:	83 ec 0c             	sub    $0xc,%esp
  801240:	53                   	push   %ebx
  801241:	e8 b6 ff ff ff       	call   8011fc <close>
	for (i = 0; i < MAXFD; i++)
  801246:	83 c3 01             	add    $0x1,%ebx
  801249:	83 c4 10             	add    $0x10,%esp
  80124c:	83 fb 20             	cmp    $0x20,%ebx
  80124f:	75 ec                	jne    80123d <close_all+0x10>
}
  801251:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801254:	c9                   	leave  
  801255:	c3                   	ret    

00801256 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801256:	f3 0f 1e fb          	endbr32 
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	57                   	push   %edi
  80125e:	56                   	push   %esi
  80125f:	53                   	push   %ebx
  801260:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801263:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801266:	50                   	push   %eax
  801267:	ff 75 08             	pushl  0x8(%ebp)
  80126a:	e8 4f fe ff ff       	call   8010be <fd_lookup>
  80126f:	89 c3                	mov    %eax,%ebx
  801271:	83 c4 10             	add    $0x10,%esp
  801274:	85 c0                	test   %eax,%eax
  801276:	0f 88 81 00 00 00    	js     8012fd <dup+0xa7>
		return r;
	close(newfdnum);
  80127c:	83 ec 0c             	sub    $0xc,%esp
  80127f:	ff 75 0c             	pushl  0xc(%ebp)
  801282:	e8 75 ff ff ff       	call   8011fc <close>

	newfd = INDEX2FD(newfdnum);
  801287:	8b 75 0c             	mov    0xc(%ebp),%esi
  80128a:	c1 e6 0c             	shl    $0xc,%esi
  80128d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801293:	83 c4 04             	add    $0x4,%esp
  801296:	ff 75 e4             	pushl  -0x1c(%ebp)
  801299:	e8 af fd ff ff       	call   80104d <fd2data>
  80129e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012a0:	89 34 24             	mov    %esi,(%esp)
  8012a3:	e8 a5 fd ff ff       	call   80104d <fd2data>
  8012a8:	83 c4 10             	add    $0x10,%esp
  8012ab:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012ad:	89 d8                	mov    %ebx,%eax
  8012af:	c1 e8 16             	shr    $0x16,%eax
  8012b2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012b9:	a8 01                	test   $0x1,%al
  8012bb:	74 11                	je     8012ce <dup+0x78>
  8012bd:	89 d8                	mov    %ebx,%eax
  8012bf:	c1 e8 0c             	shr    $0xc,%eax
  8012c2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012c9:	f6 c2 01             	test   $0x1,%dl
  8012cc:	75 39                	jne    801307 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012d1:	89 d0                	mov    %edx,%eax
  8012d3:	c1 e8 0c             	shr    $0xc,%eax
  8012d6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012dd:	83 ec 0c             	sub    $0xc,%esp
  8012e0:	25 07 0e 00 00       	and    $0xe07,%eax
  8012e5:	50                   	push   %eax
  8012e6:	56                   	push   %esi
  8012e7:	6a 00                	push   $0x0
  8012e9:	52                   	push   %edx
  8012ea:	6a 00                	push   $0x0
  8012ec:	e8 cf fa ff ff       	call   800dc0 <sys_page_map>
  8012f1:	89 c3                	mov    %eax,%ebx
  8012f3:	83 c4 20             	add    $0x20,%esp
  8012f6:	85 c0                	test   %eax,%eax
  8012f8:	78 31                	js     80132b <dup+0xd5>
		goto err;

	return newfdnum;
  8012fa:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012fd:	89 d8                	mov    %ebx,%eax
  8012ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801302:	5b                   	pop    %ebx
  801303:	5e                   	pop    %esi
  801304:	5f                   	pop    %edi
  801305:	5d                   	pop    %ebp
  801306:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801307:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80130e:	83 ec 0c             	sub    $0xc,%esp
  801311:	25 07 0e 00 00       	and    $0xe07,%eax
  801316:	50                   	push   %eax
  801317:	57                   	push   %edi
  801318:	6a 00                	push   $0x0
  80131a:	53                   	push   %ebx
  80131b:	6a 00                	push   $0x0
  80131d:	e8 9e fa ff ff       	call   800dc0 <sys_page_map>
  801322:	89 c3                	mov    %eax,%ebx
  801324:	83 c4 20             	add    $0x20,%esp
  801327:	85 c0                	test   %eax,%eax
  801329:	79 a3                	jns    8012ce <dup+0x78>
	sys_page_unmap(0, newfd);
  80132b:	83 ec 08             	sub    $0x8,%esp
  80132e:	56                   	push   %esi
  80132f:	6a 00                	push   $0x0
  801331:	e8 d0 fa ff ff       	call   800e06 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801336:	83 c4 08             	add    $0x8,%esp
  801339:	57                   	push   %edi
  80133a:	6a 00                	push   $0x0
  80133c:	e8 c5 fa ff ff       	call   800e06 <sys_page_unmap>
	return r;
  801341:	83 c4 10             	add    $0x10,%esp
  801344:	eb b7                	jmp    8012fd <dup+0xa7>

00801346 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801346:	f3 0f 1e fb          	endbr32 
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	53                   	push   %ebx
  80134e:	83 ec 1c             	sub    $0x1c,%esp
  801351:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801354:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801357:	50                   	push   %eax
  801358:	53                   	push   %ebx
  801359:	e8 60 fd ff ff       	call   8010be <fd_lookup>
  80135e:	83 c4 10             	add    $0x10,%esp
  801361:	85 c0                	test   %eax,%eax
  801363:	78 3f                	js     8013a4 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801365:	83 ec 08             	sub    $0x8,%esp
  801368:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136b:	50                   	push   %eax
  80136c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80136f:	ff 30                	pushl  (%eax)
  801371:	e8 9c fd ff ff       	call   801112 <dev_lookup>
  801376:	83 c4 10             	add    $0x10,%esp
  801379:	85 c0                	test   %eax,%eax
  80137b:	78 27                	js     8013a4 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80137d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801380:	8b 42 08             	mov    0x8(%edx),%eax
  801383:	83 e0 03             	and    $0x3,%eax
  801386:	83 f8 01             	cmp    $0x1,%eax
  801389:	74 1e                	je     8013a9 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80138b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80138e:	8b 40 08             	mov    0x8(%eax),%eax
  801391:	85 c0                	test   %eax,%eax
  801393:	74 35                	je     8013ca <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801395:	83 ec 04             	sub    $0x4,%esp
  801398:	ff 75 10             	pushl  0x10(%ebp)
  80139b:	ff 75 0c             	pushl  0xc(%ebp)
  80139e:	52                   	push   %edx
  80139f:	ff d0                	call   *%eax
  8013a1:	83 c4 10             	add    $0x10,%esp
}
  8013a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a7:	c9                   	leave  
  8013a8:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013a9:	a1 08 40 80 00       	mov    0x804008,%eax
  8013ae:	8b 40 48             	mov    0x48(%eax),%eax
  8013b1:	83 ec 04             	sub    $0x4,%esp
  8013b4:	53                   	push   %ebx
  8013b5:	50                   	push   %eax
  8013b6:	68 2d 2a 80 00       	push   $0x802a2d
  8013bb:	e8 6d ef ff ff       	call   80032d <cprintf>
		return -E_INVAL;
  8013c0:	83 c4 10             	add    $0x10,%esp
  8013c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c8:	eb da                	jmp    8013a4 <read+0x5e>
		return -E_NOT_SUPP;
  8013ca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013cf:	eb d3                	jmp    8013a4 <read+0x5e>

008013d1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013d1:	f3 0f 1e fb          	endbr32 
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
  8013d8:	57                   	push   %edi
  8013d9:	56                   	push   %esi
  8013da:	53                   	push   %ebx
  8013db:	83 ec 0c             	sub    $0xc,%esp
  8013de:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013e1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e9:	eb 02                	jmp    8013ed <readn+0x1c>
  8013eb:	01 c3                	add    %eax,%ebx
  8013ed:	39 f3                	cmp    %esi,%ebx
  8013ef:	73 21                	jae    801412 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013f1:	83 ec 04             	sub    $0x4,%esp
  8013f4:	89 f0                	mov    %esi,%eax
  8013f6:	29 d8                	sub    %ebx,%eax
  8013f8:	50                   	push   %eax
  8013f9:	89 d8                	mov    %ebx,%eax
  8013fb:	03 45 0c             	add    0xc(%ebp),%eax
  8013fe:	50                   	push   %eax
  8013ff:	57                   	push   %edi
  801400:	e8 41 ff ff ff       	call   801346 <read>
		if (m < 0)
  801405:	83 c4 10             	add    $0x10,%esp
  801408:	85 c0                	test   %eax,%eax
  80140a:	78 04                	js     801410 <readn+0x3f>
			return m;
		if (m == 0)
  80140c:	75 dd                	jne    8013eb <readn+0x1a>
  80140e:	eb 02                	jmp    801412 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801410:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801412:	89 d8                	mov    %ebx,%eax
  801414:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801417:	5b                   	pop    %ebx
  801418:	5e                   	pop    %esi
  801419:	5f                   	pop    %edi
  80141a:	5d                   	pop    %ebp
  80141b:	c3                   	ret    

0080141c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80141c:	f3 0f 1e fb          	endbr32 
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	53                   	push   %ebx
  801424:	83 ec 1c             	sub    $0x1c,%esp
  801427:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80142a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80142d:	50                   	push   %eax
  80142e:	53                   	push   %ebx
  80142f:	e8 8a fc ff ff       	call   8010be <fd_lookup>
  801434:	83 c4 10             	add    $0x10,%esp
  801437:	85 c0                	test   %eax,%eax
  801439:	78 3a                	js     801475 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80143b:	83 ec 08             	sub    $0x8,%esp
  80143e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801441:	50                   	push   %eax
  801442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801445:	ff 30                	pushl  (%eax)
  801447:	e8 c6 fc ff ff       	call   801112 <dev_lookup>
  80144c:	83 c4 10             	add    $0x10,%esp
  80144f:	85 c0                	test   %eax,%eax
  801451:	78 22                	js     801475 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801456:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80145a:	74 1e                	je     80147a <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80145c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80145f:	8b 52 0c             	mov    0xc(%edx),%edx
  801462:	85 d2                	test   %edx,%edx
  801464:	74 35                	je     80149b <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801466:	83 ec 04             	sub    $0x4,%esp
  801469:	ff 75 10             	pushl  0x10(%ebp)
  80146c:	ff 75 0c             	pushl  0xc(%ebp)
  80146f:	50                   	push   %eax
  801470:	ff d2                	call   *%edx
  801472:	83 c4 10             	add    $0x10,%esp
}
  801475:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801478:	c9                   	leave  
  801479:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80147a:	a1 08 40 80 00       	mov    0x804008,%eax
  80147f:	8b 40 48             	mov    0x48(%eax),%eax
  801482:	83 ec 04             	sub    $0x4,%esp
  801485:	53                   	push   %ebx
  801486:	50                   	push   %eax
  801487:	68 49 2a 80 00       	push   $0x802a49
  80148c:	e8 9c ee ff ff       	call   80032d <cprintf>
		return -E_INVAL;
  801491:	83 c4 10             	add    $0x10,%esp
  801494:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801499:	eb da                	jmp    801475 <write+0x59>
		return -E_NOT_SUPP;
  80149b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014a0:	eb d3                	jmp    801475 <write+0x59>

008014a2 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014a2:	f3 0f 1e fb          	endbr32 
  8014a6:	55                   	push   %ebp
  8014a7:	89 e5                	mov    %esp,%ebp
  8014a9:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014af:	50                   	push   %eax
  8014b0:	ff 75 08             	pushl  0x8(%ebp)
  8014b3:	e8 06 fc ff ff       	call   8010be <fd_lookup>
  8014b8:	83 c4 10             	add    $0x10,%esp
  8014bb:	85 c0                	test   %eax,%eax
  8014bd:	78 0e                	js     8014cd <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8014bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014cf:	f3 0f 1e fb          	endbr32 
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
  8014d6:	53                   	push   %ebx
  8014d7:	83 ec 1c             	sub    $0x1c,%esp
  8014da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e0:	50                   	push   %eax
  8014e1:	53                   	push   %ebx
  8014e2:	e8 d7 fb ff ff       	call   8010be <fd_lookup>
  8014e7:	83 c4 10             	add    $0x10,%esp
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	78 37                	js     801525 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ee:	83 ec 08             	sub    $0x8,%esp
  8014f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f4:	50                   	push   %eax
  8014f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f8:	ff 30                	pushl  (%eax)
  8014fa:	e8 13 fc ff ff       	call   801112 <dev_lookup>
  8014ff:	83 c4 10             	add    $0x10,%esp
  801502:	85 c0                	test   %eax,%eax
  801504:	78 1f                	js     801525 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801509:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80150d:	74 1b                	je     80152a <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80150f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801512:	8b 52 18             	mov    0x18(%edx),%edx
  801515:	85 d2                	test   %edx,%edx
  801517:	74 32                	je     80154b <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801519:	83 ec 08             	sub    $0x8,%esp
  80151c:	ff 75 0c             	pushl  0xc(%ebp)
  80151f:	50                   	push   %eax
  801520:	ff d2                	call   *%edx
  801522:	83 c4 10             	add    $0x10,%esp
}
  801525:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801528:	c9                   	leave  
  801529:	c3                   	ret    
			thisenv->env_id, fdnum);
  80152a:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80152f:	8b 40 48             	mov    0x48(%eax),%eax
  801532:	83 ec 04             	sub    $0x4,%esp
  801535:	53                   	push   %ebx
  801536:	50                   	push   %eax
  801537:	68 0c 2a 80 00       	push   $0x802a0c
  80153c:	e8 ec ed ff ff       	call   80032d <cprintf>
		return -E_INVAL;
  801541:	83 c4 10             	add    $0x10,%esp
  801544:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801549:	eb da                	jmp    801525 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80154b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801550:	eb d3                	jmp    801525 <ftruncate+0x56>

00801552 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801552:	f3 0f 1e fb          	endbr32 
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
  801559:	53                   	push   %ebx
  80155a:	83 ec 1c             	sub    $0x1c,%esp
  80155d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801560:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801563:	50                   	push   %eax
  801564:	ff 75 08             	pushl  0x8(%ebp)
  801567:	e8 52 fb ff ff       	call   8010be <fd_lookup>
  80156c:	83 c4 10             	add    $0x10,%esp
  80156f:	85 c0                	test   %eax,%eax
  801571:	78 4b                	js     8015be <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801573:	83 ec 08             	sub    $0x8,%esp
  801576:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801579:	50                   	push   %eax
  80157a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157d:	ff 30                	pushl  (%eax)
  80157f:	e8 8e fb ff ff       	call   801112 <dev_lookup>
  801584:	83 c4 10             	add    $0x10,%esp
  801587:	85 c0                	test   %eax,%eax
  801589:	78 33                	js     8015be <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80158b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801592:	74 2f                	je     8015c3 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801594:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801597:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80159e:	00 00 00 
	stat->st_isdir = 0;
  8015a1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015a8:	00 00 00 
	stat->st_dev = dev;
  8015ab:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015b1:	83 ec 08             	sub    $0x8,%esp
  8015b4:	53                   	push   %ebx
  8015b5:	ff 75 f0             	pushl  -0x10(%ebp)
  8015b8:	ff 50 14             	call   *0x14(%eax)
  8015bb:	83 c4 10             	add    $0x10,%esp
}
  8015be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    
		return -E_NOT_SUPP;
  8015c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015c8:	eb f4                	jmp    8015be <fstat+0x6c>

008015ca <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015ca:	f3 0f 1e fb          	endbr32 
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	56                   	push   %esi
  8015d2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015d3:	83 ec 08             	sub    $0x8,%esp
  8015d6:	6a 00                	push   $0x0
  8015d8:	ff 75 08             	pushl  0x8(%ebp)
  8015db:	e8 fb 01 00 00       	call   8017db <open>
  8015e0:	89 c3                	mov    %eax,%ebx
  8015e2:	83 c4 10             	add    $0x10,%esp
  8015e5:	85 c0                	test   %eax,%eax
  8015e7:	78 1b                	js     801604 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8015e9:	83 ec 08             	sub    $0x8,%esp
  8015ec:	ff 75 0c             	pushl  0xc(%ebp)
  8015ef:	50                   	push   %eax
  8015f0:	e8 5d ff ff ff       	call   801552 <fstat>
  8015f5:	89 c6                	mov    %eax,%esi
	close(fd);
  8015f7:	89 1c 24             	mov    %ebx,(%esp)
  8015fa:	e8 fd fb ff ff       	call   8011fc <close>
	return r;
  8015ff:	83 c4 10             	add    $0x10,%esp
  801602:	89 f3                	mov    %esi,%ebx
}
  801604:	89 d8                	mov    %ebx,%eax
  801606:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801609:	5b                   	pop    %ebx
  80160a:	5e                   	pop    %esi
  80160b:	5d                   	pop    %ebp
  80160c:	c3                   	ret    

0080160d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
  801610:	56                   	push   %esi
  801611:	53                   	push   %ebx
  801612:	89 c6                	mov    %eax,%esi
  801614:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801616:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80161d:	74 27                	je     801646 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80161f:	6a 07                	push   $0x7
  801621:	68 00 50 80 00       	push   $0x805000
  801626:	56                   	push   %esi
  801627:	ff 35 00 40 80 00    	pushl  0x804000
  80162d:	e8 8e 0c 00 00       	call   8022c0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801632:	83 c4 0c             	add    $0xc,%esp
  801635:	6a 00                	push   $0x0
  801637:	53                   	push   %ebx
  801638:	6a 00                	push   $0x0
  80163a:	e8 fc 0b 00 00       	call   80223b <ipc_recv>
}
  80163f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801642:	5b                   	pop    %ebx
  801643:	5e                   	pop    %esi
  801644:	5d                   	pop    %ebp
  801645:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801646:	83 ec 0c             	sub    $0xc,%esp
  801649:	6a 01                	push   $0x1
  80164b:	e8 c8 0c 00 00       	call   802318 <ipc_find_env>
  801650:	a3 00 40 80 00       	mov    %eax,0x804000
  801655:	83 c4 10             	add    $0x10,%esp
  801658:	eb c5                	jmp    80161f <fsipc+0x12>

0080165a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80165a:	f3 0f 1e fb          	endbr32 
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	8b 40 0c             	mov    0xc(%eax),%eax
  80166a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80166f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801672:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801677:	ba 00 00 00 00       	mov    $0x0,%edx
  80167c:	b8 02 00 00 00       	mov    $0x2,%eax
  801681:	e8 87 ff ff ff       	call   80160d <fsipc>
}
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <devfile_flush>:
{
  801688:	f3 0f 1e fb          	endbr32 
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
  80168f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	8b 40 0c             	mov    0xc(%eax),%eax
  801698:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80169d:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a2:	b8 06 00 00 00       	mov    $0x6,%eax
  8016a7:	e8 61 ff ff ff       	call   80160d <fsipc>
}
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <devfile_stat>:
{
  8016ae:	f3 0f 1e fb          	endbr32 
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
  8016b5:	53                   	push   %ebx
  8016b6:	83 ec 04             	sub    $0x4,%esp
  8016b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c2:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016cc:	b8 05 00 00 00       	mov    $0x5,%eax
  8016d1:	e8 37 ff ff ff       	call   80160d <fsipc>
  8016d6:	85 c0                	test   %eax,%eax
  8016d8:	78 2c                	js     801706 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016da:	83 ec 08             	sub    $0x8,%esp
  8016dd:	68 00 50 80 00       	push   $0x805000
  8016e2:	53                   	push   %ebx
  8016e3:	e8 4f f2 ff ff       	call   800937 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016e8:	a1 80 50 80 00       	mov    0x805080,%eax
  8016ed:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016f3:	a1 84 50 80 00       	mov    0x805084,%eax
  8016f8:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016fe:	83 c4 10             	add    $0x10,%esp
  801701:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801706:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801709:	c9                   	leave  
  80170a:	c3                   	ret    

0080170b <devfile_write>:
{
  80170b:	f3 0f 1e fb          	endbr32 
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	83 ec 0c             	sub    $0xc,%esp
  801715:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801718:	8b 55 08             	mov    0x8(%ebp),%edx
  80171b:	8b 52 0c             	mov    0xc(%edx),%edx
  80171e:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801724:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801729:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80172e:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801731:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801736:	50                   	push   %eax
  801737:	ff 75 0c             	pushl  0xc(%ebp)
  80173a:	68 08 50 80 00       	push   $0x805008
  80173f:	e8 a9 f3 ff ff       	call   800aed <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801744:	ba 00 00 00 00       	mov    $0x0,%edx
  801749:	b8 04 00 00 00       	mov    $0x4,%eax
  80174e:	e8 ba fe ff ff       	call   80160d <fsipc>
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <devfile_read>:
{
  801755:	f3 0f 1e fb          	endbr32 
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	56                   	push   %esi
  80175d:	53                   	push   %ebx
  80175e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	8b 40 0c             	mov    0xc(%eax),%eax
  801767:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80176c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801772:	ba 00 00 00 00       	mov    $0x0,%edx
  801777:	b8 03 00 00 00       	mov    $0x3,%eax
  80177c:	e8 8c fe ff ff       	call   80160d <fsipc>
  801781:	89 c3                	mov    %eax,%ebx
  801783:	85 c0                	test   %eax,%eax
  801785:	78 1f                	js     8017a6 <devfile_read+0x51>
	assert(r <= n);
  801787:	39 f0                	cmp    %esi,%eax
  801789:	77 24                	ja     8017af <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80178b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801790:	7f 33                	jg     8017c5 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801792:	83 ec 04             	sub    $0x4,%esp
  801795:	50                   	push   %eax
  801796:	68 00 50 80 00       	push   $0x805000
  80179b:	ff 75 0c             	pushl  0xc(%ebp)
  80179e:	e8 4a f3 ff ff       	call   800aed <memmove>
	return r;
  8017a3:	83 c4 10             	add    $0x10,%esp
}
  8017a6:	89 d8                	mov    %ebx,%eax
  8017a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ab:	5b                   	pop    %ebx
  8017ac:	5e                   	pop    %esi
  8017ad:	5d                   	pop    %ebp
  8017ae:	c3                   	ret    
	assert(r <= n);
  8017af:	68 7c 2a 80 00       	push   $0x802a7c
  8017b4:	68 83 2a 80 00       	push   $0x802a83
  8017b9:	6a 7c                	push   $0x7c
  8017bb:	68 98 2a 80 00       	push   $0x802a98
  8017c0:	e8 81 ea ff ff       	call   800246 <_panic>
	assert(r <= PGSIZE);
  8017c5:	68 a3 2a 80 00       	push   $0x802aa3
  8017ca:	68 83 2a 80 00       	push   $0x802a83
  8017cf:	6a 7d                	push   $0x7d
  8017d1:	68 98 2a 80 00       	push   $0x802a98
  8017d6:	e8 6b ea ff ff       	call   800246 <_panic>

008017db <open>:
{
  8017db:	f3 0f 1e fb          	endbr32 
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
  8017e2:	56                   	push   %esi
  8017e3:	53                   	push   %ebx
  8017e4:	83 ec 1c             	sub    $0x1c,%esp
  8017e7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017ea:	56                   	push   %esi
  8017eb:	e8 04 f1 ff ff       	call   8008f4 <strlen>
  8017f0:	83 c4 10             	add    $0x10,%esp
  8017f3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017f8:	7f 6c                	jg     801866 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8017fa:	83 ec 0c             	sub    $0xc,%esp
  8017fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801800:	50                   	push   %eax
  801801:	e8 62 f8 ff ff       	call   801068 <fd_alloc>
  801806:	89 c3                	mov    %eax,%ebx
  801808:	83 c4 10             	add    $0x10,%esp
  80180b:	85 c0                	test   %eax,%eax
  80180d:	78 3c                	js     80184b <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  80180f:	83 ec 08             	sub    $0x8,%esp
  801812:	56                   	push   %esi
  801813:	68 00 50 80 00       	push   $0x805000
  801818:	e8 1a f1 ff ff       	call   800937 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80181d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801820:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801825:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801828:	b8 01 00 00 00       	mov    $0x1,%eax
  80182d:	e8 db fd ff ff       	call   80160d <fsipc>
  801832:	89 c3                	mov    %eax,%ebx
  801834:	83 c4 10             	add    $0x10,%esp
  801837:	85 c0                	test   %eax,%eax
  801839:	78 19                	js     801854 <open+0x79>
	return fd2num(fd);
  80183b:	83 ec 0c             	sub    $0xc,%esp
  80183e:	ff 75 f4             	pushl  -0xc(%ebp)
  801841:	e8 f3 f7 ff ff       	call   801039 <fd2num>
  801846:	89 c3                	mov    %eax,%ebx
  801848:	83 c4 10             	add    $0x10,%esp
}
  80184b:	89 d8                	mov    %ebx,%eax
  80184d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801850:	5b                   	pop    %ebx
  801851:	5e                   	pop    %esi
  801852:	5d                   	pop    %ebp
  801853:	c3                   	ret    
		fd_close(fd, 0);
  801854:	83 ec 08             	sub    $0x8,%esp
  801857:	6a 00                	push   $0x0
  801859:	ff 75 f4             	pushl  -0xc(%ebp)
  80185c:	e8 10 f9 ff ff       	call   801171 <fd_close>
		return r;
  801861:	83 c4 10             	add    $0x10,%esp
  801864:	eb e5                	jmp    80184b <open+0x70>
		return -E_BAD_PATH;
  801866:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80186b:	eb de                	jmp    80184b <open+0x70>

0080186d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80186d:	f3 0f 1e fb          	endbr32 
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801877:	ba 00 00 00 00       	mov    $0x0,%edx
  80187c:	b8 08 00 00 00       	mov    $0x8,%eax
  801881:	e8 87 fd ff ff       	call   80160d <fsipc>
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801888:	f3 0f 1e fb          	endbr32 
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801892:	68 af 2a 80 00       	push   $0x802aaf
  801897:	ff 75 0c             	pushl  0xc(%ebp)
  80189a:	e8 98 f0 ff ff       	call   800937 <strcpy>
	return 0;
}
  80189f:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <devsock_close>:
{
  8018a6:	f3 0f 1e fb          	endbr32 
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	53                   	push   %ebx
  8018ae:	83 ec 10             	sub    $0x10,%esp
  8018b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018b4:	53                   	push   %ebx
  8018b5:	e8 9b 0a 00 00       	call   802355 <pageref>
  8018ba:	89 c2                	mov    %eax,%edx
  8018bc:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018bf:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  8018c4:	83 fa 01             	cmp    $0x1,%edx
  8018c7:	74 05                	je     8018ce <devsock_close+0x28>
}
  8018c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018ce:	83 ec 0c             	sub    $0xc,%esp
  8018d1:	ff 73 0c             	pushl  0xc(%ebx)
  8018d4:	e8 e3 02 00 00       	call   801bbc <nsipc_close>
  8018d9:	83 c4 10             	add    $0x10,%esp
  8018dc:	eb eb                	jmp    8018c9 <devsock_close+0x23>

008018de <devsock_write>:
{
  8018de:	f3 0f 1e fb          	endbr32 
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018e8:	6a 00                	push   $0x0
  8018ea:	ff 75 10             	pushl  0x10(%ebp)
  8018ed:	ff 75 0c             	pushl  0xc(%ebp)
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	ff 70 0c             	pushl  0xc(%eax)
  8018f6:	e8 b5 03 00 00       	call   801cb0 <nsipc_send>
}
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <devsock_read>:
{
  8018fd:	f3 0f 1e fb          	endbr32 
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801907:	6a 00                	push   $0x0
  801909:	ff 75 10             	pushl  0x10(%ebp)
  80190c:	ff 75 0c             	pushl  0xc(%ebp)
  80190f:	8b 45 08             	mov    0x8(%ebp),%eax
  801912:	ff 70 0c             	pushl  0xc(%eax)
  801915:	e8 1f 03 00 00       	call   801c39 <nsipc_recv>
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <fd2sockid>:
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801922:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801925:	52                   	push   %edx
  801926:	50                   	push   %eax
  801927:	e8 92 f7 ff ff       	call   8010be <fd_lookup>
  80192c:	83 c4 10             	add    $0x10,%esp
  80192f:	85 c0                	test   %eax,%eax
  801931:	78 10                	js     801943 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801936:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80193c:	39 08                	cmp    %ecx,(%eax)
  80193e:	75 05                	jne    801945 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801940:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    
		return -E_NOT_SUPP;
  801945:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80194a:	eb f7                	jmp    801943 <fd2sockid+0x27>

0080194c <alloc_sockfd>:
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	56                   	push   %esi
  801950:	53                   	push   %ebx
  801951:	83 ec 1c             	sub    $0x1c,%esp
  801954:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801956:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801959:	50                   	push   %eax
  80195a:	e8 09 f7 ff ff       	call   801068 <fd_alloc>
  80195f:	89 c3                	mov    %eax,%ebx
  801961:	83 c4 10             	add    $0x10,%esp
  801964:	85 c0                	test   %eax,%eax
  801966:	78 43                	js     8019ab <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801968:	83 ec 04             	sub    $0x4,%esp
  80196b:	68 07 04 00 00       	push   $0x407
  801970:	ff 75 f4             	pushl  -0xc(%ebp)
  801973:	6a 00                	push   $0x0
  801975:	e8 ff f3 ff ff       	call   800d79 <sys_page_alloc>
  80197a:	89 c3                	mov    %eax,%ebx
  80197c:	83 c4 10             	add    $0x10,%esp
  80197f:	85 c0                	test   %eax,%eax
  801981:	78 28                	js     8019ab <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801986:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80198c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80198e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801991:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801998:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80199b:	83 ec 0c             	sub    $0xc,%esp
  80199e:	50                   	push   %eax
  80199f:	e8 95 f6 ff ff       	call   801039 <fd2num>
  8019a4:	89 c3                	mov    %eax,%ebx
  8019a6:	83 c4 10             	add    $0x10,%esp
  8019a9:	eb 0c                	jmp    8019b7 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019ab:	83 ec 0c             	sub    $0xc,%esp
  8019ae:	56                   	push   %esi
  8019af:	e8 08 02 00 00       	call   801bbc <nsipc_close>
		return r;
  8019b4:	83 c4 10             	add    $0x10,%esp
}
  8019b7:	89 d8                	mov    %ebx,%eax
  8019b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019bc:	5b                   	pop    %ebx
  8019bd:	5e                   	pop    %esi
  8019be:	5d                   	pop    %ebp
  8019bf:	c3                   	ret    

008019c0 <accept>:
{
  8019c0:	f3 0f 1e fb          	endbr32 
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	e8 4a ff ff ff       	call   80191c <fd2sockid>
  8019d2:	85 c0                	test   %eax,%eax
  8019d4:	78 1b                	js     8019f1 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019d6:	83 ec 04             	sub    $0x4,%esp
  8019d9:	ff 75 10             	pushl  0x10(%ebp)
  8019dc:	ff 75 0c             	pushl  0xc(%ebp)
  8019df:	50                   	push   %eax
  8019e0:	e8 22 01 00 00       	call   801b07 <nsipc_accept>
  8019e5:	83 c4 10             	add    $0x10,%esp
  8019e8:	85 c0                	test   %eax,%eax
  8019ea:	78 05                	js     8019f1 <accept+0x31>
	return alloc_sockfd(r);
  8019ec:	e8 5b ff ff ff       	call   80194c <alloc_sockfd>
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <bind>:
{
  8019f3:	f3 0f 1e fb          	endbr32 
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	e8 17 ff ff ff       	call   80191c <fd2sockid>
  801a05:	85 c0                	test   %eax,%eax
  801a07:	78 12                	js     801a1b <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801a09:	83 ec 04             	sub    $0x4,%esp
  801a0c:	ff 75 10             	pushl  0x10(%ebp)
  801a0f:	ff 75 0c             	pushl  0xc(%ebp)
  801a12:	50                   	push   %eax
  801a13:	e8 45 01 00 00       	call   801b5d <nsipc_bind>
  801a18:	83 c4 10             	add    $0x10,%esp
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <shutdown>:
{
  801a1d:	f3 0f 1e fb          	endbr32 
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
  801a24:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	e8 ed fe ff ff       	call   80191c <fd2sockid>
  801a2f:	85 c0                	test   %eax,%eax
  801a31:	78 0f                	js     801a42 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801a33:	83 ec 08             	sub    $0x8,%esp
  801a36:	ff 75 0c             	pushl  0xc(%ebp)
  801a39:	50                   	push   %eax
  801a3a:	e8 57 01 00 00       	call   801b96 <nsipc_shutdown>
  801a3f:	83 c4 10             	add    $0x10,%esp
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <connect>:
{
  801a44:	f3 0f 1e fb          	endbr32 
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	e8 c6 fe ff ff       	call   80191c <fd2sockid>
  801a56:	85 c0                	test   %eax,%eax
  801a58:	78 12                	js     801a6c <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801a5a:	83 ec 04             	sub    $0x4,%esp
  801a5d:	ff 75 10             	pushl  0x10(%ebp)
  801a60:	ff 75 0c             	pushl  0xc(%ebp)
  801a63:	50                   	push   %eax
  801a64:	e8 71 01 00 00       	call   801bda <nsipc_connect>
  801a69:	83 c4 10             	add    $0x10,%esp
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <listen>:
{
  801a6e:	f3 0f 1e fb          	endbr32 
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	e8 9c fe ff ff       	call   80191c <fd2sockid>
  801a80:	85 c0                	test   %eax,%eax
  801a82:	78 0f                	js     801a93 <listen+0x25>
	return nsipc_listen(r, backlog);
  801a84:	83 ec 08             	sub    $0x8,%esp
  801a87:	ff 75 0c             	pushl  0xc(%ebp)
  801a8a:	50                   	push   %eax
  801a8b:	e8 83 01 00 00       	call   801c13 <nsipc_listen>
  801a90:	83 c4 10             	add    $0x10,%esp
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a95:	f3 0f 1e fb          	endbr32 
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a9f:	ff 75 10             	pushl  0x10(%ebp)
  801aa2:	ff 75 0c             	pushl  0xc(%ebp)
  801aa5:	ff 75 08             	pushl  0x8(%ebp)
  801aa8:	e8 65 02 00 00       	call   801d12 <nsipc_socket>
  801aad:	83 c4 10             	add    $0x10,%esp
  801ab0:	85 c0                	test   %eax,%eax
  801ab2:	78 05                	js     801ab9 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801ab4:	e8 93 fe ff ff       	call   80194c <alloc_sockfd>
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	53                   	push   %ebx
  801abf:	83 ec 04             	sub    $0x4,%esp
  801ac2:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ac4:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801acb:	74 26                	je     801af3 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801acd:	6a 07                	push   $0x7
  801acf:	68 00 60 80 00       	push   $0x806000
  801ad4:	53                   	push   %ebx
  801ad5:	ff 35 04 40 80 00    	pushl  0x804004
  801adb:	e8 e0 07 00 00       	call   8022c0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ae0:	83 c4 0c             	add    $0xc,%esp
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	e8 4d 07 00 00       	call   80223b <ipc_recv>
}
  801aee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801af3:	83 ec 0c             	sub    $0xc,%esp
  801af6:	6a 02                	push   $0x2
  801af8:	e8 1b 08 00 00       	call   802318 <ipc_find_env>
  801afd:	a3 04 40 80 00       	mov    %eax,0x804004
  801b02:	83 c4 10             	add    $0x10,%esp
  801b05:	eb c6                	jmp    801acd <nsipc+0x12>

00801b07 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b07:	f3 0f 1e fb          	endbr32 
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	56                   	push   %esi
  801b0f:	53                   	push   %ebx
  801b10:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b1b:	8b 06                	mov    (%esi),%eax
  801b1d:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b22:	b8 01 00 00 00       	mov    $0x1,%eax
  801b27:	e8 8f ff ff ff       	call   801abb <nsipc>
  801b2c:	89 c3                	mov    %eax,%ebx
  801b2e:	85 c0                	test   %eax,%eax
  801b30:	79 09                	jns    801b3b <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b32:	89 d8                	mov    %ebx,%eax
  801b34:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b37:	5b                   	pop    %ebx
  801b38:	5e                   	pop    %esi
  801b39:	5d                   	pop    %ebp
  801b3a:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b3b:	83 ec 04             	sub    $0x4,%esp
  801b3e:	ff 35 10 60 80 00    	pushl  0x806010
  801b44:	68 00 60 80 00       	push   $0x806000
  801b49:	ff 75 0c             	pushl  0xc(%ebp)
  801b4c:	e8 9c ef ff ff       	call   800aed <memmove>
		*addrlen = ret->ret_addrlen;
  801b51:	a1 10 60 80 00       	mov    0x806010,%eax
  801b56:	89 06                	mov    %eax,(%esi)
  801b58:	83 c4 10             	add    $0x10,%esp
	return r;
  801b5b:	eb d5                	jmp    801b32 <nsipc_accept+0x2b>

00801b5d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b5d:	f3 0f 1e fb          	endbr32 
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	53                   	push   %ebx
  801b65:	83 ec 08             	sub    $0x8,%esp
  801b68:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b73:	53                   	push   %ebx
  801b74:	ff 75 0c             	pushl  0xc(%ebp)
  801b77:	68 04 60 80 00       	push   $0x806004
  801b7c:	e8 6c ef ff ff       	call   800aed <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b81:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b87:	b8 02 00 00 00       	mov    $0x2,%eax
  801b8c:	e8 2a ff ff ff       	call   801abb <nsipc>
}
  801b91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b96:	f3 0f 1e fb          	endbr32 
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
  801b9d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bab:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801bb0:	b8 03 00 00 00       	mov    $0x3,%eax
  801bb5:	e8 01 ff ff ff       	call   801abb <nsipc>
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <nsipc_close>:

int
nsipc_close(int s)
{
  801bbc:	f3 0f 1e fb          	endbr32 
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801bce:	b8 04 00 00 00       	mov    $0x4,%eax
  801bd3:	e8 e3 fe ff ff       	call   801abb <nsipc>
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bda:	f3 0f 1e fb          	endbr32 
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	53                   	push   %ebx
  801be2:	83 ec 08             	sub    $0x8,%esp
  801be5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bf0:	53                   	push   %ebx
  801bf1:	ff 75 0c             	pushl  0xc(%ebp)
  801bf4:	68 04 60 80 00       	push   $0x806004
  801bf9:	e8 ef ee ff ff       	call   800aed <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801bfe:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c04:	b8 05 00 00 00       	mov    $0x5,%eax
  801c09:	e8 ad fe ff ff       	call   801abb <nsipc>
}
  801c0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c13:	f3 0f 1e fb          	endbr32 
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c20:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c28:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c2d:	b8 06 00 00 00       	mov    $0x6,%eax
  801c32:	e8 84 fe ff ff       	call   801abb <nsipc>
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c39:	f3 0f 1e fb          	endbr32 
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
  801c40:	56                   	push   %esi
  801c41:	53                   	push   %ebx
  801c42:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c4d:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c53:	8b 45 14             	mov    0x14(%ebp),%eax
  801c56:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c5b:	b8 07 00 00 00       	mov    $0x7,%eax
  801c60:	e8 56 fe ff ff       	call   801abb <nsipc>
  801c65:	89 c3                	mov    %eax,%ebx
  801c67:	85 c0                	test   %eax,%eax
  801c69:	78 26                	js     801c91 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801c6b:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801c71:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801c76:	0f 4e c6             	cmovle %esi,%eax
  801c79:	39 c3                	cmp    %eax,%ebx
  801c7b:	7f 1d                	jg     801c9a <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c7d:	83 ec 04             	sub    $0x4,%esp
  801c80:	53                   	push   %ebx
  801c81:	68 00 60 80 00       	push   $0x806000
  801c86:	ff 75 0c             	pushl  0xc(%ebp)
  801c89:	e8 5f ee ff ff       	call   800aed <memmove>
  801c8e:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c91:	89 d8                	mov    %ebx,%eax
  801c93:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c96:	5b                   	pop    %ebx
  801c97:	5e                   	pop    %esi
  801c98:	5d                   	pop    %ebp
  801c99:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c9a:	68 bb 2a 80 00       	push   $0x802abb
  801c9f:	68 83 2a 80 00       	push   $0x802a83
  801ca4:	6a 62                	push   $0x62
  801ca6:	68 d0 2a 80 00       	push   $0x802ad0
  801cab:	e8 96 e5 ff ff       	call   800246 <_panic>

00801cb0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801cb0:	f3 0f 1e fb          	endbr32 
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	53                   	push   %ebx
  801cb8:	83 ec 04             	sub    $0x4,%esp
  801cbb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801cc6:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ccc:	7f 2e                	jg     801cfc <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801cce:	83 ec 04             	sub    $0x4,%esp
  801cd1:	53                   	push   %ebx
  801cd2:	ff 75 0c             	pushl  0xc(%ebp)
  801cd5:	68 0c 60 80 00       	push   $0x80600c
  801cda:	e8 0e ee ff ff       	call   800aed <memmove>
	nsipcbuf.send.req_size = size;
  801cdf:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ce5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ce8:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801ced:	b8 08 00 00 00       	mov    $0x8,%eax
  801cf2:	e8 c4 fd ff ff       	call   801abb <nsipc>
}
  801cf7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    
	assert(size < 1600);
  801cfc:	68 dc 2a 80 00       	push   $0x802adc
  801d01:	68 83 2a 80 00       	push   $0x802a83
  801d06:	6a 6d                	push   $0x6d
  801d08:	68 d0 2a 80 00       	push   $0x802ad0
  801d0d:	e8 34 e5 ff ff       	call   800246 <_panic>

00801d12 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d12:	f3 0f 1e fb          	endbr32 
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
  801d19:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d27:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d34:	b8 09 00 00 00       	mov    $0x9,%eax
  801d39:	e8 7d fd ff ff       	call   801abb <nsipc>
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d40:	f3 0f 1e fb          	endbr32 
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	56                   	push   %esi
  801d48:	53                   	push   %ebx
  801d49:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d4c:	83 ec 0c             	sub    $0xc,%esp
  801d4f:	ff 75 08             	pushl  0x8(%ebp)
  801d52:	e8 f6 f2 ff ff       	call   80104d <fd2data>
  801d57:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d59:	83 c4 08             	add    $0x8,%esp
  801d5c:	68 e8 2a 80 00       	push   $0x802ae8
  801d61:	53                   	push   %ebx
  801d62:	e8 d0 eb ff ff       	call   800937 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d67:	8b 46 04             	mov    0x4(%esi),%eax
  801d6a:	2b 06                	sub    (%esi),%eax
  801d6c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d72:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d79:	00 00 00 
	stat->st_dev = &devpipe;
  801d7c:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d83:	30 80 00 
	return 0;
}
  801d86:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d8e:	5b                   	pop    %ebx
  801d8f:	5e                   	pop    %esi
  801d90:	5d                   	pop    %ebp
  801d91:	c3                   	ret    

00801d92 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d92:	f3 0f 1e fb          	endbr32 
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	53                   	push   %ebx
  801d9a:	83 ec 0c             	sub    $0xc,%esp
  801d9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801da0:	53                   	push   %ebx
  801da1:	6a 00                	push   $0x0
  801da3:	e8 5e f0 ff ff       	call   800e06 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801da8:	89 1c 24             	mov    %ebx,(%esp)
  801dab:	e8 9d f2 ff ff       	call   80104d <fd2data>
  801db0:	83 c4 08             	add    $0x8,%esp
  801db3:	50                   	push   %eax
  801db4:	6a 00                	push   $0x0
  801db6:	e8 4b f0 ff ff       	call   800e06 <sys_page_unmap>
}
  801dbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <_pipeisclosed>:
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	57                   	push   %edi
  801dc4:	56                   	push   %esi
  801dc5:	53                   	push   %ebx
  801dc6:	83 ec 1c             	sub    $0x1c,%esp
  801dc9:	89 c7                	mov    %eax,%edi
  801dcb:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801dcd:	a1 08 40 80 00       	mov    0x804008,%eax
  801dd2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dd5:	83 ec 0c             	sub    $0xc,%esp
  801dd8:	57                   	push   %edi
  801dd9:	e8 77 05 00 00       	call   802355 <pageref>
  801dde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801de1:	89 34 24             	mov    %esi,(%esp)
  801de4:	e8 6c 05 00 00       	call   802355 <pageref>
		nn = thisenv->env_runs;
  801de9:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801def:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801df2:	83 c4 10             	add    $0x10,%esp
  801df5:	39 cb                	cmp    %ecx,%ebx
  801df7:	74 1b                	je     801e14 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801df9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dfc:	75 cf                	jne    801dcd <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801dfe:	8b 42 58             	mov    0x58(%edx),%eax
  801e01:	6a 01                	push   $0x1
  801e03:	50                   	push   %eax
  801e04:	53                   	push   %ebx
  801e05:	68 ef 2a 80 00       	push   $0x802aef
  801e0a:	e8 1e e5 ff ff       	call   80032d <cprintf>
  801e0f:	83 c4 10             	add    $0x10,%esp
  801e12:	eb b9                	jmp    801dcd <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e14:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e17:	0f 94 c0             	sete   %al
  801e1a:	0f b6 c0             	movzbl %al,%eax
}
  801e1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e20:	5b                   	pop    %ebx
  801e21:	5e                   	pop    %esi
  801e22:	5f                   	pop    %edi
  801e23:	5d                   	pop    %ebp
  801e24:	c3                   	ret    

00801e25 <devpipe_write>:
{
  801e25:	f3 0f 1e fb          	endbr32 
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	57                   	push   %edi
  801e2d:	56                   	push   %esi
  801e2e:	53                   	push   %ebx
  801e2f:	83 ec 28             	sub    $0x28,%esp
  801e32:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e35:	56                   	push   %esi
  801e36:	e8 12 f2 ff ff       	call   80104d <fd2data>
  801e3b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e3d:	83 c4 10             	add    $0x10,%esp
  801e40:	bf 00 00 00 00       	mov    $0x0,%edi
  801e45:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e48:	74 4f                	je     801e99 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e4a:	8b 43 04             	mov    0x4(%ebx),%eax
  801e4d:	8b 0b                	mov    (%ebx),%ecx
  801e4f:	8d 51 20             	lea    0x20(%ecx),%edx
  801e52:	39 d0                	cmp    %edx,%eax
  801e54:	72 14                	jb     801e6a <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801e56:	89 da                	mov    %ebx,%edx
  801e58:	89 f0                	mov    %esi,%eax
  801e5a:	e8 61 ff ff ff       	call   801dc0 <_pipeisclosed>
  801e5f:	85 c0                	test   %eax,%eax
  801e61:	75 3b                	jne    801e9e <devpipe_write+0x79>
			sys_yield();
  801e63:	e8 ee ee ff ff       	call   800d56 <sys_yield>
  801e68:	eb e0                	jmp    801e4a <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e6d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e71:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e74:	89 c2                	mov    %eax,%edx
  801e76:	c1 fa 1f             	sar    $0x1f,%edx
  801e79:	89 d1                	mov    %edx,%ecx
  801e7b:	c1 e9 1b             	shr    $0x1b,%ecx
  801e7e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e81:	83 e2 1f             	and    $0x1f,%edx
  801e84:	29 ca                	sub    %ecx,%edx
  801e86:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e8a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e8e:	83 c0 01             	add    $0x1,%eax
  801e91:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e94:	83 c7 01             	add    $0x1,%edi
  801e97:	eb ac                	jmp    801e45 <devpipe_write+0x20>
	return i;
  801e99:	8b 45 10             	mov    0x10(%ebp),%eax
  801e9c:	eb 05                	jmp    801ea3 <devpipe_write+0x7e>
				return 0;
  801e9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ea6:	5b                   	pop    %ebx
  801ea7:	5e                   	pop    %esi
  801ea8:	5f                   	pop    %edi
  801ea9:	5d                   	pop    %ebp
  801eaa:	c3                   	ret    

00801eab <devpipe_read>:
{
  801eab:	f3 0f 1e fb          	endbr32 
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	57                   	push   %edi
  801eb3:	56                   	push   %esi
  801eb4:	53                   	push   %ebx
  801eb5:	83 ec 18             	sub    $0x18,%esp
  801eb8:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ebb:	57                   	push   %edi
  801ebc:	e8 8c f1 ff ff       	call   80104d <fd2data>
  801ec1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ec3:	83 c4 10             	add    $0x10,%esp
  801ec6:	be 00 00 00 00       	mov    $0x0,%esi
  801ecb:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ece:	75 14                	jne    801ee4 <devpipe_read+0x39>
	return i;
  801ed0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed3:	eb 02                	jmp    801ed7 <devpipe_read+0x2c>
				return i;
  801ed5:	89 f0                	mov    %esi,%eax
}
  801ed7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eda:	5b                   	pop    %ebx
  801edb:	5e                   	pop    %esi
  801edc:	5f                   	pop    %edi
  801edd:	5d                   	pop    %ebp
  801ede:	c3                   	ret    
			sys_yield();
  801edf:	e8 72 ee ff ff       	call   800d56 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ee4:	8b 03                	mov    (%ebx),%eax
  801ee6:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ee9:	75 18                	jne    801f03 <devpipe_read+0x58>
			if (i > 0)
  801eeb:	85 f6                	test   %esi,%esi
  801eed:	75 e6                	jne    801ed5 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801eef:	89 da                	mov    %ebx,%edx
  801ef1:	89 f8                	mov    %edi,%eax
  801ef3:	e8 c8 fe ff ff       	call   801dc0 <_pipeisclosed>
  801ef8:	85 c0                	test   %eax,%eax
  801efa:	74 e3                	je     801edf <devpipe_read+0x34>
				return 0;
  801efc:	b8 00 00 00 00       	mov    $0x0,%eax
  801f01:	eb d4                	jmp    801ed7 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f03:	99                   	cltd   
  801f04:	c1 ea 1b             	shr    $0x1b,%edx
  801f07:	01 d0                	add    %edx,%eax
  801f09:	83 e0 1f             	and    $0x1f,%eax
  801f0c:	29 d0                	sub    %edx,%eax
  801f0e:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f16:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f19:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f1c:	83 c6 01             	add    $0x1,%esi
  801f1f:	eb aa                	jmp    801ecb <devpipe_read+0x20>

00801f21 <pipe>:
{
  801f21:	f3 0f 1e fb          	endbr32 
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
  801f28:	56                   	push   %esi
  801f29:	53                   	push   %ebx
  801f2a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f30:	50                   	push   %eax
  801f31:	e8 32 f1 ff ff       	call   801068 <fd_alloc>
  801f36:	89 c3                	mov    %eax,%ebx
  801f38:	83 c4 10             	add    $0x10,%esp
  801f3b:	85 c0                	test   %eax,%eax
  801f3d:	0f 88 23 01 00 00    	js     802066 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f43:	83 ec 04             	sub    $0x4,%esp
  801f46:	68 07 04 00 00       	push   $0x407
  801f4b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f4e:	6a 00                	push   $0x0
  801f50:	e8 24 ee ff ff       	call   800d79 <sys_page_alloc>
  801f55:	89 c3                	mov    %eax,%ebx
  801f57:	83 c4 10             	add    $0x10,%esp
  801f5a:	85 c0                	test   %eax,%eax
  801f5c:	0f 88 04 01 00 00    	js     802066 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801f62:	83 ec 0c             	sub    $0xc,%esp
  801f65:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f68:	50                   	push   %eax
  801f69:	e8 fa f0 ff ff       	call   801068 <fd_alloc>
  801f6e:	89 c3                	mov    %eax,%ebx
  801f70:	83 c4 10             	add    $0x10,%esp
  801f73:	85 c0                	test   %eax,%eax
  801f75:	0f 88 db 00 00 00    	js     802056 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f7b:	83 ec 04             	sub    $0x4,%esp
  801f7e:	68 07 04 00 00       	push   $0x407
  801f83:	ff 75 f0             	pushl  -0x10(%ebp)
  801f86:	6a 00                	push   $0x0
  801f88:	e8 ec ed ff ff       	call   800d79 <sys_page_alloc>
  801f8d:	89 c3                	mov    %eax,%ebx
  801f8f:	83 c4 10             	add    $0x10,%esp
  801f92:	85 c0                	test   %eax,%eax
  801f94:	0f 88 bc 00 00 00    	js     802056 <pipe+0x135>
	va = fd2data(fd0);
  801f9a:	83 ec 0c             	sub    $0xc,%esp
  801f9d:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa0:	e8 a8 f0 ff ff       	call   80104d <fd2data>
  801fa5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fa7:	83 c4 0c             	add    $0xc,%esp
  801faa:	68 07 04 00 00       	push   $0x407
  801faf:	50                   	push   %eax
  801fb0:	6a 00                	push   $0x0
  801fb2:	e8 c2 ed ff ff       	call   800d79 <sys_page_alloc>
  801fb7:	89 c3                	mov    %eax,%ebx
  801fb9:	83 c4 10             	add    $0x10,%esp
  801fbc:	85 c0                	test   %eax,%eax
  801fbe:	0f 88 82 00 00 00    	js     802046 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fc4:	83 ec 0c             	sub    $0xc,%esp
  801fc7:	ff 75 f0             	pushl  -0x10(%ebp)
  801fca:	e8 7e f0 ff ff       	call   80104d <fd2data>
  801fcf:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fd6:	50                   	push   %eax
  801fd7:	6a 00                	push   $0x0
  801fd9:	56                   	push   %esi
  801fda:	6a 00                	push   $0x0
  801fdc:	e8 df ed ff ff       	call   800dc0 <sys_page_map>
  801fe1:	89 c3                	mov    %eax,%ebx
  801fe3:	83 c4 20             	add    $0x20,%esp
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	78 4e                	js     802038 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801fea:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801fef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff2:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ff4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801ffe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802001:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802006:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80200d:	83 ec 0c             	sub    $0xc,%esp
  802010:	ff 75 f4             	pushl  -0xc(%ebp)
  802013:	e8 21 f0 ff ff       	call   801039 <fd2num>
  802018:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80201b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80201d:	83 c4 04             	add    $0x4,%esp
  802020:	ff 75 f0             	pushl  -0x10(%ebp)
  802023:	e8 11 f0 ff ff       	call   801039 <fd2num>
  802028:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80202b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80202e:	83 c4 10             	add    $0x10,%esp
  802031:	bb 00 00 00 00       	mov    $0x0,%ebx
  802036:	eb 2e                	jmp    802066 <pipe+0x145>
	sys_page_unmap(0, va);
  802038:	83 ec 08             	sub    $0x8,%esp
  80203b:	56                   	push   %esi
  80203c:	6a 00                	push   $0x0
  80203e:	e8 c3 ed ff ff       	call   800e06 <sys_page_unmap>
  802043:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802046:	83 ec 08             	sub    $0x8,%esp
  802049:	ff 75 f0             	pushl  -0x10(%ebp)
  80204c:	6a 00                	push   $0x0
  80204e:	e8 b3 ed ff ff       	call   800e06 <sys_page_unmap>
  802053:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802056:	83 ec 08             	sub    $0x8,%esp
  802059:	ff 75 f4             	pushl  -0xc(%ebp)
  80205c:	6a 00                	push   $0x0
  80205e:	e8 a3 ed ff ff       	call   800e06 <sys_page_unmap>
  802063:	83 c4 10             	add    $0x10,%esp
}
  802066:	89 d8                	mov    %ebx,%eax
  802068:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80206b:	5b                   	pop    %ebx
  80206c:	5e                   	pop    %esi
  80206d:	5d                   	pop    %ebp
  80206e:	c3                   	ret    

0080206f <pipeisclosed>:
{
  80206f:	f3 0f 1e fb          	endbr32 
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
  802076:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802079:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80207c:	50                   	push   %eax
  80207d:	ff 75 08             	pushl  0x8(%ebp)
  802080:	e8 39 f0 ff ff       	call   8010be <fd_lookup>
  802085:	83 c4 10             	add    $0x10,%esp
  802088:	85 c0                	test   %eax,%eax
  80208a:	78 18                	js     8020a4 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80208c:	83 ec 0c             	sub    $0xc,%esp
  80208f:	ff 75 f4             	pushl  -0xc(%ebp)
  802092:	e8 b6 ef ff ff       	call   80104d <fd2data>
  802097:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209c:	e8 1f fd ff ff       	call   801dc0 <_pipeisclosed>
  8020a1:	83 c4 10             	add    $0x10,%esp
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8020a6:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8020aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8020af:	c3                   	ret    

008020b0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020b0:	f3 0f 1e fb          	endbr32 
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
  8020b7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8020ba:	68 07 2b 80 00       	push   $0x802b07
  8020bf:	ff 75 0c             	pushl  0xc(%ebp)
  8020c2:	e8 70 e8 ff ff       	call   800937 <strcpy>
	return 0;
}
  8020c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020cc:	c9                   	leave  
  8020cd:	c3                   	ret    

008020ce <devcons_write>:
{
  8020ce:	f3 0f 1e fb          	endbr32 
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	57                   	push   %edi
  8020d6:	56                   	push   %esi
  8020d7:	53                   	push   %ebx
  8020d8:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020de:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020e3:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020e9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020ec:	73 31                	jae    80211f <devcons_write+0x51>
		m = n - tot;
  8020ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020f1:	29 f3                	sub    %esi,%ebx
  8020f3:	83 fb 7f             	cmp    $0x7f,%ebx
  8020f6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020fb:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020fe:	83 ec 04             	sub    $0x4,%esp
  802101:	53                   	push   %ebx
  802102:	89 f0                	mov    %esi,%eax
  802104:	03 45 0c             	add    0xc(%ebp),%eax
  802107:	50                   	push   %eax
  802108:	57                   	push   %edi
  802109:	e8 df e9 ff ff       	call   800aed <memmove>
		sys_cputs(buf, m);
  80210e:	83 c4 08             	add    $0x8,%esp
  802111:	53                   	push   %ebx
  802112:	57                   	push   %edi
  802113:	e8 91 eb ff ff       	call   800ca9 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802118:	01 de                	add    %ebx,%esi
  80211a:	83 c4 10             	add    $0x10,%esp
  80211d:	eb ca                	jmp    8020e9 <devcons_write+0x1b>
}
  80211f:	89 f0                	mov    %esi,%eax
  802121:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802124:	5b                   	pop    %ebx
  802125:	5e                   	pop    %esi
  802126:	5f                   	pop    %edi
  802127:	5d                   	pop    %ebp
  802128:	c3                   	ret    

00802129 <devcons_read>:
{
  802129:	f3 0f 1e fb          	endbr32 
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
  802130:	83 ec 08             	sub    $0x8,%esp
  802133:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802138:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80213c:	74 21                	je     80215f <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80213e:	e8 88 eb ff ff       	call   800ccb <sys_cgetc>
  802143:	85 c0                	test   %eax,%eax
  802145:	75 07                	jne    80214e <devcons_read+0x25>
		sys_yield();
  802147:	e8 0a ec ff ff       	call   800d56 <sys_yield>
  80214c:	eb f0                	jmp    80213e <devcons_read+0x15>
	if (c < 0)
  80214e:	78 0f                	js     80215f <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802150:	83 f8 04             	cmp    $0x4,%eax
  802153:	74 0c                	je     802161 <devcons_read+0x38>
	*(char*)vbuf = c;
  802155:	8b 55 0c             	mov    0xc(%ebp),%edx
  802158:	88 02                	mov    %al,(%edx)
	return 1;
  80215a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80215f:	c9                   	leave  
  802160:	c3                   	ret    
		return 0;
  802161:	b8 00 00 00 00       	mov    $0x0,%eax
  802166:	eb f7                	jmp    80215f <devcons_read+0x36>

00802168 <cputchar>:
{
  802168:	f3 0f 1e fb          	endbr32 
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802178:	6a 01                	push   $0x1
  80217a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80217d:	50                   	push   %eax
  80217e:	e8 26 eb ff ff       	call   800ca9 <sys_cputs>
}
  802183:	83 c4 10             	add    $0x10,%esp
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <getchar>:
{
  802188:	f3 0f 1e fb          	endbr32 
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802192:	6a 01                	push   $0x1
  802194:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802197:	50                   	push   %eax
  802198:	6a 00                	push   $0x0
  80219a:	e8 a7 f1 ff ff       	call   801346 <read>
	if (r < 0)
  80219f:	83 c4 10             	add    $0x10,%esp
  8021a2:	85 c0                	test   %eax,%eax
  8021a4:	78 06                	js     8021ac <getchar+0x24>
	if (r < 1)
  8021a6:	74 06                	je     8021ae <getchar+0x26>
	return c;
  8021a8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021ac:	c9                   	leave  
  8021ad:	c3                   	ret    
		return -E_EOF;
  8021ae:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021b3:	eb f7                	jmp    8021ac <getchar+0x24>

008021b5 <iscons>:
{
  8021b5:	f3 0f 1e fb          	endbr32 
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021c2:	50                   	push   %eax
  8021c3:	ff 75 08             	pushl  0x8(%ebp)
  8021c6:	e8 f3 ee ff ff       	call   8010be <fd_lookup>
  8021cb:	83 c4 10             	add    $0x10,%esp
  8021ce:	85 c0                	test   %eax,%eax
  8021d0:	78 11                	js     8021e3 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8021d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d5:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021db:	39 10                	cmp    %edx,(%eax)
  8021dd:	0f 94 c0             	sete   %al
  8021e0:	0f b6 c0             	movzbl %al,%eax
}
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    

008021e5 <opencons>:
{
  8021e5:	f3 0f 1e fb          	endbr32 
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
  8021ec:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021f2:	50                   	push   %eax
  8021f3:	e8 70 ee ff ff       	call   801068 <fd_alloc>
  8021f8:	83 c4 10             	add    $0x10,%esp
  8021fb:	85 c0                	test   %eax,%eax
  8021fd:	78 3a                	js     802239 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021ff:	83 ec 04             	sub    $0x4,%esp
  802202:	68 07 04 00 00       	push   $0x407
  802207:	ff 75 f4             	pushl  -0xc(%ebp)
  80220a:	6a 00                	push   $0x0
  80220c:	e8 68 eb ff ff       	call   800d79 <sys_page_alloc>
  802211:	83 c4 10             	add    $0x10,%esp
  802214:	85 c0                	test   %eax,%eax
  802216:	78 21                	js     802239 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802221:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802226:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80222d:	83 ec 0c             	sub    $0xc,%esp
  802230:	50                   	push   %eax
  802231:	e8 03 ee ff ff       	call   801039 <fd2num>
  802236:	83 c4 10             	add    $0x10,%esp
}
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80223b:	f3 0f 1e fb          	endbr32 
  80223f:	55                   	push   %ebp
  802240:	89 e5                	mov    %esp,%ebp
  802242:	56                   	push   %esi
  802243:	53                   	push   %ebx
  802244:	8b 75 08             	mov    0x8(%ebp),%esi
  802247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  80224d:	85 c0                	test   %eax,%eax
  80224f:	74 3d                	je     80228e <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  802251:	83 ec 0c             	sub    $0xc,%esp
  802254:	50                   	push   %eax
  802255:	e8 eb ec ff ff       	call   800f45 <sys_ipc_recv>
  80225a:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  80225d:	85 f6                	test   %esi,%esi
  80225f:	74 0b                	je     80226c <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802261:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802267:	8b 52 74             	mov    0x74(%edx),%edx
  80226a:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  80226c:	85 db                	test   %ebx,%ebx
  80226e:	74 0b                	je     80227b <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  802270:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802276:	8b 52 78             	mov    0x78(%edx),%edx
  802279:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  80227b:	85 c0                	test   %eax,%eax
  80227d:	78 21                	js     8022a0 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  80227f:	a1 08 40 80 00       	mov    0x804008,%eax
  802284:	8b 40 70             	mov    0x70(%eax),%eax
}
  802287:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80228a:	5b                   	pop    %ebx
  80228b:	5e                   	pop    %esi
  80228c:	5d                   	pop    %ebp
  80228d:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  80228e:	83 ec 0c             	sub    $0xc,%esp
  802291:	68 00 00 c0 ee       	push   $0xeec00000
  802296:	e8 aa ec ff ff       	call   800f45 <sys_ipc_recv>
  80229b:	83 c4 10             	add    $0x10,%esp
  80229e:	eb bd                	jmp    80225d <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  8022a0:	85 f6                	test   %esi,%esi
  8022a2:	74 10                	je     8022b4 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  8022a4:	85 db                	test   %ebx,%ebx
  8022a6:	75 df                	jne    802287 <ipc_recv+0x4c>
  8022a8:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8022af:	00 00 00 
  8022b2:	eb d3                	jmp    802287 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  8022b4:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  8022bb:	00 00 00 
  8022be:	eb e4                	jmp    8022a4 <ipc_recv+0x69>

008022c0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022c0:	f3 0f 1e fb          	endbr32 
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
  8022c7:	57                   	push   %edi
  8022c8:	56                   	push   %esi
  8022c9:	53                   	push   %ebx
  8022ca:	83 ec 0c             	sub    $0xc,%esp
  8022cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022d0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  8022d6:	85 db                	test   %ebx,%ebx
  8022d8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022dd:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  8022e0:	ff 75 14             	pushl  0x14(%ebp)
  8022e3:	53                   	push   %ebx
  8022e4:	56                   	push   %esi
  8022e5:	57                   	push   %edi
  8022e6:	e8 33 ec ff ff       	call   800f1e <sys_ipc_try_send>
  8022eb:	83 c4 10             	add    $0x10,%esp
  8022ee:	85 c0                	test   %eax,%eax
  8022f0:	79 1e                	jns    802310 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  8022f2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022f5:	75 07                	jne    8022fe <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  8022f7:	e8 5a ea ff ff       	call   800d56 <sys_yield>
  8022fc:	eb e2                	jmp    8022e0 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  8022fe:	50                   	push   %eax
  8022ff:	68 13 2b 80 00       	push   $0x802b13
  802304:	6a 59                	push   $0x59
  802306:	68 2e 2b 80 00       	push   $0x802b2e
  80230b:	e8 36 df ff ff       	call   800246 <_panic>
	}
}
  802310:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802313:	5b                   	pop    %ebx
  802314:	5e                   	pop    %esi
  802315:	5f                   	pop    %edi
  802316:	5d                   	pop    %ebp
  802317:	c3                   	ret    

00802318 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802318:	f3 0f 1e fb          	endbr32 
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
  80231f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802322:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802327:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80232a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802330:	8b 52 50             	mov    0x50(%edx),%edx
  802333:	39 ca                	cmp    %ecx,%edx
  802335:	74 11                	je     802348 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802337:	83 c0 01             	add    $0x1,%eax
  80233a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80233f:	75 e6                	jne    802327 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802341:	b8 00 00 00 00       	mov    $0x0,%eax
  802346:	eb 0b                	jmp    802353 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802348:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80234b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802350:	8b 40 48             	mov    0x48(%eax),%eax
}
  802353:	5d                   	pop    %ebp
  802354:	c3                   	ret    

00802355 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802355:	f3 0f 1e fb          	endbr32 
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80235f:	89 c2                	mov    %eax,%edx
  802361:	c1 ea 16             	shr    $0x16,%edx
  802364:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80236b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802370:	f6 c1 01             	test   $0x1,%cl
  802373:	74 1c                	je     802391 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802375:	c1 e8 0c             	shr    $0xc,%eax
  802378:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80237f:	a8 01                	test   $0x1,%al
  802381:	74 0e                	je     802391 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802383:	c1 e8 0c             	shr    $0xc,%eax
  802386:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80238d:	ef 
  80238e:	0f b7 d2             	movzwl %dx,%edx
}
  802391:	89 d0                	mov    %edx,%eax
  802393:	5d                   	pop    %ebp
  802394:	c3                   	ret    
  802395:	66 90                	xchg   %ax,%ax
  802397:	66 90                	xchg   %ax,%ax
  802399:	66 90                	xchg   %ax,%ax
  80239b:	66 90                	xchg   %ax,%ax
  80239d:	66 90                	xchg   %ax,%ax
  80239f:	90                   	nop

008023a0 <__udivdi3>:
  8023a0:	f3 0f 1e fb          	endbr32 
  8023a4:	55                   	push   %ebp
  8023a5:	57                   	push   %edi
  8023a6:	56                   	push   %esi
  8023a7:	53                   	push   %ebx
  8023a8:	83 ec 1c             	sub    $0x1c,%esp
  8023ab:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023af:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023b7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023bb:	85 d2                	test   %edx,%edx
  8023bd:	75 19                	jne    8023d8 <__udivdi3+0x38>
  8023bf:	39 f3                	cmp    %esi,%ebx
  8023c1:	76 4d                	jbe    802410 <__udivdi3+0x70>
  8023c3:	31 ff                	xor    %edi,%edi
  8023c5:	89 e8                	mov    %ebp,%eax
  8023c7:	89 f2                	mov    %esi,%edx
  8023c9:	f7 f3                	div    %ebx
  8023cb:	89 fa                	mov    %edi,%edx
  8023cd:	83 c4 1c             	add    $0x1c,%esp
  8023d0:	5b                   	pop    %ebx
  8023d1:	5e                   	pop    %esi
  8023d2:	5f                   	pop    %edi
  8023d3:	5d                   	pop    %ebp
  8023d4:	c3                   	ret    
  8023d5:	8d 76 00             	lea    0x0(%esi),%esi
  8023d8:	39 f2                	cmp    %esi,%edx
  8023da:	76 14                	jbe    8023f0 <__udivdi3+0x50>
  8023dc:	31 ff                	xor    %edi,%edi
  8023de:	31 c0                	xor    %eax,%eax
  8023e0:	89 fa                	mov    %edi,%edx
  8023e2:	83 c4 1c             	add    $0x1c,%esp
  8023e5:	5b                   	pop    %ebx
  8023e6:	5e                   	pop    %esi
  8023e7:	5f                   	pop    %edi
  8023e8:	5d                   	pop    %ebp
  8023e9:	c3                   	ret    
  8023ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8023f0:	0f bd fa             	bsr    %edx,%edi
  8023f3:	83 f7 1f             	xor    $0x1f,%edi
  8023f6:	75 48                	jne    802440 <__udivdi3+0xa0>
  8023f8:	39 f2                	cmp    %esi,%edx
  8023fa:	72 06                	jb     802402 <__udivdi3+0x62>
  8023fc:	31 c0                	xor    %eax,%eax
  8023fe:	39 eb                	cmp    %ebp,%ebx
  802400:	77 de                	ja     8023e0 <__udivdi3+0x40>
  802402:	b8 01 00 00 00       	mov    $0x1,%eax
  802407:	eb d7                	jmp    8023e0 <__udivdi3+0x40>
  802409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802410:	89 d9                	mov    %ebx,%ecx
  802412:	85 db                	test   %ebx,%ebx
  802414:	75 0b                	jne    802421 <__udivdi3+0x81>
  802416:	b8 01 00 00 00       	mov    $0x1,%eax
  80241b:	31 d2                	xor    %edx,%edx
  80241d:	f7 f3                	div    %ebx
  80241f:	89 c1                	mov    %eax,%ecx
  802421:	31 d2                	xor    %edx,%edx
  802423:	89 f0                	mov    %esi,%eax
  802425:	f7 f1                	div    %ecx
  802427:	89 c6                	mov    %eax,%esi
  802429:	89 e8                	mov    %ebp,%eax
  80242b:	89 f7                	mov    %esi,%edi
  80242d:	f7 f1                	div    %ecx
  80242f:	89 fa                	mov    %edi,%edx
  802431:	83 c4 1c             	add    $0x1c,%esp
  802434:	5b                   	pop    %ebx
  802435:	5e                   	pop    %esi
  802436:	5f                   	pop    %edi
  802437:	5d                   	pop    %ebp
  802438:	c3                   	ret    
  802439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802440:	89 f9                	mov    %edi,%ecx
  802442:	b8 20 00 00 00       	mov    $0x20,%eax
  802447:	29 f8                	sub    %edi,%eax
  802449:	d3 e2                	shl    %cl,%edx
  80244b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80244f:	89 c1                	mov    %eax,%ecx
  802451:	89 da                	mov    %ebx,%edx
  802453:	d3 ea                	shr    %cl,%edx
  802455:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802459:	09 d1                	or     %edx,%ecx
  80245b:	89 f2                	mov    %esi,%edx
  80245d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802461:	89 f9                	mov    %edi,%ecx
  802463:	d3 e3                	shl    %cl,%ebx
  802465:	89 c1                	mov    %eax,%ecx
  802467:	d3 ea                	shr    %cl,%edx
  802469:	89 f9                	mov    %edi,%ecx
  80246b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80246f:	89 eb                	mov    %ebp,%ebx
  802471:	d3 e6                	shl    %cl,%esi
  802473:	89 c1                	mov    %eax,%ecx
  802475:	d3 eb                	shr    %cl,%ebx
  802477:	09 de                	or     %ebx,%esi
  802479:	89 f0                	mov    %esi,%eax
  80247b:	f7 74 24 08          	divl   0x8(%esp)
  80247f:	89 d6                	mov    %edx,%esi
  802481:	89 c3                	mov    %eax,%ebx
  802483:	f7 64 24 0c          	mull   0xc(%esp)
  802487:	39 d6                	cmp    %edx,%esi
  802489:	72 15                	jb     8024a0 <__udivdi3+0x100>
  80248b:	89 f9                	mov    %edi,%ecx
  80248d:	d3 e5                	shl    %cl,%ebp
  80248f:	39 c5                	cmp    %eax,%ebp
  802491:	73 04                	jae    802497 <__udivdi3+0xf7>
  802493:	39 d6                	cmp    %edx,%esi
  802495:	74 09                	je     8024a0 <__udivdi3+0x100>
  802497:	89 d8                	mov    %ebx,%eax
  802499:	31 ff                	xor    %edi,%edi
  80249b:	e9 40 ff ff ff       	jmp    8023e0 <__udivdi3+0x40>
  8024a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024a3:	31 ff                	xor    %edi,%edi
  8024a5:	e9 36 ff ff ff       	jmp    8023e0 <__udivdi3+0x40>
  8024aa:	66 90                	xchg   %ax,%ax
  8024ac:	66 90                	xchg   %ax,%ax
  8024ae:	66 90                	xchg   %ax,%ax

008024b0 <__umoddi3>:
  8024b0:	f3 0f 1e fb          	endbr32 
  8024b4:	55                   	push   %ebp
  8024b5:	57                   	push   %edi
  8024b6:	56                   	push   %esi
  8024b7:	53                   	push   %ebx
  8024b8:	83 ec 1c             	sub    $0x1c,%esp
  8024bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024bf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024c3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024cb:	85 c0                	test   %eax,%eax
  8024cd:	75 19                	jne    8024e8 <__umoddi3+0x38>
  8024cf:	39 df                	cmp    %ebx,%edi
  8024d1:	76 5d                	jbe    802530 <__umoddi3+0x80>
  8024d3:	89 f0                	mov    %esi,%eax
  8024d5:	89 da                	mov    %ebx,%edx
  8024d7:	f7 f7                	div    %edi
  8024d9:	89 d0                	mov    %edx,%eax
  8024db:	31 d2                	xor    %edx,%edx
  8024dd:	83 c4 1c             	add    $0x1c,%esp
  8024e0:	5b                   	pop    %ebx
  8024e1:	5e                   	pop    %esi
  8024e2:	5f                   	pop    %edi
  8024e3:	5d                   	pop    %ebp
  8024e4:	c3                   	ret    
  8024e5:	8d 76 00             	lea    0x0(%esi),%esi
  8024e8:	89 f2                	mov    %esi,%edx
  8024ea:	39 d8                	cmp    %ebx,%eax
  8024ec:	76 12                	jbe    802500 <__umoddi3+0x50>
  8024ee:	89 f0                	mov    %esi,%eax
  8024f0:	89 da                	mov    %ebx,%edx
  8024f2:	83 c4 1c             	add    $0x1c,%esp
  8024f5:	5b                   	pop    %ebx
  8024f6:	5e                   	pop    %esi
  8024f7:	5f                   	pop    %edi
  8024f8:	5d                   	pop    %ebp
  8024f9:	c3                   	ret    
  8024fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802500:	0f bd e8             	bsr    %eax,%ebp
  802503:	83 f5 1f             	xor    $0x1f,%ebp
  802506:	75 50                	jne    802558 <__umoddi3+0xa8>
  802508:	39 d8                	cmp    %ebx,%eax
  80250a:	0f 82 e0 00 00 00    	jb     8025f0 <__umoddi3+0x140>
  802510:	89 d9                	mov    %ebx,%ecx
  802512:	39 f7                	cmp    %esi,%edi
  802514:	0f 86 d6 00 00 00    	jbe    8025f0 <__umoddi3+0x140>
  80251a:	89 d0                	mov    %edx,%eax
  80251c:	89 ca                	mov    %ecx,%edx
  80251e:	83 c4 1c             	add    $0x1c,%esp
  802521:	5b                   	pop    %ebx
  802522:	5e                   	pop    %esi
  802523:	5f                   	pop    %edi
  802524:	5d                   	pop    %ebp
  802525:	c3                   	ret    
  802526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80252d:	8d 76 00             	lea    0x0(%esi),%esi
  802530:	89 fd                	mov    %edi,%ebp
  802532:	85 ff                	test   %edi,%edi
  802534:	75 0b                	jne    802541 <__umoddi3+0x91>
  802536:	b8 01 00 00 00       	mov    $0x1,%eax
  80253b:	31 d2                	xor    %edx,%edx
  80253d:	f7 f7                	div    %edi
  80253f:	89 c5                	mov    %eax,%ebp
  802541:	89 d8                	mov    %ebx,%eax
  802543:	31 d2                	xor    %edx,%edx
  802545:	f7 f5                	div    %ebp
  802547:	89 f0                	mov    %esi,%eax
  802549:	f7 f5                	div    %ebp
  80254b:	89 d0                	mov    %edx,%eax
  80254d:	31 d2                	xor    %edx,%edx
  80254f:	eb 8c                	jmp    8024dd <__umoddi3+0x2d>
  802551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802558:	89 e9                	mov    %ebp,%ecx
  80255a:	ba 20 00 00 00       	mov    $0x20,%edx
  80255f:	29 ea                	sub    %ebp,%edx
  802561:	d3 e0                	shl    %cl,%eax
  802563:	89 44 24 08          	mov    %eax,0x8(%esp)
  802567:	89 d1                	mov    %edx,%ecx
  802569:	89 f8                	mov    %edi,%eax
  80256b:	d3 e8                	shr    %cl,%eax
  80256d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802571:	89 54 24 04          	mov    %edx,0x4(%esp)
  802575:	8b 54 24 04          	mov    0x4(%esp),%edx
  802579:	09 c1                	or     %eax,%ecx
  80257b:	89 d8                	mov    %ebx,%eax
  80257d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802581:	89 e9                	mov    %ebp,%ecx
  802583:	d3 e7                	shl    %cl,%edi
  802585:	89 d1                	mov    %edx,%ecx
  802587:	d3 e8                	shr    %cl,%eax
  802589:	89 e9                	mov    %ebp,%ecx
  80258b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80258f:	d3 e3                	shl    %cl,%ebx
  802591:	89 c7                	mov    %eax,%edi
  802593:	89 d1                	mov    %edx,%ecx
  802595:	89 f0                	mov    %esi,%eax
  802597:	d3 e8                	shr    %cl,%eax
  802599:	89 e9                	mov    %ebp,%ecx
  80259b:	89 fa                	mov    %edi,%edx
  80259d:	d3 e6                	shl    %cl,%esi
  80259f:	09 d8                	or     %ebx,%eax
  8025a1:	f7 74 24 08          	divl   0x8(%esp)
  8025a5:	89 d1                	mov    %edx,%ecx
  8025a7:	89 f3                	mov    %esi,%ebx
  8025a9:	f7 64 24 0c          	mull   0xc(%esp)
  8025ad:	89 c6                	mov    %eax,%esi
  8025af:	89 d7                	mov    %edx,%edi
  8025b1:	39 d1                	cmp    %edx,%ecx
  8025b3:	72 06                	jb     8025bb <__umoddi3+0x10b>
  8025b5:	75 10                	jne    8025c7 <__umoddi3+0x117>
  8025b7:	39 c3                	cmp    %eax,%ebx
  8025b9:	73 0c                	jae    8025c7 <__umoddi3+0x117>
  8025bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8025bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8025c3:	89 d7                	mov    %edx,%edi
  8025c5:	89 c6                	mov    %eax,%esi
  8025c7:	89 ca                	mov    %ecx,%edx
  8025c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025ce:	29 f3                	sub    %esi,%ebx
  8025d0:	19 fa                	sbb    %edi,%edx
  8025d2:	89 d0                	mov    %edx,%eax
  8025d4:	d3 e0                	shl    %cl,%eax
  8025d6:	89 e9                	mov    %ebp,%ecx
  8025d8:	d3 eb                	shr    %cl,%ebx
  8025da:	d3 ea                	shr    %cl,%edx
  8025dc:	09 d8                	or     %ebx,%eax
  8025de:	83 c4 1c             	add    $0x1c,%esp
  8025e1:	5b                   	pop    %ebx
  8025e2:	5e                   	pop    %esi
  8025e3:	5f                   	pop    %edi
  8025e4:	5d                   	pop    %ebp
  8025e5:	c3                   	ret    
  8025e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025ed:	8d 76 00             	lea    0x0(%esi),%esi
  8025f0:	29 fe                	sub    %edi,%esi
  8025f2:	19 c3                	sbb    %eax,%ebx
  8025f4:	89 f2                	mov    %esi,%edx
  8025f6:	89 d9                	mov    %ebx,%ecx
  8025f8:	e9 1d ff ff ff       	jmp    80251a <__umoddi3+0x6a>
