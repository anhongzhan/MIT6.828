
obj/user/faultbadhandler.debug:     file format elf32-i386


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
  80002c:	e8 38 00 00 00       	call   800069 <libmain>
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
  80003a:	83 ec 0c             	sub    $0xc,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  80003d:	6a 07                	push   $0x7
  80003f:	68 00 f0 bf ee       	push   $0xeebff000
  800044:	6a 00                	push   $0x0
  800046:	e8 56 01 00 00       	call   8001a1 <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xDeadBeef);
  80004b:	83 c4 08             	add    $0x8,%esp
  80004e:	68 ef be ad de       	push   $0xdeadbeef
  800053:	6a 00                	push   $0x0
  800055:	e8 a6 02 00 00       	call   800300 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  80005a:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800061:	00 00 00 
}
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	c9                   	leave  
  800068:	c3                   	ret    

00800069 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800069:	f3 0f 1e fb          	endbr32 
  80006d:	55                   	push   %ebp
  80006e:	89 e5                	mov    %esp,%ebp
  800070:	56                   	push   %esi
  800071:	53                   	push   %ebx
  800072:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800075:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800078:	e8 de 00 00 00       	call   80015b <sys_getenvid>
  80007d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800082:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800085:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80008a:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80008f:	85 db                	test   %ebx,%ebx
  800091:	7e 07                	jle    80009a <libmain+0x31>
		binaryname = argv[0];
  800093:	8b 06                	mov    (%esi),%eax
  800095:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80009a:	83 ec 08             	sub    $0x8,%esp
  80009d:	56                   	push   %esi
  80009e:	53                   	push   %ebx
  80009f:	e8 8f ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000a4:	e8 0a 00 00 00       	call   8000b3 <exit>
}
  8000a9:	83 c4 10             	add    $0x10,%esp
  8000ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000af:	5b                   	pop    %ebx
  8000b0:	5e                   	pop    %esi
  8000b1:	5d                   	pop    %ebp
  8000b2:	c3                   	ret    

008000b3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b3:	f3 0f 1e fb          	endbr32 
  8000b7:	55                   	push   %ebp
  8000b8:	89 e5                	mov    %esp,%ebp
  8000ba:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000bd:	e8 df 04 00 00       	call   8005a1 <close_all>
	sys_env_destroy(0);
  8000c2:	83 ec 0c             	sub    $0xc,%esp
  8000c5:	6a 00                	push   $0x0
  8000c7:	e8 4a 00 00 00       	call   800116 <sys_env_destroy>
}
  8000cc:	83 c4 10             	add    $0x10,%esp
  8000cf:	c9                   	leave  
  8000d0:	c3                   	ret    

008000d1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000d1:	f3 0f 1e fb          	endbr32 
  8000d5:	55                   	push   %ebp
  8000d6:	89 e5                	mov    %esp,%ebp
  8000d8:	57                   	push   %edi
  8000d9:	56                   	push   %esi
  8000da:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000db:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000e6:	89 c3                	mov    %eax,%ebx
  8000e8:	89 c7                	mov    %eax,%edi
  8000ea:	89 c6                	mov    %eax,%esi
  8000ec:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000ee:	5b                   	pop    %ebx
  8000ef:	5e                   	pop    %esi
  8000f0:	5f                   	pop    %edi
  8000f1:	5d                   	pop    %ebp
  8000f2:	c3                   	ret    

008000f3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000f3:	f3 0f 1e fb          	endbr32 
  8000f7:	55                   	push   %ebp
  8000f8:	89 e5                	mov    %esp,%ebp
  8000fa:	57                   	push   %edi
  8000fb:	56                   	push   %esi
  8000fc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800102:	b8 01 00 00 00       	mov    $0x1,%eax
  800107:	89 d1                	mov    %edx,%ecx
  800109:	89 d3                	mov    %edx,%ebx
  80010b:	89 d7                	mov    %edx,%edi
  80010d:	89 d6                	mov    %edx,%esi
  80010f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800111:	5b                   	pop    %ebx
  800112:	5e                   	pop    %esi
  800113:	5f                   	pop    %edi
  800114:	5d                   	pop    %ebp
  800115:	c3                   	ret    

00800116 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800116:	f3 0f 1e fb          	endbr32 
  80011a:	55                   	push   %ebp
  80011b:	89 e5                	mov    %esp,%ebp
  80011d:	57                   	push   %edi
  80011e:	56                   	push   %esi
  80011f:	53                   	push   %ebx
  800120:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800123:	b9 00 00 00 00       	mov    $0x0,%ecx
  800128:	8b 55 08             	mov    0x8(%ebp),%edx
  80012b:	b8 03 00 00 00       	mov    $0x3,%eax
  800130:	89 cb                	mov    %ecx,%ebx
  800132:	89 cf                	mov    %ecx,%edi
  800134:	89 ce                	mov    %ecx,%esi
  800136:	cd 30                	int    $0x30
	if(check && ret > 0)
  800138:	85 c0                	test   %eax,%eax
  80013a:	7f 08                	jg     800144 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80013c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80013f:	5b                   	pop    %ebx
  800140:	5e                   	pop    %esi
  800141:	5f                   	pop    %edi
  800142:	5d                   	pop    %ebp
  800143:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	50                   	push   %eax
  800148:	6a 03                	push   $0x3
  80014a:	68 2a 1f 80 00       	push   $0x801f2a
  80014f:	6a 23                	push   $0x23
  800151:	68 47 1f 80 00       	push   $0x801f47
  800156:	e8 9c 0f 00 00       	call   8010f7 <_panic>

0080015b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80015b:	f3 0f 1e fb          	endbr32 
  80015f:	55                   	push   %ebp
  800160:	89 e5                	mov    %esp,%ebp
  800162:	57                   	push   %edi
  800163:	56                   	push   %esi
  800164:	53                   	push   %ebx
	asm volatile("int %1\n"
  800165:	ba 00 00 00 00       	mov    $0x0,%edx
  80016a:	b8 02 00 00 00       	mov    $0x2,%eax
  80016f:	89 d1                	mov    %edx,%ecx
  800171:	89 d3                	mov    %edx,%ebx
  800173:	89 d7                	mov    %edx,%edi
  800175:	89 d6                	mov    %edx,%esi
  800177:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800179:	5b                   	pop    %ebx
  80017a:	5e                   	pop    %esi
  80017b:	5f                   	pop    %edi
  80017c:	5d                   	pop    %ebp
  80017d:	c3                   	ret    

0080017e <sys_yield>:

void
sys_yield(void)
{
  80017e:	f3 0f 1e fb          	endbr32 
  800182:	55                   	push   %ebp
  800183:	89 e5                	mov    %esp,%ebp
  800185:	57                   	push   %edi
  800186:	56                   	push   %esi
  800187:	53                   	push   %ebx
	asm volatile("int %1\n"
  800188:	ba 00 00 00 00       	mov    $0x0,%edx
  80018d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800192:	89 d1                	mov    %edx,%ecx
  800194:	89 d3                	mov    %edx,%ebx
  800196:	89 d7                	mov    %edx,%edi
  800198:	89 d6                	mov    %edx,%esi
  80019a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80019c:	5b                   	pop    %ebx
  80019d:	5e                   	pop    %esi
  80019e:	5f                   	pop    %edi
  80019f:	5d                   	pop    %ebp
  8001a0:	c3                   	ret    

008001a1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001a1:	f3 0f 1e fb          	endbr32 
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	57                   	push   %edi
  8001a9:	56                   	push   %esi
  8001aa:	53                   	push   %ebx
  8001ab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001ae:	be 00 00 00 00       	mov    $0x0,%esi
  8001b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b9:	b8 04 00 00 00       	mov    $0x4,%eax
  8001be:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001c1:	89 f7                	mov    %esi,%edi
  8001c3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	7f 08                	jg     8001d1 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001cc:	5b                   	pop    %ebx
  8001cd:	5e                   	pop    %esi
  8001ce:	5f                   	pop    %edi
  8001cf:	5d                   	pop    %ebp
  8001d0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d1:	83 ec 0c             	sub    $0xc,%esp
  8001d4:	50                   	push   %eax
  8001d5:	6a 04                	push   $0x4
  8001d7:	68 2a 1f 80 00       	push   $0x801f2a
  8001dc:	6a 23                	push   $0x23
  8001de:	68 47 1f 80 00       	push   $0x801f47
  8001e3:	e8 0f 0f 00 00       	call   8010f7 <_panic>

008001e8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001e8:	f3 0f 1e fb          	endbr32 
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	57                   	push   %edi
  8001f0:	56                   	push   %esi
  8001f1:	53                   	push   %ebx
  8001f2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001fb:	b8 05 00 00 00       	mov    $0x5,%eax
  800200:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800203:	8b 7d 14             	mov    0x14(%ebp),%edi
  800206:	8b 75 18             	mov    0x18(%ebp),%esi
  800209:	cd 30                	int    $0x30
	if(check && ret > 0)
  80020b:	85 c0                	test   %eax,%eax
  80020d:	7f 08                	jg     800217 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80020f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800212:	5b                   	pop    %ebx
  800213:	5e                   	pop    %esi
  800214:	5f                   	pop    %edi
  800215:	5d                   	pop    %ebp
  800216:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	50                   	push   %eax
  80021b:	6a 05                	push   $0x5
  80021d:	68 2a 1f 80 00       	push   $0x801f2a
  800222:	6a 23                	push   $0x23
  800224:	68 47 1f 80 00       	push   $0x801f47
  800229:	e8 c9 0e 00 00       	call   8010f7 <_panic>

0080022e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80022e:	f3 0f 1e fb          	endbr32 
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	57                   	push   %edi
  800236:	56                   	push   %esi
  800237:	53                   	push   %ebx
  800238:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80023b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800240:	8b 55 08             	mov    0x8(%ebp),%edx
  800243:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800246:	b8 06 00 00 00       	mov    $0x6,%eax
  80024b:	89 df                	mov    %ebx,%edi
  80024d:	89 de                	mov    %ebx,%esi
  80024f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800251:	85 c0                	test   %eax,%eax
  800253:	7f 08                	jg     80025d <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800255:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800258:	5b                   	pop    %ebx
  800259:	5e                   	pop    %esi
  80025a:	5f                   	pop    %edi
  80025b:	5d                   	pop    %ebp
  80025c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80025d:	83 ec 0c             	sub    $0xc,%esp
  800260:	50                   	push   %eax
  800261:	6a 06                	push   $0x6
  800263:	68 2a 1f 80 00       	push   $0x801f2a
  800268:	6a 23                	push   $0x23
  80026a:	68 47 1f 80 00       	push   $0x801f47
  80026f:	e8 83 0e 00 00       	call   8010f7 <_panic>

00800274 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800274:	f3 0f 1e fb          	endbr32 
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	57                   	push   %edi
  80027c:	56                   	push   %esi
  80027d:	53                   	push   %ebx
  80027e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800281:	bb 00 00 00 00       	mov    $0x0,%ebx
  800286:	8b 55 08             	mov    0x8(%ebp),%edx
  800289:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80028c:	b8 08 00 00 00       	mov    $0x8,%eax
  800291:	89 df                	mov    %ebx,%edi
  800293:	89 de                	mov    %ebx,%esi
  800295:	cd 30                	int    $0x30
	if(check && ret > 0)
  800297:	85 c0                	test   %eax,%eax
  800299:	7f 08                	jg     8002a3 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80029b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029e:	5b                   	pop    %ebx
  80029f:	5e                   	pop    %esi
  8002a0:	5f                   	pop    %edi
  8002a1:	5d                   	pop    %ebp
  8002a2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002a3:	83 ec 0c             	sub    $0xc,%esp
  8002a6:	50                   	push   %eax
  8002a7:	6a 08                	push   $0x8
  8002a9:	68 2a 1f 80 00       	push   $0x801f2a
  8002ae:	6a 23                	push   $0x23
  8002b0:	68 47 1f 80 00       	push   $0x801f47
  8002b5:	e8 3d 0e 00 00       	call   8010f7 <_panic>

008002ba <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002ba:	f3 0f 1e fb          	endbr32 
  8002be:	55                   	push   %ebp
  8002bf:	89 e5                	mov    %esp,%ebp
  8002c1:	57                   	push   %edi
  8002c2:	56                   	push   %esi
  8002c3:	53                   	push   %ebx
  8002c4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8002cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d2:	b8 09 00 00 00       	mov    $0x9,%eax
  8002d7:	89 df                	mov    %ebx,%edi
  8002d9:	89 de                	mov    %ebx,%esi
  8002db:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002dd:	85 c0                	test   %eax,%eax
  8002df:	7f 08                	jg     8002e9 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e4:	5b                   	pop    %ebx
  8002e5:	5e                   	pop    %esi
  8002e6:	5f                   	pop    %edi
  8002e7:	5d                   	pop    %ebp
  8002e8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002e9:	83 ec 0c             	sub    $0xc,%esp
  8002ec:	50                   	push   %eax
  8002ed:	6a 09                	push   $0x9
  8002ef:	68 2a 1f 80 00       	push   $0x801f2a
  8002f4:	6a 23                	push   $0x23
  8002f6:	68 47 1f 80 00       	push   $0x801f47
  8002fb:	e8 f7 0d 00 00       	call   8010f7 <_panic>

00800300 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800300:	f3 0f 1e fb          	endbr32 
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
  800307:	57                   	push   %edi
  800308:	56                   	push   %esi
  800309:	53                   	push   %ebx
  80030a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80030d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800312:	8b 55 08             	mov    0x8(%ebp),%edx
  800315:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800318:	b8 0a 00 00 00       	mov    $0xa,%eax
  80031d:	89 df                	mov    %ebx,%edi
  80031f:	89 de                	mov    %ebx,%esi
  800321:	cd 30                	int    $0x30
	if(check && ret > 0)
  800323:	85 c0                	test   %eax,%eax
  800325:	7f 08                	jg     80032f <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800327:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032a:	5b                   	pop    %ebx
  80032b:	5e                   	pop    %esi
  80032c:	5f                   	pop    %edi
  80032d:	5d                   	pop    %ebp
  80032e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	50                   	push   %eax
  800333:	6a 0a                	push   $0xa
  800335:	68 2a 1f 80 00       	push   $0x801f2a
  80033a:	6a 23                	push   $0x23
  80033c:	68 47 1f 80 00       	push   $0x801f47
  800341:	e8 b1 0d 00 00       	call   8010f7 <_panic>

00800346 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800346:	f3 0f 1e fb          	endbr32 
  80034a:	55                   	push   %ebp
  80034b:	89 e5                	mov    %esp,%ebp
  80034d:	57                   	push   %edi
  80034e:	56                   	push   %esi
  80034f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800350:	8b 55 08             	mov    0x8(%ebp),%edx
  800353:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800356:	b8 0c 00 00 00       	mov    $0xc,%eax
  80035b:	be 00 00 00 00       	mov    $0x0,%esi
  800360:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800363:	8b 7d 14             	mov    0x14(%ebp),%edi
  800366:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800368:	5b                   	pop    %ebx
  800369:	5e                   	pop    %esi
  80036a:	5f                   	pop    %edi
  80036b:	5d                   	pop    %ebp
  80036c:	c3                   	ret    

0080036d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80036d:	f3 0f 1e fb          	endbr32 
  800371:	55                   	push   %ebp
  800372:	89 e5                	mov    %esp,%ebp
  800374:	57                   	push   %edi
  800375:	56                   	push   %esi
  800376:	53                   	push   %ebx
  800377:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80037a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80037f:	8b 55 08             	mov    0x8(%ebp),%edx
  800382:	b8 0d 00 00 00       	mov    $0xd,%eax
  800387:	89 cb                	mov    %ecx,%ebx
  800389:	89 cf                	mov    %ecx,%edi
  80038b:	89 ce                	mov    %ecx,%esi
  80038d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80038f:	85 c0                	test   %eax,%eax
  800391:	7f 08                	jg     80039b <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800393:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800396:	5b                   	pop    %ebx
  800397:	5e                   	pop    %esi
  800398:	5f                   	pop    %edi
  800399:	5d                   	pop    %ebp
  80039a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80039b:	83 ec 0c             	sub    $0xc,%esp
  80039e:	50                   	push   %eax
  80039f:	6a 0d                	push   $0xd
  8003a1:	68 2a 1f 80 00       	push   $0x801f2a
  8003a6:	6a 23                	push   $0x23
  8003a8:	68 47 1f 80 00       	push   $0x801f47
  8003ad:	e8 45 0d 00 00       	call   8010f7 <_panic>

008003b2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8003b2:	f3 0f 1e fb          	endbr32 
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	05 00 00 00 30       	add    $0x30000000,%eax
  8003c1:	c1 e8 0c             	shr    $0xc,%eax
}
  8003c4:	5d                   	pop    %ebp
  8003c5:	c3                   	ret    

008003c6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8003c6:	f3 0f 1e fb          	endbr32 
  8003ca:	55                   	push   %ebp
  8003cb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003da:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003df:	5d                   	pop    %ebp
  8003e0:	c3                   	ret    

008003e1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003e1:	f3 0f 1e fb          	endbr32 
  8003e5:	55                   	push   %ebp
  8003e6:	89 e5                	mov    %esp,%ebp
  8003e8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003ed:	89 c2                	mov    %eax,%edx
  8003ef:	c1 ea 16             	shr    $0x16,%edx
  8003f2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003f9:	f6 c2 01             	test   $0x1,%dl
  8003fc:	74 2d                	je     80042b <fd_alloc+0x4a>
  8003fe:	89 c2                	mov    %eax,%edx
  800400:	c1 ea 0c             	shr    $0xc,%edx
  800403:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80040a:	f6 c2 01             	test   $0x1,%dl
  80040d:	74 1c                	je     80042b <fd_alloc+0x4a>
  80040f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800414:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800419:	75 d2                	jne    8003ed <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80041b:	8b 45 08             	mov    0x8(%ebp),%eax
  80041e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800424:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800429:	eb 0a                	jmp    800435 <fd_alloc+0x54>
			*fd_store = fd;
  80042b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80042e:	89 01                	mov    %eax,(%ecx)
			return 0;
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800435:	5d                   	pop    %ebp
  800436:	c3                   	ret    

00800437 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800437:	f3 0f 1e fb          	endbr32 
  80043b:	55                   	push   %ebp
  80043c:	89 e5                	mov    %esp,%ebp
  80043e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800441:	83 f8 1f             	cmp    $0x1f,%eax
  800444:	77 30                	ja     800476 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800446:	c1 e0 0c             	shl    $0xc,%eax
  800449:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80044e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800454:	f6 c2 01             	test   $0x1,%dl
  800457:	74 24                	je     80047d <fd_lookup+0x46>
  800459:	89 c2                	mov    %eax,%edx
  80045b:	c1 ea 0c             	shr    $0xc,%edx
  80045e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800465:	f6 c2 01             	test   $0x1,%dl
  800468:	74 1a                	je     800484 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80046a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046d:	89 02                	mov    %eax,(%edx)
	return 0;
  80046f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800474:	5d                   	pop    %ebp
  800475:	c3                   	ret    
		return -E_INVAL;
  800476:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80047b:	eb f7                	jmp    800474 <fd_lookup+0x3d>
		return -E_INVAL;
  80047d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800482:	eb f0                	jmp    800474 <fd_lookup+0x3d>
  800484:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800489:	eb e9                	jmp    800474 <fd_lookup+0x3d>

0080048b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80048b:	f3 0f 1e fb          	endbr32 
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800498:	ba d4 1f 80 00       	mov    $0x801fd4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80049d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8004a2:	39 08                	cmp    %ecx,(%eax)
  8004a4:	74 33                	je     8004d9 <dev_lookup+0x4e>
  8004a6:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8004a9:	8b 02                	mov    (%edx),%eax
  8004ab:	85 c0                	test   %eax,%eax
  8004ad:	75 f3                	jne    8004a2 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8004af:	a1 04 40 80 00       	mov    0x804004,%eax
  8004b4:	8b 40 48             	mov    0x48(%eax),%eax
  8004b7:	83 ec 04             	sub    $0x4,%esp
  8004ba:	51                   	push   %ecx
  8004bb:	50                   	push   %eax
  8004bc:	68 58 1f 80 00       	push   $0x801f58
  8004c1:	e8 18 0d 00 00       	call   8011de <cprintf>
	*dev = 0;
  8004c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004cf:	83 c4 10             	add    $0x10,%esp
  8004d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004d7:	c9                   	leave  
  8004d8:	c3                   	ret    
			*dev = devtab[i];
  8004d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004dc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004de:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e3:	eb f2                	jmp    8004d7 <dev_lookup+0x4c>

008004e5 <fd_close>:
{
  8004e5:	f3 0f 1e fb          	endbr32 
  8004e9:	55                   	push   %ebp
  8004ea:	89 e5                	mov    %esp,%ebp
  8004ec:	57                   	push   %edi
  8004ed:	56                   	push   %esi
  8004ee:	53                   	push   %ebx
  8004ef:	83 ec 24             	sub    $0x24,%esp
  8004f2:	8b 75 08             	mov    0x8(%ebp),%esi
  8004f5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004f8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004fb:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004fc:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800502:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800505:	50                   	push   %eax
  800506:	e8 2c ff ff ff       	call   800437 <fd_lookup>
  80050b:	89 c3                	mov    %eax,%ebx
  80050d:	83 c4 10             	add    $0x10,%esp
  800510:	85 c0                	test   %eax,%eax
  800512:	78 05                	js     800519 <fd_close+0x34>
	    || fd != fd2)
  800514:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800517:	74 16                	je     80052f <fd_close+0x4a>
		return (must_exist ? r : 0);
  800519:	89 f8                	mov    %edi,%eax
  80051b:	84 c0                	test   %al,%al
  80051d:	b8 00 00 00 00       	mov    $0x0,%eax
  800522:	0f 44 d8             	cmove  %eax,%ebx
}
  800525:	89 d8                	mov    %ebx,%eax
  800527:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80052a:	5b                   	pop    %ebx
  80052b:	5e                   	pop    %esi
  80052c:	5f                   	pop    %edi
  80052d:	5d                   	pop    %ebp
  80052e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800535:	50                   	push   %eax
  800536:	ff 36                	pushl  (%esi)
  800538:	e8 4e ff ff ff       	call   80048b <dev_lookup>
  80053d:	89 c3                	mov    %eax,%ebx
  80053f:	83 c4 10             	add    $0x10,%esp
  800542:	85 c0                	test   %eax,%eax
  800544:	78 1a                	js     800560 <fd_close+0x7b>
		if (dev->dev_close)
  800546:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800549:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80054c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800551:	85 c0                	test   %eax,%eax
  800553:	74 0b                	je     800560 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800555:	83 ec 0c             	sub    $0xc,%esp
  800558:	56                   	push   %esi
  800559:	ff d0                	call   *%eax
  80055b:	89 c3                	mov    %eax,%ebx
  80055d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	56                   	push   %esi
  800564:	6a 00                	push   $0x0
  800566:	e8 c3 fc ff ff       	call   80022e <sys_page_unmap>
	return r;
  80056b:	83 c4 10             	add    $0x10,%esp
  80056e:	eb b5                	jmp    800525 <fd_close+0x40>

00800570 <close>:

int
close(int fdnum)
{
  800570:	f3 0f 1e fb          	endbr32 
  800574:	55                   	push   %ebp
  800575:	89 e5                	mov    %esp,%ebp
  800577:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80057a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80057d:	50                   	push   %eax
  80057e:	ff 75 08             	pushl  0x8(%ebp)
  800581:	e8 b1 fe ff ff       	call   800437 <fd_lookup>
  800586:	83 c4 10             	add    $0x10,%esp
  800589:	85 c0                	test   %eax,%eax
  80058b:	79 02                	jns    80058f <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80058d:	c9                   	leave  
  80058e:	c3                   	ret    
		return fd_close(fd, 1);
  80058f:	83 ec 08             	sub    $0x8,%esp
  800592:	6a 01                	push   $0x1
  800594:	ff 75 f4             	pushl  -0xc(%ebp)
  800597:	e8 49 ff ff ff       	call   8004e5 <fd_close>
  80059c:	83 c4 10             	add    $0x10,%esp
  80059f:	eb ec                	jmp    80058d <close+0x1d>

008005a1 <close_all>:

void
close_all(void)
{
  8005a1:	f3 0f 1e fb          	endbr32 
  8005a5:	55                   	push   %ebp
  8005a6:	89 e5                	mov    %esp,%ebp
  8005a8:	53                   	push   %ebx
  8005a9:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8005ac:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8005b1:	83 ec 0c             	sub    $0xc,%esp
  8005b4:	53                   	push   %ebx
  8005b5:	e8 b6 ff ff ff       	call   800570 <close>
	for (i = 0; i < MAXFD; i++)
  8005ba:	83 c3 01             	add    $0x1,%ebx
  8005bd:	83 c4 10             	add    $0x10,%esp
  8005c0:	83 fb 20             	cmp    $0x20,%ebx
  8005c3:	75 ec                	jne    8005b1 <close_all+0x10>
}
  8005c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005c8:	c9                   	leave  
  8005c9:	c3                   	ret    

008005ca <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005ca:	f3 0f 1e fb          	endbr32 
  8005ce:	55                   	push   %ebp
  8005cf:	89 e5                	mov    %esp,%ebp
  8005d1:	57                   	push   %edi
  8005d2:	56                   	push   %esi
  8005d3:	53                   	push   %ebx
  8005d4:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005d7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005da:	50                   	push   %eax
  8005db:	ff 75 08             	pushl  0x8(%ebp)
  8005de:	e8 54 fe ff ff       	call   800437 <fd_lookup>
  8005e3:	89 c3                	mov    %eax,%ebx
  8005e5:	83 c4 10             	add    $0x10,%esp
  8005e8:	85 c0                	test   %eax,%eax
  8005ea:	0f 88 81 00 00 00    	js     800671 <dup+0xa7>
		return r;
	close(newfdnum);
  8005f0:	83 ec 0c             	sub    $0xc,%esp
  8005f3:	ff 75 0c             	pushl  0xc(%ebp)
  8005f6:	e8 75 ff ff ff       	call   800570 <close>

	newfd = INDEX2FD(newfdnum);
  8005fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005fe:	c1 e6 0c             	shl    $0xc,%esi
  800601:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800607:	83 c4 04             	add    $0x4,%esp
  80060a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80060d:	e8 b4 fd ff ff       	call   8003c6 <fd2data>
  800612:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800614:	89 34 24             	mov    %esi,(%esp)
  800617:	e8 aa fd ff ff       	call   8003c6 <fd2data>
  80061c:	83 c4 10             	add    $0x10,%esp
  80061f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800621:	89 d8                	mov    %ebx,%eax
  800623:	c1 e8 16             	shr    $0x16,%eax
  800626:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80062d:	a8 01                	test   $0x1,%al
  80062f:	74 11                	je     800642 <dup+0x78>
  800631:	89 d8                	mov    %ebx,%eax
  800633:	c1 e8 0c             	shr    $0xc,%eax
  800636:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80063d:	f6 c2 01             	test   $0x1,%dl
  800640:	75 39                	jne    80067b <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800642:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800645:	89 d0                	mov    %edx,%eax
  800647:	c1 e8 0c             	shr    $0xc,%eax
  80064a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800651:	83 ec 0c             	sub    $0xc,%esp
  800654:	25 07 0e 00 00       	and    $0xe07,%eax
  800659:	50                   	push   %eax
  80065a:	56                   	push   %esi
  80065b:	6a 00                	push   $0x0
  80065d:	52                   	push   %edx
  80065e:	6a 00                	push   $0x0
  800660:	e8 83 fb ff ff       	call   8001e8 <sys_page_map>
  800665:	89 c3                	mov    %eax,%ebx
  800667:	83 c4 20             	add    $0x20,%esp
  80066a:	85 c0                	test   %eax,%eax
  80066c:	78 31                	js     80069f <dup+0xd5>
		goto err;

	return newfdnum;
  80066e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800671:	89 d8                	mov    %ebx,%eax
  800673:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800676:	5b                   	pop    %ebx
  800677:	5e                   	pop    %esi
  800678:	5f                   	pop    %edi
  800679:	5d                   	pop    %ebp
  80067a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80067b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800682:	83 ec 0c             	sub    $0xc,%esp
  800685:	25 07 0e 00 00       	and    $0xe07,%eax
  80068a:	50                   	push   %eax
  80068b:	57                   	push   %edi
  80068c:	6a 00                	push   $0x0
  80068e:	53                   	push   %ebx
  80068f:	6a 00                	push   $0x0
  800691:	e8 52 fb ff ff       	call   8001e8 <sys_page_map>
  800696:	89 c3                	mov    %eax,%ebx
  800698:	83 c4 20             	add    $0x20,%esp
  80069b:	85 c0                	test   %eax,%eax
  80069d:	79 a3                	jns    800642 <dup+0x78>
	sys_page_unmap(0, newfd);
  80069f:	83 ec 08             	sub    $0x8,%esp
  8006a2:	56                   	push   %esi
  8006a3:	6a 00                	push   $0x0
  8006a5:	e8 84 fb ff ff       	call   80022e <sys_page_unmap>
	sys_page_unmap(0, nva);
  8006aa:	83 c4 08             	add    $0x8,%esp
  8006ad:	57                   	push   %edi
  8006ae:	6a 00                	push   $0x0
  8006b0:	e8 79 fb ff ff       	call   80022e <sys_page_unmap>
	return r;
  8006b5:	83 c4 10             	add    $0x10,%esp
  8006b8:	eb b7                	jmp    800671 <dup+0xa7>

008006ba <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8006ba:	f3 0f 1e fb          	endbr32 
  8006be:	55                   	push   %ebp
  8006bf:	89 e5                	mov    %esp,%ebp
  8006c1:	53                   	push   %ebx
  8006c2:	83 ec 1c             	sub    $0x1c,%esp
  8006c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006cb:	50                   	push   %eax
  8006cc:	53                   	push   %ebx
  8006cd:	e8 65 fd ff ff       	call   800437 <fd_lookup>
  8006d2:	83 c4 10             	add    $0x10,%esp
  8006d5:	85 c0                	test   %eax,%eax
  8006d7:	78 3f                	js     800718 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006df:	50                   	push   %eax
  8006e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e3:	ff 30                	pushl  (%eax)
  8006e5:	e8 a1 fd ff ff       	call   80048b <dev_lookup>
  8006ea:	83 c4 10             	add    $0x10,%esp
  8006ed:	85 c0                	test   %eax,%eax
  8006ef:	78 27                	js     800718 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8006f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006f4:	8b 42 08             	mov    0x8(%edx),%eax
  8006f7:	83 e0 03             	and    $0x3,%eax
  8006fa:	83 f8 01             	cmp    $0x1,%eax
  8006fd:	74 1e                	je     80071d <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800702:	8b 40 08             	mov    0x8(%eax),%eax
  800705:	85 c0                	test   %eax,%eax
  800707:	74 35                	je     80073e <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800709:	83 ec 04             	sub    $0x4,%esp
  80070c:	ff 75 10             	pushl  0x10(%ebp)
  80070f:	ff 75 0c             	pushl  0xc(%ebp)
  800712:	52                   	push   %edx
  800713:	ff d0                	call   *%eax
  800715:	83 c4 10             	add    $0x10,%esp
}
  800718:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80071b:	c9                   	leave  
  80071c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80071d:	a1 04 40 80 00       	mov    0x804004,%eax
  800722:	8b 40 48             	mov    0x48(%eax),%eax
  800725:	83 ec 04             	sub    $0x4,%esp
  800728:	53                   	push   %ebx
  800729:	50                   	push   %eax
  80072a:	68 99 1f 80 00       	push   $0x801f99
  80072f:	e8 aa 0a 00 00       	call   8011de <cprintf>
		return -E_INVAL;
  800734:	83 c4 10             	add    $0x10,%esp
  800737:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80073c:	eb da                	jmp    800718 <read+0x5e>
		return -E_NOT_SUPP;
  80073e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800743:	eb d3                	jmp    800718 <read+0x5e>

00800745 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800745:	f3 0f 1e fb          	endbr32 
  800749:	55                   	push   %ebp
  80074a:	89 e5                	mov    %esp,%ebp
  80074c:	57                   	push   %edi
  80074d:	56                   	push   %esi
  80074e:	53                   	push   %ebx
  80074f:	83 ec 0c             	sub    $0xc,%esp
  800752:	8b 7d 08             	mov    0x8(%ebp),%edi
  800755:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800758:	bb 00 00 00 00       	mov    $0x0,%ebx
  80075d:	eb 02                	jmp    800761 <readn+0x1c>
  80075f:	01 c3                	add    %eax,%ebx
  800761:	39 f3                	cmp    %esi,%ebx
  800763:	73 21                	jae    800786 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800765:	83 ec 04             	sub    $0x4,%esp
  800768:	89 f0                	mov    %esi,%eax
  80076a:	29 d8                	sub    %ebx,%eax
  80076c:	50                   	push   %eax
  80076d:	89 d8                	mov    %ebx,%eax
  80076f:	03 45 0c             	add    0xc(%ebp),%eax
  800772:	50                   	push   %eax
  800773:	57                   	push   %edi
  800774:	e8 41 ff ff ff       	call   8006ba <read>
		if (m < 0)
  800779:	83 c4 10             	add    $0x10,%esp
  80077c:	85 c0                	test   %eax,%eax
  80077e:	78 04                	js     800784 <readn+0x3f>
			return m;
		if (m == 0)
  800780:	75 dd                	jne    80075f <readn+0x1a>
  800782:	eb 02                	jmp    800786 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800784:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800786:	89 d8                	mov    %ebx,%eax
  800788:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80078b:	5b                   	pop    %ebx
  80078c:	5e                   	pop    %esi
  80078d:	5f                   	pop    %edi
  80078e:	5d                   	pop    %ebp
  80078f:	c3                   	ret    

00800790 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800790:	f3 0f 1e fb          	endbr32 
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
  800797:	53                   	push   %ebx
  800798:	83 ec 1c             	sub    $0x1c,%esp
  80079b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80079e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007a1:	50                   	push   %eax
  8007a2:	53                   	push   %ebx
  8007a3:	e8 8f fc ff ff       	call   800437 <fd_lookup>
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	85 c0                	test   %eax,%eax
  8007ad:	78 3a                	js     8007e9 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007b5:	50                   	push   %eax
  8007b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b9:	ff 30                	pushl  (%eax)
  8007bb:	e8 cb fc ff ff       	call   80048b <dev_lookup>
  8007c0:	83 c4 10             	add    $0x10,%esp
  8007c3:	85 c0                	test   %eax,%eax
  8007c5:	78 22                	js     8007e9 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ca:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007ce:	74 1e                	je     8007ee <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d3:	8b 52 0c             	mov    0xc(%edx),%edx
  8007d6:	85 d2                	test   %edx,%edx
  8007d8:	74 35                	je     80080f <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007da:	83 ec 04             	sub    $0x4,%esp
  8007dd:	ff 75 10             	pushl  0x10(%ebp)
  8007e0:	ff 75 0c             	pushl  0xc(%ebp)
  8007e3:	50                   	push   %eax
  8007e4:	ff d2                	call   *%edx
  8007e6:	83 c4 10             	add    $0x10,%esp
}
  8007e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ec:	c9                   	leave  
  8007ed:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007ee:	a1 04 40 80 00       	mov    0x804004,%eax
  8007f3:	8b 40 48             	mov    0x48(%eax),%eax
  8007f6:	83 ec 04             	sub    $0x4,%esp
  8007f9:	53                   	push   %ebx
  8007fa:	50                   	push   %eax
  8007fb:	68 b5 1f 80 00       	push   $0x801fb5
  800800:	e8 d9 09 00 00       	call   8011de <cprintf>
		return -E_INVAL;
  800805:	83 c4 10             	add    $0x10,%esp
  800808:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80080d:	eb da                	jmp    8007e9 <write+0x59>
		return -E_NOT_SUPP;
  80080f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800814:	eb d3                	jmp    8007e9 <write+0x59>

00800816 <seek>:

int
seek(int fdnum, off_t offset)
{
  800816:	f3 0f 1e fb          	endbr32 
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800820:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800823:	50                   	push   %eax
  800824:	ff 75 08             	pushl  0x8(%ebp)
  800827:	e8 0b fc ff ff       	call   800437 <fd_lookup>
  80082c:	83 c4 10             	add    $0x10,%esp
  80082f:	85 c0                	test   %eax,%eax
  800831:	78 0e                	js     800841 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  800833:	8b 55 0c             	mov    0xc(%ebp),%edx
  800836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800839:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80083c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800841:	c9                   	leave  
  800842:	c3                   	ret    

00800843 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800843:	f3 0f 1e fb          	endbr32 
  800847:	55                   	push   %ebp
  800848:	89 e5                	mov    %esp,%ebp
  80084a:	53                   	push   %ebx
  80084b:	83 ec 1c             	sub    $0x1c,%esp
  80084e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800851:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800854:	50                   	push   %eax
  800855:	53                   	push   %ebx
  800856:	e8 dc fb ff ff       	call   800437 <fd_lookup>
  80085b:	83 c4 10             	add    $0x10,%esp
  80085e:	85 c0                	test   %eax,%eax
  800860:	78 37                	js     800899 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800868:	50                   	push   %eax
  800869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086c:	ff 30                	pushl  (%eax)
  80086e:	e8 18 fc ff ff       	call   80048b <dev_lookup>
  800873:	83 c4 10             	add    $0x10,%esp
  800876:	85 c0                	test   %eax,%eax
  800878:	78 1f                	js     800899 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80087a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800881:	74 1b                	je     80089e <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800883:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800886:	8b 52 18             	mov    0x18(%edx),%edx
  800889:	85 d2                	test   %edx,%edx
  80088b:	74 32                	je     8008bf <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80088d:	83 ec 08             	sub    $0x8,%esp
  800890:	ff 75 0c             	pushl  0xc(%ebp)
  800893:	50                   	push   %eax
  800894:	ff d2                	call   *%edx
  800896:	83 c4 10             	add    $0x10,%esp
}
  800899:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089c:	c9                   	leave  
  80089d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80089e:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8008a3:	8b 40 48             	mov    0x48(%eax),%eax
  8008a6:	83 ec 04             	sub    $0x4,%esp
  8008a9:	53                   	push   %ebx
  8008aa:	50                   	push   %eax
  8008ab:	68 78 1f 80 00       	push   $0x801f78
  8008b0:	e8 29 09 00 00       	call   8011de <cprintf>
		return -E_INVAL;
  8008b5:	83 c4 10             	add    $0x10,%esp
  8008b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008bd:	eb da                	jmp    800899 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8008bf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008c4:	eb d3                	jmp    800899 <ftruncate+0x56>

008008c6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008c6:	f3 0f 1e fb          	endbr32 
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
  8008cd:	53                   	push   %ebx
  8008ce:	83 ec 1c             	sub    $0x1c,%esp
  8008d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008d7:	50                   	push   %eax
  8008d8:	ff 75 08             	pushl  0x8(%ebp)
  8008db:	e8 57 fb ff ff       	call   800437 <fd_lookup>
  8008e0:	83 c4 10             	add    $0x10,%esp
  8008e3:	85 c0                	test   %eax,%eax
  8008e5:	78 4b                	js     800932 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008ed:	50                   	push   %eax
  8008ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f1:	ff 30                	pushl  (%eax)
  8008f3:	e8 93 fb ff ff       	call   80048b <dev_lookup>
  8008f8:	83 c4 10             	add    $0x10,%esp
  8008fb:	85 c0                	test   %eax,%eax
  8008fd:	78 33                	js     800932 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8008ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800902:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800906:	74 2f                	je     800937 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800908:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80090b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800912:	00 00 00 
	stat->st_isdir = 0;
  800915:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80091c:	00 00 00 
	stat->st_dev = dev;
  80091f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800925:	83 ec 08             	sub    $0x8,%esp
  800928:	53                   	push   %ebx
  800929:	ff 75 f0             	pushl  -0x10(%ebp)
  80092c:	ff 50 14             	call   *0x14(%eax)
  80092f:	83 c4 10             	add    $0x10,%esp
}
  800932:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800935:	c9                   	leave  
  800936:	c3                   	ret    
		return -E_NOT_SUPP;
  800937:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80093c:	eb f4                	jmp    800932 <fstat+0x6c>

0080093e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80093e:	f3 0f 1e fb          	endbr32 
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	56                   	push   %esi
  800946:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	6a 00                	push   $0x0
  80094c:	ff 75 08             	pushl  0x8(%ebp)
  80094f:	e8 fb 01 00 00       	call   800b4f <open>
  800954:	89 c3                	mov    %eax,%ebx
  800956:	83 c4 10             	add    $0x10,%esp
  800959:	85 c0                	test   %eax,%eax
  80095b:	78 1b                	js     800978 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	ff 75 0c             	pushl  0xc(%ebp)
  800963:	50                   	push   %eax
  800964:	e8 5d ff ff ff       	call   8008c6 <fstat>
  800969:	89 c6                	mov    %eax,%esi
	close(fd);
  80096b:	89 1c 24             	mov    %ebx,(%esp)
  80096e:	e8 fd fb ff ff       	call   800570 <close>
	return r;
  800973:	83 c4 10             	add    $0x10,%esp
  800976:	89 f3                	mov    %esi,%ebx
}
  800978:	89 d8                	mov    %ebx,%eax
  80097a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80097d:	5b                   	pop    %ebx
  80097e:	5e                   	pop    %esi
  80097f:	5d                   	pop    %ebp
  800980:	c3                   	ret    

00800981 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	56                   	push   %esi
  800985:	53                   	push   %ebx
  800986:	89 c6                	mov    %eax,%esi
  800988:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80098a:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800991:	74 27                	je     8009ba <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800993:	6a 07                	push   $0x7
  800995:	68 00 50 80 00       	push   $0x805000
  80099a:	56                   	push   %esi
  80099b:	ff 35 00 40 80 00    	pushl  0x804000
  8009a1:	e8 39 12 00 00       	call   801bdf <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8009a6:	83 c4 0c             	add    $0xc,%esp
  8009a9:	6a 00                	push   $0x0
  8009ab:	53                   	push   %ebx
  8009ac:	6a 00                	push   $0x0
  8009ae:	e8 a7 11 00 00       	call   801b5a <ipc_recv>
}
  8009b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009b6:	5b                   	pop    %ebx
  8009b7:	5e                   	pop    %esi
  8009b8:	5d                   	pop    %ebp
  8009b9:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009ba:	83 ec 0c             	sub    $0xc,%esp
  8009bd:	6a 01                	push   $0x1
  8009bf:	e8 73 12 00 00       	call   801c37 <ipc_find_env>
  8009c4:	a3 00 40 80 00       	mov    %eax,0x804000
  8009c9:	83 c4 10             	add    $0x10,%esp
  8009cc:	eb c5                	jmp    800993 <fsipc+0x12>

008009ce <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009ce:	f3 0f 1e fb          	endbr32 
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	8b 40 0c             	mov    0xc(%eax),%eax
  8009de:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e6:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f0:	b8 02 00 00 00       	mov    $0x2,%eax
  8009f5:	e8 87 ff ff ff       	call   800981 <fsipc>
}
  8009fa:	c9                   	leave  
  8009fb:	c3                   	ret    

008009fc <devfile_flush>:
{
  8009fc:	f3 0f 1e fb          	endbr32 
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	8b 40 0c             	mov    0xc(%eax),%eax
  800a0c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a11:	ba 00 00 00 00       	mov    $0x0,%edx
  800a16:	b8 06 00 00 00       	mov    $0x6,%eax
  800a1b:	e8 61 ff ff ff       	call   800981 <fsipc>
}
  800a20:	c9                   	leave  
  800a21:	c3                   	ret    

00800a22 <devfile_stat>:
{
  800a22:	f3 0f 1e fb          	endbr32 
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	53                   	push   %ebx
  800a2a:	83 ec 04             	sub    $0x4,%esp
  800a2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	8b 40 0c             	mov    0xc(%eax),%eax
  800a36:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a40:	b8 05 00 00 00       	mov    $0x5,%eax
  800a45:	e8 37 ff ff ff       	call   800981 <fsipc>
  800a4a:	85 c0                	test   %eax,%eax
  800a4c:	78 2c                	js     800a7a <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	68 00 50 80 00       	push   $0x805000
  800a56:	53                   	push   %ebx
  800a57:	e8 8c 0d 00 00       	call   8017e8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a5c:	a1 80 50 80 00       	mov    0x805080,%eax
  800a61:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800a67:	a1 84 50 80 00       	mov    0x805084,%eax
  800a6c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a72:	83 c4 10             	add    $0x10,%esp
  800a75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a7d:	c9                   	leave  
  800a7e:	c3                   	ret    

00800a7f <devfile_write>:
{
  800a7f:	f3 0f 1e fb          	endbr32 
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
  800a86:	83 ec 0c             	sub    $0xc,%esp
  800a89:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a8f:	8b 52 0c             	mov    0xc(%edx),%edx
  800a92:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  800a98:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800a9d:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800aa2:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  800aa5:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800aaa:	50                   	push   %eax
  800aab:	ff 75 0c             	pushl  0xc(%ebp)
  800aae:	68 08 50 80 00       	push   $0x805008
  800ab3:	e8 e6 0e 00 00       	call   80199e <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800ab8:	ba 00 00 00 00       	mov    $0x0,%edx
  800abd:	b8 04 00 00 00       	mov    $0x4,%eax
  800ac2:	e8 ba fe ff ff       	call   800981 <fsipc>
}
  800ac7:	c9                   	leave  
  800ac8:	c3                   	ret    

00800ac9 <devfile_read>:
{
  800ac9:	f3 0f 1e fb          	endbr32 
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	56                   	push   %esi
  800ad1:	53                   	push   %ebx
  800ad2:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	8b 40 0c             	mov    0xc(%eax),%eax
  800adb:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800ae0:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800ae6:	ba 00 00 00 00       	mov    $0x0,%edx
  800aeb:	b8 03 00 00 00       	mov    $0x3,%eax
  800af0:	e8 8c fe ff ff       	call   800981 <fsipc>
  800af5:	89 c3                	mov    %eax,%ebx
  800af7:	85 c0                	test   %eax,%eax
  800af9:	78 1f                	js     800b1a <devfile_read+0x51>
	assert(r <= n);
  800afb:	39 f0                	cmp    %esi,%eax
  800afd:	77 24                	ja     800b23 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800aff:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b04:	7f 33                	jg     800b39 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b06:	83 ec 04             	sub    $0x4,%esp
  800b09:	50                   	push   %eax
  800b0a:	68 00 50 80 00       	push   $0x805000
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	e8 87 0e 00 00       	call   80199e <memmove>
	return r;
  800b17:	83 c4 10             	add    $0x10,%esp
}
  800b1a:	89 d8                	mov    %ebx,%eax
  800b1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b1f:	5b                   	pop    %ebx
  800b20:	5e                   	pop    %esi
  800b21:	5d                   	pop    %ebp
  800b22:	c3                   	ret    
	assert(r <= n);
  800b23:	68 e4 1f 80 00       	push   $0x801fe4
  800b28:	68 eb 1f 80 00       	push   $0x801feb
  800b2d:	6a 7c                	push   $0x7c
  800b2f:	68 00 20 80 00       	push   $0x802000
  800b34:	e8 be 05 00 00       	call   8010f7 <_panic>
	assert(r <= PGSIZE);
  800b39:	68 0b 20 80 00       	push   $0x80200b
  800b3e:	68 eb 1f 80 00       	push   $0x801feb
  800b43:	6a 7d                	push   $0x7d
  800b45:	68 00 20 80 00       	push   $0x802000
  800b4a:	e8 a8 05 00 00       	call   8010f7 <_panic>

00800b4f <open>:
{
  800b4f:	f3 0f 1e fb          	endbr32 
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	56                   	push   %esi
  800b57:	53                   	push   %ebx
  800b58:	83 ec 1c             	sub    $0x1c,%esp
  800b5b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b5e:	56                   	push   %esi
  800b5f:	e8 41 0c 00 00       	call   8017a5 <strlen>
  800b64:	83 c4 10             	add    $0x10,%esp
  800b67:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b6c:	7f 6c                	jg     800bda <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b6e:	83 ec 0c             	sub    $0xc,%esp
  800b71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b74:	50                   	push   %eax
  800b75:	e8 67 f8 ff ff       	call   8003e1 <fd_alloc>
  800b7a:	89 c3                	mov    %eax,%ebx
  800b7c:	83 c4 10             	add    $0x10,%esp
  800b7f:	85 c0                	test   %eax,%eax
  800b81:	78 3c                	js     800bbf <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b83:	83 ec 08             	sub    $0x8,%esp
  800b86:	56                   	push   %esi
  800b87:	68 00 50 80 00       	push   $0x805000
  800b8c:	e8 57 0c 00 00       	call   8017e8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b9c:	b8 01 00 00 00       	mov    $0x1,%eax
  800ba1:	e8 db fd ff ff       	call   800981 <fsipc>
  800ba6:	89 c3                	mov    %eax,%ebx
  800ba8:	83 c4 10             	add    $0x10,%esp
  800bab:	85 c0                	test   %eax,%eax
  800bad:	78 19                	js     800bc8 <open+0x79>
	return fd2num(fd);
  800baf:	83 ec 0c             	sub    $0xc,%esp
  800bb2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb5:	e8 f8 f7 ff ff       	call   8003b2 <fd2num>
  800bba:	89 c3                	mov    %eax,%ebx
  800bbc:	83 c4 10             	add    $0x10,%esp
}
  800bbf:	89 d8                	mov    %ebx,%eax
  800bc1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bc4:	5b                   	pop    %ebx
  800bc5:	5e                   	pop    %esi
  800bc6:	5d                   	pop    %ebp
  800bc7:	c3                   	ret    
		fd_close(fd, 0);
  800bc8:	83 ec 08             	sub    $0x8,%esp
  800bcb:	6a 00                	push   $0x0
  800bcd:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd0:	e8 10 f9 ff ff       	call   8004e5 <fd_close>
		return r;
  800bd5:	83 c4 10             	add    $0x10,%esp
  800bd8:	eb e5                	jmp    800bbf <open+0x70>
		return -E_BAD_PATH;
  800bda:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800bdf:	eb de                	jmp    800bbf <open+0x70>

00800be1 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800be1:	f3 0f 1e fb          	endbr32 
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800beb:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf0:	b8 08 00 00 00       	mov    $0x8,%eax
  800bf5:	e8 87 fd ff ff       	call   800981 <fsipc>
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800bfc:	f3 0f 1e fb          	endbr32 
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	56                   	push   %esi
  800c04:	53                   	push   %ebx
  800c05:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800c08:	83 ec 0c             	sub    $0xc,%esp
  800c0b:	ff 75 08             	pushl  0x8(%ebp)
  800c0e:	e8 b3 f7 ff ff       	call   8003c6 <fd2data>
  800c13:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800c15:	83 c4 08             	add    $0x8,%esp
  800c18:	68 17 20 80 00       	push   $0x802017
  800c1d:	53                   	push   %ebx
  800c1e:	e8 c5 0b 00 00       	call   8017e8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800c23:	8b 46 04             	mov    0x4(%esi),%eax
  800c26:	2b 06                	sub    (%esi),%eax
  800c28:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800c2e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800c35:	00 00 00 
	stat->st_dev = &devpipe;
  800c38:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c3f:	30 80 00 
	return 0;
}
  800c42:	b8 00 00 00 00       	mov    $0x0,%eax
  800c47:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c4a:	5b                   	pop    %ebx
  800c4b:	5e                   	pop    %esi
  800c4c:	5d                   	pop    %ebp
  800c4d:	c3                   	ret    

00800c4e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c4e:	f3 0f 1e fb          	endbr32 
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	53                   	push   %ebx
  800c56:	83 ec 0c             	sub    $0xc,%esp
  800c59:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c5c:	53                   	push   %ebx
  800c5d:	6a 00                	push   $0x0
  800c5f:	e8 ca f5 ff ff       	call   80022e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c64:	89 1c 24             	mov    %ebx,(%esp)
  800c67:	e8 5a f7 ff ff       	call   8003c6 <fd2data>
  800c6c:	83 c4 08             	add    $0x8,%esp
  800c6f:	50                   	push   %eax
  800c70:	6a 00                	push   $0x0
  800c72:	e8 b7 f5 ff ff       	call   80022e <sys_page_unmap>
}
  800c77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c7a:	c9                   	leave  
  800c7b:	c3                   	ret    

00800c7c <_pipeisclosed>:
{
  800c7c:	55                   	push   %ebp
  800c7d:	89 e5                	mov    %esp,%ebp
  800c7f:	57                   	push   %edi
  800c80:	56                   	push   %esi
  800c81:	53                   	push   %ebx
  800c82:	83 ec 1c             	sub    $0x1c,%esp
  800c85:	89 c7                	mov    %eax,%edi
  800c87:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c89:	a1 04 40 80 00       	mov    0x804004,%eax
  800c8e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c91:	83 ec 0c             	sub    $0xc,%esp
  800c94:	57                   	push   %edi
  800c95:	e8 da 0f 00 00       	call   801c74 <pageref>
  800c9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c9d:	89 34 24             	mov    %esi,(%esp)
  800ca0:	e8 cf 0f 00 00       	call   801c74 <pageref>
		nn = thisenv->env_runs;
  800ca5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800cab:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800cae:	83 c4 10             	add    $0x10,%esp
  800cb1:	39 cb                	cmp    %ecx,%ebx
  800cb3:	74 1b                	je     800cd0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800cb5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800cb8:	75 cf                	jne    800c89 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800cba:	8b 42 58             	mov    0x58(%edx),%eax
  800cbd:	6a 01                	push   $0x1
  800cbf:	50                   	push   %eax
  800cc0:	53                   	push   %ebx
  800cc1:	68 1e 20 80 00       	push   $0x80201e
  800cc6:	e8 13 05 00 00       	call   8011de <cprintf>
  800ccb:	83 c4 10             	add    $0x10,%esp
  800cce:	eb b9                	jmp    800c89 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800cd0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800cd3:	0f 94 c0             	sete   %al
  800cd6:	0f b6 c0             	movzbl %al,%eax
}
  800cd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cdc:	5b                   	pop    %ebx
  800cdd:	5e                   	pop    %esi
  800cde:	5f                   	pop    %edi
  800cdf:	5d                   	pop    %ebp
  800ce0:	c3                   	ret    

00800ce1 <devpipe_write>:
{
  800ce1:	f3 0f 1e fb          	endbr32 
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	57                   	push   %edi
  800ce9:	56                   	push   %esi
  800cea:	53                   	push   %ebx
  800ceb:	83 ec 28             	sub    $0x28,%esp
  800cee:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800cf1:	56                   	push   %esi
  800cf2:	e8 cf f6 ff ff       	call   8003c6 <fd2data>
  800cf7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800cf9:	83 c4 10             	add    $0x10,%esp
  800cfc:	bf 00 00 00 00       	mov    $0x0,%edi
  800d01:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800d04:	74 4f                	je     800d55 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800d06:	8b 43 04             	mov    0x4(%ebx),%eax
  800d09:	8b 0b                	mov    (%ebx),%ecx
  800d0b:	8d 51 20             	lea    0x20(%ecx),%edx
  800d0e:	39 d0                	cmp    %edx,%eax
  800d10:	72 14                	jb     800d26 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  800d12:	89 da                	mov    %ebx,%edx
  800d14:	89 f0                	mov    %esi,%eax
  800d16:	e8 61 ff ff ff       	call   800c7c <_pipeisclosed>
  800d1b:	85 c0                	test   %eax,%eax
  800d1d:	75 3b                	jne    800d5a <devpipe_write+0x79>
			sys_yield();
  800d1f:	e8 5a f4 ff ff       	call   80017e <sys_yield>
  800d24:	eb e0                	jmp    800d06 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d29:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800d2d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800d30:	89 c2                	mov    %eax,%edx
  800d32:	c1 fa 1f             	sar    $0x1f,%edx
  800d35:	89 d1                	mov    %edx,%ecx
  800d37:	c1 e9 1b             	shr    $0x1b,%ecx
  800d3a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800d3d:	83 e2 1f             	and    $0x1f,%edx
  800d40:	29 ca                	sub    %ecx,%edx
  800d42:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800d46:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800d4a:	83 c0 01             	add    $0x1,%eax
  800d4d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d50:	83 c7 01             	add    $0x1,%edi
  800d53:	eb ac                	jmp    800d01 <devpipe_write+0x20>
	return i;
  800d55:	8b 45 10             	mov    0x10(%ebp),%eax
  800d58:	eb 05                	jmp    800d5f <devpipe_write+0x7e>
				return 0;
  800d5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5f                   	pop    %edi
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    

00800d67 <devpipe_read>:
{
  800d67:	f3 0f 1e fb          	endbr32 
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	57                   	push   %edi
  800d6f:	56                   	push   %esi
  800d70:	53                   	push   %ebx
  800d71:	83 ec 18             	sub    $0x18,%esp
  800d74:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d77:	57                   	push   %edi
  800d78:	e8 49 f6 ff ff       	call   8003c6 <fd2data>
  800d7d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d7f:	83 c4 10             	add    $0x10,%esp
  800d82:	be 00 00 00 00       	mov    $0x0,%esi
  800d87:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d8a:	75 14                	jne    800da0 <devpipe_read+0x39>
	return i;
  800d8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8f:	eb 02                	jmp    800d93 <devpipe_read+0x2c>
				return i;
  800d91:	89 f0                	mov    %esi,%eax
}
  800d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d96:	5b                   	pop    %ebx
  800d97:	5e                   	pop    %esi
  800d98:	5f                   	pop    %edi
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    
			sys_yield();
  800d9b:	e8 de f3 ff ff       	call   80017e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800da0:	8b 03                	mov    (%ebx),%eax
  800da2:	3b 43 04             	cmp    0x4(%ebx),%eax
  800da5:	75 18                	jne    800dbf <devpipe_read+0x58>
			if (i > 0)
  800da7:	85 f6                	test   %esi,%esi
  800da9:	75 e6                	jne    800d91 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  800dab:	89 da                	mov    %ebx,%edx
  800dad:	89 f8                	mov    %edi,%eax
  800daf:	e8 c8 fe ff ff       	call   800c7c <_pipeisclosed>
  800db4:	85 c0                	test   %eax,%eax
  800db6:	74 e3                	je     800d9b <devpipe_read+0x34>
				return 0;
  800db8:	b8 00 00 00 00       	mov    $0x0,%eax
  800dbd:	eb d4                	jmp    800d93 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800dbf:	99                   	cltd   
  800dc0:	c1 ea 1b             	shr    $0x1b,%edx
  800dc3:	01 d0                	add    %edx,%eax
  800dc5:	83 e0 1f             	and    $0x1f,%eax
  800dc8:	29 d0                	sub    %edx,%eax
  800dca:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800dcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd2:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800dd5:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800dd8:	83 c6 01             	add    $0x1,%esi
  800ddb:	eb aa                	jmp    800d87 <devpipe_read+0x20>

00800ddd <pipe>:
{
  800ddd:	f3 0f 1e fb          	endbr32 
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	56                   	push   %esi
  800de5:	53                   	push   %ebx
  800de6:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800de9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dec:	50                   	push   %eax
  800ded:	e8 ef f5 ff ff       	call   8003e1 <fd_alloc>
  800df2:	89 c3                	mov    %eax,%ebx
  800df4:	83 c4 10             	add    $0x10,%esp
  800df7:	85 c0                	test   %eax,%eax
  800df9:	0f 88 23 01 00 00    	js     800f22 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dff:	83 ec 04             	sub    $0x4,%esp
  800e02:	68 07 04 00 00       	push   $0x407
  800e07:	ff 75 f4             	pushl  -0xc(%ebp)
  800e0a:	6a 00                	push   $0x0
  800e0c:	e8 90 f3 ff ff       	call   8001a1 <sys_page_alloc>
  800e11:	89 c3                	mov    %eax,%ebx
  800e13:	83 c4 10             	add    $0x10,%esp
  800e16:	85 c0                	test   %eax,%eax
  800e18:	0f 88 04 01 00 00    	js     800f22 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  800e1e:	83 ec 0c             	sub    $0xc,%esp
  800e21:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e24:	50                   	push   %eax
  800e25:	e8 b7 f5 ff ff       	call   8003e1 <fd_alloc>
  800e2a:	89 c3                	mov    %eax,%ebx
  800e2c:	83 c4 10             	add    $0x10,%esp
  800e2f:	85 c0                	test   %eax,%eax
  800e31:	0f 88 db 00 00 00    	js     800f12 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e37:	83 ec 04             	sub    $0x4,%esp
  800e3a:	68 07 04 00 00       	push   $0x407
  800e3f:	ff 75 f0             	pushl  -0x10(%ebp)
  800e42:	6a 00                	push   $0x0
  800e44:	e8 58 f3 ff ff       	call   8001a1 <sys_page_alloc>
  800e49:	89 c3                	mov    %eax,%ebx
  800e4b:	83 c4 10             	add    $0x10,%esp
  800e4e:	85 c0                	test   %eax,%eax
  800e50:	0f 88 bc 00 00 00    	js     800f12 <pipe+0x135>
	va = fd2data(fd0);
  800e56:	83 ec 0c             	sub    $0xc,%esp
  800e59:	ff 75 f4             	pushl  -0xc(%ebp)
  800e5c:	e8 65 f5 ff ff       	call   8003c6 <fd2data>
  800e61:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e63:	83 c4 0c             	add    $0xc,%esp
  800e66:	68 07 04 00 00       	push   $0x407
  800e6b:	50                   	push   %eax
  800e6c:	6a 00                	push   $0x0
  800e6e:	e8 2e f3 ff ff       	call   8001a1 <sys_page_alloc>
  800e73:	89 c3                	mov    %eax,%ebx
  800e75:	83 c4 10             	add    $0x10,%esp
  800e78:	85 c0                	test   %eax,%eax
  800e7a:	0f 88 82 00 00 00    	js     800f02 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e80:	83 ec 0c             	sub    $0xc,%esp
  800e83:	ff 75 f0             	pushl  -0x10(%ebp)
  800e86:	e8 3b f5 ff ff       	call   8003c6 <fd2data>
  800e8b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e92:	50                   	push   %eax
  800e93:	6a 00                	push   $0x0
  800e95:	56                   	push   %esi
  800e96:	6a 00                	push   $0x0
  800e98:	e8 4b f3 ff ff       	call   8001e8 <sys_page_map>
  800e9d:	89 c3                	mov    %eax,%ebx
  800e9f:	83 c4 20             	add    $0x20,%esp
  800ea2:	85 c0                	test   %eax,%eax
  800ea4:	78 4e                	js     800ef4 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  800ea6:	a1 20 30 80 00       	mov    0x803020,%eax
  800eab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eae:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800eb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb3:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800eba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ebd:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ec2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800ec9:	83 ec 0c             	sub    $0xc,%esp
  800ecc:	ff 75 f4             	pushl  -0xc(%ebp)
  800ecf:	e8 de f4 ff ff       	call   8003b2 <fd2num>
  800ed4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ed7:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800ed9:	83 c4 04             	add    $0x4,%esp
  800edc:	ff 75 f0             	pushl  -0x10(%ebp)
  800edf:	e8 ce f4 ff ff       	call   8003b2 <fd2num>
  800ee4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ee7:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800eea:	83 c4 10             	add    $0x10,%esp
  800eed:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef2:	eb 2e                	jmp    800f22 <pipe+0x145>
	sys_page_unmap(0, va);
  800ef4:	83 ec 08             	sub    $0x8,%esp
  800ef7:	56                   	push   %esi
  800ef8:	6a 00                	push   $0x0
  800efa:	e8 2f f3 ff ff       	call   80022e <sys_page_unmap>
  800eff:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800f02:	83 ec 08             	sub    $0x8,%esp
  800f05:	ff 75 f0             	pushl  -0x10(%ebp)
  800f08:	6a 00                	push   $0x0
  800f0a:	e8 1f f3 ff ff       	call   80022e <sys_page_unmap>
  800f0f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800f12:	83 ec 08             	sub    $0x8,%esp
  800f15:	ff 75 f4             	pushl  -0xc(%ebp)
  800f18:	6a 00                	push   $0x0
  800f1a:	e8 0f f3 ff ff       	call   80022e <sys_page_unmap>
  800f1f:	83 c4 10             	add    $0x10,%esp
}
  800f22:	89 d8                	mov    %ebx,%eax
  800f24:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f27:	5b                   	pop    %ebx
  800f28:	5e                   	pop    %esi
  800f29:	5d                   	pop    %ebp
  800f2a:	c3                   	ret    

00800f2b <pipeisclosed>:
{
  800f2b:	f3 0f 1e fb          	endbr32 
  800f2f:	55                   	push   %ebp
  800f30:	89 e5                	mov    %esp,%ebp
  800f32:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f35:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f38:	50                   	push   %eax
  800f39:	ff 75 08             	pushl  0x8(%ebp)
  800f3c:	e8 f6 f4 ff ff       	call   800437 <fd_lookup>
  800f41:	83 c4 10             	add    $0x10,%esp
  800f44:	85 c0                	test   %eax,%eax
  800f46:	78 18                	js     800f60 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  800f48:	83 ec 0c             	sub    $0xc,%esp
  800f4b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4e:	e8 73 f4 ff ff       	call   8003c6 <fd2data>
  800f53:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  800f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f58:	e8 1f fd ff ff       	call   800c7c <_pipeisclosed>
  800f5d:	83 c4 10             	add    $0x10,%esp
}
  800f60:	c9                   	leave  
  800f61:	c3                   	ret    

00800f62 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800f62:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  800f66:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6b:	c3                   	ret    

00800f6c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f6c:	f3 0f 1e fb          	endbr32 
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
  800f73:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800f76:	68 36 20 80 00       	push   $0x802036
  800f7b:	ff 75 0c             	pushl  0xc(%ebp)
  800f7e:	e8 65 08 00 00       	call   8017e8 <strcpy>
	return 0;
}
  800f83:	b8 00 00 00 00       	mov    $0x0,%eax
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    

00800f8a <devcons_write>:
{
  800f8a:	f3 0f 1e fb          	endbr32 
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	57                   	push   %edi
  800f92:	56                   	push   %esi
  800f93:	53                   	push   %ebx
  800f94:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800f9a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800f9f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800fa5:	3b 75 10             	cmp    0x10(%ebp),%esi
  800fa8:	73 31                	jae    800fdb <devcons_write+0x51>
		m = n - tot;
  800faa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fad:	29 f3                	sub    %esi,%ebx
  800faf:	83 fb 7f             	cmp    $0x7f,%ebx
  800fb2:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800fb7:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800fba:	83 ec 04             	sub    $0x4,%esp
  800fbd:	53                   	push   %ebx
  800fbe:	89 f0                	mov    %esi,%eax
  800fc0:	03 45 0c             	add    0xc(%ebp),%eax
  800fc3:	50                   	push   %eax
  800fc4:	57                   	push   %edi
  800fc5:	e8 d4 09 00 00       	call   80199e <memmove>
		sys_cputs(buf, m);
  800fca:	83 c4 08             	add    $0x8,%esp
  800fcd:	53                   	push   %ebx
  800fce:	57                   	push   %edi
  800fcf:	e8 fd f0 ff ff       	call   8000d1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800fd4:	01 de                	add    %ebx,%esi
  800fd6:	83 c4 10             	add    $0x10,%esp
  800fd9:	eb ca                	jmp    800fa5 <devcons_write+0x1b>
}
  800fdb:	89 f0                	mov    %esi,%eax
  800fdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe0:	5b                   	pop    %ebx
  800fe1:	5e                   	pop    %esi
  800fe2:	5f                   	pop    %edi
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    

00800fe5 <devcons_read>:
{
  800fe5:	f3 0f 1e fb          	endbr32 
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	83 ec 08             	sub    $0x8,%esp
  800fef:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800ff4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff8:	74 21                	je     80101b <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800ffa:	e8 f4 f0 ff ff       	call   8000f3 <sys_cgetc>
  800fff:	85 c0                	test   %eax,%eax
  801001:	75 07                	jne    80100a <devcons_read+0x25>
		sys_yield();
  801003:	e8 76 f1 ff ff       	call   80017e <sys_yield>
  801008:	eb f0                	jmp    800ffa <devcons_read+0x15>
	if (c < 0)
  80100a:	78 0f                	js     80101b <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80100c:	83 f8 04             	cmp    $0x4,%eax
  80100f:	74 0c                	je     80101d <devcons_read+0x38>
	*(char*)vbuf = c;
  801011:	8b 55 0c             	mov    0xc(%ebp),%edx
  801014:	88 02                	mov    %al,(%edx)
	return 1;
  801016:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80101b:	c9                   	leave  
  80101c:	c3                   	ret    
		return 0;
  80101d:	b8 00 00 00 00       	mov    $0x0,%eax
  801022:	eb f7                	jmp    80101b <devcons_read+0x36>

00801024 <cputchar>:
{
  801024:	f3 0f 1e fb          	endbr32 
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801034:	6a 01                	push   $0x1
  801036:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801039:	50                   	push   %eax
  80103a:	e8 92 f0 ff ff       	call   8000d1 <sys_cputs>
}
  80103f:	83 c4 10             	add    $0x10,%esp
  801042:	c9                   	leave  
  801043:	c3                   	ret    

00801044 <getchar>:
{
  801044:	f3 0f 1e fb          	endbr32 
  801048:	55                   	push   %ebp
  801049:	89 e5                	mov    %esp,%ebp
  80104b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80104e:	6a 01                	push   $0x1
  801050:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801053:	50                   	push   %eax
  801054:	6a 00                	push   $0x0
  801056:	e8 5f f6 ff ff       	call   8006ba <read>
	if (r < 0)
  80105b:	83 c4 10             	add    $0x10,%esp
  80105e:	85 c0                	test   %eax,%eax
  801060:	78 06                	js     801068 <getchar+0x24>
	if (r < 1)
  801062:	74 06                	je     80106a <getchar+0x26>
	return c;
  801064:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801068:	c9                   	leave  
  801069:	c3                   	ret    
		return -E_EOF;
  80106a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80106f:	eb f7                	jmp    801068 <getchar+0x24>

00801071 <iscons>:
{
  801071:	f3 0f 1e fb          	endbr32 
  801075:	55                   	push   %ebp
  801076:	89 e5                	mov    %esp,%ebp
  801078:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80107b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80107e:	50                   	push   %eax
  80107f:	ff 75 08             	pushl  0x8(%ebp)
  801082:	e8 b0 f3 ff ff       	call   800437 <fd_lookup>
  801087:	83 c4 10             	add    $0x10,%esp
  80108a:	85 c0                	test   %eax,%eax
  80108c:	78 11                	js     80109f <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80108e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801091:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801097:	39 10                	cmp    %edx,(%eax)
  801099:	0f 94 c0             	sete   %al
  80109c:	0f b6 c0             	movzbl %al,%eax
}
  80109f:	c9                   	leave  
  8010a0:	c3                   	ret    

008010a1 <opencons>:
{
  8010a1:	f3 0f 1e fb          	endbr32 
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8010ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010ae:	50                   	push   %eax
  8010af:	e8 2d f3 ff ff       	call   8003e1 <fd_alloc>
  8010b4:	83 c4 10             	add    $0x10,%esp
  8010b7:	85 c0                	test   %eax,%eax
  8010b9:	78 3a                	js     8010f5 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8010bb:	83 ec 04             	sub    $0x4,%esp
  8010be:	68 07 04 00 00       	push   $0x407
  8010c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8010c6:	6a 00                	push   $0x0
  8010c8:	e8 d4 f0 ff ff       	call   8001a1 <sys_page_alloc>
  8010cd:	83 c4 10             	add    $0x10,%esp
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	78 21                	js     8010f5 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8010d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d7:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010dd:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8010df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8010e9:	83 ec 0c             	sub    $0xc,%esp
  8010ec:	50                   	push   %eax
  8010ed:	e8 c0 f2 ff ff       	call   8003b2 <fd2num>
  8010f2:	83 c4 10             	add    $0x10,%esp
}
  8010f5:	c9                   	leave  
  8010f6:	c3                   	ret    

008010f7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8010f7:	f3 0f 1e fb          	endbr32 
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
  8010fe:	56                   	push   %esi
  8010ff:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801100:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801103:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801109:	e8 4d f0 ff ff       	call   80015b <sys_getenvid>
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	ff 75 0c             	pushl  0xc(%ebp)
  801114:	ff 75 08             	pushl  0x8(%ebp)
  801117:	56                   	push   %esi
  801118:	50                   	push   %eax
  801119:	68 44 20 80 00       	push   $0x802044
  80111e:	e8 bb 00 00 00       	call   8011de <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801123:	83 c4 18             	add    $0x18,%esp
  801126:	53                   	push   %ebx
  801127:	ff 75 10             	pushl  0x10(%ebp)
  80112a:	e8 5a 00 00 00       	call   801189 <vcprintf>
	cprintf("\n");
  80112f:	c7 04 24 78 23 80 00 	movl   $0x802378,(%esp)
  801136:	e8 a3 00 00 00       	call   8011de <cprintf>
  80113b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80113e:	cc                   	int3   
  80113f:	eb fd                	jmp    80113e <_panic+0x47>

00801141 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801141:	f3 0f 1e fb          	endbr32 
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	53                   	push   %ebx
  801149:	83 ec 04             	sub    $0x4,%esp
  80114c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80114f:	8b 13                	mov    (%ebx),%edx
  801151:	8d 42 01             	lea    0x1(%edx),%eax
  801154:	89 03                	mov    %eax,(%ebx)
  801156:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801159:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80115d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801162:	74 09                	je     80116d <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801164:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801168:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80116b:	c9                   	leave  
  80116c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80116d:	83 ec 08             	sub    $0x8,%esp
  801170:	68 ff 00 00 00       	push   $0xff
  801175:	8d 43 08             	lea    0x8(%ebx),%eax
  801178:	50                   	push   %eax
  801179:	e8 53 ef ff ff       	call   8000d1 <sys_cputs>
		b->idx = 0;
  80117e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801184:	83 c4 10             	add    $0x10,%esp
  801187:	eb db                	jmp    801164 <putch+0x23>

00801189 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801189:	f3 0f 1e fb          	endbr32 
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801196:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80119d:	00 00 00 
	b.cnt = 0;
  8011a0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011a7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8011aa:	ff 75 0c             	pushl  0xc(%ebp)
  8011ad:	ff 75 08             	pushl  0x8(%ebp)
  8011b0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011b6:	50                   	push   %eax
  8011b7:	68 41 11 80 00       	push   $0x801141
  8011bc:	e8 20 01 00 00       	call   8012e1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8011c1:	83 c4 08             	add    $0x8,%esp
  8011c4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8011ca:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8011d0:	50                   	push   %eax
  8011d1:	e8 fb ee ff ff       	call   8000d1 <sys_cputs>

	return b.cnt;
}
  8011d6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8011dc:	c9                   	leave  
  8011dd:	c3                   	ret    

008011de <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8011de:	f3 0f 1e fb          	endbr32 
  8011e2:	55                   	push   %ebp
  8011e3:	89 e5                	mov    %esp,%ebp
  8011e5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8011e8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8011eb:	50                   	push   %eax
  8011ec:	ff 75 08             	pushl  0x8(%ebp)
  8011ef:	e8 95 ff ff ff       	call   801189 <vcprintf>
	va_end(ap);

	return cnt;
}
  8011f4:	c9                   	leave  
  8011f5:	c3                   	ret    

008011f6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	57                   	push   %edi
  8011fa:	56                   	push   %esi
  8011fb:	53                   	push   %ebx
  8011fc:	83 ec 1c             	sub    $0x1c,%esp
  8011ff:	89 c7                	mov    %eax,%edi
  801201:	89 d6                	mov    %edx,%esi
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8b 55 0c             	mov    0xc(%ebp),%edx
  801209:	89 d1                	mov    %edx,%ecx
  80120b:	89 c2                	mov    %eax,%edx
  80120d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801210:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801213:	8b 45 10             	mov    0x10(%ebp),%eax
  801216:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801219:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80121c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801223:	39 c2                	cmp    %eax,%edx
  801225:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  801228:	72 3e                	jb     801268 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80122a:	83 ec 0c             	sub    $0xc,%esp
  80122d:	ff 75 18             	pushl  0x18(%ebp)
  801230:	83 eb 01             	sub    $0x1,%ebx
  801233:	53                   	push   %ebx
  801234:	50                   	push   %eax
  801235:	83 ec 08             	sub    $0x8,%esp
  801238:	ff 75 e4             	pushl  -0x1c(%ebp)
  80123b:	ff 75 e0             	pushl  -0x20(%ebp)
  80123e:	ff 75 dc             	pushl  -0x24(%ebp)
  801241:	ff 75 d8             	pushl  -0x28(%ebp)
  801244:	e8 77 0a 00 00       	call   801cc0 <__udivdi3>
  801249:	83 c4 18             	add    $0x18,%esp
  80124c:	52                   	push   %edx
  80124d:	50                   	push   %eax
  80124e:	89 f2                	mov    %esi,%edx
  801250:	89 f8                	mov    %edi,%eax
  801252:	e8 9f ff ff ff       	call   8011f6 <printnum>
  801257:	83 c4 20             	add    $0x20,%esp
  80125a:	eb 13                	jmp    80126f <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80125c:	83 ec 08             	sub    $0x8,%esp
  80125f:	56                   	push   %esi
  801260:	ff 75 18             	pushl  0x18(%ebp)
  801263:	ff d7                	call   *%edi
  801265:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801268:	83 eb 01             	sub    $0x1,%ebx
  80126b:	85 db                	test   %ebx,%ebx
  80126d:	7f ed                	jg     80125c <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80126f:	83 ec 08             	sub    $0x8,%esp
  801272:	56                   	push   %esi
  801273:	83 ec 04             	sub    $0x4,%esp
  801276:	ff 75 e4             	pushl  -0x1c(%ebp)
  801279:	ff 75 e0             	pushl  -0x20(%ebp)
  80127c:	ff 75 dc             	pushl  -0x24(%ebp)
  80127f:	ff 75 d8             	pushl  -0x28(%ebp)
  801282:	e8 49 0b 00 00       	call   801dd0 <__umoddi3>
  801287:	83 c4 14             	add    $0x14,%esp
  80128a:	0f be 80 67 20 80 00 	movsbl 0x802067(%eax),%eax
  801291:	50                   	push   %eax
  801292:	ff d7                	call   *%edi
}
  801294:	83 c4 10             	add    $0x10,%esp
  801297:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80129a:	5b                   	pop    %ebx
  80129b:	5e                   	pop    %esi
  80129c:	5f                   	pop    %edi
  80129d:	5d                   	pop    %ebp
  80129e:	c3                   	ret    

0080129f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80129f:	f3 0f 1e fb          	endbr32 
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8012a9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8012ad:	8b 10                	mov    (%eax),%edx
  8012af:	3b 50 04             	cmp    0x4(%eax),%edx
  8012b2:	73 0a                	jae    8012be <sprintputch+0x1f>
		*b->buf++ = ch;
  8012b4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012b7:	89 08                	mov    %ecx,(%eax)
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	88 02                	mov    %al,(%edx)
}
  8012be:	5d                   	pop    %ebp
  8012bf:	c3                   	ret    

008012c0 <printfmt>:
{
  8012c0:	f3 0f 1e fb          	endbr32 
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
  8012c7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8012ca:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8012cd:	50                   	push   %eax
  8012ce:	ff 75 10             	pushl  0x10(%ebp)
  8012d1:	ff 75 0c             	pushl  0xc(%ebp)
  8012d4:	ff 75 08             	pushl  0x8(%ebp)
  8012d7:	e8 05 00 00 00       	call   8012e1 <vprintfmt>
}
  8012dc:	83 c4 10             	add    $0x10,%esp
  8012df:	c9                   	leave  
  8012e0:	c3                   	ret    

008012e1 <vprintfmt>:
{
  8012e1:	f3 0f 1e fb          	endbr32 
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	57                   	push   %edi
  8012e9:	56                   	push   %esi
  8012ea:	53                   	push   %ebx
  8012eb:	83 ec 3c             	sub    $0x3c,%esp
  8012ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8012f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012f4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8012f7:	e9 8e 03 00 00       	jmp    80168a <vprintfmt+0x3a9>
		padc = ' ';
  8012fc:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801300:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801307:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80130e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801315:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80131a:	8d 47 01             	lea    0x1(%edi),%eax
  80131d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801320:	0f b6 17             	movzbl (%edi),%edx
  801323:	8d 42 dd             	lea    -0x23(%edx),%eax
  801326:	3c 55                	cmp    $0x55,%al
  801328:	0f 87 df 03 00 00    	ja     80170d <vprintfmt+0x42c>
  80132e:	0f b6 c0             	movzbl %al,%eax
  801331:	3e ff 24 85 a0 21 80 	notrack jmp *0x8021a0(,%eax,4)
  801338:	00 
  801339:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80133c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801340:	eb d8                	jmp    80131a <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801342:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801345:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801349:	eb cf                	jmp    80131a <vprintfmt+0x39>
  80134b:	0f b6 d2             	movzbl %dl,%edx
  80134e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801351:	b8 00 00 00 00       	mov    $0x0,%eax
  801356:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801359:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80135c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801360:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801363:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801366:	83 f9 09             	cmp    $0x9,%ecx
  801369:	77 55                	ja     8013c0 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80136b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80136e:	eb e9                	jmp    801359 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801370:	8b 45 14             	mov    0x14(%ebp),%eax
  801373:	8b 00                	mov    (%eax),%eax
  801375:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801378:	8b 45 14             	mov    0x14(%ebp),%eax
  80137b:	8d 40 04             	lea    0x4(%eax),%eax
  80137e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801381:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801384:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801388:	79 90                	jns    80131a <vprintfmt+0x39>
				width = precision, precision = -1;
  80138a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80138d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801390:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801397:	eb 81                	jmp    80131a <vprintfmt+0x39>
  801399:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80139c:	85 c0                	test   %eax,%eax
  80139e:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a3:	0f 49 d0             	cmovns %eax,%edx
  8013a6:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8013a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013ac:	e9 69 ff ff ff       	jmp    80131a <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8013b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8013b4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8013bb:	e9 5a ff ff ff       	jmp    80131a <vprintfmt+0x39>
  8013c0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8013c6:	eb bc                	jmp    801384 <vprintfmt+0xa3>
			lflag++;
  8013c8:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013ce:	e9 47 ff ff ff       	jmp    80131a <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8013d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d6:	8d 78 04             	lea    0x4(%eax),%edi
  8013d9:	83 ec 08             	sub    $0x8,%esp
  8013dc:	53                   	push   %ebx
  8013dd:	ff 30                	pushl  (%eax)
  8013df:	ff d6                	call   *%esi
			break;
  8013e1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8013e4:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8013e7:	e9 9b 02 00 00       	jmp    801687 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8013ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ef:	8d 78 04             	lea    0x4(%eax),%edi
  8013f2:	8b 00                	mov    (%eax),%eax
  8013f4:	99                   	cltd   
  8013f5:	31 d0                	xor    %edx,%eax
  8013f7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8013f9:	83 f8 0f             	cmp    $0xf,%eax
  8013fc:	7f 23                	jg     801421 <vprintfmt+0x140>
  8013fe:	8b 14 85 00 23 80 00 	mov    0x802300(,%eax,4),%edx
  801405:	85 d2                	test   %edx,%edx
  801407:	74 18                	je     801421 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  801409:	52                   	push   %edx
  80140a:	68 fd 1f 80 00       	push   $0x801ffd
  80140f:	53                   	push   %ebx
  801410:	56                   	push   %esi
  801411:	e8 aa fe ff ff       	call   8012c0 <printfmt>
  801416:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801419:	89 7d 14             	mov    %edi,0x14(%ebp)
  80141c:	e9 66 02 00 00       	jmp    801687 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  801421:	50                   	push   %eax
  801422:	68 7f 20 80 00       	push   $0x80207f
  801427:	53                   	push   %ebx
  801428:	56                   	push   %esi
  801429:	e8 92 fe ff ff       	call   8012c0 <printfmt>
  80142e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801431:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801434:	e9 4e 02 00 00       	jmp    801687 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  801439:	8b 45 14             	mov    0x14(%ebp),%eax
  80143c:	83 c0 04             	add    $0x4,%eax
  80143f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801442:	8b 45 14             	mov    0x14(%ebp),%eax
  801445:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801447:	85 d2                	test   %edx,%edx
  801449:	b8 78 20 80 00       	mov    $0x802078,%eax
  80144e:	0f 45 c2             	cmovne %edx,%eax
  801451:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801454:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801458:	7e 06                	jle    801460 <vprintfmt+0x17f>
  80145a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80145e:	75 0d                	jne    80146d <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801460:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801463:	89 c7                	mov    %eax,%edi
  801465:	03 45 e0             	add    -0x20(%ebp),%eax
  801468:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80146b:	eb 55                	jmp    8014c2 <vprintfmt+0x1e1>
  80146d:	83 ec 08             	sub    $0x8,%esp
  801470:	ff 75 d8             	pushl  -0x28(%ebp)
  801473:	ff 75 cc             	pushl  -0x34(%ebp)
  801476:	e8 46 03 00 00       	call   8017c1 <strnlen>
  80147b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80147e:	29 c2                	sub    %eax,%edx
  801480:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801483:	83 c4 10             	add    $0x10,%esp
  801486:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801488:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80148c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80148f:	85 ff                	test   %edi,%edi
  801491:	7e 11                	jle    8014a4 <vprintfmt+0x1c3>
					putch(padc, putdat);
  801493:	83 ec 08             	sub    $0x8,%esp
  801496:	53                   	push   %ebx
  801497:	ff 75 e0             	pushl  -0x20(%ebp)
  80149a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80149c:	83 ef 01             	sub    $0x1,%edi
  80149f:	83 c4 10             	add    $0x10,%esp
  8014a2:	eb eb                	jmp    80148f <vprintfmt+0x1ae>
  8014a4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8014a7:	85 d2                	test   %edx,%edx
  8014a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ae:	0f 49 c2             	cmovns %edx,%eax
  8014b1:	29 c2                	sub    %eax,%edx
  8014b3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8014b6:	eb a8                	jmp    801460 <vprintfmt+0x17f>
					putch(ch, putdat);
  8014b8:	83 ec 08             	sub    $0x8,%esp
  8014bb:	53                   	push   %ebx
  8014bc:	52                   	push   %edx
  8014bd:	ff d6                	call   *%esi
  8014bf:	83 c4 10             	add    $0x10,%esp
  8014c2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8014c5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014c7:	83 c7 01             	add    $0x1,%edi
  8014ca:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8014ce:	0f be d0             	movsbl %al,%edx
  8014d1:	85 d2                	test   %edx,%edx
  8014d3:	74 4b                	je     801520 <vprintfmt+0x23f>
  8014d5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014d9:	78 06                	js     8014e1 <vprintfmt+0x200>
  8014db:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8014df:	78 1e                	js     8014ff <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8014e1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8014e5:	74 d1                	je     8014b8 <vprintfmt+0x1d7>
  8014e7:	0f be c0             	movsbl %al,%eax
  8014ea:	83 e8 20             	sub    $0x20,%eax
  8014ed:	83 f8 5e             	cmp    $0x5e,%eax
  8014f0:	76 c6                	jbe    8014b8 <vprintfmt+0x1d7>
					putch('?', putdat);
  8014f2:	83 ec 08             	sub    $0x8,%esp
  8014f5:	53                   	push   %ebx
  8014f6:	6a 3f                	push   $0x3f
  8014f8:	ff d6                	call   *%esi
  8014fa:	83 c4 10             	add    $0x10,%esp
  8014fd:	eb c3                	jmp    8014c2 <vprintfmt+0x1e1>
  8014ff:	89 cf                	mov    %ecx,%edi
  801501:	eb 0e                	jmp    801511 <vprintfmt+0x230>
				putch(' ', putdat);
  801503:	83 ec 08             	sub    $0x8,%esp
  801506:	53                   	push   %ebx
  801507:	6a 20                	push   $0x20
  801509:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80150b:	83 ef 01             	sub    $0x1,%edi
  80150e:	83 c4 10             	add    $0x10,%esp
  801511:	85 ff                	test   %edi,%edi
  801513:	7f ee                	jg     801503 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  801515:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801518:	89 45 14             	mov    %eax,0x14(%ebp)
  80151b:	e9 67 01 00 00       	jmp    801687 <vprintfmt+0x3a6>
  801520:	89 cf                	mov    %ecx,%edi
  801522:	eb ed                	jmp    801511 <vprintfmt+0x230>
	if (lflag >= 2)
  801524:	83 f9 01             	cmp    $0x1,%ecx
  801527:	7f 1b                	jg     801544 <vprintfmt+0x263>
	else if (lflag)
  801529:	85 c9                	test   %ecx,%ecx
  80152b:	74 63                	je     801590 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80152d:	8b 45 14             	mov    0x14(%ebp),%eax
  801530:	8b 00                	mov    (%eax),%eax
  801532:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801535:	99                   	cltd   
  801536:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801539:	8b 45 14             	mov    0x14(%ebp),%eax
  80153c:	8d 40 04             	lea    0x4(%eax),%eax
  80153f:	89 45 14             	mov    %eax,0x14(%ebp)
  801542:	eb 17                	jmp    80155b <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801544:	8b 45 14             	mov    0x14(%ebp),%eax
  801547:	8b 50 04             	mov    0x4(%eax),%edx
  80154a:	8b 00                	mov    (%eax),%eax
  80154c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80154f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801552:	8b 45 14             	mov    0x14(%ebp),%eax
  801555:	8d 40 08             	lea    0x8(%eax),%eax
  801558:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80155b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80155e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801561:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801566:	85 c9                	test   %ecx,%ecx
  801568:	0f 89 ff 00 00 00    	jns    80166d <vprintfmt+0x38c>
				putch('-', putdat);
  80156e:	83 ec 08             	sub    $0x8,%esp
  801571:	53                   	push   %ebx
  801572:	6a 2d                	push   $0x2d
  801574:	ff d6                	call   *%esi
				num = -(long long) num;
  801576:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801579:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80157c:	f7 da                	neg    %edx
  80157e:	83 d1 00             	adc    $0x0,%ecx
  801581:	f7 d9                	neg    %ecx
  801583:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801586:	b8 0a 00 00 00       	mov    $0xa,%eax
  80158b:	e9 dd 00 00 00       	jmp    80166d <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801590:	8b 45 14             	mov    0x14(%ebp),%eax
  801593:	8b 00                	mov    (%eax),%eax
  801595:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801598:	99                   	cltd   
  801599:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80159c:	8b 45 14             	mov    0x14(%ebp),%eax
  80159f:	8d 40 04             	lea    0x4(%eax),%eax
  8015a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8015a5:	eb b4                	jmp    80155b <vprintfmt+0x27a>
	if (lflag >= 2)
  8015a7:	83 f9 01             	cmp    $0x1,%ecx
  8015aa:	7f 1e                	jg     8015ca <vprintfmt+0x2e9>
	else if (lflag)
  8015ac:	85 c9                	test   %ecx,%ecx
  8015ae:	74 32                	je     8015e2 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8015b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b3:	8b 10                	mov    (%eax),%edx
  8015b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015ba:	8d 40 04             	lea    0x4(%eax),%eax
  8015bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015c0:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8015c5:	e9 a3 00 00 00       	jmp    80166d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8015ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8015cd:	8b 10                	mov    (%eax),%edx
  8015cf:	8b 48 04             	mov    0x4(%eax),%ecx
  8015d2:	8d 40 08             	lea    0x8(%eax),%eax
  8015d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015d8:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8015dd:	e9 8b 00 00 00       	jmp    80166d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8015e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e5:	8b 10                	mov    (%eax),%edx
  8015e7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015ec:	8d 40 04             	lea    0x4(%eax),%eax
  8015ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015f2:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8015f7:	eb 74                	jmp    80166d <vprintfmt+0x38c>
	if (lflag >= 2)
  8015f9:	83 f9 01             	cmp    $0x1,%ecx
  8015fc:	7f 1b                	jg     801619 <vprintfmt+0x338>
	else if (lflag)
  8015fe:	85 c9                	test   %ecx,%ecx
  801600:	74 2c                	je     80162e <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801602:	8b 45 14             	mov    0x14(%ebp),%eax
  801605:	8b 10                	mov    (%eax),%edx
  801607:	b9 00 00 00 00       	mov    $0x0,%ecx
  80160c:	8d 40 04             	lea    0x4(%eax),%eax
  80160f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801612:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801617:	eb 54                	jmp    80166d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801619:	8b 45 14             	mov    0x14(%ebp),%eax
  80161c:	8b 10                	mov    (%eax),%edx
  80161e:	8b 48 04             	mov    0x4(%eax),%ecx
  801621:	8d 40 08             	lea    0x8(%eax),%eax
  801624:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801627:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80162c:	eb 3f                	jmp    80166d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80162e:	8b 45 14             	mov    0x14(%ebp),%eax
  801631:	8b 10                	mov    (%eax),%edx
  801633:	b9 00 00 00 00       	mov    $0x0,%ecx
  801638:	8d 40 04             	lea    0x4(%eax),%eax
  80163b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80163e:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801643:	eb 28                	jmp    80166d <vprintfmt+0x38c>
			putch('0', putdat);
  801645:	83 ec 08             	sub    $0x8,%esp
  801648:	53                   	push   %ebx
  801649:	6a 30                	push   $0x30
  80164b:	ff d6                	call   *%esi
			putch('x', putdat);
  80164d:	83 c4 08             	add    $0x8,%esp
  801650:	53                   	push   %ebx
  801651:	6a 78                	push   $0x78
  801653:	ff d6                	call   *%esi
			num = (unsigned long long)
  801655:	8b 45 14             	mov    0x14(%ebp),%eax
  801658:	8b 10                	mov    (%eax),%edx
  80165a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80165f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801662:	8d 40 04             	lea    0x4(%eax),%eax
  801665:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801668:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80166d:	83 ec 0c             	sub    $0xc,%esp
  801670:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801674:	57                   	push   %edi
  801675:	ff 75 e0             	pushl  -0x20(%ebp)
  801678:	50                   	push   %eax
  801679:	51                   	push   %ecx
  80167a:	52                   	push   %edx
  80167b:	89 da                	mov    %ebx,%edx
  80167d:	89 f0                	mov    %esi,%eax
  80167f:	e8 72 fb ff ff       	call   8011f6 <printnum>
			break;
  801684:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801687:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80168a:	83 c7 01             	add    $0x1,%edi
  80168d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801691:	83 f8 25             	cmp    $0x25,%eax
  801694:	0f 84 62 fc ff ff    	je     8012fc <vprintfmt+0x1b>
			if (ch == '\0')
  80169a:	85 c0                	test   %eax,%eax
  80169c:	0f 84 8b 00 00 00    	je     80172d <vprintfmt+0x44c>
			putch(ch, putdat);
  8016a2:	83 ec 08             	sub    $0x8,%esp
  8016a5:	53                   	push   %ebx
  8016a6:	50                   	push   %eax
  8016a7:	ff d6                	call   *%esi
  8016a9:	83 c4 10             	add    $0x10,%esp
  8016ac:	eb dc                	jmp    80168a <vprintfmt+0x3a9>
	if (lflag >= 2)
  8016ae:	83 f9 01             	cmp    $0x1,%ecx
  8016b1:	7f 1b                	jg     8016ce <vprintfmt+0x3ed>
	else if (lflag)
  8016b3:	85 c9                	test   %ecx,%ecx
  8016b5:	74 2c                	je     8016e3 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8016b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ba:	8b 10                	mov    (%eax),%edx
  8016bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016c1:	8d 40 04             	lea    0x4(%eax),%eax
  8016c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016c7:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8016cc:	eb 9f                	jmp    80166d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8016ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d1:	8b 10                	mov    (%eax),%edx
  8016d3:	8b 48 04             	mov    0x4(%eax),%ecx
  8016d6:	8d 40 08             	lea    0x8(%eax),%eax
  8016d9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016dc:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8016e1:	eb 8a                	jmp    80166d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8016e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e6:	8b 10                	mov    (%eax),%edx
  8016e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016ed:	8d 40 04             	lea    0x4(%eax),%eax
  8016f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016f3:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8016f8:	e9 70 ff ff ff       	jmp    80166d <vprintfmt+0x38c>
			putch(ch, putdat);
  8016fd:	83 ec 08             	sub    $0x8,%esp
  801700:	53                   	push   %ebx
  801701:	6a 25                	push   $0x25
  801703:	ff d6                	call   *%esi
			break;
  801705:	83 c4 10             	add    $0x10,%esp
  801708:	e9 7a ff ff ff       	jmp    801687 <vprintfmt+0x3a6>
			putch('%', putdat);
  80170d:	83 ec 08             	sub    $0x8,%esp
  801710:	53                   	push   %ebx
  801711:	6a 25                	push   $0x25
  801713:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801715:	83 c4 10             	add    $0x10,%esp
  801718:	89 f8                	mov    %edi,%eax
  80171a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80171e:	74 05                	je     801725 <vprintfmt+0x444>
  801720:	83 e8 01             	sub    $0x1,%eax
  801723:	eb f5                	jmp    80171a <vprintfmt+0x439>
  801725:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801728:	e9 5a ff ff ff       	jmp    801687 <vprintfmt+0x3a6>
}
  80172d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801730:	5b                   	pop    %ebx
  801731:	5e                   	pop    %esi
  801732:	5f                   	pop    %edi
  801733:	5d                   	pop    %ebp
  801734:	c3                   	ret    

00801735 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801735:	f3 0f 1e fb          	endbr32 
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	83 ec 18             	sub    $0x18,%esp
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801745:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801748:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80174c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80174f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801756:	85 c0                	test   %eax,%eax
  801758:	74 26                	je     801780 <vsnprintf+0x4b>
  80175a:	85 d2                	test   %edx,%edx
  80175c:	7e 22                	jle    801780 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80175e:	ff 75 14             	pushl  0x14(%ebp)
  801761:	ff 75 10             	pushl  0x10(%ebp)
  801764:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801767:	50                   	push   %eax
  801768:	68 9f 12 80 00       	push   $0x80129f
  80176d:	e8 6f fb ff ff       	call   8012e1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801772:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801775:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177b:	83 c4 10             	add    $0x10,%esp
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    
		return -E_INVAL;
  801780:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801785:	eb f7                	jmp    80177e <vsnprintf+0x49>

00801787 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801787:	f3 0f 1e fb          	endbr32 
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801791:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801794:	50                   	push   %eax
  801795:	ff 75 10             	pushl  0x10(%ebp)
  801798:	ff 75 0c             	pushl  0xc(%ebp)
  80179b:	ff 75 08             	pushl  0x8(%ebp)
  80179e:	e8 92 ff ff ff       	call   801735 <vsnprintf>
	va_end(ap);

	return rc;
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8017a5:	f3 0f 1e fb          	endbr32 
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8017af:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8017b8:	74 05                	je     8017bf <strlen+0x1a>
		n++;
  8017ba:	83 c0 01             	add    $0x1,%eax
  8017bd:	eb f5                	jmp    8017b4 <strlen+0xf>
	return n;
}
  8017bf:	5d                   	pop    %ebp
  8017c0:	c3                   	ret    

008017c1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8017c1:	f3 0f 1e fb          	endbr32 
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017cb:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8017ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d3:	39 d0                	cmp    %edx,%eax
  8017d5:	74 0d                	je     8017e4 <strnlen+0x23>
  8017d7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8017db:	74 05                	je     8017e2 <strnlen+0x21>
		n++;
  8017dd:	83 c0 01             	add    $0x1,%eax
  8017e0:	eb f1                	jmp    8017d3 <strnlen+0x12>
  8017e2:	89 c2                	mov    %eax,%edx
	return n;
}
  8017e4:	89 d0                	mov    %edx,%eax
  8017e6:	5d                   	pop    %ebp
  8017e7:	c3                   	ret    

008017e8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8017e8:	f3 0f 1e fb          	endbr32 
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	53                   	push   %ebx
  8017f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8017f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fb:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8017ff:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801802:	83 c0 01             	add    $0x1,%eax
  801805:	84 d2                	test   %dl,%dl
  801807:	75 f2                	jne    8017fb <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801809:	89 c8                	mov    %ecx,%eax
  80180b:	5b                   	pop    %ebx
  80180c:	5d                   	pop    %ebp
  80180d:	c3                   	ret    

0080180e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80180e:	f3 0f 1e fb          	endbr32 
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	53                   	push   %ebx
  801816:	83 ec 10             	sub    $0x10,%esp
  801819:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80181c:	53                   	push   %ebx
  80181d:	e8 83 ff ff ff       	call   8017a5 <strlen>
  801822:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801825:	ff 75 0c             	pushl  0xc(%ebp)
  801828:	01 d8                	add    %ebx,%eax
  80182a:	50                   	push   %eax
  80182b:	e8 b8 ff ff ff       	call   8017e8 <strcpy>
	return dst;
}
  801830:	89 d8                	mov    %ebx,%eax
  801832:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801835:	c9                   	leave  
  801836:	c3                   	ret    

00801837 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801837:	f3 0f 1e fb          	endbr32 
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	56                   	push   %esi
  80183f:	53                   	push   %ebx
  801840:	8b 75 08             	mov    0x8(%ebp),%esi
  801843:	8b 55 0c             	mov    0xc(%ebp),%edx
  801846:	89 f3                	mov    %esi,%ebx
  801848:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80184b:	89 f0                	mov    %esi,%eax
  80184d:	39 d8                	cmp    %ebx,%eax
  80184f:	74 11                	je     801862 <strncpy+0x2b>
		*dst++ = *src;
  801851:	83 c0 01             	add    $0x1,%eax
  801854:	0f b6 0a             	movzbl (%edx),%ecx
  801857:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80185a:	80 f9 01             	cmp    $0x1,%cl
  80185d:	83 da ff             	sbb    $0xffffffff,%edx
  801860:	eb eb                	jmp    80184d <strncpy+0x16>
	}
	return ret;
}
  801862:	89 f0                	mov    %esi,%eax
  801864:	5b                   	pop    %ebx
  801865:	5e                   	pop    %esi
  801866:	5d                   	pop    %ebp
  801867:	c3                   	ret    

00801868 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801868:	f3 0f 1e fb          	endbr32 
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	56                   	push   %esi
  801870:	53                   	push   %ebx
  801871:	8b 75 08             	mov    0x8(%ebp),%esi
  801874:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801877:	8b 55 10             	mov    0x10(%ebp),%edx
  80187a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80187c:	85 d2                	test   %edx,%edx
  80187e:	74 21                	je     8018a1 <strlcpy+0x39>
  801880:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801884:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801886:	39 c2                	cmp    %eax,%edx
  801888:	74 14                	je     80189e <strlcpy+0x36>
  80188a:	0f b6 19             	movzbl (%ecx),%ebx
  80188d:	84 db                	test   %bl,%bl
  80188f:	74 0b                	je     80189c <strlcpy+0x34>
			*dst++ = *src++;
  801891:	83 c1 01             	add    $0x1,%ecx
  801894:	83 c2 01             	add    $0x1,%edx
  801897:	88 5a ff             	mov    %bl,-0x1(%edx)
  80189a:	eb ea                	jmp    801886 <strlcpy+0x1e>
  80189c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80189e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8018a1:	29 f0                	sub    %esi,%eax
}
  8018a3:	5b                   	pop    %ebx
  8018a4:	5e                   	pop    %esi
  8018a5:	5d                   	pop    %ebp
  8018a6:	c3                   	ret    

008018a7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8018a7:	f3 0f 1e fb          	endbr32 
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018b1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8018b4:	0f b6 01             	movzbl (%ecx),%eax
  8018b7:	84 c0                	test   %al,%al
  8018b9:	74 0c                	je     8018c7 <strcmp+0x20>
  8018bb:	3a 02                	cmp    (%edx),%al
  8018bd:	75 08                	jne    8018c7 <strcmp+0x20>
		p++, q++;
  8018bf:	83 c1 01             	add    $0x1,%ecx
  8018c2:	83 c2 01             	add    $0x1,%edx
  8018c5:	eb ed                	jmp    8018b4 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018c7:	0f b6 c0             	movzbl %al,%eax
  8018ca:	0f b6 12             	movzbl (%edx),%edx
  8018cd:	29 d0                	sub    %edx,%eax
}
  8018cf:	5d                   	pop    %ebp
  8018d0:	c3                   	ret    

008018d1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018d1:	f3 0f 1e fb          	endbr32 
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
  8018d8:	53                   	push   %ebx
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018df:	89 c3                	mov    %eax,%ebx
  8018e1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8018e4:	eb 06                	jmp    8018ec <strncmp+0x1b>
		n--, p++, q++;
  8018e6:	83 c0 01             	add    $0x1,%eax
  8018e9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8018ec:	39 d8                	cmp    %ebx,%eax
  8018ee:	74 16                	je     801906 <strncmp+0x35>
  8018f0:	0f b6 08             	movzbl (%eax),%ecx
  8018f3:	84 c9                	test   %cl,%cl
  8018f5:	74 04                	je     8018fb <strncmp+0x2a>
  8018f7:	3a 0a                	cmp    (%edx),%cl
  8018f9:	74 eb                	je     8018e6 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018fb:	0f b6 00             	movzbl (%eax),%eax
  8018fe:	0f b6 12             	movzbl (%edx),%edx
  801901:	29 d0                	sub    %edx,%eax
}
  801903:	5b                   	pop    %ebx
  801904:	5d                   	pop    %ebp
  801905:	c3                   	ret    
		return 0;
  801906:	b8 00 00 00 00       	mov    $0x0,%eax
  80190b:	eb f6                	jmp    801903 <strncmp+0x32>

0080190d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80190d:	f3 0f 1e fb          	endbr32 
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	8b 45 08             	mov    0x8(%ebp),%eax
  801917:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80191b:	0f b6 10             	movzbl (%eax),%edx
  80191e:	84 d2                	test   %dl,%dl
  801920:	74 09                	je     80192b <strchr+0x1e>
		if (*s == c)
  801922:	38 ca                	cmp    %cl,%dl
  801924:	74 0a                	je     801930 <strchr+0x23>
	for (; *s; s++)
  801926:	83 c0 01             	add    $0x1,%eax
  801929:	eb f0                	jmp    80191b <strchr+0xe>
			return (char *) s;
	return 0;
  80192b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801930:	5d                   	pop    %ebp
  801931:	c3                   	ret    

00801932 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801932:	f3 0f 1e fb          	endbr32 
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	8b 45 08             	mov    0x8(%ebp),%eax
  80193c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801940:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801943:	38 ca                	cmp    %cl,%dl
  801945:	74 09                	je     801950 <strfind+0x1e>
  801947:	84 d2                	test   %dl,%dl
  801949:	74 05                	je     801950 <strfind+0x1e>
	for (; *s; s++)
  80194b:	83 c0 01             	add    $0x1,%eax
  80194e:	eb f0                	jmp    801940 <strfind+0xe>
			break;
	return (char *) s;
}
  801950:	5d                   	pop    %ebp
  801951:	c3                   	ret    

00801952 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801952:	f3 0f 1e fb          	endbr32 
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
  801959:	57                   	push   %edi
  80195a:	56                   	push   %esi
  80195b:	53                   	push   %ebx
  80195c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80195f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801962:	85 c9                	test   %ecx,%ecx
  801964:	74 31                	je     801997 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801966:	89 f8                	mov    %edi,%eax
  801968:	09 c8                	or     %ecx,%eax
  80196a:	a8 03                	test   $0x3,%al
  80196c:	75 23                	jne    801991 <memset+0x3f>
		c &= 0xFF;
  80196e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801972:	89 d3                	mov    %edx,%ebx
  801974:	c1 e3 08             	shl    $0x8,%ebx
  801977:	89 d0                	mov    %edx,%eax
  801979:	c1 e0 18             	shl    $0x18,%eax
  80197c:	89 d6                	mov    %edx,%esi
  80197e:	c1 e6 10             	shl    $0x10,%esi
  801981:	09 f0                	or     %esi,%eax
  801983:	09 c2                	or     %eax,%edx
  801985:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801987:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80198a:	89 d0                	mov    %edx,%eax
  80198c:	fc                   	cld    
  80198d:	f3 ab                	rep stos %eax,%es:(%edi)
  80198f:	eb 06                	jmp    801997 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801991:	8b 45 0c             	mov    0xc(%ebp),%eax
  801994:	fc                   	cld    
  801995:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801997:	89 f8                	mov    %edi,%eax
  801999:	5b                   	pop    %ebx
  80199a:	5e                   	pop    %esi
  80199b:	5f                   	pop    %edi
  80199c:	5d                   	pop    %ebp
  80199d:	c3                   	ret    

0080199e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80199e:	f3 0f 1e fb          	endbr32 
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	57                   	push   %edi
  8019a6:	56                   	push   %esi
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019ad:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8019b0:	39 c6                	cmp    %eax,%esi
  8019b2:	73 32                	jae    8019e6 <memmove+0x48>
  8019b4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8019b7:	39 c2                	cmp    %eax,%edx
  8019b9:	76 2b                	jbe    8019e6 <memmove+0x48>
		s += n;
		d += n;
  8019bb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019be:	89 fe                	mov    %edi,%esi
  8019c0:	09 ce                	or     %ecx,%esi
  8019c2:	09 d6                	or     %edx,%esi
  8019c4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8019ca:	75 0e                	jne    8019da <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8019cc:	83 ef 04             	sub    $0x4,%edi
  8019cf:	8d 72 fc             	lea    -0x4(%edx),%esi
  8019d2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8019d5:	fd                   	std    
  8019d6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019d8:	eb 09                	jmp    8019e3 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8019da:	83 ef 01             	sub    $0x1,%edi
  8019dd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8019e0:	fd                   	std    
  8019e1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8019e3:	fc                   	cld    
  8019e4:	eb 1a                	jmp    801a00 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019e6:	89 c2                	mov    %eax,%edx
  8019e8:	09 ca                	or     %ecx,%edx
  8019ea:	09 f2                	or     %esi,%edx
  8019ec:	f6 c2 03             	test   $0x3,%dl
  8019ef:	75 0a                	jne    8019fb <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8019f1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8019f4:	89 c7                	mov    %eax,%edi
  8019f6:	fc                   	cld    
  8019f7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019f9:	eb 05                	jmp    801a00 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8019fb:	89 c7                	mov    %eax,%edi
  8019fd:	fc                   	cld    
  8019fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801a00:	5e                   	pop    %esi
  801a01:	5f                   	pop    %edi
  801a02:	5d                   	pop    %ebp
  801a03:	c3                   	ret    

00801a04 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801a04:	f3 0f 1e fb          	endbr32 
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801a0e:	ff 75 10             	pushl  0x10(%ebp)
  801a11:	ff 75 0c             	pushl  0xc(%ebp)
  801a14:	ff 75 08             	pushl  0x8(%ebp)
  801a17:	e8 82 ff ff ff       	call   80199e <memmove>
}
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801a1e:	f3 0f 1e fb          	endbr32 
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
  801a25:	56                   	push   %esi
  801a26:	53                   	push   %ebx
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2d:	89 c6                	mov    %eax,%esi
  801a2f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801a32:	39 f0                	cmp    %esi,%eax
  801a34:	74 1c                	je     801a52 <memcmp+0x34>
		if (*s1 != *s2)
  801a36:	0f b6 08             	movzbl (%eax),%ecx
  801a39:	0f b6 1a             	movzbl (%edx),%ebx
  801a3c:	38 d9                	cmp    %bl,%cl
  801a3e:	75 08                	jne    801a48 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801a40:	83 c0 01             	add    $0x1,%eax
  801a43:	83 c2 01             	add    $0x1,%edx
  801a46:	eb ea                	jmp    801a32 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801a48:	0f b6 c1             	movzbl %cl,%eax
  801a4b:	0f b6 db             	movzbl %bl,%ebx
  801a4e:	29 d8                	sub    %ebx,%eax
  801a50:	eb 05                	jmp    801a57 <memcmp+0x39>
	}

	return 0;
  801a52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a57:	5b                   	pop    %ebx
  801a58:	5e                   	pop    %esi
  801a59:	5d                   	pop    %ebp
  801a5a:	c3                   	ret    

00801a5b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a5b:	f3 0f 1e fb          	endbr32 
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	8b 45 08             	mov    0x8(%ebp),%eax
  801a65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801a68:	89 c2                	mov    %eax,%edx
  801a6a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801a6d:	39 d0                	cmp    %edx,%eax
  801a6f:	73 09                	jae    801a7a <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a71:	38 08                	cmp    %cl,(%eax)
  801a73:	74 05                	je     801a7a <memfind+0x1f>
	for (; s < ends; s++)
  801a75:	83 c0 01             	add    $0x1,%eax
  801a78:	eb f3                	jmp    801a6d <memfind+0x12>
			break;
	return (void *) s;
}
  801a7a:	5d                   	pop    %ebp
  801a7b:	c3                   	ret    

00801a7c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a7c:	f3 0f 1e fb          	endbr32 
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	57                   	push   %edi
  801a84:	56                   	push   %esi
  801a85:	53                   	push   %ebx
  801a86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a89:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a8c:	eb 03                	jmp    801a91 <strtol+0x15>
		s++;
  801a8e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801a91:	0f b6 01             	movzbl (%ecx),%eax
  801a94:	3c 20                	cmp    $0x20,%al
  801a96:	74 f6                	je     801a8e <strtol+0x12>
  801a98:	3c 09                	cmp    $0x9,%al
  801a9a:	74 f2                	je     801a8e <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801a9c:	3c 2b                	cmp    $0x2b,%al
  801a9e:	74 2a                	je     801aca <strtol+0x4e>
	int neg = 0;
  801aa0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801aa5:	3c 2d                	cmp    $0x2d,%al
  801aa7:	74 2b                	je     801ad4 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801aa9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801aaf:	75 0f                	jne    801ac0 <strtol+0x44>
  801ab1:	80 39 30             	cmpb   $0x30,(%ecx)
  801ab4:	74 28                	je     801ade <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801ab6:	85 db                	test   %ebx,%ebx
  801ab8:	b8 0a 00 00 00       	mov    $0xa,%eax
  801abd:	0f 44 d8             	cmove  %eax,%ebx
  801ac0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801ac8:	eb 46                	jmp    801b10 <strtol+0x94>
		s++;
  801aca:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801acd:	bf 00 00 00 00       	mov    $0x0,%edi
  801ad2:	eb d5                	jmp    801aa9 <strtol+0x2d>
		s++, neg = 1;
  801ad4:	83 c1 01             	add    $0x1,%ecx
  801ad7:	bf 01 00 00 00       	mov    $0x1,%edi
  801adc:	eb cb                	jmp    801aa9 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ade:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801ae2:	74 0e                	je     801af2 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801ae4:	85 db                	test   %ebx,%ebx
  801ae6:	75 d8                	jne    801ac0 <strtol+0x44>
		s++, base = 8;
  801ae8:	83 c1 01             	add    $0x1,%ecx
  801aeb:	bb 08 00 00 00       	mov    $0x8,%ebx
  801af0:	eb ce                	jmp    801ac0 <strtol+0x44>
		s += 2, base = 16;
  801af2:	83 c1 02             	add    $0x2,%ecx
  801af5:	bb 10 00 00 00       	mov    $0x10,%ebx
  801afa:	eb c4                	jmp    801ac0 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801afc:	0f be d2             	movsbl %dl,%edx
  801aff:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801b02:	3b 55 10             	cmp    0x10(%ebp),%edx
  801b05:	7d 3a                	jge    801b41 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801b07:	83 c1 01             	add    $0x1,%ecx
  801b0a:	0f af 45 10          	imul   0x10(%ebp),%eax
  801b0e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801b10:	0f b6 11             	movzbl (%ecx),%edx
  801b13:	8d 72 d0             	lea    -0x30(%edx),%esi
  801b16:	89 f3                	mov    %esi,%ebx
  801b18:	80 fb 09             	cmp    $0x9,%bl
  801b1b:	76 df                	jbe    801afc <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801b1d:	8d 72 9f             	lea    -0x61(%edx),%esi
  801b20:	89 f3                	mov    %esi,%ebx
  801b22:	80 fb 19             	cmp    $0x19,%bl
  801b25:	77 08                	ja     801b2f <strtol+0xb3>
			dig = *s - 'a' + 10;
  801b27:	0f be d2             	movsbl %dl,%edx
  801b2a:	83 ea 57             	sub    $0x57,%edx
  801b2d:	eb d3                	jmp    801b02 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801b2f:	8d 72 bf             	lea    -0x41(%edx),%esi
  801b32:	89 f3                	mov    %esi,%ebx
  801b34:	80 fb 19             	cmp    $0x19,%bl
  801b37:	77 08                	ja     801b41 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801b39:	0f be d2             	movsbl %dl,%edx
  801b3c:	83 ea 37             	sub    $0x37,%edx
  801b3f:	eb c1                	jmp    801b02 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801b41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b45:	74 05                	je     801b4c <strtol+0xd0>
		*endptr = (char *) s;
  801b47:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b4a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801b4c:	89 c2                	mov    %eax,%edx
  801b4e:	f7 da                	neg    %edx
  801b50:	85 ff                	test   %edi,%edi
  801b52:	0f 45 c2             	cmovne %edx,%eax
}
  801b55:	5b                   	pop    %ebx
  801b56:	5e                   	pop    %esi
  801b57:	5f                   	pop    %edi
  801b58:	5d                   	pop    %ebp
  801b59:	c3                   	ret    

00801b5a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b5a:	f3 0f 1e fb          	endbr32 
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	56                   	push   %esi
  801b62:	53                   	push   %ebx
  801b63:	8b 75 08             	mov    0x8(%ebp),%esi
  801b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b69:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801b6c:	85 c0                	test   %eax,%eax
  801b6e:	74 3d                	je     801bad <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801b70:	83 ec 0c             	sub    $0xc,%esp
  801b73:	50                   	push   %eax
  801b74:	e8 f4 e7 ff ff       	call   80036d <sys_ipc_recv>
  801b79:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801b7c:	85 f6                	test   %esi,%esi
  801b7e:	74 0b                	je     801b8b <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b80:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b86:	8b 52 74             	mov    0x74(%edx),%edx
  801b89:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801b8b:	85 db                	test   %ebx,%ebx
  801b8d:	74 0b                	je     801b9a <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801b8f:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b95:	8b 52 78             	mov    0x78(%edx),%edx
  801b98:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801b9a:	85 c0                	test   %eax,%eax
  801b9c:	78 21                	js     801bbf <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801b9e:	a1 04 40 80 00       	mov    0x804004,%eax
  801ba3:	8b 40 70             	mov    0x70(%eax),%eax
}
  801ba6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba9:	5b                   	pop    %ebx
  801baa:	5e                   	pop    %esi
  801bab:	5d                   	pop    %ebp
  801bac:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801bad:	83 ec 0c             	sub    $0xc,%esp
  801bb0:	68 00 00 c0 ee       	push   $0xeec00000
  801bb5:	e8 b3 e7 ff ff       	call   80036d <sys_ipc_recv>
  801bba:	83 c4 10             	add    $0x10,%esp
  801bbd:	eb bd                	jmp    801b7c <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801bbf:	85 f6                	test   %esi,%esi
  801bc1:	74 10                	je     801bd3 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801bc3:	85 db                	test   %ebx,%ebx
  801bc5:	75 df                	jne    801ba6 <ipc_recv+0x4c>
  801bc7:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801bce:	00 00 00 
  801bd1:	eb d3                	jmp    801ba6 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801bd3:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801bda:	00 00 00 
  801bdd:	eb e4                	jmp    801bc3 <ipc_recv+0x69>

00801bdf <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bdf:	f3 0f 1e fb          	endbr32 
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
  801be6:	57                   	push   %edi
  801be7:	56                   	push   %esi
  801be8:	53                   	push   %ebx
  801be9:	83 ec 0c             	sub    $0xc,%esp
  801bec:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bef:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bf2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801bf5:	85 db                	test   %ebx,%ebx
  801bf7:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801bfc:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801bff:	ff 75 14             	pushl  0x14(%ebp)
  801c02:	53                   	push   %ebx
  801c03:	56                   	push   %esi
  801c04:	57                   	push   %edi
  801c05:	e8 3c e7 ff ff       	call   800346 <sys_ipc_try_send>
  801c0a:	83 c4 10             	add    $0x10,%esp
  801c0d:	85 c0                	test   %eax,%eax
  801c0f:	79 1e                	jns    801c2f <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801c11:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c14:	75 07                	jne    801c1d <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801c16:	e8 63 e5 ff ff       	call   80017e <sys_yield>
  801c1b:	eb e2                	jmp    801bff <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801c1d:	50                   	push   %eax
  801c1e:	68 5f 23 80 00       	push   $0x80235f
  801c23:	6a 59                	push   $0x59
  801c25:	68 7a 23 80 00       	push   $0x80237a
  801c2a:	e8 c8 f4 ff ff       	call   8010f7 <_panic>
	}
}
  801c2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c32:	5b                   	pop    %ebx
  801c33:	5e                   	pop    %esi
  801c34:	5f                   	pop    %edi
  801c35:	5d                   	pop    %ebp
  801c36:	c3                   	ret    

00801c37 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c37:	f3 0f 1e fb          	endbr32 
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c41:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c46:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c49:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c4f:	8b 52 50             	mov    0x50(%edx),%edx
  801c52:	39 ca                	cmp    %ecx,%edx
  801c54:	74 11                	je     801c67 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801c56:	83 c0 01             	add    $0x1,%eax
  801c59:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c5e:	75 e6                	jne    801c46 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801c60:	b8 00 00 00 00       	mov    $0x0,%eax
  801c65:	eb 0b                	jmp    801c72 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801c67:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c6a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c6f:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c72:	5d                   	pop    %ebp
  801c73:	c3                   	ret    

00801c74 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c74:	f3 0f 1e fb          	endbr32 
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c7e:	89 c2                	mov    %eax,%edx
  801c80:	c1 ea 16             	shr    $0x16,%edx
  801c83:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c8a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c8f:	f6 c1 01             	test   $0x1,%cl
  801c92:	74 1c                	je     801cb0 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801c94:	c1 e8 0c             	shr    $0xc,%eax
  801c97:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c9e:	a8 01                	test   $0x1,%al
  801ca0:	74 0e                	je     801cb0 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ca2:	c1 e8 0c             	shr    $0xc,%eax
  801ca5:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801cac:	ef 
  801cad:	0f b7 d2             	movzwl %dx,%edx
}
  801cb0:	89 d0                	mov    %edx,%eax
  801cb2:	5d                   	pop    %ebp
  801cb3:	c3                   	ret    
  801cb4:	66 90                	xchg   %ax,%ax
  801cb6:	66 90                	xchg   %ax,%ax
  801cb8:	66 90                	xchg   %ax,%ax
  801cba:	66 90                	xchg   %ax,%ax
  801cbc:	66 90                	xchg   %ax,%ax
  801cbe:	66 90                	xchg   %ax,%ax

00801cc0 <__udivdi3>:
  801cc0:	f3 0f 1e fb          	endbr32 
  801cc4:	55                   	push   %ebp
  801cc5:	57                   	push   %edi
  801cc6:	56                   	push   %esi
  801cc7:	53                   	push   %ebx
  801cc8:	83 ec 1c             	sub    $0x1c,%esp
  801ccb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801ccf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801cd3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cd7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801cdb:	85 d2                	test   %edx,%edx
  801cdd:	75 19                	jne    801cf8 <__udivdi3+0x38>
  801cdf:	39 f3                	cmp    %esi,%ebx
  801ce1:	76 4d                	jbe    801d30 <__udivdi3+0x70>
  801ce3:	31 ff                	xor    %edi,%edi
  801ce5:	89 e8                	mov    %ebp,%eax
  801ce7:	89 f2                	mov    %esi,%edx
  801ce9:	f7 f3                	div    %ebx
  801ceb:	89 fa                	mov    %edi,%edx
  801ced:	83 c4 1c             	add    $0x1c,%esp
  801cf0:	5b                   	pop    %ebx
  801cf1:	5e                   	pop    %esi
  801cf2:	5f                   	pop    %edi
  801cf3:	5d                   	pop    %ebp
  801cf4:	c3                   	ret    
  801cf5:	8d 76 00             	lea    0x0(%esi),%esi
  801cf8:	39 f2                	cmp    %esi,%edx
  801cfa:	76 14                	jbe    801d10 <__udivdi3+0x50>
  801cfc:	31 ff                	xor    %edi,%edi
  801cfe:	31 c0                	xor    %eax,%eax
  801d00:	89 fa                	mov    %edi,%edx
  801d02:	83 c4 1c             	add    $0x1c,%esp
  801d05:	5b                   	pop    %ebx
  801d06:	5e                   	pop    %esi
  801d07:	5f                   	pop    %edi
  801d08:	5d                   	pop    %ebp
  801d09:	c3                   	ret    
  801d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d10:	0f bd fa             	bsr    %edx,%edi
  801d13:	83 f7 1f             	xor    $0x1f,%edi
  801d16:	75 48                	jne    801d60 <__udivdi3+0xa0>
  801d18:	39 f2                	cmp    %esi,%edx
  801d1a:	72 06                	jb     801d22 <__udivdi3+0x62>
  801d1c:	31 c0                	xor    %eax,%eax
  801d1e:	39 eb                	cmp    %ebp,%ebx
  801d20:	77 de                	ja     801d00 <__udivdi3+0x40>
  801d22:	b8 01 00 00 00       	mov    $0x1,%eax
  801d27:	eb d7                	jmp    801d00 <__udivdi3+0x40>
  801d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d30:	89 d9                	mov    %ebx,%ecx
  801d32:	85 db                	test   %ebx,%ebx
  801d34:	75 0b                	jne    801d41 <__udivdi3+0x81>
  801d36:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3b:	31 d2                	xor    %edx,%edx
  801d3d:	f7 f3                	div    %ebx
  801d3f:	89 c1                	mov    %eax,%ecx
  801d41:	31 d2                	xor    %edx,%edx
  801d43:	89 f0                	mov    %esi,%eax
  801d45:	f7 f1                	div    %ecx
  801d47:	89 c6                	mov    %eax,%esi
  801d49:	89 e8                	mov    %ebp,%eax
  801d4b:	89 f7                	mov    %esi,%edi
  801d4d:	f7 f1                	div    %ecx
  801d4f:	89 fa                	mov    %edi,%edx
  801d51:	83 c4 1c             	add    $0x1c,%esp
  801d54:	5b                   	pop    %ebx
  801d55:	5e                   	pop    %esi
  801d56:	5f                   	pop    %edi
  801d57:	5d                   	pop    %ebp
  801d58:	c3                   	ret    
  801d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d60:	89 f9                	mov    %edi,%ecx
  801d62:	b8 20 00 00 00       	mov    $0x20,%eax
  801d67:	29 f8                	sub    %edi,%eax
  801d69:	d3 e2                	shl    %cl,%edx
  801d6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d6f:	89 c1                	mov    %eax,%ecx
  801d71:	89 da                	mov    %ebx,%edx
  801d73:	d3 ea                	shr    %cl,%edx
  801d75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801d79:	09 d1                	or     %edx,%ecx
  801d7b:	89 f2                	mov    %esi,%edx
  801d7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d81:	89 f9                	mov    %edi,%ecx
  801d83:	d3 e3                	shl    %cl,%ebx
  801d85:	89 c1                	mov    %eax,%ecx
  801d87:	d3 ea                	shr    %cl,%edx
  801d89:	89 f9                	mov    %edi,%ecx
  801d8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801d8f:	89 eb                	mov    %ebp,%ebx
  801d91:	d3 e6                	shl    %cl,%esi
  801d93:	89 c1                	mov    %eax,%ecx
  801d95:	d3 eb                	shr    %cl,%ebx
  801d97:	09 de                	or     %ebx,%esi
  801d99:	89 f0                	mov    %esi,%eax
  801d9b:	f7 74 24 08          	divl   0x8(%esp)
  801d9f:	89 d6                	mov    %edx,%esi
  801da1:	89 c3                	mov    %eax,%ebx
  801da3:	f7 64 24 0c          	mull   0xc(%esp)
  801da7:	39 d6                	cmp    %edx,%esi
  801da9:	72 15                	jb     801dc0 <__udivdi3+0x100>
  801dab:	89 f9                	mov    %edi,%ecx
  801dad:	d3 e5                	shl    %cl,%ebp
  801daf:	39 c5                	cmp    %eax,%ebp
  801db1:	73 04                	jae    801db7 <__udivdi3+0xf7>
  801db3:	39 d6                	cmp    %edx,%esi
  801db5:	74 09                	je     801dc0 <__udivdi3+0x100>
  801db7:	89 d8                	mov    %ebx,%eax
  801db9:	31 ff                	xor    %edi,%edi
  801dbb:	e9 40 ff ff ff       	jmp    801d00 <__udivdi3+0x40>
  801dc0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801dc3:	31 ff                	xor    %edi,%edi
  801dc5:	e9 36 ff ff ff       	jmp    801d00 <__udivdi3+0x40>
  801dca:	66 90                	xchg   %ax,%ax
  801dcc:	66 90                	xchg   %ax,%ax
  801dce:	66 90                	xchg   %ax,%ax

00801dd0 <__umoddi3>:
  801dd0:	f3 0f 1e fb          	endbr32 
  801dd4:	55                   	push   %ebp
  801dd5:	57                   	push   %edi
  801dd6:	56                   	push   %esi
  801dd7:	53                   	push   %ebx
  801dd8:	83 ec 1c             	sub    $0x1c,%esp
  801ddb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ddf:	8b 74 24 30          	mov    0x30(%esp),%esi
  801de3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801de7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801deb:	85 c0                	test   %eax,%eax
  801ded:	75 19                	jne    801e08 <__umoddi3+0x38>
  801def:	39 df                	cmp    %ebx,%edi
  801df1:	76 5d                	jbe    801e50 <__umoddi3+0x80>
  801df3:	89 f0                	mov    %esi,%eax
  801df5:	89 da                	mov    %ebx,%edx
  801df7:	f7 f7                	div    %edi
  801df9:	89 d0                	mov    %edx,%eax
  801dfb:	31 d2                	xor    %edx,%edx
  801dfd:	83 c4 1c             	add    $0x1c,%esp
  801e00:	5b                   	pop    %ebx
  801e01:	5e                   	pop    %esi
  801e02:	5f                   	pop    %edi
  801e03:	5d                   	pop    %ebp
  801e04:	c3                   	ret    
  801e05:	8d 76 00             	lea    0x0(%esi),%esi
  801e08:	89 f2                	mov    %esi,%edx
  801e0a:	39 d8                	cmp    %ebx,%eax
  801e0c:	76 12                	jbe    801e20 <__umoddi3+0x50>
  801e0e:	89 f0                	mov    %esi,%eax
  801e10:	89 da                	mov    %ebx,%edx
  801e12:	83 c4 1c             	add    $0x1c,%esp
  801e15:	5b                   	pop    %ebx
  801e16:	5e                   	pop    %esi
  801e17:	5f                   	pop    %edi
  801e18:	5d                   	pop    %ebp
  801e19:	c3                   	ret    
  801e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e20:	0f bd e8             	bsr    %eax,%ebp
  801e23:	83 f5 1f             	xor    $0x1f,%ebp
  801e26:	75 50                	jne    801e78 <__umoddi3+0xa8>
  801e28:	39 d8                	cmp    %ebx,%eax
  801e2a:	0f 82 e0 00 00 00    	jb     801f10 <__umoddi3+0x140>
  801e30:	89 d9                	mov    %ebx,%ecx
  801e32:	39 f7                	cmp    %esi,%edi
  801e34:	0f 86 d6 00 00 00    	jbe    801f10 <__umoddi3+0x140>
  801e3a:	89 d0                	mov    %edx,%eax
  801e3c:	89 ca                	mov    %ecx,%edx
  801e3e:	83 c4 1c             	add    $0x1c,%esp
  801e41:	5b                   	pop    %ebx
  801e42:	5e                   	pop    %esi
  801e43:	5f                   	pop    %edi
  801e44:	5d                   	pop    %ebp
  801e45:	c3                   	ret    
  801e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e4d:	8d 76 00             	lea    0x0(%esi),%esi
  801e50:	89 fd                	mov    %edi,%ebp
  801e52:	85 ff                	test   %edi,%edi
  801e54:	75 0b                	jne    801e61 <__umoddi3+0x91>
  801e56:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5b:	31 d2                	xor    %edx,%edx
  801e5d:	f7 f7                	div    %edi
  801e5f:	89 c5                	mov    %eax,%ebp
  801e61:	89 d8                	mov    %ebx,%eax
  801e63:	31 d2                	xor    %edx,%edx
  801e65:	f7 f5                	div    %ebp
  801e67:	89 f0                	mov    %esi,%eax
  801e69:	f7 f5                	div    %ebp
  801e6b:	89 d0                	mov    %edx,%eax
  801e6d:	31 d2                	xor    %edx,%edx
  801e6f:	eb 8c                	jmp    801dfd <__umoddi3+0x2d>
  801e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e78:	89 e9                	mov    %ebp,%ecx
  801e7a:	ba 20 00 00 00       	mov    $0x20,%edx
  801e7f:	29 ea                	sub    %ebp,%edx
  801e81:	d3 e0                	shl    %cl,%eax
  801e83:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e87:	89 d1                	mov    %edx,%ecx
  801e89:	89 f8                	mov    %edi,%eax
  801e8b:	d3 e8                	shr    %cl,%eax
  801e8d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e91:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e95:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e99:	09 c1                	or     %eax,%ecx
  801e9b:	89 d8                	mov    %ebx,%eax
  801e9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ea1:	89 e9                	mov    %ebp,%ecx
  801ea3:	d3 e7                	shl    %cl,%edi
  801ea5:	89 d1                	mov    %edx,%ecx
  801ea7:	d3 e8                	shr    %cl,%eax
  801ea9:	89 e9                	mov    %ebp,%ecx
  801eab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801eaf:	d3 e3                	shl    %cl,%ebx
  801eb1:	89 c7                	mov    %eax,%edi
  801eb3:	89 d1                	mov    %edx,%ecx
  801eb5:	89 f0                	mov    %esi,%eax
  801eb7:	d3 e8                	shr    %cl,%eax
  801eb9:	89 e9                	mov    %ebp,%ecx
  801ebb:	89 fa                	mov    %edi,%edx
  801ebd:	d3 e6                	shl    %cl,%esi
  801ebf:	09 d8                	or     %ebx,%eax
  801ec1:	f7 74 24 08          	divl   0x8(%esp)
  801ec5:	89 d1                	mov    %edx,%ecx
  801ec7:	89 f3                	mov    %esi,%ebx
  801ec9:	f7 64 24 0c          	mull   0xc(%esp)
  801ecd:	89 c6                	mov    %eax,%esi
  801ecf:	89 d7                	mov    %edx,%edi
  801ed1:	39 d1                	cmp    %edx,%ecx
  801ed3:	72 06                	jb     801edb <__umoddi3+0x10b>
  801ed5:	75 10                	jne    801ee7 <__umoddi3+0x117>
  801ed7:	39 c3                	cmp    %eax,%ebx
  801ed9:	73 0c                	jae    801ee7 <__umoddi3+0x117>
  801edb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801edf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801ee3:	89 d7                	mov    %edx,%edi
  801ee5:	89 c6                	mov    %eax,%esi
  801ee7:	89 ca                	mov    %ecx,%edx
  801ee9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801eee:	29 f3                	sub    %esi,%ebx
  801ef0:	19 fa                	sbb    %edi,%edx
  801ef2:	89 d0                	mov    %edx,%eax
  801ef4:	d3 e0                	shl    %cl,%eax
  801ef6:	89 e9                	mov    %ebp,%ecx
  801ef8:	d3 eb                	shr    %cl,%ebx
  801efa:	d3 ea                	shr    %cl,%edx
  801efc:	09 d8                	or     %ebx,%eax
  801efe:	83 c4 1c             	add    $0x1c,%esp
  801f01:	5b                   	pop    %ebx
  801f02:	5e                   	pop    %esi
  801f03:	5f                   	pop    %edi
  801f04:	5d                   	pop    %ebp
  801f05:	c3                   	ret    
  801f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f0d:	8d 76 00             	lea    0x0(%esi),%esi
  801f10:	29 fe                	sub    %edi,%esi
  801f12:	19 c3                	sbb    %eax,%ebx
  801f14:	89 f2                	mov    %esi,%edx
  801f16:	89 d9                	mov    %ebx,%ecx
  801f18:	e9 1d ff ff ff       	jmp    801e3a <__umoddi3+0x6a>
