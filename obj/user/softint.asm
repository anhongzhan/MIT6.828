
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
  80005b:	a3 08 40 80 00       	mov    %eax,0x804008

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
  80008e:	e8 93 05 00 00       	call   800626 <close_all>
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
  80011b:	68 6a 24 80 00       	push   $0x80246a
  800120:	6a 23                	push   $0x23
  800122:	68 87 24 80 00       	push   $0x802487
  800127:	e8 08 15 00 00       	call   801634 <_panic>

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
  8001a8:	68 6a 24 80 00       	push   $0x80246a
  8001ad:	6a 23                	push   $0x23
  8001af:	68 87 24 80 00       	push   $0x802487
  8001b4:	e8 7b 14 00 00       	call   801634 <_panic>

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
  8001ee:	68 6a 24 80 00       	push   $0x80246a
  8001f3:	6a 23                	push   $0x23
  8001f5:	68 87 24 80 00       	push   $0x802487
  8001fa:	e8 35 14 00 00       	call   801634 <_panic>

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
  800234:	68 6a 24 80 00       	push   $0x80246a
  800239:	6a 23                	push   $0x23
  80023b:	68 87 24 80 00       	push   $0x802487
  800240:	e8 ef 13 00 00       	call   801634 <_panic>

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
  80027a:	68 6a 24 80 00       	push   $0x80246a
  80027f:	6a 23                	push   $0x23
  800281:	68 87 24 80 00       	push   $0x802487
  800286:	e8 a9 13 00 00       	call   801634 <_panic>

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
  8002c0:	68 6a 24 80 00       	push   $0x80246a
  8002c5:	6a 23                	push   $0x23
  8002c7:	68 87 24 80 00       	push   $0x802487
  8002cc:	e8 63 13 00 00       	call   801634 <_panic>

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
  800306:	68 6a 24 80 00       	push   $0x80246a
  80030b:	6a 23                	push   $0x23
  80030d:	68 87 24 80 00       	push   $0x802487
  800312:	e8 1d 13 00 00       	call   801634 <_panic>

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
  800372:	68 6a 24 80 00       	push   $0x80246a
  800377:	6a 23                	push   $0x23
  800379:	68 87 24 80 00       	push   $0x802487
  80037e:	e8 b1 12 00 00       	call   801634 <_panic>

00800383 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800383:	f3 0f 1e fb          	endbr32 
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	57                   	push   %edi
  80038b:	56                   	push   %esi
  80038c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80038d:	ba 00 00 00 00       	mov    $0x0,%edx
  800392:	b8 0e 00 00 00       	mov    $0xe,%eax
  800397:	89 d1                	mov    %edx,%ecx
  800399:	89 d3                	mov    %edx,%ebx
  80039b:	89 d7                	mov    %edx,%edi
  80039d:	89 d6                	mov    %edx,%esi
  80039f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003a1:	5b                   	pop    %ebx
  8003a2:	5e                   	pop    %esi
  8003a3:	5f                   	pop    %edi
  8003a4:	5d                   	pop    %ebp
  8003a5:	c3                   	ret    

008003a6 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  8003a6:	f3 0f 1e fb          	endbr32 
  8003aa:	55                   	push   %ebp
  8003ab:	89 e5                	mov    %esp,%ebp
  8003ad:	57                   	push   %edi
  8003ae:	56                   	push   %esi
  8003af:	53                   	push   %ebx
  8003b0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8003b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8003bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003be:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003c3:	89 df                	mov    %ebx,%edi
  8003c5:	89 de                	mov    %ebx,%esi
  8003c7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8003c9:	85 c0                	test   %eax,%eax
  8003cb:	7f 08                	jg     8003d5 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  8003cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003d0:	5b                   	pop    %ebx
  8003d1:	5e                   	pop    %esi
  8003d2:	5f                   	pop    %edi
  8003d3:	5d                   	pop    %ebp
  8003d4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8003d5:	83 ec 0c             	sub    $0xc,%esp
  8003d8:	50                   	push   %eax
  8003d9:	6a 0f                	push   $0xf
  8003db:	68 6a 24 80 00       	push   $0x80246a
  8003e0:	6a 23                	push   $0x23
  8003e2:	68 87 24 80 00       	push   $0x802487
  8003e7:	e8 48 12 00 00       	call   801634 <_panic>

008003ec <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  8003ec:	f3 0f 1e fb          	endbr32 
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	57                   	push   %edi
  8003f4:	56                   	push   %esi
  8003f5:	53                   	push   %ebx
  8003f6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8003f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003fe:	8b 55 08             	mov    0x8(%ebp),%edx
  800401:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800404:	b8 10 00 00 00       	mov    $0x10,%eax
  800409:	89 df                	mov    %ebx,%edi
  80040b:	89 de                	mov    %ebx,%esi
  80040d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80040f:	85 c0                	test   %eax,%eax
  800411:	7f 08                	jg     80041b <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  800413:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800416:	5b                   	pop    %ebx
  800417:	5e                   	pop    %esi
  800418:	5f                   	pop    %edi
  800419:	5d                   	pop    %ebp
  80041a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80041b:	83 ec 0c             	sub    $0xc,%esp
  80041e:	50                   	push   %eax
  80041f:	6a 10                	push   $0x10
  800421:	68 6a 24 80 00       	push   $0x80246a
  800426:	6a 23                	push   $0x23
  800428:	68 87 24 80 00       	push   $0x802487
  80042d:	e8 02 12 00 00       	call   801634 <_panic>

00800432 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800432:	f3 0f 1e fb          	endbr32 
  800436:	55                   	push   %ebp
  800437:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800439:	8b 45 08             	mov    0x8(%ebp),%eax
  80043c:	05 00 00 00 30       	add    $0x30000000,%eax
  800441:	c1 e8 0c             	shr    $0xc,%eax
}
  800444:	5d                   	pop    %ebp
  800445:	c3                   	ret    

00800446 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800446:	f3 0f 1e fb          	endbr32 
  80044a:	55                   	push   %ebp
  80044b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80044d:	8b 45 08             	mov    0x8(%ebp),%eax
  800450:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800455:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80045a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80045f:	5d                   	pop    %ebp
  800460:	c3                   	ret    

00800461 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800461:	f3 0f 1e fb          	endbr32 
  800465:	55                   	push   %ebp
  800466:	89 e5                	mov    %esp,%ebp
  800468:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80046d:	89 c2                	mov    %eax,%edx
  80046f:	c1 ea 16             	shr    $0x16,%edx
  800472:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800479:	f6 c2 01             	test   $0x1,%dl
  80047c:	74 2d                	je     8004ab <fd_alloc+0x4a>
  80047e:	89 c2                	mov    %eax,%edx
  800480:	c1 ea 0c             	shr    $0xc,%edx
  800483:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80048a:	f6 c2 01             	test   $0x1,%dl
  80048d:	74 1c                	je     8004ab <fd_alloc+0x4a>
  80048f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800494:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800499:	75 d2                	jne    80046d <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80049b:	8b 45 08             	mov    0x8(%ebp),%eax
  80049e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8004a4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8004a9:	eb 0a                	jmp    8004b5 <fd_alloc+0x54>
			*fd_store = fd;
  8004ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004ae:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004b5:	5d                   	pop    %ebp
  8004b6:	c3                   	ret    

008004b7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8004b7:	f3 0f 1e fb          	endbr32 
  8004bb:	55                   	push   %ebp
  8004bc:	89 e5                	mov    %esp,%ebp
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8004c1:	83 f8 1f             	cmp    $0x1f,%eax
  8004c4:	77 30                	ja     8004f6 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8004c6:	c1 e0 0c             	shl    $0xc,%eax
  8004c9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8004ce:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8004d4:	f6 c2 01             	test   $0x1,%dl
  8004d7:	74 24                	je     8004fd <fd_lookup+0x46>
  8004d9:	89 c2                	mov    %eax,%edx
  8004db:	c1 ea 0c             	shr    $0xc,%edx
  8004de:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004e5:	f6 c2 01             	test   $0x1,%dl
  8004e8:	74 1a                	je     800504 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8004ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ed:	89 02                	mov    %eax,(%edx)
	return 0;
  8004ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004f4:	5d                   	pop    %ebp
  8004f5:	c3                   	ret    
		return -E_INVAL;
  8004f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004fb:	eb f7                	jmp    8004f4 <fd_lookup+0x3d>
		return -E_INVAL;
  8004fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800502:	eb f0                	jmp    8004f4 <fd_lookup+0x3d>
  800504:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800509:	eb e9                	jmp    8004f4 <fd_lookup+0x3d>

0080050b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80050b:	f3 0f 1e fb          	endbr32 
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  800512:	83 ec 08             	sub    $0x8,%esp
  800515:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800518:	ba 00 00 00 00       	mov    $0x0,%edx
  80051d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800522:	39 08                	cmp    %ecx,(%eax)
  800524:	74 38                	je     80055e <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800526:	83 c2 01             	add    $0x1,%edx
  800529:	8b 04 95 14 25 80 00 	mov    0x802514(,%edx,4),%eax
  800530:	85 c0                	test   %eax,%eax
  800532:	75 ee                	jne    800522 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800534:	a1 08 40 80 00       	mov    0x804008,%eax
  800539:	8b 40 48             	mov    0x48(%eax),%eax
  80053c:	83 ec 04             	sub    $0x4,%esp
  80053f:	51                   	push   %ecx
  800540:	50                   	push   %eax
  800541:	68 98 24 80 00       	push   $0x802498
  800546:	e8 d0 11 00 00       	call   80171b <cprintf>
	*dev = 0;
  80054b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800554:	83 c4 10             	add    $0x10,%esp
  800557:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    
			*dev = devtab[i];
  80055e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800561:	89 01                	mov    %eax,(%ecx)
			return 0;
  800563:	b8 00 00 00 00       	mov    $0x0,%eax
  800568:	eb f2                	jmp    80055c <dev_lookup+0x51>

0080056a <fd_close>:
{
  80056a:	f3 0f 1e fb          	endbr32 
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
  800571:	57                   	push   %edi
  800572:	56                   	push   %esi
  800573:	53                   	push   %ebx
  800574:	83 ec 24             	sub    $0x24,%esp
  800577:	8b 75 08             	mov    0x8(%ebp),%esi
  80057a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80057d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800580:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800581:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800587:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80058a:	50                   	push   %eax
  80058b:	e8 27 ff ff ff       	call   8004b7 <fd_lookup>
  800590:	89 c3                	mov    %eax,%ebx
  800592:	83 c4 10             	add    $0x10,%esp
  800595:	85 c0                	test   %eax,%eax
  800597:	78 05                	js     80059e <fd_close+0x34>
	    || fd != fd2)
  800599:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80059c:	74 16                	je     8005b4 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80059e:	89 f8                	mov    %edi,%eax
  8005a0:	84 c0                	test   %al,%al
  8005a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a7:	0f 44 d8             	cmove  %eax,%ebx
}
  8005aa:	89 d8                	mov    %ebx,%eax
  8005ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005af:	5b                   	pop    %ebx
  8005b0:	5e                   	pop    %esi
  8005b1:	5f                   	pop    %edi
  8005b2:	5d                   	pop    %ebp
  8005b3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8005b4:	83 ec 08             	sub    $0x8,%esp
  8005b7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8005ba:	50                   	push   %eax
  8005bb:	ff 36                	pushl  (%esi)
  8005bd:	e8 49 ff ff ff       	call   80050b <dev_lookup>
  8005c2:	89 c3                	mov    %eax,%ebx
  8005c4:	83 c4 10             	add    $0x10,%esp
  8005c7:	85 c0                	test   %eax,%eax
  8005c9:	78 1a                	js     8005e5 <fd_close+0x7b>
		if (dev->dev_close)
  8005cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005ce:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8005d1:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8005d6:	85 c0                	test   %eax,%eax
  8005d8:	74 0b                	je     8005e5 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8005da:	83 ec 0c             	sub    $0xc,%esp
  8005dd:	56                   	push   %esi
  8005de:	ff d0                	call   *%eax
  8005e0:	89 c3                	mov    %eax,%ebx
  8005e2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8005e5:	83 ec 08             	sub    $0x8,%esp
  8005e8:	56                   	push   %esi
  8005e9:	6a 00                	push   $0x0
  8005eb:	e8 0f fc ff ff       	call   8001ff <sys_page_unmap>
	return r;
  8005f0:	83 c4 10             	add    $0x10,%esp
  8005f3:	eb b5                	jmp    8005aa <fd_close+0x40>

008005f5 <close>:

int
close(int fdnum)
{
  8005f5:	f3 0f 1e fb          	endbr32 
  8005f9:	55                   	push   %ebp
  8005fa:	89 e5                	mov    %esp,%ebp
  8005fc:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8005ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800602:	50                   	push   %eax
  800603:	ff 75 08             	pushl  0x8(%ebp)
  800606:	e8 ac fe ff ff       	call   8004b7 <fd_lookup>
  80060b:	83 c4 10             	add    $0x10,%esp
  80060e:	85 c0                	test   %eax,%eax
  800610:	79 02                	jns    800614 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800612:	c9                   	leave  
  800613:	c3                   	ret    
		return fd_close(fd, 1);
  800614:	83 ec 08             	sub    $0x8,%esp
  800617:	6a 01                	push   $0x1
  800619:	ff 75 f4             	pushl  -0xc(%ebp)
  80061c:	e8 49 ff ff ff       	call   80056a <fd_close>
  800621:	83 c4 10             	add    $0x10,%esp
  800624:	eb ec                	jmp    800612 <close+0x1d>

00800626 <close_all>:

void
close_all(void)
{
  800626:	f3 0f 1e fb          	endbr32 
  80062a:	55                   	push   %ebp
  80062b:	89 e5                	mov    %esp,%ebp
  80062d:	53                   	push   %ebx
  80062e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800631:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800636:	83 ec 0c             	sub    $0xc,%esp
  800639:	53                   	push   %ebx
  80063a:	e8 b6 ff ff ff       	call   8005f5 <close>
	for (i = 0; i < MAXFD; i++)
  80063f:	83 c3 01             	add    $0x1,%ebx
  800642:	83 c4 10             	add    $0x10,%esp
  800645:	83 fb 20             	cmp    $0x20,%ebx
  800648:	75 ec                	jne    800636 <close_all+0x10>
}
  80064a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80064d:	c9                   	leave  
  80064e:	c3                   	ret    

0080064f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80064f:	f3 0f 1e fb          	endbr32 
  800653:	55                   	push   %ebp
  800654:	89 e5                	mov    %esp,%ebp
  800656:	57                   	push   %edi
  800657:	56                   	push   %esi
  800658:	53                   	push   %ebx
  800659:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80065c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80065f:	50                   	push   %eax
  800660:	ff 75 08             	pushl  0x8(%ebp)
  800663:	e8 4f fe ff ff       	call   8004b7 <fd_lookup>
  800668:	89 c3                	mov    %eax,%ebx
  80066a:	83 c4 10             	add    $0x10,%esp
  80066d:	85 c0                	test   %eax,%eax
  80066f:	0f 88 81 00 00 00    	js     8006f6 <dup+0xa7>
		return r;
	close(newfdnum);
  800675:	83 ec 0c             	sub    $0xc,%esp
  800678:	ff 75 0c             	pushl  0xc(%ebp)
  80067b:	e8 75 ff ff ff       	call   8005f5 <close>

	newfd = INDEX2FD(newfdnum);
  800680:	8b 75 0c             	mov    0xc(%ebp),%esi
  800683:	c1 e6 0c             	shl    $0xc,%esi
  800686:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80068c:	83 c4 04             	add    $0x4,%esp
  80068f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800692:	e8 af fd ff ff       	call   800446 <fd2data>
  800697:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800699:	89 34 24             	mov    %esi,(%esp)
  80069c:	e8 a5 fd ff ff       	call   800446 <fd2data>
  8006a1:	83 c4 10             	add    $0x10,%esp
  8006a4:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8006a6:	89 d8                	mov    %ebx,%eax
  8006a8:	c1 e8 16             	shr    $0x16,%eax
  8006ab:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8006b2:	a8 01                	test   $0x1,%al
  8006b4:	74 11                	je     8006c7 <dup+0x78>
  8006b6:	89 d8                	mov    %ebx,%eax
  8006b8:	c1 e8 0c             	shr    $0xc,%eax
  8006bb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8006c2:	f6 c2 01             	test   $0x1,%dl
  8006c5:	75 39                	jne    800700 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8006c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006ca:	89 d0                	mov    %edx,%eax
  8006cc:	c1 e8 0c             	shr    $0xc,%eax
  8006cf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006d6:	83 ec 0c             	sub    $0xc,%esp
  8006d9:	25 07 0e 00 00       	and    $0xe07,%eax
  8006de:	50                   	push   %eax
  8006df:	56                   	push   %esi
  8006e0:	6a 00                	push   $0x0
  8006e2:	52                   	push   %edx
  8006e3:	6a 00                	push   $0x0
  8006e5:	e8 cf fa ff ff       	call   8001b9 <sys_page_map>
  8006ea:	89 c3                	mov    %eax,%ebx
  8006ec:	83 c4 20             	add    $0x20,%esp
  8006ef:	85 c0                	test   %eax,%eax
  8006f1:	78 31                	js     800724 <dup+0xd5>
		goto err;

	return newfdnum;
  8006f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8006f6:	89 d8                	mov    %ebx,%eax
  8006f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006fb:	5b                   	pop    %ebx
  8006fc:	5e                   	pop    %esi
  8006fd:	5f                   	pop    %edi
  8006fe:	5d                   	pop    %ebp
  8006ff:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800700:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800707:	83 ec 0c             	sub    $0xc,%esp
  80070a:	25 07 0e 00 00       	and    $0xe07,%eax
  80070f:	50                   	push   %eax
  800710:	57                   	push   %edi
  800711:	6a 00                	push   $0x0
  800713:	53                   	push   %ebx
  800714:	6a 00                	push   $0x0
  800716:	e8 9e fa ff ff       	call   8001b9 <sys_page_map>
  80071b:	89 c3                	mov    %eax,%ebx
  80071d:	83 c4 20             	add    $0x20,%esp
  800720:	85 c0                	test   %eax,%eax
  800722:	79 a3                	jns    8006c7 <dup+0x78>
	sys_page_unmap(0, newfd);
  800724:	83 ec 08             	sub    $0x8,%esp
  800727:	56                   	push   %esi
  800728:	6a 00                	push   $0x0
  80072a:	e8 d0 fa ff ff       	call   8001ff <sys_page_unmap>
	sys_page_unmap(0, nva);
  80072f:	83 c4 08             	add    $0x8,%esp
  800732:	57                   	push   %edi
  800733:	6a 00                	push   $0x0
  800735:	e8 c5 fa ff ff       	call   8001ff <sys_page_unmap>
	return r;
  80073a:	83 c4 10             	add    $0x10,%esp
  80073d:	eb b7                	jmp    8006f6 <dup+0xa7>

0080073f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80073f:	f3 0f 1e fb          	endbr32 
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	53                   	push   %ebx
  800747:	83 ec 1c             	sub    $0x1c,%esp
  80074a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80074d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800750:	50                   	push   %eax
  800751:	53                   	push   %ebx
  800752:	e8 60 fd ff ff       	call   8004b7 <fd_lookup>
  800757:	83 c4 10             	add    $0x10,%esp
  80075a:	85 c0                	test   %eax,%eax
  80075c:	78 3f                	js     80079d <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800764:	50                   	push   %eax
  800765:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800768:	ff 30                	pushl  (%eax)
  80076a:	e8 9c fd ff ff       	call   80050b <dev_lookup>
  80076f:	83 c4 10             	add    $0x10,%esp
  800772:	85 c0                	test   %eax,%eax
  800774:	78 27                	js     80079d <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800776:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800779:	8b 42 08             	mov    0x8(%edx),%eax
  80077c:	83 e0 03             	and    $0x3,%eax
  80077f:	83 f8 01             	cmp    $0x1,%eax
  800782:	74 1e                	je     8007a2 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800787:	8b 40 08             	mov    0x8(%eax),%eax
  80078a:	85 c0                	test   %eax,%eax
  80078c:	74 35                	je     8007c3 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80078e:	83 ec 04             	sub    $0x4,%esp
  800791:	ff 75 10             	pushl  0x10(%ebp)
  800794:	ff 75 0c             	pushl  0xc(%ebp)
  800797:	52                   	push   %edx
  800798:	ff d0                	call   *%eax
  80079a:	83 c4 10             	add    $0x10,%esp
}
  80079d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007a0:	c9                   	leave  
  8007a1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8007a2:	a1 08 40 80 00       	mov    0x804008,%eax
  8007a7:	8b 40 48             	mov    0x48(%eax),%eax
  8007aa:	83 ec 04             	sub    $0x4,%esp
  8007ad:	53                   	push   %ebx
  8007ae:	50                   	push   %eax
  8007af:	68 d9 24 80 00       	push   $0x8024d9
  8007b4:	e8 62 0f 00 00       	call   80171b <cprintf>
		return -E_INVAL;
  8007b9:	83 c4 10             	add    $0x10,%esp
  8007bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007c1:	eb da                	jmp    80079d <read+0x5e>
		return -E_NOT_SUPP;
  8007c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007c8:	eb d3                	jmp    80079d <read+0x5e>

008007ca <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8007ca:	f3 0f 1e fb          	endbr32 
  8007ce:	55                   	push   %ebp
  8007cf:	89 e5                	mov    %esp,%ebp
  8007d1:	57                   	push   %edi
  8007d2:	56                   	push   %esi
  8007d3:	53                   	push   %ebx
  8007d4:	83 ec 0c             	sub    $0xc,%esp
  8007d7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8007da:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8007dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007e2:	eb 02                	jmp    8007e6 <readn+0x1c>
  8007e4:	01 c3                	add    %eax,%ebx
  8007e6:	39 f3                	cmp    %esi,%ebx
  8007e8:	73 21                	jae    80080b <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8007ea:	83 ec 04             	sub    $0x4,%esp
  8007ed:	89 f0                	mov    %esi,%eax
  8007ef:	29 d8                	sub    %ebx,%eax
  8007f1:	50                   	push   %eax
  8007f2:	89 d8                	mov    %ebx,%eax
  8007f4:	03 45 0c             	add    0xc(%ebp),%eax
  8007f7:	50                   	push   %eax
  8007f8:	57                   	push   %edi
  8007f9:	e8 41 ff ff ff       	call   80073f <read>
		if (m < 0)
  8007fe:	83 c4 10             	add    $0x10,%esp
  800801:	85 c0                	test   %eax,%eax
  800803:	78 04                	js     800809 <readn+0x3f>
			return m;
		if (m == 0)
  800805:	75 dd                	jne    8007e4 <readn+0x1a>
  800807:	eb 02                	jmp    80080b <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800809:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80080b:	89 d8                	mov    %ebx,%eax
  80080d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800810:	5b                   	pop    %ebx
  800811:	5e                   	pop    %esi
  800812:	5f                   	pop    %edi
  800813:	5d                   	pop    %ebp
  800814:	c3                   	ret    

00800815 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800815:	f3 0f 1e fb          	endbr32 
  800819:	55                   	push   %ebp
  80081a:	89 e5                	mov    %esp,%ebp
  80081c:	53                   	push   %ebx
  80081d:	83 ec 1c             	sub    $0x1c,%esp
  800820:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800823:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800826:	50                   	push   %eax
  800827:	53                   	push   %ebx
  800828:	e8 8a fc ff ff       	call   8004b7 <fd_lookup>
  80082d:	83 c4 10             	add    $0x10,%esp
  800830:	85 c0                	test   %eax,%eax
  800832:	78 3a                	js     80086e <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800834:	83 ec 08             	sub    $0x8,%esp
  800837:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80083a:	50                   	push   %eax
  80083b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80083e:	ff 30                	pushl  (%eax)
  800840:	e8 c6 fc ff ff       	call   80050b <dev_lookup>
  800845:	83 c4 10             	add    $0x10,%esp
  800848:	85 c0                	test   %eax,%eax
  80084a:	78 22                	js     80086e <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80084c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800853:	74 1e                	je     800873 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800855:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800858:	8b 52 0c             	mov    0xc(%edx),%edx
  80085b:	85 d2                	test   %edx,%edx
  80085d:	74 35                	je     800894 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80085f:	83 ec 04             	sub    $0x4,%esp
  800862:	ff 75 10             	pushl  0x10(%ebp)
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	50                   	push   %eax
  800869:	ff d2                	call   *%edx
  80086b:	83 c4 10             	add    $0x10,%esp
}
  80086e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800871:	c9                   	leave  
  800872:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800873:	a1 08 40 80 00       	mov    0x804008,%eax
  800878:	8b 40 48             	mov    0x48(%eax),%eax
  80087b:	83 ec 04             	sub    $0x4,%esp
  80087e:	53                   	push   %ebx
  80087f:	50                   	push   %eax
  800880:	68 f5 24 80 00       	push   $0x8024f5
  800885:	e8 91 0e 00 00       	call   80171b <cprintf>
		return -E_INVAL;
  80088a:	83 c4 10             	add    $0x10,%esp
  80088d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800892:	eb da                	jmp    80086e <write+0x59>
		return -E_NOT_SUPP;
  800894:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800899:	eb d3                	jmp    80086e <write+0x59>

0080089b <seek>:

int
seek(int fdnum, off_t offset)
{
  80089b:	f3 0f 1e fb          	endbr32 
  80089f:	55                   	push   %ebp
  8008a0:	89 e5                	mov    %esp,%ebp
  8008a2:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8008a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008a8:	50                   	push   %eax
  8008a9:	ff 75 08             	pushl  0x8(%ebp)
  8008ac:	e8 06 fc ff ff       	call   8004b7 <fd_lookup>
  8008b1:	83 c4 10             	add    $0x10,%esp
  8008b4:	85 c0                	test   %eax,%eax
  8008b6:	78 0e                	js     8008c6 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8008b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008be:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8008c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008c6:	c9                   	leave  
  8008c7:	c3                   	ret    

008008c8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8008c8:	f3 0f 1e fb          	endbr32 
  8008cc:	55                   	push   %ebp
  8008cd:	89 e5                	mov    %esp,%ebp
  8008cf:	53                   	push   %ebx
  8008d0:	83 ec 1c             	sub    $0x1c,%esp
  8008d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008d9:	50                   	push   %eax
  8008da:	53                   	push   %ebx
  8008db:	e8 d7 fb ff ff       	call   8004b7 <fd_lookup>
  8008e0:	83 c4 10             	add    $0x10,%esp
  8008e3:	85 c0                	test   %eax,%eax
  8008e5:	78 37                	js     80091e <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008ed:	50                   	push   %eax
  8008ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f1:	ff 30                	pushl  (%eax)
  8008f3:	e8 13 fc ff ff       	call   80050b <dev_lookup>
  8008f8:	83 c4 10             	add    $0x10,%esp
  8008fb:	85 c0                	test   %eax,%eax
  8008fd:	78 1f                	js     80091e <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8008ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800902:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800906:	74 1b                	je     800923 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800908:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80090b:	8b 52 18             	mov    0x18(%edx),%edx
  80090e:	85 d2                	test   %edx,%edx
  800910:	74 32                	je     800944 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800912:	83 ec 08             	sub    $0x8,%esp
  800915:	ff 75 0c             	pushl  0xc(%ebp)
  800918:	50                   	push   %eax
  800919:	ff d2                	call   *%edx
  80091b:	83 c4 10             	add    $0x10,%esp
}
  80091e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800921:	c9                   	leave  
  800922:	c3                   	ret    
			thisenv->env_id, fdnum);
  800923:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800928:	8b 40 48             	mov    0x48(%eax),%eax
  80092b:	83 ec 04             	sub    $0x4,%esp
  80092e:	53                   	push   %ebx
  80092f:	50                   	push   %eax
  800930:	68 b8 24 80 00       	push   $0x8024b8
  800935:	e8 e1 0d 00 00       	call   80171b <cprintf>
		return -E_INVAL;
  80093a:	83 c4 10             	add    $0x10,%esp
  80093d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800942:	eb da                	jmp    80091e <ftruncate+0x56>
		return -E_NOT_SUPP;
  800944:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800949:	eb d3                	jmp    80091e <ftruncate+0x56>

0080094b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80094b:	f3 0f 1e fb          	endbr32 
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	53                   	push   %ebx
  800953:	83 ec 1c             	sub    $0x1c,%esp
  800956:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800959:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80095c:	50                   	push   %eax
  80095d:	ff 75 08             	pushl  0x8(%ebp)
  800960:	e8 52 fb ff ff       	call   8004b7 <fd_lookup>
  800965:	83 c4 10             	add    $0x10,%esp
  800968:	85 c0                	test   %eax,%eax
  80096a:	78 4b                	js     8009b7 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800972:	50                   	push   %eax
  800973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800976:	ff 30                	pushl  (%eax)
  800978:	e8 8e fb ff ff       	call   80050b <dev_lookup>
  80097d:	83 c4 10             	add    $0x10,%esp
  800980:	85 c0                	test   %eax,%eax
  800982:	78 33                	js     8009b7 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  800984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800987:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80098b:	74 2f                	je     8009bc <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80098d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800990:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800997:	00 00 00 
	stat->st_isdir = 0;
  80099a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8009a1:	00 00 00 
	stat->st_dev = dev;
  8009a4:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8009aa:	83 ec 08             	sub    $0x8,%esp
  8009ad:	53                   	push   %ebx
  8009ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8009b1:	ff 50 14             	call   *0x14(%eax)
  8009b4:	83 c4 10             	add    $0x10,%esp
}
  8009b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ba:	c9                   	leave  
  8009bb:	c3                   	ret    
		return -E_NOT_SUPP;
  8009bc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8009c1:	eb f4                	jmp    8009b7 <fstat+0x6c>

008009c3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8009c3:	f3 0f 1e fb          	endbr32 
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	56                   	push   %esi
  8009cb:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8009cc:	83 ec 08             	sub    $0x8,%esp
  8009cf:	6a 00                	push   $0x0
  8009d1:	ff 75 08             	pushl  0x8(%ebp)
  8009d4:	e8 fb 01 00 00       	call   800bd4 <open>
  8009d9:	89 c3                	mov    %eax,%ebx
  8009db:	83 c4 10             	add    $0x10,%esp
  8009de:	85 c0                	test   %eax,%eax
  8009e0:	78 1b                	js     8009fd <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8009e2:	83 ec 08             	sub    $0x8,%esp
  8009e5:	ff 75 0c             	pushl  0xc(%ebp)
  8009e8:	50                   	push   %eax
  8009e9:	e8 5d ff ff ff       	call   80094b <fstat>
  8009ee:	89 c6                	mov    %eax,%esi
	close(fd);
  8009f0:	89 1c 24             	mov    %ebx,(%esp)
  8009f3:	e8 fd fb ff ff       	call   8005f5 <close>
	return r;
  8009f8:	83 c4 10             	add    $0x10,%esp
  8009fb:	89 f3                	mov    %esi,%ebx
}
  8009fd:	89 d8                	mov    %ebx,%eax
  8009ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a02:	5b                   	pop    %ebx
  800a03:	5e                   	pop    %esi
  800a04:	5d                   	pop    %ebp
  800a05:	c3                   	ret    

00800a06 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	56                   	push   %esi
  800a0a:	53                   	push   %ebx
  800a0b:	89 c6                	mov    %eax,%esi
  800a0d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800a0f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800a16:	74 27                	je     800a3f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800a18:	6a 07                	push   $0x7
  800a1a:	68 00 50 80 00       	push   $0x805000
  800a1f:	56                   	push   %esi
  800a20:	ff 35 00 40 80 00    	pushl  0x804000
  800a26:	e8 f1 16 00 00       	call   80211c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800a2b:	83 c4 0c             	add    $0xc,%esp
  800a2e:	6a 00                	push   $0x0
  800a30:	53                   	push   %ebx
  800a31:	6a 00                	push   $0x0
  800a33:	e8 5f 16 00 00       	call   802097 <ipc_recv>
}
  800a38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a3b:	5b                   	pop    %ebx
  800a3c:	5e                   	pop    %esi
  800a3d:	5d                   	pop    %ebp
  800a3e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800a3f:	83 ec 0c             	sub    $0xc,%esp
  800a42:	6a 01                	push   $0x1
  800a44:	e8 2b 17 00 00       	call   802174 <ipc_find_env>
  800a49:	a3 00 40 80 00       	mov    %eax,0x804000
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	eb c5                	jmp    800a18 <fsipc+0x12>

00800a53 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800a53:	f3 0f 1e fb          	endbr32 
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	8b 40 0c             	mov    0xc(%eax),%eax
  800a63:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800a68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800a70:	ba 00 00 00 00       	mov    $0x0,%edx
  800a75:	b8 02 00 00 00       	mov    $0x2,%eax
  800a7a:	e8 87 ff ff ff       	call   800a06 <fsipc>
}
  800a7f:	c9                   	leave  
  800a80:	c3                   	ret    

00800a81 <devfile_flush>:
{
  800a81:	f3 0f 1e fb          	endbr32 
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	8b 40 0c             	mov    0xc(%eax),%eax
  800a91:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a96:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9b:	b8 06 00 00 00       	mov    $0x6,%eax
  800aa0:	e8 61 ff ff ff       	call   800a06 <fsipc>
}
  800aa5:	c9                   	leave  
  800aa6:	c3                   	ret    

00800aa7 <devfile_stat>:
{
  800aa7:	f3 0f 1e fb          	endbr32 
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	53                   	push   %ebx
  800aaf:	83 ec 04             	sub    $0x4,%esp
  800ab2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab8:	8b 40 0c             	mov    0xc(%eax),%eax
  800abb:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800ac0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac5:	b8 05 00 00 00       	mov    $0x5,%eax
  800aca:	e8 37 ff ff ff       	call   800a06 <fsipc>
  800acf:	85 c0                	test   %eax,%eax
  800ad1:	78 2c                	js     800aff <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	68 00 50 80 00       	push   $0x805000
  800adb:	53                   	push   %ebx
  800adc:	e8 44 12 00 00       	call   801d25 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800ae1:	a1 80 50 80 00       	mov    0x805080,%eax
  800ae6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800aec:	a1 84 50 80 00       	mov    0x805084,%eax
  800af1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800af7:	83 c4 10             	add    $0x10,%esp
  800afa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b02:	c9                   	leave  
  800b03:	c3                   	ret    

00800b04 <devfile_write>:
{
  800b04:	f3 0f 1e fb          	endbr32 
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	83 ec 0c             	sub    $0xc,%esp
  800b0e:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800b11:	8b 55 08             	mov    0x8(%ebp),%edx
  800b14:	8b 52 0c             	mov    0xc(%edx),%edx
  800b17:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  800b1d:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800b22:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800b27:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  800b2a:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800b2f:	50                   	push   %eax
  800b30:	ff 75 0c             	pushl  0xc(%ebp)
  800b33:	68 08 50 80 00       	push   $0x805008
  800b38:	e8 9e 13 00 00       	call   801edb <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800b3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b42:	b8 04 00 00 00       	mov    $0x4,%eax
  800b47:	e8 ba fe ff ff       	call   800a06 <fsipc>
}
  800b4c:	c9                   	leave  
  800b4d:	c3                   	ret    

00800b4e <devfile_read>:
{
  800b4e:	f3 0f 1e fb          	endbr32 
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	56                   	push   %esi
  800b56:	53                   	push   %ebx
  800b57:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	8b 40 0c             	mov    0xc(%eax),%eax
  800b60:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b65:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b70:	b8 03 00 00 00       	mov    $0x3,%eax
  800b75:	e8 8c fe ff ff       	call   800a06 <fsipc>
  800b7a:	89 c3                	mov    %eax,%ebx
  800b7c:	85 c0                	test   %eax,%eax
  800b7e:	78 1f                	js     800b9f <devfile_read+0x51>
	assert(r <= n);
  800b80:	39 f0                	cmp    %esi,%eax
  800b82:	77 24                	ja     800ba8 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800b84:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b89:	7f 33                	jg     800bbe <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b8b:	83 ec 04             	sub    $0x4,%esp
  800b8e:	50                   	push   %eax
  800b8f:	68 00 50 80 00       	push   $0x805000
  800b94:	ff 75 0c             	pushl  0xc(%ebp)
  800b97:	e8 3f 13 00 00       	call   801edb <memmove>
	return r;
  800b9c:	83 c4 10             	add    $0x10,%esp
}
  800b9f:	89 d8                	mov    %ebx,%eax
  800ba1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ba4:	5b                   	pop    %ebx
  800ba5:	5e                   	pop    %esi
  800ba6:	5d                   	pop    %ebp
  800ba7:	c3                   	ret    
	assert(r <= n);
  800ba8:	68 28 25 80 00       	push   $0x802528
  800bad:	68 2f 25 80 00       	push   $0x80252f
  800bb2:	6a 7c                	push   $0x7c
  800bb4:	68 44 25 80 00       	push   $0x802544
  800bb9:	e8 76 0a 00 00       	call   801634 <_panic>
	assert(r <= PGSIZE);
  800bbe:	68 4f 25 80 00       	push   $0x80254f
  800bc3:	68 2f 25 80 00       	push   $0x80252f
  800bc8:	6a 7d                	push   $0x7d
  800bca:	68 44 25 80 00       	push   $0x802544
  800bcf:	e8 60 0a 00 00       	call   801634 <_panic>

00800bd4 <open>:
{
  800bd4:	f3 0f 1e fb          	endbr32 
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	56                   	push   %esi
  800bdc:	53                   	push   %ebx
  800bdd:	83 ec 1c             	sub    $0x1c,%esp
  800be0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800be3:	56                   	push   %esi
  800be4:	e8 f9 10 00 00       	call   801ce2 <strlen>
  800be9:	83 c4 10             	add    $0x10,%esp
  800bec:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800bf1:	7f 6c                	jg     800c5f <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800bf3:	83 ec 0c             	sub    $0xc,%esp
  800bf6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bf9:	50                   	push   %eax
  800bfa:	e8 62 f8 ff ff       	call   800461 <fd_alloc>
  800bff:	89 c3                	mov    %eax,%ebx
  800c01:	83 c4 10             	add    $0x10,%esp
  800c04:	85 c0                	test   %eax,%eax
  800c06:	78 3c                	js     800c44 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800c08:	83 ec 08             	sub    $0x8,%esp
  800c0b:	56                   	push   %esi
  800c0c:	68 00 50 80 00       	push   $0x805000
  800c11:	e8 0f 11 00 00       	call   801d25 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800c16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c19:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800c1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c21:	b8 01 00 00 00       	mov    $0x1,%eax
  800c26:	e8 db fd ff ff       	call   800a06 <fsipc>
  800c2b:	89 c3                	mov    %eax,%ebx
  800c2d:	83 c4 10             	add    $0x10,%esp
  800c30:	85 c0                	test   %eax,%eax
  800c32:	78 19                	js     800c4d <open+0x79>
	return fd2num(fd);
  800c34:	83 ec 0c             	sub    $0xc,%esp
  800c37:	ff 75 f4             	pushl  -0xc(%ebp)
  800c3a:	e8 f3 f7 ff ff       	call   800432 <fd2num>
  800c3f:	89 c3                	mov    %eax,%ebx
  800c41:	83 c4 10             	add    $0x10,%esp
}
  800c44:	89 d8                	mov    %ebx,%eax
  800c46:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c49:	5b                   	pop    %ebx
  800c4a:	5e                   	pop    %esi
  800c4b:	5d                   	pop    %ebp
  800c4c:	c3                   	ret    
		fd_close(fd, 0);
  800c4d:	83 ec 08             	sub    $0x8,%esp
  800c50:	6a 00                	push   $0x0
  800c52:	ff 75 f4             	pushl  -0xc(%ebp)
  800c55:	e8 10 f9 ff ff       	call   80056a <fd_close>
		return r;
  800c5a:	83 c4 10             	add    $0x10,%esp
  800c5d:	eb e5                	jmp    800c44 <open+0x70>
		return -E_BAD_PATH;
  800c5f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800c64:	eb de                	jmp    800c44 <open+0x70>

00800c66 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800c66:	f3 0f 1e fb          	endbr32 
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c70:	ba 00 00 00 00       	mov    $0x0,%edx
  800c75:	b8 08 00 00 00       	mov    $0x8,%eax
  800c7a:	e8 87 fd ff ff       	call   800a06 <fsipc>
}
  800c7f:	c9                   	leave  
  800c80:	c3                   	ret    

00800c81 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800c81:	f3 0f 1e fb          	endbr32 
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800c8b:	68 5b 25 80 00       	push   $0x80255b
  800c90:	ff 75 0c             	pushl  0xc(%ebp)
  800c93:	e8 8d 10 00 00       	call   801d25 <strcpy>
	return 0;
}
  800c98:	b8 00 00 00 00       	mov    $0x0,%eax
  800c9d:	c9                   	leave  
  800c9e:	c3                   	ret    

00800c9f <devsock_close>:
{
  800c9f:	f3 0f 1e fb          	endbr32 
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	53                   	push   %ebx
  800ca7:	83 ec 10             	sub    $0x10,%esp
  800caa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800cad:	53                   	push   %ebx
  800cae:	e8 fe 14 00 00       	call   8021b1 <pageref>
  800cb3:	89 c2                	mov    %eax,%edx
  800cb5:	83 c4 10             	add    $0x10,%esp
		return 0;
  800cb8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  800cbd:	83 fa 01             	cmp    $0x1,%edx
  800cc0:	74 05                	je     800cc7 <devsock_close+0x28>
}
  800cc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cc5:	c9                   	leave  
  800cc6:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800cc7:	83 ec 0c             	sub    $0xc,%esp
  800cca:	ff 73 0c             	pushl  0xc(%ebx)
  800ccd:	e8 e3 02 00 00       	call   800fb5 <nsipc_close>
  800cd2:	83 c4 10             	add    $0x10,%esp
  800cd5:	eb eb                	jmp    800cc2 <devsock_close+0x23>

00800cd7 <devsock_write>:
{
  800cd7:	f3 0f 1e fb          	endbr32 
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800ce1:	6a 00                	push   $0x0
  800ce3:	ff 75 10             	pushl  0x10(%ebp)
  800ce6:	ff 75 0c             	pushl  0xc(%ebp)
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	ff 70 0c             	pushl  0xc(%eax)
  800cef:	e8 b5 03 00 00       	call   8010a9 <nsipc_send>
}
  800cf4:	c9                   	leave  
  800cf5:	c3                   	ret    

00800cf6 <devsock_read>:
{
  800cf6:	f3 0f 1e fb          	endbr32 
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800d00:	6a 00                	push   $0x0
  800d02:	ff 75 10             	pushl  0x10(%ebp)
  800d05:	ff 75 0c             	pushl  0xc(%ebp)
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	ff 70 0c             	pushl  0xc(%eax)
  800d0e:	e8 1f 03 00 00       	call   801032 <nsipc_recv>
}
  800d13:	c9                   	leave  
  800d14:	c3                   	ret    

00800d15 <fd2sockid>:
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800d1b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800d1e:	52                   	push   %edx
  800d1f:	50                   	push   %eax
  800d20:	e8 92 f7 ff ff       	call   8004b7 <fd_lookup>
  800d25:	83 c4 10             	add    $0x10,%esp
  800d28:	85 c0                	test   %eax,%eax
  800d2a:	78 10                	js     800d3c <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d2f:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800d35:	39 08                	cmp    %ecx,(%eax)
  800d37:	75 05                	jne    800d3e <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800d39:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800d3c:	c9                   	leave  
  800d3d:	c3                   	ret    
		return -E_NOT_SUPP;
  800d3e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800d43:	eb f7                	jmp    800d3c <fd2sockid+0x27>

00800d45 <alloc_sockfd>:
{
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
  800d4a:	83 ec 1c             	sub    $0x1c,%esp
  800d4d:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800d4f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d52:	50                   	push   %eax
  800d53:	e8 09 f7 ff ff       	call   800461 <fd_alloc>
  800d58:	89 c3                	mov    %eax,%ebx
  800d5a:	83 c4 10             	add    $0x10,%esp
  800d5d:	85 c0                	test   %eax,%eax
  800d5f:	78 43                	js     800da4 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800d61:	83 ec 04             	sub    $0x4,%esp
  800d64:	68 07 04 00 00       	push   $0x407
  800d69:	ff 75 f4             	pushl  -0xc(%ebp)
  800d6c:	6a 00                	push   $0x0
  800d6e:	e8 ff f3 ff ff       	call   800172 <sys_page_alloc>
  800d73:	89 c3                	mov    %eax,%ebx
  800d75:	83 c4 10             	add    $0x10,%esp
  800d78:	85 c0                	test   %eax,%eax
  800d7a:	78 28                	js     800da4 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d7f:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800d85:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d8a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800d91:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800d94:	83 ec 0c             	sub    $0xc,%esp
  800d97:	50                   	push   %eax
  800d98:	e8 95 f6 ff ff       	call   800432 <fd2num>
  800d9d:	89 c3                	mov    %eax,%ebx
  800d9f:	83 c4 10             	add    $0x10,%esp
  800da2:	eb 0c                	jmp    800db0 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800da4:	83 ec 0c             	sub    $0xc,%esp
  800da7:	56                   	push   %esi
  800da8:	e8 08 02 00 00       	call   800fb5 <nsipc_close>
		return r;
  800dad:	83 c4 10             	add    $0x10,%esp
}
  800db0:	89 d8                	mov    %ebx,%eax
  800db2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800db5:	5b                   	pop    %ebx
  800db6:	5e                   	pop    %esi
  800db7:	5d                   	pop    %ebp
  800db8:	c3                   	ret    

00800db9 <accept>:
{
  800db9:	f3 0f 1e fb          	endbr32 
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	e8 4a ff ff ff       	call   800d15 <fd2sockid>
  800dcb:	85 c0                	test   %eax,%eax
  800dcd:	78 1b                	js     800dea <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800dcf:	83 ec 04             	sub    $0x4,%esp
  800dd2:	ff 75 10             	pushl  0x10(%ebp)
  800dd5:	ff 75 0c             	pushl  0xc(%ebp)
  800dd8:	50                   	push   %eax
  800dd9:	e8 22 01 00 00       	call   800f00 <nsipc_accept>
  800dde:	83 c4 10             	add    $0x10,%esp
  800de1:	85 c0                	test   %eax,%eax
  800de3:	78 05                	js     800dea <accept+0x31>
	return alloc_sockfd(r);
  800de5:	e8 5b ff ff ff       	call   800d45 <alloc_sockfd>
}
  800dea:	c9                   	leave  
  800deb:	c3                   	ret    

00800dec <bind>:
{
  800dec:	f3 0f 1e fb          	endbr32 
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	e8 17 ff ff ff       	call   800d15 <fd2sockid>
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	78 12                	js     800e14 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  800e02:	83 ec 04             	sub    $0x4,%esp
  800e05:	ff 75 10             	pushl  0x10(%ebp)
  800e08:	ff 75 0c             	pushl  0xc(%ebp)
  800e0b:	50                   	push   %eax
  800e0c:	e8 45 01 00 00       	call   800f56 <nsipc_bind>
  800e11:	83 c4 10             	add    $0x10,%esp
}
  800e14:	c9                   	leave  
  800e15:	c3                   	ret    

00800e16 <shutdown>:
{
  800e16:	f3 0f 1e fb          	endbr32 
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	e8 ed fe ff ff       	call   800d15 <fd2sockid>
  800e28:	85 c0                	test   %eax,%eax
  800e2a:	78 0f                	js     800e3b <shutdown+0x25>
	return nsipc_shutdown(r, how);
  800e2c:	83 ec 08             	sub    $0x8,%esp
  800e2f:	ff 75 0c             	pushl  0xc(%ebp)
  800e32:	50                   	push   %eax
  800e33:	e8 57 01 00 00       	call   800f8f <nsipc_shutdown>
  800e38:	83 c4 10             	add    $0x10,%esp
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <connect>:
{
  800e3d:	f3 0f 1e fb          	endbr32 
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	e8 c6 fe ff ff       	call   800d15 <fd2sockid>
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	78 12                	js     800e65 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  800e53:	83 ec 04             	sub    $0x4,%esp
  800e56:	ff 75 10             	pushl  0x10(%ebp)
  800e59:	ff 75 0c             	pushl  0xc(%ebp)
  800e5c:	50                   	push   %eax
  800e5d:	e8 71 01 00 00       	call   800fd3 <nsipc_connect>
  800e62:	83 c4 10             	add    $0x10,%esp
}
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <listen>:
{
  800e67:	f3 0f 1e fb          	endbr32 
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	e8 9c fe ff ff       	call   800d15 <fd2sockid>
  800e79:	85 c0                	test   %eax,%eax
  800e7b:	78 0f                	js     800e8c <listen+0x25>
	return nsipc_listen(r, backlog);
  800e7d:	83 ec 08             	sub    $0x8,%esp
  800e80:	ff 75 0c             	pushl  0xc(%ebp)
  800e83:	50                   	push   %eax
  800e84:	e8 83 01 00 00       	call   80100c <nsipc_listen>
  800e89:	83 c4 10             	add    $0x10,%esp
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <socket>:

int
socket(int domain, int type, int protocol)
{
  800e8e:	f3 0f 1e fb          	endbr32 
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800e98:	ff 75 10             	pushl  0x10(%ebp)
  800e9b:	ff 75 0c             	pushl  0xc(%ebp)
  800e9e:	ff 75 08             	pushl  0x8(%ebp)
  800ea1:	e8 65 02 00 00       	call   80110b <nsipc_socket>
  800ea6:	83 c4 10             	add    $0x10,%esp
  800ea9:	85 c0                	test   %eax,%eax
  800eab:	78 05                	js     800eb2 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  800ead:	e8 93 fe ff ff       	call   800d45 <alloc_sockfd>
}
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    

00800eb4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	53                   	push   %ebx
  800eb8:	83 ec 04             	sub    $0x4,%esp
  800ebb:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800ebd:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800ec4:	74 26                	je     800eec <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800ec6:	6a 07                	push   $0x7
  800ec8:	68 00 60 80 00       	push   $0x806000
  800ecd:	53                   	push   %ebx
  800ece:	ff 35 04 40 80 00    	pushl  0x804004
  800ed4:	e8 43 12 00 00       	call   80211c <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800ed9:	83 c4 0c             	add    $0xc,%esp
  800edc:	6a 00                	push   $0x0
  800ede:	6a 00                	push   $0x0
  800ee0:	6a 00                	push   $0x0
  800ee2:	e8 b0 11 00 00       	call   802097 <ipc_recv>
}
  800ee7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800eea:	c9                   	leave  
  800eeb:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800eec:	83 ec 0c             	sub    $0xc,%esp
  800eef:	6a 02                	push   $0x2
  800ef1:	e8 7e 12 00 00       	call   802174 <ipc_find_env>
  800ef6:	a3 04 40 80 00       	mov    %eax,0x804004
  800efb:	83 c4 10             	add    $0x10,%esp
  800efe:	eb c6                	jmp    800ec6 <nsipc+0x12>

00800f00 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800f00:	f3 0f 1e fb          	endbr32 
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	56                   	push   %esi
  800f08:	53                   	push   %ebx
  800f09:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800f14:	8b 06                	mov    (%esi),%eax
  800f16:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800f1b:	b8 01 00 00 00       	mov    $0x1,%eax
  800f20:	e8 8f ff ff ff       	call   800eb4 <nsipc>
  800f25:	89 c3                	mov    %eax,%ebx
  800f27:	85 c0                	test   %eax,%eax
  800f29:	79 09                	jns    800f34 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  800f2b:	89 d8                	mov    %ebx,%eax
  800f2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f30:	5b                   	pop    %ebx
  800f31:	5e                   	pop    %esi
  800f32:	5d                   	pop    %ebp
  800f33:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800f34:	83 ec 04             	sub    $0x4,%esp
  800f37:	ff 35 10 60 80 00    	pushl  0x806010
  800f3d:	68 00 60 80 00       	push   $0x806000
  800f42:	ff 75 0c             	pushl  0xc(%ebp)
  800f45:	e8 91 0f 00 00       	call   801edb <memmove>
		*addrlen = ret->ret_addrlen;
  800f4a:	a1 10 60 80 00       	mov    0x806010,%eax
  800f4f:	89 06                	mov    %eax,(%esi)
  800f51:	83 c4 10             	add    $0x10,%esp
	return r;
  800f54:	eb d5                	jmp    800f2b <nsipc_accept+0x2b>

00800f56 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800f56:	f3 0f 1e fb          	endbr32 
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	53                   	push   %ebx
  800f5e:	83 ec 08             	sub    $0x8,%esp
  800f61:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800f6c:	53                   	push   %ebx
  800f6d:	ff 75 0c             	pushl  0xc(%ebp)
  800f70:	68 04 60 80 00       	push   $0x806004
  800f75:	e8 61 0f 00 00       	call   801edb <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800f7a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800f80:	b8 02 00 00 00       	mov    $0x2,%eax
  800f85:	e8 2a ff ff ff       	call   800eb4 <nsipc>
}
  800f8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f8d:	c9                   	leave  
  800f8e:	c3                   	ret    

00800f8f <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800f8f:	f3 0f 1e fb          	endbr32 
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800fa9:	b8 03 00 00 00       	mov    $0x3,%eax
  800fae:	e8 01 ff ff ff       	call   800eb4 <nsipc>
}
  800fb3:	c9                   	leave  
  800fb4:	c3                   	ret    

00800fb5 <nsipc_close>:

int
nsipc_close(int s)
{
  800fb5:	f3 0f 1e fb          	endbr32 
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800fc7:	b8 04 00 00 00       	mov    $0x4,%eax
  800fcc:	e8 e3 fe ff ff       	call   800eb4 <nsipc>
}
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800fd3:	f3 0f 1e fb          	endbr32 
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	53                   	push   %ebx
  800fdb:	83 ec 08             	sub    $0x8,%esp
  800fde:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800fe9:	53                   	push   %ebx
  800fea:	ff 75 0c             	pushl  0xc(%ebp)
  800fed:	68 04 60 80 00       	push   $0x806004
  800ff2:	e8 e4 0e 00 00       	call   801edb <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800ff7:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  800ffd:	b8 05 00 00 00       	mov    $0x5,%eax
  801002:	e8 ad fe ff ff       	call   800eb4 <nsipc>
}
  801007:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80100c:	f3 0f 1e fb          	endbr32 
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
  801013:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80101e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801021:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801026:	b8 06 00 00 00       	mov    $0x6,%eax
  80102b:	e8 84 fe ff ff       	call   800eb4 <nsipc>
}
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801032:	f3 0f 1e fb          	endbr32 
  801036:	55                   	push   %ebp
  801037:	89 e5                	mov    %esp,%ebp
  801039:	56                   	push   %esi
  80103a:	53                   	push   %ebx
  80103b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801046:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80104c:	8b 45 14             	mov    0x14(%ebp),%eax
  80104f:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801054:	b8 07 00 00 00       	mov    $0x7,%eax
  801059:	e8 56 fe ff ff       	call   800eb4 <nsipc>
  80105e:	89 c3                	mov    %eax,%ebx
  801060:	85 c0                	test   %eax,%eax
  801062:	78 26                	js     80108a <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801064:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  80106a:	b8 3f 06 00 00       	mov    $0x63f,%eax
  80106f:	0f 4e c6             	cmovle %esi,%eax
  801072:	39 c3                	cmp    %eax,%ebx
  801074:	7f 1d                	jg     801093 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801076:	83 ec 04             	sub    $0x4,%esp
  801079:	53                   	push   %ebx
  80107a:	68 00 60 80 00       	push   $0x806000
  80107f:	ff 75 0c             	pushl  0xc(%ebp)
  801082:	e8 54 0e 00 00       	call   801edb <memmove>
  801087:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80108a:	89 d8                	mov    %ebx,%eax
  80108c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80108f:	5b                   	pop    %ebx
  801090:	5e                   	pop    %esi
  801091:	5d                   	pop    %ebp
  801092:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801093:	68 67 25 80 00       	push   $0x802567
  801098:	68 2f 25 80 00       	push   $0x80252f
  80109d:	6a 62                	push   $0x62
  80109f:	68 7c 25 80 00       	push   $0x80257c
  8010a4:	e8 8b 05 00 00       	call   801634 <_panic>

008010a9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8010a9:	f3 0f 1e fb          	endbr32 
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	53                   	push   %ebx
  8010b1:	83 ec 04             	sub    $0x4,%esp
  8010b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8010bf:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8010c5:	7f 2e                	jg     8010f5 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8010c7:	83 ec 04             	sub    $0x4,%esp
  8010ca:	53                   	push   %ebx
  8010cb:	ff 75 0c             	pushl  0xc(%ebp)
  8010ce:	68 0c 60 80 00       	push   $0x80600c
  8010d3:	e8 03 0e 00 00       	call   801edb <memmove>
	nsipcbuf.send.req_size = size;
  8010d8:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8010de:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e1:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8010e6:	b8 08 00 00 00       	mov    $0x8,%eax
  8010eb:	e8 c4 fd ff ff       	call   800eb4 <nsipc>
}
  8010f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    
	assert(size < 1600);
  8010f5:	68 88 25 80 00       	push   $0x802588
  8010fa:	68 2f 25 80 00       	push   $0x80252f
  8010ff:	6a 6d                	push   $0x6d
  801101:	68 7c 25 80 00       	push   $0x80257c
  801106:	e8 29 05 00 00       	call   801634 <_panic>

0080110b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80110b:	f3 0f 1e fb          	endbr32 
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
  801112:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80111d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801120:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801125:	8b 45 10             	mov    0x10(%ebp),%eax
  801128:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80112d:	b8 09 00 00 00       	mov    $0x9,%eax
  801132:	e8 7d fd ff ff       	call   800eb4 <nsipc>
}
  801137:	c9                   	leave  
  801138:	c3                   	ret    

00801139 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801139:	f3 0f 1e fb          	endbr32 
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	56                   	push   %esi
  801141:	53                   	push   %ebx
  801142:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801145:	83 ec 0c             	sub    $0xc,%esp
  801148:	ff 75 08             	pushl  0x8(%ebp)
  80114b:	e8 f6 f2 ff ff       	call   800446 <fd2data>
  801150:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801152:	83 c4 08             	add    $0x8,%esp
  801155:	68 94 25 80 00       	push   $0x802594
  80115a:	53                   	push   %ebx
  80115b:	e8 c5 0b 00 00       	call   801d25 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801160:	8b 46 04             	mov    0x4(%esi),%eax
  801163:	2b 06                	sub    (%esi),%eax
  801165:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80116b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801172:	00 00 00 
	stat->st_dev = &devpipe;
  801175:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80117c:	30 80 00 
	return 0;
}
  80117f:	b8 00 00 00 00       	mov    $0x0,%eax
  801184:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801187:	5b                   	pop    %ebx
  801188:	5e                   	pop    %esi
  801189:	5d                   	pop    %ebp
  80118a:	c3                   	ret    

0080118b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80118b:	f3 0f 1e fb          	endbr32 
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	53                   	push   %ebx
  801193:	83 ec 0c             	sub    $0xc,%esp
  801196:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801199:	53                   	push   %ebx
  80119a:	6a 00                	push   $0x0
  80119c:	e8 5e f0 ff ff       	call   8001ff <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8011a1:	89 1c 24             	mov    %ebx,(%esp)
  8011a4:	e8 9d f2 ff ff       	call   800446 <fd2data>
  8011a9:	83 c4 08             	add    $0x8,%esp
  8011ac:	50                   	push   %eax
  8011ad:	6a 00                	push   $0x0
  8011af:	e8 4b f0 ff ff       	call   8001ff <sys_page_unmap>
}
  8011b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b7:	c9                   	leave  
  8011b8:	c3                   	ret    

008011b9 <_pipeisclosed>:
{
  8011b9:	55                   	push   %ebp
  8011ba:	89 e5                	mov    %esp,%ebp
  8011bc:	57                   	push   %edi
  8011bd:	56                   	push   %esi
  8011be:	53                   	push   %ebx
  8011bf:	83 ec 1c             	sub    $0x1c,%esp
  8011c2:	89 c7                	mov    %eax,%edi
  8011c4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8011c6:	a1 08 40 80 00       	mov    0x804008,%eax
  8011cb:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8011ce:	83 ec 0c             	sub    $0xc,%esp
  8011d1:	57                   	push   %edi
  8011d2:	e8 da 0f 00 00       	call   8021b1 <pageref>
  8011d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011da:	89 34 24             	mov    %esi,(%esp)
  8011dd:	e8 cf 0f 00 00       	call   8021b1 <pageref>
		nn = thisenv->env_runs;
  8011e2:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8011e8:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8011eb:	83 c4 10             	add    $0x10,%esp
  8011ee:	39 cb                	cmp    %ecx,%ebx
  8011f0:	74 1b                	je     80120d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8011f2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8011f5:	75 cf                	jne    8011c6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8011f7:	8b 42 58             	mov    0x58(%edx),%eax
  8011fa:	6a 01                	push   $0x1
  8011fc:	50                   	push   %eax
  8011fd:	53                   	push   %ebx
  8011fe:	68 9b 25 80 00       	push   $0x80259b
  801203:	e8 13 05 00 00       	call   80171b <cprintf>
  801208:	83 c4 10             	add    $0x10,%esp
  80120b:	eb b9                	jmp    8011c6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80120d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801210:	0f 94 c0             	sete   %al
  801213:	0f b6 c0             	movzbl %al,%eax
}
  801216:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801219:	5b                   	pop    %ebx
  80121a:	5e                   	pop    %esi
  80121b:	5f                   	pop    %edi
  80121c:	5d                   	pop    %ebp
  80121d:	c3                   	ret    

0080121e <devpipe_write>:
{
  80121e:	f3 0f 1e fb          	endbr32 
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	57                   	push   %edi
  801226:	56                   	push   %esi
  801227:	53                   	push   %ebx
  801228:	83 ec 28             	sub    $0x28,%esp
  80122b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80122e:	56                   	push   %esi
  80122f:	e8 12 f2 ff ff       	call   800446 <fd2data>
  801234:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801236:	83 c4 10             	add    $0x10,%esp
  801239:	bf 00 00 00 00       	mov    $0x0,%edi
  80123e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801241:	74 4f                	je     801292 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801243:	8b 43 04             	mov    0x4(%ebx),%eax
  801246:	8b 0b                	mov    (%ebx),%ecx
  801248:	8d 51 20             	lea    0x20(%ecx),%edx
  80124b:	39 d0                	cmp    %edx,%eax
  80124d:	72 14                	jb     801263 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  80124f:	89 da                	mov    %ebx,%edx
  801251:	89 f0                	mov    %esi,%eax
  801253:	e8 61 ff ff ff       	call   8011b9 <_pipeisclosed>
  801258:	85 c0                	test   %eax,%eax
  80125a:	75 3b                	jne    801297 <devpipe_write+0x79>
			sys_yield();
  80125c:	e8 ee ee ff ff       	call   80014f <sys_yield>
  801261:	eb e0                	jmp    801243 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801263:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801266:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80126a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80126d:	89 c2                	mov    %eax,%edx
  80126f:	c1 fa 1f             	sar    $0x1f,%edx
  801272:	89 d1                	mov    %edx,%ecx
  801274:	c1 e9 1b             	shr    $0x1b,%ecx
  801277:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80127a:	83 e2 1f             	and    $0x1f,%edx
  80127d:	29 ca                	sub    %ecx,%edx
  80127f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801283:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801287:	83 c0 01             	add    $0x1,%eax
  80128a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80128d:	83 c7 01             	add    $0x1,%edi
  801290:	eb ac                	jmp    80123e <devpipe_write+0x20>
	return i;
  801292:	8b 45 10             	mov    0x10(%ebp),%eax
  801295:	eb 05                	jmp    80129c <devpipe_write+0x7e>
				return 0;
  801297:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80129c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80129f:	5b                   	pop    %ebx
  8012a0:	5e                   	pop    %esi
  8012a1:	5f                   	pop    %edi
  8012a2:	5d                   	pop    %ebp
  8012a3:	c3                   	ret    

008012a4 <devpipe_read>:
{
  8012a4:	f3 0f 1e fb          	endbr32 
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	57                   	push   %edi
  8012ac:	56                   	push   %esi
  8012ad:	53                   	push   %ebx
  8012ae:	83 ec 18             	sub    $0x18,%esp
  8012b1:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8012b4:	57                   	push   %edi
  8012b5:	e8 8c f1 ff ff       	call   800446 <fd2data>
  8012ba:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8012bc:	83 c4 10             	add    $0x10,%esp
  8012bf:	be 00 00 00 00       	mov    $0x0,%esi
  8012c4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8012c7:	75 14                	jne    8012dd <devpipe_read+0x39>
	return i;
  8012c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cc:	eb 02                	jmp    8012d0 <devpipe_read+0x2c>
				return i;
  8012ce:	89 f0                	mov    %esi,%eax
}
  8012d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d3:	5b                   	pop    %ebx
  8012d4:	5e                   	pop    %esi
  8012d5:	5f                   	pop    %edi
  8012d6:	5d                   	pop    %ebp
  8012d7:	c3                   	ret    
			sys_yield();
  8012d8:	e8 72 ee ff ff       	call   80014f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8012dd:	8b 03                	mov    (%ebx),%eax
  8012df:	3b 43 04             	cmp    0x4(%ebx),%eax
  8012e2:	75 18                	jne    8012fc <devpipe_read+0x58>
			if (i > 0)
  8012e4:	85 f6                	test   %esi,%esi
  8012e6:	75 e6                	jne    8012ce <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8012e8:	89 da                	mov    %ebx,%edx
  8012ea:	89 f8                	mov    %edi,%eax
  8012ec:	e8 c8 fe ff ff       	call   8011b9 <_pipeisclosed>
  8012f1:	85 c0                	test   %eax,%eax
  8012f3:	74 e3                	je     8012d8 <devpipe_read+0x34>
				return 0;
  8012f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fa:	eb d4                	jmp    8012d0 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8012fc:	99                   	cltd   
  8012fd:	c1 ea 1b             	shr    $0x1b,%edx
  801300:	01 d0                	add    %edx,%eax
  801302:	83 e0 1f             	and    $0x1f,%eax
  801305:	29 d0                	sub    %edx,%eax
  801307:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80130c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80130f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801312:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801315:	83 c6 01             	add    $0x1,%esi
  801318:	eb aa                	jmp    8012c4 <devpipe_read+0x20>

0080131a <pipe>:
{
  80131a:	f3 0f 1e fb          	endbr32 
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	56                   	push   %esi
  801322:	53                   	push   %ebx
  801323:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801326:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801329:	50                   	push   %eax
  80132a:	e8 32 f1 ff ff       	call   800461 <fd_alloc>
  80132f:	89 c3                	mov    %eax,%ebx
  801331:	83 c4 10             	add    $0x10,%esp
  801334:	85 c0                	test   %eax,%eax
  801336:	0f 88 23 01 00 00    	js     80145f <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80133c:	83 ec 04             	sub    $0x4,%esp
  80133f:	68 07 04 00 00       	push   $0x407
  801344:	ff 75 f4             	pushl  -0xc(%ebp)
  801347:	6a 00                	push   $0x0
  801349:	e8 24 ee ff ff       	call   800172 <sys_page_alloc>
  80134e:	89 c3                	mov    %eax,%ebx
  801350:	83 c4 10             	add    $0x10,%esp
  801353:	85 c0                	test   %eax,%eax
  801355:	0f 88 04 01 00 00    	js     80145f <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80135b:	83 ec 0c             	sub    $0xc,%esp
  80135e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801361:	50                   	push   %eax
  801362:	e8 fa f0 ff ff       	call   800461 <fd_alloc>
  801367:	89 c3                	mov    %eax,%ebx
  801369:	83 c4 10             	add    $0x10,%esp
  80136c:	85 c0                	test   %eax,%eax
  80136e:	0f 88 db 00 00 00    	js     80144f <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801374:	83 ec 04             	sub    $0x4,%esp
  801377:	68 07 04 00 00       	push   $0x407
  80137c:	ff 75 f0             	pushl  -0x10(%ebp)
  80137f:	6a 00                	push   $0x0
  801381:	e8 ec ed ff ff       	call   800172 <sys_page_alloc>
  801386:	89 c3                	mov    %eax,%ebx
  801388:	83 c4 10             	add    $0x10,%esp
  80138b:	85 c0                	test   %eax,%eax
  80138d:	0f 88 bc 00 00 00    	js     80144f <pipe+0x135>
	va = fd2data(fd0);
  801393:	83 ec 0c             	sub    $0xc,%esp
  801396:	ff 75 f4             	pushl  -0xc(%ebp)
  801399:	e8 a8 f0 ff ff       	call   800446 <fd2data>
  80139e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013a0:	83 c4 0c             	add    $0xc,%esp
  8013a3:	68 07 04 00 00       	push   $0x407
  8013a8:	50                   	push   %eax
  8013a9:	6a 00                	push   $0x0
  8013ab:	e8 c2 ed ff ff       	call   800172 <sys_page_alloc>
  8013b0:	89 c3                	mov    %eax,%ebx
  8013b2:	83 c4 10             	add    $0x10,%esp
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	0f 88 82 00 00 00    	js     80143f <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013bd:	83 ec 0c             	sub    $0xc,%esp
  8013c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8013c3:	e8 7e f0 ff ff       	call   800446 <fd2data>
  8013c8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8013cf:	50                   	push   %eax
  8013d0:	6a 00                	push   $0x0
  8013d2:	56                   	push   %esi
  8013d3:	6a 00                	push   $0x0
  8013d5:	e8 df ed ff ff       	call   8001b9 <sys_page_map>
  8013da:	89 c3                	mov    %eax,%ebx
  8013dc:	83 c4 20             	add    $0x20,%esp
  8013df:	85 c0                	test   %eax,%eax
  8013e1:	78 4e                	js     801431 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8013e3:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8013e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013eb:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8013ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f0:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8013f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013fa:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8013fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ff:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801406:	83 ec 0c             	sub    $0xc,%esp
  801409:	ff 75 f4             	pushl  -0xc(%ebp)
  80140c:	e8 21 f0 ff ff       	call   800432 <fd2num>
  801411:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801414:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801416:	83 c4 04             	add    $0x4,%esp
  801419:	ff 75 f0             	pushl  -0x10(%ebp)
  80141c:	e8 11 f0 ff ff       	call   800432 <fd2num>
  801421:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801424:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801427:	83 c4 10             	add    $0x10,%esp
  80142a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80142f:	eb 2e                	jmp    80145f <pipe+0x145>
	sys_page_unmap(0, va);
  801431:	83 ec 08             	sub    $0x8,%esp
  801434:	56                   	push   %esi
  801435:	6a 00                	push   $0x0
  801437:	e8 c3 ed ff ff       	call   8001ff <sys_page_unmap>
  80143c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80143f:	83 ec 08             	sub    $0x8,%esp
  801442:	ff 75 f0             	pushl  -0x10(%ebp)
  801445:	6a 00                	push   $0x0
  801447:	e8 b3 ed ff ff       	call   8001ff <sys_page_unmap>
  80144c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80144f:	83 ec 08             	sub    $0x8,%esp
  801452:	ff 75 f4             	pushl  -0xc(%ebp)
  801455:	6a 00                	push   $0x0
  801457:	e8 a3 ed ff ff       	call   8001ff <sys_page_unmap>
  80145c:	83 c4 10             	add    $0x10,%esp
}
  80145f:	89 d8                	mov    %ebx,%eax
  801461:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801464:	5b                   	pop    %ebx
  801465:	5e                   	pop    %esi
  801466:	5d                   	pop    %ebp
  801467:	c3                   	ret    

00801468 <pipeisclosed>:
{
  801468:	f3 0f 1e fb          	endbr32 
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801472:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801475:	50                   	push   %eax
  801476:	ff 75 08             	pushl  0x8(%ebp)
  801479:	e8 39 f0 ff ff       	call   8004b7 <fd_lookup>
  80147e:	83 c4 10             	add    $0x10,%esp
  801481:	85 c0                	test   %eax,%eax
  801483:	78 18                	js     80149d <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801485:	83 ec 0c             	sub    $0xc,%esp
  801488:	ff 75 f4             	pushl  -0xc(%ebp)
  80148b:	e8 b6 ef ff ff       	call   800446 <fd2data>
  801490:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801495:	e8 1f fd ff ff       	call   8011b9 <_pipeisclosed>
  80149a:	83 c4 10             	add    $0x10,%esp
}
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80149f:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8014a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a8:	c3                   	ret    

008014a9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8014a9:	f3 0f 1e fb          	endbr32 
  8014ad:	55                   	push   %ebp
  8014ae:	89 e5                	mov    %esp,%ebp
  8014b0:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8014b3:	68 b3 25 80 00       	push   $0x8025b3
  8014b8:	ff 75 0c             	pushl  0xc(%ebp)
  8014bb:	e8 65 08 00 00       	call   801d25 <strcpy>
	return 0;
}
  8014c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <devcons_write>:
{
  8014c7:	f3 0f 1e fb          	endbr32 
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
  8014ce:	57                   	push   %edi
  8014cf:	56                   	push   %esi
  8014d0:	53                   	push   %ebx
  8014d1:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8014d7:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8014dc:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8014e2:	3b 75 10             	cmp    0x10(%ebp),%esi
  8014e5:	73 31                	jae    801518 <devcons_write+0x51>
		m = n - tot;
  8014e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014ea:	29 f3                	sub    %esi,%ebx
  8014ec:	83 fb 7f             	cmp    $0x7f,%ebx
  8014ef:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8014f4:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8014f7:	83 ec 04             	sub    $0x4,%esp
  8014fa:	53                   	push   %ebx
  8014fb:	89 f0                	mov    %esi,%eax
  8014fd:	03 45 0c             	add    0xc(%ebp),%eax
  801500:	50                   	push   %eax
  801501:	57                   	push   %edi
  801502:	e8 d4 09 00 00       	call   801edb <memmove>
		sys_cputs(buf, m);
  801507:	83 c4 08             	add    $0x8,%esp
  80150a:	53                   	push   %ebx
  80150b:	57                   	push   %edi
  80150c:	e8 91 eb ff ff       	call   8000a2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801511:	01 de                	add    %ebx,%esi
  801513:	83 c4 10             	add    $0x10,%esp
  801516:	eb ca                	jmp    8014e2 <devcons_write+0x1b>
}
  801518:	89 f0                	mov    %esi,%eax
  80151a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80151d:	5b                   	pop    %ebx
  80151e:	5e                   	pop    %esi
  80151f:	5f                   	pop    %edi
  801520:	5d                   	pop    %ebp
  801521:	c3                   	ret    

00801522 <devcons_read>:
{
  801522:	f3 0f 1e fb          	endbr32 
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	83 ec 08             	sub    $0x8,%esp
  80152c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801531:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801535:	74 21                	je     801558 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801537:	e8 88 eb ff ff       	call   8000c4 <sys_cgetc>
  80153c:	85 c0                	test   %eax,%eax
  80153e:	75 07                	jne    801547 <devcons_read+0x25>
		sys_yield();
  801540:	e8 0a ec ff ff       	call   80014f <sys_yield>
  801545:	eb f0                	jmp    801537 <devcons_read+0x15>
	if (c < 0)
  801547:	78 0f                	js     801558 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801549:	83 f8 04             	cmp    $0x4,%eax
  80154c:	74 0c                	je     80155a <devcons_read+0x38>
	*(char*)vbuf = c;
  80154e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801551:	88 02                	mov    %al,(%edx)
	return 1;
  801553:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801558:	c9                   	leave  
  801559:	c3                   	ret    
		return 0;
  80155a:	b8 00 00 00 00       	mov    $0x0,%eax
  80155f:	eb f7                	jmp    801558 <devcons_read+0x36>

00801561 <cputchar>:
{
  801561:	f3 0f 1e fb          	endbr32 
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801571:	6a 01                	push   $0x1
  801573:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801576:	50                   	push   %eax
  801577:	e8 26 eb ff ff       	call   8000a2 <sys_cputs>
}
  80157c:	83 c4 10             	add    $0x10,%esp
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <getchar>:
{
  801581:	f3 0f 1e fb          	endbr32 
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80158b:	6a 01                	push   $0x1
  80158d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801590:	50                   	push   %eax
  801591:	6a 00                	push   $0x0
  801593:	e8 a7 f1 ff ff       	call   80073f <read>
	if (r < 0)
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	85 c0                	test   %eax,%eax
  80159d:	78 06                	js     8015a5 <getchar+0x24>
	if (r < 1)
  80159f:	74 06                	je     8015a7 <getchar+0x26>
	return c;
  8015a1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    
		return -E_EOF;
  8015a7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8015ac:	eb f7                	jmp    8015a5 <getchar+0x24>

008015ae <iscons>:
{
  8015ae:	f3 0f 1e fb          	endbr32 
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
  8015b5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015bb:	50                   	push   %eax
  8015bc:	ff 75 08             	pushl  0x8(%ebp)
  8015bf:	e8 f3 ee ff ff       	call   8004b7 <fd_lookup>
  8015c4:	83 c4 10             	add    $0x10,%esp
  8015c7:	85 c0                	test   %eax,%eax
  8015c9:	78 11                	js     8015dc <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8015cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ce:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8015d4:	39 10                	cmp    %edx,(%eax)
  8015d6:	0f 94 c0             	sete   %al
  8015d9:	0f b6 c0             	movzbl %al,%eax
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <opencons>:
{
  8015de:	f3 0f 1e fb          	endbr32 
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8015e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015eb:	50                   	push   %eax
  8015ec:	e8 70 ee ff ff       	call   800461 <fd_alloc>
  8015f1:	83 c4 10             	add    $0x10,%esp
  8015f4:	85 c0                	test   %eax,%eax
  8015f6:	78 3a                	js     801632 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8015f8:	83 ec 04             	sub    $0x4,%esp
  8015fb:	68 07 04 00 00       	push   $0x407
  801600:	ff 75 f4             	pushl  -0xc(%ebp)
  801603:	6a 00                	push   $0x0
  801605:	e8 68 eb ff ff       	call   800172 <sys_page_alloc>
  80160a:	83 c4 10             	add    $0x10,%esp
  80160d:	85 c0                	test   %eax,%eax
  80160f:	78 21                	js     801632 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801614:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80161a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80161c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801626:	83 ec 0c             	sub    $0xc,%esp
  801629:	50                   	push   %eax
  80162a:	e8 03 ee ff ff       	call   800432 <fd2num>
  80162f:	83 c4 10             	add    $0x10,%esp
}
  801632:	c9                   	leave  
  801633:	c3                   	ret    

00801634 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801634:	f3 0f 1e fb          	endbr32 
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	56                   	push   %esi
  80163c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80163d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801640:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801646:	e8 e1 ea ff ff       	call   80012c <sys_getenvid>
  80164b:	83 ec 0c             	sub    $0xc,%esp
  80164e:	ff 75 0c             	pushl  0xc(%ebp)
  801651:	ff 75 08             	pushl  0x8(%ebp)
  801654:	56                   	push   %esi
  801655:	50                   	push   %eax
  801656:	68 c0 25 80 00       	push   $0x8025c0
  80165b:	e8 bb 00 00 00       	call   80171b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801660:	83 c4 18             	add    $0x18,%esp
  801663:	53                   	push   %ebx
  801664:	ff 75 10             	pushl  0x10(%ebp)
  801667:	e8 5a 00 00 00       	call   8016c6 <vcprintf>
	cprintf("\n");
  80166c:	c7 04 24 f8 28 80 00 	movl   $0x8028f8,(%esp)
  801673:	e8 a3 00 00 00       	call   80171b <cprintf>
  801678:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80167b:	cc                   	int3   
  80167c:	eb fd                	jmp    80167b <_panic+0x47>

0080167e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80167e:	f3 0f 1e fb          	endbr32 
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	53                   	push   %ebx
  801686:	83 ec 04             	sub    $0x4,%esp
  801689:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80168c:	8b 13                	mov    (%ebx),%edx
  80168e:	8d 42 01             	lea    0x1(%edx),%eax
  801691:	89 03                	mov    %eax,(%ebx)
  801693:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801696:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80169a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80169f:	74 09                	je     8016aa <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8016a1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8016a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8016aa:	83 ec 08             	sub    $0x8,%esp
  8016ad:	68 ff 00 00 00       	push   $0xff
  8016b2:	8d 43 08             	lea    0x8(%ebx),%eax
  8016b5:	50                   	push   %eax
  8016b6:	e8 e7 e9 ff ff       	call   8000a2 <sys_cputs>
		b->idx = 0;
  8016bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8016c1:	83 c4 10             	add    $0x10,%esp
  8016c4:	eb db                	jmp    8016a1 <putch+0x23>

008016c6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8016c6:	f3 0f 1e fb          	endbr32 
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
  8016cd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8016d3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8016da:	00 00 00 
	b.cnt = 0;
  8016dd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8016e4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8016e7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ea:	ff 75 08             	pushl  0x8(%ebp)
  8016ed:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8016f3:	50                   	push   %eax
  8016f4:	68 7e 16 80 00       	push   $0x80167e
  8016f9:	e8 20 01 00 00       	call   80181e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8016fe:	83 c4 08             	add    $0x8,%esp
  801701:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801707:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80170d:	50                   	push   %eax
  80170e:	e8 8f e9 ff ff       	call   8000a2 <sys_cputs>

	return b.cnt;
}
  801713:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80171b:	f3 0f 1e fb          	endbr32 
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801725:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801728:	50                   	push   %eax
  801729:	ff 75 08             	pushl  0x8(%ebp)
  80172c:	e8 95 ff ff ff       	call   8016c6 <vcprintf>
	va_end(ap);

	return cnt;
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	57                   	push   %edi
  801737:	56                   	push   %esi
  801738:	53                   	push   %ebx
  801739:	83 ec 1c             	sub    $0x1c,%esp
  80173c:	89 c7                	mov    %eax,%edi
  80173e:	89 d6                	mov    %edx,%esi
  801740:	8b 45 08             	mov    0x8(%ebp),%eax
  801743:	8b 55 0c             	mov    0xc(%ebp),%edx
  801746:	89 d1                	mov    %edx,%ecx
  801748:	89 c2                	mov    %eax,%edx
  80174a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80174d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801750:	8b 45 10             	mov    0x10(%ebp),%eax
  801753:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801756:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801759:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801760:	39 c2                	cmp    %eax,%edx
  801762:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  801765:	72 3e                	jb     8017a5 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801767:	83 ec 0c             	sub    $0xc,%esp
  80176a:	ff 75 18             	pushl  0x18(%ebp)
  80176d:	83 eb 01             	sub    $0x1,%ebx
  801770:	53                   	push   %ebx
  801771:	50                   	push   %eax
  801772:	83 ec 08             	sub    $0x8,%esp
  801775:	ff 75 e4             	pushl  -0x1c(%ebp)
  801778:	ff 75 e0             	pushl  -0x20(%ebp)
  80177b:	ff 75 dc             	pushl  -0x24(%ebp)
  80177e:	ff 75 d8             	pushl  -0x28(%ebp)
  801781:	e8 7a 0a 00 00       	call   802200 <__udivdi3>
  801786:	83 c4 18             	add    $0x18,%esp
  801789:	52                   	push   %edx
  80178a:	50                   	push   %eax
  80178b:	89 f2                	mov    %esi,%edx
  80178d:	89 f8                	mov    %edi,%eax
  80178f:	e8 9f ff ff ff       	call   801733 <printnum>
  801794:	83 c4 20             	add    $0x20,%esp
  801797:	eb 13                	jmp    8017ac <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801799:	83 ec 08             	sub    $0x8,%esp
  80179c:	56                   	push   %esi
  80179d:	ff 75 18             	pushl  0x18(%ebp)
  8017a0:	ff d7                	call   *%edi
  8017a2:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8017a5:	83 eb 01             	sub    $0x1,%ebx
  8017a8:	85 db                	test   %ebx,%ebx
  8017aa:	7f ed                	jg     801799 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8017ac:	83 ec 08             	sub    $0x8,%esp
  8017af:	56                   	push   %esi
  8017b0:	83 ec 04             	sub    $0x4,%esp
  8017b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8017b9:	ff 75 dc             	pushl  -0x24(%ebp)
  8017bc:	ff 75 d8             	pushl  -0x28(%ebp)
  8017bf:	e8 4c 0b 00 00       	call   802310 <__umoddi3>
  8017c4:	83 c4 14             	add    $0x14,%esp
  8017c7:	0f be 80 e3 25 80 00 	movsbl 0x8025e3(%eax),%eax
  8017ce:	50                   	push   %eax
  8017cf:	ff d7                	call   *%edi
}
  8017d1:	83 c4 10             	add    $0x10,%esp
  8017d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017d7:	5b                   	pop    %ebx
  8017d8:	5e                   	pop    %esi
  8017d9:	5f                   	pop    %edi
  8017da:	5d                   	pop    %ebp
  8017db:	c3                   	ret    

008017dc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8017dc:	f3 0f 1e fb          	endbr32 
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8017e6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8017ea:	8b 10                	mov    (%eax),%edx
  8017ec:	3b 50 04             	cmp    0x4(%eax),%edx
  8017ef:	73 0a                	jae    8017fb <sprintputch+0x1f>
		*b->buf++ = ch;
  8017f1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017f4:	89 08                	mov    %ecx,(%eax)
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	88 02                	mov    %al,(%edx)
}
  8017fb:	5d                   	pop    %ebp
  8017fc:	c3                   	ret    

008017fd <printfmt>:
{
  8017fd:	f3 0f 1e fb          	endbr32 
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801807:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80180a:	50                   	push   %eax
  80180b:	ff 75 10             	pushl  0x10(%ebp)
  80180e:	ff 75 0c             	pushl  0xc(%ebp)
  801811:	ff 75 08             	pushl  0x8(%ebp)
  801814:	e8 05 00 00 00       	call   80181e <vprintfmt>
}
  801819:	83 c4 10             	add    $0x10,%esp
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <vprintfmt>:
{
  80181e:	f3 0f 1e fb          	endbr32 
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	57                   	push   %edi
  801826:	56                   	push   %esi
  801827:	53                   	push   %ebx
  801828:	83 ec 3c             	sub    $0x3c,%esp
  80182b:	8b 75 08             	mov    0x8(%ebp),%esi
  80182e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801831:	8b 7d 10             	mov    0x10(%ebp),%edi
  801834:	e9 8e 03 00 00       	jmp    801bc7 <vprintfmt+0x3a9>
		padc = ' ';
  801839:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80183d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801844:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80184b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801852:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801857:	8d 47 01             	lea    0x1(%edi),%eax
  80185a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80185d:	0f b6 17             	movzbl (%edi),%edx
  801860:	8d 42 dd             	lea    -0x23(%edx),%eax
  801863:	3c 55                	cmp    $0x55,%al
  801865:	0f 87 df 03 00 00    	ja     801c4a <vprintfmt+0x42c>
  80186b:	0f b6 c0             	movzbl %al,%eax
  80186e:	3e ff 24 85 20 27 80 	notrack jmp *0x802720(,%eax,4)
  801875:	00 
  801876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801879:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80187d:	eb d8                	jmp    801857 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80187f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801882:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801886:	eb cf                	jmp    801857 <vprintfmt+0x39>
  801888:	0f b6 d2             	movzbl %dl,%edx
  80188b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80188e:	b8 00 00 00 00       	mov    $0x0,%eax
  801893:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801896:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801899:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80189d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8018a0:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8018a3:	83 f9 09             	cmp    $0x9,%ecx
  8018a6:	77 55                	ja     8018fd <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8018a8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8018ab:	eb e9                	jmp    801896 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8018ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b0:	8b 00                	mov    (%eax),%eax
  8018b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b8:	8d 40 04             	lea    0x4(%eax),%eax
  8018bb:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8018be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8018c1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018c5:	79 90                	jns    801857 <vprintfmt+0x39>
				width = precision, precision = -1;
  8018c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8018cd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8018d4:	eb 81                	jmp    801857 <vprintfmt+0x39>
  8018d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e0:	0f 49 d0             	cmovns %eax,%edx
  8018e3:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8018e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8018e9:	e9 69 ff ff ff       	jmp    801857 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8018ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8018f1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8018f8:	e9 5a ff ff ff       	jmp    801857 <vprintfmt+0x39>
  8018fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801900:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801903:	eb bc                	jmp    8018c1 <vprintfmt+0xa3>
			lflag++;
  801905:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801908:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80190b:	e9 47 ff ff ff       	jmp    801857 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  801910:	8b 45 14             	mov    0x14(%ebp),%eax
  801913:	8d 78 04             	lea    0x4(%eax),%edi
  801916:	83 ec 08             	sub    $0x8,%esp
  801919:	53                   	push   %ebx
  80191a:	ff 30                	pushl  (%eax)
  80191c:	ff d6                	call   *%esi
			break;
  80191e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801921:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801924:	e9 9b 02 00 00       	jmp    801bc4 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  801929:	8b 45 14             	mov    0x14(%ebp),%eax
  80192c:	8d 78 04             	lea    0x4(%eax),%edi
  80192f:	8b 00                	mov    (%eax),%eax
  801931:	99                   	cltd   
  801932:	31 d0                	xor    %edx,%eax
  801934:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801936:	83 f8 0f             	cmp    $0xf,%eax
  801939:	7f 23                	jg     80195e <vprintfmt+0x140>
  80193b:	8b 14 85 80 28 80 00 	mov    0x802880(,%eax,4),%edx
  801942:	85 d2                	test   %edx,%edx
  801944:	74 18                	je     80195e <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  801946:	52                   	push   %edx
  801947:	68 41 25 80 00       	push   $0x802541
  80194c:	53                   	push   %ebx
  80194d:	56                   	push   %esi
  80194e:	e8 aa fe ff ff       	call   8017fd <printfmt>
  801953:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801956:	89 7d 14             	mov    %edi,0x14(%ebp)
  801959:	e9 66 02 00 00       	jmp    801bc4 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80195e:	50                   	push   %eax
  80195f:	68 fb 25 80 00       	push   $0x8025fb
  801964:	53                   	push   %ebx
  801965:	56                   	push   %esi
  801966:	e8 92 fe ff ff       	call   8017fd <printfmt>
  80196b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80196e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801971:	e9 4e 02 00 00       	jmp    801bc4 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  801976:	8b 45 14             	mov    0x14(%ebp),%eax
  801979:	83 c0 04             	add    $0x4,%eax
  80197c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80197f:	8b 45 14             	mov    0x14(%ebp),%eax
  801982:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801984:	85 d2                	test   %edx,%edx
  801986:	b8 f4 25 80 00       	mov    $0x8025f4,%eax
  80198b:	0f 45 c2             	cmovne %edx,%eax
  80198e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801991:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801995:	7e 06                	jle    80199d <vprintfmt+0x17f>
  801997:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80199b:	75 0d                	jne    8019aa <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80199d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019a0:	89 c7                	mov    %eax,%edi
  8019a2:	03 45 e0             	add    -0x20(%ebp),%eax
  8019a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019a8:	eb 55                	jmp    8019ff <vprintfmt+0x1e1>
  8019aa:	83 ec 08             	sub    $0x8,%esp
  8019ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8019b0:	ff 75 cc             	pushl  -0x34(%ebp)
  8019b3:	e8 46 03 00 00       	call   801cfe <strnlen>
  8019b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019bb:	29 c2                	sub    %eax,%edx
  8019bd:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8019c0:	83 c4 10             	add    $0x10,%esp
  8019c3:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8019c5:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8019c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8019cc:	85 ff                	test   %edi,%edi
  8019ce:	7e 11                	jle    8019e1 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8019d0:	83 ec 08             	sub    $0x8,%esp
  8019d3:	53                   	push   %ebx
  8019d4:	ff 75 e0             	pushl  -0x20(%ebp)
  8019d7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8019d9:	83 ef 01             	sub    $0x1,%edi
  8019dc:	83 c4 10             	add    $0x10,%esp
  8019df:	eb eb                	jmp    8019cc <vprintfmt+0x1ae>
  8019e1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8019e4:	85 d2                	test   %edx,%edx
  8019e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019eb:	0f 49 c2             	cmovns %edx,%eax
  8019ee:	29 c2                	sub    %eax,%edx
  8019f0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8019f3:	eb a8                	jmp    80199d <vprintfmt+0x17f>
					putch(ch, putdat);
  8019f5:	83 ec 08             	sub    $0x8,%esp
  8019f8:	53                   	push   %ebx
  8019f9:	52                   	push   %edx
  8019fa:	ff d6                	call   *%esi
  8019fc:	83 c4 10             	add    $0x10,%esp
  8019ff:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801a02:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a04:	83 c7 01             	add    $0x1,%edi
  801a07:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a0b:	0f be d0             	movsbl %al,%edx
  801a0e:	85 d2                	test   %edx,%edx
  801a10:	74 4b                	je     801a5d <vprintfmt+0x23f>
  801a12:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801a16:	78 06                	js     801a1e <vprintfmt+0x200>
  801a18:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801a1c:	78 1e                	js     801a3c <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  801a1e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801a22:	74 d1                	je     8019f5 <vprintfmt+0x1d7>
  801a24:	0f be c0             	movsbl %al,%eax
  801a27:	83 e8 20             	sub    $0x20,%eax
  801a2a:	83 f8 5e             	cmp    $0x5e,%eax
  801a2d:	76 c6                	jbe    8019f5 <vprintfmt+0x1d7>
					putch('?', putdat);
  801a2f:	83 ec 08             	sub    $0x8,%esp
  801a32:	53                   	push   %ebx
  801a33:	6a 3f                	push   $0x3f
  801a35:	ff d6                	call   *%esi
  801a37:	83 c4 10             	add    $0x10,%esp
  801a3a:	eb c3                	jmp    8019ff <vprintfmt+0x1e1>
  801a3c:	89 cf                	mov    %ecx,%edi
  801a3e:	eb 0e                	jmp    801a4e <vprintfmt+0x230>
				putch(' ', putdat);
  801a40:	83 ec 08             	sub    $0x8,%esp
  801a43:	53                   	push   %ebx
  801a44:	6a 20                	push   $0x20
  801a46:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801a48:	83 ef 01             	sub    $0x1,%edi
  801a4b:	83 c4 10             	add    $0x10,%esp
  801a4e:	85 ff                	test   %edi,%edi
  801a50:	7f ee                	jg     801a40 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  801a52:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a55:	89 45 14             	mov    %eax,0x14(%ebp)
  801a58:	e9 67 01 00 00       	jmp    801bc4 <vprintfmt+0x3a6>
  801a5d:	89 cf                	mov    %ecx,%edi
  801a5f:	eb ed                	jmp    801a4e <vprintfmt+0x230>
	if (lflag >= 2)
  801a61:	83 f9 01             	cmp    $0x1,%ecx
  801a64:	7f 1b                	jg     801a81 <vprintfmt+0x263>
	else if (lflag)
  801a66:	85 c9                	test   %ecx,%ecx
  801a68:	74 63                	je     801acd <vprintfmt+0x2af>
		return va_arg(*ap, long);
  801a6a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6d:	8b 00                	mov    (%eax),%eax
  801a6f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a72:	99                   	cltd   
  801a73:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a76:	8b 45 14             	mov    0x14(%ebp),%eax
  801a79:	8d 40 04             	lea    0x4(%eax),%eax
  801a7c:	89 45 14             	mov    %eax,0x14(%ebp)
  801a7f:	eb 17                	jmp    801a98 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801a81:	8b 45 14             	mov    0x14(%ebp),%eax
  801a84:	8b 50 04             	mov    0x4(%eax),%edx
  801a87:	8b 00                	mov    (%eax),%eax
  801a89:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a8c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a8f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a92:	8d 40 08             	lea    0x8(%eax),%eax
  801a95:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801a98:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a9b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801a9e:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801aa3:	85 c9                	test   %ecx,%ecx
  801aa5:	0f 89 ff 00 00 00    	jns    801baa <vprintfmt+0x38c>
				putch('-', putdat);
  801aab:	83 ec 08             	sub    $0x8,%esp
  801aae:	53                   	push   %ebx
  801aaf:	6a 2d                	push   $0x2d
  801ab1:	ff d6                	call   *%esi
				num = -(long long) num;
  801ab3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ab6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801ab9:	f7 da                	neg    %edx
  801abb:	83 d1 00             	adc    $0x0,%ecx
  801abe:	f7 d9                	neg    %ecx
  801ac0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801ac3:	b8 0a 00 00 00       	mov    $0xa,%eax
  801ac8:	e9 dd 00 00 00       	jmp    801baa <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801acd:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad0:	8b 00                	mov    (%eax),%eax
  801ad2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ad5:	99                   	cltd   
  801ad6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801ad9:	8b 45 14             	mov    0x14(%ebp),%eax
  801adc:	8d 40 04             	lea    0x4(%eax),%eax
  801adf:	89 45 14             	mov    %eax,0x14(%ebp)
  801ae2:	eb b4                	jmp    801a98 <vprintfmt+0x27a>
	if (lflag >= 2)
  801ae4:	83 f9 01             	cmp    $0x1,%ecx
  801ae7:	7f 1e                	jg     801b07 <vprintfmt+0x2e9>
	else if (lflag)
  801ae9:	85 c9                	test   %ecx,%ecx
  801aeb:	74 32                	je     801b1f <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801aed:	8b 45 14             	mov    0x14(%ebp),%eax
  801af0:	8b 10                	mov    (%eax),%edx
  801af2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801af7:	8d 40 04             	lea    0x4(%eax),%eax
  801afa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801afd:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801b02:	e9 a3 00 00 00       	jmp    801baa <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b07:	8b 45 14             	mov    0x14(%ebp),%eax
  801b0a:	8b 10                	mov    (%eax),%edx
  801b0c:	8b 48 04             	mov    0x4(%eax),%ecx
  801b0f:	8d 40 08             	lea    0x8(%eax),%eax
  801b12:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b15:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  801b1a:	e9 8b 00 00 00       	jmp    801baa <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b22:	8b 10                	mov    (%eax),%edx
  801b24:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b29:	8d 40 04             	lea    0x4(%eax),%eax
  801b2c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b2f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  801b34:	eb 74                	jmp    801baa <vprintfmt+0x38c>
	if (lflag >= 2)
  801b36:	83 f9 01             	cmp    $0x1,%ecx
  801b39:	7f 1b                	jg     801b56 <vprintfmt+0x338>
	else if (lflag)
  801b3b:	85 c9                	test   %ecx,%ecx
  801b3d:	74 2c                	je     801b6b <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801b3f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b42:	8b 10                	mov    (%eax),%edx
  801b44:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b49:	8d 40 04             	lea    0x4(%eax),%eax
  801b4c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b4f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801b54:	eb 54                	jmp    801baa <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b56:	8b 45 14             	mov    0x14(%ebp),%eax
  801b59:	8b 10                	mov    (%eax),%edx
  801b5b:	8b 48 04             	mov    0x4(%eax),%ecx
  801b5e:	8d 40 08             	lea    0x8(%eax),%eax
  801b61:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b64:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801b69:	eb 3f                	jmp    801baa <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b6b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6e:	8b 10                	mov    (%eax),%edx
  801b70:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b75:	8d 40 04             	lea    0x4(%eax),%eax
  801b78:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b7b:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801b80:	eb 28                	jmp    801baa <vprintfmt+0x38c>
			putch('0', putdat);
  801b82:	83 ec 08             	sub    $0x8,%esp
  801b85:	53                   	push   %ebx
  801b86:	6a 30                	push   $0x30
  801b88:	ff d6                	call   *%esi
			putch('x', putdat);
  801b8a:	83 c4 08             	add    $0x8,%esp
  801b8d:	53                   	push   %ebx
  801b8e:	6a 78                	push   $0x78
  801b90:	ff d6                	call   *%esi
			num = (unsigned long long)
  801b92:	8b 45 14             	mov    0x14(%ebp),%eax
  801b95:	8b 10                	mov    (%eax),%edx
  801b97:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801b9c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801b9f:	8d 40 04             	lea    0x4(%eax),%eax
  801ba2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ba5:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801baa:	83 ec 0c             	sub    $0xc,%esp
  801bad:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801bb1:	57                   	push   %edi
  801bb2:	ff 75 e0             	pushl  -0x20(%ebp)
  801bb5:	50                   	push   %eax
  801bb6:	51                   	push   %ecx
  801bb7:	52                   	push   %edx
  801bb8:	89 da                	mov    %ebx,%edx
  801bba:	89 f0                	mov    %esi,%eax
  801bbc:	e8 72 fb ff ff       	call   801733 <printnum>
			break;
  801bc1:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801bc4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801bc7:	83 c7 01             	add    $0x1,%edi
  801bca:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801bce:	83 f8 25             	cmp    $0x25,%eax
  801bd1:	0f 84 62 fc ff ff    	je     801839 <vprintfmt+0x1b>
			if (ch == '\0')
  801bd7:	85 c0                	test   %eax,%eax
  801bd9:	0f 84 8b 00 00 00    	je     801c6a <vprintfmt+0x44c>
			putch(ch, putdat);
  801bdf:	83 ec 08             	sub    $0x8,%esp
  801be2:	53                   	push   %ebx
  801be3:	50                   	push   %eax
  801be4:	ff d6                	call   *%esi
  801be6:	83 c4 10             	add    $0x10,%esp
  801be9:	eb dc                	jmp    801bc7 <vprintfmt+0x3a9>
	if (lflag >= 2)
  801beb:	83 f9 01             	cmp    $0x1,%ecx
  801bee:	7f 1b                	jg     801c0b <vprintfmt+0x3ed>
	else if (lflag)
  801bf0:	85 c9                	test   %ecx,%ecx
  801bf2:	74 2c                	je     801c20 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801bf4:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf7:	8b 10                	mov    (%eax),%edx
  801bf9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bfe:	8d 40 04             	lea    0x4(%eax),%eax
  801c01:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c04:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  801c09:	eb 9f                	jmp    801baa <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801c0b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c0e:	8b 10                	mov    (%eax),%edx
  801c10:	8b 48 04             	mov    0x4(%eax),%ecx
  801c13:	8d 40 08             	lea    0x8(%eax),%eax
  801c16:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c19:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  801c1e:	eb 8a                	jmp    801baa <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801c20:	8b 45 14             	mov    0x14(%ebp),%eax
  801c23:	8b 10                	mov    (%eax),%edx
  801c25:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c2a:	8d 40 04             	lea    0x4(%eax),%eax
  801c2d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c30:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  801c35:	e9 70 ff ff ff       	jmp    801baa <vprintfmt+0x38c>
			putch(ch, putdat);
  801c3a:	83 ec 08             	sub    $0x8,%esp
  801c3d:	53                   	push   %ebx
  801c3e:	6a 25                	push   $0x25
  801c40:	ff d6                	call   *%esi
			break;
  801c42:	83 c4 10             	add    $0x10,%esp
  801c45:	e9 7a ff ff ff       	jmp    801bc4 <vprintfmt+0x3a6>
			putch('%', putdat);
  801c4a:	83 ec 08             	sub    $0x8,%esp
  801c4d:	53                   	push   %ebx
  801c4e:	6a 25                	push   $0x25
  801c50:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801c52:	83 c4 10             	add    $0x10,%esp
  801c55:	89 f8                	mov    %edi,%eax
  801c57:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801c5b:	74 05                	je     801c62 <vprintfmt+0x444>
  801c5d:	83 e8 01             	sub    $0x1,%eax
  801c60:	eb f5                	jmp    801c57 <vprintfmt+0x439>
  801c62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c65:	e9 5a ff ff ff       	jmp    801bc4 <vprintfmt+0x3a6>
}
  801c6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c6d:	5b                   	pop    %ebx
  801c6e:	5e                   	pop    %esi
  801c6f:	5f                   	pop    %edi
  801c70:	5d                   	pop    %ebp
  801c71:	c3                   	ret    

00801c72 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801c72:	f3 0f 1e fb          	endbr32 
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 18             	sub    $0x18,%esp
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801c82:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c85:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801c89:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801c8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801c93:	85 c0                	test   %eax,%eax
  801c95:	74 26                	je     801cbd <vsnprintf+0x4b>
  801c97:	85 d2                	test   %edx,%edx
  801c99:	7e 22                	jle    801cbd <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c9b:	ff 75 14             	pushl  0x14(%ebp)
  801c9e:	ff 75 10             	pushl  0x10(%ebp)
  801ca1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ca4:	50                   	push   %eax
  801ca5:	68 dc 17 80 00       	push   $0x8017dc
  801caa:	e8 6f fb ff ff       	call   80181e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801caf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cb2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb8:	83 c4 10             	add    $0x10,%esp
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    
		return -E_INVAL;
  801cbd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cc2:	eb f7                	jmp    801cbb <vsnprintf+0x49>

00801cc4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801cc4:	f3 0f 1e fb          	endbr32 
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801cce:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801cd1:	50                   	push   %eax
  801cd2:	ff 75 10             	pushl  0x10(%ebp)
  801cd5:	ff 75 0c             	pushl  0xc(%ebp)
  801cd8:	ff 75 08             	pushl  0x8(%ebp)
  801cdb:	e8 92 ff ff ff       	call   801c72 <vsnprintf>
	va_end(ap);

	return rc;
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801ce2:	f3 0f 1e fb          	endbr32 
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801cec:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801cf5:	74 05                	je     801cfc <strlen+0x1a>
		n++;
  801cf7:	83 c0 01             	add    $0x1,%eax
  801cfa:	eb f5                	jmp    801cf1 <strlen+0xf>
	return n;
}
  801cfc:	5d                   	pop    %ebp
  801cfd:	c3                   	ret    

00801cfe <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801cfe:	f3 0f 1e fb          	endbr32 
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
  801d05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d08:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d10:	39 d0                	cmp    %edx,%eax
  801d12:	74 0d                	je     801d21 <strnlen+0x23>
  801d14:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801d18:	74 05                	je     801d1f <strnlen+0x21>
		n++;
  801d1a:	83 c0 01             	add    $0x1,%eax
  801d1d:	eb f1                	jmp    801d10 <strnlen+0x12>
  801d1f:	89 c2                	mov    %eax,%edx
	return n;
}
  801d21:	89 d0                	mov    %edx,%eax
  801d23:	5d                   	pop    %ebp
  801d24:	c3                   	ret    

00801d25 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801d25:	f3 0f 1e fb          	endbr32 
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	53                   	push   %ebx
  801d2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d30:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801d33:	b8 00 00 00 00       	mov    $0x0,%eax
  801d38:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801d3c:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801d3f:	83 c0 01             	add    $0x1,%eax
  801d42:	84 d2                	test   %dl,%dl
  801d44:	75 f2                	jne    801d38 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801d46:	89 c8                	mov    %ecx,%eax
  801d48:	5b                   	pop    %ebx
  801d49:	5d                   	pop    %ebp
  801d4a:	c3                   	ret    

00801d4b <strcat>:

char *
strcat(char *dst, const char *src)
{
  801d4b:	f3 0f 1e fb          	endbr32 
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
  801d52:	53                   	push   %ebx
  801d53:	83 ec 10             	sub    $0x10,%esp
  801d56:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801d59:	53                   	push   %ebx
  801d5a:	e8 83 ff ff ff       	call   801ce2 <strlen>
  801d5f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801d62:	ff 75 0c             	pushl  0xc(%ebp)
  801d65:	01 d8                	add    %ebx,%eax
  801d67:	50                   	push   %eax
  801d68:	e8 b8 ff ff ff       	call   801d25 <strcpy>
	return dst;
}
  801d6d:	89 d8                	mov    %ebx,%eax
  801d6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801d74:	f3 0f 1e fb          	endbr32 
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
  801d7b:	56                   	push   %esi
  801d7c:	53                   	push   %ebx
  801d7d:	8b 75 08             	mov    0x8(%ebp),%esi
  801d80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d83:	89 f3                	mov    %esi,%ebx
  801d85:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801d88:	89 f0                	mov    %esi,%eax
  801d8a:	39 d8                	cmp    %ebx,%eax
  801d8c:	74 11                	je     801d9f <strncpy+0x2b>
		*dst++ = *src;
  801d8e:	83 c0 01             	add    $0x1,%eax
  801d91:	0f b6 0a             	movzbl (%edx),%ecx
  801d94:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801d97:	80 f9 01             	cmp    $0x1,%cl
  801d9a:	83 da ff             	sbb    $0xffffffff,%edx
  801d9d:	eb eb                	jmp    801d8a <strncpy+0x16>
	}
	return ret;
}
  801d9f:	89 f0                	mov    %esi,%eax
  801da1:	5b                   	pop    %ebx
  801da2:	5e                   	pop    %esi
  801da3:	5d                   	pop    %ebp
  801da4:	c3                   	ret    

00801da5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801da5:	f3 0f 1e fb          	endbr32 
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
  801dac:	56                   	push   %esi
  801dad:	53                   	push   %ebx
  801dae:	8b 75 08             	mov    0x8(%ebp),%esi
  801db1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801db4:	8b 55 10             	mov    0x10(%ebp),%edx
  801db7:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801db9:	85 d2                	test   %edx,%edx
  801dbb:	74 21                	je     801dde <strlcpy+0x39>
  801dbd:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801dc1:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801dc3:	39 c2                	cmp    %eax,%edx
  801dc5:	74 14                	je     801ddb <strlcpy+0x36>
  801dc7:	0f b6 19             	movzbl (%ecx),%ebx
  801dca:	84 db                	test   %bl,%bl
  801dcc:	74 0b                	je     801dd9 <strlcpy+0x34>
			*dst++ = *src++;
  801dce:	83 c1 01             	add    $0x1,%ecx
  801dd1:	83 c2 01             	add    $0x1,%edx
  801dd4:	88 5a ff             	mov    %bl,-0x1(%edx)
  801dd7:	eb ea                	jmp    801dc3 <strlcpy+0x1e>
  801dd9:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801ddb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801dde:	29 f0                	sub    %esi,%eax
}
  801de0:	5b                   	pop    %ebx
  801de1:	5e                   	pop    %esi
  801de2:	5d                   	pop    %ebp
  801de3:	c3                   	ret    

00801de4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801de4:	f3 0f 1e fb          	endbr32 
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dee:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801df1:	0f b6 01             	movzbl (%ecx),%eax
  801df4:	84 c0                	test   %al,%al
  801df6:	74 0c                	je     801e04 <strcmp+0x20>
  801df8:	3a 02                	cmp    (%edx),%al
  801dfa:	75 08                	jne    801e04 <strcmp+0x20>
		p++, q++;
  801dfc:	83 c1 01             	add    $0x1,%ecx
  801dff:	83 c2 01             	add    $0x1,%edx
  801e02:	eb ed                	jmp    801df1 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e04:	0f b6 c0             	movzbl %al,%eax
  801e07:	0f b6 12             	movzbl (%edx),%edx
  801e0a:	29 d0                	sub    %edx,%eax
}
  801e0c:	5d                   	pop    %ebp
  801e0d:	c3                   	ret    

00801e0e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801e0e:	f3 0f 1e fb          	endbr32 
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	53                   	push   %ebx
  801e16:	8b 45 08             	mov    0x8(%ebp),%eax
  801e19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1c:	89 c3                	mov    %eax,%ebx
  801e1e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801e21:	eb 06                	jmp    801e29 <strncmp+0x1b>
		n--, p++, q++;
  801e23:	83 c0 01             	add    $0x1,%eax
  801e26:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801e29:	39 d8                	cmp    %ebx,%eax
  801e2b:	74 16                	je     801e43 <strncmp+0x35>
  801e2d:	0f b6 08             	movzbl (%eax),%ecx
  801e30:	84 c9                	test   %cl,%cl
  801e32:	74 04                	je     801e38 <strncmp+0x2a>
  801e34:	3a 0a                	cmp    (%edx),%cl
  801e36:	74 eb                	je     801e23 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801e38:	0f b6 00             	movzbl (%eax),%eax
  801e3b:	0f b6 12             	movzbl (%edx),%edx
  801e3e:	29 d0                	sub    %edx,%eax
}
  801e40:	5b                   	pop    %ebx
  801e41:	5d                   	pop    %ebp
  801e42:	c3                   	ret    
		return 0;
  801e43:	b8 00 00 00 00       	mov    $0x0,%eax
  801e48:	eb f6                	jmp    801e40 <strncmp+0x32>

00801e4a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801e4a:	f3 0f 1e fb          	endbr32 
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	8b 45 08             	mov    0x8(%ebp),%eax
  801e54:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e58:	0f b6 10             	movzbl (%eax),%edx
  801e5b:	84 d2                	test   %dl,%dl
  801e5d:	74 09                	je     801e68 <strchr+0x1e>
		if (*s == c)
  801e5f:	38 ca                	cmp    %cl,%dl
  801e61:	74 0a                	je     801e6d <strchr+0x23>
	for (; *s; s++)
  801e63:	83 c0 01             	add    $0x1,%eax
  801e66:	eb f0                	jmp    801e58 <strchr+0xe>
			return (char *) s;
	return 0;
  801e68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6d:	5d                   	pop    %ebp
  801e6e:	c3                   	ret    

00801e6f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801e6f:	f3 0f 1e fb          	endbr32 
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e7d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801e80:	38 ca                	cmp    %cl,%dl
  801e82:	74 09                	je     801e8d <strfind+0x1e>
  801e84:	84 d2                	test   %dl,%dl
  801e86:	74 05                	je     801e8d <strfind+0x1e>
	for (; *s; s++)
  801e88:	83 c0 01             	add    $0x1,%eax
  801e8b:	eb f0                	jmp    801e7d <strfind+0xe>
			break;
	return (char *) s;
}
  801e8d:	5d                   	pop    %ebp
  801e8e:	c3                   	ret    

00801e8f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801e8f:	f3 0f 1e fb          	endbr32 
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	57                   	push   %edi
  801e97:	56                   	push   %esi
  801e98:	53                   	push   %ebx
  801e99:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e9c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801e9f:	85 c9                	test   %ecx,%ecx
  801ea1:	74 31                	je     801ed4 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801ea3:	89 f8                	mov    %edi,%eax
  801ea5:	09 c8                	or     %ecx,%eax
  801ea7:	a8 03                	test   $0x3,%al
  801ea9:	75 23                	jne    801ece <memset+0x3f>
		c &= 0xFF;
  801eab:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801eaf:	89 d3                	mov    %edx,%ebx
  801eb1:	c1 e3 08             	shl    $0x8,%ebx
  801eb4:	89 d0                	mov    %edx,%eax
  801eb6:	c1 e0 18             	shl    $0x18,%eax
  801eb9:	89 d6                	mov    %edx,%esi
  801ebb:	c1 e6 10             	shl    $0x10,%esi
  801ebe:	09 f0                	or     %esi,%eax
  801ec0:	09 c2                	or     %eax,%edx
  801ec2:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801ec4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801ec7:	89 d0                	mov    %edx,%eax
  801ec9:	fc                   	cld    
  801eca:	f3 ab                	rep stos %eax,%es:(%edi)
  801ecc:	eb 06                	jmp    801ed4 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed1:	fc                   	cld    
  801ed2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801ed4:	89 f8                	mov    %edi,%eax
  801ed6:	5b                   	pop    %ebx
  801ed7:	5e                   	pop    %esi
  801ed8:	5f                   	pop    %edi
  801ed9:	5d                   	pop    %ebp
  801eda:	c3                   	ret    

00801edb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801edb:	f3 0f 1e fb          	endbr32 
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
  801ee2:	57                   	push   %edi
  801ee3:	56                   	push   %esi
  801ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee7:	8b 75 0c             	mov    0xc(%ebp),%esi
  801eea:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801eed:	39 c6                	cmp    %eax,%esi
  801eef:	73 32                	jae    801f23 <memmove+0x48>
  801ef1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801ef4:	39 c2                	cmp    %eax,%edx
  801ef6:	76 2b                	jbe    801f23 <memmove+0x48>
		s += n;
		d += n;
  801ef8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801efb:	89 fe                	mov    %edi,%esi
  801efd:	09 ce                	or     %ecx,%esi
  801eff:	09 d6                	or     %edx,%esi
  801f01:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801f07:	75 0e                	jne    801f17 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801f09:	83 ef 04             	sub    $0x4,%edi
  801f0c:	8d 72 fc             	lea    -0x4(%edx),%esi
  801f0f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801f12:	fd                   	std    
  801f13:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801f15:	eb 09                	jmp    801f20 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801f17:	83 ef 01             	sub    $0x1,%edi
  801f1a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801f1d:	fd                   	std    
  801f1e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801f20:	fc                   	cld    
  801f21:	eb 1a                	jmp    801f3d <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801f23:	89 c2                	mov    %eax,%edx
  801f25:	09 ca                	or     %ecx,%edx
  801f27:	09 f2                	or     %esi,%edx
  801f29:	f6 c2 03             	test   $0x3,%dl
  801f2c:	75 0a                	jne    801f38 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801f2e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801f31:	89 c7                	mov    %eax,%edi
  801f33:	fc                   	cld    
  801f34:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801f36:	eb 05                	jmp    801f3d <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801f38:	89 c7                	mov    %eax,%edi
  801f3a:	fc                   	cld    
  801f3b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801f3d:	5e                   	pop    %esi
  801f3e:	5f                   	pop    %edi
  801f3f:	5d                   	pop    %ebp
  801f40:	c3                   	ret    

00801f41 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801f41:	f3 0f 1e fb          	endbr32 
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801f4b:	ff 75 10             	pushl  0x10(%ebp)
  801f4e:	ff 75 0c             	pushl  0xc(%ebp)
  801f51:	ff 75 08             	pushl  0x8(%ebp)
  801f54:	e8 82 ff ff ff       	call   801edb <memmove>
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801f5b:	f3 0f 1e fb          	endbr32 
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	56                   	push   %esi
  801f63:	53                   	push   %ebx
  801f64:	8b 45 08             	mov    0x8(%ebp),%eax
  801f67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6a:	89 c6                	mov    %eax,%esi
  801f6c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801f6f:	39 f0                	cmp    %esi,%eax
  801f71:	74 1c                	je     801f8f <memcmp+0x34>
		if (*s1 != *s2)
  801f73:	0f b6 08             	movzbl (%eax),%ecx
  801f76:	0f b6 1a             	movzbl (%edx),%ebx
  801f79:	38 d9                	cmp    %bl,%cl
  801f7b:	75 08                	jne    801f85 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801f7d:	83 c0 01             	add    $0x1,%eax
  801f80:	83 c2 01             	add    $0x1,%edx
  801f83:	eb ea                	jmp    801f6f <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801f85:	0f b6 c1             	movzbl %cl,%eax
  801f88:	0f b6 db             	movzbl %bl,%ebx
  801f8b:	29 d8                	sub    %ebx,%eax
  801f8d:	eb 05                	jmp    801f94 <memcmp+0x39>
	}

	return 0;
  801f8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f94:	5b                   	pop    %ebx
  801f95:	5e                   	pop    %esi
  801f96:	5d                   	pop    %ebp
  801f97:	c3                   	ret    

00801f98 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801f98:	f3 0f 1e fb          	endbr32 
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801fa5:	89 c2                	mov    %eax,%edx
  801fa7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801faa:	39 d0                	cmp    %edx,%eax
  801fac:	73 09                	jae    801fb7 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801fae:	38 08                	cmp    %cl,(%eax)
  801fb0:	74 05                	je     801fb7 <memfind+0x1f>
	for (; s < ends; s++)
  801fb2:	83 c0 01             	add    $0x1,%eax
  801fb5:	eb f3                	jmp    801faa <memfind+0x12>
			break;
	return (void *) s;
}
  801fb7:	5d                   	pop    %ebp
  801fb8:	c3                   	ret    

00801fb9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801fb9:	f3 0f 1e fb          	endbr32 
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
  801fc0:	57                   	push   %edi
  801fc1:	56                   	push   %esi
  801fc2:	53                   	push   %ebx
  801fc3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801fc9:	eb 03                	jmp    801fce <strtol+0x15>
		s++;
  801fcb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801fce:	0f b6 01             	movzbl (%ecx),%eax
  801fd1:	3c 20                	cmp    $0x20,%al
  801fd3:	74 f6                	je     801fcb <strtol+0x12>
  801fd5:	3c 09                	cmp    $0x9,%al
  801fd7:	74 f2                	je     801fcb <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801fd9:	3c 2b                	cmp    $0x2b,%al
  801fdb:	74 2a                	je     802007 <strtol+0x4e>
	int neg = 0;
  801fdd:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801fe2:	3c 2d                	cmp    $0x2d,%al
  801fe4:	74 2b                	je     802011 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801fe6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801fec:	75 0f                	jne    801ffd <strtol+0x44>
  801fee:	80 39 30             	cmpb   $0x30,(%ecx)
  801ff1:	74 28                	je     80201b <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801ff3:	85 db                	test   %ebx,%ebx
  801ff5:	b8 0a 00 00 00       	mov    $0xa,%eax
  801ffa:	0f 44 d8             	cmove  %eax,%ebx
  801ffd:	b8 00 00 00 00       	mov    $0x0,%eax
  802002:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802005:	eb 46                	jmp    80204d <strtol+0x94>
		s++;
  802007:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80200a:	bf 00 00 00 00       	mov    $0x0,%edi
  80200f:	eb d5                	jmp    801fe6 <strtol+0x2d>
		s++, neg = 1;
  802011:	83 c1 01             	add    $0x1,%ecx
  802014:	bf 01 00 00 00       	mov    $0x1,%edi
  802019:	eb cb                	jmp    801fe6 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80201b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80201f:	74 0e                	je     80202f <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  802021:	85 db                	test   %ebx,%ebx
  802023:	75 d8                	jne    801ffd <strtol+0x44>
		s++, base = 8;
  802025:	83 c1 01             	add    $0x1,%ecx
  802028:	bb 08 00 00 00       	mov    $0x8,%ebx
  80202d:	eb ce                	jmp    801ffd <strtol+0x44>
		s += 2, base = 16;
  80202f:	83 c1 02             	add    $0x2,%ecx
  802032:	bb 10 00 00 00       	mov    $0x10,%ebx
  802037:	eb c4                	jmp    801ffd <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  802039:	0f be d2             	movsbl %dl,%edx
  80203c:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80203f:	3b 55 10             	cmp    0x10(%ebp),%edx
  802042:	7d 3a                	jge    80207e <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  802044:	83 c1 01             	add    $0x1,%ecx
  802047:	0f af 45 10          	imul   0x10(%ebp),%eax
  80204b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80204d:	0f b6 11             	movzbl (%ecx),%edx
  802050:	8d 72 d0             	lea    -0x30(%edx),%esi
  802053:	89 f3                	mov    %esi,%ebx
  802055:	80 fb 09             	cmp    $0x9,%bl
  802058:	76 df                	jbe    802039 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  80205a:	8d 72 9f             	lea    -0x61(%edx),%esi
  80205d:	89 f3                	mov    %esi,%ebx
  80205f:	80 fb 19             	cmp    $0x19,%bl
  802062:	77 08                	ja     80206c <strtol+0xb3>
			dig = *s - 'a' + 10;
  802064:	0f be d2             	movsbl %dl,%edx
  802067:	83 ea 57             	sub    $0x57,%edx
  80206a:	eb d3                	jmp    80203f <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  80206c:	8d 72 bf             	lea    -0x41(%edx),%esi
  80206f:	89 f3                	mov    %esi,%ebx
  802071:	80 fb 19             	cmp    $0x19,%bl
  802074:	77 08                	ja     80207e <strtol+0xc5>
			dig = *s - 'A' + 10;
  802076:	0f be d2             	movsbl %dl,%edx
  802079:	83 ea 37             	sub    $0x37,%edx
  80207c:	eb c1                	jmp    80203f <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  80207e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802082:	74 05                	je     802089 <strtol+0xd0>
		*endptr = (char *) s;
  802084:	8b 75 0c             	mov    0xc(%ebp),%esi
  802087:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  802089:	89 c2                	mov    %eax,%edx
  80208b:	f7 da                	neg    %edx
  80208d:	85 ff                	test   %edi,%edi
  80208f:	0f 45 c2             	cmovne %edx,%eax
}
  802092:	5b                   	pop    %ebx
  802093:	5e                   	pop    %esi
  802094:	5f                   	pop    %edi
  802095:	5d                   	pop    %ebp
  802096:	c3                   	ret    

00802097 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802097:	f3 0f 1e fb          	endbr32 
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	56                   	push   %esi
  80209f:	53                   	push   %ebx
  8020a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8020a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8020a9:	85 c0                	test   %eax,%eax
  8020ab:	74 3d                	je     8020ea <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8020ad:	83 ec 0c             	sub    $0xc,%esp
  8020b0:	50                   	push   %eax
  8020b1:	e8 88 e2 ff ff       	call   80033e <sys_ipc_recv>
  8020b6:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8020b9:	85 f6                	test   %esi,%esi
  8020bb:	74 0b                	je     8020c8 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8020bd:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020c3:	8b 52 74             	mov    0x74(%edx),%edx
  8020c6:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8020c8:	85 db                	test   %ebx,%ebx
  8020ca:	74 0b                	je     8020d7 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8020cc:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020d2:	8b 52 78             	mov    0x78(%edx),%edx
  8020d5:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8020d7:	85 c0                	test   %eax,%eax
  8020d9:	78 21                	js     8020fc <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8020db:	a1 08 40 80 00       	mov    0x804008,%eax
  8020e0:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e6:	5b                   	pop    %ebx
  8020e7:	5e                   	pop    %esi
  8020e8:	5d                   	pop    %ebp
  8020e9:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8020ea:	83 ec 0c             	sub    $0xc,%esp
  8020ed:	68 00 00 c0 ee       	push   $0xeec00000
  8020f2:	e8 47 e2 ff ff       	call   80033e <sys_ipc_recv>
  8020f7:	83 c4 10             	add    $0x10,%esp
  8020fa:	eb bd                	jmp    8020b9 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  8020fc:	85 f6                	test   %esi,%esi
  8020fe:	74 10                	je     802110 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802100:	85 db                	test   %ebx,%ebx
  802102:	75 df                	jne    8020e3 <ipc_recv+0x4c>
  802104:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80210b:	00 00 00 
  80210e:	eb d3                	jmp    8020e3 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802110:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802117:	00 00 00 
  80211a:	eb e4                	jmp    802100 <ipc_recv+0x69>

0080211c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80211c:	f3 0f 1e fb          	endbr32 
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
  802123:	57                   	push   %edi
  802124:	56                   	push   %esi
  802125:	53                   	push   %ebx
  802126:	83 ec 0c             	sub    $0xc,%esp
  802129:	8b 7d 08             	mov    0x8(%ebp),%edi
  80212c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80212f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802132:	85 db                	test   %ebx,%ebx
  802134:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802139:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  80213c:	ff 75 14             	pushl  0x14(%ebp)
  80213f:	53                   	push   %ebx
  802140:	56                   	push   %esi
  802141:	57                   	push   %edi
  802142:	e8 d0 e1 ff ff       	call   800317 <sys_ipc_try_send>
  802147:	83 c4 10             	add    $0x10,%esp
  80214a:	85 c0                	test   %eax,%eax
  80214c:	79 1e                	jns    80216c <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  80214e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802151:	75 07                	jne    80215a <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802153:	e8 f7 df ff ff       	call   80014f <sys_yield>
  802158:	eb e2                	jmp    80213c <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  80215a:	50                   	push   %eax
  80215b:	68 df 28 80 00       	push   $0x8028df
  802160:	6a 59                	push   $0x59
  802162:	68 fa 28 80 00       	push   $0x8028fa
  802167:	e8 c8 f4 ff ff       	call   801634 <_panic>
	}
}
  80216c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80216f:	5b                   	pop    %ebx
  802170:	5e                   	pop    %esi
  802171:	5f                   	pop    %edi
  802172:	5d                   	pop    %ebp
  802173:	c3                   	ret    

00802174 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802174:	f3 0f 1e fb          	endbr32 
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
  80217b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80217e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802183:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802186:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80218c:	8b 52 50             	mov    0x50(%edx),%edx
  80218f:	39 ca                	cmp    %ecx,%edx
  802191:	74 11                	je     8021a4 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802193:	83 c0 01             	add    $0x1,%eax
  802196:	3d 00 04 00 00       	cmp    $0x400,%eax
  80219b:	75 e6                	jne    802183 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80219d:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a2:	eb 0b                	jmp    8021af <ipc_find_env+0x3b>
			return envs[i].env_id;
  8021a4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021a7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021ac:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021af:	5d                   	pop    %ebp
  8021b0:	c3                   	ret    

008021b1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021b1:	f3 0f 1e fb          	endbr32 
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021bb:	89 c2                	mov    %eax,%edx
  8021bd:	c1 ea 16             	shr    $0x16,%edx
  8021c0:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8021c7:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021cc:	f6 c1 01             	test   $0x1,%cl
  8021cf:	74 1c                	je     8021ed <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8021d1:	c1 e8 0c             	shr    $0xc,%eax
  8021d4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8021db:	a8 01                	test   $0x1,%al
  8021dd:	74 0e                	je     8021ed <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021df:	c1 e8 0c             	shr    $0xc,%eax
  8021e2:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8021e9:	ef 
  8021ea:	0f b7 d2             	movzwl %dx,%edx
}
  8021ed:	89 d0                	mov    %edx,%eax
  8021ef:	5d                   	pop    %ebp
  8021f0:	c3                   	ret    
  8021f1:	66 90                	xchg   %ax,%ax
  8021f3:	66 90                	xchg   %ax,%ax
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
