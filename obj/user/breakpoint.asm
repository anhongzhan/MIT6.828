
obj/user/breakpoint.debug:     file format elf32-i386


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
  800048:	e8 de 00 00 00       	call   80012b <sys_getenvid>
  80004d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800052:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800055:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005a:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005f:	85 db                	test   %ebx,%ebx
  800061:	7e 07                	jle    80006a <libmain+0x31>
		binaryname = argv[0];
  800063:	8b 06                	mov    (%esi),%eax
  800065:	a3 00 30 80 00       	mov    %eax,0x803000

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
  80008a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80008d:	e8 df 04 00 00       	call   800571 <close_all>
	sys_env_destroy(0);
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	6a 00                	push   $0x0
  800097:	e8 4a 00 00 00       	call   8000e6 <sys_env_destroy>
}
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	c9                   	leave  
  8000a0:	c3                   	ret    

008000a1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a1:	f3 0f 1e fb          	endbr32 
  8000a5:	55                   	push   %ebp
  8000a6:	89 e5                	mov    %esp,%ebp
  8000a8:	57                   	push   %edi
  8000a9:	56                   	push   %esi
  8000aa:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b6:	89 c3                	mov    %eax,%ebx
  8000b8:	89 c7                	mov    %eax,%edi
  8000ba:	89 c6                	mov    %eax,%esi
  8000bc:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000be:	5b                   	pop    %ebx
  8000bf:	5e                   	pop    %esi
  8000c0:	5f                   	pop    %edi
  8000c1:	5d                   	pop    %ebp
  8000c2:	c3                   	ret    

008000c3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c3:	f3 0f 1e fb          	endbr32 
  8000c7:	55                   	push   %ebp
  8000c8:	89 e5                	mov    %esp,%ebp
  8000ca:	57                   	push   %edi
  8000cb:	56                   	push   %esi
  8000cc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d7:	89 d1                	mov    %edx,%ecx
  8000d9:	89 d3                	mov    %edx,%ebx
  8000db:	89 d7                	mov    %edx,%edi
  8000dd:	89 d6                	mov    %edx,%esi
  8000df:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e1:	5b                   	pop    %ebx
  8000e2:	5e                   	pop    %esi
  8000e3:	5f                   	pop    %edi
  8000e4:	5d                   	pop    %ebp
  8000e5:	c3                   	ret    

008000e6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e6:	f3 0f 1e fb          	endbr32 
  8000ea:	55                   	push   %ebp
  8000eb:	89 e5                	mov    %esp,%ebp
  8000ed:	57                   	push   %edi
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8000fb:	b8 03 00 00 00       	mov    $0x3,%eax
  800100:	89 cb                	mov    %ecx,%ebx
  800102:	89 cf                	mov    %ecx,%edi
  800104:	89 ce                	mov    %ecx,%esi
  800106:	cd 30                	int    $0x30
	if(check && ret > 0)
  800108:	85 c0                	test   %eax,%eax
  80010a:	7f 08                	jg     800114 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80010c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010f:	5b                   	pop    %ebx
  800110:	5e                   	pop    %esi
  800111:	5f                   	pop    %edi
  800112:	5d                   	pop    %ebp
  800113:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	50                   	push   %eax
  800118:	6a 03                	push   $0x3
  80011a:	68 0a 1f 80 00       	push   $0x801f0a
  80011f:	6a 23                	push   $0x23
  800121:	68 27 1f 80 00       	push   $0x801f27
  800126:	e8 9c 0f 00 00       	call   8010c7 <_panic>

0080012b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80012b:	f3 0f 1e fb          	endbr32 
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	57                   	push   %edi
  800133:	56                   	push   %esi
  800134:	53                   	push   %ebx
	asm volatile("int %1\n"
  800135:	ba 00 00 00 00       	mov    $0x0,%edx
  80013a:	b8 02 00 00 00       	mov    $0x2,%eax
  80013f:	89 d1                	mov    %edx,%ecx
  800141:	89 d3                	mov    %edx,%ebx
  800143:	89 d7                	mov    %edx,%edi
  800145:	89 d6                	mov    %edx,%esi
  800147:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800149:	5b                   	pop    %ebx
  80014a:	5e                   	pop    %esi
  80014b:	5f                   	pop    %edi
  80014c:	5d                   	pop    %ebp
  80014d:	c3                   	ret    

0080014e <sys_yield>:

void
sys_yield(void)
{
  80014e:	f3 0f 1e fb          	endbr32 
  800152:	55                   	push   %ebp
  800153:	89 e5                	mov    %esp,%ebp
  800155:	57                   	push   %edi
  800156:	56                   	push   %esi
  800157:	53                   	push   %ebx
	asm volatile("int %1\n"
  800158:	ba 00 00 00 00       	mov    $0x0,%edx
  80015d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800162:	89 d1                	mov    %edx,%ecx
  800164:	89 d3                	mov    %edx,%ebx
  800166:	89 d7                	mov    %edx,%edi
  800168:	89 d6                	mov    %edx,%esi
  80016a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80016c:	5b                   	pop    %ebx
  80016d:	5e                   	pop    %esi
  80016e:	5f                   	pop    %edi
  80016f:	5d                   	pop    %ebp
  800170:	c3                   	ret    

00800171 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800171:	f3 0f 1e fb          	endbr32 
  800175:	55                   	push   %ebp
  800176:	89 e5                	mov    %esp,%ebp
  800178:	57                   	push   %edi
  800179:	56                   	push   %esi
  80017a:	53                   	push   %ebx
  80017b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80017e:	be 00 00 00 00       	mov    $0x0,%esi
  800183:	8b 55 08             	mov    0x8(%ebp),%edx
  800186:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800189:	b8 04 00 00 00       	mov    $0x4,%eax
  80018e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800191:	89 f7                	mov    %esi,%edi
  800193:	cd 30                	int    $0x30
	if(check && ret > 0)
  800195:	85 c0                	test   %eax,%eax
  800197:	7f 08                	jg     8001a1 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800199:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80019c:	5b                   	pop    %ebx
  80019d:	5e                   	pop    %esi
  80019e:	5f                   	pop    %edi
  80019f:	5d                   	pop    %ebp
  8001a0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	50                   	push   %eax
  8001a5:	6a 04                	push   $0x4
  8001a7:	68 0a 1f 80 00       	push   $0x801f0a
  8001ac:	6a 23                	push   $0x23
  8001ae:	68 27 1f 80 00       	push   $0x801f27
  8001b3:	e8 0f 0f 00 00       	call   8010c7 <_panic>

008001b8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001b8:	f3 0f 1e fb          	endbr32 
  8001bc:	55                   	push   %ebp
  8001bd:	89 e5                	mov    %esp,%ebp
  8001bf:	57                   	push   %edi
  8001c0:	56                   	push   %esi
  8001c1:	53                   	push   %ebx
  8001c2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001cb:	b8 05 00 00 00       	mov    $0x5,%eax
  8001d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001d3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001d6:	8b 75 18             	mov    0x18(%ebp),%esi
  8001d9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001db:	85 c0                	test   %eax,%eax
  8001dd:	7f 08                	jg     8001e7 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e2:	5b                   	pop    %ebx
  8001e3:	5e                   	pop    %esi
  8001e4:	5f                   	pop    %edi
  8001e5:	5d                   	pop    %ebp
  8001e6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	50                   	push   %eax
  8001eb:	6a 05                	push   $0x5
  8001ed:	68 0a 1f 80 00       	push   $0x801f0a
  8001f2:	6a 23                	push   $0x23
  8001f4:	68 27 1f 80 00       	push   $0x801f27
  8001f9:	e8 c9 0e 00 00       	call   8010c7 <_panic>

008001fe <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001fe:	f3 0f 1e fb          	endbr32 
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	57                   	push   %edi
  800206:	56                   	push   %esi
  800207:	53                   	push   %ebx
  800208:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80020b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800210:	8b 55 08             	mov    0x8(%ebp),%edx
  800213:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800216:	b8 06 00 00 00       	mov    $0x6,%eax
  80021b:	89 df                	mov    %ebx,%edi
  80021d:	89 de                	mov    %ebx,%esi
  80021f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800221:	85 c0                	test   %eax,%eax
  800223:	7f 08                	jg     80022d <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800225:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800228:	5b                   	pop    %ebx
  800229:	5e                   	pop    %esi
  80022a:	5f                   	pop    %edi
  80022b:	5d                   	pop    %ebp
  80022c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	50                   	push   %eax
  800231:	6a 06                	push   $0x6
  800233:	68 0a 1f 80 00       	push   $0x801f0a
  800238:	6a 23                	push   $0x23
  80023a:	68 27 1f 80 00       	push   $0x801f27
  80023f:	e8 83 0e 00 00       	call   8010c7 <_panic>

00800244 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800244:	f3 0f 1e fb          	endbr32 
  800248:	55                   	push   %ebp
  800249:	89 e5                	mov    %esp,%ebp
  80024b:	57                   	push   %edi
  80024c:	56                   	push   %esi
  80024d:	53                   	push   %ebx
  80024e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800251:	bb 00 00 00 00       	mov    $0x0,%ebx
  800256:	8b 55 08             	mov    0x8(%ebp),%edx
  800259:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80025c:	b8 08 00 00 00       	mov    $0x8,%eax
  800261:	89 df                	mov    %ebx,%edi
  800263:	89 de                	mov    %ebx,%esi
  800265:	cd 30                	int    $0x30
	if(check && ret > 0)
  800267:	85 c0                	test   %eax,%eax
  800269:	7f 08                	jg     800273 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80026b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026e:	5b                   	pop    %ebx
  80026f:	5e                   	pop    %esi
  800270:	5f                   	pop    %edi
  800271:	5d                   	pop    %ebp
  800272:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	50                   	push   %eax
  800277:	6a 08                	push   $0x8
  800279:	68 0a 1f 80 00       	push   $0x801f0a
  80027e:	6a 23                	push   $0x23
  800280:	68 27 1f 80 00       	push   $0x801f27
  800285:	e8 3d 0e 00 00       	call   8010c7 <_panic>

0080028a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80028a:	f3 0f 1e fb          	endbr32 
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	57                   	push   %edi
  800292:	56                   	push   %esi
  800293:	53                   	push   %ebx
  800294:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800297:	bb 00 00 00 00       	mov    $0x0,%ebx
  80029c:	8b 55 08             	mov    0x8(%ebp),%edx
  80029f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002a2:	b8 09 00 00 00       	mov    $0x9,%eax
  8002a7:	89 df                	mov    %ebx,%edi
  8002a9:	89 de                	mov    %ebx,%esi
  8002ab:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002ad:	85 c0                	test   %eax,%eax
  8002af:	7f 08                	jg     8002b9 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b4:	5b                   	pop    %ebx
  8002b5:	5e                   	pop    %esi
  8002b6:	5f                   	pop    %edi
  8002b7:	5d                   	pop    %ebp
  8002b8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002b9:	83 ec 0c             	sub    $0xc,%esp
  8002bc:	50                   	push   %eax
  8002bd:	6a 09                	push   $0x9
  8002bf:	68 0a 1f 80 00       	push   $0x801f0a
  8002c4:	6a 23                	push   $0x23
  8002c6:	68 27 1f 80 00       	push   $0x801f27
  8002cb:	e8 f7 0d 00 00       	call   8010c7 <_panic>

008002d0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002d0:	f3 0f 1e fb          	endbr32 
  8002d4:	55                   	push   %ebp
  8002d5:	89 e5                	mov    %esp,%ebp
  8002d7:	57                   	push   %edi
  8002d8:	56                   	push   %esi
  8002d9:	53                   	push   %ebx
  8002da:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002ed:	89 df                	mov    %ebx,%edi
  8002ef:	89 de                	mov    %ebx,%esi
  8002f1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002f3:	85 c0                	test   %eax,%eax
  8002f5:	7f 08                	jg     8002ff <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002fa:	5b                   	pop    %ebx
  8002fb:	5e                   	pop    %esi
  8002fc:	5f                   	pop    %edi
  8002fd:	5d                   	pop    %ebp
  8002fe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002ff:	83 ec 0c             	sub    $0xc,%esp
  800302:	50                   	push   %eax
  800303:	6a 0a                	push   $0xa
  800305:	68 0a 1f 80 00       	push   $0x801f0a
  80030a:	6a 23                	push   $0x23
  80030c:	68 27 1f 80 00       	push   $0x801f27
  800311:	e8 b1 0d 00 00       	call   8010c7 <_panic>

00800316 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800316:	f3 0f 1e fb          	endbr32 
  80031a:	55                   	push   %ebp
  80031b:	89 e5                	mov    %esp,%ebp
  80031d:	57                   	push   %edi
  80031e:	56                   	push   %esi
  80031f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800320:	8b 55 08             	mov    0x8(%ebp),%edx
  800323:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800326:	b8 0c 00 00 00       	mov    $0xc,%eax
  80032b:	be 00 00 00 00       	mov    $0x0,%esi
  800330:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800333:	8b 7d 14             	mov    0x14(%ebp),%edi
  800336:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800338:	5b                   	pop    %ebx
  800339:	5e                   	pop    %esi
  80033a:	5f                   	pop    %edi
  80033b:	5d                   	pop    %ebp
  80033c:	c3                   	ret    

0080033d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80033d:	f3 0f 1e fb          	endbr32 
  800341:	55                   	push   %ebp
  800342:	89 e5                	mov    %esp,%ebp
  800344:	57                   	push   %edi
  800345:	56                   	push   %esi
  800346:	53                   	push   %ebx
  800347:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80034a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80034f:	8b 55 08             	mov    0x8(%ebp),%edx
  800352:	b8 0d 00 00 00       	mov    $0xd,%eax
  800357:	89 cb                	mov    %ecx,%ebx
  800359:	89 cf                	mov    %ecx,%edi
  80035b:	89 ce                	mov    %ecx,%esi
  80035d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80035f:	85 c0                	test   %eax,%eax
  800361:	7f 08                	jg     80036b <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800363:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800366:	5b                   	pop    %ebx
  800367:	5e                   	pop    %esi
  800368:	5f                   	pop    %edi
  800369:	5d                   	pop    %ebp
  80036a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80036b:	83 ec 0c             	sub    $0xc,%esp
  80036e:	50                   	push   %eax
  80036f:	6a 0d                	push   $0xd
  800371:	68 0a 1f 80 00       	push   $0x801f0a
  800376:	6a 23                	push   $0x23
  800378:	68 27 1f 80 00       	push   $0x801f27
  80037d:	e8 45 0d 00 00       	call   8010c7 <_panic>

00800382 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800382:	f3 0f 1e fb          	endbr32 
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	05 00 00 00 30       	add    $0x30000000,%eax
  800391:	c1 e8 0c             	shr    $0xc,%eax
}
  800394:	5d                   	pop    %ebp
  800395:	c3                   	ret    

00800396 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800396:	f3 0f 1e fb          	endbr32 
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80039d:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003aa:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003af:	5d                   	pop    %ebp
  8003b0:	c3                   	ret    

008003b1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003b1:	f3 0f 1e fb          	endbr32 
  8003b5:	55                   	push   %ebp
  8003b6:	89 e5                	mov    %esp,%ebp
  8003b8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003bd:	89 c2                	mov    %eax,%edx
  8003bf:	c1 ea 16             	shr    $0x16,%edx
  8003c2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003c9:	f6 c2 01             	test   $0x1,%dl
  8003cc:	74 2d                	je     8003fb <fd_alloc+0x4a>
  8003ce:	89 c2                	mov    %eax,%edx
  8003d0:	c1 ea 0c             	shr    $0xc,%edx
  8003d3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003da:	f6 c2 01             	test   $0x1,%dl
  8003dd:	74 1c                	je     8003fb <fd_alloc+0x4a>
  8003df:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003e4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003e9:	75 d2                	jne    8003bd <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8003f4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003f9:	eb 0a                	jmp    800405 <fd_alloc+0x54>
			*fd_store = fd;
  8003fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003fe:	89 01                	mov    %eax,(%ecx)
			return 0;
  800400:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800405:	5d                   	pop    %ebp
  800406:	c3                   	ret    

00800407 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800407:	f3 0f 1e fb          	endbr32 
  80040b:	55                   	push   %ebp
  80040c:	89 e5                	mov    %esp,%ebp
  80040e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800411:	83 f8 1f             	cmp    $0x1f,%eax
  800414:	77 30                	ja     800446 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800416:	c1 e0 0c             	shl    $0xc,%eax
  800419:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80041e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800424:	f6 c2 01             	test   $0x1,%dl
  800427:	74 24                	je     80044d <fd_lookup+0x46>
  800429:	89 c2                	mov    %eax,%edx
  80042b:	c1 ea 0c             	shr    $0xc,%edx
  80042e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800435:	f6 c2 01             	test   $0x1,%dl
  800438:	74 1a                	je     800454 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80043a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80043d:	89 02                	mov    %eax,(%edx)
	return 0;
  80043f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800444:	5d                   	pop    %ebp
  800445:	c3                   	ret    
		return -E_INVAL;
  800446:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80044b:	eb f7                	jmp    800444 <fd_lookup+0x3d>
		return -E_INVAL;
  80044d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800452:	eb f0                	jmp    800444 <fd_lookup+0x3d>
  800454:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800459:	eb e9                	jmp    800444 <fd_lookup+0x3d>

0080045b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80045b:	f3 0f 1e fb          	endbr32 
  80045f:	55                   	push   %ebp
  800460:	89 e5                	mov    %esp,%ebp
  800462:	83 ec 08             	sub    $0x8,%esp
  800465:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800468:	ba b4 1f 80 00       	mov    $0x801fb4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80046d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800472:	39 08                	cmp    %ecx,(%eax)
  800474:	74 33                	je     8004a9 <dev_lookup+0x4e>
  800476:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800479:	8b 02                	mov    (%edx),%eax
  80047b:	85 c0                	test   %eax,%eax
  80047d:	75 f3                	jne    800472 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80047f:	a1 04 40 80 00       	mov    0x804004,%eax
  800484:	8b 40 48             	mov    0x48(%eax),%eax
  800487:	83 ec 04             	sub    $0x4,%esp
  80048a:	51                   	push   %ecx
  80048b:	50                   	push   %eax
  80048c:	68 38 1f 80 00       	push   $0x801f38
  800491:	e8 18 0d 00 00       	call   8011ae <cprintf>
	*dev = 0;
  800496:	8b 45 0c             	mov    0xc(%ebp),%eax
  800499:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004a7:	c9                   	leave  
  8004a8:	c3                   	ret    
			*dev = devtab[i];
  8004a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ac:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b3:	eb f2                	jmp    8004a7 <dev_lookup+0x4c>

008004b5 <fd_close>:
{
  8004b5:	f3 0f 1e fb          	endbr32 
  8004b9:	55                   	push   %ebp
  8004ba:	89 e5                	mov    %esp,%ebp
  8004bc:	57                   	push   %edi
  8004bd:	56                   	push   %esi
  8004be:	53                   	push   %ebx
  8004bf:	83 ec 24             	sub    $0x24,%esp
  8004c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004c8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004cb:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004cc:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004d2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004d5:	50                   	push   %eax
  8004d6:	e8 2c ff ff ff       	call   800407 <fd_lookup>
  8004db:	89 c3                	mov    %eax,%ebx
  8004dd:	83 c4 10             	add    $0x10,%esp
  8004e0:	85 c0                	test   %eax,%eax
  8004e2:	78 05                	js     8004e9 <fd_close+0x34>
	    || fd != fd2)
  8004e4:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004e7:	74 16                	je     8004ff <fd_close+0x4a>
		return (must_exist ? r : 0);
  8004e9:	89 f8                	mov    %edi,%eax
  8004eb:	84 c0                	test   %al,%al
  8004ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f2:	0f 44 d8             	cmove  %eax,%ebx
}
  8004f5:	89 d8                	mov    %ebx,%eax
  8004f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004fa:	5b                   	pop    %ebx
  8004fb:	5e                   	pop    %esi
  8004fc:	5f                   	pop    %edi
  8004fd:	5d                   	pop    %ebp
  8004fe:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004ff:	83 ec 08             	sub    $0x8,%esp
  800502:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800505:	50                   	push   %eax
  800506:	ff 36                	pushl  (%esi)
  800508:	e8 4e ff ff ff       	call   80045b <dev_lookup>
  80050d:	89 c3                	mov    %eax,%ebx
  80050f:	83 c4 10             	add    $0x10,%esp
  800512:	85 c0                	test   %eax,%eax
  800514:	78 1a                	js     800530 <fd_close+0x7b>
		if (dev->dev_close)
  800516:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800519:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80051c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800521:	85 c0                	test   %eax,%eax
  800523:	74 0b                	je     800530 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800525:	83 ec 0c             	sub    $0xc,%esp
  800528:	56                   	push   %esi
  800529:	ff d0                	call   *%eax
  80052b:	89 c3                	mov    %eax,%ebx
  80052d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800530:	83 ec 08             	sub    $0x8,%esp
  800533:	56                   	push   %esi
  800534:	6a 00                	push   $0x0
  800536:	e8 c3 fc ff ff       	call   8001fe <sys_page_unmap>
	return r;
  80053b:	83 c4 10             	add    $0x10,%esp
  80053e:	eb b5                	jmp    8004f5 <fd_close+0x40>

00800540 <close>:

int
close(int fdnum)
{
  800540:	f3 0f 1e fb          	endbr32 
  800544:	55                   	push   %ebp
  800545:	89 e5                	mov    %esp,%ebp
  800547:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80054a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80054d:	50                   	push   %eax
  80054e:	ff 75 08             	pushl  0x8(%ebp)
  800551:	e8 b1 fe ff ff       	call   800407 <fd_lookup>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	85 c0                	test   %eax,%eax
  80055b:	79 02                	jns    80055f <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80055d:	c9                   	leave  
  80055e:	c3                   	ret    
		return fd_close(fd, 1);
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	6a 01                	push   $0x1
  800564:	ff 75 f4             	pushl  -0xc(%ebp)
  800567:	e8 49 ff ff ff       	call   8004b5 <fd_close>
  80056c:	83 c4 10             	add    $0x10,%esp
  80056f:	eb ec                	jmp    80055d <close+0x1d>

00800571 <close_all>:

void
close_all(void)
{
  800571:	f3 0f 1e fb          	endbr32 
  800575:	55                   	push   %ebp
  800576:	89 e5                	mov    %esp,%ebp
  800578:	53                   	push   %ebx
  800579:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80057c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800581:	83 ec 0c             	sub    $0xc,%esp
  800584:	53                   	push   %ebx
  800585:	e8 b6 ff ff ff       	call   800540 <close>
	for (i = 0; i < MAXFD; i++)
  80058a:	83 c3 01             	add    $0x1,%ebx
  80058d:	83 c4 10             	add    $0x10,%esp
  800590:	83 fb 20             	cmp    $0x20,%ebx
  800593:	75 ec                	jne    800581 <close_all+0x10>
}
  800595:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800598:	c9                   	leave  
  800599:	c3                   	ret    

0080059a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80059a:	f3 0f 1e fb          	endbr32 
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
  8005a1:	57                   	push   %edi
  8005a2:	56                   	push   %esi
  8005a3:	53                   	push   %ebx
  8005a4:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005a7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005aa:	50                   	push   %eax
  8005ab:	ff 75 08             	pushl  0x8(%ebp)
  8005ae:	e8 54 fe ff ff       	call   800407 <fd_lookup>
  8005b3:	89 c3                	mov    %eax,%ebx
  8005b5:	83 c4 10             	add    $0x10,%esp
  8005b8:	85 c0                	test   %eax,%eax
  8005ba:	0f 88 81 00 00 00    	js     800641 <dup+0xa7>
		return r;
	close(newfdnum);
  8005c0:	83 ec 0c             	sub    $0xc,%esp
  8005c3:	ff 75 0c             	pushl  0xc(%ebp)
  8005c6:	e8 75 ff ff ff       	call   800540 <close>

	newfd = INDEX2FD(newfdnum);
  8005cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005ce:	c1 e6 0c             	shl    $0xc,%esi
  8005d1:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005d7:	83 c4 04             	add    $0x4,%esp
  8005da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005dd:	e8 b4 fd ff ff       	call   800396 <fd2data>
  8005e2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005e4:	89 34 24             	mov    %esi,(%esp)
  8005e7:	e8 aa fd ff ff       	call   800396 <fd2data>
  8005ec:	83 c4 10             	add    $0x10,%esp
  8005ef:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005f1:	89 d8                	mov    %ebx,%eax
  8005f3:	c1 e8 16             	shr    $0x16,%eax
  8005f6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005fd:	a8 01                	test   $0x1,%al
  8005ff:	74 11                	je     800612 <dup+0x78>
  800601:	89 d8                	mov    %ebx,%eax
  800603:	c1 e8 0c             	shr    $0xc,%eax
  800606:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80060d:	f6 c2 01             	test   $0x1,%dl
  800610:	75 39                	jne    80064b <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800612:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800615:	89 d0                	mov    %edx,%eax
  800617:	c1 e8 0c             	shr    $0xc,%eax
  80061a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	25 07 0e 00 00       	and    $0xe07,%eax
  800629:	50                   	push   %eax
  80062a:	56                   	push   %esi
  80062b:	6a 00                	push   $0x0
  80062d:	52                   	push   %edx
  80062e:	6a 00                	push   $0x0
  800630:	e8 83 fb ff ff       	call   8001b8 <sys_page_map>
  800635:	89 c3                	mov    %eax,%ebx
  800637:	83 c4 20             	add    $0x20,%esp
  80063a:	85 c0                	test   %eax,%eax
  80063c:	78 31                	js     80066f <dup+0xd5>
		goto err;

	return newfdnum;
  80063e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800641:	89 d8                	mov    %ebx,%eax
  800643:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800646:	5b                   	pop    %ebx
  800647:	5e                   	pop    %esi
  800648:	5f                   	pop    %edi
  800649:	5d                   	pop    %ebp
  80064a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80064b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800652:	83 ec 0c             	sub    $0xc,%esp
  800655:	25 07 0e 00 00       	and    $0xe07,%eax
  80065a:	50                   	push   %eax
  80065b:	57                   	push   %edi
  80065c:	6a 00                	push   $0x0
  80065e:	53                   	push   %ebx
  80065f:	6a 00                	push   $0x0
  800661:	e8 52 fb ff ff       	call   8001b8 <sys_page_map>
  800666:	89 c3                	mov    %eax,%ebx
  800668:	83 c4 20             	add    $0x20,%esp
  80066b:	85 c0                	test   %eax,%eax
  80066d:	79 a3                	jns    800612 <dup+0x78>
	sys_page_unmap(0, newfd);
  80066f:	83 ec 08             	sub    $0x8,%esp
  800672:	56                   	push   %esi
  800673:	6a 00                	push   $0x0
  800675:	e8 84 fb ff ff       	call   8001fe <sys_page_unmap>
	sys_page_unmap(0, nva);
  80067a:	83 c4 08             	add    $0x8,%esp
  80067d:	57                   	push   %edi
  80067e:	6a 00                	push   $0x0
  800680:	e8 79 fb ff ff       	call   8001fe <sys_page_unmap>
	return r;
  800685:	83 c4 10             	add    $0x10,%esp
  800688:	eb b7                	jmp    800641 <dup+0xa7>

0080068a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80068a:	f3 0f 1e fb          	endbr32 
  80068e:	55                   	push   %ebp
  80068f:	89 e5                	mov    %esp,%ebp
  800691:	53                   	push   %ebx
  800692:	83 ec 1c             	sub    $0x1c,%esp
  800695:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800698:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80069b:	50                   	push   %eax
  80069c:	53                   	push   %ebx
  80069d:	e8 65 fd ff ff       	call   800407 <fd_lookup>
  8006a2:	83 c4 10             	add    $0x10,%esp
  8006a5:	85 c0                	test   %eax,%eax
  8006a7:	78 3f                	js     8006e8 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006a9:	83 ec 08             	sub    $0x8,%esp
  8006ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006af:	50                   	push   %eax
  8006b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b3:	ff 30                	pushl  (%eax)
  8006b5:	e8 a1 fd ff ff       	call   80045b <dev_lookup>
  8006ba:	83 c4 10             	add    $0x10,%esp
  8006bd:	85 c0                	test   %eax,%eax
  8006bf:	78 27                	js     8006e8 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8006c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006c4:	8b 42 08             	mov    0x8(%edx),%eax
  8006c7:	83 e0 03             	and    $0x3,%eax
  8006ca:	83 f8 01             	cmp    $0x1,%eax
  8006cd:	74 1e                	je     8006ed <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006d2:	8b 40 08             	mov    0x8(%eax),%eax
  8006d5:	85 c0                	test   %eax,%eax
  8006d7:	74 35                	je     80070e <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006d9:	83 ec 04             	sub    $0x4,%esp
  8006dc:	ff 75 10             	pushl  0x10(%ebp)
  8006df:	ff 75 0c             	pushl  0xc(%ebp)
  8006e2:	52                   	push   %edx
  8006e3:	ff d0                	call   *%eax
  8006e5:	83 c4 10             	add    $0x10,%esp
}
  8006e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006eb:	c9                   	leave  
  8006ec:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006ed:	a1 04 40 80 00       	mov    0x804004,%eax
  8006f2:	8b 40 48             	mov    0x48(%eax),%eax
  8006f5:	83 ec 04             	sub    $0x4,%esp
  8006f8:	53                   	push   %ebx
  8006f9:	50                   	push   %eax
  8006fa:	68 79 1f 80 00       	push   $0x801f79
  8006ff:	e8 aa 0a 00 00       	call   8011ae <cprintf>
		return -E_INVAL;
  800704:	83 c4 10             	add    $0x10,%esp
  800707:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80070c:	eb da                	jmp    8006e8 <read+0x5e>
		return -E_NOT_SUPP;
  80070e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800713:	eb d3                	jmp    8006e8 <read+0x5e>

00800715 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800715:	f3 0f 1e fb          	endbr32 
  800719:	55                   	push   %ebp
  80071a:	89 e5                	mov    %esp,%ebp
  80071c:	57                   	push   %edi
  80071d:	56                   	push   %esi
  80071e:	53                   	push   %ebx
  80071f:	83 ec 0c             	sub    $0xc,%esp
  800722:	8b 7d 08             	mov    0x8(%ebp),%edi
  800725:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800728:	bb 00 00 00 00       	mov    $0x0,%ebx
  80072d:	eb 02                	jmp    800731 <readn+0x1c>
  80072f:	01 c3                	add    %eax,%ebx
  800731:	39 f3                	cmp    %esi,%ebx
  800733:	73 21                	jae    800756 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800735:	83 ec 04             	sub    $0x4,%esp
  800738:	89 f0                	mov    %esi,%eax
  80073a:	29 d8                	sub    %ebx,%eax
  80073c:	50                   	push   %eax
  80073d:	89 d8                	mov    %ebx,%eax
  80073f:	03 45 0c             	add    0xc(%ebp),%eax
  800742:	50                   	push   %eax
  800743:	57                   	push   %edi
  800744:	e8 41 ff ff ff       	call   80068a <read>
		if (m < 0)
  800749:	83 c4 10             	add    $0x10,%esp
  80074c:	85 c0                	test   %eax,%eax
  80074e:	78 04                	js     800754 <readn+0x3f>
			return m;
		if (m == 0)
  800750:	75 dd                	jne    80072f <readn+0x1a>
  800752:	eb 02                	jmp    800756 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800754:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800756:	89 d8                	mov    %ebx,%eax
  800758:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80075b:	5b                   	pop    %ebx
  80075c:	5e                   	pop    %esi
  80075d:	5f                   	pop    %edi
  80075e:	5d                   	pop    %ebp
  80075f:	c3                   	ret    

00800760 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800760:	f3 0f 1e fb          	endbr32 
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
  800767:	53                   	push   %ebx
  800768:	83 ec 1c             	sub    $0x1c,%esp
  80076b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80076e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800771:	50                   	push   %eax
  800772:	53                   	push   %ebx
  800773:	e8 8f fc ff ff       	call   800407 <fd_lookup>
  800778:	83 c4 10             	add    $0x10,%esp
  80077b:	85 c0                	test   %eax,%eax
  80077d:	78 3a                	js     8007b9 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800785:	50                   	push   %eax
  800786:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800789:	ff 30                	pushl  (%eax)
  80078b:	e8 cb fc ff ff       	call   80045b <dev_lookup>
  800790:	83 c4 10             	add    $0x10,%esp
  800793:	85 c0                	test   %eax,%eax
  800795:	78 22                	js     8007b9 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80079a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80079e:	74 1e                	je     8007be <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a3:	8b 52 0c             	mov    0xc(%edx),%edx
  8007a6:	85 d2                	test   %edx,%edx
  8007a8:	74 35                	je     8007df <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007aa:	83 ec 04             	sub    $0x4,%esp
  8007ad:	ff 75 10             	pushl  0x10(%ebp)
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	50                   	push   %eax
  8007b4:	ff d2                	call   *%edx
  8007b6:	83 c4 10             	add    $0x10,%esp
}
  8007b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007bc:	c9                   	leave  
  8007bd:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007be:	a1 04 40 80 00       	mov    0x804004,%eax
  8007c3:	8b 40 48             	mov    0x48(%eax),%eax
  8007c6:	83 ec 04             	sub    $0x4,%esp
  8007c9:	53                   	push   %ebx
  8007ca:	50                   	push   %eax
  8007cb:	68 95 1f 80 00       	push   $0x801f95
  8007d0:	e8 d9 09 00 00       	call   8011ae <cprintf>
		return -E_INVAL;
  8007d5:	83 c4 10             	add    $0x10,%esp
  8007d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007dd:	eb da                	jmp    8007b9 <write+0x59>
		return -E_NOT_SUPP;
  8007df:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007e4:	eb d3                	jmp    8007b9 <write+0x59>

008007e6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8007e6:	f3 0f 1e fb          	endbr32 
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
  8007ed:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007f3:	50                   	push   %eax
  8007f4:	ff 75 08             	pushl  0x8(%ebp)
  8007f7:	e8 0b fc ff ff       	call   800407 <fd_lookup>
  8007fc:	83 c4 10             	add    $0x10,%esp
  8007ff:	85 c0                	test   %eax,%eax
  800801:	78 0e                	js     800811 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  800803:	8b 55 0c             	mov    0xc(%ebp),%edx
  800806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800809:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80080c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800811:	c9                   	leave  
  800812:	c3                   	ret    

00800813 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800813:	f3 0f 1e fb          	endbr32 
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	53                   	push   %ebx
  80081b:	83 ec 1c             	sub    $0x1c,%esp
  80081e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800821:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800824:	50                   	push   %eax
  800825:	53                   	push   %ebx
  800826:	e8 dc fb ff ff       	call   800407 <fd_lookup>
  80082b:	83 c4 10             	add    $0x10,%esp
  80082e:	85 c0                	test   %eax,%eax
  800830:	78 37                	js     800869 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800838:	50                   	push   %eax
  800839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80083c:	ff 30                	pushl  (%eax)
  80083e:	e8 18 fc ff ff       	call   80045b <dev_lookup>
  800843:	83 c4 10             	add    $0x10,%esp
  800846:	85 c0                	test   %eax,%eax
  800848:	78 1f                	js     800869 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80084a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800851:	74 1b                	je     80086e <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800853:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800856:	8b 52 18             	mov    0x18(%edx),%edx
  800859:	85 d2                	test   %edx,%edx
  80085b:	74 32                	je     80088f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	ff 75 0c             	pushl  0xc(%ebp)
  800863:	50                   	push   %eax
  800864:	ff d2                	call   *%edx
  800866:	83 c4 10             	add    $0x10,%esp
}
  800869:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80086c:	c9                   	leave  
  80086d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80086e:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800873:	8b 40 48             	mov    0x48(%eax),%eax
  800876:	83 ec 04             	sub    $0x4,%esp
  800879:	53                   	push   %ebx
  80087a:	50                   	push   %eax
  80087b:	68 58 1f 80 00       	push   $0x801f58
  800880:	e8 29 09 00 00       	call   8011ae <cprintf>
		return -E_INVAL;
  800885:	83 c4 10             	add    $0x10,%esp
  800888:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80088d:	eb da                	jmp    800869 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80088f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800894:	eb d3                	jmp    800869 <ftruncate+0x56>

00800896 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800896:	f3 0f 1e fb          	endbr32 
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	53                   	push   %ebx
  80089e:	83 ec 1c             	sub    $0x1c,%esp
  8008a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008a7:	50                   	push   %eax
  8008a8:	ff 75 08             	pushl  0x8(%ebp)
  8008ab:	e8 57 fb ff ff       	call   800407 <fd_lookup>
  8008b0:	83 c4 10             	add    $0x10,%esp
  8008b3:	85 c0                	test   %eax,%eax
  8008b5:	78 4b                	js     800902 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008b7:	83 ec 08             	sub    $0x8,%esp
  8008ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008bd:	50                   	push   %eax
  8008be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c1:	ff 30                	pushl  (%eax)
  8008c3:	e8 93 fb ff ff       	call   80045b <dev_lookup>
  8008c8:	83 c4 10             	add    $0x10,%esp
  8008cb:	85 c0                	test   %eax,%eax
  8008cd:	78 33                	js     800902 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8008cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d2:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8008d6:	74 2f                	je     800907 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8008d8:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8008db:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8008e2:	00 00 00 
	stat->st_isdir = 0;
  8008e5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008ec:	00 00 00 
	stat->st_dev = dev;
  8008ef:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008f5:	83 ec 08             	sub    $0x8,%esp
  8008f8:	53                   	push   %ebx
  8008f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8008fc:	ff 50 14             	call   *0x14(%eax)
  8008ff:	83 c4 10             	add    $0x10,%esp
}
  800902:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800905:	c9                   	leave  
  800906:	c3                   	ret    
		return -E_NOT_SUPP;
  800907:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80090c:	eb f4                	jmp    800902 <fstat+0x6c>

0080090e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80090e:	f3 0f 1e fb          	endbr32 
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	56                   	push   %esi
  800916:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	6a 00                	push   $0x0
  80091c:	ff 75 08             	pushl  0x8(%ebp)
  80091f:	e8 fb 01 00 00       	call   800b1f <open>
  800924:	89 c3                	mov    %eax,%ebx
  800926:	83 c4 10             	add    $0x10,%esp
  800929:	85 c0                	test   %eax,%eax
  80092b:	78 1b                	js     800948 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80092d:	83 ec 08             	sub    $0x8,%esp
  800930:	ff 75 0c             	pushl  0xc(%ebp)
  800933:	50                   	push   %eax
  800934:	e8 5d ff ff ff       	call   800896 <fstat>
  800939:	89 c6                	mov    %eax,%esi
	close(fd);
  80093b:	89 1c 24             	mov    %ebx,(%esp)
  80093e:	e8 fd fb ff ff       	call   800540 <close>
	return r;
  800943:	83 c4 10             	add    $0x10,%esp
  800946:	89 f3                	mov    %esi,%ebx
}
  800948:	89 d8                	mov    %ebx,%eax
  80094a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80094d:	5b                   	pop    %ebx
  80094e:	5e                   	pop    %esi
  80094f:	5d                   	pop    %ebp
  800950:	c3                   	ret    

00800951 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	56                   	push   %esi
  800955:	53                   	push   %ebx
  800956:	89 c6                	mov    %eax,%esi
  800958:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80095a:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800961:	74 27                	je     80098a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800963:	6a 07                	push   $0x7
  800965:	68 00 50 80 00       	push   $0x805000
  80096a:	56                   	push   %esi
  80096b:	ff 35 00 40 80 00    	pushl  0x804000
  800971:	e8 39 12 00 00       	call   801baf <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800976:	83 c4 0c             	add    $0xc,%esp
  800979:	6a 00                	push   $0x0
  80097b:	53                   	push   %ebx
  80097c:	6a 00                	push   $0x0
  80097e:	e8 a7 11 00 00       	call   801b2a <ipc_recv>
}
  800983:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800986:	5b                   	pop    %ebx
  800987:	5e                   	pop    %esi
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80098a:	83 ec 0c             	sub    $0xc,%esp
  80098d:	6a 01                	push   $0x1
  80098f:	e8 73 12 00 00       	call   801c07 <ipc_find_env>
  800994:	a3 00 40 80 00       	mov    %eax,0x804000
  800999:	83 c4 10             	add    $0x10,%esp
  80099c:	eb c5                	jmp    800963 <fsipc+0x12>

0080099e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80099e:	f3 0f 1e fb          	endbr32 
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8009ae:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b6:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c0:	b8 02 00 00 00       	mov    $0x2,%eax
  8009c5:	e8 87 ff ff ff       	call   800951 <fsipc>
}
  8009ca:	c9                   	leave  
  8009cb:	c3                   	ret    

008009cc <devfile_flush>:
{
  8009cc:	f3 0f 1e fb          	endbr32 
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8009dc:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8009e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e6:	b8 06 00 00 00       	mov    $0x6,%eax
  8009eb:	e8 61 ff ff ff       	call   800951 <fsipc>
}
  8009f0:	c9                   	leave  
  8009f1:	c3                   	ret    

008009f2 <devfile_stat>:
{
  8009f2:	f3 0f 1e fb          	endbr32 
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	53                   	push   %ebx
  8009fa:	83 ec 04             	sub    $0x4,%esp
  8009fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	8b 40 0c             	mov    0xc(%eax),%eax
  800a06:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a10:	b8 05 00 00 00       	mov    $0x5,%eax
  800a15:	e8 37 ff ff ff       	call   800951 <fsipc>
  800a1a:	85 c0                	test   %eax,%eax
  800a1c:	78 2c                	js     800a4a <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	68 00 50 80 00       	push   $0x805000
  800a26:	53                   	push   %ebx
  800a27:	e8 8c 0d 00 00       	call   8017b8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a2c:	a1 80 50 80 00       	mov    0x805080,%eax
  800a31:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800a37:	a1 84 50 80 00       	mov    0x805084,%eax
  800a3c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a42:	83 c4 10             	add    $0x10,%esp
  800a45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a4d:	c9                   	leave  
  800a4e:	c3                   	ret    

00800a4f <devfile_write>:
{
  800a4f:	f3 0f 1e fb          	endbr32 
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	83 ec 0c             	sub    $0xc,%esp
  800a59:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a5f:	8b 52 0c             	mov    0xc(%edx),%edx
  800a62:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  800a68:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800a6d:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800a72:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  800a75:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a7a:	50                   	push   %eax
  800a7b:	ff 75 0c             	pushl  0xc(%ebp)
  800a7e:	68 08 50 80 00       	push   $0x805008
  800a83:	e8 e6 0e 00 00       	call   80196e <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800a88:	ba 00 00 00 00       	mov    $0x0,%edx
  800a8d:	b8 04 00 00 00       	mov    $0x4,%eax
  800a92:	e8 ba fe ff ff       	call   800951 <fsipc>
}
  800a97:	c9                   	leave  
  800a98:	c3                   	ret    

00800a99 <devfile_read>:
{
  800a99:	f3 0f 1e fb          	endbr32 
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	56                   	push   %esi
  800aa1:	53                   	push   %ebx
  800aa2:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	8b 40 0c             	mov    0xc(%eax),%eax
  800aab:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800ab0:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800ab6:	ba 00 00 00 00       	mov    $0x0,%edx
  800abb:	b8 03 00 00 00       	mov    $0x3,%eax
  800ac0:	e8 8c fe ff ff       	call   800951 <fsipc>
  800ac5:	89 c3                	mov    %eax,%ebx
  800ac7:	85 c0                	test   %eax,%eax
  800ac9:	78 1f                	js     800aea <devfile_read+0x51>
	assert(r <= n);
  800acb:	39 f0                	cmp    %esi,%eax
  800acd:	77 24                	ja     800af3 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800acf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ad4:	7f 33                	jg     800b09 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800ad6:	83 ec 04             	sub    $0x4,%esp
  800ad9:	50                   	push   %eax
  800ada:	68 00 50 80 00       	push   $0x805000
  800adf:	ff 75 0c             	pushl  0xc(%ebp)
  800ae2:	e8 87 0e 00 00       	call   80196e <memmove>
	return r;
  800ae7:	83 c4 10             	add    $0x10,%esp
}
  800aea:	89 d8                	mov    %ebx,%eax
  800aec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aef:	5b                   	pop    %ebx
  800af0:	5e                   	pop    %esi
  800af1:	5d                   	pop    %ebp
  800af2:	c3                   	ret    
	assert(r <= n);
  800af3:	68 c4 1f 80 00       	push   $0x801fc4
  800af8:	68 cb 1f 80 00       	push   $0x801fcb
  800afd:	6a 7c                	push   $0x7c
  800aff:	68 e0 1f 80 00       	push   $0x801fe0
  800b04:	e8 be 05 00 00       	call   8010c7 <_panic>
	assert(r <= PGSIZE);
  800b09:	68 eb 1f 80 00       	push   $0x801feb
  800b0e:	68 cb 1f 80 00       	push   $0x801fcb
  800b13:	6a 7d                	push   $0x7d
  800b15:	68 e0 1f 80 00       	push   $0x801fe0
  800b1a:	e8 a8 05 00 00       	call   8010c7 <_panic>

00800b1f <open>:
{
  800b1f:	f3 0f 1e fb          	endbr32 
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	56                   	push   %esi
  800b27:	53                   	push   %ebx
  800b28:	83 ec 1c             	sub    $0x1c,%esp
  800b2b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b2e:	56                   	push   %esi
  800b2f:	e8 41 0c 00 00       	call   801775 <strlen>
  800b34:	83 c4 10             	add    $0x10,%esp
  800b37:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b3c:	7f 6c                	jg     800baa <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b3e:	83 ec 0c             	sub    $0xc,%esp
  800b41:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b44:	50                   	push   %eax
  800b45:	e8 67 f8 ff ff       	call   8003b1 <fd_alloc>
  800b4a:	89 c3                	mov    %eax,%ebx
  800b4c:	83 c4 10             	add    $0x10,%esp
  800b4f:	85 c0                	test   %eax,%eax
  800b51:	78 3c                	js     800b8f <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b53:	83 ec 08             	sub    $0x8,%esp
  800b56:	56                   	push   %esi
  800b57:	68 00 50 80 00       	push   $0x805000
  800b5c:	e8 57 0c 00 00       	call   8017b8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b64:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b6c:	b8 01 00 00 00       	mov    $0x1,%eax
  800b71:	e8 db fd ff ff       	call   800951 <fsipc>
  800b76:	89 c3                	mov    %eax,%ebx
  800b78:	83 c4 10             	add    $0x10,%esp
  800b7b:	85 c0                	test   %eax,%eax
  800b7d:	78 19                	js     800b98 <open+0x79>
	return fd2num(fd);
  800b7f:	83 ec 0c             	sub    $0xc,%esp
  800b82:	ff 75 f4             	pushl  -0xc(%ebp)
  800b85:	e8 f8 f7 ff ff       	call   800382 <fd2num>
  800b8a:	89 c3                	mov    %eax,%ebx
  800b8c:	83 c4 10             	add    $0x10,%esp
}
  800b8f:	89 d8                	mov    %ebx,%eax
  800b91:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b94:	5b                   	pop    %ebx
  800b95:	5e                   	pop    %esi
  800b96:	5d                   	pop    %ebp
  800b97:	c3                   	ret    
		fd_close(fd, 0);
  800b98:	83 ec 08             	sub    $0x8,%esp
  800b9b:	6a 00                	push   $0x0
  800b9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba0:	e8 10 f9 ff ff       	call   8004b5 <fd_close>
		return r;
  800ba5:	83 c4 10             	add    $0x10,%esp
  800ba8:	eb e5                	jmp    800b8f <open+0x70>
		return -E_BAD_PATH;
  800baa:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800baf:	eb de                	jmp    800b8f <open+0x70>

00800bb1 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800bb1:	f3 0f 1e fb          	endbr32 
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800bbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc0:	b8 08 00 00 00       	mov    $0x8,%eax
  800bc5:	e8 87 fd ff ff       	call   800951 <fsipc>
}
  800bca:	c9                   	leave  
  800bcb:	c3                   	ret    

00800bcc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800bcc:	f3 0f 1e fb          	endbr32 
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	56                   	push   %esi
  800bd4:	53                   	push   %ebx
  800bd5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800bd8:	83 ec 0c             	sub    $0xc,%esp
  800bdb:	ff 75 08             	pushl  0x8(%ebp)
  800bde:	e8 b3 f7 ff ff       	call   800396 <fd2data>
  800be3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800be5:	83 c4 08             	add    $0x8,%esp
  800be8:	68 f7 1f 80 00       	push   $0x801ff7
  800bed:	53                   	push   %ebx
  800bee:	e8 c5 0b 00 00       	call   8017b8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bf3:	8b 46 04             	mov    0x4(%esi),%eax
  800bf6:	2b 06                	sub    (%esi),%eax
  800bf8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bfe:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800c05:	00 00 00 
	stat->st_dev = &devpipe;
  800c08:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c0f:	30 80 00 
	return 0;
}
  800c12:	b8 00 00 00 00       	mov    $0x0,%eax
  800c17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c1a:	5b                   	pop    %ebx
  800c1b:	5e                   	pop    %esi
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    

00800c1e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c1e:	f3 0f 1e fb          	endbr32 
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	53                   	push   %ebx
  800c26:	83 ec 0c             	sub    $0xc,%esp
  800c29:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c2c:	53                   	push   %ebx
  800c2d:	6a 00                	push   $0x0
  800c2f:	e8 ca f5 ff ff       	call   8001fe <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c34:	89 1c 24             	mov    %ebx,(%esp)
  800c37:	e8 5a f7 ff ff       	call   800396 <fd2data>
  800c3c:	83 c4 08             	add    $0x8,%esp
  800c3f:	50                   	push   %eax
  800c40:	6a 00                	push   $0x0
  800c42:	e8 b7 f5 ff ff       	call   8001fe <sys_page_unmap>
}
  800c47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c4a:	c9                   	leave  
  800c4b:	c3                   	ret    

00800c4c <_pipeisclosed>:
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	57                   	push   %edi
  800c50:	56                   	push   %esi
  800c51:	53                   	push   %ebx
  800c52:	83 ec 1c             	sub    $0x1c,%esp
  800c55:	89 c7                	mov    %eax,%edi
  800c57:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c59:	a1 04 40 80 00       	mov    0x804004,%eax
  800c5e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c61:	83 ec 0c             	sub    $0xc,%esp
  800c64:	57                   	push   %edi
  800c65:	e8 da 0f 00 00       	call   801c44 <pageref>
  800c6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c6d:	89 34 24             	mov    %esi,(%esp)
  800c70:	e8 cf 0f 00 00       	call   801c44 <pageref>
		nn = thisenv->env_runs;
  800c75:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800c7b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c7e:	83 c4 10             	add    $0x10,%esp
  800c81:	39 cb                	cmp    %ecx,%ebx
  800c83:	74 1b                	je     800ca0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c85:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c88:	75 cf                	jne    800c59 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c8a:	8b 42 58             	mov    0x58(%edx),%eax
  800c8d:	6a 01                	push   $0x1
  800c8f:	50                   	push   %eax
  800c90:	53                   	push   %ebx
  800c91:	68 fe 1f 80 00       	push   $0x801ffe
  800c96:	e8 13 05 00 00       	call   8011ae <cprintf>
  800c9b:	83 c4 10             	add    $0x10,%esp
  800c9e:	eb b9                	jmp    800c59 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800ca0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800ca3:	0f 94 c0             	sete   %al
  800ca6:	0f b6 c0             	movzbl %al,%eax
}
  800ca9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cac:	5b                   	pop    %ebx
  800cad:	5e                   	pop    %esi
  800cae:	5f                   	pop    %edi
  800caf:	5d                   	pop    %ebp
  800cb0:	c3                   	ret    

00800cb1 <devpipe_write>:
{
  800cb1:	f3 0f 1e fb          	endbr32 
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	57                   	push   %edi
  800cb9:	56                   	push   %esi
  800cba:	53                   	push   %ebx
  800cbb:	83 ec 28             	sub    $0x28,%esp
  800cbe:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800cc1:	56                   	push   %esi
  800cc2:	e8 cf f6 ff ff       	call   800396 <fd2data>
  800cc7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800cc9:	83 c4 10             	add    $0x10,%esp
  800ccc:	bf 00 00 00 00       	mov    $0x0,%edi
  800cd1:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800cd4:	74 4f                	je     800d25 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800cd6:	8b 43 04             	mov    0x4(%ebx),%eax
  800cd9:	8b 0b                	mov    (%ebx),%ecx
  800cdb:	8d 51 20             	lea    0x20(%ecx),%edx
  800cde:	39 d0                	cmp    %edx,%eax
  800ce0:	72 14                	jb     800cf6 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  800ce2:	89 da                	mov    %ebx,%edx
  800ce4:	89 f0                	mov    %esi,%eax
  800ce6:	e8 61 ff ff ff       	call   800c4c <_pipeisclosed>
  800ceb:	85 c0                	test   %eax,%eax
  800ced:	75 3b                	jne    800d2a <devpipe_write+0x79>
			sys_yield();
  800cef:	e8 5a f4 ff ff       	call   80014e <sys_yield>
  800cf4:	eb e0                	jmp    800cd6 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cf6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cfd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800d00:	89 c2                	mov    %eax,%edx
  800d02:	c1 fa 1f             	sar    $0x1f,%edx
  800d05:	89 d1                	mov    %edx,%ecx
  800d07:	c1 e9 1b             	shr    $0x1b,%ecx
  800d0a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800d0d:	83 e2 1f             	and    $0x1f,%edx
  800d10:	29 ca                	sub    %ecx,%edx
  800d12:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800d16:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800d1a:	83 c0 01             	add    $0x1,%eax
  800d1d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d20:	83 c7 01             	add    $0x1,%edi
  800d23:	eb ac                	jmp    800cd1 <devpipe_write+0x20>
	return i;
  800d25:	8b 45 10             	mov    0x10(%ebp),%eax
  800d28:	eb 05                	jmp    800d2f <devpipe_write+0x7e>
				return 0;
  800d2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5f                   	pop    %edi
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <devpipe_read>:
{
  800d37:	f3 0f 1e fb          	endbr32 
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	57                   	push   %edi
  800d3f:	56                   	push   %esi
  800d40:	53                   	push   %ebx
  800d41:	83 ec 18             	sub    $0x18,%esp
  800d44:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d47:	57                   	push   %edi
  800d48:	e8 49 f6 ff ff       	call   800396 <fd2data>
  800d4d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d4f:	83 c4 10             	add    $0x10,%esp
  800d52:	be 00 00 00 00       	mov    $0x0,%esi
  800d57:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d5a:	75 14                	jne    800d70 <devpipe_read+0x39>
	return i;
  800d5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5f:	eb 02                	jmp    800d63 <devpipe_read+0x2c>
				return i;
  800d61:	89 f0                	mov    %esi,%eax
}
  800d63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d66:	5b                   	pop    %ebx
  800d67:	5e                   	pop    %esi
  800d68:	5f                   	pop    %edi
  800d69:	5d                   	pop    %ebp
  800d6a:	c3                   	ret    
			sys_yield();
  800d6b:	e8 de f3 ff ff       	call   80014e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d70:	8b 03                	mov    (%ebx),%eax
  800d72:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d75:	75 18                	jne    800d8f <devpipe_read+0x58>
			if (i > 0)
  800d77:	85 f6                	test   %esi,%esi
  800d79:	75 e6                	jne    800d61 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  800d7b:	89 da                	mov    %ebx,%edx
  800d7d:	89 f8                	mov    %edi,%eax
  800d7f:	e8 c8 fe ff ff       	call   800c4c <_pipeisclosed>
  800d84:	85 c0                	test   %eax,%eax
  800d86:	74 e3                	je     800d6b <devpipe_read+0x34>
				return 0;
  800d88:	b8 00 00 00 00       	mov    $0x0,%eax
  800d8d:	eb d4                	jmp    800d63 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d8f:	99                   	cltd   
  800d90:	c1 ea 1b             	shr    $0x1b,%edx
  800d93:	01 d0                	add    %edx,%eax
  800d95:	83 e0 1f             	and    $0x1f,%eax
  800d98:	29 d0                	sub    %edx,%eax
  800d9a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da2:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800da5:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800da8:	83 c6 01             	add    $0x1,%esi
  800dab:	eb aa                	jmp    800d57 <devpipe_read+0x20>

00800dad <pipe>:
{
  800dad:	f3 0f 1e fb          	endbr32 
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	56                   	push   %esi
  800db5:	53                   	push   %ebx
  800db6:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800db9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dbc:	50                   	push   %eax
  800dbd:	e8 ef f5 ff ff       	call   8003b1 <fd_alloc>
  800dc2:	89 c3                	mov    %eax,%ebx
  800dc4:	83 c4 10             	add    $0x10,%esp
  800dc7:	85 c0                	test   %eax,%eax
  800dc9:	0f 88 23 01 00 00    	js     800ef2 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dcf:	83 ec 04             	sub    $0x4,%esp
  800dd2:	68 07 04 00 00       	push   $0x407
  800dd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800dda:	6a 00                	push   $0x0
  800ddc:	e8 90 f3 ff ff       	call   800171 <sys_page_alloc>
  800de1:	89 c3                	mov    %eax,%ebx
  800de3:	83 c4 10             	add    $0x10,%esp
  800de6:	85 c0                	test   %eax,%eax
  800de8:	0f 88 04 01 00 00    	js     800ef2 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  800dee:	83 ec 0c             	sub    $0xc,%esp
  800df1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800df4:	50                   	push   %eax
  800df5:	e8 b7 f5 ff ff       	call   8003b1 <fd_alloc>
  800dfa:	89 c3                	mov    %eax,%ebx
  800dfc:	83 c4 10             	add    $0x10,%esp
  800dff:	85 c0                	test   %eax,%eax
  800e01:	0f 88 db 00 00 00    	js     800ee2 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e07:	83 ec 04             	sub    $0x4,%esp
  800e0a:	68 07 04 00 00       	push   $0x407
  800e0f:	ff 75 f0             	pushl  -0x10(%ebp)
  800e12:	6a 00                	push   $0x0
  800e14:	e8 58 f3 ff ff       	call   800171 <sys_page_alloc>
  800e19:	89 c3                	mov    %eax,%ebx
  800e1b:	83 c4 10             	add    $0x10,%esp
  800e1e:	85 c0                	test   %eax,%eax
  800e20:	0f 88 bc 00 00 00    	js     800ee2 <pipe+0x135>
	va = fd2data(fd0);
  800e26:	83 ec 0c             	sub    $0xc,%esp
  800e29:	ff 75 f4             	pushl  -0xc(%ebp)
  800e2c:	e8 65 f5 ff ff       	call   800396 <fd2data>
  800e31:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e33:	83 c4 0c             	add    $0xc,%esp
  800e36:	68 07 04 00 00       	push   $0x407
  800e3b:	50                   	push   %eax
  800e3c:	6a 00                	push   $0x0
  800e3e:	e8 2e f3 ff ff       	call   800171 <sys_page_alloc>
  800e43:	89 c3                	mov    %eax,%ebx
  800e45:	83 c4 10             	add    $0x10,%esp
  800e48:	85 c0                	test   %eax,%eax
  800e4a:	0f 88 82 00 00 00    	js     800ed2 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e50:	83 ec 0c             	sub    $0xc,%esp
  800e53:	ff 75 f0             	pushl  -0x10(%ebp)
  800e56:	e8 3b f5 ff ff       	call   800396 <fd2data>
  800e5b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e62:	50                   	push   %eax
  800e63:	6a 00                	push   $0x0
  800e65:	56                   	push   %esi
  800e66:	6a 00                	push   $0x0
  800e68:	e8 4b f3 ff ff       	call   8001b8 <sys_page_map>
  800e6d:	89 c3                	mov    %eax,%ebx
  800e6f:	83 c4 20             	add    $0x20,%esp
  800e72:	85 c0                	test   %eax,%eax
  800e74:	78 4e                	js     800ec4 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  800e76:	a1 20 30 80 00       	mov    0x803020,%eax
  800e7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e7e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e83:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e8d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e92:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e99:	83 ec 0c             	sub    $0xc,%esp
  800e9c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e9f:	e8 de f4 ff ff       	call   800382 <fd2num>
  800ea4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ea7:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800ea9:	83 c4 04             	add    $0x4,%esp
  800eac:	ff 75 f0             	pushl  -0x10(%ebp)
  800eaf:	e8 ce f4 ff ff       	call   800382 <fd2num>
  800eb4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eb7:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800eba:	83 c4 10             	add    $0x10,%esp
  800ebd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec2:	eb 2e                	jmp    800ef2 <pipe+0x145>
	sys_page_unmap(0, va);
  800ec4:	83 ec 08             	sub    $0x8,%esp
  800ec7:	56                   	push   %esi
  800ec8:	6a 00                	push   $0x0
  800eca:	e8 2f f3 ff ff       	call   8001fe <sys_page_unmap>
  800ecf:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800ed2:	83 ec 08             	sub    $0x8,%esp
  800ed5:	ff 75 f0             	pushl  -0x10(%ebp)
  800ed8:	6a 00                	push   $0x0
  800eda:	e8 1f f3 ff ff       	call   8001fe <sys_page_unmap>
  800edf:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800ee2:	83 ec 08             	sub    $0x8,%esp
  800ee5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee8:	6a 00                	push   $0x0
  800eea:	e8 0f f3 ff ff       	call   8001fe <sys_page_unmap>
  800eef:	83 c4 10             	add    $0x10,%esp
}
  800ef2:	89 d8                	mov    %ebx,%eax
  800ef4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ef7:	5b                   	pop    %ebx
  800ef8:	5e                   	pop    %esi
  800ef9:	5d                   	pop    %ebp
  800efa:	c3                   	ret    

00800efb <pipeisclosed>:
{
  800efb:	f3 0f 1e fb          	endbr32 
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f05:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f08:	50                   	push   %eax
  800f09:	ff 75 08             	pushl  0x8(%ebp)
  800f0c:	e8 f6 f4 ff ff       	call   800407 <fd_lookup>
  800f11:	83 c4 10             	add    $0x10,%esp
  800f14:	85 c0                	test   %eax,%eax
  800f16:	78 18                	js     800f30 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  800f18:	83 ec 0c             	sub    $0xc,%esp
  800f1b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f1e:	e8 73 f4 ff ff       	call   800396 <fd2data>
  800f23:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  800f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f28:	e8 1f fd ff ff       	call   800c4c <_pipeisclosed>
  800f2d:	83 c4 10             	add    $0x10,%esp
}
  800f30:	c9                   	leave  
  800f31:	c3                   	ret    

00800f32 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800f32:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  800f36:	b8 00 00 00 00       	mov    $0x0,%eax
  800f3b:	c3                   	ret    

00800f3c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f3c:	f3 0f 1e fb          	endbr32 
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800f46:	68 16 20 80 00       	push   $0x802016
  800f4b:	ff 75 0c             	pushl  0xc(%ebp)
  800f4e:	e8 65 08 00 00       	call   8017b8 <strcpy>
	return 0;
}
  800f53:	b8 00 00 00 00       	mov    $0x0,%eax
  800f58:	c9                   	leave  
  800f59:	c3                   	ret    

00800f5a <devcons_write>:
{
  800f5a:	f3 0f 1e fb          	endbr32 
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	57                   	push   %edi
  800f62:	56                   	push   %esi
  800f63:	53                   	push   %ebx
  800f64:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800f6a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800f6f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800f75:	3b 75 10             	cmp    0x10(%ebp),%esi
  800f78:	73 31                	jae    800fab <devcons_write+0x51>
		m = n - tot;
  800f7a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7d:	29 f3                	sub    %esi,%ebx
  800f7f:	83 fb 7f             	cmp    $0x7f,%ebx
  800f82:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800f87:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800f8a:	83 ec 04             	sub    $0x4,%esp
  800f8d:	53                   	push   %ebx
  800f8e:	89 f0                	mov    %esi,%eax
  800f90:	03 45 0c             	add    0xc(%ebp),%eax
  800f93:	50                   	push   %eax
  800f94:	57                   	push   %edi
  800f95:	e8 d4 09 00 00       	call   80196e <memmove>
		sys_cputs(buf, m);
  800f9a:	83 c4 08             	add    $0x8,%esp
  800f9d:	53                   	push   %ebx
  800f9e:	57                   	push   %edi
  800f9f:	e8 fd f0 ff ff       	call   8000a1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800fa4:	01 de                	add    %ebx,%esi
  800fa6:	83 c4 10             	add    $0x10,%esp
  800fa9:	eb ca                	jmp    800f75 <devcons_write+0x1b>
}
  800fab:	89 f0                	mov    %esi,%eax
  800fad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb0:	5b                   	pop    %ebx
  800fb1:	5e                   	pop    %esi
  800fb2:	5f                   	pop    %edi
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    

00800fb5 <devcons_read>:
{
  800fb5:	f3 0f 1e fb          	endbr32 
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	83 ec 08             	sub    $0x8,%esp
  800fbf:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800fc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc8:	74 21                	je     800feb <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800fca:	e8 f4 f0 ff ff       	call   8000c3 <sys_cgetc>
  800fcf:	85 c0                	test   %eax,%eax
  800fd1:	75 07                	jne    800fda <devcons_read+0x25>
		sys_yield();
  800fd3:	e8 76 f1 ff ff       	call   80014e <sys_yield>
  800fd8:	eb f0                	jmp    800fca <devcons_read+0x15>
	if (c < 0)
  800fda:	78 0f                	js     800feb <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  800fdc:	83 f8 04             	cmp    $0x4,%eax
  800fdf:	74 0c                	je     800fed <devcons_read+0x38>
	*(char*)vbuf = c;
  800fe1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe4:	88 02                	mov    %al,(%edx)
	return 1;
  800fe6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800feb:	c9                   	leave  
  800fec:	c3                   	ret    
		return 0;
  800fed:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff2:	eb f7                	jmp    800feb <devcons_read+0x36>

00800ff4 <cputchar>:
{
  800ff4:	f3 0f 1e fb          	endbr32 
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
  800ffb:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801004:	6a 01                	push   $0x1
  801006:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801009:	50                   	push   %eax
  80100a:	e8 92 f0 ff ff       	call   8000a1 <sys_cputs>
}
  80100f:	83 c4 10             	add    $0x10,%esp
  801012:	c9                   	leave  
  801013:	c3                   	ret    

00801014 <getchar>:
{
  801014:	f3 0f 1e fb          	endbr32 
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80101e:	6a 01                	push   $0x1
  801020:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801023:	50                   	push   %eax
  801024:	6a 00                	push   $0x0
  801026:	e8 5f f6 ff ff       	call   80068a <read>
	if (r < 0)
  80102b:	83 c4 10             	add    $0x10,%esp
  80102e:	85 c0                	test   %eax,%eax
  801030:	78 06                	js     801038 <getchar+0x24>
	if (r < 1)
  801032:	74 06                	je     80103a <getchar+0x26>
	return c;
  801034:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801038:	c9                   	leave  
  801039:	c3                   	ret    
		return -E_EOF;
  80103a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80103f:	eb f7                	jmp    801038 <getchar+0x24>

00801041 <iscons>:
{
  801041:	f3 0f 1e fb          	endbr32 
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80104b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80104e:	50                   	push   %eax
  80104f:	ff 75 08             	pushl  0x8(%ebp)
  801052:	e8 b0 f3 ff ff       	call   800407 <fd_lookup>
  801057:	83 c4 10             	add    $0x10,%esp
  80105a:	85 c0                	test   %eax,%eax
  80105c:	78 11                	js     80106f <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80105e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801061:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801067:	39 10                	cmp    %edx,(%eax)
  801069:	0f 94 c0             	sete   %al
  80106c:	0f b6 c0             	movzbl %al,%eax
}
  80106f:	c9                   	leave  
  801070:	c3                   	ret    

00801071 <opencons>:
{
  801071:	f3 0f 1e fb          	endbr32 
  801075:	55                   	push   %ebp
  801076:	89 e5                	mov    %esp,%ebp
  801078:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80107b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80107e:	50                   	push   %eax
  80107f:	e8 2d f3 ff ff       	call   8003b1 <fd_alloc>
  801084:	83 c4 10             	add    $0x10,%esp
  801087:	85 c0                	test   %eax,%eax
  801089:	78 3a                	js     8010c5 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80108b:	83 ec 04             	sub    $0x4,%esp
  80108e:	68 07 04 00 00       	push   $0x407
  801093:	ff 75 f4             	pushl  -0xc(%ebp)
  801096:	6a 00                	push   $0x0
  801098:	e8 d4 f0 ff ff       	call   800171 <sys_page_alloc>
  80109d:	83 c4 10             	add    $0x10,%esp
  8010a0:	85 c0                	test   %eax,%eax
  8010a2:	78 21                	js     8010c5 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8010a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010a7:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010ad:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8010af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8010b9:	83 ec 0c             	sub    $0xc,%esp
  8010bc:	50                   	push   %eax
  8010bd:	e8 c0 f2 ff ff       	call   800382 <fd2num>
  8010c2:	83 c4 10             	add    $0x10,%esp
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8010c7:	f3 0f 1e fb          	endbr32 
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	56                   	push   %esi
  8010cf:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8010d0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8010d3:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8010d9:	e8 4d f0 ff ff       	call   80012b <sys_getenvid>
  8010de:	83 ec 0c             	sub    $0xc,%esp
  8010e1:	ff 75 0c             	pushl  0xc(%ebp)
  8010e4:	ff 75 08             	pushl  0x8(%ebp)
  8010e7:	56                   	push   %esi
  8010e8:	50                   	push   %eax
  8010e9:	68 24 20 80 00       	push   $0x802024
  8010ee:	e8 bb 00 00 00       	call   8011ae <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8010f3:	83 c4 18             	add    $0x18,%esp
  8010f6:	53                   	push   %ebx
  8010f7:	ff 75 10             	pushl  0x10(%ebp)
  8010fa:	e8 5a 00 00 00       	call   801159 <vcprintf>
	cprintf("\n");
  8010ff:	c7 04 24 58 23 80 00 	movl   $0x802358,(%esp)
  801106:	e8 a3 00 00 00       	call   8011ae <cprintf>
  80110b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80110e:	cc                   	int3   
  80110f:	eb fd                	jmp    80110e <_panic+0x47>

00801111 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801111:	f3 0f 1e fb          	endbr32 
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	53                   	push   %ebx
  801119:	83 ec 04             	sub    $0x4,%esp
  80111c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80111f:	8b 13                	mov    (%ebx),%edx
  801121:	8d 42 01             	lea    0x1(%edx),%eax
  801124:	89 03                	mov    %eax,(%ebx)
  801126:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801129:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80112d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801132:	74 09                	je     80113d <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801134:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801138:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80113d:	83 ec 08             	sub    $0x8,%esp
  801140:	68 ff 00 00 00       	push   $0xff
  801145:	8d 43 08             	lea    0x8(%ebx),%eax
  801148:	50                   	push   %eax
  801149:	e8 53 ef ff ff       	call   8000a1 <sys_cputs>
		b->idx = 0;
  80114e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801154:	83 c4 10             	add    $0x10,%esp
  801157:	eb db                	jmp    801134 <putch+0x23>

00801159 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801159:	f3 0f 1e fb          	endbr32 
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801166:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80116d:	00 00 00 
	b.cnt = 0;
  801170:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801177:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80117a:	ff 75 0c             	pushl  0xc(%ebp)
  80117d:	ff 75 08             	pushl  0x8(%ebp)
  801180:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801186:	50                   	push   %eax
  801187:	68 11 11 80 00       	push   $0x801111
  80118c:	e8 20 01 00 00       	call   8012b1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801191:	83 c4 08             	add    $0x8,%esp
  801194:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80119a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8011a0:	50                   	push   %eax
  8011a1:	e8 fb ee ff ff       	call   8000a1 <sys_cputs>

	return b.cnt;
}
  8011a6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8011ac:	c9                   	leave  
  8011ad:	c3                   	ret    

008011ae <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8011ae:	f3 0f 1e fb          	endbr32 
  8011b2:	55                   	push   %ebp
  8011b3:	89 e5                	mov    %esp,%ebp
  8011b5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8011b8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8011bb:	50                   	push   %eax
  8011bc:	ff 75 08             	pushl  0x8(%ebp)
  8011bf:	e8 95 ff ff ff       	call   801159 <vcprintf>
	va_end(ap);

	return cnt;
}
  8011c4:	c9                   	leave  
  8011c5:	c3                   	ret    

008011c6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
  8011c9:	57                   	push   %edi
  8011ca:	56                   	push   %esi
  8011cb:	53                   	push   %ebx
  8011cc:	83 ec 1c             	sub    $0x1c,%esp
  8011cf:	89 c7                	mov    %eax,%edi
  8011d1:	89 d6                	mov    %edx,%esi
  8011d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d9:	89 d1                	mov    %edx,%ecx
  8011db:	89 c2                	mov    %eax,%edx
  8011dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011e0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8011e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8011ec:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8011f3:	39 c2                	cmp    %eax,%edx
  8011f5:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8011f8:	72 3e                	jb     801238 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8011fa:	83 ec 0c             	sub    $0xc,%esp
  8011fd:	ff 75 18             	pushl  0x18(%ebp)
  801200:	83 eb 01             	sub    $0x1,%ebx
  801203:	53                   	push   %ebx
  801204:	50                   	push   %eax
  801205:	83 ec 08             	sub    $0x8,%esp
  801208:	ff 75 e4             	pushl  -0x1c(%ebp)
  80120b:	ff 75 e0             	pushl  -0x20(%ebp)
  80120e:	ff 75 dc             	pushl  -0x24(%ebp)
  801211:	ff 75 d8             	pushl  -0x28(%ebp)
  801214:	e8 77 0a 00 00       	call   801c90 <__udivdi3>
  801219:	83 c4 18             	add    $0x18,%esp
  80121c:	52                   	push   %edx
  80121d:	50                   	push   %eax
  80121e:	89 f2                	mov    %esi,%edx
  801220:	89 f8                	mov    %edi,%eax
  801222:	e8 9f ff ff ff       	call   8011c6 <printnum>
  801227:	83 c4 20             	add    $0x20,%esp
  80122a:	eb 13                	jmp    80123f <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80122c:	83 ec 08             	sub    $0x8,%esp
  80122f:	56                   	push   %esi
  801230:	ff 75 18             	pushl  0x18(%ebp)
  801233:	ff d7                	call   *%edi
  801235:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801238:	83 eb 01             	sub    $0x1,%ebx
  80123b:	85 db                	test   %ebx,%ebx
  80123d:	7f ed                	jg     80122c <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80123f:	83 ec 08             	sub    $0x8,%esp
  801242:	56                   	push   %esi
  801243:	83 ec 04             	sub    $0x4,%esp
  801246:	ff 75 e4             	pushl  -0x1c(%ebp)
  801249:	ff 75 e0             	pushl  -0x20(%ebp)
  80124c:	ff 75 dc             	pushl  -0x24(%ebp)
  80124f:	ff 75 d8             	pushl  -0x28(%ebp)
  801252:	e8 49 0b 00 00       	call   801da0 <__umoddi3>
  801257:	83 c4 14             	add    $0x14,%esp
  80125a:	0f be 80 47 20 80 00 	movsbl 0x802047(%eax),%eax
  801261:	50                   	push   %eax
  801262:	ff d7                	call   *%edi
}
  801264:	83 c4 10             	add    $0x10,%esp
  801267:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80126a:	5b                   	pop    %ebx
  80126b:	5e                   	pop    %esi
  80126c:	5f                   	pop    %edi
  80126d:	5d                   	pop    %ebp
  80126e:	c3                   	ret    

0080126f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80126f:	f3 0f 1e fb          	endbr32 
  801273:	55                   	push   %ebp
  801274:	89 e5                	mov    %esp,%ebp
  801276:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801279:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80127d:	8b 10                	mov    (%eax),%edx
  80127f:	3b 50 04             	cmp    0x4(%eax),%edx
  801282:	73 0a                	jae    80128e <sprintputch+0x1f>
		*b->buf++ = ch;
  801284:	8d 4a 01             	lea    0x1(%edx),%ecx
  801287:	89 08                	mov    %ecx,(%eax)
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	88 02                	mov    %al,(%edx)
}
  80128e:	5d                   	pop    %ebp
  80128f:	c3                   	ret    

00801290 <printfmt>:
{
  801290:	f3 0f 1e fb          	endbr32 
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
  801297:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80129a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80129d:	50                   	push   %eax
  80129e:	ff 75 10             	pushl  0x10(%ebp)
  8012a1:	ff 75 0c             	pushl  0xc(%ebp)
  8012a4:	ff 75 08             	pushl  0x8(%ebp)
  8012a7:	e8 05 00 00 00       	call   8012b1 <vprintfmt>
}
  8012ac:	83 c4 10             	add    $0x10,%esp
  8012af:	c9                   	leave  
  8012b0:	c3                   	ret    

008012b1 <vprintfmt>:
{
  8012b1:	f3 0f 1e fb          	endbr32 
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	57                   	push   %edi
  8012b9:	56                   	push   %esi
  8012ba:	53                   	push   %ebx
  8012bb:	83 ec 3c             	sub    $0x3c,%esp
  8012be:	8b 75 08             	mov    0x8(%ebp),%esi
  8012c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012c4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8012c7:	e9 8e 03 00 00       	jmp    80165a <vprintfmt+0x3a9>
		padc = ' ';
  8012cc:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8012d0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8012d7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8012de:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8012e5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8012ea:	8d 47 01             	lea    0x1(%edi),%eax
  8012ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012f0:	0f b6 17             	movzbl (%edi),%edx
  8012f3:	8d 42 dd             	lea    -0x23(%edx),%eax
  8012f6:	3c 55                	cmp    $0x55,%al
  8012f8:	0f 87 df 03 00 00    	ja     8016dd <vprintfmt+0x42c>
  8012fe:	0f b6 c0             	movzbl %al,%eax
  801301:	3e ff 24 85 80 21 80 	notrack jmp *0x802180(,%eax,4)
  801308:	00 
  801309:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80130c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801310:	eb d8                	jmp    8012ea <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801312:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801315:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801319:	eb cf                	jmp    8012ea <vprintfmt+0x39>
  80131b:	0f b6 d2             	movzbl %dl,%edx
  80131e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801321:	b8 00 00 00 00       	mov    $0x0,%eax
  801326:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801329:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80132c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801330:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801333:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801336:	83 f9 09             	cmp    $0x9,%ecx
  801339:	77 55                	ja     801390 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80133b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80133e:	eb e9                	jmp    801329 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801340:	8b 45 14             	mov    0x14(%ebp),%eax
  801343:	8b 00                	mov    (%eax),%eax
  801345:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801348:	8b 45 14             	mov    0x14(%ebp),%eax
  80134b:	8d 40 04             	lea    0x4(%eax),%eax
  80134e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801351:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801354:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801358:	79 90                	jns    8012ea <vprintfmt+0x39>
				width = precision, precision = -1;
  80135a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80135d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801360:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801367:	eb 81                	jmp    8012ea <vprintfmt+0x39>
  801369:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80136c:	85 c0                	test   %eax,%eax
  80136e:	ba 00 00 00 00       	mov    $0x0,%edx
  801373:	0f 49 d0             	cmovns %eax,%edx
  801376:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801379:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80137c:	e9 69 ff ff ff       	jmp    8012ea <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801381:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801384:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80138b:	e9 5a ff ff ff       	jmp    8012ea <vprintfmt+0x39>
  801390:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801393:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801396:	eb bc                	jmp    801354 <vprintfmt+0xa3>
			lflag++;
  801398:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80139b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80139e:	e9 47 ff ff ff       	jmp    8012ea <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8013a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a6:	8d 78 04             	lea    0x4(%eax),%edi
  8013a9:	83 ec 08             	sub    $0x8,%esp
  8013ac:	53                   	push   %ebx
  8013ad:	ff 30                	pushl  (%eax)
  8013af:	ff d6                	call   *%esi
			break;
  8013b1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8013b4:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8013b7:	e9 9b 02 00 00       	jmp    801657 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8013bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bf:	8d 78 04             	lea    0x4(%eax),%edi
  8013c2:	8b 00                	mov    (%eax),%eax
  8013c4:	99                   	cltd   
  8013c5:	31 d0                	xor    %edx,%eax
  8013c7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8013c9:	83 f8 0f             	cmp    $0xf,%eax
  8013cc:	7f 23                	jg     8013f1 <vprintfmt+0x140>
  8013ce:	8b 14 85 e0 22 80 00 	mov    0x8022e0(,%eax,4),%edx
  8013d5:	85 d2                	test   %edx,%edx
  8013d7:	74 18                	je     8013f1 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8013d9:	52                   	push   %edx
  8013da:	68 dd 1f 80 00       	push   $0x801fdd
  8013df:	53                   	push   %ebx
  8013e0:	56                   	push   %esi
  8013e1:	e8 aa fe ff ff       	call   801290 <printfmt>
  8013e6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8013e9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8013ec:	e9 66 02 00 00       	jmp    801657 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8013f1:	50                   	push   %eax
  8013f2:	68 5f 20 80 00       	push   $0x80205f
  8013f7:	53                   	push   %ebx
  8013f8:	56                   	push   %esi
  8013f9:	e8 92 fe ff ff       	call   801290 <printfmt>
  8013fe:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801401:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801404:	e9 4e 02 00 00       	jmp    801657 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  801409:	8b 45 14             	mov    0x14(%ebp),%eax
  80140c:	83 c0 04             	add    $0x4,%eax
  80140f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801412:	8b 45 14             	mov    0x14(%ebp),%eax
  801415:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801417:	85 d2                	test   %edx,%edx
  801419:	b8 58 20 80 00       	mov    $0x802058,%eax
  80141e:	0f 45 c2             	cmovne %edx,%eax
  801421:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801424:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801428:	7e 06                	jle    801430 <vprintfmt+0x17f>
  80142a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80142e:	75 0d                	jne    80143d <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801430:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801433:	89 c7                	mov    %eax,%edi
  801435:	03 45 e0             	add    -0x20(%ebp),%eax
  801438:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80143b:	eb 55                	jmp    801492 <vprintfmt+0x1e1>
  80143d:	83 ec 08             	sub    $0x8,%esp
  801440:	ff 75 d8             	pushl  -0x28(%ebp)
  801443:	ff 75 cc             	pushl  -0x34(%ebp)
  801446:	e8 46 03 00 00       	call   801791 <strnlen>
  80144b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80144e:	29 c2                	sub    %eax,%edx
  801450:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801453:	83 c4 10             	add    $0x10,%esp
  801456:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801458:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80145c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80145f:	85 ff                	test   %edi,%edi
  801461:	7e 11                	jle    801474 <vprintfmt+0x1c3>
					putch(padc, putdat);
  801463:	83 ec 08             	sub    $0x8,%esp
  801466:	53                   	push   %ebx
  801467:	ff 75 e0             	pushl  -0x20(%ebp)
  80146a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80146c:	83 ef 01             	sub    $0x1,%edi
  80146f:	83 c4 10             	add    $0x10,%esp
  801472:	eb eb                	jmp    80145f <vprintfmt+0x1ae>
  801474:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801477:	85 d2                	test   %edx,%edx
  801479:	b8 00 00 00 00       	mov    $0x0,%eax
  80147e:	0f 49 c2             	cmovns %edx,%eax
  801481:	29 c2                	sub    %eax,%edx
  801483:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801486:	eb a8                	jmp    801430 <vprintfmt+0x17f>
					putch(ch, putdat);
  801488:	83 ec 08             	sub    $0x8,%esp
  80148b:	53                   	push   %ebx
  80148c:	52                   	push   %edx
  80148d:	ff d6                	call   *%esi
  80148f:	83 c4 10             	add    $0x10,%esp
  801492:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801495:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801497:	83 c7 01             	add    $0x1,%edi
  80149a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80149e:	0f be d0             	movsbl %al,%edx
  8014a1:	85 d2                	test   %edx,%edx
  8014a3:	74 4b                	je     8014f0 <vprintfmt+0x23f>
  8014a5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014a9:	78 06                	js     8014b1 <vprintfmt+0x200>
  8014ab:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8014af:	78 1e                	js     8014cf <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8014b1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8014b5:	74 d1                	je     801488 <vprintfmt+0x1d7>
  8014b7:	0f be c0             	movsbl %al,%eax
  8014ba:	83 e8 20             	sub    $0x20,%eax
  8014bd:	83 f8 5e             	cmp    $0x5e,%eax
  8014c0:	76 c6                	jbe    801488 <vprintfmt+0x1d7>
					putch('?', putdat);
  8014c2:	83 ec 08             	sub    $0x8,%esp
  8014c5:	53                   	push   %ebx
  8014c6:	6a 3f                	push   $0x3f
  8014c8:	ff d6                	call   *%esi
  8014ca:	83 c4 10             	add    $0x10,%esp
  8014cd:	eb c3                	jmp    801492 <vprintfmt+0x1e1>
  8014cf:	89 cf                	mov    %ecx,%edi
  8014d1:	eb 0e                	jmp    8014e1 <vprintfmt+0x230>
				putch(' ', putdat);
  8014d3:	83 ec 08             	sub    $0x8,%esp
  8014d6:	53                   	push   %ebx
  8014d7:	6a 20                	push   $0x20
  8014d9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8014db:	83 ef 01             	sub    $0x1,%edi
  8014de:	83 c4 10             	add    $0x10,%esp
  8014e1:	85 ff                	test   %edi,%edi
  8014e3:	7f ee                	jg     8014d3 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8014e5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8014e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8014eb:	e9 67 01 00 00       	jmp    801657 <vprintfmt+0x3a6>
  8014f0:	89 cf                	mov    %ecx,%edi
  8014f2:	eb ed                	jmp    8014e1 <vprintfmt+0x230>
	if (lflag >= 2)
  8014f4:	83 f9 01             	cmp    $0x1,%ecx
  8014f7:	7f 1b                	jg     801514 <vprintfmt+0x263>
	else if (lflag)
  8014f9:	85 c9                	test   %ecx,%ecx
  8014fb:	74 63                	je     801560 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8014fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801500:	8b 00                	mov    (%eax),%eax
  801502:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801505:	99                   	cltd   
  801506:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801509:	8b 45 14             	mov    0x14(%ebp),%eax
  80150c:	8d 40 04             	lea    0x4(%eax),%eax
  80150f:	89 45 14             	mov    %eax,0x14(%ebp)
  801512:	eb 17                	jmp    80152b <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801514:	8b 45 14             	mov    0x14(%ebp),%eax
  801517:	8b 50 04             	mov    0x4(%eax),%edx
  80151a:	8b 00                	mov    (%eax),%eax
  80151c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80151f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801522:	8b 45 14             	mov    0x14(%ebp),%eax
  801525:	8d 40 08             	lea    0x8(%eax),%eax
  801528:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80152b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80152e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801531:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801536:	85 c9                	test   %ecx,%ecx
  801538:	0f 89 ff 00 00 00    	jns    80163d <vprintfmt+0x38c>
				putch('-', putdat);
  80153e:	83 ec 08             	sub    $0x8,%esp
  801541:	53                   	push   %ebx
  801542:	6a 2d                	push   $0x2d
  801544:	ff d6                	call   *%esi
				num = -(long long) num;
  801546:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801549:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80154c:	f7 da                	neg    %edx
  80154e:	83 d1 00             	adc    $0x0,%ecx
  801551:	f7 d9                	neg    %ecx
  801553:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801556:	b8 0a 00 00 00       	mov    $0xa,%eax
  80155b:	e9 dd 00 00 00       	jmp    80163d <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801560:	8b 45 14             	mov    0x14(%ebp),%eax
  801563:	8b 00                	mov    (%eax),%eax
  801565:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801568:	99                   	cltd   
  801569:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80156c:	8b 45 14             	mov    0x14(%ebp),%eax
  80156f:	8d 40 04             	lea    0x4(%eax),%eax
  801572:	89 45 14             	mov    %eax,0x14(%ebp)
  801575:	eb b4                	jmp    80152b <vprintfmt+0x27a>
	if (lflag >= 2)
  801577:	83 f9 01             	cmp    $0x1,%ecx
  80157a:	7f 1e                	jg     80159a <vprintfmt+0x2e9>
	else if (lflag)
  80157c:	85 c9                	test   %ecx,%ecx
  80157e:	74 32                	je     8015b2 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801580:	8b 45 14             	mov    0x14(%ebp),%eax
  801583:	8b 10                	mov    (%eax),%edx
  801585:	b9 00 00 00 00       	mov    $0x0,%ecx
  80158a:	8d 40 04             	lea    0x4(%eax),%eax
  80158d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801590:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801595:	e9 a3 00 00 00       	jmp    80163d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80159a:	8b 45 14             	mov    0x14(%ebp),%eax
  80159d:	8b 10                	mov    (%eax),%edx
  80159f:	8b 48 04             	mov    0x4(%eax),%ecx
  8015a2:	8d 40 08             	lea    0x8(%eax),%eax
  8015a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015a8:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8015ad:	e9 8b 00 00 00       	jmp    80163d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8015b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b5:	8b 10                	mov    (%eax),%edx
  8015b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015bc:	8d 40 04             	lea    0x4(%eax),%eax
  8015bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015c2:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8015c7:	eb 74                	jmp    80163d <vprintfmt+0x38c>
	if (lflag >= 2)
  8015c9:	83 f9 01             	cmp    $0x1,%ecx
  8015cc:	7f 1b                	jg     8015e9 <vprintfmt+0x338>
	else if (lflag)
  8015ce:	85 c9                	test   %ecx,%ecx
  8015d0:	74 2c                	je     8015fe <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8015d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d5:	8b 10                	mov    (%eax),%edx
  8015d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015dc:	8d 40 04             	lea    0x4(%eax),%eax
  8015df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8015e2:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8015e7:	eb 54                	jmp    80163d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8015e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ec:	8b 10                	mov    (%eax),%edx
  8015ee:	8b 48 04             	mov    0x4(%eax),%ecx
  8015f1:	8d 40 08             	lea    0x8(%eax),%eax
  8015f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8015f7:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8015fc:	eb 3f                	jmp    80163d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8015fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801601:	8b 10                	mov    (%eax),%edx
  801603:	b9 00 00 00 00       	mov    $0x0,%ecx
  801608:	8d 40 04             	lea    0x4(%eax),%eax
  80160b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80160e:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801613:	eb 28                	jmp    80163d <vprintfmt+0x38c>
			putch('0', putdat);
  801615:	83 ec 08             	sub    $0x8,%esp
  801618:	53                   	push   %ebx
  801619:	6a 30                	push   $0x30
  80161b:	ff d6                	call   *%esi
			putch('x', putdat);
  80161d:	83 c4 08             	add    $0x8,%esp
  801620:	53                   	push   %ebx
  801621:	6a 78                	push   $0x78
  801623:	ff d6                	call   *%esi
			num = (unsigned long long)
  801625:	8b 45 14             	mov    0x14(%ebp),%eax
  801628:	8b 10                	mov    (%eax),%edx
  80162a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80162f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801632:	8d 40 04             	lea    0x4(%eax),%eax
  801635:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801638:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80163d:	83 ec 0c             	sub    $0xc,%esp
  801640:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801644:	57                   	push   %edi
  801645:	ff 75 e0             	pushl  -0x20(%ebp)
  801648:	50                   	push   %eax
  801649:	51                   	push   %ecx
  80164a:	52                   	push   %edx
  80164b:	89 da                	mov    %ebx,%edx
  80164d:	89 f0                	mov    %esi,%eax
  80164f:	e8 72 fb ff ff       	call   8011c6 <printnum>
			break;
  801654:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801657:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80165a:	83 c7 01             	add    $0x1,%edi
  80165d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801661:	83 f8 25             	cmp    $0x25,%eax
  801664:	0f 84 62 fc ff ff    	je     8012cc <vprintfmt+0x1b>
			if (ch == '\0')
  80166a:	85 c0                	test   %eax,%eax
  80166c:	0f 84 8b 00 00 00    	je     8016fd <vprintfmt+0x44c>
			putch(ch, putdat);
  801672:	83 ec 08             	sub    $0x8,%esp
  801675:	53                   	push   %ebx
  801676:	50                   	push   %eax
  801677:	ff d6                	call   *%esi
  801679:	83 c4 10             	add    $0x10,%esp
  80167c:	eb dc                	jmp    80165a <vprintfmt+0x3a9>
	if (lflag >= 2)
  80167e:	83 f9 01             	cmp    $0x1,%ecx
  801681:	7f 1b                	jg     80169e <vprintfmt+0x3ed>
	else if (lflag)
  801683:	85 c9                	test   %ecx,%ecx
  801685:	74 2c                	je     8016b3 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801687:	8b 45 14             	mov    0x14(%ebp),%eax
  80168a:	8b 10                	mov    (%eax),%edx
  80168c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801691:	8d 40 04             	lea    0x4(%eax),%eax
  801694:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801697:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80169c:	eb 9f                	jmp    80163d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80169e:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a1:	8b 10                	mov    (%eax),%edx
  8016a3:	8b 48 04             	mov    0x4(%eax),%ecx
  8016a6:	8d 40 08             	lea    0x8(%eax),%eax
  8016a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016ac:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8016b1:	eb 8a                	jmp    80163d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8016b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b6:	8b 10                	mov    (%eax),%edx
  8016b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016bd:	8d 40 04             	lea    0x4(%eax),%eax
  8016c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016c3:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8016c8:	e9 70 ff ff ff       	jmp    80163d <vprintfmt+0x38c>
			putch(ch, putdat);
  8016cd:	83 ec 08             	sub    $0x8,%esp
  8016d0:	53                   	push   %ebx
  8016d1:	6a 25                	push   $0x25
  8016d3:	ff d6                	call   *%esi
			break;
  8016d5:	83 c4 10             	add    $0x10,%esp
  8016d8:	e9 7a ff ff ff       	jmp    801657 <vprintfmt+0x3a6>
			putch('%', putdat);
  8016dd:	83 ec 08             	sub    $0x8,%esp
  8016e0:	53                   	push   %ebx
  8016e1:	6a 25                	push   $0x25
  8016e3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8016e5:	83 c4 10             	add    $0x10,%esp
  8016e8:	89 f8                	mov    %edi,%eax
  8016ea:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8016ee:	74 05                	je     8016f5 <vprintfmt+0x444>
  8016f0:	83 e8 01             	sub    $0x1,%eax
  8016f3:	eb f5                	jmp    8016ea <vprintfmt+0x439>
  8016f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016f8:	e9 5a ff ff ff       	jmp    801657 <vprintfmt+0x3a6>
}
  8016fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801700:	5b                   	pop    %ebx
  801701:	5e                   	pop    %esi
  801702:	5f                   	pop    %edi
  801703:	5d                   	pop    %ebp
  801704:	c3                   	ret    

00801705 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801705:	f3 0f 1e fb          	endbr32 
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	83 ec 18             	sub    $0x18,%esp
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801715:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801718:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80171c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80171f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801726:	85 c0                	test   %eax,%eax
  801728:	74 26                	je     801750 <vsnprintf+0x4b>
  80172a:	85 d2                	test   %edx,%edx
  80172c:	7e 22                	jle    801750 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80172e:	ff 75 14             	pushl  0x14(%ebp)
  801731:	ff 75 10             	pushl  0x10(%ebp)
  801734:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801737:	50                   	push   %eax
  801738:	68 6f 12 80 00       	push   $0x80126f
  80173d:	e8 6f fb ff ff       	call   8012b1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801742:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801745:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174b:	83 c4 10             	add    $0x10,%esp
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    
		return -E_INVAL;
  801750:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801755:	eb f7                	jmp    80174e <vsnprintf+0x49>

00801757 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801757:	f3 0f 1e fb          	endbr32 
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801761:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801764:	50                   	push   %eax
  801765:	ff 75 10             	pushl  0x10(%ebp)
  801768:	ff 75 0c             	pushl  0xc(%ebp)
  80176b:	ff 75 08             	pushl  0x8(%ebp)
  80176e:	e8 92 ff ff ff       	call   801705 <vsnprintf>
	va_end(ap);

	return rc;
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801775:	f3 0f 1e fb          	endbr32 
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80177f:	b8 00 00 00 00       	mov    $0x0,%eax
  801784:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801788:	74 05                	je     80178f <strlen+0x1a>
		n++;
  80178a:	83 c0 01             	add    $0x1,%eax
  80178d:	eb f5                	jmp    801784 <strlen+0xf>
	return n;
}
  80178f:	5d                   	pop    %ebp
  801790:	c3                   	ret    

00801791 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801791:	f3 0f 1e fb          	endbr32 
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80179b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80179e:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a3:	39 d0                	cmp    %edx,%eax
  8017a5:	74 0d                	je     8017b4 <strnlen+0x23>
  8017a7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8017ab:	74 05                	je     8017b2 <strnlen+0x21>
		n++;
  8017ad:	83 c0 01             	add    $0x1,%eax
  8017b0:	eb f1                	jmp    8017a3 <strnlen+0x12>
  8017b2:	89 c2                	mov    %eax,%edx
	return n;
}
  8017b4:	89 d0                	mov    %edx,%eax
  8017b6:	5d                   	pop    %ebp
  8017b7:	c3                   	ret    

008017b8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8017b8:	f3 0f 1e fb          	endbr32 
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	53                   	push   %ebx
  8017c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8017c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cb:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8017cf:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8017d2:	83 c0 01             	add    $0x1,%eax
  8017d5:	84 d2                	test   %dl,%dl
  8017d7:	75 f2                	jne    8017cb <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8017d9:	89 c8                	mov    %ecx,%eax
  8017db:	5b                   	pop    %ebx
  8017dc:	5d                   	pop    %ebp
  8017dd:	c3                   	ret    

008017de <strcat>:

char *
strcat(char *dst, const char *src)
{
  8017de:	f3 0f 1e fb          	endbr32 
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	53                   	push   %ebx
  8017e6:	83 ec 10             	sub    $0x10,%esp
  8017e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8017ec:	53                   	push   %ebx
  8017ed:	e8 83 ff ff ff       	call   801775 <strlen>
  8017f2:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8017f5:	ff 75 0c             	pushl  0xc(%ebp)
  8017f8:	01 d8                	add    %ebx,%eax
  8017fa:	50                   	push   %eax
  8017fb:	e8 b8 ff ff ff       	call   8017b8 <strcpy>
	return dst;
}
  801800:	89 d8                	mov    %ebx,%eax
  801802:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801807:	f3 0f 1e fb          	endbr32 
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	56                   	push   %esi
  80180f:	53                   	push   %ebx
  801810:	8b 75 08             	mov    0x8(%ebp),%esi
  801813:	8b 55 0c             	mov    0xc(%ebp),%edx
  801816:	89 f3                	mov    %esi,%ebx
  801818:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80181b:	89 f0                	mov    %esi,%eax
  80181d:	39 d8                	cmp    %ebx,%eax
  80181f:	74 11                	je     801832 <strncpy+0x2b>
		*dst++ = *src;
  801821:	83 c0 01             	add    $0x1,%eax
  801824:	0f b6 0a             	movzbl (%edx),%ecx
  801827:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80182a:	80 f9 01             	cmp    $0x1,%cl
  80182d:	83 da ff             	sbb    $0xffffffff,%edx
  801830:	eb eb                	jmp    80181d <strncpy+0x16>
	}
	return ret;
}
  801832:	89 f0                	mov    %esi,%eax
  801834:	5b                   	pop    %ebx
  801835:	5e                   	pop    %esi
  801836:	5d                   	pop    %ebp
  801837:	c3                   	ret    

00801838 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801838:	f3 0f 1e fb          	endbr32 
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	56                   	push   %esi
  801840:	53                   	push   %ebx
  801841:	8b 75 08             	mov    0x8(%ebp),%esi
  801844:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801847:	8b 55 10             	mov    0x10(%ebp),%edx
  80184a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80184c:	85 d2                	test   %edx,%edx
  80184e:	74 21                	je     801871 <strlcpy+0x39>
  801850:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801854:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801856:	39 c2                	cmp    %eax,%edx
  801858:	74 14                	je     80186e <strlcpy+0x36>
  80185a:	0f b6 19             	movzbl (%ecx),%ebx
  80185d:	84 db                	test   %bl,%bl
  80185f:	74 0b                	je     80186c <strlcpy+0x34>
			*dst++ = *src++;
  801861:	83 c1 01             	add    $0x1,%ecx
  801864:	83 c2 01             	add    $0x1,%edx
  801867:	88 5a ff             	mov    %bl,-0x1(%edx)
  80186a:	eb ea                	jmp    801856 <strlcpy+0x1e>
  80186c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80186e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801871:	29 f0                	sub    %esi,%eax
}
  801873:	5b                   	pop    %ebx
  801874:	5e                   	pop    %esi
  801875:	5d                   	pop    %ebp
  801876:	c3                   	ret    

00801877 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801877:	f3 0f 1e fb          	endbr32 
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801881:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801884:	0f b6 01             	movzbl (%ecx),%eax
  801887:	84 c0                	test   %al,%al
  801889:	74 0c                	je     801897 <strcmp+0x20>
  80188b:	3a 02                	cmp    (%edx),%al
  80188d:	75 08                	jne    801897 <strcmp+0x20>
		p++, q++;
  80188f:	83 c1 01             	add    $0x1,%ecx
  801892:	83 c2 01             	add    $0x1,%edx
  801895:	eb ed                	jmp    801884 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801897:	0f b6 c0             	movzbl %al,%eax
  80189a:	0f b6 12             	movzbl (%edx),%edx
  80189d:	29 d0                	sub    %edx,%eax
}
  80189f:	5d                   	pop    %ebp
  8018a0:	c3                   	ret    

008018a1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018a1:	f3 0f 1e fb          	endbr32 
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
  8018a8:	53                   	push   %ebx
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018af:	89 c3                	mov    %eax,%ebx
  8018b1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8018b4:	eb 06                	jmp    8018bc <strncmp+0x1b>
		n--, p++, q++;
  8018b6:	83 c0 01             	add    $0x1,%eax
  8018b9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8018bc:	39 d8                	cmp    %ebx,%eax
  8018be:	74 16                	je     8018d6 <strncmp+0x35>
  8018c0:	0f b6 08             	movzbl (%eax),%ecx
  8018c3:	84 c9                	test   %cl,%cl
  8018c5:	74 04                	je     8018cb <strncmp+0x2a>
  8018c7:	3a 0a                	cmp    (%edx),%cl
  8018c9:	74 eb                	je     8018b6 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018cb:	0f b6 00             	movzbl (%eax),%eax
  8018ce:	0f b6 12             	movzbl (%edx),%edx
  8018d1:	29 d0                	sub    %edx,%eax
}
  8018d3:	5b                   	pop    %ebx
  8018d4:	5d                   	pop    %ebp
  8018d5:	c3                   	ret    
		return 0;
  8018d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8018db:	eb f6                	jmp    8018d3 <strncmp+0x32>

008018dd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018dd:	f3 0f 1e fb          	endbr32 
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
  8018e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8018eb:	0f b6 10             	movzbl (%eax),%edx
  8018ee:	84 d2                	test   %dl,%dl
  8018f0:	74 09                	je     8018fb <strchr+0x1e>
		if (*s == c)
  8018f2:	38 ca                	cmp    %cl,%dl
  8018f4:	74 0a                	je     801900 <strchr+0x23>
	for (; *s; s++)
  8018f6:	83 c0 01             	add    $0x1,%eax
  8018f9:	eb f0                	jmp    8018eb <strchr+0xe>
			return (char *) s;
	return 0;
  8018fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801900:	5d                   	pop    %ebp
  801901:	c3                   	ret    

00801902 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801902:	f3 0f 1e fb          	endbr32 
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801910:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801913:	38 ca                	cmp    %cl,%dl
  801915:	74 09                	je     801920 <strfind+0x1e>
  801917:	84 d2                	test   %dl,%dl
  801919:	74 05                	je     801920 <strfind+0x1e>
	for (; *s; s++)
  80191b:	83 c0 01             	add    $0x1,%eax
  80191e:	eb f0                	jmp    801910 <strfind+0xe>
			break;
	return (char *) s;
}
  801920:	5d                   	pop    %ebp
  801921:	c3                   	ret    

00801922 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801922:	f3 0f 1e fb          	endbr32 
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
  801929:	57                   	push   %edi
  80192a:	56                   	push   %esi
  80192b:	53                   	push   %ebx
  80192c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80192f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801932:	85 c9                	test   %ecx,%ecx
  801934:	74 31                	je     801967 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801936:	89 f8                	mov    %edi,%eax
  801938:	09 c8                	or     %ecx,%eax
  80193a:	a8 03                	test   $0x3,%al
  80193c:	75 23                	jne    801961 <memset+0x3f>
		c &= 0xFF;
  80193e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801942:	89 d3                	mov    %edx,%ebx
  801944:	c1 e3 08             	shl    $0x8,%ebx
  801947:	89 d0                	mov    %edx,%eax
  801949:	c1 e0 18             	shl    $0x18,%eax
  80194c:	89 d6                	mov    %edx,%esi
  80194e:	c1 e6 10             	shl    $0x10,%esi
  801951:	09 f0                	or     %esi,%eax
  801953:	09 c2                	or     %eax,%edx
  801955:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801957:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80195a:	89 d0                	mov    %edx,%eax
  80195c:	fc                   	cld    
  80195d:	f3 ab                	rep stos %eax,%es:(%edi)
  80195f:	eb 06                	jmp    801967 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801961:	8b 45 0c             	mov    0xc(%ebp),%eax
  801964:	fc                   	cld    
  801965:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801967:	89 f8                	mov    %edi,%eax
  801969:	5b                   	pop    %ebx
  80196a:	5e                   	pop    %esi
  80196b:	5f                   	pop    %edi
  80196c:	5d                   	pop    %ebp
  80196d:	c3                   	ret    

0080196e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80196e:	f3 0f 1e fb          	endbr32 
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	57                   	push   %edi
  801976:	56                   	push   %esi
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80197d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801980:	39 c6                	cmp    %eax,%esi
  801982:	73 32                	jae    8019b6 <memmove+0x48>
  801984:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801987:	39 c2                	cmp    %eax,%edx
  801989:	76 2b                	jbe    8019b6 <memmove+0x48>
		s += n;
		d += n;
  80198b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80198e:	89 fe                	mov    %edi,%esi
  801990:	09 ce                	or     %ecx,%esi
  801992:	09 d6                	or     %edx,%esi
  801994:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80199a:	75 0e                	jne    8019aa <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80199c:	83 ef 04             	sub    $0x4,%edi
  80199f:	8d 72 fc             	lea    -0x4(%edx),%esi
  8019a2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8019a5:	fd                   	std    
  8019a6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019a8:	eb 09                	jmp    8019b3 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8019aa:	83 ef 01             	sub    $0x1,%edi
  8019ad:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8019b0:	fd                   	std    
  8019b1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8019b3:	fc                   	cld    
  8019b4:	eb 1a                	jmp    8019d0 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019b6:	89 c2                	mov    %eax,%edx
  8019b8:	09 ca                	or     %ecx,%edx
  8019ba:	09 f2                	or     %esi,%edx
  8019bc:	f6 c2 03             	test   $0x3,%dl
  8019bf:	75 0a                	jne    8019cb <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8019c1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8019c4:	89 c7                	mov    %eax,%edi
  8019c6:	fc                   	cld    
  8019c7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019c9:	eb 05                	jmp    8019d0 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8019cb:	89 c7                	mov    %eax,%edi
  8019cd:	fc                   	cld    
  8019ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8019d0:	5e                   	pop    %esi
  8019d1:	5f                   	pop    %edi
  8019d2:	5d                   	pop    %ebp
  8019d3:	c3                   	ret    

008019d4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8019d4:	f3 0f 1e fb          	endbr32 
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
  8019db:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8019de:	ff 75 10             	pushl  0x10(%ebp)
  8019e1:	ff 75 0c             	pushl  0xc(%ebp)
  8019e4:	ff 75 08             	pushl  0x8(%ebp)
  8019e7:	e8 82 ff ff ff       	call   80196e <memmove>
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8019ee:	f3 0f 1e fb          	endbr32 
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	56                   	push   %esi
  8019f6:	53                   	push   %ebx
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fd:	89 c6                	mov    %eax,%esi
  8019ff:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801a02:	39 f0                	cmp    %esi,%eax
  801a04:	74 1c                	je     801a22 <memcmp+0x34>
		if (*s1 != *s2)
  801a06:	0f b6 08             	movzbl (%eax),%ecx
  801a09:	0f b6 1a             	movzbl (%edx),%ebx
  801a0c:	38 d9                	cmp    %bl,%cl
  801a0e:	75 08                	jne    801a18 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801a10:	83 c0 01             	add    $0x1,%eax
  801a13:	83 c2 01             	add    $0x1,%edx
  801a16:	eb ea                	jmp    801a02 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801a18:	0f b6 c1             	movzbl %cl,%eax
  801a1b:	0f b6 db             	movzbl %bl,%ebx
  801a1e:	29 d8                	sub    %ebx,%eax
  801a20:	eb 05                	jmp    801a27 <memcmp+0x39>
	}

	return 0;
  801a22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a27:	5b                   	pop    %ebx
  801a28:	5e                   	pop    %esi
  801a29:	5d                   	pop    %ebp
  801a2a:	c3                   	ret    

00801a2b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a2b:	f3 0f 1e fb          	endbr32 
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801a38:	89 c2                	mov    %eax,%edx
  801a3a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801a3d:	39 d0                	cmp    %edx,%eax
  801a3f:	73 09                	jae    801a4a <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a41:	38 08                	cmp    %cl,(%eax)
  801a43:	74 05                	je     801a4a <memfind+0x1f>
	for (; s < ends; s++)
  801a45:	83 c0 01             	add    $0x1,%eax
  801a48:	eb f3                	jmp    801a3d <memfind+0x12>
			break;
	return (void *) s;
}
  801a4a:	5d                   	pop    %ebp
  801a4b:	c3                   	ret    

00801a4c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a4c:	f3 0f 1e fb          	endbr32 
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	57                   	push   %edi
  801a54:	56                   	push   %esi
  801a55:	53                   	push   %ebx
  801a56:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a59:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a5c:	eb 03                	jmp    801a61 <strtol+0x15>
		s++;
  801a5e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801a61:	0f b6 01             	movzbl (%ecx),%eax
  801a64:	3c 20                	cmp    $0x20,%al
  801a66:	74 f6                	je     801a5e <strtol+0x12>
  801a68:	3c 09                	cmp    $0x9,%al
  801a6a:	74 f2                	je     801a5e <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801a6c:	3c 2b                	cmp    $0x2b,%al
  801a6e:	74 2a                	je     801a9a <strtol+0x4e>
	int neg = 0;
  801a70:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801a75:	3c 2d                	cmp    $0x2d,%al
  801a77:	74 2b                	je     801aa4 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a79:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801a7f:	75 0f                	jne    801a90 <strtol+0x44>
  801a81:	80 39 30             	cmpb   $0x30,(%ecx)
  801a84:	74 28                	je     801aae <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801a86:	85 db                	test   %ebx,%ebx
  801a88:	b8 0a 00 00 00       	mov    $0xa,%eax
  801a8d:	0f 44 d8             	cmove  %eax,%ebx
  801a90:	b8 00 00 00 00       	mov    $0x0,%eax
  801a95:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801a98:	eb 46                	jmp    801ae0 <strtol+0x94>
		s++;
  801a9a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801a9d:	bf 00 00 00 00       	mov    $0x0,%edi
  801aa2:	eb d5                	jmp    801a79 <strtol+0x2d>
		s++, neg = 1;
  801aa4:	83 c1 01             	add    $0x1,%ecx
  801aa7:	bf 01 00 00 00       	mov    $0x1,%edi
  801aac:	eb cb                	jmp    801a79 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801aae:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801ab2:	74 0e                	je     801ac2 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801ab4:	85 db                	test   %ebx,%ebx
  801ab6:	75 d8                	jne    801a90 <strtol+0x44>
		s++, base = 8;
  801ab8:	83 c1 01             	add    $0x1,%ecx
  801abb:	bb 08 00 00 00       	mov    $0x8,%ebx
  801ac0:	eb ce                	jmp    801a90 <strtol+0x44>
		s += 2, base = 16;
  801ac2:	83 c1 02             	add    $0x2,%ecx
  801ac5:	bb 10 00 00 00       	mov    $0x10,%ebx
  801aca:	eb c4                	jmp    801a90 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801acc:	0f be d2             	movsbl %dl,%edx
  801acf:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801ad2:	3b 55 10             	cmp    0x10(%ebp),%edx
  801ad5:	7d 3a                	jge    801b11 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801ad7:	83 c1 01             	add    $0x1,%ecx
  801ada:	0f af 45 10          	imul   0x10(%ebp),%eax
  801ade:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801ae0:	0f b6 11             	movzbl (%ecx),%edx
  801ae3:	8d 72 d0             	lea    -0x30(%edx),%esi
  801ae6:	89 f3                	mov    %esi,%ebx
  801ae8:	80 fb 09             	cmp    $0x9,%bl
  801aeb:	76 df                	jbe    801acc <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801aed:	8d 72 9f             	lea    -0x61(%edx),%esi
  801af0:	89 f3                	mov    %esi,%ebx
  801af2:	80 fb 19             	cmp    $0x19,%bl
  801af5:	77 08                	ja     801aff <strtol+0xb3>
			dig = *s - 'a' + 10;
  801af7:	0f be d2             	movsbl %dl,%edx
  801afa:	83 ea 57             	sub    $0x57,%edx
  801afd:	eb d3                	jmp    801ad2 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801aff:	8d 72 bf             	lea    -0x41(%edx),%esi
  801b02:	89 f3                	mov    %esi,%ebx
  801b04:	80 fb 19             	cmp    $0x19,%bl
  801b07:	77 08                	ja     801b11 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801b09:	0f be d2             	movsbl %dl,%edx
  801b0c:	83 ea 37             	sub    $0x37,%edx
  801b0f:	eb c1                	jmp    801ad2 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801b11:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b15:	74 05                	je     801b1c <strtol+0xd0>
		*endptr = (char *) s;
  801b17:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b1a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801b1c:	89 c2                	mov    %eax,%edx
  801b1e:	f7 da                	neg    %edx
  801b20:	85 ff                	test   %edi,%edi
  801b22:	0f 45 c2             	cmovne %edx,%eax
}
  801b25:	5b                   	pop    %ebx
  801b26:	5e                   	pop    %esi
  801b27:	5f                   	pop    %edi
  801b28:	5d                   	pop    %ebp
  801b29:	c3                   	ret    

00801b2a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b2a:	f3 0f 1e fb          	endbr32 
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
  801b31:	56                   	push   %esi
  801b32:	53                   	push   %ebx
  801b33:	8b 75 08             	mov    0x8(%ebp),%esi
  801b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b39:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801b3c:	85 c0                	test   %eax,%eax
  801b3e:	74 3d                	je     801b7d <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801b40:	83 ec 0c             	sub    $0xc,%esp
  801b43:	50                   	push   %eax
  801b44:	e8 f4 e7 ff ff       	call   80033d <sys_ipc_recv>
  801b49:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801b4c:	85 f6                	test   %esi,%esi
  801b4e:	74 0b                	je     801b5b <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b50:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b56:	8b 52 74             	mov    0x74(%edx),%edx
  801b59:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801b5b:	85 db                	test   %ebx,%ebx
  801b5d:	74 0b                	je     801b6a <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801b5f:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b65:	8b 52 78             	mov    0x78(%edx),%edx
  801b68:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801b6a:	85 c0                	test   %eax,%eax
  801b6c:	78 21                	js     801b8f <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801b6e:	a1 04 40 80 00       	mov    0x804004,%eax
  801b73:	8b 40 70             	mov    0x70(%eax),%eax
}
  801b76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b79:	5b                   	pop    %ebx
  801b7a:	5e                   	pop    %esi
  801b7b:	5d                   	pop    %ebp
  801b7c:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801b7d:	83 ec 0c             	sub    $0xc,%esp
  801b80:	68 00 00 c0 ee       	push   $0xeec00000
  801b85:	e8 b3 e7 ff ff       	call   80033d <sys_ipc_recv>
  801b8a:	83 c4 10             	add    $0x10,%esp
  801b8d:	eb bd                	jmp    801b4c <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801b8f:	85 f6                	test   %esi,%esi
  801b91:	74 10                	je     801ba3 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801b93:	85 db                	test   %ebx,%ebx
  801b95:	75 df                	jne    801b76 <ipc_recv+0x4c>
  801b97:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801b9e:	00 00 00 
  801ba1:	eb d3                	jmp    801b76 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801ba3:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801baa:	00 00 00 
  801bad:	eb e4                	jmp    801b93 <ipc_recv+0x69>

00801baf <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801baf:	f3 0f 1e fb          	endbr32 
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	57                   	push   %edi
  801bb7:	56                   	push   %esi
  801bb8:	53                   	push   %ebx
  801bb9:	83 ec 0c             	sub    $0xc,%esp
  801bbc:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bbf:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bc2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801bc5:	85 db                	test   %ebx,%ebx
  801bc7:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801bcc:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801bcf:	ff 75 14             	pushl  0x14(%ebp)
  801bd2:	53                   	push   %ebx
  801bd3:	56                   	push   %esi
  801bd4:	57                   	push   %edi
  801bd5:	e8 3c e7 ff ff       	call   800316 <sys_ipc_try_send>
  801bda:	83 c4 10             	add    $0x10,%esp
  801bdd:	85 c0                	test   %eax,%eax
  801bdf:	79 1e                	jns    801bff <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801be1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801be4:	75 07                	jne    801bed <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801be6:	e8 63 e5 ff ff       	call   80014e <sys_yield>
  801beb:	eb e2                	jmp    801bcf <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801bed:	50                   	push   %eax
  801bee:	68 3f 23 80 00       	push   $0x80233f
  801bf3:	6a 59                	push   $0x59
  801bf5:	68 5a 23 80 00       	push   $0x80235a
  801bfa:	e8 c8 f4 ff ff       	call   8010c7 <_panic>
	}
}
  801bff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c02:	5b                   	pop    %ebx
  801c03:	5e                   	pop    %esi
  801c04:	5f                   	pop    %edi
  801c05:	5d                   	pop    %ebp
  801c06:	c3                   	ret    

00801c07 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c07:	f3 0f 1e fb          	endbr32 
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c11:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c16:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c19:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c1f:	8b 52 50             	mov    0x50(%edx),%edx
  801c22:	39 ca                	cmp    %ecx,%edx
  801c24:	74 11                	je     801c37 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801c26:	83 c0 01             	add    $0x1,%eax
  801c29:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c2e:	75 e6                	jne    801c16 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801c30:	b8 00 00 00 00       	mov    $0x0,%eax
  801c35:	eb 0b                	jmp    801c42 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801c37:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c3a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c3f:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c42:	5d                   	pop    %ebp
  801c43:	c3                   	ret    

00801c44 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c44:	f3 0f 1e fb          	endbr32 
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c4e:	89 c2                	mov    %eax,%edx
  801c50:	c1 ea 16             	shr    $0x16,%edx
  801c53:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c5a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c5f:	f6 c1 01             	test   $0x1,%cl
  801c62:	74 1c                	je     801c80 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801c64:	c1 e8 0c             	shr    $0xc,%eax
  801c67:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c6e:	a8 01                	test   $0x1,%al
  801c70:	74 0e                	je     801c80 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c72:	c1 e8 0c             	shr    $0xc,%eax
  801c75:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801c7c:	ef 
  801c7d:	0f b7 d2             	movzwl %dx,%edx
}
  801c80:	89 d0                	mov    %edx,%eax
  801c82:	5d                   	pop    %ebp
  801c83:	c3                   	ret    
  801c84:	66 90                	xchg   %ax,%ax
  801c86:	66 90                	xchg   %ax,%ax
  801c88:	66 90                	xchg   %ax,%ax
  801c8a:	66 90                	xchg   %ax,%ax
  801c8c:	66 90                	xchg   %ax,%ax
  801c8e:	66 90                	xchg   %ax,%ax

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
