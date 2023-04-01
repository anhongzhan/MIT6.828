
obj/user/breakpoint:     file format elf32-i386


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
  80002c:	e8 08 00 00 00       	call   800039 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
	asm volatile("int $3");
  800037:	cc                   	int3   
}
  800038:	c3                   	ret    

00800039 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800039:	f3 0f 1e fb          	endbr32 
  80003d:	55                   	push   %ebp
  80003e:	89 e5                	mov    %esp,%ebp
  800040:	57                   	push   %edi
  800041:	56                   	push   %esi
  800042:	53                   	push   %ebx
  800043:	83 ec 0c             	sub    $0xc,%esp
  800046:	e8 50 00 00 00       	call   80009b <__x86.get_pc_thunk.bx>
  80004b:	81 c3 b5 1f 00 00    	add    $0x1fb5,%ebx
  800051:	8b 75 08             	mov    0x8(%ebp),%esi
  800054:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800057:	e8 06 01 00 00       	call   800162 <sys_getenvid>
  80005c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800061:	8d 04 40             	lea    (%eax,%eax,2),%eax
  800064:	c1 e0 05             	shl    $0x5,%eax
  800067:	81 c0 00 00 c0 ee    	add    $0xeec00000,%eax
  80006d:	c7 c2 2c 20 80 00    	mov    $0x80202c,%edx
  800073:	89 02                	mov    %eax,(%edx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800075:	85 f6                	test   %esi,%esi
  800077:	7e 08                	jle    800081 <libmain+0x48>
		binaryname = argv[0];
  800079:	8b 07                	mov    (%edi),%eax
  80007b:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  800081:	83 ec 08             	sub    $0x8,%esp
  800084:	57                   	push   %edi
  800085:	56                   	push   %esi
  800086:	e8 a8 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008b:	e8 0f 00 00 00       	call   80009f <exit>
}
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800096:	5b                   	pop    %ebx
  800097:	5e                   	pop    %esi
  800098:	5f                   	pop    %edi
  800099:	5d                   	pop    %ebp
  80009a:	c3                   	ret    

0080009b <__x86.get_pc_thunk.bx>:
  80009b:	8b 1c 24             	mov    (%esp),%ebx
  80009e:	c3                   	ret    

0080009f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009f:	f3 0f 1e fb          	endbr32 
  8000a3:	55                   	push   %ebp
  8000a4:	89 e5                	mov    %esp,%ebp
  8000a6:	53                   	push   %ebx
  8000a7:	83 ec 10             	sub    $0x10,%esp
  8000aa:	e8 ec ff ff ff       	call   80009b <__x86.get_pc_thunk.bx>
  8000af:	81 c3 51 1f 00 00    	add    $0x1f51,%ebx
	sys_env_destroy(0);
  8000b5:	6a 00                	push   $0x0
  8000b7:	e8 4d 00 00 00       	call   800109 <sys_env_destroy>
}
  8000bc:	83 c4 10             	add    $0x10,%esp
  8000bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000c2:	c9                   	leave  
  8000c3:	c3                   	ret    

008000c4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000c4:	f3 0f 1e fb          	endbr32 
  8000c8:	55                   	push   %ebp
  8000c9:	89 e5                	mov    %esp,%ebp
  8000cb:	57                   	push   %edi
  8000cc:	56                   	push   %esi
  8000cd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8000d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000d9:	89 c3                	mov    %eax,%ebx
  8000db:	89 c7                	mov    %eax,%edi
  8000dd:	89 c6                	mov    %eax,%esi
  8000df:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000e1:	5b                   	pop    %ebx
  8000e2:	5e                   	pop    %esi
  8000e3:	5f                   	pop    %edi
  8000e4:	5d                   	pop    %ebp
  8000e5:	c3                   	ret    

008000e6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000e6:	f3 0f 1e fb          	endbr32 
  8000ea:	55                   	push   %ebp
  8000eb:	89 e5                	mov    %esp,%ebp
  8000ed:	57                   	push   %edi
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8000f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8000fa:	89 d1                	mov    %edx,%ecx
  8000fc:	89 d3                	mov    %edx,%ebx
  8000fe:	89 d7                	mov    %edx,%edi
  800100:	89 d6                	mov    %edx,%esi
  800102:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800104:	5b                   	pop    %ebx
  800105:	5e                   	pop    %esi
  800106:	5f                   	pop    %edi
  800107:	5d                   	pop    %ebp
  800108:	c3                   	ret    

00800109 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800109:	f3 0f 1e fb          	endbr32 
  80010d:	55                   	push   %ebp
  80010e:	89 e5                	mov    %esp,%ebp
  800110:	57                   	push   %edi
  800111:	56                   	push   %esi
  800112:	53                   	push   %ebx
  800113:	83 ec 1c             	sub    $0x1c,%esp
  800116:	e8 6a 00 00 00       	call   800185 <__x86.get_pc_thunk.ax>
  80011b:	05 e5 1e 00 00       	add    $0x1ee5,%eax
  800120:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("int %1\n"
  800123:	b9 00 00 00 00       	mov    $0x0,%ecx
  800128:	8b 55 08             	mov    0x8(%ebp),%edx
  80012b:	b8 03 00 00 00       	mov    $0x3,%eax
  800130:	89 cb                	mov    %ecx,%ebx
  800132:	89 cf                	mov    %ecx,%edi
  800134:	89 ce                	mov    %ecx,%esi
  800136:	cd 30                	int    $0x30
	if(check && ret > 0)
  800138:	85 c0                	test   %eax,%eax
  80013a:	7f 08                	jg     800144 <sys_env_destroy+0x3b>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80013c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80013f:	5b                   	pop    %ebx
  800140:	5e                   	pop    %esi
  800141:	5f                   	pop    %edi
  800142:	5d                   	pop    %ebp
  800143:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	50                   	push   %eax
  800148:	6a 03                	push   $0x3
  80014a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80014d:	8d 83 1a ef ff ff    	lea    -0x10e6(%ebx),%eax
  800153:	50                   	push   %eax
  800154:	6a 23                	push   $0x23
  800156:	8d 83 37 ef ff ff    	lea    -0x10c9(%ebx),%eax
  80015c:	50                   	push   %eax
  80015d:	e8 27 00 00 00       	call   800189 <_panic>

00800162 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800162:	f3 0f 1e fb          	endbr32 
  800166:	55                   	push   %ebp
  800167:	89 e5                	mov    %esp,%ebp
  800169:	57                   	push   %edi
  80016a:	56                   	push   %esi
  80016b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80016c:	ba 00 00 00 00       	mov    $0x0,%edx
  800171:	b8 02 00 00 00       	mov    $0x2,%eax
  800176:	89 d1                	mov    %edx,%ecx
  800178:	89 d3                	mov    %edx,%ebx
  80017a:	89 d7                	mov    %edx,%edi
  80017c:	89 d6                	mov    %edx,%esi
  80017e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800180:	5b                   	pop    %ebx
  800181:	5e                   	pop    %esi
  800182:	5f                   	pop    %edi
  800183:	5d                   	pop    %ebp
  800184:	c3                   	ret    

00800185 <__x86.get_pc_thunk.ax>:
  800185:	8b 04 24             	mov    (%esp),%eax
  800188:	c3                   	ret    

00800189 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800189:	f3 0f 1e fb          	endbr32 
  80018d:	55                   	push   %ebp
  80018e:	89 e5                	mov    %esp,%ebp
  800190:	57                   	push   %edi
  800191:	56                   	push   %esi
  800192:	53                   	push   %ebx
  800193:	83 ec 0c             	sub    $0xc,%esp
  800196:	e8 00 ff ff ff       	call   80009b <__x86.get_pc_thunk.bx>
  80019b:	81 c3 65 1e 00 00    	add    $0x1e65,%ebx
	va_list ap;

	va_start(ap, fmt);
  8001a1:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001a4:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  8001aa:	8b 38                	mov    (%eax),%edi
  8001ac:	e8 b1 ff ff ff       	call   800162 <sys_getenvid>
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	ff 75 0c             	pushl  0xc(%ebp)
  8001b7:	ff 75 08             	pushl  0x8(%ebp)
  8001ba:	57                   	push   %edi
  8001bb:	50                   	push   %eax
  8001bc:	8d 83 48 ef ff ff    	lea    -0x10b8(%ebx),%eax
  8001c2:	50                   	push   %eax
  8001c3:	e8 d9 00 00 00       	call   8002a1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001c8:	83 c4 18             	add    $0x18,%esp
  8001cb:	56                   	push   %esi
  8001cc:	ff 75 10             	pushl  0x10(%ebp)
  8001cf:	e8 67 00 00 00       	call   80023b <vcprintf>
	cprintf("\n");
  8001d4:	8d 83 6b ef ff ff    	lea    -0x1095(%ebx),%eax
  8001da:	89 04 24             	mov    %eax,(%esp)
  8001dd:	e8 bf 00 00 00       	call   8002a1 <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001e5:	cc                   	int3   
  8001e6:	eb fd                	jmp    8001e5 <_panic+0x5c>

008001e8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001e8:	f3 0f 1e fb          	endbr32 
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	56                   	push   %esi
  8001f0:	53                   	push   %ebx
  8001f1:	e8 a5 fe ff ff       	call   80009b <__x86.get_pc_thunk.bx>
  8001f6:	81 c3 0a 1e 00 00    	add    $0x1e0a,%ebx
  8001fc:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  8001ff:	8b 16                	mov    (%esi),%edx
  800201:	8d 42 01             	lea    0x1(%edx),%eax
  800204:	89 06                	mov    %eax,(%esi)
  800206:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800209:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  80020d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800212:	74 0b                	je     80021f <putch+0x37>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800214:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  800218:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80021b:	5b                   	pop    %ebx
  80021c:	5e                   	pop    %esi
  80021d:	5d                   	pop    %ebp
  80021e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	68 ff 00 00 00       	push   $0xff
  800227:	8d 46 08             	lea    0x8(%esi),%eax
  80022a:	50                   	push   %eax
  80022b:	e8 94 fe ff ff       	call   8000c4 <sys_cputs>
		b->idx = 0;
  800230:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  800236:	83 c4 10             	add    $0x10,%esp
  800239:	eb d9                	jmp    800214 <putch+0x2c>

0080023b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80023b:	f3 0f 1e fb          	endbr32 
  80023f:	55                   	push   %ebp
  800240:	89 e5                	mov    %esp,%ebp
  800242:	53                   	push   %ebx
  800243:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800249:	e8 4d fe ff ff       	call   80009b <__x86.get_pc_thunk.bx>
  80024e:	81 c3 b2 1d 00 00    	add    $0x1db2,%ebx
	struct printbuf b;

	b.idx = 0;
  800254:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80025b:	00 00 00 
	b.cnt = 0;
  80025e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800265:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800268:	ff 75 0c             	pushl  0xc(%ebp)
  80026b:	ff 75 08             	pushl  0x8(%ebp)
  80026e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800274:	50                   	push   %eax
  800275:	8d 83 e8 e1 ff ff    	lea    -0x1e18(%ebx),%eax
  80027b:	50                   	push   %eax
  80027c:	e8 38 01 00 00       	call   8003b9 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800281:	83 c4 08             	add    $0x8,%esp
  800284:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80028a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800290:	50                   	push   %eax
  800291:	e8 2e fe ff ff       	call   8000c4 <sys_cputs>

	return b.cnt;
}
  800296:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80029c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80029f:	c9                   	leave  
  8002a0:	c3                   	ret    

008002a1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002a1:	f3 0f 1e fb          	endbr32 
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002ab:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002ae:	50                   	push   %eax
  8002af:	ff 75 08             	pushl  0x8(%ebp)
  8002b2:	e8 84 ff ff ff       	call   80023b <vcprintf>
	va_end(ap);

	return cnt;
}
  8002b7:	c9                   	leave  
  8002b8:	c3                   	ret    

008002b9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	57                   	push   %edi
  8002bd:	56                   	push   %esi
  8002be:	53                   	push   %ebx
  8002bf:	83 ec 2c             	sub    $0x2c,%esp
  8002c2:	e8 28 06 00 00       	call   8008ef <__x86.get_pc_thunk.cx>
  8002c7:	81 c1 39 1d 00 00    	add    $0x1d39,%ecx
  8002cd:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002d0:	89 c7                	mov    %eax,%edi
  8002d2:	89 d6                	mov    %edx,%esi
  8002d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002da:	89 d1                	mov    %edx,%ecx
  8002dc:	89 c2                	mov    %eax,%edx
  8002de:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002e1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8002e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e7:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002ed:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002f4:	39 c2                	cmp    %eax,%edx
  8002f6:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002f9:	72 41                	jb     80033c <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002fb:	83 ec 0c             	sub    $0xc,%esp
  8002fe:	ff 75 18             	pushl  0x18(%ebp)
  800301:	83 eb 01             	sub    $0x1,%ebx
  800304:	53                   	push   %ebx
  800305:	50                   	push   %eax
  800306:	83 ec 08             	sub    $0x8,%esp
  800309:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030c:	ff 75 e0             	pushl  -0x20(%ebp)
  80030f:	ff 75 d4             	pushl  -0x2c(%ebp)
  800312:	ff 75 d0             	pushl  -0x30(%ebp)
  800315:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800318:	e8 93 09 00 00       	call   800cb0 <__udivdi3>
  80031d:	83 c4 18             	add    $0x18,%esp
  800320:	52                   	push   %edx
  800321:	50                   	push   %eax
  800322:	89 f2                	mov    %esi,%edx
  800324:	89 f8                	mov    %edi,%eax
  800326:	e8 8e ff ff ff       	call   8002b9 <printnum>
  80032b:	83 c4 20             	add    $0x20,%esp
  80032e:	eb 13                	jmp    800343 <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800330:	83 ec 08             	sub    $0x8,%esp
  800333:	56                   	push   %esi
  800334:	ff 75 18             	pushl  0x18(%ebp)
  800337:	ff d7                	call   *%edi
  800339:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80033c:	83 eb 01             	sub    $0x1,%ebx
  80033f:	85 db                	test   %ebx,%ebx
  800341:	7f ed                	jg     800330 <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800343:	83 ec 08             	sub    $0x8,%esp
  800346:	56                   	push   %esi
  800347:	83 ec 04             	sub    $0x4,%esp
  80034a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80034d:	ff 75 e0             	pushl  -0x20(%ebp)
  800350:	ff 75 d4             	pushl  -0x2c(%ebp)
  800353:	ff 75 d0             	pushl  -0x30(%ebp)
  800356:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800359:	e8 62 0a 00 00       	call   800dc0 <__umoddi3>
  80035e:	83 c4 14             	add    $0x14,%esp
  800361:	0f be 84 03 6d ef ff 	movsbl -0x1093(%ebx,%eax,1),%eax
  800368:	ff 
  800369:	50                   	push   %eax
  80036a:	ff d7                	call   *%edi
}
  80036c:	83 c4 10             	add    $0x10,%esp
  80036f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800372:	5b                   	pop    %ebx
  800373:	5e                   	pop    %esi
  800374:	5f                   	pop    %edi
  800375:	5d                   	pop    %ebp
  800376:	c3                   	ret    

00800377 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800377:	f3 0f 1e fb          	endbr32 
  80037b:	55                   	push   %ebp
  80037c:	89 e5                	mov    %esp,%ebp
  80037e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800381:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800385:	8b 10                	mov    (%eax),%edx
  800387:	3b 50 04             	cmp    0x4(%eax),%edx
  80038a:	73 0a                	jae    800396 <sprintputch+0x1f>
		*b->buf++ = ch;
  80038c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80038f:	89 08                	mov    %ecx,(%eax)
  800391:	8b 45 08             	mov    0x8(%ebp),%eax
  800394:	88 02                	mov    %al,(%edx)
}
  800396:	5d                   	pop    %ebp
  800397:	c3                   	ret    

00800398 <printfmt>:
{
  800398:	f3 0f 1e fb          	endbr32 
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003a2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003a5:	50                   	push   %eax
  8003a6:	ff 75 10             	pushl  0x10(%ebp)
  8003a9:	ff 75 0c             	pushl  0xc(%ebp)
  8003ac:	ff 75 08             	pushl  0x8(%ebp)
  8003af:	e8 05 00 00 00       	call   8003b9 <vprintfmt>
}
  8003b4:	83 c4 10             	add    $0x10,%esp
  8003b7:	c9                   	leave  
  8003b8:	c3                   	ret    

008003b9 <vprintfmt>:
{
  8003b9:	f3 0f 1e fb          	endbr32 
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	57                   	push   %edi
  8003c1:	56                   	push   %esi
  8003c2:	53                   	push   %ebx
  8003c3:	83 ec 3c             	sub    $0x3c,%esp
  8003c6:	e8 ba fd ff ff       	call   800185 <__x86.get_pc_thunk.ax>
  8003cb:	05 35 1c 00 00       	add    $0x1c35,%eax
  8003d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d3:	8b 75 08             	mov    0x8(%ebp),%esi
  8003d6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003dc:	8d 80 10 00 00 00    	lea    0x10(%eax),%eax
  8003e2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8003e5:	e9 cd 03 00 00       	jmp    8007b7 <.L25+0x48>
		padc = ' ';
  8003ea:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
  8003ee:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003f5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003fc:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800403:	b9 00 00 00 00       	mov    $0x0,%ecx
  800408:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80040b:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80040e:	8d 43 01             	lea    0x1(%ebx),%eax
  800411:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800414:	0f b6 13             	movzbl (%ebx),%edx
  800417:	8d 42 dd             	lea    -0x23(%edx),%eax
  80041a:	3c 55                	cmp    $0x55,%al
  80041c:	0f 87 21 04 00 00    	ja     800843 <.L20>
  800422:	0f b6 c0             	movzbl %al,%eax
  800425:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800428:	89 ce                	mov    %ecx,%esi
  80042a:	03 b4 81 fc ef ff ff 	add    -0x1004(%ecx,%eax,4),%esi
  800431:	3e ff e6             	notrack jmp *%esi

00800434 <.L68>:
  800434:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
  800437:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80043b:	eb d1                	jmp    80040e <vprintfmt+0x55>

0080043d <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
  80043d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800440:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800444:	eb c8                	jmp    80040e <vprintfmt+0x55>

00800446 <.L31>:
  800446:	0f b6 d2             	movzbl %dl,%edx
  800449:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
  80044c:	b8 00 00 00 00       	mov    $0x0,%eax
  800451:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
  800454:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800457:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80045b:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  80045e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800461:	83 f9 09             	cmp    $0x9,%ecx
  800464:	77 58                	ja     8004be <.L36+0xf>
			for (precision = 0; ; ++fmt) {
  800466:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800469:	eb e9                	jmp    800454 <.L31+0xe>

0080046b <.L34>:
			precision = va_arg(ap, int);
  80046b:	8b 45 14             	mov    0x14(%ebp),%eax
  80046e:	8b 00                	mov    (%eax),%eax
  800470:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800473:	8b 45 14             	mov    0x14(%ebp),%eax
  800476:	8d 40 04             	lea    0x4(%eax),%eax
  800479:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80047c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
  80047f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800483:	79 89                	jns    80040e <vprintfmt+0x55>
				width = precision, precision = -1;
  800485:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800488:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80048b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800492:	e9 77 ff ff ff       	jmp    80040e <vprintfmt+0x55>

00800497 <.L33>:
  800497:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80049a:	85 c0                	test   %eax,%eax
  80049c:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a1:	0f 49 d0             	cmovns %eax,%edx
  8004a4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004aa:	e9 5f ff ff ff       	jmp    80040e <vprintfmt+0x55>

008004af <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
  8004af:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
  8004b2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004b9:	e9 50 ff ff ff       	jmp    80040e <vprintfmt+0x55>
  8004be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c1:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c4:	eb b9                	jmp    80047f <.L34+0x14>

008004c6 <.L27>:
			lflag++;
  8004c6:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ca:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004cd:	e9 3c ff ff ff       	jmp    80040e <vprintfmt+0x55>

008004d2 <.L30>:
  8004d2:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(va_arg(ap, int), putdat);
  8004d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d8:	8d 58 04             	lea    0x4(%eax),%ebx
  8004db:	83 ec 08             	sub    $0x8,%esp
  8004de:	57                   	push   %edi
  8004df:	ff 30                	pushl  (%eax)
  8004e1:	ff d6                	call   *%esi
			break;
  8004e3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004e6:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
  8004e9:	e9 c6 02 00 00       	jmp    8007b4 <.L25+0x45>

008004ee <.L28>:
  8004ee:	8b 75 08             	mov    0x8(%ebp),%esi
			err = va_arg(ap, int);
  8004f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f4:	8d 58 04             	lea    0x4(%eax),%ebx
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	99                   	cltd   
  8004fa:	31 d0                	xor    %edx,%eax
  8004fc:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004fe:	83 f8 06             	cmp    $0x6,%eax
  800501:	7f 27                	jg     80052a <.L28+0x3c>
  800503:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800506:	8b 14 82             	mov    (%edx,%eax,4),%edx
  800509:	85 d2                	test   %edx,%edx
  80050b:	74 1d                	je     80052a <.L28+0x3c>
				printfmt(putch, putdat, "%s", p);
  80050d:	52                   	push   %edx
  80050e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800511:	8d 80 8e ef ff ff    	lea    -0x1072(%eax),%eax
  800517:	50                   	push   %eax
  800518:	57                   	push   %edi
  800519:	56                   	push   %esi
  80051a:	e8 79 fe ff ff       	call   800398 <printfmt>
  80051f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800522:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800525:	e9 8a 02 00 00       	jmp    8007b4 <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
  80052a:	50                   	push   %eax
  80052b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80052e:	8d 80 85 ef ff ff    	lea    -0x107b(%eax),%eax
  800534:	50                   	push   %eax
  800535:	57                   	push   %edi
  800536:	56                   	push   %esi
  800537:	e8 5c fe ff ff       	call   800398 <printfmt>
  80053c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80053f:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800542:	e9 6d 02 00 00       	jmp    8007b4 <.L25+0x45>

00800547 <.L24>:
  800547:	8b 75 08             	mov    0x8(%ebp),%esi
			if ((p = va_arg(ap, char *)) == NULL)
  80054a:	8b 45 14             	mov    0x14(%ebp),%eax
  80054d:	83 c0 04             	add    $0x4,%eax
  800550:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800553:	8b 45 14             	mov    0x14(%ebp),%eax
  800556:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800558:	85 d2                	test   %edx,%edx
  80055a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80055d:	8d 80 7e ef ff ff    	lea    -0x1082(%eax),%eax
  800563:	0f 45 c2             	cmovne %edx,%eax
  800566:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800569:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80056d:	7e 06                	jle    800575 <.L24+0x2e>
  80056f:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800573:	75 0d                	jne    800582 <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800575:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800578:	89 c3                	mov    %eax,%ebx
  80057a:	03 45 d4             	add    -0x2c(%ebp),%eax
  80057d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800580:	eb 58                	jmp    8005da <.L24+0x93>
  800582:	83 ec 08             	sub    $0x8,%esp
  800585:	ff 75 d8             	pushl  -0x28(%ebp)
  800588:	ff 75 c8             	pushl  -0x38(%ebp)
  80058b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80058e:	e8 7c 03 00 00       	call   80090f <strnlen>
  800593:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800596:	29 c2                	sub    %eax,%edx
  800598:	89 55 bc             	mov    %edx,-0x44(%ebp)
  80059b:	83 c4 10             	add    $0x10,%esp
  80059e:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
  8005a0:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005a4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a7:	85 db                	test   %ebx,%ebx
  8005a9:	7e 11                	jle    8005bc <.L24+0x75>
					putch(padc, putdat);
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	57                   	push   %edi
  8005af:	ff 75 d4             	pushl  -0x2c(%ebp)
  8005b2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b4:	83 eb 01             	sub    $0x1,%ebx
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	eb eb                	jmp    8005a7 <.L24+0x60>
  8005bc:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8005bf:	85 d2                	test   %edx,%edx
  8005c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c6:	0f 49 c2             	cmovns %edx,%eax
  8005c9:	29 c2                	sub    %eax,%edx
  8005cb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005ce:	eb a5                	jmp    800575 <.L24+0x2e>
					putch(ch, putdat);
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	57                   	push   %edi
  8005d4:	52                   	push   %edx
  8005d5:	ff d6                	call   *%esi
  8005d7:	83 c4 10             	add    $0x10,%esp
  8005da:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005dd:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005df:	83 c3 01             	add    $0x1,%ebx
  8005e2:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8005e6:	0f be d0             	movsbl %al,%edx
  8005e9:	85 d2                	test   %edx,%edx
  8005eb:	74 4b                	je     800638 <.L24+0xf1>
  8005ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005f1:	78 06                	js     8005f9 <.L24+0xb2>
  8005f3:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005f7:	78 1e                	js     800617 <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
  8005f9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005fd:	74 d1                	je     8005d0 <.L24+0x89>
  8005ff:	0f be c0             	movsbl %al,%eax
  800602:	83 e8 20             	sub    $0x20,%eax
  800605:	83 f8 5e             	cmp    $0x5e,%eax
  800608:	76 c6                	jbe    8005d0 <.L24+0x89>
					putch('?', putdat);
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	57                   	push   %edi
  80060e:	6a 3f                	push   $0x3f
  800610:	ff d6                	call   *%esi
  800612:	83 c4 10             	add    $0x10,%esp
  800615:	eb c3                	jmp    8005da <.L24+0x93>
  800617:	89 cb                	mov    %ecx,%ebx
  800619:	eb 0e                	jmp    800629 <.L24+0xe2>
				putch(' ', putdat);
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	57                   	push   %edi
  80061f:	6a 20                	push   $0x20
  800621:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800623:	83 eb 01             	sub    $0x1,%ebx
  800626:	83 c4 10             	add    $0x10,%esp
  800629:	85 db                	test   %ebx,%ebx
  80062b:	7f ee                	jg     80061b <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
  80062d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800630:	89 45 14             	mov    %eax,0x14(%ebp)
  800633:	e9 7c 01 00 00       	jmp    8007b4 <.L25+0x45>
  800638:	89 cb                	mov    %ecx,%ebx
  80063a:	eb ed                	jmp    800629 <.L24+0xe2>

0080063c <.L29>:
  80063c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80063f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  800642:	83 f9 01             	cmp    $0x1,%ecx
  800645:	7f 1b                	jg     800662 <.L29+0x26>
	else if (lflag)
  800647:	85 c9                	test   %ecx,%ecx
  800649:	74 63                	je     8006ae <.L29+0x72>
		return va_arg(*ap, long);
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800653:	99                   	cltd   
  800654:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8d 40 04             	lea    0x4(%eax),%eax
  80065d:	89 45 14             	mov    %eax,0x14(%ebp)
  800660:	eb 17                	jmp    800679 <.L29+0x3d>
		return va_arg(*ap, long long);
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8b 50 04             	mov    0x4(%eax),%edx
  800668:	8b 00                	mov    (%eax),%eax
  80066a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8d 40 08             	lea    0x8(%eax),%eax
  800676:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800679:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80067c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80067f:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800684:	85 c9                	test   %ecx,%ecx
  800686:	0f 89 0e 01 00 00    	jns    80079a <.L25+0x2b>
				putch('-', putdat);
  80068c:	83 ec 08             	sub    $0x8,%esp
  80068f:	57                   	push   %edi
  800690:	6a 2d                	push   $0x2d
  800692:	ff d6                	call   *%esi
				num = -(long long) num;
  800694:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800697:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80069a:	f7 da                	neg    %edx
  80069c:	83 d1 00             	adc    $0x0,%ecx
  80069f:	f7 d9                	neg    %ecx
  8006a1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a9:	e9 ec 00 00 00       	jmp    80079a <.L25+0x2b>
		return va_arg(*ap, int);
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b6:	99                   	cltd   
  8006b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	8d 40 04             	lea    0x4(%eax),%eax
  8006c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c3:	eb b4                	jmp    800679 <.L29+0x3d>

008006c5 <.L23>:
  8006c5:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006c8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  8006cb:	83 f9 01             	cmp    $0x1,%ecx
  8006ce:	7f 1e                	jg     8006ee <.L23+0x29>
	else if (lflag)
  8006d0:	85 c9                	test   %ecx,%ecx
  8006d2:	74 32                	je     800706 <.L23+0x41>
		return va_arg(*ap, unsigned long);
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8b 10                	mov    (%eax),%edx
  8006d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006de:	8d 40 04             	lea    0x4(%eax),%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e4:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8006e9:	e9 ac 00 00 00       	jmp    80079a <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  8006ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f1:	8b 10                	mov    (%eax),%edx
  8006f3:	8b 48 04             	mov    0x4(%eax),%ecx
  8006f6:	8d 40 08             	lea    0x8(%eax),%eax
  8006f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006fc:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800701:	e9 94 00 00 00       	jmp    80079a <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800706:	8b 45 14             	mov    0x14(%ebp),%eax
  800709:	8b 10                	mov    (%eax),%edx
  80070b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800710:	8d 40 04             	lea    0x4(%eax),%eax
  800713:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800716:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80071b:	eb 7d                	jmp    80079a <.L25+0x2b>

0080071d <.L26>:
  80071d:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800720:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  800723:	83 f9 01             	cmp    $0x1,%ecx
  800726:	7f 1b                	jg     800743 <.L26+0x26>
	else if (lflag)
  800728:	85 c9                	test   %ecx,%ecx
  80072a:	74 2c                	je     800758 <.L26+0x3b>
		return va_arg(*ap, unsigned long);
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8b 10                	mov    (%eax),%edx
  800731:	b9 00 00 00 00       	mov    $0x0,%ecx
  800736:	8d 40 04             	lea    0x4(%eax),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80073c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800741:	eb 57                	jmp    80079a <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8b 10                	mov    (%eax),%edx
  800748:	8b 48 04             	mov    0x4(%eax),%ecx
  80074b:	8d 40 08             	lea    0x8(%eax),%eax
  80074e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800751:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800756:	eb 42                	jmp    80079a <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	8b 10                	mov    (%eax),%edx
  80075d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800762:	8d 40 04             	lea    0x4(%eax),%eax
  800765:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800768:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80076d:	eb 2b                	jmp    80079a <.L25+0x2b>

0080076f <.L25>:
  80076f:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('0', putdat);
  800772:	83 ec 08             	sub    $0x8,%esp
  800775:	57                   	push   %edi
  800776:	6a 30                	push   $0x30
  800778:	ff d6                	call   *%esi
			putch('x', putdat);
  80077a:	83 c4 08             	add    $0x8,%esp
  80077d:	57                   	push   %edi
  80077e:	6a 78                	push   $0x78
  800780:	ff d6                	call   *%esi
			num = (unsigned long long)
  800782:	8b 45 14             	mov    0x14(%ebp),%eax
  800785:	8b 10                	mov    (%eax),%edx
  800787:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80078c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80078f:	8d 40 04             	lea    0x4(%eax),%eax
  800792:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800795:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80079a:	83 ec 0c             	sub    $0xc,%esp
  80079d:	0f be 5d cf          	movsbl -0x31(%ebp),%ebx
  8007a1:	53                   	push   %ebx
  8007a2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8007a5:	50                   	push   %eax
  8007a6:	51                   	push   %ecx
  8007a7:	52                   	push   %edx
  8007a8:	89 fa                	mov    %edi,%edx
  8007aa:	89 f0                	mov    %esi,%eax
  8007ac:	e8 08 fb ff ff       	call   8002b9 <printnum>
			break;
  8007b1:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007b4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b7:	83 c3 01             	add    $0x1,%ebx
  8007ba:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8007be:	83 f8 25             	cmp    $0x25,%eax
  8007c1:	0f 84 23 fc ff ff    	je     8003ea <vprintfmt+0x31>
			if (ch == '\0')
  8007c7:	85 c0                	test   %eax,%eax
  8007c9:	0f 84 97 00 00 00    	je     800866 <.L20+0x23>
			putch(ch, putdat);
  8007cf:	83 ec 08             	sub    $0x8,%esp
  8007d2:	57                   	push   %edi
  8007d3:	50                   	push   %eax
  8007d4:	ff d6                	call   *%esi
  8007d6:	83 c4 10             	add    $0x10,%esp
  8007d9:	eb dc                	jmp    8007b7 <.L25+0x48>

008007db <.L21>:
  8007db:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8007de:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  8007e1:	83 f9 01             	cmp    $0x1,%ecx
  8007e4:	7f 1b                	jg     800801 <.L21+0x26>
	else if (lflag)
  8007e6:	85 c9                	test   %ecx,%ecx
  8007e8:	74 2c                	je     800816 <.L21+0x3b>
		return va_arg(*ap, unsigned long);
  8007ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ed:	8b 10                	mov    (%eax),%edx
  8007ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007f4:	8d 40 04             	lea    0x4(%eax),%eax
  8007f7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007fa:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8007ff:	eb 99                	jmp    80079a <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	8b 10                	mov    (%eax),%edx
  800806:	8b 48 04             	mov    0x4(%eax),%ecx
  800809:	8d 40 08             	lea    0x8(%eax),%eax
  80080c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80080f:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800814:	eb 84                	jmp    80079a <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	8b 10                	mov    (%eax),%edx
  80081b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800820:	8d 40 04             	lea    0x4(%eax),%eax
  800823:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800826:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80082b:	e9 6a ff ff ff       	jmp    80079a <.L25+0x2b>

00800830 <.L35>:
  800830:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(ch, putdat);
  800833:	83 ec 08             	sub    $0x8,%esp
  800836:	57                   	push   %edi
  800837:	6a 25                	push   $0x25
  800839:	ff d6                	call   *%esi
			break;
  80083b:	83 c4 10             	add    $0x10,%esp
  80083e:	e9 71 ff ff ff       	jmp    8007b4 <.L25+0x45>

00800843 <.L20>:
  800843:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('%', putdat);
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	57                   	push   %edi
  80084a:	6a 25                	push   $0x25
  80084c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80084e:	83 c4 10             	add    $0x10,%esp
  800851:	89 d8                	mov    %ebx,%eax
  800853:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800857:	74 05                	je     80085e <.L20+0x1b>
  800859:	83 e8 01             	sub    $0x1,%eax
  80085c:	eb f5                	jmp    800853 <.L20+0x10>
  80085e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800861:	e9 4e ff ff ff       	jmp    8007b4 <.L25+0x45>
}
  800866:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800869:	5b                   	pop    %ebx
  80086a:	5e                   	pop    %esi
  80086b:	5f                   	pop    %edi
  80086c:	5d                   	pop    %ebp
  80086d:	c3                   	ret    

0080086e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80086e:	f3 0f 1e fb          	endbr32 
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	53                   	push   %ebx
  800876:	83 ec 14             	sub    $0x14,%esp
  800879:	e8 1d f8 ff ff       	call   80009b <__x86.get_pc_thunk.bx>
  80087e:	81 c3 82 17 00 00    	add    $0x1782,%ebx
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80088a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80088d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800891:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800894:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80089b:	85 c0                	test   %eax,%eax
  80089d:	74 2b                	je     8008ca <vsnprintf+0x5c>
  80089f:	85 d2                	test   %edx,%edx
  8008a1:	7e 27                	jle    8008ca <vsnprintf+0x5c>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008a3:	ff 75 14             	pushl  0x14(%ebp)
  8008a6:	ff 75 10             	pushl  0x10(%ebp)
  8008a9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ac:	50                   	push   %eax
  8008ad:	8d 83 77 e3 ff ff    	lea    -0x1c89(%ebx),%eax
  8008b3:	50                   	push   %eax
  8008b4:	e8 00 fb ff ff       	call   8003b9 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008bc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c2:	83 c4 10             	add    $0x10,%esp
}
  8008c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c8:	c9                   	leave  
  8008c9:	c3                   	ret    
		return -E_INVAL;
  8008ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008cf:	eb f4                	jmp    8008c5 <vsnprintf+0x57>

008008d1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008d1:	f3 0f 1e fb          	endbr32 
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008db:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008de:	50                   	push   %eax
  8008df:	ff 75 10             	pushl  0x10(%ebp)
  8008e2:	ff 75 0c             	pushl  0xc(%ebp)
  8008e5:	ff 75 08             	pushl  0x8(%ebp)
  8008e8:	e8 81 ff ff ff       	call   80086e <vsnprintf>
	va_end(ap);

	return rc;
}
  8008ed:	c9                   	leave  
  8008ee:	c3                   	ret    

008008ef <__x86.get_pc_thunk.cx>:
  8008ef:	8b 0c 24             	mov    (%esp),%ecx
  8008f2:	c3                   	ret    

008008f3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008f3:	f3 0f 1e fb          	endbr32 
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800902:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800906:	74 05                	je     80090d <strlen+0x1a>
		n++;
  800908:	83 c0 01             	add    $0x1,%eax
  80090b:	eb f5                	jmp    800902 <strlen+0xf>
	return n;
}
  80090d:	5d                   	pop    %ebp
  80090e:	c3                   	ret    

0080090f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80090f:	f3 0f 1e fb          	endbr32 
  800913:	55                   	push   %ebp
  800914:	89 e5                	mov    %esp,%ebp
  800916:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800919:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80091c:	b8 00 00 00 00       	mov    $0x0,%eax
  800921:	39 d0                	cmp    %edx,%eax
  800923:	74 0d                	je     800932 <strnlen+0x23>
  800925:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800929:	74 05                	je     800930 <strnlen+0x21>
		n++;
  80092b:	83 c0 01             	add    $0x1,%eax
  80092e:	eb f1                	jmp    800921 <strnlen+0x12>
  800930:	89 c2                	mov    %eax,%edx
	return n;
}
  800932:	89 d0                	mov    %edx,%eax
  800934:	5d                   	pop    %ebp
  800935:	c3                   	ret    

00800936 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800936:	f3 0f 1e fb          	endbr32 
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	53                   	push   %ebx
  80093e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800941:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800944:	b8 00 00 00 00       	mov    $0x0,%eax
  800949:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80094d:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800950:	83 c0 01             	add    $0x1,%eax
  800953:	84 d2                	test   %dl,%dl
  800955:	75 f2                	jne    800949 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800957:	89 c8                	mov    %ecx,%eax
  800959:	5b                   	pop    %ebx
  80095a:	5d                   	pop    %ebp
  80095b:	c3                   	ret    

0080095c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80095c:	f3 0f 1e fb          	endbr32 
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	53                   	push   %ebx
  800964:	83 ec 10             	sub    $0x10,%esp
  800967:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80096a:	53                   	push   %ebx
  80096b:	e8 83 ff ff ff       	call   8008f3 <strlen>
  800970:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800973:	ff 75 0c             	pushl  0xc(%ebp)
  800976:	01 d8                	add    %ebx,%eax
  800978:	50                   	push   %eax
  800979:	e8 b8 ff ff ff       	call   800936 <strcpy>
	return dst;
}
  80097e:	89 d8                	mov    %ebx,%eax
  800980:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800983:	c9                   	leave  
  800984:	c3                   	ret    

00800985 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800985:	f3 0f 1e fb          	endbr32 
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	56                   	push   %esi
  80098d:	53                   	push   %ebx
  80098e:	8b 75 08             	mov    0x8(%ebp),%esi
  800991:	8b 55 0c             	mov    0xc(%ebp),%edx
  800994:	89 f3                	mov    %esi,%ebx
  800996:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800999:	89 f0                	mov    %esi,%eax
  80099b:	39 d8                	cmp    %ebx,%eax
  80099d:	74 11                	je     8009b0 <strncpy+0x2b>
		*dst++ = *src;
  80099f:	83 c0 01             	add    $0x1,%eax
  8009a2:	0f b6 0a             	movzbl (%edx),%ecx
  8009a5:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009a8:	80 f9 01             	cmp    $0x1,%cl
  8009ab:	83 da ff             	sbb    $0xffffffff,%edx
  8009ae:	eb eb                	jmp    80099b <strncpy+0x16>
	}
	return ret;
}
  8009b0:	89 f0                	mov    %esi,%eax
  8009b2:	5b                   	pop    %ebx
  8009b3:	5e                   	pop    %esi
  8009b4:	5d                   	pop    %ebp
  8009b5:	c3                   	ret    

008009b6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009b6:	f3 0f 1e fb          	endbr32 
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	56                   	push   %esi
  8009be:	53                   	push   %ebx
  8009bf:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c5:	8b 55 10             	mov    0x10(%ebp),%edx
  8009c8:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009ca:	85 d2                	test   %edx,%edx
  8009cc:	74 21                	je     8009ef <strlcpy+0x39>
  8009ce:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009d2:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009d4:	39 c2                	cmp    %eax,%edx
  8009d6:	74 14                	je     8009ec <strlcpy+0x36>
  8009d8:	0f b6 19             	movzbl (%ecx),%ebx
  8009db:	84 db                	test   %bl,%bl
  8009dd:	74 0b                	je     8009ea <strlcpy+0x34>
			*dst++ = *src++;
  8009df:	83 c1 01             	add    $0x1,%ecx
  8009e2:	83 c2 01             	add    $0x1,%edx
  8009e5:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009e8:	eb ea                	jmp    8009d4 <strlcpy+0x1e>
  8009ea:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ec:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009ef:	29 f0                	sub    %esi,%eax
}
  8009f1:	5b                   	pop    %ebx
  8009f2:	5e                   	pop    %esi
  8009f3:	5d                   	pop    %ebp
  8009f4:	c3                   	ret    

008009f5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009f5:	f3 0f 1e fb          	endbr32 
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ff:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a02:	0f b6 01             	movzbl (%ecx),%eax
  800a05:	84 c0                	test   %al,%al
  800a07:	74 0c                	je     800a15 <strcmp+0x20>
  800a09:	3a 02                	cmp    (%edx),%al
  800a0b:	75 08                	jne    800a15 <strcmp+0x20>
		p++, q++;
  800a0d:	83 c1 01             	add    $0x1,%ecx
  800a10:	83 c2 01             	add    $0x1,%edx
  800a13:	eb ed                	jmp    800a02 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a15:	0f b6 c0             	movzbl %al,%eax
  800a18:	0f b6 12             	movzbl (%edx),%edx
  800a1b:	29 d0                	sub    %edx,%eax
}
  800a1d:	5d                   	pop    %ebp
  800a1e:	c3                   	ret    

00800a1f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a1f:	f3 0f 1e fb          	endbr32 
  800a23:	55                   	push   %ebp
  800a24:	89 e5                	mov    %esp,%ebp
  800a26:	53                   	push   %ebx
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2d:	89 c3                	mov    %eax,%ebx
  800a2f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a32:	eb 06                	jmp    800a3a <strncmp+0x1b>
		n--, p++, q++;
  800a34:	83 c0 01             	add    $0x1,%eax
  800a37:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a3a:	39 d8                	cmp    %ebx,%eax
  800a3c:	74 16                	je     800a54 <strncmp+0x35>
  800a3e:	0f b6 08             	movzbl (%eax),%ecx
  800a41:	84 c9                	test   %cl,%cl
  800a43:	74 04                	je     800a49 <strncmp+0x2a>
  800a45:	3a 0a                	cmp    (%edx),%cl
  800a47:	74 eb                	je     800a34 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a49:	0f b6 00             	movzbl (%eax),%eax
  800a4c:	0f b6 12             	movzbl (%edx),%edx
  800a4f:	29 d0                	sub    %edx,%eax
}
  800a51:	5b                   	pop    %ebx
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    
		return 0;
  800a54:	b8 00 00 00 00       	mov    $0x0,%eax
  800a59:	eb f6                	jmp    800a51 <strncmp+0x32>

00800a5b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a5b:	f3 0f 1e fb          	endbr32 
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a69:	0f b6 10             	movzbl (%eax),%edx
  800a6c:	84 d2                	test   %dl,%dl
  800a6e:	74 09                	je     800a79 <strchr+0x1e>
		if (*s == c)
  800a70:	38 ca                	cmp    %cl,%dl
  800a72:	74 0a                	je     800a7e <strchr+0x23>
	for (; *s; s++)
  800a74:	83 c0 01             	add    $0x1,%eax
  800a77:	eb f0                	jmp    800a69 <strchr+0xe>
			return (char *) s;
	return 0;
  800a79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a7e:	5d                   	pop    %ebp
  800a7f:	c3                   	ret    

00800a80 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a80:	f3 0f 1e fb          	endbr32 
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a8e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a91:	38 ca                	cmp    %cl,%dl
  800a93:	74 09                	je     800a9e <strfind+0x1e>
  800a95:	84 d2                	test   %dl,%dl
  800a97:	74 05                	je     800a9e <strfind+0x1e>
	for (; *s; s++)
  800a99:	83 c0 01             	add    $0x1,%eax
  800a9c:	eb f0                	jmp    800a8e <strfind+0xe>
			break;
	return (char *) s;
}
  800a9e:	5d                   	pop    %ebp
  800a9f:	c3                   	ret    

00800aa0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aa0:	f3 0f 1e fb          	endbr32 
  800aa4:	55                   	push   %ebp
  800aa5:	89 e5                	mov    %esp,%ebp
  800aa7:	57                   	push   %edi
  800aa8:	56                   	push   %esi
  800aa9:	53                   	push   %ebx
  800aaa:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aad:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ab0:	85 c9                	test   %ecx,%ecx
  800ab2:	74 31                	je     800ae5 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ab4:	89 f8                	mov    %edi,%eax
  800ab6:	09 c8                	or     %ecx,%eax
  800ab8:	a8 03                	test   $0x3,%al
  800aba:	75 23                	jne    800adf <memset+0x3f>
		c &= 0xFF;
  800abc:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ac0:	89 d3                	mov    %edx,%ebx
  800ac2:	c1 e3 08             	shl    $0x8,%ebx
  800ac5:	89 d0                	mov    %edx,%eax
  800ac7:	c1 e0 18             	shl    $0x18,%eax
  800aca:	89 d6                	mov    %edx,%esi
  800acc:	c1 e6 10             	shl    $0x10,%esi
  800acf:	09 f0                	or     %esi,%eax
  800ad1:	09 c2                	or     %eax,%edx
  800ad3:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ad5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ad8:	89 d0                	mov    %edx,%eax
  800ada:	fc                   	cld    
  800adb:	f3 ab                	rep stos %eax,%es:(%edi)
  800add:	eb 06                	jmp    800ae5 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800adf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae2:	fc                   	cld    
  800ae3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ae5:	89 f8                	mov    %edi,%eax
  800ae7:	5b                   	pop    %ebx
  800ae8:	5e                   	pop    %esi
  800ae9:	5f                   	pop    %edi
  800aea:	5d                   	pop    %ebp
  800aeb:	c3                   	ret    

00800aec <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aec:	f3 0f 1e fb          	endbr32 
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	57                   	push   %edi
  800af4:	56                   	push   %esi
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800afb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800afe:	39 c6                	cmp    %eax,%esi
  800b00:	73 32                	jae    800b34 <memmove+0x48>
  800b02:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b05:	39 c2                	cmp    %eax,%edx
  800b07:	76 2b                	jbe    800b34 <memmove+0x48>
		s += n;
		d += n;
  800b09:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0c:	89 fe                	mov    %edi,%esi
  800b0e:	09 ce                	or     %ecx,%esi
  800b10:	09 d6                	or     %edx,%esi
  800b12:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b18:	75 0e                	jne    800b28 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b1a:	83 ef 04             	sub    $0x4,%edi
  800b1d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b20:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b23:	fd                   	std    
  800b24:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b26:	eb 09                	jmp    800b31 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b28:	83 ef 01             	sub    $0x1,%edi
  800b2b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b2e:	fd                   	std    
  800b2f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b31:	fc                   	cld    
  800b32:	eb 1a                	jmp    800b4e <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b34:	89 c2                	mov    %eax,%edx
  800b36:	09 ca                	or     %ecx,%edx
  800b38:	09 f2                	or     %esi,%edx
  800b3a:	f6 c2 03             	test   $0x3,%dl
  800b3d:	75 0a                	jne    800b49 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b3f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b42:	89 c7                	mov    %eax,%edi
  800b44:	fc                   	cld    
  800b45:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b47:	eb 05                	jmp    800b4e <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b49:	89 c7                	mov    %eax,%edi
  800b4b:	fc                   	cld    
  800b4c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b4e:	5e                   	pop    %esi
  800b4f:	5f                   	pop    %edi
  800b50:	5d                   	pop    %ebp
  800b51:	c3                   	ret    

00800b52 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b52:	f3 0f 1e fb          	endbr32 
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b5c:	ff 75 10             	pushl  0x10(%ebp)
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	ff 75 08             	pushl  0x8(%ebp)
  800b65:	e8 82 ff ff ff       	call   800aec <memmove>
}
  800b6a:	c9                   	leave  
  800b6b:	c3                   	ret    

00800b6c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b6c:	f3 0f 1e fb          	endbr32 
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	56                   	push   %esi
  800b74:	53                   	push   %ebx
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7b:	89 c6                	mov    %eax,%esi
  800b7d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b80:	39 f0                	cmp    %esi,%eax
  800b82:	74 1c                	je     800ba0 <memcmp+0x34>
		if (*s1 != *s2)
  800b84:	0f b6 08             	movzbl (%eax),%ecx
  800b87:	0f b6 1a             	movzbl (%edx),%ebx
  800b8a:	38 d9                	cmp    %bl,%cl
  800b8c:	75 08                	jne    800b96 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b8e:	83 c0 01             	add    $0x1,%eax
  800b91:	83 c2 01             	add    $0x1,%edx
  800b94:	eb ea                	jmp    800b80 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b96:	0f b6 c1             	movzbl %cl,%eax
  800b99:	0f b6 db             	movzbl %bl,%ebx
  800b9c:	29 d8                	sub    %ebx,%eax
  800b9e:	eb 05                	jmp    800ba5 <memcmp+0x39>
	}

	return 0;
  800ba0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba5:	5b                   	pop    %ebx
  800ba6:	5e                   	pop    %esi
  800ba7:	5d                   	pop    %ebp
  800ba8:	c3                   	ret    

00800ba9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ba9:	f3 0f 1e fb          	endbr32 
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bb6:	89 c2                	mov    %eax,%edx
  800bb8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bbb:	39 d0                	cmp    %edx,%eax
  800bbd:	73 09                	jae    800bc8 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bbf:	38 08                	cmp    %cl,(%eax)
  800bc1:	74 05                	je     800bc8 <memfind+0x1f>
	for (; s < ends; s++)
  800bc3:	83 c0 01             	add    $0x1,%eax
  800bc6:	eb f3                	jmp    800bbb <memfind+0x12>
			break;
	return (void *) s;
}
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bca:	f3 0f 1e fb          	endbr32 
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	57                   	push   %edi
  800bd2:	56                   	push   %esi
  800bd3:	53                   	push   %ebx
  800bd4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bda:	eb 03                	jmp    800bdf <strtol+0x15>
		s++;
  800bdc:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bdf:	0f b6 01             	movzbl (%ecx),%eax
  800be2:	3c 20                	cmp    $0x20,%al
  800be4:	74 f6                	je     800bdc <strtol+0x12>
  800be6:	3c 09                	cmp    $0x9,%al
  800be8:	74 f2                	je     800bdc <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800bea:	3c 2b                	cmp    $0x2b,%al
  800bec:	74 2a                	je     800c18 <strtol+0x4e>
	int neg = 0;
  800bee:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bf3:	3c 2d                	cmp    $0x2d,%al
  800bf5:	74 2b                	je     800c22 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bfd:	75 0f                	jne    800c0e <strtol+0x44>
  800bff:	80 39 30             	cmpb   $0x30,(%ecx)
  800c02:	74 28                	je     800c2c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c04:	85 db                	test   %ebx,%ebx
  800c06:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c0b:	0f 44 d8             	cmove  %eax,%ebx
  800c0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c13:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c16:	eb 46                	jmp    800c5e <strtol+0x94>
		s++;
  800c18:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c1b:	bf 00 00 00 00       	mov    $0x0,%edi
  800c20:	eb d5                	jmp    800bf7 <strtol+0x2d>
		s++, neg = 1;
  800c22:	83 c1 01             	add    $0x1,%ecx
  800c25:	bf 01 00 00 00       	mov    $0x1,%edi
  800c2a:	eb cb                	jmp    800bf7 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c2c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c30:	74 0e                	je     800c40 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c32:	85 db                	test   %ebx,%ebx
  800c34:	75 d8                	jne    800c0e <strtol+0x44>
		s++, base = 8;
  800c36:	83 c1 01             	add    $0x1,%ecx
  800c39:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c3e:	eb ce                	jmp    800c0e <strtol+0x44>
		s += 2, base = 16;
  800c40:	83 c1 02             	add    $0x2,%ecx
  800c43:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c48:	eb c4                	jmp    800c0e <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c4a:	0f be d2             	movsbl %dl,%edx
  800c4d:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c50:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c53:	7d 3a                	jge    800c8f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c55:	83 c1 01             	add    $0x1,%ecx
  800c58:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c5c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c5e:	0f b6 11             	movzbl (%ecx),%edx
  800c61:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c64:	89 f3                	mov    %esi,%ebx
  800c66:	80 fb 09             	cmp    $0x9,%bl
  800c69:	76 df                	jbe    800c4a <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c6b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c6e:	89 f3                	mov    %esi,%ebx
  800c70:	80 fb 19             	cmp    $0x19,%bl
  800c73:	77 08                	ja     800c7d <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c75:	0f be d2             	movsbl %dl,%edx
  800c78:	83 ea 57             	sub    $0x57,%edx
  800c7b:	eb d3                	jmp    800c50 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c7d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c80:	89 f3                	mov    %esi,%ebx
  800c82:	80 fb 19             	cmp    $0x19,%bl
  800c85:	77 08                	ja     800c8f <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c87:	0f be d2             	movsbl %dl,%edx
  800c8a:	83 ea 37             	sub    $0x37,%edx
  800c8d:	eb c1                	jmp    800c50 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c93:	74 05                	je     800c9a <strtol+0xd0>
		*endptr = (char *) s;
  800c95:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c98:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c9a:	89 c2                	mov    %eax,%edx
  800c9c:	f7 da                	neg    %edx
  800c9e:	85 ff                	test   %edi,%edi
  800ca0:	0f 45 c2             	cmovne %edx,%eax
}
  800ca3:	5b                   	pop    %ebx
  800ca4:	5e                   	pop    %esi
  800ca5:	5f                   	pop    %edi
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    
  800ca8:	66 90                	xchg   %ax,%ax
  800caa:	66 90                	xchg   %ax,%ax
  800cac:	66 90                	xchg   %ax,%ax
  800cae:	66 90                	xchg   %ax,%ax

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
