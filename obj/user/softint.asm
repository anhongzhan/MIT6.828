
obj/user/softint:     file format elf32-i386


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
  80002c:	e8 09 00 00 00       	call   80003a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
	asm volatile("int $14");	// page fault
  800037:	cd 0e                	int    $0xe
}
  800039:	c3                   	ret    

0080003a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003a:	f3 0f 1e fb          	endbr32 
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	57                   	push   %edi
  800042:	56                   	push   %esi
  800043:	53                   	push   %ebx
  800044:	83 ec 0c             	sub    $0xc,%esp
  800047:	e8 50 00 00 00       	call   80009c <__x86.get_pc_thunk.bx>
  80004c:	81 c3 b4 1f 00 00    	add    $0x1fb4,%ebx
  800052:	8b 75 08             	mov    0x8(%ebp),%esi
  800055:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800058:	e8 06 01 00 00       	call   800163 <sys_getenvid>
  80005d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800062:	8d 04 40             	lea    (%eax,%eax,2),%eax
  800065:	c1 e0 05             	shl    $0x5,%eax
  800068:	81 c0 00 00 c0 ee    	add    $0xeec00000,%eax
  80006e:	c7 c2 2c 20 80 00    	mov    $0x80202c,%edx
  800074:	89 02                	mov    %eax,(%edx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800076:	85 f6                	test   %esi,%esi
  800078:	7e 08                	jle    800082 <libmain+0x48>
		binaryname = argv[0];
  80007a:	8b 07                	mov    (%edi),%eax
  80007c:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	57                   	push   %edi
  800086:	56                   	push   %esi
  800087:	e8 a7 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008c:	e8 0f 00 00 00       	call   8000a0 <exit>
}
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800097:	5b                   	pop    %ebx
  800098:	5e                   	pop    %esi
  800099:	5f                   	pop    %edi
  80009a:	5d                   	pop    %ebp
  80009b:	c3                   	ret    

0080009c <__x86.get_pc_thunk.bx>:
  80009c:	8b 1c 24             	mov    (%esp),%ebx
  80009f:	c3                   	ret    

008000a0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a0:	f3 0f 1e fb          	endbr32 
  8000a4:	55                   	push   %ebp
  8000a5:	89 e5                	mov    %esp,%ebp
  8000a7:	53                   	push   %ebx
  8000a8:	83 ec 10             	sub    $0x10,%esp
  8000ab:	e8 ec ff ff ff       	call   80009c <__x86.get_pc_thunk.bx>
  8000b0:	81 c3 50 1f 00 00    	add    $0x1f50,%ebx
	sys_env_destroy(0);
  8000b6:	6a 00                	push   $0x0
  8000b8:	e8 4d 00 00 00       	call   80010a <sys_env_destroy>
}
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000c3:	c9                   	leave  
  8000c4:	c3                   	ret    

008000c5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000c5:	f3 0f 1e fb          	endbr32 
  8000c9:	55                   	push   %ebp
  8000ca:	89 e5                	mov    %esp,%ebp
  8000cc:	57                   	push   %edi
  8000cd:	56                   	push   %esi
  8000ce:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000da:	89 c3                	mov    %eax,%ebx
  8000dc:	89 c7                	mov    %eax,%edi
  8000de:	89 c6                	mov    %eax,%esi
  8000e0:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000e2:	5b                   	pop    %ebx
  8000e3:	5e                   	pop    %esi
  8000e4:	5f                   	pop    %edi
  8000e5:	5d                   	pop    %ebp
  8000e6:	c3                   	ret    

008000e7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000e7:	f3 0f 1e fb          	endbr32 
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8000f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8000fb:	89 d1                	mov    %edx,%ecx
  8000fd:	89 d3                	mov    %edx,%ebx
  8000ff:	89 d7                	mov    %edx,%edi
  800101:	89 d6                	mov    %edx,%esi
  800103:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800105:	5b                   	pop    %ebx
  800106:	5e                   	pop    %esi
  800107:	5f                   	pop    %edi
  800108:	5d                   	pop    %ebp
  800109:	c3                   	ret    

0080010a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80010a:	f3 0f 1e fb          	endbr32 
  80010e:	55                   	push   %ebp
  80010f:	89 e5                	mov    %esp,%ebp
  800111:	57                   	push   %edi
  800112:	56                   	push   %esi
  800113:	53                   	push   %ebx
  800114:	83 ec 1c             	sub    $0x1c,%esp
  800117:	e8 6a 00 00 00       	call   800186 <__x86.get_pc_thunk.ax>
  80011c:	05 e4 1e 00 00       	add    $0x1ee4,%eax
  800121:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("int %1\n"
  800124:	b9 00 00 00 00       	mov    $0x0,%ecx
  800129:	8b 55 08             	mov    0x8(%ebp),%edx
  80012c:	b8 03 00 00 00       	mov    $0x3,%eax
  800131:	89 cb                	mov    %ecx,%ebx
  800133:	89 cf                	mov    %ecx,%edi
  800135:	89 ce                	mov    %ecx,%esi
  800137:	cd 30                	int    $0x30
	if(check && ret > 0)
  800139:	85 c0                	test   %eax,%eax
  80013b:	7f 08                	jg     800145 <sys_env_destroy+0x3b>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80013d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800140:	5b                   	pop    %ebx
  800141:	5e                   	pop    %esi
  800142:	5f                   	pop    %edi
  800143:	5d                   	pop    %ebp
  800144:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	50                   	push   %eax
  800149:	6a 03                	push   $0x3
  80014b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80014e:	8d 83 1a ef ff ff    	lea    -0x10e6(%ebx),%eax
  800154:	50                   	push   %eax
  800155:	6a 23                	push   $0x23
  800157:	8d 83 37 ef ff ff    	lea    -0x10c9(%ebx),%eax
  80015d:	50                   	push   %eax
  80015e:	e8 27 00 00 00       	call   80018a <_panic>

00800163 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800163:	f3 0f 1e fb          	endbr32 
  800167:	55                   	push   %ebp
  800168:	89 e5                	mov    %esp,%ebp
  80016a:	57                   	push   %edi
  80016b:	56                   	push   %esi
  80016c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80016d:	ba 00 00 00 00       	mov    $0x0,%edx
  800172:	b8 02 00 00 00       	mov    $0x2,%eax
  800177:	89 d1                	mov    %edx,%ecx
  800179:	89 d3                	mov    %edx,%ebx
  80017b:	89 d7                	mov    %edx,%edi
  80017d:	89 d6                	mov    %edx,%esi
  80017f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800181:	5b                   	pop    %ebx
  800182:	5e                   	pop    %esi
  800183:	5f                   	pop    %edi
  800184:	5d                   	pop    %ebp
  800185:	c3                   	ret    

00800186 <__x86.get_pc_thunk.ax>:
  800186:	8b 04 24             	mov    (%esp),%eax
  800189:	c3                   	ret    

0080018a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80018a:	f3 0f 1e fb          	endbr32 
  80018e:	55                   	push   %ebp
  80018f:	89 e5                	mov    %esp,%ebp
  800191:	57                   	push   %edi
  800192:	56                   	push   %esi
  800193:	53                   	push   %ebx
  800194:	83 ec 0c             	sub    $0xc,%esp
  800197:	e8 00 ff ff ff       	call   80009c <__x86.get_pc_thunk.bx>
  80019c:	81 c3 64 1e 00 00    	add    $0x1e64,%ebx
	va_list ap;

	va_start(ap, fmt);
  8001a2:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001a5:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  8001ab:	8b 38                	mov    (%eax),%edi
  8001ad:	e8 b1 ff ff ff       	call   800163 <sys_getenvid>
  8001b2:	83 ec 0c             	sub    $0xc,%esp
  8001b5:	ff 75 0c             	pushl  0xc(%ebp)
  8001b8:	ff 75 08             	pushl  0x8(%ebp)
  8001bb:	57                   	push   %edi
  8001bc:	50                   	push   %eax
  8001bd:	8d 83 48 ef ff ff    	lea    -0x10b8(%ebx),%eax
  8001c3:	50                   	push   %eax
  8001c4:	e8 d9 00 00 00       	call   8002a2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001c9:	83 c4 18             	add    $0x18,%esp
  8001cc:	56                   	push   %esi
  8001cd:	ff 75 10             	pushl  0x10(%ebp)
  8001d0:	e8 67 00 00 00       	call   80023c <vcprintf>
	cprintf("\n");
  8001d5:	8d 83 6b ef ff ff    	lea    -0x1095(%ebx),%eax
  8001db:	89 04 24             	mov    %eax,(%esp)
  8001de:	e8 bf 00 00 00       	call   8002a2 <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001e6:	cc                   	int3   
  8001e7:	eb fd                	jmp    8001e6 <_panic+0x5c>

008001e9 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001e9:	f3 0f 1e fb          	endbr32 
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	56                   	push   %esi
  8001f1:	53                   	push   %ebx
  8001f2:	e8 a5 fe ff ff       	call   80009c <__x86.get_pc_thunk.bx>
  8001f7:	81 c3 09 1e 00 00    	add    $0x1e09,%ebx
  8001fd:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  800200:	8b 16                	mov    (%esi),%edx
  800202:	8d 42 01             	lea    0x1(%edx),%eax
  800205:	89 06                	mov    %eax,(%esi)
  800207:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80020a:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  80020e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800213:	74 0b                	je     800220 <putch+0x37>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800215:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  800219:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80021c:	5b                   	pop    %ebx
  80021d:	5e                   	pop    %esi
  80021e:	5d                   	pop    %ebp
  80021f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800220:	83 ec 08             	sub    $0x8,%esp
  800223:	68 ff 00 00 00       	push   $0xff
  800228:	8d 46 08             	lea    0x8(%esi),%eax
  80022b:	50                   	push   %eax
  80022c:	e8 94 fe ff ff       	call   8000c5 <sys_cputs>
		b->idx = 0;
  800231:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	eb d9                	jmp    800215 <putch+0x2c>

0080023c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80023c:	f3 0f 1e fb          	endbr32 
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	53                   	push   %ebx
  800244:	81 ec 14 01 00 00    	sub    $0x114,%esp
  80024a:	e8 4d fe ff ff       	call   80009c <__x86.get_pc_thunk.bx>
  80024f:	81 c3 b1 1d 00 00    	add    $0x1db1,%ebx
	struct printbuf b;

	b.idx = 0;
  800255:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80025c:	00 00 00 
	b.cnt = 0;
  80025f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800266:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800269:	ff 75 0c             	pushl  0xc(%ebp)
  80026c:	ff 75 08             	pushl  0x8(%ebp)
  80026f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800275:	50                   	push   %eax
  800276:	8d 83 e9 e1 ff ff    	lea    -0x1e17(%ebx),%eax
  80027c:	50                   	push   %eax
  80027d:	e8 38 01 00 00       	call   8003ba <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800282:	83 c4 08             	add    $0x8,%esp
  800285:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80028b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800291:	50                   	push   %eax
  800292:	e8 2e fe ff ff       	call   8000c5 <sys_cputs>

	return b.cnt;
}
  800297:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80029d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002a0:	c9                   	leave  
  8002a1:	c3                   	ret    

008002a2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002a2:	f3 0f 1e fb          	endbr32 
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  8002a9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002ac:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002af:	50                   	push   %eax
  8002b0:	ff 75 08             	pushl  0x8(%ebp)
  8002b3:	e8 84 ff ff ff       	call   80023c <vcprintf>
	va_end(ap);

	return cnt;
}
  8002b8:	c9                   	leave  
  8002b9:	c3                   	ret    

008002ba <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002ba:	55                   	push   %ebp
  8002bb:	89 e5                	mov    %esp,%ebp
  8002bd:	57                   	push   %edi
  8002be:	56                   	push   %esi
  8002bf:	53                   	push   %ebx
  8002c0:	83 ec 2c             	sub    $0x2c,%esp
  8002c3:	e8 28 06 00 00       	call   8008f0 <__x86.get_pc_thunk.cx>
  8002c8:	81 c1 38 1d 00 00    	add    $0x1d38,%ecx
  8002ce:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002d1:	89 c7                	mov    %eax,%edi
  8002d3:	89 d6                	mov    %edx,%esi
  8002d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002db:	89 d1                	mov    %edx,%ecx
  8002dd:	89 c2                	mov    %eax,%edx
  8002df:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002e2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8002e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e8:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002f5:	39 c2                	cmp    %eax,%edx
  8002f7:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002fa:	72 41                	jb     80033d <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002fc:	83 ec 0c             	sub    $0xc,%esp
  8002ff:	ff 75 18             	pushl  0x18(%ebp)
  800302:	83 eb 01             	sub    $0x1,%ebx
  800305:	53                   	push   %ebx
  800306:	50                   	push   %eax
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030d:	ff 75 e0             	pushl  -0x20(%ebp)
  800310:	ff 75 d4             	pushl  -0x2c(%ebp)
  800313:	ff 75 d0             	pushl  -0x30(%ebp)
  800316:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800319:	e8 92 09 00 00       	call   800cb0 <__udivdi3>
  80031e:	83 c4 18             	add    $0x18,%esp
  800321:	52                   	push   %edx
  800322:	50                   	push   %eax
  800323:	89 f2                	mov    %esi,%edx
  800325:	89 f8                	mov    %edi,%eax
  800327:	e8 8e ff ff ff       	call   8002ba <printnum>
  80032c:	83 c4 20             	add    $0x20,%esp
  80032f:	eb 13                	jmp    800344 <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800331:	83 ec 08             	sub    $0x8,%esp
  800334:	56                   	push   %esi
  800335:	ff 75 18             	pushl  0x18(%ebp)
  800338:	ff d7                	call   *%edi
  80033a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80033d:	83 eb 01             	sub    $0x1,%ebx
  800340:	85 db                	test   %ebx,%ebx
  800342:	7f ed                	jg     800331 <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800344:	83 ec 08             	sub    $0x8,%esp
  800347:	56                   	push   %esi
  800348:	83 ec 04             	sub    $0x4,%esp
  80034b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80034e:	ff 75 e0             	pushl  -0x20(%ebp)
  800351:	ff 75 d4             	pushl  -0x2c(%ebp)
  800354:	ff 75 d0             	pushl  -0x30(%ebp)
  800357:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80035a:	e8 61 0a 00 00       	call   800dc0 <__umoddi3>
  80035f:	83 c4 14             	add    $0x14,%esp
  800362:	0f be 84 03 6d ef ff 	movsbl -0x1093(%ebx,%eax,1),%eax
  800369:	ff 
  80036a:	50                   	push   %eax
  80036b:	ff d7                	call   *%edi
}
  80036d:	83 c4 10             	add    $0x10,%esp
  800370:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800373:	5b                   	pop    %ebx
  800374:	5e                   	pop    %esi
  800375:	5f                   	pop    %edi
  800376:	5d                   	pop    %ebp
  800377:	c3                   	ret    

00800378 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800378:	f3 0f 1e fb          	endbr32 
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800382:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800386:	8b 10                	mov    (%eax),%edx
  800388:	3b 50 04             	cmp    0x4(%eax),%edx
  80038b:	73 0a                	jae    800397 <sprintputch+0x1f>
		*b->buf++ = ch;
  80038d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800390:	89 08                	mov    %ecx,(%eax)
  800392:	8b 45 08             	mov    0x8(%ebp),%eax
  800395:	88 02                	mov    %al,(%edx)
}
  800397:	5d                   	pop    %ebp
  800398:	c3                   	ret    

00800399 <printfmt>:
{
  800399:	f3 0f 1e fb          	endbr32 
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003a3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003a6:	50                   	push   %eax
  8003a7:	ff 75 10             	pushl  0x10(%ebp)
  8003aa:	ff 75 0c             	pushl  0xc(%ebp)
  8003ad:	ff 75 08             	pushl  0x8(%ebp)
  8003b0:	e8 05 00 00 00       	call   8003ba <vprintfmt>
}
  8003b5:	83 c4 10             	add    $0x10,%esp
  8003b8:	c9                   	leave  
  8003b9:	c3                   	ret    

008003ba <vprintfmt>:
{
  8003ba:	f3 0f 1e fb          	endbr32 
  8003be:	55                   	push   %ebp
  8003bf:	89 e5                	mov    %esp,%ebp
  8003c1:	57                   	push   %edi
  8003c2:	56                   	push   %esi
  8003c3:	53                   	push   %ebx
  8003c4:	83 ec 3c             	sub    $0x3c,%esp
  8003c7:	e8 ba fd ff ff       	call   800186 <__x86.get_pc_thunk.ax>
  8003cc:	05 34 1c 00 00       	add    $0x1c34,%eax
  8003d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8003d7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003da:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003dd:	8d 80 10 00 00 00    	lea    0x10(%eax),%eax
  8003e3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8003e6:	e9 cd 03 00 00       	jmp    8007b8 <.L25+0x48>
		padc = ' ';
  8003eb:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
  8003ef:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003f6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003fd:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800404:	b9 00 00 00 00       	mov    $0x0,%ecx
  800409:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80040c:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80040f:	8d 43 01             	lea    0x1(%ebx),%eax
  800412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800415:	0f b6 13             	movzbl (%ebx),%edx
  800418:	8d 42 dd             	lea    -0x23(%edx),%eax
  80041b:	3c 55                	cmp    $0x55,%al
  80041d:	0f 87 21 04 00 00    	ja     800844 <.L20>
  800423:	0f b6 c0             	movzbl %al,%eax
  800426:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800429:	89 ce                	mov    %ecx,%esi
  80042b:	03 b4 81 fc ef ff ff 	add    -0x1004(%ecx,%eax,4),%esi
  800432:	3e ff e6             	notrack jmp *%esi

00800435 <.L68>:
  800435:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
  800438:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80043c:	eb d1                	jmp    80040f <vprintfmt+0x55>

0080043e <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
  80043e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800441:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800445:	eb c8                	jmp    80040f <vprintfmt+0x55>

00800447 <.L31>:
  800447:	0f b6 d2             	movzbl %dl,%edx
  80044a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
  80044d:	b8 00 00 00 00       	mov    $0x0,%eax
  800452:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
  800455:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800458:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80045c:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  80045f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800462:	83 f9 09             	cmp    $0x9,%ecx
  800465:	77 58                	ja     8004bf <.L36+0xf>
			for (precision = 0; ; ++fmt) {
  800467:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  80046a:	eb e9                	jmp    800455 <.L31+0xe>

0080046c <.L34>:
			precision = va_arg(ap, int);
  80046c:	8b 45 14             	mov    0x14(%ebp),%eax
  80046f:	8b 00                	mov    (%eax),%eax
  800471:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800474:	8b 45 14             	mov    0x14(%ebp),%eax
  800477:	8d 40 04             	lea    0x4(%eax),%eax
  80047a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80047d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
  800480:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800484:	79 89                	jns    80040f <vprintfmt+0x55>
				width = precision, precision = -1;
  800486:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800489:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80048c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800493:	e9 77 ff ff ff       	jmp    80040f <vprintfmt+0x55>

00800498 <.L33>:
  800498:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80049b:	85 c0                	test   %eax,%eax
  80049d:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a2:	0f 49 d0             	cmovns %eax,%edx
  8004a5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a8:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004ab:	e9 5f ff ff ff       	jmp    80040f <vprintfmt+0x55>

008004b0 <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
  8004b0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
  8004b3:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004ba:	e9 50 ff ff ff       	jmp    80040f <vprintfmt+0x55>
  8004bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c2:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c5:	eb b9                	jmp    800480 <.L34+0x14>

008004c7 <.L27>:
			lflag++;
  8004c7:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004cb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004ce:	e9 3c ff ff ff       	jmp    80040f <vprintfmt+0x55>

008004d3 <.L30>:
  8004d3:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(va_arg(ap, int), putdat);
  8004d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d9:	8d 58 04             	lea    0x4(%eax),%ebx
  8004dc:	83 ec 08             	sub    $0x8,%esp
  8004df:	57                   	push   %edi
  8004e0:	ff 30                	pushl  (%eax)
  8004e2:	ff d6                	call   *%esi
			break;
  8004e4:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004e7:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
  8004ea:	e9 c6 02 00 00       	jmp    8007b5 <.L25+0x45>

008004ef <.L28>:
  8004ef:	8b 75 08             	mov    0x8(%ebp),%esi
			err = va_arg(ap, int);
  8004f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f5:	8d 58 04             	lea    0x4(%eax),%ebx
  8004f8:	8b 00                	mov    (%eax),%eax
  8004fa:	99                   	cltd   
  8004fb:	31 d0                	xor    %edx,%eax
  8004fd:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004ff:	83 f8 06             	cmp    $0x6,%eax
  800502:	7f 27                	jg     80052b <.L28+0x3c>
  800504:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800507:	8b 14 82             	mov    (%edx,%eax,4),%edx
  80050a:	85 d2                	test   %edx,%edx
  80050c:	74 1d                	je     80052b <.L28+0x3c>
				printfmt(putch, putdat, "%s", p);
  80050e:	52                   	push   %edx
  80050f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800512:	8d 80 8e ef ff ff    	lea    -0x1072(%eax),%eax
  800518:	50                   	push   %eax
  800519:	57                   	push   %edi
  80051a:	56                   	push   %esi
  80051b:	e8 79 fe ff ff       	call   800399 <printfmt>
  800520:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800523:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800526:	e9 8a 02 00 00       	jmp    8007b5 <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
  80052b:	50                   	push   %eax
  80052c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80052f:	8d 80 85 ef ff ff    	lea    -0x107b(%eax),%eax
  800535:	50                   	push   %eax
  800536:	57                   	push   %edi
  800537:	56                   	push   %esi
  800538:	e8 5c fe ff ff       	call   800399 <printfmt>
  80053d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800540:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800543:	e9 6d 02 00 00       	jmp    8007b5 <.L25+0x45>

00800548 <.L24>:
  800548:	8b 75 08             	mov    0x8(%ebp),%esi
			if ((p = va_arg(ap, char *)) == NULL)
  80054b:	8b 45 14             	mov    0x14(%ebp),%eax
  80054e:	83 c0 04             	add    $0x4,%eax
  800551:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800554:	8b 45 14             	mov    0x14(%ebp),%eax
  800557:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800559:	85 d2                	test   %edx,%edx
  80055b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80055e:	8d 80 7e ef ff ff    	lea    -0x1082(%eax),%eax
  800564:	0f 45 c2             	cmovne %edx,%eax
  800567:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80056a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80056e:	7e 06                	jle    800576 <.L24+0x2e>
  800570:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800574:	75 0d                	jne    800583 <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800576:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800579:	89 c3                	mov    %eax,%ebx
  80057b:	03 45 d4             	add    -0x2c(%ebp),%eax
  80057e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800581:	eb 58                	jmp    8005db <.L24+0x93>
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	ff 75 d8             	pushl  -0x28(%ebp)
  800589:	ff 75 c8             	pushl  -0x38(%ebp)
  80058c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80058f:	e8 7c 03 00 00       	call   800910 <strnlen>
  800594:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800597:	29 c2                	sub    %eax,%edx
  800599:	89 55 bc             	mov    %edx,-0x44(%ebp)
  80059c:	83 c4 10             	add    $0x10,%esp
  80059f:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
  8005a1:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a8:	85 db                	test   %ebx,%ebx
  8005aa:	7e 11                	jle    8005bd <.L24+0x75>
					putch(padc, putdat);
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	57                   	push   %edi
  8005b0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8005b3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b5:	83 eb 01             	sub    $0x1,%ebx
  8005b8:	83 c4 10             	add    $0x10,%esp
  8005bb:	eb eb                	jmp    8005a8 <.L24+0x60>
  8005bd:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8005c0:	85 d2                	test   %edx,%edx
  8005c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c7:	0f 49 c2             	cmovns %edx,%eax
  8005ca:	29 c2                	sub    %eax,%edx
  8005cc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005cf:	eb a5                	jmp    800576 <.L24+0x2e>
					putch(ch, putdat);
  8005d1:	83 ec 08             	sub    $0x8,%esp
  8005d4:	57                   	push   %edi
  8005d5:	52                   	push   %edx
  8005d6:	ff d6                	call   *%esi
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005de:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005e0:	83 c3 01             	add    $0x1,%ebx
  8005e3:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8005e7:	0f be d0             	movsbl %al,%edx
  8005ea:	85 d2                	test   %edx,%edx
  8005ec:	74 4b                	je     800639 <.L24+0xf1>
  8005ee:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005f2:	78 06                	js     8005fa <.L24+0xb2>
  8005f4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005f8:	78 1e                	js     800618 <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
  8005fa:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005fe:	74 d1                	je     8005d1 <.L24+0x89>
  800600:	0f be c0             	movsbl %al,%eax
  800603:	83 e8 20             	sub    $0x20,%eax
  800606:	83 f8 5e             	cmp    $0x5e,%eax
  800609:	76 c6                	jbe    8005d1 <.L24+0x89>
					putch('?', putdat);
  80060b:	83 ec 08             	sub    $0x8,%esp
  80060e:	57                   	push   %edi
  80060f:	6a 3f                	push   $0x3f
  800611:	ff d6                	call   *%esi
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	eb c3                	jmp    8005db <.L24+0x93>
  800618:	89 cb                	mov    %ecx,%ebx
  80061a:	eb 0e                	jmp    80062a <.L24+0xe2>
				putch(' ', putdat);
  80061c:	83 ec 08             	sub    $0x8,%esp
  80061f:	57                   	push   %edi
  800620:	6a 20                	push   $0x20
  800622:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800624:	83 eb 01             	sub    $0x1,%ebx
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	85 db                	test   %ebx,%ebx
  80062c:	7f ee                	jg     80061c <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
  80062e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800631:	89 45 14             	mov    %eax,0x14(%ebp)
  800634:	e9 7c 01 00 00       	jmp    8007b5 <.L25+0x45>
  800639:	89 cb                	mov    %ecx,%ebx
  80063b:	eb ed                	jmp    80062a <.L24+0xe2>

0080063d <.L29>:
  80063d:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800640:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  800643:	83 f9 01             	cmp    $0x1,%ecx
  800646:	7f 1b                	jg     800663 <.L29+0x26>
	else if (lflag)
  800648:	85 c9                	test   %ecx,%ecx
  80064a:	74 63                	je     8006af <.L29+0x72>
		return va_arg(*ap, long);
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800654:	99                   	cltd   
  800655:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8d 40 04             	lea    0x4(%eax),%eax
  80065e:	89 45 14             	mov    %eax,0x14(%ebp)
  800661:	eb 17                	jmp    80067a <.L29+0x3d>
		return va_arg(*ap, long long);
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	8b 50 04             	mov    0x4(%eax),%edx
  800669:	8b 00                	mov    (%eax),%eax
  80066b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8d 40 08             	lea    0x8(%eax),%eax
  800677:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80067a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80067d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800680:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800685:	85 c9                	test   %ecx,%ecx
  800687:	0f 89 0e 01 00 00    	jns    80079b <.L25+0x2b>
				putch('-', putdat);
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	57                   	push   %edi
  800691:	6a 2d                	push   $0x2d
  800693:	ff d6                	call   *%esi
				num = -(long long) num;
  800695:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800698:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80069b:	f7 da                	neg    %edx
  80069d:	83 d1 00             	adc    $0x0,%ecx
  8006a0:	f7 d9                	neg    %ecx
  8006a2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006a5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006aa:	e9 ec 00 00 00       	jmp    80079b <.L25+0x2b>
		return va_arg(*ap, int);
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b7:	99                   	cltd   
  8006b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	8d 40 04             	lea    0x4(%eax),%eax
  8006c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c4:	eb b4                	jmp    80067a <.L29+0x3d>

008006c6 <.L23>:
  8006c6:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006c9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  8006cc:	83 f9 01             	cmp    $0x1,%ecx
  8006cf:	7f 1e                	jg     8006ef <.L23+0x29>
	else if (lflag)
  8006d1:	85 c9                	test   %ecx,%ecx
  8006d3:	74 32                	je     800707 <.L23+0x41>
		return va_arg(*ap, unsigned long);
  8006d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d8:	8b 10                	mov    (%eax),%edx
  8006da:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006df:	8d 40 04             	lea    0x4(%eax),%eax
  8006e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e5:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8006ea:	e9 ac 00 00 00       	jmp    80079b <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8b 10                	mov    (%eax),%edx
  8006f4:	8b 48 04             	mov    0x4(%eax),%ecx
  8006f7:	8d 40 08             	lea    0x8(%eax),%eax
  8006fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006fd:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800702:	e9 94 00 00 00       	jmp    80079b <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8b 10                	mov    (%eax),%edx
  80070c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800711:	8d 40 04             	lea    0x4(%eax),%eax
  800714:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800717:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80071c:	eb 7d                	jmp    80079b <.L25+0x2b>

0080071e <.L26>:
  80071e:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800721:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  800724:	83 f9 01             	cmp    $0x1,%ecx
  800727:	7f 1b                	jg     800744 <.L26+0x26>
	else if (lflag)
  800729:	85 c9                	test   %ecx,%ecx
  80072b:	74 2c                	je     800759 <.L26+0x3b>
		return va_arg(*ap, unsigned long);
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8b 10                	mov    (%eax),%edx
  800732:	b9 00 00 00 00       	mov    $0x0,%ecx
  800737:	8d 40 04             	lea    0x4(%eax),%eax
  80073a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80073d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800742:	eb 57                	jmp    80079b <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800744:	8b 45 14             	mov    0x14(%ebp),%eax
  800747:	8b 10                	mov    (%eax),%edx
  800749:	8b 48 04             	mov    0x4(%eax),%ecx
  80074c:	8d 40 08             	lea    0x8(%eax),%eax
  80074f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800752:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800757:	eb 42                	jmp    80079b <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	8b 10                	mov    (%eax),%edx
  80075e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800763:	8d 40 04             	lea    0x4(%eax),%eax
  800766:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800769:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80076e:	eb 2b                	jmp    80079b <.L25+0x2b>

00800770 <.L25>:
  800770:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('0', putdat);
  800773:	83 ec 08             	sub    $0x8,%esp
  800776:	57                   	push   %edi
  800777:	6a 30                	push   $0x30
  800779:	ff d6                	call   *%esi
			putch('x', putdat);
  80077b:	83 c4 08             	add    $0x8,%esp
  80077e:	57                   	push   %edi
  80077f:	6a 78                	push   $0x78
  800781:	ff d6                	call   *%esi
			num = (unsigned long long)
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	8b 10                	mov    (%eax),%edx
  800788:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80078d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800790:	8d 40 04             	lea    0x4(%eax),%eax
  800793:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800796:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80079b:	83 ec 0c             	sub    $0xc,%esp
  80079e:	0f be 5d cf          	movsbl -0x31(%ebp),%ebx
  8007a2:	53                   	push   %ebx
  8007a3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8007a6:	50                   	push   %eax
  8007a7:	51                   	push   %ecx
  8007a8:	52                   	push   %edx
  8007a9:	89 fa                	mov    %edi,%edx
  8007ab:	89 f0                	mov    %esi,%eax
  8007ad:	e8 08 fb ff ff       	call   8002ba <printnum>
			break;
  8007b2:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007b5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b8:	83 c3 01             	add    $0x1,%ebx
  8007bb:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8007bf:	83 f8 25             	cmp    $0x25,%eax
  8007c2:	0f 84 23 fc ff ff    	je     8003eb <vprintfmt+0x31>
			if (ch == '\0')
  8007c8:	85 c0                	test   %eax,%eax
  8007ca:	0f 84 97 00 00 00    	je     800867 <.L20+0x23>
			putch(ch, putdat);
  8007d0:	83 ec 08             	sub    $0x8,%esp
  8007d3:	57                   	push   %edi
  8007d4:	50                   	push   %eax
  8007d5:	ff d6                	call   *%esi
  8007d7:	83 c4 10             	add    $0x10,%esp
  8007da:	eb dc                	jmp    8007b8 <.L25+0x48>

008007dc <.L21>:
  8007dc:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8007df:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  8007e2:	83 f9 01             	cmp    $0x1,%ecx
  8007e5:	7f 1b                	jg     800802 <.L21+0x26>
	else if (lflag)
  8007e7:	85 c9                	test   %ecx,%ecx
  8007e9:	74 2c                	je     800817 <.L21+0x3b>
		return va_arg(*ap, unsigned long);
  8007eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ee:	8b 10                	mov    (%eax),%edx
  8007f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007f5:	8d 40 04             	lea    0x4(%eax),%eax
  8007f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007fb:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800800:	eb 99                	jmp    80079b <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	8b 10                	mov    (%eax),%edx
  800807:	8b 48 04             	mov    0x4(%eax),%ecx
  80080a:	8d 40 08             	lea    0x8(%eax),%eax
  80080d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800810:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800815:	eb 84                	jmp    80079b <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800817:	8b 45 14             	mov    0x14(%ebp),%eax
  80081a:	8b 10                	mov    (%eax),%edx
  80081c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800821:	8d 40 04             	lea    0x4(%eax),%eax
  800824:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800827:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80082c:	e9 6a ff ff ff       	jmp    80079b <.L25+0x2b>

00800831 <.L35>:
  800831:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(ch, putdat);
  800834:	83 ec 08             	sub    $0x8,%esp
  800837:	57                   	push   %edi
  800838:	6a 25                	push   $0x25
  80083a:	ff d6                	call   *%esi
			break;
  80083c:	83 c4 10             	add    $0x10,%esp
  80083f:	e9 71 ff ff ff       	jmp    8007b5 <.L25+0x45>

00800844 <.L20>:
  800844:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('%', putdat);
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	57                   	push   %edi
  80084b:	6a 25                	push   $0x25
  80084d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80084f:	83 c4 10             	add    $0x10,%esp
  800852:	89 d8                	mov    %ebx,%eax
  800854:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800858:	74 05                	je     80085f <.L20+0x1b>
  80085a:	83 e8 01             	sub    $0x1,%eax
  80085d:	eb f5                	jmp    800854 <.L20+0x10>
  80085f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800862:	e9 4e ff ff ff       	jmp    8007b5 <.L25+0x45>
}
  800867:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80086a:	5b                   	pop    %ebx
  80086b:	5e                   	pop    %esi
  80086c:	5f                   	pop    %edi
  80086d:	5d                   	pop    %ebp
  80086e:	c3                   	ret    

0080086f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80086f:	f3 0f 1e fb          	endbr32 
  800873:	55                   	push   %ebp
  800874:	89 e5                	mov    %esp,%ebp
  800876:	53                   	push   %ebx
  800877:	83 ec 14             	sub    $0x14,%esp
  80087a:	e8 1d f8 ff ff       	call   80009c <__x86.get_pc_thunk.bx>
  80087f:	81 c3 81 17 00 00    	add    $0x1781,%ebx
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80088b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80088e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800892:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800895:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80089c:	85 c0                	test   %eax,%eax
  80089e:	74 2b                	je     8008cb <vsnprintf+0x5c>
  8008a0:	85 d2                	test   %edx,%edx
  8008a2:	7e 27                	jle    8008cb <vsnprintf+0x5c>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008a4:	ff 75 14             	pushl  0x14(%ebp)
  8008a7:	ff 75 10             	pushl  0x10(%ebp)
  8008aa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ad:	50                   	push   %eax
  8008ae:	8d 83 78 e3 ff ff    	lea    -0x1c88(%ebx),%eax
  8008b4:	50                   	push   %eax
  8008b5:	e8 00 fb ff ff       	call   8003ba <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008bd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c3:	83 c4 10             	add    $0x10,%esp
}
  8008c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c9:	c9                   	leave  
  8008ca:	c3                   	ret    
		return -E_INVAL;
  8008cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d0:	eb f4                	jmp    8008c6 <vsnprintf+0x57>

008008d2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008d2:	f3 0f 1e fb          	endbr32 
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008dc:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008df:	50                   	push   %eax
  8008e0:	ff 75 10             	pushl  0x10(%ebp)
  8008e3:	ff 75 0c             	pushl  0xc(%ebp)
  8008e6:	ff 75 08             	pushl  0x8(%ebp)
  8008e9:	e8 81 ff ff ff       	call   80086f <vsnprintf>
	va_end(ap);

	return rc;
}
  8008ee:	c9                   	leave  
  8008ef:	c3                   	ret    

008008f0 <__x86.get_pc_thunk.cx>:
  8008f0:	8b 0c 24             	mov    (%esp),%ecx
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
  800ca9:	66 90                	xchg   %ax,%ax
  800cab:	66 90                	xchg   %ax,%ax
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
