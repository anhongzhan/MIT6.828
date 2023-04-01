
obj/user/evilhello:     file format elf32-i386


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
  80002c:	e8 30 00 00 00       	call   800061 <libmain>
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
  80003b:	83 ec 0c             	sub    $0xc,%esp
  80003e:	e8 1a 00 00 00       	call   80005d <__x86.get_pc_thunk.bx>
  800043:	81 c3 bd 1f 00 00    	add    $0x1fbd,%ebx
	// try to print the kernel entry point as a string!  mua ha ha!
	sys_cputs((char*)0xf010000c, 100);
  800049:	6a 64                	push   $0x64
  80004b:	68 0c 00 10 f0       	push   $0xf010000c
  800050:	e8 93 00 00 00       	call   8000e8 <sys_cputs>
}
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80005b:	c9                   	leave  
  80005c:	c3                   	ret    

0080005d <__x86.get_pc_thunk.bx>:
  80005d:	8b 1c 24             	mov    (%esp),%ebx
  800060:	c3                   	ret    

00800061 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800061:	f3 0f 1e fb          	endbr32 
  800065:	55                   	push   %ebp
  800066:	89 e5                	mov    %esp,%ebp
  800068:	57                   	push   %edi
  800069:	56                   	push   %esi
  80006a:	53                   	push   %ebx
  80006b:	83 ec 0c             	sub    $0xc,%esp
  80006e:	e8 ea ff ff ff       	call   80005d <__x86.get_pc_thunk.bx>
  800073:	81 c3 8d 1f 00 00    	add    $0x1f8d,%ebx
  800079:	8b 75 08             	mov    0x8(%ebp),%esi
  80007c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80007f:	e8 02 01 00 00       	call   800186 <sys_getenvid>
  800084:	25 ff 03 00 00       	and    $0x3ff,%eax
  800089:	8d 04 40             	lea    (%eax,%eax,2),%eax
  80008c:	c1 e0 05             	shl    $0x5,%eax
  80008f:	81 c0 00 00 c0 ee    	add    $0xeec00000,%eax
  800095:	c7 c2 2c 20 80 00    	mov    $0x80202c,%edx
  80009b:	89 02                	mov    %eax,(%edx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009d:	85 f6                	test   %esi,%esi
  80009f:	7e 08                	jle    8000a9 <libmain+0x48>
		binaryname = argv[0];
  8000a1:	8b 07                	mov    (%edi),%eax
  8000a3:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  8000a9:	83 ec 08             	sub    $0x8,%esp
  8000ac:	57                   	push   %edi
  8000ad:	56                   	push   %esi
  8000ae:	e8 80 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000b3:	e8 0b 00 00 00       	call   8000c3 <exit>
}
  8000b8:	83 c4 10             	add    $0x10,%esp
  8000bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000be:	5b                   	pop    %ebx
  8000bf:	5e                   	pop    %esi
  8000c0:	5f                   	pop    %edi
  8000c1:	5d                   	pop    %ebp
  8000c2:	c3                   	ret    

008000c3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c3:	f3 0f 1e fb          	endbr32 
  8000c7:	55                   	push   %ebp
  8000c8:	89 e5                	mov    %esp,%ebp
  8000ca:	53                   	push   %ebx
  8000cb:	83 ec 10             	sub    $0x10,%esp
  8000ce:	e8 8a ff ff ff       	call   80005d <__x86.get_pc_thunk.bx>
  8000d3:	81 c3 2d 1f 00 00    	add    $0x1f2d,%ebx
	sys_env_destroy(0);
  8000d9:	6a 00                	push   $0x0
  8000db:	e8 4d 00 00 00       	call   80012d <sys_env_destroy>
}
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000e6:	c9                   	leave  
  8000e7:	c3                   	ret    

008000e8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000e8:	f3 0f 1e fb          	endbr32 
  8000ec:	55                   	push   %ebp
  8000ed:	89 e5                	mov    %esp,%ebp
  8000ef:	57                   	push   %edi
  8000f0:	56                   	push   %esi
  8000f1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8000fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000fd:	89 c3                	mov    %eax,%ebx
  8000ff:	89 c7                	mov    %eax,%edi
  800101:	89 c6                	mov    %eax,%esi
  800103:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800105:	5b                   	pop    %ebx
  800106:	5e                   	pop    %esi
  800107:	5f                   	pop    %edi
  800108:	5d                   	pop    %ebp
  800109:	c3                   	ret    

0080010a <sys_cgetc>:

int
sys_cgetc(void)
{
  80010a:	f3 0f 1e fb          	endbr32 
  80010e:	55                   	push   %ebp
  80010f:	89 e5                	mov    %esp,%ebp
  800111:	57                   	push   %edi
  800112:	56                   	push   %esi
  800113:	53                   	push   %ebx
	asm volatile("int %1\n"
  800114:	ba 00 00 00 00       	mov    $0x0,%edx
  800119:	b8 01 00 00 00       	mov    $0x1,%eax
  80011e:	89 d1                	mov    %edx,%ecx
  800120:	89 d3                	mov    %edx,%ebx
  800122:	89 d7                	mov    %edx,%edi
  800124:	89 d6                	mov    %edx,%esi
  800126:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800128:	5b                   	pop    %ebx
  800129:	5e                   	pop    %esi
  80012a:	5f                   	pop    %edi
  80012b:	5d                   	pop    %ebp
  80012c:	c3                   	ret    

0080012d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80012d:	f3 0f 1e fb          	endbr32 
  800131:	55                   	push   %ebp
  800132:	89 e5                	mov    %esp,%ebp
  800134:	57                   	push   %edi
  800135:	56                   	push   %esi
  800136:	53                   	push   %ebx
  800137:	83 ec 1c             	sub    $0x1c,%esp
  80013a:	e8 6a 00 00 00       	call   8001a9 <__x86.get_pc_thunk.ax>
  80013f:	05 c1 1e 00 00       	add    $0x1ec1,%eax
  800144:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("int %1\n"
  800147:	b9 00 00 00 00       	mov    $0x0,%ecx
  80014c:	8b 55 08             	mov    0x8(%ebp),%edx
  80014f:	b8 03 00 00 00       	mov    $0x3,%eax
  800154:	89 cb                	mov    %ecx,%ebx
  800156:	89 cf                	mov    %ecx,%edi
  800158:	89 ce                	mov    %ecx,%esi
  80015a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80015c:	85 c0                	test   %eax,%eax
  80015e:	7f 08                	jg     800168 <sys_env_destroy+0x3b>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800160:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800163:	5b                   	pop    %ebx
  800164:	5e                   	pop    %esi
  800165:	5f                   	pop    %edi
  800166:	5d                   	pop    %ebp
  800167:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800168:	83 ec 0c             	sub    $0xc,%esp
  80016b:	50                   	push   %eax
  80016c:	6a 03                	push   $0x3
  80016e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800171:	8d 83 3a ef ff ff    	lea    -0x10c6(%ebx),%eax
  800177:	50                   	push   %eax
  800178:	6a 23                	push   $0x23
  80017a:	8d 83 57 ef ff ff    	lea    -0x10a9(%ebx),%eax
  800180:	50                   	push   %eax
  800181:	e8 27 00 00 00       	call   8001ad <_panic>

00800186 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800186:	f3 0f 1e fb          	endbr32 
  80018a:	55                   	push   %ebp
  80018b:	89 e5                	mov    %esp,%ebp
  80018d:	57                   	push   %edi
  80018e:	56                   	push   %esi
  80018f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800190:	ba 00 00 00 00       	mov    $0x0,%edx
  800195:	b8 02 00 00 00       	mov    $0x2,%eax
  80019a:	89 d1                	mov    %edx,%ecx
  80019c:	89 d3                	mov    %edx,%ebx
  80019e:	89 d7                	mov    %edx,%edi
  8001a0:	89 d6                	mov    %edx,%esi
  8001a2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8001a4:	5b                   	pop    %ebx
  8001a5:	5e                   	pop    %esi
  8001a6:	5f                   	pop    %edi
  8001a7:	5d                   	pop    %ebp
  8001a8:	c3                   	ret    

008001a9 <__x86.get_pc_thunk.ax>:
  8001a9:	8b 04 24             	mov    (%esp),%eax
  8001ac:	c3                   	ret    

008001ad <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001ad:	f3 0f 1e fb          	endbr32 
  8001b1:	55                   	push   %ebp
  8001b2:	89 e5                	mov    %esp,%ebp
  8001b4:	57                   	push   %edi
  8001b5:	56                   	push   %esi
  8001b6:	53                   	push   %ebx
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	e8 9e fe ff ff       	call   80005d <__x86.get_pc_thunk.bx>
  8001bf:	81 c3 41 1e 00 00    	add    $0x1e41,%ebx
	va_list ap;

	va_start(ap, fmt);
  8001c5:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001c8:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  8001ce:	8b 38                	mov    (%eax),%edi
  8001d0:	e8 b1 ff ff ff       	call   800186 <sys_getenvid>
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	ff 75 0c             	pushl  0xc(%ebp)
  8001db:	ff 75 08             	pushl  0x8(%ebp)
  8001de:	57                   	push   %edi
  8001df:	50                   	push   %eax
  8001e0:	8d 83 68 ef ff ff    	lea    -0x1098(%ebx),%eax
  8001e6:	50                   	push   %eax
  8001e7:	e8 d9 00 00 00       	call   8002c5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001ec:	83 c4 18             	add    $0x18,%esp
  8001ef:	56                   	push   %esi
  8001f0:	ff 75 10             	pushl  0x10(%ebp)
  8001f3:	e8 67 00 00 00       	call   80025f <vcprintf>
	cprintf("\n");
  8001f8:	8d 83 8b ef ff ff    	lea    -0x1075(%ebx),%eax
  8001fe:	89 04 24             	mov    %eax,(%esp)
  800201:	e8 bf 00 00 00       	call   8002c5 <cprintf>
  800206:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800209:	cc                   	int3   
  80020a:	eb fd                	jmp    800209 <_panic+0x5c>

0080020c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80020c:	f3 0f 1e fb          	endbr32 
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	56                   	push   %esi
  800214:	53                   	push   %ebx
  800215:	e8 43 fe ff ff       	call   80005d <__x86.get_pc_thunk.bx>
  80021a:	81 c3 e6 1d 00 00    	add    $0x1de6,%ebx
  800220:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  800223:	8b 16                	mov    (%esi),%edx
  800225:	8d 42 01             	lea    0x1(%edx),%eax
  800228:	89 06                	mov    %eax,(%esi)
  80022a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80022d:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  800231:	3d ff 00 00 00       	cmp    $0xff,%eax
  800236:	74 0b                	je     800243 <putch+0x37>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800238:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  80023c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80023f:	5b                   	pop    %ebx
  800240:	5e                   	pop    %esi
  800241:	5d                   	pop    %ebp
  800242:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	68 ff 00 00 00       	push   $0xff
  80024b:	8d 46 08             	lea    0x8(%esi),%eax
  80024e:	50                   	push   %eax
  80024f:	e8 94 fe ff ff       	call   8000e8 <sys_cputs>
		b->idx = 0;
  800254:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80025a:	83 c4 10             	add    $0x10,%esp
  80025d:	eb d9                	jmp    800238 <putch+0x2c>

0080025f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80025f:	f3 0f 1e fb          	endbr32 
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	53                   	push   %ebx
  800267:	81 ec 14 01 00 00    	sub    $0x114,%esp
  80026d:	e8 eb fd ff ff       	call   80005d <__x86.get_pc_thunk.bx>
  800272:	81 c3 8e 1d 00 00    	add    $0x1d8e,%ebx
	struct printbuf b;

	b.idx = 0;
  800278:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80027f:	00 00 00 
	b.cnt = 0;
  800282:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800289:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80028c:	ff 75 0c             	pushl  0xc(%ebp)
  80028f:	ff 75 08             	pushl  0x8(%ebp)
  800292:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800298:	50                   	push   %eax
  800299:	8d 83 0c e2 ff ff    	lea    -0x1df4(%ebx),%eax
  80029f:	50                   	push   %eax
  8002a0:	e8 38 01 00 00       	call   8003dd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002a5:	83 c4 08             	add    $0x8,%esp
  8002a8:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002ae:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002b4:	50                   	push   %eax
  8002b5:	e8 2e fe ff ff       	call   8000e8 <sys_cputs>

	return b.cnt;
}
  8002ba:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002c3:	c9                   	leave  
  8002c4:	c3                   	ret    

008002c5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002c5:	f3 0f 1e fb          	endbr32 
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002cf:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002d2:	50                   	push   %eax
  8002d3:	ff 75 08             	pushl  0x8(%ebp)
  8002d6:	e8 84 ff ff ff       	call   80025f <vcprintf>
	va_end(ap);

	return cnt;
}
  8002db:	c9                   	leave  
  8002dc:	c3                   	ret    

008002dd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	57                   	push   %edi
  8002e1:	56                   	push   %esi
  8002e2:	53                   	push   %ebx
  8002e3:	83 ec 2c             	sub    $0x2c,%esp
  8002e6:	e8 28 06 00 00       	call   800913 <__x86.get_pc_thunk.cx>
  8002eb:	81 c1 15 1d 00 00    	add    $0x1d15,%ecx
  8002f1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002f4:	89 c7                	mov    %eax,%edi
  8002f6:	89 d6                	mov    %edx,%esi
  8002f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002fe:	89 d1                	mov    %edx,%ecx
  800300:	89 c2                	mov    %eax,%edx
  800302:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800305:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800308:	8b 45 10             	mov    0x10(%ebp),%eax
  80030b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80030e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800311:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800318:	39 c2                	cmp    %eax,%edx
  80031a:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80031d:	72 41                	jb     800360 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	ff 75 18             	pushl  0x18(%ebp)
  800325:	83 eb 01             	sub    $0x1,%ebx
  800328:	53                   	push   %ebx
  800329:	50                   	push   %eax
  80032a:	83 ec 08             	sub    $0x8,%esp
  80032d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800330:	ff 75 e0             	pushl  -0x20(%ebp)
  800333:	ff 75 d4             	pushl  -0x2c(%ebp)
  800336:	ff 75 d0             	pushl  -0x30(%ebp)
  800339:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80033c:	e8 8f 09 00 00       	call   800cd0 <__udivdi3>
  800341:	83 c4 18             	add    $0x18,%esp
  800344:	52                   	push   %edx
  800345:	50                   	push   %eax
  800346:	89 f2                	mov    %esi,%edx
  800348:	89 f8                	mov    %edi,%eax
  80034a:	e8 8e ff ff ff       	call   8002dd <printnum>
  80034f:	83 c4 20             	add    $0x20,%esp
  800352:	eb 13                	jmp    800367 <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800354:	83 ec 08             	sub    $0x8,%esp
  800357:	56                   	push   %esi
  800358:	ff 75 18             	pushl  0x18(%ebp)
  80035b:	ff d7                	call   *%edi
  80035d:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800360:	83 eb 01             	sub    $0x1,%ebx
  800363:	85 db                	test   %ebx,%ebx
  800365:	7f ed                	jg     800354 <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800367:	83 ec 08             	sub    $0x8,%esp
  80036a:	56                   	push   %esi
  80036b:	83 ec 04             	sub    $0x4,%esp
  80036e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800371:	ff 75 e0             	pushl  -0x20(%ebp)
  800374:	ff 75 d4             	pushl  -0x2c(%ebp)
  800377:	ff 75 d0             	pushl  -0x30(%ebp)
  80037a:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80037d:	e8 5e 0a 00 00       	call   800de0 <__umoddi3>
  800382:	83 c4 14             	add    $0x14,%esp
  800385:	0f be 84 03 8d ef ff 	movsbl -0x1073(%ebx,%eax,1),%eax
  80038c:	ff 
  80038d:	50                   	push   %eax
  80038e:	ff d7                	call   *%edi
}
  800390:	83 c4 10             	add    $0x10,%esp
  800393:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800396:	5b                   	pop    %ebx
  800397:	5e                   	pop    %esi
  800398:	5f                   	pop    %edi
  800399:	5d                   	pop    %ebp
  80039a:	c3                   	ret    

0080039b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80039b:	f3 0f 1e fb          	endbr32 
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003a5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003a9:	8b 10                	mov    (%eax),%edx
  8003ab:	3b 50 04             	cmp    0x4(%eax),%edx
  8003ae:	73 0a                	jae    8003ba <sprintputch+0x1f>
		*b->buf++ = ch;
  8003b0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003b3:	89 08                	mov    %ecx,(%eax)
  8003b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b8:	88 02                	mov    %al,(%edx)
}
  8003ba:	5d                   	pop    %ebp
  8003bb:	c3                   	ret    

008003bc <printfmt>:
{
  8003bc:	f3 0f 1e fb          	endbr32 
  8003c0:	55                   	push   %ebp
  8003c1:	89 e5                	mov    %esp,%ebp
  8003c3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003c6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003c9:	50                   	push   %eax
  8003ca:	ff 75 10             	pushl  0x10(%ebp)
  8003cd:	ff 75 0c             	pushl  0xc(%ebp)
  8003d0:	ff 75 08             	pushl  0x8(%ebp)
  8003d3:	e8 05 00 00 00       	call   8003dd <vprintfmt>
}
  8003d8:	83 c4 10             	add    $0x10,%esp
  8003db:	c9                   	leave  
  8003dc:	c3                   	ret    

008003dd <vprintfmt>:
{
  8003dd:	f3 0f 1e fb          	endbr32 
  8003e1:	55                   	push   %ebp
  8003e2:	89 e5                	mov    %esp,%ebp
  8003e4:	57                   	push   %edi
  8003e5:	56                   	push   %esi
  8003e6:	53                   	push   %ebx
  8003e7:	83 ec 3c             	sub    $0x3c,%esp
  8003ea:	e8 ba fd ff ff       	call   8001a9 <__x86.get_pc_thunk.ax>
  8003ef:	05 11 1c 00 00       	add    $0x1c11,%eax
  8003f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f7:	8b 75 08             	mov    0x8(%ebp),%esi
  8003fa:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800400:	8d 80 10 00 00 00    	lea    0x10(%eax),%eax
  800406:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800409:	e9 cd 03 00 00       	jmp    8007db <.L25+0x48>
		padc = ' ';
  80040e:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
  800412:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800419:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800420:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800427:	b9 00 00 00 00       	mov    $0x0,%ecx
  80042c:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80042f:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800432:	8d 43 01             	lea    0x1(%ebx),%eax
  800435:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800438:	0f b6 13             	movzbl (%ebx),%edx
  80043b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80043e:	3c 55                	cmp    $0x55,%al
  800440:	0f 87 21 04 00 00    	ja     800867 <.L20>
  800446:	0f b6 c0             	movzbl %al,%eax
  800449:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80044c:	89 ce                	mov    %ecx,%esi
  80044e:	03 b4 81 1c f0 ff ff 	add    -0xfe4(%ecx,%eax,4),%esi
  800455:	3e ff e6             	notrack jmp *%esi

00800458 <.L68>:
  800458:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
  80045b:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80045f:	eb d1                	jmp    800432 <vprintfmt+0x55>

00800461 <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
  800461:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800464:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800468:	eb c8                	jmp    800432 <vprintfmt+0x55>

0080046a <.L31>:
  80046a:	0f b6 d2             	movzbl %dl,%edx
  80046d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
  800470:	b8 00 00 00 00       	mov    $0x0,%eax
  800475:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
  800478:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80047b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80047f:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800482:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800485:	83 f9 09             	cmp    $0x9,%ecx
  800488:	77 58                	ja     8004e2 <.L36+0xf>
			for (precision = 0; ; ++fmt) {
  80048a:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  80048d:	eb e9                	jmp    800478 <.L31+0xe>

0080048f <.L34>:
			precision = va_arg(ap, int);
  80048f:	8b 45 14             	mov    0x14(%ebp),%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800497:	8b 45 14             	mov    0x14(%ebp),%eax
  80049a:	8d 40 04             	lea    0x4(%eax),%eax
  80049d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
  8004a3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004a7:	79 89                	jns    800432 <vprintfmt+0x55>
				width = precision, precision = -1;
  8004a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004af:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004b6:	e9 77 ff ff ff       	jmp    800432 <vprintfmt+0x55>

008004bb <.L33>:
  8004bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004be:	85 c0                	test   %eax,%eax
  8004c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c5:	0f 49 d0             	cmovns %eax,%edx
  8004c8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004cb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004ce:	e9 5f ff ff ff       	jmp    800432 <vprintfmt+0x55>

008004d3 <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
  8004d3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
  8004d6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004dd:	e9 50 ff ff ff       	jmp    800432 <vprintfmt+0x55>
  8004e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e5:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e8:	eb b9                	jmp    8004a3 <.L34+0x14>

008004ea <.L27>:
			lflag++;
  8004ea:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ee:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004f1:	e9 3c ff ff ff       	jmp    800432 <vprintfmt+0x55>

008004f6 <.L30>:
  8004f6:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(va_arg(ap, int), putdat);
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	8d 58 04             	lea    0x4(%eax),%ebx
  8004ff:	83 ec 08             	sub    $0x8,%esp
  800502:	57                   	push   %edi
  800503:	ff 30                	pushl  (%eax)
  800505:	ff d6                	call   *%esi
			break;
  800507:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80050a:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
  80050d:	e9 c6 02 00 00       	jmp    8007d8 <.L25+0x45>

00800512 <.L28>:
  800512:	8b 75 08             	mov    0x8(%ebp),%esi
			err = va_arg(ap, int);
  800515:	8b 45 14             	mov    0x14(%ebp),%eax
  800518:	8d 58 04             	lea    0x4(%eax),%ebx
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	99                   	cltd   
  80051e:	31 d0                	xor    %edx,%eax
  800520:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800522:	83 f8 06             	cmp    $0x6,%eax
  800525:	7f 27                	jg     80054e <.L28+0x3c>
  800527:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80052a:	8b 14 82             	mov    (%edx,%eax,4),%edx
  80052d:	85 d2                	test   %edx,%edx
  80052f:	74 1d                	je     80054e <.L28+0x3c>
				printfmt(putch, putdat, "%s", p);
  800531:	52                   	push   %edx
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	8d 80 ae ef ff ff    	lea    -0x1052(%eax),%eax
  80053b:	50                   	push   %eax
  80053c:	57                   	push   %edi
  80053d:	56                   	push   %esi
  80053e:	e8 79 fe ff ff       	call   8003bc <printfmt>
  800543:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800546:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800549:	e9 8a 02 00 00       	jmp    8007d8 <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
  80054e:	50                   	push   %eax
  80054f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800552:	8d 80 a5 ef ff ff    	lea    -0x105b(%eax),%eax
  800558:	50                   	push   %eax
  800559:	57                   	push   %edi
  80055a:	56                   	push   %esi
  80055b:	e8 5c fe ff ff       	call   8003bc <printfmt>
  800560:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800563:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800566:	e9 6d 02 00 00       	jmp    8007d8 <.L25+0x45>

0080056b <.L24>:
  80056b:	8b 75 08             	mov    0x8(%ebp),%esi
			if ((p = va_arg(ap, char *)) == NULL)
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	83 c0 04             	add    $0x4,%eax
  800574:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800577:	8b 45 14             	mov    0x14(%ebp),%eax
  80057a:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80057c:	85 d2                	test   %edx,%edx
  80057e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800581:	8d 80 9e ef ff ff    	lea    -0x1062(%eax),%eax
  800587:	0f 45 c2             	cmovne %edx,%eax
  80058a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80058d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800591:	7e 06                	jle    800599 <.L24+0x2e>
  800593:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800597:	75 0d                	jne    8005a6 <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800599:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80059c:	89 c3                	mov    %eax,%ebx
  80059e:	03 45 d4             	add    -0x2c(%ebp),%eax
  8005a1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8005a4:	eb 58                	jmp    8005fe <.L24+0x93>
  8005a6:	83 ec 08             	sub    $0x8,%esp
  8005a9:	ff 75 d8             	pushl  -0x28(%ebp)
  8005ac:	ff 75 c8             	pushl  -0x38(%ebp)
  8005af:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005b2:	e8 7c 03 00 00       	call   800933 <strnlen>
  8005b7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005ba:	29 c2                	sub    %eax,%edx
  8005bc:	89 55 bc             	mov    %edx,-0x44(%ebp)
  8005bf:	83 c4 10             	add    $0x10,%esp
  8005c2:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
  8005c4:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005cb:	85 db                	test   %ebx,%ebx
  8005cd:	7e 11                	jle    8005e0 <.L24+0x75>
					putch(padc, putdat);
  8005cf:	83 ec 08             	sub    $0x8,%esp
  8005d2:	57                   	push   %edi
  8005d3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8005d6:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d8:	83 eb 01             	sub    $0x1,%ebx
  8005db:	83 c4 10             	add    $0x10,%esp
  8005de:	eb eb                	jmp    8005cb <.L24+0x60>
  8005e0:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8005e3:	85 d2                	test   %edx,%edx
  8005e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ea:	0f 49 c2             	cmovns %edx,%eax
  8005ed:	29 c2                	sub    %eax,%edx
  8005ef:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005f2:	eb a5                	jmp    800599 <.L24+0x2e>
					putch(ch, putdat);
  8005f4:	83 ec 08             	sub    $0x8,%esp
  8005f7:	57                   	push   %edi
  8005f8:	52                   	push   %edx
  8005f9:	ff d6                	call   *%esi
  8005fb:	83 c4 10             	add    $0x10,%esp
  8005fe:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800601:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800603:	83 c3 01             	add    $0x1,%ebx
  800606:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  80060a:	0f be d0             	movsbl %al,%edx
  80060d:	85 d2                	test   %edx,%edx
  80060f:	74 4b                	je     80065c <.L24+0xf1>
  800611:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800615:	78 06                	js     80061d <.L24+0xb2>
  800617:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80061b:	78 1e                	js     80063b <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
  80061d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800621:	74 d1                	je     8005f4 <.L24+0x89>
  800623:	0f be c0             	movsbl %al,%eax
  800626:	83 e8 20             	sub    $0x20,%eax
  800629:	83 f8 5e             	cmp    $0x5e,%eax
  80062c:	76 c6                	jbe    8005f4 <.L24+0x89>
					putch('?', putdat);
  80062e:	83 ec 08             	sub    $0x8,%esp
  800631:	57                   	push   %edi
  800632:	6a 3f                	push   $0x3f
  800634:	ff d6                	call   *%esi
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	eb c3                	jmp    8005fe <.L24+0x93>
  80063b:	89 cb                	mov    %ecx,%ebx
  80063d:	eb 0e                	jmp    80064d <.L24+0xe2>
				putch(' ', putdat);
  80063f:	83 ec 08             	sub    $0x8,%esp
  800642:	57                   	push   %edi
  800643:	6a 20                	push   $0x20
  800645:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800647:	83 eb 01             	sub    $0x1,%ebx
  80064a:	83 c4 10             	add    $0x10,%esp
  80064d:	85 db                	test   %ebx,%ebx
  80064f:	7f ee                	jg     80063f <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
  800651:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800654:	89 45 14             	mov    %eax,0x14(%ebp)
  800657:	e9 7c 01 00 00       	jmp    8007d8 <.L25+0x45>
  80065c:	89 cb                	mov    %ecx,%ebx
  80065e:	eb ed                	jmp    80064d <.L24+0xe2>

00800660 <.L29>:
  800660:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800663:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  800666:	83 f9 01             	cmp    $0x1,%ecx
  800669:	7f 1b                	jg     800686 <.L29+0x26>
	else if (lflag)
  80066b:	85 c9                	test   %ecx,%ecx
  80066d:	74 63                	je     8006d2 <.L29+0x72>
		return va_arg(*ap, long);
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800677:	99                   	cltd   
  800678:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8d 40 04             	lea    0x4(%eax),%eax
  800681:	89 45 14             	mov    %eax,0x14(%ebp)
  800684:	eb 17                	jmp    80069d <.L29+0x3d>
		return va_arg(*ap, long long);
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8b 50 04             	mov    0x4(%eax),%edx
  80068c:	8b 00                	mov    (%eax),%eax
  80068e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800691:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8d 40 08             	lea    0x8(%eax),%eax
  80069a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80069d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006a0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006a3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006a8:	85 c9                	test   %ecx,%ecx
  8006aa:	0f 89 0e 01 00 00    	jns    8007be <.L25+0x2b>
				putch('-', putdat);
  8006b0:	83 ec 08             	sub    $0x8,%esp
  8006b3:	57                   	push   %edi
  8006b4:	6a 2d                	push   $0x2d
  8006b6:	ff d6                	call   *%esi
				num = -(long long) num;
  8006b8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006bb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006be:	f7 da                	neg    %edx
  8006c0:	83 d1 00             	adc    $0x0,%ecx
  8006c3:	f7 d9                	neg    %ecx
  8006c5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006c8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006cd:	e9 ec 00 00 00       	jmp    8007be <.L25+0x2b>
		return va_arg(*ap, int);
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006da:	99                   	cltd   
  8006db:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8d 40 04             	lea    0x4(%eax),%eax
  8006e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e7:	eb b4                	jmp    80069d <.L29+0x3d>

008006e9 <.L23>:
  8006e9:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006ec:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  8006ef:	83 f9 01             	cmp    $0x1,%ecx
  8006f2:	7f 1e                	jg     800712 <.L23+0x29>
	else if (lflag)
  8006f4:	85 c9                	test   %ecx,%ecx
  8006f6:	74 32                	je     80072a <.L23+0x41>
		return va_arg(*ap, unsigned long);
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	8b 10                	mov    (%eax),%edx
  8006fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800702:	8d 40 04             	lea    0x4(%eax),%eax
  800705:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800708:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80070d:	e9 ac 00 00 00       	jmp    8007be <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	8b 10                	mov    (%eax),%edx
  800717:	8b 48 04             	mov    0x4(%eax),%ecx
  80071a:	8d 40 08             	lea    0x8(%eax),%eax
  80071d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800720:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800725:	e9 94 00 00 00       	jmp    8007be <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80072a:	8b 45 14             	mov    0x14(%ebp),%eax
  80072d:	8b 10                	mov    (%eax),%edx
  80072f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800734:	8d 40 04             	lea    0x4(%eax),%eax
  800737:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80073a:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80073f:	eb 7d                	jmp    8007be <.L25+0x2b>

00800741 <.L26>:
  800741:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800744:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  800747:	83 f9 01             	cmp    $0x1,%ecx
  80074a:	7f 1b                	jg     800767 <.L26+0x26>
	else if (lflag)
  80074c:	85 c9                	test   %ecx,%ecx
  80074e:	74 2c                	je     80077c <.L26+0x3b>
		return va_arg(*ap, unsigned long);
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	8b 10                	mov    (%eax),%edx
  800755:	b9 00 00 00 00       	mov    $0x0,%ecx
  80075a:	8d 40 04             	lea    0x4(%eax),%eax
  80075d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800760:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800765:	eb 57                	jmp    8007be <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8b 10                	mov    (%eax),%edx
  80076c:	8b 48 04             	mov    0x4(%eax),%ecx
  80076f:	8d 40 08             	lea    0x8(%eax),%eax
  800772:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800775:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80077a:	eb 42                	jmp    8007be <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	8b 10                	mov    (%eax),%edx
  800781:	b9 00 00 00 00       	mov    $0x0,%ecx
  800786:	8d 40 04             	lea    0x4(%eax),%eax
  800789:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80078c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800791:	eb 2b                	jmp    8007be <.L25+0x2b>

00800793 <.L25>:
  800793:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('0', putdat);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	57                   	push   %edi
  80079a:	6a 30                	push   $0x30
  80079c:	ff d6                	call   *%esi
			putch('x', putdat);
  80079e:	83 c4 08             	add    $0x8,%esp
  8007a1:	57                   	push   %edi
  8007a2:	6a 78                	push   $0x78
  8007a4:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a9:	8b 10                	mov    (%eax),%edx
  8007ab:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007b0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007b3:	8d 40 04             	lea    0x4(%eax),%eax
  8007b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007be:	83 ec 0c             	sub    $0xc,%esp
  8007c1:	0f be 5d cf          	movsbl -0x31(%ebp),%ebx
  8007c5:	53                   	push   %ebx
  8007c6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8007c9:	50                   	push   %eax
  8007ca:	51                   	push   %ecx
  8007cb:	52                   	push   %edx
  8007cc:	89 fa                	mov    %edi,%edx
  8007ce:	89 f0                	mov    %esi,%eax
  8007d0:	e8 08 fb ff ff       	call   8002dd <printnum>
			break;
  8007d5:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007d8:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007db:	83 c3 01             	add    $0x1,%ebx
  8007de:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8007e2:	83 f8 25             	cmp    $0x25,%eax
  8007e5:	0f 84 23 fc ff ff    	je     80040e <vprintfmt+0x31>
			if (ch == '\0')
  8007eb:	85 c0                	test   %eax,%eax
  8007ed:	0f 84 97 00 00 00    	je     80088a <.L20+0x23>
			putch(ch, putdat);
  8007f3:	83 ec 08             	sub    $0x8,%esp
  8007f6:	57                   	push   %edi
  8007f7:	50                   	push   %eax
  8007f8:	ff d6                	call   *%esi
  8007fa:	83 c4 10             	add    $0x10,%esp
  8007fd:	eb dc                	jmp    8007db <.L25+0x48>

008007ff <.L21>:
  8007ff:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800802:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  800805:	83 f9 01             	cmp    $0x1,%ecx
  800808:	7f 1b                	jg     800825 <.L21+0x26>
	else if (lflag)
  80080a:	85 c9                	test   %ecx,%ecx
  80080c:	74 2c                	je     80083a <.L21+0x3b>
		return va_arg(*ap, unsigned long);
  80080e:	8b 45 14             	mov    0x14(%ebp),%eax
  800811:	8b 10                	mov    (%eax),%edx
  800813:	b9 00 00 00 00       	mov    $0x0,%ecx
  800818:	8d 40 04             	lea    0x4(%eax),%eax
  80081b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081e:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800823:	eb 99                	jmp    8007be <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	8b 10                	mov    (%eax),%edx
  80082a:	8b 48 04             	mov    0x4(%eax),%ecx
  80082d:	8d 40 08             	lea    0x8(%eax),%eax
  800830:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800833:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800838:	eb 84                	jmp    8007be <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80083a:	8b 45 14             	mov    0x14(%ebp),%eax
  80083d:	8b 10                	mov    (%eax),%edx
  80083f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800844:	8d 40 04             	lea    0x4(%eax),%eax
  800847:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80084a:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80084f:	e9 6a ff ff ff       	jmp    8007be <.L25+0x2b>

00800854 <.L35>:
  800854:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(ch, putdat);
  800857:	83 ec 08             	sub    $0x8,%esp
  80085a:	57                   	push   %edi
  80085b:	6a 25                	push   $0x25
  80085d:	ff d6                	call   *%esi
			break;
  80085f:	83 c4 10             	add    $0x10,%esp
  800862:	e9 71 ff ff ff       	jmp    8007d8 <.L25+0x45>

00800867 <.L20>:
  800867:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('%', putdat);
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	57                   	push   %edi
  80086e:	6a 25                	push   $0x25
  800870:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800872:	83 c4 10             	add    $0x10,%esp
  800875:	89 d8                	mov    %ebx,%eax
  800877:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80087b:	74 05                	je     800882 <.L20+0x1b>
  80087d:	83 e8 01             	sub    $0x1,%eax
  800880:	eb f5                	jmp    800877 <.L20+0x10>
  800882:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800885:	e9 4e ff ff ff       	jmp    8007d8 <.L25+0x45>
}
  80088a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80088d:	5b                   	pop    %ebx
  80088e:	5e                   	pop    %esi
  80088f:	5f                   	pop    %edi
  800890:	5d                   	pop    %ebp
  800891:	c3                   	ret    

00800892 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800892:	f3 0f 1e fb          	endbr32 
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	53                   	push   %ebx
  80089a:	83 ec 14             	sub    $0x14,%esp
  80089d:	e8 bb f7 ff ff       	call   80005d <__x86.get_pc_thunk.bx>
  8008a2:	81 c3 5e 17 00 00    	add    $0x175e,%ebx
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008b1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008b5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008bf:	85 c0                	test   %eax,%eax
  8008c1:	74 2b                	je     8008ee <vsnprintf+0x5c>
  8008c3:	85 d2                	test   %edx,%edx
  8008c5:	7e 27                	jle    8008ee <vsnprintf+0x5c>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008c7:	ff 75 14             	pushl  0x14(%ebp)
  8008ca:	ff 75 10             	pushl  0x10(%ebp)
  8008cd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008d0:	50                   	push   %eax
  8008d1:	8d 83 9b e3 ff ff    	lea    -0x1c65(%ebx),%eax
  8008d7:	50                   	push   %eax
  8008d8:	e8 00 fb ff ff       	call   8003dd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e6:	83 c4 10             	add    $0x10,%esp
}
  8008e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ec:	c9                   	leave  
  8008ed:	c3                   	ret    
		return -E_INVAL;
  8008ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008f3:	eb f4                	jmp    8008e9 <vsnprintf+0x57>

008008f5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008f5:	f3 0f 1e fb          	endbr32 
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ff:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800902:	50                   	push   %eax
  800903:	ff 75 10             	pushl  0x10(%ebp)
  800906:	ff 75 0c             	pushl  0xc(%ebp)
  800909:	ff 75 08             	pushl  0x8(%ebp)
  80090c:	e8 81 ff ff ff       	call   800892 <vsnprintf>
	va_end(ap);

	return rc;
}
  800911:	c9                   	leave  
  800912:	c3                   	ret    

00800913 <__x86.get_pc_thunk.cx>:
  800913:	8b 0c 24             	mov    (%esp),%ecx
  800916:	c3                   	ret    

00800917 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800917:	f3 0f 1e fb          	endbr32 
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800921:	b8 00 00 00 00       	mov    $0x0,%eax
  800926:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80092a:	74 05                	je     800931 <strlen+0x1a>
		n++;
  80092c:	83 c0 01             	add    $0x1,%eax
  80092f:	eb f5                	jmp    800926 <strlen+0xf>
	return n;
}
  800931:	5d                   	pop    %ebp
  800932:	c3                   	ret    

00800933 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800933:	f3 0f 1e fb          	endbr32 
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80093d:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800940:	b8 00 00 00 00       	mov    $0x0,%eax
  800945:	39 d0                	cmp    %edx,%eax
  800947:	74 0d                	je     800956 <strnlen+0x23>
  800949:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80094d:	74 05                	je     800954 <strnlen+0x21>
		n++;
  80094f:	83 c0 01             	add    $0x1,%eax
  800952:	eb f1                	jmp    800945 <strnlen+0x12>
  800954:	89 c2                	mov    %eax,%edx
	return n;
}
  800956:	89 d0                	mov    %edx,%eax
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80095a:	f3 0f 1e fb          	endbr32 
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	53                   	push   %ebx
  800962:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800965:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800968:	b8 00 00 00 00       	mov    $0x0,%eax
  80096d:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800971:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800974:	83 c0 01             	add    $0x1,%eax
  800977:	84 d2                	test   %dl,%dl
  800979:	75 f2                	jne    80096d <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80097b:	89 c8                	mov    %ecx,%eax
  80097d:	5b                   	pop    %ebx
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800980:	f3 0f 1e fb          	endbr32 
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	53                   	push   %ebx
  800988:	83 ec 10             	sub    $0x10,%esp
  80098b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80098e:	53                   	push   %ebx
  80098f:	e8 83 ff ff ff       	call   800917 <strlen>
  800994:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	01 d8                	add    %ebx,%eax
  80099c:	50                   	push   %eax
  80099d:	e8 b8 ff ff ff       	call   80095a <strcpy>
	return dst;
}
  8009a2:	89 d8                	mov    %ebx,%eax
  8009a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009a7:	c9                   	leave  
  8009a8:	c3                   	ret    

008009a9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009a9:	f3 0f 1e fb          	endbr32 
  8009ad:	55                   	push   %ebp
  8009ae:	89 e5                	mov    %esp,%ebp
  8009b0:	56                   	push   %esi
  8009b1:	53                   	push   %ebx
  8009b2:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b8:	89 f3                	mov    %esi,%ebx
  8009ba:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009bd:	89 f0                	mov    %esi,%eax
  8009bf:	39 d8                	cmp    %ebx,%eax
  8009c1:	74 11                	je     8009d4 <strncpy+0x2b>
		*dst++ = *src;
  8009c3:	83 c0 01             	add    $0x1,%eax
  8009c6:	0f b6 0a             	movzbl (%edx),%ecx
  8009c9:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009cc:	80 f9 01             	cmp    $0x1,%cl
  8009cf:	83 da ff             	sbb    $0xffffffff,%edx
  8009d2:	eb eb                	jmp    8009bf <strncpy+0x16>
	}
	return ret;
}
  8009d4:	89 f0                	mov    %esi,%eax
  8009d6:	5b                   	pop    %ebx
  8009d7:	5e                   	pop    %esi
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    

008009da <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009da:	f3 0f 1e fb          	endbr32 
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
  8009e1:	56                   	push   %esi
  8009e2:	53                   	push   %ebx
  8009e3:	8b 75 08             	mov    0x8(%ebp),%esi
  8009e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e9:	8b 55 10             	mov    0x10(%ebp),%edx
  8009ec:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009ee:	85 d2                	test   %edx,%edx
  8009f0:	74 21                	je     800a13 <strlcpy+0x39>
  8009f2:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009f6:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009f8:	39 c2                	cmp    %eax,%edx
  8009fa:	74 14                	je     800a10 <strlcpy+0x36>
  8009fc:	0f b6 19             	movzbl (%ecx),%ebx
  8009ff:	84 db                	test   %bl,%bl
  800a01:	74 0b                	je     800a0e <strlcpy+0x34>
			*dst++ = *src++;
  800a03:	83 c1 01             	add    $0x1,%ecx
  800a06:	83 c2 01             	add    $0x1,%edx
  800a09:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a0c:	eb ea                	jmp    8009f8 <strlcpy+0x1e>
  800a0e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a10:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a13:	29 f0                	sub    %esi,%eax
}
  800a15:	5b                   	pop    %ebx
  800a16:	5e                   	pop    %esi
  800a17:	5d                   	pop    %ebp
  800a18:	c3                   	ret    

00800a19 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a19:	f3 0f 1e fb          	endbr32 
  800a1d:	55                   	push   %ebp
  800a1e:	89 e5                	mov    %esp,%ebp
  800a20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a23:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a26:	0f b6 01             	movzbl (%ecx),%eax
  800a29:	84 c0                	test   %al,%al
  800a2b:	74 0c                	je     800a39 <strcmp+0x20>
  800a2d:	3a 02                	cmp    (%edx),%al
  800a2f:	75 08                	jne    800a39 <strcmp+0x20>
		p++, q++;
  800a31:	83 c1 01             	add    $0x1,%ecx
  800a34:	83 c2 01             	add    $0x1,%edx
  800a37:	eb ed                	jmp    800a26 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a39:	0f b6 c0             	movzbl %al,%eax
  800a3c:	0f b6 12             	movzbl (%edx),%edx
  800a3f:	29 d0                	sub    %edx,%eax
}
  800a41:	5d                   	pop    %ebp
  800a42:	c3                   	ret    

00800a43 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a43:	f3 0f 1e fb          	endbr32 
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	53                   	push   %ebx
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a51:	89 c3                	mov    %eax,%ebx
  800a53:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a56:	eb 06                	jmp    800a5e <strncmp+0x1b>
		n--, p++, q++;
  800a58:	83 c0 01             	add    $0x1,%eax
  800a5b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a5e:	39 d8                	cmp    %ebx,%eax
  800a60:	74 16                	je     800a78 <strncmp+0x35>
  800a62:	0f b6 08             	movzbl (%eax),%ecx
  800a65:	84 c9                	test   %cl,%cl
  800a67:	74 04                	je     800a6d <strncmp+0x2a>
  800a69:	3a 0a                	cmp    (%edx),%cl
  800a6b:	74 eb                	je     800a58 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a6d:	0f b6 00             	movzbl (%eax),%eax
  800a70:	0f b6 12             	movzbl (%edx),%edx
  800a73:	29 d0                	sub    %edx,%eax
}
  800a75:	5b                   	pop    %ebx
  800a76:	5d                   	pop    %ebp
  800a77:	c3                   	ret    
		return 0;
  800a78:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7d:	eb f6                	jmp    800a75 <strncmp+0x32>

00800a7f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a7f:	f3 0f 1e fb          	endbr32 
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a8d:	0f b6 10             	movzbl (%eax),%edx
  800a90:	84 d2                	test   %dl,%dl
  800a92:	74 09                	je     800a9d <strchr+0x1e>
		if (*s == c)
  800a94:	38 ca                	cmp    %cl,%dl
  800a96:	74 0a                	je     800aa2 <strchr+0x23>
	for (; *s; s++)
  800a98:	83 c0 01             	add    $0x1,%eax
  800a9b:	eb f0                	jmp    800a8d <strchr+0xe>
			return (char *) s;
	return 0;
  800a9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aa2:	5d                   	pop    %ebp
  800aa3:	c3                   	ret    

00800aa4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aa4:	f3 0f 1e fb          	endbr32 
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ab5:	38 ca                	cmp    %cl,%dl
  800ab7:	74 09                	je     800ac2 <strfind+0x1e>
  800ab9:	84 d2                	test   %dl,%dl
  800abb:	74 05                	je     800ac2 <strfind+0x1e>
	for (; *s; s++)
  800abd:	83 c0 01             	add    $0x1,%eax
  800ac0:	eb f0                	jmp    800ab2 <strfind+0xe>
			break;
	return (char *) s;
}
  800ac2:	5d                   	pop    %ebp
  800ac3:	c3                   	ret    

00800ac4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ac4:	f3 0f 1e fb          	endbr32 
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	57                   	push   %edi
  800acc:	56                   	push   %esi
  800acd:	53                   	push   %ebx
  800ace:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ad1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ad4:	85 c9                	test   %ecx,%ecx
  800ad6:	74 31                	je     800b09 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ad8:	89 f8                	mov    %edi,%eax
  800ada:	09 c8                	or     %ecx,%eax
  800adc:	a8 03                	test   $0x3,%al
  800ade:	75 23                	jne    800b03 <memset+0x3f>
		c &= 0xFF;
  800ae0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ae4:	89 d3                	mov    %edx,%ebx
  800ae6:	c1 e3 08             	shl    $0x8,%ebx
  800ae9:	89 d0                	mov    %edx,%eax
  800aeb:	c1 e0 18             	shl    $0x18,%eax
  800aee:	89 d6                	mov    %edx,%esi
  800af0:	c1 e6 10             	shl    $0x10,%esi
  800af3:	09 f0                	or     %esi,%eax
  800af5:	09 c2                	or     %eax,%edx
  800af7:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800af9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800afc:	89 d0                	mov    %edx,%eax
  800afe:	fc                   	cld    
  800aff:	f3 ab                	rep stos %eax,%es:(%edi)
  800b01:	eb 06                	jmp    800b09 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b06:	fc                   	cld    
  800b07:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b09:	89 f8                	mov    %edi,%eax
  800b0b:	5b                   	pop    %ebx
  800b0c:	5e                   	pop    %esi
  800b0d:	5f                   	pop    %edi
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b10:	f3 0f 1e fb          	endbr32 
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	57                   	push   %edi
  800b18:	56                   	push   %esi
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b22:	39 c6                	cmp    %eax,%esi
  800b24:	73 32                	jae    800b58 <memmove+0x48>
  800b26:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b29:	39 c2                	cmp    %eax,%edx
  800b2b:	76 2b                	jbe    800b58 <memmove+0x48>
		s += n;
		d += n;
  800b2d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b30:	89 fe                	mov    %edi,%esi
  800b32:	09 ce                	or     %ecx,%esi
  800b34:	09 d6                	or     %edx,%esi
  800b36:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b3c:	75 0e                	jne    800b4c <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b3e:	83 ef 04             	sub    $0x4,%edi
  800b41:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b44:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b47:	fd                   	std    
  800b48:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b4a:	eb 09                	jmp    800b55 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b4c:	83 ef 01             	sub    $0x1,%edi
  800b4f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b52:	fd                   	std    
  800b53:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b55:	fc                   	cld    
  800b56:	eb 1a                	jmp    800b72 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b58:	89 c2                	mov    %eax,%edx
  800b5a:	09 ca                	or     %ecx,%edx
  800b5c:	09 f2                	or     %esi,%edx
  800b5e:	f6 c2 03             	test   $0x3,%dl
  800b61:	75 0a                	jne    800b6d <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b63:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b66:	89 c7                	mov    %eax,%edi
  800b68:	fc                   	cld    
  800b69:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b6b:	eb 05                	jmp    800b72 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b6d:	89 c7                	mov    %eax,%edi
  800b6f:	fc                   	cld    
  800b70:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b72:	5e                   	pop    %esi
  800b73:	5f                   	pop    %edi
  800b74:	5d                   	pop    %ebp
  800b75:	c3                   	ret    

00800b76 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b76:	f3 0f 1e fb          	endbr32 
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b80:	ff 75 10             	pushl  0x10(%ebp)
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	ff 75 08             	pushl  0x8(%ebp)
  800b89:	e8 82 ff ff ff       	call   800b10 <memmove>
}
  800b8e:	c9                   	leave  
  800b8f:	c3                   	ret    

00800b90 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b90:	f3 0f 1e fb          	endbr32 
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	56                   	push   %esi
  800b98:	53                   	push   %ebx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9f:	89 c6                	mov    %eax,%esi
  800ba1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ba4:	39 f0                	cmp    %esi,%eax
  800ba6:	74 1c                	je     800bc4 <memcmp+0x34>
		if (*s1 != *s2)
  800ba8:	0f b6 08             	movzbl (%eax),%ecx
  800bab:	0f b6 1a             	movzbl (%edx),%ebx
  800bae:	38 d9                	cmp    %bl,%cl
  800bb0:	75 08                	jne    800bba <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bb2:	83 c0 01             	add    $0x1,%eax
  800bb5:	83 c2 01             	add    $0x1,%edx
  800bb8:	eb ea                	jmp    800ba4 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800bba:	0f b6 c1             	movzbl %cl,%eax
  800bbd:	0f b6 db             	movzbl %bl,%ebx
  800bc0:	29 d8                	sub    %ebx,%eax
  800bc2:	eb 05                	jmp    800bc9 <memcmp+0x39>
	}

	return 0;
  800bc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc9:	5b                   	pop    %ebx
  800bca:	5e                   	pop    %esi
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bcd:	f3 0f 1e fb          	endbr32 
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bda:	89 c2                	mov    %eax,%edx
  800bdc:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bdf:	39 d0                	cmp    %edx,%eax
  800be1:	73 09                	jae    800bec <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800be3:	38 08                	cmp    %cl,(%eax)
  800be5:	74 05                	je     800bec <memfind+0x1f>
	for (; s < ends; s++)
  800be7:	83 c0 01             	add    $0x1,%eax
  800bea:	eb f3                	jmp    800bdf <memfind+0x12>
			break;
	return (void *) s;
}
  800bec:	5d                   	pop    %ebp
  800bed:	c3                   	ret    

00800bee <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bee:	f3 0f 1e fb          	endbr32 
  800bf2:	55                   	push   %ebp
  800bf3:	89 e5                	mov    %esp,%ebp
  800bf5:	57                   	push   %edi
  800bf6:	56                   	push   %esi
  800bf7:	53                   	push   %ebx
  800bf8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bfe:	eb 03                	jmp    800c03 <strtol+0x15>
		s++;
  800c00:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c03:	0f b6 01             	movzbl (%ecx),%eax
  800c06:	3c 20                	cmp    $0x20,%al
  800c08:	74 f6                	je     800c00 <strtol+0x12>
  800c0a:	3c 09                	cmp    $0x9,%al
  800c0c:	74 f2                	je     800c00 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800c0e:	3c 2b                	cmp    $0x2b,%al
  800c10:	74 2a                	je     800c3c <strtol+0x4e>
	int neg = 0;
  800c12:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c17:	3c 2d                	cmp    $0x2d,%al
  800c19:	74 2b                	je     800c46 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c1b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c21:	75 0f                	jne    800c32 <strtol+0x44>
  800c23:	80 39 30             	cmpb   $0x30,(%ecx)
  800c26:	74 28                	je     800c50 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c28:	85 db                	test   %ebx,%ebx
  800c2a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c2f:	0f 44 d8             	cmove  %eax,%ebx
  800c32:	b8 00 00 00 00       	mov    $0x0,%eax
  800c37:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c3a:	eb 46                	jmp    800c82 <strtol+0x94>
		s++;
  800c3c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c3f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c44:	eb d5                	jmp    800c1b <strtol+0x2d>
		s++, neg = 1;
  800c46:	83 c1 01             	add    $0x1,%ecx
  800c49:	bf 01 00 00 00       	mov    $0x1,%edi
  800c4e:	eb cb                	jmp    800c1b <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c50:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c54:	74 0e                	je     800c64 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c56:	85 db                	test   %ebx,%ebx
  800c58:	75 d8                	jne    800c32 <strtol+0x44>
		s++, base = 8;
  800c5a:	83 c1 01             	add    $0x1,%ecx
  800c5d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c62:	eb ce                	jmp    800c32 <strtol+0x44>
		s += 2, base = 16;
  800c64:	83 c1 02             	add    $0x2,%ecx
  800c67:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c6c:	eb c4                	jmp    800c32 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c6e:	0f be d2             	movsbl %dl,%edx
  800c71:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c74:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c77:	7d 3a                	jge    800cb3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c79:	83 c1 01             	add    $0x1,%ecx
  800c7c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c80:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c82:	0f b6 11             	movzbl (%ecx),%edx
  800c85:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c88:	89 f3                	mov    %esi,%ebx
  800c8a:	80 fb 09             	cmp    $0x9,%bl
  800c8d:	76 df                	jbe    800c6e <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c8f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c92:	89 f3                	mov    %esi,%ebx
  800c94:	80 fb 19             	cmp    $0x19,%bl
  800c97:	77 08                	ja     800ca1 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c99:	0f be d2             	movsbl %dl,%edx
  800c9c:	83 ea 57             	sub    $0x57,%edx
  800c9f:	eb d3                	jmp    800c74 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800ca1:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ca4:	89 f3                	mov    %esi,%ebx
  800ca6:	80 fb 19             	cmp    $0x19,%bl
  800ca9:	77 08                	ja     800cb3 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800cab:	0f be d2             	movsbl %dl,%edx
  800cae:	83 ea 37             	sub    $0x37,%edx
  800cb1:	eb c1                	jmp    800c74 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cb3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb7:	74 05                	je     800cbe <strtol+0xd0>
		*endptr = (char *) s;
  800cb9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cbc:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cbe:	89 c2                	mov    %eax,%edx
  800cc0:	f7 da                	neg    %edx
  800cc2:	85 ff                	test   %edi,%edi
  800cc4:	0f 45 c2             	cmovne %edx,%eax
}
  800cc7:	5b                   	pop    %ebx
  800cc8:	5e                   	pop    %esi
  800cc9:	5f                   	pop    %edi
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    
  800ccc:	66 90                	xchg   %ax,%ax
  800cce:	66 90                	xchg   %ax,%ax

00800cd0 <__udivdi3>:
  800cd0:	f3 0f 1e fb          	endbr32 
  800cd4:	55                   	push   %ebp
  800cd5:	57                   	push   %edi
  800cd6:	56                   	push   %esi
  800cd7:	53                   	push   %ebx
  800cd8:	83 ec 1c             	sub    $0x1c,%esp
  800cdb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800cdf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800ce3:	8b 74 24 34          	mov    0x34(%esp),%esi
  800ce7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800ceb:	85 d2                	test   %edx,%edx
  800ced:	75 19                	jne    800d08 <__udivdi3+0x38>
  800cef:	39 f3                	cmp    %esi,%ebx
  800cf1:	76 4d                	jbe    800d40 <__udivdi3+0x70>
  800cf3:	31 ff                	xor    %edi,%edi
  800cf5:	89 e8                	mov    %ebp,%eax
  800cf7:	89 f2                	mov    %esi,%edx
  800cf9:	f7 f3                	div    %ebx
  800cfb:	89 fa                	mov    %edi,%edx
  800cfd:	83 c4 1c             	add    $0x1c,%esp
  800d00:	5b                   	pop    %ebx
  800d01:	5e                   	pop    %esi
  800d02:	5f                   	pop    %edi
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    
  800d05:	8d 76 00             	lea    0x0(%esi),%esi
  800d08:	39 f2                	cmp    %esi,%edx
  800d0a:	76 14                	jbe    800d20 <__udivdi3+0x50>
  800d0c:	31 ff                	xor    %edi,%edi
  800d0e:	31 c0                	xor    %eax,%eax
  800d10:	89 fa                	mov    %edi,%edx
  800d12:	83 c4 1c             	add    $0x1c,%esp
  800d15:	5b                   	pop    %ebx
  800d16:	5e                   	pop    %esi
  800d17:	5f                   	pop    %edi
  800d18:	5d                   	pop    %ebp
  800d19:	c3                   	ret    
  800d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800d20:	0f bd fa             	bsr    %edx,%edi
  800d23:	83 f7 1f             	xor    $0x1f,%edi
  800d26:	75 48                	jne    800d70 <__udivdi3+0xa0>
  800d28:	39 f2                	cmp    %esi,%edx
  800d2a:	72 06                	jb     800d32 <__udivdi3+0x62>
  800d2c:	31 c0                	xor    %eax,%eax
  800d2e:	39 eb                	cmp    %ebp,%ebx
  800d30:	77 de                	ja     800d10 <__udivdi3+0x40>
  800d32:	b8 01 00 00 00       	mov    $0x1,%eax
  800d37:	eb d7                	jmp    800d10 <__udivdi3+0x40>
  800d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d40:	89 d9                	mov    %ebx,%ecx
  800d42:	85 db                	test   %ebx,%ebx
  800d44:	75 0b                	jne    800d51 <__udivdi3+0x81>
  800d46:	b8 01 00 00 00       	mov    $0x1,%eax
  800d4b:	31 d2                	xor    %edx,%edx
  800d4d:	f7 f3                	div    %ebx
  800d4f:	89 c1                	mov    %eax,%ecx
  800d51:	31 d2                	xor    %edx,%edx
  800d53:	89 f0                	mov    %esi,%eax
  800d55:	f7 f1                	div    %ecx
  800d57:	89 c6                	mov    %eax,%esi
  800d59:	89 e8                	mov    %ebp,%eax
  800d5b:	89 f7                	mov    %esi,%edi
  800d5d:	f7 f1                	div    %ecx
  800d5f:	89 fa                	mov    %edi,%edx
  800d61:	83 c4 1c             	add    $0x1c,%esp
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    
  800d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d70:	89 f9                	mov    %edi,%ecx
  800d72:	b8 20 00 00 00       	mov    $0x20,%eax
  800d77:	29 f8                	sub    %edi,%eax
  800d79:	d3 e2                	shl    %cl,%edx
  800d7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800d7f:	89 c1                	mov    %eax,%ecx
  800d81:	89 da                	mov    %ebx,%edx
  800d83:	d3 ea                	shr    %cl,%edx
  800d85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800d89:	09 d1                	or     %edx,%ecx
  800d8b:	89 f2                	mov    %esi,%edx
  800d8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800d91:	89 f9                	mov    %edi,%ecx
  800d93:	d3 e3                	shl    %cl,%ebx
  800d95:	89 c1                	mov    %eax,%ecx
  800d97:	d3 ea                	shr    %cl,%edx
  800d99:	89 f9                	mov    %edi,%ecx
  800d9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800d9f:	89 eb                	mov    %ebp,%ebx
  800da1:	d3 e6                	shl    %cl,%esi
  800da3:	89 c1                	mov    %eax,%ecx
  800da5:	d3 eb                	shr    %cl,%ebx
  800da7:	09 de                	or     %ebx,%esi
  800da9:	89 f0                	mov    %esi,%eax
  800dab:	f7 74 24 08          	divl   0x8(%esp)
  800daf:	89 d6                	mov    %edx,%esi
  800db1:	89 c3                	mov    %eax,%ebx
  800db3:	f7 64 24 0c          	mull   0xc(%esp)
  800db7:	39 d6                	cmp    %edx,%esi
  800db9:	72 15                	jb     800dd0 <__udivdi3+0x100>
  800dbb:	89 f9                	mov    %edi,%ecx
  800dbd:	d3 e5                	shl    %cl,%ebp
  800dbf:	39 c5                	cmp    %eax,%ebp
  800dc1:	73 04                	jae    800dc7 <__udivdi3+0xf7>
  800dc3:	39 d6                	cmp    %edx,%esi
  800dc5:	74 09                	je     800dd0 <__udivdi3+0x100>
  800dc7:	89 d8                	mov    %ebx,%eax
  800dc9:	31 ff                	xor    %edi,%edi
  800dcb:	e9 40 ff ff ff       	jmp    800d10 <__udivdi3+0x40>
  800dd0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800dd3:	31 ff                	xor    %edi,%edi
  800dd5:	e9 36 ff ff ff       	jmp    800d10 <__udivdi3+0x40>
  800dda:	66 90                	xchg   %ax,%ax
  800ddc:	66 90                	xchg   %ax,%ax
  800dde:	66 90                	xchg   %ax,%ax

00800de0 <__umoddi3>:
  800de0:	f3 0f 1e fb          	endbr32 
  800de4:	55                   	push   %ebp
  800de5:	57                   	push   %edi
  800de6:	56                   	push   %esi
  800de7:	53                   	push   %ebx
  800de8:	83 ec 1c             	sub    $0x1c,%esp
  800deb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800def:	8b 74 24 30          	mov    0x30(%esp),%esi
  800df3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800df7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800dfb:	85 c0                	test   %eax,%eax
  800dfd:	75 19                	jne    800e18 <__umoddi3+0x38>
  800dff:	39 df                	cmp    %ebx,%edi
  800e01:	76 5d                	jbe    800e60 <__umoddi3+0x80>
  800e03:	89 f0                	mov    %esi,%eax
  800e05:	89 da                	mov    %ebx,%edx
  800e07:	f7 f7                	div    %edi
  800e09:	89 d0                	mov    %edx,%eax
  800e0b:	31 d2                	xor    %edx,%edx
  800e0d:	83 c4 1c             	add    $0x1c,%esp
  800e10:	5b                   	pop    %ebx
  800e11:	5e                   	pop    %esi
  800e12:	5f                   	pop    %edi
  800e13:	5d                   	pop    %ebp
  800e14:	c3                   	ret    
  800e15:	8d 76 00             	lea    0x0(%esi),%esi
  800e18:	89 f2                	mov    %esi,%edx
  800e1a:	39 d8                	cmp    %ebx,%eax
  800e1c:	76 12                	jbe    800e30 <__umoddi3+0x50>
  800e1e:	89 f0                	mov    %esi,%eax
  800e20:	89 da                	mov    %ebx,%edx
  800e22:	83 c4 1c             	add    $0x1c,%esp
  800e25:	5b                   	pop    %ebx
  800e26:	5e                   	pop    %esi
  800e27:	5f                   	pop    %edi
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    
  800e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e30:	0f bd e8             	bsr    %eax,%ebp
  800e33:	83 f5 1f             	xor    $0x1f,%ebp
  800e36:	75 50                	jne    800e88 <__umoddi3+0xa8>
  800e38:	39 d8                	cmp    %ebx,%eax
  800e3a:	0f 82 e0 00 00 00    	jb     800f20 <__umoddi3+0x140>
  800e40:	89 d9                	mov    %ebx,%ecx
  800e42:	39 f7                	cmp    %esi,%edi
  800e44:	0f 86 d6 00 00 00    	jbe    800f20 <__umoddi3+0x140>
  800e4a:	89 d0                	mov    %edx,%eax
  800e4c:	89 ca                	mov    %ecx,%edx
  800e4e:	83 c4 1c             	add    $0x1c,%esp
  800e51:	5b                   	pop    %ebx
  800e52:	5e                   	pop    %esi
  800e53:	5f                   	pop    %edi
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    
  800e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e5d:	8d 76 00             	lea    0x0(%esi),%esi
  800e60:	89 fd                	mov    %edi,%ebp
  800e62:	85 ff                	test   %edi,%edi
  800e64:	75 0b                	jne    800e71 <__umoddi3+0x91>
  800e66:	b8 01 00 00 00       	mov    $0x1,%eax
  800e6b:	31 d2                	xor    %edx,%edx
  800e6d:	f7 f7                	div    %edi
  800e6f:	89 c5                	mov    %eax,%ebp
  800e71:	89 d8                	mov    %ebx,%eax
  800e73:	31 d2                	xor    %edx,%edx
  800e75:	f7 f5                	div    %ebp
  800e77:	89 f0                	mov    %esi,%eax
  800e79:	f7 f5                	div    %ebp
  800e7b:	89 d0                	mov    %edx,%eax
  800e7d:	31 d2                	xor    %edx,%edx
  800e7f:	eb 8c                	jmp    800e0d <__umoddi3+0x2d>
  800e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e88:	89 e9                	mov    %ebp,%ecx
  800e8a:	ba 20 00 00 00       	mov    $0x20,%edx
  800e8f:	29 ea                	sub    %ebp,%edx
  800e91:	d3 e0                	shl    %cl,%eax
  800e93:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e97:	89 d1                	mov    %edx,%ecx
  800e99:	89 f8                	mov    %edi,%eax
  800e9b:	d3 e8                	shr    %cl,%eax
  800e9d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800ea1:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ea5:	8b 54 24 04          	mov    0x4(%esp),%edx
  800ea9:	09 c1                	or     %eax,%ecx
  800eab:	89 d8                	mov    %ebx,%eax
  800ead:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800eb1:	89 e9                	mov    %ebp,%ecx
  800eb3:	d3 e7                	shl    %cl,%edi
  800eb5:	89 d1                	mov    %edx,%ecx
  800eb7:	d3 e8                	shr    %cl,%eax
  800eb9:	89 e9                	mov    %ebp,%ecx
  800ebb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800ebf:	d3 e3                	shl    %cl,%ebx
  800ec1:	89 c7                	mov    %eax,%edi
  800ec3:	89 d1                	mov    %edx,%ecx
  800ec5:	89 f0                	mov    %esi,%eax
  800ec7:	d3 e8                	shr    %cl,%eax
  800ec9:	89 e9                	mov    %ebp,%ecx
  800ecb:	89 fa                	mov    %edi,%edx
  800ecd:	d3 e6                	shl    %cl,%esi
  800ecf:	09 d8                	or     %ebx,%eax
  800ed1:	f7 74 24 08          	divl   0x8(%esp)
  800ed5:	89 d1                	mov    %edx,%ecx
  800ed7:	89 f3                	mov    %esi,%ebx
  800ed9:	f7 64 24 0c          	mull   0xc(%esp)
  800edd:	89 c6                	mov    %eax,%esi
  800edf:	89 d7                	mov    %edx,%edi
  800ee1:	39 d1                	cmp    %edx,%ecx
  800ee3:	72 06                	jb     800eeb <__umoddi3+0x10b>
  800ee5:	75 10                	jne    800ef7 <__umoddi3+0x117>
  800ee7:	39 c3                	cmp    %eax,%ebx
  800ee9:	73 0c                	jae    800ef7 <__umoddi3+0x117>
  800eeb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  800eef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  800ef3:	89 d7                	mov    %edx,%edi
  800ef5:	89 c6                	mov    %eax,%esi
  800ef7:	89 ca                	mov    %ecx,%edx
  800ef9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800efe:	29 f3                	sub    %esi,%ebx
  800f00:	19 fa                	sbb    %edi,%edx
  800f02:	89 d0                	mov    %edx,%eax
  800f04:	d3 e0                	shl    %cl,%eax
  800f06:	89 e9                	mov    %ebp,%ecx
  800f08:	d3 eb                	shr    %cl,%ebx
  800f0a:	d3 ea                	shr    %cl,%edx
  800f0c:	09 d8                	or     %ebx,%eax
  800f0e:	83 c4 1c             	add    $0x1c,%esp
  800f11:	5b                   	pop    %ebx
  800f12:	5e                   	pop    %esi
  800f13:	5f                   	pop    %edi
  800f14:	5d                   	pop    %ebp
  800f15:	c3                   	ret    
  800f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f1d:	8d 76 00             	lea    0x0(%esi),%esi
  800f20:	29 fe                	sub    %edi,%esi
  800f22:	19 c3                	sbb    %eax,%ebx
  800f24:	89 f2                	mov    %esi,%edx
  800f26:	89 d9                	mov    %ebx,%ecx
  800f28:	e9 1d ff ff ff       	jmp    800e4a <__umoddi3+0x6a>
