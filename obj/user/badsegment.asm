
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
  80005f:	a3 08 40 80 00       	mov    %eax,0x804008

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
  800092:	e8 93 05 00 00       	call   80062a <close_all>
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
  80011f:	68 6a 24 80 00       	push   $0x80246a
  800124:	6a 23                	push   $0x23
  800126:	68 87 24 80 00       	push   $0x802487
  80012b:	e8 08 15 00 00       	call   801638 <_panic>

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
  8001ac:	68 6a 24 80 00       	push   $0x80246a
  8001b1:	6a 23                	push   $0x23
  8001b3:	68 87 24 80 00       	push   $0x802487
  8001b8:	e8 7b 14 00 00       	call   801638 <_panic>

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
  8001f2:	68 6a 24 80 00       	push   $0x80246a
  8001f7:	6a 23                	push   $0x23
  8001f9:	68 87 24 80 00       	push   $0x802487
  8001fe:	e8 35 14 00 00       	call   801638 <_panic>

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
  800238:	68 6a 24 80 00       	push   $0x80246a
  80023d:	6a 23                	push   $0x23
  80023f:	68 87 24 80 00       	push   $0x802487
  800244:	e8 ef 13 00 00       	call   801638 <_panic>

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
  80027e:	68 6a 24 80 00       	push   $0x80246a
  800283:	6a 23                	push   $0x23
  800285:	68 87 24 80 00       	push   $0x802487
  80028a:	e8 a9 13 00 00       	call   801638 <_panic>

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
  8002c4:	68 6a 24 80 00       	push   $0x80246a
  8002c9:	6a 23                	push   $0x23
  8002cb:	68 87 24 80 00       	push   $0x802487
  8002d0:	e8 63 13 00 00       	call   801638 <_panic>

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
  80030a:	68 6a 24 80 00       	push   $0x80246a
  80030f:	6a 23                	push   $0x23
  800311:	68 87 24 80 00       	push   $0x802487
  800316:	e8 1d 13 00 00       	call   801638 <_panic>

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
  800376:	68 6a 24 80 00       	push   $0x80246a
  80037b:	6a 23                	push   $0x23
  80037d:	68 87 24 80 00       	push   $0x802487
  800382:	e8 b1 12 00 00       	call   801638 <_panic>

00800387 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800387:	f3 0f 1e fb          	endbr32 
  80038b:	55                   	push   %ebp
  80038c:	89 e5                	mov    %esp,%ebp
  80038e:	57                   	push   %edi
  80038f:	56                   	push   %esi
  800390:	53                   	push   %ebx
	asm volatile("int %1\n"
  800391:	ba 00 00 00 00       	mov    $0x0,%edx
  800396:	b8 0e 00 00 00       	mov    $0xe,%eax
  80039b:	89 d1                	mov    %edx,%ecx
  80039d:	89 d3                	mov    %edx,%ebx
  80039f:	89 d7                	mov    %edx,%edi
  8003a1:	89 d6                	mov    %edx,%esi
  8003a3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003a5:	5b                   	pop    %ebx
  8003a6:	5e                   	pop    %esi
  8003a7:	5f                   	pop    %edi
  8003a8:	5d                   	pop    %ebp
  8003a9:	c3                   	ret    

008003aa <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  8003aa:	f3 0f 1e fb          	endbr32 
  8003ae:	55                   	push   %ebp
  8003af:	89 e5                	mov    %esp,%ebp
  8003b1:	57                   	push   %edi
  8003b2:	56                   	push   %esi
  8003b3:	53                   	push   %ebx
  8003b4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8003b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8003bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003c2:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003c7:	89 df                	mov    %ebx,%edi
  8003c9:	89 de                	mov    %ebx,%esi
  8003cb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8003cd:	85 c0                	test   %eax,%eax
  8003cf:	7f 08                	jg     8003d9 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  8003d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003d4:	5b                   	pop    %ebx
  8003d5:	5e                   	pop    %esi
  8003d6:	5f                   	pop    %edi
  8003d7:	5d                   	pop    %ebp
  8003d8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8003d9:	83 ec 0c             	sub    $0xc,%esp
  8003dc:	50                   	push   %eax
  8003dd:	6a 0f                	push   $0xf
  8003df:	68 6a 24 80 00       	push   $0x80246a
  8003e4:	6a 23                	push   $0x23
  8003e6:	68 87 24 80 00       	push   $0x802487
  8003eb:	e8 48 12 00 00       	call   801638 <_panic>

008003f0 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  8003f0:	f3 0f 1e fb          	endbr32 
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	57                   	push   %edi
  8003f8:	56                   	push   %esi
  8003f9:	53                   	push   %ebx
  8003fa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8003fd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800402:	8b 55 08             	mov    0x8(%ebp),%edx
  800405:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800408:	b8 10 00 00 00       	mov    $0x10,%eax
  80040d:	89 df                	mov    %ebx,%edi
  80040f:	89 de                	mov    %ebx,%esi
  800411:	cd 30                	int    $0x30
	if(check && ret > 0)
  800413:	85 c0                	test   %eax,%eax
  800415:	7f 08                	jg     80041f <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800417:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80041a:	5b                   	pop    %ebx
  80041b:	5e                   	pop    %esi
  80041c:	5f                   	pop    %edi
  80041d:	5d                   	pop    %ebp
  80041e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80041f:	83 ec 0c             	sub    $0xc,%esp
  800422:	50                   	push   %eax
  800423:	6a 10                	push   $0x10
  800425:	68 6a 24 80 00       	push   $0x80246a
  80042a:	6a 23                	push   $0x23
  80042c:	68 87 24 80 00       	push   $0x802487
  800431:	e8 02 12 00 00       	call   801638 <_panic>

00800436 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800436:	f3 0f 1e fb          	endbr32 
  80043a:	55                   	push   %ebp
  80043b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	05 00 00 00 30       	add    $0x30000000,%eax
  800445:	c1 e8 0c             	shr    $0xc,%eax
}
  800448:	5d                   	pop    %ebp
  800449:	c3                   	ret    

0080044a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80044a:	f3 0f 1e fb          	endbr32 
  80044e:	55                   	push   %ebp
  80044f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800451:	8b 45 08             	mov    0x8(%ebp),%eax
  800454:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800459:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80045e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800463:	5d                   	pop    %ebp
  800464:	c3                   	ret    

00800465 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800465:	f3 0f 1e fb          	endbr32 
  800469:	55                   	push   %ebp
  80046a:	89 e5                	mov    %esp,%ebp
  80046c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800471:	89 c2                	mov    %eax,%edx
  800473:	c1 ea 16             	shr    $0x16,%edx
  800476:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80047d:	f6 c2 01             	test   $0x1,%dl
  800480:	74 2d                	je     8004af <fd_alloc+0x4a>
  800482:	89 c2                	mov    %eax,%edx
  800484:	c1 ea 0c             	shr    $0xc,%edx
  800487:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80048e:	f6 c2 01             	test   $0x1,%dl
  800491:	74 1c                	je     8004af <fd_alloc+0x4a>
  800493:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800498:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80049d:	75 d2                	jne    800471 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8004a8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8004ad:	eb 0a                	jmp    8004b9 <fd_alloc+0x54>
			*fd_store = fd;
  8004af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004b2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004b9:	5d                   	pop    %ebp
  8004ba:	c3                   	ret    

008004bb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8004bb:	f3 0f 1e fb          	endbr32 
  8004bf:	55                   	push   %ebp
  8004c0:	89 e5                	mov    %esp,%ebp
  8004c2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8004c5:	83 f8 1f             	cmp    $0x1f,%eax
  8004c8:	77 30                	ja     8004fa <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8004ca:	c1 e0 0c             	shl    $0xc,%eax
  8004cd:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8004d2:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8004d8:	f6 c2 01             	test   $0x1,%dl
  8004db:	74 24                	je     800501 <fd_lookup+0x46>
  8004dd:	89 c2                	mov    %eax,%edx
  8004df:	c1 ea 0c             	shr    $0xc,%edx
  8004e2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004e9:	f6 c2 01             	test   $0x1,%dl
  8004ec:	74 1a                	je     800508 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8004ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f1:	89 02                	mov    %eax,(%edx)
	return 0;
  8004f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004f8:	5d                   	pop    %ebp
  8004f9:	c3                   	ret    
		return -E_INVAL;
  8004fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004ff:	eb f7                	jmp    8004f8 <fd_lookup+0x3d>
		return -E_INVAL;
  800501:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800506:	eb f0                	jmp    8004f8 <fd_lookup+0x3d>
  800508:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80050d:	eb e9                	jmp    8004f8 <fd_lookup+0x3d>

0080050f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80050f:	f3 0f 1e fb          	endbr32 
  800513:	55                   	push   %ebp
  800514:	89 e5                	mov    %esp,%ebp
  800516:	83 ec 08             	sub    $0x8,%esp
  800519:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80051c:	ba 00 00 00 00       	mov    $0x0,%edx
  800521:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800526:	39 08                	cmp    %ecx,(%eax)
  800528:	74 38                	je     800562 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80052a:	83 c2 01             	add    $0x1,%edx
  80052d:	8b 04 95 14 25 80 00 	mov    0x802514(,%edx,4),%eax
  800534:	85 c0                	test   %eax,%eax
  800536:	75 ee                	jne    800526 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800538:	a1 08 40 80 00       	mov    0x804008,%eax
  80053d:	8b 40 48             	mov    0x48(%eax),%eax
  800540:	83 ec 04             	sub    $0x4,%esp
  800543:	51                   	push   %ecx
  800544:	50                   	push   %eax
  800545:	68 98 24 80 00       	push   $0x802498
  80054a:	e8 d0 11 00 00       	call   80171f <cprintf>
	*dev = 0;
  80054f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800552:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800558:	83 c4 10             	add    $0x10,%esp
  80055b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800560:	c9                   	leave  
  800561:	c3                   	ret    
			*dev = devtab[i];
  800562:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800565:	89 01                	mov    %eax,(%ecx)
			return 0;
  800567:	b8 00 00 00 00       	mov    $0x0,%eax
  80056c:	eb f2                	jmp    800560 <dev_lookup+0x51>

0080056e <fd_close>:
{
  80056e:	f3 0f 1e fb          	endbr32 
  800572:	55                   	push   %ebp
  800573:	89 e5                	mov    %esp,%ebp
  800575:	57                   	push   %edi
  800576:	56                   	push   %esi
  800577:	53                   	push   %ebx
  800578:	83 ec 24             	sub    $0x24,%esp
  80057b:	8b 75 08             	mov    0x8(%ebp),%esi
  80057e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800581:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800584:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800585:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80058b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80058e:	50                   	push   %eax
  80058f:	e8 27 ff ff ff       	call   8004bb <fd_lookup>
  800594:	89 c3                	mov    %eax,%ebx
  800596:	83 c4 10             	add    $0x10,%esp
  800599:	85 c0                	test   %eax,%eax
  80059b:	78 05                	js     8005a2 <fd_close+0x34>
	    || fd != fd2)
  80059d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8005a0:	74 16                	je     8005b8 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8005a2:	89 f8                	mov    %edi,%eax
  8005a4:	84 c0                	test   %al,%al
  8005a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ab:	0f 44 d8             	cmove  %eax,%ebx
}
  8005ae:	89 d8                	mov    %ebx,%eax
  8005b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005b3:	5b                   	pop    %ebx
  8005b4:	5e                   	pop    %esi
  8005b5:	5f                   	pop    %edi
  8005b6:	5d                   	pop    %ebp
  8005b7:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8005b8:	83 ec 08             	sub    $0x8,%esp
  8005bb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8005be:	50                   	push   %eax
  8005bf:	ff 36                	pushl  (%esi)
  8005c1:	e8 49 ff ff ff       	call   80050f <dev_lookup>
  8005c6:	89 c3                	mov    %eax,%ebx
  8005c8:	83 c4 10             	add    $0x10,%esp
  8005cb:	85 c0                	test   %eax,%eax
  8005cd:	78 1a                	js     8005e9 <fd_close+0x7b>
		if (dev->dev_close)
  8005cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d2:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8005d5:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8005da:	85 c0                	test   %eax,%eax
  8005dc:	74 0b                	je     8005e9 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8005de:	83 ec 0c             	sub    $0xc,%esp
  8005e1:	56                   	push   %esi
  8005e2:	ff d0                	call   *%eax
  8005e4:	89 c3                	mov    %eax,%ebx
  8005e6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8005e9:	83 ec 08             	sub    $0x8,%esp
  8005ec:	56                   	push   %esi
  8005ed:	6a 00                	push   $0x0
  8005ef:	e8 0f fc ff ff       	call   800203 <sys_page_unmap>
	return r;
  8005f4:	83 c4 10             	add    $0x10,%esp
  8005f7:	eb b5                	jmp    8005ae <fd_close+0x40>

008005f9 <close>:

int
close(int fdnum)
{
  8005f9:	f3 0f 1e fb          	endbr32 
  8005fd:	55                   	push   %ebp
  8005fe:	89 e5                	mov    %esp,%ebp
  800600:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800603:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800606:	50                   	push   %eax
  800607:	ff 75 08             	pushl  0x8(%ebp)
  80060a:	e8 ac fe ff ff       	call   8004bb <fd_lookup>
  80060f:	83 c4 10             	add    $0x10,%esp
  800612:	85 c0                	test   %eax,%eax
  800614:	79 02                	jns    800618 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800616:	c9                   	leave  
  800617:	c3                   	ret    
		return fd_close(fd, 1);
  800618:	83 ec 08             	sub    $0x8,%esp
  80061b:	6a 01                	push   $0x1
  80061d:	ff 75 f4             	pushl  -0xc(%ebp)
  800620:	e8 49 ff ff ff       	call   80056e <fd_close>
  800625:	83 c4 10             	add    $0x10,%esp
  800628:	eb ec                	jmp    800616 <close+0x1d>

0080062a <close_all>:

void
close_all(void)
{
  80062a:	f3 0f 1e fb          	endbr32 
  80062e:	55                   	push   %ebp
  80062f:	89 e5                	mov    %esp,%ebp
  800631:	53                   	push   %ebx
  800632:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800635:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80063a:	83 ec 0c             	sub    $0xc,%esp
  80063d:	53                   	push   %ebx
  80063e:	e8 b6 ff ff ff       	call   8005f9 <close>
	for (i = 0; i < MAXFD; i++)
  800643:	83 c3 01             	add    $0x1,%ebx
  800646:	83 c4 10             	add    $0x10,%esp
  800649:	83 fb 20             	cmp    $0x20,%ebx
  80064c:	75 ec                	jne    80063a <close_all+0x10>
}
  80064e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800651:	c9                   	leave  
  800652:	c3                   	ret    

00800653 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800653:	f3 0f 1e fb          	endbr32 
  800657:	55                   	push   %ebp
  800658:	89 e5                	mov    %esp,%ebp
  80065a:	57                   	push   %edi
  80065b:	56                   	push   %esi
  80065c:	53                   	push   %ebx
  80065d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800660:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800663:	50                   	push   %eax
  800664:	ff 75 08             	pushl  0x8(%ebp)
  800667:	e8 4f fe ff ff       	call   8004bb <fd_lookup>
  80066c:	89 c3                	mov    %eax,%ebx
  80066e:	83 c4 10             	add    $0x10,%esp
  800671:	85 c0                	test   %eax,%eax
  800673:	0f 88 81 00 00 00    	js     8006fa <dup+0xa7>
		return r;
	close(newfdnum);
  800679:	83 ec 0c             	sub    $0xc,%esp
  80067c:	ff 75 0c             	pushl  0xc(%ebp)
  80067f:	e8 75 ff ff ff       	call   8005f9 <close>

	newfd = INDEX2FD(newfdnum);
  800684:	8b 75 0c             	mov    0xc(%ebp),%esi
  800687:	c1 e6 0c             	shl    $0xc,%esi
  80068a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800690:	83 c4 04             	add    $0x4,%esp
  800693:	ff 75 e4             	pushl  -0x1c(%ebp)
  800696:	e8 af fd ff ff       	call   80044a <fd2data>
  80069b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80069d:	89 34 24             	mov    %esi,(%esp)
  8006a0:	e8 a5 fd ff ff       	call   80044a <fd2data>
  8006a5:	83 c4 10             	add    $0x10,%esp
  8006a8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8006aa:	89 d8                	mov    %ebx,%eax
  8006ac:	c1 e8 16             	shr    $0x16,%eax
  8006af:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8006b6:	a8 01                	test   $0x1,%al
  8006b8:	74 11                	je     8006cb <dup+0x78>
  8006ba:	89 d8                	mov    %ebx,%eax
  8006bc:	c1 e8 0c             	shr    $0xc,%eax
  8006bf:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8006c6:	f6 c2 01             	test   $0x1,%dl
  8006c9:	75 39                	jne    800704 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8006cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006ce:	89 d0                	mov    %edx,%eax
  8006d0:	c1 e8 0c             	shr    $0xc,%eax
  8006d3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	25 07 0e 00 00       	and    $0xe07,%eax
  8006e2:	50                   	push   %eax
  8006e3:	56                   	push   %esi
  8006e4:	6a 00                	push   $0x0
  8006e6:	52                   	push   %edx
  8006e7:	6a 00                	push   $0x0
  8006e9:	e8 cf fa ff ff       	call   8001bd <sys_page_map>
  8006ee:	89 c3                	mov    %eax,%ebx
  8006f0:	83 c4 20             	add    $0x20,%esp
  8006f3:	85 c0                	test   %eax,%eax
  8006f5:	78 31                	js     800728 <dup+0xd5>
		goto err;

	return newfdnum;
  8006f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8006fa:	89 d8                	mov    %ebx,%eax
  8006fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006ff:	5b                   	pop    %ebx
  800700:	5e                   	pop    %esi
  800701:	5f                   	pop    %edi
  800702:	5d                   	pop    %ebp
  800703:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800704:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	25 07 0e 00 00       	and    $0xe07,%eax
  800713:	50                   	push   %eax
  800714:	57                   	push   %edi
  800715:	6a 00                	push   $0x0
  800717:	53                   	push   %ebx
  800718:	6a 00                	push   $0x0
  80071a:	e8 9e fa ff ff       	call   8001bd <sys_page_map>
  80071f:	89 c3                	mov    %eax,%ebx
  800721:	83 c4 20             	add    $0x20,%esp
  800724:	85 c0                	test   %eax,%eax
  800726:	79 a3                	jns    8006cb <dup+0x78>
	sys_page_unmap(0, newfd);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	56                   	push   %esi
  80072c:	6a 00                	push   $0x0
  80072e:	e8 d0 fa ff ff       	call   800203 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800733:	83 c4 08             	add    $0x8,%esp
  800736:	57                   	push   %edi
  800737:	6a 00                	push   $0x0
  800739:	e8 c5 fa ff ff       	call   800203 <sys_page_unmap>
	return r;
  80073e:	83 c4 10             	add    $0x10,%esp
  800741:	eb b7                	jmp    8006fa <dup+0xa7>

00800743 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800743:	f3 0f 1e fb          	endbr32 
  800747:	55                   	push   %ebp
  800748:	89 e5                	mov    %esp,%ebp
  80074a:	53                   	push   %ebx
  80074b:	83 ec 1c             	sub    $0x1c,%esp
  80074e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800751:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800754:	50                   	push   %eax
  800755:	53                   	push   %ebx
  800756:	e8 60 fd ff ff       	call   8004bb <fd_lookup>
  80075b:	83 c4 10             	add    $0x10,%esp
  80075e:	85 c0                	test   %eax,%eax
  800760:	78 3f                	js     8007a1 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800762:	83 ec 08             	sub    $0x8,%esp
  800765:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800768:	50                   	push   %eax
  800769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80076c:	ff 30                	pushl  (%eax)
  80076e:	e8 9c fd ff ff       	call   80050f <dev_lookup>
  800773:	83 c4 10             	add    $0x10,%esp
  800776:	85 c0                	test   %eax,%eax
  800778:	78 27                	js     8007a1 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80077a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80077d:	8b 42 08             	mov    0x8(%edx),%eax
  800780:	83 e0 03             	and    $0x3,%eax
  800783:	83 f8 01             	cmp    $0x1,%eax
  800786:	74 1e                	je     8007a6 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80078b:	8b 40 08             	mov    0x8(%eax),%eax
  80078e:	85 c0                	test   %eax,%eax
  800790:	74 35                	je     8007c7 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800792:	83 ec 04             	sub    $0x4,%esp
  800795:	ff 75 10             	pushl  0x10(%ebp)
  800798:	ff 75 0c             	pushl  0xc(%ebp)
  80079b:	52                   	push   %edx
  80079c:	ff d0                	call   *%eax
  80079e:	83 c4 10             	add    $0x10,%esp
}
  8007a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007a4:	c9                   	leave  
  8007a5:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8007a6:	a1 08 40 80 00       	mov    0x804008,%eax
  8007ab:	8b 40 48             	mov    0x48(%eax),%eax
  8007ae:	83 ec 04             	sub    $0x4,%esp
  8007b1:	53                   	push   %ebx
  8007b2:	50                   	push   %eax
  8007b3:	68 d9 24 80 00       	push   $0x8024d9
  8007b8:	e8 62 0f 00 00       	call   80171f <cprintf>
		return -E_INVAL;
  8007bd:	83 c4 10             	add    $0x10,%esp
  8007c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007c5:	eb da                	jmp    8007a1 <read+0x5e>
		return -E_NOT_SUPP;
  8007c7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007cc:	eb d3                	jmp    8007a1 <read+0x5e>

008007ce <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8007ce:	f3 0f 1e fb          	endbr32 
  8007d2:	55                   	push   %ebp
  8007d3:	89 e5                	mov    %esp,%ebp
  8007d5:	57                   	push   %edi
  8007d6:	56                   	push   %esi
  8007d7:	53                   	push   %ebx
  8007d8:	83 ec 0c             	sub    $0xc,%esp
  8007db:	8b 7d 08             	mov    0x8(%ebp),%edi
  8007de:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8007e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007e6:	eb 02                	jmp    8007ea <readn+0x1c>
  8007e8:	01 c3                	add    %eax,%ebx
  8007ea:	39 f3                	cmp    %esi,%ebx
  8007ec:	73 21                	jae    80080f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8007ee:	83 ec 04             	sub    $0x4,%esp
  8007f1:	89 f0                	mov    %esi,%eax
  8007f3:	29 d8                	sub    %ebx,%eax
  8007f5:	50                   	push   %eax
  8007f6:	89 d8                	mov    %ebx,%eax
  8007f8:	03 45 0c             	add    0xc(%ebp),%eax
  8007fb:	50                   	push   %eax
  8007fc:	57                   	push   %edi
  8007fd:	e8 41 ff ff ff       	call   800743 <read>
		if (m < 0)
  800802:	83 c4 10             	add    $0x10,%esp
  800805:	85 c0                	test   %eax,%eax
  800807:	78 04                	js     80080d <readn+0x3f>
			return m;
		if (m == 0)
  800809:	75 dd                	jne    8007e8 <readn+0x1a>
  80080b:	eb 02                	jmp    80080f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80080d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80080f:	89 d8                	mov    %ebx,%eax
  800811:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800814:	5b                   	pop    %ebx
  800815:	5e                   	pop    %esi
  800816:	5f                   	pop    %edi
  800817:	5d                   	pop    %ebp
  800818:	c3                   	ret    

00800819 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800819:	f3 0f 1e fb          	endbr32 
  80081d:	55                   	push   %ebp
  80081e:	89 e5                	mov    %esp,%ebp
  800820:	53                   	push   %ebx
  800821:	83 ec 1c             	sub    $0x1c,%esp
  800824:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800827:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80082a:	50                   	push   %eax
  80082b:	53                   	push   %ebx
  80082c:	e8 8a fc ff ff       	call   8004bb <fd_lookup>
  800831:	83 c4 10             	add    $0x10,%esp
  800834:	85 c0                	test   %eax,%eax
  800836:	78 3a                	js     800872 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800838:	83 ec 08             	sub    $0x8,%esp
  80083b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80083e:	50                   	push   %eax
  80083f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800842:	ff 30                	pushl  (%eax)
  800844:	e8 c6 fc ff ff       	call   80050f <dev_lookup>
  800849:	83 c4 10             	add    $0x10,%esp
  80084c:	85 c0                	test   %eax,%eax
  80084e:	78 22                	js     800872 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800850:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800853:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800857:	74 1e                	je     800877 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800859:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80085c:	8b 52 0c             	mov    0xc(%edx),%edx
  80085f:	85 d2                	test   %edx,%edx
  800861:	74 35                	je     800898 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800863:	83 ec 04             	sub    $0x4,%esp
  800866:	ff 75 10             	pushl  0x10(%ebp)
  800869:	ff 75 0c             	pushl  0xc(%ebp)
  80086c:	50                   	push   %eax
  80086d:	ff d2                	call   *%edx
  80086f:	83 c4 10             	add    $0x10,%esp
}
  800872:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800875:	c9                   	leave  
  800876:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800877:	a1 08 40 80 00       	mov    0x804008,%eax
  80087c:	8b 40 48             	mov    0x48(%eax),%eax
  80087f:	83 ec 04             	sub    $0x4,%esp
  800882:	53                   	push   %ebx
  800883:	50                   	push   %eax
  800884:	68 f5 24 80 00       	push   $0x8024f5
  800889:	e8 91 0e 00 00       	call   80171f <cprintf>
		return -E_INVAL;
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800896:	eb da                	jmp    800872 <write+0x59>
		return -E_NOT_SUPP;
  800898:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80089d:	eb d3                	jmp    800872 <write+0x59>

0080089f <seek>:

int
seek(int fdnum, off_t offset)
{
  80089f:	f3 0f 1e fb          	endbr32 
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8008a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008ac:	50                   	push   %eax
  8008ad:	ff 75 08             	pushl  0x8(%ebp)
  8008b0:	e8 06 fc ff ff       	call   8004bb <fd_lookup>
  8008b5:	83 c4 10             	add    $0x10,%esp
  8008b8:	85 c0                	test   %eax,%eax
  8008ba:	78 0e                	js     8008ca <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8008bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8008c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008ca:	c9                   	leave  
  8008cb:	c3                   	ret    

008008cc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8008cc:	f3 0f 1e fb          	endbr32 
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	53                   	push   %ebx
  8008d4:	83 ec 1c             	sub    $0x1c,%esp
  8008d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008dd:	50                   	push   %eax
  8008de:	53                   	push   %ebx
  8008df:	e8 d7 fb ff ff       	call   8004bb <fd_lookup>
  8008e4:	83 c4 10             	add    $0x10,%esp
  8008e7:	85 c0                	test   %eax,%eax
  8008e9:	78 37                	js     800922 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008eb:	83 ec 08             	sub    $0x8,%esp
  8008ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008f1:	50                   	push   %eax
  8008f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f5:	ff 30                	pushl  (%eax)
  8008f7:	e8 13 fc ff ff       	call   80050f <dev_lookup>
  8008fc:	83 c4 10             	add    $0x10,%esp
  8008ff:	85 c0                	test   %eax,%eax
  800901:	78 1f                	js     800922 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800903:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800906:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80090a:	74 1b                	je     800927 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80090c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80090f:	8b 52 18             	mov    0x18(%edx),%edx
  800912:	85 d2                	test   %edx,%edx
  800914:	74 32                	je     800948 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	50                   	push   %eax
  80091d:	ff d2                	call   *%edx
  80091f:	83 c4 10             	add    $0x10,%esp
}
  800922:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800925:	c9                   	leave  
  800926:	c3                   	ret    
			thisenv->env_id, fdnum);
  800927:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80092c:	8b 40 48             	mov    0x48(%eax),%eax
  80092f:	83 ec 04             	sub    $0x4,%esp
  800932:	53                   	push   %ebx
  800933:	50                   	push   %eax
  800934:	68 b8 24 80 00       	push   $0x8024b8
  800939:	e8 e1 0d 00 00       	call   80171f <cprintf>
		return -E_INVAL;
  80093e:	83 c4 10             	add    $0x10,%esp
  800941:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800946:	eb da                	jmp    800922 <ftruncate+0x56>
		return -E_NOT_SUPP;
  800948:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80094d:	eb d3                	jmp    800922 <ftruncate+0x56>

0080094f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80094f:	f3 0f 1e fb          	endbr32 
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	53                   	push   %ebx
  800957:	83 ec 1c             	sub    $0x1c,%esp
  80095a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80095d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800960:	50                   	push   %eax
  800961:	ff 75 08             	pushl  0x8(%ebp)
  800964:	e8 52 fb ff ff       	call   8004bb <fd_lookup>
  800969:	83 c4 10             	add    $0x10,%esp
  80096c:	85 c0                	test   %eax,%eax
  80096e:	78 4b                	js     8009bb <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800970:	83 ec 08             	sub    $0x8,%esp
  800973:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800976:	50                   	push   %eax
  800977:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097a:	ff 30                	pushl  (%eax)
  80097c:	e8 8e fb ff ff       	call   80050f <dev_lookup>
  800981:	83 c4 10             	add    $0x10,%esp
  800984:	85 c0                	test   %eax,%eax
  800986:	78 33                	js     8009bb <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  800988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80098b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80098f:	74 2f                	je     8009c0 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800991:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800994:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80099b:	00 00 00 
	stat->st_isdir = 0;
  80099e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8009a5:	00 00 00 
	stat->st_dev = dev;
  8009a8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8009ae:	83 ec 08             	sub    $0x8,%esp
  8009b1:	53                   	push   %ebx
  8009b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8009b5:	ff 50 14             	call   *0x14(%eax)
  8009b8:	83 c4 10             	add    $0x10,%esp
}
  8009bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009be:	c9                   	leave  
  8009bf:	c3                   	ret    
		return -E_NOT_SUPP;
  8009c0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8009c5:	eb f4                	jmp    8009bb <fstat+0x6c>

008009c7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8009c7:	f3 0f 1e fb          	endbr32 
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	56                   	push   %esi
  8009cf:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8009d0:	83 ec 08             	sub    $0x8,%esp
  8009d3:	6a 00                	push   $0x0
  8009d5:	ff 75 08             	pushl  0x8(%ebp)
  8009d8:	e8 fb 01 00 00       	call   800bd8 <open>
  8009dd:	89 c3                	mov    %eax,%ebx
  8009df:	83 c4 10             	add    $0x10,%esp
  8009e2:	85 c0                	test   %eax,%eax
  8009e4:	78 1b                	js     800a01 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8009e6:	83 ec 08             	sub    $0x8,%esp
  8009e9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ec:	50                   	push   %eax
  8009ed:	e8 5d ff ff ff       	call   80094f <fstat>
  8009f2:	89 c6                	mov    %eax,%esi
	close(fd);
  8009f4:	89 1c 24             	mov    %ebx,(%esp)
  8009f7:	e8 fd fb ff ff       	call   8005f9 <close>
	return r;
  8009fc:	83 c4 10             	add    $0x10,%esp
  8009ff:	89 f3                	mov    %esi,%ebx
}
  800a01:	89 d8                	mov    %ebx,%eax
  800a03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a06:	5b                   	pop    %ebx
  800a07:	5e                   	pop    %esi
  800a08:	5d                   	pop    %ebp
  800a09:	c3                   	ret    

00800a0a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	56                   	push   %esi
  800a0e:	53                   	push   %ebx
  800a0f:	89 c6                	mov    %eax,%esi
  800a11:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800a13:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800a1a:	74 27                	je     800a43 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800a1c:	6a 07                	push   $0x7
  800a1e:	68 00 50 80 00       	push   $0x805000
  800a23:	56                   	push   %esi
  800a24:	ff 35 00 40 80 00    	pushl  0x804000
  800a2a:	e8 f1 16 00 00       	call   802120 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800a2f:	83 c4 0c             	add    $0xc,%esp
  800a32:	6a 00                	push   $0x0
  800a34:	53                   	push   %ebx
  800a35:	6a 00                	push   $0x0
  800a37:	e8 5f 16 00 00       	call   80209b <ipc_recv>
}
  800a3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a3f:	5b                   	pop    %ebx
  800a40:	5e                   	pop    %esi
  800a41:	5d                   	pop    %ebp
  800a42:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800a43:	83 ec 0c             	sub    $0xc,%esp
  800a46:	6a 01                	push   $0x1
  800a48:	e8 2b 17 00 00       	call   802178 <ipc_find_env>
  800a4d:	a3 00 40 80 00       	mov    %eax,0x804000
  800a52:	83 c4 10             	add    $0x10,%esp
  800a55:	eb c5                	jmp    800a1c <fsipc+0x12>

00800a57 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800a57:	f3 0f 1e fb          	endbr32 
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	8b 40 0c             	mov    0xc(%eax),%eax
  800a67:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800a74:	ba 00 00 00 00       	mov    $0x0,%edx
  800a79:	b8 02 00 00 00       	mov    $0x2,%eax
  800a7e:	e8 87 ff ff ff       	call   800a0a <fsipc>
}
  800a83:	c9                   	leave  
  800a84:	c3                   	ret    

00800a85 <devfile_flush>:
{
  800a85:	f3 0f 1e fb          	endbr32 
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	8b 40 0c             	mov    0xc(%eax),%eax
  800a95:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9f:	b8 06 00 00 00       	mov    $0x6,%eax
  800aa4:	e8 61 ff ff ff       	call   800a0a <fsipc>
}
  800aa9:	c9                   	leave  
  800aaa:	c3                   	ret    

00800aab <devfile_stat>:
{
  800aab:	f3 0f 1e fb          	endbr32 
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	53                   	push   %ebx
  800ab3:	83 ec 04             	sub    $0x4,%esp
  800ab6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	8b 40 0c             	mov    0xc(%eax),%eax
  800abf:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800ac4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac9:	b8 05 00 00 00       	mov    $0x5,%eax
  800ace:	e8 37 ff ff ff       	call   800a0a <fsipc>
  800ad3:	85 c0                	test   %eax,%eax
  800ad5:	78 2c                	js     800b03 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	68 00 50 80 00       	push   $0x805000
  800adf:	53                   	push   %ebx
  800ae0:	e8 44 12 00 00       	call   801d29 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800ae5:	a1 80 50 80 00       	mov    0x805080,%eax
  800aea:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800af0:	a1 84 50 80 00       	mov    0x805084,%eax
  800af5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800afb:	83 c4 10             	add    $0x10,%esp
  800afe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b06:	c9                   	leave  
  800b07:	c3                   	ret    

00800b08 <devfile_write>:
{
  800b08:	f3 0f 1e fb          	endbr32 
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	83 ec 0c             	sub    $0xc,%esp
  800b12:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800b15:	8b 55 08             	mov    0x8(%ebp),%edx
  800b18:	8b 52 0c             	mov    0xc(%edx),%edx
  800b1b:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  800b21:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800b26:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800b2b:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  800b2e:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800b33:	50                   	push   %eax
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	68 08 50 80 00       	push   $0x805008
  800b3c:	e8 9e 13 00 00       	call   801edf <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800b41:	ba 00 00 00 00       	mov    $0x0,%edx
  800b46:	b8 04 00 00 00       	mov    $0x4,%eax
  800b4b:	e8 ba fe ff ff       	call   800a0a <fsipc>
}
  800b50:	c9                   	leave  
  800b51:	c3                   	ret    

00800b52 <devfile_read>:
{
  800b52:	f3 0f 1e fb          	endbr32 
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	56                   	push   %esi
  800b5a:	53                   	push   %ebx
  800b5b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8b 40 0c             	mov    0xc(%eax),%eax
  800b64:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b69:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b74:	b8 03 00 00 00       	mov    $0x3,%eax
  800b79:	e8 8c fe ff ff       	call   800a0a <fsipc>
  800b7e:	89 c3                	mov    %eax,%ebx
  800b80:	85 c0                	test   %eax,%eax
  800b82:	78 1f                	js     800ba3 <devfile_read+0x51>
	assert(r <= n);
  800b84:	39 f0                	cmp    %esi,%eax
  800b86:	77 24                	ja     800bac <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800b88:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b8d:	7f 33                	jg     800bc2 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b8f:	83 ec 04             	sub    $0x4,%esp
  800b92:	50                   	push   %eax
  800b93:	68 00 50 80 00       	push   $0x805000
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	e8 3f 13 00 00       	call   801edf <memmove>
	return r;
  800ba0:	83 c4 10             	add    $0x10,%esp
}
  800ba3:	89 d8                	mov    %ebx,%eax
  800ba5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ba8:	5b                   	pop    %ebx
  800ba9:	5e                   	pop    %esi
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    
	assert(r <= n);
  800bac:	68 28 25 80 00       	push   $0x802528
  800bb1:	68 2f 25 80 00       	push   $0x80252f
  800bb6:	6a 7c                	push   $0x7c
  800bb8:	68 44 25 80 00       	push   $0x802544
  800bbd:	e8 76 0a 00 00       	call   801638 <_panic>
	assert(r <= PGSIZE);
  800bc2:	68 4f 25 80 00       	push   $0x80254f
  800bc7:	68 2f 25 80 00       	push   $0x80252f
  800bcc:	6a 7d                	push   $0x7d
  800bce:	68 44 25 80 00       	push   $0x802544
  800bd3:	e8 60 0a 00 00       	call   801638 <_panic>

00800bd8 <open>:
{
  800bd8:	f3 0f 1e fb          	endbr32 
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	56                   	push   %esi
  800be0:	53                   	push   %ebx
  800be1:	83 ec 1c             	sub    $0x1c,%esp
  800be4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800be7:	56                   	push   %esi
  800be8:	e8 f9 10 00 00       	call   801ce6 <strlen>
  800bed:	83 c4 10             	add    $0x10,%esp
  800bf0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800bf5:	7f 6c                	jg     800c63 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800bf7:	83 ec 0c             	sub    $0xc,%esp
  800bfa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bfd:	50                   	push   %eax
  800bfe:	e8 62 f8 ff ff       	call   800465 <fd_alloc>
  800c03:	89 c3                	mov    %eax,%ebx
  800c05:	83 c4 10             	add    $0x10,%esp
  800c08:	85 c0                	test   %eax,%eax
  800c0a:	78 3c                	js     800c48 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800c0c:	83 ec 08             	sub    $0x8,%esp
  800c0f:	56                   	push   %esi
  800c10:	68 00 50 80 00       	push   $0x805000
  800c15:	e8 0f 11 00 00       	call   801d29 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800c22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c25:	b8 01 00 00 00       	mov    $0x1,%eax
  800c2a:	e8 db fd ff ff       	call   800a0a <fsipc>
  800c2f:	89 c3                	mov    %eax,%ebx
  800c31:	83 c4 10             	add    $0x10,%esp
  800c34:	85 c0                	test   %eax,%eax
  800c36:	78 19                	js     800c51 <open+0x79>
	return fd2num(fd);
  800c38:	83 ec 0c             	sub    $0xc,%esp
  800c3b:	ff 75 f4             	pushl  -0xc(%ebp)
  800c3e:	e8 f3 f7 ff ff       	call   800436 <fd2num>
  800c43:	89 c3                	mov    %eax,%ebx
  800c45:	83 c4 10             	add    $0x10,%esp
}
  800c48:	89 d8                	mov    %ebx,%eax
  800c4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c4d:	5b                   	pop    %ebx
  800c4e:	5e                   	pop    %esi
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    
		fd_close(fd, 0);
  800c51:	83 ec 08             	sub    $0x8,%esp
  800c54:	6a 00                	push   $0x0
  800c56:	ff 75 f4             	pushl  -0xc(%ebp)
  800c59:	e8 10 f9 ff ff       	call   80056e <fd_close>
		return r;
  800c5e:	83 c4 10             	add    $0x10,%esp
  800c61:	eb e5                	jmp    800c48 <open+0x70>
		return -E_BAD_PATH;
  800c63:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800c68:	eb de                	jmp    800c48 <open+0x70>

00800c6a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800c6a:	f3 0f 1e fb          	endbr32 
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c74:	ba 00 00 00 00       	mov    $0x0,%edx
  800c79:	b8 08 00 00 00       	mov    $0x8,%eax
  800c7e:	e8 87 fd ff ff       	call   800a0a <fsipc>
}
  800c83:	c9                   	leave  
  800c84:	c3                   	ret    

00800c85 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800c85:	f3 0f 1e fb          	endbr32 
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800c8f:	68 5b 25 80 00       	push   $0x80255b
  800c94:	ff 75 0c             	pushl  0xc(%ebp)
  800c97:	e8 8d 10 00 00       	call   801d29 <strcpy>
	return 0;
}
  800c9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca1:	c9                   	leave  
  800ca2:	c3                   	ret    

00800ca3 <devsock_close>:
{
  800ca3:	f3 0f 1e fb          	endbr32 
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	53                   	push   %ebx
  800cab:	83 ec 10             	sub    $0x10,%esp
  800cae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800cb1:	53                   	push   %ebx
  800cb2:	e8 fe 14 00 00       	call   8021b5 <pageref>
  800cb7:	89 c2                	mov    %eax,%edx
  800cb9:	83 c4 10             	add    $0x10,%esp
		return 0;
  800cbc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  800cc1:	83 fa 01             	cmp    $0x1,%edx
  800cc4:	74 05                	je     800ccb <devsock_close+0x28>
}
  800cc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cc9:	c9                   	leave  
  800cca:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800ccb:	83 ec 0c             	sub    $0xc,%esp
  800cce:	ff 73 0c             	pushl  0xc(%ebx)
  800cd1:	e8 e3 02 00 00       	call   800fb9 <nsipc_close>
  800cd6:	83 c4 10             	add    $0x10,%esp
  800cd9:	eb eb                	jmp    800cc6 <devsock_close+0x23>

00800cdb <devsock_write>:
{
  800cdb:	f3 0f 1e fb          	endbr32 
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800ce5:	6a 00                	push   $0x0
  800ce7:	ff 75 10             	pushl  0x10(%ebp)
  800cea:	ff 75 0c             	pushl  0xc(%ebp)
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	ff 70 0c             	pushl  0xc(%eax)
  800cf3:	e8 b5 03 00 00       	call   8010ad <nsipc_send>
}
  800cf8:	c9                   	leave  
  800cf9:	c3                   	ret    

00800cfa <devsock_read>:
{
  800cfa:	f3 0f 1e fb          	endbr32 
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800d04:	6a 00                	push   $0x0
  800d06:	ff 75 10             	pushl  0x10(%ebp)
  800d09:	ff 75 0c             	pushl  0xc(%ebp)
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	ff 70 0c             	pushl  0xc(%eax)
  800d12:	e8 1f 03 00 00       	call   801036 <nsipc_recv>
}
  800d17:	c9                   	leave  
  800d18:	c3                   	ret    

00800d19 <fd2sockid>:
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800d1f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800d22:	52                   	push   %edx
  800d23:	50                   	push   %eax
  800d24:	e8 92 f7 ff ff       	call   8004bb <fd_lookup>
  800d29:	83 c4 10             	add    $0x10,%esp
  800d2c:	85 c0                	test   %eax,%eax
  800d2e:	78 10                	js     800d40 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d33:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800d39:	39 08                	cmp    %ecx,(%eax)
  800d3b:	75 05                	jne    800d42 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800d3d:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800d40:	c9                   	leave  
  800d41:	c3                   	ret    
		return -E_NOT_SUPP;
  800d42:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800d47:	eb f7                	jmp    800d40 <fd2sockid+0x27>

00800d49 <alloc_sockfd>:
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	56                   	push   %esi
  800d4d:	53                   	push   %ebx
  800d4e:	83 ec 1c             	sub    $0x1c,%esp
  800d51:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800d53:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d56:	50                   	push   %eax
  800d57:	e8 09 f7 ff ff       	call   800465 <fd_alloc>
  800d5c:	89 c3                	mov    %eax,%ebx
  800d5e:	83 c4 10             	add    $0x10,%esp
  800d61:	85 c0                	test   %eax,%eax
  800d63:	78 43                	js     800da8 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800d65:	83 ec 04             	sub    $0x4,%esp
  800d68:	68 07 04 00 00       	push   $0x407
  800d6d:	ff 75 f4             	pushl  -0xc(%ebp)
  800d70:	6a 00                	push   $0x0
  800d72:	e8 ff f3 ff ff       	call   800176 <sys_page_alloc>
  800d77:	89 c3                	mov    %eax,%ebx
  800d79:	83 c4 10             	add    $0x10,%esp
  800d7c:	85 c0                	test   %eax,%eax
  800d7e:	78 28                	js     800da8 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d83:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800d89:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d8e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800d95:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800d98:	83 ec 0c             	sub    $0xc,%esp
  800d9b:	50                   	push   %eax
  800d9c:	e8 95 f6 ff ff       	call   800436 <fd2num>
  800da1:	89 c3                	mov    %eax,%ebx
  800da3:	83 c4 10             	add    $0x10,%esp
  800da6:	eb 0c                	jmp    800db4 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800da8:	83 ec 0c             	sub    $0xc,%esp
  800dab:	56                   	push   %esi
  800dac:	e8 08 02 00 00       	call   800fb9 <nsipc_close>
		return r;
  800db1:	83 c4 10             	add    $0x10,%esp
}
  800db4:	89 d8                	mov    %ebx,%eax
  800db6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800db9:	5b                   	pop    %ebx
  800dba:	5e                   	pop    %esi
  800dbb:	5d                   	pop    %ebp
  800dbc:	c3                   	ret    

00800dbd <accept>:
{
  800dbd:	f3 0f 1e fb          	endbr32 
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	e8 4a ff ff ff       	call   800d19 <fd2sockid>
  800dcf:	85 c0                	test   %eax,%eax
  800dd1:	78 1b                	js     800dee <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800dd3:	83 ec 04             	sub    $0x4,%esp
  800dd6:	ff 75 10             	pushl  0x10(%ebp)
  800dd9:	ff 75 0c             	pushl  0xc(%ebp)
  800ddc:	50                   	push   %eax
  800ddd:	e8 22 01 00 00       	call   800f04 <nsipc_accept>
  800de2:	83 c4 10             	add    $0x10,%esp
  800de5:	85 c0                	test   %eax,%eax
  800de7:	78 05                	js     800dee <accept+0x31>
	return alloc_sockfd(r);
  800de9:	e8 5b ff ff ff       	call   800d49 <alloc_sockfd>
}
  800dee:	c9                   	leave  
  800def:	c3                   	ret    

00800df0 <bind>:
{
  800df0:	f3 0f 1e fb          	endbr32 
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	e8 17 ff ff ff       	call   800d19 <fd2sockid>
  800e02:	85 c0                	test   %eax,%eax
  800e04:	78 12                	js     800e18 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  800e06:	83 ec 04             	sub    $0x4,%esp
  800e09:	ff 75 10             	pushl  0x10(%ebp)
  800e0c:	ff 75 0c             	pushl  0xc(%ebp)
  800e0f:	50                   	push   %eax
  800e10:	e8 45 01 00 00       	call   800f5a <nsipc_bind>
  800e15:	83 c4 10             	add    $0x10,%esp
}
  800e18:	c9                   	leave  
  800e19:	c3                   	ret    

00800e1a <shutdown>:
{
  800e1a:	f3 0f 1e fb          	endbr32 
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	e8 ed fe ff ff       	call   800d19 <fd2sockid>
  800e2c:	85 c0                	test   %eax,%eax
  800e2e:	78 0f                	js     800e3f <shutdown+0x25>
	return nsipc_shutdown(r, how);
  800e30:	83 ec 08             	sub    $0x8,%esp
  800e33:	ff 75 0c             	pushl  0xc(%ebp)
  800e36:	50                   	push   %eax
  800e37:	e8 57 01 00 00       	call   800f93 <nsipc_shutdown>
  800e3c:	83 c4 10             	add    $0x10,%esp
}
  800e3f:	c9                   	leave  
  800e40:	c3                   	ret    

00800e41 <connect>:
{
  800e41:	f3 0f 1e fb          	endbr32 
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	e8 c6 fe ff ff       	call   800d19 <fd2sockid>
  800e53:	85 c0                	test   %eax,%eax
  800e55:	78 12                	js     800e69 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  800e57:	83 ec 04             	sub    $0x4,%esp
  800e5a:	ff 75 10             	pushl  0x10(%ebp)
  800e5d:	ff 75 0c             	pushl  0xc(%ebp)
  800e60:	50                   	push   %eax
  800e61:	e8 71 01 00 00       	call   800fd7 <nsipc_connect>
  800e66:	83 c4 10             	add    $0x10,%esp
}
  800e69:	c9                   	leave  
  800e6a:	c3                   	ret    

00800e6b <listen>:
{
  800e6b:	f3 0f 1e fb          	endbr32 
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
  800e72:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	e8 9c fe ff ff       	call   800d19 <fd2sockid>
  800e7d:	85 c0                	test   %eax,%eax
  800e7f:	78 0f                	js     800e90 <listen+0x25>
	return nsipc_listen(r, backlog);
  800e81:	83 ec 08             	sub    $0x8,%esp
  800e84:	ff 75 0c             	pushl  0xc(%ebp)
  800e87:	50                   	push   %eax
  800e88:	e8 83 01 00 00       	call   801010 <nsipc_listen>
  800e8d:	83 c4 10             	add    $0x10,%esp
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <socket>:

int
socket(int domain, int type, int protocol)
{
  800e92:	f3 0f 1e fb          	endbr32 
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800e9c:	ff 75 10             	pushl  0x10(%ebp)
  800e9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ea2:	ff 75 08             	pushl  0x8(%ebp)
  800ea5:	e8 65 02 00 00       	call   80110f <nsipc_socket>
  800eaa:	83 c4 10             	add    $0x10,%esp
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	78 05                	js     800eb6 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  800eb1:	e8 93 fe ff ff       	call   800d49 <alloc_sockfd>
}
  800eb6:	c9                   	leave  
  800eb7:	c3                   	ret    

00800eb8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	53                   	push   %ebx
  800ebc:	83 ec 04             	sub    $0x4,%esp
  800ebf:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800ec1:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800ec8:	74 26                	je     800ef0 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800eca:	6a 07                	push   $0x7
  800ecc:	68 00 60 80 00       	push   $0x806000
  800ed1:	53                   	push   %ebx
  800ed2:	ff 35 04 40 80 00    	pushl  0x804004
  800ed8:	e8 43 12 00 00       	call   802120 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800edd:	83 c4 0c             	add    $0xc,%esp
  800ee0:	6a 00                	push   $0x0
  800ee2:	6a 00                	push   $0x0
  800ee4:	6a 00                	push   $0x0
  800ee6:	e8 b0 11 00 00       	call   80209b <ipc_recv>
}
  800eeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800eee:	c9                   	leave  
  800eef:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800ef0:	83 ec 0c             	sub    $0xc,%esp
  800ef3:	6a 02                	push   $0x2
  800ef5:	e8 7e 12 00 00       	call   802178 <ipc_find_env>
  800efa:	a3 04 40 80 00       	mov    %eax,0x804004
  800eff:	83 c4 10             	add    $0x10,%esp
  800f02:	eb c6                	jmp    800eca <nsipc+0x12>

00800f04 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800f04:	f3 0f 1e fb          	endbr32 
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	56                   	push   %esi
  800f0c:	53                   	push   %ebx
  800f0d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800f18:	8b 06                	mov    (%esi),%eax
  800f1a:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800f1f:	b8 01 00 00 00       	mov    $0x1,%eax
  800f24:	e8 8f ff ff ff       	call   800eb8 <nsipc>
  800f29:	89 c3                	mov    %eax,%ebx
  800f2b:	85 c0                	test   %eax,%eax
  800f2d:	79 09                	jns    800f38 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  800f2f:	89 d8                	mov    %ebx,%eax
  800f31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f34:	5b                   	pop    %ebx
  800f35:	5e                   	pop    %esi
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800f38:	83 ec 04             	sub    $0x4,%esp
  800f3b:	ff 35 10 60 80 00    	pushl  0x806010
  800f41:	68 00 60 80 00       	push   $0x806000
  800f46:	ff 75 0c             	pushl  0xc(%ebp)
  800f49:	e8 91 0f 00 00       	call   801edf <memmove>
		*addrlen = ret->ret_addrlen;
  800f4e:	a1 10 60 80 00       	mov    0x806010,%eax
  800f53:	89 06                	mov    %eax,(%esi)
  800f55:	83 c4 10             	add    $0x10,%esp
	return r;
  800f58:	eb d5                	jmp    800f2f <nsipc_accept+0x2b>

00800f5a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800f5a:	f3 0f 1e fb          	endbr32 
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	53                   	push   %ebx
  800f62:	83 ec 08             	sub    $0x8,%esp
  800f65:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800f70:	53                   	push   %ebx
  800f71:	ff 75 0c             	pushl  0xc(%ebp)
  800f74:	68 04 60 80 00       	push   $0x806004
  800f79:	e8 61 0f 00 00       	call   801edf <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800f7e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800f84:	b8 02 00 00 00       	mov    $0x2,%eax
  800f89:	e8 2a ff ff ff       	call   800eb8 <nsipc>
}
  800f8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f91:	c9                   	leave  
  800f92:	c3                   	ret    

00800f93 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800f93:	f3 0f 1e fb          	endbr32 
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800fad:	b8 03 00 00 00       	mov    $0x3,%eax
  800fb2:	e8 01 ff ff ff       	call   800eb8 <nsipc>
}
  800fb7:	c9                   	leave  
  800fb8:	c3                   	ret    

00800fb9 <nsipc_close>:

int
nsipc_close(int s)
{
  800fb9:	f3 0f 1e fb          	endbr32 
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800fcb:	b8 04 00 00 00       	mov    $0x4,%eax
  800fd0:	e8 e3 fe ff ff       	call   800eb8 <nsipc>
}
  800fd5:	c9                   	leave  
  800fd6:	c3                   	ret    

00800fd7 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800fd7:	f3 0f 1e fb          	endbr32 
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	53                   	push   %ebx
  800fdf:	83 ec 08             	sub    $0x8,%esp
  800fe2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800fed:	53                   	push   %ebx
  800fee:	ff 75 0c             	pushl  0xc(%ebp)
  800ff1:	68 04 60 80 00       	push   $0x806004
  800ff6:	e8 e4 0e 00 00       	call   801edf <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800ffb:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801001:	b8 05 00 00 00       	mov    $0x5,%eax
  801006:	e8 ad fe ff ff       	call   800eb8 <nsipc>
}
  80100b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80100e:	c9                   	leave  
  80100f:	c3                   	ret    

00801010 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801010:	f3 0f 1e fb          	endbr32 
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801022:	8b 45 0c             	mov    0xc(%ebp),%eax
  801025:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80102a:	b8 06 00 00 00       	mov    $0x6,%eax
  80102f:	e8 84 fe ff ff       	call   800eb8 <nsipc>
}
  801034:	c9                   	leave  
  801035:	c3                   	ret    

00801036 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801036:	f3 0f 1e fb          	endbr32 
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	56                   	push   %esi
  80103e:	53                   	push   %ebx
  80103f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80104a:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801050:	8b 45 14             	mov    0x14(%ebp),%eax
  801053:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801058:	b8 07 00 00 00       	mov    $0x7,%eax
  80105d:	e8 56 fe ff ff       	call   800eb8 <nsipc>
  801062:	89 c3                	mov    %eax,%ebx
  801064:	85 c0                	test   %eax,%eax
  801066:	78 26                	js     80108e <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801068:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  80106e:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801073:	0f 4e c6             	cmovle %esi,%eax
  801076:	39 c3                	cmp    %eax,%ebx
  801078:	7f 1d                	jg     801097 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80107a:	83 ec 04             	sub    $0x4,%esp
  80107d:	53                   	push   %ebx
  80107e:	68 00 60 80 00       	push   $0x806000
  801083:	ff 75 0c             	pushl  0xc(%ebp)
  801086:	e8 54 0e 00 00       	call   801edf <memmove>
  80108b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80108e:	89 d8                	mov    %ebx,%eax
  801090:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801093:	5b                   	pop    %ebx
  801094:	5e                   	pop    %esi
  801095:	5d                   	pop    %ebp
  801096:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801097:	68 67 25 80 00       	push   $0x802567
  80109c:	68 2f 25 80 00       	push   $0x80252f
  8010a1:	6a 62                	push   $0x62
  8010a3:	68 7c 25 80 00       	push   $0x80257c
  8010a8:	e8 8b 05 00 00       	call   801638 <_panic>

008010ad <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8010ad:	f3 0f 1e fb          	endbr32 
  8010b1:	55                   	push   %ebp
  8010b2:	89 e5                	mov    %esp,%ebp
  8010b4:	53                   	push   %ebx
  8010b5:	83 ec 04             	sub    $0x4,%esp
  8010b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8010c3:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8010c9:	7f 2e                	jg     8010f9 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8010cb:	83 ec 04             	sub    $0x4,%esp
  8010ce:	53                   	push   %ebx
  8010cf:	ff 75 0c             	pushl  0xc(%ebp)
  8010d2:	68 0c 60 80 00       	push   $0x80600c
  8010d7:	e8 03 0e 00 00       	call   801edf <memmove>
	nsipcbuf.send.req_size = size;
  8010dc:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8010e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e5:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8010ea:	b8 08 00 00 00       	mov    $0x8,%eax
  8010ef:	e8 c4 fd ff ff       	call   800eb8 <nsipc>
}
  8010f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010f7:	c9                   	leave  
  8010f8:	c3                   	ret    
	assert(size < 1600);
  8010f9:	68 88 25 80 00       	push   $0x802588
  8010fe:	68 2f 25 80 00       	push   $0x80252f
  801103:	6a 6d                	push   $0x6d
  801105:	68 7c 25 80 00       	push   $0x80257c
  80110a:	e8 29 05 00 00       	call   801638 <_panic>

0080110f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80110f:	f3 0f 1e fb          	endbr32 
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
  801116:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801121:	8b 45 0c             	mov    0xc(%ebp),%eax
  801124:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801129:	8b 45 10             	mov    0x10(%ebp),%eax
  80112c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801131:	b8 09 00 00 00       	mov    $0x9,%eax
  801136:	e8 7d fd ff ff       	call   800eb8 <nsipc>
}
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    

0080113d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80113d:	f3 0f 1e fb          	endbr32 
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	56                   	push   %esi
  801145:	53                   	push   %ebx
  801146:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801149:	83 ec 0c             	sub    $0xc,%esp
  80114c:	ff 75 08             	pushl  0x8(%ebp)
  80114f:	e8 f6 f2 ff ff       	call   80044a <fd2data>
  801154:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801156:	83 c4 08             	add    $0x8,%esp
  801159:	68 94 25 80 00       	push   $0x802594
  80115e:	53                   	push   %ebx
  80115f:	e8 c5 0b 00 00       	call   801d29 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801164:	8b 46 04             	mov    0x4(%esi),%eax
  801167:	2b 06                	sub    (%esi),%eax
  801169:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80116f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801176:	00 00 00 
	stat->st_dev = &devpipe;
  801179:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801180:	30 80 00 
	return 0;
}
  801183:	b8 00 00 00 00       	mov    $0x0,%eax
  801188:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80118b:	5b                   	pop    %ebx
  80118c:	5e                   	pop    %esi
  80118d:	5d                   	pop    %ebp
  80118e:	c3                   	ret    

0080118f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80118f:	f3 0f 1e fb          	endbr32 
  801193:	55                   	push   %ebp
  801194:	89 e5                	mov    %esp,%ebp
  801196:	53                   	push   %ebx
  801197:	83 ec 0c             	sub    $0xc,%esp
  80119a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80119d:	53                   	push   %ebx
  80119e:	6a 00                	push   $0x0
  8011a0:	e8 5e f0 ff ff       	call   800203 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8011a5:	89 1c 24             	mov    %ebx,(%esp)
  8011a8:	e8 9d f2 ff ff       	call   80044a <fd2data>
  8011ad:	83 c4 08             	add    $0x8,%esp
  8011b0:	50                   	push   %eax
  8011b1:	6a 00                	push   $0x0
  8011b3:	e8 4b f0 ff ff       	call   800203 <sys_page_unmap>
}
  8011b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011bb:	c9                   	leave  
  8011bc:	c3                   	ret    

008011bd <_pipeisclosed>:
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	57                   	push   %edi
  8011c1:	56                   	push   %esi
  8011c2:	53                   	push   %ebx
  8011c3:	83 ec 1c             	sub    $0x1c,%esp
  8011c6:	89 c7                	mov    %eax,%edi
  8011c8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8011ca:	a1 08 40 80 00       	mov    0x804008,%eax
  8011cf:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8011d2:	83 ec 0c             	sub    $0xc,%esp
  8011d5:	57                   	push   %edi
  8011d6:	e8 da 0f 00 00       	call   8021b5 <pageref>
  8011db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011de:	89 34 24             	mov    %esi,(%esp)
  8011e1:	e8 cf 0f 00 00       	call   8021b5 <pageref>
		nn = thisenv->env_runs;
  8011e6:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8011ec:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8011ef:	83 c4 10             	add    $0x10,%esp
  8011f2:	39 cb                	cmp    %ecx,%ebx
  8011f4:	74 1b                	je     801211 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8011f6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8011f9:	75 cf                	jne    8011ca <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8011fb:	8b 42 58             	mov    0x58(%edx),%eax
  8011fe:	6a 01                	push   $0x1
  801200:	50                   	push   %eax
  801201:	53                   	push   %ebx
  801202:	68 9b 25 80 00       	push   $0x80259b
  801207:	e8 13 05 00 00       	call   80171f <cprintf>
  80120c:	83 c4 10             	add    $0x10,%esp
  80120f:	eb b9                	jmp    8011ca <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801211:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801214:	0f 94 c0             	sete   %al
  801217:	0f b6 c0             	movzbl %al,%eax
}
  80121a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80121d:	5b                   	pop    %ebx
  80121e:	5e                   	pop    %esi
  80121f:	5f                   	pop    %edi
  801220:	5d                   	pop    %ebp
  801221:	c3                   	ret    

00801222 <devpipe_write>:
{
  801222:	f3 0f 1e fb          	endbr32 
  801226:	55                   	push   %ebp
  801227:	89 e5                	mov    %esp,%ebp
  801229:	57                   	push   %edi
  80122a:	56                   	push   %esi
  80122b:	53                   	push   %ebx
  80122c:	83 ec 28             	sub    $0x28,%esp
  80122f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801232:	56                   	push   %esi
  801233:	e8 12 f2 ff ff       	call   80044a <fd2data>
  801238:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80123a:	83 c4 10             	add    $0x10,%esp
  80123d:	bf 00 00 00 00       	mov    $0x0,%edi
  801242:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801245:	74 4f                	je     801296 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801247:	8b 43 04             	mov    0x4(%ebx),%eax
  80124a:	8b 0b                	mov    (%ebx),%ecx
  80124c:	8d 51 20             	lea    0x20(%ecx),%edx
  80124f:	39 d0                	cmp    %edx,%eax
  801251:	72 14                	jb     801267 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801253:	89 da                	mov    %ebx,%edx
  801255:	89 f0                	mov    %esi,%eax
  801257:	e8 61 ff ff ff       	call   8011bd <_pipeisclosed>
  80125c:	85 c0                	test   %eax,%eax
  80125e:	75 3b                	jne    80129b <devpipe_write+0x79>
			sys_yield();
  801260:	e8 ee ee ff ff       	call   800153 <sys_yield>
  801265:	eb e0                	jmp    801247 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801267:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80126a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80126e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801271:	89 c2                	mov    %eax,%edx
  801273:	c1 fa 1f             	sar    $0x1f,%edx
  801276:	89 d1                	mov    %edx,%ecx
  801278:	c1 e9 1b             	shr    $0x1b,%ecx
  80127b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80127e:	83 e2 1f             	and    $0x1f,%edx
  801281:	29 ca                	sub    %ecx,%edx
  801283:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801287:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80128b:	83 c0 01             	add    $0x1,%eax
  80128e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801291:	83 c7 01             	add    $0x1,%edi
  801294:	eb ac                	jmp    801242 <devpipe_write+0x20>
	return i;
  801296:	8b 45 10             	mov    0x10(%ebp),%eax
  801299:	eb 05                	jmp    8012a0 <devpipe_write+0x7e>
				return 0;
  80129b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a3:	5b                   	pop    %ebx
  8012a4:	5e                   	pop    %esi
  8012a5:	5f                   	pop    %edi
  8012a6:	5d                   	pop    %ebp
  8012a7:	c3                   	ret    

008012a8 <devpipe_read>:
{
  8012a8:	f3 0f 1e fb          	endbr32 
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	57                   	push   %edi
  8012b0:	56                   	push   %esi
  8012b1:	53                   	push   %ebx
  8012b2:	83 ec 18             	sub    $0x18,%esp
  8012b5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8012b8:	57                   	push   %edi
  8012b9:	e8 8c f1 ff ff       	call   80044a <fd2data>
  8012be:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8012c0:	83 c4 10             	add    $0x10,%esp
  8012c3:	be 00 00 00 00       	mov    $0x0,%esi
  8012c8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8012cb:	75 14                	jne    8012e1 <devpipe_read+0x39>
	return i;
  8012cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d0:	eb 02                	jmp    8012d4 <devpipe_read+0x2c>
				return i;
  8012d2:	89 f0                	mov    %esi,%eax
}
  8012d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d7:	5b                   	pop    %ebx
  8012d8:	5e                   	pop    %esi
  8012d9:	5f                   	pop    %edi
  8012da:	5d                   	pop    %ebp
  8012db:	c3                   	ret    
			sys_yield();
  8012dc:	e8 72 ee ff ff       	call   800153 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8012e1:	8b 03                	mov    (%ebx),%eax
  8012e3:	3b 43 04             	cmp    0x4(%ebx),%eax
  8012e6:	75 18                	jne    801300 <devpipe_read+0x58>
			if (i > 0)
  8012e8:	85 f6                	test   %esi,%esi
  8012ea:	75 e6                	jne    8012d2 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8012ec:	89 da                	mov    %ebx,%edx
  8012ee:	89 f8                	mov    %edi,%eax
  8012f0:	e8 c8 fe ff ff       	call   8011bd <_pipeisclosed>
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	74 e3                	je     8012dc <devpipe_read+0x34>
				return 0;
  8012f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fe:	eb d4                	jmp    8012d4 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801300:	99                   	cltd   
  801301:	c1 ea 1b             	shr    $0x1b,%edx
  801304:	01 d0                	add    %edx,%eax
  801306:	83 e0 1f             	and    $0x1f,%eax
  801309:	29 d0                	sub    %edx,%eax
  80130b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801310:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801313:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801316:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801319:	83 c6 01             	add    $0x1,%esi
  80131c:	eb aa                	jmp    8012c8 <devpipe_read+0x20>

0080131e <pipe>:
{
  80131e:	f3 0f 1e fb          	endbr32 
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
  801325:	56                   	push   %esi
  801326:	53                   	push   %ebx
  801327:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80132a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80132d:	50                   	push   %eax
  80132e:	e8 32 f1 ff ff       	call   800465 <fd_alloc>
  801333:	89 c3                	mov    %eax,%ebx
  801335:	83 c4 10             	add    $0x10,%esp
  801338:	85 c0                	test   %eax,%eax
  80133a:	0f 88 23 01 00 00    	js     801463 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801340:	83 ec 04             	sub    $0x4,%esp
  801343:	68 07 04 00 00       	push   $0x407
  801348:	ff 75 f4             	pushl  -0xc(%ebp)
  80134b:	6a 00                	push   $0x0
  80134d:	e8 24 ee ff ff       	call   800176 <sys_page_alloc>
  801352:	89 c3                	mov    %eax,%ebx
  801354:	83 c4 10             	add    $0x10,%esp
  801357:	85 c0                	test   %eax,%eax
  801359:	0f 88 04 01 00 00    	js     801463 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80135f:	83 ec 0c             	sub    $0xc,%esp
  801362:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801365:	50                   	push   %eax
  801366:	e8 fa f0 ff ff       	call   800465 <fd_alloc>
  80136b:	89 c3                	mov    %eax,%ebx
  80136d:	83 c4 10             	add    $0x10,%esp
  801370:	85 c0                	test   %eax,%eax
  801372:	0f 88 db 00 00 00    	js     801453 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801378:	83 ec 04             	sub    $0x4,%esp
  80137b:	68 07 04 00 00       	push   $0x407
  801380:	ff 75 f0             	pushl  -0x10(%ebp)
  801383:	6a 00                	push   $0x0
  801385:	e8 ec ed ff ff       	call   800176 <sys_page_alloc>
  80138a:	89 c3                	mov    %eax,%ebx
  80138c:	83 c4 10             	add    $0x10,%esp
  80138f:	85 c0                	test   %eax,%eax
  801391:	0f 88 bc 00 00 00    	js     801453 <pipe+0x135>
	va = fd2data(fd0);
  801397:	83 ec 0c             	sub    $0xc,%esp
  80139a:	ff 75 f4             	pushl  -0xc(%ebp)
  80139d:	e8 a8 f0 ff ff       	call   80044a <fd2data>
  8013a2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013a4:	83 c4 0c             	add    $0xc,%esp
  8013a7:	68 07 04 00 00       	push   $0x407
  8013ac:	50                   	push   %eax
  8013ad:	6a 00                	push   $0x0
  8013af:	e8 c2 ed ff ff       	call   800176 <sys_page_alloc>
  8013b4:	89 c3                	mov    %eax,%ebx
  8013b6:	83 c4 10             	add    $0x10,%esp
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	0f 88 82 00 00 00    	js     801443 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013c1:	83 ec 0c             	sub    $0xc,%esp
  8013c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8013c7:	e8 7e f0 ff ff       	call   80044a <fd2data>
  8013cc:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8013d3:	50                   	push   %eax
  8013d4:	6a 00                	push   $0x0
  8013d6:	56                   	push   %esi
  8013d7:	6a 00                	push   $0x0
  8013d9:	e8 df ed ff ff       	call   8001bd <sys_page_map>
  8013de:	89 c3                	mov    %eax,%ebx
  8013e0:	83 c4 20             	add    $0x20,%esp
  8013e3:	85 c0                	test   %eax,%eax
  8013e5:	78 4e                	js     801435 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8013e7:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8013ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ef:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8013f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f4:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8013fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013fe:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801403:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80140a:	83 ec 0c             	sub    $0xc,%esp
  80140d:	ff 75 f4             	pushl  -0xc(%ebp)
  801410:	e8 21 f0 ff ff       	call   800436 <fd2num>
  801415:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801418:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80141a:	83 c4 04             	add    $0x4,%esp
  80141d:	ff 75 f0             	pushl  -0x10(%ebp)
  801420:	e8 11 f0 ff ff       	call   800436 <fd2num>
  801425:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801428:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80142b:	83 c4 10             	add    $0x10,%esp
  80142e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801433:	eb 2e                	jmp    801463 <pipe+0x145>
	sys_page_unmap(0, va);
  801435:	83 ec 08             	sub    $0x8,%esp
  801438:	56                   	push   %esi
  801439:	6a 00                	push   $0x0
  80143b:	e8 c3 ed ff ff       	call   800203 <sys_page_unmap>
  801440:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801443:	83 ec 08             	sub    $0x8,%esp
  801446:	ff 75 f0             	pushl  -0x10(%ebp)
  801449:	6a 00                	push   $0x0
  80144b:	e8 b3 ed ff ff       	call   800203 <sys_page_unmap>
  801450:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801453:	83 ec 08             	sub    $0x8,%esp
  801456:	ff 75 f4             	pushl  -0xc(%ebp)
  801459:	6a 00                	push   $0x0
  80145b:	e8 a3 ed ff ff       	call   800203 <sys_page_unmap>
  801460:	83 c4 10             	add    $0x10,%esp
}
  801463:	89 d8                	mov    %ebx,%eax
  801465:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801468:	5b                   	pop    %ebx
  801469:	5e                   	pop    %esi
  80146a:	5d                   	pop    %ebp
  80146b:	c3                   	ret    

0080146c <pipeisclosed>:
{
  80146c:	f3 0f 1e fb          	endbr32 
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801476:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801479:	50                   	push   %eax
  80147a:	ff 75 08             	pushl  0x8(%ebp)
  80147d:	e8 39 f0 ff ff       	call   8004bb <fd_lookup>
  801482:	83 c4 10             	add    $0x10,%esp
  801485:	85 c0                	test   %eax,%eax
  801487:	78 18                	js     8014a1 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801489:	83 ec 0c             	sub    $0xc,%esp
  80148c:	ff 75 f4             	pushl  -0xc(%ebp)
  80148f:	e8 b6 ef ff ff       	call   80044a <fd2data>
  801494:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801499:	e8 1f fd ff ff       	call   8011bd <_pipeisclosed>
  80149e:	83 c4 10             	add    $0x10,%esp
}
  8014a1:	c9                   	leave  
  8014a2:	c3                   	ret    

008014a3 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8014a3:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8014a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ac:	c3                   	ret    

008014ad <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8014ad:	f3 0f 1e fb          	endbr32 
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
  8014b4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8014b7:	68 b3 25 80 00       	push   $0x8025b3
  8014bc:	ff 75 0c             	pushl  0xc(%ebp)
  8014bf:	e8 65 08 00 00       	call   801d29 <strcpy>
	return 0;
}
  8014c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <devcons_write>:
{
  8014cb:	f3 0f 1e fb          	endbr32 
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	57                   	push   %edi
  8014d3:	56                   	push   %esi
  8014d4:	53                   	push   %ebx
  8014d5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8014db:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8014e0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8014e6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8014e9:	73 31                	jae    80151c <devcons_write+0x51>
		m = n - tot;
  8014eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014ee:	29 f3                	sub    %esi,%ebx
  8014f0:	83 fb 7f             	cmp    $0x7f,%ebx
  8014f3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8014f8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8014fb:	83 ec 04             	sub    $0x4,%esp
  8014fe:	53                   	push   %ebx
  8014ff:	89 f0                	mov    %esi,%eax
  801501:	03 45 0c             	add    0xc(%ebp),%eax
  801504:	50                   	push   %eax
  801505:	57                   	push   %edi
  801506:	e8 d4 09 00 00       	call   801edf <memmove>
		sys_cputs(buf, m);
  80150b:	83 c4 08             	add    $0x8,%esp
  80150e:	53                   	push   %ebx
  80150f:	57                   	push   %edi
  801510:	e8 91 eb ff ff       	call   8000a6 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801515:	01 de                	add    %ebx,%esi
  801517:	83 c4 10             	add    $0x10,%esp
  80151a:	eb ca                	jmp    8014e6 <devcons_write+0x1b>
}
  80151c:	89 f0                	mov    %esi,%eax
  80151e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801521:	5b                   	pop    %ebx
  801522:	5e                   	pop    %esi
  801523:	5f                   	pop    %edi
  801524:	5d                   	pop    %ebp
  801525:	c3                   	ret    

00801526 <devcons_read>:
{
  801526:	f3 0f 1e fb          	endbr32 
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	83 ec 08             	sub    $0x8,%esp
  801530:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801535:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801539:	74 21                	je     80155c <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80153b:	e8 88 eb ff ff       	call   8000c8 <sys_cgetc>
  801540:	85 c0                	test   %eax,%eax
  801542:	75 07                	jne    80154b <devcons_read+0x25>
		sys_yield();
  801544:	e8 0a ec ff ff       	call   800153 <sys_yield>
  801549:	eb f0                	jmp    80153b <devcons_read+0x15>
	if (c < 0)
  80154b:	78 0f                	js     80155c <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80154d:	83 f8 04             	cmp    $0x4,%eax
  801550:	74 0c                	je     80155e <devcons_read+0x38>
	*(char*)vbuf = c;
  801552:	8b 55 0c             	mov    0xc(%ebp),%edx
  801555:	88 02                	mov    %al,(%edx)
	return 1;
  801557:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    
		return 0;
  80155e:	b8 00 00 00 00       	mov    $0x0,%eax
  801563:	eb f7                	jmp    80155c <devcons_read+0x36>

00801565 <cputchar>:
{
  801565:	f3 0f 1e fb          	endbr32 
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80156f:	8b 45 08             	mov    0x8(%ebp),%eax
  801572:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801575:	6a 01                	push   $0x1
  801577:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80157a:	50                   	push   %eax
  80157b:	e8 26 eb ff ff       	call   8000a6 <sys_cputs>
}
  801580:	83 c4 10             	add    $0x10,%esp
  801583:	c9                   	leave  
  801584:	c3                   	ret    

00801585 <getchar>:
{
  801585:	f3 0f 1e fb          	endbr32 
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80158f:	6a 01                	push   $0x1
  801591:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801594:	50                   	push   %eax
  801595:	6a 00                	push   $0x0
  801597:	e8 a7 f1 ff ff       	call   800743 <read>
	if (r < 0)
  80159c:	83 c4 10             	add    $0x10,%esp
  80159f:	85 c0                	test   %eax,%eax
  8015a1:	78 06                	js     8015a9 <getchar+0x24>
	if (r < 1)
  8015a3:	74 06                	je     8015ab <getchar+0x26>
	return c;
  8015a5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    
		return -E_EOF;
  8015ab:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8015b0:	eb f7                	jmp    8015a9 <getchar+0x24>

008015b2 <iscons>:
{
  8015b2:	f3 0f 1e fb          	endbr32 
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015bf:	50                   	push   %eax
  8015c0:	ff 75 08             	pushl  0x8(%ebp)
  8015c3:	e8 f3 ee ff ff       	call   8004bb <fd_lookup>
  8015c8:	83 c4 10             	add    $0x10,%esp
  8015cb:	85 c0                	test   %eax,%eax
  8015cd:	78 11                	js     8015e0 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8015cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8015d8:	39 10                	cmp    %edx,(%eax)
  8015da:	0f 94 c0             	sete   %al
  8015dd:	0f b6 c0             	movzbl %al,%eax
}
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <opencons>:
{
  8015e2:	f3 0f 1e fb          	endbr32 
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
  8015e9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8015ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ef:	50                   	push   %eax
  8015f0:	e8 70 ee ff ff       	call   800465 <fd_alloc>
  8015f5:	83 c4 10             	add    $0x10,%esp
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	78 3a                	js     801636 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8015fc:	83 ec 04             	sub    $0x4,%esp
  8015ff:	68 07 04 00 00       	push   $0x407
  801604:	ff 75 f4             	pushl  -0xc(%ebp)
  801607:	6a 00                	push   $0x0
  801609:	e8 68 eb ff ff       	call   800176 <sys_page_alloc>
  80160e:	83 c4 10             	add    $0x10,%esp
  801611:	85 c0                	test   %eax,%eax
  801613:	78 21                	js     801636 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801618:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80161e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801623:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80162a:	83 ec 0c             	sub    $0xc,%esp
  80162d:	50                   	push   %eax
  80162e:	e8 03 ee ff ff       	call   800436 <fd2num>
  801633:	83 c4 10             	add    $0x10,%esp
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801638:	f3 0f 1e fb          	endbr32 
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	56                   	push   %esi
  801640:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801641:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801644:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80164a:	e8 e1 ea ff ff       	call   800130 <sys_getenvid>
  80164f:	83 ec 0c             	sub    $0xc,%esp
  801652:	ff 75 0c             	pushl  0xc(%ebp)
  801655:	ff 75 08             	pushl  0x8(%ebp)
  801658:	56                   	push   %esi
  801659:	50                   	push   %eax
  80165a:	68 c0 25 80 00       	push   $0x8025c0
  80165f:	e8 bb 00 00 00       	call   80171f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801664:	83 c4 18             	add    $0x18,%esp
  801667:	53                   	push   %ebx
  801668:	ff 75 10             	pushl  0x10(%ebp)
  80166b:	e8 5a 00 00 00       	call   8016ca <vcprintf>
	cprintf("\n");
  801670:	c7 04 24 f8 28 80 00 	movl   $0x8028f8,(%esp)
  801677:	e8 a3 00 00 00       	call   80171f <cprintf>
  80167c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80167f:	cc                   	int3   
  801680:	eb fd                	jmp    80167f <_panic+0x47>

00801682 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801682:	f3 0f 1e fb          	endbr32 
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	53                   	push   %ebx
  80168a:	83 ec 04             	sub    $0x4,%esp
  80168d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801690:	8b 13                	mov    (%ebx),%edx
  801692:	8d 42 01             	lea    0x1(%edx),%eax
  801695:	89 03                	mov    %eax,(%ebx)
  801697:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80169a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80169e:	3d ff 00 00 00       	cmp    $0xff,%eax
  8016a3:	74 09                	je     8016ae <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8016a5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8016a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8016ae:	83 ec 08             	sub    $0x8,%esp
  8016b1:	68 ff 00 00 00       	push   $0xff
  8016b6:	8d 43 08             	lea    0x8(%ebx),%eax
  8016b9:	50                   	push   %eax
  8016ba:	e8 e7 e9 ff ff       	call   8000a6 <sys_cputs>
		b->idx = 0;
  8016bf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8016c5:	83 c4 10             	add    $0x10,%esp
  8016c8:	eb db                	jmp    8016a5 <putch+0x23>

008016ca <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8016ca:	f3 0f 1e fb          	endbr32 
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8016d7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8016de:	00 00 00 
	b.cnt = 0;
  8016e1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8016e8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8016eb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ee:	ff 75 08             	pushl  0x8(%ebp)
  8016f1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8016f7:	50                   	push   %eax
  8016f8:	68 82 16 80 00       	push   $0x801682
  8016fd:	e8 20 01 00 00       	call   801822 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801702:	83 c4 08             	add    $0x8,%esp
  801705:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80170b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801711:	50                   	push   %eax
  801712:	e8 8f e9 ff ff       	call   8000a6 <sys_cputs>

	return b.cnt;
}
  801717:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80171f:	f3 0f 1e fb          	endbr32 
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801729:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80172c:	50                   	push   %eax
  80172d:	ff 75 08             	pushl  0x8(%ebp)
  801730:	e8 95 ff ff ff       	call   8016ca <vcprintf>
	va_end(ap);

	return cnt;
}
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	57                   	push   %edi
  80173b:	56                   	push   %esi
  80173c:	53                   	push   %ebx
  80173d:	83 ec 1c             	sub    $0x1c,%esp
  801740:	89 c7                	mov    %eax,%edi
  801742:	89 d6                	mov    %edx,%esi
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174a:	89 d1                	mov    %edx,%ecx
  80174c:	89 c2                	mov    %eax,%edx
  80174e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801751:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801754:	8b 45 10             	mov    0x10(%ebp),%eax
  801757:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80175a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80175d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801764:	39 c2                	cmp    %eax,%edx
  801766:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  801769:	72 3e                	jb     8017a9 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80176b:	83 ec 0c             	sub    $0xc,%esp
  80176e:	ff 75 18             	pushl  0x18(%ebp)
  801771:	83 eb 01             	sub    $0x1,%ebx
  801774:	53                   	push   %ebx
  801775:	50                   	push   %eax
  801776:	83 ec 08             	sub    $0x8,%esp
  801779:	ff 75 e4             	pushl  -0x1c(%ebp)
  80177c:	ff 75 e0             	pushl  -0x20(%ebp)
  80177f:	ff 75 dc             	pushl  -0x24(%ebp)
  801782:	ff 75 d8             	pushl  -0x28(%ebp)
  801785:	e8 76 0a 00 00       	call   802200 <__udivdi3>
  80178a:	83 c4 18             	add    $0x18,%esp
  80178d:	52                   	push   %edx
  80178e:	50                   	push   %eax
  80178f:	89 f2                	mov    %esi,%edx
  801791:	89 f8                	mov    %edi,%eax
  801793:	e8 9f ff ff ff       	call   801737 <printnum>
  801798:	83 c4 20             	add    $0x20,%esp
  80179b:	eb 13                	jmp    8017b0 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80179d:	83 ec 08             	sub    $0x8,%esp
  8017a0:	56                   	push   %esi
  8017a1:	ff 75 18             	pushl  0x18(%ebp)
  8017a4:	ff d7                	call   *%edi
  8017a6:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8017a9:	83 eb 01             	sub    $0x1,%ebx
  8017ac:	85 db                	test   %ebx,%ebx
  8017ae:	7f ed                	jg     80179d <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8017b0:	83 ec 08             	sub    $0x8,%esp
  8017b3:	56                   	push   %esi
  8017b4:	83 ec 04             	sub    $0x4,%esp
  8017b7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017ba:	ff 75 e0             	pushl  -0x20(%ebp)
  8017bd:	ff 75 dc             	pushl  -0x24(%ebp)
  8017c0:	ff 75 d8             	pushl  -0x28(%ebp)
  8017c3:	e8 48 0b 00 00       	call   802310 <__umoddi3>
  8017c8:	83 c4 14             	add    $0x14,%esp
  8017cb:	0f be 80 e3 25 80 00 	movsbl 0x8025e3(%eax),%eax
  8017d2:	50                   	push   %eax
  8017d3:	ff d7                	call   *%edi
}
  8017d5:	83 c4 10             	add    $0x10,%esp
  8017d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017db:	5b                   	pop    %ebx
  8017dc:	5e                   	pop    %esi
  8017dd:	5f                   	pop    %edi
  8017de:	5d                   	pop    %ebp
  8017df:	c3                   	ret    

008017e0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8017e0:	f3 0f 1e fb          	endbr32 
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8017ea:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8017ee:	8b 10                	mov    (%eax),%edx
  8017f0:	3b 50 04             	cmp    0x4(%eax),%edx
  8017f3:	73 0a                	jae    8017ff <sprintputch+0x1f>
		*b->buf++ = ch;
  8017f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017f8:	89 08                	mov    %ecx,(%eax)
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	88 02                	mov    %al,(%edx)
}
  8017ff:	5d                   	pop    %ebp
  801800:	c3                   	ret    

00801801 <printfmt>:
{
  801801:	f3 0f 1e fb          	endbr32 
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80180b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80180e:	50                   	push   %eax
  80180f:	ff 75 10             	pushl  0x10(%ebp)
  801812:	ff 75 0c             	pushl  0xc(%ebp)
  801815:	ff 75 08             	pushl  0x8(%ebp)
  801818:	e8 05 00 00 00       	call   801822 <vprintfmt>
}
  80181d:	83 c4 10             	add    $0x10,%esp
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <vprintfmt>:
{
  801822:	f3 0f 1e fb          	endbr32 
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	57                   	push   %edi
  80182a:	56                   	push   %esi
  80182b:	53                   	push   %ebx
  80182c:	83 ec 3c             	sub    $0x3c,%esp
  80182f:	8b 75 08             	mov    0x8(%ebp),%esi
  801832:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801835:	8b 7d 10             	mov    0x10(%ebp),%edi
  801838:	e9 8e 03 00 00       	jmp    801bcb <vprintfmt+0x3a9>
		padc = ' ';
  80183d:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801841:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801848:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80184f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801856:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80185b:	8d 47 01             	lea    0x1(%edi),%eax
  80185e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801861:	0f b6 17             	movzbl (%edi),%edx
  801864:	8d 42 dd             	lea    -0x23(%edx),%eax
  801867:	3c 55                	cmp    $0x55,%al
  801869:	0f 87 df 03 00 00    	ja     801c4e <vprintfmt+0x42c>
  80186f:	0f b6 c0             	movzbl %al,%eax
  801872:	3e ff 24 85 20 27 80 	notrack jmp *0x802720(,%eax,4)
  801879:	00 
  80187a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80187d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801881:	eb d8                	jmp    80185b <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801883:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801886:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80188a:	eb cf                	jmp    80185b <vprintfmt+0x39>
  80188c:	0f b6 d2             	movzbl %dl,%edx
  80188f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801892:	b8 00 00 00 00       	mov    $0x0,%eax
  801897:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80189a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80189d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8018a1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8018a4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8018a7:	83 f9 09             	cmp    $0x9,%ecx
  8018aa:	77 55                	ja     801901 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8018ac:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8018af:	eb e9                	jmp    80189a <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8018b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b4:	8b 00                	mov    (%eax),%eax
  8018b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8018bc:	8d 40 04             	lea    0x4(%eax),%eax
  8018bf:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8018c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8018c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018c9:	79 90                	jns    80185b <vprintfmt+0x39>
				width = precision, precision = -1;
  8018cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8018d1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8018d8:	eb 81                	jmp    80185b <vprintfmt+0x39>
  8018da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018dd:	85 c0                	test   %eax,%eax
  8018df:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e4:	0f 49 d0             	cmovns %eax,%edx
  8018e7:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8018ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8018ed:	e9 69 ff ff ff       	jmp    80185b <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8018f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8018f5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8018fc:	e9 5a ff ff ff       	jmp    80185b <vprintfmt+0x39>
  801901:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801904:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801907:	eb bc                	jmp    8018c5 <vprintfmt+0xa3>
			lflag++;
  801909:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80190c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80190f:	e9 47 ff ff ff       	jmp    80185b <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  801914:	8b 45 14             	mov    0x14(%ebp),%eax
  801917:	8d 78 04             	lea    0x4(%eax),%edi
  80191a:	83 ec 08             	sub    $0x8,%esp
  80191d:	53                   	push   %ebx
  80191e:	ff 30                	pushl  (%eax)
  801920:	ff d6                	call   *%esi
			break;
  801922:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801925:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801928:	e9 9b 02 00 00       	jmp    801bc8 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80192d:	8b 45 14             	mov    0x14(%ebp),%eax
  801930:	8d 78 04             	lea    0x4(%eax),%edi
  801933:	8b 00                	mov    (%eax),%eax
  801935:	99                   	cltd   
  801936:	31 d0                	xor    %edx,%eax
  801938:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80193a:	83 f8 0f             	cmp    $0xf,%eax
  80193d:	7f 23                	jg     801962 <vprintfmt+0x140>
  80193f:	8b 14 85 80 28 80 00 	mov    0x802880(,%eax,4),%edx
  801946:	85 d2                	test   %edx,%edx
  801948:	74 18                	je     801962 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80194a:	52                   	push   %edx
  80194b:	68 41 25 80 00       	push   $0x802541
  801950:	53                   	push   %ebx
  801951:	56                   	push   %esi
  801952:	e8 aa fe ff ff       	call   801801 <printfmt>
  801957:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80195a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80195d:	e9 66 02 00 00       	jmp    801bc8 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  801962:	50                   	push   %eax
  801963:	68 fb 25 80 00       	push   $0x8025fb
  801968:	53                   	push   %ebx
  801969:	56                   	push   %esi
  80196a:	e8 92 fe ff ff       	call   801801 <printfmt>
  80196f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801972:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801975:	e9 4e 02 00 00       	jmp    801bc8 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80197a:	8b 45 14             	mov    0x14(%ebp),%eax
  80197d:	83 c0 04             	add    $0x4,%eax
  801980:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801983:	8b 45 14             	mov    0x14(%ebp),%eax
  801986:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801988:	85 d2                	test   %edx,%edx
  80198a:	b8 f4 25 80 00       	mov    $0x8025f4,%eax
  80198f:	0f 45 c2             	cmovne %edx,%eax
  801992:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801995:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801999:	7e 06                	jle    8019a1 <vprintfmt+0x17f>
  80199b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80199f:	75 0d                	jne    8019ae <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8019a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019a4:	89 c7                	mov    %eax,%edi
  8019a6:	03 45 e0             	add    -0x20(%ebp),%eax
  8019a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019ac:	eb 55                	jmp    801a03 <vprintfmt+0x1e1>
  8019ae:	83 ec 08             	sub    $0x8,%esp
  8019b1:	ff 75 d8             	pushl  -0x28(%ebp)
  8019b4:	ff 75 cc             	pushl  -0x34(%ebp)
  8019b7:	e8 46 03 00 00       	call   801d02 <strnlen>
  8019bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019bf:	29 c2                	sub    %eax,%edx
  8019c1:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8019c4:	83 c4 10             	add    $0x10,%esp
  8019c7:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8019c9:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8019cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8019d0:	85 ff                	test   %edi,%edi
  8019d2:	7e 11                	jle    8019e5 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8019d4:	83 ec 08             	sub    $0x8,%esp
  8019d7:	53                   	push   %ebx
  8019d8:	ff 75 e0             	pushl  -0x20(%ebp)
  8019db:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8019dd:	83 ef 01             	sub    $0x1,%edi
  8019e0:	83 c4 10             	add    $0x10,%esp
  8019e3:	eb eb                	jmp    8019d0 <vprintfmt+0x1ae>
  8019e5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8019e8:	85 d2                	test   %edx,%edx
  8019ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ef:	0f 49 c2             	cmovns %edx,%eax
  8019f2:	29 c2                	sub    %eax,%edx
  8019f4:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8019f7:	eb a8                	jmp    8019a1 <vprintfmt+0x17f>
					putch(ch, putdat);
  8019f9:	83 ec 08             	sub    $0x8,%esp
  8019fc:	53                   	push   %ebx
  8019fd:	52                   	push   %edx
  8019fe:	ff d6                	call   *%esi
  801a00:	83 c4 10             	add    $0x10,%esp
  801a03:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801a06:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a08:	83 c7 01             	add    $0x1,%edi
  801a0b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a0f:	0f be d0             	movsbl %al,%edx
  801a12:	85 d2                	test   %edx,%edx
  801a14:	74 4b                	je     801a61 <vprintfmt+0x23f>
  801a16:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801a1a:	78 06                	js     801a22 <vprintfmt+0x200>
  801a1c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801a20:	78 1e                	js     801a40 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  801a22:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801a26:	74 d1                	je     8019f9 <vprintfmt+0x1d7>
  801a28:	0f be c0             	movsbl %al,%eax
  801a2b:	83 e8 20             	sub    $0x20,%eax
  801a2e:	83 f8 5e             	cmp    $0x5e,%eax
  801a31:	76 c6                	jbe    8019f9 <vprintfmt+0x1d7>
					putch('?', putdat);
  801a33:	83 ec 08             	sub    $0x8,%esp
  801a36:	53                   	push   %ebx
  801a37:	6a 3f                	push   $0x3f
  801a39:	ff d6                	call   *%esi
  801a3b:	83 c4 10             	add    $0x10,%esp
  801a3e:	eb c3                	jmp    801a03 <vprintfmt+0x1e1>
  801a40:	89 cf                	mov    %ecx,%edi
  801a42:	eb 0e                	jmp    801a52 <vprintfmt+0x230>
				putch(' ', putdat);
  801a44:	83 ec 08             	sub    $0x8,%esp
  801a47:	53                   	push   %ebx
  801a48:	6a 20                	push   $0x20
  801a4a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801a4c:	83 ef 01             	sub    $0x1,%edi
  801a4f:	83 c4 10             	add    $0x10,%esp
  801a52:	85 ff                	test   %edi,%edi
  801a54:	7f ee                	jg     801a44 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  801a56:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a59:	89 45 14             	mov    %eax,0x14(%ebp)
  801a5c:	e9 67 01 00 00       	jmp    801bc8 <vprintfmt+0x3a6>
  801a61:	89 cf                	mov    %ecx,%edi
  801a63:	eb ed                	jmp    801a52 <vprintfmt+0x230>
	if (lflag >= 2)
  801a65:	83 f9 01             	cmp    $0x1,%ecx
  801a68:	7f 1b                	jg     801a85 <vprintfmt+0x263>
	else if (lflag)
  801a6a:	85 c9                	test   %ecx,%ecx
  801a6c:	74 63                	je     801ad1 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  801a6e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a71:	8b 00                	mov    (%eax),%eax
  801a73:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a76:	99                   	cltd   
  801a77:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7d:	8d 40 04             	lea    0x4(%eax),%eax
  801a80:	89 45 14             	mov    %eax,0x14(%ebp)
  801a83:	eb 17                	jmp    801a9c <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801a85:	8b 45 14             	mov    0x14(%ebp),%eax
  801a88:	8b 50 04             	mov    0x4(%eax),%edx
  801a8b:	8b 00                	mov    (%eax),%eax
  801a8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a90:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a93:	8b 45 14             	mov    0x14(%ebp),%eax
  801a96:	8d 40 08             	lea    0x8(%eax),%eax
  801a99:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801a9c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a9f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801aa2:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801aa7:	85 c9                	test   %ecx,%ecx
  801aa9:	0f 89 ff 00 00 00    	jns    801bae <vprintfmt+0x38c>
				putch('-', putdat);
  801aaf:	83 ec 08             	sub    $0x8,%esp
  801ab2:	53                   	push   %ebx
  801ab3:	6a 2d                	push   $0x2d
  801ab5:	ff d6                	call   *%esi
				num = -(long long) num;
  801ab7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801aba:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801abd:	f7 da                	neg    %edx
  801abf:	83 d1 00             	adc    $0x0,%ecx
  801ac2:	f7 d9                	neg    %ecx
  801ac4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801ac7:	b8 0a 00 00 00       	mov    $0xa,%eax
  801acc:	e9 dd 00 00 00       	jmp    801bae <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801ad1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad4:	8b 00                	mov    (%eax),%eax
  801ad6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ad9:	99                   	cltd   
  801ada:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801add:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae0:	8d 40 04             	lea    0x4(%eax),%eax
  801ae3:	89 45 14             	mov    %eax,0x14(%ebp)
  801ae6:	eb b4                	jmp    801a9c <vprintfmt+0x27a>
	if (lflag >= 2)
  801ae8:	83 f9 01             	cmp    $0x1,%ecx
  801aeb:	7f 1e                	jg     801b0b <vprintfmt+0x2e9>
	else if (lflag)
  801aed:	85 c9                	test   %ecx,%ecx
  801aef:	74 32                	je     801b23 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801af1:	8b 45 14             	mov    0x14(%ebp),%eax
  801af4:	8b 10                	mov    (%eax),%edx
  801af6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801afb:	8d 40 04             	lea    0x4(%eax),%eax
  801afe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b01:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801b06:	e9 a3 00 00 00       	jmp    801bae <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b0e:	8b 10                	mov    (%eax),%edx
  801b10:	8b 48 04             	mov    0x4(%eax),%ecx
  801b13:	8d 40 08             	lea    0x8(%eax),%eax
  801b16:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b19:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  801b1e:	e9 8b 00 00 00       	jmp    801bae <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b23:	8b 45 14             	mov    0x14(%ebp),%eax
  801b26:	8b 10                	mov    (%eax),%edx
  801b28:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b2d:	8d 40 04             	lea    0x4(%eax),%eax
  801b30:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b33:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  801b38:	eb 74                	jmp    801bae <vprintfmt+0x38c>
	if (lflag >= 2)
  801b3a:	83 f9 01             	cmp    $0x1,%ecx
  801b3d:	7f 1b                	jg     801b5a <vprintfmt+0x338>
	else if (lflag)
  801b3f:	85 c9                	test   %ecx,%ecx
  801b41:	74 2c                	je     801b6f <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801b43:	8b 45 14             	mov    0x14(%ebp),%eax
  801b46:	8b 10                	mov    (%eax),%edx
  801b48:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b4d:	8d 40 04             	lea    0x4(%eax),%eax
  801b50:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b53:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801b58:	eb 54                	jmp    801bae <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b5a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5d:	8b 10                	mov    (%eax),%edx
  801b5f:	8b 48 04             	mov    0x4(%eax),%ecx
  801b62:	8d 40 08             	lea    0x8(%eax),%eax
  801b65:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b68:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801b6d:	eb 3f                	jmp    801bae <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b6f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b72:	8b 10                	mov    (%eax),%edx
  801b74:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b79:	8d 40 04             	lea    0x4(%eax),%eax
  801b7c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b7f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801b84:	eb 28                	jmp    801bae <vprintfmt+0x38c>
			putch('0', putdat);
  801b86:	83 ec 08             	sub    $0x8,%esp
  801b89:	53                   	push   %ebx
  801b8a:	6a 30                	push   $0x30
  801b8c:	ff d6                	call   *%esi
			putch('x', putdat);
  801b8e:	83 c4 08             	add    $0x8,%esp
  801b91:	53                   	push   %ebx
  801b92:	6a 78                	push   $0x78
  801b94:	ff d6                	call   *%esi
			num = (unsigned long long)
  801b96:	8b 45 14             	mov    0x14(%ebp),%eax
  801b99:	8b 10                	mov    (%eax),%edx
  801b9b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801ba0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801ba3:	8d 40 04             	lea    0x4(%eax),%eax
  801ba6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ba9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801bae:	83 ec 0c             	sub    $0xc,%esp
  801bb1:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801bb5:	57                   	push   %edi
  801bb6:	ff 75 e0             	pushl  -0x20(%ebp)
  801bb9:	50                   	push   %eax
  801bba:	51                   	push   %ecx
  801bbb:	52                   	push   %edx
  801bbc:	89 da                	mov    %ebx,%edx
  801bbe:	89 f0                	mov    %esi,%eax
  801bc0:	e8 72 fb ff ff       	call   801737 <printnum>
			break;
  801bc5:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801bc8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801bcb:	83 c7 01             	add    $0x1,%edi
  801bce:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801bd2:	83 f8 25             	cmp    $0x25,%eax
  801bd5:	0f 84 62 fc ff ff    	je     80183d <vprintfmt+0x1b>
			if (ch == '\0')
  801bdb:	85 c0                	test   %eax,%eax
  801bdd:	0f 84 8b 00 00 00    	je     801c6e <vprintfmt+0x44c>
			putch(ch, putdat);
  801be3:	83 ec 08             	sub    $0x8,%esp
  801be6:	53                   	push   %ebx
  801be7:	50                   	push   %eax
  801be8:	ff d6                	call   *%esi
  801bea:	83 c4 10             	add    $0x10,%esp
  801bed:	eb dc                	jmp    801bcb <vprintfmt+0x3a9>
	if (lflag >= 2)
  801bef:	83 f9 01             	cmp    $0x1,%ecx
  801bf2:	7f 1b                	jg     801c0f <vprintfmt+0x3ed>
	else if (lflag)
  801bf4:	85 c9                	test   %ecx,%ecx
  801bf6:	74 2c                	je     801c24 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801bf8:	8b 45 14             	mov    0x14(%ebp),%eax
  801bfb:	8b 10                	mov    (%eax),%edx
  801bfd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c02:	8d 40 04             	lea    0x4(%eax),%eax
  801c05:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c08:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  801c0d:	eb 9f                	jmp    801bae <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801c0f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c12:	8b 10                	mov    (%eax),%edx
  801c14:	8b 48 04             	mov    0x4(%eax),%ecx
  801c17:	8d 40 08             	lea    0x8(%eax),%eax
  801c1a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c1d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  801c22:	eb 8a                	jmp    801bae <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801c24:	8b 45 14             	mov    0x14(%ebp),%eax
  801c27:	8b 10                	mov    (%eax),%edx
  801c29:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c2e:	8d 40 04             	lea    0x4(%eax),%eax
  801c31:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c34:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  801c39:	e9 70 ff ff ff       	jmp    801bae <vprintfmt+0x38c>
			putch(ch, putdat);
  801c3e:	83 ec 08             	sub    $0x8,%esp
  801c41:	53                   	push   %ebx
  801c42:	6a 25                	push   $0x25
  801c44:	ff d6                	call   *%esi
			break;
  801c46:	83 c4 10             	add    $0x10,%esp
  801c49:	e9 7a ff ff ff       	jmp    801bc8 <vprintfmt+0x3a6>
			putch('%', putdat);
  801c4e:	83 ec 08             	sub    $0x8,%esp
  801c51:	53                   	push   %ebx
  801c52:	6a 25                	push   $0x25
  801c54:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801c56:	83 c4 10             	add    $0x10,%esp
  801c59:	89 f8                	mov    %edi,%eax
  801c5b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801c5f:	74 05                	je     801c66 <vprintfmt+0x444>
  801c61:	83 e8 01             	sub    $0x1,%eax
  801c64:	eb f5                	jmp    801c5b <vprintfmt+0x439>
  801c66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c69:	e9 5a ff ff ff       	jmp    801bc8 <vprintfmt+0x3a6>
}
  801c6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c71:	5b                   	pop    %ebx
  801c72:	5e                   	pop    %esi
  801c73:	5f                   	pop    %edi
  801c74:	5d                   	pop    %ebp
  801c75:	c3                   	ret    

00801c76 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801c76:	f3 0f 1e fb          	endbr32 
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	83 ec 18             	sub    $0x18,%esp
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801c86:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c89:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801c8d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801c90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801c97:	85 c0                	test   %eax,%eax
  801c99:	74 26                	je     801cc1 <vsnprintf+0x4b>
  801c9b:	85 d2                	test   %edx,%edx
  801c9d:	7e 22                	jle    801cc1 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c9f:	ff 75 14             	pushl  0x14(%ebp)
  801ca2:	ff 75 10             	pushl  0x10(%ebp)
  801ca5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ca8:	50                   	push   %eax
  801ca9:	68 e0 17 80 00       	push   $0x8017e0
  801cae:	e8 6f fb ff ff       	call   801822 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801cb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cb6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbc:	83 c4 10             	add    $0x10,%esp
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    
		return -E_INVAL;
  801cc1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cc6:	eb f7                	jmp    801cbf <vsnprintf+0x49>

00801cc8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801cc8:	f3 0f 1e fb          	endbr32 
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
  801ccf:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801cd2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801cd5:	50                   	push   %eax
  801cd6:	ff 75 10             	pushl  0x10(%ebp)
  801cd9:	ff 75 0c             	pushl  0xc(%ebp)
  801cdc:	ff 75 08             	pushl  0x8(%ebp)
  801cdf:	e8 92 ff ff ff       	call   801c76 <vsnprintf>
	va_end(ap);

	return rc;
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801ce6:	f3 0f 1e fb          	endbr32 
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801cf9:	74 05                	je     801d00 <strlen+0x1a>
		n++;
  801cfb:	83 c0 01             	add    $0x1,%eax
  801cfe:	eb f5                	jmp    801cf5 <strlen+0xf>
	return n;
}
  801d00:	5d                   	pop    %ebp
  801d01:	c3                   	ret    

00801d02 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801d02:	f3 0f 1e fb          	endbr32 
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d14:	39 d0                	cmp    %edx,%eax
  801d16:	74 0d                	je     801d25 <strnlen+0x23>
  801d18:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801d1c:	74 05                	je     801d23 <strnlen+0x21>
		n++;
  801d1e:	83 c0 01             	add    $0x1,%eax
  801d21:	eb f1                	jmp    801d14 <strnlen+0x12>
  801d23:	89 c2                	mov    %eax,%edx
	return n;
}
  801d25:	89 d0                	mov    %edx,%eax
  801d27:	5d                   	pop    %ebp
  801d28:	c3                   	ret    

00801d29 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801d29:	f3 0f 1e fb          	endbr32 
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	53                   	push   %ebx
  801d31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d34:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801d37:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3c:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801d40:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801d43:	83 c0 01             	add    $0x1,%eax
  801d46:	84 d2                	test   %dl,%dl
  801d48:	75 f2                	jne    801d3c <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801d4a:	89 c8                	mov    %ecx,%eax
  801d4c:	5b                   	pop    %ebx
  801d4d:	5d                   	pop    %ebp
  801d4e:	c3                   	ret    

00801d4f <strcat>:

char *
strcat(char *dst, const char *src)
{
  801d4f:	f3 0f 1e fb          	endbr32 
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
  801d56:	53                   	push   %ebx
  801d57:	83 ec 10             	sub    $0x10,%esp
  801d5a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801d5d:	53                   	push   %ebx
  801d5e:	e8 83 ff ff ff       	call   801ce6 <strlen>
  801d63:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801d66:	ff 75 0c             	pushl  0xc(%ebp)
  801d69:	01 d8                	add    %ebx,%eax
  801d6b:	50                   	push   %eax
  801d6c:	e8 b8 ff ff ff       	call   801d29 <strcpy>
	return dst;
}
  801d71:	89 d8                	mov    %ebx,%eax
  801d73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801d78:	f3 0f 1e fb          	endbr32 
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	56                   	push   %esi
  801d80:	53                   	push   %ebx
  801d81:	8b 75 08             	mov    0x8(%ebp),%esi
  801d84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d87:	89 f3                	mov    %esi,%ebx
  801d89:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801d8c:	89 f0                	mov    %esi,%eax
  801d8e:	39 d8                	cmp    %ebx,%eax
  801d90:	74 11                	je     801da3 <strncpy+0x2b>
		*dst++ = *src;
  801d92:	83 c0 01             	add    $0x1,%eax
  801d95:	0f b6 0a             	movzbl (%edx),%ecx
  801d98:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801d9b:	80 f9 01             	cmp    $0x1,%cl
  801d9e:	83 da ff             	sbb    $0xffffffff,%edx
  801da1:	eb eb                	jmp    801d8e <strncpy+0x16>
	}
	return ret;
}
  801da3:	89 f0                	mov    %esi,%eax
  801da5:	5b                   	pop    %ebx
  801da6:	5e                   	pop    %esi
  801da7:	5d                   	pop    %ebp
  801da8:	c3                   	ret    

00801da9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801da9:	f3 0f 1e fb          	endbr32 
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
  801db0:	56                   	push   %esi
  801db1:	53                   	push   %ebx
  801db2:	8b 75 08             	mov    0x8(%ebp),%esi
  801db5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801db8:	8b 55 10             	mov    0x10(%ebp),%edx
  801dbb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801dbd:	85 d2                	test   %edx,%edx
  801dbf:	74 21                	je     801de2 <strlcpy+0x39>
  801dc1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801dc5:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801dc7:	39 c2                	cmp    %eax,%edx
  801dc9:	74 14                	je     801ddf <strlcpy+0x36>
  801dcb:	0f b6 19             	movzbl (%ecx),%ebx
  801dce:	84 db                	test   %bl,%bl
  801dd0:	74 0b                	je     801ddd <strlcpy+0x34>
			*dst++ = *src++;
  801dd2:	83 c1 01             	add    $0x1,%ecx
  801dd5:	83 c2 01             	add    $0x1,%edx
  801dd8:	88 5a ff             	mov    %bl,-0x1(%edx)
  801ddb:	eb ea                	jmp    801dc7 <strlcpy+0x1e>
  801ddd:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801ddf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801de2:	29 f0                	sub    %esi,%eax
}
  801de4:	5b                   	pop    %ebx
  801de5:	5e                   	pop    %esi
  801de6:	5d                   	pop    %ebp
  801de7:	c3                   	ret    

00801de8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801de8:	f3 0f 1e fb          	endbr32 
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801df2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801df5:	0f b6 01             	movzbl (%ecx),%eax
  801df8:	84 c0                	test   %al,%al
  801dfa:	74 0c                	je     801e08 <strcmp+0x20>
  801dfc:	3a 02                	cmp    (%edx),%al
  801dfe:	75 08                	jne    801e08 <strcmp+0x20>
		p++, q++;
  801e00:	83 c1 01             	add    $0x1,%ecx
  801e03:	83 c2 01             	add    $0x1,%edx
  801e06:	eb ed                	jmp    801df5 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e08:	0f b6 c0             	movzbl %al,%eax
  801e0b:	0f b6 12             	movzbl (%edx),%edx
  801e0e:	29 d0                	sub    %edx,%eax
}
  801e10:	5d                   	pop    %ebp
  801e11:	c3                   	ret    

00801e12 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801e12:	f3 0f 1e fb          	endbr32 
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
  801e19:	53                   	push   %ebx
  801e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e20:	89 c3                	mov    %eax,%ebx
  801e22:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801e25:	eb 06                	jmp    801e2d <strncmp+0x1b>
		n--, p++, q++;
  801e27:	83 c0 01             	add    $0x1,%eax
  801e2a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801e2d:	39 d8                	cmp    %ebx,%eax
  801e2f:	74 16                	je     801e47 <strncmp+0x35>
  801e31:	0f b6 08             	movzbl (%eax),%ecx
  801e34:	84 c9                	test   %cl,%cl
  801e36:	74 04                	je     801e3c <strncmp+0x2a>
  801e38:	3a 0a                	cmp    (%edx),%cl
  801e3a:	74 eb                	je     801e27 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801e3c:	0f b6 00             	movzbl (%eax),%eax
  801e3f:	0f b6 12             	movzbl (%edx),%edx
  801e42:	29 d0                	sub    %edx,%eax
}
  801e44:	5b                   	pop    %ebx
  801e45:	5d                   	pop    %ebp
  801e46:	c3                   	ret    
		return 0;
  801e47:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4c:	eb f6                	jmp    801e44 <strncmp+0x32>

00801e4e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801e4e:	f3 0f 1e fb          	endbr32 
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e5c:	0f b6 10             	movzbl (%eax),%edx
  801e5f:	84 d2                	test   %dl,%dl
  801e61:	74 09                	je     801e6c <strchr+0x1e>
		if (*s == c)
  801e63:	38 ca                	cmp    %cl,%dl
  801e65:	74 0a                	je     801e71 <strchr+0x23>
	for (; *s; s++)
  801e67:	83 c0 01             	add    $0x1,%eax
  801e6a:	eb f0                	jmp    801e5c <strchr+0xe>
			return (char *) s;
	return 0;
  801e6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e71:	5d                   	pop    %ebp
  801e72:	c3                   	ret    

00801e73 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801e73:	f3 0f 1e fb          	endbr32 
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e81:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801e84:	38 ca                	cmp    %cl,%dl
  801e86:	74 09                	je     801e91 <strfind+0x1e>
  801e88:	84 d2                	test   %dl,%dl
  801e8a:	74 05                	je     801e91 <strfind+0x1e>
	for (; *s; s++)
  801e8c:	83 c0 01             	add    $0x1,%eax
  801e8f:	eb f0                	jmp    801e81 <strfind+0xe>
			break;
	return (char *) s;
}
  801e91:	5d                   	pop    %ebp
  801e92:	c3                   	ret    

00801e93 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801e93:	f3 0f 1e fb          	endbr32 
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	57                   	push   %edi
  801e9b:	56                   	push   %esi
  801e9c:	53                   	push   %ebx
  801e9d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ea0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801ea3:	85 c9                	test   %ecx,%ecx
  801ea5:	74 31                	je     801ed8 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801ea7:	89 f8                	mov    %edi,%eax
  801ea9:	09 c8                	or     %ecx,%eax
  801eab:	a8 03                	test   $0x3,%al
  801ead:	75 23                	jne    801ed2 <memset+0x3f>
		c &= 0xFF;
  801eaf:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801eb3:	89 d3                	mov    %edx,%ebx
  801eb5:	c1 e3 08             	shl    $0x8,%ebx
  801eb8:	89 d0                	mov    %edx,%eax
  801eba:	c1 e0 18             	shl    $0x18,%eax
  801ebd:	89 d6                	mov    %edx,%esi
  801ebf:	c1 e6 10             	shl    $0x10,%esi
  801ec2:	09 f0                	or     %esi,%eax
  801ec4:	09 c2                	or     %eax,%edx
  801ec6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801ec8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801ecb:	89 d0                	mov    %edx,%eax
  801ecd:	fc                   	cld    
  801ece:	f3 ab                	rep stos %eax,%es:(%edi)
  801ed0:	eb 06                	jmp    801ed8 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed5:	fc                   	cld    
  801ed6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801ed8:	89 f8                	mov    %edi,%eax
  801eda:	5b                   	pop    %ebx
  801edb:	5e                   	pop    %esi
  801edc:	5f                   	pop    %edi
  801edd:	5d                   	pop    %ebp
  801ede:	c3                   	ret    

00801edf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801edf:	f3 0f 1e fb          	endbr32 
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
  801ee6:	57                   	push   %edi
  801ee7:	56                   	push   %esi
  801ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eeb:	8b 75 0c             	mov    0xc(%ebp),%esi
  801eee:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801ef1:	39 c6                	cmp    %eax,%esi
  801ef3:	73 32                	jae    801f27 <memmove+0x48>
  801ef5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801ef8:	39 c2                	cmp    %eax,%edx
  801efa:	76 2b                	jbe    801f27 <memmove+0x48>
		s += n;
		d += n;
  801efc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801eff:	89 fe                	mov    %edi,%esi
  801f01:	09 ce                	or     %ecx,%esi
  801f03:	09 d6                	or     %edx,%esi
  801f05:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801f0b:	75 0e                	jne    801f1b <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801f0d:	83 ef 04             	sub    $0x4,%edi
  801f10:	8d 72 fc             	lea    -0x4(%edx),%esi
  801f13:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801f16:	fd                   	std    
  801f17:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801f19:	eb 09                	jmp    801f24 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801f1b:	83 ef 01             	sub    $0x1,%edi
  801f1e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801f21:	fd                   	std    
  801f22:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801f24:	fc                   	cld    
  801f25:	eb 1a                	jmp    801f41 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801f27:	89 c2                	mov    %eax,%edx
  801f29:	09 ca                	or     %ecx,%edx
  801f2b:	09 f2                	or     %esi,%edx
  801f2d:	f6 c2 03             	test   $0x3,%dl
  801f30:	75 0a                	jne    801f3c <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801f32:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801f35:	89 c7                	mov    %eax,%edi
  801f37:	fc                   	cld    
  801f38:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801f3a:	eb 05                	jmp    801f41 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801f3c:	89 c7                	mov    %eax,%edi
  801f3e:	fc                   	cld    
  801f3f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801f41:	5e                   	pop    %esi
  801f42:	5f                   	pop    %edi
  801f43:	5d                   	pop    %ebp
  801f44:	c3                   	ret    

00801f45 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801f45:	f3 0f 1e fb          	endbr32 
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
  801f4c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801f4f:	ff 75 10             	pushl  0x10(%ebp)
  801f52:	ff 75 0c             	pushl  0xc(%ebp)
  801f55:	ff 75 08             	pushl  0x8(%ebp)
  801f58:	e8 82 ff ff ff       	call   801edf <memmove>
}
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801f5f:	f3 0f 1e fb          	endbr32 
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
  801f66:	56                   	push   %esi
  801f67:	53                   	push   %ebx
  801f68:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6e:	89 c6                	mov    %eax,%esi
  801f70:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801f73:	39 f0                	cmp    %esi,%eax
  801f75:	74 1c                	je     801f93 <memcmp+0x34>
		if (*s1 != *s2)
  801f77:	0f b6 08             	movzbl (%eax),%ecx
  801f7a:	0f b6 1a             	movzbl (%edx),%ebx
  801f7d:	38 d9                	cmp    %bl,%cl
  801f7f:	75 08                	jne    801f89 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801f81:	83 c0 01             	add    $0x1,%eax
  801f84:	83 c2 01             	add    $0x1,%edx
  801f87:	eb ea                	jmp    801f73 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801f89:	0f b6 c1             	movzbl %cl,%eax
  801f8c:	0f b6 db             	movzbl %bl,%ebx
  801f8f:	29 d8                	sub    %ebx,%eax
  801f91:	eb 05                	jmp    801f98 <memcmp+0x39>
	}

	return 0;
  801f93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f98:	5b                   	pop    %ebx
  801f99:	5e                   	pop    %esi
  801f9a:	5d                   	pop    %ebp
  801f9b:	c3                   	ret    

00801f9c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801f9c:	f3 0f 1e fb          	endbr32 
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801fa9:	89 c2                	mov    %eax,%edx
  801fab:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801fae:	39 d0                	cmp    %edx,%eax
  801fb0:	73 09                	jae    801fbb <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801fb2:	38 08                	cmp    %cl,(%eax)
  801fb4:	74 05                	je     801fbb <memfind+0x1f>
	for (; s < ends; s++)
  801fb6:	83 c0 01             	add    $0x1,%eax
  801fb9:	eb f3                	jmp    801fae <memfind+0x12>
			break;
	return (void *) s;
}
  801fbb:	5d                   	pop    %ebp
  801fbc:	c3                   	ret    

00801fbd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801fbd:	f3 0f 1e fb          	endbr32 
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	57                   	push   %edi
  801fc5:	56                   	push   %esi
  801fc6:	53                   	push   %ebx
  801fc7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fca:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801fcd:	eb 03                	jmp    801fd2 <strtol+0x15>
		s++;
  801fcf:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801fd2:	0f b6 01             	movzbl (%ecx),%eax
  801fd5:	3c 20                	cmp    $0x20,%al
  801fd7:	74 f6                	je     801fcf <strtol+0x12>
  801fd9:	3c 09                	cmp    $0x9,%al
  801fdb:	74 f2                	je     801fcf <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801fdd:	3c 2b                	cmp    $0x2b,%al
  801fdf:	74 2a                	je     80200b <strtol+0x4e>
	int neg = 0;
  801fe1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801fe6:	3c 2d                	cmp    $0x2d,%al
  801fe8:	74 2b                	je     802015 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801fea:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801ff0:	75 0f                	jne    802001 <strtol+0x44>
  801ff2:	80 39 30             	cmpb   $0x30,(%ecx)
  801ff5:	74 28                	je     80201f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801ff7:	85 db                	test   %ebx,%ebx
  801ff9:	b8 0a 00 00 00       	mov    $0xa,%eax
  801ffe:	0f 44 d8             	cmove  %eax,%ebx
  802001:	b8 00 00 00 00       	mov    $0x0,%eax
  802006:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802009:	eb 46                	jmp    802051 <strtol+0x94>
		s++;
  80200b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80200e:	bf 00 00 00 00       	mov    $0x0,%edi
  802013:	eb d5                	jmp    801fea <strtol+0x2d>
		s++, neg = 1;
  802015:	83 c1 01             	add    $0x1,%ecx
  802018:	bf 01 00 00 00       	mov    $0x1,%edi
  80201d:	eb cb                	jmp    801fea <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80201f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  802023:	74 0e                	je     802033 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  802025:	85 db                	test   %ebx,%ebx
  802027:	75 d8                	jne    802001 <strtol+0x44>
		s++, base = 8;
  802029:	83 c1 01             	add    $0x1,%ecx
  80202c:	bb 08 00 00 00       	mov    $0x8,%ebx
  802031:	eb ce                	jmp    802001 <strtol+0x44>
		s += 2, base = 16;
  802033:	83 c1 02             	add    $0x2,%ecx
  802036:	bb 10 00 00 00       	mov    $0x10,%ebx
  80203b:	eb c4                	jmp    802001 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  80203d:	0f be d2             	movsbl %dl,%edx
  802040:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  802043:	3b 55 10             	cmp    0x10(%ebp),%edx
  802046:	7d 3a                	jge    802082 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  802048:	83 c1 01             	add    $0x1,%ecx
  80204b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80204f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  802051:	0f b6 11             	movzbl (%ecx),%edx
  802054:	8d 72 d0             	lea    -0x30(%edx),%esi
  802057:	89 f3                	mov    %esi,%ebx
  802059:	80 fb 09             	cmp    $0x9,%bl
  80205c:	76 df                	jbe    80203d <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  80205e:	8d 72 9f             	lea    -0x61(%edx),%esi
  802061:	89 f3                	mov    %esi,%ebx
  802063:	80 fb 19             	cmp    $0x19,%bl
  802066:	77 08                	ja     802070 <strtol+0xb3>
			dig = *s - 'a' + 10;
  802068:	0f be d2             	movsbl %dl,%edx
  80206b:	83 ea 57             	sub    $0x57,%edx
  80206e:	eb d3                	jmp    802043 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  802070:	8d 72 bf             	lea    -0x41(%edx),%esi
  802073:	89 f3                	mov    %esi,%ebx
  802075:	80 fb 19             	cmp    $0x19,%bl
  802078:	77 08                	ja     802082 <strtol+0xc5>
			dig = *s - 'A' + 10;
  80207a:	0f be d2             	movsbl %dl,%edx
  80207d:	83 ea 37             	sub    $0x37,%edx
  802080:	eb c1                	jmp    802043 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  802082:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802086:	74 05                	je     80208d <strtol+0xd0>
		*endptr = (char *) s;
  802088:	8b 75 0c             	mov    0xc(%ebp),%esi
  80208b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80208d:	89 c2                	mov    %eax,%edx
  80208f:	f7 da                	neg    %edx
  802091:	85 ff                	test   %edi,%edi
  802093:	0f 45 c2             	cmovne %edx,%eax
}
  802096:	5b                   	pop    %ebx
  802097:	5e                   	pop    %esi
  802098:	5f                   	pop    %edi
  802099:	5d                   	pop    %ebp
  80209a:	c3                   	ret    

0080209b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80209b:	f3 0f 1e fb          	endbr32 
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
  8020a2:	56                   	push   %esi
  8020a3:	53                   	push   %ebx
  8020a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8020a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8020ad:	85 c0                	test   %eax,%eax
  8020af:	74 3d                	je     8020ee <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8020b1:	83 ec 0c             	sub    $0xc,%esp
  8020b4:	50                   	push   %eax
  8020b5:	e8 88 e2 ff ff       	call   800342 <sys_ipc_recv>
  8020ba:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8020bd:	85 f6                	test   %esi,%esi
  8020bf:	74 0b                	je     8020cc <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8020c1:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020c7:	8b 52 74             	mov    0x74(%edx),%edx
  8020ca:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8020cc:	85 db                	test   %ebx,%ebx
  8020ce:	74 0b                	je     8020db <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8020d0:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020d6:	8b 52 78             	mov    0x78(%edx),%edx
  8020d9:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	78 21                	js     802100 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8020df:	a1 08 40 80 00       	mov    0x804008,%eax
  8020e4:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ea:	5b                   	pop    %ebx
  8020eb:	5e                   	pop    %esi
  8020ec:	5d                   	pop    %ebp
  8020ed:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8020ee:	83 ec 0c             	sub    $0xc,%esp
  8020f1:	68 00 00 c0 ee       	push   $0xeec00000
  8020f6:	e8 47 e2 ff ff       	call   800342 <sys_ipc_recv>
  8020fb:	83 c4 10             	add    $0x10,%esp
  8020fe:	eb bd                	jmp    8020bd <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802100:	85 f6                	test   %esi,%esi
  802102:	74 10                	je     802114 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802104:	85 db                	test   %ebx,%ebx
  802106:	75 df                	jne    8020e7 <ipc_recv+0x4c>
  802108:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80210f:	00 00 00 
  802112:	eb d3                	jmp    8020e7 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802114:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80211b:	00 00 00 
  80211e:	eb e4                	jmp    802104 <ipc_recv+0x69>

00802120 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802120:	f3 0f 1e fb          	endbr32 
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
  802127:	57                   	push   %edi
  802128:	56                   	push   %esi
  802129:	53                   	push   %ebx
  80212a:	83 ec 0c             	sub    $0xc,%esp
  80212d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802130:	8b 75 0c             	mov    0xc(%ebp),%esi
  802133:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802136:	85 db                	test   %ebx,%ebx
  802138:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80213d:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802140:	ff 75 14             	pushl  0x14(%ebp)
  802143:	53                   	push   %ebx
  802144:	56                   	push   %esi
  802145:	57                   	push   %edi
  802146:	e8 d0 e1 ff ff       	call   80031b <sys_ipc_try_send>
  80214b:	83 c4 10             	add    $0x10,%esp
  80214e:	85 c0                	test   %eax,%eax
  802150:	79 1e                	jns    802170 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802152:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802155:	75 07                	jne    80215e <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802157:	e8 f7 df ff ff       	call   800153 <sys_yield>
  80215c:	eb e2                	jmp    802140 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  80215e:	50                   	push   %eax
  80215f:	68 df 28 80 00       	push   $0x8028df
  802164:	6a 59                	push   $0x59
  802166:	68 fa 28 80 00       	push   $0x8028fa
  80216b:	e8 c8 f4 ff ff       	call   801638 <_panic>
	}
}
  802170:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802173:	5b                   	pop    %ebx
  802174:	5e                   	pop    %esi
  802175:	5f                   	pop    %edi
  802176:	5d                   	pop    %ebp
  802177:	c3                   	ret    

00802178 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802178:	f3 0f 1e fb          	endbr32 
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802182:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802187:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80218a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802190:	8b 52 50             	mov    0x50(%edx),%edx
  802193:	39 ca                	cmp    %ecx,%edx
  802195:	74 11                	je     8021a8 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802197:	83 c0 01             	add    $0x1,%eax
  80219a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80219f:	75 e6                	jne    802187 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8021a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a6:	eb 0b                	jmp    8021b3 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8021a8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021ab:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021b0:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021b3:	5d                   	pop    %ebp
  8021b4:	c3                   	ret    

008021b5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021b5:	f3 0f 1e fb          	endbr32 
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021bf:	89 c2                	mov    %eax,%edx
  8021c1:	c1 ea 16             	shr    $0x16,%edx
  8021c4:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8021cb:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021d0:	f6 c1 01             	test   $0x1,%cl
  8021d3:	74 1c                	je     8021f1 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8021d5:	c1 e8 0c             	shr    $0xc,%eax
  8021d8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8021df:	a8 01                	test   $0x1,%al
  8021e1:	74 0e                	je     8021f1 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021e3:	c1 e8 0c             	shr    $0xc,%eax
  8021e6:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8021ed:	ef 
  8021ee:	0f b7 d2             	movzwl %dx,%edx
}
  8021f1:	89 d0                	mov    %edx,%eax
  8021f3:	5d                   	pop    %ebp
  8021f4:	c3                   	ret    
  8021f5:	66 90                	xchg   %ax,%ax
  8021f7:	66 90                	xchg   %ax,%ax
  8021f9:	66 90                	xchg   %ax,%ax
  8021fb:	66 90                	xchg   %ax,%ax
  8021fd:	66 90                	xchg   %ax,%ax
  8021ff:	90                   	nop

00802200 <__udivdi3>:
  802200:	f3 0f 1e fb          	endbr32 
  802204:	55                   	push   %ebp
  802205:	57                   	push   %edi
  802206:	56                   	push   %esi
  802207:	53                   	push   %ebx
  802208:	83 ec 1c             	sub    $0x1c,%esp
  80220b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80220f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802213:	8b 74 24 34          	mov    0x34(%esp),%esi
  802217:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80221b:	85 d2                	test   %edx,%edx
  80221d:	75 19                	jne    802238 <__udivdi3+0x38>
  80221f:	39 f3                	cmp    %esi,%ebx
  802221:	76 4d                	jbe    802270 <__udivdi3+0x70>
  802223:	31 ff                	xor    %edi,%edi
  802225:	89 e8                	mov    %ebp,%eax
  802227:	89 f2                	mov    %esi,%edx
  802229:	f7 f3                	div    %ebx
  80222b:	89 fa                	mov    %edi,%edx
  80222d:	83 c4 1c             	add    $0x1c,%esp
  802230:	5b                   	pop    %ebx
  802231:	5e                   	pop    %esi
  802232:	5f                   	pop    %edi
  802233:	5d                   	pop    %ebp
  802234:	c3                   	ret    
  802235:	8d 76 00             	lea    0x0(%esi),%esi
  802238:	39 f2                	cmp    %esi,%edx
  80223a:	76 14                	jbe    802250 <__udivdi3+0x50>
  80223c:	31 ff                	xor    %edi,%edi
  80223e:	31 c0                	xor    %eax,%eax
  802240:	89 fa                	mov    %edi,%edx
  802242:	83 c4 1c             	add    $0x1c,%esp
  802245:	5b                   	pop    %ebx
  802246:	5e                   	pop    %esi
  802247:	5f                   	pop    %edi
  802248:	5d                   	pop    %ebp
  802249:	c3                   	ret    
  80224a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802250:	0f bd fa             	bsr    %edx,%edi
  802253:	83 f7 1f             	xor    $0x1f,%edi
  802256:	75 48                	jne    8022a0 <__udivdi3+0xa0>
  802258:	39 f2                	cmp    %esi,%edx
  80225a:	72 06                	jb     802262 <__udivdi3+0x62>
  80225c:	31 c0                	xor    %eax,%eax
  80225e:	39 eb                	cmp    %ebp,%ebx
  802260:	77 de                	ja     802240 <__udivdi3+0x40>
  802262:	b8 01 00 00 00       	mov    $0x1,%eax
  802267:	eb d7                	jmp    802240 <__udivdi3+0x40>
  802269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802270:	89 d9                	mov    %ebx,%ecx
  802272:	85 db                	test   %ebx,%ebx
  802274:	75 0b                	jne    802281 <__udivdi3+0x81>
  802276:	b8 01 00 00 00       	mov    $0x1,%eax
  80227b:	31 d2                	xor    %edx,%edx
  80227d:	f7 f3                	div    %ebx
  80227f:	89 c1                	mov    %eax,%ecx
  802281:	31 d2                	xor    %edx,%edx
  802283:	89 f0                	mov    %esi,%eax
  802285:	f7 f1                	div    %ecx
  802287:	89 c6                	mov    %eax,%esi
  802289:	89 e8                	mov    %ebp,%eax
  80228b:	89 f7                	mov    %esi,%edi
  80228d:	f7 f1                	div    %ecx
  80228f:	89 fa                	mov    %edi,%edx
  802291:	83 c4 1c             	add    $0x1c,%esp
  802294:	5b                   	pop    %ebx
  802295:	5e                   	pop    %esi
  802296:	5f                   	pop    %edi
  802297:	5d                   	pop    %ebp
  802298:	c3                   	ret    
  802299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022a0:	89 f9                	mov    %edi,%ecx
  8022a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022a7:	29 f8                	sub    %edi,%eax
  8022a9:	d3 e2                	shl    %cl,%edx
  8022ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022af:	89 c1                	mov    %eax,%ecx
  8022b1:	89 da                	mov    %ebx,%edx
  8022b3:	d3 ea                	shr    %cl,%edx
  8022b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022b9:	09 d1                	or     %edx,%ecx
  8022bb:	89 f2                	mov    %esi,%edx
  8022bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022c1:	89 f9                	mov    %edi,%ecx
  8022c3:	d3 e3                	shl    %cl,%ebx
  8022c5:	89 c1                	mov    %eax,%ecx
  8022c7:	d3 ea                	shr    %cl,%edx
  8022c9:	89 f9                	mov    %edi,%ecx
  8022cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022cf:	89 eb                	mov    %ebp,%ebx
  8022d1:	d3 e6                	shl    %cl,%esi
  8022d3:	89 c1                	mov    %eax,%ecx
  8022d5:	d3 eb                	shr    %cl,%ebx
  8022d7:	09 de                	or     %ebx,%esi
  8022d9:	89 f0                	mov    %esi,%eax
  8022db:	f7 74 24 08          	divl   0x8(%esp)
  8022df:	89 d6                	mov    %edx,%esi
  8022e1:	89 c3                	mov    %eax,%ebx
  8022e3:	f7 64 24 0c          	mull   0xc(%esp)
  8022e7:	39 d6                	cmp    %edx,%esi
  8022e9:	72 15                	jb     802300 <__udivdi3+0x100>
  8022eb:	89 f9                	mov    %edi,%ecx
  8022ed:	d3 e5                	shl    %cl,%ebp
  8022ef:	39 c5                	cmp    %eax,%ebp
  8022f1:	73 04                	jae    8022f7 <__udivdi3+0xf7>
  8022f3:	39 d6                	cmp    %edx,%esi
  8022f5:	74 09                	je     802300 <__udivdi3+0x100>
  8022f7:	89 d8                	mov    %ebx,%eax
  8022f9:	31 ff                	xor    %edi,%edi
  8022fb:	e9 40 ff ff ff       	jmp    802240 <__udivdi3+0x40>
  802300:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802303:	31 ff                	xor    %edi,%edi
  802305:	e9 36 ff ff ff       	jmp    802240 <__udivdi3+0x40>
  80230a:	66 90                	xchg   %ax,%ax
  80230c:	66 90                	xchg   %ax,%ax
  80230e:	66 90                	xchg   %ax,%ax

00802310 <__umoddi3>:
  802310:	f3 0f 1e fb          	endbr32 
  802314:	55                   	push   %ebp
  802315:	57                   	push   %edi
  802316:	56                   	push   %esi
  802317:	53                   	push   %ebx
  802318:	83 ec 1c             	sub    $0x1c,%esp
  80231b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80231f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802323:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802327:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80232b:	85 c0                	test   %eax,%eax
  80232d:	75 19                	jne    802348 <__umoddi3+0x38>
  80232f:	39 df                	cmp    %ebx,%edi
  802331:	76 5d                	jbe    802390 <__umoddi3+0x80>
  802333:	89 f0                	mov    %esi,%eax
  802335:	89 da                	mov    %ebx,%edx
  802337:	f7 f7                	div    %edi
  802339:	89 d0                	mov    %edx,%eax
  80233b:	31 d2                	xor    %edx,%edx
  80233d:	83 c4 1c             	add    $0x1c,%esp
  802340:	5b                   	pop    %ebx
  802341:	5e                   	pop    %esi
  802342:	5f                   	pop    %edi
  802343:	5d                   	pop    %ebp
  802344:	c3                   	ret    
  802345:	8d 76 00             	lea    0x0(%esi),%esi
  802348:	89 f2                	mov    %esi,%edx
  80234a:	39 d8                	cmp    %ebx,%eax
  80234c:	76 12                	jbe    802360 <__umoddi3+0x50>
  80234e:	89 f0                	mov    %esi,%eax
  802350:	89 da                	mov    %ebx,%edx
  802352:	83 c4 1c             	add    $0x1c,%esp
  802355:	5b                   	pop    %ebx
  802356:	5e                   	pop    %esi
  802357:	5f                   	pop    %edi
  802358:	5d                   	pop    %ebp
  802359:	c3                   	ret    
  80235a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802360:	0f bd e8             	bsr    %eax,%ebp
  802363:	83 f5 1f             	xor    $0x1f,%ebp
  802366:	75 50                	jne    8023b8 <__umoddi3+0xa8>
  802368:	39 d8                	cmp    %ebx,%eax
  80236a:	0f 82 e0 00 00 00    	jb     802450 <__umoddi3+0x140>
  802370:	89 d9                	mov    %ebx,%ecx
  802372:	39 f7                	cmp    %esi,%edi
  802374:	0f 86 d6 00 00 00    	jbe    802450 <__umoddi3+0x140>
  80237a:	89 d0                	mov    %edx,%eax
  80237c:	89 ca                	mov    %ecx,%edx
  80237e:	83 c4 1c             	add    $0x1c,%esp
  802381:	5b                   	pop    %ebx
  802382:	5e                   	pop    %esi
  802383:	5f                   	pop    %edi
  802384:	5d                   	pop    %ebp
  802385:	c3                   	ret    
  802386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80238d:	8d 76 00             	lea    0x0(%esi),%esi
  802390:	89 fd                	mov    %edi,%ebp
  802392:	85 ff                	test   %edi,%edi
  802394:	75 0b                	jne    8023a1 <__umoddi3+0x91>
  802396:	b8 01 00 00 00       	mov    $0x1,%eax
  80239b:	31 d2                	xor    %edx,%edx
  80239d:	f7 f7                	div    %edi
  80239f:	89 c5                	mov    %eax,%ebp
  8023a1:	89 d8                	mov    %ebx,%eax
  8023a3:	31 d2                	xor    %edx,%edx
  8023a5:	f7 f5                	div    %ebp
  8023a7:	89 f0                	mov    %esi,%eax
  8023a9:	f7 f5                	div    %ebp
  8023ab:	89 d0                	mov    %edx,%eax
  8023ad:	31 d2                	xor    %edx,%edx
  8023af:	eb 8c                	jmp    80233d <__umoddi3+0x2d>
  8023b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023b8:	89 e9                	mov    %ebp,%ecx
  8023ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8023bf:	29 ea                	sub    %ebp,%edx
  8023c1:	d3 e0                	shl    %cl,%eax
  8023c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023c7:	89 d1                	mov    %edx,%ecx
  8023c9:	89 f8                	mov    %edi,%eax
  8023cb:	d3 e8                	shr    %cl,%eax
  8023cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023d9:	09 c1                	or     %eax,%ecx
  8023db:	89 d8                	mov    %ebx,%eax
  8023dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023e1:	89 e9                	mov    %ebp,%ecx
  8023e3:	d3 e7                	shl    %cl,%edi
  8023e5:	89 d1                	mov    %edx,%ecx
  8023e7:	d3 e8                	shr    %cl,%eax
  8023e9:	89 e9                	mov    %ebp,%ecx
  8023eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023ef:	d3 e3                	shl    %cl,%ebx
  8023f1:	89 c7                	mov    %eax,%edi
  8023f3:	89 d1                	mov    %edx,%ecx
  8023f5:	89 f0                	mov    %esi,%eax
  8023f7:	d3 e8                	shr    %cl,%eax
  8023f9:	89 e9                	mov    %ebp,%ecx
  8023fb:	89 fa                	mov    %edi,%edx
  8023fd:	d3 e6                	shl    %cl,%esi
  8023ff:	09 d8                	or     %ebx,%eax
  802401:	f7 74 24 08          	divl   0x8(%esp)
  802405:	89 d1                	mov    %edx,%ecx
  802407:	89 f3                	mov    %esi,%ebx
  802409:	f7 64 24 0c          	mull   0xc(%esp)
  80240d:	89 c6                	mov    %eax,%esi
  80240f:	89 d7                	mov    %edx,%edi
  802411:	39 d1                	cmp    %edx,%ecx
  802413:	72 06                	jb     80241b <__umoddi3+0x10b>
  802415:	75 10                	jne    802427 <__umoddi3+0x117>
  802417:	39 c3                	cmp    %eax,%ebx
  802419:	73 0c                	jae    802427 <__umoddi3+0x117>
  80241b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80241f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802423:	89 d7                	mov    %edx,%edi
  802425:	89 c6                	mov    %eax,%esi
  802427:	89 ca                	mov    %ecx,%edx
  802429:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80242e:	29 f3                	sub    %esi,%ebx
  802430:	19 fa                	sbb    %edi,%edx
  802432:	89 d0                	mov    %edx,%eax
  802434:	d3 e0                	shl    %cl,%eax
  802436:	89 e9                	mov    %ebp,%ecx
  802438:	d3 eb                	shr    %cl,%ebx
  80243a:	d3 ea                	shr    %cl,%edx
  80243c:	09 d8                	or     %ebx,%eax
  80243e:	83 c4 1c             	add    $0x1c,%esp
  802441:	5b                   	pop    %ebx
  802442:	5e                   	pop    %esi
  802443:	5f                   	pop    %edi
  802444:	5d                   	pop    %ebp
  802445:	c3                   	ret    
  802446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80244d:	8d 76 00             	lea    0x0(%esi),%esi
  802450:	29 fe                	sub    %edi,%esi
  802452:	19 c3                	sbb    %eax,%ebx
  802454:	89 f2                	mov    %esi,%edx
  802456:	89 d9                	mov    %ebx,%ecx
  802458:	e9 1d ff ff ff       	jmp    80237a <__umoddi3+0x6a>
