
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
  80006c:	a3 04 40 80 00       	mov    %eax,0x804004

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
  80009f:	e8 df 04 00 00       	call   800583 <close_all>
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
  80012c:	68 0a 1f 80 00       	push   $0x801f0a
  800131:	6a 23                	push   $0x23
  800133:	68 27 1f 80 00       	push   $0x801f27
  800138:	e8 9c 0f 00 00       	call   8010d9 <_panic>

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
  8001b9:	68 0a 1f 80 00       	push   $0x801f0a
  8001be:	6a 23                	push   $0x23
  8001c0:	68 27 1f 80 00       	push   $0x801f27
  8001c5:	e8 0f 0f 00 00       	call   8010d9 <_panic>

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
  8001ff:	68 0a 1f 80 00       	push   $0x801f0a
  800204:	6a 23                	push   $0x23
  800206:	68 27 1f 80 00       	push   $0x801f27
  80020b:	e8 c9 0e 00 00       	call   8010d9 <_panic>

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
  800245:	68 0a 1f 80 00       	push   $0x801f0a
  80024a:	6a 23                	push   $0x23
  80024c:	68 27 1f 80 00       	push   $0x801f27
  800251:	e8 83 0e 00 00       	call   8010d9 <_panic>

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
  80028b:	68 0a 1f 80 00       	push   $0x801f0a
  800290:	6a 23                	push   $0x23
  800292:	68 27 1f 80 00       	push   $0x801f27
  800297:	e8 3d 0e 00 00       	call   8010d9 <_panic>

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
  8002d1:	68 0a 1f 80 00       	push   $0x801f0a
  8002d6:	6a 23                	push   $0x23
  8002d8:	68 27 1f 80 00       	push   $0x801f27
  8002dd:	e8 f7 0d 00 00       	call   8010d9 <_panic>

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
  800317:	68 0a 1f 80 00       	push   $0x801f0a
  80031c:	6a 23                	push   $0x23
  80031e:	68 27 1f 80 00       	push   $0x801f27
  800323:	e8 b1 0d 00 00       	call   8010d9 <_panic>

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
  800383:	68 0a 1f 80 00       	push   $0x801f0a
  800388:	6a 23                	push   $0x23
  80038a:	68 27 1f 80 00       	push   $0x801f27
  80038f:	e8 45 0d 00 00       	call   8010d9 <_panic>

00800394 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800394:	f3 0f 1e fb          	endbr32 
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80039b:	8b 45 08             	mov    0x8(%ebp),%eax
  80039e:	05 00 00 00 30       	add    $0x30000000,%eax
  8003a3:	c1 e8 0c             	shr    $0xc,%eax
}
  8003a6:	5d                   	pop    %ebp
  8003a7:	c3                   	ret    

008003a8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8003a8:	f3 0f 1e fb          	endbr32 
  8003ac:	55                   	push   %ebp
  8003ad:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003af:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003bc:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003c1:	5d                   	pop    %ebp
  8003c2:	c3                   	ret    

008003c3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003c3:	f3 0f 1e fb          	endbr32 
  8003c7:	55                   	push   %ebp
  8003c8:	89 e5                	mov    %esp,%ebp
  8003ca:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003cf:	89 c2                	mov    %eax,%edx
  8003d1:	c1 ea 16             	shr    $0x16,%edx
  8003d4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003db:	f6 c2 01             	test   $0x1,%dl
  8003de:	74 2d                	je     80040d <fd_alloc+0x4a>
  8003e0:	89 c2                	mov    %eax,%edx
  8003e2:	c1 ea 0c             	shr    $0xc,%edx
  8003e5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003ec:	f6 c2 01             	test   $0x1,%dl
  8003ef:	74 1c                	je     80040d <fd_alloc+0x4a>
  8003f1:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003f6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003fb:	75 d2                	jne    8003cf <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800400:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800406:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80040b:	eb 0a                	jmp    800417 <fd_alloc+0x54>
			*fd_store = fd;
  80040d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800410:	89 01                	mov    %eax,(%ecx)
			return 0;
  800412:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800417:	5d                   	pop    %ebp
  800418:	c3                   	ret    

00800419 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800419:	f3 0f 1e fb          	endbr32 
  80041d:	55                   	push   %ebp
  80041e:	89 e5                	mov    %esp,%ebp
  800420:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800423:	83 f8 1f             	cmp    $0x1f,%eax
  800426:	77 30                	ja     800458 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800428:	c1 e0 0c             	shl    $0xc,%eax
  80042b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800430:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800436:	f6 c2 01             	test   $0x1,%dl
  800439:	74 24                	je     80045f <fd_lookup+0x46>
  80043b:	89 c2                	mov    %eax,%edx
  80043d:	c1 ea 0c             	shr    $0xc,%edx
  800440:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800447:	f6 c2 01             	test   $0x1,%dl
  80044a:	74 1a                	je     800466 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80044c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80044f:	89 02                	mov    %eax,(%edx)
	return 0;
  800451:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800456:	5d                   	pop    %ebp
  800457:	c3                   	ret    
		return -E_INVAL;
  800458:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80045d:	eb f7                	jmp    800456 <fd_lookup+0x3d>
		return -E_INVAL;
  80045f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800464:	eb f0                	jmp    800456 <fd_lookup+0x3d>
  800466:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80046b:	eb e9                	jmp    800456 <fd_lookup+0x3d>

0080046d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80046d:	f3 0f 1e fb          	endbr32 
  800471:	55                   	push   %ebp
  800472:	89 e5                	mov    %esp,%ebp
  800474:	83 ec 08             	sub    $0x8,%esp
  800477:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80047a:	ba b4 1f 80 00       	mov    $0x801fb4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80047f:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800484:	39 08                	cmp    %ecx,(%eax)
  800486:	74 33                	je     8004bb <dev_lookup+0x4e>
  800488:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80048b:	8b 02                	mov    (%edx),%eax
  80048d:	85 c0                	test   %eax,%eax
  80048f:	75 f3                	jne    800484 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800491:	a1 04 40 80 00       	mov    0x804004,%eax
  800496:	8b 40 48             	mov    0x48(%eax),%eax
  800499:	83 ec 04             	sub    $0x4,%esp
  80049c:	51                   	push   %ecx
  80049d:	50                   	push   %eax
  80049e:	68 38 1f 80 00       	push   $0x801f38
  8004a3:	e8 18 0d 00 00       	call   8011c0 <cprintf>
	*dev = 0;
  8004a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004b1:	83 c4 10             	add    $0x10,%esp
  8004b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004b9:	c9                   	leave  
  8004ba:	c3                   	ret    
			*dev = devtab[i];
  8004bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004be:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c5:	eb f2                	jmp    8004b9 <dev_lookup+0x4c>

008004c7 <fd_close>:
{
  8004c7:	f3 0f 1e fb          	endbr32 
  8004cb:	55                   	push   %ebp
  8004cc:	89 e5                	mov    %esp,%ebp
  8004ce:	57                   	push   %edi
  8004cf:	56                   	push   %esi
  8004d0:	53                   	push   %ebx
  8004d1:	83 ec 24             	sub    $0x24,%esp
  8004d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d7:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004da:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004dd:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004de:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004e4:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004e7:	50                   	push   %eax
  8004e8:	e8 2c ff ff ff       	call   800419 <fd_lookup>
  8004ed:	89 c3                	mov    %eax,%ebx
  8004ef:	83 c4 10             	add    $0x10,%esp
  8004f2:	85 c0                	test   %eax,%eax
  8004f4:	78 05                	js     8004fb <fd_close+0x34>
	    || fd != fd2)
  8004f6:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004f9:	74 16                	je     800511 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8004fb:	89 f8                	mov    %edi,%eax
  8004fd:	84 c0                	test   %al,%al
  8004ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800504:	0f 44 d8             	cmove  %eax,%ebx
}
  800507:	89 d8                	mov    %ebx,%eax
  800509:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80050c:	5b                   	pop    %ebx
  80050d:	5e                   	pop    %esi
  80050e:	5f                   	pop    %edi
  80050f:	5d                   	pop    %ebp
  800510:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800511:	83 ec 08             	sub    $0x8,%esp
  800514:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800517:	50                   	push   %eax
  800518:	ff 36                	pushl  (%esi)
  80051a:	e8 4e ff ff ff       	call   80046d <dev_lookup>
  80051f:	89 c3                	mov    %eax,%ebx
  800521:	83 c4 10             	add    $0x10,%esp
  800524:	85 c0                	test   %eax,%eax
  800526:	78 1a                	js     800542 <fd_close+0x7b>
		if (dev->dev_close)
  800528:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80052b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80052e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800533:	85 c0                	test   %eax,%eax
  800535:	74 0b                	je     800542 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800537:	83 ec 0c             	sub    $0xc,%esp
  80053a:	56                   	push   %esi
  80053b:	ff d0                	call   *%eax
  80053d:	89 c3                	mov    %eax,%ebx
  80053f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	56                   	push   %esi
  800546:	6a 00                	push   $0x0
  800548:	e8 c3 fc ff ff       	call   800210 <sys_page_unmap>
	return r;
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	eb b5                	jmp    800507 <fd_close+0x40>

00800552 <close>:

int
close(int fdnum)
{
  800552:	f3 0f 1e fb          	endbr32 
  800556:	55                   	push   %ebp
  800557:	89 e5                	mov    %esp,%ebp
  800559:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80055c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80055f:	50                   	push   %eax
  800560:	ff 75 08             	pushl  0x8(%ebp)
  800563:	e8 b1 fe ff ff       	call   800419 <fd_lookup>
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	85 c0                	test   %eax,%eax
  80056d:	79 02                	jns    800571 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80056f:	c9                   	leave  
  800570:	c3                   	ret    
		return fd_close(fd, 1);
  800571:	83 ec 08             	sub    $0x8,%esp
  800574:	6a 01                	push   $0x1
  800576:	ff 75 f4             	pushl  -0xc(%ebp)
  800579:	e8 49 ff ff ff       	call   8004c7 <fd_close>
  80057e:	83 c4 10             	add    $0x10,%esp
  800581:	eb ec                	jmp    80056f <close+0x1d>

00800583 <close_all>:

void
close_all(void)
{
  800583:	f3 0f 1e fb          	endbr32 
  800587:	55                   	push   %ebp
  800588:	89 e5                	mov    %esp,%ebp
  80058a:	53                   	push   %ebx
  80058b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80058e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800593:	83 ec 0c             	sub    $0xc,%esp
  800596:	53                   	push   %ebx
  800597:	e8 b6 ff ff ff       	call   800552 <close>
	for (i = 0; i < MAXFD; i++)
  80059c:	83 c3 01             	add    $0x1,%ebx
  80059f:	83 c4 10             	add    $0x10,%esp
  8005a2:	83 fb 20             	cmp    $0x20,%ebx
  8005a5:	75 ec                	jne    800593 <close_all+0x10>
}
  8005a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005aa:	c9                   	leave  
  8005ab:	c3                   	ret    

008005ac <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005ac:	f3 0f 1e fb          	endbr32 
  8005b0:	55                   	push   %ebp
  8005b1:	89 e5                	mov    %esp,%ebp
  8005b3:	57                   	push   %edi
  8005b4:	56                   	push   %esi
  8005b5:	53                   	push   %ebx
  8005b6:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005b9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005bc:	50                   	push   %eax
  8005bd:	ff 75 08             	pushl  0x8(%ebp)
  8005c0:	e8 54 fe ff ff       	call   800419 <fd_lookup>
  8005c5:	89 c3                	mov    %eax,%ebx
  8005c7:	83 c4 10             	add    $0x10,%esp
  8005ca:	85 c0                	test   %eax,%eax
  8005cc:	0f 88 81 00 00 00    	js     800653 <dup+0xa7>
		return r;
	close(newfdnum);
  8005d2:	83 ec 0c             	sub    $0xc,%esp
  8005d5:	ff 75 0c             	pushl  0xc(%ebp)
  8005d8:	e8 75 ff ff ff       	call   800552 <close>

	newfd = INDEX2FD(newfdnum);
  8005dd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005e0:	c1 e6 0c             	shl    $0xc,%esi
  8005e3:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005e9:	83 c4 04             	add    $0x4,%esp
  8005ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005ef:	e8 b4 fd ff ff       	call   8003a8 <fd2data>
  8005f4:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005f6:	89 34 24             	mov    %esi,(%esp)
  8005f9:	e8 aa fd ff ff       	call   8003a8 <fd2data>
  8005fe:	83 c4 10             	add    $0x10,%esp
  800601:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800603:	89 d8                	mov    %ebx,%eax
  800605:	c1 e8 16             	shr    $0x16,%eax
  800608:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80060f:	a8 01                	test   $0x1,%al
  800611:	74 11                	je     800624 <dup+0x78>
  800613:	89 d8                	mov    %ebx,%eax
  800615:	c1 e8 0c             	shr    $0xc,%eax
  800618:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80061f:	f6 c2 01             	test   $0x1,%dl
  800622:	75 39                	jne    80065d <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800624:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800627:	89 d0                	mov    %edx,%eax
  800629:	c1 e8 0c             	shr    $0xc,%eax
  80062c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800633:	83 ec 0c             	sub    $0xc,%esp
  800636:	25 07 0e 00 00       	and    $0xe07,%eax
  80063b:	50                   	push   %eax
  80063c:	56                   	push   %esi
  80063d:	6a 00                	push   $0x0
  80063f:	52                   	push   %edx
  800640:	6a 00                	push   $0x0
  800642:	e8 83 fb ff ff       	call   8001ca <sys_page_map>
  800647:	89 c3                	mov    %eax,%ebx
  800649:	83 c4 20             	add    $0x20,%esp
  80064c:	85 c0                	test   %eax,%eax
  80064e:	78 31                	js     800681 <dup+0xd5>
		goto err;

	return newfdnum;
  800650:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800653:	89 d8                	mov    %ebx,%eax
  800655:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800658:	5b                   	pop    %ebx
  800659:	5e                   	pop    %esi
  80065a:	5f                   	pop    %edi
  80065b:	5d                   	pop    %ebp
  80065c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80065d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800664:	83 ec 0c             	sub    $0xc,%esp
  800667:	25 07 0e 00 00       	and    $0xe07,%eax
  80066c:	50                   	push   %eax
  80066d:	57                   	push   %edi
  80066e:	6a 00                	push   $0x0
  800670:	53                   	push   %ebx
  800671:	6a 00                	push   $0x0
  800673:	e8 52 fb ff ff       	call   8001ca <sys_page_map>
  800678:	89 c3                	mov    %eax,%ebx
  80067a:	83 c4 20             	add    $0x20,%esp
  80067d:	85 c0                	test   %eax,%eax
  80067f:	79 a3                	jns    800624 <dup+0x78>
	sys_page_unmap(0, newfd);
  800681:	83 ec 08             	sub    $0x8,%esp
  800684:	56                   	push   %esi
  800685:	6a 00                	push   $0x0
  800687:	e8 84 fb ff ff       	call   800210 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80068c:	83 c4 08             	add    $0x8,%esp
  80068f:	57                   	push   %edi
  800690:	6a 00                	push   $0x0
  800692:	e8 79 fb ff ff       	call   800210 <sys_page_unmap>
	return r;
  800697:	83 c4 10             	add    $0x10,%esp
  80069a:	eb b7                	jmp    800653 <dup+0xa7>

0080069c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80069c:	f3 0f 1e fb          	endbr32 
  8006a0:	55                   	push   %ebp
  8006a1:	89 e5                	mov    %esp,%ebp
  8006a3:	53                   	push   %ebx
  8006a4:	83 ec 1c             	sub    $0x1c,%esp
  8006a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006ad:	50                   	push   %eax
  8006ae:	53                   	push   %ebx
  8006af:	e8 65 fd ff ff       	call   800419 <fd_lookup>
  8006b4:	83 c4 10             	add    $0x10,%esp
  8006b7:	85 c0                	test   %eax,%eax
  8006b9:	78 3f                	js     8006fa <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006bb:	83 ec 08             	sub    $0x8,%esp
  8006be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006c1:	50                   	push   %eax
  8006c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c5:	ff 30                	pushl  (%eax)
  8006c7:	e8 a1 fd ff ff       	call   80046d <dev_lookup>
  8006cc:	83 c4 10             	add    $0x10,%esp
  8006cf:	85 c0                	test   %eax,%eax
  8006d1:	78 27                	js     8006fa <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8006d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006d6:	8b 42 08             	mov    0x8(%edx),%eax
  8006d9:	83 e0 03             	and    $0x3,%eax
  8006dc:	83 f8 01             	cmp    $0x1,%eax
  8006df:	74 1e                	je     8006ff <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006e4:	8b 40 08             	mov    0x8(%eax),%eax
  8006e7:	85 c0                	test   %eax,%eax
  8006e9:	74 35                	je     800720 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006eb:	83 ec 04             	sub    $0x4,%esp
  8006ee:	ff 75 10             	pushl  0x10(%ebp)
  8006f1:	ff 75 0c             	pushl  0xc(%ebp)
  8006f4:	52                   	push   %edx
  8006f5:	ff d0                	call   *%eax
  8006f7:	83 c4 10             	add    $0x10,%esp
}
  8006fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006fd:	c9                   	leave  
  8006fe:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006ff:	a1 04 40 80 00       	mov    0x804004,%eax
  800704:	8b 40 48             	mov    0x48(%eax),%eax
  800707:	83 ec 04             	sub    $0x4,%esp
  80070a:	53                   	push   %ebx
  80070b:	50                   	push   %eax
  80070c:	68 79 1f 80 00       	push   $0x801f79
  800711:	e8 aa 0a 00 00       	call   8011c0 <cprintf>
		return -E_INVAL;
  800716:	83 c4 10             	add    $0x10,%esp
  800719:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80071e:	eb da                	jmp    8006fa <read+0x5e>
		return -E_NOT_SUPP;
  800720:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800725:	eb d3                	jmp    8006fa <read+0x5e>

00800727 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800727:	f3 0f 1e fb          	endbr32 
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	57                   	push   %edi
  80072f:	56                   	push   %esi
  800730:	53                   	push   %ebx
  800731:	83 ec 0c             	sub    $0xc,%esp
  800734:	8b 7d 08             	mov    0x8(%ebp),%edi
  800737:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80073a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80073f:	eb 02                	jmp    800743 <readn+0x1c>
  800741:	01 c3                	add    %eax,%ebx
  800743:	39 f3                	cmp    %esi,%ebx
  800745:	73 21                	jae    800768 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800747:	83 ec 04             	sub    $0x4,%esp
  80074a:	89 f0                	mov    %esi,%eax
  80074c:	29 d8                	sub    %ebx,%eax
  80074e:	50                   	push   %eax
  80074f:	89 d8                	mov    %ebx,%eax
  800751:	03 45 0c             	add    0xc(%ebp),%eax
  800754:	50                   	push   %eax
  800755:	57                   	push   %edi
  800756:	e8 41 ff ff ff       	call   80069c <read>
		if (m < 0)
  80075b:	83 c4 10             	add    $0x10,%esp
  80075e:	85 c0                	test   %eax,%eax
  800760:	78 04                	js     800766 <readn+0x3f>
			return m;
		if (m == 0)
  800762:	75 dd                	jne    800741 <readn+0x1a>
  800764:	eb 02                	jmp    800768 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800766:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800768:	89 d8                	mov    %ebx,%eax
  80076a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80076d:	5b                   	pop    %ebx
  80076e:	5e                   	pop    %esi
  80076f:	5f                   	pop    %edi
  800770:	5d                   	pop    %ebp
  800771:	c3                   	ret    

00800772 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800772:	f3 0f 1e fb          	endbr32 
  800776:	55                   	push   %ebp
  800777:	89 e5                	mov    %esp,%ebp
  800779:	53                   	push   %ebx
  80077a:	83 ec 1c             	sub    $0x1c,%esp
  80077d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800780:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800783:	50                   	push   %eax
  800784:	53                   	push   %ebx
  800785:	e8 8f fc ff ff       	call   800419 <fd_lookup>
  80078a:	83 c4 10             	add    $0x10,%esp
  80078d:	85 c0                	test   %eax,%eax
  80078f:	78 3a                	js     8007cb <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800791:	83 ec 08             	sub    $0x8,%esp
  800794:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800797:	50                   	push   %eax
  800798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80079b:	ff 30                	pushl  (%eax)
  80079d:	e8 cb fc ff ff       	call   80046d <dev_lookup>
  8007a2:	83 c4 10             	add    $0x10,%esp
  8007a5:	85 c0                	test   %eax,%eax
  8007a7:	78 22                	js     8007cb <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ac:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007b0:	74 1e                	je     8007d0 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007b5:	8b 52 0c             	mov    0xc(%edx),%edx
  8007b8:	85 d2                	test   %edx,%edx
  8007ba:	74 35                	je     8007f1 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007bc:	83 ec 04             	sub    $0x4,%esp
  8007bf:	ff 75 10             	pushl  0x10(%ebp)
  8007c2:	ff 75 0c             	pushl  0xc(%ebp)
  8007c5:	50                   	push   %eax
  8007c6:	ff d2                	call   *%edx
  8007c8:	83 c4 10             	add    $0x10,%esp
}
  8007cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ce:	c9                   	leave  
  8007cf:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007d0:	a1 04 40 80 00       	mov    0x804004,%eax
  8007d5:	8b 40 48             	mov    0x48(%eax),%eax
  8007d8:	83 ec 04             	sub    $0x4,%esp
  8007db:	53                   	push   %ebx
  8007dc:	50                   	push   %eax
  8007dd:	68 95 1f 80 00       	push   $0x801f95
  8007e2:	e8 d9 09 00 00       	call   8011c0 <cprintf>
		return -E_INVAL;
  8007e7:	83 c4 10             	add    $0x10,%esp
  8007ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ef:	eb da                	jmp    8007cb <write+0x59>
		return -E_NOT_SUPP;
  8007f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007f6:	eb d3                	jmp    8007cb <write+0x59>

008007f8 <seek>:

int
seek(int fdnum, off_t offset)
{
  8007f8:	f3 0f 1e fb          	endbr32 
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800802:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800805:	50                   	push   %eax
  800806:	ff 75 08             	pushl  0x8(%ebp)
  800809:	e8 0b fc ff ff       	call   800419 <fd_lookup>
  80080e:	83 c4 10             	add    $0x10,%esp
  800811:	85 c0                	test   %eax,%eax
  800813:	78 0e                	js     800823 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  800815:	8b 55 0c             	mov    0xc(%ebp),%edx
  800818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80081b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80081e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800823:	c9                   	leave  
  800824:	c3                   	ret    

00800825 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800825:	f3 0f 1e fb          	endbr32 
  800829:	55                   	push   %ebp
  80082a:	89 e5                	mov    %esp,%ebp
  80082c:	53                   	push   %ebx
  80082d:	83 ec 1c             	sub    $0x1c,%esp
  800830:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800833:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800836:	50                   	push   %eax
  800837:	53                   	push   %ebx
  800838:	e8 dc fb ff ff       	call   800419 <fd_lookup>
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	85 c0                	test   %eax,%eax
  800842:	78 37                	js     80087b <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800844:	83 ec 08             	sub    $0x8,%esp
  800847:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80084a:	50                   	push   %eax
  80084b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084e:	ff 30                	pushl  (%eax)
  800850:	e8 18 fc ff ff       	call   80046d <dev_lookup>
  800855:	83 c4 10             	add    $0x10,%esp
  800858:	85 c0                	test   %eax,%eax
  80085a:	78 1f                	js     80087b <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80085c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80085f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800863:	74 1b                	je     800880 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800865:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800868:	8b 52 18             	mov    0x18(%edx),%edx
  80086b:	85 d2                	test   %edx,%edx
  80086d:	74 32                	je     8008a1 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	ff 75 0c             	pushl  0xc(%ebp)
  800875:	50                   	push   %eax
  800876:	ff d2                	call   *%edx
  800878:	83 c4 10             	add    $0x10,%esp
}
  80087b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80087e:	c9                   	leave  
  80087f:	c3                   	ret    
			thisenv->env_id, fdnum);
  800880:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800885:	8b 40 48             	mov    0x48(%eax),%eax
  800888:	83 ec 04             	sub    $0x4,%esp
  80088b:	53                   	push   %ebx
  80088c:	50                   	push   %eax
  80088d:	68 58 1f 80 00       	push   $0x801f58
  800892:	e8 29 09 00 00       	call   8011c0 <cprintf>
		return -E_INVAL;
  800897:	83 c4 10             	add    $0x10,%esp
  80089a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80089f:	eb da                	jmp    80087b <ftruncate+0x56>
		return -E_NOT_SUPP;
  8008a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008a6:	eb d3                	jmp    80087b <ftruncate+0x56>

008008a8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008a8:	f3 0f 1e fb          	endbr32 
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	53                   	push   %ebx
  8008b0:	83 ec 1c             	sub    $0x1c,%esp
  8008b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008b9:	50                   	push   %eax
  8008ba:	ff 75 08             	pushl  0x8(%ebp)
  8008bd:	e8 57 fb ff ff       	call   800419 <fd_lookup>
  8008c2:	83 c4 10             	add    $0x10,%esp
  8008c5:	85 c0                	test   %eax,%eax
  8008c7:	78 4b                	js     800914 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008c9:	83 ec 08             	sub    $0x8,%esp
  8008cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008cf:	50                   	push   %eax
  8008d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d3:	ff 30                	pushl  (%eax)
  8008d5:	e8 93 fb ff ff       	call   80046d <dev_lookup>
  8008da:	83 c4 10             	add    $0x10,%esp
  8008dd:	85 c0                	test   %eax,%eax
  8008df:	78 33                	js     800914 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8008e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8008e8:	74 2f                	je     800919 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8008ea:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8008ed:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8008f4:	00 00 00 
	stat->st_isdir = 0;
  8008f7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008fe:	00 00 00 
	stat->st_dev = dev;
  800901:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	53                   	push   %ebx
  80090b:	ff 75 f0             	pushl  -0x10(%ebp)
  80090e:	ff 50 14             	call   *0x14(%eax)
  800911:	83 c4 10             	add    $0x10,%esp
}
  800914:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800917:	c9                   	leave  
  800918:	c3                   	ret    
		return -E_NOT_SUPP;
  800919:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80091e:	eb f4                	jmp    800914 <fstat+0x6c>

00800920 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800920:	f3 0f 1e fb          	endbr32 
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	56                   	push   %esi
  800928:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	6a 00                	push   $0x0
  80092e:	ff 75 08             	pushl  0x8(%ebp)
  800931:	e8 fb 01 00 00       	call   800b31 <open>
  800936:	89 c3                	mov    %eax,%ebx
  800938:	83 c4 10             	add    $0x10,%esp
  80093b:	85 c0                	test   %eax,%eax
  80093d:	78 1b                	js     80095a <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	ff 75 0c             	pushl  0xc(%ebp)
  800945:	50                   	push   %eax
  800946:	e8 5d ff ff ff       	call   8008a8 <fstat>
  80094b:	89 c6                	mov    %eax,%esi
	close(fd);
  80094d:	89 1c 24             	mov    %ebx,(%esp)
  800950:	e8 fd fb ff ff       	call   800552 <close>
	return r;
  800955:	83 c4 10             	add    $0x10,%esp
  800958:	89 f3                	mov    %esi,%ebx
}
  80095a:	89 d8                	mov    %ebx,%eax
  80095c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80095f:	5b                   	pop    %ebx
  800960:	5e                   	pop    %esi
  800961:	5d                   	pop    %ebp
  800962:	c3                   	ret    

00800963 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	56                   	push   %esi
  800967:	53                   	push   %ebx
  800968:	89 c6                	mov    %eax,%esi
  80096a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80096c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800973:	74 27                	je     80099c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800975:	6a 07                	push   $0x7
  800977:	68 00 50 80 00       	push   $0x805000
  80097c:	56                   	push   %esi
  80097d:	ff 35 00 40 80 00    	pushl  0x804000
  800983:	e8 39 12 00 00       	call   801bc1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800988:	83 c4 0c             	add    $0xc,%esp
  80098b:	6a 00                	push   $0x0
  80098d:	53                   	push   %ebx
  80098e:	6a 00                	push   $0x0
  800990:	e8 a7 11 00 00       	call   801b3c <ipc_recv>
}
  800995:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800998:	5b                   	pop    %ebx
  800999:	5e                   	pop    %esi
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80099c:	83 ec 0c             	sub    $0xc,%esp
  80099f:	6a 01                	push   $0x1
  8009a1:	e8 73 12 00 00       	call   801c19 <ipc_find_env>
  8009a6:	a3 00 40 80 00       	mov    %eax,0x804000
  8009ab:	83 c4 10             	add    $0x10,%esp
  8009ae:	eb c5                	jmp    800975 <fsipc+0x12>

008009b0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009b0:	f3 0f 1e fb          	endbr32 
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8009c0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c8:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d2:	b8 02 00 00 00       	mov    $0x2,%eax
  8009d7:	e8 87 ff ff ff       	call   800963 <fsipc>
}
  8009dc:	c9                   	leave  
  8009dd:	c3                   	ret    

008009de <devfile_flush>:
{
  8009de:	f3 0f 1e fb          	endbr32 
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8009ee:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8009f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f8:	b8 06 00 00 00       	mov    $0x6,%eax
  8009fd:	e8 61 ff ff ff       	call   800963 <fsipc>
}
  800a02:	c9                   	leave  
  800a03:	c3                   	ret    

00800a04 <devfile_stat>:
{
  800a04:	f3 0f 1e fb          	endbr32 
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	53                   	push   %ebx
  800a0c:	83 ec 04             	sub    $0x4,%esp
  800a0f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8b 40 0c             	mov    0xc(%eax),%eax
  800a18:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a22:	b8 05 00 00 00       	mov    $0x5,%eax
  800a27:	e8 37 ff ff ff       	call   800963 <fsipc>
  800a2c:	85 c0                	test   %eax,%eax
  800a2e:	78 2c                	js     800a5c <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a30:	83 ec 08             	sub    $0x8,%esp
  800a33:	68 00 50 80 00       	push   $0x805000
  800a38:	53                   	push   %ebx
  800a39:	e8 8c 0d 00 00       	call   8017ca <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a3e:	a1 80 50 80 00       	mov    0x805080,%eax
  800a43:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800a49:	a1 84 50 80 00       	mov    0x805084,%eax
  800a4e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a54:	83 c4 10             	add    $0x10,%esp
  800a57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a5f:	c9                   	leave  
  800a60:	c3                   	ret    

00800a61 <devfile_write>:
{
  800a61:	f3 0f 1e fb          	endbr32 
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	83 ec 0c             	sub    $0xc,%esp
  800a6b:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800a71:	8b 52 0c             	mov    0xc(%edx),%edx
  800a74:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  800a7a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800a7f:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800a84:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  800a87:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a8c:	50                   	push   %eax
  800a8d:	ff 75 0c             	pushl  0xc(%ebp)
  800a90:	68 08 50 80 00       	push   $0x805008
  800a95:	e8 e6 0e 00 00       	call   801980 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800a9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9f:	b8 04 00 00 00       	mov    $0x4,%eax
  800aa4:	e8 ba fe ff ff       	call   800963 <fsipc>
}
  800aa9:	c9                   	leave  
  800aaa:	c3                   	ret    

00800aab <devfile_read>:
{
  800aab:	f3 0f 1e fb          	endbr32 
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	56                   	push   %esi
  800ab3:	53                   	push   %ebx
  800ab4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	8b 40 0c             	mov    0xc(%eax),%eax
  800abd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800ac2:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800ac8:	ba 00 00 00 00       	mov    $0x0,%edx
  800acd:	b8 03 00 00 00       	mov    $0x3,%eax
  800ad2:	e8 8c fe ff ff       	call   800963 <fsipc>
  800ad7:	89 c3                	mov    %eax,%ebx
  800ad9:	85 c0                	test   %eax,%eax
  800adb:	78 1f                	js     800afc <devfile_read+0x51>
	assert(r <= n);
  800add:	39 f0                	cmp    %esi,%eax
  800adf:	77 24                	ja     800b05 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800ae1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ae6:	7f 33                	jg     800b1b <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800ae8:	83 ec 04             	sub    $0x4,%esp
  800aeb:	50                   	push   %eax
  800aec:	68 00 50 80 00       	push   $0x805000
  800af1:	ff 75 0c             	pushl  0xc(%ebp)
  800af4:	e8 87 0e 00 00       	call   801980 <memmove>
	return r;
  800af9:	83 c4 10             	add    $0x10,%esp
}
  800afc:	89 d8                	mov    %ebx,%eax
  800afe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b01:	5b                   	pop    %ebx
  800b02:	5e                   	pop    %esi
  800b03:	5d                   	pop    %ebp
  800b04:	c3                   	ret    
	assert(r <= n);
  800b05:	68 c4 1f 80 00       	push   $0x801fc4
  800b0a:	68 cb 1f 80 00       	push   $0x801fcb
  800b0f:	6a 7c                	push   $0x7c
  800b11:	68 e0 1f 80 00       	push   $0x801fe0
  800b16:	e8 be 05 00 00       	call   8010d9 <_panic>
	assert(r <= PGSIZE);
  800b1b:	68 eb 1f 80 00       	push   $0x801feb
  800b20:	68 cb 1f 80 00       	push   $0x801fcb
  800b25:	6a 7d                	push   $0x7d
  800b27:	68 e0 1f 80 00       	push   $0x801fe0
  800b2c:	e8 a8 05 00 00       	call   8010d9 <_panic>

00800b31 <open>:
{
  800b31:	f3 0f 1e fb          	endbr32 
  800b35:	55                   	push   %ebp
  800b36:	89 e5                	mov    %esp,%ebp
  800b38:	56                   	push   %esi
  800b39:	53                   	push   %ebx
  800b3a:	83 ec 1c             	sub    $0x1c,%esp
  800b3d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b40:	56                   	push   %esi
  800b41:	e8 41 0c 00 00       	call   801787 <strlen>
  800b46:	83 c4 10             	add    $0x10,%esp
  800b49:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b4e:	7f 6c                	jg     800bbc <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b50:	83 ec 0c             	sub    $0xc,%esp
  800b53:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b56:	50                   	push   %eax
  800b57:	e8 67 f8 ff ff       	call   8003c3 <fd_alloc>
  800b5c:	89 c3                	mov    %eax,%ebx
  800b5e:	83 c4 10             	add    $0x10,%esp
  800b61:	85 c0                	test   %eax,%eax
  800b63:	78 3c                	js     800ba1 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b65:	83 ec 08             	sub    $0x8,%esp
  800b68:	56                   	push   %esi
  800b69:	68 00 50 80 00       	push   $0x805000
  800b6e:	e8 57 0c 00 00       	call   8017ca <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b76:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b7e:	b8 01 00 00 00       	mov    $0x1,%eax
  800b83:	e8 db fd ff ff       	call   800963 <fsipc>
  800b88:	89 c3                	mov    %eax,%ebx
  800b8a:	83 c4 10             	add    $0x10,%esp
  800b8d:	85 c0                	test   %eax,%eax
  800b8f:	78 19                	js     800baa <open+0x79>
	return fd2num(fd);
  800b91:	83 ec 0c             	sub    $0xc,%esp
  800b94:	ff 75 f4             	pushl  -0xc(%ebp)
  800b97:	e8 f8 f7 ff ff       	call   800394 <fd2num>
  800b9c:	89 c3                	mov    %eax,%ebx
  800b9e:	83 c4 10             	add    $0x10,%esp
}
  800ba1:	89 d8                	mov    %ebx,%eax
  800ba3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ba6:	5b                   	pop    %ebx
  800ba7:	5e                   	pop    %esi
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    
		fd_close(fd, 0);
  800baa:	83 ec 08             	sub    $0x8,%esp
  800bad:	6a 00                	push   $0x0
  800baf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb2:	e8 10 f9 ff ff       	call   8004c7 <fd_close>
		return r;
  800bb7:	83 c4 10             	add    $0x10,%esp
  800bba:	eb e5                	jmp    800ba1 <open+0x70>
		return -E_BAD_PATH;
  800bbc:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800bc1:	eb de                	jmp    800ba1 <open+0x70>

00800bc3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800bc3:	f3 0f 1e fb          	endbr32 
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800bcd:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd2:	b8 08 00 00 00       	mov    $0x8,%eax
  800bd7:	e8 87 fd ff ff       	call   800963 <fsipc>
}
  800bdc:	c9                   	leave  
  800bdd:	c3                   	ret    

00800bde <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800bde:	f3 0f 1e fb          	endbr32 
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	56                   	push   %esi
  800be6:	53                   	push   %ebx
  800be7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800bea:	83 ec 0c             	sub    $0xc,%esp
  800bed:	ff 75 08             	pushl  0x8(%ebp)
  800bf0:	e8 b3 f7 ff ff       	call   8003a8 <fd2data>
  800bf5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bf7:	83 c4 08             	add    $0x8,%esp
  800bfa:	68 f7 1f 80 00       	push   $0x801ff7
  800bff:	53                   	push   %ebx
  800c00:	e8 c5 0b 00 00       	call   8017ca <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800c05:	8b 46 04             	mov    0x4(%esi),%eax
  800c08:	2b 06                	sub    (%esi),%eax
  800c0a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800c10:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800c17:	00 00 00 
	stat->st_dev = &devpipe;
  800c1a:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c21:	30 80 00 
	return 0;
}
  800c24:	b8 00 00 00 00       	mov    $0x0,%eax
  800c29:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c2c:	5b                   	pop    %ebx
  800c2d:	5e                   	pop    %esi
  800c2e:	5d                   	pop    %ebp
  800c2f:	c3                   	ret    

00800c30 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c30:	f3 0f 1e fb          	endbr32 
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	53                   	push   %ebx
  800c38:	83 ec 0c             	sub    $0xc,%esp
  800c3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c3e:	53                   	push   %ebx
  800c3f:	6a 00                	push   $0x0
  800c41:	e8 ca f5 ff ff       	call   800210 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c46:	89 1c 24             	mov    %ebx,(%esp)
  800c49:	e8 5a f7 ff ff       	call   8003a8 <fd2data>
  800c4e:	83 c4 08             	add    $0x8,%esp
  800c51:	50                   	push   %eax
  800c52:	6a 00                	push   $0x0
  800c54:	e8 b7 f5 ff ff       	call   800210 <sys_page_unmap>
}
  800c59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c5c:	c9                   	leave  
  800c5d:	c3                   	ret    

00800c5e <_pipeisclosed>:
{
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	57                   	push   %edi
  800c62:	56                   	push   %esi
  800c63:	53                   	push   %ebx
  800c64:	83 ec 1c             	sub    $0x1c,%esp
  800c67:	89 c7                	mov    %eax,%edi
  800c69:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c6b:	a1 04 40 80 00       	mov    0x804004,%eax
  800c70:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c73:	83 ec 0c             	sub    $0xc,%esp
  800c76:	57                   	push   %edi
  800c77:	e8 da 0f 00 00       	call   801c56 <pageref>
  800c7c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c7f:	89 34 24             	mov    %esi,(%esp)
  800c82:	e8 cf 0f 00 00       	call   801c56 <pageref>
		nn = thisenv->env_runs;
  800c87:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800c8d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c90:	83 c4 10             	add    $0x10,%esp
  800c93:	39 cb                	cmp    %ecx,%ebx
  800c95:	74 1b                	je     800cb2 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c97:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c9a:	75 cf                	jne    800c6b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c9c:	8b 42 58             	mov    0x58(%edx),%eax
  800c9f:	6a 01                	push   $0x1
  800ca1:	50                   	push   %eax
  800ca2:	53                   	push   %ebx
  800ca3:	68 fe 1f 80 00       	push   $0x801ffe
  800ca8:	e8 13 05 00 00       	call   8011c0 <cprintf>
  800cad:	83 c4 10             	add    $0x10,%esp
  800cb0:	eb b9                	jmp    800c6b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800cb2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800cb5:	0f 94 c0             	sete   %al
  800cb8:	0f b6 c0             	movzbl %al,%eax
}
  800cbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cbe:	5b                   	pop    %ebx
  800cbf:	5e                   	pop    %esi
  800cc0:	5f                   	pop    %edi
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <devpipe_write>:
{
  800cc3:	f3 0f 1e fb          	endbr32 
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	57                   	push   %edi
  800ccb:	56                   	push   %esi
  800ccc:	53                   	push   %ebx
  800ccd:	83 ec 28             	sub    $0x28,%esp
  800cd0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800cd3:	56                   	push   %esi
  800cd4:	e8 cf f6 ff ff       	call   8003a8 <fd2data>
  800cd9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800cdb:	83 c4 10             	add    $0x10,%esp
  800cde:	bf 00 00 00 00       	mov    $0x0,%edi
  800ce3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800ce6:	74 4f                	je     800d37 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800ce8:	8b 43 04             	mov    0x4(%ebx),%eax
  800ceb:	8b 0b                	mov    (%ebx),%ecx
  800ced:	8d 51 20             	lea    0x20(%ecx),%edx
  800cf0:	39 d0                	cmp    %edx,%eax
  800cf2:	72 14                	jb     800d08 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  800cf4:	89 da                	mov    %ebx,%edx
  800cf6:	89 f0                	mov    %esi,%eax
  800cf8:	e8 61 ff ff ff       	call   800c5e <_pipeisclosed>
  800cfd:	85 c0                	test   %eax,%eax
  800cff:	75 3b                	jne    800d3c <devpipe_write+0x79>
			sys_yield();
  800d01:	e8 5a f4 ff ff       	call   800160 <sys_yield>
  800d06:	eb e0                	jmp    800ce8 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800d0f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800d12:	89 c2                	mov    %eax,%edx
  800d14:	c1 fa 1f             	sar    $0x1f,%edx
  800d17:	89 d1                	mov    %edx,%ecx
  800d19:	c1 e9 1b             	shr    $0x1b,%ecx
  800d1c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800d1f:	83 e2 1f             	and    $0x1f,%edx
  800d22:	29 ca                	sub    %ecx,%edx
  800d24:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800d28:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800d2c:	83 c0 01             	add    $0x1,%eax
  800d2f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d32:	83 c7 01             	add    $0x1,%edi
  800d35:	eb ac                	jmp    800ce3 <devpipe_write+0x20>
	return i;
  800d37:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3a:	eb 05                	jmp    800d41 <devpipe_write+0x7e>
				return 0;
  800d3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <devpipe_read>:
{
  800d49:	f3 0f 1e fb          	endbr32 
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	57                   	push   %edi
  800d51:	56                   	push   %esi
  800d52:	53                   	push   %ebx
  800d53:	83 ec 18             	sub    $0x18,%esp
  800d56:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d59:	57                   	push   %edi
  800d5a:	e8 49 f6 ff ff       	call   8003a8 <fd2data>
  800d5f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d61:	83 c4 10             	add    $0x10,%esp
  800d64:	be 00 00 00 00       	mov    $0x0,%esi
  800d69:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d6c:	75 14                	jne    800d82 <devpipe_read+0x39>
	return i;
  800d6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d71:	eb 02                	jmp    800d75 <devpipe_read+0x2c>
				return i;
  800d73:	89 f0                	mov    %esi,%eax
}
  800d75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d78:	5b                   	pop    %ebx
  800d79:	5e                   	pop    %esi
  800d7a:	5f                   	pop    %edi
  800d7b:	5d                   	pop    %ebp
  800d7c:	c3                   	ret    
			sys_yield();
  800d7d:	e8 de f3 ff ff       	call   800160 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d82:	8b 03                	mov    (%ebx),%eax
  800d84:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d87:	75 18                	jne    800da1 <devpipe_read+0x58>
			if (i > 0)
  800d89:	85 f6                	test   %esi,%esi
  800d8b:	75 e6                	jne    800d73 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  800d8d:	89 da                	mov    %ebx,%edx
  800d8f:	89 f8                	mov    %edi,%eax
  800d91:	e8 c8 fe ff ff       	call   800c5e <_pipeisclosed>
  800d96:	85 c0                	test   %eax,%eax
  800d98:	74 e3                	je     800d7d <devpipe_read+0x34>
				return 0;
  800d9a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d9f:	eb d4                	jmp    800d75 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800da1:	99                   	cltd   
  800da2:	c1 ea 1b             	shr    $0x1b,%edx
  800da5:	01 d0                	add    %edx,%eax
  800da7:	83 e0 1f             	and    $0x1f,%eax
  800daa:	29 d0                	sub    %edx,%eax
  800dac:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800db1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800db7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800dba:	83 c6 01             	add    $0x1,%esi
  800dbd:	eb aa                	jmp    800d69 <devpipe_read+0x20>

00800dbf <pipe>:
{
  800dbf:	f3 0f 1e fb          	endbr32 
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	56                   	push   %esi
  800dc7:	53                   	push   %ebx
  800dc8:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800dcb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dce:	50                   	push   %eax
  800dcf:	e8 ef f5 ff ff       	call   8003c3 <fd_alloc>
  800dd4:	89 c3                	mov    %eax,%ebx
  800dd6:	83 c4 10             	add    $0x10,%esp
  800dd9:	85 c0                	test   %eax,%eax
  800ddb:	0f 88 23 01 00 00    	js     800f04 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800de1:	83 ec 04             	sub    $0x4,%esp
  800de4:	68 07 04 00 00       	push   $0x407
  800de9:	ff 75 f4             	pushl  -0xc(%ebp)
  800dec:	6a 00                	push   $0x0
  800dee:	e8 90 f3 ff ff       	call   800183 <sys_page_alloc>
  800df3:	89 c3                	mov    %eax,%ebx
  800df5:	83 c4 10             	add    $0x10,%esp
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	0f 88 04 01 00 00    	js     800f04 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  800e00:	83 ec 0c             	sub    $0xc,%esp
  800e03:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e06:	50                   	push   %eax
  800e07:	e8 b7 f5 ff ff       	call   8003c3 <fd_alloc>
  800e0c:	89 c3                	mov    %eax,%ebx
  800e0e:	83 c4 10             	add    $0x10,%esp
  800e11:	85 c0                	test   %eax,%eax
  800e13:	0f 88 db 00 00 00    	js     800ef4 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e19:	83 ec 04             	sub    $0x4,%esp
  800e1c:	68 07 04 00 00       	push   $0x407
  800e21:	ff 75 f0             	pushl  -0x10(%ebp)
  800e24:	6a 00                	push   $0x0
  800e26:	e8 58 f3 ff ff       	call   800183 <sys_page_alloc>
  800e2b:	89 c3                	mov    %eax,%ebx
  800e2d:	83 c4 10             	add    $0x10,%esp
  800e30:	85 c0                	test   %eax,%eax
  800e32:	0f 88 bc 00 00 00    	js     800ef4 <pipe+0x135>
	va = fd2data(fd0);
  800e38:	83 ec 0c             	sub    $0xc,%esp
  800e3b:	ff 75 f4             	pushl  -0xc(%ebp)
  800e3e:	e8 65 f5 ff ff       	call   8003a8 <fd2data>
  800e43:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e45:	83 c4 0c             	add    $0xc,%esp
  800e48:	68 07 04 00 00       	push   $0x407
  800e4d:	50                   	push   %eax
  800e4e:	6a 00                	push   $0x0
  800e50:	e8 2e f3 ff ff       	call   800183 <sys_page_alloc>
  800e55:	89 c3                	mov    %eax,%ebx
  800e57:	83 c4 10             	add    $0x10,%esp
  800e5a:	85 c0                	test   %eax,%eax
  800e5c:	0f 88 82 00 00 00    	js     800ee4 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e62:	83 ec 0c             	sub    $0xc,%esp
  800e65:	ff 75 f0             	pushl  -0x10(%ebp)
  800e68:	e8 3b f5 ff ff       	call   8003a8 <fd2data>
  800e6d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e74:	50                   	push   %eax
  800e75:	6a 00                	push   $0x0
  800e77:	56                   	push   %esi
  800e78:	6a 00                	push   $0x0
  800e7a:	e8 4b f3 ff ff       	call   8001ca <sys_page_map>
  800e7f:	89 c3                	mov    %eax,%ebx
  800e81:	83 c4 20             	add    $0x20,%esp
  800e84:	85 c0                	test   %eax,%eax
  800e86:	78 4e                	js     800ed6 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  800e88:	a1 20 30 80 00       	mov    0x803020,%eax
  800e8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e90:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e95:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e9c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e9f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800eab:	83 ec 0c             	sub    $0xc,%esp
  800eae:	ff 75 f4             	pushl  -0xc(%ebp)
  800eb1:	e8 de f4 ff ff       	call   800394 <fd2num>
  800eb6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eb9:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800ebb:	83 c4 04             	add    $0x4,%esp
  800ebe:	ff 75 f0             	pushl  -0x10(%ebp)
  800ec1:	e8 ce f4 ff ff       	call   800394 <fd2num>
  800ec6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ec9:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800ecc:	83 c4 10             	add    $0x10,%esp
  800ecf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed4:	eb 2e                	jmp    800f04 <pipe+0x145>
	sys_page_unmap(0, va);
  800ed6:	83 ec 08             	sub    $0x8,%esp
  800ed9:	56                   	push   %esi
  800eda:	6a 00                	push   $0x0
  800edc:	e8 2f f3 ff ff       	call   800210 <sys_page_unmap>
  800ee1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800ee4:	83 ec 08             	sub    $0x8,%esp
  800ee7:	ff 75 f0             	pushl  -0x10(%ebp)
  800eea:	6a 00                	push   $0x0
  800eec:	e8 1f f3 ff ff       	call   800210 <sys_page_unmap>
  800ef1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800ef4:	83 ec 08             	sub    $0x8,%esp
  800ef7:	ff 75 f4             	pushl  -0xc(%ebp)
  800efa:	6a 00                	push   $0x0
  800efc:	e8 0f f3 ff ff       	call   800210 <sys_page_unmap>
  800f01:	83 c4 10             	add    $0x10,%esp
}
  800f04:	89 d8                	mov    %ebx,%eax
  800f06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f09:	5b                   	pop    %ebx
  800f0a:	5e                   	pop    %esi
  800f0b:	5d                   	pop    %ebp
  800f0c:	c3                   	ret    

00800f0d <pipeisclosed>:
{
  800f0d:	f3 0f 1e fb          	endbr32 
  800f11:	55                   	push   %ebp
  800f12:	89 e5                	mov    %esp,%ebp
  800f14:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f17:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f1a:	50                   	push   %eax
  800f1b:	ff 75 08             	pushl  0x8(%ebp)
  800f1e:	e8 f6 f4 ff ff       	call   800419 <fd_lookup>
  800f23:	83 c4 10             	add    $0x10,%esp
  800f26:	85 c0                	test   %eax,%eax
  800f28:	78 18                	js     800f42 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  800f2a:	83 ec 0c             	sub    $0xc,%esp
  800f2d:	ff 75 f4             	pushl  -0xc(%ebp)
  800f30:	e8 73 f4 ff ff       	call   8003a8 <fd2data>
  800f35:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  800f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f3a:	e8 1f fd ff ff       	call   800c5e <_pipeisclosed>
  800f3f:	83 c4 10             	add    $0x10,%esp
}
  800f42:	c9                   	leave  
  800f43:	c3                   	ret    

00800f44 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800f44:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  800f48:	b8 00 00 00 00       	mov    $0x0,%eax
  800f4d:	c3                   	ret    

00800f4e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f4e:	f3 0f 1e fb          	endbr32 
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
  800f55:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800f58:	68 16 20 80 00       	push   $0x802016
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	e8 65 08 00 00       	call   8017ca <strcpy>
	return 0;
}
  800f65:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6a:	c9                   	leave  
  800f6b:	c3                   	ret    

00800f6c <devcons_write>:
{
  800f6c:	f3 0f 1e fb          	endbr32 
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
  800f73:	57                   	push   %edi
  800f74:	56                   	push   %esi
  800f75:	53                   	push   %ebx
  800f76:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800f7c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800f81:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800f87:	3b 75 10             	cmp    0x10(%ebp),%esi
  800f8a:	73 31                	jae    800fbd <devcons_write+0x51>
		m = n - tot;
  800f8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f8f:	29 f3                	sub    %esi,%ebx
  800f91:	83 fb 7f             	cmp    $0x7f,%ebx
  800f94:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800f99:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800f9c:	83 ec 04             	sub    $0x4,%esp
  800f9f:	53                   	push   %ebx
  800fa0:	89 f0                	mov    %esi,%eax
  800fa2:	03 45 0c             	add    0xc(%ebp),%eax
  800fa5:	50                   	push   %eax
  800fa6:	57                   	push   %edi
  800fa7:	e8 d4 09 00 00       	call   801980 <memmove>
		sys_cputs(buf, m);
  800fac:	83 c4 08             	add    $0x8,%esp
  800faf:	53                   	push   %ebx
  800fb0:	57                   	push   %edi
  800fb1:	e8 fd f0 ff ff       	call   8000b3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800fb6:	01 de                	add    %ebx,%esi
  800fb8:	83 c4 10             	add    $0x10,%esp
  800fbb:	eb ca                	jmp    800f87 <devcons_write+0x1b>
}
  800fbd:	89 f0                	mov    %esi,%eax
  800fbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc2:	5b                   	pop    %ebx
  800fc3:	5e                   	pop    %esi
  800fc4:	5f                   	pop    %edi
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    

00800fc7 <devcons_read>:
{
  800fc7:	f3 0f 1e fb          	endbr32 
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 08             	sub    $0x8,%esp
  800fd1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800fd6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fda:	74 21                	je     800ffd <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800fdc:	e8 f4 f0 ff ff       	call   8000d5 <sys_cgetc>
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	75 07                	jne    800fec <devcons_read+0x25>
		sys_yield();
  800fe5:	e8 76 f1 ff ff       	call   800160 <sys_yield>
  800fea:	eb f0                	jmp    800fdc <devcons_read+0x15>
	if (c < 0)
  800fec:	78 0f                	js     800ffd <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  800fee:	83 f8 04             	cmp    $0x4,%eax
  800ff1:	74 0c                	je     800fff <devcons_read+0x38>
	*(char*)vbuf = c;
  800ff3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ff6:	88 02                	mov    %al,(%edx)
	return 1;
  800ff8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800ffd:	c9                   	leave  
  800ffe:	c3                   	ret    
		return 0;
  800fff:	b8 00 00 00 00       	mov    $0x0,%eax
  801004:	eb f7                	jmp    800ffd <devcons_read+0x36>

00801006 <cputchar>:
{
  801006:	f3 0f 1e fb          	endbr32 
  80100a:	55                   	push   %ebp
  80100b:	89 e5                	mov    %esp,%ebp
  80100d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801016:	6a 01                	push   $0x1
  801018:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80101b:	50                   	push   %eax
  80101c:	e8 92 f0 ff ff       	call   8000b3 <sys_cputs>
}
  801021:	83 c4 10             	add    $0x10,%esp
  801024:	c9                   	leave  
  801025:	c3                   	ret    

00801026 <getchar>:
{
  801026:	f3 0f 1e fb          	endbr32 
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801030:	6a 01                	push   $0x1
  801032:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801035:	50                   	push   %eax
  801036:	6a 00                	push   $0x0
  801038:	e8 5f f6 ff ff       	call   80069c <read>
	if (r < 0)
  80103d:	83 c4 10             	add    $0x10,%esp
  801040:	85 c0                	test   %eax,%eax
  801042:	78 06                	js     80104a <getchar+0x24>
	if (r < 1)
  801044:	74 06                	je     80104c <getchar+0x26>
	return c;
  801046:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80104a:	c9                   	leave  
  80104b:	c3                   	ret    
		return -E_EOF;
  80104c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801051:	eb f7                	jmp    80104a <getchar+0x24>

00801053 <iscons>:
{
  801053:	f3 0f 1e fb          	endbr32 
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80105d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801060:	50                   	push   %eax
  801061:	ff 75 08             	pushl  0x8(%ebp)
  801064:	e8 b0 f3 ff ff       	call   800419 <fd_lookup>
  801069:	83 c4 10             	add    $0x10,%esp
  80106c:	85 c0                	test   %eax,%eax
  80106e:	78 11                	js     801081 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801073:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801079:	39 10                	cmp    %edx,(%eax)
  80107b:	0f 94 c0             	sete   %al
  80107e:	0f b6 c0             	movzbl %al,%eax
}
  801081:	c9                   	leave  
  801082:	c3                   	ret    

00801083 <opencons>:
{
  801083:	f3 0f 1e fb          	endbr32 
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80108d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801090:	50                   	push   %eax
  801091:	e8 2d f3 ff ff       	call   8003c3 <fd_alloc>
  801096:	83 c4 10             	add    $0x10,%esp
  801099:	85 c0                	test   %eax,%eax
  80109b:	78 3a                	js     8010d7 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80109d:	83 ec 04             	sub    $0x4,%esp
  8010a0:	68 07 04 00 00       	push   $0x407
  8010a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8010a8:	6a 00                	push   $0x0
  8010aa:	e8 d4 f0 ff ff       	call   800183 <sys_page_alloc>
  8010af:	83 c4 10             	add    $0x10,%esp
  8010b2:	85 c0                	test   %eax,%eax
  8010b4:	78 21                	js     8010d7 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8010b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010bf:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8010c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8010cb:	83 ec 0c             	sub    $0xc,%esp
  8010ce:	50                   	push   %eax
  8010cf:	e8 c0 f2 ff ff       	call   800394 <fd2num>
  8010d4:	83 c4 10             	add    $0x10,%esp
}
  8010d7:	c9                   	leave  
  8010d8:	c3                   	ret    

008010d9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8010d9:	f3 0f 1e fb          	endbr32 
  8010dd:	55                   	push   %ebp
  8010de:	89 e5                	mov    %esp,%ebp
  8010e0:	56                   	push   %esi
  8010e1:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8010e2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8010e5:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8010eb:	e8 4d f0 ff ff       	call   80013d <sys_getenvid>
  8010f0:	83 ec 0c             	sub    $0xc,%esp
  8010f3:	ff 75 0c             	pushl  0xc(%ebp)
  8010f6:	ff 75 08             	pushl  0x8(%ebp)
  8010f9:	56                   	push   %esi
  8010fa:	50                   	push   %eax
  8010fb:	68 24 20 80 00       	push   $0x802024
  801100:	e8 bb 00 00 00       	call   8011c0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801105:	83 c4 18             	add    $0x18,%esp
  801108:	53                   	push   %ebx
  801109:	ff 75 10             	pushl  0x10(%ebp)
  80110c:	e8 5a 00 00 00       	call   80116b <vcprintf>
	cprintf("\n");
  801111:	c7 04 24 58 23 80 00 	movl   $0x802358,(%esp)
  801118:	e8 a3 00 00 00       	call   8011c0 <cprintf>
  80111d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801120:	cc                   	int3   
  801121:	eb fd                	jmp    801120 <_panic+0x47>

00801123 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801123:	f3 0f 1e fb          	endbr32 
  801127:	55                   	push   %ebp
  801128:	89 e5                	mov    %esp,%ebp
  80112a:	53                   	push   %ebx
  80112b:	83 ec 04             	sub    $0x4,%esp
  80112e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801131:	8b 13                	mov    (%ebx),%edx
  801133:	8d 42 01             	lea    0x1(%edx),%eax
  801136:	89 03                	mov    %eax,(%ebx)
  801138:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80113b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80113f:	3d ff 00 00 00       	cmp    $0xff,%eax
  801144:	74 09                	je     80114f <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801146:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80114a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80114d:	c9                   	leave  
  80114e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80114f:	83 ec 08             	sub    $0x8,%esp
  801152:	68 ff 00 00 00       	push   $0xff
  801157:	8d 43 08             	lea    0x8(%ebx),%eax
  80115a:	50                   	push   %eax
  80115b:	e8 53 ef ff ff       	call   8000b3 <sys_cputs>
		b->idx = 0;
  801160:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801166:	83 c4 10             	add    $0x10,%esp
  801169:	eb db                	jmp    801146 <putch+0x23>

0080116b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80116b:	f3 0f 1e fb          	endbr32 
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801178:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80117f:	00 00 00 
	b.cnt = 0;
  801182:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801189:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80118c:	ff 75 0c             	pushl  0xc(%ebp)
  80118f:	ff 75 08             	pushl  0x8(%ebp)
  801192:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801198:	50                   	push   %eax
  801199:	68 23 11 80 00       	push   $0x801123
  80119e:	e8 20 01 00 00       	call   8012c3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8011a3:	83 c4 08             	add    $0x8,%esp
  8011a6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8011ac:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8011b2:	50                   	push   %eax
  8011b3:	e8 fb ee ff ff       	call   8000b3 <sys_cputs>

	return b.cnt;
}
  8011b8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8011be:	c9                   	leave  
  8011bf:	c3                   	ret    

008011c0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8011c0:	f3 0f 1e fb          	endbr32 
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
  8011c7:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8011ca:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8011cd:	50                   	push   %eax
  8011ce:	ff 75 08             	pushl  0x8(%ebp)
  8011d1:	e8 95 ff ff ff       	call   80116b <vcprintf>
	va_end(ap);

	return cnt;
}
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    

008011d8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	57                   	push   %edi
  8011dc:	56                   	push   %esi
  8011dd:	53                   	push   %ebx
  8011de:	83 ec 1c             	sub    $0x1c,%esp
  8011e1:	89 c7                	mov    %eax,%edi
  8011e3:	89 d6                	mov    %edx,%esi
  8011e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011eb:	89 d1                	mov    %edx,%ecx
  8011ed:	89 c2                	mov    %eax,%edx
  8011ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011f2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8011f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f8:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8011fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801205:	39 c2                	cmp    %eax,%edx
  801207:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80120a:	72 3e                	jb     80124a <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80120c:	83 ec 0c             	sub    $0xc,%esp
  80120f:	ff 75 18             	pushl  0x18(%ebp)
  801212:	83 eb 01             	sub    $0x1,%ebx
  801215:	53                   	push   %ebx
  801216:	50                   	push   %eax
  801217:	83 ec 08             	sub    $0x8,%esp
  80121a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80121d:	ff 75 e0             	pushl  -0x20(%ebp)
  801220:	ff 75 dc             	pushl  -0x24(%ebp)
  801223:	ff 75 d8             	pushl  -0x28(%ebp)
  801226:	e8 75 0a 00 00       	call   801ca0 <__udivdi3>
  80122b:	83 c4 18             	add    $0x18,%esp
  80122e:	52                   	push   %edx
  80122f:	50                   	push   %eax
  801230:	89 f2                	mov    %esi,%edx
  801232:	89 f8                	mov    %edi,%eax
  801234:	e8 9f ff ff ff       	call   8011d8 <printnum>
  801239:	83 c4 20             	add    $0x20,%esp
  80123c:	eb 13                	jmp    801251 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80123e:	83 ec 08             	sub    $0x8,%esp
  801241:	56                   	push   %esi
  801242:	ff 75 18             	pushl  0x18(%ebp)
  801245:	ff d7                	call   *%edi
  801247:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80124a:	83 eb 01             	sub    $0x1,%ebx
  80124d:	85 db                	test   %ebx,%ebx
  80124f:	7f ed                	jg     80123e <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801251:	83 ec 08             	sub    $0x8,%esp
  801254:	56                   	push   %esi
  801255:	83 ec 04             	sub    $0x4,%esp
  801258:	ff 75 e4             	pushl  -0x1c(%ebp)
  80125b:	ff 75 e0             	pushl  -0x20(%ebp)
  80125e:	ff 75 dc             	pushl  -0x24(%ebp)
  801261:	ff 75 d8             	pushl  -0x28(%ebp)
  801264:	e8 47 0b 00 00       	call   801db0 <__umoddi3>
  801269:	83 c4 14             	add    $0x14,%esp
  80126c:	0f be 80 47 20 80 00 	movsbl 0x802047(%eax),%eax
  801273:	50                   	push   %eax
  801274:	ff d7                	call   *%edi
}
  801276:	83 c4 10             	add    $0x10,%esp
  801279:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80127c:	5b                   	pop    %ebx
  80127d:	5e                   	pop    %esi
  80127e:	5f                   	pop    %edi
  80127f:	5d                   	pop    %ebp
  801280:	c3                   	ret    

00801281 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801281:	f3 0f 1e fb          	endbr32 
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80128b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80128f:	8b 10                	mov    (%eax),%edx
  801291:	3b 50 04             	cmp    0x4(%eax),%edx
  801294:	73 0a                	jae    8012a0 <sprintputch+0x1f>
		*b->buf++ = ch;
  801296:	8d 4a 01             	lea    0x1(%edx),%ecx
  801299:	89 08                	mov    %ecx,(%eax)
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	88 02                	mov    %al,(%edx)
}
  8012a0:	5d                   	pop    %ebp
  8012a1:	c3                   	ret    

008012a2 <printfmt>:
{
  8012a2:	f3 0f 1e fb          	endbr32 
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8012ac:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8012af:	50                   	push   %eax
  8012b0:	ff 75 10             	pushl  0x10(%ebp)
  8012b3:	ff 75 0c             	pushl  0xc(%ebp)
  8012b6:	ff 75 08             	pushl  0x8(%ebp)
  8012b9:	e8 05 00 00 00       	call   8012c3 <vprintfmt>
}
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	c9                   	leave  
  8012c2:	c3                   	ret    

008012c3 <vprintfmt>:
{
  8012c3:	f3 0f 1e fb          	endbr32 
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	57                   	push   %edi
  8012cb:	56                   	push   %esi
  8012cc:	53                   	push   %ebx
  8012cd:	83 ec 3c             	sub    $0x3c,%esp
  8012d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8012d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012d6:	8b 7d 10             	mov    0x10(%ebp),%edi
  8012d9:	e9 8e 03 00 00       	jmp    80166c <vprintfmt+0x3a9>
		padc = ' ';
  8012de:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8012e2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8012e9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8012f0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8012f7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8012fc:	8d 47 01             	lea    0x1(%edi),%eax
  8012ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801302:	0f b6 17             	movzbl (%edi),%edx
  801305:	8d 42 dd             	lea    -0x23(%edx),%eax
  801308:	3c 55                	cmp    $0x55,%al
  80130a:	0f 87 df 03 00 00    	ja     8016ef <vprintfmt+0x42c>
  801310:	0f b6 c0             	movzbl %al,%eax
  801313:	3e ff 24 85 80 21 80 	notrack jmp *0x802180(,%eax,4)
  80131a:	00 
  80131b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80131e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801322:	eb d8                	jmp    8012fc <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801324:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801327:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80132b:	eb cf                	jmp    8012fc <vprintfmt+0x39>
  80132d:	0f b6 d2             	movzbl %dl,%edx
  801330:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801333:	b8 00 00 00 00       	mov    $0x0,%eax
  801338:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80133b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80133e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801342:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801345:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801348:	83 f9 09             	cmp    $0x9,%ecx
  80134b:	77 55                	ja     8013a2 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80134d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801350:	eb e9                	jmp    80133b <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801352:	8b 45 14             	mov    0x14(%ebp),%eax
  801355:	8b 00                	mov    (%eax),%eax
  801357:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80135a:	8b 45 14             	mov    0x14(%ebp),%eax
  80135d:	8d 40 04             	lea    0x4(%eax),%eax
  801360:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801363:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801366:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80136a:	79 90                	jns    8012fc <vprintfmt+0x39>
				width = precision, precision = -1;
  80136c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80136f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801372:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801379:	eb 81                	jmp    8012fc <vprintfmt+0x39>
  80137b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80137e:	85 c0                	test   %eax,%eax
  801380:	ba 00 00 00 00       	mov    $0x0,%edx
  801385:	0f 49 d0             	cmovns %eax,%edx
  801388:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80138b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80138e:	e9 69 ff ff ff       	jmp    8012fc <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801393:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801396:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80139d:	e9 5a ff ff ff       	jmp    8012fc <vprintfmt+0x39>
  8013a2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8013a8:	eb bc                	jmp    801366 <vprintfmt+0xa3>
			lflag++;
  8013aa:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013b0:	e9 47 ff ff ff       	jmp    8012fc <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8013b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b8:	8d 78 04             	lea    0x4(%eax),%edi
  8013bb:	83 ec 08             	sub    $0x8,%esp
  8013be:	53                   	push   %ebx
  8013bf:	ff 30                	pushl  (%eax)
  8013c1:	ff d6                	call   *%esi
			break;
  8013c3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8013c6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8013c9:	e9 9b 02 00 00       	jmp    801669 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8013ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d1:	8d 78 04             	lea    0x4(%eax),%edi
  8013d4:	8b 00                	mov    (%eax),%eax
  8013d6:	99                   	cltd   
  8013d7:	31 d0                	xor    %edx,%eax
  8013d9:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8013db:	83 f8 0f             	cmp    $0xf,%eax
  8013de:	7f 23                	jg     801403 <vprintfmt+0x140>
  8013e0:	8b 14 85 e0 22 80 00 	mov    0x8022e0(,%eax,4),%edx
  8013e7:	85 d2                	test   %edx,%edx
  8013e9:	74 18                	je     801403 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8013eb:	52                   	push   %edx
  8013ec:	68 dd 1f 80 00       	push   $0x801fdd
  8013f1:	53                   	push   %ebx
  8013f2:	56                   	push   %esi
  8013f3:	e8 aa fe ff ff       	call   8012a2 <printfmt>
  8013f8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8013fb:	89 7d 14             	mov    %edi,0x14(%ebp)
  8013fe:	e9 66 02 00 00       	jmp    801669 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  801403:	50                   	push   %eax
  801404:	68 5f 20 80 00       	push   $0x80205f
  801409:	53                   	push   %ebx
  80140a:	56                   	push   %esi
  80140b:	e8 92 fe ff ff       	call   8012a2 <printfmt>
  801410:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801413:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801416:	e9 4e 02 00 00       	jmp    801669 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80141b:	8b 45 14             	mov    0x14(%ebp),%eax
  80141e:	83 c0 04             	add    $0x4,%eax
  801421:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801424:	8b 45 14             	mov    0x14(%ebp),%eax
  801427:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801429:	85 d2                	test   %edx,%edx
  80142b:	b8 58 20 80 00       	mov    $0x802058,%eax
  801430:	0f 45 c2             	cmovne %edx,%eax
  801433:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801436:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80143a:	7e 06                	jle    801442 <vprintfmt+0x17f>
  80143c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801440:	75 0d                	jne    80144f <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801442:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801445:	89 c7                	mov    %eax,%edi
  801447:	03 45 e0             	add    -0x20(%ebp),%eax
  80144a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80144d:	eb 55                	jmp    8014a4 <vprintfmt+0x1e1>
  80144f:	83 ec 08             	sub    $0x8,%esp
  801452:	ff 75 d8             	pushl  -0x28(%ebp)
  801455:	ff 75 cc             	pushl  -0x34(%ebp)
  801458:	e8 46 03 00 00       	call   8017a3 <strnlen>
  80145d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801460:	29 c2                	sub    %eax,%edx
  801462:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801465:	83 c4 10             	add    $0x10,%esp
  801468:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80146a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80146e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801471:	85 ff                	test   %edi,%edi
  801473:	7e 11                	jle    801486 <vprintfmt+0x1c3>
					putch(padc, putdat);
  801475:	83 ec 08             	sub    $0x8,%esp
  801478:	53                   	push   %ebx
  801479:	ff 75 e0             	pushl  -0x20(%ebp)
  80147c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80147e:	83 ef 01             	sub    $0x1,%edi
  801481:	83 c4 10             	add    $0x10,%esp
  801484:	eb eb                	jmp    801471 <vprintfmt+0x1ae>
  801486:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801489:	85 d2                	test   %edx,%edx
  80148b:	b8 00 00 00 00       	mov    $0x0,%eax
  801490:	0f 49 c2             	cmovns %edx,%eax
  801493:	29 c2                	sub    %eax,%edx
  801495:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801498:	eb a8                	jmp    801442 <vprintfmt+0x17f>
					putch(ch, putdat);
  80149a:	83 ec 08             	sub    $0x8,%esp
  80149d:	53                   	push   %ebx
  80149e:	52                   	push   %edx
  80149f:	ff d6                	call   *%esi
  8014a1:	83 c4 10             	add    $0x10,%esp
  8014a4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8014a7:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014a9:	83 c7 01             	add    $0x1,%edi
  8014ac:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8014b0:	0f be d0             	movsbl %al,%edx
  8014b3:	85 d2                	test   %edx,%edx
  8014b5:	74 4b                	je     801502 <vprintfmt+0x23f>
  8014b7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014bb:	78 06                	js     8014c3 <vprintfmt+0x200>
  8014bd:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8014c1:	78 1e                	js     8014e1 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8014c3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8014c7:	74 d1                	je     80149a <vprintfmt+0x1d7>
  8014c9:	0f be c0             	movsbl %al,%eax
  8014cc:	83 e8 20             	sub    $0x20,%eax
  8014cf:	83 f8 5e             	cmp    $0x5e,%eax
  8014d2:	76 c6                	jbe    80149a <vprintfmt+0x1d7>
					putch('?', putdat);
  8014d4:	83 ec 08             	sub    $0x8,%esp
  8014d7:	53                   	push   %ebx
  8014d8:	6a 3f                	push   $0x3f
  8014da:	ff d6                	call   *%esi
  8014dc:	83 c4 10             	add    $0x10,%esp
  8014df:	eb c3                	jmp    8014a4 <vprintfmt+0x1e1>
  8014e1:	89 cf                	mov    %ecx,%edi
  8014e3:	eb 0e                	jmp    8014f3 <vprintfmt+0x230>
				putch(' ', putdat);
  8014e5:	83 ec 08             	sub    $0x8,%esp
  8014e8:	53                   	push   %ebx
  8014e9:	6a 20                	push   $0x20
  8014eb:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8014ed:	83 ef 01             	sub    $0x1,%edi
  8014f0:	83 c4 10             	add    $0x10,%esp
  8014f3:	85 ff                	test   %edi,%edi
  8014f5:	7f ee                	jg     8014e5 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8014f7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8014fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8014fd:	e9 67 01 00 00       	jmp    801669 <vprintfmt+0x3a6>
  801502:	89 cf                	mov    %ecx,%edi
  801504:	eb ed                	jmp    8014f3 <vprintfmt+0x230>
	if (lflag >= 2)
  801506:	83 f9 01             	cmp    $0x1,%ecx
  801509:	7f 1b                	jg     801526 <vprintfmt+0x263>
	else if (lflag)
  80150b:	85 c9                	test   %ecx,%ecx
  80150d:	74 63                	je     801572 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80150f:	8b 45 14             	mov    0x14(%ebp),%eax
  801512:	8b 00                	mov    (%eax),%eax
  801514:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801517:	99                   	cltd   
  801518:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80151b:	8b 45 14             	mov    0x14(%ebp),%eax
  80151e:	8d 40 04             	lea    0x4(%eax),%eax
  801521:	89 45 14             	mov    %eax,0x14(%ebp)
  801524:	eb 17                	jmp    80153d <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801526:	8b 45 14             	mov    0x14(%ebp),%eax
  801529:	8b 50 04             	mov    0x4(%eax),%edx
  80152c:	8b 00                	mov    (%eax),%eax
  80152e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801531:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801534:	8b 45 14             	mov    0x14(%ebp),%eax
  801537:	8d 40 08             	lea    0x8(%eax),%eax
  80153a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80153d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801540:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801543:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801548:	85 c9                	test   %ecx,%ecx
  80154a:	0f 89 ff 00 00 00    	jns    80164f <vprintfmt+0x38c>
				putch('-', putdat);
  801550:	83 ec 08             	sub    $0x8,%esp
  801553:	53                   	push   %ebx
  801554:	6a 2d                	push   $0x2d
  801556:	ff d6                	call   *%esi
				num = -(long long) num;
  801558:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80155b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80155e:	f7 da                	neg    %edx
  801560:	83 d1 00             	adc    $0x0,%ecx
  801563:	f7 d9                	neg    %ecx
  801565:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801568:	b8 0a 00 00 00       	mov    $0xa,%eax
  80156d:	e9 dd 00 00 00       	jmp    80164f <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801572:	8b 45 14             	mov    0x14(%ebp),%eax
  801575:	8b 00                	mov    (%eax),%eax
  801577:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80157a:	99                   	cltd   
  80157b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80157e:	8b 45 14             	mov    0x14(%ebp),%eax
  801581:	8d 40 04             	lea    0x4(%eax),%eax
  801584:	89 45 14             	mov    %eax,0x14(%ebp)
  801587:	eb b4                	jmp    80153d <vprintfmt+0x27a>
	if (lflag >= 2)
  801589:	83 f9 01             	cmp    $0x1,%ecx
  80158c:	7f 1e                	jg     8015ac <vprintfmt+0x2e9>
	else if (lflag)
  80158e:	85 c9                	test   %ecx,%ecx
  801590:	74 32                	je     8015c4 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801592:	8b 45 14             	mov    0x14(%ebp),%eax
  801595:	8b 10                	mov    (%eax),%edx
  801597:	b9 00 00 00 00       	mov    $0x0,%ecx
  80159c:	8d 40 04             	lea    0x4(%eax),%eax
  80159f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015a2:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8015a7:	e9 a3 00 00 00       	jmp    80164f <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8015ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8015af:	8b 10                	mov    (%eax),%edx
  8015b1:	8b 48 04             	mov    0x4(%eax),%ecx
  8015b4:	8d 40 08             	lea    0x8(%eax),%eax
  8015b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015ba:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8015bf:	e9 8b 00 00 00       	jmp    80164f <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8015c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c7:	8b 10                	mov    (%eax),%edx
  8015c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015ce:	8d 40 04             	lea    0x4(%eax),%eax
  8015d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015d4:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8015d9:	eb 74                	jmp    80164f <vprintfmt+0x38c>
	if (lflag >= 2)
  8015db:	83 f9 01             	cmp    $0x1,%ecx
  8015de:	7f 1b                	jg     8015fb <vprintfmt+0x338>
	else if (lflag)
  8015e0:	85 c9                	test   %ecx,%ecx
  8015e2:	74 2c                	je     801610 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8015e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e7:	8b 10                	mov    (%eax),%edx
  8015e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015ee:	8d 40 04             	lea    0x4(%eax),%eax
  8015f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8015f4:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8015f9:	eb 54                	jmp    80164f <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8015fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8015fe:	8b 10                	mov    (%eax),%edx
  801600:	8b 48 04             	mov    0x4(%eax),%ecx
  801603:	8d 40 08             	lea    0x8(%eax),%eax
  801606:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801609:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80160e:	eb 3f                	jmp    80164f <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801610:	8b 45 14             	mov    0x14(%ebp),%eax
  801613:	8b 10                	mov    (%eax),%edx
  801615:	b9 00 00 00 00       	mov    $0x0,%ecx
  80161a:	8d 40 04             	lea    0x4(%eax),%eax
  80161d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801620:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801625:	eb 28                	jmp    80164f <vprintfmt+0x38c>
			putch('0', putdat);
  801627:	83 ec 08             	sub    $0x8,%esp
  80162a:	53                   	push   %ebx
  80162b:	6a 30                	push   $0x30
  80162d:	ff d6                	call   *%esi
			putch('x', putdat);
  80162f:	83 c4 08             	add    $0x8,%esp
  801632:	53                   	push   %ebx
  801633:	6a 78                	push   $0x78
  801635:	ff d6                	call   *%esi
			num = (unsigned long long)
  801637:	8b 45 14             	mov    0x14(%ebp),%eax
  80163a:	8b 10                	mov    (%eax),%edx
  80163c:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801641:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801644:	8d 40 04             	lea    0x4(%eax),%eax
  801647:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80164a:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80164f:	83 ec 0c             	sub    $0xc,%esp
  801652:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801656:	57                   	push   %edi
  801657:	ff 75 e0             	pushl  -0x20(%ebp)
  80165a:	50                   	push   %eax
  80165b:	51                   	push   %ecx
  80165c:	52                   	push   %edx
  80165d:	89 da                	mov    %ebx,%edx
  80165f:	89 f0                	mov    %esi,%eax
  801661:	e8 72 fb ff ff       	call   8011d8 <printnum>
			break;
  801666:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801669:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80166c:	83 c7 01             	add    $0x1,%edi
  80166f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801673:	83 f8 25             	cmp    $0x25,%eax
  801676:	0f 84 62 fc ff ff    	je     8012de <vprintfmt+0x1b>
			if (ch == '\0')
  80167c:	85 c0                	test   %eax,%eax
  80167e:	0f 84 8b 00 00 00    	je     80170f <vprintfmt+0x44c>
			putch(ch, putdat);
  801684:	83 ec 08             	sub    $0x8,%esp
  801687:	53                   	push   %ebx
  801688:	50                   	push   %eax
  801689:	ff d6                	call   *%esi
  80168b:	83 c4 10             	add    $0x10,%esp
  80168e:	eb dc                	jmp    80166c <vprintfmt+0x3a9>
	if (lflag >= 2)
  801690:	83 f9 01             	cmp    $0x1,%ecx
  801693:	7f 1b                	jg     8016b0 <vprintfmt+0x3ed>
	else if (lflag)
  801695:	85 c9                	test   %ecx,%ecx
  801697:	74 2c                	je     8016c5 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801699:	8b 45 14             	mov    0x14(%ebp),%eax
  80169c:	8b 10                	mov    (%eax),%edx
  80169e:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016a3:	8d 40 04             	lea    0x4(%eax),%eax
  8016a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016a9:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8016ae:	eb 9f                	jmp    80164f <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8016b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b3:	8b 10                	mov    (%eax),%edx
  8016b5:	8b 48 04             	mov    0x4(%eax),%ecx
  8016b8:	8d 40 08             	lea    0x8(%eax),%eax
  8016bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016be:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8016c3:	eb 8a                	jmp    80164f <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8016c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c8:	8b 10                	mov    (%eax),%edx
  8016ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016cf:	8d 40 04             	lea    0x4(%eax),%eax
  8016d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016d5:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8016da:	e9 70 ff ff ff       	jmp    80164f <vprintfmt+0x38c>
			putch(ch, putdat);
  8016df:	83 ec 08             	sub    $0x8,%esp
  8016e2:	53                   	push   %ebx
  8016e3:	6a 25                	push   $0x25
  8016e5:	ff d6                	call   *%esi
			break;
  8016e7:	83 c4 10             	add    $0x10,%esp
  8016ea:	e9 7a ff ff ff       	jmp    801669 <vprintfmt+0x3a6>
			putch('%', putdat);
  8016ef:	83 ec 08             	sub    $0x8,%esp
  8016f2:	53                   	push   %ebx
  8016f3:	6a 25                	push   $0x25
  8016f5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8016f7:	83 c4 10             	add    $0x10,%esp
  8016fa:	89 f8                	mov    %edi,%eax
  8016fc:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801700:	74 05                	je     801707 <vprintfmt+0x444>
  801702:	83 e8 01             	sub    $0x1,%eax
  801705:	eb f5                	jmp    8016fc <vprintfmt+0x439>
  801707:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80170a:	e9 5a ff ff ff       	jmp    801669 <vprintfmt+0x3a6>
}
  80170f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801712:	5b                   	pop    %ebx
  801713:	5e                   	pop    %esi
  801714:	5f                   	pop    %edi
  801715:	5d                   	pop    %ebp
  801716:	c3                   	ret    

00801717 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801717:	f3 0f 1e fb          	endbr32 
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	83 ec 18             	sub    $0x18,%esp
  801721:	8b 45 08             	mov    0x8(%ebp),%eax
  801724:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801727:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80172a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80172e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801731:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801738:	85 c0                	test   %eax,%eax
  80173a:	74 26                	je     801762 <vsnprintf+0x4b>
  80173c:	85 d2                	test   %edx,%edx
  80173e:	7e 22                	jle    801762 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801740:	ff 75 14             	pushl  0x14(%ebp)
  801743:	ff 75 10             	pushl  0x10(%ebp)
  801746:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801749:	50                   	push   %eax
  80174a:	68 81 12 80 00       	push   $0x801281
  80174f:	e8 6f fb ff ff       	call   8012c3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801754:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801757:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80175a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175d:	83 c4 10             	add    $0x10,%esp
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    
		return -E_INVAL;
  801762:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801767:	eb f7                	jmp    801760 <vsnprintf+0x49>

00801769 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801769:	f3 0f 1e fb          	endbr32 
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801773:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801776:	50                   	push   %eax
  801777:	ff 75 10             	pushl  0x10(%ebp)
  80177a:	ff 75 0c             	pushl  0xc(%ebp)
  80177d:	ff 75 08             	pushl  0x8(%ebp)
  801780:	e8 92 ff ff ff       	call   801717 <vsnprintf>
	va_end(ap);

	return rc;
}
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801787:	f3 0f 1e fb          	endbr32 
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801791:	b8 00 00 00 00       	mov    $0x0,%eax
  801796:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80179a:	74 05                	je     8017a1 <strlen+0x1a>
		n++;
  80179c:	83 c0 01             	add    $0x1,%eax
  80179f:	eb f5                	jmp    801796 <strlen+0xf>
	return n;
}
  8017a1:	5d                   	pop    %ebp
  8017a2:	c3                   	ret    

008017a3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8017a3:	f3 0f 1e fb          	endbr32 
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017ad:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8017b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b5:	39 d0                	cmp    %edx,%eax
  8017b7:	74 0d                	je     8017c6 <strnlen+0x23>
  8017b9:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8017bd:	74 05                	je     8017c4 <strnlen+0x21>
		n++;
  8017bf:	83 c0 01             	add    $0x1,%eax
  8017c2:	eb f1                	jmp    8017b5 <strnlen+0x12>
  8017c4:	89 c2                	mov    %eax,%edx
	return n;
}
  8017c6:	89 d0                	mov    %edx,%eax
  8017c8:	5d                   	pop    %ebp
  8017c9:	c3                   	ret    

008017ca <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8017ca:	f3 0f 1e fb          	endbr32 
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	53                   	push   %ebx
  8017d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8017d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017dd:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8017e1:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8017e4:	83 c0 01             	add    $0x1,%eax
  8017e7:	84 d2                	test   %dl,%dl
  8017e9:	75 f2                	jne    8017dd <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8017eb:	89 c8                	mov    %ecx,%eax
  8017ed:	5b                   	pop    %ebx
  8017ee:	5d                   	pop    %ebp
  8017ef:	c3                   	ret    

008017f0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8017f0:	f3 0f 1e fb          	endbr32 
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	53                   	push   %ebx
  8017f8:	83 ec 10             	sub    $0x10,%esp
  8017fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8017fe:	53                   	push   %ebx
  8017ff:	e8 83 ff ff ff       	call   801787 <strlen>
  801804:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801807:	ff 75 0c             	pushl  0xc(%ebp)
  80180a:	01 d8                	add    %ebx,%eax
  80180c:	50                   	push   %eax
  80180d:	e8 b8 ff ff ff       	call   8017ca <strcpy>
	return dst;
}
  801812:	89 d8                	mov    %ebx,%eax
  801814:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801819:	f3 0f 1e fb          	endbr32 
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	56                   	push   %esi
  801821:	53                   	push   %ebx
  801822:	8b 75 08             	mov    0x8(%ebp),%esi
  801825:	8b 55 0c             	mov    0xc(%ebp),%edx
  801828:	89 f3                	mov    %esi,%ebx
  80182a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80182d:	89 f0                	mov    %esi,%eax
  80182f:	39 d8                	cmp    %ebx,%eax
  801831:	74 11                	je     801844 <strncpy+0x2b>
		*dst++ = *src;
  801833:	83 c0 01             	add    $0x1,%eax
  801836:	0f b6 0a             	movzbl (%edx),%ecx
  801839:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80183c:	80 f9 01             	cmp    $0x1,%cl
  80183f:	83 da ff             	sbb    $0xffffffff,%edx
  801842:	eb eb                	jmp    80182f <strncpy+0x16>
	}
	return ret;
}
  801844:	89 f0                	mov    %esi,%eax
  801846:	5b                   	pop    %ebx
  801847:	5e                   	pop    %esi
  801848:	5d                   	pop    %ebp
  801849:	c3                   	ret    

0080184a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80184a:	f3 0f 1e fb          	endbr32 
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	56                   	push   %esi
  801852:	53                   	push   %ebx
  801853:	8b 75 08             	mov    0x8(%ebp),%esi
  801856:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801859:	8b 55 10             	mov    0x10(%ebp),%edx
  80185c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80185e:	85 d2                	test   %edx,%edx
  801860:	74 21                	je     801883 <strlcpy+0x39>
  801862:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801866:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801868:	39 c2                	cmp    %eax,%edx
  80186a:	74 14                	je     801880 <strlcpy+0x36>
  80186c:	0f b6 19             	movzbl (%ecx),%ebx
  80186f:	84 db                	test   %bl,%bl
  801871:	74 0b                	je     80187e <strlcpy+0x34>
			*dst++ = *src++;
  801873:	83 c1 01             	add    $0x1,%ecx
  801876:	83 c2 01             	add    $0x1,%edx
  801879:	88 5a ff             	mov    %bl,-0x1(%edx)
  80187c:	eb ea                	jmp    801868 <strlcpy+0x1e>
  80187e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801880:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801883:	29 f0                	sub    %esi,%eax
}
  801885:	5b                   	pop    %ebx
  801886:	5e                   	pop    %esi
  801887:	5d                   	pop    %ebp
  801888:	c3                   	ret    

00801889 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801889:	f3 0f 1e fb          	endbr32 
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801893:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801896:	0f b6 01             	movzbl (%ecx),%eax
  801899:	84 c0                	test   %al,%al
  80189b:	74 0c                	je     8018a9 <strcmp+0x20>
  80189d:	3a 02                	cmp    (%edx),%al
  80189f:	75 08                	jne    8018a9 <strcmp+0x20>
		p++, q++;
  8018a1:	83 c1 01             	add    $0x1,%ecx
  8018a4:	83 c2 01             	add    $0x1,%edx
  8018a7:	eb ed                	jmp    801896 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018a9:	0f b6 c0             	movzbl %al,%eax
  8018ac:	0f b6 12             	movzbl (%edx),%edx
  8018af:	29 d0                	sub    %edx,%eax
}
  8018b1:	5d                   	pop    %ebp
  8018b2:	c3                   	ret    

008018b3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018b3:	f3 0f 1e fb          	endbr32 
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	53                   	push   %ebx
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c1:	89 c3                	mov    %eax,%ebx
  8018c3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8018c6:	eb 06                	jmp    8018ce <strncmp+0x1b>
		n--, p++, q++;
  8018c8:	83 c0 01             	add    $0x1,%eax
  8018cb:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8018ce:	39 d8                	cmp    %ebx,%eax
  8018d0:	74 16                	je     8018e8 <strncmp+0x35>
  8018d2:	0f b6 08             	movzbl (%eax),%ecx
  8018d5:	84 c9                	test   %cl,%cl
  8018d7:	74 04                	je     8018dd <strncmp+0x2a>
  8018d9:	3a 0a                	cmp    (%edx),%cl
  8018db:	74 eb                	je     8018c8 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018dd:	0f b6 00             	movzbl (%eax),%eax
  8018e0:	0f b6 12             	movzbl (%edx),%edx
  8018e3:	29 d0                	sub    %edx,%eax
}
  8018e5:	5b                   	pop    %ebx
  8018e6:	5d                   	pop    %ebp
  8018e7:	c3                   	ret    
		return 0;
  8018e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ed:	eb f6                	jmp    8018e5 <strncmp+0x32>

008018ef <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018ef:	f3 0f 1e fb          	endbr32 
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8018fd:	0f b6 10             	movzbl (%eax),%edx
  801900:	84 d2                	test   %dl,%dl
  801902:	74 09                	je     80190d <strchr+0x1e>
		if (*s == c)
  801904:	38 ca                	cmp    %cl,%dl
  801906:	74 0a                	je     801912 <strchr+0x23>
	for (; *s; s++)
  801908:	83 c0 01             	add    $0x1,%eax
  80190b:	eb f0                	jmp    8018fd <strchr+0xe>
			return (char *) s;
	return 0;
  80190d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801912:	5d                   	pop    %ebp
  801913:	c3                   	ret    

00801914 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801914:	f3 0f 1e fb          	endbr32 
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801922:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801925:	38 ca                	cmp    %cl,%dl
  801927:	74 09                	je     801932 <strfind+0x1e>
  801929:	84 d2                	test   %dl,%dl
  80192b:	74 05                	je     801932 <strfind+0x1e>
	for (; *s; s++)
  80192d:	83 c0 01             	add    $0x1,%eax
  801930:	eb f0                	jmp    801922 <strfind+0xe>
			break;
	return (char *) s;
}
  801932:	5d                   	pop    %ebp
  801933:	c3                   	ret    

00801934 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801934:	f3 0f 1e fb          	endbr32 
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
  80193b:	57                   	push   %edi
  80193c:	56                   	push   %esi
  80193d:	53                   	push   %ebx
  80193e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801941:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801944:	85 c9                	test   %ecx,%ecx
  801946:	74 31                	je     801979 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801948:	89 f8                	mov    %edi,%eax
  80194a:	09 c8                	or     %ecx,%eax
  80194c:	a8 03                	test   $0x3,%al
  80194e:	75 23                	jne    801973 <memset+0x3f>
		c &= 0xFF;
  801950:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801954:	89 d3                	mov    %edx,%ebx
  801956:	c1 e3 08             	shl    $0x8,%ebx
  801959:	89 d0                	mov    %edx,%eax
  80195b:	c1 e0 18             	shl    $0x18,%eax
  80195e:	89 d6                	mov    %edx,%esi
  801960:	c1 e6 10             	shl    $0x10,%esi
  801963:	09 f0                	or     %esi,%eax
  801965:	09 c2                	or     %eax,%edx
  801967:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801969:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80196c:	89 d0                	mov    %edx,%eax
  80196e:	fc                   	cld    
  80196f:	f3 ab                	rep stos %eax,%es:(%edi)
  801971:	eb 06                	jmp    801979 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801973:	8b 45 0c             	mov    0xc(%ebp),%eax
  801976:	fc                   	cld    
  801977:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801979:	89 f8                	mov    %edi,%eax
  80197b:	5b                   	pop    %ebx
  80197c:	5e                   	pop    %esi
  80197d:	5f                   	pop    %edi
  80197e:	5d                   	pop    %ebp
  80197f:	c3                   	ret    

00801980 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801980:	f3 0f 1e fb          	endbr32 
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	57                   	push   %edi
  801988:	56                   	push   %esi
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80198f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801992:	39 c6                	cmp    %eax,%esi
  801994:	73 32                	jae    8019c8 <memmove+0x48>
  801996:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801999:	39 c2                	cmp    %eax,%edx
  80199b:	76 2b                	jbe    8019c8 <memmove+0x48>
		s += n;
		d += n;
  80199d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019a0:	89 fe                	mov    %edi,%esi
  8019a2:	09 ce                	or     %ecx,%esi
  8019a4:	09 d6                	or     %edx,%esi
  8019a6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8019ac:	75 0e                	jne    8019bc <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8019ae:	83 ef 04             	sub    $0x4,%edi
  8019b1:	8d 72 fc             	lea    -0x4(%edx),%esi
  8019b4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8019b7:	fd                   	std    
  8019b8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019ba:	eb 09                	jmp    8019c5 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8019bc:	83 ef 01             	sub    $0x1,%edi
  8019bf:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8019c2:	fd                   	std    
  8019c3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8019c5:	fc                   	cld    
  8019c6:	eb 1a                	jmp    8019e2 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019c8:	89 c2                	mov    %eax,%edx
  8019ca:	09 ca                	or     %ecx,%edx
  8019cc:	09 f2                	or     %esi,%edx
  8019ce:	f6 c2 03             	test   $0x3,%dl
  8019d1:	75 0a                	jne    8019dd <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8019d3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8019d6:	89 c7                	mov    %eax,%edi
  8019d8:	fc                   	cld    
  8019d9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019db:	eb 05                	jmp    8019e2 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8019dd:	89 c7                	mov    %eax,%edi
  8019df:	fc                   	cld    
  8019e0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8019e2:	5e                   	pop    %esi
  8019e3:	5f                   	pop    %edi
  8019e4:	5d                   	pop    %ebp
  8019e5:	c3                   	ret    

008019e6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8019e6:	f3 0f 1e fb          	endbr32 
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8019f0:	ff 75 10             	pushl  0x10(%ebp)
  8019f3:	ff 75 0c             	pushl  0xc(%ebp)
  8019f6:	ff 75 08             	pushl  0x8(%ebp)
  8019f9:	e8 82 ff ff ff       	call   801980 <memmove>
}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801a00:	f3 0f 1e fb          	endbr32 
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	56                   	push   %esi
  801a08:	53                   	push   %ebx
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0f:	89 c6                	mov    %eax,%esi
  801a11:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801a14:	39 f0                	cmp    %esi,%eax
  801a16:	74 1c                	je     801a34 <memcmp+0x34>
		if (*s1 != *s2)
  801a18:	0f b6 08             	movzbl (%eax),%ecx
  801a1b:	0f b6 1a             	movzbl (%edx),%ebx
  801a1e:	38 d9                	cmp    %bl,%cl
  801a20:	75 08                	jne    801a2a <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801a22:	83 c0 01             	add    $0x1,%eax
  801a25:	83 c2 01             	add    $0x1,%edx
  801a28:	eb ea                	jmp    801a14 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801a2a:	0f b6 c1             	movzbl %cl,%eax
  801a2d:	0f b6 db             	movzbl %bl,%ebx
  801a30:	29 d8                	sub    %ebx,%eax
  801a32:	eb 05                	jmp    801a39 <memcmp+0x39>
	}

	return 0;
  801a34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a39:	5b                   	pop    %ebx
  801a3a:	5e                   	pop    %esi
  801a3b:	5d                   	pop    %ebp
  801a3c:	c3                   	ret    

00801a3d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a3d:	f3 0f 1e fb          	endbr32 
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801a4a:	89 c2                	mov    %eax,%edx
  801a4c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801a4f:	39 d0                	cmp    %edx,%eax
  801a51:	73 09                	jae    801a5c <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a53:	38 08                	cmp    %cl,(%eax)
  801a55:	74 05                	je     801a5c <memfind+0x1f>
	for (; s < ends; s++)
  801a57:	83 c0 01             	add    $0x1,%eax
  801a5a:	eb f3                	jmp    801a4f <memfind+0x12>
			break;
	return (void *) s;
}
  801a5c:	5d                   	pop    %ebp
  801a5d:	c3                   	ret    

00801a5e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a5e:	f3 0f 1e fb          	endbr32 
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
  801a65:	57                   	push   %edi
  801a66:	56                   	push   %esi
  801a67:	53                   	push   %ebx
  801a68:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a6e:	eb 03                	jmp    801a73 <strtol+0x15>
		s++;
  801a70:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801a73:	0f b6 01             	movzbl (%ecx),%eax
  801a76:	3c 20                	cmp    $0x20,%al
  801a78:	74 f6                	je     801a70 <strtol+0x12>
  801a7a:	3c 09                	cmp    $0x9,%al
  801a7c:	74 f2                	je     801a70 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801a7e:	3c 2b                	cmp    $0x2b,%al
  801a80:	74 2a                	je     801aac <strtol+0x4e>
	int neg = 0;
  801a82:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801a87:	3c 2d                	cmp    $0x2d,%al
  801a89:	74 2b                	je     801ab6 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a8b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801a91:	75 0f                	jne    801aa2 <strtol+0x44>
  801a93:	80 39 30             	cmpb   $0x30,(%ecx)
  801a96:	74 28                	je     801ac0 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801a98:	85 db                	test   %ebx,%ebx
  801a9a:	b8 0a 00 00 00       	mov    $0xa,%eax
  801a9f:	0f 44 d8             	cmove  %eax,%ebx
  801aa2:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801aaa:	eb 46                	jmp    801af2 <strtol+0x94>
		s++;
  801aac:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801aaf:	bf 00 00 00 00       	mov    $0x0,%edi
  801ab4:	eb d5                	jmp    801a8b <strtol+0x2d>
		s++, neg = 1;
  801ab6:	83 c1 01             	add    $0x1,%ecx
  801ab9:	bf 01 00 00 00       	mov    $0x1,%edi
  801abe:	eb cb                	jmp    801a8b <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ac0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801ac4:	74 0e                	je     801ad4 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801ac6:	85 db                	test   %ebx,%ebx
  801ac8:	75 d8                	jne    801aa2 <strtol+0x44>
		s++, base = 8;
  801aca:	83 c1 01             	add    $0x1,%ecx
  801acd:	bb 08 00 00 00       	mov    $0x8,%ebx
  801ad2:	eb ce                	jmp    801aa2 <strtol+0x44>
		s += 2, base = 16;
  801ad4:	83 c1 02             	add    $0x2,%ecx
  801ad7:	bb 10 00 00 00       	mov    $0x10,%ebx
  801adc:	eb c4                	jmp    801aa2 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801ade:	0f be d2             	movsbl %dl,%edx
  801ae1:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801ae4:	3b 55 10             	cmp    0x10(%ebp),%edx
  801ae7:	7d 3a                	jge    801b23 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801ae9:	83 c1 01             	add    $0x1,%ecx
  801aec:	0f af 45 10          	imul   0x10(%ebp),%eax
  801af0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801af2:	0f b6 11             	movzbl (%ecx),%edx
  801af5:	8d 72 d0             	lea    -0x30(%edx),%esi
  801af8:	89 f3                	mov    %esi,%ebx
  801afa:	80 fb 09             	cmp    $0x9,%bl
  801afd:	76 df                	jbe    801ade <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801aff:	8d 72 9f             	lea    -0x61(%edx),%esi
  801b02:	89 f3                	mov    %esi,%ebx
  801b04:	80 fb 19             	cmp    $0x19,%bl
  801b07:	77 08                	ja     801b11 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801b09:	0f be d2             	movsbl %dl,%edx
  801b0c:	83 ea 57             	sub    $0x57,%edx
  801b0f:	eb d3                	jmp    801ae4 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801b11:	8d 72 bf             	lea    -0x41(%edx),%esi
  801b14:	89 f3                	mov    %esi,%ebx
  801b16:	80 fb 19             	cmp    $0x19,%bl
  801b19:	77 08                	ja     801b23 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801b1b:	0f be d2             	movsbl %dl,%edx
  801b1e:	83 ea 37             	sub    $0x37,%edx
  801b21:	eb c1                	jmp    801ae4 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801b23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b27:	74 05                	je     801b2e <strtol+0xd0>
		*endptr = (char *) s;
  801b29:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b2c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801b2e:	89 c2                	mov    %eax,%edx
  801b30:	f7 da                	neg    %edx
  801b32:	85 ff                	test   %edi,%edi
  801b34:	0f 45 c2             	cmovne %edx,%eax
}
  801b37:	5b                   	pop    %ebx
  801b38:	5e                   	pop    %esi
  801b39:	5f                   	pop    %edi
  801b3a:	5d                   	pop    %ebp
  801b3b:	c3                   	ret    

00801b3c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b3c:	f3 0f 1e fb          	endbr32 
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	56                   	push   %esi
  801b44:	53                   	push   %ebx
  801b45:	8b 75 08             	mov    0x8(%ebp),%esi
  801b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801b4e:	85 c0                	test   %eax,%eax
  801b50:	74 3d                	je     801b8f <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801b52:	83 ec 0c             	sub    $0xc,%esp
  801b55:	50                   	push   %eax
  801b56:	e8 f4 e7 ff ff       	call   80034f <sys_ipc_recv>
  801b5b:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801b5e:	85 f6                	test   %esi,%esi
  801b60:	74 0b                	je     801b6d <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b62:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b68:	8b 52 74             	mov    0x74(%edx),%edx
  801b6b:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801b6d:	85 db                	test   %ebx,%ebx
  801b6f:	74 0b                	je     801b7c <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801b71:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b77:	8b 52 78             	mov    0x78(%edx),%edx
  801b7a:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801b7c:	85 c0                	test   %eax,%eax
  801b7e:	78 21                	js     801ba1 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801b80:	a1 04 40 80 00       	mov    0x804004,%eax
  801b85:	8b 40 70             	mov    0x70(%eax),%eax
}
  801b88:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b8b:	5b                   	pop    %ebx
  801b8c:	5e                   	pop    %esi
  801b8d:	5d                   	pop    %ebp
  801b8e:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801b8f:	83 ec 0c             	sub    $0xc,%esp
  801b92:	68 00 00 c0 ee       	push   $0xeec00000
  801b97:	e8 b3 e7 ff ff       	call   80034f <sys_ipc_recv>
  801b9c:	83 c4 10             	add    $0x10,%esp
  801b9f:	eb bd                	jmp    801b5e <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801ba1:	85 f6                	test   %esi,%esi
  801ba3:	74 10                	je     801bb5 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801ba5:	85 db                	test   %ebx,%ebx
  801ba7:	75 df                	jne    801b88 <ipc_recv+0x4c>
  801ba9:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801bb0:	00 00 00 
  801bb3:	eb d3                	jmp    801b88 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801bb5:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801bbc:	00 00 00 
  801bbf:	eb e4                	jmp    801ba5 <ipc_recv+0x69>

00801bc1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bc1:	f3 0f 1e fb          	endbr32 
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
  801bc8:	57                   	push   %edi
  801bc9:	56                   	push   %esi
  801bca:	53                   	push   %ebx
  801bcb:	83 ec 0c             	sub    $0xc,%esp
  801bce:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bd1:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bd4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801bd7:	85 db                	test   %ebx,%ebx
  801bd9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801bde:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801be1:	ff 75 14             	pushl  0x14(%ebp)
  801be4:	53                   	push   %ebx
  801be5:	56                   	push   %esi
  801be6:	57                   	push   %edi
  801be7:	e8 3c e7 ff ff       	call   800328 <sys_ipc_try_send>
  801bec:	83 c4 10             	add    $0x10,%esp
  801bef:	85 c0                	test   %eax,%eax
  801bf1:	79 1e                	jns    801c11 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801bf3:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801bf6:	75 07                	jne    801bff <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801bf8:	e8 63 e5 ff ff       	call   800160 <sys_yield>
  801bfd:	eb e2                	jmp    801be1 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801bff:	50                   	push   %eax
  801c00:	68 3f 23 80 00       	push   $0x80233f
  801c05:	6a 59                	push   $0x59
  801c07:	68 5a 23 80 00       	push   $0x80235a
  801c0c:	e8 c8 f4 ff ff       	call   8010d9 <_panic>
	}
}
  801c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c14:	5b                   	pop    %ebx
  801c15:	5e                   	pop    %esi
  801c16:	5f                   	pop    %edi
  801c17:	5d                   	pop    %ebp
  801c18:	c3                   	ret    

00801c19 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c19:	f3 0f 1e fb          	endbr32 
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c23:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c28:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c2b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c31:	8b 52 50             	mov    0x50(%edx),%edx
  801c34:	39 ca                	cmp    %ecx,%edx
  801c36:	74 11                	je     801c49 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801c38:	83 c0 01             	add    $0x1,%eax
  801c3b:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c40:	75 e6                	jne    801c28 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801c42:	b8 00 00 00 00       	mov    $0x0,%eax
  801c47:	eb 0b                	jmp    801c54 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801c49:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c4c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c51:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c54:	5d                   	pop    %ebp
  801c55:	c3                   	ret    

00801c56 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c56:	f3 0f 1e fb          	endbr32 
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c60:	89 c2                	mov    %eax,%edx
  801c62:	c1 ea 16             	shr    $0x16,%edx
  801c65:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c6c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c71:	f6 c1 01             	test   $0x1,%cl
  801c74:	74 1c                	je     801c92 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801c76:	c1 e8 0c             	shr    $0xc,%eax
  801c79:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c80:	a8 01                	test   $0x1,%al
  801c82:	74 0e                	je     801c92 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c84:	c1 e8 0c             	shr    $0xc,%eax
  801c87:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801c8e:	ef 
  801c8f:	0f b7 d2             	movzwl %dx,%edx
}
  801c92:	89 d0                	mov    %edx,%eax
  801c94:	5d                   	pop    %ebp
  801c95:	c3                   	ret    
  801c96:	66 90                	xchg   %ax,%ax
  801c98:	66 90                	xchg   %ax,%ax
  801c9a:	66 90                	xchg   %ax,%ax
  801c9c:	66 90                	xchg   %ax,%ax
  801c9e:	66 90                	xchg   %ax,%ax

00801ca0 <__udivdi3>:
  801ca0:	f3 0f 1e fb          	endbr32 
  801ca4:	55                   	push   %ebp
  801ca5:	57                   	push   %edi
  801ca6:	56                   	push   %esi
  801ca7:	53                   	push   %ebx
  801ca8:	83 ec 1c             	sub    $0x1c,%esp
  801cab:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801caf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801cb3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cb7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801cbb:	85 d2                	test   %edx,%edx
  801cbd:	75 19                	jne    801cd8 <__udivdi3+0x38>
  801cbf:	39 f3                	cmp    %esi,%ebx
  801cc1:	76 4d                	jbe    801d10 <__udivdi3+0x70>
  801cc3:	31 ff                	xor    %edi,%edi
  801cc5:	89 e8                	mov    %ebp,%eax
  801cc7:	89 f2                	mov    %esi,%edx
  801cc9:	f7 f3                	div    %ebx
  801ccb:	89 fa                	mov    %edi,%edx
  801ccd:	83 c4 1c             	add    $0x1c,%esp
  801cd0:	5b                   	pop    %ebx
  801cd1:	5e                   	pop    %esi
  801cd2:	5f                   	pop    %edi
  801cd3:	5d                   	pop    %ebp
  801cd4:	c3                   	ret    
  801cd5:	8d 76 00             	lea    0x0(%esi),%esi
  801cd8:	39 f2                	cmp    %esi,%edx
  801cda:	76 14                	jbe    801cf0 <__udivdi3+0x50>
  801cdc:	31 ff                	xor    %edi,%edi
  801cde:	31 c0                	xor    %eax,%eax
  801ce0:	89 fa                	mov    %edi,%edx
  801ce2:	83 c4 1c             	add    $0x1c,%esp
  801ce5:	5b                   	pop    %ebx
  801ce6:	5e                   	pop    %esi
  801ce7:	5f                   	pop    %edi
  801ce8:	5d                   	pop    %ebp
  801ce9:	c3                   	ret    
  801cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801cf0:	0f bd fa             	bsr    %edx,%edi
  801cf3:	83 f7 1f             	xor    $0x1f,%edi
  801cf6:	75 48                	jne    801d40 <__udivdi3+0xa0>
  801cf8:	39 f2                	cmp    %esi,%edx
  801cfa:	72 06                	jb     801d02 <__udivdi3+0x62>
  801cfc:	31 c0                	xor    %eax,%eax
  801cfe:	39 eb                	cmp    %ebp,%ebx
  801d00:	77 de                	ja     801ce0 <__udivdi3+0x40>
  801d02:	b8 01 00 00 00       	mov    $0x1,%eax
  801d07:	eb d7                	jmp    801ce0 <__udivdi3+0x40>
  801d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d10:	89 d9                	mov    %ebx,%ecx
  801d12:	85 db                	test   %ebx,%ebx
  801d14:	75 0b                	jne    801d21 <__udivdi3+0x81>
  801d16:	b8 01 00 00 00       	mov    $0x1,%eax
  801d1b:	31 d2                	xor    %edx,%edx
  801d1d:	f7 f3                	div    %ebx
  801d1f:	89 c1                	mov    %eax,%ecx
  801d21:	31 d2                	xor    %edx,%edx
  801d23:	89 f0                	mov    %esi,%eax
  801d25:	f7 f1                	div    %ecx
  801d27:	89 c6                	mov    %eax,%esi
  801d29:	89 e8                	mov    %ebp,%eax
  801d2b:	89 f7                	mov    %esi,%edi
  801d2d:	f7 f1                	div    %ecx
  801d2f:	89 fa                	mov    %edi,%edx
  801d31:	83 c4 1c             	add    $0x1c,%esp
  801d34:	5b                   	pop    %ebx
  801d35:	5e                   	pop    %esi
  801d36:	5f                   	pop    %edi
  801d37:	5d                   	pop    %ebp
  801d38:	c3                   	ret    
  801d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d40:	89 f9                	mov    %edi,%ecx
  801d42:	b8 20 00 00 00       	mov    $0x20,%eax
  801d47:	29 f8                	sub    %edi,%eax
  801d49:	d3 e2                	shl    %cl,%edx
  801d4b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d4f:	89 c1                	mov    %eax,%ecx
  801d51:	89 da                	mov    %ebx,%edx
  801d53:	d3 ea                	shr    %cl,%edx
  801d55:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801d59:	09 d1                	or     %edx,%ecx
  801d5b:	89 f2                	mov    %esi,%edx
  801d5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d61:	89 f9                	mov    %edi,%ecx
  801d63:	d3 e3                	shl    %cl,%ebx
  801d65:	89 c1                	mov    %eax,%ecx
  801d67:	d3 ea                	shr    %cl,%edx
  801d69:	89 f9                	mov    %edi,%ecx
  801d6b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801d6f:	89 eb                	mov    %ebp,%ebx
  801d71:	d3 e6                	shl    %cl,%esi
  801d73:	89 c1                	mov    %eax,%ecx
  801d75:	d3 eb                	shr    %cl,%ebx
  801d77:	09 de                	or     %ebx,%esi
  801d79:	89 f0                	mov    %esi,%eax
  801d7b:	f7 74 24 08          	divl   0x8(%esp)
  801d7f:	89 d6                	mov    %edx,%esi
  801d81:	89 c3                	mov    %eax,%ebx
  801d83:	f7 64 24 0c          	mull   0xc(%esp)
  801d87:	39 d6                	cmp    %edx,%esi
  801d89:	72 15                	jb     801da0 <__udivdi3+0x100>
  801d8b:	89 f9                	mov    %edi,%ecx
  801d8d:	d3 e5                	shl    %cl,%ebp
  801d8f:	39 c5                	cmp    %eax,%ebp
  801d91:	73 04                	jae    801d97 <__udivdi3+0xf7>
  801d93:	39 d6                	cmp    %edx,%esi
  801d95:	74 09                	je     801da0 <__udivdi3+0x100>
  801d97:	89 d8                	mov    %ebx,%eax
  801d99:	31 ff                	xor    %edi,%edi
  801d9b:	e9 40 ff ff ff       	jmp    801ce0 <__udivdi3+0x40>
  801da0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801da3:	31 ff                	xor    %edi,%edi
  801da5:	e9 36 ff ff ff       	jmp    801ce0 <__udivdi3+0x40>
  801daa:	66 90                	xchg   %ax,%ax
  801dac:	66 90                	xchg   %ax,%ax
  801dae:	66 90                	xchg   %ax,%ax

00801db0 <__umoddi3>:
  801db0:	f3 0f 1e fb          	endbr32 
  801db4:	55                   	push   %ebp
  801db5:	57                   	push   %edi
  801db6:	56                   	push   %esi
  801db7:	53                   	push   %ebx
  801db8:	83 ec 1c             	sub    $0x1c,%esp
  801dbb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801dbf:	8b 74 24 30          	mov    0x30(%esp),%esi
  801dc3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801dc7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dcb:	85 c0                	test   %eax,%eax
  801dcd:	75 19                	jne    801de8 <__umoddi3+0x38>
  801dcf:	39 df                	cmp    %ebx,%edi
  801dd1:	76 5d                	jbe    801e30 <__umoddi3+0x80>
  801dd3:	89 f0                	mov    %esi,%eax
  801dd5:	89 da                	mov    %ebx,%edx
  801dd7:	f7 f7                	div    %edi
  801dd9:	89 d0                	mov    %edx,%eax
  801ddb:	31 d2                	xor    %edx,%edx
  801ddd:	83 c4 1c             	add    $0x1c,%esp
  801de0:	5b                   	pop    %ebx
  801de1:	5e                   	pop    %esi
  801de2:	5f                   	pop    %edi
  801de3:	5d                   	pop    %ebp
  801de4:	c3                   	ret    
  801de5:	8d 76 00             	lea    0x0(%esi),%esi
  801de8:	89 f2                	mov    %esi,%edx
  801dea:	39 d8                	cmp    %ebx,%eax
  801dec:	76 12                	jbe    801e00 <__umoddi3+0x50>
  801dee:	89 f0                	mov    %esi,%eax
  801df0:	89 da                	mov    %ebx,%edx
  801df2:	83 c4 1c             	add    $0x1c,%esp
  801df5:	5b                   	pop    %ebx
  801df6:	5e                   	pop    %esi
  801df7:	5f                   	pop    %edi
  801df8:	5d                   	pop    %ebp
  801df9:	c3                   	ret    
  801dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e00:	0f bd e8             	bsr    %eax,%ebp
  801e03:	83 f5 1f             	xor    $0x1f,%ebp
  801e06:	75 50                	jne    801e58 <__umoddi3+0xa8>
  801e08:	39 d8                	cmp    %ebx,%eax
  801e0a:	0f 82 e0 00 00 00    	jb     801ef0 <__umoddi3+0x140>
  801e10:	89 d9                	mov    %ebx,%ecx
  801e12:	39 f7                	cmp    %esi,%edi
  801e14:	0f 86 d6 00 00 00    	jbe    801ef0 <__umoddi3+0x140>
  801e1a:	89 d0                	mov    %edx,%eax
  801e1c:	89 ca                	mov    %ecx,%edx
  801e1e:	83 c4 1c             	add    $0x1c,%esp
  801e21:	5b                   	pop    %ebx
  801e22:	5e                   	pop    %esi
  801e23:	5f                   	pop    %edi
  801e24:	5d                   	pop    %ebp
  801e25:	c3                   	ret    
  801e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e2d:	8d 76 00             	lea    0x0(%esi),%esi
  801e30:	89 fd                	mov    %edi,%ebp
  801e32:	85 ff                	test   %edi,%edi
  801e34:	75 0b                	jne    801e41 <__umoddi3+0x91>
  801e36:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3b:	31 d2                	xor    %edx,%edx
  801e3d:	f7 f7                	div    %edi
  801e3f:	89 c5                	mov    %eax,%ebp
  801e41:	89 d8                	mov    %ebx,%eax
  801e43:	31 d2                	xor    %edx,%edx
  801e45:	f7 f5                	div    %ebp
  801e47:	89 f0                	mov    %esi,%eax
  801e49:	f7 f5                	div    %ebp
  801e4b:	89 d0                	mov    %edx,%eax
  801e4d:	31 d2                	xor    %edx,%edx
  801e4f:	eb 8c                	jmp    801ddd <__umoddi3+0x2d>
  801e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e58:	89 e9                	mov    %ebp,%ecx
  801e5a:	ba 20 00 00 00       	mov    $0x20,%edx
  801e5f:	29 ea                	sub    %ebp,%edx
  801e61:	d3 e0                	shl    %cl,%eax
  801e63:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e67:	89 d1                	mov    %edx,%ecx
  801e69:	89 f8                	mov    %edi,%eax
  801e6b:	d3 e8                	shr    %cl,%eax
  801e6d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e71:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e75:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e79:	09 c1                	or     %eax,%ecx
  801e7b:	89 d8                	mov    %ebx,%eax
  801e7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e81:	89 e9                	mov    %ebp,%ecx
  801e83:	d3 e7                	shl    %cl,%edi
  801e85:	89 d1                	mov    %edx,%ecx
  801e87:	d3 e8                	shr    %cl,%eax
  801e89:	89 e9                	mov    %ebp,%ecx
  801e8b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e8f:	d3 e3                	shl    %cl,%ebx
  801e91:	89 c7                	mov    %eax,%edi
  801e93:	89 d1                	mov    %edx,%ecx
  801e95:	89 f0                	mov    %esi,%eax
  801e97:	d3 e8                	shr    %cl,%eax
  801e99:	89 e9                	mov    %ebp,%ecx
  801e9b:	89 fa                	mov    %edi,%edx
  801e9d:	d3 e6                	shl    %cl,%esi
  801e9f:	09 d8                	or     %ebx,%eax
  801ea1:	f7 74 24 08          	divl   0x8(%esp)
  801ea5:	89 d1                	mov    %edx,%ecx
  801ea7:	89 f3                	mov    %esi,%ebx
  801ea9:	f7 64 24 0c          	mull   0xc(%esp)
  801ead:	89 c6                	mov    %eax,%esi
  801eaf:	89 d7                	mov    %edx,%edi
  801eb1:	39 d1                	cmp    %edx,%ecx
  801eb3:	72 06                	jb     801ebb <__umoddi3+0x10b>
  801eb5:	75 10                	jne    801ec7 <__umoddi3+0x117>
  801eb7:	39 c3                	cmp    %eax,%ebx
  801eb9:	73 0c                	jae    801ec7 <__umoddi3+0x117>
  801ebb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801ebf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801ec3:	89 d7                	mov    %edx,%edi
  801ec5:	89 c6                	mov    %eax,%esi
  801ec7:	89 ca                	mov    %ecx,%edx
  801ec9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801ece:	29 f3                	sub    %esi,%ebx
  801ed0:	19 fa                	sbb    %edi,%edx
  801ed2:	89 d0                	mov    %edx,%eax
  801ed4:	d3 e0                	shl    %cl,%eax
  801ed6:	89 e9                	mov    %ebp,%ecx
  801ed8:	d3 eb                	shr    %cl,%ebx
  801eda:	d3 ea                	shr    %cl,%edx
  801edc:	09 d8                	or     %ebx,%eax
  801ede:	83 c4 1c             	add    $0x1c,%esp
  801ee1:	5b                   	pop    %ebx
  801ee2:	5e                   	pop    %esi
  801ee3:	5f                   	pop    %edi
  801ee4:	5d                   	pop    %ebp
  801ee5:	c3                   	ret    
  801ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801eed:	8d 76 00             	lea    0x0(%esi),%esi
  801ef0:	29 fe                	sub    %edi,%esi
  801ef2:	19 c3                	sbb    %eax,%ebx
  801ef4:	89 f2                	mov    %esi,%edx
  801ef6:	89 d9                	mov    %ebx,%ecx
  801ef8:	e9 1d ff ff ff       	jmp    801e1a <__umoddi3+0x6a>
