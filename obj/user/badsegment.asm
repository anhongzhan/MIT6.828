
obj/user/badsegment:     file format elf32-i386


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
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800037:	66 b8 28 00          	mov    $0x28,%ax
  80003b:	8e d8                	mov    %eax,%ds
}
  80003d:	c3                   	ret    

0080003e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003e:	f3 0f 1e fb          	endbr32 
  800042:	55                   	push   %ebp
  800043:	89 e5                	mov    %esp,%ebp
  800045:	57                   	push   %edi
  800046:	56                   	push   %esi
  800047:	53                   	push   %ebx
  800048:	83 ec 0c             	sub    $0xc,%esp
  80004b:	e8 50 00 00 00       	call   8000a0 <__x86.get_pc_thunk.bx>
  800050:	81 c3 b0 1f 00 00    	add    $0x1fb0,%ebx
  800056:	8b 75 08             	mov    0x8(%ebp),%esi
  800059:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80005c:	e8 06 01 00 00       	call   800167 <sys_getenvid>
  800061:	25 ff 03 00 00       	and    $0x3ff,%eax
  800066:	8d 04 40             	lea    (%eax,%eax,2),%eax
  800069:	c1 e0 05             	shl    $0x5,%eax
  80006c:	81 c0 00 00 c0 ee    	add    $0xeec00000,%eax
  800072:	c7 c2 2c 20 80 00    	mov    $0x80202c,%edx
  800078:	89 02                	mov    %eax,(%edx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80007a:	85 f6                	test   %esi,%esi
  80007c:	7e 08                	jle    800086 <libmain+0x48>
		binaryname = argv[0];
  80007e:	8b 07                	mov    (%edi),%eax
  800080:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  800086:	83 ec 08             	sub    $0x8,%esp
  800089:	57                   	push   %edi
  80008a:	56                   	push   %esi
  80008b:	e8 a3 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800090:	e8 0f 00 00 00       	call   8000a4 <exit>
}
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80009b:	5b                   	pop    %ebx
  80009c:	5e                   	pop    %esi
  80009d:	5f                   	pop    %edi
  80009e:	5d                   	pop    %ebp
  80009f:	c3                   	ret    

008000a0 <__x86.get_pc_thunk.bx>:
  8000a0:	8b 1c 24             	mov    (%esp),%ebx
  8000a3:	c3                   	ret    

008000a4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a4:	f3 0f 1e fb          	endbr32 
  8000a8:	55                   	push   %ebp
  8000a9:	89 e5                	mov    %esp,%ebp
  8000ab:	53                   	push   %ebx
  8000ac:	83 ec 10             	sub    $0x10,%esp
  8000af:	e8 ec ff ff ff       	call   8000a0 <__x86.get_pc_thunk.bx>
  8000b4:	81 c3 4c 1f 00 00    	add    $0x1f4c,%ebx
	sys_env_destroy(0);
  8000ba:	6a 00                	push   $0x0
  8000bc:	e8 4d 00 00 00       	call   80010e <sys_env_destroy>
}
  8000c1:	83 c4 10             	add    $0x10,%esp
  8000c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000c7:	c9                   	leave  
  8000c8:	c3                   	ret    

008000c9 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000c9:	f3 0f 1e fb          	endbr32 
  8000cd:	55                   	push   %ebp
  8000ce:	89 e5                	mov    %esp,%ebp
  8000d0:	57                   	push   %edi
  8000d1:	56                   	push   %esi
  8000d2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8000db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000de:	89 c3                	mov    %eax,%ebx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 c6                	mov    %eax,%esi
  8000e4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5f                   	pop    %edi
  8000e9:	5d                   	pop    %ebp
  8000ea:	c3                   	ret    

008000eb <sys_cgetc>:

int
sys_cgetc(void)
{
  8000eb:	f3 0f 1e fb          	endbr32 
  8000ef:	55                   	push   %ebp
  8000f0:	89 e5                	mov    %esp,%ebp
  8000f2:	57                   	push   %edi
  8000f3:	56                   	push   %esi
  8000f4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8000fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8000ff:	89 d1                	mov    %edx,%ecx
  800101:	89 d3                	mov    %edx,%ebx
  800103:	89 d7                	mov    %edx,%edi
  800105:	89 d6                	mov    %edx,%esi
  800107:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800109:	5b                   	pop    %ebx
  80010a:	5e                   	pop    %esi
  80010b:	5f                   	pop    %edi
  80010c:	5d                   	pop    %ebp
  80010d:	c3                   	ret    

0080010e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80010e:	f3 0f 1e fb          	endbr32 
  800112:	55                   	push   %ebp
  800113:	89 e5                	mov    %esp,%ebp
  800115:	57                   	push   %edi
  800116:	56                   	push   %esi
  800117:	53                   	push   %ebx
  800118:	83 ec 1c             	sub    $0x1c,%esp
  80011b:	e8 6a 00 00 00       	call   80018a <__x86.get_pc_thunk.ax>
  800120:	05 e0 1e 00 00       	add    $0x1ee0,%eax
  800125:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("int %1\n"
  800128:	b9 00 00 00 00       	mov    $0x0,%ecx
  80012d:	8b 55 08             	mov    0x8(%ebp),%edx
  800130:	b8 03 00 00 00       	mov    $0x3,%eax
  800135:	89 cb                	mov    %ecx,%ebx
  800137:	89 cf                	mov    %ecx,%edi
  800139:	89 ce                	mov    %ecx,%esi
  80013b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80013d:	85 c0                	test   %eax,%eax
  80013f:	7f 08                	jg     800149 <sys_env_destroy+0x3b>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800141:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800144:	5b                   	pop    %ebx
  800145:	5e                   	pop    %esi
  800146:	5f                   	pop    %edi
  800147:	5d                   	pop    %ebp
  800148:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800149:	83 ec 0c             	sub    $0xc,%esp
  80014c:	50                   	push   %eax
  80014d:	6a 03                	push   $0x3
  80014f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800152:	8d 83 1a ef ff ff    	lea    -0x10e6(%ebx),%eax
  800158:	50                   	push   %eax
  800159:	6a 23                	push   $0x23
  80015b:	8d 83 37 ef ff ff    	lea    -0x10c9(%ebx),%eax
  800161:	50                   	push   %eax
  800162:	e8 27 00 00 00       	call   80018e <_panic>

00800167 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800167:	f3 0f 1e fb          	endbr32 
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	57                   	push   %edi
  80016f:	56                   	push   %esi
  800170:	53                   	push   %ebx
	asm volatile("int %1\n"
  800171:	ba 00 00 00 00       	mov    $0x0,%edx
  800176:	b8 02 00 00 00       	mov    $0x2,%eax
  80017b:	89 d1                	mov    %edx,%ecx
  80017d:	89 d3                	mov    %edx,%ebx
  80017f:	89 d7                	mov    %edx,%edi
  800181:	89 d6                	mov    %edx,%esi
  800183:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800185:	5b                   	pop    %ebx
  800186:	5e                   	pop    %esi
  800187:	5f                   	pop    %edi
  800188:	5d                   	pop    %ebp
  800189:	c3                   	ret    

0080018a <__x86.get_pc_thunk.ax>:
  80018a:	8b 04 24             	mov    (%esp),%eax
  80018d:	c3                   	ret    

0080018e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80018e:	f3 0f 1e fb          	endbr32 
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	57                   	push   %edi
  800196:	56                   	push   %esi
  800197:	53                   	push   %ebx
  800198:	83 ec 0c             	sub    $0xc,%esp
  80019b:	e8 00 ff ff ff       	call   8000a0 <__x86.get_pc_thunk.bx>
  8001a0:	81 c3 60 1e 00 00    	add    $0x1e60,%ebx
	va_list ap;

	va_start(ap, fmt);
  8001a6:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001a9:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  8001af:	8b 38                	mov    (%eax),%edi
  8001b1:	e8 b1 ff ff ff       	call   800167 <sys_getenvid>
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	ff 75 0c             	pushl  0xc(%ebp)
  8001bc:	ff 75 08             	pushl  0x8(%ebp)
  8001bf:	57                   	push   %edi
  8001c0:	50                   	push   %eax
  8001c1:	8d 83 48 ef ff ff    	lea    -0x10b8(%ebx),%eax
  8001c7:	50                   	push   %eax
  8001c8:	e8 d9 00 00 00       	call   8002a6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001cd:	83 c4 18             	add    $0x18,%esp
  8001d0:	56                   	push   %esi
  8001d1:	ff 75 10             	pushl  0x10(%ebp)
  8001d4:	e8 67 00 00 00       	call   800240 <vcprintf>
	cprintf("\n");
  8001d9:	8d 83 6b ef ff ff    	lea    -0x1095(%ebx),%eax
  8001df:	89 04 24             	mov    %eax,(%esp)
  8001e2:	e8 bf 00 00 00       	call   8002a6 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001ea:	cc                   	int3   
  8001eb:	eb fd                	jmp    8001ea <_panic+0x5c>

008001ed <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ed:	f3 0f 1e fb          	endbr32 
  8001f1:	55                   	push   %ebp
  8001f2:	89 e5                	mov    %esp,%ebp
  8001f4:	56                   	push   %esi
  8001f5:	53                   	push   %ebx
  8001f6:	e8 a5 fe ff ff       	call   8000a0 <__x86.get_pc_thunk.bx>
  8001fb:	81 c3 05 1e 00 00    	add    $0x1e05,%ebx
  800201:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  800204:	8b 16                	mov    (%esi),%edx
  800206:	8d 42 01             	lea    0x1(%edx),%eax
  800209:	89 06                	mov    %eax,(%esi)
  80020b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80020e:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  800212:	3d ff 00 00 00       	cmp    $0xff,%eax
  800217:	74 0b                	je     800224 <putch+0x37>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800219:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  80021d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800220:	5b                   	pop    %ebx
  800221:	5e                   	pop    %esi
  800222:	5d                   	pop    %ebp
  800223:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800224:	83 ec 08             	sub    $0x8,%esp
  800227:	68 ff 00 00 00       	push   $0xff
  80022c:	8d 46 08             	lea    0x8(%esi),%eax
  80022f:	50                   	push   %eax
  800230:	e8 94 fe ff ff       	call   8000c9 <sys_cputs>
		b->idx = 0;
  800235:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80023b:	83 c4 10             	add    $0x10,%esp
  80023e:	eb d9                	jmp    800219 <putch+0x2c>

00800240 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800240:	f3 0f 1e fb          	endbr32 
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	53                   	push   %ebx
  800248:	81 ec 14 01 00 00    	sub    $0x114,%esp
  80024e:	e8 4d fe ff ff       	call   8000a0 <__x86.get_pc_thunk.bx>
  800253:	81 c3 ad 1d 00 00    	add    $0x1dad,%ebx
	struct printbuf b;

	b.idx = 0;
  800259:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800260:	00 00 00 
	b.cnt = 0;
  800263:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80026a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80026d:	ff 75 0c             	pushl  0xc(%ebp)
  800270:	ff 75 08             	pushl  0x8(%ebp)
  800273:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800279:	50                   	push   %eax
  80027a:	8d 83 ed e1 ff ff    	lea    -0x1e13(%ebx),%eax
  800280:	50                   	push   %eax
  800281:	e8 38 01 00 00       	call   8003be <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800286:	83 c4 08             	add    $0x8,%esp
  800289:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80028f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800295:	50                   	push   %eax
  800296:	e8 2e fe ff ff       	call   8000c9 <sys_cputs>

	return b.cnt;
}
  80029b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002a4:	c9                   	leave  
  8002a5:	c3                   	ret    

008002a6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002a6:	f3 0f 1e fb          	endbr32 
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002b0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002b3:	50                   	push   %eax
  8002b4:	ff 75 08             	pushl  0x8(%ebp)
  8002b7:	e8 84 ff ff ff       	call   800240 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002bc:	c9                   	leave  
  8002bd:	c3                   	ret    

008002be <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002be:	55                   	push   %ebp
  8002bf:	89 e5                	mov    %esp,%ebp
  8002c1:	57                   	push   %edi
  8002c2:	56                   	push   %esi
  8002c3:	53                   	push   %ebx
  8002c4:	83 ec 2c             	sub    $0x2c,%esp
  8002c7:	e8 28 06 00 00       	call   8008f4 <__x86.get_pc_thunk.cx>
  8002cc:	81 c1 34 1d 00 00    	add    $0x1d34,%ecx
  8002d2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002d5:	89 c7                	mov    %eax,%edi
  8002d7:	89 d6                	mov    %edx,%esi
  8002d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002df:	89 d1                	mov    %edx,%ecx
  8002e1:	89 c2                	mov    %eax,%edx
  8002e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002e6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8002e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ec:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002f9:	39 c2                	cmp    %eax,%edx
  8002fb:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002fe:	72 41                	jb     800341 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	ff 75 18             	pushl  0x18(%ebp)
  800306:	83 eb 01             	sub    $0x1,%ebx
  800309:	53                   	push   %ebx
  80030a:	50                   	push   %eax
  80030b:	83 ec 08             	sub    $0x8,%esp
  80030e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800311:	ff 75 e0             	pushl  -0x20(%ebp)
  800314:	ff 75 d4             	pushl  -0x2c(%ebp)
  800317:	ff 75 d0             	pushl  -0x30(%ebp)
  80031a:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80031d:	e8 8e 09 00 00       	call   800cb0 <__udivdi3>
  800322:	83 c4 18             	add    $0x18,%esp
  800325:	52                   	push   %edx
  800326:	50                   	push   %eax
  800327:	89 f2                	mov    %esi,%edx
  800329:	89 f8                	mov    %edi,%eax
  80032b:	e8 8e ff ff ff       	call   8002be <printnum>
  800330:	83 c4 20             	add    $0x20,%esp
  800333:	eb 13                	jmp    800348 <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800335:	83 ec 08             	sub    $0x8,%esp
  800338:	56                   	push   %esi
  800339:	ff 75 18             	pushl  0x18(%ebp)
  80033c:	ff d7                	call   *%edi
  80033e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800341:	83 eb 01             	sub    $0x1,%ebx
  800344:	85 db                	test   %ebx,%ebx
  800346:	7f ed                	jg     800335 <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800348:	83 ec 08             	sub    $0x8,%esp
  80034b:	56                   	push   %esi
  80034c:	83 ec 04             	sub    $0x4,%esp
  80034f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800352:	ff 75 e0             	pushl  -0x20(%ebp)
  800355:	ff 75 d4             	pushl  -0x2c(%ebp)
  800358:	ff 75 d0             	pushl  -0x30(%ebp)
  80035b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80035e:	e8 5d 0a 00 00       	call   800dc0 <__umoddi3>
  800363:	83 c4 14             	add    $0x14,%esp
  800366:	0f be 84 03 6d ef ff 	movsbl -0x1093(%ebx,%eax,1),%eax
  80036d:	ff 
  80036e:	50                   	push   %eax
  80036f:	ff d7                	call   *%edi
}
  800371:	83 c4 10             	add    $0x10,%esp
  800374:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800377:	5b                   	pop    %ebx
  800378:	5e                   	pop    %esi
  800379:	5f                   	pop    %edi
  80037a:	5d                   	pop    %ebp
  80037b:	c3                   	ret    

0080037c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80037c:	f3 0f 1e fb          	endbr32 
  800380:	55                   	push   %ebp
  800381:	89 e5                	mov    %esp,%ebp
  800383:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800386:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80038a:	8b 10                	mov    (%eax),%edx
  80038c:	3b 50 04             	cmp    0x4(%eax),%edx
  80038f:	73 0a                	jae    80039b <sprintputch+0x1f>
		*b->buf++ = ch;
  800391:	8d 4a 01             	lea    0x1(%edx),%ecx
  800394:	89 08                	mov    %ecx,(%eax)
  800396:	8b 45 08             	mov    0x8(%ebp),%eax
  800399:	88 02                	mov    %al,(%edx)
}
  80039b:	5d                   	pop    %ebp
  80039c:	c3                   	ret    

0080039d <printfmt>:
{
  80039d:	f3 0f 1e fb          	endbr32 
  8003a1:	55                   	push   %ebp
  8003a2:	89 e5                	mov    %esp,%ebp
  8003a4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003a7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003aa:	50                   	push   %eax
  8003ab:	ff 75 10             	pushl  0x10(%ebp)
  8003ae:	ff 75 0c             	pushl  0xc(%ebp)
  8003b1:	ff 75 08             	pushl  0x8(%ebp)
  8003b4:	e8 05 00 00 00       	call   8003be <vprintfmt>
}
  8003b9:	83 c4 10             	add    $0x10,%esp
  8003bc:	c9                   	leave  
  8003bd:	c3                   	ret    

008003be <vprintfmt>:
{
  8003be:	f3 0f 1e fb          	endbr32 
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	57                   	push   %edi
  8003c6:	56                   	push   %esi
  8003c7:	53                   	push   %ebx
  8003c8:	83 ec 3c             	sub    $0x3c,%esp
  8003cb:	e8 ba fd ff ff       	call   80018a <__x86.get_pc_thunk.ax>
  8003d0:	05 30 1c 00 00       	add    $0x1c30,%eax
  8003d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8003db:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003de:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e1:	8d 80 10 00 00 00    	lea    0x10(%eax),%eax
  8003e7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8003ea:	e9 cd 03 00 00       	jmp    8007bc <.L25+0x48>
		padc = ' ';
  8003ef:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
  8003f3:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003fa:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800401:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800408:	b9 00 00 00 00       	mov    $0x0,%ecx
  80040d:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800410:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800413:	8d 43 01             	lea    0x1(%ebx),%eax
  800416:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800419:	0f b6 13             	movzbl (%ebx),%edx
  80041c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80041f:	3c 55                	cmp    $0x55,%al
  800421:	0f 87 21 04 00 00    	ja     800848 <.L20>
  800427:	0f b6 c0             	movzbl %al,%eax
  80042a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80042d:	89 ce                	mov    %ecx,%esi
  80042f:	03 b4 81 fc ef ff ff 	add    -0x1004(%ecx,%eax,4),%esi
  800436:	3e ff e6             	notrack jmp *%esi

00800439 <.L68>:
  800439:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
  80043c:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800440:	eb d1                	jmp    800413 <vprintfmt+0x55>

00800442 <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
  800442:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800445:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800449:	eb c8                	jmp    800413 <vprintfmt+0x55>

0080044b <.L31>:
  80044b:	0f b6 d2             	movzbl %dl,%edx
  80044e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
  800451:	b8 00 00 00 00       	mov    $0x0,%eax
  800456:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
  800459:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80045c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800460:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800463:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800466:	83 f9 09             	cmp    $0x9,%ecx
  800469:	77 58                	ja     8004c3 <.L36+0xf>
			for (precision = 0; ; ++fmt) {
  80046b:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  80046e:	eb e9                	jmp    800459 <.L31+0xe>

00800470 <.L34>:
			precision = va_arg(ap, int);
  800470:	8b 45 14             	mov    0x14(%ebp),%eax
  800473:	8b 00                	mov    (%eax),%eax
  800475:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800478:	8b 45 14             	mov    0x14(%ebp),%eax
  80047b:	8d 40 04             	lea    0x4(%eax),%eax
  80047e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800481:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
  800484:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800488:	79 89                	jns    800413 <vprintfmt+0x55>
				width = precision, precision = -1;
  80048a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80048d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800490:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800497:	e9 77 ff ff ff       	jmp    800413 <vprintfmt+0x55>

0080049c <.L33>:
  80049c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80049f:	85 c0                	test   %eax,%eax
  8004a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a6:	0f 49 d0             	cmovns %eax,%edx
  8004a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ac:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004af:	e9 5f ff ff ff       	jmp    800413 <vprintfmt+0x55>

008004b4 <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
  8004b4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
  8004b7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004be:	e9 50 ff ff ff       	jmp    800413 <vprintfmt+0x55>
  8004c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c6:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c9:	eb b9                	jmp    800484 <.L34+0x14>

008004cb <.L27>:
			lflag++;
  8004cb:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004cf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004d2:	e9 3c ff ff ff       	jmp    800413 <vprintfmt+0x55>

008004d7 <.L30>:
  8004d7:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(va_arg(ap, int), putdat);
  8004da:	8b 45 14             	mov    0x14(%ebp),%eax
  8004dd:	8d 58 04             	lea    0x4(%eax),%ebx
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	57                   	push   %edi
  8004e4:	ff 30                	pushl  (%eax)
  8004e6:	ff d6                	call   *%esi
			break;
  8004e8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004eb:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
  8004ee:	e9 c6 02 00 00       	jmp    8007b9 <.L25+0x45>

008004f3 <.L28>:
  8004f3:	8b 75 08             	mov    0x8(%ebp),%esi
			err = va_arg(ap, int);
  8004f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f9:	8d 58 04             	lea    0x4(%eax),%ebx
  8004fc:	8b 00                	mov    (%eax),%eax
  8004fe:	99                   	cltd   
  8004ff:	31 d0                	xor    %edx,%eax
  800501:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800503:	83 f8 06             	cmp    $0x6,%eax
  800506:	7f 27                	jg     80052f <.L28+0x3c>
  800508:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80050b:	8b 14 82             	mov    (%edx,%eax,4),%edx
  80050e:	85 d2                	test   %edx,%edx
  800510:	74 1d                	je     80052f <.L28+0x3c>
				printfmt(putch, putdat, "%s", p);
  800512:	52                   	push   %edx
  800513:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800516:	8d 80 8e ef ff ff    	lea    -0x1072(%eax),%eax
  80051c:	50                   	push   %eax
  80051d:	57                   	push   %edi
  80051e:	56                   	push   %esi
  80051f:	e8 79 fe ff ff       	call   80039d <printfmt>
  800524:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800527:	89 5d 14             	mov    %ebx,0x14(%ebp)
  80052a:	e9 8a 02 00 00       	jmp    8007b9 <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
  80052f:	50                   	push   %eax
  800530:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800533:	8d 80 85 ef ff ff    	lea    -0x107b(%eax),%eax
  800539:	50                   	push   %eax
  80053a:	57                   	push   %edi
  80053b:	56                   	push   %esi
  80053c:	e8 5c fe ff ff       	call   80039d <printfmt>
  800541:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800544:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800547:	e9 6d 02 00 00       	jmp    8007b9 <.L25+0x45>

0080054c <.L24>:
  80054c:	8b 75 08             	mov    0x8(%ebp),%esi
			if ((p = va_arg(ap, char *)) == NULL)
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	83 c0 04             	add    $0x4,%eax
  800555:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800558:	8b 45 14             	mov    0x14(%ebp),%eax
  80055b:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80055d:	85 d2                	test   %edx,%edx
  80055f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800562:	8d 80 7e ef ff ff    	lea    -0x1082(%eax),%eax
  800568:	0f 45 c2             	cmovne %edx,%eax
  80056b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80056e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800572:	7e 06                	jle    80057a <.L24+0x2e>
  800574:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800578:	75 0d                	jne    800587 <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
  80057a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80057d:	89 c3                	mov    %eax,%ebx
  80057f:	03 45 d4             	add    -0x2c(%ebp),%eax
  800582:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800585:	eb 58                	jmp    8005df <.L24+0x93>
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	ff 75 d8             	pushl  -0x28(%ebp)
  80058d:	ff 75 c8             	pushl  -0x38(%ebp)
  800590:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800593:	e8 7c 03 00 00       	call   800914 <strnlen>
  800598:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80059b:	29 c2                	sub    %eax,%edx
  80059d:	89 55 bc             	mov    %edx,-0x44(%ebp)
  8005a0:	83 c4 10             	add    $0x10,%esp
  8005a3:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
  8005a5:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ac:	85 db                	test   %ebx,%ebx
  8005ae:	7e 11                	jle    8005c1 <.L24+0x75>
					putch(padc, putdat);
  8005b0:	83 ec 08             	sub    $0x8,%esp
  8005b3:	57                   	push   %edi
  8005b4:	ff 75 d4             	pushl  -0x2c(%ebp)
  8005b7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b9:	83 eb 01             	sub    $0x1,%ebx
  8005bc:	83 c4 10             	add    $0x10,%esp
  8005bf:	eb eb                	jmp    8005ac <.L24+0x60>
  8005c1:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8005c4:	85 d2                	test   %edx,%edx
  8005c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005cb:	0f 49 c2             	cmovns %edx,%eax
  8005ce:	29 c2                	sub    %eax,%edx
  8005d0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005d3:	eb a5                	jmp    80057a <.L24+0x2e>
					putch(ch, putdat);
  8005d5:	83 ec 08             	sub    $0x8,%esp
  8005d8:	57                   	push   %edi
  8005d9:	52                   	push   %edx
  8005da:	ff d6                	call   *%esi
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005e2:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005e4:	83 c3 01             	add    $0x1,%ebx
  8005e7:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8005eb:	0f be d0             	movsbl %al,%edx
  8005ee:	85 d2                	test   %edx,%edx
  8005f0:	74 4b                	je     80063d <.L24+0xf1>
  8005f2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005f6:	78 06                	js     8005fe <.L24+0xb2>
  8005f8:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005fc:	78 1e                	js     80061c <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
  8005fe:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800602:	74 d1                	je     8005d5 <.L24+0x89>
  800604:	0f be c0             	movsbl %al,%eax
  800607:	83 e8 20             	sub    $0x20,%eax
  80060a:	83 f8 5e             	cmp    $0x5e,%eax
  80060d:	76 c6                	jbe    8005d5 <.L24+0x89>
					putch('?', putdat);
  80060f:	83 ec 08             	sub    $0x8,%esp
  800612:	57                   	push   %edi
  800613:	6a 3f                	push   $0x3f
  800615:	ff d6                	call   *%esi
  800617:	83 c4 10             	add    $0x10,%esp
  80061a:	eb c3                	jmp    8005df <.L24+0x93>
  80061c:	89 cb                	mov    %ecx,%ebx
  80061e:	eb 0e                	jmp    80062e <.L24+0xe2>
				putch(' ', putdat);
  800620:	83 ec 08             	sub    $0x8,%esp
  800623:	57                   	push   %edi
  800624:	6a 20                	push   $0x20
  800626:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800628:	83 eb 01             	sub    $0x1,%ebx
  80062b:	83 c4 10             	add    $0x10,%esp
  80062e:	85 db                	test   %ebx,%ebx
  800630:	7f ee                	jg     800620 <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
  800632:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800635:	89 45 14             	mov    %eax,0x14(%ebp)
  800638:	e9 7c 01 00 00       	jmp    8007b9 <.L25+0x45>
  80063d:	89 cb                	mov    %ecx,%ebx
  80063f:	eb ed                	jmp    80062e <.L24+0xe2>

00800641 <.L29>:
  800641:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800644:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  800647:	83 f9 01             	cmp    $0x1,%ecx
  80064a:	7f 1b                	jg     800667 <.L29+0x26>
	else if (lflag)
  80064c:	85 c9                	test   %ecx,%ecx
  80064e:	74 63                	je     8006b3 <.L29+0x72>
		return va_arg(*ap, long);
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	8b 00                	mov    (%eax),%eax
  800655:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800658:	99                   	cltd   
  800659:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8d 40 04             	lea    0x4(%eax),%eax
  800662:	89 45 14             	mov    %eax,0x14(%ebp)
  800665:	eb 17                	jmp    80067e <.L29+0x3d>
		return va_arg(*ap, long long);
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	8b 50 04             	mov    0x4(%eax),%edx
  80066d:	8b 00                	mov    (%eax),%eax
  80066f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800672:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	8d 40 08             	lea    0x8(%eax),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80067e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800681:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800684:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800689:	85 c9                	test   %ecx,%ecx
  80068b:	0f 89 0e 01 00 00    	jns    80079f <.L25+0x2b>
				putch('-', putdat);
  800691:	83 ec 08             	sub    $0x8,%esp
  800694:	57                   	push   %edi
  800695:	6a 2d                	push   $0x2d
  800697:	ff d6                	call   *%esi
				num = -(long long) num;
  800699:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80069c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80069f:	f7 da                	neg    %edx
  8006a1:	83 d1 00             	adc    $0x0,%ecx
  8006a4:	f7 d9                	neg    %ecx
  8006a6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006a9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ae:	e9 ec 00 00 00       	jmp    80079f <.L25+0x2b>
		return va_arg(*ap, int);
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bb:	99                   	cltd   
  8006bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	8d 40 04             	lea    0x4(%eax),%eax
  8006c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c8:	eb b4                	jmp    80067e <.L29+0x3d>

008006ca <.L23>:
  8006ca:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006cd:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  8006d0:	83 f9 01             	cmp    $0x1,%ecx
  8006d3:	7f 1e                	jg     8006f3 <.L23+0x29>
	else if (lflag)
  8006d5:	85 c9                	test   %ecx,%ecx
  8006d7:	74 32                	je     80070b <.L23+0x41>
		return va_arg(*ap, unsigned long);
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8b 10                	mov    (%eax),%edx
  8006de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e3:	8d 40 04             	lea    0x4(%eax),%eax
  8006e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e9:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8006ee:	e9 ac 00 00 00       	jmp    80079f <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	8b 10                	mov    (%eax),%edx
  8006f8:	8b 48 04             	mov    0x4(%eax),%ecx
  8006fb:	8d 40 08             	lea    0x8(%eax),%eax
  8006fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800701:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800706:	e9 94 00 00 00       	jmp    80079f <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8b 10                	mov    (%eax),%edx
  800710:	b9 00 00 00 00       	mov    $0x0,%ecx
  800715:	8d 40 04             	lea    0x4(%eax),%eax
  800718:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80071b:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800720:	eb 7d                	jmp    80079f <.L25+0x2b>

00800722 <.L26>:
  800722:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800725:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  800728:	83 f9 01             	cmp    $0x1,%ecx
  80072b:	7f 1b                	jg     800748 <.L26+0x26>
	else if (lflag)
  80072d:	85 c9                	test   %ecx,%ecx
  80072f:	74 2c                	je     80075d <.L26+0x3b>
		return va_arg(*ap, unsigned long);
  800731:	8b 45 14             	mov    0x14(%ebp),%eax
  800734:	8b 10                	mov    (%eax),%edx
  800736:	b9 00 00 00 00       	mov    $0x0,%ecx
  80073b:	8d 40 04             	lea    0x4(%eax),%eax
  80073e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800741:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800746:	eb 57                	jmp    80079f <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800748:	8b 45 14             	mov    0x14(%ebp),%eax
  80074b:	8b 10                	mov    (%eax),%edx
  80074d:	8b 48 04             	mov    0x4(%eax),%ecx
  800750:	8d 40 08             	lea    0x8(%eax),%eax
  800753:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800756:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80075b:	eb 42                	jmp    80079f <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80075d:	8b 45 14             	mov    0x14(%ebp),%eax
  800760:	8b 10                	mov    (%eax),%edx
  800762:	b9 00 00 00 00       	mov    $0x0,%ecx
  800767:	8d 40 04             	lea    0x4(%eax),%eax
  80076a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80076d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800772:	eb 2b                	jmp    80079f <.L25+0x2b>

00800774 <.L25>:
  800774:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('0', putdat);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	57                   	push   %edi
  80077b:	6a 30                	push   $0x30
  80077d:	ff d6                	call   *%esi
			putch('x', putdat);
  80077f:	83 c4 08             	add    $0x8,%esp
  800782:	57                   	push   %edi
  800783:	6a 78                	push   $0x78
  800785:	ff d6                	call   *%esi
			num = (unsigned long long)
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	8b 10                	mov    (%eax),%edx
  80078c:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800791:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800794:	8d 40 04             	lea    0x4(%eax),%eax
  800797:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079a:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80079f:	83 ec 0c             	sub    $0xc,%esp
  8007a2:	0f be 5d cf          	movsbl -0x31(%ebp),%ebx
  8007a6:	53                   	push   %ebx
  8007a7:	ff 75 d4             	pushl  -0x2c(%ebp)
  8007aa:	50                   	push   %eax
  8007ab:	51                   	push   %ecx
  8007ac:	52                   	push   %edx
  8007ad:	89 fa                	mov    %edi,%edx
  8007af:	89 f0                	mov    %esi,%eax
  8007b1:	e8 08 fb ff ff       	call   8002be <printnum>
			break;
  8007b6:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007b9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007bc:	83 c3 01             	add    $0x1,%ebx
  8007bf:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8007c3:	83 f8 25             	cmp    $0x25,%eax
  8007c6:	0f 84 23 fc ff ff    	je     8003ef <vprintfmt+0x31>
			if (ch == '\0')
  8007cc:	85 c0                	test   %eax,%eax
  8007ce:	0f 84 97 00 00 00    	je     80086b <.L20+0x23>
			putch(ch, putdat);
  8007d4:	83 ec 08             	sub    $0x8,%esp
  8007d7:	57                   	push   %edi
  8007d8:	50                   	push   %eax
  8007d9:	ff d6                	call   *%esi
  8007db:	83 c4 10             	add    $0x10,%esp
  8007de:	eb dc                	jmp    8007bc <.L25+0x48>

008007e0 <.L21>:
  8007e0:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8007e3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  8007e6:	83 f9 01             	cmp    $0x1,%ecx
  8007e9:	7f 1b                	jg     800806 <.L21+0x26>
	else if (lflag)
  8007eb:	85 c9                	test   %ecx,%ecx
  8007ed:	74 2c                	je     80081b <.L21+0x3b>
		return va_arg(*ap, unsigned long);
  8007ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f2:	8b 10                	mov    (%eax),%edx
  8007f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007f9:	8d 40 04             	lea    0x4(%eax),%eax
  8007fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ff:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800804:	eb 99                	jmp    80079f <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	8b 10                	mov    (%eax),%edx
  80080b:	8b 48 04             	mov    0x4(%eax),%ecx
  80080e:	8d 40 08             	lea    0x8(%eax),%eax
  800811:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800814:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800819:	eb 84                	jmp    80079f <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	8b 10                	mov    (%eax),%edx
  800820:	b9 00 00 00 00       	mov    $0x0,%ecx
  800825:	8d 40 04             	lea    0x4(%eax),%eax
  800828:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800830:	e9 6a ff ff ff       	jmp    80079f <.L25+0x2b>

00800835 <.L35>:
  800835:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(ch, putdat);
  800838:	83 ec 08             	sub    $0x8,%esp
  80083b:	57                   	push   %edi
  80083c:	6a 25                	push   $0x25
  80083e:	ff d6                	call   *%esi
			break;
  800840:	83 c4 10             	add    $0x10,%esp
  800843:	e9 71 ff ff ff       	jmp    8007b9 <.L25+0x45>

00800848 <.L20>:
  800848:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('%', putdat);
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	57                   	push   %edi
  80084f:	6a 25                	push   $0x25
  800851:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800853:	83 c4 10             	add    $0x10,%esp
  800856:	89 d8                	mov    %ebx,%eax
  800858:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80085c:	74 05                	je     800863 <.L20+0x1b>
  80085e:	83 e8 01             	sub    $0x1,%eax
  800861:	eb f5                	jmp    800858 <.L20+0x10>
  800863:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800866:	e9 4e ff ff ff       	jmp    8007b9 <.L25+0x45>
}
  80086b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80086e:	5b                   	pop    %ebx
  80086f:	5e                   	pop    %esi
  800870:	5f                   	pop    %edi
  800871:	5d                   	pop    %ebp
  800872:	c3                   	ret    

00800873 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800873:	f3 0f 1e fb          	endbr32 
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	53                   	push   %ebx
  80087b:	83 ec 14             	sub    $0x14,%esp
  80087e:	e8 1d f8 ff ff       	call   8000a0 <__x86.get_pc_thunk.bx>
  800883:	81 c3 7d 17 00 00    	add    $0x177d,%ebx
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80088f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800892:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800896:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800899:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008a0:	85 c0                	test   %eax,%eax
  8008a2:	74 2b                	je     8008cf <vsnprintf+0x5c>
  8008a4:	85 d2                	test   %edx,%edx
  8008a6:	7e 27                	jle    8008cf <vsnprintf+0x5c>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008a8:	ff 75 14             	pushl  0x14(%ebp)
  8008ab:	ff 75 10             	pushl  0x10(%ebp)
  8008ae:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b1:	50                   	push   %eax
  8008b2:	8d 83 7c e3 ff ff    	lea    -0x1c84(%ebx),%eax
  8008b8:	50                   	push   %eax
  8008b9:	e8 00 fb ff ff       	call   8003be <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c7:	83 c4 10             	add    $0x10,%esp
}
  8008ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008cd:	c9                   	leave  
  8008ce:	c3                   	ret    
		return -E_INVAL;
  8008cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d4:	eb f4                	jmp    8008ca <vsnprintf+0x57>

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
  8008ed:	e8 81 ff ff ff       	call   800873 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008f2:	c9                   	leave  
  8008f3:	c3                   	ret    

008008f4 <__x86.get_pc_thunk.cx>:
  8008f4:	8b 0c 24             	mov    (%esp),%ecx
  8008f7:	c3                   	ret    

008008f8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008f8:	f3 0f 1e fb          	endbr32 
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800902:	b8 00 00 00 00       	mov    $0x0,%eax
  800907:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80090b:	74 05                	je     800912 <strlen+0x1a>
		n++;
  80090d:	83 c0 01             	add    $0x1,%eax
  800910:	eb f5                	jmp    800907 <strlen+0xf>
	return n;
}
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    

00800914 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800914:	f3 0f 1e fb          	endbr32 
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800921:	b8 00 00 00 00       	mov    $0x0,%eax
  800926:	39 d0                	cmp    %edx,%eax
  800928:	74 0d                	je     800937 <strnlen+0x23>
  80092a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80092e:	74 05                	je     800935 <strnlen+0x21>
		n++;
  800930:	83 c0 01             	add    $0x1,%eax
  800933:	eb f1                	jmp    800926 <strnlen+0x12>
  800935:	89 c2                	mov    %eax,%edx
	return n;
}
  800937:	89 d0                	mov    %edx,%eax
  800939:	5d                   	pop    %ebp
  80093a:	c3                   	ret    

0080093b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80093b:	f3 0f 1e fb          	endbr32 
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	53                   	push   %ebx
  800943:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800946:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800949:	b8 00 00 00 00       	mov    $0x0,%eax
  80094e:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800952:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800955:	83 c0 01             	add    $0x1,%eax
  800958:	84 d2                	test   %dl,%dl
  80095a:	75 f2                	jne    80094e <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80095c:	89 c8                	mov    %ecx,%eax
  80095e:	5b                   	pop    %ebx
  80095f:	5d                   	pop    %ebp
  800960:	c3                   	ret    

00800961 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800961:	f3 0f 1e fb          	endbr32 
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	53                   	push   %ebx
  800969:	83 ec 10             	sub    $0x10,%esp
  80096c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80096f:	53                   	push   %ebx
  800970:	e8 83 ff ff ff       	call   8008f8 <strlen>
  800975:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800978:	ff 75 0c             	pushl  0xc(%ebp)
  80097b:	01 d8                	add    %ebx,%eax
  80097d:	50                   	push   %eax
  80097e:	e8 b8 ff ff ff       	call   80093b <strcpy>
	return dst;
}
  800983:	89 d8                	mov    %ebx,%eax
  800985:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800988:	c9                   	leave  
  800989:	c3                   	ret    

0080098a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80098a:	f3 0f 1e fb          	endbr32 
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	56                   	push   %esi
  800992:	53                   	push   %ebx
  800993:	8b 75 08             	mov    0x8(%ebp),%esi
  800996:	8b 55 0c             	mov    0xc(%ebp),%edx
  800999:	89 f3                	mov    %esi,%ebx
  80099b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80099e:	89 f0                	mov    %esi,%eax
  8009a0:	39 d8                	cmp    %ebx,%eax
  8009a2:	74 11                	je     8009b5 <strncpy+0x2b>
		*dst++ = *src;
  8009a4:	83 c0 01             	add    $0x1,%eax
  8009a7:	0f b6 0a             	movzbl (%edx),%ecx
  8009aa:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009ad:	80 f9 01             	cmp    $0x1,%cl
  8009b0:	83 da ff             	sbb    $0xffffffff,%edx
  8009b3:	eb eb                	jmp    8009a0 <strncpy+0x16>
	}
	return ret;
}
  8009b5:	89 f0                	mov    %esi,%eax
  8009b7:	5b                   	pop    %ebx
  8009b8:	5e                   	pop    %esi
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    

008009bb <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009bb:	f3 0f 1e fb          	endbr32 
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
  8009c2:	56                   	push   %esi
  8009c3:	53                   	push   %ebx
  8009c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ca:	8b 55 10             	mov    0x10(%ebp),%edx
  8009cd:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009cf:	85 d2                	test   %edx,%edx
  8009d1:	74 21                	je     8009f4 <strlcpy+0x39>
  8009d3:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009d7:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009d9:	39 c2                	cmp    %eax,%edx
  8009db:	74 14                	je     8009f1 <strlcpy+0x36>
  8009dd:	0f b6 19             	movzbl (%ecx),%ebx
  8009e0:	84 db                	test   %bl,%bl
  8009e2:	74 0b                	je     8009ef <strlcpy+0x34>
			*dst++ = *src++;
  8009e4:	83 c1 01             	add    $0x1,%ecx
  8009e7:	83 c2 01             	add    $0x1,%edx
  8009ea:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009ed:	eb ea                	jmp    8009d9 <strlcpy+0x1e>
  8009ef:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009f1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f4:	29 f0                	sub    %esi,%eax
}
  8009f6:	5b                   	pop    %ebx
  8009f7:	5e                   	pop    %esi
  8009f8:	5d                   	pop    %ebp
  8009f9:	c3                   	ret    

008009fa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009fa:	f3 0f 1e fb          	endbr32 
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
  800a01:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a04:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a07:	0f b6 01             	movzbl (%ecx),%eax
  800a0a:	84 c0                	test   %al,%al
  800a0c:	74 0c                	je     800a1a <strcmp+0x20>
  800a0e:	3a 02                	cmp    (%edx),%al
  800a10:	75 08                	jne    800a1a <strcmp+0x20>
		p++, q++;
  800a12:	83 c1 01             	add    $0x1,%ecx
  800a15:	83 c2 01             	add    $0x1,%edx
  800a18:	eb ed                	jmp    800a07 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a1a:	0f b6 c0             	movzbl %al,%eax
  800a1d:	0f b6 12             	movzbl (%edx),%edx
  800a20:	29 d0                	sub    %edx,%eax
}
  800a22:	5d                   	pop    %ebp
  800a23:	c3                   	ret    

00800a24 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a24:	f3 0f 1e fb          	endbr32 
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	53                   	push   %ebx
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a32:	89 c3                	mov    %eax,%ebx
  800a34:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a37:	eb 06                	jmp    800a3f <strncmp+0x1b>
		n--, p++, q++;
  800a39:	83 c0 01             	add    $0x1,%eax
  800a3c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a3f:	39 d8                	cmp    %ebx,%eax
  800a41:	74 16                	je     800a59 <strncmp+0x35>
  800a43:	0f b6 08             	movzbl (%eax),%ecx
  800a46:	84 c9                	test   %cl,%cl
  800a48:	74 04                	je     800a4e <strncmp+0x2a>
  800a4a:	3a 0a                	cmp    (%edx),%cl
  800a4c:	74 eb                	je     800a39 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a4e:	0f b6 00             	movzbl (%eax),%eax
  800a51:	0f b6 12             	movzbl (%edx),%edx
  800a54:	29 d0                	sub    %edx,%eax
}
  800a56:	5b                   	pop    %ebx
  800a57:	5d                   	pop    %ebp
  800a58:	c3                   	ret    
		return 0;
  800a59:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5e:	eb f6                	jmp    800a56 <strncmp+0x32>

00800a60 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a60:	f3 0f 1e fb          	endbr32 
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a6e:	0f b6 10             	movzbl (%eax),%edx
  800a71:	84 d2                	test   %dl,%dl
  800a73:	74 09                	je     800a7e <strchr+0x1e>
		if (*s == c)
  800a75:	38 ca                	cmp    %cl,%dl
  800a77:	74 0a                	je     800a83 <strchr+0x23>
	for (; *s; s++)
  800a79:	83 c0 01             	add    $0x1,%eax
  800a7c:	eb f0                	jmp    800a6e <strchr+0xe>
			return (char *) s;
	return 0;
  800a7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    

00800a85 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a85:	f3 0f 1e fb          	endbr32 
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a93:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a96:	38 ca                	cmp    %cl,%dl
  800a98:	74 09                	je     800aa3 <strfind+0x1e>
  800a9a:	84 d2                	test   %dl,%dl
  800a9c:	74 05                	je     800aa3 <strfind+0x1e>
	for (; *s; s++)
  800a9e:	83 c0 01             	add    $0x1,%eax
  800aa1:	eb f0                	jmp    800a93 <strfind+0xe>
			break;
	return (char *) s;
}
  800aa3:	5d                   	pop    %ebp
  800aa4:	c3                   	ret    

00800aa5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aa5:	f3 0f 1e fb          	endbr32 
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	57                   	push   %edi
  800aad:	56                   	push   %esi
  800aae:	53                   	push   %ebx
  800aaf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ab2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ab5:	85 c9                	test   %ecx,%ecx
  800ab7:	74 31                	je     800aea <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ab9:	89 f8                	mov    %edi,%eax
  800abb:	09 c8                	or     %ecx,%eax
  800abd:	a8 03                	test   $0x3,%al
  800abf:	75 23                	jne    800ae4 <memset+0x3f>
		c &= 0xFF;
  800ac1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ac5:	89 d3                	mov    %edx,%ebx
  800ac7:	c1 e3 08             	shl    $0x8,%ebx
  800aca:	89 d0                	mov    %edx,%eax
  800acc:	c1 e0 18             	shl    $0x18,%eax
  800acf:	89 d6                	mov    %edx,%esi
  800ad1:	c1 e6 10             	shl    $0x10,%esi
  800ad4:	09 f0                	or     %esi,%eax
  800ad6:	09 c2                	or     %eax,%edx
  800ad8:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ada:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800add:	89 d0                	mov    %edx,%eax
  800adf:	fc                   	cld    
  800ae0:	f3 ab                	rep stos %eax,%es:(%edi)
  800ae2:	eb 06                	jmp    800aea <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ae4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae7:	fc                   	cld    
  800ae8:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aea:	89 f8                	mov    %edi,%eax
  800aec:	5b                   	pop    %ebx
  800aed:	5e                   	pop    %esi
  800aee:	5f                   	pop    %edi
  800aef:	5d                   	pop    %ebp
  800af0:	c3                   	ret    

00800af1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800af1:	f3 0f 1e fb          	endbr32 
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	57                   	push   %edi
  800af9:	56                   	push   %esi
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b00:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b03:	39 c6                	cmp    %eax,%esi
  800b05:	73 32                	jae    800b39 <memmove+0x48>
  800b07:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b0a:	39 c2                	cmp    %eax,%edx
  800b0c:	76 2b                	jbe    800b39 <memmove+0x48>
		s += n;
		d += n;
  800b0e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b11:	89 fe                	mov    %edi,%esi
  800b13:	09 ce                	or     %ecx,%esi
  800b15:	09 d6                	or     %edx,%esi
  800b17:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b1d:	75 0e                	jne    800b2d <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b1f:	83 ef 04             	sub    $0x4,%edi
  800b22:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b25:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b28:	fd                   	std    
  800b29:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b2b:	eb 09                	jmp    800b36 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b2d:	83 ef 01             	sub    $0x1,%edi
  800b30:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b33:	fd                   	std    
  800b34:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b36:	fc                   	cld    
  800b37:	eb 1a                	jmp    800b53 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b39:	89 c2                	mov    %eax,%edx
  800b3b:	09 ca                	or     %ecx,%edx
  800b3d:	09 f2                	or     %esi,%edx
  800b3f:	f6 c2 03             	test   $0x3,%dl
  800b42:	75 0a                	jne    800b4e <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b44:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b47:	89 c7                	mov    %eax,%edi
  800b49:	fc                   	cld    
  800b4a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b4c:	eb 05                	jmp    800b53 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b4e:	89 c7                	mov    %eax,%edi
  800b50:	fc                   	cld    
  800b51:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b53:	5e                   	pop    %esi
  800b54:	5f                   	pop    %edi
  800b55:	5d                   	pop    %ebp
  800b56:	c3                   	ret    

00800b57 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b57:	f3 0f 1e fb          	endbr32 
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b61:	ff 75 10             	pushl  0x10(%ebp)
  800b64:	ff 75 0c             	pushl  0xc(%ebp)
  800b67:	ff 75 08             	pushl  0x8(%ebp)
  800b6a:	e8 82 ff ff ff       	call   800af1 <memmove>
}
  800b6f:	c9                   	leave  
  800b70:	c3                   	ret    

00800b71 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b71:	f3 0f 1e fb          	endbr32 
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	56                   	push   %esi
  800b79:	53                   	push   %ebx
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b80:	89 c6                	mov    %eax,%esi
  800b82:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b85:	39 f0                	cmp    %esi,%eax
  800b87:	74 1c                	je     800ba5 <memcmp+0x34>
		if (*s1 != *s2)
  800b89:	0f b6 08             	movzbl (%eax),%ecx
  800b8c:	0f b6 1a             	movzbl (%edx),%ebx
  800b8f:	38 d9                	cmp    %bl,%cl
  800b91:	75 08                	jne    800b9b <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b93:	83 c0 01             	add    $0x1,%eax
  800b96:	83 c2 01             	add    $0x1,%edx
  800b99:	eb ea                	jmp    800b85 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b9b:	0f b6 c1             	movzbl %cl,%eax
  800b9e:	0f b6 db             	movzbl %bl,%ebx
  800ba1:	29 d8                	sub    %ebx,%eax
  800ba3:	eb 05                	jmp    800baa <memcmp+0x39>
	}

	return 0;
  800ba5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800baa:	5b                   	pop    %ebx
  800bab:	5e                   	pop    %esi
  800bac:	5d                   	pop    %ebp
  800bad:	c3                   	ret    

00800bae <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bae:	f3 0f 1e fb          	endbr32 
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bbb:	89 c2                	mov    %eax,%edx
  800bbd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bc0:	39 d0                	cmp    %edx,%eax
  800bc2:	73 09                	jae    800bcd <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bc4:	38 08                	cmp    %cl,(%eax)
  800bc6:	74 05                	je     800bcd <memfind+0x1f>
	for (; s < ends; s++)
  800bc8:	83 c0 01             	add    $0x1,%eax
  800bcb:	eb f3                	jmp    800bc0 <memfind+0x12>
			break;
	return (void *) s;
}
  800bcd:	5d                   	pop    %ebp
  800bce:	c3                   	ret    

00800bcf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bcf:	f3 0f 1e fb          	endbr32 
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	57                   	push   %edi
  800bd7:	56                   	push   %esi
  800bd8:	53                   	push   %ebx
  800bd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bdc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bdf:	eb 03                	jmp    800be4 <strtol+0x15>
		s++;
  800be1:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800be4:	0f b6 01             	movzbl (%ecx),%eax
  800be7:	3c 20                	cmp    $0x20,%al
  800be9:	74 f6                	je     800be1 <strtol+0x12>
  800beb:	3c 09                	cmp    $0x9,%al
  800bed:	74 f2                	je     800be1 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800bef:	3c 2b                	cmp    $0x2b,%al
  800bf1:	74 2a                	je     800c1d <strtol+0x4e>
	int neg = 0;
  800bf3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bf8:	3c 2d                	cmp    $0x2d,%al
  800bfa:	74 2b                	je     800c27 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bfc:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c02:	75 0f                	jne    800c13 <strtol+0x44>
  800c04:	80 39 30             	cmpb   $0x30,(%ecx)
  800c07:	74 28                	je     800c31 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c09:	85 db                	test   %ebx,%ebx
  800c0b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c10:	0f 44 d8             	cmove  %eax,%ebx
  800c13:	b8 00 00 00 00       	mov    $0x0,%eax
  800c18:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c1b:	eb 46                	jmp    800c63 <strtol+0x94>
		s++;
  800c1d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c20:	bf 00 00 00 00       	mov    $0x0,%edi
  800c25:	eb d5                	jmp    800bfc <strtol+0x2d>
		s++, neg = 1;
  800c27:	83 c1 01             	add    $0x1,%ecx
  800c2a:	bf 01 00 00 00       	mov    $0x1,%edi
  800c2f:	eb cb                	jmp    800bfc <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c31:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c35:	74 0e                	je     800c45 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c37:	85 db                	test   %ebx,%ebx
  800c39:	75 d8                	jne    800c13 <strtol+0x44>
		s++, base = 8;
  800c3b:	83 c1 01             	add    $0x1,%ecx
  800c3e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c43:	eb ce                	jmp    800c13 <strtol+0x44>
		s += 2, base = 16;
  800c45:	83 c1 02             	add    $0x2,%ecx
  800c48:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c4d:	eb c4                	jmp    800c13 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c4f:	0f be d2             	movsbl %dl,%edx
  800c52:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c55:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c58:	7d 3a                	jge    800c94 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c5a:	83 c1 01             	add    $0x1,%ecx
  800c5d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c61:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c63:	0f b6 11             	movzbl (%ecx),%edx
  800c66:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c69:	89 f3                	mov    %esi,%ebx
  800c6b:	80 fb 09             	cmp    $0x9,%bl
  800c6e:	76 df                	jbe    800c4f <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c70:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c73:	89 f3                	mov    %esi,%ebx
  800c75:	80 fb 19             	cmp    $0x19,%bl
  800c78:	77 08                	ja     800c82 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c7a:	0f be d2             	movsbl %dl,%edx
  800c7d:	83 ea 57             	sub    $0x57,%edx
  800c80:	eb d3                	jmp    800c55 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c82:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c85:	89 f3                	mov    %esi,%ebx
  800c87:	80 fb 19             	cmp    $0x19,%bl
  800c8a:	77 08                	ja     800c94 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c8c:	0f be d2             	movsbl %dl,%edx
  800c8f:	83 ea 37             	sub    $0x37,%edx
  800c92:	eb c1                	jmp    800c55 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c94:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c98:	74 05                	je     800c9f <strtol+0xd0>
		*endptr = (char *) s;
  800c9a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c9d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c9f:	89 c2                	mov    %eax,%edx
  800ca1:	f7 da                	neg    %edx
  800ca3:	85 ff                	test   %edi,%edi
  800ca5:	0f 45 c2             	cmovne %edx,%eax
}
  800ca8:	5b                   	pop    %ebx
  800ca9:	5e                   	pop    %esi
  800caa:	5f                   	pop    %edi
  800cab:	5d                   	pop    %ebp
  800cac:	c3                   	ret    
  800cad:	66 90                	xchg   %ax,%ax
  800caf:	90                   	nop

00800cb0 <__udivdi3>:
  800cb0:	f3 0f 1e fb          	endbr32 
  800cb4:	55                   	push   %ebp
  800cb5:	57                   	push   %edi
  800cb6:	56                   	push   %esi
  800cb7:	53                   	push   %ebx
  800cb8:	83 ec 1c             	sub    $0x1c,%esp
  800cbb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800cbf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800cc3:	8b 74 24 34          	mov    0x34(%esp),%esi
  800cc7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800ccb:	85 d2                	test   %edx,%edx
  800ccd:	75 19                	jne    800ce8 <__udivdi3+0x38>
  800ccf:	39 f3                	cmp    %esi,%ebx
  800cd1:	76 4d                	jbe    800d20 <__udivdi3+0x70>
  800cd3:	31 ff                	xor    %edi,%edi
  800cd5:	89 e8                	mov    %ebp,%eax
  800cd7:	89 f2                	mov    %esi,%edx
  800cd9:	f7 f3                	div    %ebx
  800cdb:	89 fa                	mov    %edi,%edx
  800cdd:	83 c4 1c             	add    $0x1c,%esp
  800ce0:	5b                   	pop    %ebx
  800ce1:	5e                   	pop    %esi
  800ce2:	5f                   	pop    %edi
  800ce3:	5d                   	pop    %ebp
  800ce4:	c3                   	ret    
  800ce5:	8d 76 00             	lea    0x0(%esi),%esi
  800ce8:	39 f2                	cmp    %esi,%edx
  800cea:	76 14                	jbe    800d00 <__udivdi3+0x50>
  800cec:	31 ff                	xor    %edi,%edi
  800cee:	31 c0                	xor    %eax,%eax
  800cf0:	89 fa                	mov    %edi,%edx
  800cf2:	83 c4 1c             	add    $0x1c,%esp
  800cf5:	5b                   	pop    %ebx
  800cf6:	5e                   	pop    %esi
  800cf7:	5f                   	pop    %edi
  800cf8:	5d                   	pop    %ebp
  800cf9:	c3                   	ret    
  800cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800d00:	0f bd fa             	bsr    %edx,%edi
  800d03:	83 f7 1f             	xor    $0x1f,%edi
  800d06:	75 48                	jne    800d50 <__udivdi3+0xa0>
  800d08:	39 f2                	cmp    %esi,%edx
  800d0a:	72 06                	jb     800d12 <__udivdi3+0x62>
  800d0c:	31 c0                	xor    %eax,%eax
  800d0e:	39 eb                	cmp    %ebp,%ebx
  800d10:	77 de                	ja     800cf0 <__udivdi3+0x40>
  800d12:	b8 01 00 00 00       	mov    $0x1,%eax
  800d17:	eb d7                	jmp    800cf0 <__udivdi3+0x40>
  800d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d20:	89 d9                	mov    %ebx,%ecx
  800d22:	85 db                	test   %ebx,%ebx
  800d24:	75 0b                	jne    800d31 <__udivdi3+0x81>
  800d26:	b8 01 00 00 00       	mov    $0x1,%eax
  800d2b:	31 d2                	xor    %edx,%edx
  800d2d:	f7 f3                	div    %ebx
  800d2f:	89 c1                	mov    %eax,%ecx
  800d31:	31 d2                	xor    %edx,%edx
  800d33:	89 f0                	mov    %esi,%eax
  800d35:	f7 f1                	div    %ecx
  800d37:	89 c6                	mov    %eax,%esi
  800d39:	89 e8                	mov    %ebp,%eax
  800d3b:	89 f7                	mov    %esi,%edi
  800d3d:	f7 f1                	div    %ecx
  800d3f:	89 fa                	mov    %edi,%edx
  800d41:	83 c4 1c             	add    $0x1c,%esp
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    
  800d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d50:	89 f9                	mov    %edi,%ecx
  800d52:	b8 20 00 00 00       	mov    $0x20,%eax
  800d57:	29 f8                	sub    %edi,%eax
  800d59:	d3 e2                	shl    %cl,%edx
  800d5b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800d5f:	89 c1                	mov    %eax,%ecx
  800d61:	89 da                	mov    %ebx,%edx
  800d63:	d3 ea                	shr    %cl,%edx
  800d65:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800d69:	09 d1                	or     %edx,%ecx
  800d6b:	89 f2                	mov    %esi,%edx
  800d6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800d71:	89 f9                	mov    %edi,%ecx
  800d73:	d3 e3                	shl    %cl,%ebx
  800d75:	89 c1                	mov    %eax,%ecx
  800d77:	d3 ea                	shr    %cl,%edx
  800d79:	89 f9                	mov    %edi,%ecx
  800d7b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800d7f:	89 eb                	mov    %ebp,%ebx
  800d81:	d3 e6                	shl    %cl,%esi
  800d83:	89 c1                	mov    %eax,%ecx
  800d85:	d3 eb                	shr    %cl,%ebx
  800d87:	09 de                	or     %ebx,%esi
  800d89:	89 f0                	mov    %esi,%eax
  800d8b:	f7 74 24 08          	divl   0x8(%esp)
  800d8f:	89 d6                	mov    %edx,%esi
  800d91:	89 c3                	mov    %eax,%ebx
  800d93:	f7 64 24 0c          	mull   0xc(%esp)
  800d97:	39 d6                	cmp    %edx,%esi
  800d99:	72 15                	jb     800db0 <__udivdi3+0x100>
  800d9b:	89 f9                	mov    %edi,%ecx
  800d9d:	d3 e5                	shl    %cl,%ebp
  800d9f:	39 c5                	cmp    %eax,%ebp
  800da1:	73 04                	jae    800da7 <__udivdi3+0xf7>
  800da3:	39 d6                	cmp    %edx,%esi
  800da5:	74 09                	je     800db0 <__udivdi3+0x100>
  800da7:	89 d8                	mov    %ebx,%eax
  800da9:	31 ff                	xor    %edi,%edi
  800dab:	e9 40 ff ff ff       	jmp    800cf0 <__udivdi3+0x40>
  800db0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800db3:	31 ff                	xor    %edi,%edi
  800db5:	e9 36 ff ff ff       	jmp    800cf0 <__udivdi3+0x40>
  800dba:	66 90                	xchg   %ax,%ax
  800dbc:	66 90                	xchg   %ax,%ax
  800dbe:	66 90                	xchg   %ax,%ax

00800dc0 <__umoddi3>:
  800dc0:	f3 0f 1e fb          	endbr32 
  800dc4:	55                   	push   %ebp
  800dc5:	57                   	push   %edi
  800dc6:	56                   	push   %esi
  800dc7:	53                   	push   %ebx
  800dc8:	83 ec 1c             	sub    $0x1c,%esp
  800dcb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800dcf:	8b 74 24 30          	mov    0x30(%esp),%esi
  800dd3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800dd7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800ddb:	85 c0                	test   %eax,%eax
  800ddd:	75 19                	jne    800df8 <__umoddi3+0x38>
  800ddf:	39 df                	cmp    %ebx,%edi
  800de1:	76 5d                	jbe    800e40 <__umoddi3+0x80>
  800de3:	89 f0                	mov    %esi,%eax
  800de5:	89 da                	mov    %ebx,%edx
  800de7:	f7 f7                	div    %edi
  800de9:	89 d0                	mov    %edx,%eax
  800deb:	31 d2                	xor    %edx,%edx
  800ded:	83 c4 1c             	add    $0x1c,%esp
  800df0:	5b                   	pop    %ebx
  800df1:	5e                   	pop    %esi
  800df2:	5f                   	pop    %edi
  800df3:	5d                   	pop    %ebp
  800df4:	c3                   	ret    
  800df5:	8d 76 00             	lea    0x0(%esi),%esi
  800df8:	89 f2                	mov    %esi,%edx
  800dfa:	39 d8                	cmp    %ebx,%eax
  800dfc:	76 12                	jbe    800e10 <__umoddi3+0x50>
  800dfe:	89 f0                	mov    %esi,%eax
  800e00:	89 da                	mov    %ebx,%edx
  800e02:	83 c4 1c             	add    $0x1c,%esp
  800e05:	5b                   	pop    %ebx
  800e06:	5e                   	pop    %esi
  800e07:	5f                   	pop    %edi
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    
  800e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e10:	0f bd e8             	bsr    %eax,%ebp
  800e13:	83 f5 1f             	xor    $0x1f,%ebp
  800e16:	75 50                	jne    800e68 <__umoddi3+0xa8>
  800e18:	39 d8                	cmp    %ebx,%eax
  800e1a:	0f 82 e0 00 00 00    	jb     800f00 <__umoddi3+0x140>
  800e20:	89 d9                	mov    %ebx,%ecx
  800e22:	39 f7                	cmp    %esi,%edi
  800e24:	0f 86 d6 00 00 00    	jbe    800f00 <__umoddi3+0x140>
  800e2a:	89 d0                	mov    %edx,%eax
  800e2c:	89 ca                	mov    %ecx,%edx
  800e2e:	83 c4 1c             	add    $0x1c,%esp
  800e31:	5b                   	pop    %ebx
  800e32:	5e                   	pop    %esi
  800e33:	5f                   	pop    %edi
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    
  800e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e3d:	8d 76 00             	lea    0x0(%esi),%esi
  800e40:	89 fd                	mov    %edi,%ebp
  800e42:	85 ff                	test   %edi,%edi
  800e44:	75 0b                	jne    800e51 <__umoddi3+0x91>
  800e46:	b8 01 00 00 00       	mov    $0x1,%eax
  800e4b:	31 d2                	xor    %edx,%edx
  800e4d:	f7 f7                	div    %edi
  800e4f:	89 c5                	mov    %eax,%ebp
  800e51:	89 d8                	mov    %ebx,%eax
  800e53:	31 d2                	xor    %edx,%edx
  800e55:	f7 f5                	div    %ebp
  800e57:	89 f0                	mov    %esi,%eax
  800e59:	f7 f5                	div    %ebp
  800e5b:	89 d0                	mov    %edx,%eax
  800e5d:	31 d2                	xor    %edx,%edx
  800e5f:	eb 8c                	jmp    800ded <__umoddi3+0x2d>
  800e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e68:	89 e9                	mov    %ebp,%ecx
  800e6a:	ba 20 00 00 00       	mov    $0x20,%edx
  800e6f:	29 ea                	sub    %ebp,%edx
  800e71:	d3 e0                	shl    %cl,%eax
  800e73:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e77:	89 d1                	mov    %edx,%ecx
  800e79:	89 f8                	mov    %edi,%eax
  800e7b:	d3 e8                	shr    %cl,%eax
  800e7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e81:	89 54 24 04          	mov    %edx,0x4(%esp)
  800e85:	8b 54 24 04          	mov    0x4(%esp),%edx
  800e89:	09 c1                	or     %eax,%ecx
  800e8b:	89 d8                	mov    %ebx,%eax
  800e8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e91:	89 e9                	mov    %ebp,%ecx
  800e93:	d3 e7                	shl    %cl,%edi
  800e95:	89 d1                	mov    %edx,%ecx
  800e97:	d3 e8                	shr    %cl,%eax
  800e99:	89 e9                	mov    %ebp,%ecx
  800e9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800e9f:	d3 e3                	shl    %cl,%ebx
  800ea1:	89 c7                	mov    %eax,%edi
  800ea3:	89 d1                	mov    %edx,%ecx
  800ea5:	89 f0                	mov    %esi,%eax
  800ea7:	d3 e8                	shr    %cl,%eax
  800ea9:	89 e9                	mov    %ebp,%ecx
  800eab:	89 fa                	mov    %edi,%edx
  800ead:	d3 e6                	shl    %cl,%esi
  800eaf:	09 d8                	or     %ebx,%eax
  800eb1:	f7 74 24 08          	divl   0x8(%esp)
  800eb5:	89 d1                	mov    %edx,%ecx
  800eb7:	89 f3                	mov    %esi,%ebx
  800eb9:	f7 64 24 0c          	mull   0xc(%esp)
  800ebd:	89 c6                	mov    %eax,%esi
  800ebf:	89 d7                	mov    %edx,%edi
  800ec1:	39 d1                	cmp    %edx,%ecx
  800ec3:	72 06                	jb     800ecb <__umoddi3+0x10b>
  800ec5:	75 10                	jne    800ed7 <__umoddi3+0x117>
  800ec7:	39 c3                	cmp    %eax,%ebx
  800ec9:	73 0c                	jae    800ed7 <__umoddi3+0x117>
  800ecb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  800ecf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  800ed3:	89 d7                	mov    %edx,%edi
  800ed5:	89 c6                	mov    %eax,%esi
  800ed7:	89 ca                	mov    %ecx,%edx
  800ed9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800ede:	29 f3                	sub    %esi,%ebx
  800ee0:	19 fa                	sbb    %edi,%edx
  800ee2:	89 d0                	mov    %edx,%eax
  800ee4:	d3 e0                	shl    %cl,%eax
  800ee6:	89 e9                	mov    %ebp,%ecx
  800ee8:	d3 eb                	shr    %cl,%ebx
  800eea:	d3 ea                	shr    %cl,%edx
  800eec:	09 d8                	or     %ebx,%eax
  800eee:	83 c4 1c             	add    $0x1c,%esp
  800ef1:	5b                   	pop    %ebx
  800ef2:	5e                   	pop    %esi
  800ef3:	5f                   	pop    %edi
  800ef4:	5d                   	pop    %ebp
  800ef5:	c3                   	ret    
  800ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800efd:	8d 76 00             	lea    0x0(%esi),%esi
  800f00:	29 fe                	sub    %edi,%esi
  800f02:	19 c3                	sbb    %eax,%ebx
  800f04:	89 f2                	mov    %esi,%edx
  800f06:	89 d9                	mov    %ebx,%ecx
  800f08:	e9 1d ff ff ff       	jmp    800e2a <__umoddi3+0x6a>
