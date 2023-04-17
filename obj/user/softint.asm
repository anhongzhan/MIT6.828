
obj/user/softint.debug:     file format elf32-i386


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
  800049:	e8 de 00 00 00       	call   80012c <sys_getenvid>
  80004e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800053:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800056:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005b:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800060:	85 db                	test   %ebx,%ebx
  800062:	7e 07                	jle    80006b <libmain+0x31>
		binaryname = argv[0];
  800064:	8b 06                	mov    (%esi),%eax
  800066:	a3 00 30 80 00       	mov    %eax,0x803000

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
  80008b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80008e:	e8 df 04 00 00       	call   800572 <close_all>
	sys_env_destroy(0);
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	6a 00                	push   $0x0
  800098:	e8 4a 00 00 00       	call   8000e7 <sys_env_destroy>
}
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a2:	f3 0f 1e fb          	endbr32 
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	57                   	push   %edi
  8000aa:	56                   	push   %esi
  8000ab:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b7:	89 c3                	mov    %eax,%ebx
  8000b9:	89 c7                	mov    %eax,%edi
  8000bb:	89 c6                	mov    %eax,%esi
  8000bd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000bf:	5b                   	pop    %ebx
  8000c0:	5e                   	pop    %esi
  8000c1:	5f                   	pop    %edi
  8000c2:	5d                   	pop    %ebp
  8000c3:	c3                   	ret    

008000c4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c4:	f3 0f 1e fb          	endbr32 
  8000c8:	55                   	push   %ebp
  8000c9:	89 e5                	mov    %esp,%ebp
  8000cb:	57                   	push   %edi
  8000cc:	56                   	push   %esi
  8000cd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d8:	89 d1                	mov    %edx,%ecx
  8000da:	89 d3                	mov    %edx,%ebx
  8000dc:	89 d7                	mov    %edx,%edi
  8000de:	89 d6                	mov    %edx,%esi
  8000e0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e2:	5b                   	pop    %ebx
  8000e3:	5e                   	pop    %esi
  8000e4:	5f                   	pop    %edi
  8000e5:	5d                   	pop    %ebp
  8000e6:	c3                   	ret    

008000e7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e7:	f3 0f 1e fb          	endbr32 
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000fc:	b8 03 00 00 00       	mov    $0x3,%eax
  800101:	89 cb                	mov    %ecx,%ebx
  800103:	89 cf                	mov    %ecx,%edi
  800105:	89 ce                	mov    %ecx,%esi
  800107:	cd 30                	int    $0x30
	if(check && ret > 0)
  800109:	85 c0                	test   %eax,%eax
  80010b:	7f 08                	jg     800115 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80010d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800110:	5b                   	pop    %ebx
  800111:	5e                   	pop    %esi
  800112:	5f                   	pop    %edi
  800113:	5d                   	pop    %ebp
  800114:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	50                   	push   %eax
  800119:	6a 03                	push   $0x3
  80011b:	68 0a 1f 80 00       	push   $0x801f0a
  800120:	6a 23                	push   $0x23
  800122:	68 27 1f 80 00       	push   $0x801f27
  800127:	e8 9c 0f 00 00       	call   8010c8 <_panic>

0080012c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80012c:	f3 0f 1e fb          	endbr32 
  800130:	55                   	push   %ebp
  800131:	89 e5                	mov    %esp,%ebp
  800133:	57                   	push   %edi
  800134:	56                   	push   %esi
  800135:	53                   	push   %ebx
	asm volatile("int %1\n"
  800136:	ba 00 00 00 00       	mov    $0x0,%edx
  80013b:	b8 02 00 00 00       	mov    $0x2,%eax
  800140:	89 d1                	mov    %edx,%ecx
  800142:	89 d3                	mov    %edx,%ebx
  800144:	89 d7                	mov    %edx,%edi
  800146:	89 d6                	mov    %edx,%esi
  800148:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80014a:	5b                   	pop    %ebx
  80014b:	5e                   	pop    %esi
  80014c:	5f                   	pop    %edi
  80014d:	5d                   	pop    %ebp
  80014e:	c3                   	ret    

0080014f <sys_yield>:

void
sys_yield(void)
{
  80014f:	f3 0f 1e fb          	endbr32 
  800153:	55                   	push   %ebp
  800154:	89 e5                	mov    %esp,%ebp
  800156:	57                   	push   %edi
  800157:	56                   	push   %esi
  800158:	53                   	push   %ebx
	asm volatile("int %1\n"
  800159:	ba 00 00 00 00       	mov    $0x0,%edx
  80015e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800163:	89 d1                	mov    %edx,%ecx
  800165:	89 d3                	mov    %edx,%ebx
  800167:	89 d7                	mov    %edx,%edi
  800169:	89 d6                	mov    %edx,%esi
  80016b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80016d:	5b                   	pop    %ebx
  80016e:	5e                   	pop    %esi
  80016f:	5f                   	pop    %edi
  800170:	5d                   	pop    %ebp
  800171:	c3                   	ret    

00800172 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800172:	f3 0f 1e fb          	endbr32 
  800176:	55                   	push   %ebp
  800177:	89 e5                	mov    %esp,%ebp
  800179:	57                   	push   %edi
  80017a:	56                   	push   %esi
  80017b:	53                   	push   %ebx
  80017c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80017f:	be 00 00 00 00       	mov    $0x0,%esi
  800184:	8b 55 08             	mov    0x8(%ebp),%edx
  800187:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80018a:	b8 04 00 00 00       	mov    $0x4,%eax
  80018f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800192:	89 f7                	mov    %esi,%edi
  800194:	cd 30                	int    $0x30
	if(check && ret > 0)
  800196:	85 c0                	test   %eax,%eax
  800198:	7f 08                	jg     8001a2 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80019a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80019d:	5b                   	pop    %ebx
  80019e:	5e                   	pop    %esi
  80019f:	5f                   	pop    %edi
  8001a0:	5d                   	pop    %ebp
  8001a1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001a2:	83 ec 0c             	sub    $0xc,%esp
  8001a5:	50                   	push   %eax
  8001a6:	6a 04                	push   $0x4
  8001a8:	68 0a 1f 80 00       	push   $0x801f0a
  8001ad:	6a 23                	push   $0x23
  8001af:	68 27 1f 80 00       	push   $0x801f27
  8001b4:	e8 0f 0f 00 00       	call   8010c8 <_panic>

008001b9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001b9:	f3 0f 1e fb          	endbr32 
  8001bd:	55                   	push   %ebp
  8001be:	89 e5                	mov    %esp,%ebp
  8001c0:	57                   	push   %edi
  8001c1:	56                   	push   %esi
  8001c2:	53                   	push   %ebx
  8001c3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001cc:	b8 05 00 00 00       	mov    $0x5,%eax
  8001d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001d4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001d7:	8b 75 18             	mov    0x18(%ebp),%esi
  8001da:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001dc:	85 c0                	test   %eax,%eax
  8001de:	7f 08                	jg     8001e8 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e3:	5b                   	pop    %ebx
  8001e4:	5e                   	pop    %esi
  8001e5:	5f                   	pop    %edi
  8001e6:	5d                   	pop    %ebp
  8001e7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001e8:	83 ec 0c             	sub    $0xc,%esp
  8001eb:	50                   	push   %eax
  8001ec:	6a 05                	push   $0x5
  8001ee:	68 0a 1f 80 00       	push   $0x801f0a
  8001f3:	6a 23                	push   $0x23
  8001f5:	68 27 1f 80 00       	push   $0x801f27
  8001fa:	e8 c9 0e 00 00       	call   8010c8 <_panic>

008001ff <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001ff:	f3 0f 1e fb          	endbr32 
  800203:	55                   	push   %ebp
  800204:	89 e5                	mov    %esp,%ebp
  800206:	57                   	push   %edi
  800207:	56                   	push   %esi
  800208:	53                   	push   %ebx
  800209:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80020c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800211:	8b 55 08             	mov    0x8(%ebp),%edx
  800214:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800217:	b8 06 00 00 00       	mov    $0x6,%eax
  80021c:	89 df                	mov    %ebx,%edi
  80021e:	89 de                	mov    %ebx,%esi
  800220:	cd 30                	int    $0x30
	if(check && ret > 0)
  800222:	85 c0                	test   %eax,%eax
  800224:	7f 08                	jg     80022e <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800226:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800229:	5b                   	pop    %ebx
  80022a:	5e                   	pop    %esi
  80022b:	5f                   	pop    %edi
  80022c:	5d                   	pop    %ebp
  80022d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80022e:	83 ec 0c             	sub    $0xc,%esp
  800231:	50                   	push   %eax
  800232:	6a 06                	push   $0x6
  800234:	68 0a 1f 80 00       	push   $0x801f0a
  800239:	6a 23                	push   $0x23
  80023b:	68 27 1f 80 00       	push   $0x801f27
  800240:	e8 83 0e 00 00       	call   8010c8 <_panic>

00800245 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800245:	f3 0f 1e fb          	endbr32 
  800249:	55                   	push   %ebp
  80024a:	89 e5                	mov    %esp,%ebp
  80024c:	57                   	push   %edi
  80024d:	56                   	push   %esi
  80024e:	53                   	push   %ebx
  80024f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800252:	bb 00 00 00 00       	mov    $0x0,%ebx
  800257:	8b 55 08             	mov    0x8(%ebp),%edx
  80025a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80025d:	b8 08 00 00 00       	mov    $0x8,%eax
  800262:	89 df                	mov    %ebx,%edi
  800264:	89 de                	mov    %ebx,%esi
  800266:	cd 30                	int    $0x30
	if(check && ret > 0)
  800268:	85 c0                	test   %eax,%eax
  80026a:	7f 08                	jg     800274 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80026c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026f:	5b                   	pop    %ebx
  800270:	5e                   	pop    %esi
  800271:	5f                   	pop    %edi
  800272:	5d                   	pop    %ebp
  800273:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	50                   	push   %eax
  800278:	6a 08                	push   $0x8
  80027a:	68 0a 1f 80 00       	push   $0x801f0a
  80027f:	6a 23                	push   $0x23
  800281:	68 27 1f 80 00       	push   $0x801f27
  800286:	e8 3d 0e 00 00       	call   8010c8 <_panic>

0080028b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80028b:	f3 0f 1e fb          	endbr32 
  80028f:	55                   	push   %ebp
  800290:	89 e5                	mov    %esp,%ebp
  800292:	57                   	push   %edi
  800293:	56                   	push   %esi
  800294:	53                   	push   %ebx
  800295:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800298:	bb 00 00 00 00       	mov    $0x0,%ebx
  80029d:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002a3:	b8 09 00 00 00       	mov    $0x9,%eax
  8002a8:	89 df                	mov    %ebx,%edi
  8002aa:	89 de                	mov    %ebx,%esi
  8002ac:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002ae:	85 c0                	test   %eax,%eax
  8002b0:	7f 08                	jg     8002ba <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b5:	5b                   	pop    %ebx
  8002b6:	5e                   	pop    %esi
  8002b7:	5f                   	pop    %edi
  8002b8:	5d                   	pop    %ebp
  8002b9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002ba:	83 ec 0c             	sub    $0xc,%esp
  8002bd:	50                   	push   %eax
  8002be:	6a 09                	push   $0x9
  8002c0:	68 0a 1f 80 00       	push   $0x801f0a
  8002c5:	6a 23                	push   $0x23
  8002c7:	68 27 1f 80 00       	push   $0x801f27
  8002cc:	e8 f7 0d 00 00       	call   8010c8 <_panic>

008002d1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002d1:	f3 0f 1e fb          	endbr32 
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
  8002d8:	57                   	push   %edi
  8002d9:	56                   	push   %esi
  8002da:	53                   	push   %ebx
  8002db:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002ee:	89 df                	mov    %ebx,%edi
  8002f0:	89 de                	mov    %ebx,%esi
  8002f2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002f4:	85 c0                	test   %eax,%eax
  8002f6:	7f 08                	jg     800300 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002fb:	5b                   	pop    %ebx
  8002fc:	5e                   	pop    %esi
  8002fd:	5f                   	pop    %edi
  8002fe:	5d                   	pop    %ebp
  8002ff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	50                   	push   %eax
  800304:	6a 0a                	push   $0xa
  800306:	68 0a 1f 80 00       	push   $0x801f0a
  80030b:	6a 23                	push   $0x23
  80030d:	68 27 1f 80 00       	push   $0x801f27
  800312:	e8 b1 0d 00 00       	call   8010c8 <_panic>

00800317 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800317:	f3 0f 1e fb          	endbr32 
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	57                   	push   %edi
  80031f:	56                   	push   %esi
  800320:	53                   	push   %ebx
	asm volatile("int %1\n"
  800321:	8b 55 08             	mov    0x8(%ebp),%edx
  800324:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800327:	b8 0c 00 00 00       	mov    $0xc,%eax
  80032c:	be 00 00 00 00       	mov    $0x0,%esi
  800331:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800334:	8b 7d 14             	mov    0x14(%ebp),%edi
  800337:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800339:	5b                   	pop    %ebx
  80033a:	5e                   	pop    %esi
  80033b:	5f                   	pop    %edi
  80033c:	5d                   	pop    %ebp
  80033d:	c3                   	ret    

0080033e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80033e:	f3 0f 1e fb          	endbr32 
  800342:	55                   	push   %ebp
  800343:	89 e5                	mov    %esp,%ebp
  800345:	57                   	push   %edi
  800346:	56                   	push   %esi
  800347:	53                   	push   %ebx
  800348:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80034b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800350:	8b 55 08             	mov    0x8(%ebp),%edx
  800353:	b8 0d 00 00 00       	mov    $0xd,%eax
  800358:	89 cb                	mov    %ecx,%ebx
  80035a:	89 cf                	mov    %ecx,%edi
  80035c:	89 ce                	mov    %ecx,%esi
  80035e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800360:	85 c0                	test   %eax,%eax
  800362:	7f 08                	jg     80036c <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800364:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800367:	5b                   	pop    %ebx
  800368:	5e                   	pop    %esi
  800369:	5f                   	pop    %edi
  80036a:	5d                   	pop    %ebp
  80036b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80036c:	83 ec 0c             	sub    $0xc,%esp
  80036f:	50                   	push   %eax
  800370:	6a 0d                	push   $0xd
  800372:	68 0a 1f 80 00       	push   $0x801f0a
  800377:	6a 23                	push   $0x23
  800379:	68 27 1f 80 00       	push   $0x801f27
  80037e:	e8 45 0d 00 00       	call   8010c8 <_panic>

00800383 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800383:	f3 0f 1e fb          	endbr32 
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80038a:	8b 45 08             	mov    0x8(%ebp),%eax
  80038d:	05 00 00 00 30       	add    $0x30000000,%eax
  800392:	c1 e8 0c             	shr    $0xc,%eax
}
  800395:	5d                   	pop    %ebp
  800396:	c3                   	ret    

00800397 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800397:	f3 0f 1e fb          	endbr32 
  80039b:	55                   	push   %ebp
  80039c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ab:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003b0:	5d                   	pop    %ebp
  8003b1:	c3                   	ret    

008003b2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003b2:	f3 0f 1e fb          	endbr32 
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003be:	89 c2                	mov    %eax,%edx
  8003c0:	c1 ea 16             	shr    $0x16,%edx
  8003c3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003ca:	f6 c2 01             	test   $0x1,%dl
  8003cd:	74 2d                	je     8003fc <fd_alloc+0x4a>
  8003cf:	89 c2                	mov    %eax,%edx
  8003d1:	c1 ea 0c             	shr    $0xc,%edx
  8003d4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003db:	f6 c2 01             	test   $0x1,%dl
  8003de:	74 1c                	je     8003fc <fd_alloc+0x4a>
  8003e0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003e5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003ea:	75 d2                	jne    8003be <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8003f5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003fa:	eb 0a                	jmp    800406 <fd_alloc+0x54>
			*fd_store = fd;
  8003fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003ff:	89 01                	mov    %eax,(%ecx)
			return 0;
  800401:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800406:	5d                   	pop    %ebp
  800407:	c3                   	ret    

00800408 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800408:	f3 0f 1e fb          	endbr32 
  80040c:	55                   	push   %ebp
  80040d:	89 e5                	mov    %esp,%ebp
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800412:	83 f8 1f             	cmp    $0x1f,%eax
  800415:	77 30                	ja     800447 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800417:	c1 e0 0c             	shl    $0xc,%eax
  80041a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80041f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800425:	f6 c2 01             	test   $0x1,%dl
  800428:	74 24                	je     80044e <fd_lookup+0x46>
  80042a:	89 c2                	mov    %eax,%edx
  80042c:	c1 ea 0c             	shr    $0xc,%edx
  80042f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800436:	f6 c2 01             	test   $0x1,%dl
  800439:	74 1a                	je     800455 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80043b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80043e:	89 02                	mov    %eax,(%edx)
	return 0;
  800440:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800445:	5d                   	pop    %ebp
  800446:	c3                   	ret    
		return -E_INVAL;
  800447:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80044c:	eb f7                	jmp    800445 <fd_lookup+0x3d>
		return -E_INVAL;
  80044e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800453:	eb f0                	jmp    800445 <fd_lookup+0x3d>
  800455:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80045a:	eb e9                	jmp    800445 <fd_lookup+0x3d>

0080045c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80045c:	f3 0f 1e fb          	endbr32 
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800469:	ba b4 1f 80 00       	mov    $0x801fb4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80046e:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800473:	39 08                	cmp    %ecx,(%eax)
  800475:	74 33                	je     8004aa <dev_lookup+0x4e>
  800477:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80047a:	8b 02                	mov    (%edx),%eax
  80047c:	85 c0                	test   %eax,%eax
  80047e:	75 f3                	jne    800473 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800480:	a1 04 40 80 00       	mov    0x804004,%eax
  800485:	8b 40 48             	mov    0x48(%eax),%eax
  800488:	83 ec 04             	sub    $0x4,%esp
  80048b:	51                   	push   %ecx
  80048c:	50                   	push   %eax
  80048d:	68 38 1f 80 00       	push   $0x801f38
  800492:	e8 18 0d 00 00       	call   8011af <cprintf>
	*dev = 0;
  800497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004a0:	83 c4 10             	add    $0x10,%esp
  8004a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004a8:	c9                   	leave  
  8004a9:	c3                   	ret    
			*dev = devtab[i];
  8004aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ad:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004af:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b4:	eb f2                	jmp    8004a8 <dev_lookup+0x4c>

008004b6 <fd_close>:
{
  8004b6:	f3 0f 1e fb          	endbr32 
  8004ba:	55                   	push   %ebp
  8004bb:	89 e5                	mov    %esp,%ebp
  8004bd:	57                   	push   %edi
  8004be:	56                   	push   %esi
  8004bf:	53                   	push   %ebx
  8004c0:	83 ec 24             	sub    $0x24,%esp
  8004c3:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004c9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004cc:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004cd:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004d3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004d6:	50                   	push   %eax
  8004d7:	e8 2c ff ff ff       	call   800408 <fd_lookup>
  8004dc:	89 c3                	mov    %eax,%ebx
  8004de:	83 c4 10             	add    $0x10,%esp
  8004e1:	85 c0                	test   %eax,%eax
  8004e3:	78 05                	js     8004ea <fd_close+0x34>
	    || fd != fd2)
  8004e5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004e8:	74 16                	je     800500 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8004ea:	89 f8                	mov    %edi,%eax
  8004ec:	84 c0                	test   %al,%al
  8004ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f3:	0f 44 d8             	cmove  %eax,%ebx
}
  8004f6:	89 d8                	mov    %ebx,%eax
  8004f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004fb:	5b                   	pop    %ebx
  8004fc:	5e                   	pop    %esi
  8004fd:	5f                   	pop    %edi
  8004fe:	5d                   	pop    %ebp
  8004ff:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800506:	50                   	push   %eax
  800507:	ff 36                	pushl  (%esi)
  800509:	e8 4e ff ff ff       	call   80045c <dev_lookup>
  80050e:	89 c3                	mov    %eax,%ebx
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	85 c0                	test   %eax,%eax
  800515:	78 1a                	js     800531 <fd_close+0x7b>
		if (dev->dev_close)
  800517:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80051a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80051d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800522:	85 c0                	test   %eax,%eax
  800524:	74 0b                	je     800531 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800526:	83 ec 0c             	sub    $0xc,%esp
  800529:	56                   	push   %esi
  80052a:	ff d0                	call   *%eax
  80052c:	89 c3                	mov    %eax,%ebx
  80052e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800531:	83 ec 08             	sub    $0x8,%esp
  800534:	56                   	push   %esi
  800535:	6a 00                	push   $0x0
  800537:	e8 c3 fc ff ff       	call   8001ff <sys_page_unmap>
	return r;
  80053c:	83 c4 10             	add    $0x10,%esp
  80053f:	eb b5                	jmp    8004f6 <fd_close+0x40>

00800541 <close>:

int
close(int fdnum)
{
  800541:	f3 0f 1e fb          	endbr32 
  800545:	55                   	push   %ebp
  800546:	89 e5                	mov    %esp,%ebp
  800548:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80054b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80054e:	50                   	push   %eax
  80054f:	ff 75 08             	pushl  0x8(%ebp)
  800552:	e8 b1 fe ff ff       	call   800408 <fd_lookup>
  800557:	83 c4 10             	add    $0x10,%esp
  80055a:	85 c0                	test   %eax,%eax
  80055c:	79 02                	jns    800560 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80055e:	c9                   	leave  
  80055f:	c3                   	ret    
		return fd_close(fd, 1);
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	6a 01                	push   $0x1
  800565:	ff 75 f4             	pushl  -0xc(%ebp)
  800568:	e8 49 ff ff ff       	call   8004b6 <fd_close>
  80056d:	83 c4 10             	add    $0x10,%esp
  800570:	eb ec                	jmp    80055e <close+0x1d>

00800572 <close_all>:

void
close_all(void)
{
  800572:	f3 0f 1e fb          	endbr32 
  800576:	55                   	push   %ebp
  800577:	89 e5                	mov    %esp,%ebp
  800579:	53                   	push   %ebx
  80057a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80057d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800582:	83 ec 0c             	sub    $0xc,%esp
  800585:	53                   	push   %ebx
  800586:	e8 b6 ff ff ff       	call   800541 <close>
	for (i = 0; i < MAXFD; i++)
  80058b:	83 c3 01             	add    $0x1,%ebx
  80058e:	83 c4 10             	add    $0x10,%esp
  800591:	83 fb 20             	cmp    $0x20,%ebx
  800594:	75 ec                	jne    800582 <close_all+0x10>
}
  800596:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800599:	c9                   	leave  
  80059a:	c3                   	ret    

0080059b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80059b:	f3 0f 1e fb          	endbr32 
  80059f:	55                   	push   %ebp
  8005a0:	89 e5                	mov    %esp,%ebp
  8005a2:	57                   	push   %edi
  8005a3:	56                   	push   %esi
  8005a4:	53                   	push   %ebx
  8005a5:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005a8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005ab:	50                   	push   %eax
  8005ac:	ff 75 08             	pushl  0x8(%ebp)
  8005af:	e8 54 fe ff ff       	call   800408 <fd_lookup>
  8005b4:	89 c3                	mov    %eax,%ebx
  8005b6:	83 c4 10             	add    $0x10,%esp
  8005b9:	85 c0                	test   %eax,%eax
  8005bb:	0f 88 81 00 00 00    	js     800642 <dup+0xa7>
		return r;
	close(newfdnum);
  8005c1:	83 ec 0c             	sub    $0xc,%esp
  8005c4:	ff 75 0c             	pushl  0xc(%ebp)
  8005c7:	e8 75 ff ff ff       	call   800541 <close>

	newfd = INDEX2FD(newfdnum);
  8005cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005cf:	c1 e6 0c             	shl    $0xc,%esi
  8005d2:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005d8:	83 c4 04             	add    $0x4,%esp
  8005db:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005de:	e8 b4 fd ff ff       	call   800397 <fd2data>
  8005e3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005e5:	89 34 24             	mov    %esi,(%esp)
  8005e8:	e8 aa fd ff ff       	call   800397 <fd2data>
  8005ed:	83 c4 10             	add    $0x10,%esp
  8005f0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005f2:	89 d8                	mov    %ebx,%eax
  8005f4:	c1 e8 16             	shr    $0x16,%eax
  8005f7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005fe:	a8 01                	test   $0x1,%al
  800600:	74 11                	je     800613 <dup+0x78>
  800602:	89 d8                	mov    %ebx,%eax
  800604:	c1 e8 0c             	shr    $0xc,%eax
  800607:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80060e:	f6 c2 01             	test   $0x1,%dl
  800611:	75 39                	jne    80064c <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800613:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800616:	89 d0                	mov    %edx,%eax
  800618:	c1 e8 0c             	shr    $0xc,%eax
  80061b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800622:	83 ec 0c             	sub    $0xc,%esp
  800625:	25 07 0e 00 00       	and    $0xe07,%eax
  80062a:	50                   	push   %eax
  80062b:	56                   	push   %esi
  80062c:	6a 00                	push   $0x0
  80062e:	52                   	push   %edx
  80062f:	6a 00                	push   $0x0
  800631:	e8 83 fb ff ff       	call   8001b9 <sys_page_map>
  800636:	89 c3                	mov    %eax,%ebx
  800638:	83 c4 20             	add    $0x20,%esp
  80063b:	85 c0                	test   %eax,%eax
  80063d:	78 31                	js     800670 <dup+0xd5>
		goto err;

	return newfdnum;
  80063f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800642:	89 d8                	mov    %ebx,%eax
  800644:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800647:	5b                   	pop    %ebx
  800648:	5e                   	pop    %esi
  800649:	5f                   	pop    %edi
  80064a:	5d                   	pop    %ebp
  80064b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80064c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800653:	83 ec 0c             	sub    $0xc,%esp
  800656:	25 07 0e 00 00       	and    $0xe07,%eax
  80065b:	50                   	push   %eax
  80065c:	57                   	push   %edi
  80065d:	6a 00                	push   $0x0
  80065f:	53                   	push   %ebx
  800660:	6a 00                	push   $0x0
  800662:	e8 52 fb ff ff       	call   8001b9 <sys_page_map>
  800667:	89 c3                	mov    %eax,%ebx
  800669:	83 c4 20             	add    $0x20,%esp
  80066c:	85 c0                	test   %eax,%eax
  80066e:	79 a3                	jns    800613 <dup+0x78>
	sys_page_unmap(0, newfd);
  800670:	83 ec 08             	sub    $0x8,%esp
  800673:	56                   	push   %esi
  800674:	6a 00                	push   $0x0
  800676:	e8 84 fb ff ff       	call   8001ff <sys_page_unmap>
	sys_page_unmap(0, nva);
  80067b:	83 c4 08             	add    $0x8,%esp
  80067e:	57                   	push   %edi
  80067f:	6a 00                	push   $0x0
  800681:	e8 79 fb ff ff       	call   8001ff <sys_page_unmap>
	return r;
  800686:	83 c4 10             	add    $0x10,%esp
  800689:	eb b7                	jmp    800642 <dup+0xa7>

0080068b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80068b:	f3 0f 1e fb          	endbr32 
  80068f:	55                   	push   %ebp
  800690:	89 e5                	mov    %esp,%ebp
  800692:	53                   	push   %ebx
  800693:	83 ec 1c             	sub    $0x1c,%esp
  800696:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800699:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80069c:	50                   	push   %eax
  80069d:	53                   	push   %ebx
  80069e:	e8 65 fd ff ff       	call   800408 <fd_lookup>
  8006a3:	83 c4 10             	add    $0x10,%esp
  8006a6:	85 c0                	test   %eax,%eax
  8006a8:	78 3f                	js     8006e9 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006b0:	50                   	push   %eax
  8006b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b4:	ff 30                	pushl  (%eax)
  8006b6:	e8 a1 fd ff ff       	call   80045c <dev_lookup>
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	85 c0                	test   %eax,%eax
  8006c0:	78 27                	js     8006e9 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8006c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006c5:	8b 42 08             	mov    0x8(%edx),%eax
  8006c8:	83 e0 03             	and    $0x3,%eax
  8006cb:	83 f8 01             	cmp    $0x1,%eax
  8006ce:	74 1e                	je     8006ee <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006d3:	8b 40 08             	mov    0x8(%eax),%eax
  8006d6:	85 c0                	test   %eax,%eax
  8006d8:	74 35                	je     80070f <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006da:	83 ec 04             	sub    $0x4,%esp
  8006dd:	ff 75 10             	pushl  0x10(%ebp)
  8006e0:	ff 75 0c             	pushl  0xc(%ebp)
  8006e3:	52                   	push   %edx
  8006e4:	ff d0                	call   *%eax
  8006e6:	83 c4 10             	add    $0x10,%esp
}
  8006e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ec:	c9                   	leave  
  8006ed:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006ee:	a1 04 40 80 00       	mov    0x804004,%eax
  8006f3:	8b 40 48             	mov    0x48(%eax),%eax
  8006f6:	83 ec 04             	sub    $0x4,%esp
  8006f9:	53                   	push   %ebx
  8006fa:	50                   	push   %eax
  8006fb:	68 79 1f 80 00       	push   $0x801f79
  800700:	e8 aa 0a 00 00       	call   8011af <cprintf>
		return -E_INVAL;
  800705:	83 c4 10             	add    $0x10,%esp
  800708:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80070d:	eb da                	jmp    8006e9 <read+0x5e>
		return -E_NOT_SUPP;
  80070f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800714:	eb d3                	jmp    8006e9 <read+0x5e>

00800716 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800716:	f3 0f 1e fb          	endbr32 
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	57                   	push   %edi
  80071e:	56                   	push   %esi
  80071f:	53                   	push   %ebx
  800720:	83 ec 0c             	sub    $0xc,%esp
  800723:	8b 7d 08             	mov    0x8(%ebp),%edi
  800726:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800729:	bb 00 00 00 00       	mov    $0x0,%ebx
  80072e:	eb 02                	jmp    800732 <readn+0x1c>
  800730:	01 c3                	add    %eax,%ebx
  800732:	39 f3                	cmp    %esi,%ebx
  800734:	73 21                	jae    800757 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800736:	83 ec 04             	sub    $0x4,%esp
  800739:	89 f0                	mov    %esi,%eax
  80073b:	29 d8                	sub    %ebx,%eax
  80073d:	50                   	push   %eax
  80073e:	89 d8                	mov    %ebx,%eax
  800740:	03 45 0c             	add    0xc(%ebp),%eax
  800743:	50                   	push   %eax
  800744:	57                   	push   %edi
  800745:	e8 41 ff ff ff       	call   80068b <read>
		if (m < 0)
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	85 c0                	test   %eax,%eax
  80074f:	78 04                	js     800755 <readn+0x3f>
			return m;
		if (m == 0)
  800751:	75 dd                	jne    800730 <readn+0x1a>
  800753:	eb 02                	jmp    800757 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800755:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800757:	89 d8                	mov    %ebx,%eax
  800759:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80075c:	5b                   	pop    %ebx
  80075d:	5e                   	pop    %esi
  80075e:	5f                   	pop    %edi
  80075f:	5d                   	pop    %ebp
  800760:	c3                   	ret    

00800761 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800761:	f3 0f 1e fb          	endbr32 
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	53                   	push   %ebx
  800769:	83 ec 1c             	sub    $0x1c,%esp
  80076c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80076f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800772:	50                   	push   %eax
  800773:	53                   	push   %ebx
  800774:	e8 8f fc ff ff       	call   800408 <fd_lookup>
  800779:	83 c4 10             	add    $0x10,%esp
  80077c:	85 c0                	test   %eax,%eax
  80077e:	78 3a                	js     8007ba <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800780:	83 ec 08             	sub    $0x8,%esp
  800783:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800786:	50                   	push   %eax
  800787:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078a:	ff 30                	pushl  (%eax)
  80078c:	e8 cb fc ff ff       	call   80045c <dev_lookup>
  800791:	83 c4 10             	add    $0x10,%esp
  800794:	85 c0                	test   %eax,%eax
  800796:	78 22                	js     8007ba <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80079b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80079f:	74 1e                	je     8007bf <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a4:	8b 52 0c             	mov    0xc(%edx),%edx
  8007a7:	85 d2                	test   %edx,%edx
  8007a9:	74 35                	je     8007e0 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007ab:	83 ec 04             	sub    $0x4,%esp
  8007ae:	ff 75 10             	pushl  0x10(%ebp)
  8007b1:	ff 75 0c             	pushl  0xc(%ebp)
  8007b4:	50                   	push   %eax
  8007b5:	ff d2                	call   *%edx
  8007b7:	83 c4 10             	add    $0x10,%esp
}
  8007ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007bd:	c9                   	leave  
  8007be:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007bf:	a1 04 40 80 00       	mov    0x804004,%eax
  8007c4:	8b 40 48             	mov    0x48(%eax),%eax
  8007c7:	83 ec 04             	sub    $0x4,%esp
  8007ca:	53                   	push   %ebx
  8007cb:	50                   	push   %eax
  8007cc:	68 95 1f 80 00       	push   $0x801f95
  8007d1:	e8 d9 09 00 00       	call   8011af <cprintf>
		return -E_INVAL;
  8007d6:	83 c4 10             	add    $0x10,%esp
  8007d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007de:	eb da                	jmp    8007ba <write+0x59>
		return -E_NOT_SUPP;
  8007e0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007e5:	eb d3                	jmp    8007ba <write+0x59>

008007e7 <seek>:

int
seek(int fdnum, off_t offset)
{
  8007e7:	f3 0f 1e fb          	endbr32 
  8007eb:	55                   	push   %ebp
  8007ec:	89 e5                	mov    %esp,%ebp
  8007ee:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007f4:	50                   	push   %eax
  8007f5:	ff 75 08             	pushl  0x8(%ebp)
  8007f8:	e8 0b fc ff ff       	call   800408 <fd_lookup>
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	85 c0                	test   %eax,%eax
  800802:	78 0e                	js     800812 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  800804:	8b 55 0c             	mov    0xc(%ebp),%edx
  800807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80080a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80080d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800812:	c9                   	leave  
  800813:	c3                   	ret    

00800814 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
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
  800827:	e8 dc fb ff ff       	call   800408 <fd_lookup>
  80082c:	83 c4 10             	add    $0x10,%esp
  80082f:	85 c0                	test   %eax,%eax
  800831:	78 37                	js     80086a <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800833:	83 ec 08             	sub    $0x8,%esp
  800836:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800839:	50                   	push   %eax
  80083a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80083d:	ff 30                	pushl  (%eax)
  80083f:	e8 18 fc ff ff       	call   80045c <dev_lookup>
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	85 c0                	test   %eax,%eax
  800849:	78 1f                	js     80086a <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80084b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800852:	74 1b                	je     80086f <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800854:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800857:	8b 52 18             	mov    0x18(%edx),%edx
  80085a:	85 d2                	test   %edx,%edx
  80085c:	74 32                	je     800890 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	50                   	push   %eax
  800865:	ff d2                	call   *%edx
  800867:	83 c4 10             	add    $0x10,%esp
}
  80086a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80086d:	c9                   	leave  
  80086e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80086f:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800874:	8b 40 48             	mov    0x48(%eax),%eax
  800877:	83 ec 04             	sub    $0x4,%esp
  80087a:	53                   	push   %ebx
  80087b:	50                   	push   %eax
  80087c:	68 58 1f 80 00       	push   $0x801f58
  800881:	e8 29 09 00 00       	call   8011af <cprintf>
		return -E_INVAL;
  800886:	83 c4 10             	add    $0x10,%esp
  800889:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80088e:	eb da                	jmp    80086a <ftruncate+0x56>
		return -E_NOT_SUPP;
  800890:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800895:	eb d3                	jmp    80086a <ftruncate+0x56>

00800897 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800897:	f3 0f 1e fb          	endbr32 
  80089b:	55                   	push   %ebp
  80089c:	89 e5                	mov    %esp,%ebp
  80089e:	53                   	push   %ebx
  80089f:	83 ec 1c             	sub    $0x1c,%esp
  8008a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008a5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008a8:	50                   	push   %eax
  8008a9:	ff 75 08             	pushl  0x8(%ebp)
  8008ac:	e8 57 fb ff ff       	call   800408 <fd_lookup>
  8008b1:	83 c4 10             	add    $0x10,%esp
  8008b4:	85 c0                	test   %eax,%eax
  8008b6:	78 4b                	js     800903 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008b8:	83 ec 08             	sub    $0x8,%esp
  8008bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008be:	50                   	push   %eax
  8008bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c2:	ff 30                	pushl  (%eax)
  8008c4:	e8 93 fb ff ff       	call   80045c <dev_lookup>
  8008c9:	83 c4 10             	add    $0x10,%esp
  8008cc:	85 c0                	test   %eax,%eax
  8008ce:	78 33                	js     800903 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8008d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8008d7:	74 2f                	je     800908 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8008d9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8008dc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8008e3:	00 00 00 
	stat->st_isdir = 0;
  8008e6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008ed:	00 00 00 
	stat->st_dev = dev;
  8008f0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008f6:	83 ec 08             	sub    $0x8,%esp
  8008f9:	53                   	push   %ebx
  8008fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8008fd:	ff 50 14             	call   *0x14(%eax)
  800900:	83 c4 10             	add    $0x10,%esp
}
  800903:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800906:	c9                   	leave  
  800907:	c3                   	ret    
		return -E_NOT_SUPP;
  800908:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80090d:	eb f4                	jmp    800903 <fstat+0x6c>

0080090f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80090f:	f3 0f 1e fb          	endbr32 
  800913:	55                   	push   %ebp
  800914:	89 e5                	mov    %esp,%ebp
  800916:	56                   	push   %esi
  800917:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800918:	83 ec 08             	sub    $0x8,%esp
  80091b:	6a 00                	push   $0x0
  80091d:	ff 75 08             	pushl  0x8(%ebp)
  800920:	e8 fb 01 00 00       	call   800b20 <open>
  800925:	89 c3                	mov    %eax,%ebx
  800927:	83 c4 10             	add    $0x10,%esp
  80092a:	85 c0                	test   %eax,%eax
  80092c:	78 1b                	js     800949 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80092e:	83 ec 08             	sub    $0x8,%esp
  800931:	ff 75 0c             	pushl  0xc(%ebp)
  800934:	50                   	push   %eax
  800935:	e8 5d ff ff ff       	call   800897 <fstat>
  80093a:	89 c6                	mov    %eax,%esi
	close(fd);
  80093c:	89 1c 24             	mov    %ebx,(%esp)
  80093f:	e8 fd fb ff ff       	call   800541 <close>
	return r;
  800944:	83 c4 10             	add    $0x10,%esp
  800947:	89 f3                	mov    %esi,%ebx
}
  800949:	89 d8                	mov    %ebx,%eax
  80094b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80094e:	5b                   	pop    %ebx
  80094f:	5e                   	pop    %esi
  800950:	5d                   	pop    %ebp
  800951:	c3                   	ret    

00800952 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	56                   	push   %esi
  800956:	53                   	push   %ebx
  800957:	89 c6                	mov    %eax,%esi
  800959:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80095b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800962:	74 27                	je     80098b <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800964:	6a 07                	push   $0x7
  800966:	68 00 50 80 00       	push   $0x805000
  80096b:	56                   	push   %esi
  80096c:	ff 35 00 40 80 00    	pushl  0x804000
  800972:	e8 39 12 00 00       	call   801bb0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800977:	83 c4 0c             	add    $0xc,%esp
  80097a:	6a 00                	push   $0x0
  80097c:	53                   	push   %ebx
  80097d:	6a 00                	push   $0x0
  80097f:	e8 a7 11 00 00       	call   801b2b <ipc_recv>
}
  800984:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800987:	5b                   	pop    %ebx
  800988:	5e                   	pop    %esi
  800989:	5d                   	pop    %ebp
  80098a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80098b:	83 ec 0c             	sub    $0xc,%esp
  80098e:	6a 01                	push   $0x1
  800990:	e8 73 12 00 00       	call   801c08 <ipc_find_env>
  800995:	a3 00 40 80 00       	mov    %eax,0x804000
  80099a:	83 c4 10             	add    $0x10,%esp
  80099d:	eb c5                	jmp    800964 <fsipc+0x12>

0080099f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80099f:	f3 0f 1e fb          	endbr32 
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8009af:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b7:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c1:	b8 02 00 00 00       	mov    $0x2,%eax
  8009c6:	e8 87 ff ff ff       	call   800952 <fsipc>
}
  8009cb:	c9                   	leave  
  8009cc:	c3                   	ret    

008009cd <devfile_flush>:
{
  8009cd:	f3 0f 1e fb          	endbr32 
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	8b 40 0c             	mov    0xc(%eax),%eax
  8009dd:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8009e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e7:	b8 06 00 00 00       	mov    $0x6,%eax
  8009ec:	e8 61 ff ff ff       	call   800952 <fsipc>
}
  8009f1:	c9                   	leave  
  8009f2:	c3                   	ret    

008009f3 <devfile_stat>:
{
  8009f3:	f3 0f 1e fb          	endbr32 
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	53                   	push   %ebx
  8009fb:	83 ec 04             	sub    $0x4,%esp
  8009fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	8b 40 0c             	mov    0xc(%eax),%eax
  800a07:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a0c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a11:	b8 05 00 00 00       	mov    $0x5,%eax
  800a16:	e8 37 ff ff ff       	call   800952 <fsipc>
  800a1b:	85 c0                	test   %eax,%eax
  800a1d:	78 2c                	js     800a4b <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	68 00 50 80 00       	push   $0x805000
  800a27:	53                   	push   %ebx
  800a28:	e8 8c 0d 00 00       	call   8017b9 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a2d:	a1 80 50 80 00       	mov    0x805080,%eax
  800a32:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800a38:	a1 84 50 80 00       	mov    0x805084,%eax
  800a3d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a43:	83 c4 10             	add    $0x10,%esp
  800a46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a4e:	c9                   	leave  
  800a4f:	c3                   	ret    

00800a50 <devfile_write>:
{
  800a50:	f3 0f 1e fb          	endbr32 
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	83 ec 0c             	sub    $0xc,%esp
  800a5a:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800a60:	8b 52 0c             	mov    0xc(%edx),%edx
  800a63:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  800a69:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800a6e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800a73:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  800a76:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a7b:	50                   	push   %eax
  800a7c:	ff 75 0c             	pushl  0xc(%ebp)
  800a7f:	68 08 50 80 00       	push   $0x805008
  800a84:	e8 e6 0e 00 00       	call   80196f <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800a89:	ba 00 00 00 00       	mov    $0x0,%edx
  800a8e:	b8 04 00 00 00       	mov    $0x4,%eax
  800a93:	e8 ba fe ff ff       	call   800952 <fsipc>
}
  800a98:	c9                   	leave  
  800a99:	c3                   	ret    

00800a9a <devfile_read>:
{
  800a9a:	f3 0f 1e fb          	endbr32 
  800a9e:	55                   	push   %ebp
  800a9f:	89 e5                	mov    %esp,%ebp
  800aa1:	56                   	push   %esi
  800aa2:	53                   	push   %ebx
  800aa3:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8b 40 0c             	mov    0xc(%eax),%eax
  800aac:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800ab1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800ab7:	ba 00 00 00 00       	mov    $0x0,%edx
  800abc:	b8 03 00 00 00       	mov    $0x3,%eax
  800ac1:	e8 8c fe ff ff       	call   800952 <fsipc>
  800ac6:	89 c3                	mov    %eax,%ebx
  800ac8:	85 c0                	test   %eax,%eax
  800aca:	78 1f                	js     800aeb <devfile_read+0x51>
	assert(r <= n);
  800acc:	39 f0                	cmp    %esi,%eax
  800ace:	77 24                	ja     800af4 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800ad0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ad5:	7f 33                	jg     800b0a <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800ad7:	83 ec 04             	sub    $0x4,%esp
  800ada:	50                   	push   %eax
  800adb:	68 00 50 80 00       	push   $0x805000
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	e8 87 0e 00 00       	call   80196f <memmove>
	return r;
  800ae8:	83 c4 10             	add    $0x10,%esp
}
  800aeb:	89 d8                	mov    %ebx,%eax
  800aed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800af0:	5b                   	pop    %ebx
  800af1:	5e                   	pop    %esi
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    
	assert(r <= n);
  800af4:	68 c4 1f 80 00       	push   $0x801fc4
  800af9:	68 cb 1f 80 00       	push   $0x801fcb
  800afe:	6a 7c                	push   $0x7c
  800b00:	68 e0 1f 80 00       	push   $0x801fe0
  800b05:	e8 be 05 00 00       	call   8010c8 <_panic>
	assert(r <= PGSIZE);
  800b0a:	68 eb 1f 80 00       	push   $0x801feb
  800b0f:	68 cb 1f 80 00       	push   $0x801fcb
  800b14:	6a 7d                	push   $0x7d
  800b16:	68 e0 1f 80 00       	push   $0x801fe0
  800b1b:	e8 a8 05 00 00       	call   8010c8 <_panic>

00800b20 <open>:
{
  800b20:	f3 0f 1e fb          	endbr32 
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	56                   	push   %esi
  800b28:	53                   	push   %ebx
  800b29:	83 ec 1c             	sub    $0x1c,%esp
  800b2c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b2f:	56                   	push   %esi
  800b30:	e8 41 0c 00 00       	call   801776 <strlen>
  800b35:	83 c4 10             	add    $0x10,%esp
  800b38:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b3d:	7f 6c                	jg     800bab <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b3f:	83 ec 0c             	sub    $0xc,%esp
  800b42:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b45:	50                   	push   %eax
  800b46:	e8 67 f8 ff ff       	call   8003b2 <fd_alloc>
  800b4b:	89 c3                	mov    %eax,%ebx
  800b4d:	83 c4 10             	add    $0x10,%esp
  800b50:	85 c0                	test   %eax,%eax
  800b52:	78 3c                	js     800b90 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b54:	83 ec 08             	sub    $0x8,%esp
  800b57:	56                   	push   %esi
  800b58:	68 00 50 80 00       	push   $0x805000
  800b5d:	e8 57 0c 00 00       	call   8017b9 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b65:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b6d:	b8 01 00 00 00       	mov    $0x1,%eax
  800b72:	e8 db fd ff ff       	call   800952 <fsipc>
  800b77:	89 c3                	mov    %eax,%ebx
  800b79:	83 c4 10             	add    $0x10,%esp
  800b7c:	85 c0                	test   %eax,%eax
  800b7e:	78 19                	js     800b99 <open+0x79>
	return fd2num(fd);
  800b80:	83 ec 0c             	sub    $0xc,%esp
  800b83:	ff 75 f4             	pushl  -0xc(%ebp)
  800b86:	e8 f8 f7 ff ff       	call   800383 <fd2num>
  800b8b:	89 c3                	mov    %eax,%ebx
  800b8d:	83 c4 10             	add    $0x10,%esp
}
  800b90:	89 d8                	mov    %ebx,%eax
  800b92:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b95:	5b                   	pop    %ebx
  800b96:	5e                   	pop    %esi
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    
		fd_close(fd, 0);
  800b99:	83 ec 08             	sub    $0x8,%esp
  800b9c:	6a 00                	push   $0x0
  800b9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba1:	e8 10 f9 ff ff       	call   8004b6 <fd_close>
		return r;
  800ba6:	83 c4 10             	add    $0x10,%esp
  800ba9:	eb e5                	jmp    800b90 <open+0x70>
		return -E_BAD_PATH;
  800bab:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800bb0:	eb de                	jmp    800b90 <open+0x70>

00800bb2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800bb2:	f3 0f 1e fb          	endbr32 
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800bbc:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc1:	b8 08 00 00 00       	mov    $0x8,%eax
  800bc6:	e8 87 fd ff ff       	call   800952 <fsipc>
}
  800bcb:	c9                   	leave  
  800bcc:	c3                   	ret    

00800bcd <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800bcd:	f3 0f 1e fb          	endbr32 
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	56                   	push   %esi
  800bd5:	53                   	push   %ebx
  800bd6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800bd9:	83 ec 0c             	sub    $0xc,%esp
  800bdc:	ff 75 08             	pushl  0x8(%ebp)
  800bdf:	e8 b3 f7 ff ff       	call   800397 <fd2data>
  800be4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800be6:	83 c4 08             	add    $0x8,%esp
  800be9:	68 f7 1f 80 00       	push   $0x801ff7
  800bee:	53                   	push   %ebx
  800bef:	e8 c5 0b 00 00       	call   8017b9 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bf4:	8b 46 04             	mov    0x4(%esi),%eax
  800bf7:	2b 06                	sub    (%esi),%eax
  800bf9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bff:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800c06:	00 00 00 
	stat->st_dev = &devpipe;
  800c09:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c10:	30 80 00 
	return 0;
}
  800c13:	b8 00 00 00 00       	mov    $0x0,%eax
  800c18:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c1b:	5b                   	pop    %ebx
  800c1c:	5e                   	pop    %esi
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    

00800c1f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c1f:	f3 0f 1e fb          	endbr32 
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	53                   	push   %ebx
  800c27:	83 ec 0c             	sub    $0xc,%esp
  800c2a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c2d:	53                   	push   %ebx
  800c2e:	6a 00                	push   $0x0
  800c30:	e8 ca f5 ff ff       	call   8001ff <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c35:	89 1c 24             	mov    %ebx,(%esp)
  800c38:	e8 5a f7 ff ff       	call   800397 <fd2data>
  800c3d:	83 c4 08             	add    $0x8,%esp
  800c40:	50                   	push   %eax
  800c41:	6a 00                	push   $0x0
  800c43:	e8 b7 f5 ff ff       	call   8001ff <sys_page_unmap>
}
  800c48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    

00800c4d <_pipeisclosed>:
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	57                   	push   %edi
  800c51:	56                   	push   %esi
  800c52:	53                   	push   %ebx
  800c53:	83 ec 1c             	sub    $0x1c,%esp
  800c56:	89 c7                	mov    %eax,%edi
  800c58:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c5a:	a1 04 40 80 00       	mov    0x804004,%eax
  800c5f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c62:	83 ec 0c             	sub    $0xc,%esp
  800c65:	57                   	push   %edi
  800c66:	e8 da 0f 00 00       	call   801c45 <pageref>
  800c6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c6e:	89 34 24             	mov    %esi,(%esp)
  800c71:	e8 cf 0f 00 00       	call   801c45 <pageref>
		nn = thisenv->env_runs;
  800c76:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800c7c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c7f:	83 c4 10             	add    $0x10,%esp
  800c82:	39 cb                	cmp    %ecx,%ebx
  800c84:	74 1b                	je     800ca1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c86:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c89:	75 cf                	jne    800c5a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c8b:	8b 42 58             	mov    0x58(%edx),%eax
  800c8e:	6a 01                	push   $0x1
  800c90:	50                   	push   %eax
  800c91:	53                   	push   %ebx
  800c92:	68 fe 1f 80 00       	push   $0x801ffe
  800c97:	e8 13 05 00 00       	call   8011af <cprintf>
  800c9c:	83 c4 10             	add    $0x10,%esp
  800c9f:	eb b9                	jmp    800c5a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800ca1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800ca4:	0f 94 c0             	sete   %al
  800ca7:	0f b6 c0             	movzbl %al,%eax
}
  800caa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cad:	5b                   	pop    %ebx
  800cae:	5e                   	pop    %esi
  800caf:	5f                   	pop    %edi
  800cb0:	5d                   	pop    %ebp
  800cb1:	c3                   	ret    

00800cb2 <devpipe_write>:
{
  800cb2:	f3 0f 1e fb          	endbr32 
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	57                   	push   %edi
  800cba:	56                   	push   %esi
  800cbb:	53                   	push   %ebx
  800cbc:	83 ec 28             	sub    $0x28,%esp
  800cbf:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800cc2:	56                   	push   %esi
  800cc3:	e8 cf f6 ff ff       	call   800397 <fd2data>
  800cc8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800cca:	83 c4 10             	add    $0x10,%esp
  800ccd:	bf 00 00 00 00       	mov    $0x0,%edi
  800cd2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800cd5:	74 4f                	je     800d26 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800cd7:	8b 43 04             	mov    0x4(%ebx),%eax
  800cda:	8b 0b                	mov    (%ebx),%ecx
  800cdc:	8d 51 20             	lea    0x20(%ecx),%edx
  800cdf:	39 d0                	cmp    %edx,%eax
  800ce1:	72 14                	jb     800cf7 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  800ce3:	89 da                	mov    %ebx,%edx
  800ce5:	89 f0                	mov    %esi,%eax
  800ce7:	e8 61 ff ff ff       	call   800c4d <_pipeisclosed>
  800cec:	85 c0                	test   %eax,%eax
  800cee:	75 3b                	jne    800d2b <devpipe_write+0x79>
			sys_yield();
  800cf0:	e8 5a f4 ff ff       	call   80014f <sys_yield>
  800cf5:	eb e0                	jmp    800cd7 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cf7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cfe:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800d01:	89 c2                	mov    %eax,%edx
  800d03:	c1 fa 1f             	sar    $0x1f,%edx
  800d06:	89 d1                	mov    %edx,%ecx
  800d08:	c1 e9 1b             	shr    $0x1b,%ecx
  800d0b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800d0e:	83 e2 1f             	and    $0x1f,%edx
  800d11:	29 ca                	sub    %ecx,%edx
  800d13:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800d17:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800d1b:	83 c0 01             	add    $0x1,%eax
  800d1e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d21:	83 c7 01             	add    $0x1,%edi
  800d24:	eb ac                	jmp    800cd2 <devpipe_write+0x20>
	return i;
  800d26:	8b 45 10             	mov    0x10(%ebp),%eax
  800d29:	eb 05                	jmp    800d30 <devpipe_write+0x7e>
				return 0;
  800d2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d33:	5b                   	pop    %ebx
  800d34:	5e                   	pop    %esi
  800d35:	5f                   	pop    %edi
  800d36:	5d                   	pop    %ebp
  800d37:	c3                   	ret    

00800d38 <devpipe_read>:
{
  800d38:	f3 0f 1e fb          	endbr32 
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	57                   	push   %edi
  800d40:	56                   	push   %esi
  800d41:	53                   	push   %ebx
  800d42:	83 ec 18             	sub    $0x18,%esp
  800d45:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d48:	57                   	push   %edi
  800d49:	e8 49 f6 ff ff       	call   800397 <fd2data>
  800d4e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d50:	83 c4 10             	add    $0x10,%esp
  800d53:	be 00 00 00 00       	mov    $0x0,%esi
  800d58:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d5b:	75 14                	jne    800d71 <devpipe_read+0x39>
	return i;
  800d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d60:	eb 02                	jmp    800d64 <devpipe_read+0x2c>
				return i;
  800d62:	89 f0                	mov    %esi,%eax
}
  800d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d67:	5b                   	pop    %ebx
  800d68:	5e                   	pop    %esi
  800d69:	5f                   	pop    %edi
  800d6a:	5d                   	pop    %ebp
  800d6b:	c3                   	ret    
			sys_yield();
  800d6c:	e8 de f3 ff ff       	call   80014f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d71:	8b 03                	mov    (%ebx),%eax
  800d73:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d76:	75 18                	jne    800d90 <devpipe_read+0x58>
			if (i > 0)
  800d78:	85 f6                	test   %esi,%esi
  800d7a:	75 e6                	jne    800d62 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  800d7c:	89 da                	mov    %ebx,%edx
  800d7e:	89 f8                	mov    %edi,%eax
  800d80:	e8 c8 fe ff ff       	call   800c4d <_pipeisclosed>
  800d85:	85 c0                	test   %eax,%eax
  800d87:	74 e3                	je     800d6c <devpipe_read+0x34>
				return 0;
  800d89:	b8 00 00 00 00       	mov    $0x0,%eax
  800d8e:	eb d4                	jmp    800d64 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d90:	99                   	cltd   
  800d91:	c1 ea 1b             	shr    $0x1b,%edx
  800d94:	01 d0                	add    %edx,%eax
  800d96:	83 e0 1f             	and    $0x1f,%eax
  800d99:	29 d0                	sub    %edx,%eax
  800d9b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800da0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800da6:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800da9:	83 c6 01             	add    $0x1,%esi
  800dac:	eb aa                	jmp    800d58 <devpipe_read+0x20>

00800dae <pipe>:
{
  800dae:	f3 0f 1e fb          	endbr32 
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	56                   	push   %esi
  800db6:	53                   	push   %ebx
  800db7:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800dba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dbd:	50                   	push   %eax
  800dbe:	e8 ef f5 ff ff       	call   8003b2 <fd_alloc>
  800dc3:	89 c3                	mov    %eax,%ebx
  800dc5:	83 c4 10             	add    $0x10,%esp
  800dc8:	85 c0                	test   %eax,%eax
  800dca:	0f 88 23 01 00 00    	js     800ef3 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dd0:	83 ec 04             	sub    $0x4,%esp
  800dd3:	68 07 04 00 00       	push   $0x407
  800dd8:	ff 75 f4             	pushl  -0xc(%ebp)
  800ddb:	6a 00                	push   $0x0
  800ddd:	e8 90 f3 ff ff       	call   800172 <sys_page_alloc>
  800de2:	89 c3                	mov    %eax,%ebx
  800de4:	83 c4 10             	add    $0x10,%esp
  800de7:	85 c0                	test   %eax,%eax
  800de9:	0f 88 04 01 00 00    	js     800ef3 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  800def:	83 ec 0c             	sub    $0xc,%esp
  800df2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800df5:	50                   	push   %eax
  800df6:	e8 b7 f5 ff ff       	call   8003b2 <fd_alloc>
  800dfb:	89 c3                	mov    %eax,%ebx
  800dfd:	83 c4 10             	add    $0x10,%esp
  800e00:	85 c0                	test   %eax,%eax
  800e02:	0f 88 db 00 00 00    	js     800ee3 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e08:	83 ec 04             	sub    $0x4,%esp
  800e0b:	68 07 04 00 00       	push   $0x407
  800e10:	ff 75 f0             	pushl  -0x10(%ebp)
  800e13:	6a 00                	push   $0x0
  800e15:	e8 58 f3 ff ff       	call   800172 <sys_page_alloc>
  800e1a:	89 c3                	mov    %eax,%ebx
  800e1c:	83 c4 10             	add    $0x10,%esp
  800e1f:	85 c0                	test   %eax,%eax
  800e21:	0f 88 bc 00 00 00    	js     800ee3 <pipe+0x135>
	va = fd2data(fd0);
  800e27:	83 ec 0c             	sub    $0xc,%esp
  800e2a:	ff 75 f4             	pushl  -0xc(%ebp)
  800e2d:	e8 65 f5 ff ff       	call   800397 <fd2data>
  800e32:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e34:	83 c4 0c             	add    $0xc,%esp
  800e37:	68 07 04 00 00       	push   $0x407
  800e3c:	50                   	push   %eax
  800e3d:	6a 00                	push   $0x0
  800e3f:	e8 2e f3 ff ff       	call   800172 <sys_page_alloc>
  800e44:	89 c3                	mov    %eax,%ebx
  800e46:	83 c4 10             	add    $0x10,%esp
  800e49:	85 c0                	test   %eax,%eax
  800e4b:	0f 88 82 00 00 00    	js     800ed3 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e51:	83 ec 0c             	sub    $0xc,%esp
  800e54:	ff 75 f0             	pushl  -0x10(%ebp)
  800e57:	e8 3b f5 ff ff       	call   800397 <fd2data>
  800e5c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e63:	50                   	push   %eax
  800e64:	6a 00                	push   $0x0
  800e66:	56                   	push   %esi
  800e67:	6a 00                	push   $0x0
  800e69:	e8 4b f3 ff ff       	call   8001b9 <sys_page_map>
  800e6e:	89 c3                	mov    %eax,%ebx
  800e70:	83 c4 20             	add    $0x20,%esp
  800e73:	85 c0                	test   %eax,%eax
  800e75:	78 4e                	js     800ec5 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  800e77:	a1 20 30 80 00       	mov    0x803020,%eax
  800e7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e7f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e84:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e8b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e8e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e93:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e9a:	83 ec 0c             	sub    $0xc,%esp
  800e9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea0:	e8 de f4 ff ff       	call   800383 <fd2num>
  800ea5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ea8:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800eaa:	83 c4 04             	add    $0x4,%esp
  800ead:	ff 75 f0             	pushl  -0x10(%ebp)
  800eb0:	e8 ce f4 ff ff       	call   800383 <fd2num>
  800eb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eb8:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800ebb:	83 c4 10             	add    $0x10,%esp
  800ebe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec3:	eb 2e                	jmp    800ef3 <pipe+0x145>
	sys_page_unmap(0, va);
  800ec5:	83 ec 08             	sub    $0x8,%esp
  800ec8:	56                   	push   %esi
  800ec9:	6a 00                	push   $0x0
  800ecb:	e8 2f f3 ff ff       	call   8001ff <sys_page_unmap>
  800ed0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800ed3:	83 ec 08             	sub    $0x8,%esp
  800ed6:	ff 75 f0             	pushl  -0x10(%ebp)
  800ed9:	6a 00                	push   $0x0
  800edb:	e8 1f f3 ff ff       	call   8001ff <sys_page_unmap>
  800ee0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800ee3:	83 ec 08             	sub    $0x8,%esp
  800ee6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee9:	6a 00                	push   $0x0
  800eeb:	e8 0f f3 ff ff       	call   8001ff <sys_page_unmap>
  800ef0:	83 c4 10             	add    $0x10,%esp
}
  800ef3:	89 d8                	mov    %ebx,%eax
  800ef5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ef8:	5b                   	pop    %ebx
  800ef9:	5e                   	pop    %esi
  800efa:	5d                   	pop    %ebp
  800efb:	c3                   	ret    

00800efc <pipeisclosed>:
{
  800efc:	f3 0f 1e fb          	endbr32 
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f09:	50                   	push   %eax
  800f0a:	ff 75 08             	pushl  0x8(%ebp)
  800f0d:	e8 f6 f4 ff ff       	call   800408 <fd_lookup>
  800f12:	83 c4 10             	add    $0x10,%esp
  800f15:	85 c0                	test   %eax,%eax
  800f17:	78 18                	js     800f31 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  800f19:	83 ec 0c             	sub    $0xc,%esp
  800f1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f1f:	e8 73 f4 ff ff       	call   800397 <fd2data>
  800f24:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  800f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f29:	e8 1f fd ff ff       	call   800c4d <_pipeisclosed>
  800f2e:	83 c4 10             	add    $0x10,%esp
}
  800f31:	c9                   	leave  
  800f32:	c3                   	ret    

00800f33 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800f33:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  800f37:	b8 00 00 00 00       	mov    $0x0,%eax
  800f3c:	c3                   	ret    

00800f3d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f3d:	f3 0f 1e fb          	endbr32 
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800f47:	68 16 20 80 00       	push   $0x802016
  800f4c:	ff 75 0c             	pushl  0xc(%ebp)
  800f4f:	e8 65 08 00 00       	call   8017b9 <strcpy>
	return 0;
}
  800f54:	b8 00 00 00 00       	mov    $0x0,%eax
  800f59:	c9                   	leave  
  800f5a:	c3                   	ret    

00800f5b <devcons_write>:
{
  800f5b:	f3 0f 1e fb          	endbr32 
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	57                   	push   %edi
  800f63:	56                   	push   %esi
  800f64:	53                   	push   %ebx
  800f65:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800f6b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800f70:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800f76:	3b 75 10             	cmp    0x10(%ebp),%esi
  800f79:	73 31                	jae    800fac <devcons_write+0x51>
		m = n - tot;
  800f7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7e:	29 f3                	sub    %esi,%ebx
  800f80:	83 fb 7f             	cmp    $0x7f,%ebx
  800f83:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800f88:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800f8b:	83 ec 04             	sub    $0x4,%esp
  800f8e:	53                   	push   %ebx
  800f8f:	89 f0                	mov    %esi,%eax
  800f91:	03 45 0c             	add    0xc(%ebp),%eax
  800f94:	50                   	push   %eax
  800f95:	57                   	push   %edi
  800f96:	e8 d4 09 00 00       	call   80196f <memmove>
		sys_cputs(buf, m);
  800f9b:	83 c4 08             	add    $0x8,%esp
  800f9e:	53                   	push   %ebx
  800f9f:	57                   	push   %edi
  800fa0:	e8 fd f0 ff ff       	call   8000a2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800fa5:	01 de                	add    %ebx,%esi
  800fa7:	83 c4 10             	add    $0x10,%esp
  800faa:	eb ca                	jmp    800f76 <devcons_write+0x1b>
}
  800fac:	89 f0                	mov    %esi,%eax
  800fae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <devcons_read>:
{
  800fb6:	f3 0f 1e fb          	endbr32 
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	83 ec 08             	sub    $0x8,%esp
  800fc0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800fc5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc9:	74 21                	je     800fec <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800fcb:	e8 f4 f0 ff ff       	call   8000c4 <sys_cgetc>
  800fd0:	85 c0                	test   %eax,%eax
  800fd2:	75 07                	jne    800fdb <devcons_read+0x25>
		sys_yield();
  800fd4:	e8 76 f1 ff ff       	call   80014f <sys_yield>
  800fd9:	eb f0                	jmp    800fcb <devcons_read+0x15>
	if (c < 0)
  800fdb:	78 0f                	js     800fec <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  800fdd:	83 f8 04             	cmp    $0x4,%eax
  800fe0:	74 0c                	je     800fee <devcons_read+0x38>
	*(char*)vbuf = c;
  800fe2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe5:	88 02                	mov    %al,(%edx)
	return 1;
  800fe7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fec:	c9                   	leave  
  800fed:	c3                   	ret    
		return 0;
  800fee:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff3:	eb f7                	jmp    800fec <devcons_read+0x36>

00800ff5 <cputchar>:
{
  800ff5:	f3 0f 1e fb          	endbr32 
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801005:	6a 01                	push   $0x1
  801007:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80100a:	50                   	push   %eax
  80100b:	e8 92 f0 ff ff       	call   8000a2 <sys_cputs>
}
  801010:	83 c4 10             	add    $0x10,%esp
  801013:	c9                   	leave  
  801014:	c3                   	ret    

00801015 <getchar>:
{
  801015:	f3 0f 1e fb          	endbr32 
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80101f:	6a 01                	push   $0x1
  801021:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801024:	50                   	push   %eax
  801025:	6a 00                	push   $0x0
  801027:	e8 5f f6 ff ff       	call   80068b <read>
	if (r < 0)
  80102c:	83 c4 10             	add    $0x10,%esp
  80102f:	85 c0                	test   %eax,%eax
  801031:	78 06                	js     801039 <getchar+0x24>
	if (r < 1)
  801033:	74 06                	je     80103b <getchar+0x26>
	return c;
  801035:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801039:	c9                   	leave  
  80103a:	c3                   	ret    
		return -E_EOF;
  80103b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801040:	eb f7                	jmp    801039 <getchar+0x24>

00801042 <iscons>:
{
  801042:	f3 0f 1e fb          	endbr32 
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80104c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80104f:	50                   	push   %eax
  801050:	ff 75 08             	pushl  0x8(%ebp)
  801053:	e8 b0 f3 ff ff       	call   800408 <fd_lookup>
  801058:	83 c4 10             	add    $0x10,%esp
  80105b:	85 c0                	test   %eax,%eax
  80105d:	78 11                	js     801070 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80105f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801062:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801068:	39 10                	cmp    %edx,(%eax)
  80106a:	0f 94 c0             	sete   %al
  80106d:	0f b6 c0             	movzbl %al,%eax
}
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <opencons>:
{
  801072:	f3 0f 1e fb          	endbr32 
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80107c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80107f:	50                   	push   %eax
  801080:	e8 2d f3 ff ff       	call   8003b2 <fd_alloc>
  801085:	83 c4 10             	add    $0x10,%esp
  801088:	85 c0                	test   %eax,%eax
  80108a:	78 3a                	js     8010c6 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80108c:	83 ec 04             	sub    $0x4,%esp
  80108f:	68 07 04 00 00       	push   $0x407
  801094:	ff 75 f4             	pushl  -0xc(%ebp)
  801097:	6a 00                	push   $0x0
  801099:	e8 d4 f0 ff ff       	call   800172 <sys_page_alloc>
  80109e:	83 c4 10             	add    $0x10,%esp
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	78 21                	js     8010c6 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8010a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010a8:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010ae:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8010b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8010ba:	83 ec 0c             	sub    $0xc,%esp
  8010bd:	50                   	push   %eax
  8010be:	e8 c0 f2 ff ff       	call   800383 <fd2num>
  8010c3:	83 c4 10             	add    $0x10,%esp
}
  8010c6:	c9                   	leave  
  8010c7:	c3                   	ret    

008010c8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8010c8:	f3 0f 1e fb          	endbr32 
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
  8010cf:	56                   	push   %esi
  8010d0:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8010d1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8010d4:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8010da:	e8 4d f0 ff ff       	call   80012c <sys_getenvid>
  8010df:	83 ec 0c             	sub    $0xc,%esp
  8010e2:	ff 75 0c             	pushl  0xc(%ebp)
  8010e5:	ff 75 08             	pushl  0x8(%ebp)
  8010e8:	56                   	push   %esi
  8010e9:	50                   	push   %eax
  8010ea:	68 24 20 80 00       	push   $0x802024
  8010ef:	e8 bb 00 00 00       	call   8011af <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8010f4:	83 c4 18             	add    $0x18,%esp
  8010f7:	53                   	push   %ebx
  8010f8:	ff 75 10             	pushl  0x10(%ebp)
  8010fb:	e8 5a 00 00 00       	call   80115a <vcprintf>
	cprintf("\n");
  801100:	c7 04 24 58 23 80 00 	movl   $0x802358,(%esp)
  801107:	e8 a3 00 00 00       	call   8011af <cprintf>
  80110c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80110f:	cc                   	int3   
  801110:	eb fd                	jmp    80110f <_panic+0x47>

00801112 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801112:	f3 0f 1e fb          	endbr32 
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	53                   	push   %ebx
  80111a:	83 ec 04             	sub    $0x4,%esp
  80111d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801120:	8b 13                	mov    (%ebx),%edx
  801122:	8d 42 01             	lea    0x1(%edx),%eax
  801125:	89 03                	mov    %eax,(%ebx)
  801127:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80112a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80112e:	3d ff 00 00 00       	cmp    $0xff,%eax
  801133:	74 09                	je     80113e <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801135:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801139:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80113c:	c9                   	leave  
  80113d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80113e:	83 ec 08             	sub    $0x8,%esp
  801141:	68 ff 00 00 00       	push   $0xff
  801146:	8d 43 08             	lea    0x8(%ebx),%eax
  801149:	50                   	push   %eax
  80114a:	e8 53 ef ff ff       	call   8000a2 <sys_cputs>
		b->idx = 0;
  80114f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801155:	83 c4 10             	add    $0x10,%esp
  801158:	eb db                	jmp    801135 <putch+0x23>

0080115a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80115a:	f3 0f 1e fb          	endbr32 
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
  801161:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801167:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80116e:	00 00 00 
	b.cnt = 0;
  801171:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801178:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80117b:	ff 75 0c             	pushl  0xc(%ebp)
  80117e:	ff 75 08             	pushl  0x8(%ebp)
  801181:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801187:	50                   	push   %eax
  801188:	68 12 11 80 00       	push   $0x801112
  80118d:	e8 20 01 00 00       	call   8012b2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801192:	83 c4 08             	add    $0x8,%esp
  801195:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80119b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8011a1:	50                   	push   %eax
  8011a2:	e8 fb ee ff ff       	call   8000a2 <sys_cputs>

	return b.cnt;
}
  8011a7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8011ad:	c9                   	leave  
  8011ae:	c3                   	ret    

008011af <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8011af:	f3 0f 1e fb          	endbr32 
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
  8011b6:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8011b9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8011bc:	50                   	push   %eax
  8011bd:	ff 75 08             	pushl  0x8(%ebp)
  8011c0:	e8 95 ff ff ff       	call   80115a <vcprintf>
	va_end(ap);

	return cnt;
}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	57                   	push   %edi
  8011cb:	56                   	push   %esi
  8011cc:	53                   	push   %ebx
  8011cd:	83 ec 1c             	sub    $0x1c,%esp
  8011d0:	89 c7                	mov    %eax,%edi
  8011d2:	89 d6                	mov    %edx,%esi
  8011d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011da:	89 d1                	mov    %edx,%ecx
  8011dc:	89 c2                	mov    %eax,%edx
  8011de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011e1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8011e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e7:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8011ed:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8011f4:	39 c2                	cmp    %eax,%edx
  8011f6:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8011f9:	72 3e                	jb     801239 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8011fb:	83 ec 0c             	sub    $0xc,%esp
  8011fe:	ff 75 18             	pushl  0x18(%ebp)
  801201:	83 eb 01             	sub    $0x1,%ebx
  801204:	53                   	push   %ebx
  801205:	50                   	push   %eax
  801206:	83 ec 08             	sub    $0x8,%esp
  801209:	ff 75 e4             	pushl  -0x1c(%ebp)
  80120c:	ff 75 e0             	pushl  -0x20(%ebp)
  80120f:	ff 75 dc             	pushl  -0x24(%ebp)
  801212:	ff 75 d8             	pushl  -0x28(%ebp)
  801215:	e8 76 0a 00 00       	call   801c90 <__udivdi3>
  80121a:	83 c4 18             	add    $0x18,%esp
  80121d:	52                   	push   %edx
  80121e:	50                   	push   %eax
  80121f:	89 f2                	mov    %esi,%edx
  801221:	89 f8                	mov    %edi,%eax
  801223:	e8 9f ff ff ff       	call   8011c7 <printnum>
  801228:	83 c4 20             	add    $0x20,%esp
  80122b:	eb 13                	jmp    801240 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80122d:	83 ec 08             	sub    $0x8,%esp
  801230:	56                   	push   %esi
  801231:	ff 75 18             	pushl  0x18(%ebp)
  801234:	ff d7                	call   *%edi
  801236:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801239:	83 eb 01             	sub    $0x1,%ebx
  80123c:	85 db                	test   %ebx,%ebx
  80123e:	7f ed                	jg     80122d <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801240:	83 ec 08             	sub    $0x8,%esp
  801243:	56                   	push   %esi
  801244:	83 ec 04             	sub    $0x4,%esp
  801247:	ff 75 e4             	pushl  -0x1c(%ebp)
  80124a:	ff 75 e0             	pushl  -0x20(%ebp)
  80124d:	ff 75 dc             	pushl  -0x24(%ebp)
  801250:	ff 75 d8             	pushl  -0x28(%ebp)
  801253:	e8 48 0b 00 00       	call   801da0 <__umoddi3>
  801258:	83 c4 14             	add    $0x14,%esp
  80125b:	0f be 80 47 20 80 00 	movsbl 0x802047(%eax),%eax
  801262:	50                   	push   %eax
  801263:	ff d7                	call   *%edi
}
  801265:	83 c4 10             	add    $0x10,%esp
  801268:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80126b:	5b                   	pop    %ebx
  80126c:	5e                   	pop    %esi
  80126d:	5f                   	pop    %edi
  80126e:	5d                   	pop    %ebp
  80126f:	c3                   	ret    

00801270 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801270:	f3 0f 1e fb          	endbr32 
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80127a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80127e:	8b 10                	mov    (%eax),%edx
  801280:	3b 50 04             	cmp    0x4(%eax),%edx
  801283:	73 0a                	jae    80128f <sprintputch+0x1f>
		*b->buf++ = ch;
  801285:	8d 4a 01             	lea    0x1(%edx),%ecx
  801288:	89 08                	mov    %ecx,(%eax)
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	88 02                	mov    %al,(%edx)
}
  80128f:	5d                   	pop    %ebp
  801290:	c3                   	ret    

00801291 <printfmt>:
{
  801291:	f3 0f 1e fb          	endbr32 
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
  801298:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80129b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80129e:	50                   	push   %eax
  80129f:	ff 75 10             	pushl  0x10(%ebp)
  8012a2:	ff 75 0c             	pushl  0xc(%ebp)
  8012a5:	ff 75 08             	pushl  0x8(%ebp)
  8012a8:	e8 05 00 00 00       	call   8012b2 <vprintfmt>
}
  8012ad:	83 c4 10             	add    $0x10,%esp
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <vprintfmt>:
{
  8012b2:	f3 0f 1e fb          	endbr32 
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
  8012b9:	57                   	push   %edi
  8012ba:	56                   	push   %esi
  8012bb:	53                   	push   %ebx
  8012bc:	83 ec 3c             	sub    $0x3c,%esp
  8012bf:	8b 75 08             	mov    0x8(%ebp),%esi
  8012c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012c5:	8b 7d 10             	mov    0x10(%ebp),%edi
  8012c8:	e9 8e 03 00 00       	jmp    80165b <vprintfmt+0x3a9>
		padc = ' ';
  8012cd:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8012d1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8012d8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8012df:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8012e6:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8012eb:	8d 47 01             	lea    0x1(%edi),%eax
  8012ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012f1:	0f b6 17             	movzbl (%edi),%edx
  8012f4:	8d 42 dd             	lea    -0x23(%edx),%eax
  8012f7:	3c 55                	cmp    $0x55,%al
  8012f9:	0f 87 df 03 00 00    	ja     8016de <vprintfmt+0x42c>
  8012ff:	0f b6 c0             	movzbl %al,%eax
  801302:	3e ff 24 85 80 21 80 	notrack jmp *0x802180(,%eax,4)
  801309:	00 
  80130a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80130d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801311:	eb d8                	jmp    8012eb <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801313:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801316:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80131a:	eb cf                	jmp    8012eb <vprintfmt+0x39>
  80131c:	0f b6 d2             	movzbl %dl,%edx
  80131f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801322:	b8 00 00 00 00       	mov    $0x0,%eax
  801327:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80132a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80132d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801331:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801334:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801337:	83 f9 09             	cmp    $0x9,%ecx
  80133a:	77 55                	ja     801391 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80133c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80133f:	eb e9                	jmp    80132a <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801341:	8b 45 14             	mov    0x14(%ebp),%eax
  801344:	8b 00                	mov    (%eax),%eax
  801346:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801349:	8b 45 14             	mov    0x14(%ebp),%eax
  80134c:	8d 40 04             	lea    0x4(%eax),%eax
  80134f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801352:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801355:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801359:	79 90                	jns    8012eb <vprintfmt+0x39>
				width = precision, precision = -1;
  80135b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80135e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801361:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801368:	eb 81                	jmp    8012eb <vprintfmt+0x39>
  80136a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80136d:	85 c0                	test   %eax,%eax
  80136f:	ba 00 00 00 00       	mov    $0x0,%edx
  801374:	0f 49 d0             	cmovns %eax,%edx
  801377:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80137a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80137d:	e9 69 ff ff ff       	jmp    8012eb <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801382:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801385:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80138c:	e9 5a ff ff ff       	jmp    8012eb <vprintfmt+0x39>
  801391:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801394:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801397:	eb bc                	jmp    801355 <vprintfmt+0xa3>
			lflag++;
  801399:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80139c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80139f:	e9 47 ff ff ff       	jmp    8012eb <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8013a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a7:	8d 78 04             	lea    0x4(%eax),%edi
  8013aa:	83 ec 08             	sub    $0x8,%esp
  8013ad:	53                   	push   %ebx
  8013ae:	ff 30                	pushl  (%eax)
  8013b0:	ff d6                	call   *%esi
			break;
  8013b2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8013b5:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8013b8:	e9 9b 02 00 00       	jmp    801658 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8013bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c0:	8d 78 04             	lea    0x4(%eax),%edi
  8013c3:	8b 00                	mov    (%eax),%eax
  8013c5:	99                   	cltd   
  8013c6:	31 d0                	xor    %edx,%eax
  8013c8:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8013ca:	83 f8 0f             	cmp    $0xf,%eax
  8013cd:	7f 23                	jg     8013f2 <vprintfmt+0x140>
  8013cf:	8b 14 85 e0 22 80 00 	mov    0x8022e0(,%eax,4),%edx
  8013d6:	85 d2                	test   %edx,%edx
  8013d8:	74 18                	je     8013f2 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8013da:	52                   	push   %edx
  8013db:	68 dd 1f 80 00       	push   $0x801fdd
  8013e0:	53                   	push   %ebx
  8013e1:	56                   	push   %esi
  8013e2:	e8 aa fe ff ff       	call   801291 <printfmt>
  8013e7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8013ea:	89 7d 14             	mov    %edi,0x14(%ebp)
  8013ed:	e9 66 02 00 00       	jmp    801658 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8013f2:	50                   	push   %eax
  8013f3:	68 5f 20 80 00       	push   $0x80205f
  8013f8:	53                   	push   %ebx
  8013f9:	56                   	push   %esi
  8013fa:	e8 92 fe ff ff       	call   801291 <printfmt>
  8013ff:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801402:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801405:	e9 4e 02 00 00       	jmp    801658 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80140a:	8b 45 14             	mov    0x14(%ebp),%eax
  80140d:	83 c0 04             	add    $0x4,%eax
  801410:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801413:	8b 45 14             	mov    0x14(%ebp),%eax
  801416:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801418:	85 d2                	test   %edx,%edx
  80141a:	b8 58 20 80 00       	mov    $0x802058,%eax
  80141f:	0f 45 c2             	cmovne %edx,%eax
  801422:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801425:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801429:	7e 06                	jle    801431 <vprintfmt+0x17f>
  80142b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80142f:	75 0d                	jne    80143e <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801431:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801434:	89 c7                	mov    %eax,%edi
  801436:	03 45 e0             	add    -0x20(%ebp),%eax
  801439:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80143c:	eb 55                	jmp    801493 <vprintfmt+0x1e1>
  80143e:	83 ec 08             	sub    $0x8,%esp
  801441:	ff 75 d8             	pushl  -0x28(%ebp)
  801444:	ff 75 cc             	pushl  -0x34(%ebp)
  801447:	e8 46 03 00 00       	call   801792 <strnlen>
  80144c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80144f:	29 c2                	sub    %eax,%edx
  801451:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801454:	83 c4 10             	add    $0x10,%esp
  801457:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801459:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80145d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801460:	85 ff                	test   %edi,%edi
  801462:	7e 11                	jle    801475 <vprintfmt+0x1c3>
					putch(padc, putdat);
  801464:	83 ec 08             	sub    $0x8,%esp
  801467:	53                   	push   %ebx
  801468:	ff 75 e0             	pushl  -0x20(%ebp)
  80146b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80146d:	83 ef 01             	sub    $0x1,%edi
  801470:	83 c4 10             	add    $0x10,%esp
  801473:	eb eb                	jmp    801460 <vprintfmt+0x1ae>
  801475:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801478:	85 d2                	test   %edx,%edx
  80147a:	b8 00 00 00 00       	mov    $0x0,%eax
  80147f:	0f 49 c2             	cmovns %edx,%eax
  801482:	29 c2                	sub    %eax,%edx
  801484:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801487:	eb a8                	jmp    801431 <vprintfmt+0x17f>
					putch(ch, putdat);
  801489:	83 ec 08             	sub    $0x8,%esp
  80148c:	53                   	push   %ebx
  80148d:	52                   	push   %edx
  80148e:	ff d6                	call   *%esi
  801490:	83 c4 10             	add    $0x10,%esp
  801493:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801496:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801498:	83 c7 01             	add    $0x1,%edi
  80149b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80149f:	0f be d0             	movsbl %al,%edx
  8014a2:	85 d2                	test   %edx,%edx
  8014a4:	74 4b                	je     8014f1 <vprintfmt+0x23f>
  8014a6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014aa:	78 06                	js     8014b2 <vprintfmt+0x200>
  8014ac:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8014b0:	78 1e                	js     8014d0 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8014b2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8014b6:	74 d1                	je     801489 <vprintfmt+0x1d7>
  8014b8:	0f be c0             	movsbl %al,%eax
  8014bb:	83 e8 20             	sub    $0x20,%eax
  8014be:	83 f8 5e             	cmp    $0x5e,%eax
  8014c1:	76 c6                	jbe    801489 <vprintfmt+0x1d7>
					putch('?', putdat);
  8014c3:	83 ec 08             	sub    $0x8,%esp
  8014c6:	53                   	push   %ebx
  8014c7:	6a 3f                	push   $0x3f
  8014c9:	ff d6                	call   *%esi
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	eb c3                	jmp    801493 <vprintfmt+0x1e1>
  8014d0:	89 cf                	mov    %ecx,%edi
  8014d2:	eb 0e                	jmp    8014e2 <vprintfmt+0x230>
				putch(' ', putdat);
  8014d4:	83 ec 08             	sub    $0x8,%esp
  8014d7:	53                   	push   %ebx
  8014d8:	6a 20                	push   $0x20
  8014da:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8014dc:	83 ef 01             	sub    $0x1,%edi
  8014df:	83 c4 10             	add    $0x10,%esp
  8014e2:	85 ff                	test   %edi,%edi
  8014e4:	7f ee                	jg     8014d4 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8014e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8014e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8014ec:	e9 67 01 00 00       	jmp    801658 <vprintfmt+0x3a6>
  8014f1:	89 cf                	mov    %ecx,%edi
  8014f3:	eb ed                	jmp    8014e2 <vprintfmt+0x230>
	if (lflag >= 2)
  8014f5:	83 f9 01             	cmp    $0x1,%ecx
  8014f8:	7f 1b                	jg     801515 <vprintfmt+0x263>
	else if (lflag)
  8014fa:	85 c9                	test   %ecx,%ecx
  8014fc:	74 63                	je     801561 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8014fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801501:	8b 00                	mov    (%eax),%eax
  801503:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801506:	99                   	cltd   
  801507:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80150a:	8b 45 14             	mov    0x14(%ebp),%eax
  80150d:	8d 40 04             	lea    0x4(%eax),%eax
  801510:	89 45 14             	mov    %eax,0x14(%ebp)
  801513:	eb 17                	jmp    80152c <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801515:	8b 45 14             	mov    0x14(%ebp),%eax
  801518:	8b 50 04             	mov    0x4(%eax),%edx
  80151b:	8b 00                	mov    (%eax),%eax
  80151d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801520:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801523:	8b 45 14             	mov    0x14(%ebp),%eax
  801526:	8d 40 08             	lea    0x8(%eax),%eax
  801529:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80152c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80152f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801532:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801537:	85 c9                	test   %ecx,%ecx
  801539:	0f 89 ff 00 00 00    	jns    80163e <vprintfmt+0x38c>
				putch('-', putdat);
  80153f:	83 ec 08             	sub    $0x8,%esp
  801542:	53                   	push   %ebx
  801543:	6a 2d                	push   $0x2d
  801545:	ff d6                	call   *%esi
				num = -(long long) num;
  801547:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80154a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80154d:	f7 da                	neg    %edx
  80154f:	83 d1 00             	adc    $0x0,%ecx
  801552:	f7 d9                	neg    %ecx
  801554:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801557:	b8 0a 00 00 00       	mov    $0xa,%eax
  80155c:	e9 dd 00 00 00       	jmp    80163e <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801561:	8b 45 14             	mov    0x14(%ebp),%eax
  801564:	8b 00                	mov    (%eax),%eax
  801566:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801569:	99                   	cltd   
  80156a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80156d:	8b 45 14             	mov    0x14(%ebp),%eax
  801570:	8d 40 04             	lea    0x4(%eax),%eax
  801573:	89 45 14             	mov    %eax,0x14(%ebp)
  801576:	eb b4                	jmp    80152c <vprintfmt+0x27a>
	if (lflag >= 2)
  801578:	83 f9 01             	cmp    $0x1,%ecx
  80157b:	7f 1e                	jg     80159b <vprintfmt+0x2e9>
	else if (lflag)
  80157d:	85 c9                	test   %ecx,%ecx
  80157f:	74 32                	je     8015b3 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801581:	8b 45 14             	mov    0x14(%ebp),%eax
  801584:	8b 10                	mov    (%eax),%edx
  801586:	b9 00 00 00 00       	mov    $0x0,%ecx
  80158b:	8d 40 04             	lea    0x4(%eax),%eax
  80158e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801591:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801596:	e9 a3 00 00 00       	jmp    80163e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80159b:	8b 45 14             	mov    0x14(%ebp),%eax
  80159e:	8b 10                	mov    (%eax),%edx
  8015a0:	8b 48 04             	mov    0x4(%eax),%ecx
  8015a3:	8d 40 08             	lea    0x8(%eax),%eax
  8015a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015a9:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8015ae:	e9 8b 00 00 00       	jmp    80163e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8015b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b6:	8b 10                	mov    (%eax),%edx
  8015b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015bd:	8d 40 04             	lea    0x4(%eax),%eax
  8015c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015c3:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8015c8:	eb 74                	jmp    80163e <vprintfmt+0x38c>
	if (lflag >= 2)
  8015ca:	83 f9 01             	cmp    $0x1,%ecx
  8015cd:	7f 1b                	jg     8015ea <vprintfmt+0x338>
	else if (lflag)
  8015cf:	85 c9                	test   %ecx,%ecx
  8015d1:	74 2c                	je     8015ff <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8015d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d6:	8b 10                	mov    (%eax),%edx
  8015d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015dd:	8d 40 04             	lea    0x4(%eax),%eax
  8015e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8015e3:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8015e8:	eb 54                	jmp    80163e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8015ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ed:	8b 10                	mov    (%eax),%edx
  8015ef:	8b 48 04             	mov    0x4(%eax),%ecx
  8015f2:	8d 40 08             	lea    0x8(%eax),%eax
  8015f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8015f8:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8015fd:	eb 3f                	jmp    80163e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8015ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801602:	8b 10                	mov    (%eax),%edx
  801604:	b9 00 00 00 00       	mov    $0x0,%ecx
  801609:	8d 40 04             	lea    0x4(%eax),%eax
  80160c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80160f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801614:	eb 28                	jmp    80163e <vprintfmt+0x38c>
			putch('0', putdat);
  801616:	83 ec 08             	sub    $0x8,%esp
  801619:	53                   	push   %ebx
  80161a:	6a 30                	push   $0x30
  80161c:	ff d6                	call   *%esi
			putch('x', putdat);
  80161e:	83 c4 08             	add    $0x8,%esp
  801621:	53                   	push   %ebx
  801622:	6a 78                	push   $0x78
  801624:	ff d6                	call   *%esi
			num = (unsigned long long)
  801626:	8b 45 14             	mov    0x14(%ebp),%eax
  801629:	8b 10                	mov    (%eax),%edx
  80162b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801630:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801633:	8d 40 04             	lea    0x4(%eax),%eax
  801636:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801639:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80163e:	83 ec 0c             	sub    $0xc,%esp
  801641:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801645:	57                   	push   %edi
  801646:	ff 75 e0             	pushl  -0x20(%ebp)
  801649:	50                   	push   %eax
  80164a:	51                   	push   %ecx
  80164b:	52                   	push   %edx
  80164c:	89 da                	mov    %ebx,%edx
  80164e:	89 f0                	mov    %esi,%eax
  801650:	e8 72 fb ff ff       	call   8011c7 <printnum>
			break;
  801655:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801658:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80165b:	83 c7 01             	add    $0x1,%edi
  80165e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801662:	83 f8 25             	cmp    $0x25,%eax
  801665:	0f 84 62 fc ff ff    	je     8012cd <vprintfmt+0x1b>
			if (ch == '\0')
  80166b:	85 c0                	test   %eax,%eax
  80166d:	0f 84 8b 00 00 00    	je     8016fe <vprintfmt+0x44c>
			putch(ch, putdat);
  801673:	83 ec 08             	sub    $0x8,%esp
  801676:	53                   	push   %ebx
  801677:	50                   	push   %eax
  801678:	ff d6                	call   *%esi
  80167a:	83 c4 10             	add    $0x10,%esp
  80167d:	eb dc                	jmp    80165b <vprintfmt+0x3a9>
	if (lflag >= 2)
  80167f:	83 f9 01             	cmp    $0x1,%ecx
  801682:	7f 1b                	jg     80169f <vprintfmt+0x3ed>
	else if (lflag)
  801684:	85 c9                	test   %ecx,%ecx
  801686:	74 2c                	je     8016b4 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801688:	8b 45 14             	mov    0x14(%ebp),%eax
  80168b:	8b 10                	mov    (%eax),%edx
  80168d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801692:	8d 40 04             	lea    0x4(%eax),%eax
  801695:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801698:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80169d:	eb 9f                	jmp    80163e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80169f:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a2:	8b 10                	mov    (%eax),%edx
  8016a4:	8b 48 04             	mov    0x4(%eax),%ecx
  8016a7:	8d 40 08             	lea    0x8(%eax),%eax
  8016aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016ad:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8016b2:	eb 8a                	jmp    80163e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8016b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b7:	8b 10                	mov    (%eax),%edx
  8016b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016be:	8d 40 04             	lea    0x4(%eax),%eax
  8016c1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016c4:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8016c9:	e9 70 ff ff ff       	jmp    80163e <vprintfmt+0x38c>
			putch(ch, putdat);
  8016ce:	83 ec 08             	sub    $0x8,%esp
  8016d1:	53                   	push   %ebx
  8016d2:	6a 25                	push   $0x25
  8016d4:	ff d6                	call   *%esi
			break;
  8016d6:	83 c4 10             	add    $0x10,%esp
  8016d9:	e9 7a ff ff ff       	jmp    801658 <vprintfmt+0x3a6>
			putch('%', putdat);
  8016de:	83 ec 08             	sub    $0x8,%esp
  8016e1:	53                   	push   %ebx
  8016e2:	6a 25                	push   $0x25
  8016e4:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8016e6:	83 c4 10             	add    $0x10,%esp
  8016e9:	89 f8                	mov    %edi,%eax
  8016eb:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8016ef:	74 05                	je     8016f6 <vprintfmt+0x444>
  8016f1:	83 e8 01             	sub    $0x1,%eax
  8016f4:	eb f5                	jmp    8016eb <vprintfmt+0x439>
  8016f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016f9:	e9 5a ff ff ff       	jmp    801658 <vprintfmt+0x3a6>
}
  8016fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801701:	5b                   	pop    %ebx
  801702:	5e                   	pop    %esi
  801703:	5f                   	pop    %edi
  801704:	5d                   	pop    %ebp
  801705:	c3                   	ret    

00801706 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801706:	f3 0f 1e fb          	endbr32 
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	83 ec 18             	sub    $0x18,%esp
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801716:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801719:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80171d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801720:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801727:	85 c0                	test   %eax,%eax
  801729:	74 26                	je     801751 <vsnprintf+0x4b>
  80172b:	85 d2                	test   %edx,%edx
  80172d:	7e 22                	jle    801751 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80172f:	ff 75 14             	pushl  0x14(%ebp)
  801732:	ff 75 10             	pushl  0x10(%ebp)
  801735:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801738:	50                   	push   %eax
  801739:	68 70 12 80 00       	push   $0x801270
  80173e:	e8 6f fb ff ff       	call   8012b2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801743:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801746:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174c:	83 c4 10             	add    $0x10,%esp
}
  80174f:	c9                   	leave  
  801750:	c3                   	ret    
		return -E_INVAL;
  801751:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801756:	eb f7                	jmp    80174f <vsnprintf+0x49>

00801758 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801758:	f3 0f 1e fb          	endbr32 
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801762:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801765:	50                   	push   %eax
  801766:	ff 75 10             	pushl  0x10(%ebp)
  801769:	ff 75 0c             	pushl  0xc(%ebp)
  80176c:	ff 75 08             	pushl  0x8(%ebp)
  80176f:	e8 92 ff ff ff       	call   801706 <vsnprintf>
	va_end(ap);

	return rc;
}
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801776:	f3 0f 1e fb          	endbr32 
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801780:	b8 00 00 00 00       	mov    $0x0,%eax
  801785:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801789:	74 05                	je     801790 <strlen+0x1a>
		n++;
  80178b:	83 c0 01             	add    $0x1,%eax
  80178e:	eb f5                	jmp    801785 <strlen+0xf>
	return n;
}
  801790:	5d                   	pop    %ebp
  801791:	c3                   	ret    

00801792 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801792:	f3 0f 1e fb          	endbr32 
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80179c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80179f:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a4:	39 d0                	cmp    %edx,%eax
  8017a6:	74 0d                	je     8017b5 <strnlen+0x23>
  8017a8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8017ac:	74 05                	je     8017b3 <strnlen+0x21>
		n++;
  8017ae:	83 c0 01             	add    $0x1,%eax
  8017b1:	eb f1                	jmp    8017a4 <strnlen+0x12>
  8017b3:	89 c2                	mov    %eax,%edx
	return n;
}
  8017b5:	89 d0                	mov    %edx,%eax
  8017b7:	5d                   	pop    %ebp
  8017b8:	c3                   	ret    

008017b9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8017b9:	f3 0f 1e fb          	endbr32 
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
  8017c0:	53                   	push   %ebx
  8017c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8017c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cc:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8017d0:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8017d3:	83 c0 01             	add    $0x1,%eax
  8017d6:	84 d2                	test   %dl,%dl
  8017d8:	75 f2                	jne    8017cc <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8017da:	89 c8                	mov    %ecx,%eax
  8017dc:	5b                   	pop    %ebx
  8017dd:	5d                   	pop    %ebp
  8017de:	c3                   	ret    

008017df <strcat>:

char *
strcat(char *dst, const char *src)
{
  8017df:	f3 0f 1e fb          	endbr32 
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
  8017e6:	53                   	push   %ebx
  8017e7:	83 ec 10             	sub    $0x10,%esp
  8017ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8017ed:	53                   	push   %ebx
  8017ee:	e8 83 ff ff ff       	call   801776 <strlen>
  8017f3:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8017f6:	ff 75 0c             	pushl  0xc(%ebp)
  8017f9:	01 d8                	add    %ebx,%eax
  8017fb:	50                   	push   %eax
  8017fc:	e8 b8 ff ff ff       	call   8017b9 <strcpy>
	return dst;
}
  801801:	89 d8                	mov    %ebx,%eax
  801803:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801808:	f3 0f 1e fb          	endbr32 
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	56                   	push   %esi
  801810:	53                   	push   %ebx
  801811:	8b 75 08             	mov    0x8(%ebp),%esi
  801814:	8b 55 0c             	mov    0xc(%ebp),%edx
  801817:	89 f3                	mov    %esi,%ebx
  801819:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80181c:	89 f0                	mov    %esi,%eax
  80181e:	39 d8                	cmp    %ebx,%eax
  801820:	74 11                	je     801833 <strncpy+0x2b>
		*dst++ = *src;
  801822:	83 c0 01             	add    $0x1,%eax
  801825:	0f b6 0a             	movzbl (%edx),%ecx
  801828:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80182b:	80 f9 01             	cmp    $0x1,%cl
  80182e:	83 da ff             	sbb    $0xffffffff,%edx
  801831:	eb eb                	jmp    80181e <strncpy+0x16>
	}
	return ret;
}
  801833:	89 f0                	mov    %esi,%eax
  801835:	5b                   	pop    %ebx
  801836:	5e                   	pop    %esi
  801837:	5d                   	pop    %ebp
  801838:	c3                   	ret    

00801839 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801839:	f3 0f 1e fb          	endbr32 
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	56                   	push   %esi
  801841:	53                   	push   %ebx
  801842:	8b 75 08             	mov    0x8(%ebp),%esi
  801845:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801848:	8b 55 10             	mov    0x10(%ebp),%edx
  80184b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80184d:	85 d2                	test   %edx,%edx
  80184f:	74 21                	je     801872 <strlcpy+0x39>
  801851:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801855:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801857:	39 c2                	cmp    %eax,%edx
  801859:	74 14                	je     80186f <strlcpy+0x36>
  80185b:	0f b6 19             	movzbl (%ecx),%ebx
  80185e:	84 db                	test   %bl,%bl
  801860:	74 0b                	je     80186d <strlcpy+0x34>
			*dst++ = *src++;
  801862:	83 c1 01             	add    $0x1,%ecx
  801865:	83 c2 01             	add    $0x1,%edx
  801868:	88 5a ff             	mov    %bl,-0x1(%edx)
  80186b:	eb ea                	jmp    801857 <strlcpy+0x1e>
  80186d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80186f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801872:	29 f0                	sub    %esi,%eax
}
  801874:	5b                   	pop    %ebx
  801875:	5e                   	pop    %esi
  801876:	5d                   	pop    %ebp
  801877:	c3                   	ret    

00801878 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801878:	f3 0f 1e fb          	endbr32 
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801882:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801885:	0f b6 01             	movzbl (%ecx),%eax
  801888:	84 c0                	test   %al,%al
  80188a:	74 0c                	je     801898 <strcmp+0x20>
  80188c:	3a 02                	cmp    (%edx),%al
  80188e:	75 08                	jne    801898 <strcmp+0x20>
		p++, q++;
  801890:	83 c1 01             	add    $0x1,%ecx
  801893:	83 c2 01             	add    $0x1,%edx
  801896:	eb ed                	jmp    801885 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801898:	0f b6 c0             	movzbl %al,%eax
  80189b:	0f b6 12             	movzbl (%edx),%edx
  80189e:	29 d0                	sub    %edx,%eax
}
  8018a0:	5d                   	pop    %ebp
  8018a1:	c3                   	ret    

008018a2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018a2:	f3 0f 1e fb          	endbr32 
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	53                   	push   %ebx
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b0:	89 c3                	mov    %eax,%ebx
  8018b2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8018b5:	eb 06                	jmp    8018bd <strncmp+0x1b>
		n--, p++, q++;
  8018b7:	83 c0 01             	add    $0x1,%eax
  8018ba:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8018bd:	39 d8                	cmp    %ebx,%eax
  8018bf:	74 16                	je     8018d7 <strncmp+0x35>
  8018c1:	0f b6 08             	movzbl (%eax),%ecx
  8018c4:	84 c9                	test   %cl,%cl
  8018c6:	74 04                	je     8018cc <strncmp+0x2a>
  8018c8:	3a 0a                	cmp    (%edx),%cl
  8018ca:	74 eb                	je     8018b7 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018cc:	0f b6 00             	movzbl (%eax),%eax
  8018cf:	0f b6 12             	movzbl (%edx),%edx
  8018d2:	29 d0                	sub    %edx,%eax
}
  8018d4:	5b                   	pop    %ebx
  8018d5:	5d                   	pop    %ebp
  8018d6:	c3                   	ret    
		return 0;
  8018d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018dc:	eb f6                	jmp    8018d4 <strncmp+0x32>

008018de <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018de:	f3 0f 1e fb          	endbr32 
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8018ec:	0f b6 10             	movzbl (%eax),%edx
  8018ef:	84 d2                	test   %dl,%dl
  8018f1:	74 09                	je     8018fc <strchr+0x1e>
		if (*s == c)
  8018f3:	38 ca                	cmp    %cl,%dl
  8018f5:	74 0a                	je     801901 <strchr+0x23>
	for (; *s; s++)
  8018f7:	83 c0 01             	add    $0x1,%eax
  8018fa:	eb f0                	jmp    8018ec <strchr+0xe>
			return (char *) s;
	return 0;
  8018fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801901:	5d                   	pop    %ebp
  801902:	c3                   	ret    

00801903 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801903:	f3 0f 1e fb          	endbr32 
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801911:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801914:	38 ca                	cmp    %cl,%dl
  801916:	74 09                	je     801921 <strfind+0x1e>
  801918:	84 d2                	test   %dl,%dl
  80191a:	74 05                	je     801921 <strfind+0x1e>
	for (; *s; s++)
  80191c:	83 c0 01             	add    $0x1,%eax
  80191f:	eb f0                	jmp    801911 <strfind+0xe>
			break;
	return (char *) s;
}
  801921:	5d                   	pop    %ebp
  801922:	c3                   	ret    

00801923 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801923:	f3 0f 1e fb          	endbr32 
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
  80192a:	57                   	push   %edi
  80192b:	56                   	push   %esi
  80192c:	53                   	push   %ebx
  80192d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801930:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801933:	85 c9                	test   %ecx,%ecx
  801935:	74 31                	je     801968 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801937:	89 f8                	mov    %edi,%eax
  801939:	09 c8                	or     %ecx,%eax
  80193b:	a8 03                	test   $0x3,%al
  80193d:	75 23                	jne    801962 <memset+0x3f>
		c &= 0xFF;
  80193f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801943:	89 d3                	mov    %edx,%ebx
  801945:	c1 e3 08             	shl    $0x8,%ebx
  801948:	89 d0                	mov    %edx,%eax
  80194a:	c1 e0 18             	shl    $0x18,%eax
  80194d:	89 d6                	mov    %edx,%esi
  80194f:	c1 e6 10             	shl    $0x10,%esi
  801952:	09 f0                	or     %esi,%eax
  801954:	09 c2                	or     %eax,%edx
  801956:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801958:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80195b:	89 d0                	mov    %edx,%eax
  80195d:	fc                   	cld    
  80195e:	f3 ab                	rep stos %eax,%es:(%edi)
  801960:	eb 06                	jmp    801968 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801962:	8b 45 0c             	mov    0xc(%ebp),%eax
  801965:	fc                   	cld    
  801966:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801968:	89 f8                	mov    %edi,%eax
  80196a:	5b                   	pop    %ebx
  80196b:	5e                   	pop    %esi
  80196c:	5f                   	pop    %edi
  80196d:	5d                   	pop    %ebp
  80196e:	c3                   	ret    

0080196f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80196f:	f3 0f 1e fb          	endbr32 
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
  801976:	57                   	push   %edi
  801977:	56                   	push   %esi
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80197e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801981:	39 c6                	cmp    %eax,%esi
  801983:	73 32                	jae    8019b7 <memmove+0x48>
  801985:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801988:	39 c2                	cmp    %eax,%edx
  80198a:	76 2b                	jbe    8019b7 <memmove+0x48>
		s += n;
		d += n;
  80198c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80198f:	89 fe                	mov    %edi,%esi
  801991:	09 ce                	or     %ecx,%esi
  801993:	09 d6                	or     %edx,%esi
  801995:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80199b:	75 0e                	jne    8019ab <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80199d:	83 ef 04             	sub    $0x4,%edi
  8019a0:	8d 72 fc             	lea    -0x4(%edx),%esi
  8019a3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8019a6:	fd                   	std    
  8019a7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019a9:	eb 09                	jmp    8019b4 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8019ab:	83 ef 01             	sub    $0x1,%edi
  8019ae:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8019b1:	fd                   	std    
  8019b2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8019b4:	fc                   	cld    
  8019b5:	eb 1a                	jmp    8019d1 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019b7:	89 c2                	mov    %eax,%edx
  8019b9:	09 ca                	or     %ecx,%edx
  8019bb:	09 f2                	or     %esi,%edx
  8019bd:	f6 c2 03             	test   $0x3,%dl
  8019c0:	75 0a                	jne    8019cc <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8019c2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8019c5:	89 c7                	mov    %eax,%edi
  8019c7:	fc                   	cld    
  8019c8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019ca:	eb 05                	jmp    8019d1 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8019cc:	89 c7                	mov    %eax,%edi
  8019ce:	fc                   	cld    
  8019cf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8019d1:	5e                   	pop    %esi
  8019d2:	5f                   	pop    %edi
  8019d3:	5d                   	pop    %ebp
  8019d4:	c3                   	ret    

008019d5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8019d5:	f3 0f 1e fb          	endbr32 
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8019df:	ff 75 10             	pushl  0x10(%ebp)
  8019e2:	ff 75 0c             	pushl  0xc(%ebp)
  8019e5:	ff 75 08             	pushl  0x8(%ebp)
  8019e8:	e8 82 ff ff ff       	call   80196f <memmove>
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8019ef:	f3 0f 1e fb          	endbr32 
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	56                   	push   %esi
  8019f7:	53                   	push   %ebx
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fe:	89 c6                	mov    %eax,%esi
  801a00:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801a03:	39 f0                	cmp    %esi,%eax
  801a05:	74 1c                	je     801a23 <memcmp+0x34>
		if (*s1 != *s2)
  801a07:	0f b6 08             	movzbl (%eax),%ecx
  801a0a:	0f b6 1a             	movzbl (%edx),%ebx
  801a0d:	38 d9                	cmp    %bl,%cl
  801a0f:	75 08                	jne    801a19 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801a11:	83 c0 01             	add    $0x1,%eax
  801a14:	83 c2 01             	add    $0x1,%edx
  801a17:	eb ea                	jmp    801a03 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801a19:	0f b6 c1             	movzbl %cl,%eax
  801a1c:	0f b6 db             	movzbl %bl,%ebx
  801a1f:	29 d8                	sub    %ebx,%eax
  801a21:	eb 05                	jmp    801a28 <memcmp+0x39>
	}

	return 0;
  801a23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a28:	5b                   	pop    %ebx
  801a29:	5e                   	pop    %esi
  801a2a:	5d                   	pop    %ebp
  801a2b:	c3                   	ret    

00801a2c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a2c:	f3 0f 1e fb          	endbr32 
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801a39:	89 c2                	mov    %eax,%edx
  801a3b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801a3e:	39 d0                	cmp    %edx,%eax
  801a40:	73 09                	jae    801a4b <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a42:	38 08                	cmp    %cl,(%eax)
  801a44:	74 05                	je     801a4b <memfind+0x1f>
	for (; s < ends; s++)
  801a46:	83 c0 01             	add    $0x1,%eax
  801a49:	eb f3                	jmp    801a3e <memfind+0x12>
			break;
	return (void *) s;
}
  801a4b:	5d                   	pop    %ebp
  801a4c:	c3                   	ret    

00801a4d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a4d:	f3 0f 1e fb          	endbr32 
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	57                   	push   %edi
  801a55:	56                   	push   %esi
  801a56:	53                   	push   %ebx
  801a57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a5a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a5d:	eb 03                	jmp    801a62 <strtol+0x15>
		s++;
  801a5f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801a62:	0f b6 01             	movzbl (%ecx),%eax
  801a65:	3c 20                	cmp    $0x20,%al
  801a67:	74 f6                	je     801a5f <strtol+0x12>
  801a69:	3c 09                	cmp    $0x9,%al
  801a6b:	74 f2                	je     801a5f <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801a6d:	3c 2b                	cmp    $0x2b,%al
  801a6f:	74 2a                	je     801a9b <strtol+0x4e>
	int neg = 0;
  801a71:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801a76:	3c 2d                	cmp    $0x2d,%al
  801a78:	74 2b                	je     801aa5 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a7a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801a80:	75 0f                	jne    801a91 <strtol+0x44>
  801a82:	80 39 30             	cmpb   $0x30,(%ecx)
  801a85:	74 28                	je     801aaf <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801a87:	85 db                	test   %ebx,%ebx
  801a89:	b8 0a 00 00 00       	mov    $0xa,%eax
  801a8e:	0f 44 d8             	cmove  %eax,%ebx
  801a91:	b8 00 00 00 00       	mov    $0x0,%eax
  801a96:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801a99:	eb 46                	jmp    801ae1 <strtol+0x94>
		s++;
  801a9b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801a9e:	bf 00 00 00 00       	mov    $0x0,%edi
  801aa3:	eb d5                	jmp    801a7a <strtol+0x2d>
		s++, neg = 1;
  801aa5:	83 c1 01             	add    $0x1,%ecx
  801aa8:	bf 01 00 00 00       	mov    $0x1,%edi
  801aad:	eb cb                	jmp    801a7a <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801aaf:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801ab3:	74 0e                	je     801ac3 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801ab5:	85 db                	test   %ebx,%ebx
  801ab7:	75 d8                	jne    801a91 <strtol+0x44>
		s++, base = 8;
  801ab9:	83 c1 01             	add    $0x1,%ecx
  801abc:	bb 08 00 00 00       	mov    $0x8,%ebx
  801ac1:	eb ce                	jmp    801a91 <strtol+0x44>
		s += 2, base = 16;
  801ac3:	83 c1 02             	add    $0x2,%ecx
  801ac6:	bb 10 00 00 00       	mov    $0x10,%ebx
  801acb:	eb c4                	jmp    801a91 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801acd:	0f be d2             	movsbl %dl,%edx
  801ad0:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801ad3:	3b 55 10             	cmp    0x10(%ebp),%edx
  801ad6:	7d 3a                	jge    801b12 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801ad8:	83 c1 01             	add    $0x1,%ecx
  801adb:	0f af 45 10          	imul   0x10(%ebp),%eax
  801adf:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801ae1:	0f b6 11             	movzbl (%ecx),%edx
  801ae4:	8d 72 d0             	lea    -0x30(%edx),%esi
  801ae7:	89 f3                	mov    %esi,%ebx
  801ae9:	80 fb 09             	cmp    $0x9,%bl
  801aec:	76 df                	jbe    801acd <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801aee:	8d 72 9f             	lea    -0x61(%edx),%esi
  801af1:	89 f3                	mov    %esi,%ebx
  801af3:	80 fb 19             	cmp    $0x19,%bl
  801af6:	77 08                	ja     801b00 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801af8:	0f be d2             	movsbl %dl,%edx
  801afb:	83 ea 57             	sub    $0x57,%edx
  801afe:	eb d3                	jmp    801ad3 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801b00:	8d 72 bf             	lea    -0x41(%edx),%esi
  801b03:	89 f3                	mov    %esi,%ebx
  801b05:	80 fb 19             	cmp    $0x19,%bl
  801b08:	77 08                	ja     801b12 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801b0a:	0f be d2             	movsbl %dl,%edx
  801b0d:	83 ea 37             	sub    $0x37,%edx
  801b10:	eb c1                	jmp    801ad3 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801b12:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b16:	74 05                	je     801b1d <strtol+0xd0>
		*endptr = (char *) s;
  801b18:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b1b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801b1d:	89 c2                	mov    %eax,%edx
  801b1f:	f7 da                	neg    %edx
  801b21:	85 ff                	test   %edi,%edi
  801b23:	0f 45 c2             	cmovne %edx,%eax
}
  801b26:	5b                   	pop    %ebx
  801b27:	5e                   	pop    %esi
  801b28:	5f                   	pop    %edi
  801b29:	5d                   	pop    %ebp
  801b2a:	c3                   	ret    

00801b2b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b2b:	f3 0f 1e fb          	endbr32 
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	56                   	push   %esi
  801b33:	53                   	push   %ebx
  801b34:	8b 75 08             	mov    0x8(%ebp),%esi
  801b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801b3d:	85 c0                	test   %eax,%eax
  801b3f:	74 3d                	je     801b7e <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801b41:	83 ec 0c             	sub    $0xc,%esp
  801b44:	50                   	push   %eax
  801b45:	e8 f4 e7 ff ff       	call   80033e <sys_ipc_recv>
  801b4a:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801b4d:	85 f6                	test   %esi,%esi
  801b4f:	74 0b                	je     801b5c <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b51:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b57:	8b 52 74             	mov    0x74(%edx),%edx
  801b5a:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801b5c:	85 db                	test   %ebx,%ebx
  801b5e:	74 0b                	je     801b6b <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801b60:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b66:	8b 52 78             	mov    0x78(%edx),%edx
  801b69:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	78 21                	js     801b90 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801b6f:	a1 04 40 80 00       	mov    0x804004,%eax
  801b74:	8b 40 70             	mov    0x70(%eax),%eax
}
  801b77:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7a:	5b                   	pop    %ebx
  801b7b:	5e                   	pop    %esi
  801b7c:	5d                   	pop    %ebp
  801b7d:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801b7e:	83 ec 0c             	sub    $0xc,%esp
  801b81:	68 00 00 c0 ee       	push   $0xeec00000
  801b86:	e8 b3 e7 ff ff       	call   80033e <sys_ipc_recv>
  801b8b:	83 c4 10             	add    $0x10,%esp
  801b8e:	eb bd                	jmp    801b4d <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801b90:	85 f6                	test   %esi,%esi
  801b92:	74 10                	je     801ba4 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801b94:	85 db                	test   %ebx,%ebx
  801b96:	75 df                	jne    801b77 <ipc_recv+0x4c>
  801b98:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801b9f:	00 00 00 
  801ba2:	eb d3                	jmp    801b77 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801ba4:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801bab:	00 00 00 
  801bae:	eb e4                	jmp    801b94 <ipc_recv+0x69>

00801bb0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bb0:	f3 0f 1e fb          	endbr32 
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	57                   	push   %edi
  801bb8:	56                   	push   %esi
  801bb9:	53                   	push   %ebx
  801bba:	83 ec 0c             	sub    $0xc,%esp
  801bbd:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bc0:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bc3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801bc6:	85 db                	test   %ebx,%ebx
  801bc8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801bcd:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801bd0:	ff 75 14             	pushl  0x14(%ebp)
  801bd3:	53                   	push   %ebx
  801bd4:	56                   	push   %esi
  801bd5:	57                   	push   %edi
  801bd6:	e8 3c e7 ff ff       	call   800317 <sys_ipc_try_send>
  801bdb:	83 c4 10             	add    $0x10,%esp
  801bde:	85 c0                	test   %eax,%eax
  801be0:	79 1e                	jns    801c00 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801be2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801be5:	75 07                	jne    801bee <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801be7:	e8 63 e5 ff ff       	call   80014f <sys_yield>
  801bec:	eb e2                	jmp    801bd0 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801bee:	50                   	push   %eax
  801bef:	68 3f 23 80 00       	push   $0x80233f
  801bf4:	6a 59                	push   $0x59
  801bf6:	68 5a 23 80 00       	push   $0x80235a
  801bfb:	e8 c8 f4 ff ff       	call   8010c8 <_panic>
	}
}
  801c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c03:	5b                   	pop    %ebx
  801c04:	5e                   	pop    %esi
  801c05:	5f                   	pop    %edi
  801c06:	5d                   	pop    %ebp
  801c07:	c3                   	ret    

00801c08 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c08:	f3 0f 1e fb          	endbr32 
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c12:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c17:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c1a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c20:	8b 52 50             	mov    0x50(%edx),%edx
  801c23:	39 ca                	cmp    %ecx,%edx
  801c25:	74 11                	je     801c38 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801c27:	83 c0 01             	add    $0x1,%eax
  801c2a:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c2f:	75 e6                	jne    801c17 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801c31:	b8 00 00 00 00       	mov    $0x0,%eax
  801c36:	eb 0b                	jmp    801c43 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801c38:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c3b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c40:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c43:	5d                   	pop    %ebp
  801c44:	c3                   	ret    

00801c45 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c45:	f3 0f 1e fb          	endbr32 
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c4f:	89 c2                	mov    %eax,%edx
  801c51:	c1 ea 16             	shr    $0x16,%edx
  801c54:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c5b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c60:	f6 c1 01             	test   $0x1,%cl
  801c63:	74 1c                	je     801c81 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801c65:	c1 e8 0c             	shr    $0xc,%eax
  801c68:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c6f:	a8 01                	test   $0x1,%al
  801c71:	74 0e                	je     801c81 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c73:	c1 e8 0c             	shr    $0xc,%eax
  801c76:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801c7d:	ef 
  801c7e:	0f b7 d2             	movzwl %dx,%edx
}
  801c81:	89 d0                	mov    %edx,%eax
  801c83:	5d                   	pop    %ebp
  801c84:	c3                   	ret    
  801c85:	66 90                	xchg   %ax,%ax
  801c87:	66 90                	xchg   %ax,%ax
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
