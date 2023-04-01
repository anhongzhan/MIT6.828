
obj/user/buggyhello:     file format elf32-i386


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
  80002c:	e8 2d 00 00 00       	call   80005e <libmain>
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
  80003e:	e8 17 00 00 00       	call   80005a <__x86.get_pc_thunk.bx>
  800043:	81 c3 bd 1f 00 00    	add    $0x1fbd,%ebx
	sys_cputs((char*)1, 1);
  800049:	6a 01                	push   $0x1
  80004b:	6a 01                	push   $0x1
  80004d:	e8 93 00 00 00       	call   8000e5 <sys_cputs>
}
  800052:	83 c4 10             	add    $0x10,%esp
  800055:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800058:	c9                   	leave  
  800059:	c3                   	ret    

0080005a <__x86.get_pc_thunk.bx>:
  80005a:	8b 1c 24             	mov    (%esp),%ebx
  80005d:	c3                   	ret    

0080005e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005e:	f3 0f 1e fb          	endbr32 
  800062:	55                   	push   %ebp
  800063:	89 e5                	mov    %esp,%ebp
  800065:	57                   	push   %edi
  800066:	56                   	push   %esi
  800067:	53                   	push   %ebx
  800068:	83 ec 0c             	sub    $0xc,%esp
  80006b:	e8 ea ff ff ff       	call   80005a <__x86.get_pc_thunk.bx>
  800070:	81 c3 90 1f 00 00    	add    $0x1f90,%ebx
  800076:	8b 75 08             	mov    0x8(%ebp),%esi
  800079:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80007c:	e8 02 01 00 00       	call   800183 <sys_getenvid>
  800081:	25 ff 03 00 00       	and    $0x3ff,%eax
  800086:	8d 04 40             	lea    (%eax,%eax,2),%eax
  800089:	c1 e0 05             	shl    $0x5,%eax
  80008c:	81 c0 00 00 c0 ee    	add    $0xeec00000,%eax
  800092:	c7 c2 2c 20 80 00    	mov    $0x80202c,%edx
  800098:	89 02                	mov    %eax,(%edx)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009a:	85 f6                	test   %esi,%esi
  80009c:	7e 08                	jle    8000a6 <libmain+0x48>
		binaryname = argv[0];
  80009e:	8b 07                	mov    (%edi),%eax
  8000a0:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  8000a6:	83 ec 08             	sub    $0x8,%esp
  8000a9:	57                   	push   %edi
  8000aa:	56                   	push   %esi
  8000ab:	e8 83 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000b0:	e8 0b 00 00 00       	call   8000c0 <exit>
}
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000bb:	5b                   	pop    %ebx
  8000bc:	5e                   	pop    %esi
  8000bd:	5f                   	pop    %edi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    

008000c0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c0:	f3 0f 1e fb          	endbr32 
  8000c4:	55                   	push   %ebp
  8000c5:	89 e5                	mov    %esp,%ebp
  8000c7:	53                   	push   %ebx
  8000c8:	83 ec 10             	sub    $0x10,%esp
  8000cb:	e8 8a ff ff ff       	call   80005a <__x86.get_pc_thunk.bx>
  8000d0:	81 c3 30 1f 00 00    	add    $0x1f30,%ebx
	sys_env_destroy(0);
  8000d6:	6a 00                	push   $0x0
  8000d8:	e8 4d 00 00 00       	call   80012a <sys_env_destroy>
}
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000e3:	c9                   	leave  
  8000e4:	c3                   	ret    

008000e5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000e5:	f3 0f 1e fb          	endbr32 
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	57                   	push   %edi
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000fa:	89 c3                	mov    %eax,%ebx
  8000fc:	89 c7                	mov    %eax,%edi
  8000fe:	89 c6                	mov    %eax,%esi
  800100:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800102:	5b                   	pop    %ebx
  800103:	5e                   	pop    %esi
  800104:	5f                   	pop    %edi
  800105:	5d                   	pop    %ebp
  800106:	c3                   	ret    

00800107 <sys_cgetc>:

int
sys_cgetc(void)
{
  800107:	f3 0f 1e fb          	endbr32 
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
  80010e:	57                   	push   %edi
  80010f:	56                   	push   %esi
  800110:	53                   	push   %ebx
	asm volatile("int %1\n"
  800111:	ba 00 00 00 00       	mov    $0x0,%edx
  800116:	b8 01 00 00 00       	mov    $0x1,%eax
  80011b:	89 d1                	mov    %edx,%ecx
  80011d:	89 d3                	mov    %edx,%ebx
  80011f:	89 d7                	mov    %edx,%edi
  800121:	89 d6                	mov    %edx,%esi
  800123:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800125:	5b                   	pop    %ebx
  800126:	5e                   	pop    %esi
  800127:	5f                   	pop    %edi
  800128:	5d                   	pop    %ebp
  800129:	c3                   	ret    

0080012a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80012a:	f3 0f 1e fb          	endbr32 
  80012e:	55                   	push   %ebp
  80012f:	89 e5                	mov    %esp,%ebp
  800131:	57                   	push   %edi
  800132:	56                   	push   %esi
  800133:	53                   	push   %ebx
  800134:	83 ec 1c             	sub    $0x1c,%esp
  800137:	e8 6a 00 00 00       	call   8001a6 <__x86.get_pc_thunk.ax>
  80013c:	05 c4 1e 00 00       	add    $0x1ec4,%eax
  800141:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("int %1\n"
  800144:	b9 00 00 00 00       	mov    $0x0,%ecx
  800149:	8b 55 08             	mov    0x8(%ebp),%edx
  80014c:	b8 03 00 00 00       	mov    $0x3,%eax
  800151:	89 cb                	mov    %ecx,%ebx
  800153:	89 cf                	mov    %ecx,%edi
  800155:	89 ce                	mov    %ecx,%esi
  800157:	cd 30                	int    $0x30
	if(check && ret > 0)
  800159:	85 c0                	test   %eax,%eax
  80015b:	7f 08                	jg     800165 <sys_env_destroy+0x3b>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80015d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800160:	5b                   	pop    %ebx
  800161:	5e                   	pop    %esi
  800162:	5f                   	pop    %edi
  800163:	5d                   	pop    %ebp
  800164:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	50                   	push   %eax
  800169:	6a 03                	push   $0x3
  80016b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80016e:	8d 83 3a ef ff ff    	lea    -0x10c6(%ebx),%eax
  800174:	50                   	push   %eax
  800175:	6a 23                	push   $0x23
  800177:	8d 83 57 ef ff ff    	lea    -0x10a9(%ebx),%eax
  80017d:	50                   	push   %eax
  80017e:	e8 27 00 00 00       	call   8001aa <_panic>

00800183 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800183:	f3 0f 1e fb          	endbr32 
  800187:	55                   	push   %ebp
  800188:	89 e5                	mov    %esp,%ebp
  80018a:	57                   	push   %edi
  80018b:	56                   	push   %esi
  80018c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80018d:	ba 00 00 00 00       	mov    $0x0,%edx
  800192:	b8 02 00 00 00       	mov    $0x2,%eax
  800197:	89 d1                	mov    %edx,%ecx
  800199:	89 d3                	mov    %edx,%ebx
  80019b:	89 d7                	mov    %edx,%edi
  80019d:	89 d6                	mov    %edx,%esi
  80019f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8001a1:	5b                   	pop    %ebx
  8001a2:	5e                   	pop    %esi
  8001a3:	5f                   	pop    %edi
  8001a4:	5d                   	pop    %ebp
  8001a5:	c3                   	ret    

008001a6 <__x86.get_pc_thunk.ax>:
  8001a6:	8b 04 24             	mov    (%esp),%eax
  8001a9:	c3                   	ret    

008001aa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001aa:	f3 0f 1e fb          	endbr32 
  8001ae:	55                   	push   %ebp
  8001af:	89 e5                	mov    %esp,%ebp
  8001b1:	57                   	push   %edi
  8001b2:	56                   	push   %esi
  8001b3:	53                   	push   %ebx
  8001b4:	83 ec 0c             	sub    $0xc,%esp
  8001b7:	e8 9e fe ff ff       	call   80005a <__x86.get_pc_thunk.bx>
  8001bc:	81 c3 44 1e 00 00    	add    $0x1e44,%ebx
	va_list ap;

	va_start(ap, fmt);
  8001c2:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001c5:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  8001cb:	8b 38                	mov    (%eax),%edi
  8001cd:	e8 b1 ff ff ff       	call   800183 <sys_getenvid>
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	ff 75 0c             	pushl  0xc(%ebp)
  8001d8:	ff 75 08             	pushl  0x8(%ebp)
  8001db:	57                   	push   %edi
  8001dc:	50                   	push   %eax
  8001dd:	8d 83 68 ef ff ff    	lea    -0x1098(%ebx),%eax
  8001e3:	50                   	push   %eax
  8001e4:	e8 d9 00 00 00       	call   8002c2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001e9:	83 c4 18             	add    $0x18,%esp
  8001ec:	56                   	push   %esi
  8001ed:	ff 75 10             	pushl  0x10(%ebp)
  8001f0:	e8 67 00 00 00       	call   80025c <vcprintf>
	cprintf("\n");
  8001f5:	8d 83 8b ef ff ff    	lea    -0x1075(%ebx),%eax
  8001fb:	89 04 24             	mov    %eax,(%esp)
  8001fe:	e8 bf 00 00 00       	call   8002c2 <cprintf>
  800203:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800206:	cc                   	int3   
  800207:	eb fd                	jmp    800206 <_panic+0x5c>

00800209 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800209:	f3 0f 1e fb          	endbr32 
  80020d:	55                   	push   %ebp
  80020e:	89 e5                	mov    %esp,%ebp
  800210:	56                   	push   %esi
  800211:	53                   	push   %ebx
  800212:	e8 43 fe ff ff       	call   80005a <__x86.get_pc_thunk.bx>
  800217:	81 c3 e9 1d 00 00    	add    $0x1de9,%ebx
  80021d:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  800220:	8b 16                	mov    (%esi),%edx
  800222:	8d 42 01             	lea    0x1(%edx),%eax
  800225:	89 06                	mov    %eax,(%esi)
  800227:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80022a:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  80022e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800233:	74 0b                	je     800240 <putch+0x37>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800235:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  800239:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80023c:	5b                   	pop    %ebx
  80023d:	5e                   	pop    %esi
  80023e:	5d                   	pop    %ebp
  80023f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800240:	83 ec 08             	sub    $0x8,%esp
  800243:	68 ff 00 00 00       	push   $0xff
  800248:	8d 46 08             	lea    0x8(%esi),%eax
  80024b:	50                   	push   %eax
  80024c:	e8 94 fe ff ff       	call   8000e5 <sys_cputs>
		b->idx = 0;
  800251:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  800257:	83 c4 10             	add    $0x10,%esp
  80025a:	eb d9                	jmp    800235 <putch+0x2c>

0080025c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80025c:	f3 0f 1e fb          	endbr32 
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	53                   	push   %ebx
  800264:	81 ec 14 01 00 00    	sub    $0x114,%esp
  80026a:	e8 eb fd ff ff       	call   80005a <__x86.get_pc_thunk.bx>
  80026f:	81 c3 91 1d 00 00    	add    $0x1d91,%ebx
	struct printbuf b;

	b.idx = 0;
  800275:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80027c:	00 00 00 
	b.cnt = 0;
  80027f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800286:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800289:	ff 75 0c             	pushl  0xc(%ebp)
  80028c:	ff 75 08             	pushl  0x8(%ebp)
  80028f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800295:	50                   	push   %eax
  800296:	8d 83 09 e2 ff ff    	lea    -0x1df7(%ebx),%eax
  80029c:	50                   	push   %eax
  80029d:	e8 38 01 00 00       	call   8003da <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002a2:	83 c4 08             	add    $0x8,%esp
  8002a5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002ab:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002b1:	50                   	push   %eax
  8002b2:	e8 2e fe ff ff       	call   8000e5 <sys_cputs>

	return b.cnt;
}
  8002b7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002c2:	f3 0f 1e fb          	endbr32 
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002cc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002cf:	50                   	push   %eax
  8002d0:	ff 75 08             	pushl  0x8(%ebp)
  8002d3:	e8 84 ff ff ff       	call   80025c <vcprintf>
	va_end(ap);

	return cnt;
}
  8002d8:	c9                   	leave  
  8002d9:	c3                   	ret    

008002da <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	57                   	push   %edi
  8002de:	56                   	push   %esi
  8002df:	53                   	push   %ebx
  8002e0:	83 ec 2c             	sub    $0x2c,%esp
  8002e3:	e8 28 06 00 00       	call   800910 <__x86.get_pc_thunk.cx>
  8002e8:	81 c1 18 1d 00 00    	add    $0x1d18,%ecx
  8002ee:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002f1:	89 c7                	mov    %eax,%edi
  8002f3:	89 d6                	mov    %edx,%esi
  8002f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002fb:	89 d1                	mov    %edx,%ecx
  8002fd:	89 c2                	mov    %eax,%edx
  8002ff:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800302:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800305:	8b 45 10             	mov    0x10(%ebp),%eax
  800308:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80030b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80030e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800315:	39 c2                	cmp    %eax,%edx
  800317:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80031a:	72 41                	jb     80035d <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80031c:	83 ec 0c             	sub    $0xc,%esp
  80031f:	ff 75 18             	pushl  0x18(%ebp)
  800322:	83 eb 01             	sub    $0x1,%ebx
  800325:	53                   	push   %ebx
  800326:	50                   	push   %eax
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80032d:	ff 75 e0             	pushl  -0x20(%ebp)
  800330:	ff 75 d4             	pushl  -0x2c(%ebp)
  800333:	ff 75 d0             	pushl  -0x30(%ebp)
  800336:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800339:	e8 92 09 00 00       	call   800cd0 <__udivdi3>
  80033e:	83 c4 18             	add    $0x18,%esp
  800341:	52                   	push   %edx
  800342:	50                   	push   %eax
  800343:	89 f2                	mov    %esi,%edx
  800345:	89 f8                	mov    %edi,%eax
  800347:	e8 8e ff ff ff       	call   8002da <printnum>
  80034c:	83 c4 20             	add    $0x20,%esp
  80034f:	eb 13                	jmp    800364 <printnum+0x8a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800351:	83 ec 08             	sub    $0x8,%esp
  800354:	56                   	push   %esi
  800355:	ff 75 18             	pushl  0x18(%ebp)
  800358:	ff d7                	call   *%edi
  80035a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80035d:	83 eb 01             	sub    $0x1,%ebx
  800360:	85 db                	test   %ebx,%ebx
  800362:	7f ed                	jg     800351 <printnum+0x77>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800364:	83 ec 08             	sub    $0x8,%esp
  800367:	56                   	push   %esi
  800368:	83 ec 04             	sub    $0x4,%esp
  80036b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80036e:	ff 75 e0             	pushl  -0x20(%ebp)
  800371:	ff 75 d4             	pushl  -0x2c(%ebp)
  800374:	ff 75 d0             	pushl  -0x30(%ebp)
  800377:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80037a:	e8 61 0a 00 00       	call   800de0 <__umoddi3>
  80037f:	83 c4 14             	add    $0x14,%esp
  800382:	0f be 84 03 8d ef ff 	movsbl -0x1073(%ebx,%eax,1),%eax
  800389:	ff 
  80038a:	50                   	push   %eax
  80038b:	ff d7                	call   *%edi
}
  80038d:	83 c4 10             	add    $0x10,%esp
  800390:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800393:	5b                   	pop    %ebx
  800394:	5e                   	pop    %esi
  800395:	5f                   	pop    %edi
  800396:	5d                   	pop    %ebp
  800397:	c3                   	ret    

00800398 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800398:	f3 0f 1e fb          	endbr32 
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003a2:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003a6:	8b 10                	mov    (%eax),%edx
  8003a8:	3b 50 04             	cmp    0x4(%eax),%edx
  8003ab:	73 0a                	jae    8003b7 <sprintputch+0x1f>
		*b->buf++ = ch;
  8003ad:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003b0:	89 08                	mov    %ecx,(%eax)
  8003b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b5:	88 02                	mov    %al,(%edx)
}
  8003b7:	5d                   	pop    %ebp
  8003b8:	c3                   	ret    

008003b9 <printfmt>:
{
  8003b9:	f3 0f 1e fb          	endbr32 
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003c3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003c6:	50                   	push   %eax
  8003c7:	ff 75 10             	pushl  0x10(%ebp)
  8003ca:	ff 75 0c             	pushl  0xc(%ebp)
  8003cd:	ff 75 08             	pushl  0x8(%ebp)
  8003d0:	e8 05 00 00 00       	call   8003da <vprintfmt>
}
  8003d5:	83 c4 10             	add    $0x10,%esp
  8003d8:	c9                   	leave  
  8003d9:	c3                   	ret    

008003da <vprintfmt>:
{
  8003da:	f3 0f 1e fb          	endbr32 
  8003de:	55                   	push   %ebp
  8003df:	89 e5                	mov    %esp,%ebp
  8003e1:	57                   	push   %edi
  8003e2:	56                   	push   %esi
  8003e3:	53                   	push   %ebx
  8003e4:	83 ec 3c             	sub    $0x3c,%esp
  8003e7:	e8 ba fd ff ff       	call   8001a6 <__x86.get_pc_thunk.ax>
  8003ec:	05 14 1c 00 00       	add    $0x1c14,%eax
  8003f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8003f7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003fd:	8d 80 10 00 00 00    	lea    0x10(%eax),%eax
  800403:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800406:	e9 cd 03 00 00       	jmp    8007d8 <.L25+0x48>
		padc = ' ';
  80040b:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		altflag = 0;
  80040f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800416:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80041d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		lflag = 0;
  800424:	b9 00 00 00 00       	mov    $0x0,%ecx
  800429:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80042c:	89 75 08             	mov    %esi,0x8(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80042f:	8d 43 01             	lea    0x1(%ebx),%eax
  800432:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800435:	0f b6 13             	movzbl (%ebx),%edx
  800438:	8d 42 dd             	lea    -0x23(%edx),%eax
  80043b:	3c 55                	cmp    $0x55,%al
  80043d:	0f 87 21 04 00 00    	ja     800864 <.L20>
  800443:	0f b6 c0             	movzbl %al,%eax
  800446:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800449:	89 ce                	mov    %ecx,%esi
  80044b:	03 b4 81 1c f0 ff ff 	add    -0xfe4(%ecx,%eax,4),%esi
  800452:	3e ff e6             	notrack jmp *%esi

00800455 <.L68>:
  800455:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			padc = '-';
  800458:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80045c:	eb d1                	jmp    80042f <vprintfmt+0x55>

0080045e <.L32>:
		switch (ch = *(unsigned char *) fmt++) {
  80045e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800461:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800465:	eb c8                	jmp    80042f <vprintfmt+0x55>

00800467 <.L31>:
  800467:	0f b6 d2             	movzbl %dl,%edx
  80046a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			for (precision = 0; ; ++fmt) {
  80046d:	b8 00 00 00 00       	mov    $0x0,%eax
  800472:	8b 75 08             	mov    0x8(%ebp),%esi
				precision = precision * 10 + ch - '0';
  800475:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800478:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80047c:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  80047f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800482:	83 f9 09             	cmp    $0x9,%ecx
  800485:	77 58                	ja     8004df <.L36+0xf>
			for (precision = 0; ; ++fmt) {
  800487:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  80048a:	eb e9                	jmp    800475 <.L31+0xe>

0080048c <.L34>:
			precision = va_arg(ap, int);
  80048c:	8b 45 14             	mov    0x14(%ebp),%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800494:	8b 45 14             	mov    0x14(%ebp),%eax
  800497:	8d 40 04             	lea    0x4(%eax),%eax
  80049a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80049d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			if (width < 0)
  8004a0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004a4:	79 89                	jns    80042f <vprintfmt+0x55>
				width = precision, precision = -1;
  8004a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004ac:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004b3:	e9 77 ff ff ff       	jmp    80042f <vprintfmt+0x55>

008004b8 <.L33>:
  8004b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004bb:	85 c0                	test   %eax,%eax
  8004bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c2:	0f 49 d0             	cmovns %eax,%edx
  8004c5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c8:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004cb:	e9 5f ff ff ff       	jmp    80042f <vprintfmt+0x55>

008004d0 <.L36>:
		switch (ch = *(unsigned char *) fmt++) {
  8004d0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			altflag = 1;
  8004d3:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004da:	e9 50 ff ff ff       	jmp    80042f <vprintfmt+0x55>
  8004df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e2:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e5:	eb b9                	jmp    8004a0 <.L34+0x14>

008004e7 <.L27>:
			lflag++;
  8004e7:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004eb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			goto reswitch;
  8004ee:	e9 3c ff ff ff       	jmp    80042f <vprintfmt+0x55>

008004f3 <.L30>:
  8004f3:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(va_arg(ap, int), putdat);
  8004f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f9:	8d 58 04             	lea    0x4(%eax),%ebx
  8004fc:	83 ec 08             	sub    $0x8,%esp
  8004ff:	57                   	push   %edi
  800500:	ff 30                	pushl  (%eax)
  800502:	ff d6                	call   *%esi
			break;
  800504:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800507:	89 5d 14             	mov    %ebx,0x14(%ebp)
			break;
  80050a:	e9 c6 02 00 00       	jmp    8007d5 <.L25+0x45>

0080050f <.L28>:
  80050f:	8b 75 08             	mov    0x8(%ebp),%esi
			err = va_arg(ap, int);
  800512:	8b 45 14             	mov    0x14(%ebp),%eax
  800515:	8d 58 04             	lea    0x4(%eax),%ebx
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	99                   	cltd   
  80051b:	31 d0                	xor    %edx,%eax
  80051d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80051f:	83 f8 06             	cmp    $0x6,%eax
  800522:	7f 27                	jg     80054b <.L28+0x3c>
  800524:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800527:	8b 14 82             	mov    (%edx,%eax,4),%edx
  80052a:	85 d2                	test   %edx,%edx
  80052c:	74 1d                	je     80054b <.L28+0x3c>
				printfmt(putch, putdat, "%s", p);
  80052e:	52                   	push   %edx
  80052f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800532:	8d 80 ae ef ff ff    	lea    -0x1052(%eax),%eax
  800538:	50                   	push   %eax
  800539:	57                   	push   %edi
  80053a:	56                   	push   %esi
  80053b:	e8 79 fe ff ff       	call   8003b9 <printfmt>
  800540:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800543:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800546:	e9 8a 02 00 00       	jmp    8007d5 <.L25+0x45>
				printfmt(putch, putdat, "error %d", err);
  80054b:	50                   	push   %eax
  80054c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054f:	8d 80 a5 ef ff ff    	lea    -0x105b(%eax),%eax
  800555:	50                   	push   %eax
  800556:	57                   	push   %edi
  800557:	56                   	push   %esi
  800558:	e8 5c fe ff ff       	call   8003b9 <printfmt>
  80055d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800560:	89 5d 14             	mov    %ebx,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800563:	e9 6d 02 00 00       	jmp    8007d5 <.L25+0x45>

00800568 <.L24>:
  800568:	8b 75 08             	mov    0x8(%ebp),%esi
			if ((p = va_arg(ap, char *)) == NULL)
  80056b:	8b 45 14             	mov    0x14(%ebp),%eax
  80056e:	83 c0 04             	add    $0x4,%eax
  800571:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800579:	85 d2                	test   %edx,%edx
  80057b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057e:	8d 80 9e ef ff ff    	lea    -0x1062(%eax),%eax
  800584:	0f 45 c2             	cmovne %edx,%eax
  800587:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80058a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80058e:	7e 06                	jle    800596 <.L24+0x2e>
  800590:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800594:	75 0d                	jne    8005a3 <.L24+0x3b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800596:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800599:	89 c3                	mov    %eax,%ebx
  80059b:	03 45 d4             	add    -0x2c(%ebp),%eax
  80059e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8005a1:	eb 58                	jmp    8005fb <.L24+0x93>
  8005a3:	83 ec 08             	sub    $0x8,%esp
  8005a6:	ff 75 d8             	pushl  -0x28(%ebp)
  8005a9:	ff 75 c8             	pushl  -0x38(%ebp)
  8005ac:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005af:	e8 7c 03 00 00       	call   800930 <strnlen>
  8005b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005b7:	29 c2                	sub    %eax,%edx
  8005b9:	89 55 bc             	mov    %edx,-0x44(%ebp)
  8005bc:	83 c4 10             	add    $0x10,%esp
  8005bf:	89 d3                	mov    %edx,%ebx
					putch(padc, putdat);
  8005c1:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c8:	85 db                	test   %ebx,%ebx
  8005ca:	7e 11                	jle    8005dd <.L24+0x75>
					putch(padc, putdat);
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	57                   	push   %edi
  8005d0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8005d3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d5:	83 eb 01             	sub    $0x1,%ebx
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	eb eb                	jmp    8005c8 <.L24+0x60>
  8005dd:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8005e0:	85 d2                	test   %edx,%edx
  8005e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e7:	0f 49 c2             	cmovns %edx,%eax
  8005ea:	29 c2                	sub    %eax,%edx
  8005ec:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005ef:	eb a5                	jmp    800596 <.L24+0x2e>
					putch(ch, putdat);
  8005f1:	83 ec 08             	sub    $0x8,%esp
  8005f4:	57                   	push   %edi
  8005f5:	52                   	push   %edx
  8005f6:	ff d6                	call   *%esi
  8005f8:	83 c4 10             	add    $0x10,%esp
  8005fb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005fe:	29 d9                	sub    %ebx,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800600:	83 c3 01             	add    $0x1,%ebx
  800603:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  800607:	0f be d0             	movsbl %al,%edx
  80060a:	85 d2                	test   %edx,%edx
  80060c:	74 4b                	je     800659 <.L24+0xf1>
  80060e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800612:	78 06                	js     80061a <.L24+0xb2>
  800614:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800618:	78 1e                	js     800638 <.L24+0xd0>
				if (altflag && (ch < ' ' || ch > '~'))
  80061a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80061e:	74 d1                	je     8005f1 <.L24+0x89>
  800620:	0f be c0             	movsbl %al,%eax
  800623:	83 e8 20             	sub    $0x20,%eax
  800626:	83 f8 5e             	cmp    $0x5e,%eax
  800629:	76 c6                	jbe    8005f1 <.L24+0x89>
					putch('?', putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	57                   	push   %edi
  80062f:	6a 3f                	push   $0x3f
  800631:	ff d6                	call   *%esi
  800633:	83 c4 10             	add    $0x10,%esp
  800636:	eb c3                	jmp    8005fb <.L24+0x93>
  800638:	89 cb                	mov    %ecx,%ebx
  80063a:	eb 0e                	jmp    80064a <.L24+0xe2>
				putch(' ', putdat);
  80063c:	83 ec 08             	sub    $0x8,%esp
  80063f:	57                   	push   %edi
  800640:	6a 20                	push   $0x20
  800642:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800644:	83 eb 01             	sub    $0x1,%ebx
  800647:	83 c4 10             	add    $0x10,%esp
  80064a:	85 db                	test   %ebx,%ebx
  80064c:	7f ee                	jg     80063c <.L24+0xd4>
			if ((p = va_arg(ap, char *)) == NULL)
  80064e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800651:	89 45 14             	mov    %eax,0x14(%ebp)
  800654:	e9 7c 01 00 00       	jmp    8007d5 <.L25+0x45>
  800659:	89 cb                	mov    %ecx,%ebx
  80065b:	eb ed                	jmp    80064a <.L24+0xe2>

0080065d <.L29>:
  80065d:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800660:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  800663:	83 f9 01             	cmp    $0x1,%ecx
  800666:	7f 1b                	jg     800683 <.L29+0x26>
	else if (lflag)
  800668:	85 c9                	test   %ecx,%ecx
  80066a:	74 63                	je     8006cf <.L29+0x72>
		return va_arg(*ap, long);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800674:	99                   	cltd   
  800675:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	8d 40 04             	lea    0x4(%eax),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
  800681:	eb 17                	jmp    80069a <.L29+0x3d>
		return va_arg(*ap, long long);
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 50 04             	mov    0x4(%eax),%edx
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	8d 40 08             	lea    0x8(%eax),%eax
  800697:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80069a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80069d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006a0:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006a5:	85 c9                	test   %ecx,%ecx
  8006a7:	0f 89 0e 01 00 00    	jns    8007bb <.L25+0x2b>
				putch('-', putdat);
  8006ad:	83 ec 08             	sub    $0x8,%esp
  8006b0:	57                   	push   %edi
  8006b1:	6a 2d                	push   $0x2d
  8006b3:	ff d6                	call   *%esi
				num = -(long long) num;
  8006b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006b8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006bb:	f7 da                	neg    %edx
  8006bd:	83 d1 00             	adc    $0x0,%ecx
  8006c0:	f7 d9                	neg    %ecx
  8006c2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ca:	e9 ec 00 00 00       	jmp    8007bb <.L25+0x2b>
		return va_arg(*ap, int);
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d7:	99                   	cltd   
  8006d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8d 40 04             	lea    0x4(%eax),%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e4:	eb b4                	jmp    80069a <.L29+0x3d>

008006e6 <.L23>:
  8006e6:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006e9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  8006ec:	83 f9 01             	cmp    $0x1,%ecx
  8006ef:	7f 1e                	jg     80070f <.L23+0x29>
	else if (lflag)
  8006f1:	85 c9                	test   %ecx,%ecx
  8006f3:	74 32                	je     800727 <.L23+0x41>
		return va_arg(*ap, unsigned long);
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	8b 10                	mov    (%eax),%edx
  8006fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ff:	8d 40 04             	lea    0x4(%eax),%eax
  800702:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800705:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80070a:	e9 ac 00 00 00       	jmp    8007bb <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8b 10                	mov    (%eax),%edx
  800714:	8b 48 04             	mov    0x4(%eax),%ecx
  800717:	8d 40 08             	lea    0x8(%eax),%eax
  80071a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80071d:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800722:	e9 94 00 00 00       	jmp    8007bb <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	8b 10                	mov    (%eax),%edx
  80072c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800731:	8d 40 04             	lea    0x4(%eax),%eax
  800734:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800737:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80073c:	eb 7d                	jmp    8007bb <.L25+0x2b>

0080073e <.L26>:
  80073e:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800741:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  800744:	83 f9 01             	cmp    $0x1,%ecx
  800747:	7f 1b                	jg     800764 <.L26+0x26>
	else if (lflag)
  800749:	85 c9                	test   %ecx,%ecx
  80074b:	74 2c                	je     800779 <.L26+0x3b>
		return va_arg(*ap, unsigned long);
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	8b 10                	mov    (%eax),%edx
  800752:	b9 00 00 00 00       	mov    $0x0,%ecx
  800757:	8d 40 04             	lea    0x4(%eax),%eax
  80075a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800762:	eb 57                	jmp    8007bb <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	8b 10                	mov    (%eax),%edx
  800769:	8b 48 04             	mov    0x4(%eax),%ecx
  80076c:	8d 40 08             	lea    0x8(%eax),%eax
  80076f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800772:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800777:	eb 42                	jmp    8007bb <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	8b 10                	mov    (%eax),%edx
  80077e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800783:	8d 40 04             	lea    0x4(%eax),%eax
  800786:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800789:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80078e:	eb 2b                	jmp    8007bb <.L25+0x2b>

00800790 <.L25>:
  800790:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('0', putdat);
  800793:	83 ec 08             	sub    $0x8,%esp
  800796:	57                   	push   %edi
  800797:	6a 30                	push   $0x30
  800799:	ff d6                	call   *%esi
			putch('x', putdat);
  80079b:	83 c4 08             	add    $0x8,%esp
  80079e:	57                   	push   %edi
  80079f:	6a 78                	push   $0x78
  8007a1:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a6:	8b 10                	mov    (%eax),%edx
  8007a8:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007ad:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007b0:	8d 40 04             	lea    0x4(%eax),%eax
  8007b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b6:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007bb:	83 ec 0c             	sub    $0xc,%esp
  8007be:	0f be 5d cf          	movsbl -0x31(%ebp),%ebx
  8007c2:	53                   	push   %ebx
  8007c3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8007c6:	50                   	push   %eax
  8007c7:	51                   	push   %ecx
  8007c8:	52                   	push   %edx
  8007c9:	89 fa                	mov    %edi,%edx
  8007cb:	89 f0                	mov    %esi,%eax
  8007cd:	e8 08 fb ff ff       	call   8002da <printnum>
			break;
  8007d2:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007d5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d8:	83 c3 01             	add    $0x1,%ebx
  8007db:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  8007df:	83 f8 25             	cmp    $0x25,%eax
  8007e2:	0f 84 23 fc ff ff    	je     80040b <vprintfmt+0x31>
			if (ch == '\0')
  8007e8:	85 c0                	test   %eax,%eax
  8007ea:	0f 84 97 00 00 00    	je     800887 <.L20+0x23>
			putch(ch, putdat);
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	57                   	push   %edi
  8007f4:	50                   	push   %eax
  8007f5:	ff d6                	call   *%esi
  8007f7:	83 c4 10             	add    $0x10,%esp
  8007fa:	eb dc                	jmp    8007d8 <.L25+0x48>

008007fc <.L21>:
  8007fc:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8007ff:	8b 75 08             	mov    0x8(%ebp),%esi
	if (lflag >= 2)
  800802:	83 f9 01             	cmp    $0x1,%ecx
  800805:	7f 1b                	jg     800822 <.L21+0x26>
	else if (lflag)
  800807:	85 c9                	test   %ecx,%ecx
  800809:	74 2c                	je     800837 <.L21+0x3b>
		return va_arg(*ap, unsigned long);
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	8b 10                	mov    (%eax),%edx
  800810:	b9 00 00 00 00       	mov    $0x0,%ecx
  800815:	8d 40 04             	lea    0x4(%eax),%eax
  800818:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800820:	eb 99                	jmp    8007bb <.L25+0x2b>
		return va_arg(*ap, unsigned long long);
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	8b 10                	mov    (%eax),%edx
  800827:	8b 48 04             	mov    0x4(%eax),%ecx
  80082a:	8d 40 08             	lea    0x8(%eax),%eax
  80082d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800830:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800835:	eb 84                	jmp    8007bb <.L25+0x2b>
		return va_arg(*ap, unsigned int);
  800837:	8b 45 14             	mov    0x14(%ebp),%eax
  80083a:	8b 10                	mov    (%eax),%edx
  80083c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800841:	8d 40 04             	lea    0x4(%eax),%eax
  800844:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800847:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80084c:	e9 6a ff ff ff       	jmp    8007bb <.L25+0x2b>

00800851 <.L35>:
  800851:	8b 75 08             	mov    0x8(%ebp),%esi
			putch(ch, putdat);
  800854:	83 ec 08             	sub    $0x8,%esp
  800857:	57                   	push   %edi
  800858:	6a 25                	push   $0x25
  80085a:	ff d6                	call   *%esi
			break;
  80085c:	83 c4 10             	add    $0x10,%esp
  80085f:	e9 71 ff ff ff       	jmp    8007d5 <.L25+0x45>

00800864 <.L20>:
  800864:	8b 75 08             	mov    0x8(%ebp),%esi
			putch('%', putdat);
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	57                   	push   %edi
  80086b:	6a 25                	push   $0x25
  80086d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80086f:	83 c4 10             	add    $0x10,%esp
  800872:	89 d8                	mov    %ebx,%eax
  800874:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800878:	74 05                	je     80087f <.L20+0x1b>
  80087a:	83 e8 01             	sub    $0x1,%eax
  80087d:	eb f5                	jmp    800874 <.L20+0x10>
  80087f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800882:	e9 4e ff ff ff       	jmp    8007d5 <.L25+0x45>
}
  800887:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80088a:	5b                   	pop    %ebx
  80088b:	5e                   	pop    %esi
  80088c:	5f                   	pop    %edi
  80088d:	5d                   	pop    %ebp
  80088e:	c3                   	ret    

0080088f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80088f:	f3 0f 1e fb          	endbr32 
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	53                   	push   %ebx
  800897:	83 ec 14             	sub    $0x14,%esp
  80089a:	e8 bb f7 ff ff       	call   80005a <__x86.get_pc_thunk.bx>
  80089f:	81 c3 61 17 00 00    	add    $0x1761,%ebx
  8008a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008ae:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008b2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008bc:	85 c0                	test   %eax,%eax
  8008be:	74 2b                	je     8008eb <vsnprintf+0x5c>
  8008c0:	85 d2                	test   %edx,%edx
  8008c2:	7e 27                	jle    8008eb <vsnprintf+0x5c>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008c4:	ff 75 14             	pushl  0x14(%ebp)
  8008c7:	ff 75 10             	pushl  0x10(%ebp)
  8008ca:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008cd:	50                   	push   %eax
  8008ce:	8d 83 98 e3 ff ff    	lea    -0x1c68(%ebx),%eax
  8008d4:	50                   	push   %eax
  8008d5:	e8 00 fb ff ff       	call   8003da <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008dd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e3:	83 c4 10             	add    $0x10,%esp
}
  8008e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008e9:	c9                   	leave  
  8008ea:	c3                   	ret    
		return -E_INVAL;
  8008eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008f0:	eb f4                	jmp    8008e6 <vsnprintf+0x57>

008008f2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008f2:	f3 0f 1e fb          	endbr32 
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008fc:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008ff:	50                   	push   %eax
  800900:	ff 75 10             	pushl  0x10(%ebp)
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	ff 75 08             	pushl  0x8(%ebp)
  800909:	e8 81 ff ff ff       	call   80088f <vsnprintf>
	va_end(ap);

	return rc;
}
  80090e:	c9                   	leave  
  80090f:	c3                   	ret    

00800910 <__x86.get_pc_thunk.cx>:
  800910:	8b 0c 24             	mov    (%esp),%ecx
  800913:	c3                   	ret    

00800914 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800914:	f3 0f 1e fb          	endbr32 
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80091e:	b8 00 00 00 00       	mov    $0x0,%eax
  800923:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800927:	74 05                	je     80092e <strlen+0x1a>
		n++;
  800929:	83 c0 01             	add    $0x1,%eax
  80092c:	eb f5                	jmp    800923 <strlen+0xf>
	return n;
}
  80092e:	5d                   	pop    %ebp
  80092f:	c3                   	ret    

00800930 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800930:	f3 0f 1e fb          	endbr32 
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80093a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80093d:	b8 00 00 00 00       	mov    $0x0,%eax
  800942:	39 d0                	cmp    %edx,%eax
  800944:	74 0d                	je     800953 <strnlen+0x23>
  800946:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80094a:	74 05                	je     800951 <strnlen+0x21>
		n++;
  80094c:	83 c0 01             	add    $0x1,%eax
  80094f:	eb f1                	jmp    800942 <strnlen+0x12>
  800951:	89 c2                	mov    %eax,%edx
	return n;
}
  800953:	89 d0                	mov    %edx,%eax
  800955:	5d                   	pop    %ebp
  800956:	c3                   	ret    

00800957 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800957:	f3 0f 1e fb          	endbr32 
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	53                   	push   %ebx
  80095f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800962:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800965:	b8 00 00 00 00       	mov    $0x0,%eax
  80096a:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80096e:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800971:	83 c0 01             	add    $0x1,%eax
  800974:	84 d2                	test   %dl,%dl
  800976:	75 f2                	jne    80096a <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800978:	89 c8                	mov    %ecx,%eax
  80097a:	5b                   	pop    %ebx
  80097b:	5d                   	pop    %ebp
  80097c:	c3                   	ret    

0080097d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80097d:	f3 0f 1e fb          	endbr32 
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	53                   	push   %ebx
  800985:	83 ec 10             	sub    $0x10,%esp
  800988:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80098b:	53                   	push   %ebx
  80098c:	e8 83 ff ff ff       	call   800914 <strlen>
  800991:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800994:	ff 75 0c             	pushl  0xc(%ebp)
  800997:	01 d8                	add    %ebx,%eax
  800999:	50                   	push   %eax
  80099a:	e8 b8 ff ff ff       	call   800957 <strcpy>
	return dst;
}
  80099f:	89 d8                	mov    %ebx,%eax
  8009a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009a4:	c9                   	leave  
  8009a5:	c3                   	ret    

008009a6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009a6:	f3 0f 1e fb          	endbr32 
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	56                   	push   %esi
  8009ae:	53                   	push   %ebx
  8009af:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b5:	89 f3                	mov    %esi,%ebx
  8009b7:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009ba:	89 f0                	mov    %esi,%eax
  8009bc:	39 d8                	cmp    %ebx,%eax
  8009be:	74 11                	je     8009d1 <strncpy+0x2b>
		*dst++ = *src;
  8009c0:	83 c0 01             	add    $0x1,%eax
  8009c3:	0f b6 0a             	movzbl (%edx),%ecx
  8009c6:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009c9:	80 f9 01             	cmp    $0x1,%cl
  8009cc:	83 da ff             	sbb    $0xffffffff,%edx
  8009cf:	eb eb                	jmp    8009bc <strncpy+0x16>
	}
	return ret;
}
  8009d1:	89 f0                	mov    %esi,%eax
  8009d3:	5b                   	pop    %ebx
  8009d4:	5e                   	pop    %esi
  8009d5:	5d                   	pop    %ebp
  8009d6:	c3                   	ret    

008009d7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009d7:	f3 0f 1e fb          	endbr32 
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	56                   	push   %esi
  8009df:	53                   	push   %ebx
  8009e0:	8b 75 08             	mov    0x8(%ebp),%esi
  8009e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e6:	8b 55 10             	mov    0x10(%ebp),%edx
  8009e9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009eb:	85 d2                	test   %edx,%edx
  8009ed:	74 21                	je     800a10 <strlcpy+0x39>
  8009ef:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009f3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009f5:	39 c2                	cmp    %eax,%edx
  8009f7:	74 14                	je     800a0d <strlcpy+0x36>
  8009f9:	0f b6 19             	movzbl (%ecx),%ebx
  8009fc:	84 db                	test   %bl,%bl
  8009fe:	74 0b                	je     800a0b <strlcpy+0x34>
			*dst++ = *src++;
  800a00:	83 c1 01             	add    $0x1,%ecx
  800a03:	83 c2 01             	add    $0x1,%edx
  800a06:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a09:	eb ea                	jmp    8009f5 <strlcpy+0x1e>
  800a0b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a0d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a10:	29 f0                	sub    %esi,%eax
}
  800a12:	5b                   	pop    %ebx
  800a13:	5e                   	pop    %esi
  800a14:	5d                   	pop    %ebp
  800a15:	c3                   	ret    

00800a16 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a16:	f3 0f 1e fb          	endbr32 
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a20:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a23:	0f b6 01             	movzbl (%ecx),%eax
  800a26:	84 c0                	test   %al,%al
  800a28:	74 0c                	je     800a36 <strcmp+0x20>
  800a2a:	3a 02                	cmp    (%edx),%al
  800a2c:	75 08                	jne    800a36 <strcmp+0x20>
		p++, q++;
  800a2e:	83 c1 01             	add    $0x1,%ecx
  800a31:	83 c2 01             	add    $0x1,%edx
  800a34:	eb ed                	jmp    800a23 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a36:	0f b6 c0             	movzbl %al,%eax
  800a39:	0f b6 12             	movzbl (%edx),%edx
  800a3c:	29 d0                	sub    %edx,%eax
}
  800a3e:	5d                   	pop    %ebp
  800a3f:	c3                   	ret    

00800a40 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a40:	f3 0f 1e fb          	endbr32 
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	53                   	push   %ebx
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4e:	89 c3                	mov    %eax,%ebx
  800a50:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a53:	eb 06                	jmp    800a5b <strncmp+0x1b>
		n--, p++, q++;
  800a55:	83 c0 01             	add    $0x1,%eax
  800a58:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a5b:	39 d8                	cmp    %ebx,%eax
  800a5d:	74 16                	je     800a75 <strncmp+0x35>
  800a5f:	0f b6 08             	movzbl (%eax),%ecx
  800a62:	84 c9                	test   %cl,%cl
  800a64:	74 04                	je     800a6a <strncmp+0x2a>
  800a66:	3a 0a                	cmp    (%edx),%cl
  800a68:	74 eb                	je     800a55 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a6a:	0f b6 00             	movzbl (%eax),%eax
  800a6d:	0f b6 12             	movzbl (%edx),%edx
  800a70:	29 d0                	sub    %edx,%eax
}
  800a72:	5b                   	pop    %ebx
  800a73:	5d                   	pop    %ebp
  800a74:	c3                   	ret    
		return 0;
  800a75:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7a:	eb f6                	jmp    800a72 <strncmp+0x32>

00800a7c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a7c:	f3 0f 1e fb          	endbr32 
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a8a:	0f b6 10             	movzbl (%eax),%edx
  800a8d:	84 d2                	test   %dl,%dl
  800a8f:	74 09                	je     800a9a <strchr+0x1e>
		if (*s == c)
  800a91:	38 ca                	cmp    %cl,%dl
  800a93:	74 0a                	je     800a9f <strchr+0x23>
	for (; *s; s++)
  800a95:	83 c0 01             	add    $0x1,%eax
  800a98:	eb f0                	jmp    800a8a <strchr+0xe>
			return (char *) s;
	return 0;
  800a9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a9f:	5d                   	pop    %ebp
  800aa0:	c3                   	ret    

00800aa1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aa1:	f3 0f 1e fb          	endbr32 
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aaf:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ab2:	38 ca                	cmp    %cl,%dl
  800ab4:	74 09                	je     800abf <strfind+0x1e>
  800ab6:	84 d2                	test   %dl,%dl
  800ab8:	74 05                	je     800abf <strfind+0x1e>
	for (; *s; s++)
  800aba:	83 c0 01             	add    $0x1,%eax
  800abd:	eb f0                	jmp    800aaf <strfind+0xe>
			break;
	return (char *) s;
}
  800abf:	5d                   	pop    %ebp
  800ac0:	c3                   	ret    

00800ac1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ac1:	f3 0f 1e fb          	endbr32 
  800ac5:	55                   	push   %ebp
  800ac6:	89 e5                	mov    %esp,%ebp
  800ac8:	57                   	push   %edi
  800ac9:	56                   	push   %esi
  800aca:	53                   	push   %ebx
  800acb:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ace:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ad1:	85 c9                	test   %ecx,%ecx
  800ad3:	74 31                	je     800b06 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ad5:	89 f8                	mov    %edi,%eax
  800ad7:	09 c8                	or     %ecx,%eax
  800ad9:	a8 03                	test   $0x3,%al
  800adb:	75 23                	jne    800b00 <memset+0x3f>
		c &= 0xFF;
  800add:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ae1:	89 d3                	mov    %edx,%ebx
  800ae3:	c1 e3 08             	shl    $0x8,%ebx
  800ae6:	89 d0                	mov    %edx,%eax
  800ae8:	c1 e0 18             	shl    $0x18,%eax
  800aeb:	89 d6                	mov    %edx,%esi
  800aed:	c1 e6 10             	shl    $0x10,%esi
  800af0:	09 f0                	or     %esi,%eax
  800af2:	09 c2                	or     %eax,%edx
  800af4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800af6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800af9:	89 d0                	mov    %edx,%eax
  800afb:	fc                   	cld    
  800afc:	f3 ab                	rep stos %eax,%es:(%edi)
  800afe:	eb 06                	jmp    800b06 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	fc                   	cld    
  800b04:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b06:	89 f8                	mov    %edi,%eax
  800b08:	5b                   	pop    %ebx
  800b09:	5e                   	pop    %esi
  800b0a:	5f                   	pop    %edi
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    

00800b0d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b0d:	f3 0f 1e fb          	endbr32 
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	57                   	push   %edi
  800b15:	56                   	push   %esi
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b1f:	39 c6                	cmp    %eax,%esi
  800b21:	73 32                	jae    800b55 <memmove+0x48>
  800b23:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b26:	39 c2                	cmp    %eax,%edx
  800b28:	76 2b                	jbe    800b55 <memmove+0x48>
		s += n;
		d += n;
  800b2a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b2d:	89 fe                	mov    %edi,%esi
  800b2f:	09 ce                	or     %ecx,%esi
  800b31:	09 d6                	or     %edx,%esi
  800b33:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b39:	75 0e                	jne    800b49 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b3b:	83 ef 04             	sub    $0x4,%edi
  800b3e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b41:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b44:	fd                   	std    
  800b45:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b47:	eb 09                	jmp    800b52 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b49:	83 ef 01             	sub    $0x1,%edi
  800b4c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b4f:	fd                   	std    
  800b50:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b52:	fc                   	cld    
  800b53:	eb 1a                	jmp    800b6f <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b55:	89 c2                	mov    %eax,%edx
  800b57:	09 ca                	or     %ecx,%edx
  800b59:	09 f2                	or     %esi,%edx
  800b5b:	f6 c2 03             	test   $0x3,%dl
  800b5e:	75 0a                	jne    800b6a <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b60:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b63:	89 c7                	mov    %eax,%edi
  800b65:	fc                   	cld    
  800b66:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b68:	eb 05                	jmp    800b6f <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b6a:	89 c7                	mov    %eax,%edi
  800b6c:	fc                   	cld    
  800b6d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b6f:	5e                   	pop    %esi
  800b70:	5f                   	pop    %edi
  800b71:	5d                   	pop    %ebp
  800b72:	c3                   	ret    

00800b73 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b73:	f3 0f 1e fb          	endbr32 
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b7d:	ff 75 10             	pushl  0x10(%ebp)
  800b80:	ff 75 0c             	pushl  0xc(%ebp)
  800b83:	ff 75 08             	pushl  0x8(%ebp)
  800b86:	e8 82 ff ff ff       	call   800b0d <memmove>
}
  800b8b:	c9                   	leave  
  800b8c:	c3                   	ret    

00800b8d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b8d:	f3 0f 1e fb          	endbr32 
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	56                   	push   %esi
  800b95:	53                   	push   %ebx
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9c:	89 c6                	mov    %eax,%esi
  800b9e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ba1:	39 f0                	cmp    %esi,%eax
  800ba3:	74 1c                	je     800bc1 <memcmp+0x34>
		if (*s1 != *s2)
  800ba5:	0f b6 08             	movzbl (%eax),%ecx
  800ba8:	0f b6 1a             	movzbl (%edx),%ebx
  800bab:	38 d9                	cmp    %bl,%cl
  800bad:	75 08                	jne    800bb7 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800baf:	83 c0 01             	add    $0x1,%eax
  800bb2:	83 c2 01             	add    $0x1,%edx
  800bb5:	eb ea                	jmp    800ba1 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800bb7:	0f b6 c1             	movzbl %cl,%eax
  800bba:	0f b6 db             	movzbl %bl,%ebx
  800bbd:	29 d8                	sub    %ebx,%eax
  800bbf:	eb 05                	jmp    800bc6 <memcmp+0x39>
	}

	return 0;
  800bc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc6:	5b                   	pop    %ebx
  800bc7:	5e                   	pop    %esi
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bca:	f3 0f 1e fb          	endbr32 
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bd7:	89 c2                	mov    %eax,%edx
  800bd9:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bdc:	39 d0                	cmp    %edx,%eax
  800bde:	73 09                	jae    800be9 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800be0:	38 08                	cmp    %cl,(%eax)
  800be2:	74 05                	je     800be9 <memfind+0x1f>
	for (; s < ends; s++)
  800be4:	83 c0 01             	add    $0x1,%eax
  800be7:	eb f3                	jmp    800bdc <memfind+0x12>
			break;
	return (void *) s;
}
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800beb:	f3 0f 1e fb          	endbr32 
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	57                   	push   %edi
  800bf3:	56                   	push   %esi
  800bf4:	53                   	push   %ebx
  800bf5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bfb:	eb 03                	jmp    800c00 <strtol+0x15>
		s++;
  800bfd:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c00:	0f b6 01             	movzbl (%ecx),%eax
  800c03:	3c 20                	cmp    $0x20,%al
  800c05:	74 f6                	je     800bfd <strtol+0x12>
  800c07:	3c 09                	cmp    $0x9,%al
  800c09:	74 f2                	je     800bfd <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800c0b:	3c 2b                	cmp    $0x2b,%al
  800c0d:	74 2a                	je     800c39 <strtol+0x4e>
	int neg = 0;
  800c0f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c14:	3c 2d                	cmp    $0x2d,%al
  800c16:	74 2b                	je     800c43 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c18:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c1e:	75 0f                	jne    800c2f <strtol+0x44>
  800c20:	80 39 30             	cmpb   $0x30,(%ecx)
  800c23:	74 28                	je     800c4d <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c25:	85 db                	test   %ebx,%ebx
  800c27:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c2c:	0f 44 d8             	cmove  %eax,%ebx
  800c2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c34:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c37:	eb 46                	jmp    800c7f <strtol+0x94>
		s++;
  800c39:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c3c:	bf 00 00 00 00       	mov    $0x0,%edi
  800c41:	eb d5                	jmp    800c18 <strtol+0x2d>
		s++, neg = 1;
  800c43:	83 c1 01             	add    $0x1,%ecx
  800c46:	bf 01 00 00 00       	mov    $0x1,%edi
  800c4b:	eb cb                	jmp    800c18 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c4d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c51:	74 0e                	je     800c61 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c53:	85 db                	test   %ebx,%ebx
  800c55:	75 d8                	jne    800c2f <strtol+0x44>
		s++, base = 8;
  800c57:	83 c1 01             	add    $0x1,%ecx
  800c5a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c5f:	eb ce                	jmp    800c2f <strtol+0x44>
		s += 2, base = 16;
  800c61:	83 c1 02             	add    $0x2,%ecx
  800c64:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c69:	eb c4                	jmp    800c2f <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c6b:	0f be d2             	movsbl %dl,%edx
  800c6e:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c71:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c74:	7d 3a                	jge    800cb0 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c76:	83 c1 01             	add    $0x1,%ecx
  800c79:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c7d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c7f:	0f b6 11             	movzbl (%ecx),%edx
  800c82:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c85:	89 f3                	mov    %esi,%ebx
  800c87:	80 fb 09             	cmp    $0x9,%bl
  800c8a:	76 df                	jbe    800c6b <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c8c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c8f:	89 f3                	mov    %esi,%ebx
  800c91:	80 fb 19             	cmp    $0x19,%bl
  800c94:	77 08                	ja     800c9e <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c96:	0f be d2             	movsbl %dl,%edx
  800c99:	83 ea 57             	sub    $0x57,%edx
  800c9c:	eb d3                	jmp    800c71 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c9e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ca1:	89 f3                	mov    %esi,%ebx
  800ca3:	80 fb 19             	cmp    $0x19,%bl
  800ca6:	77 08                	ja     800cb0 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ca8:	0f be d2             	movsbl %dl,%edx
  800cab:	83 ea 37             	sub    $0x37,%edx
  800cae:	eb c1                	jmp    800c71 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cb0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb4:	74 05                	je     800cbb <strtol+0xd0>
		*endptr = (char *) s;
  800cb6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cb9:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cbb:	89 c2                	mov    %eax,%edx
  800cbd:	f7 da                	neg    %edx
  800cbf:	85 ff                	test   %edi,%edi
  800cc1:	0f 45 c2             	cmovne %edx,%eax
}
  800cc4:	5b                   	pop    %ebx
  800cc5:	5e                   	pop    %esi
  800cc6:	5f                   	pop    %edi
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    
  800cc9:	66 90                	xchg   %ax,%ax
  800ccb:	66 90                	xchg   %ax,%ax
  800ccd:	66 90                	xchg   %ax,%ax
  800ccf:	90                   	nop

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
