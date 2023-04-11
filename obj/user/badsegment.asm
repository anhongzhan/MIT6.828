
obj/user/badsegment:     file format elf32-i386


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
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800037:	66 b8 28 00          	mov    $0x28,%ax
  80003b:	8e d8                	mov    %eax,%ds
}
  80003d:	c3                   	ret    

0080003e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003e:	f3 0f 1e fb          	endbr32 
  800042:	55                   	push   %ebp
  800043:	89 e5                	mov    %esp,%ebp
  800045:	56                   	push   %esi
  800046:	53                   	push   %ebx
  800047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80004d:	e8 d6 00 00 00       	call   800128 <sys_getenvid>
  800052:	25 ff 03 00 00       	and    $0x3ff,%eax
  800057:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005f:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800064:	85 db                	test   %ebx,%ebx
  800066:	7e 07                	jle    80006f <libmain+0x31>
		binaryname = argv[0];
  800068:	8b 06                	mov    (%esi),%eax
  80006a:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80006f:	83 ec 08             	sub    $0x8,%esp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	e8 ba ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800079:	e8 0a 00 00 00       	call   800088 <exit>
}
  80007e:	83 c4 10             	add    $0x10,%esp
  800081:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800084:	5b                   	pop    %ebx
  800085:	5e                   	pop    %esi
  800086:	5d                   	pop    %ebp
  800087:	c3                   	ret    

00800088 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800088:	f3 0f 1e fb          	endbr32 
  80008c:	55                   	push   %ebp
  80008d:	89 e5                	mov    %esp,%ebp
  80008f:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800092:	6a 00                	push   $0x0
  800094:	e8 4a 00 00 00       	call   8000e3 <sys_env_destroy>
}
  800099:	83 c4 10             	add    $0x10,%esp
  80009c:	c9                   	leave  
  80009d:	c3                   	ret    

0080009e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80009e:	f3 0f 1e fb          	endbr32 
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	57                   	push   %edi
  8000a6:	56                   	push   %esi
  8000a7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b3:	89 c3                	mov    %eax,%ebx
  8000b5:	89 c7                	mov    %eax,%edi
  8000b7:	89 c6                	mov    %eax,%esi
  8000b9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000bb:	5b                   	pop    %ebx
  8000bc:	5e                   	pop    %esi
  8000bd:	5f                   	pop    %edi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    

008000c0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c0:	f3 0f 1e fb          	endbr32 
  8000c4:	55                   	push   %ebp
  8000c5:	89 e5                	mov    %esp,%ebp
  8000c7:	57                   	push   %edi
  8000c8:	56                   	push   %esi
  8000c9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8000cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d4:	89 d1                	mov    %edx,%ecx
  8000d6:	89 d3                	mov    %edx,%ebx
  8000d8:	89 d7                	mov    %edx,%edi
  8000da:	89 d6                	mov    %edx,%esi
  8000dc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000de:	5b                   	pop    %ebx
  8000df:	5e                   	pop    %esi
  8000e0:	5f                   	pop    %edi
  8000e1:	5d                   	pop    %ebp
  8000e2:	c3                   	ret    

008000e3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e3:	f3 0f 1e fb          	endbr32 
  8000e7:	55                   	push   %ebp
  8000e8:	89 e5                	mov    %esp,%ebp
  8000ea:	57                   	push   %edi
  8000eb:	56                   	push   %esi
  8000ec:	53                   	push   %ebx
  8000ed:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f8:	b8 03 00 00 00       	mov    $0x3,%eax
  8000fd:	89 cb                	mov    %ecx,%ebx
  8000ff:	89 cf                	mov    %ecx,%edi
  800101:	89 ce                	mov    %ecx,%esi
  800103:	cd 30                	int    $0x30
	if(check && ret > 0)
  800105:	85 c0                	test   %eax,%eax
  800107:	7f 08                	jg     800111 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800109:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010c:	5b                   	pop    %ebx
  80010d:	5e                   	pop    %esi
  80010e:	5f                   	pop    %edi
  80010f:	5d                   	pop    %ebp
  800110:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	50                   	push   %eax
  800115:	6a 03                	push   $0x3
  800117:	68 0a 10 80 00       	push   $0x80100a
  80011c:	6a 23                	push   $0x23
  80011e:	68 27 10 80 00       	push   $0x801027
  800123:	e8 11 02 00 00       	call   800339 <_panic>

00800128 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800128:	f3 0f 1e fb          	endbr32 
  80012c:	55                   	push   %ebp
  80012d:	89 e5                	mov    %esp,%ebp
  80012f:	57                   	push   %edi
  800130:	56                   	push   %esi
  800131:	53                   	push   %ebx
	asm volatile("int %1\n"
  800132:	ba 00 00 00 00       	mov    $0x0,%edx
  800137:	b8 02 00 00 00       	mov    $0x2,%eax
  80013c:	89 d1                	mov    %edx,%ecx
  80013e:	89 d3                	mov    %edx,%ebx
  800140:	89 d7                	mov    %edx,%edi
  800142:	89 d6                	mov    %edx,%esi
  800144:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800146:	5b                   	pop    %ebx
  800147:	5e                   	pop    %esi
  800148:	5f                   	pop    %edi
  800149:	5d                   	pop    %ebp
  80014a:	c3                   	ret    

0080014b <sys_yield>:

void
sys_yield(void)
{
  80014b:	f3 0f 1e fb          	endbr32 
  80014f:	55                   	push   %ebp
  800150:	89 e5                	mov    %esp,%ebp
  800152:	57                   	push   %edi
  800153:	56                   	push   %esi
  800154:	53                   	push   %ebx
	asm volatile("int %1\n"
  800155:	ba 00 00 00 00       	mov    $0x0,%edx
  80015a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80015f:	89 d1                	mov    %edx,%ecx
  800161:	89 d3                	mov    %edx,%ebx
  800163:	89 d7                	mov    %edx,%edi
  800165:	89 d6                	mov    %edx,%esi
  800167:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800169:	5b                   	pop    %ebx
  80016a:	5e                   	pop    %esi
  80016b:	5f                   	pop    %edi
  80016c:	5d                   	pop    %ebp
  80016d:	c3                   	ret    

0080016e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80016e:	f3 0f 1e fb          	endbr32 
  800172:	55                   	push   %ebp
  800173:	89 e5                	mov    %esp,%ebp
  800175:	57                   	push   %edi
  800176:	56                   	push   %esi
  800177:	53                   	push   %ebx
  800178:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80017b:	be 00 00 00 00       	mov    $0x0,%esi
  800180:	8b 55 08             	mov    0x8(%ebp),%edx
  800183:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800186:	b8 04 00 00 00       	mov    $0x4,%eax
  80018b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80018e:	89 f7                	mov    %esi,%edi
  800190:	cd 30                	int    $0x30
	if(check && ret > 0)
  800192:	85 c0                	test   %eax,%eax
  800194:	7f 08                	jg     80019e <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800196:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800199:	5b                   	pop    %ebx
  80019a:	5e                   	pop    %esi
  80019b:	5f                   	pop    %edi
  80019c:	5d                   	pop    %ebp
  80019d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80019e:	83 ec 0c             	sub    $0xc,%esp
  8001a1:	50                   	push   %eax
  8001a2:	6a 04                	push   $0x4
  8001a4:	68 0a 10 80 00       	push   $0x80100a
  8001a9:	6a 23                	push   $0x23
  8001ab:	68 27 10 80 00       	push   $0x801027
  8001b0:	e8 84 01 00 00       	call   800339 <_panic>

008001b5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001b5:	f3 0f 1e fb          	endbr32 
  8001b9:	55                   	push   %ebp
  8001ba:	89 e5                	mov    %esp,%ebp
  8001bc:	57                   	push   %edi
  8001bd:	56                   	push   %esi
  8001be:	53                   	push   %ebx
  8001bf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8001c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001c8:	b8 05 00 00 00       	mov    $0x5,%eax
  8001cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001d0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001d3:	8b 75 18             	mov    0x18(%ebp),%esi
  8001d6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001d8:	85 c0                	test   %eax,%eax
  8001da:	7f 08                	jg     8001e4 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001df:	5b                   	pop    %ebx
  8001e0:	5e                   	pop    %esi
  8001e1:	5f                   	pop    %edi
  8001e2:	5d                   	pop    %ebp
  8001e3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	50                   	push   %eax
  8001e8:	6a 05                	push   $0x5
  8001ea:	68 0a 10 80 00       	push   $0x80100a
  8001ef:	6a 23                	push   $0x23
  8001f1:	68 27 10 80 00       	push   $0x801027
  8001f6:	e8 3e 01 00 00       	call   800339 <_panic>

008001fb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001fb:	f3 0f 1e fb          	endbr32 
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	57                   	push   %edi
  800203:	56                   	push   %esi
  800204:	53                   	push   %ebx
  800205:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800208:	bb 00 00 00 00       	mov    $0x0,%ebx
  80020d:	8b 55 08             	mov    0x8(%ebp),%edx
  800210:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800213:	b8 06 00 00 00       	mov    $0x6,%eax
  800218:	89 df                	mov    %ebx,%edi
  80021a:	89 de                	mov    %ebx,%esi
  80021c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80021e:	85 c0                	test   %eax,%eax
  800220:	7f 08                	jg     80022a <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800222:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800225:	5b                   	pop    %ebx
  800226:	5e                   	pop    %esi
  800227:	5f                   	pop    %edi
  800228:	5d                   	pop    %ebp
  800229:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	50                   	push   %eax
  80022e:	6a 06                	push   $0x6
  800230:	68 0a 10 80 00       	push   $0x80100a
  800235:	6a 23                	push   $0x23
  800237:	68 27 10 80 00       	push   $0x801027
  80023c:	e8 f8 00 00 00       	call   800339 <_panic>

00800241 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800241:	f3 0f 1e fb          	endbr32 
  800245:	55                   	push   %ebp
  800246:	89 e5                	mov    %esp,%ebp
  800248:	57                   	push   %edi
  800249:	56                   	push   %esi
  80024a:	53                   	push   %ebx
  80024b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80024e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800253:	8b 55 08             	mov    0x8(%ebp),%edx
  800256:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800259:	b8 08 00 00 00       	mov    $0x8,%eax
  80025e:	89 df                	mov    %ebx,%edi
  800260:	89 de                	mov    %ebx,%esi
  800262:	cd 30                	int    $0x30
	if(check && ret > 0)
  800264:	85 c0                	test   %eax,%eax
  800266:	7f 08                	jg     800270 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800268:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026b:	5b                   	pop    %ebx
  80026c:	5e                   	pop    %esi
  80026d:	5f                   	pop    %edi
  80026e:	5d                   	pop    %ebp
  80026f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	50                   	push   %eax
  800274:	6a 08                	push   $0x8
  800276:	68 0a 10 80 00       	push   $0x80100a
  80027b:	6a 23                	push   $0x23
  80027d:	68 27 10 80 00       	push   $0x801027
  800282:	e8 b2 00 00 00       	call   800339 <_panic>

00800287 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800287:	f3 0f 1e fb          	endbr32 
  80028b:	55                   	push   %ebp
  80028c:	89 e5                	mov    %esp,%ebp
  80028e:	57                   	push   %edi
  80028f:	56                   	push   %esi
  800290:	53                   	push   %ebx
  800291:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800294:	bb 00 00 00 00       	mov    $0x0,%ebx
  800299:	8b 55 08             	mov    0x8(%ebp),%edx
  80029c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80029f:	b8 09 00 00 00       	mov    $0x9,%eax
  8002a4:	89 df                	mov    %ebx,%edi
  8002a6:	89 de                	mov    %ebx,%esi
  8002a8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002aa:	85 c0                	test   %eax,%eax
  8002ac:	7f 08                	jg     8002b6 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b1:	5b                   	pop    %ebx
  8002b2:	5e                   	pop    %esi
  8002b3:	5f                   	pop    %edi
  8002b4:	5d                   	pop    %ebp
  8002b5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002b6:	83 ec 0c             	sub    $0xc,%esp
  8002b9:	50                   	push   %eax
  8002ba:	6a 09                	push   $0x9
  8002bc:	68 0a 10 80 00       	push   $0x80100a
  8002c1:	6a 23                	push   $0x23
  8002c3:	68 27 10 80 00       	push   $0x801027
  8002c8:	e8 6c 00 00 00       	call   800339 <_panic>

008002cd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002cd:	f3 0f 1e fb          	endbr32 
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	57                   	push   %edi
  8002d5:	56                   	push   %esi
  8002d6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002dd:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002e2:	be 00 00 00 00       	mov    $0x0,%esi
  8002e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002ea:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002ed:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002ef:	5b                   	pop    %ebx
  8002f0:	5e                   	pop    %esi
  8002f1:	5f                   	pop    %edi
  8002f2:	5d                   	pop    %ebp
  8002f3:	c3                   	ret    

008002f4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002f4:	f3 0f 1e fb          	endbr32 
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
  8002fb:	57                   	push   %edi
  8002fc:	56                   	push   %esi
  8002fd:	53                   	push   %ebx
  8002fe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800301:	b9 00 00 00 00       	mov    $0x0,%ecx
  800306:	8b 55 08             	mov    0x8(%ebp),%edx
  800309:	b8 0c 00 00 00       	mov    $0xc,%eax
  80030e:	89 cb                	mov    %ecx,%ebx
  800310:	89 cf                	mov    %ecx,%edi
  800312:	89 ce                	mov    %ecx,%esi
  800314:	cd 30                	int    $0x30
	if(check && ret > 0)
  800316:	85 c0                	test   %eax,%eax
  800318:	7f 08                	jg     800322 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80031a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031d:	5b                   	pop    %ebx
  80031e:	5e                   	pop    %esi
  80031f:	5f                   	pop    %edi
  800320:	5d                   	pop    %ebp
  800321:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800322:	83 ec 0c             	sub    $0xc,%esp
  800325:	50                   	push   %eax
  800326:	6a 0c                	push   $0xc
  800328:	68 0a 10 80 00       	push   $0x80100a
  80032d:	6a 23                	push   $0x23
  80032f:	68 27 10 80 00       	push   $0x801027
  800334:	e8 00 00 00 00       	call   800339 <_panic>

00800339 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800339:	f3 0f 1e fb          	endbr32 
  80033d:	55                   	push   %ebp
  80033e:	89 e5                	mov    %esp,%ebp
  800340:	56                   	push   %esi
  800341:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800342:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800345:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80034b:	e8 d8 fd ff ff       	call   800128 <sys_getenvid>
  800350:	83 ec 0c             	sub    $0xc,%esp
  800353:	ff 75 0c             	pushl  0xc(%ebp)
  800356:	ff 75 08             	pushl  0x8(%ebp)
  800359:	56                   	push   %esi
  80035a:	50                   	push   %eax
  80035b:	68 38 10 80 00       	push   $0x801038
  800360:	e8 bb 00 00 00       	call   800420 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800365:	83 c4 18             	add    $0x18,%esp
  800368:	53                   	push   %ebx
  800369:	ff 75 10             	pushl  0x10(%ebp)
  80036c:	e8 5a 00 00 00       	call   8003cb <vcprintf>
	cprintf("\n");
  800371:	c7 04 24 5b 10 80 00 	movl   $0x80105b,(%esp)
  800378:	e8 a3 00 00 00       	call   800420 <cprintf>
  80037d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800380:	cc                   	int3   
  800381:	eb fd                	jmp    800380 <_panic+0x47>

00800383 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800383:	f3 0f 1e fb          	endbr32 
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	53                   	push   %ebx
  80038b:	83 ec 04             	sub    $0x4,%esp
  80038e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800391:	8b 13                	mov    (%ebx),%edx
  800393:	8d 42 01             	lea    0x1(%edx),%eax
  800396:	89 03                	mov    %eax,(%ebx)
  800398:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80039b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80039f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a4:	74 09                	je     8003af <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003a6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003ad:	c9                   	leave  
  8003ae:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003af:	83 ec 08             	sub    $0x8,%esp
  8003b2:	68 ff 00 00 00       	push   $0xff
  8003b7:	8d 43 08             	lea    0x8(%ebx),%eax
  8003ba:	50                   	push   %eax
  8003bb:	e8 de fc ff ff       	call   80009e <sys_cputs>
		b->idx = 0;
  8003c0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003c6:	83 c4 10             	add    $0x10,%esp
  8003c9:	eb db                	jmp    8003a6 <putch+0x23>

008003cb <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003cb:	f3 0f 1e fb          	endbr32 
  8003cf:	55                   	push   %ebp
  8003d0:	89 e5                	mov    %esp,%ebp
  8003d2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003d8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003df:	00 00 00 
	b.cnt = 0;
  8003e2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003e9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003ec:	ff 75 0c             	pushl  0xc(%ebp)
  8003ef:	ff 75 08             	pushl  0x8(%ebp)
  8003f2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003f8:	50                   	push   %eax
  8003f9:	68 83 03 80 00       	push   $0x800383
  8003fe:	e8 20 01 00 00       	call   800523 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800403:	83 c4 08             	add    $0x8,%esp
  800406:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80040c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800412:	50                   	push   %eax
  800413:	e8 86 fc ff ff       	call   80009e <sys_cputs>

	return b.cnt;
}
  800418:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800420:	f3 0f 1e fb          	endbr32 
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80042a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80042d:	50                   	push   %eax
  80042e:	ff 75 08             	pushl  0x8(%ebp)
  800431:	e8 95 ff ff ff       	call   8003cb <vcprintf>
	va_end(ap);

	return cnt;
}
  800436:	c9                   	leave  
  800437:	c3                   	ret    

00800438 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800438:	55                   	push   %ebp
  800439:	89 e5                	mov    %esp,%ebp
  80043b:	57                   	push   %edi
  80043c:	56                   	push   %esi
  80043d:	53                   	push   %ebx
  80043e:	83 ec 1c             	sub    $0x1c,%esp
  800441:	89 c7                	mov    %eax,%edi
  800443:	89 d6                	mov    %edx,%esi
  800445:	8b 45 08             	mov    0x8(%ebp),%eax
  800448:	8b 55 0c             	mov    0xc(%ebp),%edx
  80044b:	89 d1                	mov    %edx,%ecx
  80044d:	89 c2                	mov    %eax,%edx
  80044f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800452:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800455:	8b 45 10             	mov    0x10(%ebp),%eax
  800458:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80045b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800465:	39 c2                	cmp    %eax,%edx
  800467:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80046a:	72 3e                	jb     8004aa <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80046c:	83 ec 0c             	sub    $0xc,%esp
  80046f:	ff 75 18             	pushl  0x18(%ebp)
  800472:	83 eb 01             	sub    $0x1,%ebx
  800475:	53                   	push   %ebx
  800476:	50                   	push   %eax
  800477:	83 ec 08             	sub    $0x8,%esp
  80047a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80047d:	ff 75 e0             	pushl  -0x20(%ebp)
  800480:	ff 75 dc             	pushl  -0x24(%ebp)
  800483:	ff 75 d8             	pushl  -0x28(%ebp)
  800486:	e8 15 09 00 00       	call   800da0 <__udivdi3>
  80048b:	83 c4 18             	add    $0x18,%esp
  80048e:	52                   	push   %edx
  80048f:	50                   	push   %eax
  800490:	89 f2                	mov    %esi,%edx
  800492:	89 f8                	mov    %edi,%eax
  800494:	e8 9f ff ff ff       	call   800438 <printnum>
  800499:	83 c4 20             	add    $0x20,%esp
  80049c:	eb 13                	jmp    8004b1 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80049e:	83 ec 08             	sub    $0x8,%esp
  8004a1:	56                   	push   %esi
  8004a2:	ff 75 18             	pushl  0x18(%ebp)
  8004a5:	ff d7                	call   *%edi
  8004a7:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004aa:	83 eb 01             	sub    $0x1,%ebx
  8004ad:	85 db                	test   %ebx,%ebx
  8004af:	7f ed                	jg     80049e <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	56                   	push   %esi
  8004b5:	83 ec 04             	sub    $0x4,%esp
  8004b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004bb:	ff 75 e0             	pushl  -0x20(%ebp)
  8004be:	ff 75 dc             	pushl  -0x24(%ebp)
  8004c1:	ff 75 d8             	pushl  -0x28(%ebp)
  8004c4:	e8 e7 09 00 00       	call   800eb0 <__umoddi3>
  8004c9:	83 c4 14             	add    $0x14,%esp
  8004cc:	0f be 80 5d 10 80 00 	movsbl 0x80105d(%eax),%eax
  8004d3:	50                   	push   %eax
  8004d4:	ff d7                	call   *%edi
}
  8004d6:	83 c4 10             	add    $0x10,%esp
  8004d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004dc:	5b                   	pop    %ebx
  8004dd:	5e                   	pop    %esi
  8004de:	5f                   	pop    %edi
  8004df:	5d                   	pop    %ebp
  8004e0:	c3                   	ret    

008004e1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004e1:	f3 0f 1e fb          	endbr32 
  8004e5:	55                   	push   %ebp
  8004e6:	89 e5                	mov    %esp,%ebp
  8004e8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004eb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004ef:	8b 10                	mov    (%eax),%edx
  8004f1:	3b 50 04             	cmp    0x4(%eax),%edx
  8004f4:	73 0a                	jae    800500 <sprintputch+0x1f>
		*b->buf++ = ch;
  8004f6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004f9:	89 08                	mov    %ecx,(%eax)
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	88 02                	mov    %al,(%edx)
}
  800500:	5d                   	pop    %ebp
  800501:	c3                   	ret    

00800502 <printfmt>:
{
  800502:	f3 0f 1e fb          	endbr32 
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80050c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80050f:	50                   	push   %eax
  800510:	ff 75 10             	pushl  0x10(%ebp)
  800513:	ff 75 0c             	pushl  0xc(%ebp)
  800516:	ff 75 08             	pushl  0x8(%ebp)
  800519:	e8 05 00 00 00       	call   800523 <vprintfmt>
}
  80051e:	83 c4 10             	add    $0x10,%esp
  800521:	c9                   	leave  
  800522:	c3                   	ret    

00800523 <vprintfmt>:
{
  800523:	f3 0f 1e fb          	endbr32 
  800527:	55                   	push   %ebp
  800528:	89 e5                	mov    %esp,%ebp
  80052a:	57                   	push   %edi
  80052b:	56                   	push   %esi
  80052c:	53                   	push   %ebx
  80052d:	83 ec 3c             	sub    $0x3c,%esp
  800530:	8b 75 08             	mov    0x8(%ebp),%esi
  800533:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800536:	8b 7d 10             	mov    0x10(%ebp),%edi
  800539:	e9 8e 03 00 00       	jmp    8008cc <vprintfmt+0x3a9>
		padc = ' ';
  80053e:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800542:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800549:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800550:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800557:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80055c:	8d 47 01             	lea    0x1(%edi),%eax
  80055f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800562:	0f b6 17             	movzbl (%edi),%edx
  800565:	8d 42 dd             	lea    -0x23(%edx),%eax
  800568:	3c 55                	cmp    $0x55,%al
  80056a:	0f 87 df 03 00 00    	ja     80094f <vprintfmt+0x42c>
  800570:	0f b6 c0             	movzbl %al,%eax
  800573:	3e ff 24 85 20 11 80 	notrack jmp *0x801120(,%eax,4)
  80057a:	00 
  80057b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80057e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800582:	eb d8                	jmp    80055c <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800584:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800587:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80058b:	eb cf                	jmp    80055c <vprintfmt+0x39>
  80058d:	0f b6 d2             	movzbl %dl,%edx
  800590:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800593:	b8 00 00 00 00       	mov    $0x0,%eax
  800598:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80059b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80059e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005a2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005a5:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005a8:	83 f9 09             	cmp    $0x9,%ecx
  8005ab:	77 55                	ja     800602 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8005ad:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005b0:	eb e9                	jmp    80059b <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8005b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b5:	8b 00                	mov    (%eax),%eax
  8005b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bd:	8d 40 04             	lea    0x4(%eax),%eax
  8005c0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005ca:	79 90                	jns    80055c <vprintfmt+0x39>
				width = precision, precision = -1;
  8005cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005d9:	eb 81                	jmp    80055c <vprintfmt+0x39>
  8005db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005de:	85 c0                	test   %eax,%eax
  8005e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e5:	0f 49 d0             	cmovns %eax,%edx
  8005e8:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005ee:	e9 69 ff ff ff       	jmp    80055c <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8005f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005f6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8005fd:	e9 5a ff ff ff       	jmp    80055c <vprintfmt+0x39>
  800602:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800605:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800608:	eb bc                	jmp    8005c6 <vprintfmt+0xa3>
			lflag++;
  80060a:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80060d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800610:	e9 47 ff ff ff       	jmp    80055c <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8d 78 04             	lea    0x4(%eax),%edi
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	53                   	push   %ebx
  80061f:	ff 30                	pushl  (%eax)
  800621:	ff d6                	call   *%esi
			break;
  800623:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800626:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800629:	e9 9b 02 00 00       	jmp    8008c9 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8d 78 04             	lea    0x4(%eax),%edi
  800634:	8b 00                	mov    (%eax),%eax
  800636:	99                   	cltd   
  800637:	31 d0                	xor    %edx,%eax
  800639:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80063b:	83 f8 08             	cmp    $0x8,%eax
  80063e:	7f 23                	jg     800663 <vprintfmt+0x140>
  800640:	8b 14 85 80 12 80 00 	mov    0x801280(,%eax,4),%edx
  800647:	85 d2                	test   %edx,%edx
  800649:	74 18                	je     800663 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80064b:	52                   	push   %edx
  80064c:	68 7e 10 80 00       	push   $0x80107e
  800651:	53                   	push   %ebx
  800652:	56                   	push   %esi
  800653:	e8 aa fe ff ff       	call   800502 <printfmt>
  800658:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80065b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80065e:	e9 66 02 00 00       	jmp    8008c9 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800663:	50                   	push   %eax
  800664:	68 75 10 80 00       	push   $0x801075
  800669:	53                   	push   %ebx
  80066a:	56                   	push   %esi
  80066b:	e8 92 fe ff ff       	call   800502 <printfmt>
  800670:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800673:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800676:	e9 4e 02 00 00       	jmp    8008c9 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	83 c0 04             	add    $0x4,%eax
  800681:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800689:	85 d2                	test   %edx,%edx
  80068b:	b8 6e 10 80 00       	mov    $0x80106e,%eax
  800690:	0f 45 c2             	cmovne %edx,%eax
  800693:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800696:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80069a:	7e 06                	jle    8006a2 <vprintfmt+0x17f>
  80069c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006a0:	75 0d                	jne    8006af <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006a5:	89 c7                	mov    %eax,%edi
  8006a7:	03 45 e0             	add    -0x20(%ebp),%eax
  8006aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006ad:	eb 55                	jmp    800704 <vprintfmt+0x1e1>
  8006af:	83 ec 08             	sub    $0x8,%esp
  8006b2:	ff 75 d8             	pushl  -0x28(%ebp)
  8006b5:	ff 75 cc             	pushl  -0x34(%ebp)
  8006b8:	e8 46 03 00 00       	call   800a03 <strnlen>
  8006bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c0:	29 c2                	sub    %eax,%edx
  8006c2:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006c5:	83 c4 10             	add    $0x10,%esp
  8006c8:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006ca:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d1:	85 ff                	test   %edi,%edi
  8006d3:	7e 11                	jle    8006e6 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8006d5:	83 ec 08             	sub    $0x8,%esp
  8006d8:	53                   	push   %ebx
  8006d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8006dc:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006de:	83 ef 01             	sub    $0x1,%edi
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	eb eb                	jmp    8006d1 <vprintfmt+0x1ae>
  8006e6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006e9:	85 d2                	test   %edx,%edx
  8006eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f0:	0f 49 c2             	cmovns %edx,%eax
  8006f3:	29 c2                	sub    %eax,%edx
  8006f5:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8006f8:	eb a8                	jmp    8006a2 <vprintfmt+0x17f>
					putch(ch, putdat);
  8006fa:	83 ec 08             	sub    $0x8,%esp
  8006fd:	53                   	push   %ebx
  8006fe:	52                   	push   %edx
  8006ff:	ff d6                	call   *%esi
  800701:	83 c4 10             	add    $0x10,%esp
  800704:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800707:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800709:	83 c7 01             	add    $0x1,%edi
  80070c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800710:	0f be d0             	movsbl %al,%edx
  800713:	85 d2                	test   %edx,%edx
  800715:	74 4b                	je     800762 <vprintfmt+0x23f>
  800717:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80071b:	78 06                	js     800723 <vprintfmt+0x200>
  80071d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800721:	78 1e                	js     800741 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800723:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800727:	74 d1                	je     8006fa <vprintfmt+0x1d7>
  800729:	0f be c0             	movsbl %al,%eax
  80072c:	83 e8 20             	sub    $0x20,%eax
  80072f:	83 f8 5e             	cmp    $0x5e,%eax
  800732:	76 c6                	jbe    8006fa <vprintfmt+0x1d7>
					putch('?', putdat);
  800734:	83 ec 08             	sub    $0x8,%esp
  800737:	53                   	push   %ebx
  800738:	6a 3f                	push   $0x3f
  80073a:	ff d6                	call   *%esi
  80073c:	83 c4 10             	add    $0x10,%esp
  80073f:	eb c3                	jmp    800704 <vprintfmt+0x1e1>
  800741:	89 cf                	mov    %ecx,%edi
  800743:	eb 0e                	jmp    800753 <vprintfmt+0x230>
				putch(' ', putdat);
  800745:	83 ec 08             	sub    $0x8,%esp
  800748:	53                   	push   %ebx
  800749:	6a 20                	push   $0x20
  80074b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80074d:	83 ef 01             	sub    $0x1,%edi
  800750:	83 c4 10             	add    $0x10,%esp
  800753:	85 ff                	test   %edi,%edi
  800755:	7f ee                	jg     800745 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800757:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80075a:	89 45 14             	mov    %eax,0x14(%ebp)
  80075d:	e9 67 01 00 00       	jmp    8008c9 <vprintfmt+0x3a6>
  800762:	89 cf                	mov    %ecx,%edi
  800764:	eb ed                	jmp    800753 <vprintfmt+0x230>
	if (lflag >= 2)
  800766:	83 f9 01             	cmp    $0x1,%ecx
  800769:	7f 1b                	jg     800786 <vprintfmt+0x263>
	else if (lflag)
  80076b:	85 c9                	test   %ecx,%ecx
  80076d:	74 63                	je     8007d2 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800777:	99                   	cltd   
  800778:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	8d 40 04             	lea    0x4(%eax),%eax
  800781:	89 45 14             	mov    %eax,0x14(%ebp)
  800784:	eb 17                	jmp    80079d <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8b 50 04             	mov    0x4(%eax),%edx
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800791:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8d 40 08             	lea    0x8(%eax),%eax
  80079a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80079d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007a0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007a3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007a8:	85 c9                	test   %ecx,%ecx
  8007aa:	0f 89 ff 00 00 00    	jns    8008af <vprintfmt+0x38c>
				putch('-', putdat);
  8007b0:	83 ec 08             	sub    $0x8,%esp
  8007b3:	53                   	push   %ebx
  8007b4:	6a 2d                	push   $0x2d
  8007b6:	ff d6                	call   *%esi
				num = -(long long) num;
  8007b8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007bb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007be:	f7 da                	neg    %edx
  8007c0:	83 d1 00             	adc    $0x0,%ecx
  8007c3:	f7 d9                	neg    %ecx
  8007c5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007c8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007cd:	e9 dd 00 00 00       	jmp    8008af <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007da:	99                   	cltd   
  8007db:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	8d 40 04             	lea    0x4(%eax),%eax
  8007e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e7:	eb b4                	jmp    80079d <vprintfmt+0x27a>
	if (lflag >= 2)
  8007e9:	83 f9 01             	cmp    $0x1,%ecx
  8007ec:	7f 1e                	jg     80080c <vprintfmt+0x2e9>
	else if (lflag)
  8007ee:	85 c9                	test   %ecx,%ecx
  8007f0:	74 32                	je     800824 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	8b 10                	mov    (%eax),%edx
  8007f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007fc:	8d 40 04             	lea    0x4(%eax),%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800802:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800807:	e9 a3 00 00 00       	jmp    8008af <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80080c:	8b 45 14             	mov    0x14(%ebp),%eax
  80080f:	8b 10                	mov    (%eax),%edx
  800811:	8b 48 04             	mov    0x4(%eax),%ecx
  800814:	8d 40 08             	lea    0x8(%eax),%eax
  800817:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80081a:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80081f:	e9 8b 00 00 00       	jmp    8008af <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	8b 10                	mov    (%eax),%edx
  800829:	b9 00 00 00 00       	mov    $0x0,%ecx
  80082e:	8d 40 04             	lea    0x4(%eax),%eax
  800831:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800834:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800839:	eb 74                	jmp    8008af <vprintfmt+0x38c>
	if (lflag >= 2)
  80083b:	83 f9 01             	cmp    $0x1,%ecx
  80083e:	7f 1b                	jg     80085b <vprintfmt+0x338>
	else if (lflag)
  800840:	85 c9                	test   %ecx,%ecx
  800842:	74 2c                	je     800870 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	8b 10                	mov    (%eax),%edx
  800849:	b9 00 00 00 00       	mov    $0x0,%ecx
  80084e:	8d 40 04             	lea    0x4(%eax),%eax
  800851:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800854:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800859:	eb 54                	jmp    8008af <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	8b 10                	mov    (%eax),%edx
  800860:	8b 48 04             	mov    0x4(%eax),%ecx
  800863:	8d 40 08             	lea    0x8(%eax),%eax
  800866:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800869:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80086e:	eb 3f                	jmp    8008af <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800870:	8b 45 14             	mov    0x14(%ebp),%eax
  800873:	8b 10                	mov    (%eax),%edx
  800875:	b9 00 00 00 00       	mov    $0x0,%ecx
  80087a:	8d 40 04             	lea    0x4(%eax),%eax
  80087d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800880:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800885:	eb 28                	jmp    8008af <vprintfmt+0x38c>
			putch('0', putdat);
  800887:	83 ec 08             	sub    $0x8,%esp
  80088a:	53                   	push   %ebx
  80088b:	6a 30                	push   $0x30
  80088d:	ff d6                	call   *%esi
			putch('x', putdat);
  80088f:	83 c4 08             	add    $0x8,%esp
  800892:	53                   	push   %ebx
  800893:	6a 78                	push   $0x78
  800895:	ff d6                	call   *%esi
			num = (unsigned long long)
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	8b 10                	mov    (%eax),%edx
  80089c:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008a1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008a4:	8d 40 04             	lea    0x4(%eax),%eax
  8008a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008aa:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008af:	83 ec 0c             	sub    $0xc,%esp
  8008b2:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8008b6:	57                   	push   %edi
  8008b7:	ff 75 e0             	pushl  -0x20(%ebp)
  8008ba:	50                   	push   %eax
  8008bb:	51                   	push   %ecx
  8008bc:	52                   	push   %edx
  8008bd:	89 da                	mov    %ebx,%edx
  8008bf:	89 f0                	mov    %esi,%eax
  8008c1:	e8 72 fb ff ff       	call   800438 <printnum>
			break;
  8008c6:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008cc:	83 c7 01             	add    $0x1,%edi
  8008cf:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008d3:	83 f8 25             	cmp    $0x25,%eax
  8008d6:	0f 84 62 fc ff ff    	je     80053e <vprintfmt+0x1b>
			if (ch == '\0')
  8008dc:	85 c0                	test   %eax,%eax
  8008de:	0f 84 8b 00 00 00    	je     80096f <vprintfmt+0x44c>
			putch(ch, putdat);
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	53                   	push   %ebx
  8008e8:	50                   	push   %eax
  8008e9:	ff d6                	call   *%esi
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	eb dc                	jmp    8008cc <vprintfmt+0x3a9>
	if (lflag >= 2)
  8008f0:	83 f9 01             	cmp    $0x1,%ecx
  8008f3:	7f 1b                	jg     800910 <vprintfmt+0x3ed>
	else if (lflag)
  8008f5:	85 c9                	test   %ecx,%ecx
  8008f7:	74 2c                	je     800925 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8008f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fc:	8b 10                	mov    (%eax),%edx
  8008fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800903:	8d 40 04             	lea    0x4(%eax),%eax
  800906:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800909:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80090e:	eb 9f                	jmp    8008af <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800910:	8b 45 14             	mov    0x14(%ebp),%eax
  800913:	8b 10                	mov    (%eax),%edx
  800915:	8b 48 04             	mov    0x4(%eax),%ecx
  800918:	8d 40 08             	lea    0x8(%eax),%eax
  80091b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80091e:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800923:	eb 8a                	jmp    8008af <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800925:	8b 45 14             	mov    0x14(%ebp),%eax
  800928:	8b 10                	mov    (%eax),%edx
  80092a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80092f:	8d 40 04             	lea    0x4(%eax),%eax
  800932:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800935:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80093a:	e9 70 ff ff ff       	jmp    8008af <vprintfmt+0x38c>
			putch(ch, putdat);
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	53                   	push   %ebx
  800943:	6a 25                	push   $0x25
  800945:	ff d6                	call   *%esi
			break;
  800947:	83 c4 10             	add    $0x10,%esp
  80094a:	e9 7a ff ff ff       	jmp    8008c9 <vprintfmt+0x3a6>
			putch('%', putdat);
  80094f:	83 ec 08             	sub    $0x8,%esp
  800952:	53                   	push   %ebx
  800953:	6a 25                	push   $0x25
  800955:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800957:	83 c4 10             	add    $0x10,%esp
  80095a:	89 f8                	mov    %edi,%eax
  80095c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800960:	74 05                	je     800967 <vprintfmt+0x444>
  800962:	83 e8 01             	sub    $0x1,%eax
  800965:	eb f5                	jmp    80095c <vprintfmt+0x439>
  800967:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80096a:	e9 5a ff ff ff       	jmp    8008c9 <vprintfmt+0x3a6>
}
  80096f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800972:	5b                   	pop    %ebx
  800973:	5e                   	pop    %esi
  800974:	5f                   	pop    %edi
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800977:	f3 0f 1e fb          	endbr32 
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	83 ec 18             	sub    $0x18,%esp
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800987:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80098a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80098e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800991:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800998:	85 c0                	test   %eax,%eax
  80099a:	74 26                	je     8009c2 <vsnprintf+0x4b>
  80099c:	85 d2                	test   %edx,%edx
  80099e:	7e 22                	jle    8009c2 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009a0:	ff 75 14             	pushl  0x14(%ebp)
  8009a3:	ff 75 10             	pushl  0x10(%ebp)
  8009a6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009a9:	50                   	push   %eax
  8009aa:	68 e1 04 80 00       	push   $0x8004e1
  8009af:	e8 6f fb ff ff       	call   800523 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009bd:	83 c4 10             	add    $0x10,%esp
}
  8009c0:	c9                   	leave  
  8009c1:	c3                   	ret    
		return -E_INVAL;
  8009c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009c7:	eb f7                	jmp    8009c0 <vsnprintf+0x49>

008009c9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009c9:	f3 0f 1e fb          	endbr32 
  8009cd:	55                   	push   %ebp
  8009ce:	89 e5                	mov    %esp,%ebp
  8009d0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009d6:	50                   	push   %eax
  8009d7:	ff 75 10             	pushl  0x10(%ebp)
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	ff 75 08             	pushl  0x8(%ebp)
  8009e0:	e8 92 ff ff ff       	call   800977 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009e5:	c9                   	leave  
  8009e6:	c3                   	ret    

008009e7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009e7:	f3 0f 1e fb          	endbr32 
  8009eb:	55                   	push   %ebp
  8009ec:	89 e5                	mov    %esp,%ebp
  8009ee:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009fa:	74 05                	je     800a01 <strlen+0x1a>
		n++;
  8009fc:	83 c0 01             	add    $0x1,%eax
  8009ff:	eb f5                	jmp    8009f6 <strlen+0xf>
	return n;
}
  800a01:	5d                   	pop    %ebp
  800a02:	c3                   	ret    

00800a03 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a03:	f3 0f 1e fb          	endbr32 
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a10:	b8 00 00 00 00       	mov    $0x0,%eax
  800a15:	39 d0                	cmp    %edx,%eax
  800a17:	74 0d                	je     800a26 <strnlen+0x23>
  800a19:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a1d:	74 05                	je     800a24 <strnlen+0x21>
		n++;
  800a1f:	83 c0 01             	add    $0x1,%eax
  800a22:	eb f1                	jmp    800a15 <strnlen+0x12>
  800a24:	89 c2                	mov    %eax,%edx
	return n;
}
  800a26:	89 d0                	mov    %edx,%eax
  800a28:	5d                   	pop    %ebp
  800a29:	c3                   	ret    

00800a2a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a2a:	f3 0f 1e fb          	endbr32 
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	53                   	push   %ebx
  800a32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a35:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a38:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3d:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800a41:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800a44:	83 c0 01             	add    $0x1,%eax
  800a47:	84 d2                	test   %dl,%dl
  800a49:	75 f2                	jne    800a3d <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800a4b:	89 c8                	mov    %ecx,%eax
  800a4d:	5b                   	pop    %ebx
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    

00800a50 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a50:	f3 0f 1e fb          	endbr32 
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	53                   	push   %ebx
  800a58:	83 ec 10             	sub    $0x10,%esp
  800a5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a5e:	53                   	push   %ebx
  800a5f:	e8 83 ff ff ff       	call   8009e7 <strlen>
  800a64:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a67:	ff 75 0c             	pushl  0xc(%ebp)
  800a6a:	01 d8                	add    %ebx,%eax
  800a6c:	50                   	push   %eax
  800a6d:	e8 b8 ff ff ff       	call   800a2a <strcpy>
	return dst;
}
  800a72:	89 d8                	mov    %ebx,%eax
  800a74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a77:	c9                   	leave  
  800a78:	c3                   	ret    

00800a79 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a79:	f3 0f 1e fb          	endbr32 
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	56                   	push   %esi
  800a81:	53                   	push   %ebx
  800a82:	8b 75 08             	mov    0x8(%ebp),%esi
  800a85:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a88:	89 f3                	mov    %esi,%ebx
  800a8a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a8d:	89 f0                	mov    %esi,%eax
  800a8f:	39 d8                	cmp    %ebx,%eax
  800a91:	74 11                	je     800aa4 <strncpy+0x2b>
		*dst++ = *src;
  800a93:	83 c0 01             	add    $0x1,%eax
  800a96:	0f b6 0a             	movzbl (%edx),%ecx
  800a99:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a9c:	80 f9 01             	cmp    $0x1,%cl
  800a9f:	83 da ff             	sbb    $0xffffffff,%edx
  800aa2:	eb eb                	jmp    800a8f <strncpy+0x16>
	}
	return ret;
}
  800aa4:	89 f0                	mov    %esi,%eax
  800aa6:	5b                   	pop    %ebx
  800aa7:	5e                   	pop    %esi
  800aa8:	5d                   	pop    %ebp
  800aa9:	c3                   	ret    

00800aaa <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aaa:	f3 0f 1e fb          	endbr32 
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	56                   	push   %esi
  800ab2:	53                   	push   %ebx
  800ab3:	8b 75 08             	mov    0x8(%ebp),%esi
  800ab6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ab9:	8b 55 10             	mov    0x10(%ebp),%edx
  800abc:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800abe:	85 d2                	test   %edx,%edx
  800ac0:	74 21                	je     800ae3 <strlcpy+0x39>
  800ac2:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ac6:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ac8:	39 c2                	cmp    %eax,%edx
  800aca:	74 14                	je     800ae0 <strlcpy+0x36>
  800acc:	0f b6 19             	movzbl (%ecx),%ebx
  800acf:	84 db                	test   %bl,%bl
  800ad1:	74 0b                	je     800ade <strlcpy+0x34>
			*dst++ = *src++;
  800ad3:	83 c1 01             	add    $0x1,%ecx
  800ad6:	83 c2 01             	add    $0x1,%edx
  800ad9:	88 5a ff             	mov    %bl,-0x1(%edx)
  800adc:	eb ea                	jmp    800ac8 <strlcpy+0x1e>
  800ade:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ae0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ae3:	29 f0                	sub    %esi,%eax
}
  800ae5:	5b                   	pop    %ebx
  800ae6:	5e                   	pop    %esi
  800ae7:	5d                   	pop    %ebp
  800ae8:	c3                   	ret    

00800ae9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ae9:	f3 0f 1e fb          	endbr32 
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
  800af0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800af6:	0f b6 01             	movzbl (%ecx),%eax
  800af9:	84 c0                	test   %al,%al
  800afb:	74 0c                	je     800b09 <strcmp+0x20>
  800afd:	3a 02                	cmp    (%edx),%al
  800aff:	75 08                	jne    800b09 <strcmp+0x20>
		p++, q++;
  800b01:	83 c1 01             	add    $0x1,%ecx
  800b04:	83 c2 01             	add    $0x1,%edx
  800b07:	eb ed                	jmp    800af6 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b09:	0f b6 c0             	movzbl %al,%eax
  800b0c:	0f b6 12             	movzbl (%edx),%edx
  800b0f:	29 d0                	sub    %edx,%eax
}
  800b11:	5d                   	pop    %ebp
  800b12:	c3                   	ret    

00800b13 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b13:	f3 0f 1e fb          	endbr32 
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	53                   	push   %ebx
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b21:	89 c3                	mov    %eax,%ebx
  800b23:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b26:	eb 06                	jmp    800b2e <strncmp+0x1b>
		n--, p++, q++;
  800b28:	83 c0 01             	add    $0x1,%eax
  800b2b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b2e:	39 d8                	cmp    %ebx,%eax
  800b30:	74 16                	je     800b48 <strncmp+0x35>
  800b32:	0f b6 08             	movzbl (%eax),%ecx
  800b35:	84 c9                	test   %cl,%cl
  800b37:	74 04                	je     800b3d <strncmp+0x2a>
  800b39:	3a 0a                	cmp    (%edx),%cl
  800b3b:	74 eb                	je     800b28 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b3d:	0f b6 00             	movzbl (%eax),%eax
  800b40:	0f b6 12             	movzbl (%edx),%edx
  800b43:	29 d0                	sub    %edx,%eax
}
  800b45:	5b                   	pop    %ebx
  800b46:	5d                   	pop    %ebp
  800b47:	c3                   	ret    
		return 0;
  800b48:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4d:	eb f6                	jmp    800b45 <strncmp+0x32>

00800b4f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b4f:	f3 0f 1e fb          	endbr32 
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b5d:	0f b6 10             	movzbl (%eax),%edx
  800b60:	84 d2                	test   %dl,%dl
  800b62:	74 09                	je     800b6d <strchr+0x1e>
		if (*s == c)
  800b64:	38 ca                	cmp    %cl,%dl
  800b66:	74 0a                	je     800b72 <strchr+0x23>
	for (; *s; s++)
  800b68:	83 c0 01             	add    $0x1,%eax
  800b6b:	eb f0                	jmp    800b5d <strchr+0xe>
			return (char *) s;
	return 0;
  800b6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    

00800b74 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b74:	f3 0f 1e fb          	endbr32 
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b82:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b85:	38 ca                	cmp    %cl,%dl
  800b87:	74 09                	je     800b92 <strfind+0x1e>
  800b89:	84 d2                	test   %dl,%dl
  800b8b:	74 05                	je     800b92 <strfind+0x1e>
	for (; *s; s++)
  800b8d:	83 c0 01             	add    $0x1,%eax
  800b90:	eb f0                	jmp    800b82 <strfind+0xe>
			break;
	return (char *) s;
}
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    

00800b94 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b94:	f3 0f 1e fb          	endbr32 
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	57                   	push   %edi
  800b9c:	56                   	push   %esi
  800b9d:	53                   	push   %ebx
  800b9e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ba1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ba4:	85 c9                	test   %ecx,%ecx
  800ba6:	74 31                	je     800bd9 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ba8:	89 f8                	mov    %edi,%eax
  800baa:	09 c8                	or     %ecx,%eax
  800bac:	a8 03                	test   $0x3,%al
  800bae:	75 23                	jne    800bd3 <memset+0x3f>
		c &= 0xFF;
  800bb0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bb4:	89 d3                	mov    %edx,%ebx
  800bb6:	c1 e3 08             	shl    $0x8,%ebx
  800bb9:	89 d0                	mov    %edx,%eax
  800bbb:	c1 e0 18             	shl    $0x18,%eax
  800bbe:	89 d6                	mov    %edx,%esi
  800bc0:	c1 e6 10             	shl    $0x10,%esi
  800bc3:	09 f0                	or     %esi,%eax
  800bc5:	09 c2                	or     %eax,%edx
  800bc7:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bc9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bcc:	89 d0                	mov    %edx,%eax
  800bce:	fc                   	cld    
  800bcf:	f3 ab                	rep stos %eax,%es:(%edi)
  800bd1:	eb 06                	jmp    800bd9 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd6:	fc                   	cld    
  800bd7:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bd9:	89 f8                	mov    %edi,%eax
  800bdb:	5b                   	pop    %ebx
  800bdc:	5e                   	pop    %esi
  800bdd:	5f                   	pop    %edi
  800bde:	5d                   	pop    %ebp
  800bdf:	c3                   	ret    

00800be0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800be0:	f3 0f 1e fb          	endbr32 
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	57                   	push   %edi
  800be8:	56                   	push   %esi
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bef:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bf2:	39 c6                	cmp    %eax,%esi
  800bf4:	73 32                	jae    800c28 <memmove+0x48>
  800bf6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bf9:	39 c2                	cmp    %eax,%edx
  800bfb:	76 2b                	jbe    800c28 <memmove+0x48>
		s += n;
		d += n;
  800bfd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c00:	89 fe                	mov    %edi,%esi
  800c02:	09 ce                	or     %ecx,%esi
  800c04:	09 d6                	or     %edx,%esi
  800c06:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c0c:	75 0e                	jne    800c1c <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c0e:	83 ef 04             	sub    $0x4,%edi
  800c11:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c14:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c17:	fd                   	std    
  800c18:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c1a:	eb 09                	jmp    800c25 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c1c:	83 ef 01             	sub    $0x1,%edi
  800c1f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c22:	fd                   	std    
  800c23:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c25:	fc                   	cld    
  800c26:	eb 1a                	jmp    800c42 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c28:	89 c2                	mov    %eax,%edx
  800c2a:	09 ca                	or     %ecx,%edx
  800c2c:	09 f2                	or     %esi,%edx
  800c2e:	f6 c2 03             	test   $0x3,%dl
  800c31:	75 0a                	jne    800c3d <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c33:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c36:	89 c7                	mov    %eax,%edi
  800c38:	fc                   	cld    
  800c39:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c3b:	eb 05                	jmp    800c42 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800c3d:	89 c7                	mov    %eax,%edi
  800c3f:	fc                   	cld    
  800c40:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c42:	5e                   	pop    %esi
  800c43:	5f                   	pop    %edi
  800c44:	5d                   	pop    %ebp
  800c45:	c3                   	ret    

00800c46 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c46:	f3 0f 1e fb          	endbr32 
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c50:	ff 75 10             	pushl  0x10(%ebp)
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	ff 75 08             	pushl  0x8(%ebp)
  800c59:	e8 82 ff ff ff       	call   800be0 <memmove>
}
  800c5e:	c9                   	leave  
  800c5f:	c3                   	ret    

00800c60 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c60:	f3 0f 1e fb          	endbr32 
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6f:	89 c6                	mov    %eax,%esi
  800c71:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c74:	39 f0                	cmp    %esi,%eax
  800c76:	74 1c                	je     800c94 <memcmp+0x34>
		if (*s1 != *s2)
  800c78:	0f b6 08             	movzbl (%eax),%ecx
  800c7b:	0f b6 1a             	movzbl (%edx),%ebx
  800c7e:	38 d9                	cmp    %bl,%cl
  800c80:	75 08                	jne    800c8a <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c82:	83 c0 01             	add    $0x1,%eax
  800c85:	83 c2 01             	add    $0x1,%edx
  800c88:	eb ea                	jmp    800c74 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800c8a:	0f b6 c1             	movzbl %cl,%eax
  800c8d:	0f b6 db             	movzbl %bl,%ebx
  800c90:	29 d8                	sub    %ebx,%eax
  800c92:	eb 05                	jmp    800c99 <memcmp+0x39>
	}

	return 0;
  800c94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c99:	5b                   	pop    %ebx
  800c9a:	5e                   	pop    %esi
  800c9b:	5d                   	pop    %ebp
  800c9c:	c3                   	ret    

00800c9d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c9d:	f3 0f 1e fb          	endbr32 
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800caa:	89 c2                	mov    %eax,%edx
  800cac:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800caf:	39 d0                	cmp    %edx,%eax
  800cb1:	73 09                	jae    800cbc <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cb3:	38 08                	cmp    %cl,(%eax)
  800cb5:	74 05                	je     800cbc <memfind+0x1f>
	for (; s < ends; s++)
  800cb7:	83 c0 01             	add    $0x1,%eax
  800cba:	eb f3                	jmp    800caf <memfind+0x12>
			break;
	return (void *) s;
}
  800cbc:	5d                   	pop    %ebp
  800cbd:	c3                   	ret    

00800cbe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cbe:	f3 0f 1e fb          	endbr32 
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	57                   	push   %edi
  800cc6:	56                   	push   %esi
  800cc7:	53                   	push   %ebx
  800cc8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ccb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cce:	eb 03                	jmp    800cd3 <strtol+0x15>
		s++;
  800cd0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cd3:	0f b6 01             	movzbl (%ecx),%eax
  800cd6:	3c 20                	cmp    $0x20,%al
  800cd8:	74 f6                	je     800cd0 <strtol+0x12>
  800cda:	3c 09                	cmp    $0x9,%al
  800cdc:	74 f2                	je     800cd0 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800cde:	3c 2b                	cmp    $0x2b,%al
  800ce0:	74 2a                	je     800d0c <strtol+0x4e>
	int neg = 0;
  800ce2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ce7:	3c 2d                	cmp    $0x2d,%al
  800ce9:	74 2b                	je     800d16 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ceb:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cf1:	75 0f                	jne    800d02 <strtol+0x44>
  800cf3:	80 39 30             	cmpb   $0x30,(%ecx)
  800cf6:	74 28                	je     800d20 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cf8:	85 db                	test   %ebx,%ebx
  800cfa:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cff:	0f 44 d8             	cmove  %eax,%ebx
  800d02:	b8 00 00 00 00       	mov    $0x0,%eax
  800d07:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d0a:	eb 46                	jmp    800d52 <strtol+0x94>
		s++;
  800d0c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d0f:	bf 00 00 00 00       	mov    $0x0,%edi
  800d14:	eb d5                	jmp    800ceb <strtol+0x2d>
		s++, neg = 1;
  800d16:	83 c1 01             	add    $0x1,%ecx
  800d19:	bf 01 00 00 00       	mov    $0x1,%edi
  800d1e:	eb cb                	jmp    800ceb <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d20:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d24:	74 0e                	je     800d34 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d26:	85 db                	test   %ebx,%ebx
  800d28:	75 d8                	jne    800d02 <strtol+0x44>
		s++, base = 8;
  800d2a:	83 c1 01             	add    $0x1,%ecx
  800d2d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d32:	eb ce                	jmp    800d02 <strtol+0x44>
		s += 2, base = 16;
  800d34:	83 c1 02             	add    $0x2,%ecx
  800d37:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d3c:	eb c4                	jmp    800d02 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800d3e:	0f be d2             	movsbl %dl,%edx
  800d41:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d44:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d47:	7d 3a                	jge    800d83 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d49:	83 c1 01             	add    $0x1,%ecx
  800d4c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d50:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d52:	0f b6 11             	movzbl (%ecx),%edx
  800d55:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d58:	89 f3                	mov    %esi,%ebx
  800d5a:	80 fb 09             	cmp    $0x9,%bl
  800d5d:	76 df                	jbe    800d3e <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800d5f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d62:	89 f3                	mov    %esi,%ebx
  800d64:	80 fb 19             	cmp    $0x19,%bl
  800d67:	77 08                	ja     800d71 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d69:	0f be d2             	movsbl %dl,%edx
  800d6c:	83 ea 57             	sub    $0x57,%edx
  800d6f:	eb d3                	jmp    800d44 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800d71:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d74:	89 f3                	mov    %esi,%ebx
  800d76:	80 fb 19             	cmp    $0x19,%bl
  800d79:	77 08                	ja     800d83 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d7b:	0f be d2             	movsbl %dl,%edx
  800d7e:	83 ea 37             	sub    $0x37,%edx
  800d81:	eb c1                	jmp    800d44 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d87:	74 05                	je     800d8e <strtol+0xd0>
		*endptr = (char *) s;
  800d89:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d8c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d8e:	89 c2                	mov    %eax,%edx
  800d90:	f7 da                	neg    %edx
  800d92:	85 ff                	test   %edi,%edi
  800d94:	0f 45 c2             	cmovne %edx,%eax
}
  800d97:	5b                   	pop    %ebx
  800d98:	5e                   	pop    %esi
  800d99:	5f                   	pop    %edi
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    
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
