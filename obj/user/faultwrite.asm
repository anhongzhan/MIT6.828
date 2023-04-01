
obj/user/faultwrite:     file format elf32-i386


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
  80002c:	e8 11 00 00 00       	call   800042 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
	*(unsigned*)0 = 0;
  800037:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80003e:	00 00 00 
}
  800041:	c3                   	ret    

00800042 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800042:	f3 0f 1e fb          	endbr32 
  800046:	55                   	push   %ebp
  800047:	89 e5                	mov    %esp,%ebp
  800049:	57                   	push   %edi
  80004a:	56                   	push   %esi
  80004b:	53                   	push   %ebx
  80004c:	83 ec 0c             	sub    $0xc,%esp
  80004f:	e8 50 00 00 00       	call   8000a4 <__x86.get_pc_thunk.bx>
  800054:	81 c3 ac 1f 00 00    	add    $0x1fac,%ebx
  80005a:	8b 75 08             	mov    0x8(%ebp),%esi
  80005d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800060:	e8 06 01 00 00       	call   80016b <sys_getenvid>
  800065:	25 ff 03 00 00       	and    $0x3ff,%eax
  80006a:	8d 04 40             	lea    (%eax,%eax,2),%eax
  80006d:	c1 e0 05             	shl    $0x5,%eax
  800070:	81 c0 00 00 c0 ee    	add    $0xeec00000,%eax
  800076:	c7 c2 2c 20 80 00    	mov    $0x80202c,%edx
  80007c:	89 02                	mov    %eax,(%edx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80007e:	85 f6                	test   %esi,%esi
  800080:	7e 08                	jle    80008a <libmain+0x48>
		binaryname = argv[0];
  800082:	8b 07                	mov    (%edi),%eax
  800084:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  80008a:	83 ec 08             	sub    $0x8,%esp
  80008d:	57                   	push   %edi
  80008e:	56                   	push   %esi
  80008f:	e8 9f ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800094:	e8 0f 00 00 00       	call   8000a8 <exit>
}
  800099:	83 c4 10             	add    $0x10,%esp
  80009c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80009f:	5b                   	pop    %ebx
  8000a0:	5e                   	pop    %esi
  8000a1:	5f                   	pop    %edi
  8000a2:	5d                   	pop    %ebp
  8000a3:	c3                   	ret    

008000a4 <__x86.get_pc_thunk.bx>:
  8000a4:	8b 1c 24             	mov    (%esp),%ebx
  8000a7:	c3                   	ret    

008000a8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a8:	f3 0f 1e fb          	endbr32 
  8000ac:	55                   	push   %ebp
  8000ad:	89 e5                	mov    %esp,%ebp
  8000af:	53                   	push   %ebx
  8000b0:	83 ec 10             	sub    $0x10,%esp
  8000b3:	e8 ec ff ff ff       	call   8000a4 <__x86.get_pc_thunk.bx>
  8000b8:	81 c3 48 1f 00 00    	add    $0x1f48,%ebx
	sys_env_destroy(0);
  8000be:	6a 00                	push   $0x0
  8000c0:	e8 4d 00 00 00       	call   800112 <sys_env_destroy>
}
  8000c5:	83 c4 10             	add    $0x10,%esp
  8000c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000cb:	c9                   	leave  
  8000cc:	c3                   	ret    

008000cd <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000cd:	f3 0f 1e fb          	endbr32 
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	57                   	push   %edi
  8000d5:	56                   	push   %esi
  8000d6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8000df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000e2:	89 c3                	mov    %eax,%ebx
  8000e4:	89 c7                	mov    %eax,%edi
  8000e6:	89 c6                	mov    %eax,%esi
  8000e8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000ea:	5b                   	pop    %ebx
  8000eb:	5e                   	pop    %esi
  8000ec:	5f                   	pop    %edi
  8000ed:	5d                   	pop    %ebp
  8000ee:	c3                   	ret    

008000ef <sys_cgetc>:

int
sys_cgetc(void)
{
  8000ef:	f3 0f 1e fb          	endbr32 
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	57                   	push   %edi
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000fe:	b8 01 00 00 00       	mov    $0x1,%eax
  800103:	89 d1                	mov    %edx,%ecx
  800105:	89 d3                	mov    %edx,%ebx
  800107:	89 d7                	mov    %edx,%edi
  800109:	89 d6                	mov    %edx,%esi
  80010b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80010d:	5b                   	pop    %ebx
  80010e:	5e                   	pop    %esi
  80010f:	5f                   	pop    %edi
  800110:	5d                   	pop    %ebp
  800111:	c3                   	ret    

00800112 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800112:	f3 0f 1e fb          	endbr32 
  800116:	55                   	push   %ebp
  800117:	89 e5                	mov    %esp,%ebp
  800119:	57                   	push   %edi
  80011a:	56                   	push   %esi
  80011b:	53                   	push   %ebx
  80011c:	83 ec 1c             	sub    $0x1c,%esp
  80011f:	e8 6a 00 00 00       	call   80018e <__x86.get_pc_thunk.ax>
  800124:	05 dc 1e 00 00       	add    $0x1edc,%eax
  800129:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("int %1\n"
  80012c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800131:	8b 55 08             	mov    0x8(%ebp),%edx
  800134:	b8 03 00 00 00       	mov    $0x3,%eax
  800139:	89 cb                	mov    %ecx,%ebx
  80013b:	89 cf                	mov    %ecx,%edi
  80013d:	89 ce                	mov    %ecx,%esi
  80013f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800141:	85 c0                	test   %eax,%eax
  800143:	7f 08                	jg     80014d <sys_env_destroy+0x3b>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800145:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800148:	5b                   	pop    %ebx
  800149:	5e                   	pop    %esi
  80014a:	5f                   	pop    %edi
  80014b:	5d                   	pop    %ebp
  80014c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80014d:	83 ec 0c             	sub    $0xc,%esp
  800150:	50                   	push   %eax
  800151:	6a 03                	push   $0x3
  800153:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800156:	8d 83 2a ef ff ff    	lea    -0x10d6(%ebx),%eax
  80015c:	50                   	push   %eax
  80015d:	6a 23                	push   $0x23
  80015f:	8d 83 47 ef ff ff    	lea    -0x10b9(%ebx),%eax
  800165:	50                   	push   %eax
  800166:	e8 27 00 00 00       	call   800192 <_panic>

0080016b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80016b:	f3 0f 1e fb          	endbr32 
  80016f:	55                   	push   %ebp
  800170:	89 e5                	mov    %esp,%ebp
  800172:	57                   	push   %edi
  800173:	56                   	push   %esi
  800174:	53                   	push   %ebx
	asm volatile("int %1\n"
  800175:	ba 00 00 00 00       	mov    $0x0,%edx
  80017a:	b8 02 00 00 00       	mov    $0x2,%eax
  80017f:	89 d1                	mov    %edx,%ecx
  800181:	89 d3                	mov    %edx,%ebx
  800183:	89 d7                	mov    %edx,%edi
  800185:	89 d6                	mov    %edx,%esi
  800187:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800189:	5b                   	pop    %ebx
  80018a:	5e                   	pop    %esi
  80018b:	5f                   	pop    %edi
  80018c:	5d                   	pop    %ebp
  80018d:	c3                   	ret    

0080018e <__x86.get_pc_thunk.ax>:
  80018e:	8b 04 24             	mov    (%esp),%eax
  800191:	c3                   	ret    

00800192 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800192:	f3 0f 1e fb          	endbr32 
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	57                   	push   %edi
  80019a:	56                   	push   %esi
  80019b:	53                   	push   %ebx
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	e8 00 ff ff ff       	call   8000a4 <__x86.get_pc_thunk.bx>
  8001a4:	81 c3 5c 1e 00 00    	add    $0x1e5c,%ebx
	va_list ap;

	va_start(ap, fmt);
  8001aa:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001ad:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  8001b3:	8b 38                	mov    (%eax),%edi
  8001b5:	e8 b1 ff ff ff       	call   80016b <sys_getenvid>
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	ff 75 0c             	pushl  0xc(%ebp)
  8001c0:	ff 75 08             	pushl  0x8(%ebp)
  8001c3:	57                   	push   %edi
  8001c4:	50                   	push   %eax
  8001c5:	8d 83 58 ef ff ff    	lea    -0x10a8(%ebx),%eax
  8001cb:	50                   	push   %eax
  8001cc:	e8 d9 00 00 00       	call   8002aa <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001d1:	83 c4 18             	add    $0x18,%esp
  8001d4:	56                   	push   %esi
  8001d5:	ff 75 10             	pushl  0x10(%ebp)
  8001d8:	e8 67 00 00 00       	call   800244 <vcprintf>
	cprintf("\n");
  8001dd:	8d 83 7b ef ff ff    	lea    -0x1085(%ebx),%eax
  8001e3:	89 04 24             	mov    %eax,(%esp)
  8001e6:	e8 bf 00 00 00       	call   8002aa <cprintf>
  8001eb:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001ee:	cc                   	int3   
  8001ef:	eb fd                	jmp    8001ee <_panic+0x5c>

008001f1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001f1:	f3 0f 1e fb          	endbr32 
  8001f5:	55                   	push   %ebp
  8001f6:	89 e5                	mov    %esp,%ebp
  8001f8:	56                   	push   %esi
  8001f9:	53                   	push   %ebx
  8001fa:	e8 a5 fe ff ff       	call   8000a4 <__x86.get_pc_thunk.bx>
  8001ff:	81 c3 01 1e 00 00    	add    $0x1e01,%ebx
  800205:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  800208:	8b 16                	mov    (%esi),%edx
  80020a:	8d 42 01             	lea    0x1(%edx),%eax
  80020d:	89 06                	mov    %eax,(%esi)
  80020f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800212:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  800216:	3d ff 00 00 00       	cmp    $0xff,%eax
  80021b:	74 0b                	je     800228 <putch+0x37>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80021d:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  800221:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800224:	5b                   	pop    %ebx
  800225:	5e                   	pop    %esi
  800226:	5d                   	pop    %ebp
  800227:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800228:	83 ec 08             	sub    $0x8,%esp
  80022b:	68 ff 00 00 00       	push   $0xff
  800230:	8d 46 08             	lea    0x8(%esi),%eax
  800233:	50                   	push   %eax
  800234:	e8 94 fe ff ff       	call   8000cd <sys_cputs>
		b->idx = 0;
  800239:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	eb d9                	jmp    80021d <putch+0x2c>

00800244 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800244:	f3 0f 1e fb          	endbr32 
  800248:	55                   	push   %ebp
  800249:	89 e5                	mov    %esp,%ebp
  80024b:	53                   	push   %ebx
  80024c:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800252:	e8 4d fe ff ff       	call   8000a4 <__x86.get_pc_thunk.bx>
  800257:	81 c3 a9 1d 00 00    	add    $0x1da9,%ebx
	struct printbuf b;

	b.idx = 0;
  80025d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800264:	00 00 00 
	b.cnt = 0;
  800267:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80026e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800271:	ff 75 0c             	pushl  0xc(%ebp)
  800274:	ff 75 08             	pushl  0x8(%ebp)
  800277:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80027d:	50                   	push   %eax
  80027e:	8d 83 f1 e1 ff ff    	lea    -0x1e0f(%ebx),%eax
  800284:	50                   	push   %eax
  800285:	e8 38 01 00 00       	call   8003c2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80028a:	83 c4 08             	add    $0x8,%esp
  80028d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800293:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800299:	50                   	push   %eax
  80029a:	e8 2e fe ff ff       	call   8000cd <sys_cputs>

	return b.cnt;
}
  80029f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002a8:	c9                   	leave  
  8002a9:	c3                   	ret    

008002aa <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002aa:	f3 0f 1e fb          	endbr32 
  8002ae:	55                   	push   %ebp
  8002af:	89 e5                	mov    %esp,%ebp
  8002b1:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002b4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002b7:	50                   	push   %eax
  8002b8:	ff 75 08             	pushl  0x8(%ebp)
  8002bb:	e8 84 ff ff ff       	call   800244 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	57                   	push   %edi
  8002c6:	56                   	push   %esi
  8002c7:	53                   	push   %ebx
  8002c8:	83 ec 2c             	sub    $0x2c,%esp
  8002cb:	e8 28 06 00 00       	call   8008f8 <__x86.get_pc_thunk.cx>
  8002d0:	81 c1 30 1d 00 00    	add    $0x1d30,%ecx
  8002d6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002d9:	89 c7                	mov    %eax,%edi
  8002db:	89 d6                	mov    %edx,%esi
  8002dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e3:	89 d1                	mov    %edx,%ecx
  8002e5:	89 c2                	mov    %eax,%edx
  8002e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002ea:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8002ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f0:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800302:	72 41                	jb     800345 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	ff 75 18             	pushl  0x18(%ebp)
  80030a:	83 eb 01             	sub    $0x1,%ebx
  80030d:	53                   	push   %ebx
  80030e:	50                   	push   %eax
  80030f:	83 ec 08             	sub    $0x8,%esp
  800312:	ff 75 e4             	pushl  -0x1c(%ebp)
  800315:	ff 75 e0             	pushl  -0x20(%ebp)
  800318:	ff 75 d4             	pushl  -0x2c(%ebp)
  80031b:	ff 75 d0             	pushl  -0x30(%ebp)
  80031e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800321:	e8 9a 09 00 00       	call   800cc0 <__udivdi3>
  800326:	83 c4 18             	add    $0x18,%esp
  800329:	52                   	push   %edx
  80032a:	50                   	push   %eax
  80032b:	89 f2                	mov    %esi,%edx
  80032d:	89 f8                	mov    %edi,%eax
  80032f:	e8 8e ff ff ff       	call   8002c2 <printnum>
  800334:	83 c4 20             	add    $0x20,%esp
  800337:	eb 13                	jmp    80034c <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800339:	83 ec 08             	sub    $0x8,%esp
  80033c:	56                   	push   %esi
  80033d:	ff 75 18             	pushl  0x18(%ebp)
  800340:	ff d7                	call   *%edi
  800342:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800345:	83 eb 01             	sub    $0x1,%ebx
  800348:	85 db                	test   %ebx,%ebx
  80034a:	7f ed                	jg     800339 <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80034c:	83 ec 08             	sub    $0x8,%esp
  80034f:	56                   	push   %esi
  800350:	83 ec 04             	sub    $0x4,%esp
  800353:	ff 75 e4             	pushl  -0x1c(%ebp)
  800356:	ff 75 e0             	pushl  -0x20(%ebp)
  800359:	ff 75 d4             	pushl  -0x2c(%ebp)
  80035c:	ff 75 d0             	pushl  -0x30(%ebp)
  80035f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800362:	e8 69 0a 00 00       	call   800dd0 <__umoddi3>
  800367:	83 c4 14             	add    $0x14,%esp
  80036a:	0f be 84 03 7d ef ff 	movsbl -0x1083(%ebx,%eax,1),%eax
  800371:	ff 
  800372:	50                   	push   %eax
  800373:	ff d7                	call   *%edi
}
  800375:	83 c4 10             	add    $0x10,%esp
  800378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80037b:	5b                   	pop    %ebx
  80037c:	5e                   	pop    %esi
  80037d:	5f                   	pop    %edi
  80037e:	5d                   	pop    %ebp
  80037f:	c3                   	ret    

00800380 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800380:	f3 0f 1e fb          	endbr32 
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80038a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80038e:	8b 10                	mov    (%eax),%edx
  800390:	3b 50 04             	cmp    0x4(%eax),%edx
  800393:	73 0a                	jae    80039f <sprintputch+0x1f>
		*b->buf++ = ch;
  800395:	8d 4a 01             	lea    0x1(%edx),%ecx
  800398:	89 08                	mov    %ecx,(%eax)
  80039a:	8b 45 08             	mov    0x8(%ebp),%eax
  80039d:	88 02                	mov    %al,(%edx)
}
  80039f:	5d                   	pop    %ebp
  8003a0:	c3                   	ret    

008003a1 <printfmt>:
{
  8003a1:	f3 0f 1e fb          	endbr32 
  8003a5:	55                   	push   %ebp
  8003a6:	89 e5                	mov    %esp,%ebp
  8003a8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003ab:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003ae:	50                   	push   %eax
  8003af:	ff 75 10             	pushl  0x10(%ebp)
  8003b2:	ff 75 0c             	pushl  0xc(%ebp)
  8003b5:	ff 75 08             	pushl  0x8(%ebp)
  8003b8:	e8 05 00 00 00       	call   8003c2 <vprintfmt>
}
  8003bd:	83 c4 10             	add    $0x10,%esp
  8003c0:	c9                   	leave  
  8003c1:	c3                   	ret    

008003c2 <vprintfmt>:
{
  8003c2:	f3 0f 1e fb          	endbr32 
  8003c6:	55                   	push   %ebp
  8003c7:	89 e5                	mov    %esp,%ebp
  8003c9:	57                   	push   %edi
  8003ca:	56                   	push   %esi
  8003cb:	53                   	push   %ebx
  8003cc:	83 ec 3c             	sub    $0x3c,%esp
  8003cf:	e8 ba fd ff ff       	call   80018e <__x86.get_pc_thunk.ax>
  8003d4:	05 2c 1c 00 00       	add    $0x1c2c,%eax
  8003d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003dc:	8b 75 08             	mov    0x8(%ebp),%esi
  8003df:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e5:	8d 80 10 00 00 00    	lea    0x10(%eax),%eax
  8003eb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8003ee:	e9 cd 03 00 00       	jmp    8007c0 <.L25+0x48>
		padc = ' ';
  8003f3:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
  8003f7:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003fe:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800405:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  80040c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800411:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800414:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800417:	8d 43 01             	lea    0x1(%ebx),%eax
  80041a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80041d:	0f b6 13             	movzbl (%ebx),%edx
  800420:	8d 42 dd             	lea    -0x23(%edx),%eax
  800423:	3c 55                	cmp    $0x55,%al
  800425:	0f 87 21 04 00 00    	ja     80084c <.L20>
  80042b:	0f b6 c0             	movzbl %al,%eax
  80042e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800431:	89 ce                	mov    %ecx,%esi
  800433:	03 b4 81 0c f0 ff ff 	add    -0xff4(%ecx,%eax,4),%esi
  80043a:	3e ff e6             	notrack jmp *%esi

0080043d <.L68>:
  80043d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
  800440:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800444:	eb d1                	jmp    800417 <vprintfmt+0x55>

00800446 <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
  800446:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800449:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80044d:	eb c8                	jmp    800417 <vprintfmt+0x55>

0080044f <.L31>:
  80044f:	0f b6 d2             	movzbl %dl,%edx
  800452:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
  800455:	b8 00 00 00 00       	mov    $0x0,%eax
  80045a:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
  80045d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800460:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800464:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800467:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80046a:	83 f9 09             	cmp    $0x9,%ecx
  80046d:	77 58                	ja     8004c7 <.L36+0xf>
			for (precision = 0; ; ++fmt) {
  80046f:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800472:	eb e9                	jmp    80045d <.L31+0xe>

00800474 <.L34>:
			precision = va_arg(ap, int);
  800474:	8b 45 14             	mov    0x14(%ebp),%eax
  800477:	8b 00                	mov    (%eax),%eax
  800479:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80047c:	8b 45 14             	mov    0x14(%ebp),%eax
  80047f:	8d 40 04             	lea    0x4(%eax),%eax
  800482:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800485:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
  800488:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80048c:	79 89                	jns    800417 <vprintfmt+0x55>
				width = precision, precision = -1;
  80048e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800491:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800494:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80049b:	e9 77 ff ff ff       	jmp    800417 <vprintfmt+0x55>

008004a0 <.L33>:
  8004a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004a3:	85 c0                	test   %eax,%eax
  8004a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8004aa:	0f 49 d0             	cmovns %eax,%edx
  8004ad:	89 55 d4             	mov    %edx,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004b0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004b3:	e9 5f ff ff ff       	jmp    800417 <vprintfmt+0x55>

008004b8 <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
  8004b8:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
  8004bb:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004c2:	e9 50 ff ff ff       	jmp    800417 <vprintfmt+0x55>
  8004c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ca:	89 75 08             	mov    %esi,0x8(%ebp)
  8004cd:	eb b9                	jmp    800488 <.L34+0x14>

008004cf <.L27>:
			lflag++;
  8004cf:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004d6:	e9 3c ff ff ff       	jmp    800417 <vprintfmt+0x55>

008004db <.L30>:
  8004db:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(va_arg(ap, int), putdat);
  8004de:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e1:	8d 58 04             	lea    0x4(%eax),%ebx
  8004e4:	83 ec 08             	sub    $0x8,%esp
  8004e7:	57                   	push   %edi
  8004e8:	ff 30                	pushl  (%eax)
  8004ea:	ff d6                	call   *%esi
			break;
  8004ec:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004ef:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
  8004f2:	e9 c6 02 00 00       	jmp    8007bd <.L25+0x45>

008004f7 <.L28>:
  8004f7:	8b 75 08             	mov    0x8(%ebp),%esi
			err = va_arg(ap, int);
  8004fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fd:	8d 58 04             	lea    0x4(%eax),%ebx
  800500:	8b 00                	mov    (%eax),%eax
  800502:	99                   	cltd   
  800503:	31 d0                	xor    %edx,%eax
  800505:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800507:	83 f8 06             	cmp    $0x6,%eax
  80050a:	7f 27                	jg     800533 <.L28+0x3c>
  80050c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80050f:	8b 14 82             	mov    (%edx,%eax,4),%edx
  800512:	85 d2                	test   %edx,%edx
  800514:	74 1d                	je     800533 <.L28+0x3c>
				printfmt(putch, putdat, "%s", p);
  800516:	52                   	push   %edx
  800517:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80051a:	8d 80 9e ef ff ff    	lea    -0x1062(%eax),%eax
  800520:	50                   	push   %eax
  800521:	57                   	push   %edi
  800522:	56                   	push   %esi
  800523:	e8 79 fe ff ff       	call   8003a1 <printfmt>
  800528:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80052b:	89 5d 14             	mov    %ebx,0x14(%ebp)
  80052e:	e9 8a 02 00 00       	jmp    8007bd <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
  800533:	50                   	push   %eax
  800534:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800537:	8d 80 95 ef ff ff    	lea    -0x106b(%eax),%eax
  80053d:	50                   	push   %eax
  80053e:	57                   	push   %edi
  80053f:	56                   	push   %esi
  800540:	e8 5c fe ff ff       	call   8003a1 <printfmt>
  800545:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800548:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80054b:	e9 6d 02 00 00       	jmp    8007bd <.L25+0x45>

00800550 <.L24>:
  800550:	8b 75 08             	mov    0x8(%ebp),%esi
			if ((p = va_arg(ap, char *)) == NULL)
  800553:	8b 45 14             	mov    0x14(%ebp),%eax
  800556:	83 c0 04             	add    $0x4,%eax
  800559:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80055c:	8b 45 14             	mov    0x14(%ebp),%eax
  80055f:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800561:	85 d2                	test   %edx,%edx
  800563:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800566:	8d 80 8e ef ff ff    	lea    -0x1072(%eax),%eax
  80056c:	0f 45 c2             	cmovne %edx,%eax
  80056f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800572:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800576:	7e 06                	jle    80057e <.L24+0x2e>
  800578:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80057c:	75 0d                	jne    80058b <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
  80057e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800581:	89 c3                	mov    %eax,%ebx
  800583:	03 45 d4             	add    -0x2c(%ebp),%eax
  800586:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800589:	eb 58                	jmp    8005e3 <.L24+0x93>
  80058b:	83 ec 08             	sub    $0x8,%esp
  80058e:	ff 75 d8             	pushl  -0x28(%ebp)
  800591:	ff 75 c8             	pushl  -0x38(%ebp)
  800594:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800597:	e8 7c 03 00 00       	call   800918 <strnlen>
  80059c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80059f:	29 c2                	sub    %eax,%edx
  8005a1:	89 55 bc             	mov    %edx,-0x44(%ebp)
  8005a4:	83 c4 10             	add    $0x10,%esp
  8005a7:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
  8005a9:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005ad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b0:	85 db                	test   %ebx,%ebx
  8005b2:	7e 11                	jle    8005c5 <.L24+0x75>
					putch(padc, putdat);
  8005b4:	83 ec 08             	sub    $0x8,%esp
  8005b7:	57                   	push   %edi
  8005b8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8005bb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005bd:	83 eb 01             	sub    $0x1,%ebx
  8005c0:	83 c4 10             	add    $0x10,%esp
  8005c3:	eb eb                	jmp    8005b0 <.L24+0x60>
  8005c5:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8005c8:	85 d2                	test   %edx,%edx
  8005ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8005cf:	0f 49 c2             	cmovns %edx,%eax
  8005d2:	29 c2                	sub    %eax,%edx
  8005d4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005d7:	eb a5                	jmp    80057e <.L24+0x2e>
					putch(ch, putdat);
  8005d9:	83 ec 08             	sub    $0x8,%esp
  8005dc:	57                   	push   %edi
  8005dd:	52                   	push   %edx
  8005de:	ff d6                	call   *%esi
  8005e0:	83 c4 10             	add    $0x10,%esp
  8005e3:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005e6:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005e8:	83 c3 01             	add    $0x1,%ebx
  8005eb:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8005ef:	0f be d0             	movsbl %al,%edx
  8005f2:	85 d2                	test   %edx,%edx
  8005f4:	74 4b                	je     800641 <.L24+0xf1>
  8005f6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005fa:	78 06                	js     800602 <.L24+0xb2>
  8005fc:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800600:	78 1e                	js     800620 <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
  800602:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800606:	74 d1                	je     8005d9 <.L24+0x89>
  800608:	0f be c0             	movsbl %al,%eax
  80060b:	83 e8 20             	sub    $0x20,%eax
  80060e:	83 f8 5e             	cmp    $0x5e,%eax
  800611:	76 c6                	jbe    8005d9 <.L24+0x89>
					putch('?', putdat);
  800613:	83 ec 08             	sub    $0x8,%esp
  800616:	57                   	push   %edi
  800617:	6a 3f                	push   $0x3f
  800619:	ff d6                	call   *%esi
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	eb c3                	jmp    8005e3 <.L24+0x93>
  800620:	89 cb                	mov    %ecx,%ebx
  800622:	eb 0e                	jmp    800632 <.L24+0xe2>
				putch(' ', putdat);
  800624:	83 ec 08             	sub    $0x8,%esp
  800627:	57                   	push   %edi
  800628:	6a 20                	push   $0x20
  80062a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80062c:	83 eb 01             	sub    $0x1,%ebx
  80062f:	83 c4 10             	add    $0x10,%esp
  800632:	85 db                	test   %ebx,%ebx
  800634:	7f ee                	jg     800624 <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
  800636:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800639:	89 45 14             	mov    %eax,0x14(%ebp)
  80063c:	e9 7c 01 00 00       	jmp    8007bd <.L25+0x45>
  800641:	89 cb                	mov    %ecx,%ebx
  800643:	eb ed                	jmp    800632 <.L24+0xe2>

00800645 <.L29>:
  800645:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800648:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  80064b:	83 f9 01             	cmp    $0x1,%ecx
  80064e:	7f 1b                	jg     80066b <.L29+0x26>
	else if (lflag)
  800650:	85 c9                	test   %ecx,%ecx
  800652:	74 63                	je     8006b7 <.L29+0x72>
		return va_arg(*ap, long);
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8b 00                	mov    (%eax),%eax
  800659:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065c:	99                   	cltd   
  80065d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8d 40 04             	lea    0x4(%eax),%eax
  800666:	89 45 14             	mov    %eax,0x14(%ebp)
  800669:	eb 17                	jmp    800682 <.L29+0x3d>
		return va_arg(*ap, long long);
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8b 50 04             	mov    0x4(%eax),%edx
  800671:	8b 00                	mov    (%eax),%eax
  800673:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800676:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	8d 40 08             	lea    0x8(%eax),%eax
  80067f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800682:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800685:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800688:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80068d:	85 c9                	test   %ecx,%ecx
  80068f:	0f 89 0e 01 00 00    	jns    8007a3 <.L25+0x2b>
				putch('-', putdat);
  800695:	83 ec 08             	sub    $0x8,%esp
  800698:	57                   	push   %edi
  800699:	6a 2d                	push   $0x2d
  80069b:	ff d6                	call   *%esi
				num = -(long long) num;
  80069d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006a0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006a3:	f7 da                	neg    %edx
  8006a5:	83 d1 00             	adc    $0x0,%ecx
  8006a8:	f7 d9                	neg    %ecx
  8006aa:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006ad:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b2:	e9 ec 00 00 00       	jmp    8007a3 <.L25+0x2b>
		return va_arg(*ap, int);
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bf:	99                   	cltd   
  8006c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8d 40 04             	lea    0x4(%eax),%eax
  8006c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006cc:	eb b4                	jmp    800682 <.L29+0x3d>

008006ce <.L23>:
  8006ce:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006d1:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  8006d4:	83 f9 01             	cmp    $0x1,%ecx
  8006d7:	7f 1e                	jg     8006f7 <.L23+0x29>
	else if (lflag)
  8006d9:	85 c9                	test   %ecx,%ecx
  8006db:	74 32                	je     80070f <.L23+0x41>
		return va_arg(*ap, unsigned long);
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8b 10                	mov    (%eax),%edx
  8006e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ed:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8006f2:	e9 ac 00 00 00       	jmp    8007a3 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	8b 10                	mov    (%eax),%edx
  8006fc:	8b 48 04             	mov    0x4(%eax),%ecx
  8006ff:	8d 40 08             	lea    0x8(%eax),%eax
  800702:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800705:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80070a:	e9 94 00 00 00       	jmp    8007a3 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8b 10                	mov    (%eax),%edx
  800714:	b9 00 00 00 00       	mov    $0x0,%ecx
  800719:	8d 40 04             	lea    0x4(%eax),%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80071f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800724:	eb 7d                	jmp    8007a3 <.L25+0x2b>

00800726 <.L26>:
  800726:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800729:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  80072c:	83 f9 01             	cmp    $0x1,%ecx
  80072f:	7f 1b                	jg     80074c <.L26+0x26>
	else if (lflag)
  800731:	85 c9                	test   %ecx,%ecx
  800733:	74 2c                	je     800761 <.L26+0x3b>
		return va_arg(*ap, unsigned long);
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8b 10                	mov    (%eax),%edx
  80073a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80073f:	8d 40 04             	lea    0x4(%eax),%eax
  800742:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800745:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80074a:	eb 57                	jmp    8007a3 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	8b 10                	mov    (%eax),%edx
  800751:	8b 48 04             	mov    0x4(%eax),%ecx
  800754:	8d 40 08             	lea    0x8(%eax),%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80075f:	eb 42                	jmp    8007a3 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	8b 10                	mov    (%eax),%edx
  800766:	b9 00 00 00 00       	mov    $0x0,%ecx
  80076b:	8d 40 04             	lea    0x4(%eax),%eax
  80076e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800771:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800776:	eb 2b                	jmp    8007a3 <.L25+0x2b>

00800778 <.L25>:
  800778:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('0', putdat);
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	57                   	push   %edi
  80077f:	6a 30                	push   $0x30
  800781:	ff d6                	call   *%esi
			putch('x', putdat);
  800783:	83 c4 08             	add    $0x8,%esp
  800786:	57                   	push   %edi
  800787:	6a 78                	push   $0x78
  800789:	ff d6                	call   *%esi
			num = (unsigned long long)
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8b 10                	mov    (%eax),%edx
  800790:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800795:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800798:	8d 40 04             	lea    0x4(%eax),%eax
  80079b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007a3:	83 ec 0c             	sub    $0xc,%esp
  8007a6:	0f be 5d cf          	movsbl -0x31(%ebp),%ebx
  8007aa:	53                   	push   %ebx
  8007ab:	ff 75 d4             	pushl  -0x2c(%ebp)
  8007ae:	50                   	push   %eax
  8007af:	51                   	push   %ecx
  8007b0:	52                   	push   %edx
  8007b1:	89 fa                	mov    %edi,%edx
  8007b3:	89 f0                	mov    %esi,%eax
  8007b5:	e8 08 fb ff ff       	call   8002c2 <printnum>
			break;
  8007ba:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007bd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c0:	83 c3 01             	add    $0x1,%ebx
  8007c3:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8007c7:	83 f8 25             	cmp    $0x25,%eax
  8007ca:	0f 84 23 fc ff ff    	je     8003f3 <vprintfmt+0x31>
			if (ch == '\0')
  8007d0:	85 c0                	test   %eax,%eax
  8007d2:	0f 84 97 00 00 00    	je     80086f <.L20+0x23>
			putch(ch, putdat);
  8007d8:	83 ec 08             	sub    $0x8,%esp
  8007db:	57                   	push   %edi
  8007dc:	50                   	push   %eax
  8007dd:	ff d6                	call   *%esi
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	eb dc                	jmp    8007c0 <.L25+0x48>

008007e4 <.L21>:
  8007e4:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8007e7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  8007ea:	83 f9 01             	cmp    $0x1,%ecx
  8007ed:	7f 1b                	jg     80080a <.L21+0x26>
	else if (lflag)
  8007ef:	85 c9                	test   %ecx,%ecx
  8007f1:	74 2c                	je     80081f <.L21+0x3b>
		return va_arg(*ap, unsigned long);
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	8b 10                	mov    (%eax),%edx
  8007f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007fd:	8d 40 04             	lea    0x4(%eax),%eax
  800800:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800803:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800808:	eb 99                	jmp    8007a3 <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  80080a:	8b 45 14             	mov    0x14(%ebp),%eax
  80080d:	8b 10                	mov    (%eax),%edx
  80080f:	8b 48 04             	mov    0x4(%eax),%ecx
  800812:	8d 40 08             	lea    0x8(%eax),%eax
  800815:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800818:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80081d:	eb 84                	jmp    8007a3 <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  80081f:	8b 45 14             	mov    0x14(%ebp),%eax
  800822:	8b 10                	mov    (%eax),%edx
  800824:	b9 00 00 00 00       	mov    $0x0,%ecx
  800829:	8d 40 04             	lea    0x4(%eax),%eax
  80082c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082f:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800834:	e9 6a ff ff ff       	jmp    8007a3 <.L25+0x2b>

00800839 <.L35>:
  800839:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(ch, putdat);
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	57                   	push   %edi
  800840:	6a 25                	push   $0x25
  800842:	ff d6                	call   *%esi
			break;
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	e9 71 ff ff ff       	jmp    8007bd <.L25+0x45>

0080084c <.L20>:
  80084c:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('%', putdat);
  80084f:	83 ec 08             	sub    $0x8,%esp
  800852:	57                   	push   %edi
  800853:	6a 25                	push   $0x25
  800855:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800857:	83 c4 10             	add    $0x10,%esp
  80085a:	89 d8                	mov    %ebx,%eax
  80085c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800860:	74 05                	je     800867 <.L20+0x1b>
  800862:	83 e8 01             	sub    $0x1,%eax
  800865:	eb f5                	jmp    80085c <.L20+0x10>
  800867:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80086a:	e9 4e ff ff ff       	jmp    8007bd <.L25+0x45>
}
  80086f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800872:	5b                   	pop    %ebx
  800873:	5e                   	pop    %esi
  800874:	5f                   	pop    %edi
  800875:	5d                   	pop    %ebp
  800876:	c3                   	ret    

00800877 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800877:	f3 0f 1e fb          	endbr32 
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	53                   	push   %ebx
  80087f:	83 ec 14             	sub    $0x14,%esp
  800882:	e8 1d f8 ff ff       	call   8000a4 <__x86.get_pc_thunk.bx>
  800887:	81 c3 79 17 00 00    	add    $0x1779,%ebx
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800893:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800896:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80089a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80089d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008a4:	85 c0                	test   %eax,%eax
  8008a6:	74 2b                	je     8008d3 <vsnprintf+0x5c>
  8008a8:	85 d2                	test   %edx,%edx
  8008aa:	7e 27                	jle    8008d3 <vsnprintf+0x5c>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008ac:	ff 75 14             	pushl  0x14(%ebp)
  8008af:	ff 75 10             	pushl  0x10(%ebp)
  8008b2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b5:	50                   	push   %eax
  8008b6:	8d 83 80 e3 ff ff    	lea    -0x1c80(%ebx),%eax
  8008bc:	50                   	push   %eax
  8008bd:	e8 00 fb ff ff       	call   8003c2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008cb:	83 c4 10             	add    $0x10,%esp
}
  8008ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008d1:	c9                   	leave  
  8008d2:	c3                   	ret    
		return -E_INVAL;
  8008d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d8:	eb f4                	jmp    8008ce <vsnprintf+0x57>

008008da <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008da:	f3 0f 1e fb          	endbr32 
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008e4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008e7:	50                   	push   %eax
  8008e8:	ff 75 10             	pushl  0x10(%ebp)
  8008eb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ee:	ff 75 08             	pushl  0x8(%ebp)
  8008f1:	e8 81 ff ff ff       	call   800877 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008f6:	c9                   	leave  
  8008f7:	c3                   	ret    

008008f8 <__x86.get_pc_thunk.cx>:
  8008f8:	8b 0c 24             	mov    (%esp),%ecx
  8008fb:	c3                   	ret    

008008fc <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008fc:	f3 0f 1e fb          	endbr32 
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800906:	b8 00 00 00 00       	mov    $0x0,%eax
  80090b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80090f:	74 05                	je     800916 <strlen+0x1a>
		n++;
  800911:	83 c0 01             	add    $0x1,%eax
  800914:	eb f5                	jmp    80090b <strlen+0xf>
	return n;
}
  800916:	5d                   	pop    %ebp
  800917:	c3                   	ret    

00800918 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800918:	f3 0f 1e fb          	endbr32 
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800922:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800925:	b8 00 00 00 00       	mov    $0x0,%eax
  80092a:	39 d0                	cmp    %edx,%eax
  80092c:	74 0d                	je     80093b <strnlen+0x23>
  80092e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800932:	74 05                	je     800939 <strnlen+0x21>
		n++;
  800934:	83 c0 01             	add    $0x1,%eax
  800937:	eb f1                	jmp    80092a <strnlen+0x12>
  800939:	89 c2                	mov    %eax,%edx
	return n;
}
  80093b:	89 d0                	mov    %edx,%eax
  80093d:	5d                   	pop    %ebp
  80093e:	c3                   	ret    

0080093f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80093f:	f3 0f 1e fb          	endbr32 
  800943:	55                   	push   %ebp
  800944:	89 e5                	mov    %esp,%ebp
  800946:	53                   	push   %ebx
  800947:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80094a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80094d:	b8 00 00 00 00       	mov    $0x0,%eax
  800952:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800956:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800959:	83 c0 01             	add    $0x1,%eax
  80095c:	84 d2                	test   %dl,%dl
  80095e:	75 f2                	jne    800952 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800960:	89 c8                	mov    %ecx,%eax
  800962:	5b                   	pop    %ebx
  800963:	5d                   	pop    %ebp
  800964:	c3                   	ret    

00800965 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800965:	f3 0f 1e fb          	endbr32 
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	53                   	push   %ebx
  80096d:	83 ec 10             	sub    $0x10,%esp
  800970:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800973:	53                   	push   %ebx
  800974:	e8 83 ff ff ff       	call   8008fc <strlen>
  800979:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80097c:	ff 75 0c             	pushl  0xc(%ebp)
  80097f:	01 d8                	add    %ebx,%eax
  800981:	50                   	push   %eax
  800982:	e8 b8 ff ff ff       	call   80093f <strcpy>
	return dst;
}
  800987:	89 d8                	mov    %ebx,%eax
  800989:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80098c:	c9                   	leave  
  80098d:	c3                   	ret    

0080098e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80098e:	f3 0f 1e fb          	endbr32 
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	56                   	push   %esi
  800996:	53                   	push   %ebx
  800997:	8b 75 08             	mov    0x8(%ebp),%esi
  80099a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099d:	89 f3                	mov    %esi,%ebx
  80099f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a2:	89 f0                	mov    %esi,%eax
  8009a4:	39 d8                	cmp    %ebx,%eax
  8009a6:	74 11                	je     8009b9 <strncpy+0x2b>
		*dst++ = *src;
  8009a8:	83 c0 01             	add    $0x1,%eax
  8009ab:	0f b6 0a             	movzbl (%edx),%ecx
  8009ae:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009b1:	80 f9 01             	cmp    $0x1,%cl
  8009b4:	83 da ff             	sbb    $0xffffffff,%edx
  8009b7:	eb eb                	jmp    8009a4 <strncpy+0x16>
	}
	return ret;
}
  8009b9:	89 f0                	mov    %esi,%eax
  8009bb:	5b                   	pop    %ebx
  8009bc:	5e                   	pop    %esi
  8009bd:	5d                   	pop    %ebp
  8009be:	c3                   	ret    

008009bf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009bf:	f3 0f 1e fb          	endbr32 
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
  8009c6:	56                   	push   %esi
  8009c7:	53                   	push   %ebx
  8009c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8009cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ce:	8b 55 10             	mov    0x10(%ebp),%edx
  8009d1:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009d3:	85 d2                	test   %edx,%edx
  8009d5:	74 21                	je     8009f8 <strlcpy+0x39>
  8009d7:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009db:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009dd:	39 c2                	cmp    %eax,%edx
  8009df:	74 14                	je     8009f5 <strlcpy+0x36>
  8009e1:	0f b6 19             	movzbl (%ecx),%ebx
  8009e4:	84 db                	test   %bl,%bl
  8009e6:	74 0b                	je     8009f3 <strlcpy+0x34>
			*dst++ = *src++;
  8009e8:	83 c1 01             	add    $0x1,%ecx
  8009eb:	83 c2 01             	add    $0x1,%edx
  8009ee:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009f1:	eb ea                	jmp    8009dd <strlcpy+0x1e>
  8009f3:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009f5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f8:	29 f0                	sub    %esi,%eax
}
  8009fa:	5b                   	pop    %ebx
  8009fb:	5e                   	pop    %esi
  8009fc:	5d                   	pop    %ebp
  8009fd:	c3                   	ret    

008009fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009fe:	f3 0f 1e fb          	endbr32 
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a08:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a0b:	0f b6 01             	movzbl (%ecx),%eax
  800a0e:	84 c0                	test   %al,%al
  800a10:	74 0c                	je     800a1e <strcmp+0x20>
  800a12:	3a 02                	cmp    (%edx),%al
  800a14:	75 08                	jne    800a1e <strcmp+0x20>
		p++, q++;
  800a16:	83 c1 01             	add    $0x1,%ecx
  800a19:	83 c2 01             	add    $0x1,%edx
  800a1c:	eb ed                	jmp    800a0b <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a1e:	0f b6 c0             	movzbl %al,%eax
  800a21:	0f b6 12             	movzbl (%edx),%edx
  800a24:	29 d0                	sub    %edx,%eax
}
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    

00800a28 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a28:	f3 0f 1e fb          	endbr32 
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	53                   	push   %ebx
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a36:	89 c3                	mov    %eax,%ebx
  800a38:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a3b:	eb 06                	jmp    800a43 <strncmp+0x1b>
		n--, p++, q++;
  800a3d:	83 c0 01             	add    $0x1,%eax
  800a40:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a43:	39 d8                	cmp    %ebx,%eax
  800a45:	74 16                	je     800a5d <strncmp+0x35>
  800a47:	0f b6 08             	movzbl (%eax),%ecx
  800a4a:	84 c9                	test   %cl,%cl
  800a4c:	74 04                	je     800a52 <strncmp+0x2a>
  800a4e:	3a 0a                	cmp    (%edx),%cl
  800a50:	74 eb                	je     800a3d <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a52:	0f b6 00             	movzbl (%eax),%eax
  800a55:	0f b6 12             	movzbl (%edx),%edx
  800a58:	29 d0                	sub    %edx,%eax
}
  800a5a:	5b                   	pop    %ebx
  800a5b:	5d                   	pop    %ebp
  800a5c:	c3                   	ret    
		return 0;
  800a5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a62:	eb f6                	jmp    800a5a <strncmp+0x32>

00800a64 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a64:	f3 0f 1e fb          	endbr32 
  800a68:	55                   	push   %ebp
  800a69:	89 e5                	mov    %esp,%ebp
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a72:	0f b6 10             	movzbl (%eax),%edx
  800a75:	84 d2                	test   %dl,%dl
  800a77:	74 09                	je     800a82 <strchr+0x1e>
		if (*s == c)
  800a79:	38 ca                	cmp    %cl,%dl
  800a7b:	74 0a                	je     800a87 <strchr+0x23>
	for (; *s; s++)
  800a7d:	83 c0 01             	add    $0x1,%eax
  800a80:	eb f0                	jmp    800a72 <strchr+0xe>
			return (char *) s;
	return 0;
  800a82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a87:	5d                   	pop    %ebp
  800a88:	c3                   	ret    

00800a89 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a89:	f3 0f 1e fb          	endbr32 
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a97:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a9a:	38 ca                	cmp    %cl,%dl
  800a9c:	74 09                	je     800aa7 <strfind+0x1e>
  800a9e:	84 d2                	test   %dl,%dl
  800aa0:	74 05                	je     800aa7 <strfind+0x1e>
	for (; *s; s++)
  800aa2:	83 c0 01             	add    $0x1,%eax
  800aa5:	eb f0                	jmp    800a97 <strfind+0xe>
			break;
	return (char *) s;
}
  800aa7:	5d                   	pop    %ebp
  800aa8:	c3                   	ret    

00800aa9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aa9:	f3 0f 1e fb          	endbr32 
  800aad:	55                   	push   %ebp
  800aae:	89 e5                	mov    %esp,%ebp
  800ab0:	57                   	push   %edi
  800ab1:	56                   	push   %esi
  800ab2:	53                   	push   %ebx
  800ab3:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ab6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ab9:	85 c9                	test   %ecx,%ecx
  800abb:	74 31                	je     800aee <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800abd:	89 f8                	mov    %edi,%eax
  800abf:	09 c8                	or     %ecx,%eax
  800ac1:	a8 03                	test   $0x3,%al
  800ac3:	75 23                	jne    800ae8 <memset+0x3f>
		c &= 0xFF;
  800ac5:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ac9:	89 d3                	mov    %edx,%ebx
  800acb:	c1 e3 08             	shl    $0x8,%ebx
  800ace:	89 d0                	mov    %edx,%eax
  800ad0:	c1 e0 18             	shl    $0x18,%eax
  800ad3:	89 d6                	mov    %edx,%esi
  800ad5:	c1 e6 10             	shl    $0x10,%esi
  800ad8:	09 f0                	or     %esi,%eax
  800ada:	09 c2                	or     %eax,%edx
  800adc:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ade:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ae1:	89 d0                	mov    %edx,%eax
  800ae3:	fc                   	cld    
  800ae4:	f3 ab                	rep stos %eax,%es:(%edi)
  800ae6:	eb 06                	jmp    800aee <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ae8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aeb:	fc                   	cld    
  800aec:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aee:	89 f8                	mov    %edi,%eax
  800af0:	5b                   	pop    %ebx
  800af1:	5e                   	pop    %esi
  800af2:	5f                   	pop    %edi
  800af3:	5d                   	pop    %ebp
  800af4:	c3                   	ret    

00800af5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800af5:	f3 0f 1e fb          	endbr32 
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	57                   	push   %edi
  800afd:	56                   	push   %esi
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b04:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b07:	39 c6                	cmp    %eax,%esi
  800b09:	73 32                	jae    800b3d <memmove+0x48>
  800b0b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b0e:	39 c2                	cmp    %eax,%edx
  800b10:	76 2b                	jbe    800b3d <memmove+0x48>
		s += n;
		d += n;
  800b12:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b15:	89 fe                	mov    %edi,%esi
  800b17:	09 ce                	or     %ecx,%esi
  800b19:	09 d6                	or     %edx,%esi
  800b1b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b21:	75 0e                	jne    800b31 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b23:	83 ef 04             	sub    $0x4,%edi
  800b26:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b29:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b2c:	fd                   	std    
  800b2d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b2f:	eb 09                	jmp    800b3a <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b31:	83 ef 01             	sub    $0x1,%edi
  800b34:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b37:	fd                   	std    
  800b38:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b3a:	fc                   	cld    
  800b3b:	eb 1a                	jmp    800b57 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b3d:	89 c2                	mov    %eax,%edx
  800b3f:	09 ca                	or     %ecx,%edx
  800b41:	09 f2                	or     %esi,%edx
  800b43:	f6 c2 03             	test   $0x3,%dl
  800b46:	75 0a                	jne    800b52 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b48:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b4b:	89 c7                	mov    %eax,%edi
  800b4d:	fc                   	cld    
  800b4e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b50:	eb 05                	jmp    800b57 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b52:	89 c7                	mov    %eax,%edi
  800b54:	fc                   	cld    
  800b55:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b57:	5e                   	pop    %esi
  800b58:	5f                   	pop    %edi
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    

00800b5b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b5b:	f3 0f 1e fb          	endbr32 
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b65:	ff 75 10             	pushl  0x10(%ebp)
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	ff 75 08             	pushl  0x8(%ebp)
  800b6e:	e8 82 ff ff ff       	call   800af5 <memmove>
}
  800b73:	c9                   	leave  
  800b74:	c3                   	ret    

00800b75 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b75:	f3 0f 1e fb          	endbr32 
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	56                   	push   %esi
  800b7d:	53                   	push   %ebx
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b84:	89 c6                	mov    %eax,%esi
  800b86:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b89:	39 f0                	cmp    %esi,%eax
  800b8b:	74 1c                	je     800ba9 <memcmp+0x34>
		if (*s1 != *s2)
  800b8d:	0f b6 08             	movzbl (%eax),%ecx
  800b90:	0f b6 1a             	movzbl (%edx),%ebx
  800b93:	38 d9                	cmp    %bl,%cl
  800b95:	75 08                	jne    800b9f <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b97:	83 c0 01             	add    $0x1,%eax
  800b9a:	83 c2 01             	add    $0x1,%edx
  800b9d:	eb ea                	jmp    800b89 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b9f:	0f b6 c1             	movzbl %cl,%eax
  800ba2:	0f b6 db             	movzbl %bl,%ebx
  800ba5:	29 d8                	sub    %ebx,%eax
  800ba7:	eb 05                	jmp    800bae <memcmp+0x39>
	}

	return 0;
  800ba9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bae:	5b                   	pop    %ebx
  800baf:	5e                   	pop    %esi
  800bb0:	5d                   	pop    %ebp
  800bb1:	c3                   	ret    

00800bb2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bb2:	f3 0f 1e fb          	endbr32 
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bbf:	89 c2                	mov    %eax,%edx
  800bc1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bc4:	39 d0                	cmp    %edx,%eax
  800bc6:	73 09                	jae    800bd1 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bc8:	38 08                	cmp    %cl,(%eax)
  800bca:	74 05                	je     800bd1 <memfind+0x1f>
	for (; s < ends; s++)
  800bcc:	83 c0 01             	add    $0x1,%eax
  800bcf:	eb f3                	jmp    800bc4 <memfind+0x12>
			break;
	return (void *) s;
}
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    

00800bd3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bd3:	f3 0f 1e fb          	endbr32 
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	57                   	push   %edi
  800bdb:	56                   	push   %esi
  800bdc:	53                   	push   %ebx
  800bdd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800be0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800be3:	eb 03                	jmp    800be8 <strtol+0x15>
		s++;
  800be5:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800be8:	0f b6 01             	movzbl (%ecx),%eax
  800beb:	3c 20                	cmp    $0x20,%al
  800bed:	74 f6                	je     800be5 <strtol+0x12>
  800bef:	3c 09                	cmp    $0x9,%al
  800bf1:	74 f2                	je     800be5 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800bf3:	3c 2b                	cmp    $0x2b,%al
  800bf5:	74 2a                	je     800c21 <strtol+0x4e>
	int neg = 0;
  800bf7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bfc:	3c 2d                	cmp    $0x2d,%al
  800bfe:	74 2b                	je     800c2b <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c00:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c06:	75 0f                	jne    800c17 <strtol+0x44>
  800c08:	80 39 30             	cmpb   $0x30,(%ecx)
  800c0b:	74 28                	je     800c35 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c0d:	85 db                	test   %ebx,%ebx
  800c0f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c14:	0f 44 d8             	cmove  %eax,%ebx
  800c17:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c1f:	eb 46                	jmp    800c67 <strtol+0x94>
		s++;
  800c21:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c24:	bf 00 00 00 00       	mov    $0x0,%edi
  800c29:	eb d5                	jmp    800c00 <strtol+0x2d>
		s++, neg = 1;
  800c2b:	83 c1 01             	add    $0x1,%ecx
  800c2e:	bf 01 00 00 00       	mov    $0x1,%edi
  800c33:	eb cb                	jmp    800c00 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c35:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c39:	74 0e                	je     800c49 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c3b:	85 db                	test   %ebx,%ebx
  800c3d:	75 d8                	jne    800c17 <strtol+0x44>
		s++, base = 8;
  800c3f:	83 c1 01             	add    $0x1,%ecx
  800c42:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c47:	eb ce                	jmp    800c17 <strtol+0x44>
		s += 2, base = 16;
  800c49:	83 c1 02             	add    $0x2,%ecx
  800c4c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c51:	eb c4                	jmp    800c17 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c53:	0f be d2             	movsbl %dl,%edx
  800c56:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c59:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c5c:	7d 3a                	jge    800c98 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c5e:	83 c1 01             	add    $0x1,%ecx
  800c61:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c65:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c67:	0f b6 11             	movzbl (%ecx),%edx
  800c6a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c6d:	89 f3                	mov    %esi,%ebx
  800c6f:	80 fb 09             	cmp    $0x9,%bl
  800c72:	76 df                	jbe    800c53 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c74:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c77:	89 f3                	mov    %esi,%ebx
  800c79:	80 fb 19             	cmp    $0x19,%bl
  800c7c:	77 08                	ja     800c86 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c7e:	0f be d2             	movsbl %dl,%edx
  800c81:	83 ea 57             	sub    $0x57,%edx
  800c84:	eb d3                	jmp    800c59 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c86:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c89:	89 f3                	mov    %esi,%ebx
  800c8b:	80 fb 19             	cmp    $0x19,%bl
  800c8e:	77 08                	ja     800c98 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c90:	0f be d2             	movsbl %dl,%edx
  800c93:	83 ea 37             	sub    $0x37,%edx
  800c96:	eb c1                	jmp    800c59 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9c:	74 05                	je     800ca3 <strtol+0xd0>
		*endptr = (char *) s;
  800c9e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ca1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ca3:	89 c2                	mov    %eax,%edx
  800ca5:	f7 da                	neg    %edx
  800ca7:	85 ff                	test   %edi,%edi
  800ca9:	0f 45 c2             	cmovne %edx,%eax
}
  800cac:	5b                   	pop    %ebx
  800cad:	5e                   	pop    %esi
  800cae:	5f                   	pop    %edi
  800caf:	5d                   	pop    %ebp
  800cb0:	c3                   	ret    
  800cb1:	66 90                	xchg   %ax,%ax
  800cb3:	66 90                	xchg   %ax,%ax
  800cb5:	66 90                	xchg   %ax,%ax
  800cb7:	66 90                	xchg   %ax,%ax
  800cb9:	66 90                	xchg   %ax,%ax
  800cbb:	66 90                	xchg   %ax,%ax
  800cbd:	66 90                	xchg   %ax,%ax
  800cbf:	90                   	nop

00800cc0 <__udivdi3>:
  800cc0:	f3 0f 1e fb          	endbr32 
  800cc4:	55                   	push   %ebp
  800cc5:	57                   	push   %edi
  800cc6:	56                   	push   %esi
  800cc7:	53                   	push   %ebx
  800cc8:	83 ec 1c             	sub    $0x1c,%esp
  800ccb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800ccf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800cd3:	8b 74 24 34          	mov    0x34(%esp),%esi
  800cd7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800cdb:	85 d2                	test   %edx,%edx
  800cdd:	75 19                	jne    800cf8 <__udivdi3+0x38>
  800cdf:	39 f3                	cmp    %esi,%ebx
  800ce1:	76 4d                	jbe    800d30 <__udivdi3+0x70>
  800ce3:	31 ff                	xor    %edi,%edi
  800ce5:	89 e8                	mov    %ebp,%eax
  800ce7:	89 f2                	mov    %esi,%edx
  800ce9:	f7 f3                	div    %ebx
  800ceb:	89 fa                	mov    %edi,%edx
  800ced:	83 c4 1c             	add    $0x1c,%esp
  800cf0:	5b                   	pop    %ebx
  800cf1:	5e                   	pop    %esi
  800cf2:	5f                   	pop    %edi
  800cf3:	5d                   	pop    %ebp
  800cf4:	c3                   	ret    
  800cf5:	8d 76 00             	lea    0x0(%esi),%esi
  800cf8:	39 f2                	cmp    %esi,%edx
  800cfa:	76 14                	jbe    800d10 <__udivdi3+0x50>
  800cfc:	31 ff                	xor    %edi,%edi
  800cfe:	31 c0                	xor    %eax,%eax
  800d00:	89 fa                	mov    %edi,%edx
  800d02:	83 c4 1c             	add    $0x1c,%esp
  800d05:	5b                   	pop    %ebx
  800d06:	5e                   	pop    %esi
  800d07:	5f                   	pop    %edi
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    
  800d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800d10:	0f bd fa             	bsr    %edx,%edi
  800d13:	83 f7 1f             	xor    $0x1f,%edi
  800d16:	75 48                	jne    800d60 <__udivdi3+0xa0>
  800d18:	39 f2                	cmp    %esi,%edx
  800d1a:	72 06                	jb     800d22 <__udivdi3+0x62>
  800d1c:	31 c0                	xor    %eax,%eax
  800d1e:	39 eb                	cmp    %ebp,%ebx
  800d20:	77 de                	ja     800d00 <__udivdi3+0x40>
  800d22:	b8 01 00 00 00       	mov    $0x1,%eax
  800d27:	eb d7                	jmp    800d00 <__udivdi3+0x40>
  800d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d30:	89 d9                	mov    %ebx,%ecx
  800d32:	85 db                	test   %ebx,%ebx
  800d34:	75 0b                	jne    800d41 <__udivdi3+0x81>
  800d36:	b8 01 00 00 00       	mov    $0x1,%eax
  800d3b:	31 d2                	xor    %edx,%edx
  800d3d:	f7 f3                	div    %ebx
  800d3f:	89 c1                	mov    %eax,%ecx
  800d41:	31 d2                	xor    %edx,%edx
  800d43:	89 f0                	mov    %esi,%eax
  800d45:	f7 f1                	div    %ecx
  800d47:	89 c6                	mov    %eax,%esi
  800d49:	89 e8                	mov    %ebp,%eax
  800d4b:	89 f7                	mov    %esi,%edi
  800d4d:	f7 f1                	div    %ecx
  800d4f:	89 fa                	mov    %edi,%edx
  800d51:	83 c4 1c             	add    $0x1c,%esp
  800d54:	5b                   	pop    %ebx
  800d55:	5e                   	pop    %esi
  800d56:	5f                   	pop    %edi
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    
  800d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d60:	89 f9                	mov    %edi,%ecx
  800d62:	b8 20 00 00 00       	mov    $0x20,%eax
  800d67:	29 f8                	sub    %edi,%eax
  800d69:	d3 e2                	shl    %cl,%edx
  800d6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800d6f:	89 c1                	mov    %eax,%ecx
  800d71:	89 da                	mov    %ebx,%edx
  800d73:	d3 ea                	shr    %cl,%edx
  800d75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800d79:	09 d1                	or     %edx,%ecx
  800d7b:	89 f2                	mov    %esi,%edx
  800d7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800d81:	89 f9                	mov    %edi,%ecx
  800d83:	d3 e3                	shl    %cl,%ebx
  800d85:	89 c1                	mov    %eax,%ecx
  800d87:	d3 ea                	shr    %cl,%edx
  800d89:	89 f9                	mov    %edi,%ecx
  800d8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800d8f:	89 eb                	mov    %ebp,%ebx
  800d91:	d3 e6                	shl    %cl,%esi
  800d93:	89 c1                	mov    %eax,%ecx
  800d95:	d3 eb                	shr    %cl,%ebx
  800d97:	09 de                	or     %ebx,%esi
  800d99:	89 f0                	mov    %esi,%eax
  800d9b:	f7 74 24 08          	divl   0x8(%esp)
  800d9f:	89 d6                	mov    %edx,%esi
  800da1:	89 c3                	mov    %eax,%ebx
  800da3:	f7 64 24 0c          	mull   0xc(%esp)
  800da7:	39 d6                	cmp    %edx,%esi
  800da9:	72 15                	jb     800dc0 <__udivdi3+0x100>
  800dab:	89 f9                	mov    %edi,%ecx
  800dad:	d3 e5                	shl    %cl,%ebp
  800daf:	39 c5                	cmp    %eax,%ebp
  800db1:	73 04                	jae    800db7 <__udivdi3+0xf7>
  800db3:	39 d6                	cmp    %edx,%esi
  800db5:	74 09                	je     800dc0 <__udivdi3+0x100>
  800db7:	89 d8                	mov    %ebx,%eax
  800db9:	31 ff                	xor    %edi,%edi
  800dbb:	e9 40 ff ff ff       	jmp    800d00 <__udivdi3+0x40>
  800dc0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800dc3:	31 ff                	xor    %edi,%edi
  800dc5:	e9 36 ff ff ff       	jmp    800d00 <__udivdi3+0x40>
  800dca:	66 90                	xchg   %ax,%ax
  800dcc:	66 90                	xchg   %ax,%ax
  800dce:	66 90                	xchg   %ax,%ax

00800dd0 <__umoddi3>:
  800dd0:	f3 0f 1e fb          	endbr32 
  800dd4:	55                   	push   %ebp
  800dd5:	57                   	push   %edi
  800dd6:	56                   	push   %esi
  800dd7:	53                   	push   %ebx
  800dd8:	83 ec 1c             	sub    $0x1c,%esp
  800ddb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800ddf:	8b 74 24 30          	mov    0x30(%esp),%esi
  800de3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800de7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800deb:	85 c0                	test   %eax,%eax
  800ded:	75 19                	jne    800e08 <__umoddi3+0x38>
  800def:	39 df                	cmp    %ebx,%edi
  800df1:	76 5d                	jbe    800e50 <__umoddi3+0x80>
  800df3:	89 f0                	mov    %esi,%eax
  800df5:	89 da                	mov    %ebx,%edx
  800df7:	f7 f7                	div    %edi
  800df9:	89 d0                	mov    %edx,%eax
  800dfb:	31 d2                	xor    %edx,%edx
  800dfd:	83 c4 1c             	add    $0x1c,%esp
  800e00:	5b                   	pop    %ebx
  800e01:	5e                   	pop    %esi
  800e02:	5f                   	pop    %edi
  800e03:	5d                   	pop    %ebp
  800e04:	c3                   	ret    
  800e05:	8d 76 00             	lea    0x0(%esi),%esi
  800e08:	89 f2                	mov    %esi,%edx
  800e0a:	39 d8                	cmp    %ebx,%eax
  800e0c:	76 12                	jbe    800e20 <__umoddi3+0x50>
  800e0e:	89 f0                	mov    %esi,%eax
  800e10:	89 da                	mov    %ebx,%edx
  800e12:	83 c4 1c             	add    $0x1c,%esp
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    
  800e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e20:	0f bd e8             	bsr    %eax,%ebp
  800e23:	83 f5 1f             	xor    $0x1f,%ebp
  800e26:	75 50                	jne    800e78 <__umoddi3+0xa8>
  800e28:	39 d8                	cmp    %ebx,%eax
  800e2a:	0f 82 e0 00 00 00    	jb     800f10 <__umoddi3+0x140>
  800e30:	89 d9                	mov    %ebx,%ecx
  800e32:	39 f7                	cmp    %esi,%edi
  800e34:	0f 86 d6 00 00 00    	jbe    800f10 <__umoddi3+0x140>
  800e3a:	89 d0                	mov    %edx,%eax
  800e3c:	89 ca                	mov    %ecx,%edx
  800e3e:	83 c4 1c             	add    $0x1c,%esp
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    
  800e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e4d:	8d 76 00             	lea    0x0(%esi),%esi
  800e50:	89 fd                	mov    %edi,%ebp
  800e52:	85 ff                	test   %edi,%edi
  800e54:	75 0b                	jne    800e61 <__umoddi3+0x91>
  800e56:	b8 01 00 00 00       	mov    $0x1,%eax
  800e5b:	31 d2                	xor    %edx,%edx
  800e5d:	f7 f7                	div    %edi
  800e5f:	89 c5                	mov    %eax,%ebp
  800e61:	89 d8                	mov    %ebx,%eax
  800e63:	31 d2                	xor    %edx,%edx
  800e65:	f7 f5                	div    %ebp
  800e67:	89 f0                	mov    %esi,%eax
  800e69:	f7 f5                	div    %ebp
  800e6b:	89 d0                	mov    %edx,%eax
  800e6d:	31 d2                	xor    %edx,%edx
  800e6f:	eb 8c                	jmp    800dfd <__umoddi3+0x2d>
  800e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e78:	89 e9                	mov    %ebp,%ecx
  800e7a:	ba 20 00 00 00       	mov    $0x20,%edx
  800e7f:	29 ea                	sub    %ebp,%edx
  800e81:	d3 e0                	shl    %cl,%eax
  800e83:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e87:	89 d1                	mov    %edx,%ecx
  800e89:	89 f8                	mov    %edi,%eax
  800e8b:	d3 e8                	shr    %cl,%eax
  800e8d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e91:	89 54 24 04          	mov    %edx,0x4(%esp)
  800e95:	8b 54 24 04          	mov    0x4(%esp),%edx
  800e99:	09 c1                	or     %eax,%ecx
  800e9b:	89 d8                	mov    %ebx,%eax
  800e9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ea1:	89 e9                	mov    %ebp,%ecx
  800ea3:	d3 e7                	shl    %cl,%edi
  800ea5:	89 d1                	mov    %edx,%ecx
  800ea7:	d3 e8                	shr    %cl,%eax
  800ea9:	89 e9                	mov    %ebp,%ecx
  800eab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800eaf:	d3 e3                	shl    %cl,%ebx
  800eb1:	89 c7                	mov    %eax,%edi
  800eb3:	89 d1                	mov    %edx,%ecx
  800eb5:	89 f0                	mov    %esi,%eax
  800eb7:	d3 e8                	shr    %cl,%eax
  800eb9:	89 e9                	mov    %ebp,%ecx
  800ebb:	89 fa                	mov    %edi,%edx
  800ebd:	d3 e6                	shl    %cl,%esi
  800ebf:	09 d8                	or     %ebx,%eax
  800ec1:	f7 74 24 08          	divl   0x8(%esp)
  800ec5:	89 d1                	mov    %edx,%ecx
  800ec7:	89 f3                	mov    %esi,%ebx
  800ec9:	f7 64 24 0c          	mull   0xc(%esp)
  800ecd:	89 c6                	mov    %eax,%esi
  800ecf:	89 d7                	mov    %edx,%edi
  800ed1:	39 d1                	cmp    %edx,%ecx
  800ed3:	72 06                	jb     800edb <__umoddi3+0x10b>
  800ed5:	75 10                	jne    800ee7 <__umoddi3+0x117>
  800ed7:	39 c3                	cmp    %eax,%ebx
  800ed9:	73 0c                	jae    800ee7 <__umoddi3+0x117>
  800edb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  800edf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  800ee3:	89 d7                	mov    %edx,%edi
  800ee5:	89 c6                	mov    %eax,%esi
  800ee7:	89 ca                	mov    %ecx,%edx
  800ee9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800eee:	29 f3                	sub    %esi,%ebx
  800ef0:	19 fa                	sbb    %edi,%edx
  800ef2:	89 d0                	mov    %edx,%eax
  800ef4:	d3 e0                	shl    %cl,%eax
  800ef6:	89 e9                	mov    %ebp,%ecx
  800ef8:	d3 eb                	shr    %cl,%ebx
  800efa:	d3 ea                	shr    %cl,%edx
  800efc:	09 d8                	or     %ebx,%eax
  800efe:	83 c4 1c             	add    $0x1c,%esp
  800f01:	5b                   	pop    %ebx
  800f02:	5e                   	pop    %esi
  800f03:	5f                   	pop    %edi
  800f04:	5d                   	pop    %ebp
  800f05:	c3                   	ret    
  800f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f0d:	8d 76 00             	lea    0x0(%esi),%esi
  800f10:	29 fe                	sub    %edi,%esi
  800f12:	19 c3                	sbb    %eax,%ebx
  800f14:	89 f2                	mov    %esi,%edx
  800f16:	89 d9                	mov    %ebx,%ecx
  800f18:	e9 1d ff ff ff       	jmp    800e3a <__umoddi3+0x6a>
