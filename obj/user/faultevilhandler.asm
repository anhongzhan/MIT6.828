
obj/user/faultevilhandler.debug:     file format elf32-i386


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
	sys_env_set_pgfault_upcall(0, (void*) 0xF0100020);
  80004b:	83 c4 08             	add    $0x8,%esp
  80004e:	68 20 00 10 f0       	push   $0xf0100020
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
  80008a:	a3 08 40 80 00       	mov    %eax,0x804008

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
  8000bd:	e8 93 05 00 00       	call   800655 <close_all>
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
  80014a:	68 8a 24 80 00       	push   $0x80248a
  80014f:	6a 23                	push   $0x23
  800151:	68 a7 24 80 00       	push   $0x8024a7
  800156:	e8 08 15 00 00       	call   801663 <_panic>

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
  8001d7:	68 8a 24 80 00       	push   $0x80248a
  8001dc:	6a 23                	push   $0x23
  8001de:	68 a7 24 80 00       	push   $0x8024a7
  8001e3:	e8 7b 14 00 00       	call   801663 <_panic>

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
  80021d:	68 8a 24 80 00       	push   $0x80248a
  800222:	6a 23                	push   $0x23
  800224:	68 a7 24 80 00       	push   $0x8024a7
  800229:	e8 35 14 00 00       	call   801663 <_panic>

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
  800263:	68 8a 24 80 00       	push   $0x80248a
  800268:	6a 23                	push   $0x23
  80026a:	68 a7 24 80 00       	push   $0x8024a7
  80026f:	e8 ef 13 00 00       	call   801663 <_panic>

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
  8002a9:	68 8a 24 80 00       	push   $0x80248a
  8002ae:	6a 23                	push   $0x23
  8002b0:	68 a7 24 80 00       	push   $0x8024a7
  8002b5:	e8 a9 13 00 00       	call   801663 <_panic>

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
  8002ef:	68 8a 24 80 00       	push   $0x80248a
  8002f4:	6a 23                	push   $0x23
  8002f6:	68 a7 24 80 00       	push   $0x8024a7
  8002fb:	e8 63 13 00 00       	call   801663 <_panic>

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
  800335:	68 8a 24 80 00       	push   $0x80248a
  80033a:	6a 23                	push   $0x23
  80033c:	68 a7 24 80 00       	push   $0x8024a7
  800341:	e8 1d 13 00 00       	call   801663 <_panic>

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
  8003a1:	68 8a 24 80 00       	push   $0x80248a
  8003a6:	6a 23                	push   $0x23
  8003a8:	68 a7 24 80 00       	push   $0x8024a7
  8003ad:	e8 b1 12 00 00       	call   801663 <_panic>

008003b2 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8003b2:	f3 0f 1e fb          	endbr32 
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	57                   	push   %edi
  8003ba:	56                   	push   %esi
  8003bb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c1:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003c6:	89 d1                	mov    %edx,%ecx
  8003c8:	89 d3                	mov    %edx,%ebx
  8003ca:	89 d7                	mov    %edx,%edi
  8003cc:	89 d6                	mov    %edx,%esi
  8003ce:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003d0:	5b                   	pop    %ebx
  8003d1:	5e                   	pop    %esi
  8003d2:	5f                   	pop    %edi
  8003d3:	5d                   	pop    %ebp
  8003d4:	c3                   	ret    

008003d5 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  8003d5:	f3 0f 1e fb          	endbr32 
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	57                   	push   %edi
  8003dd:	56                   	push   %esi
  8003de:	53                   	push   %ebx
  8003df:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8003e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003ed:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003f2:	89 df                	mov    %ebx,%edi
  8003f4:	89 de                	mov    %ebx,%esi
  8003f6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8003f8:	85 c0                	test   %eax,%eax
  8003fa:	7f 08                	jg     800404 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  8003fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003ff:	5b                   	pop    %ebx
  800400:	5e                   	pop    %esi
  800401:	5f                   	pop    %edi
  800402:	5d                   	pop    %ebp
  800403:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800404:	83 ec 0c             	sub    $0xc,%esp
  800407:	50                   	push   %eax
  800408:	6a 0f                	push   $0xf
  80040a:	68 8a 24 80 00       	push   $0x80248a
  80040f:	6a 23                	push   $0x23
  800411:	68 a7 24 80 00       	push   $0x8024a7
  800416:	e8 48 12 00 00       	call   801663 <_panic>

0080041b <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  80041b:	f3 0f 1e fb          	endbr32 
  80041f:	55                   	push   %ebp
  800420:	89 e5                	mov    %esp,%ebp
  800422:	57                   	push   %edi
  800423:	56                   	push   %esi
  800424:	53                   	push   %ebx
  800425:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800428:	bb 00 00 00 00       	mov    $0x0,%ebx
  80042d:	8b 55 08             	mov    0x8(%ebp),%edx
  800430:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800433:	b8 10 00 00 00       	mov    $0x10,%eax
  800438:	89 df                	mov    %ebx,%edi
  80043a:	89 de                	mov    %ebx,%esi
  80043c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80043e:	85 c0                	test   %eax,%eax
  800440:	7f 08                	jg     80044a <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800442:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800445:	5b                   	pop    %ebx
  800446:	5e                   	pop    %esi
  800447:	5f                   	pop    %edi
  800448:	5d                   	pop    %ebp
  800449:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80044a:	83 ec 0c             	sub    $0xc,%esp
  80044d:	50                   	push   %eax
  80044e:	6a 10                	push   $0x10
  800450:	68 8a 24 80 00       	push   $0x80248a
  800455:	6a 23                	push   $0x23
  800457:	68 a7 24 80 00       	push   $0x8024a7
  80045c:	e8 02 12 00 00       	call   801663 <_panic>

00800461 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800461:	f3 0f 1e fb          	endbr32 
  800465:	55                   	push   %ebp
  800466:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	05 00 00 00 30       	add    $0x30000000,%eax
  800470:	c1 e8 0c             	shr    $0xc,%eax
}
  800473:	5d                   	pop    %ebp
  800474:	c3                   	ret    

00800475 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800475:	f3 0f 1e fb          	endbr32 
  800479:	55                   	push   %ebp
  80047a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80047c:	8b 45 08             	mov    0x8(%ebp),%eax
  80047f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800484:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800489:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80048e:	5d                   	pop    %ebp
  80048f:	c3                   	ret    

00800490 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800490:	f3 0f 1e fb          	endbr32 
  800494:	55                   	push   %ebp
  800495:	89 e5                	mov    %esp,%ebp
  800497:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80049c:	89 c2                	mov    %eax,%edx
  80049e:	c1 ea 16             	shr    $0x16,%edx
  8004a1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8004a8:	f6 c2 01             	test   $0x1,%dl
  8004ab:	74 2d                	je     8004da <fd_alloc+0x4a>
  8004ad:	89 c2                	mov    %eax,%edx
  8004af:	c1 ea 0c             	shr    $0xc,%edx
  8004b2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004b9:	f6 c2 01             	test   $0x1,%dl
  8004bc:	74 1c                	je     8004da <fd_alloc+0x4a>
  8004be:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8004c3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8004c8:	75 d2                	jne    80049c <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8004ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8004d3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8004d8:	eb 0a                	jmp    8004e4 <fd_alloc+0x54>
			*fd_store = fd;
  8004da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004dd:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004e4:	5d                   	pop    %ebp
  8004e5:	c3                   	ret    

008004e6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8004e6:	f3 0f 1e fb          	endbr32 
  8004ea:	55                   	push   %ebp
  8004eb:	89 e5                	mov    %esp,%ebp
  8004ed:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8004f0:	83 f8 1f             	cmp    $0x1f,%eax
  8004f3:	77 30                	ja     800525 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8004f5:	c1 e0 0c             	shl    $0xc,%eax
  8004f8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8004fd:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800503:	f6 c2 01             	test   $0x1,%dl
  800506:	74 24                	je     80052c <fd_lookup+0x46>
  800508:	89 c2                	mov    %eax,%edx
  80050a:	c1 ea 0c             	shr    $0xc,%edx
  80050d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800514:	f6 c2 01             	test   $0x1,%dl
  800517:	74 1a                	je     800533 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800519:	8b 55 0c             	mov    0xc(%ebp),%edx
  80051c:	89 02                	mov    %eax,(%edx)
	return 0;
  80051e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800523:	5d                   	pop    %ebp
  800524:	c3                   	ret    
		return -E_INVAL;
  800525:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80052a:	eb f7                	jmp    800523 <fd_lookup+0x3d>
		return -E_INVAL;
  80052c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800531:	eb f0                	jmp    800523 <fd_lookup+0x3d>
  800533:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800538:	eb e9                	jmp    800523 <fd_lookup+0x3d>

0080053a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80053a:	f3 0f 1e fb          	endbr32 
  80053e:	55                   	push   %ebp
  80053f:	89 e5                	mov    %esp,%ebp
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800547:	ba 00 00 00 00       	mov    $0x0,%edx
  80054c:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800551:	39 08                	cmp    %ecx,(%eax)
  800553:	74 38                	je     80058d <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800555:	83 c2 01             	add    $0x1,%edx
  800558:	8b 04 95 34 25 80 00 	mov    0x802534(,%edx,4),%eax
  80055f:	85 c0                	test   %eax,%eax
  800561:	75 ee                	jne    800551 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800563:	a1 08 40 80 00       	mov    0x804008,%eax
  800568:	8b 40 48             	mov    0x48(%eax),%eax
  80056b:	83 ec 04             	sub    $0x4,%esp
  80056e:	51                   	push   %ecx
  80056f:	50                   	push   %eax
  800570:	68 b8 24 80 00       	push   $0x8024b8
  800575:	e8 d0 11 00 00       	call   80174a <cprintf>
	*dev = 0;
  80057a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80057d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800583:	83 c4 10             	add    $0x10,%esp
  800586:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80058b:	c9                   	leave  
  80058c:	c3                   	ret    
			*dev = devtab[i];
  80058d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800590:	89 01                	mov    %eax,(%ecx)
			return 0;
  800592:	b8 00 00 00 00       	mov    $0x0,%eax
  800597:	eb f2                	jmp    80058b <dev_lookup+0x51>

00800599 <fd_close>:
{
  800599:	f3 0f 1e fb          	endbr32 
  80059d:	55                   	push   %ebp
  80059e:	89 e5                	mov    %esp,%ebp
  8005a0:	57                   	push   %edi
  8005a1:	56                   	push   %esi
  8005a2:	53                   	push   %ebx
  8005a3:	83 ec 24             	sub    $0x24,%esp
  8005a6:	8b 75 08             	mov    0x8(%ebp),%esi
  8005a9:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8005ac:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005af:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8005b0:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8005b6:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8005b9:	50                   	push   %eax
  8005ba:	e8 27 ff ff ff       	call   8004e6 <fd_lookup>
  8005bf:	89 c3                	mov    %eax,%ebx
  8005c1:	83 c4 10             	add    $0x10,%esp
  8005c4:	85 c0                	test   %eax,%eax
  8005c6:	78 05                	js     8005cd <fd_close+0x34>
	    || fd != fd2)
  8005c8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8005cb:	74 16                	je     8005e3 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8005cd:	89 f8                	mov    %edi,%eax
  8005cf:	84 c0                	test   %al,%al
  8005d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d6:	0f 44 d8             	cmove  %eax,%ebx
}
  8005d9:	89 d8                	mov    %ebx,%eax
  8005db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005de:	5b                   	pop    %ebx
  8005df:	5e                   	pop    %esi
  8005e0:	5f                   	pop    %edi
  8005e1:	5d                   	pop    %ebp
  8005e2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8005e3:	83 ec 08             	sub    $0x8,%esp
  8005e6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8005e9:	50                   	push   %eax
  8005ea:	ff 36                	pushl  (%esi)
  8005ec:	e8 49 ff ff ff       	call   80053a <dev_lookup>
  8005f1:	89 c3                	mov    %eax,%ebx
  8005f3:	83 c4 10             	add    $0x10,%esp
  8005f6:	85 c0                	test   %eax,%eax
  8005f8:	78 1a                	js     800614 <fd_close+0x7b>
		if (dev->dev_close)
  8005fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005fd:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800600:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800605:	85 c0                	test   %eax,%eax
  800607:	74 0b                	je     800614 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800609:	83 ec 0c             	sub    $0xc,%esp
  80060c:	56                   	push   %esi
  80060d:	ff d0                	call   *%eax
  80060f:	89 c3                	mov    %eax,%ebx
  800611:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800614:	83 ec 08             	sub    $0x8,%esp
  800617:	56                   	push   %esi
  800618:	6a 00                	push   $0x0
  80061a:	e8 0f fc ff ff       	call   80022e <sys_page_unmap>
	return r;
  80061f:	83 c4 10             	add    $0x10,%esp
  800622:	eb b5                	jmp    8005d9 <fd_close+0x40>

00800624 <close>:

int
close(int fdnum)
{
  800624:	f3 0f 1e fb          	endbr32 
  800628:	55                   	push   %ebp
  800629:	89 e5                	mov    %esp,%ebp
  80062b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80062e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800631:	50                   	push   %eax
  800632:	ff 75 08             	pushl  0x8(%ebp)
  800635:	e8 ac fe ff ff       	call   8004e6 <fd_lookup>
  80063a:	83 c4 10             	add    $0x10,%esp
  80063d:	85 c0                	test   %eax,%eax
  80063f:	79 02                	jns    800643 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800641:	c9                   	leave  
  800642:	c3                   	ret    
		return fd_close(fd, 1);
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	6a 01                	push   $0x1
  800648:	ff 75 f4             	pushl  -0xc(%ebp)
  80064b:	e8 49 ff ff ff       	call   800599 <fd_close>
  800650:	83 c4 10             	add    $0x10,%esp
  800653:	eb ec                	jmp    800641 <close+0x1d>

00800655 <close_all>:

void
close_all(void)
{
  800655:	f3 0f 1e fb          	endbr32 
  800659:	55                   	push   %ebp
  80065a:	89 e5                	mov    %esp,%ebp
  80065c:	53                   	push   %ebx
  80065d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800660:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800665:	83 ec 0c             	sub    $0xc,%esp
  800668:	53                   	push   %ebx
  800669:	e8 b6 ff ff ff       	call   800624 <close>
	for (i = 0; i < MAXFD; i++)
  80066e:	83 c3 01             	add    $0x1,%ebx
  800671:	83 c4 10             	add    $0x10,%esp
  800674:	83 fb 20             	cmp    $0x20,%ebx
  800677:	75 ec                	jne    800665 <close_all+0x10>
}
  800679:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80067e:	f3 0f 1e fb          	endbr32 
  800682:	55                   	push   %ebp
  800683:	89 e5                	mov    %esp,%ebp
  800685:	57                   	push   %edi
  800686:	56                   	push   %esi
  800687:	53                   	push   %ebx
  800688:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80068b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80068e:	50                   	push   %eax
  80068f:	ff 75 08             	pushl  0x8(%ebp)
  800692:	e8 4f fe ff ff       	call   8004e6 <fd_lookup>
  800697:	89 c3                	mov    %eax,%ebx
  800699:	83 c4 10             	add    $0x10,%esp
  80069c:	85 c0                	test   %eax,%eax
  80069e:	0f 88 81 00 00 00    	js     800725 <dup+0xa7>
		return r;
	close(newfdnum);
  8006a4:	83 ec 0c             	sub    $0xc,%esp
  8006a7:	ff 75 0c             	pushl  0xc(%ebp)
  8006aa:	e8 75 ff ff ff       	call   800624 <close>

	newfd = INDEX2FD(newfdnum);
  8006af:	8b 75 0c             	mov    0xc(%ebp),%esi
  8006b2:	c1 e6 0c             	shl    $0xc,%esi
  8006b5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8006bb:	83 c4 04             	add    $0x4,%esp
  8006be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006c1:	e8 af fd ff ff       	call   800475 <fd2data>
  8006c6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8006c8:	89 34 24             	mov    %esi,(%esp)
  8006cb:	e8 a5 fd ff ff       	call   800475 <fd2data>
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8006d5:	89 d8                	mov    %ebx,%eax
  8006d7:	c1 e8 16             	shr    $0x16,%eax
  8006da:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8006e1:	a8 01                	test   $0x1,%al
  8006e3:	74 11                	je     8006f6 <dup+0x78>
  8006e5:	89 d8                	mov    %ebx,%eax
  8006e7:	c1 e8 0c             	shr    $0xc,%eax
  8006ea:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8006f1:	f6 c2 01             	test   $0x1,%dl
  8006f4:	75 39                	jne    80072f <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8006f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006f9:	89 d0                	mov    %edx,%eax
  8006fb:	c1 e8 0c             	shr    $0xc,%eax
  8006fe:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800705:	83 ec 0c             	sub    $0xc,%esp
  800708:	25 07 0e 00 00       	and    $0xe07,%eax
  80070d:	50                   	push   %eax
  80070e:	56                   	push   %esi
  80070f:	6a 00                	push   $0x0
  800711:	52                   	push   %edx
  800712:	6a 00                	push   $0x0
  800714:	e8 cf fa ff ff       	call   8001e8 <sys_page_map>
  800719:	89 c3                	mov    %eax,%ebx
  80071b:	83 c4 20             	add    $0x20,%esp
  80071e:	85 c0                	test   %eax,%eax
  800720:	78 31                	js     800753 <dup+0xd5>
		goto err;

	return newfdnum;
  800722:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800725:	89 d8                	mov    %ebx,%eax
  800727:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80072a:	5b                   	pop    %ebx
  80072b:	5e                   	pop    %esi
  80072c:	5f                   	pop    %edi
  80072d:	5d                   	pop    %ebp
  80072e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80072f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800736:	83 ec 0c             	sub    $0xc,%esp
  800739:	25 07 0e 00 00       	and    $0xe07,%eax
  80073e:	50                   	push   %eax
  80073f:	57                   	push   %edi
  800740:	6a 00                	push   $0x0
  800742:	53                   	push   %ebx
  800743:	6a 00                	push   $0x0
  800745:	e8 9e fa ff ff       	call   8001e8 <sys_page_map>
  80074a:	89 c3                	mov    %eax,%ebx
  80074c:	83 c4 20             	add    $0x20,%esp
  80074f:	85 c0                	test   %eax,%eax
  800751:	79 a3                	jns    8006f6 <dup+0x78>
	sys_page_unmap(0, newfd);
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	56                   	push   %esi
  800757:	6a 00                	push   $0x0
  800759:	e8 d0 fa ff ff       	call   80022e <sys_page_unmap>
	sys_page_unmap(0, nva);
  80075e:	83 c4 08             	add    $0x8,%esp
  800761:	57                   	push   %edi
  800762:	6a 00                	push   $0x0
  800764:	e8 c5 fa ff ff       	call   80022e <sys_page_unmap>
	return r;
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	eb b7                	jmp    800725 <dup+0xa7>

0080076e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80076e:	f3 0f 1e fb          	endbr32 
  800772:	55                   	push   %ebp
  800773:	89 e5                	mov    %esp,%ebp
  800775:	53                   	push   %ebx
  800776:	83 ec 1c             	sub    $0x1c,%esp
  800779:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80077c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80077f:	50                   	push   %eax
  800780:	53                   	push   %ebx
  800781:	e8 60 fd ff ff       	call   8004e6 <fd_lookup>
  800786:	83 c4 10             	add    $0x10,%esp
  800789:	85 c0                	test   %eax,%eax
  80078b:	78 3f                	js     8007cc <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800793:	50                   	push   %eax
  800794:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800797:	ff 30                	pushl  (%eax)
  800799:	e8 9c fd ff ff       	call   80053a <dev_lookup>
  80079e:	83 c4 10             	add    $0x10,%esp
  8007a1:	85 c0                	test   %eax,%eax
  8007a3:	78 27                	js     8007cc <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8007a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8007a8:	8b 42 08             	mov    0x8(%edx),%eax
  8007ab:	83 e0 03             	and    $0x3,%eax
  8007ae:	83 f8 01             	cmp    $0x1,%eax
  8007b1:	74 1e                	je     8007d1 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8007b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007b6:	8b 40 08             	mov    0x8(%eax),%eax
  8007b9:	85 c0                	test   %eax,%eax
  8007bb:	74 35                	je     8007f2 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8007bd:	83 ec 04             	sub    $0x4,%esp
  8007c0:	ff 75 10             	pushl  0x10(%ebp)
  8007c3:	ff 75 0c             	pushl  0xc(%ebp)
  8007c6:	52                   	push   %edx
  8007c7:	ff d0                	call   *%eax
  8007c9:	83 c4 10             	add    $0x10,%esp
}
  8007cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007cf:	c9                   	leave  
  8007d0:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8007d1:	a1 08 40 80 00       	mov    0x804008,%eax
  8007d6:	8b 40 48             	mov    0x48(%eax),%eax
  8007d9:	83 ec 04             	sub    $0x4,%esp
  8007dc:	53                   	push   %ebx
  8007dd:	50                   	push   %eax
  8007de:	68 f9 24 80 00       	push   $0x8024f9
  8007e3:	e8 62 0f 00 00       	call   80174a <cprintf>
		return -E_INVAL;
  8007e8:	83 c4 10             	add    $0x10,%esp
  8007eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007f0:	eb da                	jmp    8007cc <read+0x5e>
		return -E_NOT_SUPP;
  8007f2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007f7:	eb d3                	jmp    8007cc <read+0x5e>

008007f9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8007f9:	f3 0f 1e fb          	endbr32 
  8007fd:	55                   	push   %ebp
  8007fe:	89 e5                	mov    %esp,%ebp
  800800:	57                   	push   %edi
  800801:	56                   	push   %esi
  800802:	53                   	push   %ebx
  800803:	83 ec 0c             	sub    $0xc,%esp
  800806:	8b 7d 08             	mov    0x8(%ebp),%edi
  800809:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80080c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800811:	eb 02                	jmp    800815 <readn+0x1c>
  800813:	01 c3                	add    %eax,%ebx
  800815:	39 f3                	cmp    %esi,%ebx
  800817:	73 21                	jae    80083a <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800819:	83 ec 04             	sub    $0x4,%esp
  80081c:	89 f0                	mov    %esi,%eax
  80081e:	29 d8                	sub    %ebx,%eax
  800820:	50                   	push   %eax
  800821:	89 d8                	mov    %ebx,%eax
  800823:	03 45 0c             	add    0xc(%ebp),%eax
  800826:	50                   	push   %eax
  800827:	57                   	push   %edi
  800828:	e8 41 ff ff ff       	call   80076e <read>
		if (m < 0)
  80082d:	83 c4 10             	add    $0x10,%esp
  800830:	85 c0                	test   %eax,%eax
  800832:	78 04                	js     800838 <readn+0x3f>
			return m;
		if (m == 0)
  800834:	75 dd                	jne    800813 <readn+0x1a>
  800836:	eb 02                	jmp    80083a <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800838:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80083a:	89 d8                	mov    %ebx,%eax
  80083c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80083f:	5b                   	pop    %ebx
  800840:	5e                   	pop    %esi
  800841:	5f                   	pop    %edi
  800842:	5d                   	pop    %ebp
  800843:	c3                   	ret    

00800844 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800844:	f3 0f 1e fb          	endbr32 
  800848:	55                   	push   %ebp
  800849:	89 e5                	mov    %esp,%ebp
  80084b:	53                   	push   %ebx
  80084c:	83 ec 1c             	sub    $0x1c,%esp
  80084f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800852:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800855:	50                   	push   %eax
  800856:	53                   	push   %ebx
  800857:	e8 8a fc ff ff       	call   8004e6 <fd_lookup>
  80085c:	83 c4 10             	add    $0x10,%esp
  80085f:	85 c0                	test   %eax,%eax
  800861:	78 3a                	js     80089d <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800869:	50                   	push   %eax
  80086a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086d:	ff 30                	pushl  (%eax)
  80086f:	e8 c6 fc ff ff       	call   80053a <dev_lookup>
  800874:	83 c4 10             	add    $0x10,%esp
  800877:	85 c0                	test   %eax,%eax
  800879:	78 22                	js     80089d <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80087b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800882:	74 1e                	je     8008a2 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800884:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800887:	8b 52 0c             	mov    0xc(%edx),%edx
  80088a:	85 d2                	test   %edx,%edx
  80088c:	74 35                	je     8008c3 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80088e:	83 ec 04             	sub    $0x4,%esp
  800891:	ff 75 10             	pushl  0x10(%ebp)
  800894:	ff 75 0c             	pushl  0xc(%ebp)
  800897:	50                   	push   %eax
  800898:	ff d2                	call   *%edx
  80089a:	83 c4 10             	add    $0x10,%esp
}
  80089d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a0:	c9                   	leave  
  8008a1:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8008a2:	a1 08 40 80 00       	mov    0x804008,%eax
  8008a7:	8b 40 48             	mov    0x48(%eax),%eax
  8008aa:	83 ec 04             	sub    $0x4,%esp
  8008ad:	53                   	push   %ebx
  8008ae:	50                   	push   %eax
  8008af:	68 15 25 80 00       	push   $0x802515
  8008b4:	e8 91 0e 00 00       	call   80174a <cprintf>
		return -E_INVAL;
  8008b9:	83 c4 10             	add    $0x10,%esp
  8008bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008c1:	eb da                	jmp    80089d <write+0x59>
		return -E_NOT_SUPP;
  8008c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008c8:	eb d3                	jmp    80089d <write+0x59>

008008ca <seek>:

int
seek(int fdnum, off_t offset)
{
  8008ca:	f3 0f 1e fb          	endbr32 
  8008ce:	55                   	push   %ebp
  8008cf:	89 e5                	mov    %esp,%ebp
  8008d1:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8008d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008d7:	50                   	push   %eax
  8008d8:	ff 75 08             	pushl  0x8(%ebp)
  8008db:	e8 06 fc ff ff       	call   8004e6 <fd_lookup>
  8008e0:	83 c4 10             	add    $0x10,%esp
  8008e3:	85 c0                	test   %eax,%eax
  8008e5:	78 0e                	js     8008f5 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8008e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ed:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8008f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008f5:	c9                   	leave  
  8008f6:	c3                   	ret    

008008f7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8008f7:	f3 0f 1e fb          	endbr32 
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	53                   	push   %ebx
  8008ff:	83 ec 1c             	sub    $0x1c,%esp
  800902:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800905:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800908:	50                   	push   %eax
  800909:	53                   	push   %ebx
  80090a:	e8 d7 fb ff ff       	call   8004e6 <fd_lookup>
  80090f:	83 c4 10             	add    $0x10,%esp
  800912:	85 c0                	test   %eax,%eax
  800914:	78 37                	js     80094d <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80091c:	50                   	push   %eax
  80091d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800920:	ff 30                	pushl  (%eax)
  800922:	e8 13 fc ff ff       	call   80053a <dev_lookup>
  800927:	83 c4 10             	add    $0x10,%esp
  80092a:	85 c0                	test   %eax,%eax
  80092c:	78 1f                	js     80094d <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80092e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800931:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800935:	74 1b                	je     800952 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800937:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80093a:	8b 52 18             	mov    0x18(%edx),%edx
  80093d:	85 d2                	test   %edx,%edx
  80093f:	74 32                	je     800973 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800941:	83 ec 08             	sub    $0x8,%esp
  800944:	ff 75 0c             	pushl  0xc(%ebp)
  800947:	50                   	push   %eax
  800948:	ff d2                	call   *%edx
  80094a:	83 c4 10             	add    $0x10,%esp
}
  80094d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800950:	c9                   	leave  
  800951:	c3                   	ret    
			thisenv->env_id, fdnum);
  800952:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800957:	8b 40 48             	mov    0x48(%eax),%eax
  80095a:	83 ec 04             	sub    $0x4,%esp
  80095d:	53                   	push   %ebx
  80095e:	50                   	push   %eax
  80095f:	68 d8 24 80 00       	push   $0x8024d8
  800964:	e8 e1 0d 00 00       	call   80174a <cprintf>
		return -E_INVAL;
  800969:	83 c4 10             	add    $0x10,%esp
  80096c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800971:	eb da                	jmp    80094d <ftruncate+0x56>
		return -E_NOT_SUPP;
  800973:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800978:	eb d3                	jmp    80094d <ftruncate+0x56>

0080097a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80097a:	f3 0f 1e fb          	endbr32 
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	53                   	push   %ebx
  800982:	83 ec 1c             	sub    $0x1c,%esp
  800985:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800988:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80098b:	50                   	push   %eax
  80098c:	ff 75 08             	pushl  0x8(%ebp)
  80098f:	e8 52 fb ff ff       	call   8004e6 <fd_lookup>
  800994:	83 c4 10             	add    $0x10,%esp
  800997:	85 c0                	test   %eax,%eax
  800999:	78 4b                	js     8009e6 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80099b:	83 ec 08             	sub    $0x8,%esp
  80099e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009a1:	50                   	push   %eax
  8009a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a5:	ff 30                	pushl  (%eax)
  8009a7:	e8 8e fb ff ff       	call   80053a <dev_lookup>
  8009ac:	83 c4 10             	add    $0x10,%esp
  8009af:	85 c0                	test   %eax,%eax
  8009b1:	78 33                	js     8009e6 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8009b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009b6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8009ba:	74 2f                	je     8009eb <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8009bc:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8009bf:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8009c6:	00 00 00 
	stat->st_isdir = 0;
  8009c9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8009d0:	00 00 00 
	stat->st_dev = dev;
  8009d3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8009d9:	83 ec 08             	sub    $0x8,%esp
  8009dc:	53                   	push   %ebx
  8009dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8009e0:	ff 50 14             	call   *0x14(%eax)
  8009e3:	83 c4 10             	add    $0x10,%esp
}
  8009e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e9:	c9                   	leave  
  8009ea:	c3                   	ret    
		return -E_NOT_SUPP;
  8009eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8009f0:	eb f4                	jmp    8009e6 <fstat+0x6c>

008009f2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8009f2:	f3 0f 1e fb          	endbr32 
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	56                   	push   %esi
  8009fa:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	6a 00                	push   $0x0
  800a00:	ff 75 08             	pushl  0x8(%ebp)
  800a03:	e8 fb 01 00 00       	call   800c03 <open>
  800a08:	89 c3                	mov    %eax,%ebx
  800a0a:	83 c4 10             	add    $0x10,%esp
  800a0d:	85 c0                	test   %eax,%eax
  800a0f:	78 1b                	js     800a2c <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  800a11:	83 ec 08             	sub    $0x8,%esp
  800a14:	ff 75 0c             	pushl  0xc(%ebp)
  800a17:	50                   	push   %eax
  800a18:	e8 5d ff ff ff       	call   80097a <fstat>
  800a1d:	89 c6                	mov    %eax,%esi
	close(fd);
  800a1f:	89 1c 24             	mov    %ebx,(%esp)
  800a22:	e8 fd fb ff ff       	call   800624 <close>
	return r;
  800a27:	83 c4 10             	add    $0x10,%esp
  800a2a:	89 f3                	mov    %esi,%ebx
}
  800a2c:	89 d8                	mov    %ebx,%eax
  800a2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a31:	5b                   	pop    %ebx
  800a32:	5e                   	pop    %esi
  800a33:	5d                   	pop    %ebp
  800a34:	c3                   	ret    

00800a35 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	56                   	push   %esi
  800a39:	53                   	push   %ebx
  800a3a:	89 c6                	mov    %eax,%esi
  800a3c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800a3e:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800a45:	74 27                	je     800a6e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800a47:	6a 07                	push   $0x7
  800a49:	68 00 50 80 00       	push   $0x805000
  800a4e:	56                   	push   %esi
  800a4f:	ff 35 00 40 80 00    	pushl  0x804000
  800a55:	e8 f1 16 00 00       	call   80214b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800a5a:	83 c4 0c             	add    $0xc,%esp
  800a5d:	6a 00                	push   $0x0
  800a5f:	53                   	push   %ebx
  800a60:	6a 00                	push   $0x0
  800a62:	e8 5f 16 00 00       	call   8020c6 <ipc_recv>
}
  800a67:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a6a:	5b                   	pop    %ebx
  800a6b:	5e                   	pop    %esi
  800a6c:	5d                   	pop    %ebp
  800a6d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800a6e:	83 ec 0c             	sub    $0xc,%esp
  800a71:	6a 01                	push   $0x1
  800a73:	e8 2b 17 00 00       	call   8021a3 <ipc_find_env>
  800a78:	a3 00 40 80 00       	mov    %eax,0x804000
  800a7d:	83 c4 10             	add    $0x10,%esp
  800a80:	eb c5                	jmp    800a47 <fsipc+0x12>

00800a82 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800a82:	f3 0f 1e fb          	endbr32 
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	8b 40 0c             	mov    0xc(%eax),%eax
  800a92:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800a97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9a:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800a9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa4:	b8 02 00 00 00       	mov    $0x2,%eax
  800aa9:	e8 87 ff ff ff       	call   800a35 <fsipc>
}
  800aae:	c9                   	leave  
  800aaf:	c3                   	ret    

00800ab0 <devfile_flush>:
{
  800ab0:	f3 0f 1e fb          	endbr32 
  800ab4:	55                   	push   %ebp
  800ab5:	89 e5                	mov    %esp,%ebp
  800ab7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	8b 40 0c             	mov    0xc(%eax),%eax
  800ac0:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800ac5:	ba 00 00 00 00       	mov    $0x0,%edx
  800aca:	b8 06 00 00 00       	mov    $0x6,%eax
  800acf:	e8 61 ff ff ff       	call   800a35 <fsipc>
}
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    

00800ad6 <devfile_stat>:
{
  800ad6:	f3 0f 1e fb          	endbr32 
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	53                   	push   %ebx
  800ade:	83 ec 04             	sub    $0x4,%esp
  800ae1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae7:	8b 40 0c             	mov    0xc(%eax),%eax
  800aea:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800aef:	ba 00 00 00 00       	mov    $0x0,%edx
  800af4:	b8 05 00 00 00       	mov    $0x5,%eax
  800af9:	e8 37 ff ff ff       	call   800a35 <fsipc>
  800afe:	85 c0                	test   %eax,%eax
  800b00:	78 2c                	js     800b2e <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800b02:	83 ec 08             	sub    $0x8,%esp
  800b05:	68 00 50 80 00       	push   $0x805000
  800b0a:	53                   	push   %ebx
  800b0b:	e8 44 12 00 00       	call   801d54 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800b10:	a1 80 50 80 00       	mov    0x805080,%eax
  800b15:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800b1b:	a1 84 50 80 00       	mov    0x805084,%eax
  800b20:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800b26:	83 c4 10             	add    $0x10,%esp
  800b29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b31:	c9                   	leave  
  800b32:	c3                   	ret    

00800b33 <devfile_write>:
{
  800b33:	f3 0f 1e fb          	endbr32 
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	83 ec 0c             	sub    $0xc,%esp
  800b3d:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800b40:	8b 55 08             	mov    0x8(%ebp),%edx
  800b43:	8b 52 0c             	mov    0xc(%edx),%edx
  800b46:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  800b4c:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800b51:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800b56:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  800b59:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800b5e:	50                   	push   %eax
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	68 08 50 80 00       	push   $0x805008
  800b67:	e8 9e 13 00 00       	call   801f0a <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800b6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b71:	b8 04 00 00 00       	mov    $0x4,%eax
  800b76:	e8 ba fe ff ff       	call   800a35 <fsipc>
}
  800b7b:	c9                   	leave  
  800b7c:	c3                   	ret    

00800b7d <devfile_read>:
{
  800b7d:	f3 0f 1e fb          	endbr32 
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	56                   	push   %esi
  800b85:	53                   	push   %ebx
  800b86:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	8b 40 0c             	mov    0xc(%eax),%eax
  800b8f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b94:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9f:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba4:	e8 8c fe ff ff       	call   800a35 <fsipc>
  800ba9:	89 c3                	mov    %eax,%ebx
  800bab:	85 c0                	test   %eax,%eax
  800bad:	78 1f                	js     800bce <devfile_read+0x51>
	assert(r <= n);
  800baf:	39 f0                	cmp    %esi,%eax
  800bb1:	77 24                	ja     800bd7 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800bb3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800bb8:	7f 33                	jg     800bed <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800bba:	83 ec 04             	sub    $0x4,%esp
  800bbd:	50                   	push   %eax
  800bbe:	68 00 50 80 00       	push   $0x805000
  800bc3:	ff 75 0c             	pushl  0xc(%ebp)
  800bc6:	e8 3f 13 00 00       	call   801f0a <memmove>
	return r;
  800bcb:	83 c4 10             	add    $0x10,%esp
}
  800bce:	89 d8                	mov    %ebx,%eax
  800bd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bd3:	5b                   	pop    %ebx
  800bd4:	5e                   	pop    %esi
  800bd5:	5d                   	pop    %ebp
  800bd6:	c3                   	ret    
	assert(r <= n);
  800bd7:	68 48 25 80 00       	push   $0x802548
  800bdc:	68 4f 25 80 00       	push   $0x80254f
  800be1:	6a 7c                	push   $0x7c
  800be3:	68 64 25 80 00       	push   $0x802564
  800be8:	e8 76 0a 00 00       	call   801663 <_panic>
	assert(r <= PGSIZE);
  800bed:	68 6f 25 80 00       	push   $0x80256f
  800bf2:	68 4f 25 80 00       	push   $0x80254f
  800bf7:	6a 7d                	push   $0x7d
  800bf9:	68 64 25 80 00       	push   $0x802564
  800bfe:	e8 60 0a 00 00       	call   801663 <_panic>

00800c03 <open>:
{
  800c03:	f3 0f 1e fb          	endbr32 
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	56                   	push   %esi
  800c0b:	53                   	push   %ebx
  800c0c:	83 ec 1c             	sub    $0x1c,%esp
  800c0f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800c12:	56                   	push   %esi
  800c13:	e8 f9 10 00 00       	call   801d11 <strlen>
  800c18:	83 c4 10             	add    $0x10,%esp
  800c1b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800c20:	7f 6c                	jg     800c8e <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800c22:	83 ec 0c             	sub    $0xc,%esp
  800c25:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c28:	50                   	push   %eax
  800c29:	e8 62 f8 ff ff       	call   800490 <fd_alloc>
  800c2e:	89 c3                	mov    %eax,%ebx
  800c30:	83 c4 10             	add    $0x10,%esp
  800c33:	85 c0                	test   %eax,%eax
  800c35:	78 3c                	js     800c73 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800c37:	83 ec 08             	sub    $0x8,%esp
  800c3a:	56                   	push   %esi
  800c3b:	68 00 50 80 00       	push   $0x805000
  800c40:	e8 0f 11 00 00       	call   801d54 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800c45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c48:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800c4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c50:	b8 01 00 00 00       	mov    $0x1,%eax
  800c55:	e8 db fd ff ff       	call   800a35 <fsipc>
  800c5a:	89 c3                	mov    %eax,%ebx
  800c5c:	83 c4 10             	add    $0x10,%esp
  800c5f:	85 c0                	test   %eax,%eax
  800c61:	78 19                	js     800c7c <open+0x79>
	return fd2num(fd);
  800c63:	83 ec 0c             	sub    $0xc,%esp
  800c66:	ff 75 f4             	pushl  -0xc(%ebp)
  800c69:	e8 f3 f7 ff ff       	call   800461 <fd2num>
  800c6e:	89 c3                	mov    %eax,%ebx
  800c70:	83 c4 10             	add    $0x10,%esp
}
  800c73:	89 d8                	mov    %ebx,%eax
  800c75:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c78:	5b                   	pop    %ebx
  800c79:	5e                   	pop    %esi
  800c7a:	5d                   	pop    %ebp
  800c7b:	c3                   	ret    
		fd_close(fd, 0);
  800c7c:	83 ec 08             	sub    $0x8,%esp
  800c7f:	6a 00                	push   $0x0
  800c81:	ff 75 f4             	pushl  -0xc(%ebp)
  800c84:	e8 10 f9 ff ff       	call   800599 <fd_close>
		return r;
  800c89:	83 c4 10             	add    $0x10,%esp
  800c8c:	eb e5                	jmp    800c73 <open+0x70>
		return -E_BAD_PATH;
  800c8e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800c93:	eb de                	jmp    800c73 <open+0x70>

00800c95 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800c95:	f3 0f 1e fb          	endbr32 
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca4:	b8 08 00 00 00       	mov    $0x8,%eax
  800ca9:	e8 87 fd ff ff       	call   800a35 <fsipc>
}
  800cae:	c9                   	leave  
  800caf:	c3                   	ret    

00800cb0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800cb0:	f3 0f 1e fb          	endbr32 
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800cba:	68 7b 25 80 00       	push   $0x80257b
  800cbf:	ff 75 0c             	pushl  0xc(%ebp)
  800cc2:	e8 8d 10 00 00       	call   801d54 <strcpy>
	return 0;
}
  800cc7:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccc:	c9                   	leave  
  800ccd:	c3                   	ret    

00800cce <devsock_close>:
{
  800cce:	f3 0f 1e fb          	endbr32 
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	53                   	push   %ebx
  800cd6:	83 ec 10             	sub    $0x10,%esp
  800cd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800cdc:	53                   	push   %ebx
  800cdd:	e8 fe 14 00 00       	call   8021e0 <pageref>
  800ce2:	89 c2                	mov    %eax,%edx
  800ce4:	83 c4 10             	add    $0x10,%esp
		return 0;
  800ce7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  800cec:	83 fa 01             	cmp    $0x1,%edx
  800cef:	74 05                	je     800cf6 <devsock_close+0x28>
}
  800cf1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cf4:	c9                   	leave  
  800cf5:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800cf6:	83 ec 0c             	sub    $0xc,%esp
  800cf9:	ff 73 0c             	pushl  0xc(%ebx)
  800cfc:	e8 e3 02 00 00       	call   800fe4 <nsipc_close>
  800d01:	83 c4 10             	add    $0x10,%esp
  800d04:	eb eb                	jmp    800cf1 <devsock_close+0x23>

00800d06 <devsock_write>:
{
  800d06:	f3 0f 1e fb          	endbr32 
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
  800d0d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800d10:	6a 00                	push   $0x0
  800d12:	ff 75 10             	pushl  0x10(%ebp)
  800d15:	ff 75 0c             	pushl  0xc(%ebp)
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	ff 70 0c             	pushl  0xc(%eax)
  800d1e:	e8 b5 03 00 00       	call   8010d8 <nsipc_send>
}
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <devsock_read>:
{
  800d25:	f3 0f 1e fb          	endbr32 
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800d2f:	6a 00                	push   $0x0
  800d31:	ff 75 10             	pushl  0x10(%ebp)
  800d34:	ff 75 0c             	pushl  0xc(%ebp)
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	ff 70 0c             	pushl  0xc(%eax)
  800d3d:	e8 1f 03 00 00       	call   801061 <nsipc_recv>
}
  800d42:	c9                   	leave  
  800d43:	c3                   	ret    

00800d44 <fd2sockid>:
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800d4a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800d4d:	52                   	push   %edx
  800d4e:	50                   	push   %eax
  800d4f:	e8 92 f7 ff ff       	call   8004e6 <fd_lookup>
  800d54:	83 c4 10             	add    $0x10,%esp
  800d57:	85 c0                	test   %eax,%eax
  800d59:	78 10                	js     800d6b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d5e:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800d64:	39 08                	cmp    %ecx,(%eax)
  800d66:	75 05                	jne    800d6d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800d68:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800d6b:	c9                   	leave  
  800d6c:	c3                   	ret    
		return -E_NOT_SUPP;
  800d6d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800d72:	eb f7                	jmp    800d6b <fd2sockid+0x27>

00800d74 <alloc_sockfd>:
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	56                   	push   %esi
  800d78:	53                   	push   %ebx
  800d79:	83 ec 1c             	sub    $0x1c,%esp
  800d7c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800d7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d81:	50                   	push   %eax
  800d82:	e8 09 f7 ff ff       	call   800490 <fd_alloc>
  800d87:	89 c3                	mov    %eax,%ebx
  800d89:	83 c4 10             	add    $0x10,%esp
  800d8c:	85 c0                	test   %eax,%eax
  800d8e:	78 43                	js     800dd3 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800d90:	83 ec 04             	sub    $0x4,%esp
  800d93:	68 07 04 00 00       	push   $0x407
  800d98:	ff 75 f4             	pushl  -0xc(%ebp)
  800d9b:	6a 00                	push   $0x0
  800d9d:	e8 ff f3 ff ff       	call   8001a1 <sys_page_alloc>
  800da2:	89 c3                	mov    %eax,%ebx
  800da4:	83 c4 10             	add    $0x10,%esp
  800da7:	85 c0                	test   %eax,%eax
  800da9:	78 28                	js     800dd3 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dae:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800db4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800db9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800dc0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800dc3:	83 ec 0c             	sub    $0xc,%esp
  800dc6:	50                   	push   %eax
  800dc7:	e8 95 f6 ff ff       	call   800461 <fd2num>
  800dcc:	89 c3                	mov    %eax,%ebx
  800dce:	83 c4 10             	add    $0x10,%esp
  800dd1:	eb 0c                	jmp    800ddf <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800dd3:	83 ec 0c             	sub    $0xc,%esp
  800dd6:	56                   	push   %esi
  800dd7:	e8 08 02 00 00       	call   800fe4 <nsipc_close>
		return r;
  800ddc:	83 c4 10             	add    $0x10,%esp
}
  800ddf:	89 d8                	mov    %ebx,%eax
  800de1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800de4:	5b                   	pop    %ebx
  800de5:	5e                   	pop    %esi
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <accept>:
{
  800de8:	f3 0f 1e fb          	endbr32 
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	e8 4a ff ff ff       	call   800d44 <fd2sockid>
  800dfa:	85 c0                	test   %eax,%eax
  800dfc:	78 1b                	js     800e19 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800dfe:	83 ec 04             	sub    $0x4,%esp
  800e01:	ff 75 10             	pushl  0x10(%ebp)
  800e04:	ff 75 0c             	pushl  0xc(%ebp)
  800e07:	50                   	push   %eax
  800e08:	e8 22 01 00 00       	call   800f2f <nsipc_accept>
  800e0d:	83 c4 10             	add    $0x10,%esp
  800e10:	85 c0                	test   %eax,%eax
  800e12:	78 05                	js     800e19 <accept+0x31>
	return alloc_sockfd(r);
  800e14:	e8 5b ff ff ff       	call   800d74 <alloc_sockfd>
}
  800e19:	c9                   	leave  
  800e1a:	c3                   	ret    

00800e1b <bind>:
{
  800e1b:	f3 0f 1e fb          	endbr32 
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	e8 17 ff ff ff       	call   800d44 <fd2sockid>
  800e2d:	85 c0                	test   %eax,%eax
  800e2f:	78 12                	js     800e43 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  800e31:	83 ec 04             	sub    $0x4,%esp
  800e34:	ff 75 10             	pushl  0x10(%ebp)
  800e37:	ff 75 0c             	pushl  0xc(%ebp)
  800e3a:	50                   	push   %eax
  800e3b:	e8 45 01 00 00       	call   800f85 <nsipc_bind>
  800e40:	83 c4 10             	add    $0x10,%esp
}
  800e43:	c9                   	leave  
  800e44:	c3                   	ret    

00800e45 <shutdown>:
{
  800e45:	f3 0f 1e fb          	endbr32 
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	e8 ed fe ff ff       	call   800d44 <fd2sockid>
  800e57:	85 c0                	test   %eax,%eax
  800e59:	78 0f                	js     800e6a <shutdown+0x25>
	return nsipc_shutdown(r, how);
  800e5b:	83 ec 08             	sub    $0x8,%esp
  800e5e:	ff 75 0c             	pushl  0xc(%ebp)
  800e61:	50                   	push   %eax
  800e62:	e8 57 01 00 00       	call   800fbe <nsipc_shutdown>
  800e67:	83 c4 10             	add    $0x10,%esp
}
  800e6a:	c9                   	leave  
  800e6b:	c3                   	ret    

00800e6c <connect>:
{
  800e6c:	f3 0f 1e fb          	endbr32 
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	e8 c6 fe ff ff       	call   800d44 <fd2sockid>
  800e7e:	85 c0                	test   %eax,%eax
  800e80:	78 12                	js     800e94 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  800e82:	83 ec 04             	sub    $0x4,%esp
  800e85:	ff 75 10             	pushl  0x10(%ebp)
  800e88:	ff 75 0c             	pushl  0xc(%ebp)
  800e8b:	50                   	push   %eax
  800e8c:	e8 71 01 00 00       	call   801002 <nsipc_connect>
  800e91:	83 c4 10             	add    $0x10,%esp
}
  800e94:	c9                   	leave  
  800e95:	c3                   	ret    

00800e96 <listen>:
{
  800e96:	f3 0f 1e fb          	endbr32 
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	e8 9c fe ff ff       	call   800d44 <fd2sockid>
  800ea8:	85 c0                	test   %eax,%eax
  800eaa:	78 0f                	js     800ebb <listen+0x25>
	return nsipc_listen(r, backlog);
  800eac:	83 ec 08             	sub    $0x8,%esp
  800eaf:	ff 75 0c             	pushl  0xc(%ebp)
  800eb2:	50                   	push   %eax
  800eb3:	e8 83 01 00 00       	call   80103b <nsipc_listen>
  800eb8:	83 c4 10             	add    $0x10,%esp
}
  800ebb:	c9                   	leave  
  800ebc:	c3                   	ret    

00800ebd <socket>:

int
socket(int domain, int type, int protocol)
{
  800ebd:	f3 0f 1e fb          	endbr32 
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800ec7:	ff 75 10             	pushl  0x10(%ebp)
  800eca:	ff 75 0c             	pushl  0xc(%ebp)
  800ecd:	ff 75 08             	pushl  0x8(%ebp)
  800ed0:	e8 65 02 00 00       	call   80113a <nsipc_socket>
  800ed5:	83 c4 10             	add    $0x10,%esp
  800ed8:	85 c0                	test   %eax,%eax
  800eda:	78 05                	js     800ee1 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  800edc:	e8 93 fe ff ff       	call   800d74 <alloc_sockfd>
}
  800ee1:	c9                   	leave  
  800ee2:	c3                   	ret    

00800ee3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	53                   	push   %ebx
  800ee7:	83 ec 04             	sub    $0x4,%esp
  800eea:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800eec:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800ef3:	74 26                	je     800f1b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800ef5:	6a 07                	push   $0x7
  800ef7:	68 00 60 80 00       	push   $0x806000
  800efc:	53                   	push   %ebx
  800efd:	ff 35 04 40 80 00    	pushl  0x804004
  800f03:	e8 43 12 00 00       	call   80214b <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800f08:	83 c4 0c             	add    $0xc,%esp
  800f0b:	6a 00                	push   $0x0
  800f0d:	6a 00                	push   $0x0
  800f0f:	6a 00                	push   $0x0
  800f11:	e8 b0 11 00 00       	call   8020c6 <ipc_recv>
}
  800f16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f19:	c9                   	leave  
  800f1a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800f1b:	83 ec 0c             	sub    $0xc,%esp
  800f1e:	6a 02                	push   $0x2
  800f20:	e8 7e 12 00 00       	call   8021a3 <ipc_find_env>
  800f25:	a3 04 40 80 00       	mov    %eax,0x804004
  800f2a:	83 c4 10             	add    $0x10,%esp
  800f2d:	eb c6                	jmp    800ef5 <nsipc+0x12>

00800f2f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800f2f:	f3 0f 1e fb          	endbr32 
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	56                   	push   %esi
  800f37:	53                   	push   %ebx
  800f38:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800f43:	8b 06                	mov    (%esi),%eax
  800f45:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800f4a:	b8 01 00 00 00       	mov    $0x1,%eax
  800f4f:	e8 8f ff ff ff       	call   800ee3 <nsipc>
  800f54:	89 c3                	mov    %eax,%ebx
  800f56:	85 c0                	test   %eax,%eax
  800f58:	79 09                	jns    800f63 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  800f5a:	89 d8                	mov    %ebx,%eax
  800f5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f5f:	5b                   	pop    %ebx
  800f60:	5e                   	pop    %esi
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800f63:	83 ec 04             	sub    $0x4,%esp
  800f66:	ff 35 10 60 80 00    	pushl  0x806010
  800f6c:	68 00 60 80 00       	push   $0x806000
  800f71:	ff 75 0c             	pushl  0xc(%ebp)
  800f74:	e8 91 0f 00 00       	call   801f0a <memmove>
		*addrlen = ret->ret_addrlen;
  800f79:	a1 10 60 80 00       	mov    0x806010,%eax
  800f7e:	89 06                	mov    %eax,(%esi)
  800f80:	83 c4 10             	add    $0x10,%esp
	return r;
  800f83:	eb d5                	jmp    800f5a <nsipc_accept+0x2b>

00800f85 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800f85:	f3 0f 1e fb          	endbr32 
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	53                   	push   %ebx
  800f8d:	83 ec 08             	sub    $0x8,%esp
  800f90:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800f9b:	53                   	push   %ebx
  800f9c:	ff 75 0c             	pushl  0xc(%ebp)
  800f9f:	68 04 60 80 00       	push   $0x806004
  800fa4:	e8 61 0f 00 00       	call   801f0a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800fa9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800faf:	b8 02 00 00 00       	mov    $0x2,%eax
  800fb4:	e8 2a ff ff ff       	call   800ee3 <nsipc>
}
  800fb9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fbc:	c9                   	leave  
  800fbd:	c3                   	ret    

00800fbe <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800fbe:	f3 0f 1e fb          	endbr32 
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd3:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800fd8:	b8 03 00 00 00       	mov    $0x3,%eax
  800fdd:	e8 01 ff ff ff       	call   800ee3 <nsipc>
}
  800fe2:	c9                   	leave  
  800fe3:	c3                   	ret    

00800fe4 <nsipc_close>:

int
nsipc_close(int s)
{
  800fe4:	f3 0f 1e fb          	endbr32 
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800ff6:	b8 04 00 00 00       	mov    $0x4,%eax
  800ffb:	e8 e3 fe ff ff       	call   800ee3 <nsipc>
}
  801000:	c9                   	leave  
  801001:	c3                   	ret    

00801002 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801002:	f3 0f 1e fb          	endbr32 
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	53                   	push   %ebx
  80100a:	83 ec 08             	sub    $0x8,%esp
  80100d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801018:	53                   	push   %ebx
  801019:	ff 75 0c             	pushl  0xc(%ebp)
  80101c:	68 04 60 80 00       	push   $0x806004
  801021:	e8 e4 0e 00 00       	call   801f0a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801026:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80102c:	b8 05 00 00 00       	mov    $0x5,%eax
  801031:	e8 ad fe ff ff       	call   800ee3 <nsipc>
}
  801036:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801039:	c9                   	leave  
  80103a:	c3                   	ret    

0080103b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80103b:	f3 0f 1e fb          	endbr32 
  80103f:	55                   	push   %ebp
  801040:	89 e5                	mov    %esp,%ebp
  801042:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80104d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801050:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801055:	b8 06 00 00 00       	mov    $0x6,%eax
  80105a:	e8 84 fe ff ff       	call   800ee3 <nsipc>
}
  80105f:	c9                   	leave  
  801060:	c3                   	ret    

00801061 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801061:	f3 0f 1e fb          	endbr32 
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	56                   	push   %esi
  801069:	53                   	push   %ebx
  80106a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801075:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80107b:	8b 45 14             	mov    0x14(%ebp),%eax
  80107e:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801083:	b8 07 00 00 00       	mov    $0x7,%eax
  801088:	e8 56 fe ff ff       	call   800ee3 <nsipc>
  80108d:	89 c3                	mov    %eax,%ebx
  80108f:	85 c0                	test   %eax,%eax
  801091:	78 26                	js     8010b9 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801093:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801099:	b8 3f 06 00 00       	mov    $0x63f,%eax
  80109e:	0f 4e c6             	cmovle %esi,%eax
  8010a1:	39 c3                	cmp    %eax,%ebx
  8010a3:	7f 1d                	jg     8010c2 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8010a5:	83 ec 04             	sub    $0x4,%esp
  8010a8:	53                   	push   %ebx
  8010a9:	68 00 60 80 00       	push   $0x806000
  8010ae:	ff 75 0c             	pushl  0xc(%ebp)
  8010b1:	e8 54 0e 00 00       	call   801f0a <memmove>
  8010b6:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8010b9:	89 d8                	mov    %ebx,%eax
  8010bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010be:	5b                   	pop    %ebx
  8010bf:	5e                   	pop    %esi
  8010c0:	5d                   	pop    %ebp
  8010c1:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8010c2:	68 87 25 80 00       	push   $0x802587
  8010c7:	68 4f 25 80 00       	push   $0x80254f
  8010cc:	6a 62                	push   $0x62
  8010ce:	68 9c 25 80 00       	push   $0x80259c
  8010d3:	e8 8b 05 00 00       	call   801663 <_panic>

008010d8 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8010d8:	f3 0f 1e fb          	endbr32 
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	53                   	push   %ebx
  8010e0:	83 ec 04             	sub    $0x4,%esp
  8010e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8010ee:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8010f4:	7f 2e                	jg     801124 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8010f6:	83 ec 04             	sub    $0x4,%esp
  8010f9:	53                   	push   %ebx
  8010fa:	ff 75 0c             	pushl  0xc(%ebp)
  8010fd:	68 0c 60 80 00       	push   $0x80600c
  801102:	e8 03 0e 00 00       	call   801f0a <memmove>
	nsipcbuf.send.req_size = size;
  801107:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80110d:	8b 45 14             	mov    0x14(%ebp),%eax
  801110:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801115:	b8 08 00 00 00       	mov    $0x8,%eax
  80111a:	e8 c4 fd ff ff       	call   800ee3 <nsipc>
}
  80111f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801122:	c9                   	leave  
  801123:	c3                   	ret    
	assert(size < 1600);
  801124:	68 a8 25 80 00       	push   $0x8025a8
  801129:	68 4f 25 80 00       	push   $0x80254f
  80112e:	6a 6d                	push   $0x6d
  801130:	68 9c 25 80 00       	push   $0x80259c
  801135:	e8 29 05 00 00       	call   801663 <_panic>

0080113a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80113a:	f3 0f 1e fb          	endbr32 
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
  801141:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80114c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801154:	8b 45 10             	mov    0x10(%ebp),%eax
  801157:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80115c:	b8 09 00 00 00       	mov    $0x9,%eax
  801161:	e8 7d fd ff ff       	call   800ee3 <nsipc>
}
  801166:	c9                   	leave  
  801167:	c3                   	ret    

00801168 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801168:	f3 0f 1e fb          	endbr32 
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	56                   	push   %esi
  801170:	53                   	push   %ebx
  801171:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801174:	83 ec 0c             	sub    $0xc,%esp
  801177:	ff 75 08             	pushl  0x8(%ebp)
  80117a:	e8 f6 f2 ff ff       	call   800475 <fd2data>
  80117f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801181:	83 c4 08             	add    $0x8,%esp
  801184:	68 b4 25 80 00       	push   $0x8025b4
  801189:	53                   	push   %ebx
  80118a:	e8 c5 0b 00 00       	call   801d54 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80118f:	8b 46 04             	mov    0x4(%esi),%eax
  801192:	2b 06                	sub    (%esi),%eax
  801194:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80119a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8011a1:	00 00 00 
	stat->st_dev = &devpipe;
  8011a4:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  8011ab:	30 80 00 
	return 0;
}
  8011ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011b6:	5b                   	pop    %ebx
  8011b7:	5e                   	pop    %esi
  8011b8:	5d                   	pop    %ebp
  8011b9:	c3                   	ret    

008011ba <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8011ba:	f3 0f 1e fb          	endbr32 
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	53                   	push   %ebx
  8011c2:	83 ec 0c             	sub    $0xc,%esp
  8011c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8011c8:	53                   	push   %ebx
  8011c9:	6a 00                	push   $0x0
  8011cb:	e8 5e f0 ff ff       	call   80022e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8011d0:	89 1c 24             	mov    %ebx,(%esp)
  8011d3:	e8 9d f2 ff ff       	call   800475 <fd2data>
  8011d8:	83 c4 08             	add    $0x8,%esp
  8011db:	50                   	push   %eax
  8011dc:	6a 00                	push   $0x0
  8011de:	e8 4b f0 ff ff       	call   80022e <sys_page_unmap>
}
  8011e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011e6:	c9                   	leave  
  8011e7:	c3                   	ret    

008011e8 <_pipeisclosed>:
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	57                   	push   %edi
  8011ec:	56                   	push   %esi
  8011ed:	53                   	push   %ebx
  8011ee:	83 ec 1c             	sub    $0x1c,%esp
  8011f1:	89 c7                	mov    %eax,%edi
  8011f3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8011f5:	a1 08 40 80 00       	mov    0x804008,%eax
  8011fa:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8011fd:	83 ec 0c             	sub    $0xc,%esp
  801200:	57                   	push   %edi
  801201:	e8 da 0f 00 00       	call   8021e0 <pageref>
  801206:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801209:	89 34 24             	mov    %esi,(%esp)
  80120c:	e8 cf 0f 00 00       	call   8021e0 <pageref>
		nn = thisenv->env_runs;
  801211:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801217:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80121a:	83 c4 10             	add    $0x10,%esp
  80121d:	39 cb                	cmp    %ecx,%ebx
  80121f:	74 1b                	je     80123c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801221:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801224:	75 cf                	jne    8011f5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801226:	8b 42 58             	mov    0x58(%edx),%eax
  801229:	6a 01                	push   $0x1
  80122b:	50                   	push   %eax
  80122c:	53                   	push   %ebx
  80122d:	68 bb 25 80 00       	push   $0x8025bb
  801232:	e8 13 05 00 00       	call   80174a <cprintf>
  801237:	83 c4 10             	add    $0x10,%esp
  80123a:	eb b9                	jmp    8011f5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80123c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80123f:	0f 94 c0             	sete   %al
  801242:	0f b6 c0             	movzbl %al,%eax
}
  801245:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801248:	5b                   	pop    %ebx
  801249:	5e                   	pop    %esi
  80124a:	5f                   	pop    %edi
  80124b:	5d                   	pop    %ebp
  80124c:	c3                   	ret    

0080124d <devpipe_write>:
{
  80124d:	f3 0f 1e fb          	endbr32 
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	57                   	push   %edi
  801255:	56                   	push   %esi
  801256:	53                   	push   %ebx
  801257:	83 ec 28             	sub    $0x28,%esp
  80125a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80125d:	56                   	push   %esi
  80125e:	e8 12 f2 ff ff       	call   800475 <fd2data>
  801263:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801265:	83 c4 10             	add    $0x10,%esp
  801268:	bf 00 00 00 00       	mov    $0x0,%edi
  80126d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801270:	74 4f                	je     8012c1 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801272:	8b 43 04             	mov    0x4(%ebx),%eax
  801275:	8b 0b                	mov    (%ebx),%ecx
  801277:	8d 51 20             	lea    0x20(%ecx),%edx
  80127a:	39 d0                	cmp    %edx,%eax
  80127c:	72 14                	jb     801292 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  80127e:	89 da                	mov    %ebx,%edx
  801280:	89 f0                	mov    %esi,%eax
  801282:	e8 61 ff ff ff       	call   8011e8 <_pipeisclosed>
  801287:	85 c0                	test   %eax,%eax
  801289:	75 3b                	jne    8012c6 <devpipe_write+0x79>
			sys_yield();
  80128b:	e8 ee ee ff ff       	call   80017e <sys_yield>
  801290:	eb e0                	jmp    801272 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801292:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801295:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801299:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80129c:	89 c2                	mov    %eax,%edx
  80129e:	c1 fa 1f             	sar    $0x1f,%edx
  8012a1:	89 d1                	mov    %edx,%ecx
  8012a3:	c1 e9 1b             	shr    $0x1b,%ecx
  8012a6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8012a9:	83 e2 1f             	and    $0x1f,%edx
  8012ac:	29 ca                	sub    %ecx,%edx
  8012ae:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8012b2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8012b6:	83 c0 01             	add    $0x1,%eax
  8012b9:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8012bc:	83 c7 01             	add    $0x1,%edi
  8012bf:	eb ac                	jmp    80126d <devpipe_write+0x20>
	return i;
  8012c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c4:	eb 05                	jmp    8012cb <devpipe_write+0x7e>
				return 0;
  8012c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ce:	5b                   	pop    %ebx
  8012cf:	5e                   	pop    %esi
  8012d0:	5f                   	pop    %edi
  8012d1:	5d                   	pop    %ebp
  8012d2:	c3                   	ret    

008012d3 <devpipe_read>:
{
  8012d3:	f3 0f 1e fb          	endbr32 
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
  8012da:	57                   	push   %edi
  8012db:	56                   	push   %esi
  8012dc:	53                   	push   %ebx
  8012dd:	83 ec 18             	sub    $0x18,%esp
  8012e0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8012e3:	57                   	push   %edi
  8012e4:	e8 8c f1 ff ff       	call   800475 <fd2data>
  8012e9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8012eb:	83 c4 10             	add    $0x10,%esp
  8012ee:	be 00 00 00 00       	mov    $0x0,%esi
  8012f3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8012f6:	75 14                	jne    80130c <devpipe_read+0x39>
	return i;
  8012f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fb:	eb 02                	jmp    8012ff <devpipe_read+0x2c>
				return i;
  8012fd:	89 f0                	mov    %esi,%eax
}
  8012ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801302:	5b                   	pop    %ebx
  801303:	5e                   	pop    %esi
  801304:	5f                   	pop    %edi
  801305:	5d                   	pop    %ebp
  801306:	c3                   	ret    
			sys_yield();
  801307:	e8 72 ee ff ff       	call   80017e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80130c:	8b 03                	mov    (%ebx),%eax
  80130e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801311:	75 18                	jne    80132b <devpipe_read+0x58>
			if (i > 0)
  801313:	85 f6                	test   %esi,%esi
  801315:	75 e6                	jne    8012fd <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801317:	89 da                	mov    %ebx,%edx
  801319:	89 f8                	mov    %edi,%eax
  80131b:	e8 c8 fe ff ff       	call   8011e8 <_pipeisclosed>
  801320:	85 c0                	test   %eax,%eax
  801322:	74 e3                	je     801307 <devpipe_read+0x34>
				return 0;
  801324:	b8 00 00 00 00       	mov    $0x0,%eax
  801329:	eb d4                	jmp    8012ff <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80132b:	99                   	cltd   
  80132c:	c1 ea 1b             	shr    $0x1b,%edx
  80132f:	01 d0                	add    %edx,%eax
  801331:	83 e0 1f             	and    $0x1f,%eax
  801334:	29 d0                	sub    %edx,%eax
  801336:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80133b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80133e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801341:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801344:	83 c6 01             	add    $0x1,%esi
  801347:	eb aa                	jmp    8012f3 <devpipe_read+0x20>

00801349 <pipe>:
{
  801349:	f3 0f 1e fb          	endbr32 
  80134d:	55                   	push   %ebp
  80134e:	89 e5                	mov    %esp,%ebp
  801350:	56                   	push   %esi
  801351:	53                   	push   %ebx
  801352:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801355:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801358:	50                   	push   %eax
  801359:	e8 32 f1 ff ff       	call   800490 <fd_alloc>
  80135e:	89 c3                	mov    %eax,%ebx
  801360:	83 c4 10             	add    $0x10,%esp
  801363:	85 c0                	test   %eax,%eax
  801365:	0f 88 23 01 00 00    	js     80148e <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80136b:	83 ec 04             	sub    $0x4,%esp
  80136e:	68 07 04 00 00       	push   $0x407
  801373:	ff 75 f4             	pushl  -0xc(%ebp)
  801376:	6a 00                	push   $0x0
  801378:	e8 24 ee ff ff       	call   8001a1 <sys_page_alloc>
  80137d:	89 c3                	mov    %eax,%ebx
  80137f:	83 c4 10             	add    $0x10,%esp
  801382:	85 c0                	test   %eax,%eax
  801384:	0f 88 04 01 00 00    	js     80148e <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80138a:	83 ec 0c             	sub    $0xc,%esp
  80138d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801390:	50                   	push   %eax
  801391:	e8 fa f0 ff ff       	call   800490 <fd_alloc>
  801396:	89 c3                	mov    %eax,%ebx
  801398:	83 c4 10             	add    $0x10,%esp
  80139b:	85 c0                	test   %eax,%eax
  80139d:	0f 88 db 00 00 00    	js     80147e <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013a3:	83 ec 04             	sub    $0x4,%esp
  8013a6:	68 07 04 00 00       	push   $0x407
  8013ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8013ae:	6a 00                	push   $0x0
  8013b0:	e8 ec ed ff ff       	call   8001a1 <sys_page_alloc>
  8013b5:	89 c3                	mov    %eax,%ebx
  8013b7:	83 c4 10             	add    $0x10,%esp
  8013ba:	85 c0                	test   %eax,%eax
  8013bc:	0f 88 bc 00 00 00    	js     80147e <pipe+0x135>
	va = fd2data(fd0);
  8013c2:	83 ec 0c             	sub    $0xc,%esp
  8013c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8013c8:	e8 a8 f0 ff ff       	call   800475 <fd2data>
  8013cd:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013cf:	83 c4 0c             	add    $0xc,%esp
  8013d2:	68 07 04 00 00       	push   $0x407
  8013d7:	50                   	push   %eax
  8013d8:	6a 00                	push   $0x0
  8013da:	e8 c2 ed ff ff       	call   8001a1 <sys_page_alloc>
  8013df:	89 c3                	mov    %eax,%ebx
  8013e1:	83 c4 10             	add    $0x10,%esp
  8013e4:	85 c0                	test   %eax,%eax
  8013e6:	0f 88 82 00 00 00    	js     80146e <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013ec:	83 ec 0c             	sub    $0xc,%esp
  8013ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8013f2:	e8 7e f0 ff ff       	call   800475 <fd2data>
  8013f7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8013fe:	50                   	push   %eax
  8013ff:	6a 00                	push   $0x0
  801401:	56                   	push   %esi
  801402:	6a 00                	push   $0x0
  801404:	e8 df ed ff ff       	call   8001e8 <sys_page_map>
  801409:	89 c3                	mov    %eax,%ebx
  80140b:	83 c4 20             	add    $0x20,%esp
  80140e:	85 c0                	test   %eax,%eax
  801410:	78 4e                	js     801460 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801412:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801417:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80141c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801426:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801429:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80142b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80142e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801435:	83 ec 0c             	sub    $0xc,%esp
  801438:	ff 75 f4             	pushl  -0xc(%ebp)
  80143b:	e8 21 f0 ff ff       	call   800461 <fd2num>
  801440:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801443:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801445:	83 c4 04             	add    $0x4,%esp
  801448:	ff 75 f0             	pushl  -0x10(%ebp)
  80144b:	e8 11 f0 ff ff       	call   800461 <fd2num>
  801450:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801453:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801456:	83 c4 10             	add    $0x10,%esp
  801459:	bb 00 00 00 00       	mov    $0x0,%ebx
  80145e:	eb 2e                	jmp    80148e <pipe+0x145>
	sys_page_unmap(0, va);
  801460:	83 ec 08             	sub    $0x8,%esp
  801463:	56                   	push   %esi
  801464:	6a 00                	push   $0x0
  801466:	e8 c3 ed ff ff       	call   80022e <sys_page_unmap>
  80146b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80146e:	83 ec 08             	sub    $0x8,%esp
  801471:	ff 75 f0             	pushl  -0x10(%ebp)
  801474:	6a 00                	push   $0x0
  801476:	e8 b3 ed ff ff       	call   80022e <sys_page_unmap>
  80147b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80147e:	83 ec 08             	sub    $0x8,%esp
  801481:	ff 75 f4             	pushl  -0xc(%ebp)
  801484:	6a 00                	push   $0x0
  801486:	e8 a3 ed ff ff       	call   80022e <sys_page_unmap>
  80148b:	83 c4 10             	add    $0x10,%esp
}
  80148e:	89 d8                	mov    %ebx,%eax
  801490:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801493:	5b                   	pop    %ebx
  801494:	5e                   	pop    %esi
  801495:	5d                   	pop    %ebp
  801496:	c3                   	ret    

00801497 <pipeisclosed>:
{
  801497:	f3 0f 1e fb          	endbr32 
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a4:	50                   	push   %eax
  8014a5:	ff 75 08             	pushl  0x8(%ebp)
  8014a8:	e8 39 f0 ff ff       	call   8004e6 <fd_lookup>
  8014ad:	83 c4 10             	add    $0x10,%esp
  8014b0:	85 c0                	test   %eax,%eax
  8014b2:	78 18                	js     8014cc <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8014b4:	83 ec 0c             	sub    $0xc,%esp
  8014b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8014ba:	e8 b6 ef ff ff       	call   800475 <fd2data>
  8014bf:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8014c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c4:	e8 1f fd ff ff       	call   8011e8 <_pipeisclosed>
  8014c9:	83 c4 10             	add    $0x10,%esp
}
  8014cc:	c9                   	leave  
  8014cd:	c3                   	ret    

008014ce <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8014ce:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8014d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d7:	c3                   	ret    

008014d8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8014d8:	f3 0f 1e fb          	endbr32 
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8014e2:	68 d3 25 80 00       	push   $0x8025d3
  8014e7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ea:	e8 65 08 00 00       	call   801d54 <strcpy>
	return 0;
}
  8014ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <devcons_write>:
{
  8014f6:	f3 0f 1e fb          	endbr32 
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	57                   	push   %edi
  8014fe:	56                   	push   %esi
  8014ff:	53                   	push   %ebx
  801500:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801506:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80150b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801511:	3b 75 10             	cmp    0x10(%ebp),%esi
  801514:	73 31                	jae    801547 <devcons_write+0x51>
		m = n - tot;
  801516:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801519:	29 f3                	sub    %esi,%ebx
  80151b:	83 fb 7f             	cmp    $0x7f,%ebx
  80151e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801523:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801526:	83 ec 04             	sub    $0x4,%esp
  801529:	53                   	push   %ebx
  80152a:	89 f0                	mov    %esi,%eax
  80152c:	03 45 0c             	add    0xc(%ebp),%eax
  80152f:	50                   	push   %eax
  801530:	57                   	push   %edi
  801531:	e8 d4 09 00 00       	call   801f0a <memmove>
		sys_cputs(buf, m);
  801536:	83 c4 08             	add    $0x8,%esp
  801539:	53                   	push   %ebx
  80153a:	57                   	push   %edi
  80153b:	e8 91 eb ff ff       	call   8000d1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801540:	01 de                	add    %ebx,%esi
  801542:	83 c4 10             	add    $0x10,%esp
  801545:	eb ca                	jmp    801511 <devcons_write+0x1b>
}
  801547:	89 f0                	mov    %esi,%eax
  801549:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80154c:	5b                   	pop    %ebx
  80154d:	5e                   	pop    %esi
  80154e:	5f                   	pop    %edi
  80154f:	5d                   	pop    %ebp
  801550:	c3                   	ret    

00801551 <devcons_read>:
{
  801551:	f3 0f 1e fb          	endbr32 
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
  801558:	83 ec 08             	sub    $0x8,%esp
  80155b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801560:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801564:	74 21                	je     801587 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801566:	e8 88 eb ff ff       	call   8000f3 <sys_cgetc>
  80156b:	85 c0                	test   %eax,%eax
  80156d:	75 07                	jne    801576 <devcons_read+0x25>
		sys_yield();
  80156f:	e8 0a ec ff ff       	call   80017e <sys_yield>
  801574:	eb f0                	jmp    801566 <devcons_read+0x15>
	if (c < 0)
  801576:	78 0f                	js     801587 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801578:	83 f8 04             	cmp    $0x4,%eax
  80157b:	74 0c                	je     801589 <devcons_read+0x38>
	*(char*)vbuf = c;
  80157d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801580:	88 02                	mov    %al,(%edx)
	return 1;
  801582:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    
		return 0;
  801589:	b8 00 00 00 00       	mov    $0x0,%eax
  80158e:	eb f7                	jmp    801587 <devcons_read+0x36>

00801590 <cputchar>:
{
  801590:	f3 0f 1e fb          	endbr32 
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8015a0:	6a 01                	push   $0x1
  8015a2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8015a5:	50                   	push   %eax
  8015a6:	e8 26 eb ff ff       	call   8000d1 <sys_cputs>
}
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <getchar>:
{
  8015b0:	f3 0f 1e fb          	endbr32 
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8015ba:	6a 01                	push   $0x1
  8015bc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8015bf:	50                   	push   %eax
  8015c0:	6a 00                	push   $0x0
  8015c2:	e8 a7 f1 ff ff       	call   80076e <read>
	if (r < 0)
  8015c7:	83 c4 10             	add    $0x10,%esp
  8015ca:	85 c0                	test   %eax,%eax
  8015cc:	78 06                	js     8015d4 <getchar+0x24>
	if (r < 1)
  8015ce:	74 06                	je     8015d6 <getchar+0x26>
	return c;
  8015d0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    
		return -E_EOF;
  8015d6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8015db:	eb f7                	jmp    8015d4 <getchar+0x24>

008015dd <iscons>:
{
  8015dd:	f3 0f 1e fb          	endbr32 
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ea:	50                   	push   %eax
  8015eb:	ff 75 08             	pushl  0x8(%ebp)
  8015ee:	e8 f3 ee ff ff       	call   8004e6 <fd_lookup>
  8015f3:	83 c4 10             	add    $0x10,%esp
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	78 11                	js     80160b <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8015fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fd:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801603:	39 10                	cmp    %edx,(%eax)
  801605:	0f 94 c0             	sete   %al
  801608:	0f b6 c0             	movzbl %al,%eax
}
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    

0080160d <opencons>:
{
  80160d:	f3 0f 1e fb          	endbr32 
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
  801614:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801617:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80161a:	50                   	push   %eax
  80161b:	e8 70 ee ff ff       	call   800490 <fd_alloc>
  801620:	83 c4 10             	add    $0x10,%esp
  801623:	85 c0                	test   %eax,%eax
  801625:	78 3a                	js     801661 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801627:	83 ec 04             	sub    $0x4,%esp
  80162a:	68 07 04 00 00       	push   $0x407
  80162f:	ff 75 f4             	pushl  -0xc(%ebp)
  801632:	6a 00                	push   $0x0
  801634:	e8 68 eb ff ff       	call   8001a1 <sys_page_alloc>
  801639:	83 c4 10             	add    $0x10,%esp
  80163c:	85 c0                	test   %eax,%eax
  80163e:	78 21                	js     801661 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801643:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801649:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80164b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801655:	83 ec 0c             	sub    $0xc,%esp
  801658:	50                   	push   %eax
  801659:	e8 03 ee ff ff       	call   800461 <fd2num>
  80165e:	83 c4 10             	add    $0x10,%esp
}
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801663:	f3 0f 1e fb          	endbr32 
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	56                   	push   %esi
  80166b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80166c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80166f:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801675:	e8 e1 ea ff ff       	call   80015b <sys_getenvid>
  80167a:	83 ec 0c             	sub    $0xc,%esp
  80167d:	ff 75 0c             	pushl  0xc(%ebp)
  801680:	ff 75 08             	pushl  0x8(%ebp)
  801683:	56                   	push   %esi
  801684:	50                   	push   %eax
  801685:	68 e0 25 80 00       	push   $0x8025e0
  80168a:	e8 bb 00 00 00       	call   80174a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80168f:	83 c4 18             	add    $0x18,%esp
  801692:	53                   	push   %ebx
  801693:	ff 75 10             	pushl  0x10(%ebp)
  801696:	e8 5a 00 00 00       	call   8016f5 <vcprintf>
	cprintf("\n");
  80169b:	c7 04 24 18 29 80 00 	movl   $0x802918,(%esp)
  8016a2:	e8 a3 00 00 00       	call   80174a <cprintf>
  8016a7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8016aa:	cc                   	int3   
  8016ab:	eb fd                	jmp    8016aa <_panic+0x47>

008016ad <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8016ad:	f3 0f 1e fb          	endbr32 
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	53                   	push   %ebx
  8016b5:	83 ec 04             	sub    $0x4,%esp
  8016b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8016bb:	8b 13                	mov    (%ebx),%edx
  8016bd:	8d 42 01             	lea    0x1(%edx),%eax
  8016c0:	89 03                	mov    %eax,(%ebx)
  8016c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016c5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8016c9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8016ce:	74 09                	je     8016d9 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8016d0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8016d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8016d9:	83 ec 08             	sub    $0x8,%esp
  8016dc:	68 ff 00 00 00       	push   $0xff
  8016e1:	8d 43 08             	lea    0x8(%ebx),%eax
  8016e4:	50                   	push   %eax
  8016e5:	e8 e7 e9 ff ff       	call   8000d1 <sys_cputs>
		b->idx = 0;
  8016ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8016f0:	83 c4 10             	add    $0x10,%esp
  8016f3:	eb db                	jmp    8016d0 <putch+0x23>

008016f5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8016f5:	f3 0f 1e fb          	endbr32 
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801702:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801709:	00 00 00 
	b.cnt = 0;
  80170c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801713:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801716:	ff 75 0c             	pushl  0xc(%ebp)
  801719:	ff 75 08             	pushl  0x8(%ebp)
  80171c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801722:	50                   	push   %eax
  801723:	68 ad 16 80 00       	push   $0x8016ad
  801728:	e8 20 01 00 00       	call   80184d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80172d:	83 c4 08             	add    $0x8,%esp
  801730:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801736:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80173c:	50                   	push   %eax
  80173d:	e8 8f e9 ff ff       	call   8000d1 <sys_cputs>

	return b.cnt;
}
  801742:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80174a:	f3 0f 1e fb          	endbr32 
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801754:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801757:	50                   	push   %eax
  801758:	ff 75 08             	pushl  0x8(%ebp)
  80175b:	e8 95 ff ff ff       	call   8016f5 <vcprintf>
	va_end(ap);

	return cnt;
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	57                   	push   %edi
  801766:	56                   	push   %esi
  801767:	53                   	push   %ebx
  801768:	83 ec 1c             	sub    $0x1c,%esp
  80176b:	89 c7                	mov    %eax,%edi
  80176d:	89 d6                	mov    %edx,%esi
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8b 55 0c             	mov    0xc(%ebp),%edx
  801775:	89 d1                	mov    %edx,%ecx
  801777:	89 c2                	mov    %eax,%edx
  801779:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80177c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80177f:	8b 45 10             	mov    0x10(%ebp),%eax
  801782:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801785:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801788:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80178f:	39 c2                	cmp    %eax,%edx
  801791:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  801794:	72 3e                	jb     8017d4 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801796:	83 ec 0c             	sub    $0xc,%esp
  801799:	ff 75 18             	pushl  0x18(%ebp)
  80179c:	83 eb 01             	sub    $0x1,%ebx
  80179f:	53                   	push   %ebx
  8017a0:	50                   	push   %eax
  8017a1:	83 ec 08             	sub    $0x8,%esp
  8017a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8017aa:	ff 75 dc             	pushl  -0x24(%ebp)
  8017ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8017b0:	e8 6b 0a 00 00       	call   802220 <__udivdi3>
  8017b5:	83 c4 18             	add    $0x18,%esp
  8017b8:	52                   	push   %edx
  8017b9:	50                   	push   %eax
  8017ba:	89 f2                	mov    %esi,%edx
  8017bc:	89 f8                	mov    %edi,%eax
  8017be:	e8 9f ff ff ff       	call   801762 <printnum>
  8017c3:	83 c4 20             	add    $0x20,%esp
  8017c6:	eb 13                	jmp    8017db <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8017c8:	83 ec 08             	sub    $0x8,%esp
  8017cb:	56                   	push   %esi
  8017cc:	ff 75 18             	pushl  0x18(%ebp)
  8017cf:	ff d7                	call   *%edi
  8017d1:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8017d4:	83 eb 01             	sub    $0x1,%ebx
  8017d7:	85 db                	test   %ebx,%ebx
  8017d9:	7f ed                	jg     8017c8 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8017db:	83 ec 08             	sub    $0x8,%esp
  8017de:	56                   	push   %esi
  8017df:	83 ec 04             	sub    $0x4,%esp
  8017e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017e5:	ff 75 e0             	pushl  -0x20(%ebp)
  8017e8:	ff 75 dc             	pushl  -0x24(%ebp)
  8017eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8017ee:	e8 3d 0b 00 00       	call   802330 <__umoddi3>
  8017f3:	83 c4 14             	add    $0x14,%esp
  8017f6:	0f be 80 03 26 80 00 	movsbl 0x802603(%eax),%eax
  8017fd:	50                   	push   %eax
  8017fe:	ff d7                	call   *%edi
}
  801800:	83 c4 10             	add    $0x10,%esp
  801803:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801806:	5b                   	pop    %ebx
  801807:	5e                   	pop    %esi
  801808:	5f                   	pop    %edi
  801809:	5d                   	pop    %ebp
  80180a:	c3                   	ret    

0080180b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80180b:	f3 0f 1e fb          	endbr32 
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
  801812:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801815:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801819:	8b 10                	mov    (%eax),%edx
  80181b:	3b 50 04             	cmp    0x4(%eax),%edx
  80181e:	73 0a                	jae    80182a <sprintputch+0x1f>
		*b->buf++ = ch;
  801820:	8d 4a 01             	lea    0x1(%edx),%ecx
  801823:	89 08                	mov    %ecx,(%eax)
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	88 02                	mov    %al,(%edx)
}
  80182a:	5d                   	pop    %ebp
  80182b:	c3                   	ret    

0080182c <printfmt>:
{
  80182c:	f3 0f 1e fb          	endbr32 
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801836:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801839:	50                   	push   %eax
  80183a:	ff 75 10             	pushl  0x10(%ebp)
  80183d:	ff 75 0c             	pushl  0xc(%ebp)
  801840:	ff 75 08             	pushl  0x8(%ebp)
  801843:	e8 05 00 00 00       	call   80184d <vprintfmt>
}
  801848:	83 c4 10             	add    $0x10,%esp
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <vprintfmt>:
{
  80184d:	f3 0f 1e fb          	endbr32 
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	57                   	push   %edi
  801855:	56                   	push   %esi
  801856:	53                   	push   %ebx
  801857:	83 ec 3c             	sub    $0x3c,%esp
  80185a:	8b 75 08             	mov    0x8(%ebp),%esi
  80185d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801860:	8b 7d 10             	mov    0x10(%ebp),%edi
  801863:	e9 8e 03 00 00       	jmp    801bf6 <vprintfmt+0x3a9>
		padc = ' ';
  801868:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80186c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801873:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80187a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801881:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801886:	8d 47 01             	lea    0x1(%edi),%eax
  801889:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80188c:	0f b6 17             	movzbl (%edi),%edx
  80188f:	8d 42 dd             	lea    -0x23(%edx),%eax
  801892:	3c 55                	cmp    $0x55,%al
  801894:	0f 87 df 03 00 00    	ja     801c79 <vprintfmt+0x42c>
  80189a:	0f b6 c0             	movzbl %al,%eax
  80189d:	3e ff 24 85 40 27 80 	notrack jmp *0x802740(,%eax,4)
  8018a4:	00 
  8018a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8018a8:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8018ac:	eb d8                	jmp    801886 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8018ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8018b1:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8018b5:	eb cf                	jmp    801886 <vprintfmt+0x39>
  8018b7:	0f b6 d2             	movzbl %dl,%edx
  8018ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8018bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8018c5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8018c8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8018cc:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8018cf:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8018d2:	83 f9 09             	cmp    $0x9,%ecx
  8018d5:	77 55                	ja     80192c <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8018d7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8018da:	eb e9                	jmp    8018c5 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8018dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8018df:	8b 00                	mov    (%eax),%eax
  8018e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e7:	8d 40 04             	lea    0x4(%eax),%eax
  8018ea:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8018ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8018f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018f4:	79 90                	jns    801886 <vprintfmt+0x39>
				width = precision, precision = -1;
  8018f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8018fc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801903:	eb 81                	jmp    801886 <vprintfmt+0x39>
  801905:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801908:	85 c0                	test   %eax,%eax
  80190a:	ba 00 00 00 00       	mov    $0x0,%edx
  80190f:	0f 49 d0             	cmovns %eax,%edx
  801912:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801915:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801918:	e9 69 ff ff ff       	jmp    801886 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80191d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801920:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801927:	e9 5a ff ff ff       	jmp    801886 <vprintfmt+0x39>
  80192c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80192f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801932:	eb bc                	jmp    8018f0 <vprintfmt+0xa3>
			lflag++;
  801934:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801937:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80193a:	e9 47 ff ff ff       	jmp    801886 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80193f:	8b 45 14             	mov    0x14(%ebp),%eax
  801942:	8d 78 04             	lea    0x4(%eax),%edi
  801945:	83 ec 08             	sub    $0x8,%esp
  801948:	53                   	push   %ebx
  801949:	ff 30                	pushl  (%eax)
  80194b:	ff d6                	call   *%esi
			break;
  80194d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801950:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801953:	e9 9b 02 00 00       	jmp    801bf3 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  801958:	8b 45 14             	mov    0x14(%ebp),%eax
  80195b:	8d 78 04             	lea    0x4(%eax),%edi
  80195e:	8b 00                	mov    (%eax),%eax
  801960:	99                   	cltd   
  801961:	31 d0                	xor    %edx,%eax
  801963:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801965:	83 f8 0f             	cmp    $0xf,%eax
  801968:	7f 23                	jg     80198d <vprintfmt+0x140>
  80196a:	8b 14 85 a0 28 80 00 	mov    0x8028a0(,%eax,4),%edx
  801971:	85 d2                	test   %edx,%edx
  801973:	74 18                	je     80198d <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  801975:	52                   	push   %edx
  801976:	68 61 25 80 00       	push   $0x802561
  80197b:	53                   	push   %ebx
  80197c:	56                   	push   %esi
  80197d:	e8 aa fe ff ff       	call   80182c <printfmt>
  801982:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801985:	89 7d 14             	mov    %edi,0x14(%ebp)
  801988:	e9 66 02 00 00       	jmp    801bf3 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80198d:	50                   	push   %eax
  80198e:	68 1b 26 80 00       	push   $0x80261b
  801993:	53                   	push   %ebx
  801994:	56                   	push   %esi
  801995:	e8 92 fe ff ff       	call   80182c <printfmt>
  80199a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80199d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8019a0:	e9 4e 02 00 00       	jmp    801bf3 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8019a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a8:	83 c0 04             	add    $0x4,%eax
  8019ab:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8019ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b1:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8019b3:	85 d2                	test   %edx,%edx
  8019b5:	b8 14 26 80 00       	mov    $0x802614,%eax
  8019ba:	0f 45 c2             	cmovne %edx,%eax
  8019bd:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8019c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019c4:	7e 06                	jle    8019cc <vprintfmt+0x17f>
  8019c6:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8019ca:	75 0d                	jne    8019d9 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8019cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019cf:	89 c7                	mov    %eax,%edi
  8019d1:	03 45 e0             	add    -0x20(%ebp),%eax
  8019d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019d7:	eb 55                	jmp    801a2e <vprintfmt+0x1e1>
  8019d9:	83 ec 08             	sub    $0x8,%esp
  8019dc:	ff 75 d8             	pushl  -0x28(%ebp)
  8019df:	ff 75 cc             	pushl  -0x34(%ebp)
  8019e2:	e8 46 03 00 00       	call   801d2d <strnlen>
  8019e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019ea:	29 c2                	sub    %eax,%edx
  8019ec:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8019ef:	83 c4 10             	add    $0x10,%esp
  8019f2:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8019f4:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8019f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8019fb:	85 ff                	test   %edi,%edi
  8019fd:	7e 11                	jle    801a10 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8019ff:	83 ec 08             	sub    $0x8,%esp
  801a02:	53                   	push   %ebx
  801a03:	ff 75 e0             	pushl  -0x20(%ebp)
  801a06:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801a08:	83 ef 01             	sub    $0x1,%edi
  801a0b:	83 c4 10             	add    $0x10,%esp
  801a0e:	eb eb                	jmp    8019fb <vprintfmt+0x1ae>
  801a10:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801a13:	85 d2                	test   %edx,%edx
  801a15:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1a:	0f 49 c2             	cmovns %edx,%eax
  801a1d:	29 c2                	sub    %eax,%edx
  801a1f:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801a22:	eb a8                	jmp    8019cc <vprintfmt+0x17f>
					putch(ch, putdat);
  801a24:	83 ec 08             	sub    $0x8,%esp
  801a27:	53                   	push   %ebx
  801a28:	52                   	push   %edx
  801a29:	ff d6                	call   *%esi
  801a2b:	83 c4 10             	add    $0x10,%esp
  801a2e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801a31:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a33:	83 c7 01             	add    $0x1,%edi
  801a36:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a3a:	0f be d0             	movsbl %al,%edx
  801a3d:	85 d2                	test   %edx,%edx
  801a3f:	74 4b                	je     801a8c <vprintfmt+0x23f>
  801a41:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801a45:	78 06                	js     801a4d <vprintfmt+0x200>
  801a47:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801a4b:	78 1e                	js     801a6b <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  801a4d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801a51:	74 d1                	je     801a24 <vprintfmt+0x1d7>
  801a53:	0f be c0             	movsbl %al,%eax
  801a56:	83 e8 20             	sub    $0x20,%eax
  801a59:	83 f8 5e             	cmp    $0x5e,%eax
  801a5c:	76 c6                	jbe    801a24 <vprintfmt+0x1d7>
					putch('?', putdat);
  801a5e:	83 ec 08             	sub    $0x8,%esp
  801a61:	53                   	push   %ebx
  801a62:	6a 3f                	push   $0x3f
  801a64:	ff d6                	call   *%esi
  801a66:	83 c4 10             	add    $0x10,%esp
  801a69:	eb c3                	jmp    801a2e <vprintfmt+0x1e1>
  801a6b:	89 cf                	mov    %ecx,%edi
  801a6d:	eb 0e                	jmp    801a7d <vprintfmt+0x230>
				putch(' ', putdat);
  801a6f:	83 ec 08             	sub    $0x8,%esp
  801a72:	53                   	push   %ebx
  801a73:	6a 20                	push   $0x20
  801a75:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801a77:	83 ef 01             	sub    $0x1,%edi
  801a7a:	83 c4 10             	add    $0x10,%esp
  801a7d:	85 ff                	test   %edi,%edi
  801a7f:	7f ee                	jg     801a6f <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  801a81:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a84:	89 45 14             	mov    %eax,0x14(%ebp)
  801a87:	e9 67 01 00 00       	jmp    801bf3 <vprintfmt+0x3a6>
  801a8c:	89 cf                	mov    %ecx,%edi
  801a8e:	eb ed                	jmp    801a7d <vprintfmt+0x230>
	if (lflag >= 2)
  801a90:	83 f9 01             	cmp    $0x1,%ecx
  801a93:	7f 1b                	jg     801ab0 <vprintfmt+0x263>
	else if (lflag)
  801a95:	85 c9                	test   %ecx,%ecx
  801a97:	74 63                	je     801afc <vprintfmt+0x2af>
		return va_arg(*ap, long);
  801a99:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9c:	8b 00                	mov    (%eax),%eax
  801a9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801aa1:	99                   	cltd   
  801aa2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801aa5:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa8:	8d 40 04             	lea    0x4(%eax),%eax
  801aab:	89 45 14             	mov    %eax,0x14(%ebp)
  801aae:	eb 17                	jmp    801ac7 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801ab0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab3:	8b 50 04             	mov    0x4(%eax),%edx
  801ab6:	8b 00                	mov    (%eax),%eax
  801ab8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801abb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801abe:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac1:	8d 40 08             	lea    0x8(%eax),%eax
  801ac4:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801ac7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801aca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801acd:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801ad2:	85 c9                	test   %ecx,%ecx
  801ad4:	0f 89 ff 00 00 00    	jns    801bd9 <vprintfmt+0x38c>
				putch('-', putdat);
  801ada:	83 ec 08             	sub    $0x8,%esp
  801add:	53                   	push   %ebx
  801ade:	6a 2d                	push   $0x2d
  801ae0:	ff d6                	call   *%esi
				num = -(long long) num;
  801ae2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ae5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801ae8:	f7 da                	neg    %edx
  801aea:	83 d1 00             	adc    $0x0,%ecx
  801aed:	f7 d9                	neg    %ecx
  801aef:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801af2:	b8 0a 00 00 00       	mov    $0xa,%eax
  801af7:	e9 dd 00 00 00       	jmp    801bd9 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801afc:	8b 45 14             	mov    0x14(%ebp),%eax
  801aff:	8b 00                	mov    (%eax),%eax
  801b01:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b04:	99                   	cltd   
  801b05:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801b08:	8b 45 14             	mov    0x14(%ebp),%eax
  801b0b:	8d 40 04             	lea    0x4(%eax),%eax
  801b0e:	89 45 14             	mov    %eax,0x14(%ebp)
  801b11:	eb b4                	jmp    801ac7 <vprintfmt+0x27a>
	if (lflag >= 2)
  801b13:	83 f9 01             	cmp    $0x1,%ecx
  801b16:	7f 1e                	jg     801b36 <vprintfmt+0x2e9>
	else if (lflag)
  801b18:	85 c9                	test   %ecx,%ecx
  801b1a:	74 32                	je     801b4e <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801b1c:	8b 45 14             	mov    0x14(%ebp),%eax
  801b1f:	8b 10                	mov    (%eax),%edx
  801b21:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b26:	8d 40 04             	lea    0x4(%eax),%eax
  801b29:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b2c:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801b31:	e9 a3 00 00 00       	jmp    801bd9 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b36:	8b 45 14             	mov    0x14(%ebp),%eax
  801b39:	8b 10                	mov    (%eax),%edx
  801b3b:	8b 48 04             	mov    0x4(%eax),%ecx
  801b3e:	8d 40 08             	lea    0x8(%eax),%eax
  801b41:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b44:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  801b49:	e9 8b 00 00 00       	jmp    801bd9 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b4e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b51:	8b 10                	mov    (%eax),%edx
  801b53:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b58:	8d 40 04             	lea    0x4(%eax),%eax
  801b5b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b5e:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  801b63:	eb 74                	jmp    801bd9 <vprintfmt+0x38c>
	if (lflag >= 2)
  801b65:	83 f9 01             	cmp    $0x1,%ecx
  801b68:	7f 1b                	jg     801b85 <vprintfmt+0x338>
	else if (lflag)
  801b6a:	85 c9                	test   %ecx,%ecx
  801b6c:	74 2c                	je     801b9a <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801b6e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b71:	8b 10                	mov    (%eax),%edx
  801b73:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b78:	8d 40 04             	lea    0x4(%eax),%eax
  801b7b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b7e:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801b83:	eb 54                	jmp    801bd9 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b85:	8b 45 14             	mov    0x14(%ebp),%eax
  801b88:	8b 10                	mov    (%eax),%edx
  801b8a:	8b 48 04             	mov    0x4(%eax),%ecx
  801b8d:	8d 40 08             	lea    0x8(%eax),%eax
  801b90:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b93:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801b98:	eb 3f                	jmp    801bd9 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b9a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b9d:	8b 10                	mov    (%eax),%edx
  801b9f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ba4:	8d 40 04             	lea    0x4(%eax),%eax
  801ba7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801baa:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801baf:	eb 28                	jmp    801bd9 <vprintfmt+0x38c>
			putch('0', putdat);
  801bb1:	83 ec 08             	sub    $0x8,%esp
  801bb4:	53                   	push   %ebx
  801bb5:	6a 30                	push   $0x30
  801bb7:	ff d6                	call   *%esi
			putch('x', putdat);
  801bb9:	83 c4 08             	add    $0x8,%esp
  801bbc:	53                   	push   %ebx
  801bbd:	6a 78                	push   $0x78
  801bbf:	ff d6                	call   *%esi
			num = (unsigned long long)
  801bc1:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc4:	8b 10                	mov    (%eax),%edx
  801bc6:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801bcb:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801bce:	8d 40 04             	lea    0x4(%eax),%eax
  801bd1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801bd4:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801bd9:	83 ec 0c             	sub    $0xc,%esp
  801bdc:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801be0:	57                   	push   %edi
  801be1:	ff 75 e0             	pushl  -0x20(%ebp)
  801be4:	50                   	push   %eax
  801be5:	51                   	push   %ecx
  801be6:	52                   	push   %edx
  801be7:	89 da                	mov    %ebx,%edx
  801be9:	89 f0                	mov    %esi,%eax
  801beb:	e8 72 fb ff ff       	call   801762 <printnum>
			break;
  801bf0:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801bf3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801bf6:	83 c7 01             	add    $0x1,%edi
  801bf9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801bfd:	83 f8 25             	cmp    $0x25,%eax
  801c00:	0f 84 62 fc ff ff    	je     801868 <vprintfmt+0x1b>
			if (ch == '\0')
  801c06:	85 c0                	test   %eax,%eax
  801c08:	0f 84 8b 00 00 00    	je     801c99 <vprintfmt+0x44c>
			putch(ch, putdat);
  801c0e:	83 ec 08             	sub    $0x8,%esp
  801c11:	53                   	push   %ebx
  801c12:	50                   	push   %eax
  801c13:	ff d6                	call   *%esi
  801c15:	83 c4 10             	add    $0x10,%esp
  801c18:	eb dc                	jmp    801bf6 <vprintfmt+0x3a9>
	if (lflag >= 2)
  801c1a:	83 f9 01             	cmp    $0x1,%ecx
  801c1d:	7f 1b                	jg     801c3a <vprintfmt+0x3ed>
	else if (lflag)
  801c1f:	85 c9                	test   %ecx,%ecx
  801c21:	74 2c                	je     801c4f <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801c23:	8b 45 14             	mov    0x14(%ebp),%eax
  801c26:	8b 10                	mov    (%eax),%edx
  801c28:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c2d:	8d 40 04             	lea    0x4(%eax),%eax
  801c30:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c33:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  801c38:	eb 9f                	jmp    801bd9 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801c3a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c3d:	8b 10                	mov    (%eax),%edx
  801c3f:	8b 48 04             	mov    0x4(%eax),%ecx
  801c42:	8d 40 08             	lea    0x8(%eax),%eax
  801c45:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c48:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  801c4d:	eb 8a                	jmp    801bd9 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801c4f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c52:	8b 10                	mov    (%eax),%edx
  801c54:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c59:	8d 40 04             	lea    0x4(%eax),%eax
  801c5c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c5f:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  801c64:	e9 70 ff ff ff       	jmp    801bd9 <vprintfmt+0x38c>
			putch(ch, putdat);
  801c69:	83 ec 08             	sub    $0x8,%esp
  801c6c:	53                   	push   %ebx
  801c6d:	6a 25                	push   $0x25
  801c6f:	ff d6                	call   *%esi
			break;
  801c71:	83 c4 10             	add    $0x10,%esp
  801c74:	e9 7a ff ff ff       	jmp    801bf3 <vprintfmt+0x3a6>
			putch('%', putdat);
  801c79:	83 ec 08             	sub    $0x8,%esp
  801c7c:	53                   	push   %ebx
  801c7d:	6a 25                	push   $0x25
  801c7f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801c81:	83 c4 10             	add    $0x10,%esp
  801c84:	89 f8                	mov    %edi,%eax
  801c86:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801c8a:	74 05                	je     801c91 <vprintfmt+0x444>
  801c8c:	83 e8 01             	sub    $0x1,%eax
  801c8f:	eb f5                	jmp    801c86 <vprintfmt+0x439>
  801c91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c94:	e9 5a ff ff ff       	jmp    801bf3 <vprintfmt+0x3a6>
}
  801c99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c9c:	5b                   	pop    %ebx
  801c9d:	5e                   	pop    %esi
  801c9e:	5f                   	pop    %edi
  801c9f:	5d                   	pop    %ebp
  801ca0:	c3                   	ret    

00801ca1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ca1:	f3 0f 1e fb          	endbr32 
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	83 ec 18             	sub    $0x18,%esp
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801cb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801cb4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801cb8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801cbb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801cc2:	85 c0                	test   %eax,%eax
  801cc4:	74 26                	je     801cec <vsnprintf+0x4b>
  801cc6:	85 d2                	test   %edx,%edx
  801cc8:	7e 22                	jle    801cec <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801cca:	ff 75 14             	pushl  0x14(%ebp)
  801ccd:	ff 75 10             	pushl  0x10(%ebp)
  801cd0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801cd3:	50                   	push   %eax
  801cd4:	68 0b 18 80 00       	push   $0x80180b
  801cd9:	e8 6f fb ff ff       	call   80184d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801cde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ce1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce7:	83 c4 10             	add    $0x10,%esp
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    
		return -E_INVAL;
  801cec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cf1:	eb f7                	jmp    801cea <vsnprintf+0x49>

00801cf3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801cf3:	f3 0f 1e fb          	endbr32 
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801cfd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801d00:	50                   	push   %eax
  801d01:	ff 75 10             	pushl  0x10(%ebp)
  801d04:	ff 75 0c             	pushl  0xc(%ebp)
  801d07:	ff 75 08             	pushl  0x8(%ebp)
  801d0a:	e8 92 ff ff ff       	call   801ca1 <vsnprintf>
	va_end(ap);

	return rc;
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801d11:	f3 0f 1e fb          	endbr32 
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801d1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d20:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801d24:	74 05                	je     801d2b <strlen+0x1a>
		n++;
  801d26:	83 c0 01             	add    $0x1,%eax
  801d29:	eb f5                	jmp    801d20 <strlen+0xf>
	return n;
}
  801d2b:	5d                   	pop    %ebp
  801d2c:	c3                   	ret    

00801d2d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801d2d:	f3 0f 1e fb          	endbr32 
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
  801d34:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d37:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3f:	39 d0                	cmp    %edx,%eax
  801d41:	74 0d                	je     801d50 <strnlen+0x23>
  801d43:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801d47:	74 05                	je     801d4e <strnlen+0x21>
		n++;
  801d49:	83 c0 01             	add    $0x1,%eax
  801d4c:	eb f1                	jmp    801d3f <strnlen+0x12>
  801d4e:	89 c2                	mov    %eax,%edx
	return n;
}
  801d50:	89 d0                	mov    %edx,%eax
  801d52:	5d                   	pop    %ebp
  801d53:	c3                   	ret    

00801d54 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801d54:	f3 0f 1e fb          	endbr32 
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	53                   	push   %ebx
  801d5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d5f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801d62:	b8 00 00 00 00       	mov    $0x0,%eax
  801d67:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801d6b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801d6e:	83 c0 01             	add    $0x1,%eax
  801d71:	84 d2                	test   %dl,%dl
  801d73:	75 f2                	jne    801d67 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801d75:	89 c8                	mov    %ecx,%eax
  801d77:	5b                   	pop    %ebx
  801d78:	5d                   	pop    %ebp
  801d79:	c3                   	ret    

00801d7a <strcat>:

char *
strcat(char *dst, const char *src)
{
  801d7a:	f3 0f 1e fb          	endbr32 
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	53                   	push   %ebx
  801d82:	83 ec 10             	sub    $0x10,%esp
  801d85:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801d88:	53                   	push   %ebx
  801d89:	e8 83 ff ff ff       	call   801d11 <strlen>
  801d8e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801d91:	ff 75 0c             	pushl  0xc(%ebp)
  801d94:	01 d8                	add    %ebx,%eax
  801d96:	50                   	push   %eax
  801d97:	e8 b8 ff ff ff       	call   801d54 <strcpy>
	return dst;
}
  801d9c:	89 d8                	mov    %ebx,%eax
  801d9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801da3:	f3 0f 1e fb          	endbr32 
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	56                   	push   %esi
  801dab:	53                   	push   %ebx
  801dac:	8b 75 08             	mov    0x8(%ebp),%esi
  801daf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db2:	89 f3                	mov    %esi,%ebx
  801db4:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801db7:	89 f0                	mov    %esi,%eax
  801db9:	39 d8                	cmp    %ebx,%eax
  801dbb:	74 11                	je     801dce <strncpy+0x2b>
		*dst++ = *src;
  801dbd:	83 c0 01             	add    $0x1,%eax
  801dc0:	0f b6 0a             	movzbl (%edx),%ecx
  801dc3:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801dc6:	80 f9 01             	cmp    $0x1,%cl
  801dc9:	83 da ff             	sbb    $0xffffffff,%edx
  801dcc:	eb eb                	jmp    801db9 <strncpy+0x16>
	}
	return ret;
}
  801dce:	89 f0                	mov    %esi,%eax
  801dd0:	5b                   	pop    %ebx
  801dd1:	5e                   	pop    %esi
  801dd2:	5d                   	pop    %ebp
  801dd3:	c3                   	ret    

00801dd4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801dd4:	f3 0f 1e fb          	endbr32 
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
  801ddb:	56                   	push   %esi
  801ddc:	53                   	push   %ebx
  801ddd:	8b 75 08             	mov    0x8(%ebp),%esi
  801de0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801de3:	8b 55 10             	mov    0x10(%ebp),%edx
  801de6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801de8:	85 d2                	test   %edx,%edx
  801dea:	74 21                	je     801e0d <strlcpy+0x39>
  801dec:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801df0:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801df2:	39 c2                	cmp    %eax,%edx
  801df4:	74 14                	je     801e0a <strlcpy+0x36>
  801df6:	0f b6 19             	movzbl (%ecx),%ebx
  801df9:	84 db                	test   %bl,%bl
  801dfb:	74 0b                	je     801e08 <strlcpy+0x34>
			*dst++ = *src++;
  801dfd:	83 c1 01             	add    $0x1,%ecx
  801e00:	83 c2 01             	add    $0x1,%edx
  801e03:	88 5a ff             	mov    %bl,-0x1(%edx)
  801e06:	eb ea                	jmp    801df2 <strlcpy+0x1e>
  801e08:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801e0a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801e0d:	29 f0                	sub    %esi,%eax
}
  801e0f:	5b                   	pop    %ebx
  801e10:	5e                   	pop    %esi
  801e11:	5d                   	pop    %ebp
  801e12:	c3                   	ret    

00801e13 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801e13:	f3 0f 1e fb          	endbr32 
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e1d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801e20:	0f b6 01             	movzbl (%ecx),%eax
  801e23:	84 c0                	test   %al,%al
  801e25:	74 0c                	je     801e33 <strcmp+0x20>
  801e27:	3a 02                	cmp    (%edx),%al
  801e29:	75 08                	jne    801e33 <strcmp+0x20>
		p++, q++;
  801e2b:	83 c1 01             	add    $0x1,%ecx
  801e2e:	83 c2 01             	add    $0x1,%edx
  801e31:	eb ed                	jmp    801e20 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e33:	0f b6 c0             	movzbl %al,%eax
  801e36:	0f b6 12             	movzbl (%edx),%edx
  801e39:	29 d0                	sub    %edx,%eax
}
  801e3b:	5d                   	pop    %ebp
  801e3c:	c3                   	ret    

00801e3d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801e3d:	f3 0f 1e fb          	endbr32 
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	53                   	push   %ebx
  801e45:	8b 45 08             	mov    0x8(%ebp),%eax
  801e48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4b:	89 c3                	mov    %eax,%ebx
  801e4d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801e50:	eb 06                	jmp    801e58 <strncmp+0x1b>
		n--, p++, q++;
  801e52:	83 c0 01             	add    $0x1,%eax
  801e55:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801e58:	39 d8                	cmp    %ebx,%eax
  801e5a:	74 16                	je     801e72 <strncmp+0x35>
  801e5c:	0f b6 08             	movzbl (%eax),%ecx
  801e5f:	84 c9                	test   %cl,%cl
  801e61:	74 04                	je     801e67 <strncmp+0x2a>
  801e63:	3a 0a                	cmp    (%edx),%cl
  801e65:	74 eb                	je     801e52 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801e67:	0f b6 00             	movzbl (%eax),%eax
  801e6a:	0f b6 12             	movzbl (%edx),%edx
  801e6d:	29 d0                	sub    %edx,%eax
}
  801e6f:	5b                   	pop    %ebx
  801e70:	5d                   	pop    %ebp
  801e71:	c3                   	ret    
		return 0;
  801e72:	b8 00 00 00 00       	mov    $0x0,%eax
  801e77:	eb f6                	jmp    801e6f <strncmp+0x32>

00801e79 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801e79:	f3 0f 1e fb          	endbr32 
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	8b 45 08             	mov    0x8(%ebp),%eax
  801e83:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e87:	0f b6 10             	movzbl (%eax),%edx
  801e8a:	84 d2                	test   %dl,%dl
  801e8c:	74 09                	je     801e97 <strchr+0x1e>
		if (*s == c)
  801e8e:	38 ca                	cmp    %cl,%dl
  801e90:	74 0a                	je     801e9c <strchr+0x23>
	for (; *s; s++)
  801e92:	83 c0 01             	add    $0x1,%eax
  801e95:	eb f0                	jmp    801e87 <strchr+0xe>
			return (char *) s;
	return 0;
  801e97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e9c:	5d                   	pop    %ebp
  801e9d:	c3                   	ret    

00801e9e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801e9e:	f3 0f 1e fb          	endbr32 
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801eac:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801eaf:	38 ca                	cmp    %cl,%dl
  801eb1:	74 09                	je     801ebc <strfind+0x1e>
  801eb3:	84 d2                	test   %dl,%dl
  801eb5:	74 05                	je     801ebc <strfind+0x1e>
	for (; *s; s++)
  801eb7:	83 c0 01             	add    $0x1,%eax
  801eba:	eb f0                	jmp    801eac <strfind+0xe>
			break;
	return (char *) s;
}
  801ebc:	5d                   	pop    %ebp
  801ebd:	c3                   	ret    

00801ebe <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801ebe:	f3 0f 1e fb          	endbr32 
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	57                   	push   %edi
  801ec6:	56                   	push   %esi
  801ec7:	53                   	push   %ebx
  801ec8:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ecb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801ece:	85 c9                	test   %ecx,%ecx
  801ed0:	74 31                	je     801f03 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801ed2:	89 f8                	mov    %edi,%eax
  801ed4:	09 c8                	or     %ecx,%eax
  801ed6:	a8 03                	test   $0x3,%al
  801ed8:	75 23                	jne    801efd <memset+0x3f>
		c &= 0xFF;
  801eda:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801ede:	89 d3                	mov    %edx,%ebx
  801ee0:	c1 e3 08             	shl    $0x8,%ebx
  801ee3:	89 d0                	mov    %edx,%eax
  801ee5:	c1 e0 18             	shl    $0x18,%eax
  801ee8:	89 d6                	mov    %edx,%esi
  801eea:	c1 e6 10             	shl    $0x10,%esi
  801eed:	09 f0                	or     %esi,%eax
  801eef:	09 c2                	or     %eax,%edx
  801ef1:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801ef3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801ef6:	89 d0                	mov    %edx,%eax
  801ef8:	fc                   	cld    
  801ef9:	f3 ab                	rep stos %eax,%es:(%edi)
  801efb:	eb 06                	jmp    801f03 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f00:	fc                   	cld    
  801f01:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801f03:	89 f8                	mov    %edi,%eax
  801f05:	5b                   	pop    %ebx
  801f06:	5e                   	pop    %esi
  801f07:	5f                   	pop    %edi
  801f08:	5d                   	pop    %ebp
  801f09:	c3                   	ret    

00801f0a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801f0a:	f3 0f 1e fb          	endbr32 
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
  801f11:	57                   	push   %edi
  801f12:	56                   	push   %esi
  801f13:	8b 45 08             	mov    0x8(%ebp),%eax
  801f16:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f19:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801f1c:	39 c6                	cmp    %eax,%esi
  801f1e:	73 32                	jae    801f52 <memmove+0x48>
  801f20:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801f23:	39 c2                	cmp    %eax,%edx
  801f25:	76 2b                	jbe    801f52 <memmove+0x48>
		s += n;
		d += n;
  801f27:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801f2a:	89 fe                	mov    %edi,%esi
  801f2c:	09 ce                	or     %ecx,%esi
  801f2e:	09 d6                	or     %edx,%esi
  801f30:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801f36:	75 0e                	jne    801f46 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801f38:	83 ef 04             	sub    $0x4,%edi
  801f3b:	8d 72 fc             	lea    -0x4(%edx),%esi
  801f3e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801f41:	fd                   	std    
  801f42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801f44:	eb 09                	jmp    801f4f <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801f46:	83 ef 01             	sub    $0x1,%edi
  801f49:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801f4c:	fd                   	std    
  801f4d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801f4f:	fc                   	cld    
  801f50:	eb 1a                	jmp    801f6c <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801f52:	89 c2                	mov    %eax,%edx
  801f54:	09 ca                	or     %ecx,%edx
  801f56:	09 f2                	or     %esi,%edx
  801f58:	f6 c2 03             	test   $0x3,%dl
  801f5b:	75 0a                	jne    801f67 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801f5d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801f60:	89 c7                	mov    %eax,%edi
  801f62:	fc                   	cld    
  801f63:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801f65:	eb 05                	jmp    801f6c <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801f67:	89 c7                	mov    %eax,%edi
  801f69:	fc                   	cld    
  801f6a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801f6c:	5e                   	pop    %esi
  801f6d:	5f                   	pop    %edi
  801f6e:	5d                   	pop    %ebp
  801f6f:	c3                   	ret    

00801f70 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801f70:	f3 0f 1e fb          	endbr32 
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801f7a:	ff 75 10             	pushl  0x10(%ebp)
  801f7d:	ff 75 0c             	pushl  0xc(%ebp)
  801f80:	ff 75 08             	pushl  0x8(%ebp)
  801f83:	e8 82 ff ff ff       	call   801f0a <memmove>
}
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801f8a:	f3 0f 1e fb          	endbr32 
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
  801f91:	56                   	push   %esi
  801f92:	53                   	push   %ebx
  801f93:	8b 45 08             	mov    0x8(%ebp),%eax
  801f96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f99:	89 c6                	mov    %eax,%esi
  801f9b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801f9e:	39 f0                	cmp    %esi,%eax
  801fa0:	74 1c                	je     801fbe <memcmp+0x34>
		if (*s1 != *s2)
  801fa2:	0f b6 08             	movzbl (%eax),%ecx
  801fa5:	0f b6 1a             	movzbl (%edx),%ebx
  801fa8:	38 d9                	cmp    %bl,%cl
  801faa:	75 08                	jne    801fb4 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801fac:	83 c0 01             	add    $0x1,%eax
  801faf:	83 c2 01             	add    $0x1,%edx
  801fb2:	eb ea                	jmp    801f9e <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801fb4:	0f b6 c1             	movzbl %cl,%eax
  801fb7:	0f b6 db             	movzbl %bl,%ebx
  801fba:	29 d8                	sub    %ebx,%eax
  801fbc:	eb 05                	jmp    801fc3 <memcmp+0x39>
	}

	return 0;
  801fbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc3:	5b                   	pop    %ebx
  801fc4:	5e                   	pop    %esi
  801fc5:	5d                   	pop    %ebp
  801fc6:	c3                   	ret    

00801fc7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801fc7:	f3 0f 1e fb          	endbr32 
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801fd4:	89 c2                	mov    %eax,%edx
  801fd6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801fd9:	39 d0                	cmp    %edx,%eax
  801fdb:	73 09                	jae    801fe6 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801fdd:	38 08                	cmp    %cl,(%eax)
  801fdf:	74 05                	je     801fe6 <memfind+0x1f>
	for (; s < ends; s++)
  801fe1:	83 c0 01             	add    $0x1,%eax
  801fe4:	eb f3                	jmp    801fd9 <memfind+0x12>
			break;
	return (void *) s;
}
  801fe6:	5d                   	pop    %ebp
  801fe7:	c3                   	ret    

00801fe8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801fe8:	f3 0f 1e fb          	endbr32 
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	57                   	push   %edi
  801ff0:	56                   	push   %esi
  801ff1:	53                   	push   %ebx
  801ff2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ff5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801ff8:	eb 03                	jmp    801ffd <strtol+0x15>
		s++;
  801ffa:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801ffd:	0f b6 01             	movzbl (%ecx),%eax
  802000:	3c 20                	cmp    $0x20,%al
  802002:	74 f6                	je     801ffa <strtol+0x12>
  802004:	3c 09                	cmp    $0x9,%al
  802006:	74 f2                	je     801ffa <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  802008:	3c 2b                	cmp    $0x2b,%al
  80200a:	74 2a                	je     802036 <strtol+0x4e>
	int neg = 0;
  80200c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  802011:	3c 2d                	cmp    $0x2d,%al
  802013:	74 2b                	je     802040 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802015:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80201b:	75 0f                	jne    80202c <strtol+0x44>
  80201d:	80 39 30             	cmpb   $0x30,(%ecx)
  802020:	74 28                	je     80204a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  802022:	85 db                	test   %ebx,%ebx
  802024:	b8 0a 00 00 00       	mov    $0xa,%eax
  802029:	0f 44 d8             	cmove  %eax,%ebx
  80202c:	b8 00 00 00 00       	mov    $0x0,%eax
  802031:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802034:	eb 46                	jmp    80207c <strtol+0x94>
		s++;
  802036:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  802039:	bf 00 00 00 00       	mov    $0x0,%edi
  80203e:	eb d5                	jmp    802015 <strtol+0x2d>
		s++, neg = 1;
  802040:	83 c1 01             	add    $0x1,%ecx
  802043:	bf 01 00 00 00       	mov    $0x1,%edi
  802048:	eb cb                	jmp    802015 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80204a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80204e:	74 0e                	je     80205e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  802050:	85 db                	test   %ebx,%ebx
  802052:	75 d8                	jne    80202c <strtol+0x44>
		s++, base = 8;
  802054:	83 c1 01             	add    $0x1,%ecx
  802057:	bb 08 00 00 00       	mov    $0x8,%ebx
  80205c:	eb ce                	jmp    80202c <strtol+0x44>
		s += 2, base = 16;
  80205e:	83 c1 02             	add    $0x2,%ecx
  802061:	bb 10 00 00 00       	mov    $0x10,%ebx
  802066:	eb c4                	jmp    80202c <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  802068:	0f be d2             	movsbl %dl,%edx
  80206b:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80206e:	3b 55 10             	cmp    0x10(%ebp),%edx
  802071:	7d 3a                	jge    8020ad <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  802073:	83 c1 01             	add    $0x1,%ecx
  802076:	0f af 45 10          	imul   0x10(%ebp),%eax
  80207a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80207c:	0f b6 11             	movzbl (%ecx),%edx
  80207f:	8d 72 d0             	lea    -0x30(%edx),%esi
  802082:	89 f3                	mov    %esi,%ebx
  802084:	80 fb 09             	cmp    $0x9,%bl
  802087:	76 df                	jbe    802068 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  802089:	8d 72 9f             	lea    -0x61(%edx),%esi
  80208c:	89 f3                	mov    %esi,%ebx
  80208e:	80 fb 19             	cmp    $0x19,%bl
  802091:	77 08                	ja     80209b <strtol+0xb3>
			dig = *s - 'a' + 10;
  802093:	0f be d2             	movsbl %dl,%edx
  802096:	83 ea 57             	sub    $0x57,%edx
  802099:	eb d3                	jmp    80206e <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  80209b:	8d 72 bf             	lea    -0x41(%edx),%esi
  80209e:	89 f3                	mov    %esi,%ebx
  8020a0:	80 fb 19             	cmp    $0x19,%bl
  8020a3:	77 08                	ja     8020ad <strtol+0xc5>
			dig = *s - 'A' + 10;
  8020a5:	0f be d2             	movsbl %dl,%edx
  8020a8:	83 ea 37             	sub    $0x37,%edx
  8020ab:	eb c1                	jmp    80206e <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  8020ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020b1:	74 05                	je     8020b8 <strtol+0xd0>
		*endptr = (char *) s;
  8020b3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020b6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8020b8:	89 c2                	mov    %eax,%edx
  8020ba:	f7 da                	neg    %edx
  8020bc:	85 ff                	test   %edi,%edi
  8020be:	0f 45 c2             	cmovne %edx,%eax
}
  8020c1:	5b                   	pop    %ebx
  8020c2:	5e                   	pop    %esi
  8020c3:	5f                   	pop    %edi
  8020c4:	5d                   	pop    %ebp
  8020c5:	c3                   	ret    

008020c6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020c6:	f3 0f 1e fb          	endbr32 
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	56                   	push   %esi
  8020ce:	53                   	push   %ebx
  8020cf:	8b 75 08             	mov    0x8(%ebp),%esi
  8020d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	74 3d                	je     802119 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8020dc:	83 ec 0c             	sub    $0xc,%esp
  8020df:	50                   	push   %eax
  8020e0:	e8 88 e2 ff ff       	call   80036d <sys_ipc_recv>
  8020e5:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8020e8:	85 f6                	test   %esi,%esi
  8020ea:	74 0b                	je     8020f7 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8020ec:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020f2:	8b 52 74             	mov    0x74(%edx),%edx
  8020f5:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8020f7:	85 db                	test   %ebx,%ebx
  8020f9:	74 0b                	je     802106 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8020fb:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802101:	8b 52 78             	mov    0x78(%edx),%edx
  802104:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  802106:	85 c0                	test   %eax,%eax
  802108:	78 21                	js     80212b <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  80210a:	a1 08 40 80 00       	mov    0x804008,%eax
  80210f:	8b 40 70             	mov    0x70(%eax),%eax
}
  802112:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802115:	5b                   	pop    %ebx
  802116:	5e                   	pop    %esi
  802117:	5d                   	pop    %ebp
  802118:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802119:	83 ec 0c             	sub    $0xc,%esp
  80211c:	68 00 00 c0 ee       	push   $0xeec00000
  802121:	e8 47 e2 ff ff       	call   80036d <sys_ipc_recv>
  802126:	83 c4 10             	add    $0x10,%esp
  802129:	eb bd                	jmp    8020e8 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  80212b:	85 f6                	test   %esi,%esi
  80212d:	74 10                	je     80213f <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  80212f:	85 db                	test   %ebx,%ebx
  802131:	75 df                	jne    802112 <ipc_recv+0x4c>
  802133:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80213a:	00 00 00 
  80213d:	eb d3                	jmp    802112 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  80213f:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802146:	00 00 00 
  802149:	eb e4                	jmp    80212f <ipc_recv+0x69>

0080214b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80214b:	f3 0f 1e fb          	endbr32 
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
  802152:	57                   	push   %edi
  802153:	56                   	push   %esi
  802154:	53                   	push   %ebx
  802155:	83 ec 0c             	sub    $0xc,%esp
  802158:	8b 7d 08             	mov    0x8(%ebp),%edi
  80215b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80215e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802161:	85 db                	test   %ebx,%ebx
  802163:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802168:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  80216b:	ff 75 14             	pushl  0x14(%ebp)
  80216e:	53                   	push   %ebx
  80216f:	56                   	push   %esi
  802170:	57                   	push   %edi
  802171:	e8 d0 e1 ff ff       	call   800346 <sys_ipc_try_send>
  802176:	83 c4 10             	add    $0x10,%esp
  802179:	85 c0                	test   %eax,%eax
  80217b:	79 1e                	jns    80219b <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  80217d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802180:	75 07                	jne    802189 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802182:	e8 f7 df ff ff       	call   80017e <sys_yield>
  802187:	eb e2                	jmp    80216b <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802189:	50                   	push   %eax
  80218a:	68 ff 28 80 00       	push   $0x8028ff
  80218f:	6a 59                	push   $0x59
  802191:	68 1a 29 80 00       	push   $0x80291a
  802196:	e8 c8 f4 ff ff       	call   801663 <_panic>
	}
}
  80219b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80219e:	5b                   	pop    %ebx
  80219f:	5e                   	pop    %esi
  8021a0:	5f                   	pop    %edi
  8021a1:	5d                   	pop    %ebp
  8021a2:	c3                   	ret    

008021a3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8021a3:	f3 0f 1e fb          	endbr32 
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
  8021aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021ad:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8021b2:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8021b5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021bb:	8b 52 50             	mov    0x50(%edx),%edx
  8021be:	39 ca                	cmp    %ecx,%edx
  8021c0:	74 11                	je     8021d3 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8021c2:	83 c0 01             	add    $0x1,%eax
  8021c5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021ca:	75 e6                	jne    8021b2 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8021cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d1:	eb 0b                	jmp    8021de <ipc_find_env+0x3b>
			return envs[i].env_id;
  8021d3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021d6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021db:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021de:	5d                   	pop    %ebp
  8021df:	c3                   	ret    

008021e0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021e0:	f3 0f 1e fb          	endbr32 
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021ea:	89 c2                	mov    %eax,%edx
  8021ec:	c1 ea 16             	shr    $0x16,%edx
  8021ef:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8021f6:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021fb:	f6 c1 01             	test   $0x1,%cl
  8021fe:	74 1c                	je     80221c <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802200:	c1 e8 0c             	shr    $0xc,%eax
  802203:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80220a:	a8 01                	test   $0x1,%al
  80220c:	74 0e                	je     80221c <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80220e:	c1 e8 0c             	shr    $0xc,%eax
  802211:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802218:	ef 
  802219:	0f b7 d2             	movzwl %dx,%edx
}
  80221c:	89 d0                	mov    %edx,%eax
  80221e:	5d                   	pop    %ebp
  80221f:	c3                   	ret    

00802220 <__udivdi3>:
  802220:	f3 0f 1e fb          	endbr32 
  802224:	55                   	push   %ebp
  802225:	57                   	push   %edi
  802226:	56                   	push   %esi
  802227:	53                   	push   %ebx
  802228:	83 ec 1c             	sub    $0x1c,%esp
  80222b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80222f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802233:	8b 74 24 34          	mov    0x34(%esp),%esi
  802237:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80223b:	85 d2                	test   %edx,%edx
  80223d:	75 19                	jne    802258 <__udivdi3+0x38>
  80223f:	39 f3                	cmp    %esi,%ebx
  802241:	76 4d                	jbe    802290 <__udivdi3+0x70>
  802243:	31 ff                	xor    %edi,%edi
  802245:	89 e8                	mov    %ebp,%eax
  802247:	89 f2                	mov    %esi,%edx
  802249:	f7 f3                	div    %ebx
  80224b:	89 fa                	mov    %edi,%edx
  80224d:	83 c4 1c             	add    $0x1c,%esp
  802250:	5b                   	pop    %ebx
  802251:	5e                   	pop    %esi
  802252:	5f                   	pop    %edi
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    
  802255:	8d 76 00             	lea    0x0(%esi),%esi
  802258:	39 f2                	cmp    %esi,%edx
  80225a:	76 14                	jbe    802270 <__udivdi3+0x50>
  80225c:	31 ff                	xor    %edi,%edi
  80225e:	31 c0                	xor    %eax,%eax
  802260:	89 fa                	mov    %edi,%edx
  802262:	83 c4 1c             	add    $0x1c,%esp
  802265:	5b                   	pop    %ebx
  802266:	5e                   	pop    %esi
  802267:	5f                   	pop    %edi
  802268:	5d                   	pop    %ebp
  802269:	c3                   	ret    
  80226a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802270:	0f bd fa             	bsr    %edx,%edi
  802273:	83 f7 1f             	xor    $0x1f,%edi
  802276:	75 48                	jne    8022c0 <__udivdi3+0xa0>
  802278:	39 f2                	cmp    %esi,%edx
  80227a:	72 06                	jb     802282 <__udivdi3+0x62>
  80227c:	31 c0                	xor    %eax,%eax
  80227e:	39 eb                	cmp    %ebp,%ebx
  802280:	77 de                	ja     802260 <__udivdi3+0x40>
  802282:	b8 01 00 00 00       	mov    $0x1,%eax
  802287:	eb d7                	jmp    802260 <__udivdi3+0x40>
  802289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802290:	89 d9                	mov    %ebx,%ecx
  802292:	85 db                	test   %ebx,%ebx
  802294:	75 0b                	jne    8022a1 <__udivdi3+0x81>
  802296:	b8 01 00 00 00       	mov    $0x1,%eax
  80229b:	31 d2                	xor    %edx,%edx
  80229d:	f7 f3                	div    %ebx
  80229f:	89 c1                	mov    %eax,%ecx
  8022a1:	31 d2                	xor    %edx,%edx
  8022a3:	89 f0                	mov    %esi,%eax
  8022a5:	f7 f1                	div    %ecx
  8022a7:	89 c6                	mov    %eax,%esi
  8022a9:	89 e8                	mov    %ebp,%eax
  8022ab:	89 f7                	mov    %esi,%edi
  8022ad:	f7 f1                	div    %ecx
  8022af:	89 fa                	mov    %edi,%edx
  8022b1:	83 c4 1c             	add    $0x1c,%esp
  8022b4:	5b                   	pop    %ebx
  8022b5:	5e                   	pop    %esi
  8022b6:	5f                   	pop    %edi
  8022b7:	5d                   	pop    %ebp
  8022b8:	c3                   	ret    
  8022b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022c0:	89 f9                	mov    %edi,%ecx
  8022c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022c7:	29 f8                	sub    %edi,%eax
  8022c9:	d3 e2                	shl    %cl,%edx
  8022cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022cf:	89 c1                	mov    %eax,%ecx
  8022d1:	89 da                	mov    %ebx,%edx
  8022d3:	d3 ea                	shr    %cl,%edx
  8022d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022d9:	09 d1                	or     %edx,%ecx
  8022db:	89 f2                	mov    %esi,%edx
  8022dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022e1:	89 f9                	mov    %edi,%ecx
  8022e3:	d3 e3                	shl    %cl,%ebx
  8022e5:	89 c1                	mov    %eax,%ecx
  8022e7:	d3 ea                	shr    %cl,%edx
  8022e9:	89 f9                	mov    %edi,%ecx
  8022eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022ef:	89 eb                	mov    %ebp,%ebx
  8022f1:	d3 e6                	shl    %cl,%esi
  8022f3:	89 c1                	mov    %eax,%ecx
  8022f5:	d3 eb                	shr    %cl,%ebx
  8022f7:	09 de                	or     %ebx,%esi
  8022f9:	89 f0                	mov    %esi,%eax
  8022fb:	f7 74 24 08          	divl   0x8(%esp)
  8022ff:	89 d6                	mov    %edx,%esi
  802301:	89 c3                	mov    %eax,%ebx
  802303:	f7 64 24 0c          	mull   0xc(%esp)
  802307:	39 d6                	cmp    %edx,%esi
  802309:	72 15                	jb     802320 <__udivdi3+0x100>
  80230b:	89 f9                	mov    %edi,%ecx
  80230d:	d3 e5                	shl    %cl,%ebp
  80230f:	39 c5                	cmp    %eax,%ebp
  802311:	73 04                	jae    802317 <__udivdi3+0xf7>
  802313:	39 d6                	cmp    %edx,%esi
  802315:	74 09                	je     802320 <__udivdi3+0x100>
  802317:	89 d8                	mov    %ebx,%eax
  802319:	31 ff                	xor    %edi,%edi
  80231b:	e9 40 ff ff ff       	jmp    802260 <__udivdi3+0x40>
  802320:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802323:	31 ff                	xor    %edi,%edi
  802325:	e9 36 ff ff ff       	jmp    802260 <__udivdi3+0x40>
  80232a:	66 90                	xchg   %ax,%ax
  80232c:	66 90                	xchg   %ax,%ax
  80232e:	66 90                	xchg   %ax,%ax

00802330 <__umoddi3>:
  802330:	f3 0f 1e fb          	endbr32 
  802334:	55                   	push   %ebp
  802335:	57                   	push   %edi
  802336:	56                   	push   %esi
  802337:	53                   	push   %ebx
  802338:	83 ec 1c             	sub    $0x1c,%esp
  80233b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80233f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802343:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802347:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80234b:	85 c0                	test   %eax,%eax
  80234d:	75 19                	jne    802368 <__umoddi3+0x38>
  80234f:	39 df                	cmp    %ebx,%edi
  802351:	76 5d                	jbe    8023b0 <__umoddi3+0x80>
  802353:	89 f0                	mov    %esi,%eax
  802355:	89 da                	mov    %ebx,%edx
  802357:	f7 f7                	div    %edi
  802359:	89 d0                	mov    %edx,%eax
  80235b:	31 d2                	xor    %edx,%edx
  80235d:	83 c4 1c             	add    $0x1c,%esp
  802360:	5b                   	pop    %ebx
  802361:	5e                   	pop    %esi
  802362:	5f                   	pop    %edi
  802363:	5d                   	pop    %ebp
  802364:	c3                   	ret    
  802365:	8d 76 00             	lea    0x0(%esi),%esi
  802368:	89 f2                	mov    %esi,%edx
  80236a:	39 d8                	cmp    %ebx,%eax
  80236c:	76 12                	jbe    802380 <__umoddi3+0x50>
  80236e:	89 f0                	mov    %esi,%eax
  802370:	89 da                	mov    %ebx,%edx
  802372:	83 c4 1c             	add    $0x1c,%esp
  802375:	5b                   	pop    %ebx
  802376:	5e                   	pop    %esi
  802377:	5f                   	pop    %edi
  802378:	5d                   	pop    %ebp
  802379:	c3                   	ret    
  80237a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802380:	0f bd e8             	bsr    %eax,%ebp
  802383:	83 f5 1f             	xor    $0x1f,%ebp
  802386:	75 50                	jne    8023d8 <__umoddi3+0xa8>
  802388:	39 d8                	cmp    %ebx,%eax
  80238a:	0f 82 e0 00 00 00    	jb     802470 <__umoddi3+0x140>
  802390:	89 d9                	mov    %ebx,%ecx
  802392:	39 f7                	cmp    %esi,%edi
  802394:	0f 86 d6 00 00 00    	jbe    802470 <__umoddi3+0x140>
  80239a:	89 d0                	mov    %edx,%eax
  80239c:	89 ca                	mov    %ecx,%edx
  80239e:	83 c4 1c             	add    $0x1c,%esp
  8023a1:	5b                   	pop    %ebx
  8023a2:	5e                   	pop    %esi
  8023a3:	5f                   	pop    %edi
  8023a4:	5d                   	pop    %ebp
  8023a5:	c3                   	ret    
  8023a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ad:	8d 76 00             	lea    0x0(%esi),%esi
  8023b0:	89 fd                	mov    %edi,%ebp
  8023b2:	85 ff                	test   %edi,%edi
  8023b4:	75 0b                	jne    8023c1 <__umoddi3+0x91>
  8023b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023bb:	31 d2                	xor    %edx,%edx
  8023bd:	f7 f7                	div    %edi
  8023bf:	89 c5                	mov    %eax,%ebp
  8023c1:	89 d8                	mov    %ebx,%eax
  8023c3:	31 d2                	xor    %edx,%edx
  8023c5:	f7 f5                	div    %ebp
  8023c7:	89 f0                	mov    %esi,%eax
  8023c9:	f7 f5                	div    %ebp
  8023cb:	89 d0                	mov    %edx,%eax
  8023cd:	31 d2                	xor    %edx,%edx
  8023cf:	eb 8c                	jmp    80235d <__umoddi3+0x2d>
  8023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023d8:	89 e9                	mov    %ebp,%ecx
  8023da:	ba 20 00 00 00       	mov    $0x20,%edx
  8023df:	29 ea                	sub    %ebp,%edx
  8023e1:	d3 e0                	shl    %cl,%eax
  8023e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023e7:	89 d1                	mov    %edx,%ecx
  8023e9:	89 f8                	mov    %edi,%eax
  8023eb:	d3 e8                	shr    %cl,%eax
  8023ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023f9:	09 c1                	or     %eax,%ecx
  8023fb:	89 d8                	mov    %ebx,%eax
  8023fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802401:	89 e9                	mov    %ebp,%ecx
  802403:	d3 e7                	shl    %cl,%edi
  802405:	89 d1                	mov    %edx,%ecx
  802407:	d3 e8                	shr    %cl,%eax
  802409:	89 e9                	mov    %ebp,%ecx
  80240b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80240f:	d3 e3                	shl    %cl,%ebx
  802411:	89 c7                	mov    %eax,%edi
  802413:	89 d1                	mov    %edx,%ecx
  802415:	89 f0                	mov    %esi,%eax
  802417:	d3 e8                	shr    %cl,%eax
  802419:	89 e9                	mov    %ebp,%ecx
  80241b:	89 fa                	mov    %edi,%edx
  80241d:	d3 e6                	shl    %cl,%esi
  80241f:	09 d8                	or     %ebx,%eax
  802421:	f7 74 24 08          	divl   0x8(%esp)
  802425:	89 d1                	mov    %edx,%ecx
  802427:	89 f3                	mov    %esi,%ebx
  802429:	f7 64 24 0c          	mull   0xc(%esp)
  80242d:	89 c6                	mov    %eax,%esi
  80242f:	89 d7                	mov    %edx,%edi
  802431:	39 d1                	cmp    %edx,%ecx
  802433:	72 06                	jb     80243b <__umoddi3+0x10b>
  802435:	75 10                	jne    802447 <__umoddi3+0x117>
  802437:	39 c3                	cmp    %eax,%ebx
  802439:	73 0c                	jae    802447 <__umoddi3+0x117>
  80243b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80243f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802443:	89 d7                	mov    %edx,%edi
  802445:	89 c6                	mov    %eax,%esi
  802447:	89 ca                	mov    %ecx,%edx
  802449:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80244e:	29 f3                	sub    %esi,%ebx
  802450:	19 fa                	sbb    %edi,%edx
  802452:	89 d0                	mov    %edx,%eax
  802454:	d3 e0                	shl    %cl,%eax
  802456:	89 e9                	mov    %ebp,%ecx
  802458:	d3 eb                	shr    %cl,%ebx
  80245a:	d3 ea                	shr    %cl,%edx
  80245c:	09 d8                	or     %ebx,%eax
  80245e:	83 c4 1c             	add    $0x1c,%esp
  802461:	5b                   	pop    %ebx
  802462:	5e                   	pop    %esi
  802463:	5f                   	pop    %edi
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    
  802466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80246d:	8d 76 00             	lea    0x0(%esi),%esi
  802470:	29 fe                	sub    %edi,%esi
  802472:	19 c3                	sbb    %eax,%ebx
  802474:	89 f2                	mov    %esi,%edx
  802476:	89 d9                	mov    %ebx,%ecx
  802478:	e9 1d ff ff ff       	jmp    80239a <__umoddi3+0x6a>
