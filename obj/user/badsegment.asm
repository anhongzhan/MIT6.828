
obj/user/badsegment.debug:     file format elf32-i386


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
  80004d:	e8 de 00 00 00       	call   800130 <sys_getenvid>
  800052:	25 ff 03 00 00       	and    $0x3ff,%eax
  800057:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005f:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800064:	85 db                	test   %ebx,%ebx
  800066:	7e 07                	jle    80006f <libmain+0x31>
		binaryname = argv[0];
  800068:	8b 06                	mov    (%esi),%eax
  80006a:	a3 00 30 80 00       	mov    %eax,0x803000

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
  80008f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800092:	e8 df 04 00 00       	call   800576 <close_all>
	sys_env_destroy(0);
  800097:	83 ec 0c             	sub    $0xc,%esp
  80009a:	6a 00                	push   $0x0
  80009c:	e8 4a 00 00 00       	call   8000eb <sys_env_destroy>
}
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	c9                   	leave  
  8000a5:	c3                   	ret    

008000a6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a6:	f3 0f 1e fb          	endbr32 
  8000aa:	55                   	push   %ebp
  8000ab:	89 e5                	mov    %esp,%ebp
  8000ad:	57                   	push   %edi
  8000ae:	56                   	push   %esi
  8000af:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000bb:	89 c3                	mov    %eax,%ebx
  8000bd:	89 c7                	mov    %eax,%edi
  8000bf:	89 c6                	mov    %eax,%esi
  8000c1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c3:	5b                   	pop    %ebx
  8000c4:	5e                   	pop    %esi
  8000c5:	5f                   	pop    %edi
  8000c6:	5d                   	pop    %ebp
  8000c7:	c3                   	ret    

008000c8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c8:	f3 0f 1e fb          	endbr32 
  8000cc:	55                   	push   %ebp
  8000cd:	89 e5                	mov    %esp,%ebp
  8000cf:	57                   	push   %edi
  8000d0:	56                   	push   %esi
  8000d1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8000dc:	89 d1                	mov    %edx,%ecx
  8000de:	89 d3                	mov    %edx,%ebx
  8000e0:	89 d7                	mov    %edx,%edi
  8000e2:	89 d6                	mov    %edx,%esi
  8000e4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5f                   	pop    %edi
  8000e9:	5d                   	pop    %ebp
  8000ea:	c3                   	ret    

008000eb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000eb:	f3 0f 1e fb          	endbr32 
  8000ef:	55                   	push   %ebp
  8000f0:	89 e5                	mov    %esp,%ebp
  8000f2:	57                   	push   %edi
  8000f3:	56                   	push   %esi
  8000f4:	53                   	push   %ebx
  8000f5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000fd:	8b 55 08             	mov    0x8(%ebp),%edx
  800100:	b8 03 00 00 00       	mov    $0x3,%eax
  800105:	89 cb                	mov    %ecx,%ebx
  800107:	89 cf                	mov    %ecx,%edi
  800109:	89 ce                	mov    %ecx,%esi
  80010b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80010d:	85 c0                	test   %eax,%eax
  80010f:	7f 08                	jg     800119 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800111:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800114:	5b                   	pop    %ebx
  800115:	5e                   	pop    %esi
  800116:	5f                   	pop    %edi
  800117:	5d                   	pop    %ebp
  800118:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	50                   	push   %eax
  80011d:	6a 03                	push   $0x3
  80011f:	68 0a 1f 80 00       	push   $0x801f0a
  800124:	6a 23                	push   $0x23
  800126:	68 27 1f 80 00       	push   $0x801f27
  80012b:	e8 9c 0f 00 00       	call   8010cc <_panic>

00800130 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800130:	f3 0f 1e fb          	endbr32 
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	57                   	push   %edi
  800138:	56                   	push   %esi
  800139:	53                   	push   %ebx
	asm volatile("int %1\n"
  80013a:	ba 00 00 00 00       	mov    $0x0,%edx
  80013f:	b8 02 00 00 00       	mov    $0x2,%eax
  800144:	89 d1                	mov    %edx,%ecx
  800146:	89 d3                	mov    %edx,%ebx
  800148:	89 d7                	mov    %edx,%edi
  80014a:	89 d6                	mov    %edx,%esi
  80014c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80014e:	5b                   	pop    %ebx
  80014f:	5e                   	pop    %esi
  800150:	5f                   	pop    %edi
  800151:	5d                   	pop    %ebp
  800152:	c3                   	ret    

00800153 <sys_yield>:

void
sys_yield(void)
{
  800153:	f3 0f 1e fb          	endbr32 
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	57                   	push   %edi
  80015b:	56                   	push   %esi
  80015c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80015d:	ba 00 00 00 00       	mov    $0x0,%edx
  800162:	b8 0b 00 00 00       	mov    $0xb,%eax
  800167:	89 d1                	mov    %edx,%ecx
  800169:	89 d3                	mov    %edx,%ebx
  80016b:	89 d7                	mov    %edx,%edi
  80016d:	89 d6                	mov    %edx,%esi
  80016f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800171:	5b                   	pop    %ebx
  800172:	5e                   	pop    %esi
  800173:	5f                   	pop    %edi
  800174:	5d                   	pop    %ebp
  800175:	c3                   	ret    

00800176 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800176:	f3 0f 1e fb          	endbr32 
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	57                   	push   %edi
  80017e:	56                   	push   %esi
  80017f:	53                   	push   %ebx
  800180:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800183:	be 00 00 00 00       	mov    $0x0,%esi
  800188:	8b 55 08             	mov    0x8(%ebp),%edx
  80018b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80018e:	b8 04 00 00 00       	mov    $0x4,%eax
  800193:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800196:	89 f7                	mov    %esi,%edi
  800198:	cd 30                	int    $0x30
	if(check && ret > 0)
  80019a:	85 c0                	test   %eax,%eax
  80019c:	7f 08                	jg     8001a6 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80019e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a1:	5b                   	pop    %ebx
  8001a2:	5e                   	pop    %esi
  8001a3:	5f                   	pop    %edi
  8001a4:	5d                   	pop    %ebp
  8001a5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001a6:	83 ec 0c             	sub    $0xc,%esp
  8001a9:	50                   	push   %eax
  8001aa:	6a 04                	push   $0x4
  8001ac:	68 0a 1f 80 00       	push   $0x801f0a
  8001b1:	6a 23                	push   $0x23
  8001b3:	68 27 1f 80 00       	push   $0x801f27
  8001b8:	e8 0f 0f 00 00       	call   8010cc <_panic>

008001bd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001bd:	f3 0f 1e fb          	endbr32 
  8001c1:	55                   	push   %ebp
  8001c2:	89 e5                	mov    %esp,%ebp
  8001c4:	57                   	push   %edi
  8001c5:	56                   	push   %esi
  8001c6:	53                   	push   %ebx
  8001c7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8001cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001d0:	b8 05 00 00 00       	mov    $0x5,%eax
  8001d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001d8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001db:	8b 75 18             	mov    0x18(%ebp),%esi
  8001de:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001e0:	85 c0                	test   %eax,%eax
  8001e2:	7f 08                	jg     8001ec <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e7:	5b                   	pop    %ebx
  8001e8:	5e                   	pop    %esi
  8001e9:	5f                   	pop    %edi
  8001ea:	5d                   	pop    %ebp
  8001eb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ec:	83 ec 0c             	sub    $0xc,%esp
  8001ef:	50                   	push   %eax
  8001f0:	6a 05                	push   $0x5
  8001f2:	68 0a 1f 80 00       	push   $0x801f0a
  8001f7:	6a 23                	push   $0x23
  8001f9:	68 27 1f 80 00       	push   $0x801f27
  8001fe:	e8 c9 0e 00 00       	call   8010cc <_panic>

00800203 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800203:	f3 0f 1e fb          	endbr32 
  800207:	55                   	push   %ebp
  800208:	89 e5                	mov    %esp,%ebp
  80020a:	57                   	push   %edi
  80020b:	56                   	push   %esi
  80020c:	53                   	push   %ebx
  80020d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800210:	bb 00 00 00 00       	mov    $0x0,%ebx
  800215:	8b 55 08             	mov    0x8(%ebp),%edx
  800218:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80021b:	b8 06 00 00 00       	mov    $0x6,%eax
  800220:	89 df                	mov    %ebx,%edi
  800222:	89 de                	mov    %ebx,%esi
  800224:	cd 30                	int    $0x30
	if(check && ret > 0)
  800226:	85 c0                	test   %eax,%eax
  800228:	7f 08                	jg     800232 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80022a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80022d:	5b                   	pop    %ebx
  80022e:	5e                   	pop    %esi
  80022f:	5f                   	pop    %edi
  800230:	5d                   	pop    %ebp
  800231:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	50                   	push   %eax
  800236:	6a 06                	push   $0x6
  800238:	68 0a 1f 80 00       	push   $0x801f0a
  80023d:	6a 23                	push   $0x23
  80023f:	68 27 1f 80 00       	push   $0x801f27
  800244:	e8 83 0e 00 00       	call   8010cc <_panic>

00800249 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800249:	f3 0f 1e fb          	endbr32 
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	57                   	push   %edi
  800251:	56                   	push   %esi
  800252:	53                   	push   %ebx
  800253:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800256:	bb 00 00 00 00       	mov    $0x0,%ebx
  80025b:	8b 55 08             	mov    0x8(%ebp),%edx
  80025e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800261:	b8 08 00 00 00       	mov    $0x8,%eax
  800266:	89 df                	mov    %ebx,%edi
  800268:	89 de                	mov    %ebx,%esi
  80026a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80026c:	85 c0                	test   %eax,%eax
  80026e:	7f 08                	jg     800278 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800270:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800273:	5b                   	pop    %ebx
  800274:	5e                   	pop    %esi
  800275:	5f                   	pop    %edi
  800276:	5d                   	pop    %ebp
  800277:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800278:	83 ec 0c             	sub    $0xc,%esp
  80027b:	50                   	push   %eax
  80027c:	6a 08                	push   $0x8
  80027e:	68 0a 1f 80 00       	push   $0x801f0a
  800283:	6a 23                	push   $0x23
  800285:	68 27 1f 80 00       	push   $0x801f27
  80028a:	e8 3d 0e 00 00       	call   8010cc <_panic>

0080028f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80028f:	f3 0f 1e fb          	endbr32 
  800293:	55                   	push   %ebp
  800294:	89 e5                	mov    %esp,%ebp
  800296:	57                   	push   %edi
  800297:	56                   	push   %esi
  800298:	53                   	push   %ebx
  800299:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80029c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002a7:	b8 09 00 00 00       	mov    $0x9,%eax
  8002ac:	89 df                	mov    %ebx,%edi
  8002ae:	89 de                	mov    %ebx,%esi
  8002b0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002b2:	85 c0                	test   %eax,%eax
  8002b4:	7f 08                	jg     8002be <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b9:	5b                   	pop    %ebx
  8002ba:	5e                   	pop    %esi
  8002bb:	5f                   	pop    %edi
  8002bc:	5d                   	pop    %ebp
  8002bd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	50                   	push   %eax
  8002c2:	6a 09                	push   $0x9
  8002c4:	68 0a 1f 80 00       	push   $0x801f0a
  8002c9:	6a 23                	push   $0x23
  8002cb:	68 27 1f 80 00       	push   $0x801f27
  8002d0:	e8 f7 0d 00 00       	call   8010cc <_panic>

008002d5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002d5:	f3 0f 1e fb          	endbr32 
  8002d9:	55                   	push   %ebp
  8002da:	89 e5                	mov    %esp,%ebp
  8002dc:	57                   	push   %edi
  8002dd:	56                   	push   %esi
  8002de:	53                   	push   %ebx
  8002df:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ed:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002f2:	89 df                	mov    %ebx,%edi
  8002f4:	89 de                	mov    %ebx,%esi
  8002f6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002f8:	85 c0                	test   %eax,%eax
  8002fa:	7f 08                	jg     800304 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ff:	5b                   	pop    %ebx
  800300:	5e                   	pop    %esi
  800301:	5f                   	pop    %edi
  800302:	5d                   	pop    %ebp
  800303:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	50                   	push   %eax
  800308:	6a 0a                	push   $0xa
  80030a:	68 0a 1f 80 00       	push   $0x801f0a
  80030f:	6a 23                	push   $0x23
  800311:	68 27 1f 80 00       	push   $0x801f27
  800316:	e8 b1 0d 00 00       	call   8010cc <_panic>

0080031b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80031b:	f3 0f 1e fb          	endbr32 
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	57                   	push   %edi
  800323:	56                   	push   %esi
  800324:	53                   	push   %ebx
	asm volatile("int %1\n"
  800325:	8b 55 08             	mov    0x8(%ebp),%edx
  800328:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80032b:	b8 0c 00 00 00       	mov    $0xc,%eax
  800330:	be 00 00 00 00       	mov    $0x0,%esi
  800335:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800338:	8b 7d 14             	mov    0x14(%ebp),%edi
  80033b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80033d:	5b                   	pop    %ebx
  80033e:	5e                   	pop    %esi
  80033f:	5f                   	pop    %edi
  800340:	5d                   	pop    %ebp
  800341:	c3                   	ret    

00800342 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800342:	f3 0f 1e fb          	endbr32 
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	57                   	push   %edi
  80034a:	56                   	push   %esi
  80034b:	53                   	push   %ebx
  80034c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80034f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800354:	8b 55 08             	mov    0x8(%ebp),%edx
  800357:	b8 0d 00 00 00       	mov    $0xd,%eax
  80035c:	89 cb                	mov    %ecx,%ebx
  80035e:	89 cf                	mov    %ecx,%edi
  800360:	89 ce                	mov    %ecx,%esi
  800362:	cd 30                	int    $0x30
	if(check && ret > 0)
  800364:	85 c0                	test   %eax,%eax
  800366:	7f 08                	jg     800370 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800368:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80036b:	5b                   	pop    %ebx
  80036c:	5e                   	pop    %esi
  80036d:	5f                   	pop    %edi
  80036e:	5d                   	pop    %ebp
  80036f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800370:	83 ec 0c             	sub    $0xc,%esp
  800373:	50                   	push   %eax
  800374:	6a 0d                	push   $0xd
  800376:	68 0a 1f 80 00       	push   $0x801f0a
  80037b:	6a 23                	push   $0x23
  80037d:	68 27 1f 80 00       	push   $0x801f27
  800382:	e8 45 0d 00 00       	call   8010cc <_panic>

00800387 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800387:	f3 0f 1e fb          	endbr32 
  80038b:	55                   	push   %ebp
  80038c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	05 00 00 00 30       	add    $0x30000000,%eax
  800396:	c1 e8 0c             	shr    $0xc,%eax
}
  800399:	5d                   	pop    %ebp
  80039a:	c3                   	ret    

0080039b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80039b:	f3 0f 1e fb          	endbr32 
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003af:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003b4:	5d                   	pop    %ebp
  8003b5:	c3                   	ret    

008003b6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003b6:	f3 0f 1e fb          	endbr32 
  8003ba:	55                   	push   %ebp
  8003bb:	89 e5                	mov    %esp,%ebp
  8003bd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003c2:	89 c2                	mov    %eax,%edx
  8003c4:	c1 ea 16             	shr    $0x16,%edx
  8003c7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003ce:	f6 c2 01             	test   $0x1,%dl
  8003d1:	74 2d                	je     800400 <fd_alloc+0x4a>
  8003d3:	89 c2                	mov    %eax,%edx
  8003d5:	c1 ea 0c             	shr    $0xc,%edx
  8003d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003df:	f6 c2 01             	test   $0x1,%dl
  8003e2:	74 1c                	je     800400 <fd_alloc+0x4a>
  8003e4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003e9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003ee:	75 d2                	jne    8003c2 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8003f9:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003fe:	eb 0a                	jmp    80040a <fd_alloc+0x54>
			*fd_store = fd;
  800400:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800403:	89 01                	mov    %eax,(%ecx)
			return 0;
  800405:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80040a:	5d                   	pop    %ebp
  80040b:	c3                   	ret    

0080040c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80040c:	f3 0f 1e fb          	endbr32 
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800416:	83 f8 1f             	cmp    $0x1f,%eax
  800419:	77 30                	ja     80044b <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80041b:	c1 e0 0c             	shl    $0xc,%eax
  80041e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800423:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800429:	f6 c2 01             	test   $0x1,%dl
  80042c:	74 24                	je     800452 <fd_lookup+0x46>
  80042e:	89 c2                	mov    %eax,%edx
  800430:	c1 ea 0c             	shr    $0xc,%edx
  800433:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80043a:	f6 c2 01             	test   $0x1,%dl
  80043d:	74 1a                	je     800459 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80043f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800442:	89 02                	mov    %eax,(%edx)
	return 0;
  800444:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800449:	5d                   	pop    %ebp
  80044a:	c3                   	ret    
		return -E_INVAL;
  80044b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800450:	eb f7                	jmp    800449 <fd_lookup+0x3d>
		return -E_INVAL;
  800452:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800457:	eb f0                	jmp    800449 <fd_lookup+0x3d>
  800459:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80045e:	eb e9                	jmp    800449 <fd_lookup+0x3d>

00800460 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800460:	f3 0f 1e fb          	endbr32 
  800464:	55                   	push   %ebp
  800465:	89 e5                	mov    %esp,%ebp
  800467:	83 ec 08             	sub    $0x8,%esp
  80046a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80046d:	ba b4 1f 80 00       	mov    $0x801fb4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800472:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800477:	39 08                	cmp    %ecx,(%eax)
  800479:	74 33                	je     8004ae <dev_lookup+0x4e>
  80047b:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80047e:	8b 02                	mov    (%edx),%eax
  800480:	85 c0                	test   %eax,%eax
  800482:	75 f3                	jne    800477 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800484:	a1 04 40 80 00       	mov    0x804004,%eax
  800489:	8b 40 48             	mov    0x48(%eax),%eax
  80048c:	83 ec 04             	sub    $0x4,%esp
  80048f:	51                   	push   %ecx
  800490:	50                   	push   %eax
  800491:	68 38 1f 80 00       	push   $0x801f38
  800496:	e8 18 0d 00 00       	call   8011b3 <cprintf>
	*dev = 0;
  80049b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004a4:	83 c4 10             	add    $0x10,%esp
  8004a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    
			*dev = devtab[i];
  8004ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004b1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b8:	eb f2                	jmp    8004ac <dev_lookup+0x4c>

008004ba <fd_close>:
{
  8004ba:	f3 0f 1e fb          	endbr32 
  8004be:	55                   	push   %ebp
  8004bf:	89 e5                	mov    %esp,%ebp
  8004c1:	57                   	push   %edi
  8004c2:	56                   	push   %esi
  8004c3:	53                   	push   %ebx
  8004c4:	83 ec 24             	sub    $0x24,%esp
  8004c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ca:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004cd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004d0:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004d1:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004d7:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004da:	50                   	push   %eax
  8004db:	e8 2c ff ff ff       	call   80040c <fd_lookup>
  8004e0:	89 c3                	mov    %eax,%ebx
  8004e2:	83 c4 10             	add    $0x10,%esp
  8004e5:	85 c0                	test   %eax,%eax
  8004e7:	78 05                	js     8004ee <fd_close+0x34>
	    || fd != fd2)
  8004e9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004ec:	74 16                	je     800504 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8004ee:	89 f8                	mov    %edi,%eax
  8004f0:	84 c0                	test   %al,%al
  8004f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f7:	0f 44 d8             	cmove  %eax,%ebx
}
  8004fa:	89 d8                	mov    %ebx,%eax
  8004fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004ff:	5b                   	pop    %ebx
  800500:	5e                   	pop    %esi
  800501:	5f                   	pop    %edi
  800502:	5d                   	pop    %ebp
  800503:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800504:	83 ec 08             	sub    $0x8,%esp
  800507:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80050a:	50                   	push   %eax
  80050b:	ff 36                	pushl  (%esi)
  80050d:	e8 4e ff ff ff       	call   800460 <dev_lookup>
  800512:	89 c3                	mov    %eax,%ebx
  800514:	83 c4 10             	add    $0x10,%esp
  800517:	85 c0                	test   %eax,%eax
  800519:	78 1a                	js     800535 <fd_close+0x7b>
		if (dev->dev_close)
  80051b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80051e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800521:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800526:	85 c0                	test   %eax,%eax
  800528:	74 0b                	je     800535 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80052a:	83 ec 0c             	sub    $0xc,%esp
  80052d:	56                   	push   %esi
  80052e:	ff d0                	call   *%eax
  800530:	89 c3                	mov    %eax,%ebx
  800532:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	56                   	push   %esi
  800539:	6a 00                	push   $0x0
  80053b:	e8 c3 fc ff ff       	call   800203 <sys_page_unmap>
	return r;
  800540:	83 c4 10             	add    $0x10,%esp
  800543:	eb b5                	jmp    8004fa <fd_close+0x40>

00800545 <close>:

int
close(int fdnum)
{
  800545:	f3 0f 1e fb          	endbr32 
  800549:	55                   	push   %ebp
  80054a:	89 e5                	mov    %esp,%ebp
  80054c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80054f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800552:	50                   	push   %eax
  800553:	ff 75 08             	pushl  0x8(%ebp)
  800556:	e8 b1 fe ff ff       	call   80040c <fd_lookup>
  80055b:	83 c4 10             	add    $0x10,%esp
  80055e:	85 c0                	test   %eax,%eax
  800560:	79 02                	jns    800564 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800562:	c9                   	leave  
  800563:	c3                   	ret    
		return fd_close(fd, 1);
  800564:	83 ec 08             	sub    $0x8,%esp
  800567:	6a 01                	push   $0x1
  800569:	ff 75 f4             	pushl  -0xc(%ebp)
  80056c:	e8 49 ff ff ff       	call   8004ba <fd_close>
  800571:	83 c4 10             	add    $0x10,%esp
  800574:	eb ec                	jmp    800562 <close+0x1d>

00800576 <close_all>:

void
close_all(void)
{
  800576:	f3 0f 1e fb          	endbr32 
  80057a:	55                   	push   %ebp
  80057b:	89 e5                	mov    %esp,%ebp
  80057d:	53                   	push   %ebx
  80057e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800581:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800586:	83 ec 0c             	sub    $0xc,%esp
  800589:	53                   	push   %ebx
  80058a:	e8 b6 ff ff ff       	call   800545 <close>
	for (i = 0; i < MAXFD; i++)
  80058f:	83 c3 01             	add    $0x1,%ebx
  800592:	83 c4 10             	add    $0x10,%esp
  800595:	83 fb 20             	cmp    $0x20,%ebx
  800598:	75 ec                	jne    800586 <close_all+0x10>
}
  80059a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80059d:	c9                   	leave  
  80059e:	c3                   	ret    

0080059f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80059f:	f3 0f 1e fb          	endbr32 
  8005a3:	55                   	push   %ebp
  8005a4:	89 e5                	mov    %esp,%ebp
  8005a6:	57                   	push   %edi
  8005a7:	56                   	push   %esi
  8005a8:	53                   	push   %ebx
  8005a9:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005ac:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005af:	50                   	push   %eax
  8005b0:	ff 75 08             	pushl  0x8(%ebp)
  8005b3:	e8 54 fe ff ff       	call   80040c <fd_lookup>
  8005b8:	89 c3                	mov    %eax,%ebx
  8005ba:	83 c4 10             	add    $0x10,%esp
  8005bd:	85 c0                	test   %eax,%eax
  8005bf:	0f 88 81 00 00 00    	js     800646 <dup+0xa7>
		return r;
	close(newfdnum);
  8005c5:	83 ec 0c             	sub    $0xc,%esp
  8005c8:	ff 75 0c             	pushl  0xc(%ebp)
  8005cb:	e8 75 ff ff ff       	call   800545 <close>

	newfd = INDEX2FD(newfdnum);
  8005d0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005d3:	c1 e6 0c             	shl    $0xc,%esi
  8005d6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005dc:	83 c4 04             	add    $0x4,%esp
  8005df:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005e2:	e8 b4 fd ff ff       	call   80039b <fd2data>
  8005e7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005e9:	89 34 24             	mov    %esi,(%esp)
  8005ec:	e8 aa fd ff ff       	call   80039b <fd2data>
  8005f1:	83 c4 10             	add    $0x10,%esp
  8005f4:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005f6:	89 d8                	mov    %ebx,%eax
  8005f8:	c1 e8 16             	shr    $0x16,%eax
  8005fb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800602:	a8 01                	test   $0x1,%al
  800604:	74 11                	je     800617 <dup+0x78>
  800606:	89 d8                	mov    %ebx,%eax
  800608:	c1 e8 0c             	shr    $0xc,%eax
  80060b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800612:	f6 c2 01             	test   $0x1,%dl
  800615:	75 39                	jne    800650 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800617:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80061a:	89 d0                	mov    %edx,%eax
  80061c:	c1 e8 0c             	shr    $0xc,%eax
  80061f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800626:	83 ec 0c             	sub    $0xc,%esp
  800629:	25 07 0e 00 00       	and    $0xe07,%eax
  80062e:	50                   	push   %eax
  80062f:	56                   	push   %esi
  800630:	6a 00                	push   $0x0
  800632:	52                   	push   %edx
  800633:	6a 00                	push   $0x0
  800635:	e8 83 fb ff ff       	call   8001bd <sys_page_map>
  80063a:	89 c3                	mov    %eax,%ebx
  80063c:	83 c4 20             	add    $0x20,%esp
  80063f:	85 c0                	test   %eax,%eax
  800641:	78 31                	js     800674 <dup+0xd5>
		goto err;

	return newfdnum;
  800643:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800646:	89 d8                	mov    %ebx,%eax
  800648:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80064b:	5b                   	pop    %ebx
  80064c:	5e                   	pop    %esi
  80064d:	5f                   	pop    %edi
  80064e:	5d                   	pop    %ebp
  80064f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800650:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800657:	83 ec 0c             	sub    $0xc,%esp
  80065a:	25 07 0e 00 00       	and    $0xe07,%eax
  80065f:	50                   	push   %eax
  800660:	57                   	push   %edi
  800661:	6a 00                	push   $0x0
  800663:	53                   	push   %ebx
  800664:	6a 00                	push   $0x0
  800666:	e8 52 fb ff ff       	call   8001bd <sys_page_map>
  80066b:	89 c3                	mov    %eax,%ebx
  80066d:	83 c4 20             	add    $0x20,%esp
  800670:	85 c0                	test   %eax,%eax
  800672:	79 a3                	jns    800617 <dup+0x78>
	sys_page_unmap(0, newfd);
  800674:	83 ec 08             	sub    $0x8,%esp
  800677:	56                   	push   %esi
  800678:	6a 00                	push   $0x0
  80067a:	e8 84 fb ff ff       	call   800203 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80067f:	83 c4 08             	add    $0x8,%esp
  800682:	57                   	push   %edi
  800683:	6a 00                	push   $0x0
  800685:	e8 79 fb ff ff       	call   800203 <sys_page_unmap>
	return r;
  80068a:	83 c4 10             	add    $0x10,%esp
  80068d:	eb b7                	jmp    800646 <dup+0xa7>

0080068f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80068f:	f3 0f 1e fb          	endbr32 
  800693:	55                   	push   %ebp
  800694:	89 e5                	mov    %esp,%ebp
  800696:	53                   	push   %ebx
  800697:	83 ec 1c             	sub    $0x1c,%esp
  80069a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80069d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006a0:	50                   	push   %eax
  8006a1:	53                   	push   %ebx
  8006a2:	e8 65 fd ff ff       	call   80040c <fd_lookup>
  8006a7:	83 c4 10             	add    $0x10,%esp
  8006aa:	85 c0                	test   %eax,%eax
  8006ac:	78 3f                	js     8006ed <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006ae:	83 ec 08             	sub    $0x8,%esp
  8006b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006b4:	50                   	push   %eax
  8006b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b8:	ff 30                	pushl  (%eax)
  8006ba:	e8 a1 fd ff ff       	call   800460 <dev_lookup>
  8006bf:	83 c4 10             	add    $0x10,%esp
  8006c2:	85 c0                	test   %eax,%eax
  8006c4:	78 27                	js     8006ed <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8006c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006c9:	8b 42 08             	mov    0x8(%edx),%eax
  8006cc:	83 e0 03             	and    $0x3,%eax
  8006cf:	83 f8 01             	cmp    $0x1,%eax
  8006d2:	74 1e                	je     8006f2 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006d7:	8b 40 08             	mov    0x8(%eax),%eax
  8006da:	85 c0                	test   %eax,%eax
  8006dc:	74 35                	je     800713 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006de:	83 ec 04             	sub    $0x4,%esp
  8006e1:	ff 75 10             	pushl  0x10(%ebp)
  8006e4:	ff 75 0c             	pushl  0xc(%ebp)
  8006e7:	52                   	push   %edx
  8006e8:	ff d0                	call   *%eax
  8006ea:	83 c4 10             	add    $0x10,%esp
}
  8006ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006f0:	c9                   	leave  
  8006f1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006f2:	a1 04 40 80 00       	mov    0x804004,%eax
  8006f7:	8b 40 48             	mov    0x48(%eax),%eax
  8006fa:	83 ec 04             	sub    $0x4,%esp
  8006fd:	53                   	push   %ebx
  8006fe:	50                   	push   %eax
  8006ff:	68 79 1f 80 00       	push   $0x801f79
  800704:	e8 aa 0a 00 00       	call   8011b3 <cprintf>
		return -E_INVAL;
  800709:	83 c4 10             	add    $0x10,%esp
  80070c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800711:	eb da                	jmp    8006ed <read+0x5e>
		return -E_NOT_SUPP;
  800713:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800718:	eb d3                	jmp    8006ed <read+0x5e>

0080071a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80071a:	f3 0f 1e fb          	endbr32 
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	57                   	push   %edi
  800722:	56                   	push   %esi
  800723:	53                   	push   %ebx
  800724:	83 ec 0c             	sub    $0xc,%esp
  800727:	8b 7d 08             	mov    0x8(%ebp),%edi
  80072a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80072d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800732:	eb 02                	jmp    800736 <readn+0x1c>
  800734:	01 c3                	add    %eax,%ebx
  800736:	39 f3                	cmp    %esi,%ebx
  800738:	73 21                	jae    80075b <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80073a:	83 ec 04             	sub    $0x4,%esp
  80073d:	89 f0                	mov    %esi,%eax
  80073f:	29 d8                	sub    %ebx,%eax
  800741:	50                   	push   %eax
  800742:	89 d8                	mov    %ebx,%eax
  800744:	03 45 0c             	add    0xc(%ebp),%eax
  800747:	50                   	push   %eax
  800748:	57                   	push   %edi
  800749:	e8 41 ff ff ff       	call   80068f <read>
		if (m < 0)
  80074e:	83 c4 10             	add    $0x10,%esp
  800751:	85 c0                	test   %eax,%eax
  800753:	78 04                	js     800759 <readn+0x3f>
			return m;
		if (m == 0)
  800755:	75 dd                	jne    800734 <readn+0x1a>
  800757:	eb 02                	jmp    80075b <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800759:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80075b:	89 d8                	mov    %ebx,%eax
  80075d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800760:	5b                   	pop    %ebx
  800761:	5e                   	pop    %esi
  800762:	5f                   	pop    %edi
  800763:	5d                   	pop    %ebp
  800764:	c3                   	ret    

00800765 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800765:	f3 0f 1e fb          	endbr32 
  800769:	55                   	push   %ebp
  80076a:	89 e5                	mov    %esp,%ebp
  80076c:	53                   	push   %ebx
  80076d:	83 ec 1c             	sub    $0x1c,%esp
  800770:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800773:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800776:	50                   	push   %eax
  800777:	53                   	push   %ebx
  800778:	e8 8f fc ff ff       	call   80040c <fd_lookup>
  80077d:	83 c4 10             	add    $0x10,%esp
  800780:	85 c0                	test   %eax,%eax
  800782:	78 3a                	js     8007be <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80078a:	50                   	push   %eax
  80078b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078e:	ff 30                	pushl  (%eax)
  800790:	e8 cb fc ff ff       	call   800460 <dev_lookup>
  800795:	83 c4 10             	add    $0x10,%esp
  800798:	85 c0                	test   %eax,%eax
  80079a:	78 22                	js     8007be <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80079c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80079f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007a3:	74 1e                	je     8007c3 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a8:	8b 52 0c             	mov    0xc(%edx),%edx
  8007ab:	85 d2                	test   %edx,%edx
  8007ad:	74 35                	je     8007e4 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007af:	83 ec 04             	sub    $0x4,%esp
  8007b2:	ff 75 10             	pushl  0x10(%ebp)
  8007b5:	ff 75 0c             	pushl  0xc(%ebp)
  8007b8:	50                   	push   %eax
  8007b9:	ff d2                	call   *%edx
  8007bb:	83 c4 10             	add    $0x10,%esp
}
  8007be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c1:	c9                   	leave  
  8007c2:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007c3:	a1 04 40 80 00       	mov    0x804004,%eax
  8007c8:	8b 40 48             	mov    0x48(%eax),%eax
  8007cb:	83 ec 04             	sub    $0x4,%esp
  8007ce:	53                   	push   %ebx
  8007cf:	50                   	push   %eax
  8007d0:	68 95 1f 80 00       	push   $0x801f95
  8007d5:	e8 d9 09 00 00       	call   8011b3 <cprintf>
		return -E_INVAL;
  8007da:	83 c4 10             	add    $0x10,%esp
  8007dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007e2:	eb da                	jmp    8007be <write+0x59>
		return -E_NOT_SUPP;
  8007e4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007e9:	eb d3                	jmp    8007be <write+0x59>

008007eb <seek>:

int
seek(int fdnum, off_t offset)
{
  8007eb:	f3 0f 1e fb          	endbr32 
  8007ef:	55                   	push   %ebp
  8007f0:	89 e5                	mov    %esp,%ebp
  8007f2:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007f8:	50                   	push   %eax
  8007f9:	ff 75 08             	pushl  0x8(%ebp)
  8007fc:	e8 0b fc ff ff       	call   80040c <fd_lookup>
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	85 c0                	test   %eax,%eax
  800806:	78 0e                	js     800816 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  800808:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80080e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800811:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800816:	c9                   	leave  
  800817:	c3                   	ret    

00800818 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800818:	f3 0f 1e fb          	endbr32 
  80081c:	55                   	push   %ebp
  80081d:	89 e5                	mov    %esp,%ebp
  80081f:	53                   	push   %ebx
  800820:	83 ec 1c             	sub    $0x1c,%esp
  800823:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800826:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800829:	50                   	push   %eax
  80082a:	53                   	push   %ebx
  80082b:	e8 dc fb ff ff       	call   80040c <fd_lookup>
  800830:	83 c4 10             	add    $0x10,%esp
  800833:	85 c0                	test   %eax,%eax
  800835:	78 37                	js     80086e <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800837:	83 ec 08             	sub    $0x8,%esp
  80083a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80083d:	50                   	push   %eax
  80083e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800841:	ff 30                	pushl  (%eax)
  800843:	e8 18 fc ff ff       	call   800460 <dev_lookup>
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	85 c0                	test   %eax,%eax
  80084d:	78 1f                	js     80086e <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80084f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800852:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800856:	74 1b                	je     800873 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800858:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80085b:	8b 52 18             	mov    0x18(%edx),%edx
  80085e:	85 d2                	test   %edx,%edx
  800860:	74 32                	je     800894 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	50                   	push   %eax
  800869:	ff d2                	call   *%edx
  80086b:	83 c4 10             	add    $0x10,%esp
}
  80086e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800871:	c9                   	leave  
  800872:	c3                   	ret    
			thisenv->env_id, fdnum);
  800873:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800878:	8b 40 48             	mov    0x48(%eax),%eax
  80087b:	83 ec 04             	sub    $0x4,%esp
  80087e:	53                   	push   %ebx
  80087f:	50                   	push   %eax
  800880:	68 58 1f 80 00       	push   $0x801f58
  800885:	e8 29 09 00 00       	call   8011b3 <cprintf>
		return -E_INVAL;
  80088a:	83 c4 10             	add    $0x10,%esp
  80088d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800892:	eb da                	jmp    80086e <ftruncate+0x56>
		return -E_NOT_SUPP;
  800894:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800899:	eb d3                	jmp    80086e <ftruncate+0x56>

0080089b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80089b:	f3 0f 1e fb          	endbr32 
  80089f:	55                   	push   %ebp
  8008a0:	89 e5                	mov    %esp,%ebp
  8008a2:	53                   	push   %ebx
  8008a3:	83 ec 1c             	sub    $0x1c,%esp
  8008a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008ac:	50                   	push   %eax
  8008ad:	ff 75 08             	pushl  0x8(%ebp)
  8008b0:	e8 57 fb ff ff       	call   80040c <fd_lookup>
  8008b5:	83 c4 10             	add    $0x10,%esp
  8008b8:	85 c0                	test   %eax,%eax
  8008ba:	78 4b                	js     800907 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008bc:	83 ec 08             	sub    $0x8,%esp
  8008bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008c2:	50                   	push   %eax
  8008c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c6:	ff 30                	pushl  (%eax)
  8008c8:	e8 93 fb ff ff       	call   800460 <dev_lookup>
  8008cd:	83 c4 10             	add    $0x10,%esp
  8008d0:	85 c0                	test   %eax,%eax
  8008d2:	78 33                	js     800907 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8008d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d7:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8008db:	74 2f                	je     80090c <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8008dd:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8008e0:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8008e7:	00 00 00 
	stat->st_isdir = 0;
  8008ea:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008f1:	00 00 00 
	stat->st_dev = dev;
  8008f4:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008fa:	83 ec 08             	sub    $0x8,%esp
  8008fd:	53                   	push   %ebx
  8008fe:	ff 75 f0             	pushl  -0x10(%ebp)
  800901:	ff 50 14             	call   *0x14(%eax)
  800904:	83 c4 10             	add    $0x10,%esp
}
  800907:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80090a:	c9                   	leave  
  80090b:	c3                   	ret    
		return -E_NOT_SUPP;
  80090c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800911:	eb f4                	jmp    800907 <fstat+0x6c>

00800913 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800913:	f3 0f 1e fb          	endbr32 
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	56                   	push   %esi
  80091b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80091c:	83 ec 08             	sub    $0x8,%esp
  80091f:	6a 00                	push   $0x0
  800921:	ff 75 08             	pushl  0x8(%ebp)
  800924:	e8 fb 01 00 00       	call   800b24 <open>
  800929:	89 c3                	mov    %eax,%ebx
  80092b:	83 c4 10             	add    $0x10,%esp
  80092e:	85 c0                	test   %eax,%eax
  800930:	78 1b                	js     80094d <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  800932:	83 ec 08             	sub    $0x8,%esp
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	50                   	push   %eax
  800939:	e8 5d ff ff ff       	call   80089b <fstat>
  80093e:	89 c6                	mov    %eax,%esi
	close(fd);
  800940:	89 1c 24             	mov    %ebx,(%esp)
  800943:	e8 fd fb ff ff       	call   800545 <close>
	return r;
  800948:	83 c4 10             	add    $0x10,%esp
  80094b:	89 f3                	mov    %esi,%ebx
}
  80094d:	89 d8                	mov    %ebx,%eax
  80094f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800952:	5b                   	pop    %ebx
  800953:	5e                   	pop    %esi
  800954:	5d                   	pop    %ebp
  800955:	c3                   	ret    

00800956 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	56                   	push   %esi
  80095a:	53                   	push   %ebx
  80095b:	89 c6                	mov    %eax,%esi
  80095d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80095f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800966:	74 27                	je     80098f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800968:	6a 07                	push   $0x7
  80096a:	68 00 50 80 00       	push   $0x805000
  80096f:	56                   	push   %esi
  800970:	ff 35 00 40 80 00    	pushl  0x804000
  800976:	e8 39 12 00 00       	call   801bb4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80097b:	83 c4 0c             	add    $0xc,%esp
  80097e:	6a 00                	push   $0x0
  800980:	53                   	push   %ebx
  800981:	6a 00                	push   $0x0
  800983:	e8 a7 11 00 00       	call   801b2f <ipc_recv>
}
  800988:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80098b:	5b                   	pop    %ebx
  80098c:	5e                   	pop    %esi
  80098d:	5d                   	pop    %ebp
  80098e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80098f:	83 ec 0c             	sub    $0xc,%esp
  800992:	6a 01                	push   $0x1
  800994:	e8 73 12 00 00       	call   801c0c <ipc_find_env>
  800999:	a3 00 40 80 00       	mov    %eax,0x804000
  80099e:	83 c4 10             	add    $0x10,%esp
  8009a1:	eb c5                	jmp    800968 <fsipc+0x12>

008009a3 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009a3:	f3 0f 1e fb          	endbr32 
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8009b3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009bb:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c5:	b8 02 00 00 00       	mov    $0x2,%eax
  8009ca:	e8 87 ff ff ff       	call   800956 <fsipc>
}
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <devfile_flush>:
{
  8009d1:	f3 0f 1e fb          	endbr32 
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	8b 40 0c             	mov    0xc(%eax),%eax
  8009e1:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8009e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009eb:	b8 06 00 00 00       	mov    $0x6,%eax
  8009f0:	e8 61 ff ff ff       	call   800956 <fsipc>
}
  8009f5:	c9                   	leave  
  8009f6:	c3                   	ret    

008009f7 <devfile_stat>:
{
  8009f7:	f3 0f 1e fb          	endbr32 
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	53                   	push   %ebx
  8009ff:	83 ec 04             	sub    $0x4,%esp
  800a02:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	8b 40 0c             	mov    0xc(%eax),%eax
  800a0b:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a10:	ba 00 00 00 00       	mov    $0x0,%edx
  800a15:	b8 05 00 00 00       	mov    $0x5,%eax
  800a1a:	e8 37 ff ff ff       	call   800956 <fsipc>
  800a1f:	85 c0                	test   %eax,%eax
  800a21:	78 2c                	js     800a4f <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	68 00 50 80 00       	push   $0x805000
  800a2b:	53                   	push   %ebx
  800a2c:	e8 8c 0d 00 00       	call   8017bd <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a31:	a1 80 50 80 00       	mov    0x805080,%eax
  800a36:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800a3c:	a1 84 50 80 00       	mov    0x805084,%eax
  800a41:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a47:	83 c4 10             	add    $0x10,%esp
  800a4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a52:	c9                   	leave  
  800a53:	c3                   	ret    

00800a54 <devfile_write>:
{
  800a54:	f3 0f 1e fb          	endbr32 
  800a58:	55                   	push   %ebp
  800a59:	89 e5                	mov    %esp,%ebp
  800a5b:	83 ec 0c             	sub    $0xc,%esp
  800a5e:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a61:	8b 55 08             	mov    0x8(%ebp),%edx
  800a64:	8b 52 0c             	mov    0xc(%edx),%edx
  800a67:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  800a6d:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800a72:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800a77:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  800a7a:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a7f:	50                   	push   %eax
  800a80:	ff 75 0c             	pushl  0xc(%ebp)
  800a83:	68 08 50 80 00       	push   $0x805008
  800a88:	e8 e6 0e 00 00       	call   801973 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800a8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a92:	b8 04 00 00 00       	mov    $0x4,%eax
  800a97:	e8 ba fe ff ff       	call   800956 <fsipc>
}
  800a9c:	c9                   	leave  
  800a9d:	c3                   	ret    

00800a9e <devfile_read>:
{
  800a9e:	f3 0f 1e fb          	endbr32 
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	56                   	push   %esi
  800aa6:	53                   	push   %ebx
  800aa7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800aad:	8b 40 0c             	mov    0xc(%eax),%eax
  800ab0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800ab5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800abb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac0:	b8 03 00 00 00       	mov    $0x3,%eax
  800ac5:	e8 8c fe ff ff       	call   800956 <fsipc>
  800aca:	89 c3                	mov    %eax,%ebx
  800acc:	85 c0                	test   %eax,%eax
  800ace:	78 1f                	js     800aef <devfile_read+0x51>
	assert(r <= n);
  800ad0:	39 f0                	cmp    %esi,%eax
  800ad2:	77 24                	ja     800af8 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800ad4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ad9:	7f 33                	jg     800b0e <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800adb:	83 ec 04             	sub    $0x4,%esp
  800ade:	50                   	push   %eax
  800adf:	68 00 50 80 00       	push   $0x805000
  800ae4:	ff 75 0c             	pushl  0xc(%ebp)
  800ae7:	e8 87 0e 00 00       	call   801973 <memmove>
	return r;
  800aec:	83 c4 10             	add    $0x10,%esp
}
  800aef:	89 d8                	mov    %ebx,%eax
  800af1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800af4:	5b                   	pop    %ebx
  800af5:	5e                   	pop    %esi
  800af6:	5d                   	pop    %ebp
  800af7:	c3                   	ret    
	assert(r <= n);
  800af8:	68 c4 1f 80 00       	push   $0x801fc4
  800afd:	68 cb 1f 80 00       	push   $0x801fcb
  800b02:	6a 7c                	push   $0x7c
  800b04:	68 e0 1f 80 00       	push   $0x801fe0
  800b09:	e8 be 05 00 00       	call   8010cc <_panic>
	assert(r <= PGSIZE);
  800b0e:	68 eb 1f 80 00       	push   $0x801feb
  800b13:	68 cb 1f 80 00       	push   $0x801fcb
  800b18:	6a 7d                	push   $0x7d
  800b1a:	68 e0 1f 80 00       	push   $0x801fe0
  800b1f:	e8 a8 05 00 00       	call   8010cc <_panic>

00800b24 <open>:
{
  800b24:	f3 0f 1e fb          	endbr32 
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	56                   	push   %esi
  800b2c:	53                   	push   %ebx
  800b2d:	83 ec 1c             	sub    $0x1c,%esp
  800b30:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b33:	56                   	push   %esi
  800b34:	e8 41 0c 00 00       	call   80177a <strlen>
  800b39:	83 c4 10             	add    $0x10,%esp
  800b3c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b41:	7f 6c                	jg     800baf <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b43:	83 ec 0c             	sub    $0xc,%esp
  800b46:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b49:	50                   	push   %eax
  800b4a:	e8 67 f8 ff ff       	call   8003b6 <fd_alloc>
  800b4f:	89 c3                	mov    %eax,%ebx
  800b51:	83 c4 10             	add    $0x10,%esp
  800b54:	85 c0                	test   %eax,%eax
  800b56:	78 3c                	js     800b94 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	56                   	push   %esi
  800b5c:	68 00 50 80 00       	push   $0x805000
  800b61:	e8 57 0c 00 00       	call   8017bd <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b69:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b71:	b8 01 00 00 00       	mov    $0x1,%eax
  800b76:	e8 db fd ff ff       	call   800956 <fsipc>
  800b7b:	89 c3                	mov    %eax,%ebx
  800b7d:	83 c4 10             	add    $0x10,%esp
  800b80:	85 c0                	test   %eax,%eax
  800b82:	78 19                	js     800b9d <open+0x79>
	return fd2num(fd);
  800b84:	83 ec 0c             	sub    $0xc,%esp
  800b87:	ff 75 f4             	pushl  -0xc(%ebp)
  800b8a:	e8 f8 f7 ff ff       	call   800387 <fd2num>
  800b8f:	89 c3                	mov    %eax,%ebx
  800b91:	83 c4 10             	add    $0x10,%esp
}
  800b94:	89 d8                	mov    %ebx,%eax
  800b96:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b99:	5b                   	pop    %ebx
  800b9a:	5e                   	pop    %esi
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    
		fd_close(fd, 0);
  800b9d:	83 ec 08             	sub    $0x8,%esp
  800ba0:	6a 00                	push   $0x0
  800ba2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba5:	e8 10 f9 ff ff       	call   8004ba <fd_close>
		return r;
  800baa:	83 c4 10             	add    $0x10,%esp
  800bad:	eb e5                	jmp    800b94 <open+0x70>
		return -E_BAD_PATH;
  800baf:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800bb4:	eb de                	jmp    800b94 <open+0x70>

00800bb6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800bb6:	f3 0f 1e fb          	endbr32 
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800bc0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc5:	b8 08 00 00 00       	mov    $0x8,%eax
  800bca:	e8 87 fd ff ff       	call   800956 <fsipc>
}
  800bcf:	c9                   	leave  
  800bd0:	c3                   	ret    

00800bd1 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800bd1:	f3 0f 1e fb          	endbr32 
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	56                   	push   %esi
  800bd9:	53                   	push   %ebx
  800bda:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800bdd:	83 ec 0c             	sub    $0xc,%esp
  800be0:	ff 75 08             	pushl  0x8(%ebp)
  800be3:	e8 b3 f7 ff ff       	call   80039b <fd2data>
  800be8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bea:	83 c4 08             	add    $0x8,%esp
  800bed:	68 f7 1f 80 00       	push   $0x801ff7
  800bf2:	53                   	push   %ebx
  800bf3:	e8 c5 0b 00 00       	call   8017bd <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bf8:	8b 46 04             	mov    0x4(%esi),%eax
  800bfb:	2b 06                	sub    (%esi),%eax
  800bfd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800c03:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800c0a:	00 00 00 
	stat->st_dev = &devpipe;
  800c0d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c14:	30 80 00 
	return 0;
}
  800c17:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c1f:	5b                   	pop    %ebx
  800c20:	5e                   	pop    %esi
  800c21:	5d                   	pop    %ebp
  800c22:	c3                   	ret    

00800c23 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c23:	f3 0f 1e fb          	endbr32 
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	53                   	push   %ebx
  800c2b:	83 ec 0c             	sub    $0xc,%esp
  800c2e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c31:	53                   	push   %ebx
  800c32:	6a 00                	push   $0x0
  800c34:	e8 ca f5 ff ff       	call   800203 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c39:	89 1c 24             	mov    %ebx,(%esp)
  800c3c:	e8 5a f7 ff ff       	call   80039b <fd2data>
  800c41:	83 c4 08             	add    $0x8,%esp
  800c44:	50                   	push   %eax
  800c45:	6a 00                	push   $0x0
  800c47:	e8 b7 f5 ff ff       	call   800203 <sys_page_unmap>
}
  800c4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c4f:	c9                   	leave  
  800c50:	c3                   	ret    

00800c51 <_pipeisclosed>:
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	57                   	push   %edi
  800c55:	56                   	push   %esi
  800c56:	53                   	push   %ebx
  800c57:	83 ec 1c             	sub    $0x1c,%esp
  800c5a:	89 c7                	mov    %eax,%edi
  800c5c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c5e:	a1 04 40 80 00       	mov    0x804004,%eax
  800c63:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c66:	83 ec 0c             	sub    $0xc,%esp
  800c69:	57                   	push   %edi
  800c6a:	e8 da 0f 00 00       	call   801c49 <pageref>
  800c6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c72:	89 34 24             	mov    %esi,(%esp)
  800c75:	e8 cf 0f 00 00       	call   801c49 <pageref>
		nn = thisenv->env_runs;
  800c7a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800c80:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c83:	83 c4 10             	add    $0x10,%esp
  800c86:	39 cb                	cmp    %ecx,%ebx
  800c88:	74 1b                	je     800ca5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c8a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c8d:	75 cf                	jne    800c5e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c8f:	8b 42 58             	mov    0x58(%edx),%eax
  800c92:	6a 01                	push   $0x1
  800c94:	50                   	push   %eax
  800c95:	53                   	push   %ebx
  800c96:	68 fe 1f 80 00       	push   $0x801ffe
  800c9b:	e8 13 05 00 00       	call   8011b3 <cprintf>
  800ca0:	83 c4 10             	add    $0x10,%esp
  800ca3:	eb b9                	jmp    800c5e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800ca5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800ca8:	0f 94 c0             	sete   %al
  800cab:	0f b6 c0             	movzbl %al,%eax
}
  800cae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb1:	5b                   	pop    %ebx
  800cb2:	5e                   	pop    %esi
  800cb3:	5f                   	pop    %edi
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    

00800cb6 <devpipe_write>:
{
  800cb6:	f3 0f 1e fb          	endbr32 
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	57                   	push   %edi
  800cbe:	56                   	push   %esi
  800cbf:	53                   	push   %ebx
  800cc0:	83 ec 28             	sub    $0x28,%esp
  800cc3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800cc6:	56                   	push   %esi
  800cc7:	e8 cf f6 ff ff       	call   80039b <fd2data>
  800ccc:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800cce:	83 c4 10             	add    $0x10,%esp
  800cd1:	bf 00 00 00 00       	mov    $0x0,%edi
  800cd6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800cd9:	74 4f                	je     800d2a <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800cdb:	8b 43 04             	mov    0x4(%ebx),%eax
  800cde:	8b 0b                	mov    (%ebx),%ecx
  800ce0:	8d 51 20             	lea    0x20(%ecx),%edx
  800ce3:	39 d0                	cmp    %edx,%eax
  800ce5:	72 14                	jb     800cfb <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  800ce7:	89 da                	mov    %ebx,%edx
  800ce9:	89 f0                	mov    %esi,%eax
  800ceb:	e8 61 ff ff ff       	call   800c51 <_pipeisclosed>
  800cf0:	85 c0                	test   %eax,%eax
  800cf2:	75 3b                	jne    800d2f <devpipe_write+0x79>
			sys_yield();
  800cf4:	e8 5a f4 ff ff       	call   800153 <sys_yield>
  800cf9:	eb e0                	jmp    800cdb <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfe:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800d02:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800d05:	89 c2                	mov    %eax,%edx
  800d07:	c1 fa 1f             	sar    $0x1f,%edx
  800d0a:	89 d1                	mov    %edx,%ecx
  800d0c:	c1 e9 1b             	shr    $0x1b,%ecx
  800d0f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800d12:	83 e2 1f             	and    $0x1f,%edx
  800d15:	29 ca                	sub    %ecx,%edx
  800d17:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800d1b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800d1f:	83 c0 01             	add    $0x1,%eax
  800d22:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d25:	83 c7 01             	add    $0x1,%edi
  800d28:	eb ac                	jmp    800cd6 <devpipe_write+0x20>
	return i;
  800d2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2d:	eb 05                	jmp    800d34 <devpipe_write+0x7e>
				return 0;
  800d2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d37:	5b                   	pop    %ebx
  800d38:	5e                   	pop    %esi
  800d39:	5f                   	pop    %edi
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    

00800d3c <devpipe_read>:
{
  800d3c:	f3 0f 1e fb          	endbr32 
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	57                   	push   %edi
  800d44:	56                   	push   %esi
  800d45:	53                   	push   %ebx
  800d46:	83 ec 18             	sub    $0x18,%esp
  800d49:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d4c:	57                   	push   %edi
  800d4d:	e8 49 f6 ff ff       	call   80039b <fd2data>
  800d52:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d54:	83 c4 10             	add    $0x10,%esp
  800d57:	be 00 00 00 00       	mov    $0x0,%esi
  800d5c:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d5f:	75 14                	jne    800d75 <devpipe_read+0x39>
	return i;
  800d61:	8b 45 10             	mov    0x10(%ebp),%eax
  800d64:	eb 02                	jmp    800d68 <devpipe_read+0x2c>
				return i;
  800d66:	89 f0                	mov    %esi,%eax
}
  800d68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6b:	5b                   	pop    %ebx
  800d6c:	5e                   	pop    %esi
  800d6d:	5f                   	pop    %edi
  800d6e:	5d                   	pop    %ebp
  800d6f:	c3                   	ret    
			sys_yield();
  800d70:	e8 de f3 ff ff       	call   800153 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d75:	8b 03                	mov    (%ebx),%eax
  800d77:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d7a:	75 18                	jne    800d94 <devpipe_read+0x58>
			if (i > 0)
  800d7c:	85 f6                	test   %esi,%esi
  800d7e:	75 e6                	jne    800d66 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  800d80:	89 da                	mov    %ebx,%edx
  800d82:	89 f8                	mov    %edi,%eax
  800d84:	e8 c8 fe ff ff       	call   800c51 <_pipeisclosed>
  800d89:	85 c0                	test   %eax,%eax
  800d8b:	74 e3                	je     800d70 <devpipe_read+0x34>
				return 0;
  800d8d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d92:	eb d4                	jmp    800d68 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d94:	99                   	cltd   
  800d95:	c1 ea 1b             	shr    $0x1b,%edx
  800d98:	01 d0                	add    %edx,%eax
  800d9a:	83 e0 1f             	and    $0x1f,%eax
  800d9d:	29 d0                	sub    %edx,%eax
  800d9f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800da4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da7:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800daa:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800dad:	83 c6 01             	add    $0x1,%esi
  800db0:	eb aa                	jmp    800d5c <devpipe_read+0x20>

00800db2 <pipe>:
{
  800db2:	f3 0f 1e fb          	endbr32 
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	56                   	push   %esi
  800dba:	53                   	push   %ebx
  800dbb:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800dbe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dc1:	50                   	push   %eax
  800dc2:	e8 ef f5 ff ff       	call   8003b6 <fd_alloc>
  800dc7:	89 c3                	mov    %eax,%ebx
  800dc9:	83 c4 10             	add    $0x10,%esp
  800dcc:	85 c0                	test   %eax,%eax
  800dce:	0f 88 23 01 00 00    	js     800ef7 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dd4:	83 ec 04             	sub    $0x4,%esp
  800dd7:	68 07 04 00 00       	push   $0x407
  800ddc:	ff 75 f4             	pushl  -0xc(%ebp)
  800ddf:	6a 00                	push   $0x0
  800de1:	e8 90 f3 ff ff       	call   800176 <sys_page_alloc>
  800de6:	89 c3                	mov    %eax,%ebx
  800de8:	83 c4 10             	add    $0x10,%esp
  800deb:	85 c0                	test   %eax,%eax
  800ded:	0f 88 04 01 00 00    	js     800ef7 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  800df3:	83 ec 0c             	sub    $0xc,%esp
  800df6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800df9:	50                   	push   %eax
  800dfa:	e8 b7 f5 ff ff       	call   8003b6 <fd_alloc>
  800dff:	89 c3                	mov    %eax,%ebx
  800e01:	83 c4 10             	add    $0x10,%esp
  800e04:	85 c0                	test   %eax,%eax
  800e06:	0f 88 db 00 00 00    	js     800ee7 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e0c:	83 ec 04             	sub    $0x4,%esp
  800e0f:	68 07 04 00 00       	push   $0x407
  800e14:	ff 75 f0             	pushl  -0x10(%ebp)
  800e17:	6a 00                	push   $0x0
  800e19:	e8 58 f3 ff ff       	call   800176 <sys_page_alloc>
  800e1e:	89 c3                	mov    %eax,%ebx
  800e20:	83 c4 10             	add    $0x10,%esp
  800e23:	85 c0                	test   %eax,%eax
  800e25:	0f 88 bc 00 00 00    	js     800ee7 <pipe+0x135>
	va = fd2data(fd0);
  800e2b:	83 ec 0c             	sub    $0xc,%esp
  800e2e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e31:	e8 65 f5 ff ff       	call   80039b <fd2data>
  800e36:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e38:	83 c4 0c             	add    $0xc,%esp
  800e3b:	68 07 04 00 00       	push   $0x407
  800e40:	50                   	push   %eax
  800e41:	6a 00                	push   $0x0
  800e43:	e8 2e f3 ff ff       	call   800176 <sys_page_alloc>
  800e48:	89 c3                	mov    %eax,%ebx
  800e4a:	83 c4 10             	add    $0x10,%esp
  800e4d:	85 c0                	test   %eax,%eax
  800e4f:	0f 88 82 00 00 00    	js     800ed7 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e55:	83 ec 0c             	sub    $0xc,%esp
  800e58:	ff 75 f0             	pushl  -0x10(%ebp)
  800e5b:	e8 3b f5 ff ff       	call   80039b <fd2data>
  800e60:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e67:	50                   	push   %eax
  800e68:	6a 00                	push   $0x0
  800e6a:	56                   	push   %esi
  800e6b:	6a 00                	push   $0x0
  800e6d:	e8 4b f3 ff ff       	call   8001bd <sys_page_map>
  800e72:	89 c3                	mov    %eax,%ebx
  800e74:	83 c4 20             	add    $0x20,%esp
  800e77:	85 c0                	test   %eax,%eax
  800e79:	78 4e                	js     800ec9 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  800e7b:	a1 20 30 80 00       	mov    0x803020,%eax
  800e80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e83:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e88:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e8f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e92:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e97:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e9e:	83 ec 0c             	sub    $0xc,%esp
  800ea1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea4:	e8 de f4 ff ff       	call   800387 <fd2num>
  800ea9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eac:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800eae:	83 c4 04             	add    $0x4,%esp
  800eb1:	ff 75 f0             	pushl  -0x10(%ebp)
  800eb4:	e8 ce f4 ff ff       	call   800387 <fd2num>
  800eb9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ebc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800ebf:	83 c4 10             	add    $0x10,%esp
  800ec2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec7:	eb 2e                	jmp    800ef7 <pipe+0x145>
	sys_page_unmap(0, va);
  800ec9:	83 ec 08             	sub    $0x8,%esp
  800ecc:	56                   	push   %esi
  800ecd:	6a 00                	push   $0x0
  800ecf:	e8 2f f3 ff ff       	call   800203 <sys_page_unmap>
  800ed4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800ed7:	83 ec 08             	sub    $0x8,%esp
  800eda:	ff 75 f0             	pushl  -0x10(%ebp)
  800edd:	6a 00                	push   $0x0
  800edf:	e8 1f f3 ff ff       	call   800203 <sys_page_unmap>
  800ee4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800ee7:	83 ec 08             	sub    $0x8,%esp
  800eea:	ff 75 f4             	pushl  -0xc(%ebp)
  800eed:	6a 00                	push   $0x0
  800eef:	e8 0f f3 ff ff       	call   800203 <sys_page_unmap>
  800ef4:	83 c4 10             	add    $0x10,%esp
}
  800ef7:	89 d8                	mov    %ebx,%eax
  800ef9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800efc:	5b                   	pop    %ebx
  800efd:	5e                   	pop    %esi
  800efe:	5d                   	pop    %ebp
  800eff:	c3                   	ret    

00800f00 <pipeisclosed>:
{
  800f00:	f3 0f 1e fb          	endbr32 
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f0d:	50                   	push   %eax
  800f0e:	ff 75 08             	pushl  0x8(%ebp)
  800f11:	e8 f6 f4 ff ff       	call   80040c <fd_lookup>
  800f16:	83 c4 10             	add    $0x10,%esp
  800f19:	85 c0                	test   %eax,%eax
  800f1b:	78 18                	js     800f35 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  800f1d:	83 ec 0c             	sub    $0xc,%esp
  800f20:	ff 75 f4             	pushl  -0xc(%ebp)
  800f23:	e8 73 f4 ff ff       	call   80039b <fd2data>
  800f28:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  800f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f2d:	e8 1f fd ff ff       	call   800c51 <_pipeisclosed>
  800f32:	83 c4 10             	add    $0x10,%esp
}
  800f35:	c9                   	leave  
  800f36:	c3                   	ret    

00800f37 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800f37:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  800f3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f40:	c3                   	ret    

00800f41 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f41:	f3 0f 1e fb          	endbr32 
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800f4b:	68 16 20 80 00       	push   $0x802016
  800f50:	ff 75 0c             	pushl  0xc(%ebp)
  800f53:	e8 65 08 00 00       	call   8017bd <strcpy>
	return 0;
}
  800f58:	b8 00 00 00 00       	mov    $0x0,%eax
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <devcons_write>:
{
  800f5f:	f3 0f 1e fb          	endbr32 
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	57                   	push   %edi
  800f67:	56                   	push   %esi
  800f68:	53                   	push   %ebx
  800f69:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800f6f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800f74:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800f7a:	3b 75 10             	cmp    0x10(%ebp),%esi
  800f7d:	73 31                	jae    800fb0 <devcons_write+0x51>
		m = n - tot;
  800f7f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f82:	29 f3                	sub    %esi,%ebx
  800f84:	83 fb 7f             	cmp    $0x7f,%ebx
  800f87:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800f8c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800f8f:	83 ec 04             	sub    $0x4,%esp
  800f92:	53                   	push   %ebx
  800f93:	89 f0                	mov    %esi,%eax
  800f95:	03 45 0c             	add    0xc(%ebp),%eax
  800f98:	50                   	push   %eax
  800f99:	57                   	push   %edi
  800f9a:	e8 d4 09 00 00       	call   801973 <memmove>
		sys_cputs(buf, m);
  800f9f:	83 c4 08             	add    $0x8,%esp
  800fa2:	53                   	push   %ebx
  800fa3:	57                   	push   %edi
  800fa4:	e8 fd f0 ff ff       	call   8000a6 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800fa9:	01 de                	add    %ebx,%esi
  800fab:	83 c4 10             	add    $0x10,%esp
  800fae:	eb ca                	jmp    800f7a <devcons_write+0x1b>
}
  800fb0:	89 f0                	mov    %esi,%eax
  800fb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb5:	5b                   	pop    %ebx
  800fb6:	5e                   	pop    %esi
  800fb7:	5f                   	pop    %edi
  800fb8:	5d                   	pop    %ebp
  800fb9:	c3                   	ret    

00800fba <devcons_read>:
{
  800fba:	f3 0f 1e fb          	endbr32 
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	83 ec 08             	sub    $0x8,%esp
  800fc4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800fc9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcd:	74 21                	je     800ff0 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800fcf:	e8 f4 f0 ff ff       	call   8000c8 <sys_cgetc>
  800fd4:	85 c0                	test   %eax,%eax
  800fd6:	75 07                	jne    800fdf <devcons_read+0x25>
		sys_yield();
  800fd8:	e8 76 f1 ff ff       	call   800153 <sys_yield>
  800fdd:	eb f0                	jmp    800fcf <devcons_read+0x15>
	if (c < 0)
  800fdf:	78 0f                	js     800ff0 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  800fe1:	83 f8 04             	cmp    $0x4,%eax
  800fe4:	74 0c                	je     800ff2 <devcons_read+0x38>
	*(char*)vbuf = c;
  800fe6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe9:	88 02                	mov    %al,(%edx)
	return 1;
  800feb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800ff0:	c9                   	leave  
  800ff1:	c3                   	ret    
		return 0;
  800ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff7:	eb f7                	jmp    800ff0 <devcons_read+0x36>

00800ff9 <cputchar>:
{
  800ff9:	f3 0f 1e fb          	endbr32 
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801009:	6a 01                	push   $0x1
  80100b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80100e:	50                   	push   %eax
  80100f:	e8 92 f0 ff ff       	call   8000a6 <sys_cputs>
}
  801014:	83 c4 10             	add    $0x10,%esp
  801017:	c9                   	leave  
  801018:	c3                   	ret    

00801019 <getchar>:
{
  801019:	f3 0f 1e fb          	endbr32 
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801023:	6a 01                	push   $0x1
  801025:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801028:	50                   	push   %eax
  801029:	6a 00                	push   $0x0
  80102b:	e8 5f f6 ff ff       	call   80068f <read>
	if (r < 0)
  801030:	83 c4 10             	add    $0x10,%esp
  801033:	85 c0                	test   %eax,%eax
  801035:	78 06                	js     80103d <getchar+0x24>
	if (r < 1)
  801037:	74 06                	je     80103f <getchar+0x26>
	return c;
  801039:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80103d:	c9                   	leave  
  80103e:	c3                   	ret    
		return -E_EOF;
  80103f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801044:	eb f7                	jmp    80103d <getchar+0x24>

00801046 <iscons>:
{
  801046:	f3 0f 1e fb          	endbr32 
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801050:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801053:	50                   	push   %eax
  801054:	ff 75 08             	pushl  0x8(%ebp)
  801057:	e8 b0 f3 ff ff       	call   80040c <fd_lookup>
  80105c:	83 c4 10             	add    $0x10,%esp
  80105f:	85 c0                	test   %eax,%eax
  801061:	78 11                	js     801074 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801066:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80106c:	39 10                	cmp    %edx,(%eax)
  80106e:	0f 94 c0             	sete   %al
  801071:	0f b6 c0             	movzbl %al,%eax
}
  801074:	c9                   	leave  
  801075:	c3                   	ret    

00801076 <opencons>:
{
  801076:	f3 0f 1e fb          	endbr32 
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801080:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801083:	50                   	push   %eax
  801084:	e8 2d f3 ff ff       	call   8003b6 <fd_alloc>
  801089:	83 c4 10             	add    $0x10,%esp
  80108c:	85 c0                	test   %eax,%eax
  80108e:	78 3a                	js     8010ca <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801090:	83 ec 04             	sub    $0x4,%esp
  801093:	68 07 04 00 00       	push   $0x407
  801098:	ff 75 f4             	pushl  -0xc(%ebp)
  80109b:	6a 00                	push   $0x0
  80109d:	e8 d4 f0 ff ff       	call   800176 <sys_page_alloc>
  8010a2:	83 c4 10             	add    $0x10,%esp
  8010a5:	85 c0                	test   %eax,%eax
  8010a7:	78 21                	js     8010ca <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8010a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ac:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010b2:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8010b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8010be:	83 ec 0c             	sub    $0xc,%esp
  8010c1:	50                   	push   %eax
  8010c2:	e8 c0 f2 ff ff       	call   800387 <fd2num>
  8010c7:	83 c4 10             	add    $0x10,%esp
}
  8010ca:	c9                   	leave  
  8010cb:	c3                   	ret    

008010cc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8010cc:	f3 0f 1e fb          	endbr32 
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	56                   	push   %esi
  8010d4:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8010d5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8010d8:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8010de:	e8 4d f0 ff ff       	call   800130 <sys_getenvid>
  8010e3:	83 ec 0c             	sub    $0xc,%esp
  8010e6:	ff 75 0c             	pushl  0xc(%ebp)
  8010e9:	ff 75 08             	pushl  0x8(%ebp)
  8010ec:	56                   	push   %esi
  8010ed:	50                   	push   %eax
  8010ee:	68 24 20 80 00       	push   $0x802024
  8010f3:	e8 bb 00 00 00       	call   8011b3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8010f8:	83 c4 18             	add    $0x18,%esp
  8010fb:	53                   	push   %ebx
  8010fc:	ff 75 10             	pushl  0x10(%ebp)
  8010ff:	e8 5a 00 00 00       	call   80115e <vcprintf>
	cprintf("\n");
  801104:	c7 04 24 58 23 80 00 	movl   $0x802358,(%esp)
  80110b:	e8 a3 00 00 00       	call   8011b3 <cprintf>
  801110:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801113:	cc                   	int3   
  801114:	eb fd                	jmp    801113 <_panic+0x47>

00801116 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801116:	f3 0f 1e fb          	endbr32 
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	53                   	push   %ebx
  80111e:	83 ec 04             	sub    $0x4,%esp
  801121:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801124:	8b 13                	mov    (%ebx),%edx
  801126:	8d 42 01             	lea    0x1(%edx),%eax
  801129:	89 03                	mov    %eax,(%ebx)
  80112b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80112e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801132:	3d ff 00 00 00       	cmp    $0xff,%eax
  801137:	74 09                	je     801142 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801139:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80113d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801140:	c9                   	leave  
  801141:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801142:	83 ec 08             	sub    $0x8,%esp
  801145:	68 ff 00 00 00       	push   $0xff
  80114a:	8d 43 08             	lea    0x8(%ebx),%eax
  80114d:	50                   	push   %eax
  80114e:	e8 53 ef ff ff       	call   8000a6 <sys_cputs>
		b->idx = 0;
  801153:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801159:	83 c4 10             	add    $0x10,%esp
  80115c:	eb db                	jmp    801139 <putch+0x23>

0080115e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80115e:	f3 0f 1e fb          	endbr32 
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80116b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801172:	00 00 00 
	b.cnt = 0;
  801175:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80117c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80117f:	ff 75 0c             	pushl  0xc(%ebp)
  801182:	ff 75 08             	pushl  0x8(%ebp)
  801185:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80118b:	50                   	push   %eax
  80118c:	68 16 11 80 00       	push   $0x801116
  801191:	e8 20 01 00 00       	call   8012b6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801196:	83 c4 08             	add    $0x8,%esp
  801199:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80119f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8011a5:	50                   	push   %eax
  8011a6:	e8 fb ee ff ff       	call   8000a6 <sys_cputs>

	return b.cnt;
}
  8011ab:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8011b1:	c9                   	leave  
  8011b2:	c3                   	ret    

008011b3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8011b3:	f3 0f 1e fb          	endbr32 
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
  8011ba:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8011bd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8011c0:	50                   	push   %eax
  8011c1:	ff 75 08             	pushl  0x8(%ebp)
  8011c4:	e8 95 ff ff ff       	call   80115e <vcprintf>
	va_end(ap);

	return cnt;
}
  8011c9:	c9                   	leave  
  8011ca:	c3                   	ret    

008011cb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
  8011ce:	57                   	push   %edi
  8011cf:	56                   	push   %esi
  8011d0:	53                   	push   %ebx
  8011d1:	83 ec 1c             	sub    $0x1c,%esp
  8011d4:	89 c7                	mov    %eax,%edi
  8011d6:	89 d6                	mov    %edx,%esi
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011de:	89 d1                	mov    %edx,%ecx
  8011e0:	89 c2                	mov    %eax,%edx
  8011e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011e5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8011e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011eb:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8011f1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8011f8:	39 c2                	cmp    %eax,%edx
  8011fa:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8011fd:	72 3e                	jb     80123d <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8011ff:	83 ec 0c             	sub    $0xc,%esp
  801202:	ff 75 18             	pushl  0x18(%ebp)
  801205:	83 eb 01             	sub    $0x1,%ebx
  801208:	53                   	push   %ebx
  801209:	50                   	push   %eax
  80120a:	83 ec 08             	sub    $0x8,%esp
  80120d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801210:	ff 75 e0             	pushl  -0x20(%ebp)
  801213:	ff 75 dc             	pushl  -0x24(%ebp)
  801216:	ff 75 d8             	pushl  -0x28(%ebp)
  801219:	e8 72 0a 00 00       	call   801c90 <__udivdi3>
  80121e:	83 c4 18             	add    $0x18,%esp
  801221:	52                   	push   %edx
  801222:	50                   	push   %eax
  801223:	89 f2                	mov    %esi,%edx
  801225:	89 f8                	mov    %edi,%eax
  801227:	e8 9f ff ff ff       	call   8011cb <printnum>
  80122c:	83 c4 20             	add    $0x20,%esp
  80122f:	eb 13                	jmp    801244 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801231:	83 ec 08             	sub    $0x8,%esp
  801234:	56                   	push   %esi
  801235:	ff 75 18             	pushl  0x18(%ebp)
  801238:	ff d7                	call   *%edi
  80123a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80123d:	83 eb 01             	sub    $0x1,%ebx
  801240:	85 db                	test   %ebx,%ebx
  801242:	7f ed                	jg     801231 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801244:	83 ec 08             	sub    $0x8,%esp
  801247:	56                   	push   %esi
  801248:	83 ec 04             	sub    $0x4,%esp
  80124b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80124e:	ff 75 e0             	pushl  -0x20(%ebp)
  801251:	ff 75 dc             	pushl  -0x24(%ebp)
  801254:	ff 75 d8             	pushl  -0x28(%ebp)
  801257:	e8 44 0b 00 00       	call   801da0 <__umoddi3>
  80125c:	83 c4 14             	add    $0x14,%esp
  80125f:	0f be 80 47 20 80 00 	movsbl 0x802047(%eax),%eax
  801266:	50                   	push   %eax
  801267:	ff d7                	call   *%edi
}
  801269:	83 c4 10             	add    $0x10,%esp
  80126c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80126f:	5b                   	pop    %ebx
  801270:	5e                   	pop    %esi
  801271:	5f                   	pop    %edi
  801272:	5d                   	pop    %ebp
  801273:	c3                   	ret    

00801274 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801274:	f3 0f 1e fb          	endbr32 
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
  80127b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80127e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801282:	8b 10                	mov    (%eax),%edx
  801284:	3b 50 04             	cmp    0x4(%eax),%edx
  801287:	73 0a                	jae    801293 <sprintputch+0x1f>
		*b->buf++ = ch;
  801289:	8d 4a 01             	lea    0x1(%edx),%ecx
  80128c:	89 08                	mov    %ecx,(%eax)
  80128e:	8b 45 08             	mov    0x8(%ebp),%eax
  801291:	88 02                	mov    %al,(%edx)
}
  801293:	5d                   	pop    %ebp
  801294:	c3                   	ret    

00801295 <printfmt>:
{
  801295:	f3 0f 1e fb          	endbr32 
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80129f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8012a2:	50                   	push   %eax
  8012a3:	ff 75 10             	pushl  0x10(%ebp)
  8012a6:	ff 75 0c             	pushl  0xc(%ebp)
  8012a9:	ff 75 08             	pushl  0x8(%ebp)
  8012ac:	e8 05 00 00 00       	call   8012b6 <vprintfmt>
}
  8012b1:	83 c4 10             	add    $0x10,%esp
  8012b4:	c9                   	leave  
  8012b5:	c3                   	ret    

008012b6 <vprintfmt>:
{
  8012b6:	f3 0f 1e fb          	endbr32 
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
  8012bd:	57                   	push   %edi
  8012be:	56                   	push   %esi
  8012bf:	53                   	push   %ebx
  8012c0:	83 ec 3c             	sub    $0x3c,%esp
  8012c3:	8b 75 08             	mov    0x8(%ebp),%esi
  8012c6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012c9:	8b 7d 10             	mov    0x10(%ebp),%edi
  8012cc:	e9 8e 03 00 00       	jmp    80165f <vprintfmt+0x3a9>
		padc = ' ';
  8012d1:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8012d5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8012dc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8012e3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8012ea:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8012ef:	8d 47 01             	lea    0x1(%edi),%eax
  8012f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012f5:	0f b6 17             	movzbl (%edi),%edx
  8012f8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8012fb:	3c 55                	cmp    $0x55,%al
  8012fd:	0f 87 df 03 00 00    	ja     8016e2 <vprintfmt+0x42c>
  801303:	0f b6 c0             	movzbl %al,%eax
  801306:	3e ff 24 85 80 21 80 	notrack jmp *0x802180(,%eax,4)
  80130d:	00 
  80130e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801311:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801315:	eb d8                	jmp    8012ef <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801317:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80131a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80131e:	eb cf                	jmp    8012ef <vprintfmt+0x39>
  801320:	0f b6 d2             	movzbl %dl,%edx
  801323:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801326:	b8 00 00 00 00       	mov    $0x0,%eax
  80132b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80132e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801331:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801335:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801338:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80133b:	83 f9 09             	cmp    $0x9,%ecx
  80133e:	77 55                	ja     801395 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  801340:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801343:	eb e9                	jmp    80132e <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801345:	8b 45 14             	mov    0x14(%ebp),%eax
  801348:	8b 00                	mov    (%eax),%eax
  80134a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80134d:	8b 45 14             	mov    0x14(%ebp),%eax
  801350:	8d 40 04             	lea    0x4(%eax),%eax
  801353:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801356:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801359:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80135d:	79 90                	jns    8012ef <vprintfmt+0x39>
				width = precision, precision = -1;
  80135f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801362:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801365:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80136c:	eb 81                	jmp    8012ef <vprintfmt+0x39>
  80136e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801371:	85 c0                	test   %eax,%eax
  801373:	ba 00 00 00 00       	mov    $0x0,%edx
  801378:	0f 49 d0             	cmovns %eax,%edx
  80137b:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80137e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801381:	e9 69 ff ff ff       	jmp    8012ef <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801386:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801389:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801390:	e9 5a ff ff ff       	jmp    8012ef <vprintfmt+0x39>
  801395:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801398:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80139b:	eb bc                	jmp    801359 <vprintfmt+0xa3>
			lflag++;
  80139d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013a3:	e9 47 ff ff ff       	jmp    8012ef <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8013a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ab:	8d 78 04             	lea    0x4(%eax),%edi
  8013ae:	83 ec 08             	sub    $0x8,%esp
  8013b1:	53                   	push   %ebx
  8013b2:	ff 30                	pushl  (%eax)
  8013b4:	ff d6                	call   *%esi
			break;
  8013b6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8013b9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8013bc:	e9 9b 02 00 00       	jmp    80165c <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8013c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c4:	8d 78 04             	lea    0x4(%eax),%edi
  8013c7:	8b 00                	mov    (%eax),%eax
  8013c9:	99                   	cltd   
  8013ca:	31 d0                	xor    %edx,%eax
  8013cc:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8013ce:	83 f8 0f             	cmp    $0xf,%eax
  8013d1:	7f 23                	jg     8013f6 <vprintfmt+0x140>
  8013d3:	8b 14 85 e0 22 80 00 	mov    0x8022e0(,%eax,4),%edx
  8013da:	85 d2                	test   %edx,%edx
  8013dc:	74 18                	je     8013f6 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8013de:	52                   	push   %edx
  8013df:	68 dd 1f 80 00       	push   $0x801fdd
  8013e4:	53                   	push   %ebx
  8013e5:	56                   	push   %esi
  8013e6:	e8 aa fe ff ff       	call   801295 <printfmt>
  8013eb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8013ee:	89 7d 14             	mov    %edi,0x14(%ebp)
  8013f1:	e9 66 02 00 00       	jmp    80165c <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8013f6:	50                   	push   %eax
  8013f7:	68 5f 20 80 00       	push   $0x80205f
  8013fc:	53                   	push   %ebx
  8013fd:	56                   	push   %esi
  8013fe:	e8 92 fe ff ff       	call   801295 <printfmt>
  801403:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801406:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801409:	e9 4e 02 00 00       	jmp    80165c <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80140e:	8b 45 14             	mov    0x14(%ebp),%eax
  801411:	83 c0 04             	add    $0x4,%eax
  801414:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801417:	8b 45 14             	mov    0x14(%ebp),%eax
  80141a:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80141c:	85 d2                	test   %edx,%edx
  80141e:	b8 58 20 80 00       	mov    $0x802058,%eax
  801423:	0f 45 c2             	cmovne %edx,%eax
  801426:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801429:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80142d:	7e 06                	jle    801435 <vprintfmt+0x17f>
  80142f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801433:	75 0d                	jne    801442 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801435:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801438:	89 c7                	mov    %eax,%edi
  80143a:	03 45 e0             	add    -0x20(%ebp),%eax
  80143d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801440:	eb 55                	jmp    801497 <vprintfmt+0x1e1>
  801442:	83 ec 08             	sub    $0x8,%esp
  801445:	ff 75 d8             	pushl  -0x28(%ebp)
  801448:	ff 75 cc             	pushl  -0x34(%ebp)
  80144b:	e8 46 03 00 00       	call   801796 <strnlen>
  801450:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801453:	29 c2                	sub    %eax,%edx
  801455:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801458:	83 c4 10             	add    $0x10,%esp
  80145b:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80145d:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801461:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801464:	85 ff                	test   %edi,%edi
  801466:	7e 11                	jle    801479 <vprintfmt+0x1c3>
					putch(padc, putdat);
  801468:	83 ec 08             	sub    $0x8,%esp
  80146b:	53                   	push   %ebx
  80146c:	ff 75 e0             	pushl  -0x20(%ebp)
  80146f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801471:	83 ef 01             	sub    $0x1,%edi
  801474:	83 c4 10             	add    $0x10,%esp
  801477:	eb eb                	jmp    801464 <vprintfmt+0x1ae>
  801479:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80147c:	85 d2                	test   %edx,%edx
  80147e:	b8 00 00 00 00       	mov    $0x0,%eax
  801483:	0f 49 c2             	cmovns %edx,%eax
  801486:	29 c2                	sub    %eax,%edx
  801488:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80148b:	eb a8                	jmp    801435 <vprintfmt+0x17f>
					putch(ch, putdat);
  80148d:	83 ec 08             	sub    $0x8,%esp
  801490:	53                   	push   %ebx
  801491:	52                   	push   %edx
  801492:	ff d6                	call   *%esi
  801494:	83 c4 10             	add    $0x10,%esp
  801497:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80149a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80149c:	83 c7 01             	add    $0x1,%edi
  80149f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8014a3:	0f be d0             	movsbl %al,%edx
  8014a6:	85 d2                	test   %edx,%edx
  8014a8:	74 4b                	je     8014f5 <vprintfmt+0x23f>
  8014aa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014ae:	78 06                	js     8014b6 <vprintfmt+0x200>
  8014b0:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8014b4:	78 1e                	js     8014d4 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8014b6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8014ba:	74 d1                	je     80148d <vprintfmt+0x1d7>
  8014bc:	0f be c0             	movsbl %al,%eax
  8014bf:	83 e8 20             	sub    $0x20,%eax
  8014c2:	83 f8 5e             	cmp    $0x5e,%eax
  8014c5:	76 c6                	jbe    80148d <vprintfmt+0x1d7>
					putch('?', putdat);
  8014c7:	83 ec 08             	sub    $0x8,%esp
  8014ca:	53                   	push   %ebx
  8014cb:	6a 3f                	push   $0x3f
  8014cd:	ff d6                	call   *%esi
  8014cf:	83 c4 10             	add    $0x10,%esp
  8014d2:	eb c3                	jmp    801497 <vprintfmt+0x1e1>
  8014d4:	89 cf                	mov    %ecx,%edi
  8014d6:	eb 0e                	jmp    8014e6 <vprintfmt+0x230>
				putch(' ', putdat);
  8014d8:	83 ec 08             	sub    $0x8,%esp
  8014db:	53                   	push   %ebx
  8014dc:	6a 20                	push   $0x20
  8014de:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8014e0:	83 ef 01             	sub    $0x1,%edi
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	85 ff                	test   %edi,%edi
  8014e8:	7f ee                	jg     8014d8 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8014ea:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8014ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8014f0:	e9 67 01 00 00       	jmp    80165c <vprintfmt+0x3a6>
  8014f5:	89 cf                	mov    %ecx,%edi
  8014f7:	eb ed                	jmp    8014e6 <vprintfmt+0x230>
	if (lflag >= 2)
  8014f9:	83 f9 01             	cmp    $0x1,%ecx
  8014fc:	7f 1b                	jg     801519 <vprintfmt+0x263>
	else if (lflag)
  8014fe:	85 c9                	test   %ecx,%ecx
  801500:	74 63                	je     801565 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  801502:	8b 45 14             	mov    0x14(%ebp),%eax
  801505:	8b 00                	mov    (%eax),%eax
  801507:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80150a:	99                   	cltd   
  80150b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80150e:	8b 45 14             	mov    0x14(%ebp),%eax
  801511:	8d 40 04             	lea    0x4(%eax),%eax
  801514:	89 45 14             	mov    %eax,0x14(%ebp)
  801517:	eb 17                	jmp    801530 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801519:	8b 45 14             	mov    0x14(%ebp),%eax
  80151c:	8b 50 04             	mov    0x4(%eax),%edx
  80151f:	8b 00                	mov    (%eax),%eax
  801521:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801524:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801527:	8b 45 14             	mov    0x14(%ebp),%eax
  80152a:	8d 40 08             	lea    0x8(%eax),%eax
  80152d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801530:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801533:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801536:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80153b:	85 c9                	test   %ecx,%ecx
  80153d:	0f 89 ff 00 00 00    	jns    801642 <vprintfmt+0x38c>
				putch('-', putdat);
  801543:	83 ec 08             	sub    $0x8,%esp
  801546:	53                   	push   %ebx
  801547:	6a 2d                	push   $0x2d
  801549:	ff d6                	call   *%esi
				num = -(long long) num;
  80154b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80154e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801551:	f7 da                	neg    %edx
  801553:	83 d1 00             	adc    $0x0,%ecx
  801556:	f7 d9                	neg    %ecx
  801558:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80155b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801560:	e9 dd 00 00 00       	jmp    801642 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801565:	8b 45 14             	mov    0x14(%ebp),%eax
  801568:	8b 00                	mov    (%eax),%eax
  80156a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80156d:	99                   	cltd   
  80156e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801571:	8b 45 14             	mov    0x14(%ebp),%eax
  801574:	8d 40 04             	lea    0x4(%eax),%eax
  801577:	89 45 14             	mov    %eax,0x14(%ebp)
  80157a:	eb b4                	jmp    801530 <vprintfmt+0x27a>
	if (lflag >= 2)
  80157c:	83 f9 01             	cmp    $0x1,%ecx
  80157f:	7f 1e                	jg     80159f <vprintfmt+0x2e9>
	else if (lflag)
  801581:	85 c9                	test   %ecx,%ecx
  801583:	74 32                	je     8015b7 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801585:	8b 45 14             	mov    0x14(%ebp),%eax
  801588:	8b 10                	mov    (%eax),%edx
  80158a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80158f:	8d 40 04             	lea    0x4(%eax),%eax
  801592:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801595:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80159a:	e9 a3 00 00 00       	jmp    801642 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80159f:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a2:	8b 10                	mov    (%eax),%edx
  8015a4:	8b 48 04             	mov    0x4(%eax),%ecx
  8015a7:	8d 40 08             	lea    0x8(%eax),%eax
  8015aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015ad:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8015b2:	e9 8b 00 00 00       	jmp    801642 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8015b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ba:	8b 10                	mov    (%eax),%edx
  8015bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015c1:	8d 40 04             	lea    0x4(%eax),%eax
  8015c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015c7:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8015cc:	eb 74                	jmp    801642 <vprintfmt+0x38c>
	if (lflag >= 2)
  8015ce:	83 f9 01             	cmp    $0x1,%ecx
  8015d1:	7f 1b                	jg     8015ee <vprintfmt+0x338>
	else if (lflag)
  8015d3:	85 c9                	test   %ecx,%ecx
  8015d5:	74 2c                	je     801603 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8015d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015da:	8b 10                	mov    (%eax),%edx
  8015dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015e1:	8d 40 04             	lea    0x4(%eax),%eax
  8015e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8015e7:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8015ec:	eb 54                	jmp    801642 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8015ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8015f1:	8b 10                	mov    (%eax),%edx
  8015f3:	8b 48 04             	mov    0x4(%eax),%ecx
  8015f6:	8d 40 08             	lea    0x8(%eax),%eax
  8015f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8015fc:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801601:	eb 3f                	jmp    801642 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801603:	8b 45 14             	mov    0x14(%ebp),%eax
  801606:	8b 10                	mov    (%eax),%edx
  801608:	b9 00 00 00 00       	mov    $0x0,%ecx
  80160d:	8d 40 04             	lea    0x4(%eax),%eax
  801610:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801613:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801618:	eb 28                	jmp    801642 <vprintfmt+0x38c>
			putch('0', putdat);
  80161a:	83 ec 08             	sub    $0x8,%esp
  80161d:	53                   	push   %ebx
  80161e:	6a 30                	push   $0x30
  801620:	ff d6                	call   *%esi
			putch('x', putdat);
  801622:	83 c4 08             	add    $0x8,%esp
  801625:	53                   	push   %ebx
  801626:	6a 78                	push   $0x78
  801628:	ff d6                	call   *%esi
			num = (unsigned long long)
  80162a:	8b 45 14             	mov    0x14(%ebp),%eax
  80162d:	8b 10                	mov    (%eax),%edx
  80162f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801634:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801637:	8d 40 04             	lea    0x4(%eax),%eax
  80163a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80163d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801642:	83 ec 0c             	sub    $0xc,%esp
  801645:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801649:	57                   	push   %edi
  80164a:	ff 75 e0             	pushl  -0x20(%ebp)
  80164d:	50                   	push   %eax
  80164e:	51                   	push   %ecx
  80164f:	52                   	push   %edx
  801650:	89 da                	mov    %ebx,%edx
  801652:	89 f0                	mov    %esi,%eax
  801654:	e8 72 fb ff ff       	call   8011cb <printnum>
			break;
  801659:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80165c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80165f:	83 c7 01             	add    $0x1,%edi
  801662:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801666:	83 f8 25             	cmp    $0x25,%eax
  801669:	0f 84 62 fc ff ff    	je     8012d1 <vprintfmt+0x1b>
			if (ch == '\0')
  80166f:	85 c0                	test   %eax,%eax
  801671:	0f 84 8b 00 00 00    	je     801702 <vprintfmt+0x44c>
			putch(ch, putdat);
  801677:	83 ec 08             	sub    $0x8,%esp
  80167a:	53                   	push   %ebx
  80167b:	50                   	push   %eax
  80167c:	ff d6                	call   *%esi
  80167e:	83 c4 10             	add    $0x10,%esp
  801681:	eb dc                	jmp    80165f <vprintfmt+0x3a9>
	if (lflag >= 2)
  801683:	83 f9 01             	cmp    $0x1,%ecx
  801686:	7f 1b                	jg     8016a3 <vprintfmt+0x3ed>
	else if (lflag)
  801688:	85 c9                	test   %ecx,%ecx
  80168a:	74 2c                	je     8016b8 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  80168c:	8b 45 14             	mov    0x14(%ebp),%eax
  80168f:	8b 10                	mov    (%eax),%edx
  801691:	b9 00 00 00 00       	mov    $0x0,%ecx
  801696:	8d 40 04             	lea    0x4(%eax),%eax
  801699:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80169c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8016a1:	eb 9f                	jmp    801642 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8016a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a6:	8b 10                	mov    (%eax),%edx
  8016a8:	8b 48 04             	mov    0x4(%eax),%ecx
  8016ab:	8d 40 08             	lea    0x8(%eax),%eax
  8016ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016b1:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8016b6:	eb 8a                	jmp    801642 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8016b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016bb:	8b 10                	mov    (%eax),%edx
  8016bd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016c2:	8d 40 04             	lea    0x4(%eax),%eax
  8016c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016c8:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8016cd:	e9 70 ff ff ff       	jmp    801642 <vprintfmt+0x38c>
			putch(ch, putdat);
  8016d2:	83 ec 08             	sub    $0x8,%esp
  8016d5:	53                   	push   %ebx
  8016d6:	6a 25                	push   $0x25
  8016d8:	ff d6                	call   *%esi
			break;
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	e9 7a ff ff ff       	jmp    80165c <vprintfmt+0x3a6>
			putch('%', putdat);
  8016e2:	83 ec 08             	sub    $0x8,%esp
  8016e5:	53                   	push   %ebx
  8016e6:	6a 25                	push   $0x25
  8016e8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8016ea:	83 c4 10             	add    $0x10,%esp
  8016ed:	89 f8                	mov    %edi,%eax
  8016ef:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8016f3:	74 05                	je     8016fa <vprintfmt+0x444>
  8016f5:	83 e8 01             	sub    $0x1,%eax
  8016f8:	eb f5                	jmp    8016ef <vprintfmt+0x439>
  8016fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016fd:	e9 5a ff ff ff       	jmp    80165c <vprintfmt+0x3a6>
}
  801702:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801705:	5b                   	pop    %ebx
  801706:	5e                   	pop    %esi
  801707:	5f                   	pop    %edi
  801708:	5d                   	pop    %ebp
  801709:	c3                   	ret    

0080170a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80170a:	f3 0f 1e fb          	endbr32 
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	83 ec 18             	sub    $0x18,%esp
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80171a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80171d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801721:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801724:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80172b:	85 c0                	test   %eax,%eax
  80172d:	74 26                	je     801755 <vsnprintf+0x4b>
  80172f:	85 d2                	test   %edx,%edx
  801731:	7e 22                	jle    801755 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801733:	ff 75 14             	pushl  0x14(%ebp)
  801736:	ff 75 10             	pushl  0x10(%ebp)
  801739:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80173c:	50                   	push   %eax
  80173d:	68 74 12 80 00       	push   $0x801274
  801742:	e8 6f fb ff ff       	call   8012b6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801747:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80174a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80174d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801750:	83 c4 10             	add    $0x10,%esp
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    
		return -E_INVAL;
  801755:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80175a:	eb f7                	jmp    801753 <vsnprintf+0x49>

0080175c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80175c:	f3 0f 1e fb          	endbr32 
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801766:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801769:	50                   	push   %eax
  80176a:	ff 75 10             	pushl  0x10(%ebp)
  80176d:	ff 75 0c             	pushl  0xc(%ebp)
  801770:	ff 75 08             	pushl  0x8(%ebp)
  801773:	e8 92 ff ff ff       	call   80170a <vsnprintf>
	va_end(ap);

	return rc;
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80177a:	f3 0f 1e fb          	endbr32 
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
  801781:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801784:	b8 00 00 00 00       	mov    $0x0,%eax
  801789:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80178d:	74 05                	je     801794 <strlen+0x1a>
		n++;
  80178f:	83 c0 01             	add    $0x1,%eax
  801792:	eb f5                	jmp    801789 <strlen+0xf>
	return n;
}
  801794:	5d                   	pop    %ebp
  801795:	c3                   	ret    

00801796 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801796:	f3 0f 1e fb          	endbr32 
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017a0:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8017a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a8:	39 d0                	cmp    %edx,%eax
  8017aa:	74 0d                	je     8017b9 <strnlen+0x23>
  8017ac:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8017b0:	74 05                	je     8017b7 <strnlen+0x21>
		n++;
  8017b2:	83 c0 01             	add    $0x1,%eax
  8017b5:	eb f1                	jmp    8017a8 <strnlen+0x12>
  8017b7:	89 c2                	mov    %eax,%edx
	return n;
}
  8017b9:	89 d0                	mov    %edx,%eax
  8017bb:	5d                   	pop    %ebp
  8017bc:	c3                   	ret    

008017bd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8017bd:	f3 0f 1e fb          	endbr32 
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	53                   	push   %ebx
  8017c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8017cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8017d4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8017d7:	83 c0 01             	add    $0x1,%eax
  8017da:	84 d2                	test   %dl,%dl
  8017dc:	75 f2                	jne    8017d0 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8017de:	89 c8                	mov    %ecx,%eax
  8017e0:	5b                   	pop    %ebx
  8017e1:	5d                   	pop    %ebp
  8017e2:	c3                   	ret    

008017e3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8017e3:	f3 0f 1e fb          	endbr32 
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	53                   	push   %ebx
  8017eb:	83 ec 10             	sub    $0x10,%esp
  8017ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8017f1:	53                   	push   %ebx
  8017f2:	e8 83 ff ff ff       	call   80177a <strlen>
  8017f7:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8017fa:	ff 75 0c             	pushl  0xc(%ebp)
  8017fd:	01 d8                	add    %ebx,%eax
  8017ff:	50                   	push   %eax
  801800:	e8 b8 ff ff ff       	call   8017bd <strcpy>
	return dst;
}
  801805:	89 d8                	mov    %ebx,%eax
  801807:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80180c:	f3 0f 1e fb          	endbr32 
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	56                   	push   %esi
  801814:	53                   	push   %ebx
  801815:	8b 75 08             	mov    0x8(%ebp),%esi
  801818:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181b:	89 f3                	mov    %esi,%ebx
  80181d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801820:	89 f0                	mov    %esi,%eax
  801822:	39 d8                	cmp    %ebx,%eax
  801824:	74 11                	je     801837 <strncpy+0x2b>
		*dst++ = *src;
  801826:	83 c0 01             	add    $0x1,%eax
  801829:	0f b6 0a             	movzbl (%edx),%ecx
  80182c:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80182f:	80 f9 01             	cmp    $0x1,%cl
  801832:	83 da ff             	sbb    $0xffffffff,%edx
  801835:	eb eb                	jmp    801822 <strncpy+0x16>
	}
	return ret;
}
  801837:	89 f0                	mov    %esi,%eax
  801839:	5b                   	pop    %ebx
  80183a:	5e                   	pop    %esi
  80183b:	5d                   	pop    %ebp
  80183c:	c3                   	ret    

0080183d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80183d:	f3 0f 1e fb          	endbr32 
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	56                   	push   %esi
  801845:	53                   	push   %ebx
  801846:	8b 75 08             	mov    0x8(%ebp),%esi
  801849:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80184c:	8b 55 10             	mov    0x10(%ebp),%edx
  80184f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801851:	85 d2                	test   %edx,%edx
  801853:	74 21                	je     801876 <strlcpy+0x39>
  801855:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801859:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80185b:	39 c2                	cmp    %eax,%edx
  80185d:	74 14                	je     801873 <strlcpy+0x36>
  80185f:	0f b6 19             	movzbl (%ecx),%ebx
  801862:	84 db                	test   %bl,%bl
  801864:	74 0b                	je     801871 <strlcpy+0x34>
			*dst++ = *src++;
  801866:	83 c1 01             	add    $0x1,%ecx
  801869:	83 c2 01             	add    $0x1,%edx
  80186c:	88 5a ff             	mov    %bl,-0x1(%edx)
  80186f:	eb ea                	jmp    80185b <strlcpy+0x1e>
  801871:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801873:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801876:	29 f0                	sub    %esi,%eax
}
  801878:	5b                   	pop    %ebx
  801879:	5e                   	pop    %esi
  80187a:	5d                   	pop    %ebp
  80187b:	c3                   	ret    

0080187c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80187c:	f3 0f 1e fb          	endbr32 
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801886:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801889:	0f b6 01             	movzbl (%ecx),%eax
  80188c:	84 c0                	test   %al,%al
  80188e:	74 0c                	je     80189c <strcmp+0x20>
  801890:	3a 02                	cmp    (%edx),%al
  801892:	75 08                	jne    80189c <strcmp+0x20>
		p++, q++;
  801894:	83 c1 01             	add    $0x1,%ecx
  801897:	83 c2 01             	add    $0x1,%edx
  80189a:	eb ed                	jmp    801889 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80189c:	0f b6 c0             	movzbl %al,%eax
  80189f:	0f b6 12             	movzbl (%edx),%edx
  8018a2:	29 d0                	sub    %edx,%eax
}
  8018a4:	5d                   	pop    %ebp
  8018a5:	c3                   	ret    

008018a6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018a6:	f3 0f 1e fb          	endbr32 
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	53                   	push   %ebx
  8018ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b4:	89 c3                	mov    %eax,%ebx
  8018b6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8018b9:	eb 06                	jmp    8018c1 <strncmp+0x1b>
		n--, p++, q++;
  8018bb:	83 c0 01             	add    $0x1,%eax
  8018be:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8018c1:	39 d8                	cmp    %ebx,%eax
  8018c3:	74 16                	je     8018db <strncmp+0x35>
  8018c5:	0f b6 08             	movzbl (%eax),%ecx
  8018c8:	84 c9                	test   %cl,%cl
  8018ca:	74 04                	je     8018d0 <strncmp+0x2a>
  8018cc:	3a 0a                	cmp    (%edx),%cl
  8018ce:	74 eb                	je     8018bb <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018d0:	0f b6 00             	movzbl (%eax),%eax
  8018d3:	0f b6 12             	movzbl (%edx),%edx
  8018d6:	29 d0                	sub    %edx,%eax
}
  8018d8:	5b                   	pop    %ebx
  8018d9:	5d                   	pop    %ebp
  8018da:	c3                   	ret    
		return 0;
  8018db:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e0:	eb f6                	jmp    8018d8 <strncmp+0x32>

008018e2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018e2:	f3 0f 1e fb          	endbr32 
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8018f0:	0f b6 10             	movzbl (%eax),%edx
  8018f3:	84 d2                	test   %dl,%dl
  8018f5:	74 09                	je     801900 <strchr+0x1e>
		if (*s == c)
  8018f7:	38 ca                	cmp    %cl,%dl
  8018f9:	74 0a                	je     801905 <strchr+0x23>
	for (; *s; s++)
  8018fb:	83 c0 01             	add    $0x1,%eax
  8018fe:	eb f0                	jmp    8018f0 <strchr+0xe>
			return (char *) s;
	return 0;
  801900:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801905:	5d                   	pop    %ebp
  801906:	c3                   	ret    

00801907 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801907:	f3 0f 1e fb          	endbr32 
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801915:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801918:	38 ca                	cmp    %cl,%dl
  80191a:	74 09                	je     801925 <strfind+0x1e>
  80191c:	84 d2                	test   %dl,%dl
  80191e:	74 05                	je     801925 <strfind+0x1e>
	for (; *s; s++)
  801920:	83 c0 01             	add    $0x1,%eax
  801923:	eb f0                	jmp    801915 <strfind+0xe>
			break;
	return (char *) s;
}
  801925:	5d                   	pop    %ebp
  801926:	c3                   	ret    

00801927 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801927:	f3 0f 1e fb          	endbr32 
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	57                   	push   %edi
  80192f:	56                   	push   %esi
  801930:	53                   	push   %ebx
  801931:	8b 7d 08             	mov    0x8(%ebp),%edi
  801934:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801937:	85 c9                	test   %ecx,%ecx
  801939:	74 31                	je     80196c <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80193b:	89 f8                	mov    %edi,%eax
  80193d:	09 c8                	or     %ecx,%eax
  80193f:	a8 03                	test   $0x3,%al
  801941:	75 23                	jne    801966 <memset+0x3f>
		c &= 0xFF;
  801943:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801947:	89 d3                	mov    %edx,%ebx
  801949:	c1 e3 08             	shl    $0x8,%ebx
  80194c:	89 d0                	mov    %edx,%eax
  80194e:	c1 e0 18             	shl    $0x18,%eax
  801951:	89 d6                	mov    %edx,%esi
  801953:	c1 e6 10             	shl    $0x10,%esi
  801956:	09 f0                	or     %esi,%eax
  801958:	09 c2                	or     %eax,%edx
  80195a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80195c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80195f:	89 d0                	mov    %edx,%eax
  801961:	fc                   	cld    
  801962:	f3 ab                	rep stos %eax,%es:(%edi)
  801964:	eb 06                	jmp    80196c <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801966:	8b 45 0c             	mov    0xc(%ebp),%eax
  801969:	fc                   	cld    
  80196a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80196c:	89 f8                	mov    %edi,%eax
  80196e:	5b                   	pop    %ebx
  80196f:	5e                   	pop    %esi
  801970:	5f                   	pop    %edi
  801971:	5d                   	pop    %ebp
  801972:	c3                   	ret    

00801973 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801973:	f3 0f 1e fb          	endbr32 
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	57                   	push   %edi
  80197b:	56                   	push   %esi
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801982:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801985:	39 c6                	cmp    %eax,%esi
  801987:	73 32                	jae    8019bb <memmove+0x48>
  801989:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80198c:	39 c2                	cmp    %eax,%edx
  80198e:	76 2b                	jbe    8019bb <memmove+0x48>
		s += n;
		d += n;
  801990:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801993:	89 fe                	mov    %edi,%esi
  801995:	09 ce                	or     %ecx,%esi
  801997:	09 d6                	or     %edx,%esi
  801999:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80199f:	75 0e                	jne    8019af <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8019a1:	83 ef 04             	sub    $0x4,%edi
  8019a4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8019a7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8019aa:	fd                   	std    
  8019ab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019ad:	eb 09                	jmp    8019b8 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8019af:	83 ef 01             	sub    $0x1,%edi
  8019b2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8019b5:	fd                   	std    
  8019b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8019b8:	fc                   	cld    
  8019b9:	eb 1a                	jmp    8019d5 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019bb:	89 c2                	mov    %eax,%edx
  8019bd:	09 ca                	or     %ecx,%edx
  8019bf:	09 f2                	or     %esi,%edx
  8019c1:	f6 c2 03             	test   $0x3,%dl
  8019c4:	75 0a                	jne    8019d0 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8019c6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8019c9:	89 c7                	mov    %eax,%edi
  8019cb:	fc                   	cld    
  8019cc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019ce:	eb 05                	jmp    8019d5 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8019d0:	89 c7                	mov    %eax,%edi
  8019d2:	fc                   	cld    
  8019d3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8019d5:	5e                   	pop    %esi
  8019d6:	5f                   	pop    %edi
  8019d7:	5d                   	pop    %ebp
  8019d8:	c3                   	ret    

008019d9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8019d9:	f3 0f 1e fb          	endbr32 
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8019e3:	ff 75 10             	pushl  0x10(%ebp)
  8019e6:	ff 75 0c             	pushl  0xc(%ebp)
  8019e9:	ff 75 08             	pushl  0x8(%ebp)
  8019ec:	e8 82 ff ff ff       	call   801973 <memmove>
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8019f3:	f3 0f 1e fb          	endbr32 
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	56                   	push   %esi
  8019fb:	53                   	push   %ebx
  8019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a02:	89 c6                	mov    %eax,%esi
  801a04:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801a07:	39 f0                	cmp    %esi,%eax
  801a09:	74 1c                	je     801a27 <memcmp+0x34>
		if (*s1 != *s2)
  801a0b:	0f b6 08             	movzbl (%eax),%ecx
  801a0e:	0f b6 1a             	movzbl (%edx),%ebx
  801a11:	38 d9                	cmp    %bl,%cl
  801a13:	75 08                	jne    801a1d <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801a15:	83 c0 01             	add    $0x1,%eax
  801a18:	83 c2 01             	add    $0x1,%edx
  801a1b:	eb ea                	jmp    801a07 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801a1d:	0f b6 c1             	movzbl %cl,%eax
  801a20:	0f b6 db             	movzbl %bl,%ebx
  801a23:	29 d8                	sub    %ebx,%eax
  801a25:	eb 05                	jmp    801a2c <memcmp+0x39>
	}

	return 0;
  801a27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a2c:	5b                   	pop    %ebx
  801a2d:	5e                   	pop    %esi
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    

00801a30 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a30:	f3 0f 1e fb          	endbr32 
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801a3d:	89 c2                	mov    %eax,%edx
  801a3f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801a42:	39 d0                	cmp    %edx,%eax
  801a44:	73 09                	jae    801a4f <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a46:	38 08                	cmp    %cl,(%eax)
  801a48:	74 05                	je     801a4f <memfind+0x1f>
	for (; s < ends; s++)
  801a4a:	83 c0 01             	add    $0x1,%eax
  801a4d:	eb f3                	jmp    801a42 <memfind+0x12>
			break;
	return (void *) s;
}
  801a4f:	5d                   	pop    %ebp
  801a50:	c3                   	ret    

00801a51 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a51:	f3 0f 1e fb          	endbr32 
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	57                   	push   %edi
  801a59:	56                   	push   %esi
  801a5a:	53                   	push   %ebx
  801a5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a61:	eb 03                	jmp    801a66 <strtol+0x15>
		s++;
  801a63:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801a66:	0f b6 01             	movzbl (%ecx),%eax
  801a69:	3c 20                	cmp    $0x20,%al
  801a6b:	74 f6                	je     801a63 <strtol+0x12>
  801a6d:	3c 09                	cmp    $0x9,%al
  801a6f:	74 f2                	je     801a63 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801a71:	3c 2b                	cmp    $0x2b,%al
  801a73:	74 2a                	je     801a9f <strtol+0x4e>
	int neg = 0;
  801a75:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801a7a:	3c 2d                	cmp    $0x2d,%al
  801a7c:	74 2b                	je     801aa9 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a7e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801a84:	75 0f                	jne    801a95 <strtol+0x44>
  801a86:	80 39 30             	cmpb   $0x30,(%ecx)
  801a89:	74 28                	je     801ab3 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801a8b:	85 db                	test   %ebx,%ebx
  801a8d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801a92:	0f 44 d8             	cmove  %eax,%ebx
  801a95:	b8 00 00 00 00       	mov    $0x0,%eax
  801a9a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801a9d:	eb 46                	jmp    801ae5 <strtol+0x94>
		s++;
  801a9f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801aa2:	bf 00 00 00 00       	mov    $0x0,%edi
  801aa7:	eb d5                	jmp    801a7e <strtol+0x2d>
		s++, neg = 1;
  801aa9:	83 c1 01             	add    $0x1,%ecx
  801aac:	bf 01 00 00 00       	mov    $0x1,%edi
  801ab1:	eb cb                	jmp    801a7e <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ab3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801ab7:	74 0e                	je     801ac7 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801ab9:	85 db                	test   %ebx,%ebx
  801abb:	75 d8                	jne    801a95 <strtol+0x44>
		s++, base = 8;
  801abd:	83 c1 01             	add    $0x1,%ecx
  801ac0:	bb 08 00 00 00       	mov    $0x8,%ebx
  801ac5:	eb ce                	jmp    801a95 <strtol+0x44>
		s += 2, base = 16;
  801ac7:	83 c1 02             	add    $0x2,%ecx
  801aca:	bb 10 00 00 00       	mov    $0x10,%ebx
  801acf:	eb c4                	jmp    801a95 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801ad1:	0f be d2             	movsbl %dl,%edx
  801ad4:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801ad7:	3b 55 10             	cmp    0x10(%ebp),%edx
  801ada:	7d 3a                	jge    801b16 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801adc:	83 c1 01             	add    $0x1,%ecx
  801adf:	0f af 45 10          	imul   0x10(%ebp),%eax
  801ae3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801ae5:	0f b6 11             	movzbl (%ecx),%edx
  801ae8:	8d 72 d0             	lea    -0x30(%edx),%esi
  801aeb:	89 f3                	mov    %esi,%ebx
  801aed:	80 fb 09             	cmp    $0x9,%bl
  801af0:	76 df                	jbe    801ad1 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801af2:	8d 72 9f             	lea    -0x61(%edx),%esi
  801af5:	89 f3                	mov    %esi,%ebx
  801af7:	80 fb 19             	cmp    $0x19,%bl
  801afa:	77 08                	ja     801b04 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801afc:	0f be d2             	movsbl %dl,%edx
  801aff:	83 ea 57             	sub    $0x57,%edx
  801b02:	eb d3                	jmp    801ad7 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801b04:	8d 72 bf             	lea    -0x41(%edx),%esi
  801b07:	89 f3                	mov    %esi,%ebx
  801b09:	80 fb 19             	cmp    $0x19,%bl
  801b0c:	77 08                	ja     801b16 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801b0e:	0f be d2             	movsbl %dl,%edx
  801b11:	83 ea 37             	sub    $0x37,%edx
  801b14:	eb c1                	jmp    801ad7 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801b16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b1a:	74 05                	je     801b21 <strtol+0xd0>
		*endptr = (char *) s;
  801b1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b1f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801b21:	89 c2                	mov    %eax,%edx
  801b23:	f7 da                	neg    %edx
  801b25:	85 ff                	test   %edi,%edi
  801b27:	0f 45 c2             	cmovne %edx,%eax
}
  801b2a:	5b                   	pop    %ebx
  801b2b:	5e                   	pop    %esi
  801b2c:	5f                   	pop    %edi
  801b2d:	5d                   	pop    %ebp
  801b2e:	c3                   	ret    

00801b2f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b2f:	f3 0f 1e fb          	endbr32 
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
  801b36:	56                   	push   %esi
  801b37:	53                   	push   %ebx
  801b38:	8b 75 08             	mov    0x8(%ebp),%esi
  801b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801b41:	85 c0                	test   %eax,%eax
  801b43:	74 3d                	je     801b82 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801b45:	83 ec 0c             	sub    $0xc,%esp
  801b48:	50                   	push   %eax
  801b49:	e8 f4 e7 ff ff       	call   800342 <sys_ipc_recv>
  801b4e:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801b51:	85 f6                	test   %esi,%esi
  801b53:	74 0b                	je     801b60 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b55:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b5b:	8b 52 74             	mov    0x74(%edx),%edx
  801b5e:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801b60:	85 db                	test   %ebx,%ebx
  801b62:	74 0b                	je     801b6f <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801b64:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b6a:	8b 52 78             	mov    0x78(%edx),%edx
  801b6d:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801b6f:	85 c0                	test   %eax,%eax
  801b71:	78 21                	js     801b94 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801b73:	a1 04 40 80 00       	mov    0x804004,%eax
  801b78:	8b 40 70             	mov    0x70(%eax),%eax
}
  801b7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7e:	5b                   	pop    %ebx
  801b7f:	5e                   	pop    %esi
  801b80:	5d                   	pop    %ebp
  801b81:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801b82:	83 ec 0c             	sub    $0xc,%esp
  801b85:	68 00 00 c0 ee       	push   $0xeec00000
  801b8a:	e8 b3 e7 ff ff       	call   800342 <sys_ipc_recv>
  801b8f:	83 c4 10             	add    $0x10,%esp
  801b92:	eb bd                	jmp    801b51 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801b94:	85 f6                	test   %esi,%esi
  801b96:	74 10                	je     801ba8 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801b98:	85 db                	test   %ebx,%ebx
  801b9a:	75 df                	jne    801b7b <ipc_recv+0x4c>
  801b9c:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801ba3:	00 00 00 
  801ba6:	eb d3                	jmp    801b7b <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801ba8:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801baf:	00 00 00 
  801bb2:	eb e4                	jmp    801b98 <ipc_recv+0x69>

00801bb4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bb4:	f3 0f 1e fb          	endbr32 
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
  801bbb:	57                   	push   %edi
  801bbc:	56                   	push   %esi
  801bbd:	53                   	push   %ebx
  801bbe:	83 ec 0c             	sub    $0xc,%esp
  801bc1:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bc4:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bc7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801bca:	85 db                	test   %ebx,%ebx
  801bcc:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801bd1:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801bd4:	ff 75 14             	pushl  0x14(%ebp)
  801bd7:	53                   	push   %ebx
  801bd8:	56                   	push   %esi
  801bd9:	57                   	push   %edi
  801bda:	e8 3c e7 ff ff       	call   80031b <sys_ipc_try_send>
  801bdf:	83 c4 10             	add    $0x10,%esp
  801be2:	85 c0                	test   %eax,%eax
  801be4:	79 1e                	jns    801c04 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801be6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801be9:	75 07                	jne    801bf2 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801beb:	e8 63 e5 ff ff       	call   800153 <sys_yield>
  801bf0:	eb e2                	jmp    801bd4 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801bf2:	50                   	push   %eax
  801bf3:	68 3f 23 80 00       	push   $0x80233f
  801bf8:	6a 59                	push   $0x59
  801bfa:	68 5a 23 80 00       	push   $0x80235a
  801bff:	e8 c8 f4 ff ff       	call   8010cc <_panic>
	}
}
  801c04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c07:	5b                   	pop    %ebx
  801c08:	5e                   	pop    %esi
  801c09:	5f                   	pop    %edi
  801c0a:	5d                   	pop    %ebp
  801c0b:	c3                   	ret    

00801c0c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c0c:	f3 0f 1e fb          	endbr32 
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c16:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c1b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c1e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c24:	8b 52 50             	mov    0x50(%edx),%edx
  801c27:	39 ca                	cmp    %ecx,%edx
  801c29:	74 11                	je     801c3c <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801c2b:	83 c0 01             	add    $0x1,%eax
  801c2e:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c33:	75 e6                	jne    801c1b <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801c35:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3a:	eb 0b                	jmp    801c47 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801c3c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c3f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c44:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c47:	5d                   	pop    %ebp
  801c48:	c3                   	ret    

00801c49 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c49:	f3 0f 1e fb          	endbr32 
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c53:	89 c2                	mov    %eax,%edx
  801c55:	c1 ea 16             	shr    $0x16,%edx
  801c58:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c5f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c64:	f6 c1 01             	test   $0x1,%cl
  801c67:	74 1c                	je     801c85 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801c69:	c1 e8 0c             	shr    $0xc,%eax
  801c6c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c73:	a8 01                	test   $0x1,%al
  801c75:	74 0e                	je     801c85 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c77:	c1 e8 0c             	shr    $0xc,%eax
  801c7a:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801c81:	ef 
  801c82:	0f b7 d2             	movzwl %dx,%edx
}
  801c85:	89 d0                	mov    %edx,%eax
  801c87:	5d                   	pop    %ebp
  801c88:	c3                   	ret    
  801c89:	66 90                	xchg   %ax,%ax
  801c8b:	66 90                	xchg   %ax,%ax
  801c8d:	66 90                	xchg   %ax,%ax
  801c8f:	90                   	nop

00801c90 <__udivdi3>:
  801c90:	f3 0f 1e fb          	endbr32 
  801c94:	55                   	push   %ebp
  801c95:	57                   	push   %edi
  801c96:	56                   	push   %esi
  801c97:	53                   	push   %ebx
  801c98:	83 ec 1c             	sub    $0x1c,%esp
  801c9b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801c9f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801ca3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ca7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801cab:	85 d2                	test   %edx,%edx
  801cad:	75 19                	jne    801cc8 <__udivdi3+0x38>
  801caf:	39 f3                	cmp    %esi,%ebx
  801cb1:	76 4d                	jbe    801d00 <__udivdi3+0x70>
  801cb3:	31 ff                	xor    %edi,%edi
  801cb5:	89 e8                	mov    %ebp,%eax
  801cb7:	89 f2                	mov    %esi,%edx
  801cb9:	f7 f3                	div    %ebx
  801cbb:	89 fa                	mov    %edi,%edx
  801cbd:	83 c4 1c             	add    $0x1c,%esp
  801cc0:	5b                   	pop    %ebx
  801cc1:	5e                   	pop    %esi
  801cc2:	5f                   	pop    %edi
  801cc3:	5d                   	pop    %ebp
  801cc4:	c3                   	ret    
  801cc5:	8d 76 00             	lea    0x0(%esi),%esi
  801cc8:	39 f2                	cmp    %esi,%edx
  801cca:	76 14                	jbe    801ce0 <__udivdi3+0x50>
  801ccc:	31 ff                	xor    %edi,%edi
  801cce:	31 c0                	xor    %eax,%eax
  801cd0:	89 fa                	mov    %edi,%edx
  801cd2:	83 c4 1c             	add    $0x1c,%esp
  801cd5:	5b                   	pop    %ebx
  801cd6:	5e                   	pop    %esi
  801cd7:	5f                   	pop    %edi
  801cd8:	5d                   	pop    %ebp
  801cd9:	c3                   	ret    
  801cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801ce0:	0f bd fa             	bsr    %edx,%edi
  801ce3:	83 f7 1f             	xor    $0x1f,%edi
  801ce6:	75 48                	jne    801d30 <__udivdi3+0xa0>
  801ce8:	39 f2                	cmp    %esi,%edx
  801cea:	72 06                	jb     801cf2 <__udivdi3+0x62>
  801cec:	31 c0                	xor    %eax,%eax
  801cee:	39 eb                	cmp    %ebp,%ebx
  801cf0:	77 de                	ja     801cd0 <__udivdi3+0x40>
  801cf2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf7:	eb d7                	jmp    801cd0 <__udivdi3+0x40>
  801cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d00:	89 d9                	mov    %ebx,%ecx
  801d02:	85 db                	test   %ebx,%ebx
  801d04:	75 0b                	jne    801d11 <__udivdi3+0x81>
  801d06:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0b:	31 d2                	xor    %edx,%edx
  801d0d:	f7 f3                	div    %ebx
  801d0f:	89 c1                	mov    %eax,%ecx
  801d11:	31 d2                	xor    %edx,%edx
  801d13:	89 f0                	mov    %esi,%eax
  801d15:	f7 f1                	div    %ecx
  801d17:	89 c6                	mov    %eax,%esi
  801d19:	89 e8                	mov    %ebp,%eax
  801d1b:	89 f7                	mov    %esi,%edi
  801d1d:	f7 f1                	div    %ecx
  801d1f:	89 fa                	mov    %edi,%edx
  801d21:	83 c4 1c             	add    $0x1c,%esp
  801d24:	5b                   	pop    %ebx
  801d25:	5e                   	pop    %esi
  801d26:	5f                   	pop    %edi
  801d27:	5d                   	pop    %ebp
  801d28:	c3                   	ret    
  801d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d30:	89 f9                	mov    %edi,%ecx
  801d32:	b8 20 00 00 00       	mov    $0x20,%eax
  801d37:	29 f8                	sub    %edi,%eax
  801d39:	d3 e2                	shl    %cl,%edx
  801d3b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d3f:	89 c1                	mov    %eax,%ecx
  801d41:	89 da                	mov    %ebx,%edx
  801d43:	d3 ea                	shr    %cl,%edx
  801d45:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801d49:	09 d1                	or     %edx,%ecx
  801d4b:	89 f2                	mov    %esi,%edx
  801d4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d51:	89 f9                	mov    %edi,%ecx
  801d53:	d3 e3                	shl    %cl,%ebx
  801d55:	89 c1                	mov    %eax,%ecx
  801d57:	d3 ea                	shr    %cl,%edx
  801d59:	89 f9                	mov    %edi,%ecx
  801d5b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801d5f:	89 eb                	mov    %ebp,%ebx
  801d61:	d3 e6                	shl    %cl,%esi
  801d63:	89 c1                	mov    %eax,%ecx
  801d65:	d3 eb                	shr    %cl,%ebx
  801d67:	09 de                	or     %ebx,%esi
  801d69:	89 f0                	mov    %esi,%eax
  801d6b:	f7 74 24 08          	divl   0x8(%esp)
  801d6f:	89 d6                	mov    %edx,%esi
  801d71:	89 c3                	mov    %eax,%ebx
  801d73:	f7 64 24 0c          	mull   0xc(%esp)
  801d77:	39 d6                	cmp    %edx,%esi
  801d79:	72 15                	jb     801d90 <__udivdi3+0x100>
  801d7b:	89 f9                	mov    %edi,%ecx
  801d7d:	d3 e5                	shl    %cl,%ebp
  801d7f:	39 c5                	cmp    %eax,%ebp
  801d81:	73 04                	jae    801d87 <__udivdi3+0xf7>
  801d83:	39 d6                	cmp    %edx,%esi
  801d85:	74 09                	je     801d90 <__udivdi3+0x100>
  801d87:	89 d8                	mov    %ebx,%eax
  801d89:	31 ff                	xor    %edi,%edi
  801d8b:	e9 40 ff ff ff       	jmp    801cd0 <__udivdi3+0x40>
  801d90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d93:	31 ff                	xor    %edi,%edi
  801d95:	e9 36 ff ff ff       	jmp    801cd0 <__udivdi3+0x40>
  801d9a:	66 90                	xchg   %ax,%ax
  801d9c:	66 90                	xchg   %ax,%ax
  801d9e:	66 90                	xchg   %ax,%ax

00801da0 <__umoddi3>:
  801da0:	f3 0f 1e fb          	endbr32 
  801da4:	55                   	push   %ebp
  801da5:	57                   	push   %edi
  801da6:	56                   	push   %esi
  801da7:	53                   	push   %ebx
  801da8:	83 ec 1c             	sub    $0x1c,%esp
  801dab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801daf:	8b 74 24 30          	mov    0x30(%esp),%esi
  801db3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801db7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dbb:	85 c0                	test   %eax,%eax
  801dbd:	75 19                	jne    801dd8 <__umoddi3+0x38>
  801dbf:	39 df                	cmp    %ebx,%edi
  801dc1:	76 5d                	jbe    801e20 <__umoddi3+0x80>
  801dc3:	89 f0                	mov    %esi,%eax
  801dc5:	89 da                	mov    %ebx,%edx
  801dc7:	f7 f7                	div    %edi
  801dc9:	89 d0                	mov    %edx,%eax
  801dcb:	31 d2                	xor    %edx,%edx
  801dcd:	83 c4 1c             	add    $0x1c,%esp
  801dd0:	5b                   	pop    %ebx
  801dd1:	5e                   	pop    %esi
  801dd2:	5f                   	pop    %edi
  801dd3:	5d                   	pop    %ebp
  801dd4:	c3                   	ret    
  801dd5:	8d 76 00             	lea    0x0(%esi),%esi
  801dd8:	89 f2                	mov    %esi,%edx
  801dda:	39 d8                	cmp    %ebx,%eax
  801ddc:	76 12                	jbe    801df0 <__umoddi3+0x50>
  801dde:	89 f0                	mov    %esi,%eax
  801de0:	89 da                	mov    %ebx,%edx
  801de2:	83 c4 1c             	add    $0x1c,%esp
  801de5:	5b                   	pop    %ebx
  801de6:	5e                   	pop    %esi
  801de7:	5f                   	pop    %edi
  801de8:	5d                   	pop    %ebp
  801de9:	c3                   	ret    
  801dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801df0:	0f bd e8             	bsr    %eax,%ebp
  801df3:	83 f5 1f             	xor    $0x1f,%ebp
  801df6:	75 50                	jne    801e48 <__umoddi3+0xa8>
  801df8:	39 d8                	cmp    %ebx,%eax
  801dfa:	0f 82 e0 00 00 00    	jb     801ee0 <__umoddi3+0x140>
  801e00:	89 d9                	mov    %ebx,%ecx
  801e02:	39 f7                	cmp    %esi,%edi
  801e04:	0f 86 d6 00 00 00    	jbe    801ee0 <__umoddi3+0x140>
  801e0a:	89 d0                	mov    %edx,%eax
  801e0c:	89 ca                	mov    %ecx,%edx
  801e0e:	83 c4 1c             	add    $0x1c,%esp
  801e11:	5b                   	pop    %ebx
  801e12:	5e                   	pop    %esi
  801e13:	5f                   	pop    %edi
  801e14:	5d                   	pop    %ebp
  801e15:	c3                   	ret    
  801e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e1d:	8d 76 00             	lea    0x0(%esi),%esi
  801e20:	89 fd                	mov    %edi,%ebp
  801e22:	85 ff                	test   %edi,%edi
  801e24:	75 0b                	jne    801e31 <__umoddi3+0x91>
  801e26:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2b:	31 d2                	xor    %edx,%edx
  801e2d:	f7 f7                	div    %edi
  801e2f:	89 c5                	mov    %eax,%ebp
  801e31:	89 d8                	mov    %ebx,%eax
  801e33:	31 d2                	xor    %edx,%edx
  801e35:	f7 f5                	div    %ebp
  801e37:	89 f0                	mov    %esi,%eax
  801e39:	f7 f5                	div    %ebp
  801e3b:	89 d0                	mov    %edx,%eax
  801e3d:	31 d2                	xor    %edx,%edx
  801e3f:	eb 8c                	jmp    801dcd <__umoddi3+0x2d>
  801e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e48:	89 e9                	mov    %ebp,%ecx
  801e4a:	ba 20 00 00 00       	mov    $0x20,%edx
  801e4f:	29 ea                	sub    %ebp,%edx
  801e51:	d3 e0                	shl    %cl,%eax
  801e53:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e57:	89 d1                	mov    %edx,%ecx
  801e59:	89 f8                	mov    %edi,%eax
  801e5b:	d3 e8                	shr    %cl,%eax
  801e5d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e61:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e65:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e69:	09 c1                	or     %eax,%ecx
  801e6b:	89 d8                	mov    %ebx,%eax
  801e6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e71:	89 e9                	mov    %ebp,%ecx
  801e73:	d3 e7                	shl    %cl,%edi
  801e75:	89 d1                	mov    %edx,%ecx
  801e77:	d3 e8                	shr    %cl,%eax
  801e79:	89 e9                	mov    %ebp,%ecx
  801e7b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e7f:	d3 e3                	shl    %cl,%ebx
  801e81:	89 c7                	mov    %eax,%edi
  801e83:	89 d1                	mov    %edx,%ecx
  801e85:	89 f0                	mov    %esi,%eax
  801e87:	d3 e8                	shr    %cl,%eax
  801e89:	89 e9                	mov    %ebp,%ecx
  801e8b:	89 fa                	mov    %edi,%edx
  801e8d:	d3 e6                	shl    %cl,%esi
  801e8f:	09 d8                	or     %ebx,%eax
  801e91:	f7 74 24 08          	divl   0x8(%esp)
  801e95:	89 d1                	mov    %edx,%ecx
  801e97:	89 f3                	mov    %esi,%ebx
  801e99:	f7 64 24 0c          	mull   0xc(%esp)
  801e9d:	89 c6                	mov    %eax,%esi
  801e9f:	89 d7                	mov    %edx,%edi
  801ea1:	39 d1                	cmp    %edx,%ecx
  801ea3:	72 06                	jb     801eab <__umoddi3+0x10b>
  801ea5:	75 10                	jne    801eb7 <__umoddi3+0x117>
  801ea7:	39 c3                	cmp    %eax,%ebx
  801ea9:	73 0c                	jae    801eb7 <__umoddi3+0x117>
  801eab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801eaf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801eb3:	89 d7                	mov    %edx,%edi
  801eb5:	89 c6                	mov    %eax,%esi
  801eb7:	89 ca                	mov    %ecx,%edx
  801eb9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801ebe:	29 f3                	sub    %esi,%ebx
  801ec0:	19 fa                	sbb    %edi,%edx
  801ec2:	89 d0                	mov    %edx,%eax
  801ec4:	d3 e0                	shl    %cl,%eax
  801ec6:	89 e9                	mov    %ebp,%ecx
  801ec8:	d3 eb                	shr    %cl,%ebx
  801eca:	d3 ea                	shr    %cl,%edx
  801ecc:	09 d8                	or     %ebx,%eax
  801ece:	83 c4 1c             	add    $0x1c,%esp
  801ed1:	5b                   	pop    %ebx
  801ed2:	5e                   	pop    %esi
  801ed3:	5f                   	pop    %edi
  801ed4:	5d                   	pop    %ebp
  801ed5:	c3                   	ret    
  801ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801edd:	8d 76 00             	lea    0x0(%esi),%esi
  801ee0:	29 fe                	sub    %edi,%esi
  801ee2:	19 c3                	sbb    %eax,%ebx
  801ee4:	89 f2                	mov    %esi,%edx
  801ee6:	89 d9                	mov    %ebx,%ecx
  801ee8:	e9 1d ff ff ff       	jmp    801e0a <__umoddi3+0x6a>
