
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
  80005a:	a3 08 40 80 00       	mov    %eax,0x804008

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
  80008d:	e8 93 05 00 00       	call   800625 <close_all>
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
  80011a:	68 6a 24 80 00       	push   $0x80246a
  80011f:	6a 23                	push   $0x23
  800121:	68 87 24 80 00       	push   $0x802487
  800126:	e8 08 15 00 00       	call   801633 <_panic>

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
  8001a7:	68 6a 24 80 00       	push   $0x80246a
  8001ac:	6a 23                	push   $0x23
  8001ae:	68 87 24 80 00       	push   $0x802487
  8001b3:	e8 7b 14 00 00       	call   801633 <_panic>

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
  8001ed:	68 6a 24 80 00       	push   $0x80246a
  8001f2:	6a 23                	push   $0x23
  8001f4:	68 87 24 80 00       	push   $0x802487
  8001f9:	e8 35 14 00 00       	call   801633 <_panic>

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
  800233:	68 6a 24 80 00       	push   $0x80246a
  800238:	6a 23                	push   $0x23
  80023a:	68 87 24 80 00       	push   $0x802487
  80023f:	e8 ef 13 00 00       	call   801633 <_panic>

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
  800279:	68 6a 24 80 00       	push   $0x80246a
  80027e:	6a 23                	push   $0x23
  800280:	68 87 24 80 00       	push   $0x802487
  800285:	e8 a9 13 00 00       	call   801633 <_panic>

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
  8002bf:	68 6a 24 80 00       	push   $0x80246a
  8002c4:	6a 23                	push   $0x23
  8002c6:	68 87 24 80 00       	push   $0x802487
  8002cb:	e8 63 13 00 00       	call   801633 <_panic>

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
  800305:	68 6a 24 80 00       	push   $0x80246a
  80030a:	6a 23                	push   $0x23
  80030c:	68 87 24 80 00       	push   $0x802487
  800311:	e8 1d 13 00 00       	call   801633 <_panic>

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
  800371:	68 6a 24 80 00       	push   $0x80246a
  800376:	6a 23                	push   $0x23
  800378:	68 87 24 80 00       	push   $0x802487
  80037d:	e8 b1 12 00 00       	call   801633 <_panic>

00800382 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800382:	f3 0f 1e fb          	endbr32 
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
  800389:	57                   	push   %edi
  80038a:	56                   	push   %esi
  80038b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80038c:	ba 00 00 00 00       	mov    $0x0,%edx
  800391:	b8 0e 00 00 00       	mov    $0xe,%eax
  800396:	89 d1                	mov    %edx,%ecx
  800398:	89 d3                	mov    %edx,%ebx
  80039a:	89 d7                	mov    %edx,%edi
  80039c:	89 d6                	mov    %edx,%esi
  80039e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003a0:	5b                   	pop    %ebx
  8003a1:	5e                   	pop    %esi
  8003a2:	5f                   	pop    %edi
  8003a3:	5d                   	pop    %ebp
  8003a4:	c3                   	ret    

008003a5 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  8003a5:	f3 0f 1e fb          	endbr32 
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	57                   	push   %edi
  8003ad:	56                   	push   %esi
  8003ae:	53                   	push   %ebx
  8003af:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8003b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003bd:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003c2:	89 df                	mov    %ebx,%edi
  8003c4:	89 de                	mov    %ebx,%esi
  8003c6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8003c8:	85 c0                	test   %eax,%eax
  8003ca:	7f 08                	jg     8003d4 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  8003cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003cf:	5b                   	pop    %ebx
  8003d0:	5e                   	pop    %esi
  8003d1:	5f                   	pop    %edi
  8003d2:	5d                   	pop    %ebp
  8003d3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8003d4:	83 ec 0c             	sub    $0xc,%esp
  8003d7:	50                   	push   %eax
  8003d8:	6a 0f                	push   $0xf
  8003da:	68 6a 24 80 00       	push   $0x80246a
  8003df:	6a 23                	push   $0x23
  8003e1:	68 87 24 80 00       	push   $0x802487
  8003e6:	e8 48 12 00 00       	call   801633 <_panic>

008003eb <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  8003eb:	f3 0f 1e fb          	endbr32 
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	57                   	push   %edi
  8003f3:	56                   	push   %esi
  8003f4:	53                   	push   %ebx
  8003f5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8003f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003fd:	8b 55 08             	mov    0x8(%ebp),%edx
  800400:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800403:	b8 10 00 00 00       	mov    $0x10,%eax
  800408:	89 df                	mov    %ebx,%edi
  80040a:	89 de                	mov    %ebx,%esi
  80040c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80040e:	85 c0                	test   %eax,%eax
  800410:	7f 08                	jg     80041a <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800412:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800415:	5b                   	pop    %ebx
  800416:	5e                   	pop    %esi
  800417:	5f                   	pop    %edi
  800418:	5d                   	pop    %ebp
  800419:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80041a:	83 ec 0c             	sub    $0xc,%esp
  80041d:	50                   	push   %eax
  80041e:	6a 10                	push   $0x10
  800420:	68 6a 24 80 00       	push   $0x80246a
  800425:	6a 23                	push   $0x23
  800427:	68 87 24 80 00       	push   $0x802487
  80042c:	e8 02 12 00 00       	call   801633 <_panic>

00800431 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800431:	f3 0f 1e fb          	endbr32 
  800435:	55                   	push   %ebp
  800436:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800438:	8b 45 08             	mov    0x8(%ebp),%eax
  80043b:	05 00 00 00 30       	add    $0x30000000,%eax
  800440:	c1 e8 0c             	shr    $0xc,%eax
}
  800443:	5d                   	pop    %ebp
  800444:	c3                   	ret    

00800445 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800445:	f3 0f 1e fb          	endbr32 
  800449:	55                   	push   %ebp
  80044a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800454:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800459:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80045e:	5d                   	pop    %ebp
  80045f:	c3                   	ret    

00800460 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800460:	f3 0f 1e fb          	endbr32 
  800464:	55                   	push   %ebp
  800465:	89 e5                	mov    %esp,%ebp
  800467:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80046c:	89 c2                	mov    %eax,%edx
  80046e:	c1 ea 16             	shr    $0x16,%edx
  800471:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800478:	f6 c2 01             	test   $0x1,%dl
  80047b:	74 2d                	je     8004aa <fd_alloc+0x4a>
  80047d:	89 c2                	mov    %eax,%edx
  80047f:	c1 ea 0c             	shr    $0xc,%edx
  800482:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800489:	f6 c2 01             	test   $0x1,%dl
  80048c:	74 1c                	je     8004aa <fd_alloc+0x4a>
  80048e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800493:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800498:	75 d2                	jne    80046c <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80049a:	8b 45 08             	mov    0x8(%ebp),%eax
  80049d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8004a3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8004a8:	eb 0a                	jmp    8004b4 <fd_alloc+0x54>
			*fd_store = fd;
  8004aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004ad:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004b4:	5d                   	pop    %ebp
  8004b5:	c3                   	ret    

008004b6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8004b6:	f3 0f 1e fb          	endbr32 
  8004ba:	55                   	push   %ebp
  8004bb:	89 e5                	mov    %esp,%ebp
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8004c0:	83 f8 1f             	cmp    $0x1f,%eax
  8004c3:	77 30                	ja     8004f5 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8004c5:	c1 e0 0c             	shl    $0xc,%eax
  8004c8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8004cd:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8004d3:	f6 c2 01             	test   $0x1,%dl
  8004d6:	74 24                	je     8004fc <fd_lookup+0x46>
  8004d8:	89 c2                	mov    %eax,%edx
  8004da:	c1 ea 0c             	shr    $0xc,%edx
  8004dd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004e4:	f6 c2 01             	test   $0x1,%dl
  8004e7:	74 1a                	je     800503 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8004e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ec:	89 02                	mov    %eax,(%edx)
	return 0;
  8004ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004f3:	5d                   	pop    %ebp
  8004f4:	c3                   	ret    
		return -E_INVAL;
  8004f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004fa:	eb f7                	jmp    8004f3 <fd_lookup+0x3d>
		return -E_INVAL;
  8004fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800501:	eb f0                	jmp    8004f3 <fd_lookup+0x3d>
  800503:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800508:	eb e9                	jmp    8004f3 <fd_lookup+0x3d>

0080050a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80050a:	f3 0f 1e fb          	endbr32 
  80050e:	55                   	push   %ebp
  80050f:	89 e5                	mov    %esp,%ebp
  800511:	83 ec 08             	sub    $0x8,%esp
  800514:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800517:	ba 00 00 00 00       	mov    $0x0,%edx
  80051c:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800521:	39 08                	cmp    %ecx,(%eax)
  800523:	74 38                	je     80055d <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800525:	83 c2 01             	add    $0x1,%edx
  800528:	8b 04 95 14 25 80 00 	mov    0x802514(,%edx,4),%eax
  80052f:	85 c0                	test   %eax,%eax
  800531:	75 ee                	jne    800521 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800533:	a1 08 40 80 00       	mov    0x804008,%eax
  800538:	8b 40 48             	mov    0x48(%eax),%eax
  80053b:	83 ec 04             	sub    $0x4,%esp
  80053e:	51                   	push   %ecx
  80053f:	50                   	push   %eax
  800540:	68 98 24 80 00       	push   $0x802498
  800545:	e8 d0 11 00 00       	call   80171a <cprintf>
	*dev = 0;
  80054a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800553:	83 c4 10             	add    $0x10,%esp
  800556:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80055b:	c9                   	leave  
  80055c:	c3                   	ret    
			*dev = devtab[i];
  80055d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800560:	89 01                	mov    %eax,(%ecx)
			return 0;
  800562:	b8 00 00 00 00       	mov    $0x0,%eax
  800567:	eb f2                	jmp    80055b <dev_lookup+0x51>

00800569 <fd_close>:
{
  800569:	f3 0f 1e fb          	endbr32 
  80056d:	55                   	push   %ebp
  80056e:	89 e5                	mov    %esp,%ebp
  800570:	57                   	push   %edi
  800571:	56                   	push   %esi
  800572:	53                   	push   %ebx
  800573:	83 ec 24             	sub    $0x24,%esp
  800576:	8b 75 08             	mov    0x8(%ebp),%esi
  800579:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80057c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80057f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800580:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800586:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800589:	50                   	push   %eax
  80058a:	e8 27 ff ff ff       	call   8004b6 <fd_lookup>
  80058f:	89 c3                	mov    %eax,%ebx
  800591:	83 c4 10             	add    $0x10,%esp
  800594:	85 c0                	test   %eax,%eax
  800596:	78 05                	js     80059d <fd_close+0x34>
	    || fd != fd2)
  800598:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80059b:	74 16                	je     8005b3 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80059d:	89 f8                	mov    %edi,%eax
  80059f:	84 c0                	test   %al,%al
  8005a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a6:	0f 44 d8             	cmove  %eax,%ebx
}
  8005a9:	89 d8                	mov    %ebx,%eax
  8005ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005ae:	5b                   	pop    %ebx
  8005af:	5e                   	pop    %esi
  8005b0:	5f                   	pop    %edi
  8005b1:	5d                   	pop    %ebp
  8005b2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8005b9:	50                   	push   %eax
  8005ba:	ff 36                	pushl  (%esi)
  8005bc:	e8 49 ff ff ff       	call   80050a <dev_lookup>
  8005c1:	89 c3                	mov    %eax,%ebx
  8005c3:	83 c4 10             	add    $0x10,%esp
  8005c6:	85 c0                	test   %eax,%eax
  8005c8:	78 1a                	js     8005e4 <fd_close+0x7b>
		if (dev->dev_close)
  8005ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005cd:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8005d0:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8005d5:	85 c0                	test   %eax,%eax
  8005d7:	74 0b                	je     8005e4 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8005d9:	83 ec 0c             	sub    $0xc,%esp
  8005dc:	56                   	push   %esi
  8005dd:	ff d0                	call   *%eax
  8005df:	89 c3                	mov    %eax,%ebx
  8005e1:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8005e4:	83 ec 08             	sub    $0x8,%esp
  8005e7:	56                   	push   %esi
  8005e8:	6a 00                	push   $0x0
  8005ea:	e8 0f fc ff ff       	call   8001fe <sys_page_unmap>
	return r;
  8005ef:	83 c4 10             	add    $0x10,%esp
  8005f2:	eb b5                	jmp    8005a9 <fd_close+0x40>

008005f4 <close>:

int
close(int fdnum)
{
  8005f4:	f3 0f 1e fb          	endbr32 
  8005f8:	55                   	push   %ebp
  8005f9:	89 e5                	mov    %esp,%ebp
  8005fb:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8005fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800601:	50                   	push   %eax
  800602:	ff 75 08             	pushl  0x8(%ebp)
  800605:	e8 ac fe ff ff       	call   8004b6 <fd_lookup>
  80060a:	83 c4 10             	add    $0x10,%esp
  80060d:	85 c0                	test   %eax,%eax
  80060f:	79 02                	jns    800613 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800611:	c9                   	leave  
  800612:	c3                   	ret    
		return fd_close(fd, 1);
  800613:	83 ec 08             	sub    $0x8,%esp
  800616:	6a 01                	push   $0x1
  800618:	ff 75 f4             	pushl  -0xc(%ebp)
  80061b:	e8 49 ff ff ff       	call   800569 <fd_close>
  800620:	83 c4 10             	add    $0x10,%esp
  800623:	eb ec                	jmp    800611 <close+0x1d>

00800625 <close_all>:

void
close_all(void)
{
  800625:	f3 0f 1e fb          	endbr32 
  800629:	55                   	push   %ebp
  80062a:	89 e5                	mov    %esp,%ebp
  80062c:	53                   	push   %ebx
  80062d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800630:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800635:	83 ec 0c             	sub    $0xc,%esp
  800638:	53                   	push   %ebx
  800639:	e8 b6 ff ff ff       	call   8005f4 <close>
	for (i = 0; i < MAXFD; i++)
  80063e:	83 c3 01             	add    $0x1,%ebx
  800641:	83 c4 10             	add    $0x10,%esp
  800644:	83 fb 20             	cmp    $0x20,%ebx
  800647:	75 ec                	jne    800635 <close_all+0x10>
}
  800649:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80064c:	c9                   	leave  
  80064d:	c3                   	ret    

0080064e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80064e:	f3 0f 1e fb          	endbr32 
  800652:	55                   	push   %ebp
  800653:	89 e5                	mov    %esp,%ebp
  800655:	57                   	push   %edi
  800656:	56                   	push   %esi
  800657:	53                   	push   %ebx
  800658:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80065b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80065e:	50                   	push   %eax
  80065f:	ff 75 08             	pushl  0x8(%ebp)
  800662:	e8 4f fe ff ff       	call   8004b6 <fd_lookup>
  800667:	89 c3                	mov    %eax,%ebx
  800669:	83 c4 10             	add    $0x10,%esp
  80066c:	85 c0                	test   %eax,%eax
  80066e:	0f 88 81 00 00 00    	js     8006f5 <dup+0xa7>
		return r;
	close(newfdnum);
  800674:	83 ec 0c             	sub    $0xc,%esp
  800677:	ff 75 0c             	pushl  0xc(%ebp)
  80067a:	e8 75 ff ff ff       	call   8005f4 <close>

	newfd = INDEX2FD(newfdnum);
  80067f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800682:	c1 e6 0c             	shl    $0xc,%esi
  800685:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80068b:	83 c4 04             	add    $0x4,%esp
  80068e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800691:	e8 af fd ff ff       	call   800445 <fd2data>
  800696:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800698:	89 34 24             	mov    %esi,(%esp)
  80069b:	e8 a5 fd ff ff       	call   800445 <fd2data>
  8006a0:	83 c4 10             	add    $0x10,%esp
  8006a3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8006a5:	89 d8                	mov    %ebx,%eax
  8006a7:	c1 e8 16             	shr    $0x16,%eax
  8006aa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8006b1:	a8 01                	test   $0x1,%al
  8006b3:	74 11                	je     8006c6 <dup+0x78>
  8006b5:	89 d8                	mov    %ebx,%eax
  8006b7:	c1 e8 0c             	shr    $0xc,%eax
  8006ba:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8006c1:	f6 c2 01             	test   $0x1,%dl
  8006c4:	75 39                	jne    8006ff <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8006c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006c9:	89 d0                	mov    %edx,%eax
  8006cb:	c1 e8 0c             	shr    $0xc,%eax
  8006ce:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006d5:	83 ec 0c             	sub    $0xc,%esp
  8006d8:	25 07 0e 00 00       	and    $0xe07,%eax
  8006dd:	50                   	push   %eax
  8006de:	56                   	push   %esi
  8006df:	6a 00                	push   $0x0
  8006e1:	52                   	push   %edx
  8006e2:	6a 00                	push   $0x0
  8006e4:	e8 cf fa ff ff       	call   8001b8 <sys_page_map>
  8006e9:	89 c3                	mov    %eax,%ebx
  8006eb:	83 c4 20             	add    $0x20,%esp
  8006ee:	85 c0                	test   %eax,%eax
  8006f0:	78 31                	js     800723 <dup+0xd5>
		goto err;

	return newfdnum;
  8006f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8006f5:	89 d8                	mov    %ebx,%eax
  8006f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006fa:	5b                   	pop    %ebx
  8006fb:	5e                   	pop    %esi
  8006fc:	5f                   	pop    %edi
  8006fd:	5d                   	pop    %ebp
  8006fe:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8006ff:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	25 07 0e 00 00       	and    $0xe07,%eax
  80070e:	50                   	push   %eax
  80070f:	57                   	push   %edi
  800710:	6a 00                	push   $0x0
  800712:	53                   	push   %ebx
  800713:	6a 00                	push   $0x0
  800715:	e8 9e fa ff ff       	call   8001b8 <sys_page_map>
  80071a:	89 c3                	mov    %eax,%ebx
  80071c:	83 c4 20             	add    $0x20,%esp
  80071f:	85 c0                	test   %eax,%eax
  800721:	79 a3                	jns    8006c6 <dup+0x78>
	sys_page_unmap(0, newfd);
  800723:	83 ec 08             	sub    $0x8,%esp
  800726:	56                   	push   %esi
  800727:	6a 00                	push   $0x0
  800729:	e8 d0 fa ff ff       	call   8001fe <sys_page_unmap>
	sys_page_unmap(0, nva);
  80072e:	83 c4 08             	add    $0x8,%esp
  800731:	57                   	push   %edi
  800732:	6a 00                	push   $0x0
  800734:	e8 c5 fa ff ff       	call   8001fe <sys_page_unmap>
	return r;
  800739:	83 c4 10             	add    $0x10,%esp
  80073c:	eb b7                	jmp    8006f5 <dup+0xa7>

0080073e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80073e:	f3 0f 1e fb          	endbr32 
  800742:	55                   	push   %ebp
  800743:	89 e5                	mov    %esp,%ebp
  800745:	53                   	push   %ebx
  800746:	83 ec 1c             	sub    $0x1c,%esp
  800749:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80074c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80074f:	50                   	push   %eax
  800750:	53                   	push   %ebx
  800751:	e8 60 fd ff ff       	call   8004b6 <fd_lookup>
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	85 c0                	test   %eax,%eax
  80075b:	78 3f                	js     80079c <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800763:	50                   	push   %eax
  800764:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800767:	ff 30                	pushl  (%eax)
  800769:	e8 9c fd ff ff       	call   80050a <dev_lookup>
  80076e:	83 c4 10             	add    $0x10,%esp
  800771:	85 c0                	test   %eax,%eax
  800773:	78 27                	js     80079c <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800775:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800778:	8b 42 08             	mov    0x8(%edx),%eax
  80077b:	83 e0 03             	and    $0x3,%eax
  80077e:	83 f8 01             	cmp    $0x1,%eax
  800781:	74 1e                	je     8007a1 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800786:	8b 40 08             	mov    0x8(%eax),%eax
  800789:	85 c0                	test   %eax,%eax
  80078b:	74 35                	je     8007c2 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80078d:	83 ec 04             	sub    $0x4,%esp
  800790:	ff 75 10             	pushl  0x10(%ebp)
  800793:	ff 75 0c             	pushl  0xc(%ebp)
  800796:	52                   	push   %edx
  800797:	ff d0                	call   *%eax
  800799:	83 c4 10             	add    $0x10,%esp
}
  80079c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80079f:	c9                   	leave  
  8007a0:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8007a1:	a1 08 40 80 00       	mov    0x804008,%eax
  8007a6:	8b 40 48             	mov    0x48(%eax),%eax
  8007a9:	83 ec 04             	sub    $0x4,%esp
  8007ac:	53                   	push   %ebx
  8007ad:	50                   	push   %eax
  8007ae:	68 d9 24 80 00       	push   $0x8024d9
  8007b3:	e8 62 0f 00 00       	call   80171a <cprintf>
		return -E_INVAL;
  8007b8:	83 c4 10             	add    $0x10,%esp
  8007bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007c0:	eb da                	jmp    80079c <read+0x5e>
		return -E_NOT_SUPP;
  8007c2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007c7:	eb d3                	jmp    80079c <read+0x5e>

008007c9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8007c9:	f3 0f 1e fb          	endbr32 
  8007cd:	55                   	push   %ebp
  8007ce:	89 e5                	mov    %esp,%ebp
  8007d0:	57                   	push   %edi
  8007d1:	56                   	push   %esi
  8007d2:	53                   	push   %ebx
  8007d3:	83 ec 0c             	sub    $0xc,%esp
  8007d6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8007d9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8007dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007e1:	eb 02                	jmp    8007e5 <readn+0x1c>
  8007e3:	01 c3                	add    %eax,%ebx
  8007e5:	39 f3                	cmp    %esi,%ebx
  8007e7:	73 21                	jae    80080a <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8007e9:	83 ec 04             	sub    $0x4,%esp
  8007ec:	89 f0                	mov    %esi,%eax
  8007ee:	29 d8                	sub    %ebx,%eax
  8007f0:	50                   	push   %eax
  8007f1:	89 d8                	mov    %ebx,%eax
  8007f3:	03 45 0c             	add    0xc(%ebp),%eax
  8007f6:	50                   	push   %eax
  8007f7:	57                   	push   %edi
  8007f8:	e8 41 ff ff ff       	call   80073e <read>
		if (m < 0)
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	85 c0                	test   %eax,%eax
  800802:	78 04                	js     800808 <readn+0x3f>
			return m;
		if (m == 0)
  800804:	75 dd                	jne    8007e3 <readn+0x1a>
  800806:	eb 02                	jmp    80080a <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800808:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80080a:	89 d8                	mov    %ebx,%eax
  80080c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80080f:	5b                   	pop    %ebx
  800810:	5e                   	pop    %esi
  800811:	5f                   	pop    %edi
  800812:	5d                   	pop    %ebp
  800813:	c3                   	ret    

00800814 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800814:	f3 0f 1e fb          	endbr32 
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
  80081b:	53                   	push   %ebx
  80081c:	83 ec 1c             	sub    $0x1c,%esp
  80081f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800822:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800825:	50                   	push   %eax
  800826:	53                   	push   %ebx
  800827:	e8 8a fc ff ff       	call   8004b6 <fd_lookup>
  80082c:	83 c4 10             	add    $0x10,%esp
  80082f:	85 c0                	test   %eax,%eax
  800831:	78 3a                	js     80086d <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800833:	83 ec 08             	sub    $0x8,%esp
  800836:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800839:	50                   	push   %eax
  80083a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80083d:	ff 30                	pushl  (%eax)
  80083f:	e8 c6 fc ff ff       	call   80050a <dev_lookup>
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	85 c0                	test   %eax,%eax
  800849:	78 22                	js     80086d <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80084b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800852:	74 1e                	je     800872 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800854:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800857:	8b 52 0c             	mov    0xc(%edx),%edx
  80085a:	85 d2                	test   %edx,%edx
  80085c:	74 35                	je     800893 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80085e:	83 ec 04             	sub    $0x4,%esp
  800861:	ff 75 10             	pushl  0x10(%ebp)
  800864:	ff 75 0c             	pushl  0xc(%ebp)
  800867:	50                   	push   %eax
  800868:	ff d2                	call   *%edx
  80086a:	83 c4 10             	add    $0x10,%esp
}
  80086d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800870:	c9                   	leave  
  800871:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800872:	a1 08 40 80 00       	mov    0x804008,%eax
  800877:	8b 40 48             	mov    0x48(%eax),%eax
  80087a:	83 ec 04             	sub    $0x4,%esp
  80087d:	53                   	push   %ebx
  80087e:	50                   	push   %eax
  80087f:	68 f5 24 80 00       	push   $0x8024f5
  800884:	e8 91 0e 00 00       	call   80171a <cprintf>
		return -E_INVAL;
  800889:	83 c4 10             	add    $0x10,%esp
  80088c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800891:	eb da                	jmp    80086d <write+0x59>
		return -E_NOT_SUPP;
  800893:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800898:	eb d3                	jmp    80086d <write+0x59>

0080089a <seek>:

int
seek(int fdnum, off_t offset)
{
  80089a:	f3 0f 1e fb          	endbr32 
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
  8008a1:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8008a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008a7:	50                   	push   %eax
  8008a8:	ff 75 08             	pushl  0x8(%ebp)
  8008ab:	e8 06 fc ff ff       	call   8004b6 <fd_lookup>
  8008b0:	83 c4 10             	add    $0x10,%esp
  8008b3:	85 c0                	test   %eax,%eax
  8008b5:	78 0e                	js     8008c5 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8008b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008bd:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8008c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008c5:	c9                   	leave  
  8008c6:	c3                   	ret    

008008c7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8008c7:	f3 0f 1e fb          	endbr32 
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	53                   	push   %ebx
  8008cf:	83 ec 1c             	sub    $0x1c,%esp
  8008d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008d8:	50                   	push   %eax
  8008d9:	53                   	push   %ebx
  8008da:	e8 d7 fb ff ff       	call   8004b6 <fd_lookup>
  8008df:	83 c4 10             	add    $0x10,%esp
  8008e2:	85 c0                	test   %eax,%eax
  8008e4:	78 37                	js     80091d <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008e6:	83 ec 08             	sub    $0x8,%esp
  8008e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008ec:	50                   	push   %eax
  8008ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f0:	ff 30                	pushl  (%eax)
  8008f2:	e8 13 fc ff ff       	call   80050a <dev_lookup>
  8008f7:	83 c4 10             	add    $0x10,%esp
  8008fa:	85 c0                	test   %eax,%eax
  8008fc:	78 1f                	js     80091d <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8008fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800901:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800905:	74 1b                	je     800922 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800907:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80090a:	8b 52 18             	mov    0x18(%edx),%edx
  80090d:	85 d2                	test   %edx,%edx
  80090f:	74 32                	je     800943 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	50                   	push   %eax
  800918:	ff d2                	call   *%edx
  80091a:	83 c4 10             	add    $0x10,%esp
}
  80091d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800920:	c9                   	leave  
  800921:	c3                   	ret    
			thisenv->env_id, fdnum);
  800922:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800927:	8b 40 48             	mov    0x48(%eax),%eax
  80092a:	83 ec 04             	sub    $0x4,%esp
  80092d:	53                   	push   %ebx
  80092e:	50                   	push   %eax
  80092f:	68 b8 24 80 00       	push   $0x8024b8
  800934:	e8 e1 0d 00 00       	call   80171a <cprintf>
		return -E_INVAL;
  800939:	83 c4 10             	add    $0x10,%esp
  80093c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800941:	eb da                	jmp    80091d <ftruncate+0x56>
		return -E_NOT_SUPP;
  800943:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800948:	eb d3                	jmp    80091d <ftruncate+0x56>

0080094a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80094a:	f3 0f 1e fb          	endbr32 
  80094e:	55                   	push   %ebp
  80094f:	89 e5                	mov    %esp,%ebp
  800951:	53                   	push   %ebx
  800952:	83 ec 1c             	sub    $0x1c,%esp
  800955:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800958:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80095b:	50                   	push   %eax
  80095c:	ff 75 08             	pushl  0x8(%ebp)
  80095f:	e8 52 fb ff ff       	call   8004b6 <fd_lookup>
  800964:	83 c4 10             	add    $0x10,%esp
  800967:	85 c0                	test   %eax,%eax
  800969:	78 4b                	js     8009b6 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80096b:	83 ec 08             	sub    $0x8,%esp
  80096e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800971:	50                   	push   %eax
  800972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800975:	ff 30                	pushl  (%eax)
  800977:	e8 8e fb ff ff       	call   80050a <dev_lookup>
  80097c:	83 c4 10             	add    $0x10,%esp
  80097f:	85 c0                	test   %eax,%eax
  800981:	78 33                	js     8009b6 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  800983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800986:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80098a:	74 2f                	je     8009bb <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80098c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80098f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800996:	00 00 00 
	stat->st_isdir = 0;
  800999:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8009a0:	00 00 00 
	stat->st_dev = dev;
  8009a3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	53                   	push   %ebx
  8009ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8009b0:	ff 50 14             	call   *0x14(%eax)
  8009b3:	83 c4 10             	add    $0x10,%esp
}
  8009b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009b9:	c9                   	leave  
  8009ba:	c3                   	ret    
		return -E_NOT_SUPP;
  8009bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8009c0:	eb f4                	jmp    8009b6 <fstat+0x6c>

008009c2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8009c2:	f3 0f 1e fb          	endbr32 
  8009c6:	55                   	push   %ebp
  8009c7:	89 e5                	mov    %esp,%ebp
  8009c9:	56                   	push   %esi
  8009ca:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8009cb:	83 ec 08             	sub    $0x8,%esp
  8009ce:	6a 00                	push   $0x0
  8009d0:	ff 75 08             	pushl  0x8(%ebp)
  8009d3:	e8 fb 01 00 00       	call   800bd3 <open>
  8009d8:	89 c3                	mov    %eax,%ebx
  8009da:	83 c4 10             	add    $0x10,%esp
  8009dd:	85 c0                	test   %eax,%eax
  8009df:	78 1b                	js     8009fc <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8009e1:	83 ec 08             	sub    $0x8,%esp
  8009e4:	ff 75 0c             	pushl  0xc(%ebp)
  8009e7:	50                   	push   %eax
  8009e8:	e8 5d ff ff ff       	call   80094a <fstat>
  8009ed:	89 c6                	mov    %eax,%esi
	close(fd);
  8009ef:	89 1c 24             	mov    %ebx,(%esp)
  8009f2:	e8 fd fb ff ff       	call   8005f4 <close>
	return r;
  8009f7:	83 c4 10             	add    $0x10,%esp
  8009fa:	89 f3                	mov    %esi,%ebx
}
  8009fc:	89 d8                	mov    %ebx,%eax
  8009fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a01:	5b                   	pop    %ebx
  800a02:	5e                   	pop    %esi
  800a03:	5d                   	pop    %ebp
  800a04:	c3                   	ret    

00800a05 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	56                   	push   %esi
  800a09:	53                   	push   %ebx
  800a0a:	89 c6                	mov    %eax,%esi
  800a0c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800a0e:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800a15:	74 27                	je     800a3e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800a17:	6a 07                	push   $0x7
  800a19:	68 00 50 80 00       	push   $0x805000
  800a1e:	56                   	push   %esi
  800a1f:	ff 35 00 40 80 00    	pushl  0x804000
  800a25:	e8 f1 16 00 00       	call   80211b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800a2a:	83 c4 0c             	add    $0xc,%esp
  800a2d:	6a 00                	push   $0x0
  800a2f:	53                   	push   %ebx
  800a30:	6a 00                	push   $0x0
  800a32:	e8 5f 16 00 00       	call   802096 <ipc_recv>
}
  800a37:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a3a:	5b                   	pop    %ebx
  800a3b:	5e                   	pop    %esi
  800a3c:	5d                   	pop    %ebp
  800a3d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800a3e:	83 ec 0c             	sub    $0xc,%esp
  800a41:	6a 01                	push   $0x1
  800a43:	e8 2b 17 00 00       	call   802173 <ipc_find_env>
  800a48:	a3 00 40 80 00       	mov    %eax,0x804000
  800a4d:	83 c4 10             	add    $0x10,%esp
  800a50:	eb c5                	jmp    800a17 <fsipc+0x12>

00800a52 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800a52:	f3 0f 1e fb          	endbr32 
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8b 40 0c             	mov    0xc(%eax),%eax
  800a62:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6a:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800a6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a74:	b8 02 00 00 00       	mov    $0x2,%eax
  800a79:	e8 87 ff ff ff       	call   800a05 <fsipc>
}
  800a7e:	c9                   	leave  
  800a7f:	c3                   	ret    

00800a80 <devfile_flush>:
{
  800a80:	f3 0f 1e fb          	endbr32 
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	8b 40 0c             	mov    0xc(%eax),%eax
  800a90:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a95:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9a:	b8 06 00 00 00       	mov    $0x6,%eax
  800a9f:	e8 61 ff ff ff       	call   800a05 <fsipc>
}
  800aa4:	c9                   	leave  
  800aa5:	c3                   	ret    

00800aa6 <devfile_stat>:
{
  800aa6:	f3 0f 1e fb          	endbr32 
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	53                   	push   %ebx
  800aae:	83 ec 04             	sub    $0x4,%esp
  800ab1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	8b 40 0c             	mov    0xc(%eax),%eax
  800aba:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800abf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac4:	b8 05 00 00 00       	mov    $0x5,%eax
  800ac9:	e8 37 ff ff ff       	call   800a05 <fsipc>
  800ace:	85 c0                	test   %eax,%eax
  800ad0:	78 2c                	js     800afe <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	68 00 50 80 00       	push   $0x805000
  800ada:	53                   	push   %ebx
  800adb:	e8 44 12 00 00       	call   801d24 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800ae0:	a1 80 50 80 00       	mov    0x805080,%eax
  800ae5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800aeb:	a1 84 50 80 00       	mov    0x805084,%eax
  800af0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800af6:	83 c4 10             	add    $0x10,%esp
  800af9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800afe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b01:	c9                   	leave  
  800b02:	c3                   	ret    

00800b03 <devfile_write>:
{
  800b03:	f3 0f 1e fb          	endbr32 
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	83 ec 0c             	sub    $0xc,%esp
  800b0d:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800b10:	8b 55 08             	mov    0x8(%ebp),%edx
  800b13:	8b 52 0c             	mov    0xc(%edx),%edx
  800b16:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  800b1c:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800b21:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800b26:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  800b29:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800b2e:	50                   	push   %eax
  800b2f:	ff 75 0c             	pushl  0xc(%ebp)
  800b32:	68 08 50 80 00       	push   $0x805008
  800b37:	e8 9e 13 00 00       	call   801eda <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800b3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b41:	b8 04 00 00 00       	mov    $0x4,%eax
  800b46:	e8 ba fe ff ff       	call   800a05 <fsipc>
}
  800b4b:	c9                   	leave  
  800b4c:	c3                   	ret    

00800b4d <devfile_read>:
{
  800b4d:	f3 0f 1e fb          	endbr32 
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	56                   	push   %esi
  800b55:	53                   	push   %ebx
  800b56:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	8b 40 0c             	mov    0xc(%eax),%eax
  800b5f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b64:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6f:	b8 03 00 00 00       	mov    $0x3,%eax
  800b74:	e8 8c fe ff ff       	call   800a05 <fsipc>
  800b79:	89 c3                	mov    %eax,%ebx
  800b7b:	85 c0                	test   %eax,%eax
  800b7d:	78 1f                	js     800b9e <devfile_read+0x51>
	assert(r <= n);
  800b7f:	39 f0                	cmp    %esi,%eax
  800b81:	77 24                	ja     800ba7 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800b83:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b88:	7f 33                	jg     800bbd <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b8a:	83 ec 04             	sub    $0x4,%esp
  800b8d:	50                   	push   %eax
  800b8e:	68 00 50 80 00       	push   $0x805000
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	e8 3f 13 00 00       	call   801eda <memmove>
	return r;
  800b9b:	83 c4 10             	add    $0x10,%esp
}
  800b9e:	89 d8                	mov    %ebx,%eax
  800ba0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ba3:	5b                   	pop    %ebx
  800ba4:	5e                   	pop    %esi
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    
	assert(r <= n);
  800ba7:	68 28 25 80 00       	push   $0x802528
  800bac:	68 2f 25 80 00       	push   $0x80252f
  800bb1:	6a 7c                	push   $0x7c
  800bb3:	68 44 25 80 00       	push   $0x802544
  800bb8:	e8 76 0a 00 00       	call   801633 <_panic>
	assert(r <= PGSIZE);
  800bbd:	68 4f 25 80 00       	push   $0x80254f
  800bc2:	68 2f 25 80 00       	push   $0x80252f
  800bc7:	6a 7d                	push   $0x7d
  800bc9:	68 44 25 80 00       	push   $0x802544
  800bce:	e8 60 0a 00 00       	call   801633 <_panic>

00800bd3 <open>:
{
  800bd3:	f3 0f 1e fb          	endbr32 
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	56                   	push   %esi
  800bdb:	53                   	push   %ebx
  800bdc:	83 ec 1c             	sub    $0x1c,%esp
  800bdf:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800be2:	56                   	push   %esi
  800be3:	e8 f9 10 00 00       	call   801ce1 <strlen>
  800be8:	83 c4 10             	add    $0x10,%esp
  800beb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800bf0:	7f 6c                	jg     800c5e <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800bf2:	83 ec 0c             	sub    $0xc,%esp
  800bf5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bf8:	50                   	push   %eax
  800bf9:	e8 62 f8 ff ff       	call   800460 <fd_alloc>
  800bfe:	89 c3                	mov    %eax,%ebx
  800c00:	83 c4 10             	add    $0x10,%esp
  800c03:	85 c0                	test   %eax,%eax
  800c05:	78 3c                	js     800c43 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800c07:	83 ec 08             	sub    $0x8,%esp
  800c0a:	56                   	push   %esi
  800c0b:	68 00 50 80 00       	push   $0x805000
  800c10:	e8 0f 11 00 00       	call   801d24 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800c15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c18:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800c1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c20:	b8 01 00 00 00       	mov    $0x1,%eax
  800c25:	e8 db fd ff ff       	call   800a05 <fsipc>
  800c2a:	89 c3                	mov    %eax,%ebx
  800c2c:	83 c4 10             	add    $0x10,%esp
  800c2f:	85 c0                	test   %eax,%eax
  800c31:	78 19                	js     800c4c <open+0x79>
	return fd2num(fd);
  800c33:	83 ec 0c             	sub    $0xc,%esp
  800c36:	ff 75 f4             	pushl  -0xc(%ebp)
  800c39:	e8 f3 f7 ff ff       	call   800431 <fd2num>
  800c3e:	89 c3                	mov    %eax,%ebx
  800c40:	83 c4 10             	add    $0x10,%esp
}
  800c43:	89 d8                	mov    %ebx,%eax
  800c45:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c48:	5b                   	pop    %ebx
  800c49:	5e                   	pop    %esi
  800c4a:	5d                   	pop    %ebp
  800c4b:	c3                   	ret    
		fd_close(fd, 0);
  800c4c:	83 ec 08             	sub    $0x8,%esp
  800c4f:	6a 00                	push   $0x0
  800c51:	ff 75 f4             	pushl  -0xc(%ebp)
  800c54:	e8 10 f9 ff ff       	call   800569 <fd_close>
		return r;
  800c59:	83 c4 10             	add    $0x10,%esp
  800c5c:	eb e5                	jmp    800c43 <open+0x70>
		return -E_BAD_PATH;
  800c5e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800c63:	eb de                	jmp    800c43 <open+0x70>

00800c65 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800c65:	f3 0f 1e fb          	endbr32 
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c74:	b8 08 00 00 00       	mov    $0x8,%eax
  800c79:	e8 87 fd ff ff       	call   800a05 <fsipc>
}
  800c7e:	c9                   	leave  
  800c7f:	c3                   	ret    

00800c80 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800c80:	f3 0f 1e fb          	endbr32 
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800c8a:	68 5b 25 80 00       	push   $0x80255b
  800c8f:	ff 75 0c             	pushl  0xc(%ebp)
  800c92:	e8 8d 10 00 00       	call   801d24 <strcpy>
	return 0;
}
  800c97:	b8 00 00 00 00       	mov    $0x0,%eax
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <devsock_close>:
{
  800c9e:	f3 0f 1e fb          	endbr32 
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	53                   	push   %ebx
  800ca6:	83 ec 10             	sub    $0x10,%esp
  800ca9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800cac:	53                   	push   %ebx
  800cad:	e8 fe 14 00 00       	call   8021b0 <pageref>
  800cb2:	89 c2                	mov    %eax,%edx
  800cb4:	83 c4 10             	add    $0x10,%esp
		return 0;
  800cb7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  800cbc:	83 fa 01             	cmp    $0x1,%edx
  800cbf:	74 05                	je     800cc6 <devsock_close+0x28>
}
  800cc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cc4:	c9                   	leave  
  800cc5:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800cc6:	83 ec 0c             	sub    $0xc,%esp
  800cc9:	ff 73 0c             	pushl  0xc(%ebx)
  800ccc:	e8 e3 02 00 00       	call   800fb4 <nsipc_close>
  800cd1:	83 c4 10             	add    $0x10,%esp
  800cd4:	eb eb                	jmp    800cc1 <devsock_close+0x23>

00800cd6 <devsock_write>:
{
  800cd6:	f3 0f 1e fb          	endbr32 
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
  800cdd:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800ce0:	6a 00                	push   $0x0
  800ce2:	ff 75 10             	pushl  0x10(%ebp)
  800ce5:	ff 75 0c             	pushl  0xc(%ebp)
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	ff 70 0c             	pushl  0xc(%eax)
  800cee:	e8 b5 03 00 00       	call   8010a8 <nsipc_send>
}
  800cf3:	c9                   	leave  
  800cf4:	c3                   	ret    

00800cf5 <devsock_read>:
{
  800cf5:	f3 0f 1e fb          	endbr32 
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800cff:	6a 00                	push   $0x0
  800d01:	ff 75 10             	pushl  0x10(%ebp)
  800d04:	ff 75 0c             	pushl  0xc(%ebp)
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	ff 70 0c             	pushl  0xc(%eax)
  800d0d:	e8 1f 03 00 00       	call   801031 <nsipc_recv>
}
  800d12:	c9                   	leave  
  800d13:	c3                   	ret    

00800d14 <fd2sockid>:
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800d1a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800d1d:	52                   	push   %edx
  800d1e:	50                   	push   %eax
  800d1f:	e8 92 f7 ff ff       	call   8004b6 <fd_lookup>
  800d24:	83 c4 10             	add    $0x10,%esp
  800d27:	85 c0                	test   %eax,%eax
  800d29:	78 10                	js     800d3b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d2e:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800d34:	39 08                	cmp    %ecx,(%eax)
  800d36:	75 05                	jne    800d3d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800d38:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800d3b:	c9                   	leave  
  800d3c:	c3                   	ret    
		return -E_NOT_SUPP;
  800d3d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800d42:	eb f7                	jmp    800d3b <fd2sockid+0x27>

00800d44 <alloc_sockfd>:
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	56                   	push   %esi
  800d48:	53                   	push   %ebx
  800d49:	83 ec 1c             	sub    $0x1c,%esp
  800d4c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800d4e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d51:	50                   	push   %eax
  800d52:	e8 09 f7 ff ff       	call   800460 <fd_alloc>
  800d57:	89 c3                	mov    %eax,%ebx
  800d59:	83 c4 10             	add    $0x10,%esp
  800d5c:	85 c0                	test   %eax,%eax
  800d5e:	78 43                	js     800da3 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800d60:	83 ec 04             	sub    $0x4,%esp
  800d63:	68 07 04 00 00       	push   $0x407
  800d68:	ff 75 f4             	pushl  -0xc(%ebp)
  800d6b:	6a 00                	push   $0x0
  800d6d:	e8 ff f3 ff ff       	call   800171 <sys_page_alloc>
  800d72:	89 c3                	mov    %eax,%ebx
  800d74:	83 c4 10             	add    $0x10,%esp
  800d77:	85 c0                	test   %eax,%eax
  800d79:	78 28                	js     800da3 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d7e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800d84:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d89:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800d90:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800d93:	83 ec 0c             	sub    $0xc,%esp
  800d96:	50                   	push   %eax
  800d97:	e8 95 f6 ff ff       	call   800431 <fd2num>
  800d9c:	89 c3                	mov    %eax,%ebx
  800d9e:	83 c4 10             	add    $0x10,%esp
  800da1:	eb 0c                	jmp    800daf <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800da3:	83 ec 0c             	sub    $0xc,%esp
  800da6:	56                   	push   %esi
  800da7:	e8 08 02 00 00       	call   800fb4 <nsipc_close>
		return r;
  800dac:	83 c4 10             	add    $0x10,%esp
}
  800daf:	89 d8                	mov    %ebx,%eax
  800db1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800db4:	5b                   	pop    %ebx
  800db5:	5e                   	pop    %esi
  800db6:	5d                   	pop    %ebp
  800db7:	c3                   	ret    

00800db8 <accept>:
{
  800db8:	f3 0f 1e fb          	endbr32 
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	e8 4a ff ff ff       	call   800d14 <fd2sockid>
  800dca:	85 c0                	test   %eax,%eax
  800dcc:	78 1b                	js     800de9 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800dce:	83 ec 04             	sub    $0x4,%esp
  800dd1:	ff 75 10             	pushl  0x10(%ebp)
  800dd4:	ff 75 0c             	pushl  0xc(%ebp)
  800dd7:	50                   	push   %eax
  800dd8:	e8 22 01 00 00       	call   800eff <nsipc_accept>
  800ddd:	83 c4 10             	add    $0x10,%esp
  800de0:	85 c0                	test   %eax,%eax
  800de2:	78 05                	js     800de9 <accept+0x31>
	return alloc_sockfd(r);
  800de4:	e8 5b ff ff ff       	call   800d44 <alloc_sockfd>
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <bind>:
{
  800deb:	f3 0f 1e fb          	endbr32 
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	e8 17 ff ff ff       	call   800d14 <fd2sockid>
  800dfd:	85 c0                	test   %eax,%eax
  800dff:	78 12                	js     800e13 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  800e01:	83 ec 04             	sub    $0x4,%esp
  800e04:	ff 75 10             	pushl  0x10(%ebp)
  800e07:	ff 75 0c             	pushl  0xc(%ebp)
  800e0a:	50                   	push   %eax
  800e0b:	e8 45 01 00 00       	call   800f55 <nsipc_bind>
  800e10:	83 c4 10             	add    $0x10,%esp
}
  800e13:	c9                   	leave  
  800e14:	c3                   	ret    

00800e15 <shutdown>:
{
  800e15:	f3 0f 1e fb          	endbr32 
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	e8 ed fe ff ff       	call   800d14 <fd2sockid>
  800e27:	85 c0                	test   %eax,%eax
  800e29:	78 0f                	js     800e3a <shutdown+0x25>
	return nsipc_shutdown(r, how);
  800e2b:	83 ec 08             	sub    $0x8,%esp
  800e2e:	ff 75 0c             	pushl  0xc(%ebp)
  800e31:	50                   	push   %eax
  800e32:	e8 57 01 00 00       	call   800f8e <nsipc_shutdown>
  800e37:	83 c4 10             	add    $0x10,%esp
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <connect>:
{
  800e3c:	f3 0f 1e fb          	endbr32 
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	e8 c6 fe ff ff       	call   800d14 <fd2sockid>
  800e4e:	85 c0                	test   %eax,%eax
  800e50:	78 12                	js     800e64 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  800e52:	83 ec 04             	sub    $0x4,%esp
  800e55:	ff 75 10             	pushl  0x10(%ebp)
  800e58:	ff 75 0c             	pushl  0xc(%ebp)
  800e5b:	50                   	push   %eax
  800e5c:	e8 71 01 00 00       	call   800fd2 <nsipc_connect>
  800e61:	83 c4 10             	add    $0x10,%esp
}
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <listen>:
{
  800e66:	f3 0f 1e fb          	endbr32 
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	e8 9c fe ff ff       	call   800d14 <fd2sockid>
  800e78:	85 c0                	test   %eax,%eax
  800e7a:	78 0f                	js     800e8b <listen+0x25>
	return nsipc_listen(r, backlog);
  800e7c:	83 ec 08             	sub    $0x8,%esp
  800e7f:	ff 75 0c             	pushl  0xc(%ebp)
  800e82:	50                   	push   %eax
  800e83:	e8 83 01 00 00       	call   80100b <nsipc_listen>
  800e88:	83 c4 10             	add    $0x10,%esp
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <socket>:

int
socket(int domain, int type, int protocol)
{
  800e8d:	f3 0f 1e fb          	endbr32 
  800e91:	55                   	push   %ebp
  800e92:	89 e5                	mov    %esp,%ebp
  800e94:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800e97:	ff 75 10             	pushl  0x10(%ebp)
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	ff 75 08             	pushl  0x8(%ebp)
  800ea0:	e8 65 02 00 00       	call   80110a <nsipc_socket>
  800ea5:	83 c4 10             	add    $0x10,%esp
  800ea8:	85 c0                	test   %eax,%eax
  800eaa:	78 05                	js     800eb1 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  800eac:	e8 93 fe ff ff       	call   800d44 <alloc_sockfd>
}
  800eb1:	c9                   	leave  
  800eb2:	c3                   	ret    

00800eb3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800eb3:	55                   	push   %ebp
  800eb4:	89 e5                	mov    %esp,%ebp
  800eb6:	53                   	push   %ebx
  800eb7:	83 ec 04             	sub    $0x4,%esp
  800eba:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800ebc:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800ec3:	74 26                	je     800eeb <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800ec5:	6a 07                	push   $0x7
  800ec7:	68 00 60 80 00       	push   $0x806000
  800ecc:	53                   	push   %ebx
  800ecd:	ff 35 04 40 80 00    	pushl  0x804004
  800ed3:	e8 43 12 00 00       	call   80211b <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800ed8:	83 c4 0c             	add    $0xc,%esp
  800edb:	6a 00                	push   $0x0
  800edd:	6a 00                	push   $0x0
  800edf:	6a 00                	push   $0x0
  800ee1:	e8 b0 11 00 00       	call   802096 <ipc_recv>
}
  800ee6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ee9:	c9                   	leave  
  800eea:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800eeb:	83 ec 0c             	sub    $0xc,%esp
  800eee:	6a 02                	push   $0x2
  800ef0:	e8 7e 12 00 00       	call   802173 <ipc_find_env>
  800ef5:	a3 04 40 80 00       	mov    %eax,0x804004
  800efa:	83 c4 10             	add    $0x10,%esp
  800efd:	eb c6                	jmp    800ec5 <nsipc+0x12>

00800eff <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800eff:	f3 0f 1e fb          	endbr32 
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	56                   	push   %esi
  800f07:	53                   	push   %ebx
  800f08:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800f13:	8b 06                	mov    (%esi),%eax
  800f15:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800f1a:	b8 01 00 00 00       	mov    $0x1,%eax
  800f1f:	e8 8f ff ff ff       	call   800eb3 <nsipc>
  800f24:	89 c3                	mov    %eax,%ebx
  800f26:	85 c0                	test   %eax,%eax
  800f28:	79 09                	jns    800f33 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  800f2a:	89 d8                	mov    %ebx,%eax
  800f2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f2f:	5b                   	pop    %ebx
  800f30:	5e                   	pop    %esi
  800f31:	5d                   	pop    %ebp
  800f32:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800f33:	83 ec 04             	sub    $0x4,%esp
  800f36:	ff 35 10 60 80 00    	pushl  0x806010
  800f3c:	68 00 60 80 00       	push   $0x806000
  800f41:	ff 75 0c             	pushl  0xc(%ebp)
  800f44:	e8 91 0f 00 00       	call   801eda <memmove>
		*addrlen = ret->ret_addrlen;
  800f49:	a1 10 60 80 00       	mov    0x806010,%eax
  800f4e:	89 06                	mov    %eax,(%esi)
  800f50:	83 c4 10             	add    $0x10,%esp
	return r;
  800f53:	eb d5                	jmp    800f2a <nsipc_accept+0x2b>

00800f55 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800f55:	f3 0f 1e fb          	endbr32 
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	53                   	push   %ebx
  800f5d:	83 ec 08             	sub    $0x8,%esp
  800f60:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800f6b:	53                   	push   %ebx
  800f6c:	ff 75 0c             	pushl  0xc(%ebp)
  800f6f:	68 04 60 80 00       	push   $0x806004
  800f74:	e8 61 0f 00 00       	call   801eda <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800f79:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800f7f:	b8 02 00 00 00       	mov    $0x2,%eax
  800f84:	e8 2a ff ff ff       	call   800eb3 <nsipc>
}
  800f89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f8c:	c9                   	leave  
  800f8d:	c3                   	ret    

00800f8e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800f8e:	f3 0f 1e fb          	endbr32 
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa3:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800fa8:	b8 03 00 00 00       	mov    $0x3,%eax
  800fad:	e8 01 ff ff ff       	call   800eb3 <nsipc>
}
  800fb2:	c9                   	leave  
  800fb3:	c3                   	ret    

00800fb4 <nsipc_close>:

int
nsipc_close(int s)
{
  800fb4:	f3 0f 1e fb          	endbr32 
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800fc6:	b8 04 00 00 00       	mov    $0x4,%eax
  800fcb:	e8 e3 fe ff ff       	call   800eb3 <nsipc>
}
  800fd0:	c9                   	leave  
  800fd1:	c3                   	ret    

00800fd2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800fd2:	f3 0f 1e fb          	endbr32 
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
  800fd9:	53                   	push   %ebx
  800fda:	83 ec 08             	sub    $0x8,%esp
  800fdd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800fe8:	53                   	push   %ebx
  800fe9:	ff 75 0c             	pushl  0xc(%ebp)
  800fec:	68 04 60 80 00       	push   $0x806004
  800ff1:	e8 e4 0e 00 00       	call   801eda <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800ff6:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  800ffc:	b8 05 00 00 00       	mov    $0x5,%eax
  801001:	e8 ad fe ff ff       	call   800eb3 <nsipc>
}
  801006:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801009:	c9                   	leave  
  80100a:	c3                   	ret    

0080100b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80100b:	f3 0f 1e fb          	endbr32 
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80101d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801020:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801025:	b8 06 00 00 00       	mov    $0x6,%eax
  80102a:	e8 84 fe ff ff       	call   800eb3 <nsipc>
}
  80102f:	c9                   	leave  
  801030:	c3                   	ret    

00801031 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801031:	f3 0f 1e fb          	endbr32 
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	56                   	push   %esi
  801039:	53                   	push   %ebx
  80103a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801045:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80104b:	8b 45 14             	mov    0x14(%ebp),%eax
  80104e:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801053:	b8 07 00 00 00       	mov    $0x7,%eax
  801058:	e8 56 fe ff ff       	call   800eb3 <nsipc>
  80105d:	89 c3                	mov    %eax,%ebx
  80105f:	85 c0                	test   %eax,%eax
  801061:	78 26                	js     801089 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801063:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801069:	b8 3f 06 00 00       	mov    $0x63f,%eax
  80106e:	0f 4e c6             	cmovle %esi,%eax
  801071:	39 c3                	cmp    %eax,%ebx
  801073:	7f 1d                	jg     801092 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801075:	83 ec 04             	sub    $0x4,%esp
  801078:	53                   	push   %ebx
  801079:	68 00 60 80 00       	push   $0x806000
  80107e:	ff 75 0c             	pushl  0xc(%ebp)
  801081:	e8 54 0e 00 00       	call   801eda <memmove>
  801086:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801089:	89 d8                	mov    %ebx,%eax
  80108b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80108e:	5b                   	pop    %ebx
  80108f:	5e                   	pop    %esi
  801090:	5d                   	pop    %ebp
  801091:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801092:	68 67 25 80 00       	push   $0x802567
  801097:	68 2f 25 80 00       	push   $0x80252f
  80109c:	6a 62                	push   $0x62
  80109e:	68 7c 25 80 00       	push   $0x80257c
  8010a3:	e8 8b 05 00 00       	call   801633 <_panic>

008010a8 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8010a8:	f3 0f 1e fb          	endbr32 
  8010ac:	55                   	push   %ebp
  8010ad:	89 e5                	mov    %esp,%ebp
  8010af:	53                   	push   %ebx
  8010b0:	83 ec 04             	sub    $0x4,%esp
  8010b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8010be:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8010c4:	7f 2e                	jg     8010f4 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8010c6:	83 ec 04             	sub    $0x4,%esp
  8010c9:	53                   	push   %ebx
  8010ca:	ff 75 0c             	pushl  0xc(%ebp)
  8010cd:	68 0c 60 80 00       	push   $0x80600c
  8010d2:	e8 03 0e 00 00       	call   801eda <memmove>
	nsipcbuf.send.req_size = size;
  8010d7:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8010dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e0:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8010e5:	b8 08 00 00 00       	mov    $0x8,%eax
  8010ea:	e8 c4 fd ff ff       	call   800eb3 <nsipc>
}
  8010ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    
	assert(size < 1600);
  8010f4:	68 88 25 80 00       	push   $0x802588
  8010f9:	68 2f 25 80 00       	push   $0x80252f
  8010fe:	6a 6d                	push   $0x6d
  801100:	68 7c 25 80 00       	push   $0x80257c
  801105:	e8 29 05 00 00       	call   801633 <_panic>

0080110a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80110a:	f3 0f 1e fb          	endbr32 
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80111c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801124:	8b 45 10             	mov    0x10(%ebp),%eax
  801127:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80112c:	b8 09 00 00 00       	mov    $0x9,%eax
  801131:	e8 7d fd ff ff       	call   800eb3 <nsipc>
}
  801136:	c9                   	leave  
  801137:	c3                   	ret    

00801138 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801138:	f3 0f 1e fb          	endbr32 
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	56                   	push   %esi
  801140:	53                   	push   %ebx
  801141:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801144:	83 ec 0c             	sub    $0xc,%esp
  801147:	ff 75 08             	pushl  0x8(%ebp)
  80114a:	e8 f6 f2 ff ff       	call   800445 <fd2data>
  80114f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801151:	83 c4 08             	add    $0x8,%esp
  801154:	68 94 25 80 00       	push   $0x802594
  801159:	53                   	push   %ebx
  80115a:	e8 c5 0b 00 00       	call   801d24 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80115f:	8b 46 04             	mov    0x4(%esi),%eax
  801162:	2b 06                	sub    (%esi),%eax
  801164:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80116a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801171:	00 00 00 
	stat->st_dev = &devpipe;
  801174:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80117b:	30 80 00 
	return 0;
}
  80117e:	b8 00 00 00 00       	mov    $0x0,%eax
  801183:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801186:	5b                   	pop    %ebx
  801187:	5e                   	pop    %esi
  801188:	5d                   	pop    %ebp
  801189:	c3                   	ret    

0080118a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80118a:	f3 0f 1e fb          	endbr32 
  80118e:	55                   	push   %ebp
  80118f:	89 e5                	mov    %esp,%ebp
  801191:	53                   	push   %ebx
  801192:	83 ec 0c             	sub    $0xc,%esp
  801195:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801198:	53                   	push   %ebx
  801199:	6a 00                	push   $0x0
  80119b:	e8 5e f0 ff ff       	call   8001fe <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8011a0:	89 1c 24             	mov    %ebx,(%esp)
  8011a3:	e8 9d f2 ff ff       	call   800445 <fd2data>
  8011a8:	83 c4 08             	add    $0x8,%esp
  8011ab:	50                   	push   %eax
  8011ac:	6a 00                	push   $0x0
  8011ae:	e8 4b f0 ff ff       	call   8001fe <sys_page_unmap>
}
  8011b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b6:	c9                   	leave  
  8011b7:	c3                   	ret    

008011b8 <_pipeisclosed>:
{
  8011b8:	55                   	push   %ebp
  8011b9:	89 e5                	mov    %esp,%ebp
  8011bb:	57                   	push   %edi
  8011bc:	56                   	push   %esi
  8011bd:	53                   	push   %ebx
  8011be:	83 ec 1c             	sub    $0x1c,%esp
  8011c1:	89 c7                	mov    %eax,%edi
  8011c3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8011c5:	a1 08 40 80 00       	mov    0x804008,%eax
  8011ca:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8011cd:	83 ec 0c             	sub    $0xc,%esp
  8011d0:	57                   	push   %edi
  8011d1:	e8 da 0f 00 00       	call   8021b0 <pageref>
  8011d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011d9:	89 34 24             	mov    %esi,(%esp)
  8011dc:	e8 cf 0f 00 00       	call   8021b0 <pageref>
		nn = thisenv->env_runs;
  8011e1:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8011e7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8011ea:	83 c4 10             	add    $0x10,%esp
  8011ed:	39 cb                	cmp    %ecx,%ebx
  8011ef:	74 1b                	je     80120c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8011f1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8011f4:	75 cf                	jne    8011c5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8011f6:	8b 42 58             	mov    0x58(%edx),%eax
  8011f9:	6a 01                	push   $0x1
  8011fb:	50                   	push   %eax
  8011fc:	53                   	push   %ebx
  8011fd:	68 9b 25 80 00       	push   $0x80259b
  801202:	e8 13 05 00 00       	call   80171a <cprintf>
  801207:	83 c4 10             	add    $0x10,%esp
  80120a:	eb b9                	jmp    8011c5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80120c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80120f:	0f 94 c0             	sete   %al
  801212:	0f b6 c0             	movzbl %al,%eax
}
  801215:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801218:	5b                   	pop    %ebx
  801219:	5e                   	pop    %esi
  80121a:	5f                   	pop    %edi
  80121b:	5d                   	pop    %ebp
  80121c:	c3                   	ret    

0080121d <devpipe_write>:
{
  80121d:	f3 0f 1e fb          	endbr32 
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	57                   	push   %edi
  801225:	56                   	push   %esi
  801226:	53                   	push   %ebx
  801227:	83 ec 28             	sub    $0x28,%esp
  80122a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80122d:	56                   	push   %esi
  80122e:	e8 12 f2 ff ff       	call   800445 <fd2data>
  801233:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801235:	83 c4 10             	add    $0x10,%esp
  801238:	bf 00 00 00 00       	mov    $0x0,%edi
  80123d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801240:	74 4f                	je     801291 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801242:	8b 43 04             	mov    0x4(%ebx),%eax
  801245:	8b 0b                	mov    (%ebx),%ecx
  801247:	8d 51 20             	lea    0x20(%ecx),%edx
  80124a:	39 d0                	cmp    %edx,%eax
  80124c:	72 14                	jb     801262 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  80124e:	89 da                	mov    %ebx,%edx
  801250:	89 f0                	mov    %esi,%eax
  801252:	e8 61 ff ff ff       	call   8011b8 <_pipeisclosed>
  801257:	85 c0                	test   %eax,%eax
  801259:	75 3b                	jne    801296 <devpipe_write+0x79>
			sys_yield();
  80125b:	e8 ee ee ff ff       	call   80014e <sys_yield>
  801260:	eb e0                	jmp    801242 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801262:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801265:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801269:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80126c:	89 c2                	mov    %eax,%edx
  80126e:	c1 fa 1f             	sar    $0x1f,%edx
  801271:	89 d1                	mov    %edx,%ecx
  801273:	c1 e9 1b             	shr    $0x1b,%ecx
  801276:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801279:	83 e2 1f             	and    $0x1f,%edx
  80127c:	29 ca                	sub    %ecx,%edx
  80127e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801282:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801286:	83 c0 01             	add    $0x1,%eax
  801289:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80128c:	83 c7 01             	add    $0x1,%edi
  80128f:	eb ac                	jmp    80123d <devpipe_write+0x20>
	return i;
  801291:	8b 45 10             	mov    0x10(%ebp),%eax
  801294:	eb 05                	jmp    80129b <devpipe_write+0x7e>
				return 0;
  801296:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80129b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80129e:	5b                   	pop    %ebx
  80129f:	5e                   	pop    %esi
  8012a0:	5f                   	pop    %edi
  8012a1:	5d                   	pop    %ebp
  8012a2:	c3                   	ret    

008012a3 <devpipe_read>:
{
  8012a3:	f3 0f 1e fb          	endbr32 
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
  8012aa:	57                   	push   %edi
  8012ab:	56                   	push   %esi
  8012ac:	53                   	push   %ebx
  8012ad:	83 ec 18             	sub    $0x18,%esp
  8012b0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8012b3:	57                   	push   %edi
  8012b4:	e8 8c f1 ff ff       	call   800445 <fd2data>
  8012b9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8012bb:	83 c4 10             	add    $0x10,%esp
  8012be:	be 00 00 00 00       	mov    $0x0,%esi
  8012c3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8012c6:	75 14                	jne    8012dc <devpipe_read+0x39>
	return i;
  8012c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cb:	eb 02                	jmp    8012cf <devpipe_read+0x2c>
				return i;
  8012cd:	89 f0                	mov    %esi,%eax
}
  8012cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d2:	5b                   	pop    %ebx
  8012d3:	5e                   	pop    %esi
  8012d4:	5f                   	pop    %edi
  8012d5:	5d                   	pop    %ebp
  8012d6:	c3                   	ret    
			sys_yield();
  8012d7:	e8 72 ee ff ff       	call   80014e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8012dc:	8b 03                	mov    (%ebx),%eax
  8012de:	3b 43 04             	cmp    0x4(%ebx),%eax
  8012e1:	75 18                	jne    8012fb <devpipe_read+0x58>
			if (i > 0)
  8012e3:	85 f6                	test   %esi,%esi
  8012e5:	75 e6                	jne    8012cd <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8012e7:	89 da                	mov    %ebx,%edx
  8012e9:	89 f8                	mov    %edi,%eax
  8012eb:	e8 c8 fe ff ff       	call   8011b8 <_pipeisclosed>
  8012f0:	85 c0                	test   %eax,%eax
  8012f2:	74 e3                	je     8012d7 <devpipe_read+0x34>
				return 0;
  8012f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f9:	eb d4                	jmp    8012cf <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8012fb:	99                   	cltd   
  8012fc:	c1 ea 1b             	shr    $0x1b,%edx
  8012ff:	01 d0                	add    %edx,%eax
  801301:	83 e0 1f             	and    $0x1f,%eax
  801304:	29 d0                	sub    %edx,%eax
  801306:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80130b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80130e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801311:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801314:	83 c6 01             	add    $0x1,%esi
  801317:	eb aa                	jmp    8012c3 <devpipe_read+0x20>

00801319 <pipe>:
{
  801319:	f3 0f 1e fb          	endbr32 
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
  801320:	56                   	push   %esi
  801321:	53                   	push   %ebx
  801322:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801325:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801328:	50                   	push   %eax
  801329:	e8 32 f1 ff ff       	call   800460 <fd_alloc>
  80132e:	89 c3                	mov    %eax,%ebx
  801330:	83 c4 10             	add    $0x10,%esp
  801333:	85 c0                	test   %eax,%eax
  801335:	0f 88 23 01 00 00    	js     80145e <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80133b:	83 ec 04             	sub    $0x4,%esp
  80133e:	68 07 04 00 00       	push   $0x407
  801343:	ff 75 f4             	pushl  -0xc(%ebp)
  801346:	6a 00                	push   $0x0
  801348:	e8 24 ee ff ff       	call   800171 <sys_page_alloc>
  80134d:	89 c3                	mov    %eax,%ebx
  80134f:	83 c4 10             	add    $0x10,%esp
  801352:	85 c0                	test   %eax,%eax
  801354:	0f 88 04 01 00 00    	js     80145e <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80135a:	83 ec 0c             	sub    $0xc,%esp
  80135d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801360:	50                   	push   %eax
  801361:	e8 fa f0 ff ff       	call   800460 <fd_alloc>
  801366:	89 c3                	mov    %eax,%ebx
  801368:	83 c4 10             	add    $0x10,%esp
  80136b:	85 c0                	test   %eax,%eax
  80136d:	0f 88 db 00 00 00    	js     80144e <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801373:	83 ec 04             	sub    $0x4,%esp
  801376:	68 07 04 00 00       	push   $0x407
  80137b:	ff 75 f0             	pushl  -0x10(%ebp)
  80137e:	6a 00                	push   $0x0
  801380:	e8 ec ed ff ff       	call   800171 <sys_page_alloc>
  801385:	89 c3                	mov    %eax,%ebx
  801387:	83 c4 10             	add    $0x10,%esp
  80138a:	85 c0                	test   %eax,%eax
  80138c:	0f 88 bc 00 00 00    	js     80144e <pipe+0x135>
	va = fd2data(fd0);
  801392:	83 ec 0c             	sub    $0xc,%esp
  801395:	ff 75 f4             	pushl  -0xc(%ebp)
  801398:	e8 a8 f0 ff ff       	call   800445 <fd2data>
  80139d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80139f:	83 c4 0c             	add    $0xc,%esp
  8013a2:	68 07 04 00 00       	push   $0x407
  8013a7:	50                   	push   %eax
  8013a8:	6a 00                	push   $0x0
  8013aa:	e8 c2 ed ff ff       	call   800171 <sys_page_alloc>
  8013af:	89 c3                	mov    %eax,%ebx
  8013b1:	83 c4 10             	add    $0x10,%esp
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	0f 88 82 00 00 00    	js     80143e <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8013c2:	e8 7e f0 ff ff       	call   800445 <fd2data>
  8013c7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8013ce:	50                   	push   %eax
  8013cf:	6a 00                	push   $0x0
  8013d1:	56                   	push   %esi
  8013d2:	6a 00                	push   $0x0
  8013d4:	e8 df ed ff ff       	call   8001b8 <sys_page_map>
  8013d9:	89 c3                	mov    %eax,%ebx
  8013db:	83 c4 20             	add    $0x20,%esp
  8013de:	85 c0                	test   %eax,%eax
  8013e0:	78 4e                	js     801430 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8013e2:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8013e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ea:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8013ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ef:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8013f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013f9:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8013fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013fe:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801405:	83 ec 0c             	sub    $0xc,%esp
  801408:	ff 75 f4             	pushl  -0xc(%ebp)
  80140b:	e8 21 f0 ff ff       	call   800431 <fd2num>
  801410:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801413:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801415:	83 c4 04             	add    $0x4,%esp
  801418:	ff 75 f0             	pushl  -0x10(%ebp)
  80141b:	e8 11 f0 ff ff       	call   800431 <fd2num>
  801420:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801423:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801426:	83 c4 10             	add    $0x10,%esp
  801429:	bb 00 00 00 00       	mov    $0x0,%ebx
  80142e:	eb 2e                	jmp    80145e <pipe+0x145>
	sys_page_unmap(0, va);
  801430:	83 ec 08             	sub    $0x8,%esp
  801433:	56                   	push   %esi
  801434:	6a 00                	push   $0x0
  801436:	e8 c3 ed ff ff       	call   8001fe <sys_page_unmap>
  80143b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80143e:	83 ec 08             	sub    $0x8,%esp
  801441:	ff 75 f0             	pushl  -0x10(%ebp)
  801444:	6a 00                	push   $0x0
  801446:	e8 b3 ed ff ff       	call   8001fe <sys_page_unmap>
  80144b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80144e:	83 ec 08             	sub    $0x8,%esp
  801451:	ff 75 f4             	pushl  -0xc(%ebp)
  801454:	6a 00                	push   $0x0
  801456:	e8 a3 ed ff ff       	call   8001fe <sys_page_unmap>
  80145b:	83 c4 10             	add    $0x10,%esp
}
  80145e:	89 d8                	mov    %ebx,%eax
  801460:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801463:	5b                   	pop    %ebx
  801464:	5e                   	pop    %esi
  801465:	5d                   	pop    %ebp
  801466:	c3                   	ret    

00801467 <pipeisclosed>:
{
  801467:	f3 0f 1e fb          	endbr32 
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
  80146e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801471:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801474:	50                   	push   %eax
  801475:	ff 75 08             	pushl  0x8(%ebp)
  801478:	e8 39 f0 ff ff       	call   8004b6 <fd_lookup>
  80147d:	83 c4 10             	add    $0x10,%esp
  801480:	85 c0                	test   %eax,%eax
  801482:	78 18                	js     80149c <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801484:	83 ec 0c             	sub    $0xc,%esp
  801487:	ff 75 f4             	pushl  -0xc(%ebp)
  80148a:	e8 b6 ef ff ff       	call   800445 <fd2data>
  80148f:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801494:	e8 1f fd ff ff       	call   8011b8 <_pipeisclosed>
  801499:	83 c4 10             	add    $0x10,%esp
}
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    

0080149e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80149e:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8014a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a7:	c3                   	ret    

008014a8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8014a8:	f3 0f 1e fb          	endbr32 
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
  8014af:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8014b2:	68 b3 25 80 00       	push   $0x8025b3
  8014b7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ba:	e8 65 08 00 00       	call   801d24 <strcpy>
	return 0;
}
  8014bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c4:	c9                   	leave  
  8014c5:	c3                   	ret    

008014c6 <devcons_write>:
{
  8014c6:	f3 0f 1e fb          	endbr32 
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	57                   	push   %edi
  8014ce:	56                   	push   %esi
  8014cf:	53                   	push   %ebx
  8014d0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8014d6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8014db:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8014e1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8014e4:	73 31                	jae    801517 <devcons_write+0x51>
		m = n - tot;
  8014e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014e9:	29 f3                	sub    %esi,%ebx
  8014eb:	83 fb 7f             	cmp    $0x7f,%ebx
  8014ee:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8014f3:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8014f6:	83 ec 04             	sub    $0x4,%esp
  8014f9:	53                   	push   %ebx
  8014fa:	89 f0                	mov    %esi,%eax
  8014fc:	03 45 0c             	add    0xc(%ebp),%eax
  8014ff:	50                   	push   %eax
  801500:	57                   	push   %edi
  801501:	e8 d4 09 00 00       	call   801eda <memmove>
		sys_cputs(buf, m);
  801506:	83 c4 08             	add    $0x8,%esp
  801509:	53                   	push   %ebx
  80150a:	57                   	push   %edi
  80150b:	e8 91 eb ff ff       	call   8000a1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801510:	01 de                	add    %ebx,%esi
  801512:	83 c4 10             	add    $0x10,%esp
  801515:	eb ca                	jmp    8014e1 <devcons_write+0x1b>
}
  801517:	89 f0                	mov    %esi,%eax
  801519:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80151c:	5b                   	pop    %ebx
  80151d:	5e                   	pop    %esi
  80151e:	5f                   	pop    %edi
  80151f:	5d                   	pop    %ebp
  801520:	c3                   	ret    

00801521 <devcons_read>:
{
  801521:	f3 0f 1e fb          	endbr32 
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	83 ec 08             	sub    $0x8,%esp
  80152b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801530:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801534:	74 21                	je     801557 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801536:	e8 88 eb ff ff       	call   8000c3 <sys_cgetc>
  80153b:	85 c0                	test   %eax,%eax
  80153d:	75 07                	jne    801546 <devcons_read+0x25>
		sys_yield();
  80153f:	e8 0a ec ff ff       	call   80014e <sys_yield>
  801544:	eb f0                	jmp    801536 <devcons_read+0x15>
	if (c < 0)
  801546:	78 0f                	js     801557 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801548:	83 f8 04             	cmp    $0x4,%eax
  80154b:	74 0c                	je     801559 <devcons_read+0x38>
	*(char*)vbuf = c;
  80154d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801550:	88 02                	mov    %al,(%edx)
	return 1;
  801552:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801557:	c9                   	leave  
  801558:	c3                   	ret    
		return 0;
  801559:	b8 00 00 00 00       	mov    $0x0,%eax
  80155e:	eb f7                	jmp    801557 <devcons_read+0x36>

00801560 <cputchar>:
{
  801560:	f3 0f 1e fb          	endbr32 
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801570:	6a 01                	push   $0x1
  801572:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801575:	50                   	push   %eax
  801576:	e8 26 eb ff ff       	call   8000a1 <sys_cputs>
}
  80157b:	83 c4 10             	add    $0x10,%esp
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <getchar>:
{
  801580:	f3 0f 1e fb          	endbr32 
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80158a:	6a 01                	push   $0x1
  80158c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80158f:	50                   	push   %eax
  801590:	6a 00                	push   $0x0
  801592:	e8 a7 f1 ff ff       	call   80073e <read>
	if (r < 0)
  801597:	83 c4 10             	add    $0x10,%esp
  80159a:	85 c0                	test   %eax,%eax
  80159c:	78 06                	js     8015a4 <getchar+0x24>
	if (r < 1)
  80159e:	74 06                	je     8015a6 <getchar+0x26>
	return c;
  8015a0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    
		return -E_EOF;
  8015a6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8015ab:	eb f7                	jmp    8015a4 <getchar+0x24>

008015ad <iscons>:
{
  8015ad:	f3 0f 1e fb          	endbr32 
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ba:	50                   	push   %eax
  8015bb:	ff 75 08             	pushl  0x8(%ebp)
  8015be:	e8 f3 ee ff ff       	call   8004b6 <fd_lookup>
  8015c3:	83 c4 10             	add    $0x10,%esp
  8015c6:	85 c0                	test   %eax,%eax
  8015c8:	78 11                	js     8015db <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8015ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015cd:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8015d3:	39 10                	cmp    %edx,(%eax)
  8015d5:	0f 94 c0             	sete   %al
  8015d8:	0f b6 c0             	movzbl %al,%eax
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <opencons>:
{
  8015dd:	f3 0f 1e fb          	endbr32 
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8015e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ea:	50                   	push   %eax
  8015eb:	e8 70 ee ff ff       	call   800460 <fd_alloc>
  8015f0:	83 c4 10             	add    $0x10,%esp
  8015f3:	85 c0                	test   %eax,%eax
  8015f5:	78 3a                	js     801631 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8015f7:	83 ec 04             	sub    $0x4,%esp
  8015fa:	68 07 04 00 00       	push   $0x407
  8015ff:	ff 75 f4             	pushl  -0xc(%ebp)
  801602:	6a 00                	push   $0x0
  801604:	e8 68 eb ff ff       	call   800171 <sys_page_alloc>
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	85 c0                	test   %eax,%eax
  80160e:	78 21                	js     801631 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801613:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801619:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80161b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801625:	83 ec 0c             	sub    $0xc,%esp
  801628:	50                   	push   %eax
  801629:	e8 03 ee ff ff       	call   800431 <fd2num>
  80162e:	83 c4 10             	add    $0x10,%esp
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801633:	f3 0f 1e fb          	endbr32 
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	56                   	push   %esi
  80163b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80163c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80163f:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801645:	e8 e1 ea ff ff       	call   80012b <sys_getenvid>
  80164a:	83 ec 0c             	sub    $0xc,%esp
  80164d:	ff 75 0c             	pushl  0xc(%ebp)
  801650:	ff 75 08             	pushl  0x8(%ebp)
  801653:	56                   	push   %esi
  801654:	50                   	push   %eax
  801655:	68 c0 25 80 00       	push   $0x8025c0
  80165a:	e8 bb 00 00 00       	call   80171a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80165f:	83 c4 18             	add    $0x18,%esp
  801662:	53                   	push   %ebx
  801663:	ff 75 10             	pushl  0x10(%ebp)
  801666:	e8 5a 00 00 00       	call   8016c5 <vcprintf>
	cprintf("\n");
  80166b:	c7 04 24 f8 28 80 00 	movl   $0x8028f8,(%esp)
  801672:	e8 a3 00 00 00       	call   80171a <cprintf>
  801677:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80167a:	cc                   	int3   
  80167b:	eb fd                	jmp    80167a <_panic+0x47>

0080167d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80167d:	f3 0f 1e fb          	endbr32 
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	53                   	push   %ebx
  801685:	83 ec 04             	sub    $0x4,%esp
  801688:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80168b:	8b 13                	mov    (%ebx),%edx
  80168d:	8d 42 01             	lea    0x1(%edx),%eax
  801690:	89 03                	mov    %eax,(%ebx)
  801692:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801695:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801699:	3d ff 00 00 00       	cmp    $0xff,%eax
  80169e:	74 09                	je     8016a9 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8016a0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8016a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8016a9:	83 ec 08             	sub    $0x8,%esp
  8016ac:	68 ff 00 00 00       	push   $0xff
  8016b1:	8d 43 08             	lea    0x8(%ebx),%eax
  8016b4:	50                   	push   %eax
  8016b5:	e8 e7 e9 ff ff       	call   8000a1 <sys_cputs>
		b->idx = 0;
  8016ba:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8016c0:	83 c4 10             	add    $0x10,%esp
  8016c3:	eb db                	jmp    8016a0 <putch+0x23>

008016c5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8016c5:	f3 0f 1e fb          	endbr32 
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8016d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8016d9:	00 00 00 
	b.cnt = 0;
  8016dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8016e3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8016e6:	ff 75 0c             	pushl  0xc(%ebp)
  8016e9:	ff 75 08             	pushl  0x8(%ebp)
  8016ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8016f2:	50                   	push   %eax
  8016f3:	68 7d 16 80 00       	push   $0x80167d
  8016f8:	e8 20 01 00 00       	call   80181d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8016fd:	83 c4 08             	add    $0x8,%esp
  801700:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801706:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80170c:	50                   	push   %eax
  80170d:	e8 8f e9 ff ff       	call   8000a1 <sys_cputs>

	return b.cnt;
}
  801712:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80171a:	f3 0f 1e fb          	endbr32 
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
  801721:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801724:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801727:	50                   	push   %eax
  801728:	ff 75 08             	pushl  0x8(%ebp)
  80172b:	e8 95 ff ff ff       	call   8016c5 <vcprintf>
	va_end(ap);

	return cnt;
}
  801730:	c9                   	leave  
  801731:	c3                   	ret    

00801732 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
  801735:	57                   	push   %edi
  801736:	56                   	push   %esi
  801737:	53                   	push   %ebx
  801738:	83 ec 1c             	sub    $0x1c,%esp
  80173b:	89 c7                	mov    %eax,%edi
  80173d:	89 d6                	mov    %edx,%esi
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	8b 55 0c             	mov    0xc(%ebp),%edx
  801745:	89 d1                	mov    %edx,%ecx
  801747:	89 c2                	mov    %eax,%edx
  801749:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80174c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80174f:	8b 45 10             	mov    0x10(%ebp),%eax
  801752:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801755:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801758:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80175f:	39 c2                	cmp    %eax,%edx
  801761:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  801764:	72 3e                	jb     8017a4 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801766:	83 ec 0c             	sub    $0xc,%esp
  801769:	ff 75 18             	pushl  0x18(%ebp)
  80176c:	83 eb 01             	sub    $0x1,%ebx
  80176f:	53                   	push   %ebx
  801770:	50                   	push   %eax
  801771:	83 ec 08             	sub    $0x8,%esp
  801774:	ff 75 e4             	pushl  -0x1c(%ebp)
  801777:	ff 75 e0             	pushl  -0x20(%ebp)
  80177a:	ff 75 dc             	pushl  -0x24(%ebp)
  80177d:	ff 75 d8             	pushl  -0x28(%ebp)
  801780:	e8 6b 0a 00 00       	call   8021f0 <__udivdi3>
  801785:	83 c4 18             	add    $0x18,%esp
  801788:	52                   	push   %edx
  801789:	50                   	push   %eax
  80178a:	89 f2                	mov    %esi,%edx
  80178c:	89 f8                	mov    %edi,%eax
  80178e:	e8 9f ff ff ff       	call   801732 <printnum>
  801793:	83 c4 20             	add    $0x20,%esp
  801796:	eb 13                	jmp    8017ab <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801798:	83 ec 08             	sub    $0x8,%esp
  80179b:	56                   	push   %esi
  80179c:	ff 75 18             	pushl  0x18(%ebp)
  80179f:	ff d7                	call   *%edi
  8017a1:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8017a4:	83 eb 01             	sub    $0x1,%ebx
  8017a7:	85 db                	test   %ebx,%ebx
  8017a9:	7f ed                	jg     801798 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8017ab:	83 ec 08             	sub    $0x8,%esp
  8017ae:	56                   	push   %esi
  8017af:	83 ec 04             	sub    $0x4,%esp
  8017b2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017b5:	ff 75 e0             	pushl  -0x20(%ebp)
  8017b8:	ff 75 dc             	pushl  -0x24(%ebp)
  8017bb:	ff 75 d8             	pushl  -0x28(%ebp)
  8017be:	e8 3d 0b 00 00       	call   802300 <__umoddi3>
  8017c3:	83 c4 14             	add    $0x14,%esp
  8017c6:	0f be 80 e3 25 80 00 	movsbl 0x8025e3(%eax),%eax
  8017cd:	50                   	push   %eax
  8017ce:	ff d7                	call   *%edi
}
  8017d0:	83 c4 10             	add    $0x10,%esp
  8017d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017d6:	5b                   	pop    %ebx
  8017d7:	5e                   	pop    %esi
  8017d8:	5f                   	pop    %edi
  8017d9:	5d                   	pop    %ebp
  8017da:	c3                   	ret    

008017db <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8017db:	f3 0f 1e fb          	endbr32 
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
  8017e2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8017e5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8017e9:	8b 10                	mov    (%eax),%edx
  8017eb:	3b 50 04             	cmp    0x4(%eax),%edx
  8017ee:	73 0a                	jae    8017fa <sprintputch+0x1f>
		*b->buf++ = ch;
  8017f0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017f3:	89 08                	mov    %ecx,(%eax)
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	88 02                	mov    %al,(%edx)
}
  8017fa:	5d                   	pop    %ebp
  8017fb:	c3                   	ret    

008017fc <printfmt>:
{
  8017fc:	f3 0f 1e fb          	endbr32 
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801806:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801809:	50                   	push   %eax
  80180a:	ff 75 10             	pushl  0x10(%ebp)
  80180d:	ff 75 0c             	pushl  0xc(%ebp)
  801810:	ff 75 08             	pushl  0x8(%ebp)
  801813:	e8 05 00 00 00       	call   80181d <vprintfmt>
}
  801818:	83 c4 10             	add    $0x10,%esp
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <vprintfmt>:
{
  80181d:	f3 0f 1e fb          	endbr32 
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	57                   	push   %edi
  801825:	56                   	push   %esi
  801826:	53                   	push   %ebx
  801827:	83 ec 3c             	sub    $0x3c,%esp
  80182a:	8b 75 08             	mov    0x8(%ebp),%esi
  80182d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801830:	8b 7d 10             	mov    0x10(%ebp),%edi
  801833:	e9 8e 03 00 00       	jmp    801bc6 <vprintfmt+0x3a9>
		padc = ' ';
  801838:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80183c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801843:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80184a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801851:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801856:	8d 47 01             	lea    0x1(%edi),%eax
  801859:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80185c:	0f b6 17             	movzbl (%edi),%edx
  80185f:	8d 42 dd             	lea    -0x23(%edx),%eax
  801862:	3c 55                	cmp    $0x55,%al
  801864:	0f 87 df 03 00 00    	ja     801c49 <vprintfmt+0x42c>
  80186a:	0f b6 c0             	movzbl %al,%eax
  80186d:	3e ff 24 85 20 27 80 	notrack jmp *0x802720(,%eax,4)
  801874:	00 
  801875:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801878:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80187c:	eb d8                	jmp    801856 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80187e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801881:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801885:	eb cf                	jmp    801856 <vprintfmt+0x39>
  801887:	0f b6 d2             	movzbl %dl,%edx
  80188a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80188d:	b8 00 00 00 00       	mov    $0x0,%eax
  801892:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801895:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801898:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80189c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80189f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8018a2:	83 f9 09             	cmp    $0x9,%ecx
  8018a5:	77 55                	ja     8018fc <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8018a7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8018aa:	eb e9                	jmp    801895 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8018ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8018af:	8b 00                	mov    (%eax),%eax
  8018b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b7:	8d 40 04             	lea    0x4(%eax),%eax
  8018ba:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8018bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8018c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018c4:	79 90                	jns    801856 <vprintfmt+0x39>
				width = precision, precision = -1;
  8018c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8018cc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8018d3:	eb 81                	jmp    801856 <vprintfmt+0x39>
  8018d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	ba 00 00 00 00       	mov    $0x0,%edx
  8018df:	0f 49 d0             	cmovns %eax,%edx
  8018e2:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8018e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8018e8:	e9 69 ff ff ff       	jmp    801856 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8018ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8018f0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8018f7:	e9 5a ff ff ff       	jmp    801856 <vprintfmt+0x39>
  8018fc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8018ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801902:	eb bc                	jmp    8018c0 <vprintfmt+0xa3>
			lflag++;
  801904:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801907:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80190a:	e9 47 ff ff ff       	jmp    801856 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80190f:	8b 45 14             	mov    0x14(%ebp),%eax
  801912:	8d 78 04             	lea    0x4(%eax),%edi
  801915:	83 ec 08             	sub    $0x8,%esp
  801918:	53                   	push   %ebx
  801919:	ff 30                	pushl  (%eax)
  80191b:	ff d6                	call   *%esi
			break;
  80191d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801920:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801923:	e9 9b 02 00 00       	jmp    801bc3 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  801928:	8b 45 14             	mov    0x14(%ebp),%eax
  80192b:	8d 78 04             	lea    0x4(%eax),%edi
  80192e:	8b 00                	mov    (%eax),%eax
  801930:	99                   	cltd   
  801931:	31 d0                	xor    %edx,%eax
  801933:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801935:	83 f8 0f             	cmp    $0xf,%eax
  801938:	7f 23                	jg     80195d <vprintfmt+0x140>
  80193a:	8b 14 85 80 28 80 00 	mov    0x802880(,%eax,4),%edx
  801941:	85 d2                	test   %edx,%edx
  801943:	74 18                	je     80195d <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  801945:	52                   	push   %edx
  801946:	68 41 25 80 00       	push   $0x802541
  80194b:	53                   	push   %ebx
  80194c:	56                   	push   %esi
  80194d:	e8 aa fe ff ff       	call   8017fc <printfmt>
  801952:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801955:	89 7d 14             	mov    %edi,0x14(%ebp)
  801958:	e9 66 02 00 00       	jmp    801bc3 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80195d:	50                   	push   %eax
  80195e:	68 fb 25 80 00       	push   $0x8025fb
  801963:	53                   	push   %ebx
  801964:	56                   	push   %esi
  801965:	e8 92 fe ff ff       	call   8017fc <printfmt>
  80196a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80196d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801970:	e9 4e 02 00 00       	jmp    801bc3 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  801975:	8b 45 14             	mov    0x14(%ebp),%eax
  801978:	83 c0 04             	add    $0x4,%eax
  80197b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80197e:	8b 45 14             	mov    0x14(%ebp),%eax
  801981:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801983:	85 d2                	test   %edx,%edx
  801985:	b8 f4 25 80 00       	mov    $0x8025f4,%eax
  80198a:	0f 45 c2             	cmovne %edx,%eax
  80198d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801990:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801994:	7e 06                	jle    80199c <vprintfmt+0x17f>
  801996:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80199a:	75 0d                	jne    8019a9 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80199c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80199f:	89 c7                	mov    %eax,%edi
  8019a1:	03 45 e0             	add    -0x20(%ebp),%eax
  8019a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019a7:	eb 55                	jmp    8019fe <vprintfmt+0x1e1>
  8019a9:	83 ec 08             	sub    $0x8,%esp
  8019ac:	ff 75 d8             	pushl  -0x28(%ebp)
  8019af:	ff 75 cc             	pushl  -0x34(%ebp)
  8019b2:	e8 46 03 00 00       	call   801cfd <strnlen>
  8019b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019ba:	29 c2                	sub    %eax,%edx
  8019bc:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8019c4:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8019c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8019cb:	85 ff                	test   %edi,%edi
  8019cd:	7e 11                	jle    8019e0 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8019cf:	83 ec 08             	sub    $0x8,%esp
  8019d2:	53                   	push   %ebx
  8019d3:	ff 75 e0             	pushl  -0x20(%ebp)
  8019d6:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8019d8:	83 ef 01             	sub    $0x1,%edi
  8019db:	83 c4 10             	add    $0x10,%esp
  8019de:	eb eb                	jmp    8019cb <vprintfmt+0x1ae>
  8019e0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8019e3:	85 d2                	test   %edx,%edx
  8019e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ea:	0f 49 c2             	cmovns %edx,%eax
  8019ed:	29 c2                	sub    %eax,%edx
  8019ef:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8019f2:	eb a8                	jmp    80199c <vprintfmt+0x17f>
					putch(ch, putdat);
  8019f4:	83 ec 08             	sub    $0x8,%esp
  8019f7:	53                   	push   %ebx
  8019f8:	52                   	push   %edx
  8019f9:	ff d6                	call   *%esi
  8019fb:	83 c4 10             	add    $0x10,%esp
  8019fe:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801a01:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a03:	83 c7 01             	add    $0x1,%edi
  801a06:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a0a:	0f be d0             	movsbl %al,%edx
  801a0d:	85 d2                	test   %edx,%edx
  801a0f:	74 4b                	je     801a5c <vprintfmt+0x23f>
  801a11:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801a15:	78 06                	js     801a1d <vprintfmt+0x200>
  801a17:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801a1b:	78 1e                	js     801a3b <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  801a1d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801a21:	74 d1                	je     8019f4 <vprintfmt+0x1d7>
  801a23:	0f be c0             	movsbl %al,%eax
  801a26:	83 e8 20             	sub    $0x20,%eax
  801a29:	83 f8 5e             	cmp    $0x5e,%eax
  801a2c:	76 c6                	jbe    8019f4 <vprintfmt+0x1d7>
					putch('?', putdat);
  801a2e:	83 ec 08             	sub    $0x8,%esp
  801a31:	53                   	push   %ebx
  801a32:	6a 3f                	push   $0x3f
  801a34:	ff d6                	call   *%esi
  801a36:	83 c4 10             	add    $0x10,%esp
  801a39:	eb c3                	jmp    8019fe <vprintfmt+0x1e1>
  801a3b:	89 cf                	mov    %ecx,%edi
  801a3d:	eb 0e                	jmp    801a4d <vprintfmt+0x230>
				putch(' ', putdat);
  801a3f:	83 ec 08             	sub    $0x8,%esp
  801a42:	53                   	push   %ebx
  801a43:	6a 20                	push   $0x20
  801a45:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801a47:	83 ef 01             	sub    $0x1,%edi
  801a4a:	83 c4 10             	add    $0x10,%esp
  801a4d:	85 ff                	test   %edi,%edi
  801a4f:	7f ee                	jg     801a3f <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  801a51:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a54:	89 45 14             	mov    %eax,0x14(%ebp)
  801a57:	e9 67 01 00 00       	jmp    801bc3 <vprintfmt+0x3a6>
  801a5c:	89 cf                	mov    %ecx,%edi
  801a5e:	eb ed                	jmp    801a4d <vprintfmt+0x230>
	if (lflag >= 2)
  801a60:	83 f9 01             	cmp    $0x1,%ecx
  801a63:	7f 1b                	jg     801a80 <vprintfmt+0x263>
	else if (lflag)
  801a65:	85 c9                	test   %ecx,%ecx
  801a67:	74 63                	je     801acc <vprintfmt+0x2af>
		return va_arg(*ap, long);
  801a69:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6c:	8b 00                	mov    (%eax),%eax
  801a6e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a71:	99                   	cltd   
  801a72:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a75:	8b 45 14             	mov    0x14(%ebp),%eax
  801a78:	8d 40 04             	lea    0x4(%eax),%eax
  801a7b:	89 45 14             	mov    %eax,0x14(%ebp)
  801a7e:	eb 17                	jmp    801a97 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801a80:	8b 45 14             	mov    0x14(%ebp),%eax
  801a83:	8b 50 04             	mov    0x4(%eax),%edx
  801a86:	8b 00                	mov    (%eax),%eax
  801a88:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a8b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a91:	8d 40 08             	lea    0x8(%eax),%eax
  801a94:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801a97:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a9a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801a9d:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801aa2:	85 c9                	test   %ecx,%ecx
  801aa4:	0f 89 ff 00 00 00    	jns    801ba9 <vprintfmt+0x38c>
				putch('-', putdat);
  801aaa:	83 ec 08             	sub    $0x8,%esp
  801aad:	53                   	push   %ebx
  801aae:	6a 2d                	push   $0x2d
  801ab0:	ff d6                	call   *%esi
				num = -(long long) num;
  801ab2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ab5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801ab8:	f7 da                	neg    %edx
  801aba:	83 d1 00             	adc    $0x0,%ecx
  801abd:	f7 d9                	neg    %ecx
  801abf:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801ac2:	b8 0a 00 00 00       	mov    $0xa,%eax
  801ac7:	e9 dd 00 00 00       	jmp    801ba9 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801acc:	8b 45 14             	mov    0x14(%ebp),%eax
  801acf:	8b 00                	mov    (%eax),%eax
  801ad1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ad4:	99                   	cltd   
  801ad5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801ad8:	8b 45 14             	mov    0x14(%ebp),%eax
  801adb:	8d 40 04             	lea    0x4(%eax),%eax
  801ade:	89 45 14             	mov    %eax,0x14(%ebp)
  801ae1:	eb b4                	jmp    801a97 <vprintfmt+0x27a>
	if (lflag >= 2)
  801ae3:	83 f9 01             	cmp    $0x1,%ecx
  801ae6:	7f 1e                	jg     801b06 <vprintfmt+0x2e9>
	else if (lflag)
  801ae8:	85 c9                	test   %ecx,%ecx
  801aea:	74 32                	je     801b1e <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801aec:	8b 45 14             	mov    0x14(%ebp),%eax
  801aef:	8b 10                	mov    (%eax),%edx
  801af1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801af6:	8d 40 04             	lea    0x4(%eax),%eax
  801af9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801afc:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801b01:	e9 a3 00 00 00       	jmp    801ba9 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b06:	8b 45 14             	mov    0x14(%ebp),%eax
  801b09:	8b 10                	mov    (%eax),%edx
  801b0b:	8b 48 04             	mov    0x4(%eax),%ecx
  801b0e:	8d 40 08             	lea    0x8(%eax),%eax
  801b11:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b14:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  801b19:	e9 8b 00 00 00       	jmp    801ba9 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b21:	8b 10                	mov    (%eax),%edx
  801b23:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b28:	8d 40 04             	lea    0x4(%eax),%eax
  801b2b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b2e:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  801b33:	eb 74                	jmp    801ba9 <vprintfmt+0x38c>
	if (lflag >= 2)
  801b35:	83 f9 01             	cmp    $0x1,%ecx
  801b38:	7f 1b                	jg     801b55 <vprintfmt+0x338>
	else if (lflag)
  801b3a:	85 c9                	test   %ecx,%ecx
  801b3c:	74 2c                	je     801b6a <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801b3e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b41:	8b 10                	mov    (%eax),%edx
  801b43:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b48:	8d 40 04             	lea    0x4(%eax),%eax
  801b4b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b4e:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801b53:	eb 54                	jmp    801ba9 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b55:	8b 45 14             	mov    0x14(%ebp),%eax
  801b58:	8b 10                	mov    (%eax),%edx
  801b5a:	8b 48 04             	mov    0x4(%eax),%ecx
  801b5d:	8d 40 08             	lea    0x8(%eax),%eax
  801b60:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b63:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801b68:	eb 3f                	jmp    801ba9 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b6a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6d:	8b 10                	mov    (%eax),%edx
  801b6f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b74:	8d 40 04             	lea    0x4(%eax),%eax
  801b77:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b7a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801b7f:	eb 28                	jmp    801ba9 <vprintfmt+0x38c>
			putch('0', putdat);
  801b81:	83 ec 08             	sub    $0x8,%esp
  801b84:	53                   	push   %ebx
  801b85:	6a 30                	push   $0x30
  801b87:	ff d6                	call   *%esi
			putch('x', putdat);
  801b89:	83 c4 08             	add    $0x8,%esp
  801b8c:	53                   	push   %ebx
  801b8d:	6a 78                	push   $0x78
  801b8f:	ff d6                	call   *%esi
			num = (unsigned long long)
  801b91:	8b 45 14             	mov    0x14(%ebp),%eax
  801b94:	8b 10                	mov    (%eax),%edx
  801b96:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801b9b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801b9e:	8d 40 04             	lea    0x4(%eax),%eax
  801ba1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ba4:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801ba9:	83 ec 0c             	sub    $0xc,%esp
  801bac:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801bb0:	57                   	push   %edi
  801bb1:	ff 75 e0             	pushl  -0x20(%ebp)
  801bb4:	50                   	push   %eax
  801bb5:	51                   	push   %ecx
  801bb6:	52                   	push   %edx
  801bb7:	89 da                	mov    %ebx,%edx
  801bb9:	89 f0                	mov    %esi,%eax
  801bbb:	e8 72 fb ff ff       	call   801732 <printnum>
			break;
  801bc0:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801bc3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801bc6:	83 c7 01             	add    $0x1,%edi
  801bc9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801bcd:	83 f8 25             	cmp    $0x25,%eax
  801bd0:	0f 84 62 fc ff ff    	je     801838 <vprintfmt+0x1b>
			if (ch == '\0')
  801bd6:	85 c0                	test   %eax,%eax
  801bd8:	0f 84 8b 00 00 00    	je     801c69 <vprintfmt+0x44c>
			putch(ch, putdat);
  801bde:	83 ec 08             	sub    $0x8,%esp
  801be1:	53                   	push   %ebx
  801be2:	50                   	push   %eax
  801be3:	ff d6                	call   *%esi
  801be5:	83 c4 10             	add    $0x10,%esp
  801be8:	eb dc                	jmp    801bc6 <vprintfmt+0x3a9>
	if (lflag >= 2)
  801bea:	83 f9 01             	cmp    $0x1,%ecx
  801bed:	7f 1b                	jg     801c0a <vprintfmt+0x3ed>
	else if (lflag)
  801bef:	85 c9                	test   %ecx,%ecx
  801bf1:	74 2c                	je     801c1f <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801bf3:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf6:	8b 10                	mov    (%eax),%edx
  801bf8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bfd:	8d 40 04             	lea    0x4(%eax),%eax
  801c00:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c03:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  801c08:	eb 9f                	jmp    801ba9 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801c0a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c0d:	8b 10                	mov    (%eax),%edx
  801c0f:	8b 48 04             	mov    0x4(%eax),%ecx
  801c12:	8d 40 08             	lea    0x8(%eax),%eax
  801c15:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c18:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  801c1d:	eb 8a                	jmp    801ba9 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801c1f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c22:	8b 10                	mov    (%eax),%edx
  801c24:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c29:	8d 40 04             	lea    0x4(%eax),%eax
  801c2c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c2f:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  801c34:	e9 70 ff ff ff       	jmp    801ba9 <vprintfmt+0x38c>
			putch(ch, putdat);
  801c39:	83 ec 08             	sub    $0x8,%esp
  801c3c:	53                   	push   %ebx
  801c3d:	6a 25                	push   $0x25
  801c3f:	ff d6                	call   *%esi
			break;
  801c41:	83 c4 10             	add    $0x10,%esp
  801c44:	e9 7a ff ff ff       	jmp    801bc3 <vprintfmt+0x3a6>
			putch('%', putdat);
  801c49:	83 ec 08             	sub    $0x8,%esp
  801c4c:	53                   	push   %ebx
  801c4d:	6a 25                	push   $0x25
  801c4f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801c51:	83 c4 10             	add    $0x10,%esp
  801c54:	89 f8                	mov    %edi,%eax
  801c56:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801c5a:	74 05                	je     801c61 <vprintfmt+0x444>
  801c5c:	83 e8 01             	sub    $0x1,%eax
  801c5f:	eb f5                	jmp    801c56 <vprintfmt+0x439>
  801c61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c64:	e9 5a ff ff ff       	jmp    801bc3 <vprintfmt+0x3a6>
}
  801c69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c6c:	5b                   	pop    %ebx
  801c6d:	5e                   	pop    %esi
  801c6e:	5f                   	pop    %edi
  801c6f:	5d                   	pop    %ebp
  801c70:	c3                   	ret    

00801c71 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801c71:	f3 0f 1e fb          	endbr32 
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	83 ec 18             	sub    $0x18,%esp
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801c81:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c84:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801c88:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801c8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801c92:	85 c0                	test   %eax,%eax
  801c94:	74 26                	je     801cbc <vsnprintf+0x4b>
  801c96:	85 d2                	test   %edx,%edx
  801c98:	7e 22                	jle    801cbc <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c9a:	ff 75 14             	pushl  0x14(%ebp)
  801c9d:	ff 75 10             	pushl  0x10(%ebp)
  801ca0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ca3:	50                   	push   %eax
  801ca4:	68 db 17 80 00       	push   $0x8017db
  801ca9:	e8 6f fb ff ff       	call   80181d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801cae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cb1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb7:	83 c4 10             	add    $0x10,%esp
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    
		return -E_INVAL;
  801cbc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cc1:	eb f7                	jmp    801cba <vsnprintf+0x49>

00801cc3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801cc3:	f3 0f 1e fb          	endbr32 
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801ccd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801cd0:	50                   	push   %eax
  801cd1:	ff 75 10             	pushl  0x10(%ebp)
  801cd4:	ff 75 0c             	pushl  0xc(%ebp)
  801cd7:	ff 75 08             	pushl  0x8(%ebp)
  801cda:	e8 92 ff ff ff       	call   801c71 <vsnprintf>
	va_end(ap);

	return rc;
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801ce1:	f3 0f 1e fb          	endbr32 
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801ceb:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801cf4:	74 05                	je     801cfb <strlen+0x1a>
		n++;
  801cf6:	83 c0 01             	add    $0x1,%eax
  801cf9:	eb f5                	jmp    801cf0 <strlen+0xf>
	return n;
}
  801cfb:	5d                   	pop    %ebp
  801cfc:	c3                   	ret    

00801cfd <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801cfd:	f3 0f 1e fb          	endbr32 
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d07:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0f:	39 d0                	cmp    %edx,%eax
  801d11:	74 0d                	je     801d20 <strnlen+0x23>
  801d13:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801d17:	74 05                	je     801d1e <strnlen+0x21>
		n++;
  801d19:	83 c0 01             	add    $0x1,%eax
  801d1c:	eb f1                	jmp    801d0f <strnlen+0x12>
  801d1e:	89 c2                	mov    %eax,%edx
	return n;
}
  801d20:	89 d0                	mov    %edx,%eax
  801d22:	5d                   	pop    %ebp
  801d23:	c3                   	ret    

00801d24 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801d24:	f3 0f 1e fb          	endbr32 
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	53                   	push   %ebx
  801d2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d2f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801d32:	b8 00 00 00 00       	mov    $0x0,%eax
  801d37:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801d3b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801d3e:	83 c0 01             	add    $0x1,%eax
  801d41:	84 d2                	test   %dl,%dl
  801d43:	75 f2                	jne    801d37 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801d45:	89 c8                	mov    %ecx,%eax
  801d47:	5b                   	pop    %ebx
  801d48:	5d                   	pop    %ebp
  801d49:	c3                   	ret    

00801d4a <strcat>:

char *
strcat(char *dst, const char *src)
{
  801d4a:	f3 0f 1e fb          	endbr32 
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	53                   	push   %ebx
  801d52:	83 ec 10             	sub    $0x10,%esp
  801d55:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801d58:	53                   	push   %ebx
  801d59:	e8 83 ff ff ff       	call   801ce1 <strlen>
  801d5e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801d61:	ff 75 0c             	pushl  0xc(%ebp)
  801d64:	01 d8                	add    %ebx,%eax
  801d66:	50                   	push   %eax
  801d67:	e8 b8 ff ff ff       	call   801d24 <strcpy>
	return dst;
}
  801d6c:	89 d8                	mov    %ebx,%eax
  801d6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801d73:	f3 0f 1e fb          	endbr32 
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
  801d7a:	56                   	push   %esi
  801d7b:	53                   	push   %ebx
  801d7c:	8b 75 08             	mov    0x8(%ebp),%esi
  801d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d82:	89 f3                	mov    %esi,%ebx
  801d84:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801d87:	89 f0                	mov    %esi,%eax
  801d89:	39 d8                	cmp    %ebx,%eax
  801d8b:	74 11                	je     801d9e <strncpy+0x2b>
		*dst++ = *src;
  801d8d:	83 c0 01             	add    $0x1,%eax
  801d90:	0f b6 0a             	movzbl (%edx),%ecx
  801d93:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801d96:	80 f9 01             	cmp    $0x1,%cl
  801d99:	83 da ff             	sbb    $0xffffffff,%edx
  801d9c:	eb eb                	jmp    801d89 <strncpy+0x16>
	}
	return ret;
}
  801d9e:	89 f0                	mov    %esi,%eax
  801da0:	5b                   	pop    %ebx
  801da1:	5e                   	pop    %esi
  801da2:	5d                   	pop    %ebp
  801da3:	c3                   	ret    

00801da4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801da4:	f3 0f 1e fb          	endbr32 
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	56                   	push   %esi
  801dac:	53                   	push   %ebx
  801dad:	8b 75 08             	mov    0x8(%ebp),%esi
  801db0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801db3:	8b 55 10             	mov    0x10(%ebp),%edx
  801db6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801db8:	85 d2                	test   %edx,%edx
  801dba:	74 21                	je     801ddd <strlcpy+0x39>
  801dbc:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801dc0:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801dc2:	39 c2                	cmp    %eax,%edx
  801dc4:	74 14                	je     801dda <strlcpy+0x36>
  801dc6:	0f b6 19             	movzbl (%ecx),%ebx
  801dc9:	84 db                	test   %bl,%bl
  801dcb:	74 0b                	je     801dd8 <strlcpy+0x34>
			*dst++ = *src++;
  801dcd:	83 c1 01             	add    $0x1,%ecx
  801dd0:	83 c2 01             	add    $0x1,%edx
  801dd3:	88 5a ff             	mov    %bl,-0x1(%edx)
  801dd6:	eb ea                	jmp    801dc2 <strlcpy+0x1e>
  801dd8:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801dda:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801ddd:	29 f0                	sub    %esi,%eax
}
  801ddf:	5b                   	pop    %ebx
  801de0:	5e                   	pop    %esi
  801de1:	5d                   	pop    %ebp
  801de2:	c3                   	ret    

00801de3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801de3:	f3 0f 1e fb          	endbr32 
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ded:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801df0:	0f b6 01             	movzbl (%ecx),%eax
  801df3:	84 c0                	test   %al,%al
  801df5:	74 0c                	je     801e03 <strcmp+0x20>
  801df7:	3a 02                	cmp    (%edx),%al
  801df9:	75 08                	jne    801e03 <strcmp+0x20>
		p++, q++;
  801dfb:	83 c1 01             	add    $0x1,%ecx
  801dfe:	83 c2 01             	add    $0x1,%edx
  801e01:	eb ed                	jmp    801df0 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e03:	0f b6 c0             	movzbl %al,%eax
  801e06:	0f b6 12             	movzbl (%edx),%edx
  801e09:	29 d0                	sub    %edx,%eax
}
  801e0b:	5d                   	pop    %ebp
  801e0c:	c3                   	ret    

00801e0d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801e0d:	f3 0f 1e fb          	endbr32 
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
  801e14:	53                   	push   %ebx
  801e15:	8b 45 08             	mov    0x8(%ebp),%eax
  801e18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1b:	89 c3                	mov    %eax,%ebx
  801e1d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801e20:	eb 06                	jmp    801e28 <strncmp+0x1b>
		n--, p++, q++;
  801e22:	83 c0 01             	add    $0x1,%eax
  801e25:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801e28:	39 d8                	cmp    %ebx,%eax
  801e2a:	74 16                	je     801e42 <strncmp+0x35>
  801e2c:	0f b6 08             	movzbl (%eax),%ecx
  801e2f:	84 c9                	test   %cl,%cl
  801e31:	74 04                	je     801e37 <strncmp+0x2a>
  801e33:	3a 0a                	cmp    (%edx),%cl
  801e35:	74 eb                	je     801e22 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801e37:	0f b6 00             	movzbl (%eax),%eax
  801e3a:	0f b6 12             	movzbl (%edx),%edx
  801e3d:	29 d0                	sub    %edx,%eax
}
  801e3f:	5b                   	pop    %ebx
  801e40:	5d                   	pop    %ebp
  801e41:	c3                   	ret    
		return 0;
  801e42:	b8 00 00 00 00       	mov    $0x0,%eax
  801e47:	eb f6                	jmp    801e3f <strncmp+0x32>

00801e49 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801e49:	f3 0f 1e fb          	endbr32 
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	8b 45 08             	mov    0x8(%ebp),%eax
  801e53:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e57:	0f b6 10             	movzbl (%eax),%edx
  801e5a:	84 d2                	test   %dl,%dl
  801e5c:	74 09                	je     801e67 <strchr+0x1e>
		if (*s == c)
  801e5e:	38 ca                	cmp    %cl,%dl
  801e60:	74 0a                	je     801e6c <strchr+0x23>
	for (; *s; s++)
  801e62:	83 c0 01             	add    $0x1,%eax
  801e65:	eb f0                	jmp    801e57 <strchr+0xe>
			return (char *) s;
	return 0;
  801e67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6c:	5d                   	pop    %ebp
  801e6d:	c3                   	ret    

00801e6e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801e6e:	f3 0f 1e fb          	endbr32 
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	8b 45 08             	mov    0x8(%ebp),%eax
  801e78:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e7c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801e7f:	38 ca                	cmp    %cl,%dl
  801e81:	74 09                	je     801e8c <strfind+0x1e>
  801e83:	84 d2                	test   %dl,%dl
  801e85:	74 05                	je     801e8c <strfind+0x1e>
	for (; *s; s++)
  801e87:	83 c0 01             	add    $0x1,%eax
  801e8a:	eb f0                	jmp    801e7c <strfind+0xe>
			break;
	return (char *) s;
}
  801e8c:	5d                   	pop    %ebp
  801e8d:	c3                   	ret    

00801e8e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801e8e:	f3 0f 1e fb          	endbr32 
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	57                   	push   %edi
  801e96:	56                   	push   %esi
  801e97:	53                   	push   %ebx
  801e98:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801e9e:	85 c9                	test   %ecx,%ecx
  801ea0:	74 31                	je     801ed3 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801ea2:	89 f8                	mov    %edi,%eax
  801ea4:	09 c8                	or     %ecx,%eax
  801ea6:	a8 03                	test   $0x3,%al
  801ea8:	75 23                	jne    801ecd <memset+0x3f>
		c &= 0xFF;
  801eaa:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801eae:	89 d3                	mov    %edx,%ebx
  801eb0:	c1 e3 08             	shl    $0x8,%ebx
  801eb3:	89 d0                	mov    %edx,%eax
  801eb5:	c1 e0 18             	shl    $0x18,%eax
  801eb8:	89 d6                	mov    %edx,%esi
  801eba:	c1 e6 10             	shl    $0x10,%esi
  801ebd:	09 f0                	or     %esi,%eax
  801ebf:	09 c2                	or     %eax,%edx
  801ec1:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801ec3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801ec6:	89 d0                	mov    %edx,%eax
  801ec8:	fc                   	cld    
  801ec9:	f3 ab                	rep stos %eax,%es:(%edi)
  801ecb:	eb 06                	jmp    801ed3 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed0:	fc                   	cld    
  801ed1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801ed3:	89 f8                	mov    %edi,%eax
  801ed5:	5b                   	pop    %ebx
  801ed6:	5e                   	pop    %esi
  801ed7:	5f                   	pop    %edi
  801ed8:	5d                   	pop    %ebp
  801ed9:	c3                   	ret    

00801eda <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801eda:	f3 0f 1e fb          	endbr32 
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
  801ee1:	57                   	push   %edi
  801ee2:	56                   	push   %esi
  801ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee6:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ee9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801eec:	39 c6                	cmp    %eax,%esi
  801eee:	73 32                	jae    801f22 <memmove+0x48>
  801ef0:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801ef3:	39 c2                	cmp    %eax,%edx
  801ef5:	76 2b                	jbe    801f22 <memmove+0x48>
		s += n;
		d += n;
  801ef7:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801efa:	89 fe                	mov    %edi,%esi
  801efc:	09 ce                	or     %ecx,%esi
  801efe:	09 d6                	or     %edx,%esi
  801f00:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801f06:	75 0e                	jne    801f16 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801f08:	83 ef 04             	sub    $0x4,%edi
  801f0b:	8d 72 fc             	lea    -0x4(%edx),%esi
  801f0e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801f11:	fd                   	std    
  801f12:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801f14:	eb 09                	jmp    801f1f <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801f16:	83 ef 01             	sub    $0x1,%edi
  801f19:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801f1c:	fd                   	std    
  801f1d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801f1f:	fc                   	cld    
  801f20:	eb 1a                	jmp    801f3c <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801f22:	89 c2                	mov    %eax,%edx
  801f24:	09 ca                	or     %ecx,%edx
  801f26:	09 f2                	or     %esi,%edx
  801f28:	f6 c2 03             	test   $0x3,%dl
  801f2b:	75 0a                	jne    801f37 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801f2d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801f30:	89 c7                	mov    %eax,%edi
  801f32:	fc                   	cld    
  801f33:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801f35:	eb 05                	jmp    801f3c <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801f37:	89 c7                	mov    %eax,%edi
  801f39:	fc                   	cld    
  801f3a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801f3c:	5e                   	pop    %esi
  801f3d:	5f                   	pop    %edi
  801f3e:	5d                   	pop    %ebp
  801f3f:	c3                   	ret    

00801f40 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801f40:	f3 0f 1e fb          	endbr32 
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801f4a:	ff 75 10             	pushl  0x10(%ebp)
  801f4d:	ff 75 0c             	pushl  0xc(%ebp)
  801f50:	ff 75 08             	pushl  0x8(%ebp)
  801f53:	e8 82 ff ff ff       	call   801eda <memmove>
}
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    

00801f5a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801f5a:	f3 0f 1e fb          	endbr32 
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	56                   	push   %esi
  801f62:	53                   	push   %ebx
  801f63:	8b 45 08             	mov    0x8(%ebp),%eax
  801f66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f69:	89 c6                	mov    %eax,%esi
  801f6b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801f6e:	39 f0                	cmp    %esi,%eax
  801f70:	74 1c                	je     801f8e <memcmp+0x34>
		if (*s1 != *s2)
  801f72:	0f b6 08             	movzbl (%eax),%ecx
  801f75:	0f b6 1a             	movzbl (%edx),%ebx
  801f78:	38 d9                	cmp    %bl,%cl
  801f7a:	75 08                	jne    801f84 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801f7c:	83 c0 01             	add    $0x1,%eax
  801f7f:	83 c2 01             	add    $0x1,%edx
  801f82:	eb ea                	jmp    801f6e <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801f84:	0f b6 c1             	movzbl %cl,%eax
  801f87:	0f b6 db             	movzbl %bl,%ebx
  801f8a:	29 d8                	sub    %ebx,%eax
  801f8c:	eb 05                	jmp    801f93 <memcmp+0x39>
	}

	return 0;
  801f8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f93:	5b                   	pop    %ebx
  801f94:	5e                   	pop    %esi
  801f95:	5d                   	pop    %ebp
  801f96:	c3                   	ret    

00801f97 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801f97:	f3 0f 1e fb          	endbr32 
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801fa4:	89 c2                	mov    %eax,%edx
  801fa6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801fa9:	39 d0                	cmp    %edx,%eax
  801fab:	73 09                	jae    801fb6 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801fad:	38 08                	cmp    %cl,(%eax)
  801faf:	74 05                	je     801fb6 <memfind+0x1f>
	for (; s < ends; s++)
  801fb1:	83 c0 01             	add    $0x1,%eax
  801fb4:	eb f3                	jmp    801fa9 <memfind+0x12>
			break;
	return (void *) s;
}
  801fb6:	5d                   	pop    %ebp
  801fb7:	c3                   	ret    

00801fb8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801fb8:	f3 0f 1e fb          	endbr32 
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	57                   	push   %edi
  801fc0:	56                   	push   %esi
  801fc1:	53                   	push   %ebx
  801fc2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fc5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801fc8:	eb 03                	jmp    801fcd <strtol+0x15>
		s++;
  801fca:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801fcd:	0f b6 01             	movzbl (%ecx),%eax
  801fd0:	3c 20                	cmp    $0x20,%al
  801fd2:	74 f6                	je     801fca <strtol+0x12>
  801fd4:	3c 09                	cmp    $0x9,%al
  801fd6:	74 f2                	je     801fca <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801fd8:	3c 2b                	cmp    $0x2b,%al
  801fda:	74 2a                	je     802006 <strtol+0x4e>
	int neg = 0;
  801fdc:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801fe1:	3c 2d                	cmp    $0x2d,%al
  801fe3:	74 2b                	je     802010 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801fe5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801feb:	75 0f                	jne    801ffc <strtol+0x44>
  801fed:	80 39 30             	cmpb   $0x30,(%ecx)
  801ff0:	74 28                	je     80201a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801ff2:	85 db                	test   %ebx,%ebx
  801ff4:	b8 0a 00 00 00       	mov    $0xa,%eax
  801ff9:	0f 44 d8             	cmove  %eax,%ebx
  801ffc:	b8 00 00 00 00       	mov    $0x0,%eax
  802001:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802004:	eb 46                	jmp    80204c <strtol+0x94>
		s++;
  802006:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  802009:	bf 00 00 00 00       	mov    $0x0,%edi
  80200e:	eb d5                	jmp    801fe5 <strtol+0x2d>
		s++, neg = 1;
  802010:	83 c1 01             	add    $0x1,%ecx
  802013:	bf 01 00 00 00       	mov    $0x1,%edi
  802018:	eb cb                	jmp    801fe5 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80201a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80201e:	74 0e                	je     80202e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  802020:	85 db                	test   %ebx,%ebx
  802022:	75 d8                	jne    801ffc <strtol+0x44>
		s++, base = 8;
  802024:	83 c1 01             	add    $0x1,%ecx
  802027:	bb 08 00 00 00       	mov    $0x8,%ebx
  80202c:	eb ce                	jmp    801ffc <strtol+0x44>
		s += 2, base = 16;
  80202e:	83 c1 02             	add    $0x2,%ecx
  802031:	bb 10 00 00 00       	mov    $0x10,%ebx
  802036:	eb c4                	jmp    801ffc <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  802038:	0f be d2             	movsbl %dl,%edx
  80203b:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80203e:	3b 55 10             	cmp    0x10(%ebp),%edx
  802041:	7d 3a                	jge    80207d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  802043:	83 c1 01             	add    $0x1,%ecx
  802046:	0f af 45 10          	imul   0x10(%ebp),%eax
  80204a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80204c:	0f b6 11             	movzbl (%ecx),%edx
  80204f:	8d 72 d0             	lea    -0x30(%edx),%esi
  802052:	89 f3                	mov    %esi,%ebx
  802054:	80 fb 09             	cmp    $0x9,%bl
  802057:	76 df                	jbe    802038 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  802059:	8d 72 9f             	lea    -0x61(%edx),%esi
  80205c:	89 f3                	mov    %esi,%ebx
  80205e:	80 fb 19             	cmp    $0x19,%bl
  802061:	77 08                	ja     80206b <strtol+0xb3>
			dig = *s - 'a' + 10;
  802063:	0f be d2             	movsbl %dl,%edx
  802066:	83 ea 57             	sub    $0x57,%edx
  802069:	eb d3                	jmp    80203e <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  80206b:	8d 72 bf             	lea    -0x41(%edx),%esi
  80206e:	89 f3                	mov    %esi,%ebx
  802070:	80 fb 19             	cmp    $0x19,%bl
  802073:	77 08                	ja     80207d <strtol+0xc5>
			dig = *s - 'A' + 10;
  802075:	0f be d2             	movsbl %dl,%edx
  802078:	83 ea 37             	sub    $0x37,%edx
  80207b:	eb c1                	jmp    80203e <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  80207d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802081:	74 05                	je     802088 <strtol+0xd0>
		*endptr = (char *) s;
  802083:	8b 75 0c             	mov    0xc(%ebp),%esi
  802086:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  802088:	89 c2                	mov    %eax,%edx
  80208a:	f7 da                	neg    %edx
  80208c:	85 ff                	test   %edi,%edi
  80208e:	0f 45 c2             	cmovne %edx,%eax
}
  802091:	5b                   	pop    %ebx
  802092:	5e                   	pop    %esi
  802093:	5f                   	pop    %edi
  802094:	5d                   	pop    %ebp
  802095:	c3                   	ret    

00802096 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802096:	f3 0f 1e fb          	endbr32 
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	56                   	push   %esi
  80209e:	53                   	push   %ebx
  80209f:	8b 75 08             	mov    0x8(%ebp),%esi
  8020a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8020a8:	85 c0                	test   %eax,%eax
  8020aa:	74 3d                	je     8020e9 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8020ac:	83 ec 0c             	sub    $0xc,%esp
  8020af:	50                   	push   %eax
  8020b0:	e8 88 e2 ff ff       	call   80033d <sys_ipc_recv>
  8020b5:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8020b8:	85 f6                	test   %esi,%esi
  8020ba:	74 0b                	je     8020c7 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8020bc:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020c2:	8b 52 74             	mov    0x74(%edx),%edx
  8020c5:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8020c7:	85 db                	test   %ebx,%ebx
  8020c9:	74 0b                	je     8020d6 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8020cb:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020d1:	8b 52 78             	mov    0x78(%edx),%edx
  8020d4:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8020d6:	85 c0                	test   %eax,%eax
  8020d8:	78 21                	js     8020fb <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8020da:	a1 08 40 80 00       	mov    0x804008,%eax
  8020df:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e5:	5b                   	pop    %ebx
  8020e6:	5e                   	pop    %esi
  8020e7:	5d                   	pop    %ebp
  8020e8:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8020e9:	83 ec 0c             	sub    $0xc,%esp
  8020ec:	68 00 00 c0 ee       	push   $0xeec00000
  8020f1:	e8 47 e2 ff ff       	call   80033d <sys_ipc_recv>
  8020f6:	83 c4 10             	add    $0x10,%esp
  8020f9:	eb bd                	jmp    8020b8 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  8020fb:	85 f6                	test   %esi,%esi
  8020fd:	74 10                	je     80210f <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  8020ff:	85 db                	test   %ebx,%ebx
  802101:	75 df                	jne    8020e2 <ipc_recv+0x4c>
  802103:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80210a:	00 00 00 
  80210d:	eb d3                	jmp    8020e2 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  80210f:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802116:	00 00 00 
  802119:	eb e4                	jmp    8020ff <ipc_recv+0x69>

0080211b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80211b:	f3 0f 1e fb          	endbr32 
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	57                   	push   %edi
  802123:	56                   	push   %esi
  802124:	53                   	push   %ebx
  802125:	83 ec 0c             	sub    $0xc,%esp
  802128:	8b 7d 08             	mov    0x8(%ebp),%edi
  80212b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80212e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802131:	85 db                	test   %ebx,%ebx
  802133:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802138:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  80213b:	ff 75 14             	pushl  0x14(%ebp)
  80213e:	53                   	push   %ebx
  80213f:	56                   	push   %esi
  802140:	57                   	push   %edi
  802141:	e8 d0 e1 ff ff       	call   800316 <sys_ipc_try_send>
  802146:	83 c4 10             	add    $0x10,%esp
  802149:	85 c0                	test   %eax,%eax
  80214b:	79 1e                	jns    80216b <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  80214d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802150:	75 07                	jne    802159 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802152:	e8 f7 df ff ff       	call   80014e <sys_yield>
  802157:	eb e2                	jmp    80213b <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802159:	50                   	push   %eax
  80215a:	68 df 28 80 00       	push   $0x8028df
  80215f:	6a 59                	push   $0x59
  802161:	68 fa 28 80 00       	push   $0x8028fa
  802166:	e8 c8 f4 ff ff       	call   801633 <_panic>
	}
}
  80216b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80216e:	5b                   	pop    %ebx
  80216f:	5e                   	pop    %esi
  802170:	5f                   	pop    %edi
  802171:	5d                   	pop    %ebp
  802172:	c3                   	ret    

00802173 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802173:	f3 0f 1e fb          	endbr32 
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80217d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802182:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802185:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80218b:	8b 52 50             	mov    0x50(%edx),%edx
  80218e:	39 ca                	cmp    %ecx,%edx
  802190:	74 11                	je     8021a3 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802192:	83 c0 01             	add    $0x1,%eax
  802195:	3d 00 04 00 00       	cmp    $0x400,%eax
  80219a:	75 e6                	jne    802182 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80219c:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a1:	eb 0b                	jmp    8021ae <ipc_find_env+0x3b>
			return envs[i].env_id;
  8021a3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021a6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021ab:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021ae:	5d                   	pop    %ebp
  8021af:	c3                   	ret    

008021b0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021b0:	f3 0f 1e fb          	endbr32 
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021ba:	89 c2                	mov    %eax,%edx
  8021bc:	c1 ea 16             	shr    $0x16,%edx
  8021bf:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8021c6:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021cb:	f6 c1 01             	test   $0x1,%cl
  8021ce:	74 1c                	je     8021ec <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8021d0:	c1 e8 0c             	shr    $0xc,%eax
  8021d3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8021da:	a8 01                	test   $0x1,%al
  8021dc:	74 0e                	je     8021ec <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021de:	c1 e8 0c             	shr    $0xc,%eax
  8021e1:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8021e8:	ef 
  8021e9:	0f b7 d2             	movzwl %dx,%edx
}
  8021ec:	89 d0                	mov    %edx,%eax
  8021ee:	5d                   	pop    %ebp
  8021ef:	c3                   	ret    

008021f0 <__udivdi3>:
  8021f0:	f3 0f 1e fb          	endbr32 
  8021f4:	55                   	push   %ebp
  8021f5:	57                   	push   %edi
  8021f6:	56                   	push   %esi
  8021f7:	53                   	push   %ebx
  8021f8:	83 ec 1c             	sub    $0x1c,%esp
  8021fb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021ff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802203:	8b 74 24 34          	mov    0x34(%esp),%esi
  802207:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80220b:	85 d2                	test   %edx,%edx
  80220d:	75 19                	jne    802228 <__udivdi3+0x38>
  80220f:	39 f3                	cmp    %esi,%ebx
  802211:	76 4d                	jbe    802260 <__udivdi3+0x70>
  802213:	31 ff                	xor    %edi,%edi
  802215:	89 e8                	mov    %ebp,%eax
  802217:	89 f2                	mov    %esi,%edx
  802219:	f7 f3                	div    %ebx
  80221b:	89 fa                	mov    %edi,%edx
  80221d:	83 c4 1c             	add    $0x1c,%esp
  802220:	5b                   	pop    %ebx
  802221:	5e                   	pop    %esi
  802222:	5f                   	pop    %edi
  802223:	5d                   	pop    %ebp
  802224:	c3                   	ret    
  802225:	8d 76 00             	lea    0x0(%esi),%esi
  802228:	39 f2                	cmp    %esi,%edx
  80222a:	76 14                	jbe    802240 <__udivdi3+0x50>
  80222c:	31 ff                	xor    %edi,%edi
  80222e:	31 c0                	xor    %eax,%eax
  802230:	89 fa                	mov    %edi,%edx
  802232:	83 c4 1c             	add    $0x1c,%esp
  802235:	5b                   	pop    %ebx
  802236:	5e                   	pop    %esi
  802237:	5f                   	pop    %edi
  802238:	5d                   	pop    %ebp
  802239:	c3                   	ret    
  80223a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802240:	0f bd fa             	bsr    %edx,%edi
  802243:	83 f7 1f             	xor    $0x1f,%edi
  802246:	75 48                	jne    802290 <__udivdi3+0xa0>
  802248:	39 f2                	cmp    %esi,%edx
  80224a:	72 06                	jb     802252 <__udivdi3+0x62>
  80224c:	31 c0                	xor    %eax,%eax
  80224e:	39 eb                	cmp    %ebp,%ebx
  802250:	77 de                	ja     802230 <__udivdi3+0x40>
  802252:	b8 01 00 00 00       	mov    $0x1,%eax
  802257:	eb d7                	jmp    802230 <__udivdi3+0x40>
  802259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802260:	89 d9                	mov    %ebx,%ecx
  802262:	85 db                	test   %ebx,%ebx
  802264:	75 0b                	jne    802271 <__udivdi3+0x81>
  802266:	b8 01 00 00 00       	mov    $0x1,%eax
  80226b:	31 d2                	xor    %edx,%edx
  80226d:	f7 f3                	div    %ebx
  80226f:	89 c1                	mov    %eax,%ecx
  802271:	31 d2                	xor    %edx,%edx
  802273:	89 f0                	mov    %esi,%eax
  802275:	f7 f1                	div    %ecx
  802277:	89 c6                	mov    %eax,%esi
  802279:	89 e8                	mov    %ebp,%eax
  80227b:	89 f7                	mov    %esi,%edi
  80227d:	f7 f1                	div    %ecx
  80227f:	89 fa                	mov    %edi,%edx
  802281:	83 c4 1c             	add    $0x1c,%esp
  802284:	5b                   	pop    %ebx
  802285:	5e                   	pop    %esi
  802286:	5f                   	pop    %edi
  802287:	5d                   	pop    %ebp
  802288:	c3                   	ret    
  802289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802290:	89 f9                	mov    %edi,%ecx
  802292:	b8 20 00 00 00       	mov    $0x20,%eax
  802297:	29 f8                	sub    %edi,%eax
  802299:	d3 e2                	shl    %cl,%edx
  80229b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80229f:	89 c1                	mov    %eax,%ecx
  8022a1:	89 da                	mov    %ebx,%edx
  8022a3:	d3 ea                	shr    %cl,%edx
  8022a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022a9:	09 d1                	or     %edx,%ecx
  8022ab:	89 f2                	mov    %esi,%edx
  8022ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022b1:	89 f9                	mov    %edi,%ecx
  8022b3:	d3 e3                	shl    %cl,%ebx
  8022b5:	89 c1                	mov    %eax,%ecx
  8022b7:	d3 ea                	shr    %cl,%edx
  8022b9:	89 f9                	mov    %edi,%ecx
  8022bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022bf:	89 eb                	mov    %ebp,%ebx
  8022c1:	d3 e6                	shl    %cl,%esi
  8022c3:	89 c1                	mov    %eax,%ecx
  8022c5:	d3 eb                	shr    %cl,%ebx
  8022c7:	09 de                	or     %ebx,%esi
  8022c9:	89 f0                	mov    %esi,%eax
  8022cb:	f7 74 24 08          	divl   0x8(%esp)
  8022cf:	89 d6                	mov    %edx,%esi
  8022d1:	89 c3                	mov    %eax,%ebx
  8022d3:	f7 64 24 0c          	mull   0xc(%esp)
  8022d7:	39 d6                	cmp    %edx,%esi
  8022d9:	72 15                	jb     8022f0 <__udivdi3+0x100>
  8022db:	89 f9                	mov    %edi,%ecx
  8022dd:	d3 e5                	shl    %cl,%ebp
  8022df:	39 c5                	cmp    %eax,%ebp
  8022e1:	73 04                	jae    8022e7 <__udivdi3+0xf7>
  8022e3:	39 d6                	cmp    %edx,%esi
  8022e5:	74 09                	je     8022f0 <__udivdi3+0x100>
  8022e7:	89 d8                	mov    %ebx,%eax
  8022e9:	31 ff                	xor    %edi,%edi
  8022eb:	e9 40 ff ff ff       	jmp    802230 <__udivdi3+0x40>
  8022f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022f3:	31 ff                	xor    %edi,%edi
  8022f5:	e9 36 ff ff ff       	jmp    802230 <__udivdi3+0x40>
  8022fa:	66 90                	xchg   %ax,%ax
  8022fc:	66 90                	xchg   %ax,%ax
  8022fe:	66 90                	xchg   %ax,%ax

00802300 <__umoddi3>:
  802300:	f3 0f 1e fb          	endbr32 
  802304:	55                   	push   %ebp
  802305:	57                   	push   %edi
  802306:	56                   	push   %esi
  802307:	53                   	push   %ebx
  802308:	83 ec 1c             	sub    $0x1c,%esp
  80230b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80230f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802313:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802317:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80231b:	85 c0                	test   %eax,%eax
  80231d:	75 19                	jne    802338 <__umoddi3+0x38>
  80231f:	39 df                	cmp    %ebx,%edi
  802321:	76 5d                	jbe    802380 <__umoddi3+0x80>
  802323:	89 f0                	mov    %esi,%eax
  802325:	89 da                	mov    %ebx,%edx
  802327:	f7 f7                	div    %edi
  802329:	89 d0                	mov    %edx,%eax
  80232b:	31 d2                	xor    %edx,%edx
  80232d:	83 c4 1c             	add    $0x1c,%esp
  802330:	5b                   	pop    %ebx
  802331:	5e                   	pop    %esi
  802332:	5f                   	pop    %edi
  802333:	5d                   	pop    %ebp
  802334:	c3                   	ret    
  802335:	8d 76 00             	lea    0x0(%esi),%esi
  802338:	89 f2                	mov    %esi,%edx
  80233a:	39 d8                	cmp    %ebx,%eax
  80233c:	76 12                	jbe    802350 <__umoddi3+0x50>
  80233e:	89 f0                	mov    %esi,%eax
  802340:	89 da                	mov    %ebx,%edx
  802342:	83 c4 1c             	add    $0x1c,%esp
  802345:	5b                   	pop    %ebx
  802346:	5e                   	pop    %esi
  802347:	5f                   	pop    %edi
  802348:	5d                   	pop    %ebp
  802349:	c3                   	ret    
  80234a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802350:	0f bd e8             	bsr    %eax,%ebp
  802353:	83 f5 1f             	xor    $0x1f,%ebp
  802356:	75 50                	jne    8023a8 <__umoddi3+0xa8>
  802358:	39 d8                	cmp    %ebx,%eax
  80235a:	0f 82 e0 00 00 00    	jb     802440 <__umoddi3+0x140>
  802360:	89 d9                	mov    %ebx,%ecx
  802362:	39 f7                	cmp    %esi,%edi
  802364:	0f 86 d6 00 00 00    	jbe    802440 <__umoddi3+0x140>
  80236a:	89 d0                	mov    %edx,%eax
  80236c:	89 ca                	mov    %ecx,%edx
  80236e:	83 c4 1c             	add    $0x1c,%esp
  802371:	5b                   	pop    %ebx
  802372:	5e                   	pop    %esi
  802373:	5f                   	pop    %edi
  802374:	5d                   	pop    %ebp
  802375:	c3                   	ret    
  802376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80237d:	8d 76 00             	lea    0x0(%esi),%esi
  802380:	89 fd                	mov    %edi,%ebp
  802382:	85 ff                	test   %edi,%edi
  802384:	75 0b                	jne    802391 <__umoddi3+0x91>
  802386:	b8 01 00 00 00       	mov    $0x1,%eax
  80238b:	31 d2                	xor    %edx,%edx
  80238d:	f7 f7                	div    %edi
  80238f:	89 c5                	mov    %eax,%ebp
  802391:	89 d8                	mov    %ebx,%eax
  802393:	31 d2                	xor    %edx,%edx
  802395:	f7 f5                	div    %ebp
  802397:	89 f0                	mov    %esi,%eax
  802399:	f7 f5                	div    %ebp
  80239b:	89 d0                	mov    %edx,%eax
  80239d:	31 d2                	xor    %edx,%edx
  80239f:	eb 8c                	jmp    80232d <__umoddi3+0x2d>
  8023a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023a8:	89 e9                	mov    %ebp,%ecx
  8023aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8023af:	29 ea                	sub    %ebp,%edx
  8023b1:	d3 e0                	shl    %cl,%eax
  8023b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023b7:	89 d1                	mov    %edx,%ecx
  8023b9:	89 f8                	mov    %edi,%eax
  8023bb:	d3 e8                	shr    %cl,%eax
  8023bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023c9:	09 c1                	or     %eax,%ecx
  8023cb:	89 d8                	mov    %ebx,%eax
  8023cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023d1:	89 e9                	mov    %ebp,%ecx
  8023d3:	d3 e7                	shl    %cl,%edi
  8023d5:	89 d1                	mov    %edx,%ecx
  8023d7:	d3 e8                	shr    %cl,%eax
  8023d9:	89 e9                	mov    %ebp,%ecx
  8023db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023df:	d3 e3                	shl    %cl,%ebx
  8023e1:	89 c7                	mov    %eax,%edi
  8023e3:	89 d1                	mov    %edx,%ecx
  8023e5:	89 f0                	mov    %esi,%eax
  8023e7:	d3 e8                	shr    %cl,%eax
  8023e9:	89 e9                	mov    %ebp,%ecx
  8023eb:	89 fa                	mov    %edi,%edx
  8023ed:	d3 e6                	shl    %cl,%esi
  8023ef:	09 d8                	or     %ebx,%eax
  8023f1:	f7 74 24 08          	divl   0x8(%esp)
  8023f5:	89 d1                	mov    %edx,%ecx
  8023f7:	89 f3                	mov    %esi,%ebx
  8023f9:	f7 64 24 0c          	mull   0xc(%esp)
  8023fd:	89 c6                	mov    %eax,%esi
  8023ff:	89 d7                	mov    %edx,%edi
  802401:	39 d1                	cmp    %edx,%ecx
  802403:	72 06                	jb     80240b <__umoddi3+0x10b>
  802405:	75 10                	jne    802417 <__umoddi3+0x117>
  802407:	39 c3                	cmp    %eax,%ebx
  802409:	73 0c                	jae    802417 <__umoddi3+0x117>
  80240b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80240f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802413:	89 d7                	mov    %edx,%edi
  802415:	89 c6                	mov    %eax,%esi
  802417:	89 ca                	mov    %ecx,%edx
  802419:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80241e:	29 f3                	sub    %esi,%ebx
  802420:	19 fa                	sbb    %edi,%edx
  802422:	89 d0                	mov    %edx,%eax
  802424:	d3 e0                	shl    %cl,%eax
  802426:	89 e9                	mov    %ebp,%ecx
  802428:	d3 eb                	shr    %cl,%ebx
  80242a:	d3 ea                	shr    %cl,%edx
  80242c:	09 d8                	or     %ebx,%eax
  80242e:	83 c4 1c             	add    $0x1c,%esp
  802431:	5b                   	pop    %ebx
  802432:	5e                   	pop    %esi
  802433:	5f                   	pop    %edi
  802434:	5d                   	pop    %ebp
  802435:	c3                   	ret    
  802436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80243d:	8d 76 00             	lea    0x0(%esi),%esi
  802440:	29 fe                	sub    %edi,%esi
  802442:	19 c3                	sbb    %eax,%ebx
  802444:	89 f2                	mov    %esi,%edx
  802446:	89 d9                	mov    %ebx,%ecx
  802448:	e9 1d ff ff ff       	jmp    80236a <__umoddi3+0x6a>
