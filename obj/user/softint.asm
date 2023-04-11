
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
  800041:	56                   	push   %esi
  800042:	53                   	push   %ebx
  800043:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800046:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800049:	e8 d6 00 00 00       	call   800124 <sys_getenvid>
  80004e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800053:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800056:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005b:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800060:	85 db                	test   %ebx,%ebx
  800062:	7e 07                	jle    80006b <libmain+0x31>
		binaryname = argv[0];
  800064:	8b 06                	mov    (%esi),%eax
  800066:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80006b:	83 ec 08             	sub    $0x8,%esp
  80006e:	56                   	push   %esi
  80006f:	53                   	push   %ebx
  800070:	e8 be ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800075:	e8 0a 00 00 00       	call   800084 <exit>
}
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800080:	5b                   	pop    %ebx
  800081:	5e                   	pop    %esi
  800082:	5d                   	pop    %ebp
  800083:	c3                   	ret    

00800084 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800084:	f3 0f 1e fb          	endbr32 
  800088:	55                   	push   %ebp
  800089:	89 e5                	mov    %esp,%ebp
  80008b:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  80008e:	6a 00                	push   $0x0
  800090:	e8 4a 00 00 00       	call   8000df <sys_env_destroy>
}
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	c9                   	leave  
  800099:	c3                   	ret    

0080009a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80009a:	f3 0f 1e fb          	endbr32 
  80009e:	55                   	push   %ebp
  80009f:	89 e5                	mov    %esp,%ebp
  8000a1:	57                   	push   %edi
  8000a2:	56                   	push   %esi
  8000a3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000af:	89 c3                	mov    %eax,%ebx
  8000b1:	89 c7                	mov    %eax,%edi
  8000b3:	89 c6                	mov    %eax,%esi
  8000b5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b7:	5b                   	pop    %ebx
  8000b8:	5e                   	pop    %esi
  8000b9:	5f                   	pop    %edi
  8000ba:	5d                   	pop    %ebp
  8000bb:	c3                   	ret    

008000bc <sys_cgetc>:

int
sys_cgetc(void)
{
  8000bc:	f3 0f 1e fb          	endbr32 
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	57                   	push   %edi
  8000c4:	56                   	push   %esi
  8000c5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d0:	89 d1                	mov    %edx,%ecx
  8000d2:	89 d3                	mov    %edx,%ebx
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	89 d6                	mov    %edx,%esi
  8000d8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000da:	5b                   	pop    %ebx
  8000db:	5e                   	pop    %esi
  8000dc:	5f                   	pop    %edi
  8000dd:	5d                   	pop    %ebp
  8000de:	c3                   	ret    

008000df <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000df:	f3 0f 1e fb          	endbr32 
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	57                   	push   %edi
  8000e7:	56                   	push   %esi
  8000e8:	53                   	push   %ebx
  8000e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f4:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f9:	89 cb                	mov    %ecx,%ebx
  8000fb:	89 cf                	mov    %ecx,%edi
  8000fd:	89 ce                	mov    %ecx,%esi
  8000ff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800101:	85 c0                	test   %eax,%eax
  800103:	7f 08                	jg     80010d <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800105:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800108:	5b                   	pop    %ebx
  800109:	5e                   	pop    %esi
  80010a:	5f                   	pop    %edi
  80010b:	5d                   	pop    %ebp
  80010c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80010d:	83 ec 0c             	sub    $0xc,%esp
  800110:	50                   	push   %eax
  800111:	6a 03                	push   $0x3
  800113:	68 0a 10 80 00       	push   $0x80100a
  800118:	6a 23                	push   $0x23
  80011a:	68 27 10 80 00       	push   $0x801027
  80011f:	e8 11 02 00 00       	call   800335 <_panic>

00800124 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800124:	f3 0f 1e fb          	endbr32 
  800128:	55                   	push   %ebp
  800129:	89 e5                	mov    %esp,%ebp
  80012b:	57                   	push   %edi
  80012c:	56                   	push   %esi
  80012d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80012e:	ba 00 00 00 00       	mov    $0x0,%edx
  800133:	b8 02 00 00 00       	mov    $0x2,%eax
  800138:	89 d1                	mov    %edx,%ecx
  80013a:	89 d3                	mov    %edx,%ebx
  80013c:	89 d7                	mov    %edx,%edi
  80013e:	89 d6                	mov    %edx,%esi
  800140:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800142:	5b                   	pop    %ebx
  800143:	5e                   	pop    %esi
  800144:	5f                   	pop    %edi
  800145:	5d                   	pop    %ebp
  800146:	c3                   	ret    

00800147 <sys_yield>:

void
sys_yield(void)
{
  800147:	f3 0f 1e fb          	endbr32 
  80014b:	55                   	push   %ebp
  80014c:	89 e5                	mov    %esp,%ebp
  80014e:	57                   	push   %edi
  80014f:	56                   	push   %esi
  800150:	53                   	push   %ebx
	asm volatile("int %1\n"
  800151:	ba 00 00 00 00       	mov    $0x0,%edx
  800156:	b8 0a 00 00 00       	mov    $0xa,%eax
  80015b:	89 d1                	mov    %edx,%ecx
  80015d:	89 d3                	mov    %edx,%ebx
  80015f:	89 d7                	mov    %edx,%edi
  800161:	89 d6                	mov    %edx,%esi
  800163:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800165:	5b                   	pop    %ebx
  800166:	5e                   	pop    %esi
  800167:	5f                   	pop    %edi
  800168:	5d                   	pop    %ebp
  800169:	c3                   	ret    

0080016a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80016a:	f3 0f 1e fb          	endbr32 
  80016e:	55                   	push   %ebp
  80016f:	89 e5                	mov    %esp,%ebp
  800171:	57                   	push   %edi
  800172:	56                   	push   %esi
  800173:	53                   	push   %ebx
  800174:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800177:	be 00 00 00 00       	mov    $0x0,%esi
  80017c:	8b 55 08             	mov    0x8(%ebp),%edx
  80017f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800182:	b8 04 00 00 00       	mov    $0x4,%eax
  800187:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80018a:	89 f7                	mov    %esi,%edi
  80018c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80018e:	85 c0                	test   %eax,%eax
  800190:	7f 08                	jg     80019a <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800192:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800195:	5b                   	pop    %ebx
  800196:	5e                   	pop    %esi
  800197:	5f                   	pop    %edi
  800198:	5d                   	pop    %ebp
  800199:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80019a:	83 ec 0c             	sub    $0xc,%esp
  80019d:	50                   	push   %eax
  80019e:	6a 04                	push   $0x4
  8001a0:	68 0a 10 80 00       	push   $0x80100a
  8001a5:	6a 23                	push   $0x23
  8001a7:	68 27 10 80 00       	push   $0x801027
  8001ac:	e8 84 01 00 00       	call   800335 <_panic>

008001b1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001b1:	f3 0f 1e fb          	endbr32 
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	57                   	push   %edi
  8001b9:	56                   	push   %esi
  8001ba:	53                   	push   %ebx
  8001bb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001be:	8b 55 08             	mov    0x8(%ebp),%edx
  8001c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001c4:	b8 05 00 00 00       	mov    $0x5,%eax
  8001c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001cc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001cf:	8b 75 18             	mov    0x18(%ebp),%esi
  8001d2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001d4:	85 c0                	test   %eax,%eax
  8001d6:	7f 08                	jg     8001e0 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001db:	5b                   	pop    %ebx
  8001dc:	5e                   	pop    %esi
  8001dd:	5f                   	pop    %edi
  8001de:	5d                   	pop    %ebp
  8001df:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001e0:	83 ec 0c             	sub    $0xc,%esp
  8001e3:	50                   	push   %eax
  8001e4:	6a 05                	push   $0x5
  8001e6:	68 0a 10 80 00       	push   $0x80100a
  8001eb:	6a 23                	push   $0x23
  8001ed:	68 27 10 80 00       	push   $0x801027
  8001f2:	e8 3e 01 00 00       	call   800335 <_panic>

008001f7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001f7:	f3 0f 1e fb          	endbr32 
  8001fb:	55                   	push   %ebp
  8001fc:	89 e5                	mov    %esp,%ebp
  8001fe:	57                   	push   %edi
  8001ff:	56                   	push   %esi
  800200:	53                   	push   %ebx
  800201:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800204:	bb 00 00 00 00       	mov    $0x0,%ebx
  800209:	8b 55 08             	mov    0x8(%ebp),%edx
  80020c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80020f:	b8 06 00 00 00       	mov    $0x6,%eax
  800214:	89 df                	mov    %ebx,%edi
  800216:	89 de                	mov    %ebx,%esi
  800218:	cd 30                	int    $0x30
	if(check && ret > 0)
  80021a:	85 c0                	test   %eax,%eax
  80021c:	7f 08                	jg     800226 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80021e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800221:	5b                   	pop    %ebx
  800222:	5e                   	pop    %esi
  800223:	5f                   	pop    %edi
  800224:	5d                   	pop    %ebp
  800225:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800226:	83 ec 0c             	sub    $0xc,%esp
  800229:	50                   	push   %eax
  80022a:	6a 06                	push   $0x6
  80022c:	68 0a 10 80 00       	push   $0x80100a
  800231:	6a 23                	push   $0x23
  800233:	68 27 10 80 00       	push   $0x801027
  800238:	e8 f8 00 00 00       	call   800335 <_panic>

0080023d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80023d:	f3 0f 1e fb          	endbr32 
  800241:	55                   	push   %ebp
  800242:	89 e5                	mov    %esp,%ebp
  800244:	57                   	push   %edi
  800245:	56                   	push   %esi
  800246:	53                   	push   %ebx
  800247:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80024a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80024f:	8b 55 08             	mov    0x8(%ebp),%edx
  800252:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800255:	b8 08 00 00 00       	mov    $0x8,%eax
  80025a:	89 df                	mov    %ebx,%edi
  80025c:	89 de                	mov    %ebx,%esi
  80025e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800260:	85 c0                	test   %eax,%eax
  800262:	7f 08                	jg     80026c <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800264:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800267:	5b                   	pop    %ebx
  800268:	5e                   	pop    %esi
  800269:	5f                   	pop    %edi
  80026a:	5d                   	pop    %ebp
  80026b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	50                   	push   %eax
  800270:	6a 08                	push   $0x8
  800272:	68 0a 10 80 00       	push   $0x80100a
  800277:	6a 23                	push   $0x23
  800279:	68 27 10 80 00       	push   $0x801027
  80027e:	e8 b2 00 00 00       	call   800335 <_panic>

00800283 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800283:	f3 0f 1e fb          	endbr32 
  800287:	55                   	push   %ebp
  800288:	89 e5                	mov    %esp,%ebp
  80028a:	57                   	push   %edi
  80028b:	56                   	push   %esi
  80028c:	53                   	push   %ebx
  80028d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800290:	bb 00 00 00 00       	mov    $0x0,%ebx
  800295:	8b 55 08             	mov    0x8(%ebp),%edx
  800298:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80029b:	b8 09 00 00 00       	mov    $0x9,%eax
  8002a0:	89 df                	mov    %ebx,%edi
  8002a2:	89 de                	mov    %ebx,%esi
  8002a4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002a6:	85 c0                	test   %eax,%eax
  8002a8:	7f 08                	jg     8002b2 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ad:	5b                   	pop    %ebx
  8002ae:	5e                   	pop    %esi
  8002af:	5f                   	pop    %edi
  8002b0:	5d                   	pop    %ebp
  8002b1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002b2:	83 ec 0c             	sub    $0xc,%esp
  8002b5:	50                   	push   %eax
  8002b6:	6a 09                	push   $0x9
  8002b8:	68 0a 10 80 00       	push   $0x80100a
  8002bd:	6a 23                	push   $0x23
  8002bf:	68 27 10 80 00       	push   $0x801027
  8002c4:	e8 6c 00 00 00       	call   800335 <_panic>

008002c9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002c9:	f3 0f 1e fb          	endbr32 
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	57                   	push   %edi
  8002d1:	56                   	push   %esi
  8002d2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d9:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002de:	be 00 00 00 00       	mov    $0x0,%esi
  8002e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002e6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002e9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002eb:	5b                   	pop    %ebx
  8002ec:	5e                   	pop    %esi
  8002ed:	5f                   	pop    %edi
  8002ee:	5d                   	pop    %ebp
  8002ef:	c3                   	ret    

008002f0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002f0:	f3 0f 1e fb          	endbr32 
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	57                   	push   %edi
  8002f8:	56                   	push   %esi
  8002f9:	53                   	push   %ebx
  8002fa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800302:	8b 55 08             	mov    0x8(%ebp),%edx
  800305:	b8 0c 00 00 00       	mov    $0xc,%eax
  80030a:	89 cb                	mov    %ecx,%ebx
  80030c:	89 cf                	mov    %ecx,%edi
  80030e:	89 ce                	mov    %ecx,%esi
  800310:	cd 30                	int    $0x30
	if(check && ret > 0)
  800312:	85 c0                	test   %eax,%eax
  800314:	7f 08                	jg     80031e <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800316:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800319:	5b                   	pop    %ebx
  80031a:	5e                   	pop    %esi
  80031b:	5f                   	pop    %edi
  80031c:	5d                   	pop    %ebp
  80031d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80031e:	83 ec 0c             	sub    $0xc,%esp
  800321:	50                   	push   %eax
  800322:	6a 0c                	push   $0xc
  800324:	68 0a 10 80 00       	push   $0x80100a
  800329:	6a 23                	push   $0x23
  80032b:	68 27 10 80 00       	push   $0x801027
  800330:	e8 00 00 00 00       	call   800335 <_panic>

00800335 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800335:	f3 0f 1e fb          	endbr32 
  800339:	55                   	push   %ebp
  80033a:	89 e5                	mov    %esp,%ebp
  80033c:	56                   	push   %esi
  80033d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80033e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800341:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800347:	e8 d8 fd ff ff       	call   800124 <sys_getenvid>
  80034c:	83 ec 0c             	sub    $0xc,%esp
  80034f:	ff 75 0c             	pushl  0xc(%ebp)
  800352:	ff 75 08             	pushl  0x8(%ebp)
  800355:	56                   	push   %esi
  800356:	50                   	push   %eax
  800357:	68 38 10 80 00       	push   $0x801038
  80035c:	e8 bb 00 00 00       	call   80041c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800361:	83 c4 18             	add    $0x18,%esp
  800364:	53                   	push   %ebx
  800365:	ff 75 10             	pushl  0x10(%ebp)
  800368:	e8 5a 00 00 00       	call   8003c7 <vcprintf>
	cprintf("\n");
  80036d:	c7 04 24 5b 10 80 00 	movl   $0x80105b,(%esp)
  800374:	e8 a3 00 00 00       	call   80041c <cprintf>
  800379:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80037c:	cc                   	int3   
  80037d:	eb fd                	jmp    80037c <_panic+0x47>

0080037f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80037f:	f3 0f 1e fb          	endbr32 
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	53                   	push   %ebx
  800387:	83 ec 04             	sub    $0x4,%esp
  80038a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80038d:	8b 13                	mov    (%ebx),%edx
  80038f:	8d 42 01             	lea    0x1(%edx),%eax
  800392:	89 03                	mov    %eax,(%ebx)
  800394:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800397:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80039b:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a0:	74 09                	je     8003ab <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003a2:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003a9:	c9                   	leave  
  8003aa:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003ab:	83 ec 08             	sub    $0x8,%esp
  8003ae:	68 ff 00 00 00       	push   $0xff
  8003b3:	8d 43 08             	lea    0x8(%ebx),%eax
  8003b6:	50                   	push   %eax
  8003b7:	e8 de fc ff ff       	call   80009a <sys_cputs>
		b->idx = 0;
  8003bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003c2:	83 c4 10             	add    $0x10,%esp
  8003c5:	eb db                	jmp    8003a2 <putch+0x23>

008003c7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003c7:	f3 0f 1e fb          	endbr32 
  8003cb:	55                   	push   %ebp
  8003cc:	89 e5                	mov    %esp,%ebp
  8003ce:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003db:	00 00 00 
	b.cnt = 0;
  8003de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003e5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003e8:	ff 75 0c             	pushl  0xc(%ebp)
  8003eb:	ff 75 08             	pushl  0x8(%ebp)
  8003ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003f4:	50                   	push   %eax
  8003f5:	68 7f 03 80 00       	push   $0x80037f
  8003fa:	e8 20 01 00 00       	call   80051f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003ff:	83 c4 08             	add    $0x8,%esp
  800402:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800408:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80040e:	50                   	push   %eax
  80040f:	e8 86 fc ff ff       	call   80009a <sys_cputs>

	return b.cnt;
}
  800414:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80041a:	c9                   	leave  
  80041b:	c3                   	ret    

0080041c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80041c:	f3 0f 1e fb          	endbr32 
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800426:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800429:	50                   	push   %eax
  80042a:	ff 75 08             	pushl  0x8(%ebp)
  80042d:	e8 95 ff ff ff       	call   8003c7 <vcprintf>
	va_end(ap);

	return cnt;
}
  800432:	c9                   	leave  
  800433:	c3                   	ret    

00800434 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800434:	55                   	push   %ebp
  800435:	89 e5                	mov    %esp,%ebp
  800437:	57                   	push   %edi
  800438:	56                   	push   %esi
  800439:	53                   	push   %ebx
  80043a:	83 ec 1c             	sub    $0x1c,%esp
  80043d:	89 c7                	mov    %eax,%edi
  80043f:	89 d6                	mov    %edx,%esi
  800441:	8b 45 08             	mov    0x8(%ebp),%eax
  800444:	8b 55 0c             	mov    0xc(%ebp),%edx
  800447:	89 d1                	mov    %edx,%ecx
  800449:	89 c2                	mov    %eax,%edx
  80044b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80044e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800451:	8b 45 10             	mov    0x10(%ebp),%eax
  800454:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800457:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800461:	39 c2                	cmp    %eax,%edx
  800463:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800466:	72 3e                	jb     8004a6 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800468:	83 ec 0c             	sub    $0xc,%esp
  80046b:	ff 75 18             	pushl  0x18(%ebp)
  80046e:	83 eb 01             	sub    $0x1,%ebx
  800471:	53                   	push   %ebx
  800472:	50                   	push   %eax
  800473:	83 ec 08             	sub    $0x8,%esp
  800476:	ff 75 e4             	pushl  -0x1c(%ebp)
  800479:	ff 75 e0             	pushl  -0x20(%ebp)
  80047c:	ff 75 dc             	pushl  -0x24(%ebp)
  80047f:	ff 75 d8             	pushl  -0x28(%ebp)
  800482:	e8 19 09 00 00       	call   800da0 <__udivdi3>
  800487:	83 c4 18             	add    $0x18,%esp
  80048a:	52                   	push   %edx
  80048b:	50                   	push   %eax
  80048c:	89 f2                	mov    %esi,%edx
  80048e:	89 f8                	mov    %edi,%eax
  800490:	e8 9f ff ff ff       	call   800434 <printnum>
  800495:	83 c4 20             	add    $0x20,%esp
  800498:	eb 13                	jmp    8004ad <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	56                   	push   %esi
  80049e:	ff 75 18             	pushl  0x18(%ebp)
  8004a1:	ff d7                	call   *%edi
  8004a3:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004a6:	83 eb 01             	sub    $0x1,%ebx
  8004a9:	85 db                	test   %ebx,%ebx
  8004ab:	7f ed                	jg     80049a <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004ad:	83 ec 08             	sub    $0x8,%esp
  8004b0:	56                   	push   %esi
  8004b1:	83 ec 04             	sub    $0x4,%esp
  8004b4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004b7:	ff 75 e0             	pushl  -0x20(%ebp)
  8004ba:	ff 75 dc             	pushl  -0x24(%ebp)
  8004bd:	ff 75 d8             	pushl  -0x28(%ebp)
  8004c0:	e8 eb 09 00 00       	call   800eb0 <__umoddi3>
  8004c5:	83 c4 14             	add    $0x14,%esp
  8004c8:	0f be 80 5d 10 80 00 	movsbl 0x80105d(%eax),%eax
  8004cf:	50                   	push   %eax
  8004d0:	ff d7                	call   *%edi
}
  8004d2:	83 c4 10             	add    $0x10,%esp
  8004d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004d8:	5b                   	pop    %ebx
  8004d9:	5e                   	pop    %esi
  8004da:	5f                   	pop    %edi
  8004db:	5d                   	pop    %ebp
  8004dc:	c3                   	ret    

008004dd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004dd:	f3 0f 1e fb          	endbr32 
  8004e1:	55                   	push   %ebp
  8004e2:	89 e5                	mov    %esp,%ebp
  8004e4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004e7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004eb:	8b 10                	mov    (%eax),%edx
  8004ed:	3b 50 04             	cmp    0x4(%eax),%edx
  8004f0:	73 0a                	jae    8004fc <sprintputch+0x1f>
		*b->buf++ = ch;
  8004f2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004f5:	89 08                	mov    %ecx,(%eax)
  8004f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fa:	88 02                	mov    %al,(%edx)
}
  8004fc:	5d                   	pop    %ebp
  8004fd:	c3                   	ret    

008004fe <printfmt>:
{
  8004fe:	f3 0f 1e fb          	endbr32 
  800502:	55                   	push   %ebp
  800503:	89 e5                	mov    %esp,%ebp
  800505:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800508:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80050b:	50                   	push   %eax
  80050c:	ff 75 10             	pushl  0x10(%ebp)
  80050f:	ff 75 0c             	pushl  0xc(%ebp)
  800512:	ff 75 08             	pushl  0x8(%ebp)
  800515:	e8 05 00 00 00       	call   80051f <vprintfmt>
}
  80051a:	83 c4 10             	add    $0x10,%esp
  80051d:	c9                   	leave  
  80051e:	c3                   	ret    

0080051f <vprintfmt>:
{
  80051f:	f3 0f 1e fb          	endbr32 
  800523:	55                   	push   %ebp
  800524:	89 e5                	mov    %esp,%ebp
  800526:	57                   	push   %edi
  800527:	56                   	push   %esi
  800528:	53                   	push   %ebx
  800529:	83 ec 3c             	sub    $0x3c,%esp
  80052c:	8b 75 08             	mov    0x8(%ebp),%esi
  80052f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800532:	8b 7d 10             	mov    0x10(%ebp),%edi
  800535:	e9 8e 03 00 00       	jmp    8008c8 <vprintfmt+0x3a9>
		padc = ' ';
  80053a:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80053e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800545:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80054c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800553:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800558:	8d 47 01             	lea    0x1(%edi),%eax
  80055b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80055e:	0f b6 17             	movzbl (%edi),%edx
  800561:	8d 42 dd             	lea    -0x23(%edx),%eax
  800564:	3c 55                	cmp    $0x55,%al
  800566:	0f 87 df 03 00 00    	ja     80094b <vprintfmt+0x42c>
  80056c:	0f b6 c0             	movzbl %al,%eax
  80056f:	3e ff 24 85 20 11 80 	notrack jmp *0x801120(,%eax,4)
  800576:	00 
  800577:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80057a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80057e:	eb d8                	jmp    800558 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800580:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800583:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800587:	eb cf                	jmp    800558 <vprintfmt+0x39>
  800589:	0f b6 d2             	movzbl %dl,%edx
  80058c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80058f:	b8 00 00 00 00       	mov    $0x0,%eax
  800594:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800597:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80059a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80059e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005a1:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005a4:	83 f9 09             	cmp    $0x9,%ecx
  8005a7:	77 55                	ja     8005fe <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8005a9:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005ac:	eb e9                	jmp    800597 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	8d 40 04             	lea    0x4(%eax),%eax
  8005bc:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005c2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005c6:	79 90                	jns    800558 <vprintfmt+0x39>
				width = precision, precision = -1;
  8005c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ce:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005d5:	eb 81                	jmp    800558 <vprintfmt+0x39>
  8005d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005da:	85 c0                	test   %eax,%eax
  8005dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e1:	0f 49 d0             	cmovns %eax,%edx
  8005e4:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005ea:	e9 69 ff ff ff       	jmp    800558 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8005ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005f2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8005f9:	e9 5a ff ff ff       	jmp    800558 <vprintfmt+0x39>
  8005fe:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800601:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800604:	eb bc                	jmp    8005c2 <vprintfmt+0xa3>
			lflag++;
  800606:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800609:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80060c:	e9 47 ff ff ff       	jmp    800558 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	8d 78 04             	lea    0x4(%eax),%edi
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	53                   	push   %ebx
  80061b:	ff 30                	pushl  (%eax)
  80061d:	ff d6                	call   *%esi
			break;
  80061f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800622:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800625:	e9 9b 02 00 00       	jmp    8008c5 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8d 78 04             	lea    0x4(%eax),%edi
  800630:	8b 00                	mov    (%eax),%eax
  800632:	99                   	cltd   
  800633:	31 d0                	xor    %edx,%eax
  800635:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800637:	83 f8 08             	cmp    $0x8,%eax
  80063a:	7f 23                	jg     80065f <vprintfmt+0x140>
  80063c:	8b 14 85 80 12 80 00 	mov    0x801280(,%eax,4),%edx
  800643:	85 d2                	test   %edx,%edx
  800645:	74 18                	je     80065f <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800647:	52                   	push   %edx
  800648:	68 7e 10 80 00       	push   $0x80107e
  80064d:	53                   	push   %ebx
  80064e:	56                   	push   %esi
  80064f:	e8 aa fe ff ff       	call   8004fe <printfmt>
  800654:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800657:	89 7d 14             	mov    %edi,0x14(%ebp)
  80065a:	e9 66 02 00 00       	jmp    8008c5 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80065f:	50                   	push   %eax
  800660:	68 75 10 80 00       	push   $0x801075
  800665:	53                   	push   %ebx
  800666:	56                   	push   %esi
  800667:	e8 92 fe ff ff       	call   8004fe <printfmt>
  80066c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80066f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800672:	e9 4e 02 00 00       	jmp    8008c5 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	83 c0 04             	add    $0x4,%eax
  80067d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800685:	85 d2                	test   %edx,%edx
  800687:	b8 6e 10 80 00       	mov    $0x80106e,%eax
  80068c:	0f 45 c2             	cmovne %edx,%eax
  80068f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800692:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800696:	7e 06                	jle    80069e <vprintfmt+0x17f>
  800698:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80069c:	75 0d                	jne    8006ab <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80069e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006a1:	89 c7                	mov    %eax,%edi
  8006a3:	03 45 e0             	add    -0x20(%ebp),%eax
  8006a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a9:	eb 55                	jmp    800700 <vprintfmt+0x1e1>
  8006ab:	83 ec 08             	sub    $0x8,%esp
  8006ae:	ff 75 d8             	pushl  -0x28(%ebp)
  8006b1:	ff 75 cc             	pushl  -0x34(%ebp)
  8006b4:	e8 46 03 00 00       	call   8009ff <strnlen>
  8006b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006bc:	29 c2                	sub    %eax,%edx
  8006be:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006c1:	83 c4 10             	add    $0x10,%esp
  8006c4:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006c6:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006cd:	85 ff                	test   %edi,%edi
  8006cf:	7e 11                	jle    8006e2 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8006d1:	83 ec 08             	sub    $0x8,%esp
  8006d4:	53                   	push   %ebx
  8006d5:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006da:	83 ef 01             	sub    $0x1,%edi
  8006dd:	83 c4 10             	add    $0x10,%esp
  8006e0:	eb eb                	jmp    8006cd <vprintfmt+0x1ae>
  8006e2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006e5:	85 d2                	test   %edx,%edx
  8006e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ec:	0f 49 c2             	cmovns %edx,%eax
  8006ef:	29 c2                	sub    %eax,%edx
  8006f1:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8006f4:	eb a8                	jmp    80069e <vprintfmt+0x17f>
					putch(ch, putdat);
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	53                   	push   %ebx
  8006fa:	52                   	push   %edx
  8006fb:	ff d6                	call   *%esi
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800703:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800705:	83 c7 01             	add    $0x1,%edi
  800708:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80070c:	0f be d0             	movsbl %al,%edx
  80070f:	85 d2                	test   %edx,%edx
  800711:	74 4b                	je     80075e <vprintfmt+0x23f>
  800713:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800717:	78 06                	js     80071f <vprintfmt+0x200>
  800719:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80071d:	78 1e                	js     80073d <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80071f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800723:	74 d1                	je     8006f6 <vprintfmt+0x1d7>
  800725:	0f be c0             	movsbl %al,%eax
  800728:	83 e8 20             	sub    $0x20,%eax
  80072b:	83 f8 5e             	cmp    $0x5e,%eax
  80072e:	76 c6                	jbe    8006f6 <vprintfmt+0x1d7>
					putch('?', putdat);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	53                   	push   %ebx
  800734:	6a 3f                	push   $0x3f
  800736:	ff d6                	call   *%esi
  800738:	83 c4 10             	add    $0x10,%esp
  80073b:	eb c3                	jmp    800700 <vprintfmt+0x1e1>
  80073d:	89 cf                	mov    %ecx,%edi
  80073f:	eb 0e                	jmp    80074f <vprintfmt+0x230>
				putch(' ', putdat);
  800741:	83 ec 08             	sub    $0x8,%esp
  800744:	53                   	push   %ebx
  800745:	6a 20                	push   $0x20
  800747:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800749:	83 ef 01             	sub    $0x1,%edi
  80074c:	83 c4 10             	add    $0x10,%esp
  80074f:	85 ff                	test   %edi,%edi
  800751:	7f ee                	jg     800741 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800753:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800756:	89 45 14             	mov    %eax,0x14(%ebp)
  800759:	e9 67 01 00 00       	jmp    8008c5 <vprintfmt+0x3a6>
  80075e:	89 cf                	mov    %ecx,%edi
  800760:	eb ed                	jmp    80074f <vprintfmt+0x230>
	if (lflag >= 2)
  800762:	83 f9 01             	cmp    $0x1,%ecx
  800765:	7f 1b                	jg     800782 <vprintfmt+0x263>
	else if (lflag)
  800767:	85 c9                	test   %ecx,%ecx
  800769:	74 63                	je     8007ce <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80076b:	8b 45 14             	mov    0x14(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800773:	99                   	cltd   
  800774:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	8d 40 04             	lea    0x4(%eax),%eax
  80077d:	89 45 14             	mov    %eax,0x14(%ebp)
  800780:	eb 17                	jmp    800799 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800782:	8b 45 14             	mov    0x14(%ebp),%eax
  800785:	8b 50 04             	mov    0x4(%eax),%edx
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800790:	8b 45 14             	mov    0x14(%ebp),%eax
  800793:	8d 40 08             	lea    0x8(%eax),%eax
  800796:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800799:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80079c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80079f:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007a4:	85 c9                	test   %ecx,%ecx
  8007a6:	0f 89 ff 00 00 00    	jns    8008ab <vprintfmt+0x38c>
				putch('-', putdat);
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	53                   	push   %ebx
  8007b0:	6a 2d                	push   $0x2d
  8007b2:	ff d6                	call   *%esi
				num = -(long long) num;
  8007b4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007b7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007ba:	f7 da                	neg    %edx
  8007bc:	83 d1 00             	adc    $0x0,%ecx
  8007bf:	f7 d9                	neg    %ecx
  8007c1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007c4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c9:	e9 dd 00 00 00       	jmp    8008ab <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d6:	99                   	cltd   
  8007d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	8d 40 04             	lea    0x4(%eax),%eax
  8007e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e3:	eb b4                	jmp    800799 <vprintfmt+0x27a>
	if (lflag >= 2)
  8007e5:	83 f9 01             	cmp    $0x1,%ecx
  8007e8:	7f 1e                	jg     800808 <vprintfmt+0x2e9>
	else if (lflag)
  8007ea:	85 c9                	test   %ecx,%ecx
  8007ec:	74 32                	je     800820 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	8b 10                	mov    (%eax),%edx
  8007f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007f8:	8d 40 04             	lea    0x4(%eax),%eax
  8007fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007fe:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800803:	e9 a3 00 00 00       	jmp    8008ab <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8b 10                	mov    (%eax),%edx
  80080d:	8b 48 04             	mov    0x4(%eax),%ecx
  800810:	8d 40 08             	lea    0x8(%eax),%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800816:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80081b:	e9 8b 00 00 00       	jmp    8008ab <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800820:	8b 45 14             	mov    0x14(%ebp),%eax
  800823:	8b 10                	mov    (%eax),%edx
  800825:	b9 00 00 00 00       	mov    $0x0,%ecx
  80082a:	8d 40 04             	lea    0x4(%eax),%eax
  80082d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800830:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800835:	eb 74                	jmp    8008ab <vprintfmt+0x38c>
	if (lflag >= 2)
  800837:	83 f9 01             	cmp    $0x1,%ecx
  80083a:	7f 1b                	jg     800857 <vprintfmt+0x338>
	else if (lflag)
  80083c:	85 c9                	test   %ecx,%ecx
  80083e:	74 2c                	je     80086c <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	8b 10                	mov    (%eax),%edx
  800845:	b9 00 00 00 00       	mov    $0x0,%ecx
  80084a:	8d 40 04             	lea    0x4(%eax),%eax
  80084d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800850:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800855:	eb 54                	jmp    8008ab <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800857:	8b 45 14             	mov    0x14(%ebp),%eax
  80085a:	8b 10                	mov    (%eax),%edx
  80085c:	8b 48 04             	mov    0x4(%eax),%ecx
  80085f:	8d 40 08             	lea    0x8(%eax),%eax
  800862:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800865:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80086a:	eb 3f                	jmp    8008ab <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80086c:	8b 45 14             	mov    0x14(%ebp),%eax
  80086f:	8b 10                	mov    (%eax),%edx
  800871:	b9 00 00 00 00       	mov    $0x0,%ecx
  800876:	8d 40 04             	lea    0x4(%eax),%eax
  800879:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80087c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800881:	eb 28                	jmp    8008ab <vprintfmt+0x38c>
			putch('0', putdat);
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	53                   	push   %ebx
  800887:	6a 30                	push   $0x30
  800889:	ff d6                	call   *%esi
			putch('x', putdat);
  80088b:	83 c4 08             	add    $0x8,%esp
  80088e:	53                   	push   %ebx
  80088f:	6a 78                	push   $0x78
  800891:	ff d6                	call   *%esi
			num = (unsigned long long)
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	8b 10                	mov    (%eax),%edx
  800898:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80089d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008a0:	8d 40 04             	lea    0x4(%eax),%eax
  8008a3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a6:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008ab:	83 ec 0c             	sub    $0xc,%esp
  8008ae:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8008b2:	57                   	push   %edi
  8008b3:	ff 75 e0             	pushl  -0x20(%ebp)
  8008b6:	50                   	push   %eax
  8008b7:	51                   	push   %ecx
  8008b8:	52                   	push   %edx
  8008b9:	89 da                	mov    %ebx,%edx
  8008bb:	89 f0                	mov    %esi,%eax
  8008bd:	e8 72 fb ff ff       	call   800434 <printnum>
			break;
  8008c2:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c8:	83 c7 01             	add    $0x1,%edi
  8008cb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008cf:	83 f8 25             	cmp    $0x25,%eax
  8008d2:	0f 84 62 fc ff ff    	je     80053a <vprintfmt+0x1b>
			if (ch == '\0')
  8008d8:	85 c0                	test   %eax,%eax
  8008da:	0f 84 8b 00 00 00    	je     80096b <vprintfmt+0x44c>
			putch(ch, putdat);
  8008e0:	83 ec 08             	sub    $0x8,%esp
  8008e3:	53                   	push   %ebx
  8008e4:	50                   	push   %eax
  8008e5:	ff d6                	call   *%esi
  8008e7:	83 c4 10             	add    $0x10,%esp
  8008ea:	eb dc                	jmp    8008c8 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8008ec:	83 f9 01             	cmp    $0x1,%ecx
  8008ef:	7f 1b                	jg     80090c <vprintfmt+0x3ed>
	else if (lflag)
  8008f1:	85 c9                	test   %ecx,%ecx
  8008f3:	74 2c                	je     800921 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8008f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f8:	8b 10                	mov    (%eax),%edx
  8008fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008ff:	8d 40 04             	lea    0x4(%eax),%eax
  800902:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800905:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80090a:	eb 9f                	jmp    8008ab <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	8b 10                	mov    (%eax),%edx
  800911:	8b 48 04             	mov    0x4(%eax),%ecx
  800914:	8d 40 08             	lea    0x8(%eax),%eax
  800917:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80091a:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80091f:	eb 8a                	jmp    8008ab <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800921:	8b 45 14             	mov    0x14(%ebp),%eax
  800924:	8b 10                	mov    (%eax),%edx
  800926:	b9 00 00 00 00       	mov    $0x0,%ecx
  80092b:	8d 40 04             	lea    0x4(%eax),%eax
  80092e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800931:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800936:	e9 70 ff ff ff       	jmp    8008ab <vprintfmt+0x38c>
			putch(ch, putdat);
  80093b:	83 ec 08             	sub    $0x8,%esp
  80093e:	53                   	push   %ebx
  80093f:	6a 25                	push   $0x25
  800941:	ff d6                	call   *%esi
			break;
  800943:	83 c4 10             	add    $0x10,%esp
  800946:	e9 7a ff ff ff       	jmp    8008c5 <vprintfmt+0x3a6>
			putch('%', putdat);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	53                   	push   %ebx
  80094f:	6a 25                	push   $0x25
  800951:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800953:	83 c4 10             	add    $0x10,%esp
  800956:	89 f8                	mov    %edi,%eax
  800958:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80095c:	74 05                	je     800963 <vprintfmt+0x444>
  80095e:	83 e8 01             	sub    $0x1,%eax
  800961:	eb f5                	jmp    800958 <vprintfmt+0x439>
  800963:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800966:	e9 5a ff ff ff       	jmp    8008c5 <vprintfmt+0x3a6>
}
  80096b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80096e:	5b                   	pop    %ebx
  80096f:	5e                   	pop    %esi
  800970:	5f                   	pop    %edi
  800971:	5d                   	pop    %ebp
  800972:	c3                   	ret    

00800973 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800973:	f3 0f 1e fb          	endbr32 
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	83 ec 18             	sub    $0x18,%esp
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800983:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800986:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80098a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80098d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800994:	85 c0                	test   %eax,%eax
  800996:	74 26                	je     8009be <vsnprintf+0x4b>
  800998:	85 d2                	test   %edx,%edx
  80099a:	7e 22                	jle    8009be <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80099c:	ff 75 14             	pushl  0x14(%ebp)
  80099f:	ff 75 10             	pushl  0x10(%ebp)
  8009a2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009a5:	50                   	push   %eax
  8009a6:	68 dd 04 80 00       	push   $0x8004dd
  8009ab:	e8 6f fb ff ff       	call   80051f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009b9:	83 c4 10             	add    $0x10,%esp
}
  8009bc:	c9                   	leave  
  8009bd:	c3                   	ret    
		return -E_INVAL;
  8009be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009c3:	eb f7                	jmp    8009bc <vsnprintf+0x49>

008009c5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009c5:	f3 0f 1e fb          	endbr32 
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009cf:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009d2:	50                   	push   %eax
  8009d3:	ff 75 10             	pushl  0x10(%ebp)
  8009d6:	ff 75 0c             	pushl  0xc(%ebp)
  8009d9:	ff 75 08             	pushl  0x8(%ebp)
  8009dc:	e8 92 ff ff ff       	call   800973 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009e1:	c9                   	leave  
  8009e2:	c3                   	ret    

008009e3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009e3:	f3 0f 1e fb          	endbr32 
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009f6:	74 05                	je     8009fd <strlen+0x1a>
		n++;
  8009f8:	83 c0 01             	add    $0x1,%eax
  8009fb:	eb f5                	jmp    8009f2 <strlen+0xf>
	return n;
}
  8009fd:	5d                   	pop    %ebp
  8009fe:	c3                   	ret    

008009ff <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009ff:	f3 0f 1e fb          	endbr32 
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a09:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a11:	39 d0                	cmp    %edx,%eax
  800a13:	74 0d                	je     800a22 <strnlen+0x23>
  800a15:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a19:	74 05                	je     800a20 <strnlen+0x21>
		n++;
  800a1b:	83 c0 01             	add    $0x1,%eax
  800a1e:	eb f1                	jmp    800a11 <strnlen+0x12>
  800a20:	89 c2                	mov    %eax,%edx
	return n;
}
  800a22:	89 d0                	mov    %edx,%eax
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a26:	f3 0f 1e fb          	endbr32 
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	53                   	push   %ebx
  800a2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a34:	b8 00 00 00 00       	mov    $0x0,%eax
  800a39:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800a3d:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800a40:	83 c0 01             	add    $0x1,%eax
  800a43:	84 d2                	test   %dl,%dl
  800a45:	75 f2                	jne    800a39 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800a47:	89 c8                	mov    %ecx,%eax
  800a49:	5b                   	pop    %ebx
  800a4a:	5d                   	pop    %ebp
  800a4b:	c3                   	ret    

00800a4c <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a4c:	f3 0f 1e fb          	endbr32 
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	53                   	push   %ebx
  800a54:	83 ec 10             	sub    $0x10,%esp
  800a57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a5a:	53                   	push   %ebx
  800a5b:	e8 83 ff ff ff       	call   8009e3 <strlen>
  800a60:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a63:	ff 75 0c             	pushl  0xc(%ebp)
  800a66:	01 d8                	add    %ebx,%eax
  800a68:	50                   	push   %eax
  800a69:	e8 b8 ff ff ff       	call   800a26 <strcpy>
	return dst;
}
  800a6e:	89 d8                	mov    %ebx,%eax
  800a70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a73:	c9                   	leave  
  800a74:	c3                   	ret    

00800a75 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a75:	f3 0f 1e fb          	endbr32 
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	56                   	push   %esi
  800a7d:	53                   	push   %ebx
  800a7e:	8b 75 08             	mov    0x8(%ebp),%esi
  800a81:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a84:	89 f3                	mov    %esi,%ebx
  800a86:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a89:	89 f0                	mov    %esi,%eax
  800a8b:	39 d8                	cmp    %ebx,%eax
  800a8d:	74 11                	je     800aa0 <strncpy+0x2b>
		*dst++ = *src;
  800a8f:	83 c0 01             	add    $0x1,%eax
  800a92:	0f b6 0a             	movzbl (%edx),%ecx
  800a95:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a98:	80 f9 01             	cmp    $0x1,%cl
  800a9b:	83 da ff             	sbb    $0xffffffff,%edx
  800a9e:	eb eb                	jmp    800a8b <strncpy+0x16>
	}
	return ret;
}
  800aa0:	89 f0                	mov    %esi,%eax
  800aa2:	5b                   	pop    %ebx
  800aa3:	5e                   	pop    %esi
  800aa4:	5d                   	pop    %ebp
  800aa5:	c3                   	ret    

00800aa6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aa6:	f3 0f 1e fb          	endbr32 
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	56                   	push   %esi
  800aae:	53                   	push   %ebx
  800aaf:	8b 75 08             	mov    0x8(%ebp),%esi
  800ab2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ab5:	8b 55 10             	mov    0x10(%ebp),%edx
  800ab8:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800aba:	85 d2                	test   %edx,%edx
  800abc:	74 21                	je     800adf <strlcpy+0x39>
  800abe:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ac2:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ac4:	39 c2                	cmp    %eax,%edx
  800ac6:	74 14                	je     800adc <strlcpy+0x36>
  800ac8:	0f b6 19             	movzbl (%ecx),%ebx
  800acb:	84 db                	test   %bl,%bl
  800acd:	74 0b                	je     800ada <strlcpy+0x34>
			*dst++ = *src++;
  800acf:	83 c1 01             	add    $0x1,%ecx
  800ad2:	83 c2 01             	add    $0x1,%edx
  800ad5:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ad8:	eb ea                	jmp    800ac4 <strlcpy+0x1e>
  800ada:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800adc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800adf:	29 f0                	sub    %esi,%eax
}
  800ae1:	5b                   	pop    %ebx
  800ae2:	5e                   	pop    %esi
  800ae3:	5d                   	pop    %ebp
  800ae4:	c3                   	ret    

00800ae5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ae5:	f3 0f 1e fb          	endbr32 
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aef:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800af2:	0f b6 01             	movzbl (%ecx),%eax
  800af5:	84 c0                	test   %al,%al
  800af7:	74 0c                	je     800b05 <strcmp+0x20>
  800af9:	3a 02                	cmp    (%edx),%al
  800afb:	75 08                	jne    800b05 <strcmp+0x20>
		p++, q++;
  800afd:	83 c1 01             	add    $0x1,%ecx
  800b00:	83 c2 01             	add    $0x1,%edx
  800b03:	eb ed                	jmp    800af2 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b05:	0f b6 c0             	movzbl %al,%eax
  800b08:	0f b6 12             	movzbl (%edx),%edx
  800b0b:	29 d0                	sub    %edx,%eax
}
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    

00800b0f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b0f:	f3 0f 1e fb          	endbr32 
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	53                   	push   %ebx
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1d:	89 c3                	mov    %eax,%ebx
  800b1f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b22:	eb 06                	jmp    800b2a <strncmp+0x1b>
		n--, p++, q++;
  800b24:	83 c0 01             	add    $0x1,%eax
  800b27:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b2a:	39 d8                	cmp    %ebx,%eax
  800b2c:	74 16                	je     800b44 <strncmp+0x35>
  800b2e:	0f b6 08             	movzbl (%eax),%ecx
  800b31:	84 c9                	test   %cl,%cl
  800b33:	74 04                	je     800b39 <strncmp+0x2a>
  800b35:	3a 0a                	cmp    (%edx),%cl
  800b37:	74 eb                	je     800b24 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b39:	0f b6 00             	movzbl (%eax),%eax
  800b3c:	0f b6 12             	movzbl (%edx),%edx
  800b3f:	29 d0                	sub    %edx,%eax
}
  800b41:	5b                   	pop    %ebx
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    
		return 0;
  800b44:	b8 00 00 00 00       	mov    $0x0,%eax
  800b49:	eb f6                	jmp    800b41 <strncmp+0x32>

00800b4b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b4b:	f3 0f 1e fb          	endbr32 
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b59:	0f b6 10             	movzbl (%eax),%edx
  800b5c:	84 d2                	test   %dl,%dl
  800b5e:	74 09                	je     800b69 <strchr+0x1e>
		if (*s == c)
  800b60:	38 ca                	cmp    %cl,%dl
  800b62:	74 0a                	je     800b6e <strchr+0x23>
	for (; *s; s++)
  800b64:	83 c0 01             	add    $0x1,%eax
  800b67:	eb f0                	jmp    800b59 <strchr+0xe>
			return (char *) s;
	return 0;
  800b69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b70:	f3 0f 1e fb          	endbr32 
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b7e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b81:	38 ca                	cmp    %cl,%dl
  800b83:	74 09                	je     800b8e <strfind+0x1e>
  800b85:	84 d2                	test   %dl,%dl
  800b87:	74 05                	je     800b8e <strfind+0x1e>
	for (; *s; s++)
  800b89:	83 c0 01             	add    $0x1,%eax
  800b8c:	eb f0                	jmp    800b7e <strfind+0xe>
			break;
	return (char *) s;
}
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b90:	f3 0f 1e fb          	endbr32 
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	57                   	push   %edi
  800b98:	56                   	push   %esi
  800b99:	53                   	push   %ebx
  800b9a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ba0:	85 c9                	test   %ecx,%ecx
  800ba2:	74 31                	je     800bd5 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ba4:	89 f8                	mov    %edi,%eax
  800ba6:	09 c8                	or     %ecx,%eax
  800ba8:	a8 03                	test   $0x3,%al
  800baa:	75 23                	jne    800bcf <memset+0x3f>
		c &= 0xFF;
  800bac:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bb0:	89 d3                	mov    %edx,%ebx
  800bb2:	c1 e3 08             	shl    $0x8,%ebx
  800bb5:	89 d0                	mov    %edx,%eax
  800bb7:	c1 e0 18             	shl    $0x18,%eax
  800bba:	89 d6                	mov    %edx,%esi
  800bbc:	c1 e6 10             	shl    $0x10,%esi
  800bbf:	09 f0                	or     %esi,%eax
  800bc1:	09 c2                	or     %eax,%edx
  800bc3:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bc5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bc8:	89 d0                	mov    %edx,%eax
  800bca:	fc                   	cld    
  800bcb:	f3 ab                	rep stos %eax,%es:(%edi)
  800bcd:	eb 06                	jmp    800bd5 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd2:	fc                   	cld    
  800bd3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bd5:	89 f8                	mov    %edi,%eax
  800bd7:	5b                   	pop    %ebx
  800bd8:	5e                   	pop    %esi
  800bd9:	5f                   	pop    %edi
  800bda:	5d                   	pop    %ebp
  800bdb:	c3                   	ret    

00800bdc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bdc:	f3 0f 1e fb          	endbr32 
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	57                   	push   %edi
  800be4:	56                   	push   %esi
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800beb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bee:	39 c6                	cmp    %eax,%esi
  800bf0:	73 32                	jae    800c24 <memmove+0x48>
  800bf2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bf5:	39 c2                	cmp    %eax,%edx
  800bf7:	76 2b                	jbe    800c24 <memmove+0x48>
		s += n;
		d += n;
  800bf9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bfc:	89 fe                	mov    %edi,%esi
  800bfe:	09 ce                	or     %ecx,%esi
  800c00:	09 d6                	or     %edx,%esi
  800c02:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c08:	75 0e                	jne    800c18 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c0a:	83 ef 04             	sub    $0x4,%edi
  800c0d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c10:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c13:	fd                   	std    
  800c14:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c16:	eb 09                	jmp    800c21 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c18:	83 ef 01             	sub    $0x1,%edi
  800c1b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c1e:	fd                   	std    
  800c1f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c21:	fc                   	cld    
  800c22:	eb 1a                	jmp    800c3e <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c24:	89 c2                	mov    %eax,%edx
  800c26:	09 ca                	or     %ecx,%edx
  800c28:	09 f2                	or     %esi,%edx
  800c2a:	f6 c2 03             	test   $0x3,%dl
  800c2d:	75 0a                	jne    800c39 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c2f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c32:	89 c7                	mov    %eax,%edi
  800c34:	fc                   	cld    
  800c35:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c37:	eb 05                	jmp    800c3e <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800c39:	89 c7                	mov    %eax,%edi
  800c3b:	fc                   	cld    
  800c3c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c3e:	5e                   	pop    %esi
  800c3f:	5f                   	pop    %edi
  800c40:	5d                   	pop    %ebp
  800c41:	c3                   	ret    

00800c42 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c42:	f3 0f 1e fb          	endbr32 
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c4c:	ff 75 10             	pushl  0x10(%ebp)
  800c4f:	ff 75 0c             	pushl  0xc(%ebp)
  800c52:	ff 75 08             	pushl  0x8(%ebp)
  800c55:	e8 82 ff ff ff       	call   800bdc <memmove>
}
  800c5a:	c9                   	leave  
  800c5b:	c3                   	ret    

00800c5c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c5c:	f3 0f 1e fb          	endbr32 
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	56                   	push   %esi
  800c64:	53                   	push   %ebx
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6b:	89 c6                	mov    %eax,%esi
  800c6d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c70:	39 f0                	cmp    %esi,%eax
  800c72:	74 1c                	je     800c90 <memcmp+0x34>
		if (*s1 != *s2)
  800c74:	0f b6 08             	movzbl (%eax),%ecx
  800c77:	0f b6 1a             	movzbl (%edx),%ebx
  800c7a:	38 d9                	cmp    %bl,%cl
  800c7c:	75 08                	jne    800c86 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c7e:	83 c0 01             	add    $0x1,%eax
  800c81:	83 c2 01             	add    $0x1,%edx
  800c84:	eb ea                	jmp    800c70 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800c86:	0f b6 c1             	movzbl %cl,%eax
  800c89:	0f b6 db             	movzbl %bl,%ebx
  800c8c:	29 d8                	sub    %ebx,%eax
  800c8e:	eb 05                	jmp    800c95 <memcmp+0x39>
	}

	return 0;
  800c90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c95:	5b                   	pop    %ebx
  800c96:	5e                   	pop    %esi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c99:	f3 0f 1e fb          	endbr32 
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ca6:	89 c2                	mov    %eax,%edx
  800ca8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cab:	39 d0                	cmp    %edx,%eax
  800cad:	73 09                	jae    800cb8 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800caf:	38 08                	cmp    %cl,(%eax)
  800cb1:	74 05                	je     800cb8 <memfind+0x1f>
	for (; s < ends; s++)
  800cb3:	83 c0 01             	add    $0x1,%eax
  800cb6:	eb f3                	jmp    800cab <memfind+0x12>
			break;
	return (void *) s;
}
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    

00800cba <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cba:	f3 0f 1e fb          	endbr32 
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	57                   	push   %edi
  800cc2:	56                   	push   %esi
  800cc3:	53                   	push   %ebx
  800cc4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cc7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cca:	eb 03                	jmp    800ccf <strtol+0x15>
		s++;
  800ccc:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ccf:	0f b6 01             	movzbl (%ecx),%eax
  800cd2:	3c 20                	cmp    $0x20,%al
  800cd4:	74 f6                	je     800ccc <strtol+0x12>
  800cd6:	3c 09                	cmp    $0x9,%al
  800cd8:	74 f2                	je     800ccc <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800cda:	3c 2b                	cmp    $0x2b,%al
  800cdc:	74 2a                	je     800d08 <strtol+0x4e>
	int neg = 0;
  800cde:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ce3:	3c 2d                	cmp    $0x2d,%al
  800ce5:	74 2b                	je     800d12 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ced:	75 0f                	jne    800cfe <strtol+0x44>
  800cef:	80 39 30             	cmpb   $0x30,(%ecx)
  800cf2:	74 28                	je     800d1c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cf4:	85 db                	test   %ebx,%ebx
  800cf6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cfb:	0f 44 d8             	cmove  %eax,%ebx
  800cfe:	b8 00 00 00 00       	mov    $0x0,%eax
  800d03:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d06:	eb 46                	jmp    800d4e <strtol+0x94>
		s++;
  800d08:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d0b:	bf 00 00 00 00       	mov    $0x0,%edi
  800d10:	eb d5                	jmp    800ce7 <strtol+0x2d>
		s++, neg = 1;
  800d12:	83 c1 01             	add    $0x1,%ecx
  800d15:	bf 01 00 00 00       	mov    $0x1,%edi
  800d1a:	eb cb                	jmp    800ce7 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d1c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d20:	74 0e                	je     800d30 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d22:	85 db                	test   %ebx,%ebx
  800d24:	75 d8                	jne    800cfe <strtol+0x44>
		s++, base = 8;
  800d26:	83 c1 01             	add    $0x1,%ecx
  800d29:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d2e:	eb ce                	jmp    800cfe <strtol+0x44>
		s += 2, base = 16;
  800d30:	83 c1 02             	add    $0x2,%ecx
  800d33:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d38:	eb c4                	jmp    800cfe <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800d3a:	0f be d2             	movsbl %dl,%edx
  800d3d:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d40:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d43:	7d 3a                	jge    800d7f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d45:	83 c1 01             	add    $0x1,%ecx
  800d48:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d4c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d4e:	0f b6 11             	movzbl (%ecx),%edx
  800d51:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d54:	89 f3                	mov    %esi,%ebx
  800d56:	80 fb 09             	cmp    $0x9,%bl
  800d59:	76 df                	jbe    800d3a <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800d5b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d5e:	89 f3                	mov    %esi,%ebx
  800d60:	80 fb 19             	cmp    $0x19,%bl
  800d63:	77 08                	ja     800d6d <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d65:	0f be d2             	movsbl %dl,%edx
  800d68:	83 ea 57             	sub    $0x57,%edx
  800d6b:	eb d3                	jmp    800d40 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800d6d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d70:	89 f3                	mov    %esi,%ebx
  800d72:	80 fb 19             	cmp    $0x19,%bl
  800d75:	77 08                	ja     800d7f <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d77:	0f be d2             	movsbl %dl,%edx
  800d7a:	83 ea 37             	sub    $0x37,%edx
  800d7d:	eb c1                	jmp    800d40 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d83:	74 05                	je     800d8a <strtol+0xd0>
		*endptr = (char *) s;
  800d85:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d88:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d8a:	89 c2                	mov    %eax,%edx
  800d8c:	f7 da                	neg    %edx
  800d8e:	85 ff                	test   %edi,%edi
  800d90:	0f 45 c2             	cmovne %edx,%eax
}
  800d93:	5b                   	pop    %ebx
  800d94:	5e                   	pop    %esi
  800d95:	5f                   	pop    %edi
  800d96:	5d                   	pop    %ebp
  800d97:	c3                   	ret    
  800d98:	66 90                	xchg   %ax,%ax
  800d9a:	66 90                	xchg   %ax,%ax
  800d9c:	66 90                	xchg   %ax,%ax
  800d9e:	66 90                	xchg   %ax,%ax

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
