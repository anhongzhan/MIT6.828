
obj/user/buggyhello2:     file format elf32-i386


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
  80002c:	e8 34 00 00 00       	call   800065 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	53                   	push   %ebx
  80003b:	83 ec 0c             	sub    $0xc,%esp
  80003e:	e8 1e 00 00 00       	call   800061 <__x86.get_pc_thunk.bx>
  800043:	81 c3 bd 1f 00 00    	add    $0x1fbd,%ebx
	sys_cputs(hello, 1024*1024);
  800049:	68 00 00 10 00       	push   $0x100000
  80004e:	ff b3 0c 00 00 00    	pushl  0xc(%ebx)
  800054:	e8 93 00 00 00       	call   8000ec <sys_cputs>
}
  800059:	83 c4 10             	add    $0x10,%esp
  80005c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80005f:	c9                   	leave  
  800060:	c3                   	ret    

00800061 <__x86.get_pc_thunk.bx>:
  800061:	8b 1c 24             	mov    (%esp),%ebx
  800064:	c3                   	ret    

00800065 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800065:	f3 0f 1e fb          	endbr32 
  800069:	55                   	push   %ebp
  80006a:	89 e5                	mov    %esp,%ebp
  80006c:	57                   	push   %edi
  80006d:	56                   	push   %esi
  80006e:	53                   	push   %ebx
  80006f:	83 ec 0c             	sub    $0xc,%esp
  800072:	e8 ea ff ff ff       	call   800061 <__x86.get_pc_thunk.bx>
  800077:	81 c3 89 1f 00 00    	add    $0x1f89,%ebx
  80007d:	8b 75 08             	mov    0x8(%ebp),%esi
  800080:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800083:	e8 02 01 00 00       	call   80018a <sys_getenvid>
  800088:	25 ff 03 00 00       	and    $0x3ff,%eax
  80008d:	8d 04 40             	lea    (%eax,%eax,2),%eax
  800090:	c1 e0 05             	shl    $0x5,%eax
  800093:	81 c0 00 00 c0 ee    	add    $0xeec00000,%eax
  800099:	c7 c2 30 20 80 00    	mov    $0x802030,%edx
  80009f:	89 02                	mov    %eax,(%edx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a1:	85 f6                	test   %esi,%esi
  8000a3:	7e 08                	jle    8000ad <libmain+0x48>
		binaryname = argv[0];
  8000a5:	8b 07                	mov    (%edi),%eax
  8000a7:	89 83 10 00 00 00    	mov    %eax,0x10(%ebx)

	// call user main routine
	umain(argc, argv);
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	57                   	push   %edi
  8000b1:	56                   	push   %esi
  8000b2:	e8 7c ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000b7:	e8 0b 00 00 00       	call   8000c7 <exit>
}
  8000bc:	83 c4 10             	add    $0x10,%esp
  8000bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000c2:	5b                   	pop    %ebx
  8000c3:	5e                   	pop    %esi
  8000c4:	5f                   	pop    %edi
  8000c5:	5d                   	pop    %ebp
  8000c6:	c3                   	ret    

008000c7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c7:	f3 0f 1e fb          	endbr32 
  8000cb:	55                   	push   %ebp
  8000cc:	89 e5                	mov    %esp,%ebp
  8000ce:	53                   	push   %ebx
  8000cf:	83 ec 10             	sub    $0x10,%esp
  8000d2:	e8 8a ff ff ff       	call   800061 <__x86.get_pc_thunk.bx>
  8000d7:	81 c3 29 1f 00 00    	add    $0x1f29,%ebx
	sys_env_destroy(0);
  8000dd:	6a 00                	push   $0x0
  8000df:	e8 4d 00 00 00       	call   800131 <sys_env_destroy>
}
  8000e4:	83 c4 10             	add    $0x10,%esp
  8000e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000ea:	c9                   	leave  
  8000eb:	c3                   	ret    

008000ec <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000ec:	f3 0f 1e fb          	endbr32 
  8000f0:	55                   	push   %ebp
  8000f1:	89 e5                	mov    %esp,%ebp
  8000f3:	57                   	push   %edi
  8000f4:	56                   	push   %esi
  8000f5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8000fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800101:	89 c3                	mov    %eax,%ebx
  800103:	89 c7                	mov    %eax,%edi
  800105:	89 c6                	mov    %eax,%esi
  800107:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800109:	5b                   	pop    %ebx
  80010a:	5e                   	pop    %esi
  80010b:	5f                   	pop    %edi
  80010c:	5d                   	pop    %ebp
  80010d:	c3                   	ret    

0080010e <sys_cgetc>:

int
sys_cgetc(void)
{
  80010e:	f3 0f 1e fb          	endbr32 
  800112:	55                   	push   %ebp
  800113:	89 e5                	mov    %esp,%ebp
  800115:	57                   	push   %edi
  800116:	56                   	push   %esi
  800117:	53                   	push   %ebx
	asm volatile("int %1\n"
  800118:	ba 00 00 00 00       	mov    $0x0,%edx
  80011d:	b8 01 00 00 00       	mov    $0x1,%eax
  800122:	89 d1                	mov    %edx,%ecx
  800124:	89 d3                	mov    %edx,%ebx
  800126:	89 d7                	mov    %edx,%edi
  800128:	89 d6                	mov    %edx,%esi
  80012a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80012c:	5b                   	pop    %ebx
  80012d:	5e                   	pop    %esi
  80012e:	5f                   	pop    %edi
  80012f:	5d                   	pop    %ebp
  800130:	c3                   	ret    

00800131 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800131:	f3 0f 1e fb          	endbr32 
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	57                   	push   %edi
  800139:	56                   	push   %esi
  80013a:	53                   	push   %ebx
  80013b:	83 ec 1c             	sub    $0x1c,%esp
  80013e:	e8 6a 00 00 00       	call   8001ad <__x86.get_pc_thunk.ax>
  800143:	05 bd 1e 00 00       	add    $0x1ebd,%eax
  800148:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("int %1\n"
  80014b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800150:	8b 55 08             	mov    0x8(%ebp),%edx
  800153:	b8 03 00 00 00       	mov    $0x3,%eax
  800158:	89 cb                	mov    %ecx,%ebx
  80015a:	89 cf                	mov    %ecx,%edi
  80015c:	89 ce                	mov    %ecx,%esi
  80015e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800160:	85 c0                	test   %eax,%eax
  800162:	7f 08                	jg     80016c <sys_env_destroy+0x3b>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800164:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800167:	5b                   	pop    %ebx
  800168:	5e                   	pop    %esi
  800169:	5f                   	pop    %edi
  80016a:	5d                   	pop    %ebp
  80016b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80016c:	83 ec 0c             	sub    $0xc,%esp
  80016f:	50                   	push   %eax
  800170:	6a 03                	push   $0x3
  800172:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800175:	8d 83 48 ef ff ff    	lea    -0x10b8(%ebx),%eax
  80017b:	50                   	push   %eax
  80017c:	6a 23                	push   $0x23
  80017e:	8d 83 65 ef ff ff    	lea    -0x109b(%ebx),%eax
  800184:	50                   	push   %eax
  800185:	e8 27 00 00 00       	call   8001b1 <_panic>

0080018a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80018a:	f3 0f 1e fb          	endbr32 
  80018e:	55                   	push   %ebp
  80018f:	89 e5                	mov    %esp,%ebp
  800191:	57                   	push   %edi
  800192:	56                   	push   %esi
  800193:	53                   	push   %ebx
	asm volatile("int %1\n"
  800194:	ba 00 00 00 00       	mov    $0x0,%edx
  800199:	b8 02 00 00 00       	mov    $0x2,%eax
  80019e:	89 d1                	mov    %edx,%ecx
  8001a0:	89 d3                	mov    %edx,%ebx
  8001a2:	89 d7                	mov    %edx,%edi
  8001a4:	89 d6                	mov    %edx,%esi
  8001a6:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8001a8:	5b                   	pop    %ebx
  8001a9:	5e                   	pop    %esi
  8001aa:	5f                   	pop    %edi
  8001ab:	5d                   	pop    %ebp
  8001ac:	c3                   	ret    

008001ad <__x86.get_pc_thunk.ax>:
  8001ad:	8b 04 24             	mov    (%esp),%eax
  8001b0:	c3                   	ret    

008001b1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001b1:	f3 0f 1e fb          	endbr32 
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	57                   	push   %edi
  8001b9:	56                   	push   %esi
  8001ba:	53                   	push   %ebx
  8001bb:	83 ec 0c             	sub    $0xc,%esp
  8001be:	e8 9e fe ff ff       	call   800061 <__x86.get_pc_thunk.bx>
  8001c3:	81 c3 3d 1e 00 00    	add    $0x1e3d,%ebx
	va_list ap;

	va_start(ap, fmt);
  8001c9:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001cc:	c7 c0 10 20 80 00    	mov    $0x802010,%eax
  8001d2:	8b 38                	mov    (%eax),%edi
  8001d4:	e8 b1 ff ff ff       	call   80018a <sys_getenvid>
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	ff 75 0c             	pushl  0xc(%ebp)
  8001df:	ff 75 08             	pushl  0x8(%ebp)
  8001e2:	57                   	push   %edi
  8001e3:	50                   	push   %eax
  8001e4:	8d 83 74 ef ff ff    	lea    -0x108c(%ebx),%eax
  8001ea:	50                   	push   %eax
  8001eb:	e8 d9 00 00 00       	call   8002c9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001f0:	83 c4 18             	add    $0x18,%esp
  8001f3:	56                   	push   %esi
  8001f4:	ff 75 10             	pushl  0x10(%ebp)
  8001f7:	e8 67 00 00 00       	call   800263 <vcprintf>
	cprintf("\n");
  8001fc:	8d 83 3c ef ff ff    	lea    -0x10c4(%ebx),%eax
  800202:	89 04 24             	mov    %eax,(%esp)
  800205:	e8 bf 00 00 00       	call   8002c9 <cprintf>
  80020a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80020d:	cc                   	int3   
  80020e:	eb fd                	jmp    80020d <_panic+0x5c>

00800210 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800210:	f3 0f 1e fb          	endbr32 
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	56                   	push   %esi
  800218:	53                   	push   %ebx
  800219:	e8 43 fe ff ff       	call   800061 <__x86.get_pc_thunk.bx>
  80021e:	81 c3 e2 1d 00 00    	add    $0x1de2,%ebx
  800224:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  800227:	8b 16                	mov    (%esi),%edx
  800229:	8d 42 01             	lea    0x1(%edx),%eax
  80022c:	89 06                	mov    %eax,(%esi)
  80022e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800231:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  800235:	3d ff 00 00 00       	cmp    $0xff,%eax
  80023a:	74 0b                	je     800247 <putch+0x37>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80023c:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  800240:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800243:	5b                   	pop    %ebx
  800244:	5e                   	pop    %esi
  800245:	5d                   	pop    %ebp
  800246:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800247:	83 ec 08             	sub    $0x8,%esp
  80024a:	68 ff 00 00 00       	push   $0xff
  80024f:	8d 46 08             	lea    0x8(%esi),%eax
  800252:	50                   	push   %eax
  800253:	e8 94 fe ff ff       	call   8000ec <sys_cputs>
		b->idx = 0;
  800258:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80025e:	83 c4 10             	add    $0x10,%esp
  800261:	eb d9                	jmp    80023c <putch+0x2c>

00800263 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800263:	f3 0f 1e fb          	endbr32 
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	53                   	push   %ebx
  80026b:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800271:	e8 eb fd ff ff       	call   800061 <__x86.get_pc_thunk.bx>
  800276:	81 c3 8a 1d 00 00    	add    $0x1d8a,%ebx
	struct printbuf b;

	b.idx = 0;
  80027c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800283:	00 00 00 
	b.cnt = 0;
  800286:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80028d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800290:	ff 75 0c             	pushl  0xc(%ebp)
  800293:	ff 75 08             	pushl  0x8(%ebp)
  800296:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80029c:	50                   	push   %eax
  80029d:	8d 83 10 e2 ff ff    	lea    -0x1df0(%ebx),%eax
  8002a3:	50                   	push   %eax
  8002a4:	e8 38 01 00 00       	call   8003e1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002a9:	83 c4 08             	add    $0x8,%esp
  8002ac:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002b2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002b8:	50                   	push   %eax
  8002b9:	e8 2e fe ff ff       	call   8000ec <sys_cputs>

	return b.cnt;
}
  8002be:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002c7:	c9                   	leave  
  8002c8:	c3                   	ret    

008002c9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002c9:	f3 0f 1e fb          	endbr32 
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002d3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002d6:	50                   	push   %eax
  8002d7:	ff 75 08             	pushl  0x8(%ebp)
  8002da:	e8 84 ff ff ff       	call   800263 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002df:	c9                   	leave  
  8002e0:	c3                   	ret    

008002e1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002e1:	55                   	push   %ebp
  8002e2:	89 e5                	mov    %esp,%ebp
  8002e4:	57                   	push   %edi
  8002e5:	56                   	push   %esi
  8002e6:	53                   	push   %ebx
  8002e7:	83 ec 2c             	sub    $0x2c,%esp
  8002ea:	e8 28 06 00 00       	call   800917 <__x86.get_pc_thunk.cx>
  8002ef:	81 c1 11 1d 00 00    	add    $0x1d11,%ecx
  8002f5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002f8:	89 c7                	mov    %eax,%edi
  8002fa:	89 d6                	mov    %edx,%esi
  8002fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800302:	89 d1                	mov    %edx,%ecx
  800304:	89 c2                	mov    %eax,%edx
  800306:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800309:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80030c:	8b 45 10             	mov    0x10(%ebp),%eax
  80030f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800312:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800315:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80031c:	39 c2                	cmp    %eax,%edx
  80031e:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800321:	72 41                	jb     800364 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800323:	83 ec 0c             	sub    $0xc,%esp
  800326:	ff 75 18             	pushl  0x18(%ebp)
  800329:	83 eb 01             	sub    $0x1,%ebx
  80032c:	53                   	push   %ebx
  80032d:	50                   	push   %eax
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	ff 75 e4             	pushl  -0x1c(%ebp)
  800334:	ff 75 e0             	pushl  -0x20(%ebp)
  800337:	ff 75 d4             	pushl  -0x2c(%ebp)
  80033a:	ff 75 d0             	pushl  -0x30(%ebp)
  80033d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800340:	e8 8b 09 00 00       	call   800cd0 <__udivdi3>
  800345:	83 c4 18             	add    $0x18,%esp
  800348:	52                   	push   %edx
  800349:	50                   	push   %eax
  80034a:	89 f2                	mov    %esi,%edx
  80034c:	89 f8                	mov    %edi,%eax
  80034e:	e8 8e ff ff ff       	call   8002e1 <printnum>
  800353:	83 c4 20             	add    $0x20,%esp
  800356:	eb 13                	jmp    80036b <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800358:	83 ec 08             	sub    $0x8,%esp
  80035b:	56                   	push   %esi
  80035c:	ff 75 18             	pushl  0x18(%ebp)
  80035f:	ff d7                	call   *%edi
  800361:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800364:	83 eb 01             	sub    $0x1,%ebx
  800367:	85 db                	test   %ebx,%ebx
  800369:	7f ed                	jg     800358 <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80036b:	83 ec 08             	sub    $0x8,%esp
  80036e:	56                   	push   %esi
  80036f:	83 ec 04             	sub    $0x4,%esp
  800372:	ff 75 e4             	pushl  -0x1c(%ebp)
  800375:	ff 75 e0             	pushl  -0x20(%ebp)
  800378:	ff 75 d4             	pushl  -0x2c(%ebp)
  80037b:	ff 75 d0             	pushl  -0x30(%ebp)
  80037e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800381:	e8 5a 0a 00 00       	call   800de0 <__umoddi3>
  800386:	83 c4 14             	add    $0x14,%esp
  800389:	0f be 84 03 97 ef ff 	movsbl -0x1069(%ebx,%eax,1),%eax
  800390:	ff 
  800391:	50                   	push   %eax
  800392:	ff d7                	call   *%edi
}
  800394:	83 c4 10             	add    $0x10,%esp
  800397:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80039a:	5b                   	pop    %ebx
  80039b:	5e                   	pop    %esi
  80039c:	5f                   	pop    %edi
  80039d:	5d                   	pop    %ebp
  80039e:	c3                   	ret    

0080039f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80039f:	f3 0f 1e fb          	endbr32 
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003a9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003ad:	8b 10                	mov    (%eax),%edx
  8003af:	3b 50 04             	cmp    0x4(%eax),%edx
  8003b2:	73 0a                	jae    8003be <sprintputch+0x1f>
		*b->buf++ = ch;
  8003b4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003b7:	89 08                	mov    %ecx,(%eax)
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	88 02                	mov    %al,(%edx)
}
  8003be:	5d                   	pop    %ebp
  8003bf:	c3                   	ret    

008003c0 <printfmt>:
{
  8003c0:	f3 0f 1e fb          	endbr32 
  8003c4:	55                   	push   %ebp
  8003c5:	89 e5                	mov    %esp,%ebp
  8003c7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003ca:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003cd:	50                   	push   %eax
  8003ce:	ff 75 10             	pushl  0x10(%ebp)
  8003d1:	ff 75 0c             	pushl  0xc(%ebp)
  8003d4:	ff 75 08             	pushl  0x8(%ebp)
  8003d7:	e8 05 00 00 00       	call   8003e1 <vprintfmt>
}
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	c9                   	leave  
  8003e0:	c3                   	ret    

008003e1 <vprintfmt>:
{
  8003e1:	f3 0f 1e fb          	endbr32 
  8003e5:	55                   	push   %ebp
  8003e6:	89 e5                	mov    %esp,%ebp
  8003e8:	57                   	push   %edi
  8003e9:	56                   	push   %esi
  8003ea:	53                   	push   %ebx
  8003eb:	83 ec 3c             	sub    $0x3c,%esp
  8003ee:	e8 ba fd ff ff       	call   8001ad <__x86.get_pc_thunk.ax>
  8003f3:	05 0d 1c 00 00       	add    $0x1c0d,%eax
  8003f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8003fe:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800401:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800404:	8d 80 14 00 00 00    	lea    0x14(%eax),%eax
  80040a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80040d:	e9 cd 03 00 00       	jmp    8007df <.L25+0x48>
		padc = ' ';
  800412:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
  800416:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80041d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800424:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  80042b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800430:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800433:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800436:	8d 43 01             	lea    0x1(%ebx),%eax
  800439:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80043c:	0f b6 13             	movzbl (%ebx),%edx
  80043f:	8d 42 dd             	lea    -0x23(%edx),%eax
  800442:	3c 55                	cmp    $0x55,%al
  800444:	0f 87 21 04 00 00    	ja     80086b <.L20>
  80044a:	0f b6 c0             	movzbl %al,%eax
  80044d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800450:	89 ce                	mov    %ecx,%esi
  800452:	03 b4 81 24 f0 ff ff 	add    -0xfdc(%ecx,%eax,4),%esi
  800459:	3e ff e6             	notrack jmp *%esi

0080045c <.L68>:
  80045c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
  80045f:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800463:	eb d1                	jmp    800436 <vprintfmt+0x55>

00800465 <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
  800465:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800468:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80046c:	eb c8                	jmp    800436 <vprintfmt+0x55>

0080046e <.L31>:
  80046e:	0f b6 d2             	movzbl %dl,%edx
  800471:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
  800474:	b8 00 00 00 00       	mov    $0x0,%eax
  800479:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
  80047c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80047f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800483:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800486:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800489:	83 f9 09             	cmp    $0x9,%ecx
  80048c:	77 58                	ja     8004e6 <.L36+0xf>
			for (precision = 0; ; ++fmt) {
  80048e:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800491:	eb e9                	jmp    80047c <.L31+0xe>

00800493 <.L34>:
			precision = va_arg(ap, int);
  800493:	8b 45 14             	mov    0x14(%ebp),%eax
  800496:	8b 00                	mov    (%eax),%eax
  800498:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80049b:	8b 45 14             	mov    0x14(%ebp),%eax
  80049e:	8d 40 04             	lea    0x4(%eax),%eax
  8004a1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
  8004a7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004ab:	79 89                	jns    800436 <vprintfmt+0x55>
				width = precision, precision = -1;
  8004ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004b0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004b3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004ba:	e9 77 ff ff ff       	jmp    800436 <vprintfmt+0x55>

008004bf <.L33>:
  8004bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004c2:	85 c0                	test   %eax,%eax
  8004c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c9:	0f 49 d0             	cmovns %eax,%edx
  8004cc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004cf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004d2:	e9 5f ff ff ff       	jmp    800436 <vprintfmt+0x55>

008004d7 <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
  8004d7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
  8004da:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004e1:	e9 50 ff ff ff       	jmp    800436 <vprintfmt+0x55>
  8004e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e9:	89 75 08             	mov    %esi,0x8(%ebp)
  8004ec:	eb b9                	jmp    8004a7 <.L34+0x14>

008004ee <.L27>:
			lflag++;
  8004ee:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004f2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004f5:	e9 3c ff ff ff       	jmp    800436 <vprintfmt+0x55>

008004fa <.L30>:
  8004fa:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(va_arg(ap, int), putdat);
  8004fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800500:	8d 58 04             	lea    0x4(%eax),%ebx
  800503:	83 ec 08             	sub    $0x8,%esp
  800506:	57                   	push   %edi
  800507:	ff 30                	pushl  (%eax)
  800509:	ff d6                	call   *%esi
			break;
  80050b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80050e:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
  800511:	e9 c6 02 00 00       	jmp    8007dc <.L25+0x45>

00800516 <.L28>:
  800516:	8b 75 08             	mov    0x8(%ebp),%esi
			err = va_arg(ap, int);
  800519:	8b 45 14             	mov    0x14(%ebp),%eax
  80051c:	8d 58 04             	lea    0x4(%eax),%ebx
  80051f:	8b 00                	mov    (%eax),%eax
  800521:	99                   	cltd   
  800522:	31 d0                	xor    %edx,%eax
  800524:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800526:	83 f8 06             	cmp    $0x6,%eax
  800529:	7f 27                	jg     800552 <.L28+0x3c>
  80052b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80052e:	8b 14 82             	mov    (%edx,%eax,4),%edx
  800531:	85 d2                	test   %edx,%edx
  800533:	74 1d                	je     800552 <.L28+0x3c>
				printfmt(putch, putdat, "%s", p);
  800535:	52                   	push   %edx
  800536:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800539:	8d 80 b8 ef ff ff    	lea    -0x1048(%eax),%eax
  80053f:	50                   	push   %eax
  800540:	57                   	push   %edi
  800541:	56                   	push   %esi
  800542:	e8 79 fe ff ff       	call   8003c0 <printfmt>
  800547:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80054a:	89 5d 14             	mov    %ebx,0x14(%ebp)
  80054d:	e9 8a 02 00 00       	jmp    8007dc <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
  800552:	50                   	push   %eax
  800553:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800556:	8d 80 af ef ff ff    	lea    -0x1051(%eax),%eax
  80055c:	50                   	push   %eax
  80055d:	57                   	push   %edi
  80055e:	56                   	push   %esi
  80055f:	e8 5c fe ff ff       	call   8003c0 <printfmt>
  800564:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800567:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80056a:	e9 6d 02 00 00       	jmp    8007dc <.L25+0x45>

0080056f <.L24>:
  80056f:	8b 75 08             	mov    0x8(%ebp),%esi
			if ((p = va_arg(ap, char *)) == NULL)
  800572:	8b 45 14             	mov    0x14(%ebp),%eax
  800575:	83 c0 04             	add    $0x4,%eax
  800578:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80057b:	8b 45 14             	mov    0x14(%ebp),%eax
  80057e:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800580:	85 d2                	test   %edx,%edx
  800582:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800585:	8d 80 a8 ef ff ff    	lea    -0x1058(%eax),%eax
  80058b:	0f 45 c2             	cmovne %edx,%eax
  80058e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800591:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800595:	7e 06                	jle    80059d <.L24+0x2e>
  800597:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80059b:	75 0d                	jne    8005aa <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
  80059d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005a0:	89 c3                	mov    %eax,%ebx
  8005a2:	03 45 d4             	add    -0x2c(%ebp),%eax
  8005a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8005a8:	eb 58                	jmp    800602 <.L24+0x93>
  8005aa:	83 ec 08             	sub    $0x8,%esp
  8005ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8005b0:	ff 75 c8             	pushl  -0x38(%ebp)
  8005b3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005b6:	e8 7c 03 00 00       	call   800937 <strnlen>
  8005bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005be:	29 c2                	sub    %eax,%edx
  8005c0:	89 55 bc             	mov    %edx,-0x44(%ebp)
  8005c3:	83 c4 10             	add    $0x10,%esp
  8005c6:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
  8005c8:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005cc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005cf:	85 db                	test   %ebx,%ebx
  8005d1:	7e 11                	jle    8005e4 <.L24+0x75>
					putch(padc, putdat);
  8005d3:	83 ec 08             	sub    $0x8,%esp
  8005d6:	57                   	push   %edi
  8005d7:	ff 75 d4             	pushl  -0x2c(%ebp)
  8005da:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005dc:	83 eb 01             	sub    $0x1,%ebx
  8005df:	83 c4 10             	add    $0x10,%esp
  8005e2:	eb eb                	jmp    8005cf <.L24+0x60>
  8005e4:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8005e7:	85 d2                	test   %edx,%edx
  8005e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ee:	0f 49 c2             	cmovns %edx,%eax
  8005f1:	29 c2                	sub    %eax,%edx
  8005f3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005f6:	eb a5                	jmp    80059d <.L24+0x2e>
					putch(ch, putdat);
  8005f8:	83 ec 08             	sub    $0x8,%esp
  8005fb:	57                   	push   %edi
  8005fc:	52                   	push   %edx
  8005fd:	ff d6                	call   *%esi
  8005ff:	83 c4 10             	add    $0x10,%esp
  800602:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800605:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800607:	83 c3 01             	add    $0x1,%ebx
  80060a:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  80060e:	0f be d0             	movsbl %al,%edx
  800611:	85 d2                	test   %edx,%edx
  800613:	74 4b                	je     800660 <.L24+0xf1>
  800615:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800619:	78 06                	js     800621 <.L24+0xb2>
  80061b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80061f:	78 1e                	js     80063f <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
  800621:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800625:	74 d1                	je     8005f8 <.L24+0x89>
  800627:	0f be c0             	movsbl %al,%eax
  80062a:	83 e8 20             	sub    $0x20,%eax
  80062d:	83 f8 5e             	cmp    $0x5e,%eax
  800630:	76 c6                	jbe    8005f8 <.L24+0x89>
					putch('?', putdat);
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	57                   	push   %edi
  800636:	6a 3f                	push   $0x3f
  800638:	ff d6                	call   *%esi
  80063a:	83 c4 10             	add    $0x10,%esp
  80063d:	eb c3                	jmp    800602 <.L24+0x93>
  80063f:	89 cb                	mov    %ecx,%ebx
  800641:	eb 0e                	jmp    800651 <.L24+0xe2>
				putch(' ', putdat);
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	57                   	push   %edi
  800647:	6a 20                	push   $0x20
  800649:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80064b:	83 eb 01             	sub    $0x1,%ebx
  80064e:	83 c4 10             	add    $0x10,%esp
  800651:	85 db                	test   %ebx,%ebx
  800653:	7f ee                	jg     800643 <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
  800655:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800658:	89 45 14             	mov    %eax,0x14(%ebp)
  80065b:	e9 7c 01 00 00       	jmp    8007dc <.L25+0x45>
  800660:	89 cb                	mov    %ecx,%ebx
  800662:	eb ed                	jmp    800651 <.L24+0xe2>

00800664 <.L29>:
  800664:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800667:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  80066a:	83 f9 01             	cmp    $0x1,%ecx
  80066d:	7f 1b                	jg     80068a <.L29+0x26>
	else if (lflag)
  80066f:	85 c9                	test   %ecx,%ecx
  800671:	74 63                	je     8006d6 <.L29+0x72>
		return va_arg(*ap, long);
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	8b 00                	mov    (%eax),%eax
  800678:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067b:	99                   	cltd   
  80067c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8d 40 04             	lea    0x4(%eax),%eax
  800685:	89 45 14             	mov    %eax,0x14(%ebp)
  800688:	eb 17                	jmp    8006a1 <.L29+0x3d>
		return va_arg(*ap, long long);
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	8b 50 04             	mov    0x4(%eax),%edx
  800690:	8b 00                	mov    (%eax),%eax
  800692:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800695:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8d 40 08             	lea    0x8(%eax),%eax
  80069e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006a1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006a4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006a7:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006ac:	85 c9                	test   %ecx,%ecx
  8006ae:	0f 89 0e 01 00 00    	jns    8007c2 <.L25+0x2b>
				putch('-', putdat);
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	57                   	push   %edi
  8006b8:	6a 2d                	push   $0x2d
  8006ba:	ff d6                	call   *%esi
				num = -(long long) num;
  8006bc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006bf:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006c2:	f7 da                	neg    %edx
  8006c4:	83 d1 00             	adc    $0x0,%ecx
  8006c7:	f7 d9                	neg    %ecx
  8006c9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006cc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d1:	e9 ec 00 00 00       	jmp    8007c2 <.L25+0x2b>
		return va_arg(*ap, int);
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006de:	99                   	cltd   
  8006df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	8d 40 04             	lea    0x4(%eax),%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006eb:	eb b4                	jmp    8006a1 <.L29+0x3d>

008006ed <.L23>:
  8006ed:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006f0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  8006f3:	83 f9 01             	cmp    $0x1,%ecx
  8006f6:	7f 1e                	jg     800716 <.L23+0x29>
	else if (lflag)
  8006f8:	85 c9                	test   %ecx,%ecx
  8006fa:	74 32                	je     80072e <.L23+0x41>
		return va_arg(*ap, unsigned long);
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8b 10                	mov    (%eax),%edx
  800701:	b9 00 00 00 00       	mov    $0x0,%ecx
  800706:	8d 40 04             	lea    0x4(%eax),%eax
  800709:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80070c:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800711:	e9 ac 00 00 00       	jmp    8007c2 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	8b 10                	mov    (%eax),%edx
  80071b:	8b 48 04             	mov    0x4(%eax),%ecx
  80071e:	8d 40 08             	lea    0x8(%eax),%eax
  800721:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800724:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800729:	e9 94 00 00 00       	jmp    8007c2 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8b 10                	mov    (%eax),%edx
  800733:	b9 00 00 00 00       	mov    $0x0,%ecx
  800738:	8d 40 04             	lea    0x4(%eax),%eax
  80073b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80073e:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800743:	eb 7d                	jmp    8007c2 <.L25+0x2b>

00800745 <.L26>:
  800745:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800748:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  80074b:	83 f9 01             	cmp    $0x1,%ecx
  80074e:	7f 1b                	jg     80076b <.L26+0x26>
	else if (lflag)
  800750:	85 c9                	test   %ecx,%ecx
  800752:	74 2c                	je     800780 <.L26+0x3b>
		return va_arg(*ap, unsigned long);
  800754:	8b 45 14             	mov    0x14(%ebp),%eax
  800757:	8b 10                	mov    (%eax),%edx
  800759:	b9 00 00 00 00       	mov    $0x0,%ecx
  80075e:	8d 40 04             	lea    0x4(%eax),%eax
  800761:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800764:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800769:	eb 57                	jmp    8007c2 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  80076b:	8b 45 14             	mov    0x14(%ebp),%eax
  80076e:	8b 10                	mov    (%eax),%edx
  800770:	8b 48 04             	mov    0x4(%eax),%ecx
  800773:	8d 40 08             	lea    0x8(%eax),%eax
  800776:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800779:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80077e:	eb 42                	jmp    8007c2 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	8b 10                	mov    (%eax),%edx
  800785:	b9 00 00 00 00       	mov    $0x0,%ecx
  80078a:	8d 40 04             	lea    0x4(%eax),%eax
  80078d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800790:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800795:	eb 2b                	jmp    8007c2 <.L25+0x2b>

00800797 <.L25>:
  800797:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('0', putdat);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	57                   	push   %edi
  80079e:	6a 30                	push   $0x30
  8007a0:	ff d6                	call   *%esi
			putch('x', putdat);
  8007a2:	83 c4 08             	add    $0x8,%esp
  8007a5:	57                   	push   %edi
  8007a6:	6a 78                	push   $0x78
  8007a8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ad:	8b 10                	mov    (%eax),%edx
  8007af:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007b4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007b7:	8d 40 04             	lea    0x4(%eax),%eax
  8007ba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007bd:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007c2:	83 ec 0c             	sub    $0xc,%esp
  8007c5:	0f be 5d cf          	movsbl -0x31(%ebp),%ebx
  8007c9:	53                   	push   %ebx
  8007ca:	ff 75 d4             	pushl  -0x2c(%ebp)
  8007cd:	50                   	push   %eax
  8007ce:	51                   	push   %ecx
  8007cf:	52                   	push   %edx
  8007d0:	89 fa                	mov    %edi,%edx
  8007d2:	89 f0                	mov    %esi,%eax
  8007d4:	e8 08 fb ff ff       	call   8002e1 <printnum>
			break;
  8007d9:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007dc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007df:	83 c3 01             	add    $0x1,%ebx
  8007e2:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8007e6:	83 f8 25             	cmp    $0x25,%eax
  8007e9:	0f 84 23 fc ff ff    	je     800412 <vprintfmt+0x31>
			if (ch == '\0')
  8007ef:	85 c0                	test   %eax,%eax
  8007f1:	0f 84 97 00 00 00    	je     80088e <.L20+0x23>
			putch(ch, putdat);
  8007f7:	83 ec 08             	sub    $0x8,%esp
  8007fa:	57                   	push   %edi
  8007fb:	50                   	push   %eax
  8007fc:	ff d6                	call   *%esi
  8007fe:	83 c4 10             	add    $0x10,%esp
  800801:	eb dc                	jmp    8007df <.L25+0x48>

00800803 <.L21>:
  800803:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800806:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  800809:	83 f9 01             	cmp    $0x1,%ecx
  80080c:	7f 1b                	jg     800829 <.L21+0x26>
	else if (lflag)
  80080e:	85 c9                	test   %ecx,%ecx
  800810:	74 2c                	je     80083e <.L21+0x3b>
		return va_arg(*ap, unsigned long);
  800812:	8b 45 14             	mov    0x14(%ebp),%eax
  800815:	8b 10                	mov    (%eax),%edx
  800817:	b9 00 00 00 00       	mov    $0x0,%ecx
  80081c:	8d 40 04             	lea    0x4(%eax),%eax
  80081f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800822:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800827:	eb 99                	jmp    8007c2 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800829:	8b 45 14             	mov    0x14(%ebp),%eax
  80082c:	8b 10                	mov    (%eax),%edx
  80082e:	8b 48 04             	mov    0x4(%eax),%ecx
  800831:	8d 40 08             	lea    0x8(%eax),%eax
  800834:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800837:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80083c:	eb 84                	jmp    8007c2 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80083e:	8b 45 14             	mov    0x14(%ebp),%eax
  800841:	8b 10                	mov    (%eax),%edx
  800843:	b9 00 00 00 00       	mov    $0x0,%ecx
  800848:	8d 40 04             	lea    0x4(%eax),%eax
  80084b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80084e:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800853:	e9 6a ff ff ff       	jmp    8007c2 <.L25+0x2b>

00800858 <.L35>:
  800858:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(ch, putdat);
  80085b:	83 ec 08             	sub    $0x8,%esp
  80085e:	57                   	push   %edi
  80085f:	6a 25                	push   $0x25
  800861:	ff d6                	call   *%esi
			break;
  800863:	83 c4 10             	add    $0x10,%esp
  800866:	e9 71 ff ff ff       	jmp    8007dc <.L25+0x45>

0080086b <.L20>:
  80086b:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('%', putdat);
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	57                   	push   %edi
  800872:	6a 25                	push   $0x25
  800874:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800876:	83 c4 10             	add    $0x10,%esp
  800879:	89 d8                	mov    %ebx,%eax
  80087b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80087f:	74 05                	je     800886 <.L20+0x1b>
  800881:	83 e8 01             	sub    $0x1,%eax
  800884:	eb f5                	jmp    80087b <.L20+0x10>
  800886:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800889:	e9 4e ff ff ff       	jmp    8007dc <.L25+0x45>
}
  80088e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800891:	5b                   	pop    %ebx
  800892:	5e                   	pop    %esi
  800893:	5f                   	pop    %edi
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    

00800896 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800896:	f3 0f 1e fb          	endbr32 
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	53                   	push   %ebx
  80089e:	83 ec 14             	sub    $0x14,%esp
  8008a1:	e8 bb f7 ff ff       	call   800061 <__x86.get_pc_thunk.bx>
  8008a6:	81 c3 5a 17 00 00    	add    $0x175a,%ebx
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008b5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008b9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008c3:	85 c0                	test   %eax,%eax
  8008c5:	74 2b                	je     8008f2 <vsnprintf+0x5c>
  8008c7:	85 d2                	test   %edx,%edx
  8008c9:	7e 27                	jle    8008f2 <vsnprintf+0x5c>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008cb:	ff 75 14             	pushl  0x14(%ebp)
  8008ce:	ff 75 10             	pushl  0x10(%ebp)
  8008d1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008d4:	50                   	push   %eax
  8008d5:	8d 83 9f e3 ff ff    	lea    -0x1c61(%ebx),%eax
  8008db:	50                   	push   %eax
  8008dc:	e8 00 fb ff ff       	call   8003e1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ea:	83 c4 10             	add    $0x10,%esp
}
  8008ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008f0:	c9                   	leave  
  8008f1:	c3                   	ret    
		return -E_INVAL;
  8008f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008f7:	eb f4                	jmp    8008ed <vsnprintf+0x57>

008008f9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008f9:	f3 0f 1e fb          	endbr32 
  8008fd:	55                   	push   %ebp
  8008fe:	89 e5                	mov    %esp,%ebp
  800900:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800903:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800906:	50                   	push   %eax
  800907:	ff 75 10             	pushl  0x10(%ebp)
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	ff 75 08             	pushl  0x8(%ebp)
  800910:	e8 81 ff ff ff       	call   800896 <vsnprintf>
	va_end(ap);

	return rc;
}
  800915:	c9                   	leave  
  800916:	c3                   	ret    

00800917 <__x86.get_pc_thunk.cx>:
  800917:	8b 0c 24             	mov    (%esp),%ecx
  80091a:	c3                   	ret    

0080091b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80091b:	f3 0f 1e fb          	endbr32 
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800925:	b8 00 00 00 00       	mov    $0x0,%eax
  80092a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80092e:	74 05                	je     800935 <strlen+0x1a>
		n++;
  800930:	83 c0 01             	add    $0x1,%eax
  800933:	eb f5                	jmp    80092a <strlen+0xf>
	return n;
}
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800937:	f3 0f 1e fb          	endbr32 
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800941:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800944:	b8 00 00 00 00       	mov    $0x0,%eax
  800949:	39 d0                	cmp    %edx,%eax
  80094b:	74 0d                	je     80095a <strnlen+0x23>
  80094d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800951:	74 05                	je     800958 <strnlen+0x21>
		n++;
  800953:	83 c0 01             	add    $0x1,%eax
  800956:	eb f1                	jmp    800949 <strnlen+0x12>
  800958:	89 c2                	mov    %eax,%edx
	return n;
}
  80095a:	89 d0                	mov    %edx,%eax
  80095c:	5d                   	pop    %ebp
  80095d:	c3                   	ret    

0080095e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80095e:	f3 0f 1e fb          	endbr32 
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	53                   	push   %ebx
  800966:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800969:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80096c:	b8 00 00 00 00       	mov    $0x0,%eax
  800971:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800975:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800978:	83 c0 01             	add    $0x1,%eax
  80097b:	84 d2                	test   %dl,%dl
  80097d:	75 f2                	jne    800971 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80097f:	89 c8                	mov    %ecx,%eax
  800981:	5b                   	pop    %ebx
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800984:	f3 0f 1e fb          	endbr32 
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	53                   	push   %ebx
  80098c:	83 ec 10             	sub    $0x10,%esp
  80098f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800992:	53                   	push   %ebx
  800993:	e8 83 ff ff ff       	call   80091b <strlen>
  800998:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80099b:	ff 75 0c             	pushl  0xc(%ebp)
  80099e:	01 d8                	add    %ebx,%eax
  8009a0:	50                   	push   %eax
  8009a1:	e8 b8 ff ff ff       	call   80095e <strcpy>
	return dst;
}
  8009a6:	89 d8                	mov    %ebx,%eax
  8009a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ab:	c9                   	leave  
  8009ac:	c3                   	ret    

008009ad <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009ad:	f3 0f 1e fb          	endbr32 
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
  8009b4:	56                   	push   %esi
  8009b5:	53                   	push   %ebx
  8009b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bc:	89 f3                	mov    %esi,%ebx
  8009be:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009c1:	89 f0                	mov    %esi,%eax
  8009c3:	39 d8                	cmp    %ebx,%eax
  8009c5:	74 11                	je     8009d8 <strncpy+0x2b>
		*dst++ = *src;
  8009c7:	83 c0 01             	add    $0x1,%eax
  8009ca:	0f b6 0a             	movzbl (%edx),%ecx
  8009cd:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009d0:	80 f9 01             	cmp    $0x1,%cl
  8009d3:	83 da ff             	sbb    $0xffffffff,%edx
  8009d6:	eb eb                	jmp    8009c3 <strncpy+0x16>
	}
	return ret;
}
  8009d8:	89 f0                	mov    %esi,%eax
  8009da:	5b                   	pop    %ebx
  8009db:	5e                   	pop    %esi
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    

008009de <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009de:	f3 0f 1e fb          	endbr32 
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	56                   	push   %esi
  8009e6:	53                   	push   %ebx
  8009e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ed:	8b 55 10             	mov    0x10(%ebp),%edx
  8009f0:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009f2:	85 d2                	test   %edx,%edx
  8009f4:	74 21                	je     800a17 <strlcpy+0x39>
  8009f6:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009fa:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009fc:	39 c2                	cmp    %eax,%edx
  8009fe:	74 14                	je     800a14 <strlcpy+0x36>
  800a00:	0f b6 19             	movzbl (%ecx),%ebx
  800a03:	84 db                	test   %bl,%bl
  800a05:	74 0b                	je     800a12 <strlcpy+0x34>
			*dst++ = *src++;
  800a07:	83 c1 01             	add    $0x1,%ecx
  800a0a:	83 c2 01             	add    $0x1,%edx
  800a0d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a10:	eb ea                	jmp    8009fc <strlcpy+0x1e>
  800a12:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a14:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a17:	29 f0                	sub    %esi,%eax
}
  800a19:	5b                   	pop    %ebx
  800a1a:	5e                   	pop    %esi
  800a1b:	5d                   	pop    %ebp
  800a1c:	c3                   	ret    

00800a1d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a1d:	f3 0f 1e fb          	endbr32 
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a27:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a2a:	0f b6 01             	movzbl (%ecx),%eax
  800a2d:	84 c0                	test   %al,%al
  800a2f:	74 0c                	je     800a3d <strcmp+0x20>
  800a31:	3a 02                	cmp    (%edx),%al
  800a33:	75 08                	jne    800a3d <strcmp+0x20>
		p++, q++;
  800a35:	83 c1 01             	add    $0x1,%ecx
  800a38:	83 c2 01             	add    $0x1,%edx
  800a3b:	eb ed                	jmp    800a2a <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a3d:	0f b6 c0             	movzbl %al,%eax
  800a40:	0f b6 12             	movzbl (%edx),%edx
  800a43:	29 d0                	sub    %edx,%eax
}
  800a45:	5d                   	pop    %ebp
  800a46:	c3                   	ret    

00800a47 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a47:	f3 0f 1e fb          	endbr32 
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	53                   	push   %ebx
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a55:	89 c3                	mov    %eax,%ebx
  800a57:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a5a:	eb 06                	jmp    800a62 <strncmp+0x1b>
		n--, p++, q++;
  800a5c:	83 c0 01             	add    $0x1,%eax
  800a5f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a62:	39 d8                	cmp    %ebx,%eax
  800a64:	74 16                	je     800a7c <strncmp+0x35>
  800a66:	0f b6 08             	movzbl (%eax),%ecx
  800a69:	84 c9                	test   %cl,%cl
  800a6b:	74 04                	je     800a71 <strncmp+0x2a>
  800a6d:	3a 0a                	cmp    (%edx),%cl
  800a6f:	74 eb                	je     800a5c <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a71:	0f b6 00             	movzbl (%eax),%eax
  800a74:	0f b6 12             	movzbl (%edx),%edx
  800a77:	29 d0                	sub    %edx,%eax
}
  800a79:	5b                   	pop    %ebx
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    
		return 0;
  800a7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a81:	eb f6                	jmp    800a79 <strncmp+0x32>

00800a83 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a83:	f3 0f 1e fb          	endbr32 
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a91:	0f b6 10             	movzbl (%eax),%edx
  800a94:	84 d2                	test   %dl,%dl
  800a96:	74 09                	je     800aa1 <strchr+0x1e>
		if (*s == c)
  800a98:	38 ca                	cmp    %cl,%dl
  800a9a:	74 0a                	je     800aa6 <strchr+0x23>
	for (; *s; s++)
  800a9c:	83 c0 01             	add    $0x1,%eax
  800a9f:	eb f0                	jmp    800a91 <strchr+0xe>
			return (char *) s;
	return 0;
  800aa1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aa6:	5d                   	pop    %ebp
  800aa7:	c3                   	ret    

00800aa8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aa8:	f3 0f 1e fb          	endbr32 
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab6:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ab9:	38 ca                	cmp    %cl,%dl
  800abb:	74 09                	je     800ac6 <strfind+0x1e>
  800abd:	84 d2                	test   %dl,%dl
  800abf:	74 05                	je     800ac6 <strfind+0x1e>
	for (; *s; s++)
  800ac1:	83 c0 01             	add    $0x1,%eax
  800ac4:	eb f0                	jmp    800ab6 <strfind+0xe>
			break;
	return (char *) s;
}
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ac8:	f3 0f 1e fb          	endbr32 
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	57                   	push   %edi
  800ad0:	56                   	push   %esi
  800ad1:	53                   	push   %ebx
  800ad2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ad5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ad8:	85 c9                	test   %ecx,%ecx
  800ada:	74 31                	je     800b0d <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800adc:	89 f8                	mov    %edi,%eax
  800ade:	09 c8                	or     %ecx,%eax
  800ae0:	a8 03                	test   $0x3,%al
  800ae2:	75 23                	jne    800b07 <memset+0x3f>
		c &= 0xFF;
  800ae4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ae8:	89 d3                	mov    %edx,%ebx
  800aea:	c1 e3 08             	shl    $0x8,%ebx
  800aed:	89 d0                	mov    %edx,%eax
  800aef:	c1 e0 18             	shl    $0x18,%eax
  800af2:	89 d6                	mov    %edx,%esi
  800af4:	c1 e6 10             	shl    $0x10,%esi
  800af7:	09 f0                	or     %esi,%eax
  800af9:	09 c2                	or     %eax,%edx
  800afb:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800afd:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b00:	89 d0                	mov    %edx,%eax
  800b02:	fc                   	cld    
  800b03:	f3 ab                	rep stos %eax,%es:(%edi)
  800b05:	eb 06                	jmp    800b0d <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0a:	fc                   	cld    
  800b0b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b0d:	89 f8                	mov    %edi,%eax
  800b0f:	5b                   	pop    %ebx
  800b10:	5e                   	pop    %esi
  800b11:	5f                   	pop    %edi
  800b12:	5d                   	pop    %ebp
  800b13:	c3                   	ret    

00800b14 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b14:	f3 0f 1e fb          	endbr32 
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	57                   	push   %edi
  800b1c:	56                   	push   %esi
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b23:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b26:	39 c6                	cmp    %eax,%esi
  800b28:	73 32                	jae    800b5c <memmove+0x48>
  800b2a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b2d:	39 c2                	cmp    %eax,%edx
  800b2f:	76 2b                	jbe    800b5c <memmove+0x48>
		s += n;
		d += n;
  800b31:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b34:	89 fe                	mov    %edi,%esi
  800b36:	09 ce                	or     %ecx,%esi
  800b38:	09 d6                	or     %edx,%esi
  800b3a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b40:	75 0e                	jne    800b50 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b42:	83 ef 04             	sub    $0x4,%edi
  800b45:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b48:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b4b:	fd                   	std    
  800b4c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b4e:	eb 09                	jmp    800b59 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b50:	83 ef 01             	sub    $0x1,%edi
  800b53:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b56:	fd                   	std    
  800b57:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b59:	fc                   	cld    
  800b5a:	eb 1a                	jmp    800b76 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b5c:	89 c2                	mov    %eax,%edx
  800b5e:	09 ca                	or     %ecx,%edx
  800b60:	09 f2                	or     %esi,%edx
  800b62:	f6 c2 03             	test   $0x3,%dl
  800b65:	75 0a                	jne    800b71 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b67:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b6a:	89 c7                	mov    %eax,%edi
  800b6c:	fc                   	cld    
  800b6d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b6f:	eb 05                	jmp    800b76 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b71:	89 c7                	mov    %eax,%edi
  800b73:	fc                   	cld    
  800b74:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b76:	5e                   	pop    %esi
  800b77:	5f                   	pop    %edi
  800b78:	5d                   	pop    %ebp
  800b79:	c3                   	ret    

00800b7a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b7a:	f3 0f 1e fb          	endbr32 
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b84:	ff 75 10             	pushl  0x10(%ebp)
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	ff 75 08             	pushl  0x8(%ebp)
  800b8d:	e8 82 ff ff ff       	call   800b14 <memmove>
}
  800b92:	c9                   	leave  
  800b93:	c3                   	ret    

00800b94 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b94:	f3 0f 1e fb          	endbr32 
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	56                   	push   %esi
  800b9c:	53                   	push   %ebx
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba3:	89 c6                	mov    %eax,%esi
  800ba5:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ba8:	39 f0                	cmp    %esi,%eax
  800baa:	74 1c                	je     800bc8 <memcmp+0x34>
		if (*s1 != *s2)
  800bac:	0f b6 08             	movzbl (%eax),%ecx
  800baf:	0f b6 1a             	movzbl (%edx),%ebx
  800bb2:	38 d9                	cmp    %bl,%cl
  800bb4:	75 08                	jne    800bbe <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bb6:	83 c0 01             	add    $0x1,%eax
  800bb9:	83 c2 01             	add    $0x1,%edx
  800bbc:	eb ea                	jmp    800ba8 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800bbe:	0f b6 c1             	movzbl %cl,%eax
  800bc1:	0f b6 db             	movzbl %bl,%ebx
  800bc4:	29 d8                	sub    %ebx,%eax
  800bc6:	eb 05                	jmp    800bcd <memcmp+0x39>
	}

	return 0;
  800bc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bcd:	5b                   	pop    %ebx
  800bce:	5e                   	pop    %esi
  800bcf:	5d                   	pop    %ebp
  800bd0:	c3                   	ret    

00800bd1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bd1:	f3 0f 1e fb          	endbr32 
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bde:	89 c2                	mov    %eax,%edx
  800be0:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800be3:	39 d0                	cmp    %edx,%eax
  800be5:	73 09                	jae    800bf0 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800be7:	38 08                	cmp    %cl,(%eax)
  800be9:	74 05                	je     800bf0 <memfind+0x1f>
	for (; s < ends; s++)
  800beb:	83 c0 01             	add    $0x1,%eax
  800bee:	eb f3                	jmp    800be3 <memfind+0x12>
			break;
	return (void *) s;
}
  800bf0:	5d                   	pop    %ebp
  800bf1:	c3                   	ret    

00800bf2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bf2:	f3 0f 1e fb          	endbr32 
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	57                   	push   %edi
  800bfa:	56                   	push   %esi
  800bfb:	53                   	push   %ebx
  800bfc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bff:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c02:	eb 03                	jmp    800c07 <strtol+0x15>
		s++;
  800c04:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c07:	0f b6 01             	movzbl (%ecx),%eax
  800c0a:	3c 20                	cmp    $0x20,%al
  800c0c:	74 f6                	je     800c04 <strtol+0x12>
  800c0e:	3c 09                	cmp    $0x9,%al
  800c10:	74 f2                	je     800c04 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800c12:	3c 2b                	cmp    $0x2b,%al
  800c14:	74 2a                	je     800c40 <strtol+0x4e>
	int neg = 0;
  800c16:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c1b:	3c 2d                	cmp    $0x2d,%al
  800c1d:	74 2b                	je     800c4a <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c1f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c25:	75 0f                	jne    800c36 <strtol+0x44>
  800c27:	80 39 30             	cmpb   $0x30,(%ecx)
  800c2a:	74 28                	je     800c54 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c2c:	85 db                	test   %ebx,%ebx
  800c2e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c33:	0f 44 d8             	cmove  %eax,%ebx
  800c36:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c3e:	eb 46                	jmp    800c86 <strtol+0x94>
		s++;
  800c40:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c43:	bf 00 00 00 00       	mov    $0x0,%edi
  800c48:	eb d5                	jmp    800c1f <strtol+0x2d>
		s++, neg = 1;
  800c4a:	83 c1 01             	add    $0x1,%ecx
  800c4d:	bf 01 00 00 00       	mov    $0x1,%edi
  800c52:	eb cb                	jmp    800c1f <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c54:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c58:	74 0e                	je     800c68 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c5a:	85 db                	test   %ebx,%ebx
  800c5c:	75 d8                	jne    800c36 <strtol+0x44>
		s++, base = 8;
  800c5e:	83 c1 01             	add    $0x1,%ecx
  800c61:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c66:	eb ce                	jmp    800c36 <strtol+0x44>
		s += 2, base = 16;
  800c68:	83 c1 02             	add    $0x2,%ecx
  800c6b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c70:	eb c4                	jmp    800c36 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c72:	0f be d2             	movsbl %dl,%edx
  800c75:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c78:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c7b:	7d 3a                	jge    800cb7 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c7d:	83 c1 01             	add    $0x1,%ecx
  800c80:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c84:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c86:	0f b6 11             	movzbl (%ecx),%edx
  800c89:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c8c:	89 f3                	mov    %esi,%ebx
  800c8e:	80 fb 09             	cmp    $0x9,%bl
  800c91:	76 df                	jbe    800c72 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c93:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c96:	89 f3                	mov    %esi,%ebx
  800c98:	80 fb 19             	cmp    $0x19,%bl
  800c9b:	77 08                	ja     800ca5 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c9d:	0f be d2             	movsbl %dl,%edx
  800ca0:	83 ea 57             	sub    $0x57,%edx
  800ca3:	eb d3                	jmp    800c78 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800ca5:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ca8:	89 f3                	mov    %esi,%ebx
  800caa:	80 fb 19             	cmp    $0x19,%bl
  800cad:	77 08                	ja     800cb7 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800caf:	0f be d2             	movsbl %dl,%edx
  800cb2:	83 ea 37             	sub    $0x37,%edx
  800cb5:	eb c1                	jmp    800c78 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cb7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cbb:	74 05                	je     800cc2 <strtol+0xd0>
		*endptr = (char *) s;
  800cbd:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cc0:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cc2:	89 c2                	mov    %eax,%edx
  800cc4:	f7 da                	neg    %edx
  800cc6:	85 ff                	test   %edi,%edi
  800cc8:	0f 45 c2             	cmovne %edx,%eax
}
  800ccb:	5b                   	pop    %ebx
  800ccc:	5e                   	pop    %esi
  800ccd:	5f                   	pop    %edi
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    

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
