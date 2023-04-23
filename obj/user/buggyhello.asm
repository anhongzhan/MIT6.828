
obj/user/buggyhello.debug:     file format elf32-i386


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
  80002c:	e8 1a 00 00 00       	call   80004b <libmain>
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
  80003a:	83 ec 10             	sub    $0x10,%esp
	sys_cputs((char*)1, 1);
  80003d:	6a 01                	push   $0x1
  80003f:	6a 01                	push   $0x1
  800041:	e8 6d 00 00 00       	call   8000b3 <sys_cputs>
}
  800046:	83 c4 10             	add    $0x10,%esp
  800049:	c9                   	leave  
  80004a:	c3                   	ret    

0080004b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004b:	f3 0f 1e fb          	endbr32 
  80004f:	55                   	push   %ebp
  800050:	89 e5                	mov    %esp,%ebp
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800057:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80005a:	e8 de 00 00 00       	call   80013d <sys_getenvid>
  80005f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800064:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800067:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006c:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800071:	85 db                	test   %ebx,%ebx
  800073:	7e 07                	jle    80007c <libmain+0x31>
		binaryname = argv[0];
  800075:	8b 06                	mov    (%esi),%eax
  800077:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	56                   	push   %esi
  800080:	53                   	push   %ebx
  800081:	e8 ad ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800086:	e8 0a 00 00 00       	call   800095 <exit>
}
  80008b:	83 c4 10             	add    $0x10,%esp
  80008e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800091:	5b                   	pop    %ebx
  800092:	5e                   	pop    %esi
  800093:	5d                   	pop    %ebp
  800094:	c3                   	ret    

00800095 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800095:	f3 0f 1e fb          	endbr32 
  800099:	55                   	push   %ebp
  80009a:	89 e5                	mov    %esp,%ebp
  80009c:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80009f:	e8 93 05 00 00       	call   800637 <close_all>
	sys_env_destroy(0);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	6a 00                	push   $0x0
  8000a9:	e8 4a 00 00 00       	call   8000f8 <sys_env_destroy>
}
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	c9                   	leave  
  8000b2:	c3                   	ret    

008000b3 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000b3:	f3 0f 1e fb          	endbr32 
  8000b7:	55                   	push   %ebp
  8000b8:	89 e5                	mov    %esp,%ebp
  8000ba:	57                   	push   %edi
  8000bb:	56                   	push   %esi
  8000bc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8000c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000c8:	89 c3                	mov    %eax,%ebx
  8000ca:	89 c7                	mov    %eax,%edi
  8000cc:	89 c6                	mov    %eax,%esi
  8000ce:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000d0:	5b                   	pop    %ebx
  8000d1:	5e                   	pop    %esi
  8000d2:	5f                   	pop    %edi
  8000d3:	5d                   	pop    %ebp
  8000d4:	c3                   	ret    

008000d5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000d5:	f3 0f 1e fb          	endbr32 
  8000d9:	55                   	push   %ebp
  8000da:	89 e5                	mov    %esp,%ebp
  8000dc:	57                   	push   %edi
  8000dd:	56                   	push   %esi
  8000de:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000df:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8000e9:	89 d1                	mov    %edx,%ecx
  8000eb:	89 d3                	mov    %edx,%ebx
  8000ed:	89 d7                	mov    %edx,%edi
  8000ef:	89 d6                	mov    %edx,%esi
  8000f1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000f3:	5b                   	pop    %ebx
  8000f4:	5e                   	pop    %esi
  8000f5:	5f                   	pop    %edi
  8000f6:	5d                   	pop    %ebp
  8000f7:	c3                   	ret    

008000f8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000f8:	f3 0f 1e fb          	endbr32 
  8000fc:	55                   	push   %ebp
  8000fd:	89 e5                	mov    %esp,%ebp
  8000ff:	57                   	push   %edi
  800100:	56                   	push   %esi
  800101:	53                   	push   %ebx
  800102:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800105:	b9 00 00 00 00       	mov    $0x0,%ecx
  80010a:	8b 55 08             	mov    0x8(%ebp),%edx
  80010d:	b8 03 00 00 00       	mov    $0x3,%eax
  800112:	89 cb                	mov    %ecx,%ebx
  800114:	89 cf                	mov    %ecx,%edi
  800116:	89 ce                	mov    %ecx,%esi
  800118:	cd 30                	int    $0x30
	if(check && ret > 0)
  80011a:	85 c0                	test   %eax,%eax
  80011c:	7f 08                	jg     800126 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80011e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800121:	5b                   	pop    %ebx
  800122:	5e                   	pop    %esi
  800123:	5f                   	pop    %edi
  800124:	5d                   	pop    %ebp
  800125:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800126:	83 ec 0c             	sub    $0xc,%esp
  800129:	50                   	push   %eax
  80012a:	6a 03                	push   $0x3
  80012c:	68 8a 24 80 00       	push   $0x80248a
  800131:	6a 23                	push   $0x23
  800133:	68 a7 24 80 00       	push   $0x8024a7
  800138:	e8 08 15 00 00       	call   801645 <_panic>

0080013d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80013d:	f3 0f 1e fb          	endbr32 
  800141:	55                   	push   %ebp
  800142:	89 e5                	mov    %esp,%ebp
  800144:	57                   	push   %edi
  800145:	56                   	push   %esi
  800146:	53                   	push   %ebx
	asm volatile("int %1\n"
  800147:	ba 00 00 00 00       	mov    $0x0,%edx
  80014c:	b8 02 00 00 00       	mov    $0x2,%eax
  800151:	89 d1                	mov    %edx,%ecx
  800153:	89 d3                	mov    %edx,%ebx
  800155:	89 d7                	mov    %edx,%edi
  800157:	89 d6                	mov    %edx,%esi
  800159:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80015b:	5b                   	pop    %ebx
  80015c:	5e                   	pop    %esi
  80015d:	5f                   	pop    %edi
  80015e:	5d                   	pop    %ebp
  80015f:	c3                   	ret    

00800160 <sys_yield>:

void
sys_yield(void)
{
  800160:	f3 0f 1e fb          	endbr32 
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	57                   	push   %edi
  800168:	56                   	push   %esi
  800169:	53                   	push   %ebx
	asm volatile("int %1\n"
  80016a:	ba 00 00 00 00       	mov    $0x0,%edx
  80016f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800174:	89 d1                	mov    %edx,%ecx
  800176:	89 d3                	mov    %edx,%ebx
  800178:	89 d7                	mov    %edx,%edi
  80017a:	89 d6                	mov    %edx,%esi
  80017c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80017e:	5b                   	pop    %ebx
  80017f:	5e                   	pop    %esi
  800180:	5f                   	pop    %edi
  800181:	5d                   	pop    %ebp
  800182:	c3                   	ret    

00800183 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800183:	f3 0f 1e fb          	endbr32 
  800187:	55                   	push   %ebp
  800188:	89 e5                	mov    %esp,%ebp
  80018a:	57                   	push   %edi
  80018b:	56                   	push   %esi
  80018c:	53                   	push   %ebx
  80018d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800190:	be 00 00 00 00       	mov    $0x0,%esi
  800195:	8b 55 08             	mov    0x8(%ebp),%edx
  800198:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80019b:	b8 04 00 00 00       	mov    $0x4,%eax
  8001a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001a3:	89 f7                	mov    %esi,%edi
  8001a5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	7f 08                	jg     8001b3 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ae:	5b                   	pop    %ebx
  8001af:	5e                   	pop    %esi
  8001b0:	5f                   	pop    %edi
  8001b1:	5d                   	pop    %ebp
  8001b2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	50                   	push   %eax
  8001b7:	6a 04                	push   $0x4
  8001b9:	68 8a 24 80 00       	push   $0x80248a
  8001be:	6a 23                	push   $0x23
  8001c0:	68 a7 24 80 00       	push   $0x8024a7
  8001c5:	e8 7b 14 00 00       	call   801645 <_panic>

008001ca <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001ca:	f3 0f 1e fb          	endbr32 
  8001ce:	55                   	push   %ebp
  8001cf:	89 e5                	mov    %esp,%ebp
  8001d1:	57                   	push   %edi
  8001d2:	56                   	push   %esi
  8001d3:	53                   	push   %ebx
  8001d4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8001da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001dd:	b8 05 00 00 00       	mov    $0x5,%eax
  8001e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001e5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001e8:	8b 75 18             	mov    0x18(%ebp),%esi
  8001eb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001ed:	85 c0                	test   %eax,%eax
  8001ef:	7f 08                	jg     8001f9 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f4:	5b                   	pop    %ebx
  8001f5:	5e                   	pop    %esi
  8001f6:	5f                   	pop    %edi
  8001f7:	5d                   	pop    %ebp
  8001f8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	50                   	push   %eax
  8001fd:	6a 05                	push   $0x5
  8001ff:	68 8a 24 80 00       	push   $0x80248a
  800204:	6a 23                	push   $0x23
  800206:	68 a7 24 80 00       	push   $0x8024a7
  80020b:	e8 35 14 00 00       	call   801645 <_panic>

00800210 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800210:	f3 0f 1e fb          	endbr32 
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	57                   	push   %edi
  800218:	56                   	push   %esi
  800219:	53                   	push   %ebx
  80021a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80021d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800222:	8b 55 08             	mov    0x8(%ebp),%edx
  800225:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800228:	b8 06 00 00 00       	mov    $0x6,%eax
  80022d:	89 df                	mov    %ebx,%edi
  80022f:	89 de                	mov    %ebx,%esi
  800231:	cd 30                	int    $0x30
	if(check && ret > 0)
  800233:	85 c0                	test   %eax,%eax
  800235:	7f 08                	jg     80023f <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800237:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023a:	5b                   	pop    %ebx
  80023b:	5e                   	pop    %esi
  80023c:	5f                   	pop    %edi
  80023d:	5d                   	pop    %ebp
  80023e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80023f:	83 ec 0c             	sub    $0xc,%esp
  800242:	50                   	push   %eax
  800243:	6a 06                	push   $0x6
  800245:	68 8a 24 80 00       	push   $0x80248a
  80024a:	6a 23                	push   $0x23
  80024c:	68 a7 24 80 00       	push   $0x8024a7
  800251:	e8 ef 13 00 00       	call   801645 <_panic>

00800256 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800256:	f3 0f 1e fb          	endbr32 
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	57                   	push   %edi
  80025e:	56                   	push   %esi
  80025f:	53                   	push   %ebx
  800260:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800263:	bb 00 00 00 00       	mov    $0x0,%ebx
  800268:	8b 55 08             	mov    0x8(%ebp),%edx
  80026b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80026e:	b8 08 00 00 00       	mov    $0x8,%eax
  800273:	89 df                	mov    %ebx,%edi
  800275:	89 de                	mov    %ebx,%esi
  800277:	cd 30                	int    $0x30
	if(check && ret > 0)
  800279:	85 c0                	test   %eax,%eax
  80027b:	7f 08                	jg     800285 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80027d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800280:	5b                   	pop    %ebx
  800281:	5e                   	pop    %esi
  800282:	5f                   	pop    %edi
  800283:	5d                   	pop    %ebp
  800284:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	50                   	push   %eax
  800289:	6a 08                	push   $0x8
  80028b:	68 8a 24 80 00       	push   $0x80248a
  800290:	6a 23                	push   $0x23
  800292:	68 a7 24 80 00       	push   $0x8024a7
  800297:	e8 a9 13 00 00       	call   801645 <_panic>

0080029c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80029c:	f3 0f 1e fb          	endbr32 
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	57                   	push   %edi
  8002a4:	56                   	push   %esi
  8002a5:	53                   	push   %ebx
  8002a6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b4:	b8 09 00 00 00       	mov    $0x9,%eax
  8002b9:	89 df                	mov    %ebx,%edi
  8002bb:	89 de                	mov    %ebx,%esi
  8002bd:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002bf:	85 c0                	test   %eax,%eax
  8002c1:	7f 08                	jg     8002cb <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c6:	5b                   	pop    %ebx
  8002c7:	5e                   	pop    %esi
  8002c8:	5f                   	pop    %edi
  8002c9:	5d                   	pop    %ebp
  8002ca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	50                   	push   %eax
  8002cf:	6a 09                	push   $0x9
  8002d1:	68 8a 24 80 00       	push   $0x80248a
  8002d6:	6a 23                	push   $0x23
  8002d8:	68 a7 24 80 00       	push   $0x8024a7
  8002dd:	e8 63 13 00 00       	call   801645 <_panic>

008002e2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002e2:	f3 0f 1e fb          	endbr32 
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	57                   	push   %edi
  8002ea:	56                   	push   %esi
  8002eb:	53                   	push   %ebx
  8002ec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002fa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002ff:	89 df                	mov    %ebx,%edi
  800301:	89 de                	mov    %ebx,%esi
  800303:	cd 30                	int    $0x30
	if(check && ret > 0)
  800305:	85 c0                	test   %eax,%eax
  800307:	7f 08                	jg     800311 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800309:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030c:	5b                   	pop    %ebx
  80030d:	5e                   	pop    %esi
  80030e:	5f                   	pop    %edi
  80030f:	5d                   	pop    %ebp
  800310:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800311:	83 ec 0c             	sub    $0xc,%esp
  800314:	50                   	push   %eax
  800315:	6a 0a                	push   $0xa
  800317:	68 8a 24 80 00       	push   $0x80248a
  80031c:	6a 23                	push   $0x23
  80031e:	68 a7 24 80 00       	push   $0x8024a7
  800323:	e8 1d 13 00 00       	call   801645 <_panic>

00800328 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800328:	f3 0f 1e fb          	endbr32 
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	57                   	push   %edi
  800330:	56                   	push   %esi
  800331:	53                   	push   %ebx
	asm volatile("int %1\n"
  800332:	8b 55 08             	mov    0x8(%ebp),%edx
  800335:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800338:	b8 0c 00 00 00       	mov    $0xc,%eax
  80033d:	be 00 00 00 00       	mov    $0x0,%esi
  800342:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800345:	8b 7d 14             	mov    0x14(%ebp),%edi
  800348:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80034a:	5b                   	pop    %ebx
  80034b:	5e                   	pop    %esi
  80034c:	5f                   	pop    %edi
  80034d:	5d                   	pop    %ebp
  80034e:	c3                   	ret    

0080034f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80034f:	f3 0f 1e fb          	endbr32 
  800353:	55                   	push   %ebp
  800354:	89 e5                	mov    %esp,%ebp
  800356:	57                   	push   %edi
  800357:	56                   	push   %esi
  800358:	53                   	push   %ebx
  800359:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80035c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800361:	8b 55 08             	mov    0x8(%ebp),%edx
  800364:	b8 0d 00 00 00       	mov    $0xd,%eax
  800369:	89 cb                	mov    %ecx,%ebx
  80036b:	89 cf                	mov    %ecx,%edi
  80036d:	89 ce                	mov    %ecx,%esi
  80036f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800371:	85 c0                	test   %eax,%eax
  800373:	7f 08                	jg     80037d <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800375:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800378:	5b                   	pop    %ebx
  800379:	5e                   	pop    %esi
  80037a:	5f                   	pop    %edi
  80037b:	5d                   	pop    %ebp
  80037c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80037d:	83 ec 0c             	sub    $0xc,%esp
  800380:	50                   	push   %eax
  800381:	6a 0d                	push   $0xd
  800383:	68 8a 24 80 00       	push   $0x80248a
  800388:	6a 23                	push   $0x23
  80038a:	68 a7 24 80 00       	push   $0x8024a7
  80038f:	e8 b1 12 00 00       	call   801645 <_panic>

00800394 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800394:	f3 0f 1e fb          	endbr32 
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	57                   	push   %edi
  80039c:	56                   	push   %esi
  80039d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80039e:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a3:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003a8:	89 d1                	mov    %edx,%ecx
  8003aa:	89 d3                	mov    %edx,%ebx
  8003ac:	89 d7                	mov    %edx,%edi
  8003ae:	89 d6                	mov    %edx,%esi
  8003b0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003b2:	5b                   	pop    %ebx
  8003b3:	5e                   	pop    %esi
  8003b4:	5f                   	pop    %edi
  8003b5:	5d                   	pop    %ebp
  8003b6:	c3                   	ret    

008003b7 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  8003b7:	f3 0f 1e fb          	endbr32 
  8003bb:	55                   	push   %ebp
  8003bc:	89 e5                	mov    %esp,%ebp
  8003be:	57                   	push   %edi
  8003bf:	56                   	push   %esi
  8003c0:	53                   	push   %ebx
  8003c1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8003c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8003cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003cf:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003d4:	89 df                	mov    %ebx,%edi
  8003d6:	89 de                	mov    %ebx,%esi
  8003d8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8003da:	85 c0                	test   %eax,%eax
  8003dc:	7f 08                	jg     8003e6 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  8003de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003e1:	5b                   	pop    %ebx
  8003e2:	5e                   	pop    %esi
  8003e3:	5f                   	pop    %edi
  8003e4:	5d                   	pop    %ebp
  8003e5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8003e6:	83 ec 0c             	sub    $0xc,%esp
  8003e9:	50                   	push   %eax
  8003ea:	6a 0f                	push   $0xf
  8003ec:	68 8a 24 80 00       	push   $0x80248a
  8003f1:	6a 23                	push   $0x23
  8003f3:	68 a7 24 80 00       	push   $0x8024a7
  8003f8:	e8 48 12 00 00       	call   801645 <_panic>

008003fd <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  8003fd:	f3 0f 1e fb          	endbr32 
  800401:	55                   	push   %ebp
  800402:	89 e5                	mov    %esp,%ebp
  800404:	57                   	push   %edi
  800405:	56                   	push   %esi
  800406:	53                   	push   %ebx
  800407:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80040a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80040f:	8b 55 08             	mov    0x8(%ebp),%edx
  800412:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800415:	b8 10 00 00 00       	mov    $0x10,%eax
  80041a:	89 df                	mov    %ebx,%edi
  80041c:	89 de                	mov    %ebx,%esi
  80041e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800420:	85 c0                	test   %eax,%eax
  800422:	7f 08                	jg     80042c <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800424:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800427:	5b                   	pop    %ebx
  800428:	5e                   	pop    %esi
  800429:	5f                   	pop    %edi
  80042a:	5d                   	pop    %ebp
  80042b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80042c:	83 ec 0c             	sub    $0xc,%esp
  80042f:	50                   	push   %eax
  800430:	6a 10                	push   $0x10
  800432:	68 8a 24 80 00       	push   $0x80248a
  800437:	6a 23                	push   $0x23
  800439:	68 a7 24 80 00       	push   $0x8024a7
  80043e:	e8 02 12 00 00       	call   801645 <_panic>

00800443 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800443:	f3 0f 1e fb          	endbr32 
  800447:	55                   	push   %ebp
  800448:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80044a:	8b 45 08             	mov    0x8(%ebp),%eax
  80044d:	05 00 00 00 30       	add    $0x30000000,%eax
  800452:	c1 e8 0c             	shr    $0xc,%eax
}
  800455:	5d                   	pop    %ebp
  800456:	c3                   	ret    

00800457 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800457:	f3 0f 1e fb          	endbr32 
  80045b:	55                   	push   %ebp
  80045c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80045e:	8b 45 08             	mov    0x8(%ebp),%eax
  800461:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800466:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80046b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800470:	5d                   	pop    %ebp
  800471:	c3                   	ret    

00800472 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800472:	f3 0f 1e fb          	endbr32 
  800476:	55                   	push   %ebp
  800477:	89 e5                	mov    %esp,%ebp
  800479:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80047e:	89 c2                	mov    %eax,%edx
  800480:	c1 ea 16             	shr    $0x16,%edx
  800483:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80048a:	f6 c2 01             	test   $0x1,%dl
  80048d:	74 2d                	je     8004bc <fd_alloc+0x4a>
  80048f:	89 c2                	mov    %eax,%edx
  800491:	c1 ea 0c             	shr    $0xc,%edx
  800494:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80049b:	f6 c2 01             	test   $0x1,%dl
  80049e:	74 1c                	je     8004bc <fd_alloc+0x4a>
  8004a0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8004a5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8004aa:	75 d2                	jne    80047e <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8004b5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8004ba:	eb 0a                	jmp    8004c6 <fd_alloc+0x54>
			*fd_store = fd;
  8004bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004bf:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004c6:	5d                   	pop    %ebp
  8004c7:	c3                   	ret    

008004c8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8004c8:	f3 0f 1e fb          	endbr32 
  8004cc:	55                   	push   %ebp
  8004cd:	89 e5                	mov    %esp,%ebp
  8004cf:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8004d2:	83 f8 1f             	cmp    $0x1f,%eax
  8004d5:	77 30                	ja     800507 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8004d7:	c1 e0 0c             	shl    $0xc,%eax
  8004da:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8004df:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8004e5:	f6 c2 01             	test   $0x1,%dl
  8004e8:	74 24                	je     80050e <fd_lookup+0x46>
  8004ea:	89 c2                	mov    %eax,%edx
  8004ec:	c1 ea 0c             	shr    $0xc,%edx
  8004ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004f6:	f6 c2 01             	test   $0x1,%dl
  8004f9:	74 1a                	je     800515 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8004fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004fe:	89 02                	mov    %eax,(%edx)
	return 0;
  800500:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800505:	5d                   	pop    %ebp
  800506:	c3                   	ret    
		return -E_INVAL;
  800507:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80050c:	eb f7                	jmp    800505 <fd_lookup+0x3d>
		return -E_INVAL;
  80050e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800513:	eb f0                	jmp    800505 <fd_lookup+0x3d>
  800515:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80051a:	eb e9                	jmp    800505 <fd_lookup+0x3d>

0080051c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80051c:	f3 0f 1e fb          	endbr32 
  800520:	55                   	push   %ebp
  800521:	89 e5                	mov    %esp,%ebp
  800523:	83 ec 08             	sub    $0x8,%esp
  800526:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800529:	ba 00 00 00 00       	mov    $0x0,%edx
  80052e:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800533:	39 08                	cmp    %ecx,(%eax)
  800535:	74 38                	je     80056f <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800537:	83 c2 01             	add    $0x1,%edx
  80053a:	8b 04 95 34 25 80 00 	mov    0x802534(,%edx,4),%eax
  800541:	85 c0                	test   %eax,%eax
  800543:	75 ee                	jne    800533 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800545:	a1 08 40 80 00       	mov    0x804008,%eax
  80054a:	8b 40 48             	mov    0x48(%eax),%eax
  80054d:	83 ec 04             	sub    $0x4,%esp
  800550:	51                   	push   %ecx
  800551:	50                   	push   %eax
  800552:	68 b8 24 80 00       	push   $0x8024b8
  800557:	e8 d0 11 00 00       	call   80172c <cprintf>
	*dev = 0;
  80055c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80055f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800565:	83 c4 10             	add    $0x10,%esp
  800568:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80056d:	c9                   	leave  
  80056e:	c3                   	ret    
			*dev = devtab[i];
  80056f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800572:	89 01                	mov    %eax,(%ecx)
			return 0;
  800574:	b8 00 00 00 00       	mov    $0x0,%eax
  800579:	eb f2                	jmp    80056d <dev_lookup+0x51>

0080057b <fd_close>:
{
  80057b:	f3 0f 1e fb          	endbr32 
  80057f:	55                   	push   %ebp
  800580:	89 e5                	mov    %esp,%ebp
  800582:	57                   	push   %edi
  800583:	56                   	push   %esi
  800584:	53                   	push   %ebx
  800585:	83 ec 24             	sub    $0x24,%esp
  800588:	8b 75 08             	mov    0x8(%ebp),%esi
  80058b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80058e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800591:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800592:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800598:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80059b:	50                   	push   %eax
  80059c:	e8 27 ff ff ff       	call   8004c8 <fd_lookup>
  8005a1:	89 c3                	mov    %eax,%ebx
  8005a3:	83 c4 10             	add    $0x10,%esp
  8005a6:	85 c0                	test   %eax,%eax
  8005a8:	78 05                	js     8005af <fd_close+0x34>
	    || fd != fd2)
  8005aa:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8005ad:	74 16                	je     8005c5 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8005af:	89 f8                	mov    %edi,%eax
  8005b1:	84 c0                	test   %al,%al
  8005b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b8:	0f 44 d8             	cmove  %eax,%ebx
}
  8005bb:	89 d8                	mov    %ebx,%eax
  8005bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005c0:	5b                   	pop    %ebx
  8005c1:	5e                   	pop    %esi
  8005c2:	5f                   	pop    %edi
  8005c3:	5d                   	pop    %ebp
  8005c4:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8005c5:	83 ec 08             	sub    $0x8,%esp
  8005c8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8005cb:	50                   	push   %eax
  8005cc:	ff 36                	pushl  (%esi)
  8005ce:	e8 49 ff ff ff       	call   80051c <dev_lookup>
  8005d3:	89 c3                	mov    %eax,%ebx
  8005d5:	83 c4 10             	add    $0x10,%esp
  8005d8:	85 c0                	test   %eax,%eax
  8005da:	78 1a                	js     8005f6 <fd_close+0x7b>
		if (dev->dev_close)
  8005dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005df:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8005e2:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8005e7:	85 c0                	test   %eax,%eax
  8005e9:	74 0b                	je     8005f6 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8005eb:	83 ec 0c             	sub    $0xc,%esp
  8005ee:	56                   	push   %esi
  8005ef:	ff d0                	call   *%eax
  8005f1:	89 c3                	mov    %eax,%ebx
  8005f3:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8005f6:	83 ec 08             	sub    $0x8,%esp
  8005f9:	56                   	push   %esi
  8005fa:	6a 00                	push   $0x0
  8005fc:	e8 0f fc ff ff       	call   800210 <sys_page_unmap>
	return r;
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	eb b5                	jmp    8005bb <fd_close+0x40>

00800606 <close>:

int
close(int fdnum)
{
  800606:	f3 0f 1e fb          	endbr32 
  80060a:	55                   	push   %ebp
  80060b:	89 e5                	mov    %esp,%ebp
  80060d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800610:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800613:	50                   	push   %eax
  800614:	ff 75 08             	pushl  0x8(%ebp)
  800617:	e8 ac fe ff ff       	call   8004c8 <fd_lookup>
  80061c:	83 c4 10             	add    $0x10,%esp
  80061f:	85 c0                	test   %eax,%eax
  800621:	79 02                	jns    800625 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800623:	c9                   	leave  
  800624:	c3                   	ret    
		return fd_close(fd, 1);
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	6a 01                	push   $0x1
  80062a:	ff 75 f4             	pushl  -0xc(%ebp)
  80062d:	e8 49 ff ff ff       	call   80057b <fd_close>
  800632:	83 c4 10             	add    $0x10,%esp
  800635:	eb ec                	jmp    800623 <close+0x1d>

00800637 <close_all>:

void
close_all(void)
{
  800637:	f3 0f 1e fb          	endbr32 
  80063b:	55                   	push   %ebp
  80063c:	89 e5                	mov    %esp,%ebp
  80063e:	53                   	push   %ebx
  80063f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800642:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	53                   	push   %ebx
  80064b:	e8 b6 ff ff ff       	call   800606 <close>
	for (i = 0; i < MAXFD; i++)
  800650:	83 c3 01             	add    $0x1,%ebx
  800653:	83 c4 10             	add    $0x10,%esp
  800656:	83 fb 20             	cmp    $0x20,%ebx
  800659:	75 ec                	jne    800647 <close_all+0x10>
}
  80065b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80065e:	c9                   	leave  
  80065f:	c3                   	ret    

00800660 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800660:	f3 0f 1e fb          	endbr32 
  800664:	55                   	push   %ebp
  800665:	89 e5                	mov    %esp,%ebp
  800667:	57                   	push   %edi
  800668:	56                   	push   %esi
  800669:	53                   	push   %ebx
  80066a:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80066d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800670:	50                   	push   %eax
  800671:	ff 75 08             	pushl  0x8(%ebp)
  800674:	e8 4f fe ff ff       	call   8004c8 <fd_lookup>
  800679:	89 c3                	mov    %eax,%ebx
  80067b:	83 c4 10             	add    $0x10,%esp
  80067e:	85 c0                	test   %eax,%eax
  800680:	0f 88 81 00 00 00    	js     800707 <dup+0xa7>
		return r;
	close(newfdnum);
  800686:	83 ec 0c             	sub    $0xc,%esp
  800689:	ff 75 0c             	pushl  0xc(%ebp)
  80068c:	e8 75 ff ff ff       	call   800606 <close>

	newfd = INDEX2FD(newfdnum);
  800691:	8b 75 0c             	mov    0xc(%ebp),%esi
  800694:	c1 e6 0c             	shl    $0xc,%esi
  800697:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80069d:	83 c4 04             	add    $0x4,%esp
  8006a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006a3:	e8 af fd ff ff       	call   800457 <fd2data>
  8006a8:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8006aa:	89 34 24             	mov    %esi,(%esp)
  8006ad:	e8 a5 fd ff ff       	call   800457 <fd2data>
  8006b2:	83 c4 10             	add    $0x10,%esp
  8006b5:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8006b7:	89 d8                	mov    %ebx,%eax
  8006b9:	c1 e8 16             	shr    $0x16,%eax
  8006bc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8006c3:	a8 01                	test   $0x1,%al
  8006c5:	74 11                	je     8006d8 <dup+0x78>
  8006c7:	89 d8                	mov    %ebx,%eax
  8006c9:	c1 e8 0c             	shr    $0xc,%eax
  8006cc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8006d3:	f6 c2 01             	test   $0x1,%dl
  8006d6:	75 39                	jne    800711 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8006d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006db:	89 d0                	mov    %edx,%eax
  8006dd:	c1 e8 0c             	shr    $0xc,%eax
  8006e0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	25 07 0e 00 00       	and    $0xe07,%eax
  8006ef:	50                   	push   %eax
  8006f0:	56                   	push   %esi
  8006f1:	6a 00                	push   $0x0
  8006f3:	52                   	push   %edx
  8006f4:	6a 00                	push   $0x0
  8006f6:	e8 cf fa ff ff       	call   8001ca <sys_page_map>
  8006fb:	89 c3                	mov    %eax,%ebx
  8006fd:	83 c4 20             	add    $0x20,%esp
  800700:	85 c0                	test   %eax,%eax
  800702:	78 31                	js     800735 <dup+0xd5>
		goto err;

	return newfdnum;
  800704:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800707:	89 d8                	mov    %ebx,%eax
  800709:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80070c:	5b                   	pop    %ebx
  80070d:	5e                   	pop    %esi
  80070e:	5f                   	pop    %edi
  80070f:	5d                   	pop    %ebp
  800710:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800711:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	25 07 0e 00 00       	and    $0xe07,%eax
  800720:	50                   	push   %eax
  800721:	57                   	push   %edi
  800722:	6a 00                	push   $0x0
  800724:	53                   	push   %ebx
  800725:	6a 00                	push   $0x0
  800727:	e8 9e fa ff ff       	call   8001ca <sys_page_map>
  80072c:	89 c3                	mov    %eax,%ebx
  80072e:	83 c4 20             	add    $0x20,%esp
  800731:	85 c0                	test   %eax,%eax
  800733:	79 a3                	jns    8006d8 <dup+0x78>
	sys_page_unmap(0, newfd);
  800735:	83 ec 08             	sub    $0x8,%esp
  800738:	56                   	push   %esi
  800739:	6a 00                	push   $0x0
  80073b:	e8 d0 fa ff ff       	call   800210 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800740:	83 c4 08             	add    $0x8,%esp
  800743:	57                   	push   %edi
  800744:	6a 00                	push   $0x0
  800746:	e8 c5 fa ff ff       	call   800210 <sys_page_unmap>
	return r;
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	eb b7                	jmp    800707 <dup+0xa7>

00800750 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800750:	f3 0f 1e fb          	endbr32 
  800754:	55                   	push   %ebp
  800755:	89 e5                	mov    %esp,%ebp
  800757:	53                   	push   %ebx
  800758:	83 ec 1c             	sub    $0x1c,%esp
  80075b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80075e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800761:	50                   	push   %eax
  800762:	53                   	push   %ebx
  800763:	e8 60 fd ff ff       	call   8004c8 <fd_lookup>
  800768:	83 c4 10             	add    $0x10,%esp
  80076b:	85 c0                	test   %eax,%eax
  80076d:	78 3f                	js     8007ae <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80076f:	83 ec 08             	sub    $0x8,%esp
  800772:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800775:	50                   	push   %eax
  800776:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800779:	ff 30                	pushl  (%eax)
  80077b:	e8 9c fd ff ff       	call   80051c <dev_lookup>
  800780:	83 c4 10             	add    $0x10,%esp
  800783:	85 c0                	test   %eax,%eax
  800785:	78 27                	js     8007ae <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800787:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80078a:	8b 42 08             	mov    0x8(%edx),%eax
  80078d:	83 e0 03             	and    $0x3,%eax
  800790:	83 f8 01             	cmp    $0x1,%eax
  800793:	74 1e                	je     8007b3 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800798:	8b 40 08             	mov    0x8(%eax),%eax
  80079b:	85 c0                	test   %eax,%eax
  80079d:	74 35                	je     8007d4 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80079f:	83 ec 04             	sub    $0x4,%esp
  8007a2:	ff 75 10             	pushl  0x10(%ebp)
  8007a5:	ff 75 0c             	pushl  0xc(%ebp)
  8007a8:	52                   	push   %edx
  8007a9:	ff d0                	call   *%eax
  8007ab:	83 c4 10             	add    $0x10,%esp
}
  8007ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b1:	c9                   	leave  
  8007b2:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8007b3:	a1 08 40 80 00       	mov    0x804008,%eax
  8007b8:	8b 40 48             	mov    0x48(%eax),%eax
  8007bb:	83 ec 04             	sub    $0x4,%esp
  8007be:	53                   	push   %ebx
  8007bf:	50                   	push   %eax
  8007c0:	68 f9 24 80 00       	push   $0x8024f9
  8007c5:	e8 62 0f 00 00       	call   80172c <cprintf>
		return -E_INVAL;
  8007ca:	83 c4 10             	add    $0x10,%esp
  8007cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007d2:	eb da                	jmp    8007ae <read+0x5e>
		return -E_NOT_SUPP;
  8007d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007d9:	eb d3                	jmp    8007ae <read+0x5e>

008007db <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8007db:	f3 0f 1e fb          	endbr32 
  8007df:	55                   	push   %ebp
  8007e0:	89 e5                	mov    %esp,%ebp
  8007e2:	57                   	push   %edi
  8007e3:	56                   	push   %esi
  8007e4:	53                   	push   %ebx
  8007e5:	83 ec 0c             	sub    $0xc,%esp
  8007e8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8007eb:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8007ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007f3:	eb 02                	jmp    8007f7 <readn+0x1c>
  8007f5:	01 c3                	add    %eax,%ebx
  8007f7:	39 f3                	cmp    %esi,%ebx
  8007f9:	73 21                	jae    80081c <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8007fb:	83 ec 04             	sub    $0x4,%esp
  8007fe:	89 f0                	mov    %esi,%eax
  800800:	29 d8                	sub    %ebx,%eax
  800802:	50                   	push   %eax
  800803:	89 d8                	mov    %ebx,%eax
  800805:	03 45 0c             	add    0xc(%ebp),%eax
  800808:	50                   	push   %eax
  800809:	57                   	push   %edi
  80080a:	e8 41 ff ff ff       	call   800750 <read>
		if (m < 0)
  80080f:	83 c4 10             	add    $0x10,%esp
  800812:	85 c0                	test   %eax,%eax
  800814:	78 04                	js     80081a <readn+0x3f>
			return m;
		if (m == 0)
  800816:	75 dd                	jne    8007f5 <readn+0x1a>
  800818:	eb 02                	jmp    80081c <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80081a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80081c:	89 d8                	mov    %ebx,%eax
  80081e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800821:	5b                   	pop    %ebx
  800822:	5e                   	pop    %esi
  800823:	5f                   	pop    %edi
  800824:	5d                   	pop    %ebp
  800825:	c3                   	ret    

00800826 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800826:	f3 0f 1e fb          	endbr32 
  80082a:	55                   	push   %ebp
  80082b:	89 e5                	mov    %esp,%ebp
  80082d:	53                   	push   %ebx
  80082e:	83 ec 1c             	sub    $0x1c,%esp
  800831:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800834:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800837:	50                   	push   %eax
  800838:	53                   	push   %ebx
  800839:	e8 8a fc ff ff       	call   8004c8 <fd_lookup>
  80083e:	83 c4 10             	add    $0x10,%esp
  800841:	85 c0                	test   %eax,%eax
  800843:	78 3a                	js     80087f <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80084b:	50                   	push   %eax
  80084c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084f:	ff 30                	pushl  (%eax)
  800851:	e8 c6 fc ff ff       	call   80051c <dev_lookup>
  800856:	83 c4 10             	add    $0x10,%esp
  800859:	85 c0                	test   %eax,%eax
  80085b:	78 22                	js     80087f <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80085d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800860:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800864:	74 1e                	je     800884 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800866:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800869:	8b 52 0c             	mov    0xc(%edx),%edx
  80086c:	85 d2                	test   %edx,%edx
  80086e:	74 35                	je     8008a5 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800870:	83 ec 04             	sub    $0x4,%esp
  800873:	ff 75 10             	pushl  0x10(%ebp)
  800876:	ff 75 0c             	pushl  0xc(%ebp)
  800879:	50                   	push   %eax
  80087a:	ff d2                	call   *%edx
  80087c:	83 c4 10             	add    $0x10,%esp
}
  80087f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800882:	c9                   	leave  
  800883:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800884:	a1 08 40 80 00       	mov    0x804008,%eax
  800889:	8b 40 48             	mov    0x48(%eax),%eax
  80088c:	83 ec 04             	sub    $0x4,%esp
  80088f:	53                   	push   %ebx
  800890:	50                   	push   %eax
  800891:	68 15 25 80 00       	push   $0x802515
  800896:	e8 91 0e 00 00       	call   80172c <cprintf>
		return -E_INVAL;
  80089b:	83 c4 10             	add    $0x10,%esp
  80089e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a3:	eb da                	jmp    80087f <write+0x59>
		return -E_NOT_SUPP;
  8008a5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008aa:	eb d3                	jmp    80087f <write+0x59>

008008ac <seek>:

int
seek(int fdnum, off_t offset)
{
  8008ac:	f3 0f 1e fb          	endbr32 
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8008b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008b9:	50                   	push   %eax
  8008ba:	ff 75 08             	pushl  0x8(%ebp)
  8008bd:	e8 06 fc ff ff       	call   8004c8 <fd_lookup>
  8008c2:	83 c4 10             	add    $0x10,%esp
  8008c5:	85 c0                	test   %eax,%eax
  8008c7:	78 0e                	js     8008d7 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8008c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008cf:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8008d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008d7:	c9                   	leave  
  8008d8:	c3                   	ret    

008008d9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8008d9:	f3 0f 1e fb          	endbr32 
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	53                   	push   %ebx
  8008e1:	83 ec 1c             	sub    $0x1c,%esp
  8008e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008ea:	50                   	push   %eax
  8008eb:	53                   	push   %ebx
  8008ec:	e8 d7 fb ff ff       	call   8004c8 <fd_lookup>
  8008f1:	83 c4 10             	add    $0x10,%esp
  8008f4:	85 c0                	test   %eax,%eax
  8008f6:	78 37                	js     80092f <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008f8:	83 ec 08             	sub    $0x8,%esp
  8008fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008fe:	50                   	push   %eax
  8008ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800902:	ff 30                	pushl  (%eax)
  800904:	e8 13 fc ff ff       	call   80051c <dev_lookup>
  800909:	83 c4 10             	add    $0x10,%esp
  80090c:	85 c0                	test   %eax,%eax
  80090e:	78 1f                	js     80092f <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800910:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800913:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800917:	74 1b                	je     800934 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800919:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80091c:	8b 52 18             	mov    0x18(%edx),%edx
  80091f:	85 d2                	test   %edx,%edx
  800921:	74 32                	je     800955 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800923:	83 ec 08             	sub    $0x8,%esp
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	50                   	push   %eax
  80092a:	ff d2                	call   *%edx
  80092c:	83 c4 10             	add    $0x10,%esp
}
  80092f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800932:	c9                   	leave  
  800933:	c3                   	ret    
			thisenv->env_id, fdnum);
  800934:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800939:	8b 40 48             	mov    0x48(%eax),%eax
  80093c:	83 ec 04             	sub    $0x4,%esp
  80093f:	53                   	push   %ebx
  800940:	50                   	push   %eax
  800941:	68 d8 24 80 00       	push   $0x8024d8
  800946:	e8 e1 0d 00 00       	call   80172c <cprintf>
		return -E_INVAL;
  80094b:	83 c4 10             	add    $0x10,%esp
  80094e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800953:	eb da                	jmp    80092f <ftruncate+0x56>
		return -E_NOT_SUPP;
  800955:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80095a:	eb d3                	jmp    80092f <ftruncate+0x56>

0080095c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80095c:	f3 0f 1e fb          	endbr32 
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	53                   	push   %ebx
  800964:	83 ec 1c             	sub    $0x1c,%esp
  800967:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80096a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80096d:	50                   	push   %eax
  80096e:	ff 75 08             	pushl  0x8(%ebp)
  800971:	e8 52 fb ff ff       	call   8004c8 <fd_lookup>
  800976:	83 c4 10             	add    $0x10,%esp
  800979:	85 c0                	test   %eax,%eax
  80097b:	78 4b                	js     8009c8 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800983:	50                   	push   %eax
  800984:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800987:	ff 30                	pushl  (%eax)
  800989:	e8 8e fb ff ff       	call   80051c <dev_lookup>
  80098e:	83 c4 10             	add    $0x10,%esp
  800991:	85 c0                	test   %eax,%eax
  800993:	78 33                	js     8009c8 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  800995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800998:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80099c:	74 2f                	je     8009cd <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80099e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8009a1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8009a8:	00 00 00 
	stat->st_isdir = 0;
  8009ab:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8009b2:	00 00 00 
	stat->st_dev = dev;
  8009b5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	53                   	push   %ebx
  8009bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8009c2:	ff 50 14             	call   *0x14(%eax)
  8009c5:	83 c4 10             	add    $0x10,%esp
}
  8009c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009cb:	c9                   	leave  
  8009cc:	c3                   	ret    
		return -E_NOT_SUPP;
  8009cd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8009d2:	eb f4                	jmp    8009c8 <fstat+0x6c>

008009d4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8009d4:	f3 0f 1e fb          	endbr32 
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	56                   	push   %esi
  8009dc:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8009dd:	83 ec 08             	sub    $0x8,%esp
  8009e0:	6a 00                	push   $0x0
  8009e2:	ff 75 08             	pushl  0x8(%ebp)
  8009e5:	e8 fb 01 00 00       	call   800be5 <open>
  8009ea:	89 c3                	mov    %eax,%ebx
  8009ec:	83 c4 10             	add    $0x10,%esp
  8009ef:	85 c0                	test   %eax,%eax
  8009f1:	78 1b                	js     800a0e <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8009f3:	83 ec 08             	sub    $0x8,%esp
  8009f6:	ff 75 0c             	pushl  0xc(%ebp)
  8009f9:	50                   	push   %eax
  8009fa:	e8 5d ff ff ff       	call   80095c <fstat>
  8009ff:	89 c6                	mov    %eax,%esi
	close(fd);
  800a01:	89 1c 24             	mov    %ebx,(%esp)
  800a04:	e8 fd fb ff ff       	call   800606 <close>
	return r;
  800a09:	83 c4 10             	add    $0x10,%esp
  800a0c:	89 f3                	mov    %esi,%ebx
}
  800a0e:	89 d8                	mov    %ebx,%eax
  800a10:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a13:	5b                   	pop    %ebx
  800a14:	5e                   	pop    %esi
  800a15:	5d                   	pop    %ebp
  800a16:	c3                   	ret    

00800a17 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	56                   	push   %esi
  800a1b:	53                   	push   %ebx
  800a1c:	89 c6                	mov    %eax,%esi
  800a1e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800a20:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800a27:	74 27                	je     800a50 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800a29:	6a 07                	push   $0x7
  800a2b:	68 00 50 80 00       	push   $0x805000
  800a30:	56                   	push   %esi
  800a31:	ff 35 00 40 80 00    	pushl  0x804000
  800a37:	e8 f1 16 00 00       	call   80212d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800a3c:	83 c4 0c             	add    $0xc,%esp
  800a3f:	6a 00                	push   $0x0
  800a41:	53                   	push   %ebx
  800a42:	6a 00                	push   $0x0
  800a44:	e8 5f 16 00 00       	call   8020a8 <ipc_recv>
}
  800a49:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a4c:	5b                   	pop    %ebx
  800a4d:	5e                   	pop    %esi
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800a50:	83 ec 0c             	sub    $0xc,%esp
  800a53:	6a 01                	push   $0x1
  800a55:	e8 2b 17 00 00       	call   802185 <ipc_find_env>
  800a5a:	a3 00 40 80 00       	mov    %eax,0x804000
  800a5f:	83 c4 10             	add    $0x10,%esp
  800a62:	eb c5                	jmp    800a29 <fsipc+0x12>

00800a64 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800a64:	f3 0f 1e fb          	endbr32 
  800a68:	55                   	push   %ebp
  800a69:	89 e5                	mov    %esp,%ebp
  800a6b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a71:	8b 40 0c             	mov    0xc(%eax),%eax
  800a74:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7c:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800a81:	ba 00 00 00 00       	mov    $0x0,%edx
  800a86:	b8 02 00 00 00       	mov    $0x2,%eax
  800a8b:	e8 87 ff ff ff       	call   800a17 <fsipc>
}
  800a90:	c9                   	leave  
  800a91:	c3                   	ret    

00800a92 <devfile_flush>:
{
  800a92:	f3 0f 1e fb          	endbr32 
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	8b 40 0c             	mov    0xc(%eax),%eax
  800aa2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800aa7:	ba 00 00 00 00       	mov    $0x0,%edx
  800aac:	b8 06 00 00 00       	mov    $0x6,%eax
  800ab1:	e8 61 ff ff ff       	call   800a17 <fsipc>
}
  800ab6:	c9                   	leave  
  800ab7:	c3                   	ret    

00800ab8 <devfile_stat>:
{
  800ab8:	f3 0f 1e fb          	endbr32 
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	53                   	push   %ebx
  800ac0:	83 ec 04             	sub    $0x4,%esp
  800ac3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	8b 40 0c             	mov    0xc(%eax),%eax
  800acc:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800ad1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad6:	b8 05 00 00 00       	mov    $0x5,%eax
  800adb:	e8 37 ff ff ff       	call   800a17 <fsipc>
  800ae0:	85 c0                	test   %eax,%eax
  800ae2:	78 2c                	js     800b10 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	68 00 50 80 00       	push   $0x805000
  800aec:	53                   	push   %ebx
  800aed:	e8 44 12 00 00       	call   801d36 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800af2:	a1 80 50 80 00       	mov    0x805080,%eax
  800af7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800afd:	a1 84 50 80 00       	mov    0x805084,%eax
  800b02:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800b08:	83 c4 10             	add    $0x10,%esp
  800b0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b13:	c9                   	leave  
  800b14:	c3                   	ret    

00800b15 <devfile_write>:
{
  800b15:	f3 0f 1e fb          	endbr32 
  800b19:	55                   	push   %ebp
  800b1a:	89 e5                	mov    %esp,%ebp
  800b1c:	83 ec 0c             	sub    $0xc,%esp
  800b1f:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800b22:	8b 55 08             	mov    0x8(%ebp),%edx
  800b25:	8b 52 0c             	mov    0xc(%edx),%edx
  800b28:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  800b2e:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800b33:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800b38:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  800b3b:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800b40:	50                   	push   %eax
  800b41:	ff 75 0c             	pushl  0xc(%ebp)
  800b44:	68 08 50 80 00       	push   $0x805008
  800b49:	e8 9e 13 00 00       	call   801eec <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800b4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b53:	b8 04 00 00 00       	mov    $0x4,%eax
  800b58:	e8 ba fe ff ff       	call   800a17 <fsipc>
}
  800b5d:	c9                   	leave  
  800b5e:	c3                   	ret    

00800b5f <devfile_read>:
{
  800b5f:	f3 0f 1e fb          	endbr32 
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	56                   	push   %esi
  800b67:	53                   	push   %ebx
  800b68:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	8b 40 0c             	mov    0xc(%eax),%eax
  800b71:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b76:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b7c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b81:	b8 03 00 00 00       	mov    $0x3,%eax
  800b86:	e8 8c fe ff ff       	call   800a17 <fsipc>
  800b8b:	89 c3                	mov    %eax,%ebx
  800b8d:	85 c0                	test   %eax,%eax
  800b8f:	78 1f                	js     800bb0 <devfile_read+0x51>
	assert(r <= n);
  800b91:	39 f0                	cmp    %esi,%eax
  800b93:	77 24                	ja     800bb9 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800b95:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b9a:	7f 33                	jg     800bcf <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b9c:	83 ec 04             	sub    $0x4,%esp
  800b9f:	50                   	push   %eax
  800ba0:	68 00 50 80 00       	push   $0x805000
  800ba5:	ff 75 0c             	pushl  0xc(%ebp)
  800ba8:	e8 3f 13 00 00       	call   801eec <memmove>
	return r;
  800bad:	83 c4 10             	add    $0x10,%esp
}
  800bb0:	89 d8                	mov    %ebx,%eax
  800bb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bb5:	5b                   	pop    %ebx
  800bb6:	5e                   	pop    %esi
  800bb7:	5d                   	pop    %ebp
  800bb8:	c3                   	ret    
	assert(r <= n);
  800bb9:	68 48 25 80 00       	push   $0x802548
  800bbe:	68 4f 25 80 00       	push   $0x80254f
  800bc3:	6a 7c                	push   $0x7c
  800bc5:	68 64 25 80 00       	push   $0x802564
  800bca:	e8 76 0a 00 00       	call   801645 <_panic>
	assert(r <= PGSIZE);
  800bcf:	68 6f 25 80 00       	push   $0x80256f
  800bd4:	68 4f 25 80 00       	push   $0x80254f
  800bd9:	6a 7d                	push   $0x7d
  800bdb:	68 64 25 80 00       	push   $0x802564
  800be0:	e8 60 0a 00 00       	call   801645 <_panic>

00800be5 <open>:
{
  800be5:	f3 0f 1e fb          	endbr32 
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	56                   	push   %esi
  800bed:	53                   	push   %ebx
  800bee:	83 ec 1c             	sub    $0x1c,%esp
  800bf1:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800bf4:	56                   	push   %esi
  800bf5:	e8 f9 10 00 00       	call   801cf3 <strlen>
  800bfa:	83 c4 10             	add    $0x10,%esp
  800bfd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800c02:	7f 6c                	jg     800c70 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800c04:	83 ec 0c             	sub    $0xc,%esp
  800c07:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c0a:	50                   	push   %eax
  800c0b:	e8 62 f8 ff ff       	call   800472 <fd_alloc>
  800c10:	89 c3                	mov    %eax,%ebx
  800c12:	83 c4 10             	add    $0x10,%esp
  800c15:	85 c0                	test   %eax,%eax
  800c17:	78 3c                	js     800c55 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800c19:	83 ec 08             	sub    $0x8,%esp
  800c1c:	56                   	push   %esi
  800c1d:	68 00 50 80 00       	push   $0x805000
  800c22:	e8 0f 11 00 00       	call   801d36 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800c2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c32:	b8 01 00 00 00       	mov    $0x1,%eax
  800c37:	e8 db fd ff ff       	call   800a17 <fsipc>
  800c3c:	89 c3                	mov    %eax,%ebx
  800c3e:	83 c4 10             	add    $0x10,%esp
  800c41:	85 c0                	test   %eax,%eax
  800c43:	78 19                	js     800c5e <open+0x79>
	return fd2num(fd);
  800c45:	83 ec 0c             	sub    $0xc,%esp
  800c48:	ff 75 f4             	pushl  -0xc(%ebp)
  800c4b:	e8 f3 f7 ff ff       	call   800443 <fd2num>
  800c50:	89 c3                	mov    %eax,%ebx
  800c52:	83 c4 10             	add    $0x10,%esp
}
  800c55:	89 d8                	mov    %ebx,%eax
  800c57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c5a:	5b                   	pop    %ebx
  800c5b:	5e                   	pop    %esi
  800c5c:	5d                   	pop    %ebp
  800c5d:	c3                   	ret    
		fd_close(fd, 0);
  800c5e:	83 ec 08             	sub    $0x8,%esp
  800c61:	6a 00                	push   $0x0
  800c63:	ff 75 f4             	pushl  -0xc(%ebp)
  800c66:	e8 10 f9 ff ff       	call   80057b <fd_close>
		return r;
  800c6b:	83 c4 10             	add    $0x10,%esp
  800c6e:	eb e5                	jmp    800c55 <open+0x70>
		return -E_BAD_PATH;
  800c70:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800c75:	eb de                	jmp    800c55 <open+0x70>

00800c77 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800c77:	f3 0f 1e fb          	endbr32 
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c81:	ba 00 00 00 00       	mov    $0x0,%edx
  800c86:	b8 08 00 00 00       	mov    $0x8,%eax
  800c8b:	e8 87 fd ff ff       	call   800a17 <fsipc>
}
  800c90:	c9                   	leave  
  800c91:	c3                   	ret    

00800c92 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800c92:	f3 0f 1e fb          	endbr32 
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
  800c99:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800c9c:	68 7b 25 80 00       	push   $0x80257b
  800ca1:	ff 75 0c             	pushl  0xc(%ebp)
  800ca4:	e8 8d 10 00 00       	call   801d36 <strcpy>
	return 0;
}
  800ca9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cae:	c9                   	leave  
  800caf:	c3                   	ret    

00800cb0 <devsock_close>:
{
  800cb0:	f3 0f 1e fb          	endbr32 
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	53                   	push   %ebx
  800cb8:	83 ec 10             	sub    $0x10,%esp
  800cbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800cbe:	53                   	push   %ebx
  800cbf:	e8 fe 14 00 00       	call   8021c2 <pageref>
  800cc4:	89 c2                	mov    %eax,%edx
  800cc6:	83 c4 10             	add    $0x10,%esp
		return 0;
  800cc9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  800cce:	83 fa 01             	cmp    $0x1,%edx
  800cd1:	74 05                	je     800cd8 <devsock_close+0x28>
}
  800cd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cd6:	c9                   	leave  
  800cd7:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800cd8:	83 ec 0c             	sub    $0xc,%esp
  800cdb:	ff 73 0c             	pushl  0xc(%ebx)
  800cde:	e8 e3 02 00 00       	call   800fc6 <nsipc_close>
  800ce3:	83 c4 10             	add    $0x10,%esp
  800ce6:	eb eb                	jmp    800cd3 <devsock_close+0x23>

00800ce8 <devsock_write>:
{
  800ce8:	f3 0f 1e fb          	endbr32 
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800cf2:	6a 00                	push   $0x0
  800cf4:	ff 75 10             	pushl  0x10(%ebp)
  800cf7:	ff 75 0c             	pushl  0xc(%ebp)
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfd:	ff 70 0c             	pushl  0xc(%eax)
  800d00:	e8 b5 03 00 00       	call   8010ba <nsipc_send>
}
  800d05:	c9                   	leave  
  800d06:	c3                   	ret    

00800d07 <devsock_read>:
{
  800d07:	f3 0f 1e fb          	endbr32 
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800d11:	6a 00                	push   $0x0
  800d13:	ff 75 10             	pushl  0x10(%ebp)
  800d16:	ff 75 0c             	pushl  0xc(%ebp)
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	ff 70 0c             	pushl  0xc(%eax)
  800d1f:	e8 1f 03 00 00       	call   801043 <nsipc_recv>
}
  800d24:	c9                   	leave  
  800d25:	c3                   	ret    

00800d26 <fd2sockid>:
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800d2c:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800d2f:	52                   	push   %edx
  800d30:	50                   	push   %eax
  800d31:	e8 92 f7 ff ff       	call   8004c8 <fd_lookup>
  800d36:	83 c4 10             	add    $0x10,%esp
  800d39:	85 c0                	test   %eax,%eax
  800d3b:	78 10                	js     800d4d <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d40:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800d46:	39 08                	cmp    %ecx,(%eax)
  800d48:	75 05                	jne    800d4f <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800d4a:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800d4d:	c9                   	leave  
  800d4e:	c3                   	ret    
		return -E_NOT_SUPP;
  800d4f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800d54:	eb f7                	jmp    800d4d <fd2sockid+0x27>

00800d56 <alloc_sockfd>:
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	56                   	push   %esi
  800d5a:	53                   	push   %ebx
  800d5b:	83 ec 1c             	sub    $0x1c,%esp
  800d5e:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800d60:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d63:	50                   	push   %eax
  800d64:	e8 09 f7 ff ff       	call   800472 <fd_alloc>
  800d69:	89 c3                	mov    %eax,%ebx
  800d6b:	83 c4 10             	add    $0x10,%esp
  800d6e:	85 c0                	test   %eax,%eax
  800d70:	78 43                	js     800db5 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800d72:	83 ec 04             	sub    $0x4,%esp
  800d75:	68 07 04 00 00       	push   $0x407
  800d7a:	ff 75 f4             	pushl  -0xc(%ebp)
  800d7d:	6a 00                	push   $0x0
  800d7f:	e8 ff f3 ff ff       	call   800183 <sys_page_alloc>
  800d84:	89 c3                	mov    %eax,%ebx
  800d86:	83 c4 10             	add    $0x10,%esp
  800d89:	85 c0                	test   %eax,%eax
  800d8b:	78 28                	js     800db5 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d90:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800d96:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d9b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800da2:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800da5:	83 ec 0c             	sub    $0xc,%esp
  800da8:	50                   	push   %eax
  800da9:	e8 95 f6 ff ff       	call   800443 <fd2num>
  800dae:	89 c3                	mov    %eax,%ebx
  800db0:	83 c4 10             	add    $0x10,%esp
  800db3:	eb 0c                	jmp    800dc1 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800db5:	83 ec 0c             	sub    $0xc,%esp
  800db8:	56                   	push   %esi
  800db9:	e8 08 02 00 00       	call   800fc6 <nsipc_close>
		return r;
  800dbe:	83 c4 10             	add    $0x10,%esp
}
  800dc1:	89 d8                	mov    %ebx,%eax
  800dc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dc6:	5b                   	pop    %ebx
  800dc7:	5e                   	pop    %esi
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    

00800dca <accept>:
{
  800dca:	f3 0f 1e fb          	endbr32 
  800dce:	55                   	push   %ebp
  800dcf:	89 e5                	mov    %esp,%ebp
  800dd1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	e8 4a ff ff ff       	call   800d26 <fd2sockid>
  800ddc:	85 c0                	test   %eax,%eax
  800dde:	78 1b                	js     800dfb <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	ff 75 10             	pushl  0x10(%ebp)
  800de6:	ff 75 0c             	pushl  0xc(%ebp)
  800de9:	50                   	push   %eax
  800dea:	e8 22 01 00 00       	call   800f11 <nsipc_accept>
  800def:	83 c4 10             	add    $0x10,%esp
  800df2:	85 c0                	test   %eax,%eax
  800df4:	78 05                	js     800dfb <accept+0x31>
	return alloc_sockfd(r);
  800df6:	e8 5b ff ff ff       	call   800d56 <alloc_sockfd>
}
  800dfb:	c9                   	leave  
  800dfc:	c3                   	ret    

00800dfd <bind>:
{
  800dfd:	f3 0f 1e fb          	endbr32 
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	e8 17 ff ff ff       	call   800d26 <fd2sockid>
  800e0f:	85 c0                	test   %eax,%eax
  800e11:	78 12                	js     800e25 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  800e13:	83 ec 04             	sub    $0x4,%esp
  800e16:	ff 75 10             	pushl  0x10(%ebp)
  800e19:	ff 75 0c             	pushl  0xc(%ebp)
  800e1c:	50                   	push   %eax
  800e1d:	e8 45 01 00 00       	call   800f67 <nsipc_bind>
  800e22:	83 c4 10             	add    $0x10,%esp
}
  800e25:	c9                   	leave  
  800e26:	c3                   	ret    

00800e27 <shutdown>:
{
  800e27:	f3 0f 1e fb          	endbr32 
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	e8 ed fe ff ff       	call   800d26 <fd2sockid>
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	78 0f                	js     800e4c <shutdown+0x25>
	return nsipc_shutdown(r, how);
  800e3d:	83 ec 08             	sub    $0x8,%esp
  800e40:	ff 75 0c             	pushl  0xc(%ebp)
  800e43:	50                   	push   %eax
  800e44:	e8 57 01 00 00       	call   800fa0 <nsipc_shutdown>
  800e49:	83 c4 10             	add    $0x10,%esp
}
  800e4c:	c9                   	leave  
  800e4d:	c3                   	ret    

00800e4e <connect>:
{
  800e4e:	f3 0f 1e fb          	endbr32 
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	e8 c6 fe ff ff       	call   800d26 <fd2sockid>
  800e60:	85 c0                	test   %eax,%eax
  800e62:	78 12                	js     800e76 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  800e64:	83 ec 04             	sub    $0x4,%esp
  800e67:	ff 75 10             	pushl  0x10(%ebp)
  800e6a:	ff 75 0c             	pushl  0xc(%ebp)
  800e6d:	50                   	push   %eax
  800e6e:	e8 71 01 00 00       	call   800fe4 <nsipc_connect>
  800e73:	83 c4 10             	add    $0x10,%esp
}
  800e76:	c9                   	leave  
  800e77:	c3                   	ret    

00800e78 <listen>:
{
  800e78:	f3 0f 1e fb          	endbr32 
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	e8 9c fe ff ff       	call   800d26 <fd2sockid>
  800e8a:	85 c0                	test   %eax,%eax
  800e8c:	78 0f                	js     800e9d <listen+0x25>
	return nsipc_listen(r, backlog);
  800e8e:	83 ec 08             	sub    $0x8,%esp
  800e91:	ff 75 0c             	pushl  0xc(%ebp)
  800e94:	50                   	push   %eax
  800e95:	e8 83 01 00 00       	call   80101d <nsipc_listen>
  800e9a:	83 c4 10             	add    $0x10,%esp
}
  800e9d:	c9                   	leave  
  800e9e:	c3                   	ret    

00800e9f <socket>:

int
socket(int domain, int type, int protocol)
{
  800e9f:	f3 0f 1e fb          	endbr32 
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800ea9:	ff 75 10             	pushl  0x10(%ebp)
  800eac:	ff 75 0c             	pushl  0xc(%ebp)
  800eaf:	ff 75 08             	pushl  0x8(%ebp)
  800eb2:	e8 65 02 00 00       	call   80111c <nsipc_socket>
  800eb7:	83 c4 10             	add    $0x10,%esp
  800eba:	85 c0                	test   %eax,%eax
  800ebc:	78 05                	js     800ec3 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  800ebe:	e8 93 fe ff ff       	call   800d56 <alloc_sockfd>
}
  800ec3:	c9                   	leave  
  800ec4:	c3                   	ret    

00800ec5 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	53                   	push   %ebx
  800ec9:	83 ec 04             	sub    $0x4,%esp
  800ecc:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800ece:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800ed5:	74 26                	je     800efd <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800ed7:	6a 07                	push   $0x7
  800ed9:	68 00 60 80 00       	push   $0x806000
  800ede:	53                   	push   %ebx
  800edf:	ff 35 04 40 80 00    	pushl  0x804004
  800ee5:	e8 43 12 00 00       	call   80212d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800eea:	83 c4 0c             	add    $0xc,%esp
  800eed:	6a 00                	push   $0x0
  800eef:	6a 00                	push   $0x0
  800ef1:	6a 00                	push   $0x0
  800ef3:	e8 b0 11 00 00       	call   8020a8 <ipc_recv>
}
  800ef8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800efd:	83 ec 0c             	sub    $0xc,%esp
  800f00:	6a 02                	push   $0x2
  800f02:	e8 7e 12 00 00       	call   802185 <ipc_find_env>
  800f07:	a3 04 40 80 00       	mov    %eax,0x804004
  800f0c:	83 c4 10             	add    $0x10,%esp
  800f0f:	eb c6                	jmp    800ed7 <nsipc+0x12>

00800f11 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800f11:	f3 0f 1e fb          	endbr32 
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	56                   	push   %esi
  800f19:	53                   	push   %ebx
  800f1a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800f25:	8b 06                	mov    (%esi),%eax
  800f27:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800f2c:	b8 01 00 00 00       	mov    $0x1,%eax
  800f31:	e8 8f ff ff ff       	call   800ec5 <nsipc>
  800f36:	89 c3                	mov    %eax,%ebx
  800f38:	85 c0                	test   %eax,%eax
  800f3a:	79 09                	jns    800f45 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  800f3c:	89 d8                	mov    %ebx,%eax
  800f3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5d                   	pop    %ebp
  800f44:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800f45:	83 ec 04             	sub    $0x4,%esp
  800f48:	ff 35 10 60 80 00    	pushl  0x806010
  800f4e:	68 00 60 80 00       	push   $0x806000
  800f53:	ff 75 0c             	pushl  0xc(%ebp)
  800f56:	e8 91 0f 00 00       	call   801eec <memmove>
		*addrlen = ret->ret_addrlen;
  800f5b:	a1 10 60 80 00       	mov    0x806010,%eax
  800f60:	89 06                	mov    %eax,(%esi)
  800f62:	83 c4 10             	add    $0x10,%esp
	return r;
  800f65:	eb d5                	jmp    800f3c <nsipc_accept+0x2b>

00800f67 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800f67:	f3 0f 1e fb          	endbr32 
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	53                   	push   %ebx
  800f6f:	83 ec 08             	sub    $0x8,%esp
  800f72:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800f7d:	53                   	push   %ebx
  800f7e:	ff 75 0c             	pushl  0xc(%ebp)
  800f81:	68 04 60 80 00       	push   $0x806004
  800f86:	e8 61 0f 00 00       	call   801eec <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800f8b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800f91:	b8 02 00 00 00       	mov    $0x2,%eax
  800f96:	e8 2a ff ff ff       	call   800ec5 <nsipc>
}
  800f9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f9e:	c9                   	leave  
  800f9f:	c3                   	ret    

00800fa0 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800fa0:	f3 0f 1e fb          	endbr32 
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800fb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb5:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800fba:	b8 03 00 00 00       	mov    $0x3,%eax
  800fbf:	e8 01 ff ff ff       	call   800ec5 <nsipc>
}
  800fc4:	c9                   	leave  
  800fc5:	c3                   	ret    

00800fc6 <nsipc_close>:

int
nsipc_close(int s)
{
  800fc6:	f3 0f 1e fb          	endbr32 
  800fca:	55                   	push   %ebp
  800fcb:	89 e5                	mov    %esp,%ebp
  800fcd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800fd8:	b8 04 00 00 00       	mov    $0x4,%eax
  800fdd:	e8 e3 fe ff ff       	call   800ec5 <nsipc>
}
  800fe2:	c9                   	leave  
  800fe3:	c3                   	ret    

00800fe4 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800fe4:	f3 0f 1e fb          	endbr32 
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	53                   	push   %ebx
  800fec:	83 ec 08             	sub    $0x8,%esp
  800fef:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800ffa:	53                   	push   %ebx
  800ffb:	ff 75 0c             	pushl  0xc(%ebp)
  800ffe:	68 04 60 80 00       	push   $0x806004
  801003:	e8 e4 0e 00 00       	call   801eec <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801008:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80100e:	b8 05 00 00 00       	mov    $0x5,%eax
  801013:	e8 ad fe ff ff       	call   800ec5 <nsipc>
}
  801018:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80101b:	c9                   	leave  
  80101c:	c3                   	ret    

0080101d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80101d:	f3 0f 1e fb          	endbr32 
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80102f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801032:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801037:	b8 06 00 00 00       	mov    $0x6,%eax
  80103c:	e8 84 fe ff ff       	call   800ec5 <nsipc>
}
  801041:	c9                   	leave  
  801042:	c3                   	ret    

00801043 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801043:	f3 0f 1e fb          	endbr32 
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	56                   	push   %esi
  80104b:	53                   	push   %ebx
  80104c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801057:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80105d:	8b 45 14             	mov    0x14(%ebp),%eax
  801060:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801065:	b8 07 00 00 00       	mov    $0x7,%eax
  80106a:	e8 56 fe ff ff       	call   800ec5 <nsipc>
  80106f:	89 c3                	mov    %eax,%ebx
  801071:	85 c0                	test   %eax,%eax
  801073:	78 26                	js     80109b <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801075:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  80107b:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801080:	0f 4e c6             	cmovle %esi,%eax
  801083:	39 c3                	cmp    %eax,%ebx
  801085:	7f 1d                	jg     8010a4 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801087:	83 ec 04             	sub    $0x4,%esp
  80108a:	53                   	push   %ebx
  80108b:	68 00 60 80 00       	push   $0x806000
  801090:	ff 75 0c             	pushl  0xc(%ebp)
  801093:	e8 54 0e 00 00       	call   801eec <memmove>
  801098:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80109b:	89 d8                	mov    %ebx,%eax
  80109d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010a0:	5b                   	pop    %ebx
  8010a1:	5e                   	pop    %esi
  8010a2:	5d                   	pop    %ebp
  8010a3:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8010a4:	68 87 25 80 00       	push   $0x802587
  8010a9:	68 4f 25 80 00       	push   $0x80254f
  8010ae:	6a 62                	push   $0x62
  8010b0:	68 9c 25 80 00       	push   $0x80259c
  8010b5:	e8 8b 05 00 00       	call   801645 <_panic>

008010ba <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8010ba:	f3 0f 1e fb          	endbr32 
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
  8010c1:	53                   	push   %ebx
  8010c2:	83 ec 04             	sub    $0x4,%esp
  8010c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8010d0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8010d6:	7f 2e                	jg     801106 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	53                   	push   %ebx
  8010dc:	ff 75 0c             	pushl  0xc(%ebp)
  8010df:	68 0c 60 80 00       	push   $0x80600c
  8010e4:	e8 03 0e 00 00       	call   801eec <memmove>
	nsipcbuf.send.req_size = size;
  8010e9:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8010ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f2:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8010f7:	b8 08 00 00 00       	mov    $0x8,%eax
  8010fc:	e8 c4 fd ff ff       	call   800ec5 <nsipc>
}
  801101:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801104:	c9                   	leave  
  801105:	c3                   	ret    
	assert(size < 1600);
  801106:	68 a8 25 80 00       	push   $0x8025a8
  80110b:	68 4f 25 80 00       	push   $0x80254f
  801110:	6a 6d                	push   $0x6d
  801112:	68 9c 25 80 00       	push   $0x80259c
  801117:	e8 29 05 00 00       	call   801645 <_panic>

0080111c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80111c:	f3 0f 1e fb          	endbr32 
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80112e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801131:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801136:	8b 45 10             	mov    0x10(%ebp),%eax
  801139:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80113e:	b8 09 00 00 00       	mov    $0x9,%eax
  801143:	e8 7d fd ff ff       	call   800ec5 <nsipc>
}
  801148:	c9                   	leave  
  801149:	c3                   	ret    

0080114a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80114a:	f3 0f 1e fb          	endbr32 
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	56                   	push   %esi
  801152:	53                   	push   %ebx
  801153:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801156:	83 ec 0c             	sub    $0xc,%esp
  801159:	ff 75 08             	pushl  0x8(%ebp)
  80115c:	e8 f6 f2 ff ff       	call   800457 <fd2data>
  801161:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801163:	83 c4 08             	add    $0x8,%esp
  801166:	68 b4 25 80 00       	push   $0x8025b4
  80116b:	53                   	push   %ebx
  80116c:	e8 c5 0b 00 00       	call   801d36 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801171:	8b 46 04             	mov    0x4(%esi),%eax
  801174:	2b 06                	sub    (%esi),%eax
  801176:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80117c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801183:	00 00 00 
	stat->st_dev = &devpipe;
  801186:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80118d:	30 80 00 
	return 0;
}
  801190:	b8 00 00 00 00       	mov    $0x0,%eax
  801195:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801198:	5b                   	pop    %ebx
  801199:	5e                   	pop    %esi
  80119a:	5d                   	pop    %ebp
  80119b:	c3                   	ret    

0080119c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80119c:	f3 0f 1e fb          	endbr32 
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	53                   	push   %ebx
  8011a4:	83 ec 0c             	sub    $0xc,%esp
  8011a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8011aa:	53                   	push   %ebx
  8011ab:	6a 00                	push   $0x0
  8011ad:	e8 5e f0 ff ff       	call   800210 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8011b2:	89 1c 24             	mov    %ebx,(%esp)
  8011b5:	e8 9d f2 ff ff       	call   800457 <fd2data>
  8011ba:	83 c4 08             	add    $0x8,%esp
  8011bd:	50                   	push   %eax
  8011be:	6a 00                	push   $0x0
  8011c0:	e8 4b f0 ff ff       	call   800210 <sys_page_unmap>
}
  8011c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011c8:	c9                   	leave  
  8011c9:	c3                   	ret    

008011ca <_pipeisclosed>:
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	57                   	push   %edi
  8011ce:	56                   	push   %esi
  8011cf:	53                   	push   %ebx
  8011d0:	83 ec 1c             	sub    $0x1c,%esp
  8011d3:	89 c7                	mov    %eax,%edi
  8011d5:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8011d7:	a1 08 40 80 00       	mov    0x804008,%eax
  8011dc:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8011df:	83 ec 0c             	sub    $0xc,%esp
  8011e2:	57                   	push   %edi
  8011e3:	e8 da 0f 00 00       	call   8021c2 <pageref>
  8011e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011eb:	89 34 24             	mov    %esi,(%esp)
  8011ee:	e8 cf 0f 00 00       	call   8021c2 <pageref>
		nn = thisenv->env_runs;
  8011f3:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8011f9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8011fc:	83 c4 10             	add    $0x10,%esp
  8011ff:	39 cb                	cmp    %ecx,%ebx
  801201:	74 1b                	je     80121e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801203:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801206:	75 cf                	jne    8011d7 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801208:	8b 42 58             	mov    0x58(%edx),%eax
  80120b:	6a 01                	push   $0x1
  80120d:	50                   	push   %eax
  80120e:	53                   	push   %ebx
  80120f:	68 bb 25 80 00       	push   $0x8025bb
  801214:	e8 13 05 00 00       	call   80172c <cprintf>
  801219:	83 c4 10             	add    $0x10,%esp
  80121c:	eb b9                	jmp    8011d7 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80121e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801221:	0f 94 c0             	sete   %al
  801224:	0f b6 c0             	movzbl %al,%eax
}
  801227:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80122a:	5b                   	pop    %ebx
  80122b:	5e                   	pop    %esi
  80122c:	5f                   	pop    %edi
  80122d:	5d                   	pop    %ebp
  80122e:	c3                   	ret    

0080122f <devpipe_write>:
{
  80122f:	f3 0f 1e fb          	endbr32 
  801233:	55                   	push   %ebp
  801234:	89 e5                	mov    %esp,%ebp
  801236:	57                   	push   %edi
  801237:	56                   	push   %esi
  801238:	53                   	push   %ebx
  801239:	83 ec 28             	sub    $0x28,%esp
  80123c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80123f:	56                   	push   %esi
  801240:	e8 12 f2 ff ff       	call   800457 <fd2data>
  801245:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801247:	83 c4 10             	add    $0x10,%esp
  80124a:	bf 00 00 00 00       	mov    $0x0,%edi
  80124f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801252:	74 4f                	je     8012a3 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801254:	8b 43 04             	mov    0x4(%ebx),%eax
  801257:	8b 0b                	mov    (%ebx),%ecx
  801259:	8d 51 20             	lea    0x20(%ecx),%edx
  80125c:	39 d0                	cmp    %edx,%eax
  80125e:	72 14                	jb     801274 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801260:	89 da                	mov    %ebx,%edx
  801262:	89 f0                	mov    %esi,%eax
  801264:	e8 61 ff ff ff       	call   8011ca <_pipeisclosed>
  801269:	85 c0                	test   %eax,%eax
  80126b:	75 3b                	jne    8012a8 <devpipe_write+0x79>
			sys_yield();
  80126d:	e8 ee ee ff ff       	call   800160 <sys_yield>
  801272:	eb e0                	jmp    801254 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801274:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801277:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80127b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80127e:	89 c2                	mov    %eax,%edx
  801280:	c1 fa 1f             	sar    $0x1f,%edx
  801283:	89 d1                	mov    %edx,%ecx
  801285:	c1 e9 1b             	shr    $0x1b,%ecx
  801288:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80128b:	83 e2 1f             	and    $0x1f,%edx
  80128e:	29 ca                	sub    %ecx,%edx
  801290:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801294:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801298:	83 c0 01             	add    $0x1,%eax
  80129b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80129e:	83 c7 01             	add    $0x1,%edi
  8012a1:	eb ac                	jmp    80124f <devpipe_write+0x20>
	return i;
  8012a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a6:	eb 05                	jmp    8012ad <devpipe_write+0x7e>
				return 0;
  8012a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b0:	5b                   	pop    %ebx
  8012b1:	5e                   	pop    %esi
  8012b2:	5f                   	pop    %edi
  8012b3:	5d                   	pop    %ebp
  8012b4:	c3                   	ret    

008012b5 <devpipe_read>:
{
  8012b5:	f3 0f 1e fb          	endbr32 
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
  8012bc:	57                   	push   %edi
  8012bd:	56                   	push   %esi
  8012be:	53                   	push   %ebx
  8012bf:	83 ec 18             	sub    $0x18,%esp
  8012c2:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8012c5:	57                   	push   %edi
  8012c6:	e8 8c f1 ff ff       	call   800457 <fd2data>
  8012cb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8012cd:	83 c4 10             	add    $0x10,%esp
  8012d0:	be 00 00 00 00       	mov    $0x0,%esi
  8012d5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8012d8:	75 14                	jne    8012ee <devpipe_read+0x39>
	return i;
  8012da:	8b 45 10             	mov    0x10(%ebp),%eax
  8012dd:	eb 02                	jmp    8012e1 <devpipe_read+0x2c>
				return i;
  8012df:	89 f0                	mov    %esi,%eax
}
  8012e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e4:	5b                   	pop    %ebx
  8012e5:	5e                   	pop    %esi
  8012e6:	5f                   	pop    %edi
  8012e7:	5d                   	pop    %ebp
  8012e8:	c3                   	ret    
			sys_yield();
  8012e9:	e8 72 ee ff ff       	call   800160 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8012ee:	8b 03                	mov    (%ebx),%eax
  8012f0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8012f3:	75 18                	jne    80130d <devpipe_read+0x58>
			if (i > 0)
  8012f5:	85 f6                	test   %esi,%esi
  8012f7:	75 e6                	jne    8012df <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8012f9:	89 da                	mov    %ebx,%edx
  8012fb:	89 f8                	mov    %edi,%eax
  8012fd:	e8 c8 fe ff ff       	call   8011ca <_pipeisclosed>
  801302:	85 c0                	test   %eax,%eax
  801304:	74 e3                	je     8012e9 <devpipe_read+0x34>
				return 0;
  801306:	b8 00 00 00 00       	mov    $0x0,%eax
  80130b:	eb d4                	jmp    8012e1 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80130d:	99                   	cltd   
  80130e:	c1 ea 1b             	shr    $0x1b,%edx
  801311:	01 d0                	add    %edx,%eax
  801313:	83 e0 1f             	and    $0x1f,%eax
  801316:	29 d0                	sub    %edx,%eax
  801318:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80131d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801320:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801323:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801326:	83 c6 01             	add    $0x1,%esi
  801329:	eb aa                	jmp    8012d5 <devpipe_read+0x20>

0080132b <pipe>:
{
  80132b:	f3 0f 1e fb          	endbr32 
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
  801332:	56                   	push   %esi
  801333:	53                   	push   %ebx
  801334:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801337:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80133a:	50                   	push   %eax
  80133b:	e8 32 f1 ff ff       	call   800472 <fd_alloc>
  801340:	89 c3                	mov    %eax,%ebx
  801342:	83 c4 10             	add    $0x10,%esp
  801345:	85 c0                	test   %eax,%eax
  801347:	0f 88 23 01 00 00    	js     801470 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80134d:	83 ec 04             	sub    $0x4,%esp
  801350:	68 07 04 00 00       	push   $0x407
  801355:	ff 75 f4             	pushl  -0xc(%ebp)
  801358:	6a 00                	push   $0x0
  80135a:	e8 24 ee ff ff       	call   800183 <sys_page_alloc>
  80135f:	89 c3                	mov    %eax,%ebx
  801361:	83 c4 10             	add    $0x10,%esp
  801364:	85 c0                	test   %eax,%eax
  801366:	0f 88 04 01 00 00    	js     801470 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80136c:	83 ec 0c             	sub    $0xc,%esp
  80136f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801372:	50                   	push   %eax
  801373:	e8 fa f0 ff ff       	call   800472 <fd_alloc>
  801378:	89 c3                	mov    %eax,%ebx
  80137a:	83 c4 10             	add    $0x10,%esp
  80137d:	85 c0                	test   %eax,%eax
  80137f:	0f 88 db 00 00 00    	js     801460 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801385:	83 ec 04             	sub    $0x4,%esp
  801388:	68 07 04 00 00       	push   $0x407
  80138d:	ff 75 f0             	pushl  -0x10(%ebp)
  801390:	6a 00                	push   $0x0
  801392:	e8 ec ed ff ff       	call   800183 <sys_page_alloc>
  801397:	89 c3                	mov    %eax,%ebx
  801399:	83 c4 10             	add    $0x10,%esp
  80139c:	85 c0                	test   %eax,%eax
  80139e:	0f 88 bc 00 00 00    	js     801460 <pipe+0x135>
	va = fd2data(fd0);
  8013a4:	83 ec 0c             	sub    $0xc,%esp
  8013a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8013aa:	e8 a8 f0 ff ff       	call   800457 <fd2data>
  8013af:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013b1:	83 c4 0c             	add    $0xc,%esp
  8013b4:	68 07 04 00 00       	push   $0x407
  8013b9:	50                   	push   %eax
  8013ba:	6a 00                	push   $0x0
  8013bc:	e8 c2 ed ff ff       	call   800183 <sys_page_alloc>
  8013c1:	89 c3                	mov    %eax,%ebx
  8013c3:	83 c4 10             	add    $0x10,%esp
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	0f 88 82 00 00 00    	js     801450 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013ce:	83 ec 0c             	sub    $0xc,%esp
  8013d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8013d4:	e8 7e f0 ff ff       	call   800457 <fd2data>
  8013d9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8013e0:	50                   	push   %eax
  8013e1:	6a 00                	push   $0x0
  8013e3:	56                   	push   %esi
  8013e4:	6a 00                	push   $0x0
  8013e6:	e8 df ed ff ff       	call   8001ca <sys_page_map>
  8013eb:	89 c3                	mov    %eax,%ebx
  8013ed:	83 c4 20             	add    $0x20,%esp
  8013f0:	85 c0                	test   %eax,%eax
  8013f2:	78 4e                	js     801442 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8013f4:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8013f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013fc:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8013fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801401:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801408:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80140b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80140d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801410:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801417:	83 ec 0c             	sub    $0xc,%esp
  80141a:	ff 75 f4             	pushl  -0xc(%ebp)
  80141d:	e8 21 f0 ff ff       	call   800443 <fd2num>
  801422:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801425:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801427:	83 c4 04             	add    $0x4,%esp
  80142a:	ff 75 f0             	pushl  -0x10(%ebp)
  80142d:	e8 11 f0 ff ff       	call   800443 <fd2num>
  801432:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801435:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801438:	83 c4 10             	add    $0x10,%esp
  80143b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801440:	eb 2e                	jmp    801470 <pipe+0x145>
	sys_page_unmap(0, va);
  801442:	83 ec 08             	sub    $0x8,%esp
  801445:	56                   	push   %esi
  801446:	6a 00                	push   $0x0
  801448:	e8 c3 ed ff ff       	call   800210 <sys_page_unmap>
  80144d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801450:	83 ec 08             	sub    $0x8,%esp
  801453:	ff 75 f0             	pushl  -0x10(%ebp)
  801456:	6a 00                	push   $0x0
  801458:	e8 b3 ed ff ff       	call   800210 <sys_page_unmap>
  80145d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801460:	83 ec 08             	sub    $0x8,%esp
  801463:	ff 75 f4             	pushl  -0xc(%ebp)
  801466:	6a 00                	push   $0x0
  801468:	e8 a3 ed ff ff       	call   800210 <sys_page_unmap>
  80146d:	83 c4 10             	add    $0x10,%esp
}
  801470:	89 d8                	mov    %ebx,%eax
  801472:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801475:	5b                   	pop    %ebx
  801476:	5e                   	pop    %esi
  801477:	5d                   	pop    %ebp
  801478:	c3                   	ret    

00801479 <pipeisclosed>:
{
  801479:	f3 0f 1e fb          	endbr32 
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
  801480:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801483:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801486:	50                   	push   %eax
  801487:	ff 75 08             	pushl  0x8(%ebp)
  80148a:	e8 39 f0 ff ff       	call   8004c8 <fd_lookup>
  80148f:	83 c4 10             	add    $0x10,%esp
  801492:	85 c0                	test   %eax,%eax
  801494:	78 18                	js     8014ae <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801496:	83 ec 0c             	sub    $0xc,%esp
  801499:	ff 75 f4             	pushl  -0xc(%ebp)
  80149c:	e8 b6 ef ff ff       	call   800457 <fd2data>
  8014a1:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8014a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a6:	e8 1f fd ff ff       	call   8011ca <_pipeisclosed>
  8014ab:	83 c4 10             	add    $0x10,%esp
}
  8014ae:	c9                   	leave  
  8014af:	c3                   	ret    

008014b0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8014b0:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8014b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b9:	c3                   	ret    

008014ba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8014ba:	f3 0f 1e fb          	endbr32 
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8014c4:	68 d3 25 80 00       	push   $0x8025d3
  8014c9:	ff 75 0c             	pushl  0xc(%ebp)
  8014cc:	e8 65 08 00 00       	call   801d36 <strcpy>
	return 0;
}
  8014d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d6:	c9                   	leave  
  8014d7:	c3                   	ret    

008014d8 <devcons_write>:
{
  8014d8:	f3 0f 1e fb          	endbr32 
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	57                   	push   %edi
  8014e0:	56                   	push   %esi
  8014e1:	53                   	push   %ebx
  8014e2:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8014e8:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8014ed:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8014f3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8014f6:	73 31                	jae    801529 <devcons_write+0x51>
		m = n - tot;
  8014f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014fb:	29 f3                	sub    %esi,%ebx
  8014fd:	83 fb 7f             	cmp    $0x7f,%ebx
  801500:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801505:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801508:	83 ec 04             	sub    $0x4,%esp
  80150b:	53                   	push   %ebx
  80150c:	89 f0                	mov    %esi,%eax
  80150e:	03 45 0c             	add    0xc(%ebp),%eax
  801511:	50                   	push   %eax
  801512:	57                   	push   %edi
  801513:	e8 d4 09 00 00       	call   801eec <memmove>
		sys_cputs(buf, m);
  801518:	83 c4 08             	add    $0x8,%esp
  80151b:	53                   	push   %ebx
  80151c:	57                   	push   %edi
  80151d:	e8 91 eb ff ff       	call   8000b3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801522:	01 de                	add    %ebx,%esi
  801524:	83 c4 10             	add    $0x10,%esp
  801527:	eb ca                	jmp    8014f3 <devcons_write+0x1b>
}
  801529:	89 f0                	mov    %esi,%eax
  80152b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80152e:	5b                   	pop    %ebx
  80152f:	5e                   	pop    %esi
  801530:	5f                   	pop    %edi
  801531:	5d                   	pop    %ebp
  801532:	c3                   	ret    

00801533 <devcons_read>:
{
  801533:	f3 0f 1e fb          	endbr32 
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	83 ec 08             	sub    $0x8,%esp
  80153d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801542:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801546:	74 21                	je     801569 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801548:	e8 88 eb ff ff       	call   8000d5 <sys_cgetc>
  80154d:	85 c0                	test   %eax,%eax
  80154f:	75 07                	jne    801558 <devcons_read+0x25>
		sys_yield();
  801551:	e8 0a ec ff ff       	call   800160 <sys_yield>
  801556:	eb f0                	jmp    801548 <devcons_read+0x15>
	if (c < 0)
  801558:	78 0f                	js     801569 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80155a:	83 f8 04             	cmp    $0x4,%eax
  80155d:	74 0c                	je     80156b <devcons_read+0x38>
	*(char*)vbuf = c;
  80155f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801562:	88 02                	mov    %al,(%edx)
	return 1;
  801564:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801569:	c9                   	leave  
  80156a:	c3                   	ret    
		return 0;
  80156b:	b8 00 00 00 00       	mov    $0x0,%eax
  801570:	eb f7                	jmp    801569 <devcons_read+0x36>

00801572 <cputchar>:
{
  801572:	f3 0f 1e fb          	endbr32 
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80157c:	8b 45 08             	mov    0x8(%ebp),%eax
  80157f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801582:	6a 01                	push   $0x1
  801584:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801587:	50                   	push   %eax
  801588:	e8 26 eb ff ff       	call   8000b3 <sys_cputs>
}
  80158d:	83 c4 10             	add    $0x10,%esp
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <getchar>:
{
  801592:	f3 0f 1e fb          	endbr32 
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80159c:	6a 01                	push   $0x1
  80159e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8015a1:	50                   	push   %eax
  8015a2:	6a 00                	push   $0x0
  8015a4:	e8 a7 f1 ff ff       	call   800750 <read>
	if (r < 0)
  8015a9:	83 c4 10             	add    $0x10,%esp
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	78 06                	js     8015b6 <getchar+0x24>
	if (r < 1)
  8015b0:	74 06                	je     8015b8 <getchar+0x26>
	return c;
  8015b2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    
		return -E_EOF;
  8015b8:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8015bd:	eb f7                	jmp    8015b6 <getchar+0x24>

008015bf <iscons>:
{
  8015bf:	f3 0f 1e fb          	endbr32 
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
  8015c6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015cc:	50                   	push   %eax
  8015cd:	ff 75 08             	pushl  0x8(%ebp)
  8015d0:	e8 f3 ee ff ff       	call   8004c8 <fd_lookup>
  8015d5:	83 c4 10             	add    $0x10,%esp
  8015d8:	85 c0                	test   %eax,%eax
  8015da:	78 11                	js     8015ed <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8015dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015df:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8015e5:	39 10                	cmp    %edx,(%eax)
  8015e7:	0f 94 c0             	sete   %al
  8015ea:	0f b6 c0             	movzbl %al,%eax
}
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <opencons>:
{
  8015ef:	f3 0f 1e fb          	endbr32 
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8015f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fc:	50                   	push   %eax
  8015fd:	e8 70 ee ff ff       	call   800472 <fd_alloc>
  801602:	83 c4 10             	add    $0x10,%esp
  801605:	85 c0                	test   %eax,%eax
  801607:	78 3a                	js     801643 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801609:	83 ec 04             	sub    $0x4,%esp
  80160c:	68 07 04 00 00       	push   $0x407
  801611:	ff 75 f4             	pushl  -0xc(%ebp)
  801614:	6a 00                	push   $0x0
  801616:	e8 68 eb ff ff       	call   800183 <sys_page_alloc>
  80161b:	83 c4 10             	add    $0x10,%esp
  80161e:	85 c0                	test   %eax,%eax
  801620:	78 21                	js     801643 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801625:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80162b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80162d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801630:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801637:	83 ec 0c             	sub    $0xc,%esp
  80163a:	50                   	push   %eax
  80163b:	e8 03 ee ff ff       	call   800443 <fd2num>
  801640:	83 c4 10             	add    $0x10,%esp
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801645:	f3 0f 1e fb          	endbr32 
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
  80164c:	56                   	push   %esi
  80164d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80164e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801651:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801657:	e8 e1 ea ff ff       	call   80013d <sys_getenvid>
  80165c:	83 ec 0c             	sub    $0xc,%esp
  80165f:	ff 75 0c             	pushl  0xc(%ebp)
  801662:	ff 75 08             	pushl  0x8(%ebp)
  801665:	56                   	push   %esi
  801666:	50                   	push   %eax
  801667:	68 e0 25 80 00       	push   $0x8025e0
  80166c:	e8 bb 00 00 00       	call   80172c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801671:	83 c4 18             	add    $0x18,%esp
  801674:	53                   	push   %ebx
  801675:	ff 75 10             	pushl  0x10(%ebp)
  801678:	e8 5a 00 00 00       	call   8016d7 <vcprintf>
	cprintf("\n");
  80167d:	c7 04 24 18 29 80 00 	movl   $0x802918,(%esp)
  801684:	e8 a3 00 00 00       	call   80172c <cprintf>
  801689:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80168c:	cc                   	int3   
  80168d:	eb fd                	jmp    80168c <_panic+0x47>

0080168f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80168f:	f3 0f 1e fb          	endbr32 
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	53                   	push   %ebx
  801697:	83 ec 04             	sub    $0x4,%esp
  80169a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80169d:	8b 13                	mov    (%ebx),%edx
  80169f:	8d 42 01             	lea    0x1(%edx),%eax
  8016a2:	89 03                	mov    %eax,(%ebx)
  8016a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016a7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8016ab:	3d ff 00 00 00       	cmp    $0xff,%eax
  8016b0:	74 09                	je     8016bb <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8016b2:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8016b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8016bb:	83 ec 08             	sub    $0x8,%esp
  8016be:	68 ff 00 00 00       	push   $0xff
  8016c3:	8d 43 08             	lea    0x8(%ebx),%eax
  8016c6:	50                   	push   %eax
  8016c7:	e8 e7 e9 ff ff       	call   8000b3 <sys_cputs>
		b->idx = 0;
  8016cc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8016d2:	83 c4 10             	add    $0x10,%esp
  8016d5:	eb db                	jmp    8016b2 <putch+0x23>

008016d7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8016d7:	f3 0f 1e fb          	endbr32 
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8016e4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8016eb:	00 00 00 
	b.cnt = 0;
  8016ee:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8016f5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8016f8:	ff 75 0c             	pushl  0xc(%ebp)
  8016fb:	ff 75 08             	pushl  0x8(%ebp)
  8016fe:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801704:	50                   	push   %eax
  801705:	68 8f 16 80 00       	push   $0x80168f
  80170a:	e8 20 01 00 00       	call   80182f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80170f:	83 c4 08             	add    $0x8,%esp
  801712:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801718:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80171e:	50                   	push   %eax
  80171f:	e8 8f e9 ff ff       	call   8000b3 <sys_cputs>

	return b.cnt;
}
  801724:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80172c:	f3 0f 1e fb          	endbr32 
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801736:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801739:	50                   	push   %eax
  80173a:	ff 75 08             	pushl  0x8(%ebp)
  80173d:	e8 95 ff ff ff       	call   8016d7 <vcprintf>
	va_end(ap);

	return cnt;
}
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	57                   	push   %edi
  801748:	56                   	push   %esi
  801749:	53                   	push   %ebx
  80174a:	83 ec 1c             	sub    $0x1c,%esp
  80174d:	89 c7                	mov    %eax,%edi
  80174f:	89 d6                	mov    %edx,%esi
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	8b 55 0c             	mov    0xc(%ebp),%edx
  801757:	89 d1                	mov    %edx,%ecx
  801759:	89 c2                	mov    %eax,%edx
  80175b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80175e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801761:	8b 45 10             	mov    0x10(%ebp),%eax
  801764:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801767:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80176a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801771:	39 c2                	cmp    %eax,%edx
  801773:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  801776:	72 3e                	jb     8017b6 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801778:	83 ec 0c             	sub    $0xc,%esp
  80177b:	ff 75 18             	pushl  0x18(%ebp)
  80177e:	83 eb 01             	sub    $0x1,%ebx
  801781:	53                   	push   %ebx
  801782:	50                   	push   %eax
  801783:	83 ec 08             	sub    $0x8,%esp
  801786:	ff 75 e4             	pushl  -0x1c(%ebp)
  801789:	ff 75 e0             	pushl  -0x20(%ebp)
  80178c:	ff 75 dc             	pushl  -0x24(%ebp)
  80178f:	ff 75 d8             	pushl  -0x28(%ebp)
  801792:	e8 79 0a 00 00       	call   802210 <__udivdi3>
  801797:	83 c4 18             	add    $0x18,%esp
  80179a:	52                   	push   %edx
  80179b:	50                   	push   %eax
  80179c:	89 f2                	mov    %esi,%edx
  80179e:	89 f8                	mov    %edi,%eax
  8017a0:	e8 9f ff ff ff       	call   801744 <printnum>
  8017a5:	83 c4 20             	add    $0x20,%esp
  8017a8:	eb 13                	jmp    8017bd <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8017aa:	83 ec 08             	sub    $0x8,%esp
  8017ad:	56                   	push   %esi
  8017ae:	ff 75 18             	pushl  0x18(%ebp)
  8017b1:	ff d7                	call   *%edi
  8017b3:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8017b6:	83 eb 01             	sub    $0x1,%ebx
  8017b9:	85 db                	test   %ebx,%ebx
  8017bb:	7f ed                	jg     8017aa <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8017bd:	83 ec 08             	sub    $0x8,%esp
  8017c0:	56                   	push   %esi
  8017c1:	83 ec 04             	sub    $0x4,%esp
  8017c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017c7:	ff 75 e0             	pushl  -0x20(%ebp)
  8017ca:	ff 75 dc             	pushl  -0x24(%ebp)
  8017cd:	ff 75 d8             	pushl  -0x28(%ebp)
  8017d0:	e8 4b 0b 00 00       	call   802320 <__umoddi3>
  8017d5:	83 c4 14             	add    $0x14,%esp
  8017d8:	0f be 80 03 26 80 00 	movsbl 0x802603(%eax),%eax
  8017df:	50                   	push   %eax
  8017e0:	ff d7                	call   *%edi
}
  8017e2:	83 c4 10             	add    $0x10,%esp
  8017e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017e8:	5b                   	pop    %ebx
  8017e9:	5e                   	pop    %esi
  8017ea:	5f                   	pop    %edi
  8017eb:	5d                   	pop    %ebp
  8017ec:	c3                   	ret    

008017ed <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8017ed:	f3 0f 1e fb          	endbr32 
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8017f7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8017fb:	8b 10                	mov    (%eax),%edx
  8017fd:	3b 50 04             	cmp    0x4(%eax),%edx
  801800:	73 0a                	jae    80180c <sprintputch+0x1f>
		*b->buf++ = ch;
  801802:	8d 4a 01             	lea    0x1(%edx),%ecx
  801805:	89 08                	mov    %ecx,(%eax)
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	88 02                	mov    %al,(%edx)
}
  80180c:	5d                   	pop    %ebp
  80180d:	c3                   	ret    

0080180e <printfmt>:
{
  80180e:	f3 0f 1e fb          	endbr32 
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801818:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80181b:	50                   	push   %eax
  80181c:	ff 75 10             	pushl  0x10(%ebp)
  80181f:	ff 75 0c             	pushl  0xc(%ebp)
  801822:	ff 75 08             	pushl  0x8(%ebp)
  801825:	e8 05 00 00 00       	call   80182f <vprintfmt>
}
  80182a:	83 c4 10             	add    $0x10,%esp
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <vprintfmt>:
{
  80182f:	f3 0f 1e fb          	endbr32 
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	57                   	push   %edi
  801837:	56                   	push   %esi
  801838:	53                   	push   %ebx
  801839:	83 ec 3c             	sub    $0x3c,%esp
  80183c:	8b 75 08             	mov    0x8(%ebp),%esi
  80183f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801842:	8b 7d 10             	mov    0x10(%ebp),%edi
  801845:	e9 8e 03 00 00       	jmp    801bd8 <vprintfmt+0x3a9>
		padc = ' ';
  80184a:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80184e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801855:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80185c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801863:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801868:	8d 47 01             	lea    0x1(%edi),%eax
  80186b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80186e:	0f b6 17             	movzbl (%edi),%edx
  801871:	8d 42 dd             	lea    -0x23(%edx),%eax
  801874:	3c 55                	cmp    $0x55,%al
  801876:	0f 87 df 03 00 00    	ja     801c5b <vprintfmt+0x42c>
  80187c:	0f b6 c0             	movzbl %al,%eax
  80187f:	3e ff 24 85 40 27 80 	notrack jmp *0x802740(,%eax,4)
  801886:	00 
  801887:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80188a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80188e:	eb d8                	jmp    801868 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801890:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801893:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801897:	eb cf                	jmp    801868 <vprintfmt+0x39>
  801899:	0f b6 d2             	movzbl %dl,%edx
  80189c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80189f:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8018a7:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8018aa:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8018ae:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8018b1:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8018b4:	83 f9 09             	cmp    $0x9,%ecx
  8018b7:	77 55                	ja     80190e <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8018b9:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8018bc:	eb e9                	jmp    8018a7 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8018be:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c1:	8b 00                	mov    (%eax),%eax
  8018c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c9:	8d 40 04             	lea    0x4(%eax),%eax
  8018cc:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8018cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8018d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018d6:	79 90                	jns    801868 <vprintfmt+0x39>
				width = precision, precision = -1;
  8018d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018db:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8018de:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8018e5:	eb 81                	jmp    801868 <vprintfmt+0x39>
  8018e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ea:	85 c0                	test   %eax,%eax
  8018ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f1:	0f 49 d0             	cmovns %eax,%edx
  8018f4:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8018f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8018fa:	e9 69 ff ff ff       	jmp    801868 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8018ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801902:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801909:	e9 5a ff ff ff       	jmp    801868 <vprintfmt+0x39>
  80190e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801911:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801914:	eb bc                	jmp    8018d2 <vprintfmt+0xa3>
			lflag++;
  801916:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801919:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80191c:	e9 47 ff ff ff       	jmp    801868 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  801921:	8b 45 14             	mov    0x14(%ebp),%eax
  801924:	8d 78 04             	lea    0x4(%eax),%edi
  801927:	83 ec 08             	sub    $0x8,%esp
  80192a:	53                   	push   %ebx
  80192b:	ff 30                	pushl  (%eax)
  80192d:	ff d6                	call   *%esi
			break;
  80192f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801932:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801935:	e9 9b 02 00 00       	jmp    801bd5 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80193a:	8b 45 14             	mov    0x14(%ebp),%eax
  80193d:	8d 78 04             	lea    0x4(%eax),%edi
  801940:	8b 00                	mov    (%eax),%eax
  801942:	99                   	cltd   
  801943:	31 d0                	xor    %edx,%eax
  801945:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801947:	83 f8 0f             	cmp    $0xf,%eax
  80194a:	7f 23                	jg     80196f <vprintfmt+0x140>
  80194c:	8b 14 85 a0 28 80 00 	mov    0x8028a0(,%eax,4),%edx
  801953:	85 d2                	test   %edx,%edx
  801955:	74 18                	je     80196f <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  801957:	52                   	push   %edx
  801958:	68 61 25 80 00       	push   $0x802561
  80195d:	53                   	push   %ebx
  80195e:	56                   	push   %esi
  80195f:	e8 aa fe ff ff       	call   80180e <printfmt>
  801964:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801967:	89 7d 14             	mov    %edi,0x14(%ebp)
  80196a:	e9 66 02 00 00       	jmp    801bd5 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80196f:	50                   	push   %eax
  801970:	68 1b 26 80 00       	push   $0x80261b
  801975:	53                   	push   %ebx
  801976:	56                   	push   %esi
  801977:	e8 92 fe ff ff       	call   80180e <printfmt>
  80197c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80197f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801982:	e9 4e 02 00 00       	jmp    801bd5 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  801987:	8b 45 14             	mov    0x14(%ebp),%eax
  80198a:	83 c0 04             	add    $0x4,%eax
  80198d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801990:	8b 45 14             	mov    0x14(%ebp),%eax
  801993:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801995:	85 d2                	test   %edx,%edx
  801997:	b8 14 26 80 00       	mov    $0x802614,%eax
  80199c:	0f 45 c2             	cmovne %edx,%eax
  80199f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8019a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019a6:	7e 06                	jle    8019ae <vprintfmt+0x17f>
  8019a8:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8019ac:	75 0d                	jne    8019bb <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8019ae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019b1:	89 c7                	mov    %eax,%edi
  8019b3:	03 45 e0             	add    -0x20(%ebp),%eax
  8019b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019b9:	eb 55                	jmp    801a10 <vprintfmt+0x1e1>
  8019bb:	83 ec 08             	sub    $0x8,%esp
  8019be:	ff 75 d8             	pushl  -0x28(%ebp)
  8019c1:	ff 75 cc             	pushl  -0x34(%ebp)
  8019c4:	e8 46 03 00 00       	call   801d0f <strnlen>
  8019c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019cc:	29 c2                	sub    %eax,%edx
  8019ce:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8019d1:	83 c4 10             	add    $0x10,%esp
  8019d4:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8019d6:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8019da:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8019dd:	85 ff                	test   %edi,%edi
  8019df:	7e 11                	jle    8019f2 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8019e1:	83 ec 08             	sub    $0x8,%esp
  8019e4:	53                   	push   %ebx
  8019e5:	ff 75 e0             	pushl  -0x20(%ebp)
  8019e8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8019ea:	83 ef 01             	sub    $0x1,%edi
  8019ed:	83 c4 10             	add    $0x10,%esp
  8019f0:	eb eb                	jmp    8019dd <vprintfmt+0x1ae>
  8019f2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8019f5:	85 d2                	test   %edx,%edx
  8019f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fc:	0f 49 c2             	cmovns %edx,%eax
  8019ff:	29 c2                	sub    %eax,%edx
  801a01:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801a04:	eb a8                	jmp    8019ae <vprintfmt+0x17f>
					putch(ch, putdat);
  801a06:	83 ec 08             	sub    $0x8,%esp
  801a09:	53                   	push   %ebx
  801a0a:	52                   	push   %edx
  801a0b:	ff d6                	call   *%esi
  801a0d:	83 c4 10             	add    $0x10,%esp
  801a10:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801a13:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a15:	83 c7 01             	add    $0x1,%edi
  801a18:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a1c:	0f be d0             	movsbl %al,%edx
  801a1f:	85 d2                	test   %edx,%edx
  801a21:	74 4b                	je     801a6e <vprintfmt+0x23f>
  801a23:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801a27:	78 06                	js     801a2f <vprintfmt+0x200>
  801a29:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801a2d:	78 1e                	js     801a4d <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  801a2f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801a33:	74 d1                	je     801a06 <vprintfmt+0x1d7>
  801a35:	0f be c0             	movsbl %al,%eax
  801a38:	83 e8 20             	sub    $0x20,%eax
  801a3b:	83 f8 5e             	cmp    $0x5e,%eax
  801a3e:	76 c6                	jbe    801a06 <vprintfmt+0x1d7>
					putch('?', putdat);
  801a40:	83 ec 08             	sub    $0x8,%esp
  801a43:	53                   	push   %ebx
  801a44:	6a 3f                	push   $0x3f
  801a46:	ff d6                	call   *%esi
  801a48:	83 c4 10             	add    $0x10,%esp
  801a4b:	eb c3                	jmp    801a10 <vprintfmt+0x1e1>
  801a4d:	89 cf                	mov    %ecx,%edi
  801a4f:	eb 0e                	jmp    801a5f <vprintfmt+0x230>
				putch(' ', putdat);
  801a51:	83 ec 08             	sub    $0x8,%esp
  801a54:	53                   	push   %ebx
  801a55:	6a 20                	push   $0x20
  801a57:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801a59:	83 ef 01             	sub    $0x1,%edi
  801a5c:	83 c4 10             	add    $0x10,%esp
  801a5f:	85 ff                	test   %edi,%edi
  801a61:	7f ee                	jg     801a51 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  801a63:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a66:	89 45 14             	mov    %eax,0x14(%ebp)
  801a69:	e9 67 01 00 00       	jmp    801bd5 <vprintfmt+0x3a6>
  801a6e:	89 cf                	mov    %ecx,%edi
  801a70:	eb ed                	jmp    801a5f <vprintfmt+0x230>
	if (lflag >= 2)
  801a72:	83 f9 01             	cmp    $0x1,%ecx
  801a75:	7f 1b                	jg     801a92 <vprintfmt+0x263>
	else if (lflag)
  801a77:	85 c9                	test   %ecx,%ecx
  801a79:	74 63                	je     801ade <vprintfmt+0x2af>
		return va_arg(*ap, long);
  801a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7e:	8b 00                	mov    (%eax),%eax
  801a80:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a83:	99                   	cltd   
  801a84:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a87:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8a:	8d 40 04             	lea    0x4(%eax),%eax
  801a8d:	89 45 14             	mov    %eax,0x14(%ebp)
  801a90:	eb 17                	jmp    801aa9 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801a92:	8b 45 14             	mov    0x14(%ebp),%eax
  801a95:	8b 50 04             	mov    0x4(%eax),%edx
  801a98:	8b 00                	mov    (%eax),%eax
  801a9a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a9d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa3:	8d 40 08             	lea    0x8(%eax),%eax
  801aa6:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801aa9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801aac:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801aaf:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801ab4:	85 c9                	test   %ecx,%ecx
  801ab6:	0f 89 ff 00 00 00    	jns    801bbb <vprintfmt+0x38c>
				putch('-', putdat);
  801abc:	83 ec 08             	sub    $0x8,%esp
  801abf:	53                   	push   %ebx
  801ac0:	6a 2d                	push   $0x2d
  801ac2:	ff d6                	call   *%esi
				num = -(long long) num;
  801ac4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ac7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801aca:	f7 da                	neg    %edx
  801acc:	83 d1 00             	adc    $0x0,%ecx
  801acf:	f7 d9                	neg    %ecx
  801ad1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801ad4:	b8 0a 00 00 00       	mov    $0xa,%eax
  801ad9:	e9 dd 00 00 00       	jmp    801bbb <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801ade:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae1:	8b 00                	mov    (%eax),%eax
  801ae3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ae6:	99                   	cltd   
  801ae7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801aea:	8b 45 14             	mov    0x14(%ebp),%eax
  801aed:	8d 40 04             	lea    0x4(%eax),%eax
  801af0:	89 45 14             	mov    %eax,0x14(%ebp)
  801af3:	eb b4                	jmp    801aa9 <vprintfmt+0x27a>
	if (lflag >= 2)
  801af5:	83 f9 01             	cmp    $0x1,%ecx
  801af8:	7f 1e                	jg     801b18 <vprintfmt+0x2e9>
	else if (lflag)
  801afa:	85 c9                	test   %ecx,%ecx
  801afc:	74 32                	je     801b30 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801afe:	8b 45 14             	mov    0x14(%ebp),%eax
  801b01:	8b 10                	mov    (%eax),%edx
  801b03:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b08:	8d 40 04             	lea    0x4(%eax),%eax
  801b0b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b0e:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801b13:	e9 a3 00 00 00       	jmp    801bbb <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b18:	8b 45 14             	mov    0x14(%ebp),%eax
  801b1b:	8b 10                	mov    (%eax),%edx
  801b1d:	8b 48 04             	mov    0x4(%eax),%ecx
  801b20:	8d 40 08             	lea    0x8(%eax),%eax
  801b23:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b26:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  801b2b:	e9 8b 00 00 00       	jmp    801bbb <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b30:	8b 45 14             	mov    0x14(%ebp),%eax
  801b33:	8b 10                	mov    (%eax),%edx
  801b35:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b3a:	8d 40 04             	lea    0x4(%eax),%eax
  801b3d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b40:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  801b45:	eb 74                	jmp    801bbb <vprintfmt+0x38c>
	if (lflag >= 2)
  801b47:	83 f9 01             	cmp    $0x1,%ecx
  801b4a:	7f 1b                	jg     801b67 <vprintfmt+0x338>
	else if (lflag)
  801b4c:	85 c9                	test   %ecx,%ecx
  801b4e:	74 2c                	je     801b7c <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801b50:	8b 45 14             	mov    0x14(%ebp),%eax
  801b53:	8b 10                	mov    (%eax),%edx
  801b55:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b5a:	8d 40 04             	lea    0x4(%eax),%eax
  801b5d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b60:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801b65:	eb 54                	jmp    801bbb <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b67:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6a:	8b 10                	mov    (%eax),%edx
  801b6c:	8b 48 04             	mov    0x4(%eax),%ecx
  801b6f:	8d 40 08             	lea    0x8(%eax),%eax
  801b72:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b75:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801b7a:	eb 3f                	jmp    801bbb <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b7c:	8b 45 14             	mov    0x14(%ebp),%eax
  801b7f:	8b 10                	mov    (%eax),%edx
  801b81:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b86:	8d 40 04             	lea    0x4(%eax),%eax
  801b89:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b8c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801b91:	eb 28                	jmp    801bbb <vprintfmt+0x38c>
			putch('0', putdat);
  801b93:	83 ec 08             	sub    $0x8,%esp
  801b96:	53                   	push   %ebx
  801b97:	6a 30                	push   $0x30
  801b99:	ff d6                	call   *%esi
			putch('x', putdat);
  801b9b:	83 c4 08             	add    $0x8,%esp
  801b9e:	53                   	push   %ebx
  801b9f:	6a 78                	push   $0x78
  801ba1:	ff d6                	call   *%esi
			num = (unsigned long long)
  801ba3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba6:	8b 10                	mov    (%eax),%edx
  801ba8:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801bad:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801bb0:	8d 40 04             	lea    0x4(%eax),%eax
  801bb3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801bb6:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801bbb:	83 ec 0c             	sub    $0xc,%esp
  801bbe:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801bc2:	57                   	push   %edi
  801bc3:	ff 75 e0             	pushl  -0x20(%ebp)
  801bc6:	50                   	push   %eax
  801bc7:	51                   	push   %ecx
  801bc8:	52                   	push   %edx
  801bc9:	89 da                	mov    %ebx,%edx
  801bcb:	89 f0                	mov    %esi,%eax
  801bcd:	e8 72 fb ff ff       	call   801744 <printnum>
			break;
  801bd2:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801bd5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801bd8:	83 c7 01             	add    $0x1,%edi
  801bdb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801bdf:	83 f8 25             	cmp    $0x25,%eax
  801be2:	0f 84 62 fc ff ff    	je     80184a <vprintfmt+0x1b>
			if (ch == '\0')
  801be8:	85 c0                	test   %eax,%eax
  801bea:	0f 84 8b 00 00 00    	je     801c7b <vprintfmt+0x44c>
			putch(ch, putdat);
  801bf0:	83 ec 08             	sub    $0x8,%esp
  801bf3:	53                   	push   %ebx
  801bf4:	50                   	push   %eax
  801bf5:	ff d6                	call   *%esi
  801bf7:	83 c4 10             	add    $0x10,%esp
  801bfa:	eb dc                	jmp    801bd8 <vprintfmt+0x3a9>
	if (lflag >= 2)
  801bfc:	83 f9 01             	cmp    $0x1,%ecx
  801bff:	7f 1b                	jg     801c1c <vprintfmt+0x3ed>
	else if (lflag)
  801c01:	85 c9                	test   %ecx,%ecx
  801c03:	74 2c                	je     801c31 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801c05:	8b 45 14             	mov    0x14(%ebp),%eax
  801c08:	8b 10                	mov    (%eax),%edx
  801c0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c0f:	8d 40 04             	lea    0x4(%eax),%eax
  801c12:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c15:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  801c1a:	eb 9f                	jmp    801bbb <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801c1c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1f:	8b 10                	mov    (%eax),%edx
  801c21:	8b 48 04             	mov    0x4(%eax),%ecx
  801c24:	8d 40 08             	lea    0x8(%eax),%eax
  801c27:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c2a:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  801c2f:	eb 8a                	jmp    801bbb <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801c31:	8b 45 14             	mov    0x14(%ebp),%eax
  801c34:	8b 10                	mov    (%eax),%edx
  801c36:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c3b:	8d 40 04             	lea    0x4(%eax),%eax
  801c3e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c41:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  801c46:	e9 70 ff ff ff       	jmp    801bbb <vprintfmt+0x38c>
			putch(ch, putdat);
  801c4b:	83 ec 08             	sub    $0x8,%esp
  801c4e:	53                   	push   %ebx
  801c4f:	6a 25                	push   $0x25
  801c51:	ff d6                	call   *%esi
			break;
  801c53:	83 c4 10             	add    $0x10,%esp
  801c56:	e9 7a ff ff ff       	jmp    801bd5 <vprintfmt+0x3a6>
			putch('%', putdat);
  801c5b:	83 ec 08             	sub    $0x8,%esp
  801c5e:	53                   	push   %ebx
  801c5f:	6a 25                	push   $0x25
  801c61:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801c63:	83 c4 10             	add    $0x10,%esp
  801c66:	89 f8                	mov    %edi,%eax
  801c68:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801c6c:	74 05                	je     801c73 <vprintfmt+0x444>
  801c6e:	83 e8 01             	sub    $0x1,%eax
  801c71:	eb f5                	jmp    801c68 <vprintfmt+0x439>
  801c73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c76:	e9 5a ff ff ff       	jmp    801bd5 <vprintfmt+0x3a6>
}
  801c7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c7e:	5b                   	pop    %ebx
  801c7f:	5e                   	pop    %esi
  801c80:	5f                   	pop    %edi
  801c81:	5d                   	pop    %ebp
  801c82:	c3                   	ret    

00801c83 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801c83:	f3 0f 1e fb          	endbr32 
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	83 ec 18             	sub    $0x18,%esp
  801c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c90:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801c93:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c96:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801c9a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801c9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801ca4:	85 c0                	test   %eax,%eax
  801ca6:	74 26                	je     801cce <vsnprintf+0x4b>
  801ca8:	85 d2                	test   %edx,%edx
  801caa:	7e 22                	jle    801cce <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801cac:	ff 75 14             	pushl  0x14(%ebp)
  801caf:	ff 75 10             	pushl  0x10(%ebp)
  801cb2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801cb5:	50                   	push   %eax
  801cb6:	68 ed 17 80 00       	push   $0x8017ed
  801cbb:	e8 6f fb ff ff       	call   80182f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801cc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cc3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc9:	83 c4 10             	add    $0x10,%esp
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    
		return -E_INVAL;
  801cce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cd3:	eb f7                	jmp    801ccc <vsnprintf+0x49>

00801cd5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801cd5:	f3 0f 1e fb          	endbr32 
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801cdf:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801ce2:	50                   	push   %eax
  801ce3:	ff 75 10             	pushl  0x10(%ebp)
  801ce6:	ff 75 0c             	pushl  0xc(%ebp)
  801ce9:	ff 75 08             	pushl  0x8(%ebp)
  801cec:	e8 92 ff ff ff       	call   801c83 <vsnprintf>
	va_end(ap);

	return rc;
}
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801cf3:	f3 0f 1e fb          	endbr32 
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  801d02:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801d06:	74 05                	je     801d0d <strlen+0x1a>
		n++;
  801d08:	83 c0 01             	add    $0x1,%eax
  801d0b:	eb f5                	jmp    801d02 <strlen+0xf>
	return n;
}
  801d0d:	5d                   	pop    %ebp
  801d0e:	c3                   	ret    

00801d0f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801d0f:	f3 0f 1e fb          	endbr32 
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d19:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d21:	39 d0                	cmp    %edx,%eax
  801d23:	74 0d                	je     801d32 <strnlen+0x23>
  801d25:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801d29:	74 05                	je     801d30 <strnlen+0x21>
		n++;
  801d2b:	83 c0 01             	add    $0x1,%eax
  801d2e:	eb f1                	jmp    801d21 <strnlen+0x12>
  801d30:	89 c2                	mov    %eax,%edx
	return n;
}
  801d32:	89 d0                	mov    %edx,%eax
  801d34:	5d                   	pop    %ebp
  801d35:	c3                   	ret    

00801d36 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801d36:	f3 0f 1e fb          	endbr32 
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	53                   	push   %ebx
  801d3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d41:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801d44:	b8 00 00 00 00       	mov    $0x0,%eax
  801d49:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801d4d:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801d50:	83 c0 01             	add    $0x1,%eax
  801d53:	84 d2                	test   %dl,%dl
  801d55:	75 f2                	jne    801d49 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801d57:	89 c8                	mov    %ecx,%eax
  801d59:	5b                   	pop    %ebx
  801d5a:	5d                   	pop    %ebp
  801d5b:	c3                   	ret    

00801d5c <strcat>:

char *
strcat(char *dst, const char *src)
{
  801d5c:	f3 0f 1e fb          	endbr32 
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	53                   	push   %ebx
  801d64:	83 ec 10             	sub    $0x10,%esp
  801d67:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801d6a:	53                   	push   %ebx
  801d6b:	e8 83 ff ff ff       	call   801cf3 <strlen>
  801d70:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801d73:	ff 75 0c             	pushl  0xc(%ebp)
  801d76:	01 d8                	add    %ebx,%eax
  801d78:	50                   	push   %eax
  801d79:	e8 b8 ff ff ff       	call   801d36 <strcpy>
	return dst;
}
  801d7e:	89 d8                	mov    %ebx,%eax
  801d80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801d85:	f3 0f 1e fb          	endbr32 
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
  801d8c:	56                   	push   %esi
  801d8d:	53                   	push   %ebx
  801d8e:	8b 75 08             	mov    0x8(%ebp),%esi
  801d91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d94:	89 f3                	mov    %esi,%ebx
  801d96:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801d99:	89 f0                	mov    %esi,%eax
  801d9b:	39 d8                	cmp    %ebx,%eax
  801d9d:	74 11                	je     801db0 <strncpy+0x2b>
		*dst++ = *src;
  801d9f:	83 c0 01             	add    $0x1,%eax
  801da2:	0f b6 0a             	movzbl (%edx),%ecx
  801da5:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801da8:	80 f9 01             	cmp    $0x1,%cl
  801dab:	83 da ff             	sbb    $0xffffffff,%edx
  801dae:	eb eb                	jmp    801d9b <strncpy+0x16>
	}
	return ret;
}
  801db0:	89 f0                	mov    %esi,%eax
  801db2:	5b                   	pop    %ebx
  801db3:	5e                   	pop    %esi
  801db4:	5d                   	pop    %ebp
  801db5:	c3                   	ret    

00801db6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801db6:	f3 0f 1e fb          	endbr32 
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	56                   	push   %esi
  801dbe:	53                   	push   %ebx
  801dbf:	8b 75 08             	mov    0x8(%ebp),%esi
  801dc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dc5:	8b 55 10             	mov    0x10(%ebp),%edx
  801dc8:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801dca:	85 d2                	test   %edx,%edx
  801dcc:	74 21                	je     801def <strlcpy+0x39>
  801dce:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801dd2:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801dd4:	39 c2                	cmp    %eax,%edx
  801dd6:	74 14                	je     801dec <strlcpy+0x36>
  801dd8:	0f b6 19             	movzbl (%ecx),%ebx
  801ddb:	84 db                	test   %bl,%bl
  801ddd:	74 0b                	je     801dea <strlcpy+0x34>
			*dst++ = *src++;
  801ddf:	83 c1 01             	add    $0x1,%ecx
  801de2:	83 c2 01             	add    $0x1,%edx
  801de5:	88 5a ff             	mov    %bl,-0x1(%edx)
  801de8:	eb ea                	jmp    801dd4 <strlcpy+0x1e>
  801dea:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801dec:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801def:	29 f0                	sub    %esi,%eax
}
  801df1:	5b                   	pop    %ebx
  801df2:	5e                   	pop    %esi
  801df3:	5d                   	pop    %ebp
  801df4:	c3                   	ret    

00801df5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801df5:	f3 0f 1e fb          	endbr32 
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dff:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801e02:	0f b6 01             	movzbl (%ecx),%eax
  801e05:	84 c0                	test   %al,%al
  801e07:	74 0c                	je     801e15 <strcmp+0x20>
  801e09:	3a 02                	cmp    (%edx),%al
  801e0b:	75 08                	jne    801e15 <strcmp+0x20>
		p++, q++;
  801e0d:	83 c1 01             	add    $0x1,%ecx
  801e10:	83 c2 01             	add    $0x1,%edx
  801e13:	eb ed                	jmp    801e02 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e15:	0f b6 c0             	movzbl %al,%eax
  801e18:	0f b6 12             	movzbl (%edx),%edx
  801e1b:	29 d0                	sub    %edx,%eax
}
  801e1d:	5d                   	pop    %ebp
  801e1e:	c3                   	ret    

00801e1f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801e1f:	f3 0f 1e fb          	endbr32 
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	53                   	push   %ebx
  801e27:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2d:	89 c3                	mov    %eax,%ebx
  801e2f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801e32:	eb 06                	jmp    801e3a <strncmp+0x1b>
		n--, p++, q++;
  801e34:	83 c0 01             	add    $0x1,%eax
  801e37:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801e3a:	39 d8                	cmp    %ebx,%eax
  801e3c:	74 16                	je     801e54 <strncmp+0x35>
  801e3e:	0f b6 08             	movzbl (%eax),%ecx
  801e41:	84 c9                	test   %cl,%cl
  801e43:	74 04                	je     801e49 <strncmp+0x2a>
  801e45:	3a 0a                	cmp    (%edx),%cl
  801e47:	74 eb                	je     801e34 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801e49:	0f b6 00             	movzbl (%eax),%eax
  801e4c:	0f b6 12             	movzbl (%edx),%edx
  801e4f:	29 d0                	sub    %edx,%eax
}
  801e51:	5b                   	pop    %ebx
  801e52:	5d                   	pop    %ebp
  801e53:	c3                   	ret    
		return 0;
  801e54:	b8 00 00 00 00       	mov    $0x0,%eax
  801e59:	eb f6                	jmp    801e51 <strncmp+0x32>

00801e5b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801e5b:	f3 0f 1e fb          	endbr32 
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	8b 45 08             	mov    0x8(%ebp),%eax
  801e65:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e69:	0f b6 10             	movzbl (%eax),%edx
  801e6c:	84 d2                	test   %dl,%dl
  801e6e:	74 09                	je     801e79 <strchr+0x1e>
		if (*s == c)
  801e70:	38 ca                	cmp    %cl,%dl
  801e72:	74 0a                	je     801e7e <strchr+0x23>
	for (; *s; s++)
  801e74:	83 c0 01             	add    $0x1,%eax
  801e77:	eb f0                	jmp    801e69 <strchr+0xe>
			return (char *) s;
	return 0;
  801e79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7e:	5d                   	pop    %ebp
  801e7f:	c3                   	ret    

00801e80 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801e80:	f3 0f 1e fb          	endbr32 
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e8e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801e91:	38 ca                	cmp    %cl,%dl
  801e93:	74 09                	je     801e9e <strfind+0x1e>
  801e95:	84 d2                	test   %dl,%dl
  801e97:	74 05                	je     801e9e <strfind+0x1e>
	for (; *s; s++)
  801e99:	83 c0 01             	add    $0x1,%eax
  801e9c:	eb f0                	jmp    801e8e <strfind+0xe>
			break;
	return (char *) s;
}
  801e9e:	5d                   	pop    %ebp
  801e9f:	c3                   	ret    

00801ea0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801ea0:	f3 0f 1e fb          	endbr32 
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	57                   	push   %edi
  801ea8:	56                   	push   %esi
  801ea9:	53                   	push   %ebx
  801eaa:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ead:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801eb0:	85 c9                	test   %ecx,%ecx
  801eb2:	74 31                	je     801ee5 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801eb4:	89 f8                	mov    %edi,%eax
  801eb6:	09 c8                	or     %ecx,%eax
  801eb8:	a8 03                	test   $0x3,%al
  801eba:	75 23                	jne    801edf <memset+0x3f>
		c &= 0xFF;
  801ebc:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801ec0:	89 d3                	mov    %edx,%ebx
  801ec2:	c1 e3 08             	shl    $0x8,%ebx
  801ec5:	89 d0                	mov    %edx,%eax
  801ec7:	c1 e0 18             	shl    $0x18,%eax
  801eca:	89 d6                	mov    %edx,%esi
  801ecc:	c1 e6 10             	shl    $0x10,%esi
  801ecf:	09 f0                	or     %esi,%eax
  801ed1:	09 c2                	or     %eax,%edx
  801ed3:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801ed5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801ed8:	89 d0                	mov    %edx,%eax
  801eda:	fc                   	cld    
  801edb:	f3 ab                	rep stos %eax,%es:(%edi)
  801edd:	eb 06                	jmp    801ee5 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee2:	fc                   	cld    
  801ee3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801ee5:	89 f8                	mov    %edi,%eax
  801ee7:	5b                   	pop    %ebx
  801ee8:	5e                   	pop    %esi
  801ee9:	5f                   	pop    %edi
  801eea:	5d                   	pop    %ebp
  801eeb:	c3                   	ret    

00801eec <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801eec:	f3 0f 1e fb          	endbr32 
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	57                   	push   %edi
  801ef4:	56                   	push   %esi
  801ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef8:	8b 75 0c             	mov    0xc(%ebp),%esi
  801efb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801efe:	39 c6                	cmp    %eax,%esi
  801f00:	73 32                	jae    801f34 <memmove+0x48>
  801f02:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801f05:	39 c2                	cmp    %eax,%edx
  801f07:	76 2b                	jbe    801f34 <memmove+0x48>
		s += n;
		d += n;
  801f09:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801f0c:	89 fe                	mov    %edi,%esi
  801f0e:	09 ce                	or     %ecx,%esi
  801f10:	09 d6                	or     %edx,%esi
  801f12:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801f18:	75 0e                	jne    801f28 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801f1a:	83 ef 04             	sub    $0x4,%edi
  801f1d:	8d 72 fc             	lea    -0x4(%edx),%esi
  801f20:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801f23:	fd                   	std    
  801f24:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801f26:	eb 09                	jmp    801f31 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801f28:	83 ef 01             	sub    $0x1,%edi
  801f2b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801f2e:	fd                   	std    
  801f2f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801f31:	fc                   	cld    
  801f32:	eb 1a                	jmp    801f4e <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801f34:	89 c2                	mov    %eax,%edx
  801f36:	09 ca                	or     %ecx,%edx
  801f38:	09 f2                	or     %esi,%edx
  801f3a:	f6 c2 03             	test   $0x3,%dl
  801f3d:	75 0a                	jne    801f49 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801f3f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801f42:	89 c7                	mov    %eax,%edi
  801f44:	fc                   	cld    
  801f45:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801f47:	eb 05                	jmp    801f4e <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801f49:	89 c7                	mov    %eax,%edi
  801f4b:	fc                   	cld    
  801f4c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801f4e:	5e                   	pop    %esi
  801f4f:	5f                   	pop    %edi
  801f50:	5d                   	pop    %ebp
  801f51:	c3                   	ret    

00801f52 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801f52:	f3 0f 1e fb          	endbr32 
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801f5c:	ff 75 10             	pushl  0x10(%ebp)
  801f5f:	ff 75 0c             	pushl  0xc(%ebp)
  801f62:	ff 75 08             	pushl  0x8(%ebp)
  801f65:	e8 82 ff ff ff       	call   801eec <memmove>
}
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801f6c:	f3 0f 1e fb          	endbr32 
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	56                   	push   %esi
  801f74:	53                   	push   %ebx
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7b:	89 c6                	mov    %eax,%esi
  801f7d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801f80:	39 f0                	cmp    %esi,%eax
  801f82:	74 1c                	je     801fa0 <memcmp+0x34>
		if (*s1 != *s2)
  801f84:	0f b6 08             	movzbl (%eax),%ecx
  801f87:	0f b6 1a             	movzbl (%edx),%ebx
  801f8a:	38 d9                	cmp    %bl,%cl
  801f8c:	75 08                	jne    801f96 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801f8e:	83 c0 01             	add    $0x1,%eax
  801f91:	83 c2 01             	add    $0x1,%edx
  801f94:	eb ea                	jmp    801f80 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801f96:	0f b6 c1             	movzbl %cl,%eax
  801f99:	0f b6 db             	movzbl %bl,%ebx
  801f9c:	29 d8                	sub    %ebx,%eax
  801f9e:	eb 05                	jmp    801fa5 <memcmp+0x39>
	}

	return 0;
  801fa0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa5:	5b                   	pop    %ebx
  801fa6:	5e                   	pop    %esi
  801fa7:	5d                   	pop    %ebp
  801fa8:	c3                   	ret    

00801fa9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801fa9:	f3 0f 1e fb          	endbr32 
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801fb6:	89 c2                	mov    %eax,%edx
  801fb8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801fbb:	39 d0                	cmp    %edx,%eax
  801fbd:	73 09                	jae    801fc8 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801fbf:	38 08                	cmp    %cl,(%eax)
  801fc1:	74 05                	je     801fc8 <memfind+0x1f>
	for (; s < ends; s++)
  801fc3:	83 c0 01             	add    $0x1,%eax
  801fc6:	eb f3                	jmp    801fbb <memfind+0x12>
			break;
	return (void *) s;
}
  801fc8:	5d                   	pop    %ebp
  801fc9:	c3                   	ret    

00801fca <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801fca:	f3 0f 1e fb          	endbr32 
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	57                   	push   %edi
  801fd2:	56                   	push   %esi
  801fd3:	53                   	push   %ebx
  801fd4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801fda:	eb 03                	jmp    801fdf <strtol+0x15>
		s++;
  801fdc:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801fdf:	0f b6 01             	movzbl (%ecx),%eax
  801fe2:	3c 20                	cmp    $0x20,%al
  801fe4:	74 f6                	je     801fdc <strtol+0x12>
  801fe6:	3c 09                	cmp    $0x9,%al
  801fe8:	74 f2                	je     801fdc <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801fea:	3c 2b                	cmp    $0x2b,%al
  801fec:	74 2a                	je     802018 <strtol+0x4e>
	int neg = 0;
  801fee:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801ff3:	3c 2d                	cmp    $0x2d,%al
  801ff5:	74 2b                	je     802022 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ff7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801ffd:	75 0f                	jne    80200e <strtol+0x44>
  801fff:	80 39 30             	cmpb   $0x30,(%ecx)
  802002:	74 28                	je     80202c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  802004:	85 db                	test   %ebx,%ebx
  802006:	b8 0a 00 00 00       	mov    $0xa,%eax
  80200b:	0f 44 d8             	cmove  %eax,%ebx
  80200e:	b8 00 00 00 00       	mov    $0x0,%eax
  802013:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802016:	eb 46                	jmp    80205e <strtol+0x94>
		s++;
  802018:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80201b:	bf 00 00 00 00       	mov    $0x0,%edi
  802020:	eb d5                	jmp    801ff7 <strtol+0x2d>
		s++, neg = 1;
  802022:	83 c1 01             	add    $0x1,%ecx
  802025:	bf 01 00 00 00       	mov    $0x1,%edi
  80202a:	eb cb                	jmp    801ff7 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80202c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  802030:	74 0e                	je     802040 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  802032:	85 db                	test   %ebx,%ebx
  802034:	75 d8                	jne    80200e <strtol+0x44>
		s++, base = 8;
  802036:	83 c1 01             	add    $0x1,%ecx
  802039:	bb 08 00 00 00       	mov    $0x8,%ebx
  80203e:	eb ce                	jmp    80200e <strtol+0x44>
		s += 2, base = 16;
  802040:	83 c1 02             	add    $0x2,%ecx
  802043:	bb 10 00 00 00       	mov    $0x10,%ebx
  802048:	eb c4                	jmp    80200e <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  80204a:	0f be d2             	movsbl %dl,%edx
  80204d:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  802050:	3b 55 10             	cmp    0x10(%ebp),%edx
  802053:	7d 3a                	jge    80208f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  802055:	83 c1 01             	add    $0x1,%ecx
  802058:	0f af 45 10          	imul   0x10(%ebp),%eax
  80205c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80205e:	0f b6 11             	movzbl (%ecx),%edx
  802061:	8d 72 d0             	lea    -0x30(%edx),%esi
  802064:	89 f3                	mov    %esi,%ebx
  802066:	80 fb 09             	cmp    $0x9,%bl
  802069:	76 df                	jbe    80204a <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  80206b:	8d 72 9f             	lea    -0x61(%edx),%esi
  80206e:	89 f3                	mov    %esi,%ebx
  802070:	80 fb 19             	cmp    $0x19,%bl
  802073:	77 08                	ja     80207d <strtol+0xb3>
			dig = *s - 'a' + 10;
  802075:	0f be d2             	movsbl %dl,%edx
  802078:	83 ea 57             	sub    $0x57,%edx
  80207b:	eb d3                	jmp    802050 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  80207d:	8d 72 bf             	lea    -0x41(%edx),%esi
  802080:	89 f3                	mov    %esi,%ebx
  802082:	80 fb 19             	cmp    $0x19,%bl
  802085:	77 08                	ja     80208f <strtol+0xc5>
			dig = *s - 'A' + 10;
  802087:	0f be d2             	movsbl %dl,%edx
  80208a:	83 ea 37             	sub    $0x37,%edx
  80208d:	eb c1                	jmp    802050 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  80208f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802093:	74 05                	je     80209a <strtol+0xd0>
		*endptr = (char *) s;
  802095:	8b 75 0c             	mov    0xc(%ebp),%esi
  802098:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80209a:	89 c2                	mov    %eax,%edx
  80209c:	f7 da                	neg    %edx
  80209e:	85 ff                	test   %edi,%edi
  8020a0:	0f 45 c2             	cmovne %edx,%eax
}
  8020a3:	5b                   	pop    %ebx
  8020a4:	5e                   	pop    %esi
  8020a5:	5f                   	pop    %edi
  8020a6:	5d                   	pop    %ebp
  8020a7:	c3                   	ret    

008020a8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020a8:	f3 0f 1e fb          	endbr32 
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
  8020af:	56                   	push   %esi
  8020b0:	53                   	push   %ebx
  8020b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8020b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8020ba:	85 c0                	test   %eax,%eax
  8020bc:	74 3d                	je     8020fb <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8020be:	83 ec 0c             	sub    $0xc,%esp
  8020c1:	50                   	push   %eax
  8020c2:	e8 88 e2 ff ff       	call   80034f <sys_ipc_recv>
  8020c7:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8020ca:	85 f6                	test   %esi,%esi
  8020cc:	74 0b                	je     8020d9 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8020ce:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020d4:	8b 52 74             	mov    0x74(%edx),%edx
  8020d7:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8020d9:	85 db                	test   %ebx,%ebx
  8020db:	74 0b                	je     8020e8 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8020dd:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020e3:	8b 52 78             	mov    0x78(%edx),%edx
  8020e6:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8020e8:	85 c0                	test   %eax,%eax
  8020ea:	78 21                	js     80210d <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8020ec:	a1 08 40 80 00       	mov    0x804008,%eax
  8020f1:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020f7:	5b                   	pop    %ebx
  8020f8:	5e                   	pop    %esi
  8020f9:	5d                   	pop    %ebp
  8020fa:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8020fb:	83 ec 0c             	sub    $0xc,%esp
  8020fe:	68 00 00 c0 ee       	push   $0xeec00000
  802103:	e8 47 e2 ff ff       	call   80034f <sys_ipc_recv>
  802108:	83 c4 10             	add    $0x10,%esp
  80210b:	eb bd                	jmp    8020ca <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  80210d:	85 f6                	test   %esi,%esi
  80210f:	74 10                	je     802121 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802111:	85 db                	test   %ebx,%ebx
  802113:	75 df                	jne    8020f4 <ipc_recv+0x4c>
  802115:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80211c:	00 00 00 
  80211f:	eb d3                	jmp    8020f4 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802121:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802128:	00 00 00 
  80212b:	eb e4                	jmp    802111 <ipc_recv+0x69>

0080212d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80212d:	f3 0f 1e fb          	endbr32 
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
  802134:	57                   	push   %edi
  802135:	56                   	push   %esi
  802136:	53                   	push   %ebx
  802137:	83 ec 0c             	sub    $0xc,%esp
  80213a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80213d:	8b 75 0c             	mov    0xc(%ebp),%esi
  802140:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802143:	85 db                	test   %ebx,%ebx
  802145:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80214a:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  80214d:	ff 75 14             	pushl  0x14(%ebp)
  802150:	53                   	push   %ebx
  802151:	56                   	push   %esi
  802152:	57                   	push   %edi
  802153:	e8 d0 e1 ff ff       	call   800328 <sys_ipc_try_send>
  802158:	83 c4 10             	add    $0x10,%esp
  80215b:	85 c0                	test   %eax,%eax
  80215d:	79 1e                	jns    80217d <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  80215f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802162:	75 07                	jne    80216b <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802164:	e8 f7 df ff ff       	call   800160 <sys_yield>
  802169:	eb e2                	jmp    80214d <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  80216b:	50                   	push   %eax
  80216c:	68 ff 28 80 00       	push   $0x8028ff
  802171:	6a 59                	push   $0x59
  802173:	68 1a 29 80 00       	push   $0x80291a
  802178:	e8 c8 f4 ff ff       	call   801645 <_panic>
	}
}
  80217d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802180:	5b                   	pop    %ebx
  802181:	5e                   	pop    %esi
  802182:	5f                   	pop    %edi
  802183:	5d                   	pop    %ebp
  802184:	c3                   	ret    

00802185 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802185:	f3 0f 1e fb          	endbr32 
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80218f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802194:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802197:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80219d:	8b 52 50             	mov    0x50(%edx),%edx
  8021a0:	39 ca                	cmp    %ecx,%edx
  8021a2:	74 11                	je     8021b5 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8021a4:	83 c0 01             	add    $0x1,%eax
  8021a7:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021ac:	75 e6                	jne    802194 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8021ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b3:	eb 0b                	jmp    8021c0 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8021b5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021b8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021bd:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021c0:	5d                   	pop    %ebp
  8021c1:	c3                   	ret    

008021c2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021c2:	f3 0f 1e fb          	endbr32 
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021cc:	89 c2                	mov    %eax,%edx
  8021ce:	c1 ea 16             	shr    $0x16,%edx
  8021d1:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8021d8:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021dd:	f6 c1 01             	test   $0x1,%cl
  8021e0:	74 1c                	je     8021fe <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8021e2:	c1 e8 0c             	shr    $0xc,%eax
  8021e5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8021ec:	a8 01                	test   $0x1,%al
  8021ee:	74 0e                	je     8021fe <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021f0:	c1 e8 0c             	shr    $0xc,%eax
  8021f3:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8021fa:	ef 
  8021fb:	0f b7 d2             	movzwl %dx,%edx
}
  8021fe:	89 d0                	mov    %edx,%eax
  802200:	5d                   	pop    %ebp
  802201:	c3                   	ret    
  802202:	66 90                	xchg   %ax,%ax
  802204:	66 90                	xchg   %ax,%ax
  802206:	66 90                	xchg   %ax,%ax
  802208:	66 90                	xchg   %ax,%ax
  80220a:	66 90                	xchg   %ax,%ax
  80220c:	66 90                	xchg   %ax,%ax
  80220e:	66 90                	xchg   %ax,%ax

00802210 <__udivdi3>:
  802210:	f3 0f 1e fb          	endbr32 
  802214:	55                   	push   %ebp
  802215:	57                   	push   %edi
  802216:	56                   	push   %esi
  802217:	53                   	push   %ebx
  802218:	83 ec 1c             	sub    $0x1c,%esp
  80221b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80221f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802223:	8b 74 24 34          	mov    0x34(%esp),%esi
  802227:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80222b:	85 d2                	test   %edx,%edx
  80222d:	75 19                	jne    802248 <__udivdi3+0x38>
  80222f:	39 f3                	cmp    %esi,%ebx
  802231:	76 4d                	jbe    802280 <__udivdi3+0x70>
  802233:	31 ff                	xor    %edi,%edi
  802235:	89 e8                	mov    %ebp,%eax
  802237:	89 f2                	mov    %esi,%edx
  802239:	f7 f3                	div    %ebx
  80223b:	89 fa                	mov    %edi,%edx
  80223d:	83 c4 1c             	add    $0x1c,%esp
  802240:	5b                   	pop    %ebx
  802241:	5e                   	pop    %esi
  802242:	5f                   	pop    %edi
  802243:	5d                   	pop    %ebp
  802244:	c3                   	ret    
  802245:	8d 76 00             	lea    0x0(%esi),%esi
  802248:	39 f2                	cmp    %esi,%edx
  80224a:	76 14                	jbe    802260 <__udivdi3+0x50>
  80224c:	31 ff                	xor    %edi,%edi
  80224e:	31 c0                	xor    %eax,%eax
  802250:	89 fa                	mov    %edi,%edx
  802252:	83 c4 1c             	add    $0x1c,%esp
  802255:	5b                   	pop    %ebx
  802256:	5e                   	pop    %esi
  802257:	5f                   	pop    %edi
  802258:	5d                   	pop    %ebp
  802259:	c3                   	ret    
  80225a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802260:	0f bd fa             	bsr    %edx,%edi
  802263:	83 f7 1f             	xor    $0x1f,%edi
  802266:	75 48                	jne    8022b0 <__udivdi3+0xa0>
  802268:	39 f2                	cmp    %esi,%edx
  80226a:	72 06                	jb     802272 <__udivdi3+0x62>
  80226c:	31 c0                	xor    %eax,%eax
  80226e:	39 eb                	cmp    %ebp,%ebx
  802270:	77 de                	ja     802250 <__udivdi3+0x40>
  802272:	b8 01 00 00 00       	mov    $0x1,%eax
  802277:	eb d7                	jmp    802250 <__udivdi3+0x40>
  802279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802280:	89 d9                	mov    %ebx,%ecx
  802282:	85 db                	test   %ebx,%ebx
  802284:	75 0b                	jne    802291 <__udivdi3+0x81>
  802286:	b8 01 00 00 00       	mov    $0x1,%eax
  80228b:	31 d2                	xor    %edx,%edx
  80228d:	f7 f3                	div    %ebx
  80228f:	89 c1                	mov    %eax,%ecx
  802291:	31 d2                	xor    %edx,%edx
  802293:	89 f0                	mov    %esi,%eax
  802295:	f7 f1                	div    %ecx
  802297:	89 c6                	mov    %eax,%esi
  802299:	89 e8                	mov    %ebp,%eax
  80229b:	89 f7                	mov    %esi,%edi
  80229d:	f7 f1                	div    %ecx
  80229f:	89 fa                	mov    %edi,%edx
  8022a1:	83 c4 1c             	add    $0x1c,%esp
  8022a4:	5b                   	pop    %ebx
  8022a5:	5e                   	pop    %esi
  8022a6:	5f                   	pop    %edi
  8022a7:	5d                   	pop    %ebp
  8022a8:	c3                   	ret    
  8022a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022b0:	89 f9                	mov    %edi,%ecx
  8022b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022b7:	29 f8                	sub    %edi,%eax
  8022b9:	d3 e2                	shl    %cl,%edx
  8022bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022bf:	89 c1                	mov    %eax,%ecx
  8022c1:	89 da                	mov    %ebx,%edx
  8022c3:	d3 ea                	shr    %cl,%edx
  8022c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022c9:	09 d1                	or     %edx,%ecx
  8022cb:	89 f2                	mov    %esi,%edx
  8022cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022d1:	89 f9                	mov    %edi,%ecx
  8022d3:	d3 e3                	shl    %cl,%ebx
  8022d5:	89 c1                	mov    %eax,%ecx
  8022d7:	d3 ea                	shr    %cl,%edx
  8022d9:	89 f9                	mov    %edi,%ecx
  8022db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022df:	89 eb                	mov    %ebp,%ebx
  8022e1:	d3 e6                	shl    %cl,%esi
  8022e3:	89 c1                	mov    %eax,%ecx
  8022e5:	d3 eb                	shr    %cl,%ebx
  8022e7:	09 de                	or     %ebx,%esi
  8022e9:	89 f0                	mov    %esi,%eax
  8022eb:	f7 74 24 08          	divl   0x8(%esp)
  8022ef:	89 d6                	mov    %edx,%esi
  8022f1:	89 c3                	mov    %eax,%ebx
  8022f3:	f7 64 24 0c          	mull   0xc(%esp)
  8022f7:	39 d6                	cmp    %edx,%esi
  8022f9:	72 15                	jb     802310 <__udivdi3+0x100>
  8022fb:	89 f9                	mov    %edi,%ecx
  8022fd:	d3 e5                	shl    %cl,%ebp
  8022ff:	39 c5                	cmp    %eax,%ebp
  802301:	73 04                	jae    802307 <__udivdi3+0xf7>
  802303:	39 d6                	cmp    %edx,%esi
  802305:	74 09                	je     802310 <__udivdi3+0x100>
  802307:	89 d8                	mov    %ebx,%eax
  802309:	31 ff                	xor    %edi,%edi
  80230b:	e9 40 ff ff ff       	jmp    802250 <__udivdi3+0x40>
  802310:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802313:	31 ff                	xor    %edi,%edi
  802315:	e9 36 ff ff ff       	jmp    802250 <__udivdi3+0x40>
  80231a:	66 90                	xchg   %ax,%ax
  80231c:	66 90                	xchg   %ax,%ax
  80231e:	66 90                	xchg   %ax,%ax

00802320 <__umoddi3>:
  802320:	f3 0f 1e fb          	endbr32 
  802324:	55                   	push   %ebp
  802325:	57                   	push   %edi
  802326:	56                   	push   %esi
  802327:	53                   	push   %ebx
  802328:	83 ec 1c             	sub    $0x1c,%esp
  80232b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80232f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802333:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802337:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80233b:	85 c0                	test   %eax,%eax
  80233d:	75 19                	jne    802358 <__umoddi3+0x38>
  80233f:	39 df                	cmp    %ebx,%edi
  802341:	76 5d                	jbe    8023a0 <__umoddi3+0x80>
  802343:	89 f0                	mov    %esi,%eax
  802345:	89 da                	mov    %ebx,%edx
  802347:	f7 f7                	div    %edi
  802349:	89 d0                	mov    %edx,%eax
  80234b:	31 d2                	xor    %edx,%edx
  80234d:	83 c4 1c             	add    $0x1c,%esp
  802350:	5b                   	pop    %ebx
  802351:	5e                   	pop    %esi
  802352:	5f                   	pop    %edi
  802353:	5d                   	pop    %ebp
  802354:	c3                   	ret    
  802355:	8d 76 00             	lea    0x0(%esi),%esi
  802358:	89 f2                	mov    %esi,%edx
  80235a:	39 d8                	cmp    %ebx,%eax
  80235c:	76 12                	jbe    802370 <__umoddi3+0x50>
  80235e:	89 f0                	mov    %esi,%eax
  802360:	89 da                	mov    %ebx,%edx
  802362:	83 c4 1c             	add    $0x1c,%esp
  802365:	5b                   	pop    %ebx
  802366:	5e                   	pop    %esi
  802367:	5f                   	pop    %edi
  802368:	5d                   	pop    %ebp
  802369:	c3                   	ret    
  80236a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802370:	0f bd e8             	bsr    %eax,%ebp
  802373:	83 f5 1f             	xor    $0x1f,%ebp
  802376:	75 50                	jne    8023c8 <__umoddi3+0xa8>
  802378:	39 d8                	cmp    %ebx,%eax
  80237a:	0f 82 e0 00 00 00    	jb     802460 <__umoddi3+0x140>
  802380:	89 d9                	mov    %ebx,%ecx
  802382:	39 f7                	cmp    %esi,%edi
  802384:	0f 86 d6 00 00 00    	jbe    802460 <__umoddi3+0x140>
  80238a:	89 d0                	mov    %edx,%eax
  80238c:	89 ca                	mov    %ecx,%edx
  80238e:	83 c4 1c             	add    $0x1c,%esp
  802391:	5b                   	pop    %ebx
  802392:	5e                   	pop    %esi
  802393:	5f                   	pop    %edi
  802394:	5d                   	pop    %ebp
  802395:	c3                   	ret    
  802396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80239d:	8d 76 00             	lea    0x0(%esi),%esi
  8023a0:	89 fd                	mov    %edi,%ebp
  8023a2:	85 ff                	test   %edi,%edi
  8023a4:	75 0b                	jne    8023b1 <__umoddi3+0x91>
  8023a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ab:	31 d2                	xor    %edx,%edx
  8023ad:	f7 f7                	div    %edi
  8023af:	89 c5                	mov    %eax,%ebp
  8023b1:	89 d8                	mov    %ebx,%eax
  8023b3:	31 d2                	xor    %edx,%edx
  8023b5:	f7 f5                	div    %ebp
  8023b7:	89 f0                	mov    %esi,%eax
  8023b9:	f7 f5                	div    %ebp
  8023bb:	89 d0                	mov    %edx,%eax
  8023bd:	31 d2                	xor    %edx,%edx
  8023bf:	eb 8c                	jmp    80234d <__umoddi3+0x2d>
  8023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023c8:	89 e9                	mov    %ebp,%ecx
  8023ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8023cf:	29 ea                	sub    %ebp,%edx
  8023d1:	d3 e0                	shl    %cl,%eax
  8023d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023d7:	89 d1                	mov    %edx,%ecx
  8023d9:	89 f8                	mov    %edi,%eax
  8023db:	d3 e8                	shr    %cl,%eax
  8023dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023e9:	09 c1                	or     %eax,%ecx
  8023eb:	89 d8                	mov    %ebx,%eax
  8023ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023f1:	89 e9                	mov    %ebp,%ecx
  8023f3:	d3 e7                	shl    %cl,%edi
  8023f5:	89 d1                	mov    %edx,%ecx
  8023f7:	d3 e8                	shr    %cl,%eax
  8023f9:	89 e9                	mov    %ebp,%ecx
  8023fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023ff:	d3 e3                	shl    %cl,%ebx
  802401:	89 c7                	mov    %eax,%edi
  802403:	89 d1                	mov    %edx,%ecx
  802405:	89 f0                	mov    %esi,%eax
  802407:	d3 e8                	shr    %cl,%eax
  802409:	89 e9                	mov    %ebp,%ecx
  80240b:	89 fa                	mov    %edi,%edx
  80240d:	d3 e6                	shl    %cl,%esi
  80240f:	09 d8                	or     %ebx,%eax
  802411:	f7 74 24 08          	divl   0x8(%esp)
  802415:	89 d1                	mov    %edx,%ecx
  802417:	89 f3                	mov    %esi,%ebx
  802419:	f7 64 24 0c          	mull   0xc(%esp)
  80241d:	89 c6                	mov    %eax,%esi
  80241f:	89 d7                	mov    %edx,%edi
  802421:	39 d1                	cmp    %edx,%ecx
  802423:	72 06                	jb     80242b <__umoddi3+0x10b>
  802425:	75 10                	jne    802437 <__umoddi3+0x117>
  802427:	39 c3                	cmp    %eax,%ebx
  802429:	73 0c                	jae    802437 <__umoddi3+0x117>
  80242b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80242f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802433:	89 d7                	mov    %edx,%edi
  802435:	89 c6                	mov    %eax,%esi
  802437:	89 ca                	mov    %ecx,%edx
  802439:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80243e:	29 f3                	sub    %esi,%ebx
  802440:	19 fa                	sbb    %edi,%edx
  802442:	89 d0                	mov    %edx,%eax
  802444:	d3 e0                	shl    %cl,%eax
  802446:	89 e9                	mov    %ebp,%ecx
  802448:	d3 eb                	shr    %cl,%ebx
  80244a:	d3 ea                	shr    %cl,%edx
  80244c:	09 d8                	or     %ebx,%eax
  80244e:	83 c4 1c             	add    $0x1c,%esp
  802451:	5b                   	pop    %ebx
  802452:	5e                   	pop    %esi
  802453:	5f                   	pop    %edi
  802454:	5d                   	pop    %ebp
  802455:	c3                   	ret    
  802456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80245d:	8d 76 00             	lea    0x0(%esi),%esi
  802460:	29 fe                	sub    %edi,%esi
  802462:	19 c3                	sbb    %eax,%ebx
  802464:	89 f2                	mov    %esi,%edx
  802466:	89 d9                	mov    %ebx,%ecx
  802468:	e9 1d ff ff ff       	jmp    80238a <__umoddi3+0x6a>
