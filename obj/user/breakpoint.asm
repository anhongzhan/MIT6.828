
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
  800040:	56                   	push   %esi
  800041:	53                   	push   %ebx
  800042:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800045:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800048:	e8 d6 00 00 00       	call   800123 <sys_getenvid>
  80004d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800052:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800055:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005a:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005f:	85 db                	test   %ebx,%ebx
  800061:	7e 07                	jle    80006a <libmain+0x31>
		binaryname = argv[0];
  800063:	8b 06                	mov    (%esi),%eax
  800065:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	56                   	push   %esi
  80006e:	53                   	push   %ebx
  80006f:	e8 bf ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800074:	e8 0a 00 00 00       	call   800083 <exit>
}
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007f:	5b                   	pop    %ebx
  800080:	5e                   	pop    %esi
  800081:	5d                   	pop    %ebp
  800082:	c3                   	ret    

00800083 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800083:	f3 0f 1e fb          	endbr32 
  800087:	55                   	push   %ebp
  800088:	89 e5                	mov    %esp,%ebp
  80008a:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  80008d:	6a 00                	push   $0x0
  80008f:	e8 4a 00 00 00       	call   8000de <sys_env_destroy>
}
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	c9                   	leave  
  800098:	c3                   	ret    

00800099 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800099:	f3 0f 1e fb          	endbr32 
  80009d:	55                   	push   %ebp
  80009e:	89 e5                	mov    %esp,%ebp
  8000a0:	57                   	push   %edi
  8000a1:	56                   	push   %esi
  8000a2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ae:	89 c3                	mov    %eax,%ebx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 c6                	mov    %eax,%esi
  8000b4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b6:	5b                   	pop    %ebx
  8000b7:	5e                   	pop    %esi
  8000b8:	5f                   	pop    %edi
  8000b9:	5d                   	pop    %ebp
  8000ba:	c3                   	ret    

008000bb <sys_cgetc>:

int
sys_cgetc(void)
{
  8000bb:	f3 0f 1e fb          	endbr32 
  8000bf:	55                   	push   %ebp
  8000c0:	89 e5                	mov    %esp,%ebp
  8000c2:	57                   	push   %edi
  8000c3:	56                   	push   %esi
  8000c4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8000cf:	89 d1                	mov    %edx,%ecx
  8000d1:	89 d3                	mov    %edx,%ebx
  8000d3:	89 d7                	mov    %edx,%edi
  8000d5:	89 d6                	mov    %edx,%esi
  8000d7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d9:	5b                   	pop    %ebx
  8000da:	5e                   	pop    %esi
  8000db:	5f                   	pop    %edi
  8000dc:	5d                   	pop    %ebp
  8000dd:	c3                   	ret    

008000de <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000de:	f3 0f 1e fb          	endbr32 
  8000e2:	55                   	push   %ebp
  8000e3:	89 e5                	mov    %esp,%ebp
  8000e5:	57                   	push   %edi
  8000e6:	56                   	push   %esi
  8000e7:	53                   	push   %ebx
  8000e8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f3:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f8:	89 cb                	mov    %ecx,%ebx
  8000fa:	89 cf                	mov    %ecx,%edi
  8000fc:	89 ce                	mov    %ecx,%esi
  8000fe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800100:	85 c0                	test   %eax,%eax
  800102:	7f 08                	jg     80010c <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800104:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800107:	5b                   	pop    %ebx
  800108:	5e                   	pop    %esi
  800109:	5f                   	pop    %edi
  80010a:	5d                   	pop    %ebp
  80010b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	50                   	push   %eax
  800110:	6a 03                	push   $0x3
  800112:	68 0a 10 80 00       	push   $0x80100a
  800117:	6a 23                	push   $0x23
  800119:	68 27 10 80 00       	push   $0x801027
  80011e:	e8 11 02 00 00       	call   800334 <_panic>

00800123 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800123:	f3 0f 1e fb          	endbr32 
  800127:	55                   	push   %ebp
  800128:	89 e5                	mov    %esp,%ebp
  80012a:	57                   	push   %edi
  80012b:	56                   	push   %esi
  80012c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80012d:	ba 00 00 00 00       	mov    $0x0,%edx
  800132:	b8 02 00 00 00       	mov    $0x2,%eax
  800137:	89 d1                	mov    %edx,%ecx
  800139:	89 d3                	mov    %edx,%ebx
  80013b:	89 d7                	mov    %edx,%edi
  80013d:	89 d6                	mov    %edx,%esi
  80013f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800141:	5b                   	pop    %ebx
  800142:	5e                   	pop    %esi
  800143:	5f                   	pop    %edi
  800144:	5d                   	pop    %ebp
  800145:	c3                   	ret    

00800146 <sys_yield>:

void
sys_yield(void)
{
  800146:	f3 0f 1e fb          	endbr32 
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	57                   	push   %edi
  80014e:	56                   	push   %esi
  80014f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800150:	ba 00 00 00 00       	mov    $0x0,%edx
  800155:	b8 0a 00 00 00       	mov    $0xa,%eax
  80015a:	89 d1                	mov    %edx,%ecx
  80015c:	89 d3                	mov    %edx,%ebx
  80015e:	89 d7                	mov    %edx,%edi
  800160:	89 d6                	mov    %edx,%esi
  800162:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800164:	5b                   	pop    %ebx
  800165:	5e                   	pop    %esi
  800166:	5f                   	pop    %edi
  800167:	5d                   	pop    %ebp
  800168:	c3                   	ret    

00800169 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800169:	f3 0f 1e fb          	endbr32 
  80016d:	55                   	push   %ebp
  80016e:	89 e5                	mov    %esp,%ebp
  800170:	57                   	push   %edi
  800171:	56                   	push   %esi
  800172:	53                   	push   %ebx
  800173:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800176:	be 00 00 00 00       	mov    $0x0,%esi
  80017b:	8b 55 08             	mov    0x8(%ebp),%edx
  80017e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800181:	b8 04 00 00 00       	mov    $0x4,%eax
  800186:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800189:	89 f7                	mov    %esi,%edi
  80018b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80018d:	85 c0                	test   %eax,%eax
  80018f:	7f 08                	jg     800199 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800191:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800194:	5b                   	pop    %ebx
  800195:	5e                   	pop    %esi
  800196:	5f                   	pop    %edi
  800197:	5d                   	pop    %ebp
  800198:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800199:	83 ec 0c             	sub    $0xc,%esp
  80019c:	50                   	push   %eax
  80019d:	6a 04                	push   $0x4
  80019f:	68 0a 10 80 00       	push   $0x80100a
  8001a4:	6a 23                	push   $0x23
  8001a6:	68 27 10 80 00       	push   $0x801027
  8001ab:	e8 84 01 00 00       	call   800334 <_panic>

008001b0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001b0:	f3 0f 1e fb          	endbr32 
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	57                   	push   %edi
  8001b8:	56                   	push   %esi
  8001b9:	53                   	push   %ebx
  8001ba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8001c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001c3:	b8 05 00 00 00       	mov    $0x5,%eax
  8001c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001cb:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001ce:	8b 75 18             	mov    0x18(%ebp),%esi
  8001d1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001d3:	85 c0                	test   %eax,%eax
  8001d5:	7f 08                	jg     8001df <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001da:	5b                   	pop    %ebx
  8001db:	5e                   	pop    %esi
  8001dc:	5f                   	pop    %edi
  8001dd:	5d                   	pop    %ebp
  8001de:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001df:	83 ec 0c             	sub    $0xc,%esp
  8001e2:	50                   	push   %eax
  8001e3:	6a 05                	push   $0x5
  8001e5:	68 0a 10 80 00       	push   $0x80100a
  8001ea:	6a 23                	push   $0x23
  8001ec:	68 27 10 80 00       	push   $0x801027
  8001f1:	e8 3e 01 00 00       	call   800334 <_panic>

008001f6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001f6:	f3 0f 1e fb          	endbr32 
  8001fa:	55                   	push   %ebp
  8001fb:	89 e5                	mov    %esp,%ebp
  8001fd:	57                   	push   %edi
  8001fe:	56                   	push   %esi
  8001ff:	53                   	push   %ebx
  800200:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800203:	bb 00 00 00 00       	mov    $0x0,%ebx
  800208:	8b 55 08             	mov    0x8(%ebp),%edx
  80020b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80020e:	b8 06 00 00 00       	mov    $0x6,%eax
  800213:	89 df                	mov    %ebx,%edi
  800215:	89 de                	mov    %ebx,%esi
  800217:	cd 30                	int    $0x30
	if(check && ret > 0)
  800219:	85 c0                	test   %eax,%eax
  80021b:	7f 08                	jg     800225 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80021d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800220:	5b                   	pop    %ebx
  800221:	5e                   	pop    %esi
  800222:	5f                   	pop    %edi
  800223:	5d                   	pop    %ebp
  800224:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800225:	83 ec 0c             	sub    $0xc,%esp
  800228:	50                   	push   %eax
  800229:	6a 06                	push   $0x6
  80022b:	68 0a 10 80 00       	push   $0x80100a
  800230:	6a 23                	push   $0x23
  800232:	68 27 10 80 00       	push   $0x801027
  800237:	e8 f8 00 00 00       	call   800334 <_panic>

0080023c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80023c:	f3 0f 1e fb          	endbr32 
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	57                   	push   %edi
  800244:	56                   	push   %esi
  800245:	53                   	push   %ebx
  800246:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800249:	bb 00 00 00 00       	mov    $0x0,%ebx
  80024e:	8b 55 08             	mov    0x8(%ebp),%edx
  800251:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800254:	b8 08 00 00 00       	mov    $0x8,%eax
  800259:	89 df                	mov    %ebx,%edi
  80025b:	89 de                	mov    %ebx,%esi
  80025d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80025f:	85 c0                	test   %eax,%eax
  800261:	7f 08                	jg     80026b <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800263:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800266:	5b                   	pop    %ebx
  800267:	5e                   	pop    %esi
  800268:	5f                   	pop    %edi
  800269:	5d                   	pop    %ebp
  80026a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	50                   	push   %eax
  80026f:	6a 08                	push   $0x8
  800271:	68 0a 10 80 00       	push   $0x80100a
  800276:	6a 23                	push   $0x23
  800278:	68 27 10 80 00       	push   $0x801027
  80027d:	e8 b2 00 00 00       	call   800334 <_panic>

00800282 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800282:	f3 0f 1e fb          	endbr32 
  800286:	55                   	push   %ebp
  800287:	89 e5                	mov    %esp,%ebp
  800289:	57                   	push   %edi
  80028a:	56                   	push   %esi
  80028b:	53                   	push   %ebx
  80028c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80028f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800294:	8b 55 08             	mov    0x8(%ebp),%edx
  800297:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80029a:	b8 09 00 00 00       	mov    $0x9,%eax
  80029f:	89 df                	mov    %ebx,%edi
  8002a1:	89 de                	mov    %ebx,%esi
  8002a3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002a5:	85 c0                	test   %eax,%eax
  8002a7:	7f 08                	jg     8002b1 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ac:	5b                   	pop    %ebx
  8002ad:	5e                   	pop    %esi
  8002ae:	5f                   	pop    %edi
  8002af:	5d                   	pop    %ebp
  8002b0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002b1:	83 ec 0c             	sub    $0xc,%esp
  8002b4:	50                   	push   %eax
  8002b5:	6a 09                	push   $0x9
  8002b7:	68 0a 10 80 00       	push   $0x80100a
  8002bc:	6a 23                	push   $0x23
  8002be:	68 27 10 80 00       	push   $0x801027
  8002c3:	e8 6c 00 00 00       	call   800334 <_panic>

008002c8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002c8:	f3 0f 1e fb          	endbr32 
  8002cc:	55                   	push   %ebp
  8002cd:	89 e5                	mov    %esp,%ebp
  8002cf:	57                   	push   %edi
  8002d0:	56                   	push   %esi
  8002d1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d8:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002dd:	be 00 00 00 00       	mov    $0x0,%esi
  8002e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002e5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002e8:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002ea:	5b                   	pop    %ebx
  8002eb:	5e                   	pop    %esi
  8002ec:	5f                   	pop    %edi
  8002ed:	5d                   	pop    %ebp
  8002ee:	c3                   	ret    

008002ef <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002ef:	f3 0f 1e fb          	endbr32 
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	57                   	push   %edi
  8002f7:	56                   	push   %esi
  8002f8:	53                   	push   %ebx
  8002f9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800301:	8b 55 08             	mov    0x8(%ebp),%edx
  800304:	b8 0c 00 00 00       	mov    $0xc,%eax
  800309:	89 cb                	mov    %ecx,%ebx
  80030b:	89 cf                	mov    %ecx,%edi
  80030d:	89 ce                	mov    %ecx,%esi
  80030f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800311:	85 c0                	test   %eax,%eax
  800313:	7f 08                	jg     80031d <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800315:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800318:	5b                   	pop    %ebx
  800319:	5e                   	pop    %esi
  80031a:	5f                   	pop    %edi
  80031b:	5d                   	pop    %ebp
  80031c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80031d:	83 ec 0c             	sub    $0xc,%esp
  800320:	50                   	push   %eax
  800321:	6a 0c                	push   $0xc
  800323:	68 0a 10 80 00       	push   $0x80100a
  800328:	6a 23                	push   $0x23
  80032a:	68 27 10 80 00       	push   $0x801027
  80032f:	e8 00 00 00 00       	call   800334 <_panic>

00800334 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800334:	f3 0f 1e fb          	endbr32 
  800338:	55                   	push   %ebp
  800339:	89 e5                	mov    %esp,%ebp
  80033b:	56                   	push   %esi
  80033c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80033d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800340:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800346:	e8 d8 fd ff ff       	call   800123 <sys_getenvid>
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	ff 75 0c             	pushl  0xc(%ebp)
  800351:	ff 75 08             	pushl  0x8(%ebp)
  800354:	56                   	push   %esi
  800355:	50                   	push   %eax
  800356:	68 38 10 80 00       	push   $0x801038
  80035b:	e8 bb 00 00 00       	call   80041b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800360:	83 c4 18             	add    $0x18,%esp
  800363:	53                   	push   %ebx
  800364:	ff 75 10             	pushl  0x10(%ebp)
  800367:	e8 5a 00 00 00       	call   8003c6 <vcprintf>
	cprintf("\n");
  80036c:	c7 04 24 5b 10 80 00 	movl   $0x80105b,(%esp)
  800373:	e8 a3 00 00 00       	call   80041b <cprintf>
  800378:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80037b:	cc                   	int3   
  80037c:	eb fd                	jmp    80037b <_panic+0x47>

0080037e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80037e:	f3 0f 1e fb          	endbr32 
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	53                   	push   %ebx
  800386:	83 ec 04             	sub    $0x4,%esp
  800389:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80038c:	8b 13                	mov    (%ebx),%edx
  80038e:	8d 42 01             	lea    0x1(%edx),%eax
  800391:	89 03                	mov    %eax,(%ebx)
  800393:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800396:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80039a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80039f:	74 09                	je     8003aa <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003a1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003a8:	c9                   	leave  
  8003a9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003aa:	83 ec 08             	sub    $0x8,%esp
  8003ad:	68 ff 00 00 00       	push   $0xff
  8003b2:	8d 43 08             	lea    0x8(%ebx),%eax
  8003b5:	50                   	push   %eax
  8003b6:	e8 de fc ff ff       	call   800099 <sys_cputs>
		b->idx = 0;
  8003bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003c1:	83 c4 10             	add    $0x10,%esp
  8003c4:	eb db                	jmp    8003a1 <putch+0x23>

008003c6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003c6:	f3 0f 1e fb          	endbr32 
  8003ca:	55                   	push   %ebp
  8003cb:	89 e5                	mov    %esp,%ebp
  8003cd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003d3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003da:	00 00 00 
	b.cnt = 0;
  8003dd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003e4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003e7:	ff 75 0c             	pushl  0xc(%ebp)
  8003ea:	ff 75 08             	pushl  0x8(%ebp)
  8003ed:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003f3:	50                   	push   %eax
  8003f4:	68 7e 03 80 00       	push   $0x80037e
  8003f9:	e8 20 01 00 00       	call   80051e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003fe:	83 c4 08             	add    $0x8,%esp
  800401:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800407:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80040d:	50                   	push   %eax
  80040e:	e8 86 fc ff ff       	call   800099 <sys_cputs>

	return b.cnt;
}
  800413:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800419:	c9                   	leave  
  80041a:	c3                   	ret    

0080041b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80041b:	f3 0f 1e fb          	endbr32 
  80041f:	55                   	push   %ebp
  800420:	89 e5                	mov    %esp,%ebp
  800422:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800425:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800428:	50                   	push   %eax
  800429:	ff 75 08             	pushl  0x8(%ebp)
  80042c:	e8 95 ff ff ff       	call   8003c6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800431:	c9                   	leave  
  800432:	c3                   	ret    

00800433 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	57                   	push   %edi
  800437:	56                   	push   %esi
  800438:	53                   	push   %ebx
  800439:	83 ec 1c             	sub    $0x1c,%esp
  80043c:	89 c7                	mov    %eax,%edi
  80043e:	89 d6                	mov    %edx,%esi
  800440:	8b 45 08             	mov    0x8(%ebp),%eax
  800443:	8b 55 0c             	mov    0xc(%ebp),%edx
  800446:	89 d1                	mov    %edx,%ecx
  800448:	89 c2                	mov    %eax,%edx
  80044a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80044d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800450:	8b 45 10             	mov    0x10(%ebp),%eax
  800453:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800456:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800459:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800460:	39 c2                	cmp    %eax,%edx
  800462:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800465:	72 3e                	jb     8004a5 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800467:	83 ec 0c             	sub    $0xc,%esp
  80046a:	ff 75 18             	pushl  0x18(%ebp)
  80046d:	83 eb 01             	sub    $0x1,%ebx
  800470:	53                   	push   %ebx
  800471:	50                   	push   %eax
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	ff 75 e4             	pushl  -0x1c(%ebp)
  800478:	ff 75 e0             	pushl  -0x20(%ebp)
  80047b:	ff 75 dc             	pushl  -0x24(%ebp)
  80047e:	ff 75 d8             	pushl  -0x28(%ebp)
  800481:	e8 1a 09 00 00       	call   800da0 <__udivdi3>
  800486:	83 c4 18             	add    $0x18,%esp
  800489:	52                   	push   %edx
  80048a:	50                   	push   %eax
  80048b:	89 f2                	mov    %esi,%edx
  80048d:	89 f8                	mov    %edi,%eax
  80048f:	e8 9f ff ff ff       	call   800433 <printnum>
  800494:	83 c4 20             	add    $0x20,%esp
  800497:	eb 13                	jmp    8004ac <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800499:	83 ec 08             	sub    $0x8,%esp
  80049c:	56                   	push   %esi
  80049d:	ff 75 18             	pushl  0x18(%ebp)
  8004a0:	ff d7                	call   *%edi
  8004a2:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004a5:	83 eb 01             	sub    $0x1,%ebx
  8004a8:	85 db                	test   %ebx,%ebx
  8004aa:	7f ed                	jg     800499 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004ac:	83 ec 08             	sub    $0x8,%esp
  8004af:	56                   	push   %esi
  8004b0:	83 ec 04             	sub    $0x4,%esp
  8004b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b9:	ff 75 dc             	pushl  -0x24(%ebp)
  8004bc:	ff 75 d8             	pushl  -0x28(%ebp)
  8004bf:	e8 ec 09 00 00       	call   800eb0 <__umoddi3>
  8004c4:	83 c4 14             	add    $0x14,%esp
  8004c7:	0f be 80 5d 10 80 00 	movsbl 0x80105d(%eax),%eax
  8004ce:	50                   	push   %eax
  8004cf:	ff d7                	call   *%edi
}
  8004d1:	83 c4 10             	add    $0x10,%esp
  8004d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004d7:	5b                   	pop    %ebx
  8004d8:	5e                   	pop    %esi
  8004d9:	5f                   	pop    %edi
  8004da:	5d                   	pop    %ebp
  8004db:	c3                   	ret    

008004dc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004dc:	f3 0f 1e fb          	endbr32 
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
  8004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004e6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004ea:	8b 10                	mov    (%eax),%edx
  8004ec:	3b 50 04             	cmp    0x4(%eax),%edx
  8004ef:	73 0a                	jae    8004fb <sprintputch+0x1f>
		*b->buf++ = ch;
  8004f1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004f4:	89 08                	mov    %ecx,(%eax)
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	88 02                	mov    %al,(%edx)
}
  8004fb:	5d                   	pop    %ebp
  8004fc:	c3                   	ret    

008004fd <printfmt>:
{
  8004fd:	f3 0f 1e fb          	endbr32 
  800501:	55                   	push   %ebp
  800502:	89 e5                	mov    %esp,%ebp
  800504:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800507:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80050a:	50                   	push   %eax
  80050b:	ff 75 10             	pushl  0x10(%ebp)
  80050e:	ff 75 0c             	pushl  0xc(%ebp)
  800511:	ff 75 08             	pushl  0x8(%ebp)
  800514:	e8 05 00 00 00       	call   80051e <vprintfmt>
}
  800519:	83 c4 10             	add    $0x10,%esp
  80051c:	c9                   	leave  
  80051d:	c3                   	ret    

0080051e <vprintfmt>:
{
  80051e:	f3 0f 1e fb          	endbr32 
  800522:	55                   	push   %ebp
  800523:	89 e5                	mov    %esp,%ebp
  800525:	57                   	push   %edi
  800526:	56                   	push   %esi
  800527:	53                   	push   %ebx
  800528:	83 ec 3c             	sub    $0x3c,%esp
  80052b:	8b 75 08             	mov    0x8(%ebp),%esi
  80052e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800531:	8b 7d 10             	mov    0x10(%ebp),%edi
  800534:	e9 8e 03 00 00       	jmp    8008c7 <vprintfmt+0x3a9>
		padc = ' ';
  800539:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80053d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800544:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80054b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800552:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800557:	8d 47 01             	lea    0x1(%edi),%eax
  80055a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80055d:	0f b6 17             	movzbl (%edi),%edx
  800560:	8d 42 dd             	lea    -0x23(%edx),%eax
  800563:	3c 55                	cmp    $0x55,%al
  800565:	0f 87 df 03 00 00    	ja     80094a <vprintfmt+0x42c>
  80056b:	0f b6 c0             	movzbl %al,%eax
  80056e:	3e ff 24 85 20 11 80 	notrack jmp *0x801120(,%eax,4)
  800575:	00 
  800576:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800579:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80057d:	eb d8                	jmp    800557 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80057f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800582:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800586:	eb cf                	jmp    800557 <vprintfmt+0x39>
  800588:	0f b6 d2             	movzbl %dl,%edx
  80058b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80058e:	b8 00 00 00 00       	mov    $0x0,%eax
  800593:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800596:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800599:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80059d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005a0:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005a3:	83 f9 09             	cmp    $0x9,%ecx
  8005a6:	77 55                	ja     8005fd <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8005a8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005ab:	eb e9                	jmp    800596 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	8b 00                	mov    (%eax),%eax
  8005b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b8:	8d 40 04             	lea    0x4(%eax),%eax
  8005bb:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005c1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005c5:	79 90                	jns    800557 <vprintfmt+0x39>
				width = precision, precision = -1;
  8005c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005cd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005d4:	eb 81                	jmp    800557 <vprintfmt+0x39>
  8005d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d9:	85 c0                	test   %eax,%eax
  8005db:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e0:	0f 49 d0             	cmovns %eax,%edx
  8005e3:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005e9:	e9 69 ff ff ff       	jmp    800557 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8005ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005f1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8005f8:	e9 5a ff ff ff       	jmp    800557 <vprintfmt+0x39>
  8005fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800600:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800603:	eb bc                	jmp    8005c1 <vprintfmt+0xa3>
			lflag++;
  800605:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800608:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80060b:	e9 47 ff ff ff       	jmp    800557 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8d 78 04             	lea    0x4(%eax),%edi
  800616:	83 ec 08             	sub    $0x8,%esp
  800619:	53                   	push   %ebx
  80061a:	ff 30                	pushl  (%eax)
  80061c:	ff d6                	call   *%esi
			break;
  80061e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800621:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800624:	e9 9b 02 00 00       	jmp    8008c4 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800629:	8b 45 14             	mov    0x14(%ebp),%eax
  80062c:	8d 78 04             	lea    0x4(%eax),%edi
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	99                   	cltd   
  800632:	31 d0                	xor    %edx,%eax
  800634:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800636:	83 f8 08             	cmp    $0x8,%eax
  800639:	7f 23                	jg     80065e <vprintfmt+0x140>
  80063b:	8b 14 85 80 12 80 00 	mov    0x801280(,%eax,4),%edx
  800642:	85 d2                	test   %edx,%edx
  800644:	74 18                	je     80065e <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800646:	52                   	push   %edx
  800647:	68 7e 10 80 00       	push   $0x80107e
  80064c:	53                   	push   %ebx
  80064d:	56                   	push   %esi
  80064e:	e8 aa fe ff ff       	call   8004fd <printfmt>
  800653:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800656:	89 7d 14             	mov    %edi,0x14(%ebp)
  800659:	e9 66 02 00 00       	jmp    8008c4 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80065e:	50                   	push   %eax
  80065f:	68 75 10 80 00       	push   $0x801075
  800664:	53                   	push   %ebx
  800665:	56                   	push   %esi
  800666:	e8 92 fe ff ff       	call   8004fd <printfmt>
  80066b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80066e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800671:	e9 4e 02 00 00       	jmp    8008c4 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	83 c0 04             	add    $0x4,%eax
  80067c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800684:	85 d2                	test   %edx,%edx
  800686:	b8 6e 10 80 00       	mov    $0x80106e,%eax
  80068b:	0f 45 c2             	cmovne %edx,%eax
  80068e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800691:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800695:	7e 06                	jle    80069d <vprintfmt+0x17f>
  800697:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80069b:	75 0d                	jne    8006aa <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80069d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006a0:	89 c7                	mov    %eax,%edi
  8006a2:	03 45 e0             	add    -0x20(%ebp),%eax
  8006a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a8:	eb 55                	jmp    8006ff <vprintfmt+0x1e1>
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8006b0:	ff 75 cc             	pushl  -0x34(%ebp)
  8006b3:	e8 46 03 00 00       	call   8009fe <strnlen>
  8006b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006bb:	29 c2                	sub    %eax,%edx
  8006bd:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006c0:	83 c4 10             	add    $0x10,%esp
  8006c3:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006c5:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006cc:	85 ff                	test   %edi,%edi
  8006ce:	7e 11                	jle    8006e1 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	53                   	push   %ebx
  8006d4:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d9:	83 ef 01             	sub    $0x1,%edi
  8006dc:	83 c4 10             	add    $0x10,%esp
  8006df:	eb eb                	jmp    8006cc <vprintfmt+0x1ae>
  8006e1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006e4:	85 d2                	test   %edx,%edx
  8006e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006eb:	0f 49 c2             	cmovns %edx,%eax
  8006ee:	29 c2                	sub    %eax,%edx
  8006f0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8006f3:	eb a8                	jmp    80069d <vprintfmt+0x17f>
					putch(ch, putdat);
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	53                   	push   %ebx
  8006f9:	52                   	push   %edx
  8006fa:	ff d6                	call   *%esi
  8006fc:	83 c4 10             	add    $0x10,%esp
  8006ff:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800702:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800704:	83 c7 01             	add    $0x1,%edi
  800707:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80070b:	0f be d0             	movsbl %al,%edx
  80070e:	85 d2                	test   %edx,%edx
  800710:	74 4b                	je     80075d <vprintfmt+0x23f>
  800712:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800716:	78 06                	js     80071e <vprintfmt+0x200>
  800718:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80071c:	78 1e                	js     80073c <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80071e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800722:	74 d1                	je     8006f5 <vprintfmt+0x1d7>
  800724:	0f be c0             	movsbl %al,%eax
  800727:	83 e8 20             	sub    $0x20,%eax
  80072a:	83 f8 5e             	cmp    $0x5e,%eax
  80072d:	76 c6                	jbe    8006f5 <vprintfmt+0x1d7>
					putch('?', putdat);
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	53                   	push   %ebx
  800733:	6a 3f                	push   $0x3f
  800735:	ff d6                	call   *%esi
  800737:	83 c4 10             	add    $0x10,%esp
  80073a:	eb c3                	jmp    8006ff <vprintfmt+0x1e1>
  80073c:	89 cf                	mov    %ecx,%edi
  80073e:	eb 0e                	jmp    80074e <vprintfmt+0x230>
				putch(' ', putdat);
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	53                   	push   %ebx
  800744:	6a 20                	push   $0x20
  800746:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800748:	83 ef 01             	sub    $0x1,%edi
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	85 ff                	test   %edi,%edi
  800750:	7f ee                	jg     800740 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800752:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800755:	89 45 14             	mov    %eax,0x14(%ebp)
  800758:	e9 67 01 00 00       	jmp    8008c4 <vprintfmt+0x3a6>
  80075d:	89 cf                	mov    %ecx,%edi
  80075f:	eb ed                	jmp    80074e <vprintfmt+0x230>
	if (lflag >= 2)
  800761:	83 f9 01             	cmp    $0x1,%ecx
  800764:	7f 1b                	jg     800781 <vprintfmt+0x263>
	else if (lflag)
  800766:	85 c9                	test   %ecx,%ecx
  800768:	74 63                	je     8007cd <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800772:	99                   	cltd   
  800773:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	8d 40 04             	lea    0x4(%eax),%eax
  80077c:	89 45 14             	mov    %eax,0x14(%ebp)
  80077f:	eb 17                	jmp    800798 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	8b 50 04             	mov    0x4(%eax),%edx
  800787:	8b 00                	mov    (%eax),%eax
  800789:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8d 40 08             	lea    0x8(%eax),%eax
  800795:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800798:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80079b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80079e:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007a3:	85 c9                	test   %ecx,%ecx
  8007a5:	0f 89 ff 00 00 00    	jns    8008aa <vprintfmt+0x38c>
				putch('-', putdat);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	53                   	push   %ebx
  8007af:	6a 2d                	push   $0x2d
  8007b1:	ff d6                	call   *%esi
				num = -(long long) num;
  8007b3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007b6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007b9:	f7 da                	neg    %edx
  8007bb:	83 d1 00             	adc    $0x0,%ecx
  8007be:	f7 d9                	neg    %ecx
  8007c0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007c3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c8:	e9 dd 00 00 00       	jmp    8008aa <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d5:	99                   	cltd   
  8007d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	8d 40 04             	lea    0x4(%eax),%eax
  8007df:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e2:	eb b4                	jmp    800798 <vprintfmt+0x27a>
	if (lflag >= 2)
  8007e4:	83 f9 01             	cmp    $0x1,%ecx
  8007e7:	7f 1e                	jg     800807 <vprintfmt+0x2e9>
	else if (lflag)
  8007e9:	85 c9                	test   %ecx,%ecx
  8007eb:	74 32                	je     80081f <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8007ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f0:	8b 10                	mov    (%eax),%edx
  8007f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007f7:	8d 40 04             	lea    0x4(%eax),%eax
  8007fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007fd:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800802:	e9 a3 00 00 00       	jmp    8008aa <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800807:	8b 45 14             	mov    0x14(%ebp),%eax
  80080a:	8b 10                	mov    (%eax),%edx
  80080c:	8b 48 04             	mov    0x4(%eax),%ecx
  80080f:	8d 40 08             	lea    0x8(%eax),%eax
  800812:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800815:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80081a:	e9 8b 00 00 00       	jmp    8008aa <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80081f:	8b 45 14             	mov    0x14(%ebp),%eax
  800822:	8b 10                	mov    (%eax),%edx
  800824:	b9 00 00 00 00       	mov    $0x0,%ecx
  800829:	8d 40 04             	lea    0x4(%eax),%eax
  80082c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80082f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800834:	eb 74                	jmp    8008aa <vprintfmt+0x38c>
	if (lflag >= 2)
  800836:	83 f9 01             	cmp    $0x1,%ecx
  800839:	7f 1b                	jg     800856 <vprintfmt+0x338>
	else if (lflag)
  80083b:	85 c9                	test   %ecx,%ecx
  80083d:	74 2c                	je     80086b <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80083f:	8b 45 14             	mov    0x14(%ebp),%eax
  800842:	8b 10                	mov    (%eax),%edx
  800844:	b9 00 00 00 00       	mov    $0x0,%ecx
  800849:	8d 40 04             	lea    0x4(%eax),%eax
  80084c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80084f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800854:	eb 54                	jmp    8008aa <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800856:	8b 45 14             	mov    0x14(%ebp),%eax
  800859:	8b 10                	mov    (%eax),%edx
  80085b:	8b 48 04             	mov    0x4(%eax),%ecx
  80085e:	8d 40 08             	lea    0x8(%eax),%eax
  800861:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800864:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800869:	eb 3f                	jmp    8008aa <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	8b 10                	mov    (%eax),%edx
  800870:	b9 00 00 00 00       	mov    $0x0,%ecx
  800875:	8d 40 04             	lea    0x4(%eax),%eax
  800878:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80087b:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800880:	eb 28                	jmp    8008aa <vprintfmt+0x38c>
			putch('0', putdat);
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	53                   	push   %ebx
  800886:	6a 30                	push   $0x30
  800888:	ff d6                	call   *%esi
			putch('x', putdat);
  80088a:	83 c4 08             	add    $0x8,%esp
  80088d:	53                   	push   %ebx
  80088e:	6a 78                	push   $0x78
  800890:	ff d6                	call   *%esi
			num = (unsigned long long)
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	8b 10                	mov    (%eax),%edx
  800897:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80089c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80089f:	8d 40 04             	lea    0x4(%eax),%eax
  8008a2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a5:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008aa:	83 ec 0c             	sub    $0xc,%esp
  8008ad:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8008b1:	57                   	push   %edi
  8008b2:	ff 75 e0             	pushl  -0x20(%ebp)
  8008b5:	50                   	push   %eax
  8008b6:	51                   	push   %ecx
  8008b7:	52                   	push   %edx
  8008b8:	89 da                	mov    %ebx,%edx
  8008ba:	89 f0                	mov    %esi,%eax
  8008bc:	e8 72 fb ff ff       	call   800433 <printnum>
			break;
  8008c1:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c7:	83 c7 01             	add    $0x1,%edi
  8008ca:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008ce:	83 f8 25             	cmp    $0x25,%eax
  8008d1:	0f 84 62 fc ff ff    	je     800539 <vprintfmt+0x1b>
			if (ch == '\0')
  8008d7:	85 c0                	test   %eax,%eax
  8008d9:	0f 84 8b 00 00 00    	je     80096a <vprintfmt+0x44c>
			putch(ch, putdat);
  8008df:	83 ec 08             	sub    $0x8,%esp
  8008e2:	53                   	push   %ebx
  8008e3:	50                   	push   %eax
  8008e4:	ff d6                	call   *%esi
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	eb dc                	jmp    8008c7 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8008eb:	83 f9 01             	cmp    $0x1,%ecx
  8008ee:	7f 1b                	jg     80090b <vprintfmt+0x3ed>
	else if (lflag)
  8008f0:	85 c9                	test   %ecx,%ecx
  8008f2:	74 2c                	je     800920 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8008f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f7:	8b 10                	mov    (%eax),%edx
  8008f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008fe:	8d 40 04             	lea    0x4(%eax),%eax
  800901:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800904:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800909:	eb 9f                	jmp    8008aa <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80090b:	8b 45 14             	mov    0x14(%ebp),%eax
  80090e:	8b 10                	mov    (%eax),%edx
  800910:	8b 48 04             	mov    0x4(%eax),%ecx
  800913:	8d 40 08             	lea    0x8(%eax),%eax
  800916:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800919:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80091e:	eb 8a                	jmp    8008aa <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800920:	8b 45 14             	mov    0x14(%ebp),%eax
  800923:	8b 10                	mov    (%eax),%edx
  800925:	b9 00 00 00 00       	mov    $0x0,%ecx
  80092a:	8d 40 04             	lea    0x4(%eax),%eax
  80092d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800930:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800935:	e9 70 ff ff ff       	jmp    8008aa <vprintfmt+0x38c>
			putch(ch, putdat);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	53                   	push   %ebx
  80093e:	6a 25                	push   $0x25
  800940:	ff d6                	call   *%esi
			break;
  800942:	83 c4 10             	add    $0x10,%esp
  800945:	e9 7a ff ff ff       	jmp    8008c4 <vprintfmt+0x3a6>
			putch('%', putdat);
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	53                   	push   %ebx
  80094e:	6a 25                	push   $0x25
  800950:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800952:	83 c4 10             	add    $0x10,%esp
  800955:	89 f8                	mov    %edi,%eax
  800957:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80095b:	74 05                	je     800962 <vprintfmt+0x444>
  80095d:	83 e8 01             	sub    $0x1,%eax
  800960:	eb f5                	jmp    800957 <vprintfmt+0x439>
  800962:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800965:	e9 5a ff ff ff       	jmp    8008c4 <vprintfmt+0x3a6>
}
  80096a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80096d:	5b                   	pop    %ebx
  80096e:	5e                   	pop    %esi
  80096f:	5f                   	pop    %edi
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    

00800972 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800972:	f3 0f 1e fb          	endbr32 
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	83 ec 18             	sub    $0x18,%esp
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800982:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800985:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800989:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80098c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800993:	85 c0                	test   %eax,%eax
  800995:	74 26                	je     8009bd <vsnprintf+0x4b>
  800997:	85 d2                	test   %edx,%edx
  800999:	7e 22                	jle    8009bd <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80099b:	ff 75 14             	pushl  0x14(%ebp)
  80099e:	ff 75 10             	pushl  0x10(%ebp)
  8009a1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009a4:	50                   	push   %eax
  8009a5:	68 dc 04 80 00       	push   $0x8004dc
  8009aa:	e8 6f fb ff ff       	call   80051e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009b8:	83 c4 10             	add    $0x10,%esp
}
  8009bb:	c9                   	leave  
  8009bc:	c3                   	ret    
		return -E_INVAL;
  8009bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009c2:	eb f7                	jmp    8009bb <vsnprintf+0x49>

008009c4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009c4:	f3 0f 1e fb          	endbr32 
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009ce:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009d1:	50                   	push   %eax
  8009d2:	ff 75 10             	pushl  0x10(%ebp)
  8009d5:	ff 75 0c             	pushl  0xc(%ebp)
  8009d8:	ff 75 08             	pushl  0x8(%ebp)
  8009db:	e8 92 ff ff ff       	call   800972 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009e0:	c9                   	leave  
  8009e1:	c3                   	ret    

008009e2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009e2:	f3 0f 1e fb          	endbr32 
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009f5:	74 05                	je     8009fc <strlen+0x1a>
		n++;
  8009f7:	83 c0 01             	add    $0x1,%eax
  8009fa:	eb f5                	jmp    8009f1 <strlen+0xf>
	return n;
}
  8009fc:	5d                   	pop    %ebp
  8009fd:	c3                   	ret    

008009fe <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009fe:	f3 0f 1e fb          	endbr32 
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a08:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a10:	39 d0                	cmp    %edx,%eax
  800a12:	74 0d                	je     800a21 <strnlen+0x23>
  800a14:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a18:	74 05                	je     800a1f <strnlen+0x21>
		n++;
  800a1a:	83 c0 01             	add    $0x1,%eax
  800a1d:	eb f1                	jmp    800a10 <strnlen+0x12>
  800a1f:	89 c2                	mov    %eax,%edx
	return n;
}
  800a21:	89 d0                	mov    %edx,%eax
  800a23:	5d                   	pop    %ebp
  800a24:	c3                   	ret    

00800a25 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a25:	f3 0f 1e fb          	endbr32 
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	53                   	push   %ebx
  800a2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a30:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a33:	b8 00 00 00 00       	mov    $0x0,%eax
  800a38:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800a3c:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800a3f:	83 c0 01             	add    $0x1,%eax
  800a42:	84 d2                	test   %dl,%dl
  800a44:	75 f2                	jne    800a38 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800a46:	89 c8                	mov    %ecx,%eax
  800a48:	5b                   	pop    %ebx
  800a49:	5d                   	pop    %ebp
  800a4a:	c3                   	ret    

00800a4b <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a4b:	f3 0f 1e fb          	endbr32 
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	53                   	push   %ebx
  800a53:	83 ec 10             	sub    $0x10,%esp
  800a56:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a59:	53                   	push   %ebx
  800a5a:	e8 83 ff ff ff       	call   8009e2 <strlen>
  800a5f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a62:	ff 75 0c             	pushl  0xc(%ebp)
  800a65:	01 d8                	add    %ebx,%eax
  800a67:	50                   	push   %eax
  800a68:	e8 b8 ff ff ff       	call   800a25 <strcpy>
	return dst;
}
  800a6d:	89 d8                	mov    %ebx,%eax
  800a6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a72:	c9                   	leave  
  800a73:	c3                   	ret    

00800a74 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a74:	f3 0f 1e fb          	endbr32 
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	56                   	push   %esi
  800a7c:	53                   	push   %ebx
  800a7d:	8b 75 08             	mov    0x8(%ebp),%esi
  800a80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a83:	89 f3                	mov    %esi,%ebx
  800a85:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a88:	89 f0                	mov    %esi,%eax
  800a8a:	39 d8                	cmp    %ebx,%eax
  800a8c:	74 11                	je     800a9f <strncpy+0x2b>
		*dst++ = *src;
  800a8e:	83 c0 01             	add    $0x1,%eax
  800a91:	0f b6 0a             	movzbl (%edx),%ecx
  800a94:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a97:	80 f9 01             	cmp    $0x1,%cl
  800a9a:	83 da ff             	sbb    $0xffffffff,%edx
  800a9d:	eb eb                	jmp    800a8a <strncpy+0x16>
	}
	return ret;
}
  800a9f:	89 f0                	mov    %esi,%eax
  800aa1:	5b                   	pop    %ebx
  800aa2:	5e                   	pop    %esi
  800aa3:	5d                   	pop    %ebp
  800aa4:	c3                   	ret    

00800aa5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aa5:	f3 0f 1e fb          	endbr32 
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	56                   	push   %esi
  800aad:	53                   	push   %ebx
  800aae:	8b 75 08             	mov    0x8(%ebp),%esi
  800ab1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ab4:	8b 55 10             	mov    0x10(%ebp),%edx
  800ab7:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ab9:	85 d2                	test   %edx,%edx
  800abb:	74 21                	je     800ade <strlcpy+0x39>
  800abd:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ac1:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ac3:	39 c2                	cmp    %eax,%edx
  800ac5:	74 14                	je     800adb <strlcpy+0x36>
  800ac7:	0f b6 19             	movzbl (%ecx),%ebx
  800aca:	84 db                	test   %bl,%bl
  800acc:	74 0b                	je     800ad9 <strlcpy+0x34>
			*dst++ = *src++;
  800ace:	83 c1 01             	add    $0x1,%ecx
  800ad1:	83 c2 01             	add    $0x1,%edx
  800ad4:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ad7:	eb ea                	jmp    800ac3 <strlcpy+0x1e>
  800ad9:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800adb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ade:	29 f0                	sub    %esi,%eax
}
  800ae0:	5b                   	pop    %ebx
  800ae1:	5e                   	pop    %esi
  800ae2:	5d                   	pop    %ebp
  800ae3:	c3                   	ret    

00800ae4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ae4:	f3 0f 1e fb          	endbr32 
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aee:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800af1:	0f b6 01             	movzbl (%ecx),%eax
  800af4:	84 c0                	test   %al,%al
  800af6:	74 0c                	je     800b04 <strcmp+0x20>
  800af8:	3a 02                	cmp    (%edx),%al
  800afa:	75 08                	jne    800b04 <strcmp+0x20>
		p++, q++;
  800afc:	83 c1 01             	add    $0x1,%ecx
  800aff:	83 c2 01             	add    $0x1,%edx
  800b02:	eb ed                	jmp    800af1 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b04:	0f b6 c0             	movzbl %al,%eax
  800b07:	0f b6 12             	movzbl (%edx),%edx
  800b0a:	29 d0                	sub    %edx,%eax
}
  800b0c:	5d                   	pop    %ebp
  800b0d:	c3                   	ret    

00800b0e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b0e:	f3 0f 1e fb          	endbr32 
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	53                   	push   %ebx
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1c:	89 c3                	mov    %eax,%ebx
  800b1e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b21:	eb 06                	jmp    800b29 <strncmp+0x1b>
		n--, p++, q++;
  800b23:	83 c0 01             	add    $0x1,%eax
  800b26:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b29:	39 d8                	cmp    %ebx,%eax
  800b2b:	74 16                	je     800b43 <strncmp+0x35>
  800b2d:	0f b6 08             	movzbl (%eax),%ecx
  800b30:	84 c9                	test   %cl,%cl
  800b32:	74 04                	je     800b38 <strncmp+0x2a>
  800b34:	3a 0a                	cmp    (%edx),%cl
  800b36:	74 eb                	je     800b23 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b38:	0f b6 00             	movzbl (%eax),%eax
  800b3b:	0f b6 12             	movzbl (%edx),%edx
  800b3e:	29 d0                	sub    %edx,%eax
}
  800b40:	5b                   	pop    %ebx
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    
		return 0;
  800b43:	b8 00 00 00 00       	mov    $0x0,%eax
  800b48:	eb f6                	jmp    800b40 <strncmp+0x32>

00800b4a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b4a:	f3 0f 1e fb          	endbr32 
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b58:	0f b6 10             	movzbl (%eax),%edx
  800b5b:	84 d2                	test   %dl,%dl
  800b5d:	74 09                	je     800b68 <strchr+0x1e>
		if (*s == c)
  800b5f:	38 ca                	cmp    %cl,%dl
  800b61:	74 0a                	je     800b6d <strchr+0x23>
	for (; *s; s++)
  800b63:	83 c0 01             	add    $0x1,%eax
  800b66:	eb f0                	jmp    800b58 <strchr+0xe>
			return (char *) s;
	return 0;
  800b68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b6f:	f3 0f 1e fb          	endbr32 
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b7d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b80:	38 ca                	cmp    %cl,%dl
  800b82:	74 09                	je     800b8d <strfind+0x1e>
  800b84:	84 d2                	test   %dl,%dl
  800b86:	74 05                	je     800b8d <strfind+0x1e>
	for (; *s; s++)
  800b88:	83 c0 01             	add    $0x1,%eax
  800b8b:	eb f0                	jmp    800b7d <strfind+0xe>
			break;
	return (char *) s;
}
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b8f:	f3 0f 1e fb          	endbr32 
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	57                   	push   %edi
  800b97:	56                   	push   %esi
  800b98:	53                   	push   %ebx
  800b99:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b9c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b9f:	85 c9                	test   %ecx,%ecx
  800ba1:	74 31                	je     800bd4 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ba3:	89 f8                	mov    %edi,%eax
  800ba5:	09 c8                	or     %ecx,%eax
  800ba7:	a8 03                	test   $0x3,%al
  800ba9:	75 23                	jne    800bce <memset+0x3f>
		c &= 0xFF;
  800bab:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800baf:	89 d3                	mov    %edx,%ebx
  800bb1:	c1 e3 08             	shl    $0x8,%ebx
  800bb4:	89 d0                	mov    %edx,%eax
  800bb6:	c1 e0 18             	shl    $0x18,%eax
  800bb9:	89 d6                	mov    %edx,%esi
  800bbb:	c1 e6 10             	shl    $0x10,%esi
  800bbe:	09 f0                	or     %esi,%eax
  800bc0:	09 c2                	or     %eax,%edx
  800bc2:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bc4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bc7:	89 d0                	mov    %edx,%eax
  800bc9:	fc                   	cld    
  800bca:	f3 ab                	rep stos %eax,%es:(%edi)
  800bcc:	eb 06                	jmp    800bd4 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd1:	fc                   	cld    
  800bd2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bd4:	89 f8                	mov    %edi,%eax
  800bd6:	5b                   	pop    %ebx
  800bd7:	5e                   	pop    %esi
  800bd8:	5f                   	pop    %edi
  800bd9:	5d                   	pop    %ebp
  800bda:	c3                   	ret    

00800bdb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bdb:	f3 0f 1e fb          	endbr32 
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
  800be2:	57                   	push   %edi
  800be3:	56                   	push   %esi
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bea:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bed:	39 c6                	cmp    %eax,%esi
  800bef:	73 32                	jae    800c23 <memmove+0x48>
  800bf1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bf4:	39 c2                	cmp    %eax,%edx
  800bf6:	76 2b                	jbe    800c23 <memmove+0x48>
		s += n;
		d += n;
  800bf8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bfb:	89 fe                	mov    %edi,%esi
  800bfd:	09 ce                	or     %ecx,%esi
  800bff:	09 d6                	or     %edx,%esi
  800c01:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c07:	75 0e                	jne    800c17 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c09:	83 ef 04             	sub    $0x4,%edi
  800c0c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c0f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c12:	fd                   	std    
  800c13:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c15:	eb 09                	jmp    800c20 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c17:	83 ef 01             	sub    $0x1,%edi
  800c1a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c1d:	fd                   	std    
  800c1e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c20:	fc                   	cld    
  800c21:	eb 1a                	jmp    800c3d <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c23:	89 c2                	mov    %eax,%edx
  800c25:	09 ca                	or     %ecx,%edx
  800c27:	09 f2                	or     %esi,%edx
  800c29:	f6 c2 03             	test   $0x3,%dl
  800c2c:	75 0a                	jne    800c38 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c2e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c31:	89 c7                	mov    %eax,%edi
  800c33:	fc                   	cld    
  800c34:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c36:	eb 05                	jmp    800c3d <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800c38:	89 c7                	mov    %eax,%edi
  800c3a:	fc                   	cld    
  800c3b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c3d:	5e                   	pop    %esi
  800c3e:	5f                   	pop    %edi
  800c3f:	5d                   	pop    %ebp
  800c40:	c3                   	ret    

00800c41 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c41:	f3 0f 1e fb          	endbr32 
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c4b:	ff 75 10             	pushl  0x10(%ebp)
  800c4e:	ff 75 0c             	pushl  0xc(%ebp)
  800c51:	ff 75 08             	pushl  0x8(%ebp)
  800c54:	e8 82 ff ff ff       	call   800bdb <memmove>
}
  800c59:	c9                   	leave  
  800c5a:	c3                   	ret    

00800c5b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c5b:	f3 0f 1e fb          	endbr32 
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	56                   	push   %esi
  800c63:	53                   	push   %ebx
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6a:	89 c6                	mov    %eax,%esi
  800c6c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c6f:	39 f0                	cmp    %esi,%eax
  800c71:	74 1c                	je     800c8f <memcmp+0x34>
		if (*s1 != *s2)
  800c73:	0f b6 08             	movzbl (%eax),%ecx
  800c76:	0f b6 1a             	movzbl (%edx),%ebx
  800c79:	38 d9                	cmp    %bl,%cl
  800c7b:	75 08                	jne    800c85 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c7d:	83 c0 01             	add    $0x1,%eax
  800c80:	83 c2 01             	add    $0x1,%edx
  800c83:	eb ea                	jmp    800c6f <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800c85:	0f b6 c1             	movzbl %cl,%eax
  800c88:	0f b6 db             	movzbl %bl,%ebx
  800c8b:	29 d8                	sub    %ebx,%eax
  800c8d:	eb 05                	jmp    800c94 <memcmp+0x39>
	}

	return 0;
  800c8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    

00800c98 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c98:	f3 0f 1e fb          	endbr32 
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ca5:	89 c2                	mov    %eax,%edx
  800ca7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800caa:	39 d0                	cmp    %edx,%eax
  800cac:	73 09                	jae    800cb7 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cae:	38 08                	cmp    %cl,(%eax)
  800cb0:	74 05                	je     800cb7 <memfind+0x1f>
	for (; s < ends; s++)
  800cb2:	83 c0 01             	add    $0x1,%eax
  800cb5:	eb f3                	jmp    800caa <memfind+0x12>
			break;
	return (void *) s;
}
  800cb7:	5d                   	pop    %ebp
  800cb8:	c3                   	ret    

00800cb9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cb9:	f3 0f 1e fb          	endbr32 
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	57                   	push   %edi
  800cc1:	56                   	push   %esi
  800cc2:	53                   	push   %ebx
  800cc3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cc9:	eb 03                	jmp    800cce <strtol+0x15>
		s++;
  800ccb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cce:	0f b6 01             	movzbl (%ecx),%eax
  800cd1:	3c 20                	cmp    $0x20,%al
  800cd3:	74 f6                	je     800ccb <strtol+0x12>
  800cd5:	3c 09                	cmp    $0x9,%al
  800cd7:	74 f2                	je     800ccb <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800cd9:	3c 2b                	cmp    $0x2b,%al
  800cdb:	74 2a                	je     800d07 <strtol+0x4e>
	int neg = 0;
  800cdd:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ce2:	3c 2d                	cmp    $0x2d,%al
  800ce4:	74 2b                	je     800d11 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cec:	75 0f                	jne    800cfd <strtol+0x44>
  800cee:	80 39 30             	cmpb   $0x30,(%ecx)
  800cf1:	74 28                	je     800d1b <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cf3:	85 db                	test   %ebx,%ebx
  800cf5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cfa:	0f 44 d8             	cmove  %eax,%ebx
  800cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  800d02:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d05:	eb 46                	jmp    800d4d <strtol+0x94>
		s++;
  800d07:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d0a:	bf 00 00 00 00       	mov    $0x0,%edi
  800d0f:	eb d5                	jmp    800ce6 <strtol+0x2d>
		s++, neg = 1;
  800d11:	83 c1 01             	add    $0x1,%ecx
  800d14:	bf 01 00 00 00       	mov    $0x1,%edi
  800d19:	eb cb                	jmp    800ce6 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d1b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d1f:	74 0e                	je     800d2f <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d21:	85 db                	test   %ebx,%ebx
  800d23:	75 d8                	jne    800cfd <strtol+0x44>
		s++, base = 8;
  800d25:	83 c1 01             	add    $0x1,%ecx
  800d28:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d2d:	eb ce                	jmp    800cfd <strtol+0x44>
		s += 2, base = 16;
  800d2f:	83 c1 02             	add    $0x2,%ecx
  800d32:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d37:	eb c4                	jmp    800cfd <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800d39:	0f be d2             	movsbl %dl,%edx
  800d3c:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d3f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d42:	7d 3a                	jge    800d7e <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d44:	83 c1 01             	add    $0x1,%ecx
  800d47:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d4b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d4d:	0f b6 11             	movzbl (%ecx),%edx
  800d50:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d53:	89 f3                	mov    %esi,%ebx
  800d55:	80 fb 09             	cmp    $0x9,%bl
  800d58:	76 df                	jbe    800d39 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800d5a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d5d:	89 f3                	mov    %esi,%ebx
  800d5f:	80 fb 19             	cmp    $0x19,%bl
  800d62:	77 08                	ja     800d6c <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d64:	0f be d2             	movsbl %dl,%edx
  800d67:	83 ea 57             	sub    $0x57,%edx
  800d6a:	eb d3                	jmp    800d3f <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800d6c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d6f:	89 f3                	mov    %esi,%ebx
  800d71:	80 fb 19             	cmp    $0x19,%bl
  800d74:	77 08                	ja     800d7e <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d76:	0f be d2             	movsbl %dl,%edx
  800d79:	83 ea 37             	sub    $0x37,%edx
  800d7c:	eb c1                	jmp    800d3f <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d82:	74 05                	je     800d89 <strtol+0xd0>
		*endptr = (char *) s;
  800d84:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d87:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d89:	89 c2                	mov    %eax,%edx
  800d8b:	f7 da                	neg    %edx
  800d8d:	85 ff                	test   %edi,%edi
  800d8f:	0f 45 c2             	cmovne %edx,%eax
}
  800d92:	5b                   	pop    %ebx
  800d93:	5e                   	pop    %esi
  800d94:	5f                   	pop    %edi
  800d95:	5d                   	pop    %ebp
  800d96:	c3                   	ret    
  800d97:	66 90                	xchg   %ax,%ax
  800d99:	66 90                	xchg   %ax,%ax
  800d9b:	66 90                	xchg   %ax,%ax
  800d9d:	66 90                	xchg   %ax,%ax
  800d9f:	90                   	nop

00800da0 <__udivdi3>:
  800da0:	f3 0f 1e fb          	endbr32 
  800da4:	55                   	push   %ebp
  800da5:	57                   	push   %edi
  800da6:	56                   	push   %esi
  800da7:	53                   	push   %ebx
  800da8:	83 ec 1c             	sub    $0x1c,%esp
  800dab:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800daf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800db3:	8b 74 24 34          	mov    0x34(%esp),%esi
  800db7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800dbb:	85 d2                	test   %edx,%edx
  800dbd:	75 19                	jne    800dd8 <__udivdi3+0x38>
  800dbf:	39 f3                	cmp    %esi,%ebx
  800dc1:	76 4d                	jbe    800e10 <__udivdi3+0x70>
  800dc3:	31 ff                	xor    %edi,%edi
  800dc5:	89 e8                	mov    %ebp,%eax
  800dc7:	89 f2                	mov    %esi,%edx
  800dc9:	f7 f3                	div    %ebx
  800dcb:	89 fa                	mov    %edi,%edx
  800dcd:	83 c4 1c             	add    $0x1c,%esp
  800dd0:	5b                   	pop    %ebx
  800dd1:	5e                   	pop    %esi
  800dd2:	5f                   	pop    %edi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    
  800dd5:	8d 76 00             	lea    0x0(%esi),%esi
  800dd8:	39 f2                	cmp    %esi,%edx
  800dda:	76 14                	jbe    800df0 <__udivdi3+0x50>
  800ddc:	31 ff                	xor    %edi,%edi
  800dde:	31 c0                	xor    %eax,%eax
  800de0:	89 fa                	mov    %edi,%edx
  800de2:	83 c4 1c             	add    $0x1c,%esp
  800de5:	5b                   	pop    %ebx
  800de6:	5e                   	pop    %esi
  800de7:	5f                   	pop    %edi
  800de8:	5d                   	pop    %ebp
  800de9:	c3                   	ret    
  800dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800df0:	0f bd fa             	bsr    %edx,%edi
  800df3:	83 f7 1f             	xor    $0x1f,%edi
  800df6:	75 48                	jne    800e40 <__udivdi3+0xa0>
  800df8:	39 f2                	cmp    %esi,%edx
  800dfa:	72 06                	jb     800e02 <__udivdi3+0x62>
  800dfc:	31 c0                	xor    %eax,%eax
  800dfe:	39 eb                	cmp    %ebp,%ebx
  800e00:	77 de                	ja     800de0 <__udivdi3+0x40>
  800e02:	b8 01 00 00 00       	mov    $0x1,%eax
  800e07:	eb d7                	jmp    800de0 <__udivdi3+0x40>
  800e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e10:	89 d9                	mov    %ebx,%ecx
  800e12:	85 db                	test   %ebx,%ebx
  800e14:	75 0b                	jne    800e21 <__udivdi3+0x81>
  800e16:	b8 01 00 00 00       	mov    $0x1,%eax
  800e1b:	31 d2                	xor    %edx,%edx
  800e1d:	f7 f3                	div    %ebx
  800e1f:	89 c1                	mov    %eax,%ecx
  800e21:	31 d2                	xor    %edx,%edx
  800e23:	89 f0                	mov    %esi,%eax
  800e25:	f7 f1                	div    %ecx
  800e27:	89 c6                	mov    %eax,%esi
  800e29:	89 e8                	mov    %ebp,%eax
  800e2b:	89 f7                	mov    %esi,%edi
  800e2d:	f7 f1                	div    %ecx
  800e2f:	89 fa                	mov    %edi,%edx
  800e31:	83 c4 1c             	add    $0x1c,%esp
  800e34:	5b                   	pop    %ebx
  800e35:	5e                   	pop    %esi
  800e36:	5f                   	pop    %edi
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    
  800e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e40:	89 f9                	mov    %edi,%ecx
  800e42:	b8 20 00 00 00       	mov    $0x20,%eax
  800e47:	29 f8                	sub    %edi,%eax
  800e49:	d3 e2                	shl    %cl,%edx
  800e4b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e4f:	89 c1                	mov    %eax,%ecx
  800e51:	89 da                	mov    %ebx,%edx
  800e53:	d3 ea                	shr    %cl,%edx
  800e55:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e59:	09 d1                	or     %edx,%ecx
  800e5b:	89 f2                	mov    %esi,%edx
  800e5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e61:	89 f9                	mov    %edi,%ecx
  800e63:	d3 e3                	shl    %cl,%ebx
  800e65:	89 c1                	mov    %eax,%ecx
  800e67:	d3 ea                	shr    %cl,%edx
  800e69:	89 f9                	mov    %edi,%ecx
  800e6b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e6f:	89 eb                	mov    %ebp,%ebx
  800e71:	d3 e6                	shl    %cl,%esi
  800e73:	89 c1                	mov    %eax,%ecx
  800e75:	d3 eb                	shr    %cl,%ebx
  800e77:	09 de                	or     %ebx,%esi
  800e79:	89 f0                	mov    %esi,%eax
  800e7b:	f7 74 24 08          	divl   0x8(%esp)
  800e7f:	89 d6                	mov    %edx,%esi
  800e81:	89 c3                	mov    %eax,%ebx
  800e83:	f7 64 24 0c          	mull   0xc(%esp)
  800e87:	39 d6                	cmp    %edx,%esi
  800e89:	72 15                	jb     800ea0 <__udivdi3+0x100>
  800e8b:	89 f9                	mov    %edi,%ecx
  800e8d:	d3 e5                	shl    %cl,%ebp
  800e8f:	39 c5                	cmp    %eax,%ebp
  800e91:	73 04                	jae    800e97 <__udivdi3+0xf7>
  800e93:	39 d6                	cmp    %edx,%esi
  800e95:	74 09                	je     800ea0 <__udivdi3+0x100>
  800e97:	89 d8                	mov    %ebx,%eax
  800e99:	31 ff                	xor    %edi,%edi
  800e9b:	e9 40 ff ff ff       	jmp    800de0 <__udivdi3+0x40>
  800ea0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800ea3:	31 ff                	xor    %edi,%edi
  800ea5:	e9 36 ff ff ff       	jmp    800de0 <__udivdi3+0x40>
  800eaa:	66 90                	xchg   %ax,%ax
  800eac:	66 90                	xchg   %ax,%ax
  800eae:	66 90                	xchg   %ax,%ax

00800eb0 <__umoddi3>:
  800eb0:	f3 0f 1e fb          	endbr32 
  800eb4:	55                   	push   %ebp
  800eb5:	57                   	push   %edi
  800eb6:	56                   	push   %esi
  800eb7:	53                   	push   %ebx
  800eb8:	83 ec 1c             	sub    $0x1c,%esp
  800ebb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800ebf:	8b 74 24 30          	mov    0x30(%esp),%esi
  800ec3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800ec7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800ecb:	85 c0                	test   %eax,%eax
  800ecd:	75 19                	jne    800ee8 <__umoddi3+0x38>
  800ecf:	39 df                	cmp    %ebx,%edi
  800ed1:	76 5d                	jbe    800f30 <__umoddi3+0x80>
  800ed3:	89 f0                	mov    %esi,%eax
  800ed5:	89 da                	mov    %ebx,%edx
  800ed7:	f7 f7                	div    %edi
  800ed9:	89 d0                	mov    %edx,%eax
  800edb:	31 d2                	xor    %edx,%edx
  800edd:	83 c4 1c             	add    $0x1c,%esp
  800ee0:	5b                   	pop    %ebx
  800ee1:	5e                   	pop    %esi
  800ee2:	5f                   	pop    %edi
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    
  800ee5:	8d 76 00             	lea    0x0(%esi),%esi
  800ee8:	89 f2                	mov    %esi,%edx
  800eea:	39 d8                	cmp    %ebx,%eax
  800eec:	76 12                	jbe    800f00 <__umoddi3+0x50>
  800eee:	89 f0                	mov    %esi,%eax
  800ef0:	89 da                	mov    %ebx,%edx
  800ef2:	83 c4 1c             	add    $0x1c,%esp
  800ef5:	5b                   	pop    %ebx
  800ef6:	5e                   	pop    %esi
  800ef7:	5f                   	pop    %edi
  800ef8:	5d                   	pop    %ebp
  800ef9:	c3                   	ret    
  800efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f00:	0f bd e8             	bsr    %eax,%ebp
  800f03:	83 f5 1f             	xor    $0x1f,%ebp
  800f06:	75 50                	jne    800f58 <__umoddi3+0xa8>
  800f08:	39 d8                	cmp    %ebx,%eax
  800f0a:	0f 82 e0 00 00 00    	jb     800ff0 <__umoddi3+0x140>
  800f10:	89 d9                	mov    %ebx,%ecx
  800f12:	39 f7                	cmp    %esi,%edi
  800f14:	0f 86 d6 00 00 00    	jbe    800ff0 <__umoddi3+0x140>
  800f1a:	89 d0                	mov    %edx,%eax
  800f1c:	89 ca                	mov    %ecx,%edx
  800f1e:	83 c4 1c             	add    $0x1c,%esp
  800f21:	5b                   	pop    %ebx
  800f22:	5e                   	pop    %esi
  800f23:	5f                   	pop    %edi
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    
  800f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f2d:	8d 76 00             	lea    0x0(%esi),%esi
  800f30:	89 fd                	mov    %edi,%ebp
  800f32:	85 ff                	test   %edi,%edi
  800f34:	75 0b                	jne    800f41 <__umoddi3+0x91>
  800f36:	b8 01 00 00 00       	mov    $0x1,%eax
  800f3b:	31 d2                	xor    %edx,%edx
  800f3d:	f7 f7                	div    %edi
  800f3f:	89 c5                	mov    %eax,%ebp
  800f41:	89 d8                	mov    %ebx,%eax
  800f43:	31 d2                	xor    %edx,%edx
  800f45:	f7 f5                	div    %ebp
  800f47:	89 f0                	mov    %esi,%eax
  800f49:	f7 f5                	div    %ebp
  800f4b:	89 d0                	mov    %edx,%eax
  800f4d:	31 d2                	xor    %edx,%edx
  800f4f:	eb 8c                	jmp    800edd <__umoddi3+0x2d>
  800f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f58:	89 e9                	mov    %ebp,%ecx
  800f5a:	ba 20 00 00 00       	mov    $0x20,%edx
  800f5f:	29 ea                	sub    %ebp,%edx
  800f61:	d3 e0                	shl    %cl,%eax
  800f63:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f67:	89 d1                	mov    %edx,%ecx
  800f69:	89 f8                	mov    %edi,%eax
  800f6b:	d3 e8                	shr    %cl,%eax
  800f6d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f71:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f75:	8b 54 24 04          	mov    0x4(%esp),%edx
  800f79:	09 c1                	or     %eax,%ecx
  800f7b:	89 d8                	mov    %ebx,%eax
  800f7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f81:	89 e9                	mov    %ebp,%ecx
  800f83:	d3 e7                	shl    %cl,%edi
  800f85:	89 d1                	mov    %edx,%ecx
  800f87:	d3 e8                	shr    %cl,%eax
  800f89:	89 e9                	mov    %ebp,%ecx
  800f8b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800f8f:	d3 e3                	shl    %cl,%ebx
  800f91:	89 c7                	mov    %eax,%edi
  800f93:	89 d1                	mov    %edx,%ecx
  800f95:	89 f0                	mov    %esi,%eax
  800f97:	d3 e8                	shr    %cl,%eax
  800f99:	89 e9                	mov    %ebp,%ecx
  800f9b:	89 fa                	mov    %edi,%edx
  800f9d:	d3 e6                	shl    %cl,%esi
  800f9f:	09 d8                	or     %ebx,%eax
  800fa1:	f7 74 24 08          	divl   0x8(%esp)
  800fa5:	89 d1                	mov    %edx,%ecx
  800fa7:	89 f3                	mov    %esi,%ebx
  800fa9:	f7 64 24 0c          	mull   0xc(%esp)
  800fad:	89 c6                	mov    %eax,%esi
  800faf:	89 d7                	mov    %edx,%edi
  800fb1:	39 d1                	cmp    %edx,%ecx
  800fb3:	72 06                	jb     800fbb <__umoddi3+0x10b>
  800fb5:	75 10                	jne    800fc7 <__umoddi3+0x117>
  800fb7:	39 c3                	cmp    %eax,%ebx
  800fb9:	73 0c                	jae    800fc7 <__umoddi3+0x117>
  800fbb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  800fbf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  800fc3:	89 d7                	mov    %edx,%edi
  800fc5:	89 c6                	mov    %eax,%esi
  800fc7:	89 ca                	mov    %ecx,%edx
  800fc9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800fce:	29 f3                	sub    %esi,%ebx
  800fd0:	19 fa                	sbb    %edi,%edx
  800fd2:	89 d0                	mov    %edx,%eax
  800fd4:	d3 e0                	shl    %cl,%eax
  800fd6:	89 e9                	mov    %ebp,%ecx
  800fd8:	d3 eb                	shr    %cl,%ebx
  800fda:	d3 ea                	shr    %cl,%edx
  800fdc:	09 d8                	or     %ebx,%eax
  800fde:	83 c4 1c             	add    $0x1c,%esp
  800fe1:	5b                   	pop    %ebx
  800fe2:	5e                   	pop    %esi
  800fe3:	5f                   	pop    %edi
  800fe4:	5d                   	pop    %ebp
  800fe5:	c3                   	ret    
  800fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fed:	8d 76 00             	lea    0x0(%esi),%esi
  800ff0:	29 fe                	sub    %edi,%esi
  800ff2:	19 c3                	sbb    %eax,%ebx
  800ff4:	89 f2                	mov    %esi,%edx
  800ff6:	89 d9                	mov    %ebx,%ecx
  800ff8:	e9 1d ff ff ff       	jmp    800f1a <__umoddi3+0x6a>
