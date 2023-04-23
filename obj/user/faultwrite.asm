
obj/user/faultwrite.debug:     file format elf32-i386


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
  80002c:	e8 11 00 00 00       	call   800042 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
	*(unsigned*)0 = 0;
  800037:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80003e:	00 00 00 
}
  800041:	c3                   	ret    

00800042 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800042:	f3 0f 1e fb          	endbr32 
  800046:	55                   	push   %ebp
  800047:	89 e5                	mov    %esp,%ebp
  800049:	56                   	push   %esi
  80004a:	53                   	push   %ebx
  80004b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800051:	e8 de 00 00 00       	call   800134 <sys_getenvid>
  800056:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800063:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800068:	85 db                	test   %ebx,%ebx
  80006a:	7e 07                	jle    800073 <libmain+0x31>
		binaryname = argv[0];
  80006c:	8b 06                	mov    (%esi),%eax
  80006e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800073:	83 ec 08             	sub    $0x8,%esp
  800076:	56                   	push   %esi
  800077:	53                   	push   %ebx
  800078:	e8 b6 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80007d:	e8 0a 00 00 00       	call   80008c <exit>
}
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800088:	5b                   	pop    %ebx
  800089:	5e                   	pop    %esi
  80008a:	5d                   	pop    %ebp
  80008b:	c3                   	ret    

0080008c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80008c:	f3 0f 1e fb          	endbr32 
  800090:	55                   	push   %ebp
  800091:	89 e5                	mov    %esp,%ebp
  800093:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800096:	e8 93 05 00 00       	call   80062e <close_all>
	sys_env_destroy(0);
  80009b:	83 ec 0c             	sub    $0xc,%esp
  80009e:	6a 00                	push   $0x0
  8000a0:	e8 4a 00 00 00       	call   8000ef <sys_env_destroy>
}
  8000a5:	83 c4 10             	add    $0x10,%esp
  8000a8:	c9                   	leave  
  8000a9:	c3                   	ret    

008000aa <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000aa:	f3 0f 1e fb          	endbr32 
  8000ae:	55                   	push   %ebp
  8000af:	89 e5                	mov    %esp,%ebp
  8000b1:	57                   	push   %edi
  8000b2:	56                   	push   %esi
  8000b3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000bf:	89 c3                	mov    %eax,%ebx
  8000c1:	89 c7                	mov    %eax,%edi
  8000c3:	89 c6                	mov    %eax,%esi
  8000c5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c7:	5b                   	pop    %ebx
  8000c8:	5e                   	pop    %esi
  8000c9:	5f                   	pop    %edi
  8000ca:	5d                   	pop    %ebp
  8000cb:	c3                   	ret    

008000cc <sys_cgetc>:

int
sys_cgetc(void)
{
  8000cc:	f3 0f 1e fb          	endbr32 
  8000d0:	55                   	push   %ebp
  8000d1:	89 e5                	mov    %esp,%ebp
  8000d3:	57                   	push   %edi
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000db:	b8 01 00 00 00       	mov    $0x1,%eax
  8000e0:	89 d1                	mov    %edx,%ecx
  8000e2:	89 d3                	mov    %edx,%ebx
  8000e4:	89 d7                	mov    %edx,%edi
  8000e6:	89 d6                	mov    %edx,%esi
  8000e8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000ea:	5b                   	pop    %ebx
  8000eb:	5e                   	pop    %esi
  8000ec:	5f                   	pop    %edi
  8000ed:	5d                   	pop    %ebp
  8000ee:	c3                   	ret    

008000ef <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000ef:	f3 0f 1e fb          	endbr32 
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	57                   	push   %edi
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800101:	8b 55 08             	mov    0x8(%ebp),%edx
  800104:	b8 03 00 00 00       	mov    $0x3,%eax
  800109:	89 cb                	mov    %ecx,%ebx
  80010b:	89 cf                	mov    %ecx,%edi
  80010d:	89 ce                	mov    %ecx,%esi
  80010f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800111:	85 c0                	test   %eax,%eax
  800113:	7f 08                	jg     80011d <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800115:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800118:	5b                   	pop    %ebx
  800119:	5e                   	pop    %esi
  80011a:	5f                   	pop    %edi
  80011b:	5d                   	pop    %ebp
  80011c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80011d:	83 ec 0c             	sub    $0xc,%esp
  800120:	50                   	push   %eax
  800121:	6a 03                	push   $0x3
  800123:	68 6a 24 80 00       	push   $0x80246a
  800128:	6a 23                	push   $0x23
  80012a:	68 87 24 80 00       	push   $0x802487
  80012f:	e8 08 15 00 00       	call   80163c <_panic>

00800134 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800134:	f3 0f 1e fb          	endbr32 
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	57                   	push   %edi
  80013c:	56                   	push   %esi
  80013d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80013e:	ba 00 00 00 00       	mov    $0x0,%edx
  800143:	b8 02 00 00 00       	mov    $0x2,%eax
  800148:	89 d1                	mov    %edx,%ecx
  80014a:	89 d3                	mov    %edx,%ebx
  80014c:	89 d7                	mov    %edx,%edi
  80014e:	89 d6                	mov    %edx,%esi
  800150:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800152:	5b                   	pop    %ebx
  800153:	5e                   	pop    %esi
  800154:	5f                   	pop    %edi
  800155:	5d                   	pop    %ebp
  800156:	c3                   	ret    

00800157 <sys_yield>:

void
sys_yield(void)
{
  800157:	f3 0f 1e fb          	endbr32 
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	57                   	push   %edi
  80015f:	56                   	push   %esi
  800160:	53                   	push   %ebx
	asm volatile("int %1\n"
  800161:	ba 00 00 00 00       	mov    $0x0,%edx
  800166:	b8 0b 00 00 00       	mov    $0xb,%eax
  80016b:	89 d1                	mov    %edx,%ecx
  80016d:	89 d3                	mov    %edx,%ebx
  80016f:	89 d7                	mov    %edx,%edi
  800171:	89 d6                	mov    %edx,%esi
  800173:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800175:	5b                   	pop    %ebx
  800176:	5e                   	pop    %esi
  800177:	5f                   	pop    %edi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    

0080017a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80017a:	f3 0f 1e fb          	endbr32 
  80017e:	55                   	push   %ebp
  80017f:	89 e5                	mov    %esp,%ebp
  800181:	57                   	push   %edi
  800182:	56                   	push   %esi
  800183:	53                   	push   %ebx
  800184:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800187:	be 00 00 00 00       	mov    $0x0,%esi
  80018c:	8b 55 08             	mov    0x8(%ebp),%edx
  80018f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800192:	b8 04 00 00 00       	mov    $0x4,%eax
  800197:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80019a:	89 f7                	mov    %esi,%edi
  80019c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80019e:	85 c0                	test   %eax,%eax
  8001a0:	7f 08                	jg     8001aa <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a5:	5b                   	pop    %ebx
  8001a6:	5e                   	pop    %esi
  8001a7:	5f                   	pop    %edi
  8001a8:	5d                   	pop    %ebp
  8001a9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001aa:	83 ec 0c             	sub    $0xc,%esp
  8001ad:	50                   	push   %eax
  8001ae:	6a 04                	push   $0x4
  8001b0:	68 6a 24 80 00       	push   $0x80246a
  8001b5:	6a 23                	push   $0x23
  8001b7:	68 87 24 80 00       	push   $0x802487
  8001bc:	e8 7b 14 00 00       	call   80163c <_panic>

008001c1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001c1:	f3 0f 1e fb          	endbr32 
  8001c5:	55                   	push   %ebp
  8001c6:	89 e5                	mov    %esp,%ebp
  8001c8:	57                   	push   %edi
  8001c9:	56                   	push   %esi
  8001ca:	53                   	push   %ebx
  8001cb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001d4:	b8 05 00 00 00       	mov    $0x5,%eax
  8001d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001dc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001df:	8b 75 18             	mov    0x18(%ebp),%esi
  8001e2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001e4:	85 c0                	test   %eax,%eax
  8001e6:	7f 08                	jg     8001f0 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001eb:	5b                   	pop    %ebx
  8001ec:	5e                   	pop    %esi
  8001ed:	5f                   	pop    %edi
  8001ee:	5d                   	pop    %ebp
  8001ef:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	50                   	push   %eax
  8001f4:	6a 05                	push   $0x5
  8001f6:	68 6a 24 80 00       	push   $0x80246a
  8001fb:	6a 23                	push   $0x23
  8001fd:	68 87 24 80 00       	push   $0x802487
  800202:	e8 35 14 00 00       	call   80163c <_panic>

00800207 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800207:	f3 0f 1e fb          	endbr32 
  80020b:	55                   	push   %ebp
  80020c:	89 e5                	mov    %esp,%ebp
  80020e:	57                   	push   %edi
  80020f:	56                   	push   %esi
  800210:	53                   	push   %ebx
  800211:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800214:	bb 00 00 00 00       	mov    $0x0,%ebx
  800219:	8b 55 08             	mov    0x8(%ebp),%edx
  80021c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80021f:	b8 06 00 00 00       	mov    $0x6,%eax
  800224:	89 df                	mov    %ebx,%edi
  800226:	89 de                	mov    %ebx,%esi
  800228:	cd 30                	int    $0x30
	if(check && ret > 0)
  80022a:	85 c0                	test   %eax,%eax
  80022c:	7f 08                	jg     800236 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80022e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800231:	5b                   	pop    %ebx
  800232:	5e                   	pop    %esi
  800233:	5f                   	pop    %edi
  800234:	5d                   	pop    %ebp
  800235:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	50                   	push   %eax
  80023a:	6a 06                	push   $0x6
  80023c:	68 6a 24 80 00       	push   $0x80246a
  800241:	6a 23                	push   $0x23
  800243:	68 87 24 80 00       	push   $0x802487
  800248:	e8 ef 13 00 00       	call   80163c <_panic>

0080024d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80024d:	f3 0f 1e fb          	endbr32 
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	57                   	push   %edi
  800255:	56                   	push   %esi
  800256:	53                   	push   %ebx
  800257:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80025a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80025f:	8b 55 08             	mov    0x8(%ebp),%edx
  800262:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800265:	b8 08 00 00 00       	mov    $0x8,%eax
  80026a:	89 df                	mov    %ebx,%edi
  80026c:	89 de                	mov    %ebx,%esi
  80026e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800270:	85 c0                	test   %eax,%eax
  800272:	7f 08                	jg     80027c <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800274:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800277:	5b                   	pop    %ebx
  800278:	5e                   	pop    %esi
  800279:	5f                   	pop    %edi
  80027a:	5d                   	pop    %ebp
  80027b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	50                   	push   %eax
  800280:	6a 08                	push   $0x8
  800282:	68 6a 24 80 00       	push   $0x80246a
  800287:	6a 23                	push   $0x23
  800289:	68 87 24 80 00       	push   $0x802487
  80028e:	e8 a9 13 00 00       	call   80163c <_panic>

00800293 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800293:	f3 0f 1e fb          	endbr32 
  800297:	55                   	push   %ebp
  800298:	89 e5                	mov    %esp,%ebp
  80029a:	57                   	push   %edi
  80029b:	56                   	push   %esi
  80029c:	53                   	push   %ebx
  80029d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ab:	b8 09 00 00 00       	mov    $0x9,%eax
  8002b0:	89 df                	mov    %ebx,%edi
  8002b2:	89 de                	mov    %ebx,%esi
  8002b4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002b6:	85 c0                	test   %eax,%eax
  8002b8:	7f 08                	jg     8002c2 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bd:	5b                   	pop    %ebx
  8002be:	5e                   	pop    %esi
  8002bf:	5f                   	pop    %edi
  8002c0:	5d                   	pop    %ebp
  8002c1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002c2:	83 ec 0c             	sub    $0xc,%esp
  8002c5:	50                   	push   %eax
  8002c6:	6a 09                	push   $0x9
  8002c8:	68 6a 24 80 00       	push   $0x80246a
  8002cd:	6a 23                	push   $0x23
  8002cf:	68 87 24 80 00       	push   $0x802487
  8002d4:	e8 63 13 00 00       	call   80163c <_panic>

008002d9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002d9:	f3 0f 1e fb          	endbr32 
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	57                   	push   %edi
  8002e1:	56                   	push   %esi
  8002e2:	53                   	push   %ebx
  8002e3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002f6:	89 df                	mov    %ebx,%edi
  8002f8:	89 de                	mov    %ebx,%esi
  8002fa:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002fc:	85 c0                	test   %eax,%eax
  8002fe:	7f 08                	jg     800308 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800300:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800303:	5b                   	pop    %ebx
  800304:	5e                   	pop    %esi
  800305:	5f                   	pop    %edi
  800306:	5d                   	pop    %ebp
  800307:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	50                   	push   %eax
  80030c:	6a 0a                	push   $0xa
  80030e:	68 6a 24 80 00       	push   $0x80246a
  800313:	6a 23                	push   $0x23
  800315:	68 87 24 80 00       	push   $0x802487
  80031a:	e8 1d 13 00 00       	call   80163c <_panic>

0080031f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80031f:	f3 0f 1e fb          	endbr32 
  800323:	55                   	push   %ebp
  800324:	89 e5                	mov    %esp,%ebp
  800326:	57                   	push   %edi
  800327:	56                   	push   %esi
  800328:	53                   	push   %ebx
	asm volatile("int %1\n"
  800329:	8b 55 08             	mov    0x8(%ebp),%edx
  80032c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80032f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800334:	be 00 00 00 00       	mov    $0x0,%esi
  800339:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80033c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80033f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800341:	5b                   	pop    %ebx
  800342:	5e                   	pop    %esi
  800343:	5f                   	pop    %edi
  800344:	5d                   	pop    %ebp
  800345:	c3                   	ret    

00800346 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800346:	f3 0f 1e fb          	endbr32 
  80034a:	55                   	push   %ebp
  80034b:	89 e5                	mov    %esp,%ebp
  80034d:	57                   	push   %edi
  80034e:	56                   	push   %esi
  80034f:	53                   	push   %ebx
  800350:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800353:	b9 00 00 00 00       	mov    $0x0,%ecx
  800358:	8b 55 08             	mov    0x8(%ebp),%edx
  80035b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800360:	89 cb                	mov    %ecx,%ebx
  800362:	89 cf                	mov    %ecx,%edi
  800364:	89 ce                	mov    %ecx,%esi
  800366:	cd 30                	int    $0x30
	if(check && ret > 0)
  800368:	85 c0                	test   %eax,%eax
  80036a:	7f 08                	jg     800374 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80036c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80036f:	5b                   	pop    %ebx
  800370:	5e                   	pop    %esi
  800371:	5f                   	pop    %edi
  800372:	5d                   	pop    %ebp
  800373:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800374:	83 ec 0c             	sub    $0xc,%esp
  800377:	50                   	push   %eax
  800378:	6a 0d                	push   $0xd
  80037a:	68 6a 24 80 00       	push   $0x80246a
  80037f:	6a 23                	push   $0x23
  800381:	68 87 24 80 00       	push   $0x802487
  800386:	e8 b1 12 00 00       	call   80163c <_panic>

0080038b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80038b:	f3 0f 1e fb          	endbr32 
  80038f:	55                   	push   %ebp
  800390:	89 e5                	mov    %esp,%ebp
  800392:	57                   	push   %edi
  800393:	56                   	push   %esi
  800394:	53                   	push   %ebx
	asm volatile("int %1\n"
  800395:	ba 00 00 00 00       	mov    $0x0,%edx
  80039a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80039f:	89 d1                	mov    %edx,%ecx
  8003a1:	89 d3                	mov    %edx,%ebx
  8003a3:	89 d7                	mov    %edx,%edi
  8003a5:	89 d6                	mov    %edx,%esi
  8003a7:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003a9:	5b                   	pop    %ebx
  8003aa:	5e                   	pop    %esi
  8003ab:	5f                   	pop    %edi
  8003ac:	5d                   	pop    %ebp
  8003ad:	c3                   	ret    

008003ae <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  8003ae:	f3 0f 1e fb          	endbr32 
  8003b2:	55                   	push   %ebp
  8003b3:	89 e5                	mov    %esp,%ebp
  8003b5:	57                   	push   %edi
  8003b6:	56                   	push   %esi
  8003b7:	53                   	push   %ebx
  8003b8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8003bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003c6:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003cb:	89 df                	mov    %ebx,%edi
  8003cd:	89 de                	mov    %ebx,%esi
  8003cf:	cd 30                	int    $0x30
	if(check && ret > 0)
  8003d1:	85 c0                	test   %eax,%eax
  8003d3:	7f 08                	jg     8003dd <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  8003d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003d8:	5b                   	pop    %ebx
  8003d9:	5e                   	pop    %esi
  8003da:	5f                   	pop    %edi
  8003db:	5d                   	pop    %ebp
  8003dc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8003dd:	83 ec 0c             	sub    $0xc,%esp
  8003e0:	50                   	push   %eax
  8003e1:	6a 0f                	push   $0xf
  8003e3:	68 6a 24 80 00       	push   $0x80246a
  8003e8:	6a 23                	push   $0x23
  8003ea:	68 87 24 80 00       	push   $0x802487
  8003ef:	e8 48 12 00 00       	call   80163c <_panic>

008003f4 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  8003f4:	f3 0f 1e fb          	endbr32 
  8003f8:	55                   	push   %ebp
  8003f9:	89 e5                	mov    %esp,%ebp
  8003fb:	57                   	push   %edi
  8003fc:	56                   	push   %esi
  8003fd:	53                   	push   %ebx
  8003fe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800401:	bb 00 00 00 00       	mov    $0x0,%ebx
  800406:	8b 55 08             	mov    0x8(%ebp),%edx
  800409:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80040c:	b8 10 00 00 00       	mov    $0x10,%eax
  800411:	89 df                	mov    %ebx,%edi
  800413:	89 de                	mov    %ebx,%esi
  800415:	cd 30                	int    $0x30
	if(check && ret > 0)
  800417:	85 c0                	test   %eax,%eax
  800419:	7f 08                	jg     800423 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  80041b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80041e:	5b                   	pop    %ebx
  80041f:	5e                   	pop    %esi
  800420:	5f                   	pop    %edi
  800421:	5d                   	pop    %ebp
  800422:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800423:	83 ec 0c             	sub    $0xc,%esp
  800426:	50                   	push   %eax
  800427:	6a 10                	push   $0x10
  800429:	68 6a 24 80 00       	push   $0x80246a
  80042e:	6a 23                	push   $0x23
  800430:	68 87 24 80 00       	push   $0x802487
  800435:	e8 02 12 00 00       	call   80163c <_panic>

0080043a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80043a:	f3 0f 1e fb          	endbr32 
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800441:	8b 45 08             	mov    0x8(%ebp),%eax
  800444:	05 00 00 00 30       	add    $0x30000000,%eax
  800449:	c1 e8 0c             	shr    $0xc,%eax
}
  80044c:	5d                   	pop    %ebp
  80044d:	c3                   	ret    

0080044e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80044e:	f3 0f 1e fb          	endbr32 
  800452:	55                   	push   %ebp
  800453:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800455:	8b 45 08             	mov    0x8(%ebp),%eax
  800458:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80045d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800462:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800467:	5d                   	pop    %ebp
  800468:	c3                   	ret    

00800469 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800469:	f3 0f 1e fb          	endbr32 
  80046d:	55                   	push   %ebp
  80046e:	89 e5                	mov    %esp,%ebp
  800470:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800475:	89 c2                	mov    %eax,%edx
  800477:	c1 ea 16             	shr    $0x16,%edx
  80047a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800481:	f6 c2 01             	test   $0x1,%dl
  800484:	74 2d                	je     8004b3 <fd_alloc+0x4a>
  800486:	89 c2                	mov    %eax,%edx
  800488:	c1 ea 0c             	shr    $0xc,%edx
  80048b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800492:	f6 c2 01             	test   $0x1,%dl
  800495:	74 1c                	je     8004b3 <fd_alloc+0x4a>
  800497:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80049c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8004a1:	75 d2                	jne    800475 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8004a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8004ac:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8004b1:	eb 0a                	jmp    8004bd <fd_alloc+0x54>
			*fd_store = fd;
  8004b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004b6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004bd:	5d                   	pop    %ebp
  8004be:	c3                   	ret    

008004bf <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8004bf:	f3 0f 1e fb          	endbr32 
  8004c3:	55                   	push   %ebp
  8004c4:	89 e5                	mov    %esp,%ebp
  8004c6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8004c9:	83 f8 1f             	cmp    $0x1f,%eax
  8004cc:	77 30                	ja     8004fe <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8004ce:	c1 e0 0c             	shl    $0xc,%eax
  8004d1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8004d6:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8004dc:	f6 c2 01             	test   $0x1,%dl
  8004df:	74 24                	je     800505 <fd_lookup+0x46>
  8004e1:	89 c2                	mov    %eax,%edx
  8004e3:	c1 ea 0c             	shr    $0xc,%edx
  8004e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004ed:	f6 c2 01             	test   $0x1,%dl
  8004f0:	74 1a                	je     80050c <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8004f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f5:	89 02                	mov    %eax,(%edx)
	return 0;
  8004f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004fc:	5d                   	pop    %ebp
  8004fd:	c3                   	ret    
		return -E_INVAL;
  8004fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800503:	eb f7                	jmp    8004fc <fd_lookup+0x3d>
		return -E_INVAL;
  800505:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80050a:	eb f0                	jmp    8004fc <fd_lookup+0x3d>
  80050c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800511:	eb e9                	jmp    8004fc <fd_lookup+0x3d>

00800513 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800513:	f3 0f 1e fb          	endbr32 
  800517:	55                   	push   %ebp
  800518:	89 e5                	mov    %esp,%ebp
  80051a:	83 ec 08             	sub    $0x8,%esp
  80051d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800520:	ba 00 00 00 00       	mov    $0x0,%edx
  800525:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80052a:	39 08                	cmp    %ecx,(%eax)
  80052c:	74 38                	je     800566 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80052e:	83 c2 01             	add    $0x1,%edx
  800531:	8b 04 95 14 25 80 00 	mov    0x802514(,%edx,4),%eax
  800538:	85 c0                	test   %eax,%eax
  80053a:	75 ee                	jne    80052a <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80053c:	a1 08 40 80 00       	mov    0x804008,%eax
  800541:	8b 40 48             	mov    0x48(%eax),%eax
  800544:	83 ec 04             	sub    $0x4,%esp
  800547:	51                   	push   %ecx
  800548:	50                   	push   %eax
  800549:	68 98 24 80 00       	push   $0x802498
  80054e:	e8 d0 11 00 00       	call   801723 <cprintf>
	*dev = 0;
  800553:	8b 45 0c             	mov    0xc(%ebp),%eax
  800556:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800564:	c9                   	leave  
  800565:	c3                   	ret    
			*dev = devtab[i];
  800566:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800569:	89 01                	mov    %eax,(%ecx)
			return 0;
  80056b:	b8 00 00 00 00       	mov    $0x0,%eax
  800570:	eb f2                	jmp    800564 <dev_lookup+0x51>

00800572 <fd_close>:
{
  800572:	f3 0f 1e fb          	endbr32 
  800576:	55                   	push   %ebp
  800577:	89 e5                	mov    %esp,%ebp
  800579:	57                   	push   %edi
  80057a:	56                   	push   %esi
  80057b:	53                   	push   %ebx
  80057c:	83 ec 24             	sub    $0x24,%esp
  80057f:	8b 75 08             	mov    0x8(%ebp),%esi
  800582:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800585:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800588:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800589:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80058f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800592:	50                   	push   %eax
  800593:	e8 27 ff ff ff       	call   8004bf <fd_lookup>
  800598:	89 c3                	mov    %eax,%ebx
  80059a:	83 c4 10             	add    $0x10,%esp
  80059d:	85 c0                	test   %eax,%eax
  80059f:	78 05                	js     8005a6 <fd_close+0x34>
	    || fd != fd2)
  8005a1:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8005a4:	74 16                	je     8005bc <fd_close+0x4a>
		return (must_exist ? r : 0);
  8005a6:	89 f8                	mov    %edi,%eax
  8005a8:	84 c0                	test   %al,%al
  8005aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8005af:	0f 44 d8             	cmove  %eax,%ebx
}
  8005b2:	89 d8                	mov    %ebx,%eax
  8005b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005b7:	5b                   	pop    %ebx
  8005b8:	5e                   	pop    %esi
  8005b9:	5f                   	pop    %edi
  8005ba:	5d                   	pop    %ebp
  8005bb:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8005bc:	83 ec 08             	sub    $0x8,%esp
  8005bf:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8005c2:	50                   	push   %eax
  8005c3:	ff 36                	pushl  (%esi)
  8005c5:	e8 49 ff ff ff       	call   800513 <dev_lookup>
  8005ca:	89 c3                	mov    %eax,%ebx
  8005cc:	83 c4 10             	add    $0x10,%esp
  8005cf:	85 c0                	test   %eax,%eax
  8005d1:	78 1a                	js     8005ed <fd_close+0x7b>
		if (dev->dev_close)
  8005d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d6:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8005d9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8005de:	85 c0                	test   %eax,%eax
  8005e0:	74 0b                	je     8005ed <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8005e2:	83 ec 0c             	sub    $0xc,%esp
  8005e5:	56                   	push   %esi
  8005e6:	ff d0                	call   *%eax
  8005e8:	89 c3                	mov    %eax,%ebx
  8005ea:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8005ed:	83 ec 08             	sub    $0x8,%esp
  8005f0:	56                   	push   %esi
  8005f1:	6a 00                	push   $0x0
  8005f3:	e8 0f fc ff ff       	call   800207 <sys_page_unmap>
	return r;
  8005f8:	83 c4 10             	add    $0x10,%esp
  8005fb:	eb b5                	jmp    8005b2 <fd_close+0x40>

008005fd <close>:

int
close(int fdnum)
{
  8005fd:	f3 0f 1e fb          	endbr32 
  800601:	55                   	push   %ebp
  800602:	89 e5                	mov    %esp,%ebp
  800604:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800607:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80060a:	50                   	push   %eax
  80060b:	ff 75 08             	pushl  0x8(%ebp)
  80060e:	e8 ac fe ff ff       	call   8004bf <fd_lookup>
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	85 c0                	test   %eax,%eax
  800618:	79 02                	jns    80061c <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80061a:	c9                   	leave  
  80061b:	c3                   	ret    
		return fd_close(fd, 1);
  80061c:	83 ec 08             	sub    $0x8,%esp
  80061f:	6a 01                	push   $0x1
  800621:	ff 75 f4             	pushl  -0xc(%ebp)
  800624:	e8 49 ff ff ff       	call   800572 <fd_close>
  800629:	83 c4 10             	add    $0x10,%esp
  80062c:	eb ec                	jmp    80061a <close+0x1d>

0080062e <close_all>:

void
close_all(void)
{
  80062e:	f3 0f 1e fb          	endbr32 
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
  800635:	53                   	push   %ebx
  800636:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800639:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80063e:	83 ec 0c             	sub    $0xc,%esp
  800641:	53                   	push   %ebx
  800642:	e8 b6 ff ff ff       	call   8005fd <close>
	for (i = 0; i < MAXFD; i++)
  800647:	83 c3 01             	add    $0x1,%ebx
  80064a:	83 c4 10             	add    $0x10,%esp
  80064d:	83 fb 20             	cmp    $0x20,%ebx
  800650:	75 ec                	jne    80063e <close_all+0x10>
}
  800652:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800655:	c9                   	leave  
  800656:	c3                   	ret    

00800657 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800657:	f3 0f 1e fb          	endbr32 
  80065b:	55                   	push   %ebp
  80065c:	89 e5                	mov    %esp,%ebp
  80065e:	57                   	push   %edi
  80065f:	56                   	push   %esi
  800660:	53                   	push   %ebx
  800661:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800664:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800667:	50                   	push   %eax
  800668:	ff 75 08             	pushl  0x8(%ebp)
  80066b:	e8 4f fe ff ff       	call   8004bf <fd_lookup>
  800670:	89 c3                	mov    %eax,%ebx
  800672:	83 c4 10             	add    $0x10,%esp
  800675:	85 c0                	test   %eax,%eax
  800677:	0f 88 81 00 00 00    	js     8006fe <dup+0xa7>
		return r;
	close(newfdnum);
  80067d:	83 ec 0c             	sub    $0xc,%esp
  800680:	ff 75 0c             	pushl  0xc(%ebp)
  800683:	e8 75 ff ff ff       	call   8005fd <close>

	newfd = INDEX2FD(newfdnum);
  800688:	8b 75 0c             	mov    0xc(%ebp),%esi
  80068b:	c1 e6 0c             	shl    $0xc,%esi
  80068e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800694:	83 c4 04             	add    $0x4,%esp
  800697:	ff 75 e4             	pushl  -0x1c(%ebp)
  80069a:	e8 af fd ff ff       	call   80044e <fd2data>
  80069f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8006a1:	89 34 24             	mov    %esi,(%esp)
  8006a4:	e8 a5 fd ff ff       	call   80044e <fd2data>
  8006a9:	83 c4 10             	add    $0x10,%esp
  8006ac:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8006ae:	89 d8                	mov    %ebx,%eax
  8006b0:	c1 e8 16             	shr    $0x16,%eax
  8006b3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8006ba:	a8 01                	test   $0x1,%al
  8006bc:	74 11                	je     8006cf <dup+0x78>
  8006be:	89 d8                	mov    %ebx,%eax
  8006c0:	c1 e8 0c             	shr    $0xc,%eax
  8006c3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8006ca:	f6 c2 01             	test   $0x1,%dl
  8006cd:	75 39                	jne    800708 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8006cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006d2:	89 d0                	mov    %edx,%eax
  8006d4:	c1 e8 0c             	shr    $0xc,%eax
  8006d7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006de:	83 ec 0c             	sub    $0xc,%esp
  8006e1:	25 07 0e 00 00       	and    $0xe07,%eax
  8006e6:	50                   	push   %eax
  8006e7:	56                   	push   %esi
  8006e8:	6a 00                	push   $0x0
  8006ea:	52                   	push   %edx
  8006eb:	6a 00                	push   $0x0
  8006ed:	e8 cf fa ff ff       	call   8001c1 <sys_page_map>
  8006f2:	89 c3                	mov    %eax,%ebx
  8006f4:	83 c4 20             	add    $0x20,%esp
  8006f7:	85 c0                	test   %eax,%eax
  8006f9:	78 31                	js     80072c <dup+0xd5>
		goto err;

	return newfdnum;
  8006fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8006fe:	89 d8                	mov    %ebx,%eax
  800700:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800703:	5b                   	pop    %ebx
  800704:	5e                   	pop    %esi
  800705:	5f                   	pop    %edi
  800706:	5d                   	pop    %ebp
  800707:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800708:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80070f:	83 ec 0c             	sub    $0xc,%esp
  800712:	25 07 0e 00 00       	and    $0xe07,%eax
  800717:	50                   	push   %eax
  800718:	57                   	push   %edi
  800719:	6a 00                	push   $0x0
  80071b:	53                   	push   %ebx
  80071c:	6a 00                	push   $0x0
  80071e:	e8 9e fa ff ff       	call   8001c1 <sys_page_map>
  800723:	89 c3                	mov    %eax,%ebx
  800725:	83 c4 20             	add    $0x20,%esp
  800728:	85 c0                	test   %eax,%eax
  80072a:	79 a3                	jns    8006cf <dup+0x78>
	sys_page_unmap(0, newfd);
  80072c:	83 ec 08             	sub    $0x8,%esp
  80072f:	56                   	push   %esi
  800730:	6a 00                	push   $0x0
  800732:	e8 d0 fa ff ff       	call   800207 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800737:	83 c4 08             	add    $0x8,%esp
  80073a:	57                   	push   %edi
  80073b:	6a 00                	push   $0x0
  80073d:	e8 c5 fa ff ff       	call   800207 <sys_page_unmap>
	return r;
  800742:	83 c4 10             	add    $0x10,%esp
  800745:	eb b7                	jmp    8006fe <dup+0xa7>

00800747 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800747:	f3 0f 1e fb          	endbr32 
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	53                   	push   %ebx
  80074f:	83 ec 1c             	sub    $0x1c,%esp
  800752:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800755:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800758:	50                   	push   %eax
  800759:	53                   	push   %ebx
  80075a:	e8 60 fd ff ff       	call   8004bf <fd_lookup>
  80075f:	83 c4 10             	add    $0x10,%esp
  800762:	85 c0                	test   %eax,%eax
  800764:	78 3f                	js     8007a5 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800766:	83 ec 08             	sub    $0x8,%esp
  800769:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80076c:	50                   	push   %eax
  80076d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800770:	ff 30                	pushl  (%eax)
  800772:	e8 9c fd ff ff       	call   800513 <dev_lookup>
  800777:	83 c4 10             	add    $0x10,%esp
  80077a:	85 c0                	test   %eax,%eax
  80077c:	78 27                	js     8007a5 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80077e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800781:	8b 42 08             	mov    0x8(%edx),%eax
  800784:	83 e0 03             	and    $0x3,%eax
  800787:	83 f8 01             	cmp    $0x1,%eax
  80078a:	74 1e                	je     8007aa <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80078c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80078f:	8b 40 08             	mov    0x8(%eax),%eax
  800792:	85 c0                	test   %eax,%eax
  800794:	74 35                	je     8007cb <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800796:	83 ec 04             	sub    $0x4,%esp
  800799:	ff 75 10             	pushl  0x10(%ebp)
  80079c:	ff 75 0c             	pushl  0xc(%ebp)
  80079f:	52                   	push   %edx
  8007a0:	ff d0                	call   *%eax
  8007a2:	83 c4 10             	add    $0x10,%esp
}
  8007a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007a8:	c9                   	leave  
  8007a9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8007aa:	a1 08 40 80 00       	mov    0x804008,%eax
  8007af:	8b 40 48             	mov    0x48(%eax),%eax
  8007b2:	83 ec 04             	sub    $0x4,%esp
  8007b5:	53                   	push   %ebx
  8007b6:	50                   	push   %eax
  8007b7:	68 d9 24 80 00       	push   $0x8024d9
  8007bc:	e8 62 0f 00 00       	call   801723 <cprintf>
		return -E_INVAL;
  8007c1:	83 c4 10             	add    $0x10,%esp
  8007c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007c9:	eb da                	jmp    8007a5 <read+0x5e>
		return -E_NOT_SUPP;
  8007cb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007d0:	eb d3                	jmp    8007a5 <read+0x5e>

008007d2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8007d2:	f3 0f 1e fb          	endbr32 
  8007d6:	55                   	push   %ebp
  8007d7:	89 e5                	mov    %esp,%ebp
  8007d9:	57                   	push   %edi
  8007da:	56                   	push   %esi
  8007db:	53                   	push   %ebx
  8007dc:	83 ec 0c             	sub    $0xc,%esp
  8007df:	8b 7d 08             	mov    0x8(%ebp),%edi
  8007e2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8007e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007ea:	eb 02                	jmp    8007ee <readn+0x1c>
  8007ec:	01 c3                	add    %eax,%ebx
  8007ee:	39 f3                	cmp    %esi,%ebx
  8007f0:	73 21                	jae    800813 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8007f2:	83 ec 04             	sub    $0x4,%esp
  8007f5:	89 f0                	mov    %esi,%eax
  8007f7:	29 d8                	sub    %ebx,%eax
  8007f9:	50                   	push   %eax
  8007fa:	89 d8                	mov    %ebx,%eax
  8007fc:	03 45 0c             	add    0xc(%ebp),%eax
  8007ff:	50                   	push   %eax
  800800:	57                   	push   %edi
  800801:	e8 41 ff ff ff       	call   800747 <read>
		if (m < 0)
  800806:	83 c4 10             	add    $0x10,%esp
  800809:	85 c0                	test   %eax,%eax
  80080b:	78 04                	js     800811 <readn+0x3f>
			return m;
		if (m == 0)
  80080d:	75 dd                	jne    8007ec <readn+0x1a>
  80080f:	eb 02                	jmp    800813 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800811:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800813:	89 d8                	mov    %ebx,%eax
  800815:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800818:	5b                   	pop    %ebx
  800819:	5e                   	pop    %esi
  80081a:	5f                   	pop    %edi
  80081b:	5d                   	pop    %ebp
  80081c:	c3                   	ret    

0080081d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80081d:	f3 0f 1e fb          	endbr32 
  800821:	55                   	push   %ebp
  800822:	89 e5                	mov    %esp,%ebp
  800824:	53                   	push   %ebx
  800825:	83 ec 1c             	sub    $0x1c,%esp
  800828:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80082b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80082e:	50                   	push   %eax
  80082f:	53                   	push   %ebx
  800830:	e8 8a fc ff ff       	call   8004bf <fd_lookup>
  800835:	83 c4 10             	add    $0x10,%esp
  800838:	85 c0                	test   %eax,%eax
  80083a:	78 3a                	js     800876 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800842:	50                   	push   %eax
  800843:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800846:	ff 30                	pushl  (%eax)
  800848:	e8 c6 fc ff ff       	call   800513 <dev_lookup>
  80084d:	83 c4 10             	add    $0x10,%esp
  800850:	85 c0                	test   %eax,%eax
  800852:	78 22                	js     800876 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800854:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800857:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80085b:	74 1e                	je     80087b <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80085d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800860:	8b 52 0c             	mov    0xc(%edx),%edx
  800863:	85 d2                	test   %edx,%edx
  800865:	74 35                	je     80089c <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800867:	83 ec 04             	sub    $0x4,%esp
  80086a:	ff 75 10             	pushl  0x10(%ebp)
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	50                   	push   %eax
  800871:	ff d2                	call   *%edx
  800873:	83 c4 10             	add    $0x10,%esp
}
  800876:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800879:	c9                   	leave  
  80087a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80087b:	a1 08 40 80 00       	mov    0x804008,%eax
  800880:	8b 40 48             	mov    0x48(%eax),%eax
  800883:	83 ec 04             	sub    $0x4,%esp
  800886:	53                   	push   %ebx
  800887:	50                   	push   %eax
  800888:	68 f5 24 80 00       	push   $0x8024f5
  80088d:	e8 91 0e 00 00       	call   801723 <cprintf>
		return -E_INVAL;
  800892:	83 c4 10             	add    $0x10,%esp
  800895:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80089a:	eb da                	jmp    800876 <write+0x59>
		return -E_NOT_SUPP;
  80089c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008a1:	eb d3                	jmp    800876 <write+0x59>

008008a3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8008a3:	f3 0f 1e fb          	endbr32 
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8008ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008b0:	50                   	push   %eax
  8008b1:	ff 75 08             	pushl  0x8(%ebp)
  8008b4:	e8 06 fc ff ff       	call   8004bf <fd_lookup>
  8008b9:	83 c4 10             	add    $0x10,%esp
  8008bc:	85 c0                	test   %eax,%eax
  8008be:	78 0e                	js     8008ce <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8008c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8008c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008ce:	c9                   	leave  
  8008cf:	c3                   	ret    

008008d0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8008d0:	f3 0f 1e fb          	endbr32 
  8008d4:	55                   	push   %ebp
  8008d5:	89 e5                	mov    %esp,%ebp
  8008d7:	53                   	push   %ebx
  8008d8:	83 ec 1c             	sub    $0x1c,%esp
  8008db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008de:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008e1:	50                   	push   %eax
  8008e2:	53                   	push   %ebx
  8008e3:	e8 d7 fb ff ff       	call   8004bf <fd_lookup>
  8008e8:	83 c4 10             	add    $0x10,%esp
  8008eb:	85 c0                	test   %eax,%eax
  8008ed:	78 37                	js     800926 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008f5:	50                   	push   %eax
  8008f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f9:	ff 30                	pushl  (%eax)
  8008fb:	e8 13 fc ff ff       	call   800513 <dev_lookup>
  800900:	83 c4 10             	add    $0x10,%esp
  800903:	85 c0                	test   %eax,%eax
  800905:	78 1f                	js     800926 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800907:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80090a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80090e:	74 1b                	je     80092b <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800910:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800913:	8b 52 18             	mov    0x18(%edx),%edx
  800916:	85 d2                	test   %edx,%edx
  800918:	74 32                	je     80094c <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80091a:	83 ec 08             	sub    $0x8,%esp
  80091d:	ff 75 0c             	pushl  0xc(%ebp)
  800920:	50                   	push   %eax
  800921:	ff d2                	call   *%edx
  800923:	83 c4 10             	add    $0x10,%esp
}
  800926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800929:	c9                   	leave  
  80092a:	c3                   	ret    
			thisenv->env_id, fdnum);
  80092b:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800930:	8b 40 48             	mov    0x48(%eax),%eax
  800933:	83 ec 04             	sub    $0x4,%esp
  800936:	53                   	push   %ebx
  800937:	50                   	push   %eax
  800938:	68 b8 24 80 00       	push   $0x8024b8
  80093d:	e8 e1 0d 00 00       	call   801723 <cprintf>
		return -E_INVAL;
  800942:	83 c4 10             	add    $0x10,%esp
  800945:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80094a:	eb da                	jmp    800926 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80094c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800951:	eb d3                	jmp    800926 <ftruncate+0x56>

00800953 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800953:	f3 0f 1e fb          	endbr32 
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	53                   	push   %ebx
  80095b:	83 ec 1c             	sub    $0x1c,%esp
  80095e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800961:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800964:	50                   	push   %eax
  800965:	ff 75 08             	pushl  0x8(%ebp)
  800968:	e8 52 fb ff ff       	call   8004bf <fd_lookup>
  80096d:	83 c4 10             	add    $0x10,%esp
  800970:	85 c0                	test   %eax,%eax
  800972:	78 4b                	js     8009bf <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80097a:	50                   	push   %eax
  80097b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097e:	ff 30                	pushl  (%eax)
  800980:	e8 8e fb ff ff       	call   800513 <dev_lookup>
  800985:	83 c4 10             	add    $0x10,%esp
  800988:	85 c0                	test   %eax,%eax
  80098a:	78 33                	js     8009bf <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80098c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80098f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800993:	74 2f                	je     8009c4 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800995:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800998:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80099f:	00 00 00 
	stat->st_isdir = 0;
  8009a2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8009a9:	00 00 00 
	stat->st_dev = dev;
  8009ac:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8009b2:	83 ec 08             	sub    $0x8,%esp
  8009b5:	53                   	push   %ebx
  8009b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8009b9:	ff 50 14             	call   *0x14(%eax)
  8009bc:	83 c4 10             	add    $0x10,%esp
}
  8009bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009c2:	c9                   	leave  
  8009c3:	c3                   	ret    
		return -E_NOT_SUPP;
  8009c4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8009c9:	eb f4                	jmp    8009bf <fstat+0x6c>

008009cb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8009cb:	f3 0f 1e fb          	endbr32 
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	56                   	push   %esi
  8009d3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	6a 00                	push   $0x0
  8009d9:	ff 75 08             	pushl  0x8(%ebp)
  8009dc:	e8 fb 01 00 00       	call   800bdc <open>
  8009e1:	89 c3                	mov    %eax,%ebx
  8009e3:	83 c4 10             	add    $0x10,%esp
  8009e6:	85 c0                	test   %eax,%eax
  8009e8:	78 1b                	js     800a05 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	50                   	push   %eax
  8009f1:	e8 5d ff ff ff       	call   800953 <fstat>
  8009f6:	89 c6                	mov    %eax,%esi
	close(fd);
  8009f8:	89 1c 24             	mov    %ebx,(%esp)
  8009fb:	e8 fd fb ff ff       	call   8005fd <close>
	return r;
  800a00:	83 c4 10             	add    $0x10,%esp
  800a03:	89 f3                	mov    %esi,%ebx
}
  800a05:	89 d8                	mov    %ebx,%eax
  800a07:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a0a:	5b                   	pop    %ebx
  800a0b:	5e                   	pop    %esi
  800a0c:	5d                   	pop    %ebp
  800a0d:	c3                   	ret    

00800a0e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	56                   	push   %esi
  800a12:	53                   	push   %ebx
  800a13:	89 c6                	mov    %eax,%esi
  800a15:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800a17:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800a1e:	74 27                	je     800a47 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800a20:	6a 07                	push   $0x7
  800a22:	68 00 50 80 00       	push   $0x805000
  800a27:	56                   	push   %esi
  800a28:	ff 35 00 40 80 00    	pushl  0x804000
  800a2e:	e8 f1 16 00 00       	call   802124 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800a33:	83 c4 0c             	add    $0xc,%esp
  800a36:	6a 00                	push   $0x0
  800a38:	53                   	push   %ebx
  800a39:	6a 00                	push   $0x0
  800a3b:	e8 5f 16 00 00       	call   80209f <ipc_recv>
}
  800a40:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a43:	5b                   	pop    %ebx
  800a44:	5e                   	pop    %esi
  800a45:	5d                   	pop    %ebp
  800a46:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800a47:	83 ec 0c             	sub    $0xc,%esp
  800a4a:	6a 01                	push   $0x1
  800a4c:	e8 2b 17 00 00       	call   80217c <ipc_find_env>
  800a51:	a3 00 40 80 00       	mov    %eax,0x804000
  800a56:	83 c4 10             	add    $0x10,%esp
  800a59:	eb c5                	jmp    800a20 <fsipc+0x12>

00800a5b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800a5b:	f3 0f 1e fb          	endbr32 
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	8b 40 0c             	mov    0xc(%eax),%eax
  800a6b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800a70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a73:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800a78:	ba 00 00 00 00       	mov    $0x0,%edx
  800a7d:	b8 02 00 00 00       	mov    $0x2,%eax
  800a82:	e8 87 ff ff ff       	call   800a0e <fsipc>
}
  800a87:	c9                   	leave  
  800a88:	c3                   	ret    

00800a89 <devfile_flush>:
{
  800a89:	f3 0f 1e fb          	endbr32 
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	8b 40 0c             	mov    0xc(%eax),%eax
  800a99:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa3:	b8 06 00 00 00       	mov    $0x6,%eax
  800aa8:	e8 61 ff ff ff       	call   800a0e <fsipc>
}
  800aad:	c9                   	leave  
  800aae:	c3                   	ret    

00800aaf <devfile_stat>:
{
  800aaf:	f3 0f 1e fb          	endbr32 
  800ab3:	55                   	push   %ebp
  800ab4:	89 e5                	mov    %esp,%ebp
  800ab6:	53                   	push   %ebx
  800ab7:	83 ec 04             	sub    $0x4,%esp
  800aba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	8b 40 0c             	mov    0xc(%eax),%eax
  800ac3:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800ac8:	ba 00 00 00 00       	mov    $0x0,%edx
  800acd:	b8 05 00 00 00       	mov    $0x5,%eax
  800ad2:	e8 37 ff ff ff       	call   800a0e <fsipc>
  800ad7:	85 c0                	test   %eax,%eax
  800ad9:	78 2c                	js     800b07 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800adb:	83 ec 08             	sub    $0x8,%esp
  800ade:	68 00 50 80 00       	push   $0x805000
  800ae3:	53                   	push   %ebx
  800ae4:	e8 44 12 00 00       	call   801d2d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800ae9:	a1 80 50 80 00       	mov    0x805080,%eax
  800aee:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800af4:	a1 84 50 80 00       	mov    0x805084,%eax
  800af9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800aff:	83 c4 10             	add    $0x10,%esp
  800b02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b0a:	c9                   	leave  
  800b0b:	c3                   	ret    

00800b0c <devfile_write>:
{
  800b0c:	f3 0f 1e fb          	endbr32 
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	83 ec 0c             	sub    $0xc,%esp
  800b16:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800b19:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1c:	8b 52 0c             	mov    0xc(%edx),%edx
  800b1f:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  800b25:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800b2a:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800b2f:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  800b32:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800b37:	50                   	push   %eax
  800b38:	ff 75 0c             	pushl  0xc(%ebp)
  800b3b:	68 08 50 80 00       	push   $0x805008
  800b40:	e8 9e 13 00 00       	call   801ee3 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800b45:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4a:	b8 04 00 00 00       	mov    $0x4,%eax
  800b4f:	e8 ba fe ff ff       	call   800a0e <fsipc>
}
  800b54:	c9                   	leave  
  800b55:	c3                   	ret    

00800b56 <devfile_read>:
{
  800b56:	f3 0f 1e fb          	endbr32 
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	56                   	push   %esi
  800b5e:	53                   	push   %ebx
  800b5f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8b 40 0c             	mov    0xc(%eax),%eax
  800b68:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b6d:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b73:	ba 00 00 00 00       	mov    $0x0,%edx
  800b78:	b8 03 00 00 00       	mov    $0x3,%eax
  800b7d:	e8 8c fe ff ff       	call   800a0e <fsipc>
  800b82:	89 c3                	mov    %eax,%ebx
  800b84:	85 c0                	test   %eax,%eax
  800b86:	78 1f                	js     800ba7 <devfile_read+0x51>
	assert(r <= n);
  800b88:	39 f0                	cmp    %esi,%eax
  800b8a:	77 24                	ja     800bb0 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800b8c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b91:	7f 33                	jg     800bc6 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b93:	83 ec 04             	sub    $0x4,%esp
  800b96:	50                   	push   %eax
  800b97:	68 00 50 80 00       	push   $0x805000
  800b9c:	ff 75 0c             	pushl  0xc(%ebp)
  800b9f:	e8 3f 13 00 00       	call   801ee3 <memmove>
	return r;
  800ba4:	83 c4 10             	add    $0x10,%esp
}
  800ba7:	89 d8                	mov    %ebx,%eax
  800ba9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bac:	5b                   	pop    %ebx
  800bad:	5e                   	pop    %esi
  800bae:	5d                   	pop    %ebp
  800baf:	c3                   	ret    
	assert(r <= n);
  800bb0:	68 28 25 80 00       	push   $0x802528
  800bb5:	68 2f 25 80 00       	push   $0x80252f
  800bba:	6a 7c                	push   $0x7c
  800bbc:	68 44 25 80 00       	push   $0x802544
  800bc1:	e8 76 0a 00 00       	call   80163c <_panic>
	assert(r <= PGSIZE);
  800bc6:	68 4f 25 80 00       	push   $0x80254f
  800bcb:	68 2f 25 80 00       	push   $0x80252f
  800bd0:	6a 7d                	push   $0x7d
  800bd2:	68 44 25 80 00       	push   $0x802544
  800bd7:	e8 60 0a 00 00       	call   80163c <_panic>

00800bdc <open>:
{
  800bdc:	f3 0f 1e fb          	endbr32 
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	56                   	push   %esi
  800be4:	53                   	push   %ebx
  800be5:	83 ec 1c             	sub    $0x1c,%esp
  800be8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800beb:	56                   	push   %esi
  800bec:	e8 f9 10 00 00       	call   801cea <strlen>
  800bf1:	83 c4 10             	add    $0x10,%esp
  800bf4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800bf9:	7f 6c                	jg     800c67 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800bfb:	83 ec 0c             	sub    $0xc,%esp
  800bfe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c01:	50                   	push   %eax
  800c02:	e8 62 f8 ff ff       	call   800469 <fd_alloc>
  800c07:	89 c3                	mov    %eax,%ebx
  800c09:	83 c4 10             	add    $0x10,%esp
  800c0c:	85 c0                	test   %eax,%eax
  800c0e:	78 3c                	js     800c4c <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	56                   	push   %esi
  800c14:	68 00 50 80 00       	push   $0x805000
  800c19:	e8 0f 11 00 00       	call   801d2d <strcpy>
	fsipcbuf.open.req_omode = mode;
  800c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c21:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800c26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c29:	b8 01 00 00 00       	mov    $0x1,%eax
  800c2e:	e8 db fd ff ff       	call   800a0e <fsipc>
  800c33:	89 c3                	mov    %eax,%ebx
  800c35:	83 c4 10             	add    $0x10,%esp
  800c38:	85 c0                	test   %eax,%eax
  800c3a:	78 19                	js     800c55 <open+0x79>
	return fd2num(fd);
  800c3c:	83 ec 0c             	sub    $0xc,%esp
  800c3f:	ff 75 f4             	pushl  -0xc(%ebp)
  800c42:	e8 f3 f7 ff ff       	call   80043a <fd2num>
  800c47:	89 c3                	mov    %eax,%ebx
  800c49:	83 c4 10             	add    $0x10,%esp
}
  800c4c:	89 d8                	mov    %ebx,%eax
  800c4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c51:	5b                   	pop    %ebx
  800c52:	5e                   	pop    %esi
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    
		fd_close(fd, 0);
  800c55:	83 ec 08             	sub    $0x8,%esp
  800c58:	6a 00                	push   $0x0
  800c5a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c5d:	e8 10 f9 ff ff       	call   800572 <fd_close>
		return r;
  800c62:	83 c4 10             	add    $0x10,%esp
  800c65:	eb e5                	jmp    800c4c <open+0x70>
		return -E_BAD_PATH;
  800c67:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800c6c:	eb de                	jmp    800c4c <open+0x70>

00800c6e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800c6e:	f3 0f 1e fb          	endbr32 
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c78:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7d:	b8 08 00 00 00       	mov    $0x8,%eax
  800c82:	e8 87 fd ff ff       	call   800a0e <fsipc>
}
  800c87:	c9                   	leave  
  800c88:	c3                   	ret    

00800c89 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800c89:	f3 0f 1e fb          	endbr32 
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800c93:	68 5b 25 80 00       	push   $0x80255b
  800c98:	ff 75 0c             	pushl  0xc(%ebp)
  800c9b:	e8 8d 10 00 00       	call   801d2d <strcpy>
	return 0;
}
  800ca0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca5:	c9                   	leave  
  800ca6:	c3                   	ret    

00800ca7 <devsock_close>:
{
  800ca7:	f3 0f 1e fb          	endbr32 
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	53                   	push   %ebx
  800caf:	83 ec 10             	sub    $0x10,%esp
  800cb2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800cb5:	53                   	push   %ebx
  800cb6:	e8 fe 14 00 00       	call   8021b9 <pageref>
  800cbb:	89 c2                	mov    %eax,%edx
  800cbd:	83 c4 10             	add    $0x10,%esp
		return 0;
  800cc0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  800cc5:	83 fa 01             	cmp    $0x1,%edx
  800cc8:	74 05                	je     800ccf <devsock_close+0x28>
}
  800cca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ccd:	c9                   	leave  
  800cce:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800ccf:	83 ec 0c             	sub    $0xc,%esp
  800cd2:	ff 73 0c             	pushl  0xc(%ebx)
  800cd5:	e8 e3 02 00 00       	call   800fbd <nsipc_close>
  800cda:	83 c4 10             	add    $0x10,%esp
  800cdd:	eb eb                	jmp    800cca <devsock_close+0x23>

00800cdf <devsock_write>:
{
  800cdf:	f3 0f 1e fb          	endbr32 
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800ce9:	6a 00                	push   $0x0
  800ceb:	ff 75 10             	pushl  0x10(%ebp)
  800cee:	ff 75 0c             	pushl  0xc(%ebp)
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	ff 70 0c             	pushl  0xc(%eax)
  800cf7:	e8 b5 03 00 00       	call   8010b1 <nsipc_send>
}
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <devsock_read>:
{
  800cfe:	f3 0f 1e fb          	endbr32 
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800d08:	6a 00                	push   $0x0
  800d0a:	ff 75 10             	pushl  0x10(%ebp)
  800d0d:	ff 75 0c             	pushl  0xc(%ebp)
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	ff 70 0c             	pushl  0xc(%eax)
  800d16:	e8 1f 03 00 00       	call   80103a <nsipc_recv>
}
  800d1b:	c9                   	leave  
  800d1c:	c3                   	ret    

00800d1d <fd2sockid>:
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800d23:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800d26:	52                   	push   %edx
  800d27:	50                   	push   %eax
  800d28:	e8 92 f7 ff ff       	call   8004bf <fd_lookup>
  800d2d:	83 c4 10             	add    $0x10,%esp
  800d30:	85 c0                	test   %eax,%eax
  800d32:	78 10                	js     800d44 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d37:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800d3d:	39 08                	cmp    %ecx,(%eax)
  800d3f:	75 05                	jne    800d46 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800d41:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800d44:	c9                   	leave  
  800d45:	c3                   	ret    
		return -E_NOT_SUPP;
  800d46:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800d4b:	eb f7                	jmp    800d44 <fd2sockid+0x27>

00800d4d <alloc_sockfd>:
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	56                   	push   %esi
  800d51:	53                   	push   %ebx
  800d52:	83 ec 1c             	sub    $0x1c,%esp
  800d55:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800d57:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d5a:	50                   	push   %eax
  800d5b:	e8 09 f7 ff ff       	call   800469 <fd_alloc>
  800d60:	89 c3                	mov    %eax,%ebx
  800d62:	83 c4 10             	add    $0x10,%esp
  800d65:	85 c0                	test   %eax,%eax
  800d67:	78 43                	js     800dac <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800d69:	83 ec 04             	sub    $0x4,%esp
  800d6c:	68 07 04 00 00       	push   $0x407
  800d71:	ff 75 f4             	pushl  -0xc(%ebp)
  800d74:	6a 00                	push   $0x0
  800d76:	e8 ff f3 ff ff       	call   80017a <sys_page_alloc>
  800d7b:	89 c3                	mov    %eax,%ebx
  800d7d:	83 c4 10             	add    $0x10,%esp
  800d80:	85 c0                	test   %eax,%eax
  800d82:	78 28                	js     800dac <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d87:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800d8d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d92:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800d99:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800d9c:	83 ec 0c             	sub    $0xc,%esp
  800d9f:	50                   	push   %eax
  800da0:	e8 95 f6 ff ff       	call   80043a <fd2num>
  800da5:	89 c3                	mov    %eax,%ebx
  800da7:	83 c4 10             	add    $0x10,%esp
  800daa:	eb 0c                	jmp    800db8 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800dac:	83 ec 0c             	sub    $0xc,%esp
  800daf:	56                   	push   %esi
  800db0:	e8 08 02 00 00       	call   800fbd <nsipc_close>
		return r;
  800db5:	83 c4 10             	add    $0x10,%esp
}
  800db8:	89 d8                	mov    %ebx,%eax
  800dba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dbd:	5b                   	pop    %ebx
  800dbe:	5e                   	pop    %esi
  800dbf:	5d                   	pop    %ebp
  800dc0:	c3                   	ret    

00800dc1 <accept>:
{
  800dc1:	f3 0f 1e fb          	endbr32 
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	e8 4a ff ff ff       	call   800d1d <fd2sockid>
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	78 1b                	js     800df2 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800dd7:	83 ec 04             	sub    $0x4,%esp
  800dda:	ff 75 10             	pushl  0x10(%ebp)
  800ddd:	ff 75 0c             	pushl  0xc(%ebp)
  800de0:	50                   	push   %eax
  800de1:	e8 22 01 00 00       	call   800f08 <nsipc_accept>
  800de6:	83 c4 10             	add    $0x10,%esp
  800de9:	85 c0                	test   %eax,%eax
  800deb:	78 05                	js     800df2 <accept+0x31>
	return alloc_sockfd(r);
  800ded:	e8 5b ff ff ff       	call   800d4d <alloc_sockfd>
}
  800df2:	c9                   	leave  
  800df3:	c3                   	ret    

00800df4 <bind>:
{
  800df4:	f3 0f 1e fb          	endbr32 
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	e8 17 ff ff ff       	call   800d1d <fd2sockid>
  800e06:	85 c0                	test   %eax,%eax
  800e08:	78 12                	js     800e1c <bind+0x28>
	return nsipc_bind(r, name, namelen);
  800e0a:	83 ec 04             	sub    $0x4,%esp
  800e0d:	ff 75 10             	pushl  0x10(%ebp)
  800e10:	ff 75 0c             	pushl  0xc(%ebp)
  800e13:	50                   	push   %eax
  800e14:	e8 45 01 00 00       	call   800f5e <nsipc_bind>
  800e19:	83 c4 10             	add    $0x10,%esp
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <shutdown>:
{
  800e1e:	f3 0f 1e fb          	endbr32 
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	e8 ed fe ff ff       	call   800d1d <fd2sockid>
  800e30:	85 c0                	test   %eax,%eax
  800e32:	78 0f                	js     800e43 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  800e34:	83 ec 08             	sub    $0x8,%esp
  800e37:	ff 75 0c             	pushl  0xc(%ebp)
  800e3a:	50                   	push   %eax
  800e3b:	e8 57 01 00 00       	call   800f97 <nsipc_shutdown>
  800e40:	83 c4 10             	add    $0x10,%esp
}
  800e43:	c9                   	leave  
  800e44:	c3                   	ret    

00800e45 <connect>:
{
  800e45:	f3 0f 1e fb          	endbr32 
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	e8 c6 fe ff ff       	call   800d1d <fd2sockid>
  800e57:	85 c0                	test   %eax,%eax
  800e59:	78 12                	js     800e6d <connect+0x28>
	return nsipc_connect(r, name, namelen);
  800e5b:	83 ec 04             	sub    $0x4,%esp
  800e5e:	ff 75 10             	pushl  0x10(%ebp)
  800e61:	ff 75 0c             	pushl  0xc(%ebp)
  800e64:	50                   	push   %eax
  800e65:	e8 71 01 00 00       	call   800fdb <nsipc_connect>
  800e6a:	83 c4 10             	add    $0x10,%esp
}
  800e6d:	c9                   	leave  
  800e6e:	c3                   	ret    

00800e6f <listen>:
{
  800e6f:	f3 0f 1e fb          	endbr32 
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e79:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7c:	e8 9c fe ff ff       	call   800d1d <fd2sockid>
  800e81:	85 c0                	test   %eax,%eax
  800e83:	78 0f                	js     800e94 <listen+0x25>
	return nsipc_listen(r, backlog);
  800e85:	83 ec 08             	sub    $0x8,%esp
  800e88:	ff 75 0c             	pushl  0xc(%ebp)
  800e8b:	50                   	push   %eax
  800e8c:	e8 83 01 00 00       	call   801014 <nsipc_listen>
  800e91:	83 c4 10             	add    $0x10,%esp
}
  800e94:	c9                   	leave  
  800e95:	c3                   	ret    

00800e96 <socket>:

int
socket(int domain, int type, int protocol)
{
  800e96:	f3 0f 1e fb          	endbr32 
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800ea0:	ff 75 10             	pushl  0x10(%ebp)
  800ea3:	ff 75 0c             	pushl  0xc(%ebp)
  800ea6:	ff 75 08             	pushl  0x8(%ebp)
  800ea9:	e8 65 02 00 00       	call   801113 <nsipc_socket>
  800eae:	83 c4 10             	add    $0x10,%esp
  800eb1:	85 c0                	test   %eax,%eax
  800eb3:	78 05                	js     800eba <socket+0x24>
		return r;
	return alloc_sockfd(r);
  800eb5:	e8 93 fe ff ff       	call   800d4d <alloc_sockfd>
}
  800eba:	c9                   	leave  
  800ebb:	c3                   	ret    

00800ebc <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	53                   	push   %ebx
  800ec0:	83 ec 04             	sub    $0x4,%esp
  800ec3:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800ec5:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800ecc:	74 26                	je     800ef4 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800ece:	6a 07                	push   $0x7
  800ed0:	68 00 60 80 00       	push   $0x806000
  800ed5:	53                   	push   %ebx
  800ed6:	ff 35 04 40 80 00    	pushl  0x804004
  800edc:	e8 43 12 00 00       	call   802124 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800ee1:	83 c4 0c             	add    $0xc,%esp
  800ee4:	6a 00                	push   $0x0
  800ee6:	6a 00                	push   $0x0
  800ee8:	6a 00                	push   $0x0
  800eea:	e8 b0 11 00 00       	call   80209f <ipc_recv>
}
  800eef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ef2:	c9                   	leave  
  800ef3:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800ef4:	83 ec 0c             	sub    $0xc,%esp
  800ef7:	6a 02                	push   $0x2
  800ef9:	e8 7e 12 00 00       	call   80217c <ipc_find_env>
  800efe:	a3 04 40 80 00       	mov    %eax,0x804004
  800f03:	83 c4 10             	add    $0x10,%esp
  800f06:	eb c6                	jmp    800ece <nsipc+0x12>

00800f08 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800f08:	f3 0f 1e fb          	endbr32 
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	56                   	push   %esi
  800f10:	53                   	push   %ebx
  800f11:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
  800f17:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800f1c:	8b 06                	mov    (%esi),%eax
  800f1e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800f23:	b8 01 00 00 00       	mov    $0x1,%eax
  800f28:	e8 8f ff ff ff       	call   800ebc <nsipc>
  800f2d:	89 c3                	mov    %eax,%ebx
  800f2f:	85 c0                	test   %eax,%eax
  800f31:	79 09                	jns    800f3c <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  800f33:	89 d8                	mov    %ebx,%eax
  800f35:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f38:	5b                   	pop    %ebx
  800f39:	5e                   	pop    %esi
  800f3a:	5d                   	pop    %ebp
  800f3b:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800f3c:	83 ec 04             	sub    $0x4,%esp
  800f3f:	ff 35 10 60 80 00    	pushl  0x806010
  800f45:	68 00 60 80 00       	push   $0x806000
  800f4a:	ff 75 0c             	pushl  0xc(%ebp)
  800f4d:	e8 91 0f 00 00       	call   801ee3 <memmove>
		*addrlen = ret->ret_addrlen;
  800f52:	a1 10 60 80 00       	mov    0x806010,%eax
  800f57:	89 06                	mov    %eax,(%esi)
  800f59:	83 c4 10             	add    $0x10,%esp
	return r;
  800f5c:	eb d5                	jmp    800f33 <nsipc_accept+0x2b>

00800f5e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800f5e:	f3 0f 1e fb          	endbr32 
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	53                   	push   %ebx
  800f66:	83 ec 08             	sub    $0x8,%esp
  800f69:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800f74:	53                   	push   %ebx
  800f75:	ff 75 0c             	pushl  0xc(%ebp)
  800f78:	68 04 60 80 00       	push   $0x806004
  800f7d:	e8 61 0f 00 00       	call   801ee3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800f82:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800f88:	b8 02 00 00 00       	mov    $0x2,%eax
  800f8d:	e8 2a ff ff ff       	call   800ebc <nsipc>
}
  800f92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f95:	c9                   	leave  
  800f96:	c3                   	ret    

00800f97 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800f97:	f3 0f 1e fb          	endbr32 
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800fa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fac:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800fb1:	b8 03 00 00 00       	mov    $0x3,%eax
  800fb6:	e8 01 ff ff ff       	call   800ebc <nsipc>
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    

00800fbd <nsipc_close>:

int
nsipc_close(int s)
{
  800fbd:	f3 0f 1e fb          	endbr32 
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800fcf:	b8 04 00 00 00       	mov    $0x4,%eax
  800fd4:	e8 e3 fe ff ff       	call   800ebc <nsipc>
}
  800fd9:	c9                   	leave  
  800fda:	c3                   	ret    

00800fdb <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800fdb:	f3 0f 1e fb          	endbr32 
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	53                   	push   %ebx
  800fe3:	83 ec 08             	sub    $0x8,%esp
  800fe6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800ff1:	53                   	push   %ebx
  800ff2:	ff 75 0c             	pushl  0xc(%ebp)
  800ff5:	68 04 60 80 00       	push   $0x806004
  800ffa:	e8 e4 0e 00 00       	call   801ee3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800fff:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801005:	b8 05 00 00 00       	mov    $0x5,%eax
  80100a:	e8 ad fe ff ff       	call   800ebc <nsipc>
}
  80100f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801012:	c9                   	leave  
  801013:	c3                   	ret    

00801014 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801014:	f3 0f 1e fb          	endbr32 
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801026:	8b 45 0c             	mov    0xc(%ebp),%eax
  801029:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80102e:	b8 06 00 00 00       	mov    $0x6,%eax
  801033:	e8 84 fe ff ff       	call   800ebc <nsipc>
}
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80103a:	f3 0f 1e fb          	endbr32 
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	56                   	push   %esi
  801042:	53                   	push   %ebx
  801043:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80104e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801054:	8b 45 14             	mov    0x14(%ebp),%eax
  801057:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80105c:	b8 07 00 00 00       	mov    $0x7,%eax
  801061:	e8 56 fe ff ff       	call   800ebc <nsipc>
  801066:	89 c3                	mov    %eax,%ebx
  801068:	85 c0                	test   %eax,%eax
  80106a:	78 26                	js     801092 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  80106c:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801072:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801077:	0f 4e c6             	cmovle %esi,%eax
  80107a:	39 c3                	cmp    %eax,%ebx
  80107c:	7f 1d                	jg     80109b <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80107e:	83 ec 04             	sub    $0x4,%esp
  801081:	53                   	push   %ebx
  801082:	68 00 60 80 00       	push   $0x806000
  801087:	ff 75 0c             	pushl  0xc(%ebp)
  80108a:	e8 54 0e 00 00       	call   801ee3 <memmove>
  80108f:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801092:	89 d8                	mov    %ebx,%eax
  801094:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801097:	5b                   	pop    %ebx
  801098:	5e                   	pop    %esi
  801099:	5d                   	pop    %ebp
  80109a:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80109b:	68 67 25 80 00       	push   $0x802567
  8010a0:	68 2f 25 80 00       	push   $0x80252f
  8010a5:	6a 62                	push   $0x62
  8010a7:	68 7c 25 80 00       	push   $0x80257c
  8010ac:	e8 8b 05 00 00       	call   80163c <_panic>

008010b1 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8010b1:	f3 0f 1e fb          	endbr32 
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
  8010b8:	53                   	push   %ebx
  8010b9:	83 ec 04             	sub    $0x4,%esp
  8010bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8010c7:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8010cd:	7f 2e                	jg     8010fd <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8010cf:	83 ec 04             	sub    $0x4,%esp
  8010d2:	53                   	push   %ebx
  8010d3:	ff 75 0c             	pushl  0xc(%ebp)
  8010d6:	68 0c 60 80 00       	push   $0x80600c
  8010db:	e8 03 0e 00 00       	call   801ee3 <memmove>
	nsipcbuf.send.req_size = size;
  8010e0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8010e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8010ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8010f3:	e8 c4 fd ff ff       	call   800ebc <nsipc>
}
  8010f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010fb:	c9                   	leave  
  8010fc:	c3                   	ret    
	assert(size < 1600);
  8010fd:	68 88 25 80 00       	push   $0x802588
  801102:	68 2f 25 80 00       	push   $0x80252f
  801107:	6a 6d                	push   $0x6d
  801109:	68 7c 25 80 00       	push   $0x80257c
  80110e:	e8 29 05 00 00       	call   80163c <_panic>

00801113 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801113:	f3 0f 1e fb          	endbr32 
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801125:	8b 45 0c             	mov    0xc(%ebp),%eax
  801128:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80112d:	8b 45 10             	mov    0x10(%ebp),%eax
  801130:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801135:	b8 09 00 00 00       	mov    $0x9,%eax
  80113a:	e8 7d fd ff ff       	call   800ebc <nsipc>
}
  80113f:	c9                   	leave  
  801140:	c3                   	ret    

00801141 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801141:	f3 0f 1e fb          	endbr32 
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	56                   	push   %esi
  801149:	53                   	push   %ebx
  80114a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80114d:	83 ec 0c             	sub    $0xc,%esp
  801150:	ff 75 08             	pushl  0x8(%ebp)
  801153:	e8 f6 f2 ff ff       	call   80044e <fd2data>
  801158:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80115a:	83 c4 08             	add    $0x8,%esp
  80115d:	68 94 25 80 00       	push   $0x802594
  801162:	53                   	push   %ebx
  801163:	e8 c5 0b 00 00       	call   801d2d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801168:	8b 46 04             	mov    0x4(%esi),%eax
  80116b:	2b 06                	sub    (%esi),%eax
  80116d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801173:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80117a:	00 00 00 
	stat->st_dev = &devpipe;
  80117d:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801184:	30 80 00 
	return 0;
}
  801187:	b8 00 00 00 00       	mov    $0x0,%eax
  80118c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80118f:	5b                   	pop    %ebx
  801190:	5e                   	pop    %esi
  801191:	5d                   	pop    %ebp
  801192:	c3                   	ret    

00801193 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801193:	f3 0f 1e fb          	endbr32 
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	53                   	push   %ebx
  80119b:	83 ec 0c             	sub    $0xc,%esp
  80119e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8011a1:	53                   	push   %ebx
  8011a2:	6a 00                	push   $0x0
  8011a4:	e8 5e f0 ff ff       	call   800207 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8011a9:	89 1c 24             	mov    %ebx,(%esp)
  8011ac:	e8 9d f2 ff ff       	call   80044e <fd2data>
  8011b1:	83 c4 08             	add    $0x8,%esp
  8011b4:	50                   	push   %eax
  8011b5:	6a 00                	push   $0x0
  8011b7:	e8 4b f0 ff ff       	call   800207 <sys_page_unmap>
}
  8011bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011bf:	c9                   	leave  
  8011c0:	c3                   	ret    

008011c1 <_pipeisclosed>:
{
  8011c1:	55                   	push   %ebp
  8011c2:	89 e5                	mov    %esp,%ebp
  8011c4:	57                   	push   %edi
  8011c5:	56                   	push   %esi
  8011c6:	53                   	push   %ebx
  8011c7:	83 ec 1c             	sub    $0x1c,%esp
  8011ca:	89 c7                	mov    %eax,%edi
  8011cc:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8011ce:	a1 08 40 80 00       	mov    0x804008,%eax
  8011d3:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8011d6:	83 ec 0c             	sub    $0xc,%esp
  8011d9:	57                   	push   %edi
  8011da:	e8 da 0f 00 00       	call   8021b9 <pageref>
  8011df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011e2:	89 34 24             	mov    %esi,(%esp)
  8011e5:	e8 cf 0f 00 00       	call   8021b9 <pageref>
		nn = thisenv->env_runs;
  8011ea:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8011f0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8011f3:	83 c4 10             	add    $0x10,%esp
  8011f6:	39 cb                	cmp    %ecx,%ebx
  8011f8:	74 1b                	je     801215 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8011fa:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8011fd:	75 cf                	jne    8011ce <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8011ff:	8b 42 58             	mov    0x58(%edx),%eax
  801202:	6a 01                	push   $0x1
  801204:	50                   	push   %eax
  801205:	53                   	push   %ebx
  801206:	68 9b 25 80 00       	push   $0x80259b
  80120b:	e8 13 05 00 00       	call   801723 <cprintf>
  801210:	83 c4 10             	add    $0x10,%esp
  801213:	eb b9                	jmp    8011ce <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801215:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801218:	0f 94 c0             	sete   %al
  80121b:	0f b6 c0             	movzbl %al,%eax
}
  80121e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801221:	5b                   	pop    %ebx
  801222:	5e                   	pop    %esi
  801223:	5f                   	pop    %edi
  801224:	5d                   	pop    %ebp
  801225:	c3                   	ret    

00801226 <devpipe_write>:
{
  801226:	f3 0f 1e fb          	endbr32 
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	57                   	push   %edi
  80122e:	56                   	push   %esi
  80122f:	53                   	push   %ebx
  801230:	83 ec 28             	sub    $0x28,%esp
  801233:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801236:	56                   	push   %esi
  801237:	e8 12 f2 ff ff       	call   80044e <fd2data>
  80123c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80123e:	83 c4 10             	add    $0x10,%esp
  801241:	bf 00 00 00 00       	mov    $0x0,%edi
  801246:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801249:	74 4f                	je     80129a <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80124b:	8b 43 04             	mov    0x4(%ebx),%eax
  80124e:	8b 0b                	mov    (%ebx),%ecx
  801250:	8d 51 20             	lea    0x20(%ecx),%edx
  801253:	39 d0                	cmp    %edx,%eax
  801255:	72 14                	jb     80126b <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801257:	89 da                	mov    %ebx,%edx
  801259:	89 f0                	mov    %esi,%eax
  80125b:	e8 61 ff ff ff       	call   8011c1 <_pipeisclosed>
  801260:	85 c0                	test   %eax,%eax
  801262:	75 3b                	jne    80129f <devpipe_write+0x79>
			sys_yield();
  801264:	e8 ee ee ff ff       	call   800157 <sys_yield>
  801269:	eb e0                	jmp    80124b <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80126b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80126e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801272:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801275:	89 c2                	mov    %eax,%edx
  801277:	c1 fa 1f             	sar    $0x1f,%edx
  80127a:	89 d1                	mov    %edx,%ecx
  80127c:	c1 e9 1b             	shr    $0x1b,%ecx
  80127f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801282:	83 e2 1f             	and    $0x1f,%edx
  801285:	29 ca                	sub    %ecx,%edx
  801287:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80128b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80128f:	83 c0 01             	add    $0x1,%eax
  801292:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801295:	83 c7 01             	add    $0x1,%edi
  801298:	eb ac                	jmp    801246 <devpipe_write+0x20>
	return i;
  80129a:	8b 45 10             	mov    0x10(%ebp),%eax
  80129d:	eb 05                	jmp    8012a4 <devpipe_write+0x7e>
				return 0;
  80129f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a7:	5b                   	pop    %ebx
  8012a8:	5e                   	pop    %esi
  8012a9:	5f                   	pop    %edi
  8012aa:	5d                   	pop    %ebp
  8012ab:	c3                   	ret    

008012ac <devpipe_read>:
{
  8012ac:	f3 0f 1e fb          	endbr32 
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	57                   	push   %edi
  8012b4:	56                   	push   %esi
  8012b5:	53                   	push   %ebx
  8012b6:	83 ec 18             	sub    $0x18,%esp
  8012b9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8012bc:	57                   	push   %edi
  8012bd:	e8 8c f1 ff ff       	call   80044e <fd2data>
  8012c2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8012c4:	83 c4 10             	add    $0x10,%esp
  8012c7:	be 00 00 00 00       	mov    $0x0,%esi
  8012cc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8012cf:	75 14                	jne    8012e5 <devpipe_read+0x39>
	return i;
  8012d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d4:	eb 02                	jmp    8012d8 <devpipe_read+0x2c>
				return i;
  8012d6:	89 f0                	mov    %esi,%eax
}
  8012d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012db:	5b                   	pop    %ebx
  8012dc:	5e                   	pop    %esi
  8012dd:	5f                   	pop    %edi
  8012de:	5d                   	pop    %ebp
  8012df:	c3                   	ret    
			sys_yield();
  8012e0:	e8 72 ee ff ff       	call   800157 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8012e5:	8b 03                	mov    (%ebx),%eax
  8012e7:	3b 43 04             	cmp    0x4(%ebx),%eax
  8012ea:	75 18                	jne    801304 <devpipe_read+0x58>
			if (i > 0)
  8012ec:	85 f6                	test   %esi,%esi
  8012ee:	75 e6                	jne    8012d6 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8012f0:	89 da                	mov    %ebx,%edx
  8012f2:	89 f8                	mov    %edi,%eax
  8012f4:	e8 c8 fe ff ff       	call   8011c1 <_pipeisclosed>
  8012f9:	85 c0                	test   %eax,%eax
  8012fb:	74 e3                	je     8012e0 <devpipe_read+0x34>
				return 0;
  8012fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801302:	eb d4                	jmp    8012d8 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801304:	99                   	cltd   
  801305:	c1 ea 1b             	shr    $0x1b,%edx
  801308:	01 d0                	add    %edx,%eax
  80130a:	83 e0 1f             	and    $0x1f,%eax
  80130d:	29 d0                	sub    %edx,%eax
  80130f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801314:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801317:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80131a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80131d:	83 c6 01             	add    $0x1,%esi
  801320:	eb aa                	jmp    8012cc <devpipe_read+0x20>

00801322 <pipe>:
{
  801322:	f3 0f 1e fb          	endbr32 
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	56                   	push   %esi
  80132a:	53                   	push   %ebx
  80132b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80132e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801331:	50                   	push   %eax
  801332:	e8 32 f1 ff ff       	call   800469 <fd_alloc>
  801337:	89 c3                	mov    %eax,%ebx
  801339:	83 c4 10             	add    $0x10,%esp
  80133c:	85 c0                	test   %eax,%eax
  80133e:	0f 88 23 01 00 00    	js     801467 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801344:	83 ec 04             	sub    $0x4,%esp
  801347:	68 07 04 00 00       	push   $0x407
  80134c:	ff 75 f4             	pushl  -0xc(%ebp)
  80134f:	6a 00                	push   $0x0
  801351:	e8 24 ee ff ff       	call   80017a <sys_page_alloc>
  801356:	89 c3                	mov    %eax,%ebx
  801358:	83 c4 10             	add    $0x10,%esp
  80135b:	85 c0                	test   %eax,%eax
  80135d:	0f 88 04 01 00 00    	js     801467 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801363:	83 ec 0c             	sub    $0xc,%esp
  801366:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801369:	50                   	push   %eax
  80136a:	e8 fa f0 ff ff       	call   800469 <fd_alloc>
  80136f:	89 c3                	mov    %eax,%ebx
  801371:	83 c4 10             	add    $0x10,%esp
  801374:	85 c0                	test   %eax,%eax
  801376:	0f 88 db 00 00 00    	js     801457 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80137c:	83 ec 04             	sub    $0x4,%esp
  80137f:	68 07 04 00 00       	push   $0x407
  801384:	ff 75 f0             	pushl  -0x10(%ebp)
  801387:	6a 00                	push   $0x0
  801389:	e8 ec ed ff ff       	call   80017a <sys_page_alloc>
  80138e:	89 c3                	mov    %eax,%ebx
  801390:	83 c4 10             	add    $0x10,%esp
  801393:	85 c0                	test   %eax,%eax
  801395:	0f 88 bc 00 00 00    	js     801457 <pipe+0x135>
	va = fd2data(fd0);
  80139b:	83 ec 0c             	sub    $0xc,%esp
  80139e:	ff 75 f4             	pushl  -0xc(%ebp)
  8013a1:	e8 a8 f0 ff ff       	call   80044e <fd2data>
  8013a6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013a8:	83 c4 0c             	add    $0xc,%esp
  8013ab:	68 07 04 00 00       	push   $0x407
  8013b0:	50                   	push   %eax
  8013b1:	6a 00                	push   $0x0
  8013b3:	e8 c2 ed ff ff       	call   80017a <sys_page_alloc>
  8013b8:	89 c3                	mov    %eax,%ebx
  8013ba:	83 c4 10             	add    $0x10,%esp
  8013bd:	85 c0                	test   %eax,%eax
  8013bf:	0f 88 82 00 00 00    	js     801447 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013c5:	83 ec 0c             	sub    $0xc,%esp
  8013c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8013cb:	e8 7e f0 ff ff       	call   80044e <fd2data>
  8013d0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8013d7:	50                   	push   %eax
  8013d8:	6a 00                	push   $0x0
  8013da:	56                   	push   %esi
  8013db:	6a 00                	push   $0x0
  8013dd:	e8 df ed ff ff       	call   8001c1 <sys_page_map>
  8013e2:	89 c3                	mov    %eax,%ebx
  8013e4:	83 c4 20             	add    $0x20,%esp
  8013e7:	85 c0                	test   %eax,%eax
  8013e9:	78 4e                	js     801439 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8013eb:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8013f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f3:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8013f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f8:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8013ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801402:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801404:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801407:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80140e:	83 ec 0c             	sub    $0xc,%esp
  801411:	ff 75 f4             	pushl  -0xc(%ebp)
  801414:	e8 21 f0 ff ff       	call   80043a <fd2num>
  801419:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80141c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80141e:	83 c4 04             	add    $0x4,%esp
  801421:	ff 75 f0             	pushl  -0x10(%ebp)
  801424:	e8 11 f0 ff ff       	call   80043a <fd2num>
  801429:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80142c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80142f:	83 c4 10             	add    $0x10,%esp
  801432:	bb 00 00 00 00       	mov    $0x0,%ebx
  801437:	eb 2e                	jmp    801467 <pipe+0x145>
	sys_page_unmap(0, va);
  801439:	83 ec 08             	sub    $0x8,%esp
  80143c:	56                   	push   %esi
  80143d:	6a 00                	push   $0x0
  80143f:	e8 c3 ed ff ff       	call   800207 <sys_page_unmap>
  801444:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801447:	83 ec 08             	sub    $0x8,%esp
  80144a:	ff 75 f0             	pushl  -0x10(%ebp)
  80144d:	6a 00                	push   $0x0
  80144f:	e8 b3 ed ff ff       	call   800207 <sys_page_unmap>
  801454:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801457:	83 ec 08             	sub    $0x8,%esp
  80145a:	ff 75 f4             	pushl  -0xc(%ebp)
  80145d:	6a 00                	push   $0x0
  80145f:	e8 a3 ed ff ff       	call   800207 <sys_page_unmap>
  801464:	83 c4 10             	add    $0x10,%esp
}
  801467:	89 d8                	mov    %ebx,%eax
  801469:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80146c:	5b                   	pop    %ebx
  80146d:	5e                   	pop    %esi
  80146e:	5d                   	pop    %ebp
  80146f:	c3                   	ret    

00801470 <pipeisclosed>:
{
  801470:	f3 0f 1e fb          	endbr32 
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80147a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147d:	50                   	push   %eax
  80147e:	ff 75 08             	pushl  0x8(%ebp)
  801481:	e8 39 f0 ff ff       	call   8004bf <fd_lookup>
  801486:	83 c4 10             	add    $0x10,%esp
  801489:	85 c0                	test   %eax,%eax
  80148b:	78 18                	js     8014a5 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80148d:	83 ec 0c             	sub    $0xc,%esp
  801490:	ff 75 f4             	pushl  -0xc(%ebp)
  801493:	e8 b6 ef ff ff       	call   80044e <fd2data>
  801498:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80149a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80149d:	e8 1f fd ff ff       	call   8011c1 <_pipeisclosed>
  8014a2:	83 c4 10             	add    $0x10,%esp
}
  8014a5:	c9                   	leave  
  8014a6:	c3                   	ret    

008014a7 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8014a7:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8014ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b0:	c3                   	ret    

008014b1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8014b1:	f3 0f 1e fb          	endbr32 
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8014bb:	68 b3 25 80 00       	push   $0x8025b3
  8014c0:	ff 75 0c             	pushl  0xc(%ebp)
  8014c3:	e8 65 08 00 00       	call   801d2d <strcpy>
	return 0;
}
  8014c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <devcons_write>:
{
  8014cf:	f3 0f 1e fb          	endbr32 
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
  8014d6:	57                   	push   %edi
  8014d7:	56                   	push   %esi
  8014d8:	53                   	push   %ebx
  8014d9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8014df:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8014e4:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8014ea:	3b 75 10             	cmp    0x10(%ebp),%esi
  8014ed:	73 31                	jae    801520 <devcons_write+0x51>
		m = n - tot;
  8014ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014f2:	29 f3                	sub    %esi,%ebx
  8014f4:	83 fb 7f             	cmp    $0x7f,%ebx
  8014f7:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8014fc:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8014ff:	83 ec 04             	sub    $0x4,%esp
  801502:	53                   	push   %ebx
  801503:	89 f0                	mov    %esi,%eax
  801505:	03 45 0c             	add    0xc(%ebp),%eax
  801508:	50                   	push   %eax
  801509:	57                   	push   %edi
  80150a:	e8 d4 09 00 00       	call   801ee3 <memmove>
		sys_cputs(buf, m);
  80150f:	83 c4 08             	add    $0x8,%esp
  801512:	53                   	push   %ebx
  801513:	57                   	push   %edi
  801514:	e8 91 eb ff ff       	call   8000aa <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801519:	01 de                	add    %ebx,%esi
  80151b:	83 c4 10             	add    $0x10,%esp
  80151e:	eb ca                	jmp    8014ea <devcons_write+0x1b>
}
  801520:	89 f0                	mov    %esi,%eax
  801522:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801525:	5b                   	pop    %ebx
  801526:	5e                   	pop    %esi
  801527:	5f                   	pop    %edi
  801528:	5d                   	pop    %ebp
  801529:	c3                   	ret    

0080152a <devcons_read>:
{
  80152a:	f3 0f 1e fb          	endbr32 
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	83 ec 08             	sub    $0x8,%esp
  801534:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801539:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80153d:	74 21                	je     801560 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80153f:	e8 88 eb ff ff       	call   8000cc <sys_cgetc>
  801544:	85 c0                	test   %eax,%eax
  801546:	75 07                	jne    80154f <devcons_read+0x25>
		sys_yield();
  801548:	e8 0a ec ff ff       	call   800157 <sys_yield>
  80154d:	eb f0                	jmp    80153f <devcons_read+0x15>
	if (c < 0)
  80154f:	78 0f                	js     801560 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801551:	83 f8 04             	cmp    $0x4,%eax
  801554:	74 0c                	je     801562 <devcons_read+0x38>
	*(char*)vbuf = c;
  801556:	8b 55 0c             	mov    0xc(%ebp),%edx
  801559:	88 02                	mov    %al,(%edx)
	return 1;
  80155b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801560:	c9                   	leave  
  801561:	c3                   	ret    
		return 0;
  801562:	b8 00 00 00 00       	mov    $0x0,%eax
  801567:	eb f7                	jmp    801560 <devcons_read+0x36>

00801569 <cputchar>:
{
  801569:	f3 0f 1e fb          	endbr32 
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
  801570:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801579:	6a 01                	push   $0x1
  80157b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80157e:	50                   	push   %eax
  80157f:	e8 26 eb ff ff       	call   8000aa <sys_cputs>
}
  801584:	83 c4 10             	add    $0x10,%esp
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <getchar>:
{
  801589:	f3 0f 1e fb          	endbr32 
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801593:	6a 01                	push   $0x1
  801595:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801598:	50                   	push   %eax
  801599:	6a 00                	push   $0x0
  80159b:	e8 a7 f1 ff ff       	call   800747 <read>
	if (r < 0)
  8015a0:	83 c4 10             	add    $0x10,%esp
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	78 06                	js     8015ad <getchar+0x24>
	if (r < 1)
  8015a7:	74 06                	je     8015af <getchar+0x26>
	return c;
  8015a9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    
		return -E_EOF;
  8015af:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8015b4:	eb f7                	jmp    8015ad <getchar+0x24>

008015b6 <iscons>:
{
  8015b6:	f3 0f 1e fb          	endbr32 
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c3:	50                   	push   %eax
  8015c4:	ff 75 08             	pushl  0x8(%ebp)
  8015c7:	e8 f3 ee ff ff       	call   8004bf <fd_lookup>
  8015cc:	83 c4 10             	add    $0x10,%esp
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	78 11                	js     8015e4 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8015d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d6:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8015dc:	39 10                	cmp    %edx,(%eax)
  8015de:	0f 94 c0             	sete   %al
  8015e1:	0f b6 c0             	movzbl %al,%eax
}
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <opencons>:
{
  8015e6:	f3 0f 1e fb          	endbr32 
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8015f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f3:	50                   	push   %eax
  8015f4:	e8 70 ee ff ff       	call   800469 <fd_alloc>
  8015f9:	83 c4 10             	add    $0x10,%esp
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	78 3a                	js     80163a <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801600:	83 ec 04             	sub    $0x4,%esp
  801603:	68 07 04 00 00       	push   $0x407
  801608:	ff 75 f4             	pushl  -0xc(%ebp)
  80160b:	6a 00                	push   $0x0
  80160d:	e8 68 eb ff ff       	call   80017a <sys_page_alloc>
  801612:	83 c4 10             	add    $0x10,%esp
  801615:	85 c0                	test   %eax,%eax
  801617:	78 21                	js     80163a <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801622:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801627:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80162e:	83 ec 0c             	sub    $0xc,%esp
  801631:	50                   	push   %eax
  801632:	e8 03 ee ff ff       	call   80043a <fd2num>
  801637:	83 c4 10             	add    $0x10,%esp
}
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80163c:	f3 0f 1e fb          	endbr32 
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	56                   	push   %esi
  801644:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801645:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801648:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80164e:	e8 e1 ea ff ff       	call   800134 <sys_getenvid>
  801653:	83 ec 0c             	sub    $0xc,%esp
  801656:	ff 75 0c             	pushl  0xc(%ebp)
  801659:	ff 75 08             	pushl  0x8(%ebp)
  80165c:	56                   	push   %esi
  80165d:	50                   	push   %eax
  80165e:	68 c0 25 80 00       	push   $0x8025c0
  801663:	e8 bb 00 00 00       	call   801723 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801668:	83 c4 18             	add    $0x18,%esp
  80166b:	53                   	push   %ebx
  80166c:	ff 75 10             	pushl  0x10(%ebp)
  80166f:	e8 5a 00 00 00       	call   8016ce <vcprintf>
	cprintf("\n");
  801674:	c7 04 24 f8 28 80 00 	movl   $0x8028f8,(%esp)
  80167b:	e8 a3 00 00 00       	call   801723 <cprintf>
  801680:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801683:	cc                   	int3   
  801684:	eb fd                	jmp    801683 <_panic+0x47>

00801686 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801686:	f3 0f 1e fb          	endbr32 
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	53                   	push   %ebx
  80168e:	83 ec 04             	sub    $0x4,%esp
  801691:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801694:	8b 13                	mov    (%ebx),%edx
  801696:	8d 42 01             	lea    0x1(%edx),%eax
  801699:	89 03                	mov    %eax,(%ebx)
  80169b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80169e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8016a2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8016a7:	74 09                	je     8016b2 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8016a9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8016ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8016b2:	83 ec 08             	sub    $0x8,%esp
  8016b5:	68 ff 00 00 00       	push   $0xff
  8016ba:	8d 43 08             	lea    0x8(%ebx),%eax
  8016bd:	50                   	push   %eax
  8016be:	e8 e7 e9 ff ff       	call   8000aa <sys_cputs>
		b->idx = 0;
  8016c3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8016c9:	83 c4 10             	add    $0x10,%esp
  8016cc:	eb db                	jmp    8016a9 <putch+0x23>

008016ce <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8016ce:	f3 0f 1e fb          	endbr32 
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8016db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8016e2:	00 00 00 
	b.cnt = 0;
  8016e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8016ec:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8016ef:	ff 75 0c             	pushl  0xc(%ebp)
  8016f2:	ff 75 08             	pushl  0x8(%ebp)
  8016f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8016fb:	50                   	push   %eax
  8016fc:	68 86 16 80 00       	push   $0x801686
  801701:	e8 20 01 00 00       	call   801826 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801706:	83 c4 08             	add    $0x8,%esp
  801709:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80170f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801715:	50                   	push   %eax
  801716:	e8 8f e9 ff ff       	call   8000aa <sys_cputs>

	return b.cnt;
}
  80171b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801723:	f3 0f 1e fb          	endbr32 
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
  80172a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80172d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801730:	50                   	push   %eax
  801731:	ff 75 08             	pushl  0x8(%ebp)
  801734:	e8 95 ff ff ff       	call   8016ce <vcprintf>
	va_end(ap);

	return cnt;
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	57                   	push   %edi
  80173f:	56                   	push   %esi
  801740:	53                   	push   %ebx
  801741:	83 ec 1c             	sub    $0x1c,%esp
  801744:	89 c7                	mov    %eax,%edi
  801746:	89 d6                	mov    %edx,%esi
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174e:	89 d1                	mov    %edx,%ecx
  801750:	89 c2                	mov    %eax,%edx
  801752:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801755:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801758:	8b 45 10             	mov    0x10(%ebp),%eax
  80175b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80175e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801761:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801768:	39 c2                	cmp    %eax,%edx
  80176a:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80176d:	72 3e                	jb     8017ad <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80176f:	83 ec 0c             	sub    $0xc,%esp
  801772:	ff 75 18             	pushl  0x18(%ebp)
  801775:	83 eb 01             	sub    $0x1,%ebx
  801778:	53                   	push   %ebx
  801779:	50                   	push   %eax
  80177a:	83 ec 08             	sub    $0x8,%esp
  80177d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801780:	ff 75 e0             	pushl  -0x20(%ebp)
  801783:	ff 75 dc             	pushl  -0x24(%ebp)
  801786:	ff 75 d8             	pushl  -0x28(%ebp)
  801789:	e8 72 0a 00 00       	call   802200 <__udivdi3>
  80178e:	83 c4 18             	add    $0x18,%esp
  801791:	52                   	push   %edx
  801792:	50                   	push   %eax
  801793:	89 f2                	mov    %esi,%edx
  801795:	89 f8                	mov    %edi,%eax
  801797:	e8 9f ff ff ff       	call   80173b <printnum>
  80179c:	83 c4 20             	add    $0x20,%esp
  80179f:	eb 13                	jmp    8017b4 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8017a1:	83 ec 08             	sub    $0x8,%esp
  8017a4:	56                   	push   %esi
  8017a5:	ff 75 18             	pushl  0x18(%ebp)
  8017a8:	ff d7                	call   *%edi
  8017aa:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8017ad:	83 eb 01             	sub    $0x1,%ebx
  8017b0:	85 db                	test   %ebx,%ebx
  8017b2:	7f ed                	jg     8017a1 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8017b4:	83 ec 08             	sub    $0x8,%esp
  8017b7:	56                   	push   %esi
  8017b8:	83 ec 04             	sub    $0x4,%esp
  8017bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017be:	ff 75 e0             	pushl  -0x20(%ebp)
  8017c1:	ff 75 dc             	pushl  -0x24(%ebp)
  8017c4:	ff 75 d8             	pushl  -0x28(%ebp)
  8017c7:	e8 44 0b 00 00       	call   802310 <__umoddi3>
  8017cc:	83 c4 14             	add    $0x14,%esp
  8017cf:	0f be 80 e3 25 80 00 	movsbl 0x8025e3(%eax),%eax
  8017d6:	50                   	push   %eax
  8017d7:	ff d7                	call   *%edi
}
  8017d9:	83 c4 10             	add    $0x10,%esp
  8017dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017df:	5b                   	pop    %ebx
  8017e0:	5e                   	pop    %esi
  8017e1:	5f                   	pop    %edi
  8017e2:	5d                   	pop    %ebp
  8017e3:	c3                   	ret    

008017e4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8017e4:	f3 0f 1e fb          	endbr32 
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8017ee:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8017f2:	8b 10                	mov    (%eax),%edx
  8017f4:	3b 50 04             	cmp    0x4(%eax),%edx
  8017f7:	73 0a                	jae    801803 <sprintputch+0x1f>
		*b->buf++ = ch;
  8017f9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017fc:	89 08                	mov    %ecx,(%eax)
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	88 02                	mov    %al,(%edx)
}
  801803:	5d                   	pop    %ebp
  801804:	c3                   	ret    

00801805 <printfmt>:
{
  801805:	f3 0f 1e fb          	endbr32 
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80180f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801812:	50                   	push   %eax
  801813:	ff 75 10             	pushl  0x10(%ebp)
  801816:	ff 75 0c             	pushl  0xc(%ebp)
  801819:	ff 75 08             	pushl  0x8(%ebp)
  80181c:	e8 05 00 00 00       	call   801826 <vprintfmt>
}
  801821:	83 c4 10             	add    $0x10,%esp
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <vprintfmt>:
{
  801826:	f3 0f 1e fb          	endbr32 
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	57                   	push   %edi
  80182e:	56                   	push   %esi
  80182f:	53                   	push   %ebx
  801830:	83 ec 3c             	sub    $0x3c,%esp
  801833:	8b 75 08             	mov    0x8(%ebp),%esi
  801836:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801839:	8b 7d 10             	mov    0x10(%ebp),%edi
  80183c:	e9 8e 03 00 00       	jmp    801bcf <vprintfmt+0x3a9>
		padc = ' ';
  801841:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801845:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80184c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801853:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80185a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80185f:	8d 47 01             	lea    0x1(%edi),%eax
  801862:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801865:	0f b6 17             	movzbl (%edi),%edx
  801868:	8d 42 dd             	lea    -0x23(%edx),%eax
  80186b:	3c 55                	cmp    $0x55,%al
  80186d:	0f 87 df 03 00 00    	ja     801c52 <vprintfmt+0x42c>
  801873:	0f b6 c0             	movzbl %al,%eax
  801876:	3e ff 24 85 20 27 80 	notrack jmp *0x802720(,%eax,4)
  80187d:	00 
  80187e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801881:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801885:	eb d8                	jmp    80185f <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801887:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80188a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80188e:	eb cf                	jmp    80185f <vprintfmt+0x39>
  801890:	0f b6 d2             	movzbl %dl,%edx
  801893:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801896:	b8 00 00 00 00       	mov    $0x0,%eax
  80189b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80189e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8018a1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8018a5:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8018a8:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8018ab:	83 f9 09             	cmp    $0x9,%ecx
  8018ae:	77 55                	ja     801905 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8018b0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8018b3:	eb e9                	jmp    80189e <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8018b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b8:	8b 00                	mov    (%eax),%eax
  8018ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c0:	8d 40 04             	lea    0x4(%eax),%eax
  8018c3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8018c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8018c9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018cd:	79 90                	jns    80185f <vprintfmt+0x39>
				width = precision, precision = -1;
  8018cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8018d5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8018dc:	eb 81                	jmp    80185f <vprintfmt+0x39>
  8018de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018e1:	85 c0                	test   %eax,%eax
  8018e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e8:	0f 49 d0             	cmovns %eax,%edx
  8018eb:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8018ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8018f1:	e9 69 ff ff ff       	jmp    80185f <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8018f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8018f9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801900:	e9 5a ff ff ff       	jmp    80185f <vprintfmt+0x39>
  801905:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801908:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80190b:	eb bc                	jmp    8018c9 <vprintfmt+0xa3>
			lflag++;
  80190d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801910:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801913:	e9 47 ff ff ff       	jmp    80185f <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  801918:	8b 45 14             	mov    0x14(%ebp),%eax
  80191b:	8d 78 04             	lea    0x4(%eax),%edi
  80191e:	83 ec 08             	sub    $0x8,%esp
  801921:	53                   	push   %ebx
  801922:	ff 30                	pushl  (%eax)
  801924:	ff d6                	call   *%esi
			break;
  801926:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801929:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80192c:	e9 9b 02 00 00       	jmp    801bcc <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  801931:	8b 45 14             	mov    0x14(%ebp),%eax
  801934:	8d 78 04             	lea    0x4(%eax),%edi
  801937:	8b 00                	mov    (%eax),%eax
  801939:	99                   	cltd   
  80193a:	31 d0                	xor    %edx,%eax
  80193c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80193e:	83 f8 0f             	cmp    $0xf,%eax
  801941:	7f 23                	jg     801966 <vprintfmt+0x140>
  801943:	8b 14 85 80 28 80 00 	mov    0x802880(,%eax,4),%edx
  80194a:	85 d2                	test   %edx,%edx
  80194c:	74 18                	je     801966 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80194e:	52                   	push   %edx
  80194f:	68 41 25 80 00       	push   $0x802541
  801954:	53                   	push   %ebx
  801955:	56                   	push   %esi
  801956:	e8 aa fe ff ff       	call   801805 <printfmt>
  80195b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80195e:	89 7d 14             	mov    %edi,0x14(%ebp)
  801961:	e9 66 02 00 00       	jmp    801bcc <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  801966:	50                   	push   %eax
  801967:	68 fb 25 80 00       	push   $0x8025fb
  80196c:	53                   	push   %ebx
  80196d:	56                   	push   %esi
  80196e:	e8 92 fe ff ff       	call   801805 <printfmt>
  801973:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801976:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801979:	e9 4e 02 00 00       	jmp    801bcc <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80197e:	8b 45 14             	mov    0x14(%ebp),%eax
  801981:	83 c0 04             	add    $0x4,%eax
  801984:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801987:	8b 45 14             	mov    0x14(%ebp),%eax
  80198a:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80198c:	85 d2                	test   %edx,%edx
  80198e:	b8 f4 25 80 00       	mov    $0x8025f4,%eax
  801993:	0f 45 c2             	cmovne %edx,%eax
  801996:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801999:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80199d:	7e 06                	jle    8019a5 <vprintfmt+0x17f>
  80199f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8019a3:	75 0d                	jne    8019b2 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8019a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019a8:	89 c7                	mov    %eax,%edi
  8019aa:	03 45 e0             	add    -0x20(%ebp),%eax
  8019ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019b0:	eb 55                	jmp    801a07 <vprintfmt+0x1e1>
  8019b2:	83 ec 08             	sub    $0x8,%esp
  8019b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8019b8:	ff 75 cc             	pushl  -0x34(%ebp)
  8019bb:	e8 46 03 00 00       	call   801d06 <strnlen>
  8019c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019c3:	29 c2                	sub    %eax,%edx
  8019c5:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8019c8:	83 c4 10             	add    $0x10,%esp
  8019cb:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8019cd:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8019d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8019d4:	85 ff                	test   %edi,%edi
  8019d6:	7e 11                	jle    8019e9 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8019d8:	83 ec 08             	sub    $0x8,%esp
  8019db:	53                   	push   %ebx
  8019dc:	ff 75 e0             	pushl  -0x20(%ebp)
  8019df:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8019e1:	83 ef 01             	sub    $0x1,%edi
  8019e4:	83 c4 10             	add    $0x10,%esp
  8019e7:	eb eb                	jmp    8019d4 <vprintfmt+0x1ae>
  8019e9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8019ec:	85 d2                	test   %edx,%edx
  8019ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f3:	0f 49 c2             	cmovns %edx,%eax
  8019f6:	29 c2                	sub    %eax,%edx
  8019f8:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8019fb:	eb a8                	jmp    8019a5 <vprintfmt+0x17f>
					putch(ch, putdat);
  8019fd:	83 ec 08             	sub    $0x8,%esp
  801a00:	53                   	push   %ebx
  801a01:	52                   	push   %edx
  801a02:	ff d6                	call   *%esi
  801a04:	83 c4 10             	add    $0x10,%esp
  801a07:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801a0a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a0c:	83 c7 01             	add    $0x1,%edi
  801a0f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a13:	0f be d0             	movsbl %al,%edx
  801a16:	85 d2                	test   %edx,%edx
  801a18:	74 4b                	je     801a65 <vprintfmt+0x23f>
  801a1a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801a1e:	78 06                	js     801a26 <vprintfmt+0x200>
  801a20:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801a24:	78 1e                	js     801a44 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  801a26:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801a2a:	74 d1                	je     8019fd <vprintfmt+0x1d7>
  801a2c:	0f be c0             	movsbl %al,%eax
  801a2f:	83 e8 20             	sub    $0x20,%eax
  801a32:	83 f8 5e             	cmp    $0x5e,%eax
  801a35:	76 c6                	jbe    8019fd <vprintfmt+0x1d7>
					putch('?', putdat);
  801a37:	83 ec 08             	sub    $0x8,%esp
  801a3a:	53                   	push   %ebx
  801a3b:	6a 3f                	push   $0x3f
  801a3d:	ff d6                	call   *%esi
  801a3f:	83 c4 10             	add    $0x10,%esp
  801a42:	eb c3                	jmp    801a07 <vprintfmt+0x1e1>
  801a44:	89 cf                	mov    %ecx,%edi
  801a46:	eb 0e                	jmp    801a56 <vprintfmt+0x230>
				putch(' ', putdat);
  801a48:	83 ec 08             	sub    $0x8,%esp
  801a4b:	53                   	push   %ebx
  801a4c:	6a 20                	push   $0x20
  801a4e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801a50:	83 ef 01             	sub    $0x1,%edi
  801a53:	83 c4 10             	add    $0x10,%esp
  801a56:	85 ff                	test   %edi,%edi
  801a58:	7f ee                	jg     801a48 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  801a5a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a5d:	89 45 14             	mov    %eax,0x14(%ebp)
  801a60:	e9 67 01 00 00       	jmp    801bcc <vprintfmt+0x3a6>
  801a65:	89 cf                	mov    %ecx,%edi
  801a67:	eb ed                	jmp    801a56 <vprintfmt+0x230>
	if (lflag >= 2)
  801a69:	83 f9 01             	cmp    $0x1,%ecx
  801a6c:	7f 1b                	jg     801a89 <vprintfmt+0x263>
	else if (lflag)
  801a6e:	85 c9                	test   %ecx,%ecx
  801a70:	74 63                	je     801ad5 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  801a72:	8b 45 14             	mov    0x14(%ebp),%eax
  801a75:	8b 00                	mov    (%eax),%eax
  801a77:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a7a:	99                   	cltd   
  801a7b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a7e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a81:	8d 40 04             	lea    0x4(%eax),%eax
  801a84:	89 45 14             	mov    %eax,0x14(%ebp)
  801a87:	eb 17                	jmp    801aa0 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801a89:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8c:	8b 50 04             	mov    0x4(%eax),%edx
  801a8f:	8b 00                	mov    (%eax),%eax
  801a91:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a94:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a97:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9a:	8d 40 08             	lea    0x8(%eax),%eax
  801a9d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801aa0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801aa3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801aa6:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801aab:	85 c9                	test   %ecx,%ecx
  801aad:	0f 89 ff 00 00 00    	jns    801bb2 <vprintfmt+0x38c>
				putch('-', putdat);
  801ab3:	83 ec 08             	sub    $0x8,%esp
  801ab6:	53                   	push   %ebx
  801ab7:	6a 2d                	push   $0x2d
  801ab9:	ff d6                	call   *%esi
				num = -(long long) num;
  801abb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801abe:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801ac1:	f7 da                	neg    %edx
  801ac3:	83 d1 00             	adc    $0x0,%ecx
  801ac6:	f7 d9                	neg    %ecx
  801ac8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801acb:	b8 0a 00 00 00       	mov    $0xa,%eax
  801ad0:	e9 dd 00 00 00       	jmp    801bb2 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad8:	8b 00                	mov    (%eax),%eax
  801ada:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801add:	99                   	cltd   
  801ade:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801ae1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae4:	8d 40 04             	lea    0x4(%eax),%eax
  801ae7:	89 45 14             	mov    %eax,0x14(%ebp)
  801aea:	eb b4                	jmp    801aa0 <vprintfmt+0x27a>
	if (lflag >= 2)
  801aec:	83 f9 01             	cmp    $0x1,%ecx
  801aef:	7f 1e                	jg     801b0f <vprintfmt+0x2e9>
	else if (lflag)
  801af1:	85 c9                	test   %ecx,%ecx
  801af3:	74 32                	je     801b27 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801af5:	8b 45 14             	mov    0x14(%ebp),%eax
  801af8:	8b 10                	mov    (%eax),%edx
  801afa:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aff:	8d 40 04             	lea    0x4(%eax),%eax
  801b02:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b05:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801b0a:	e9 a3 00 00 00       	jmp    801bb2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b0f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b12:	8b 10                	mov    (%eax),%edx
  801b14:	8b 48 04             	mov    0x4(%eax),%ecx
  801b17:	8d 40 08             	lea    0x8(%eax),%eax
  801b1a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b1d:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  801b22:	e9 8b 00 00 00       	jmp    801bb2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b27:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2a:	8b 10                	mov    (%eax),%edx
  801b2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b31:	8d 40 04             	lea    0x4(%eax),%eax
  801b34:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801b37:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  801b3c:	eb 74                	jmp    801bb2 <vprintfmt+0x38c>
	if (lflag >= 2)
  801b3e:	83 f9 01             	cmp    $0x1,%ecx
  801b41:	7f 1b                	jg     801b5e <vprintfmt+0x338>
	else if (lflag)
  801b43:	85 c9                	test   %ecx,%ecx
  801b45:	74 2c                	je     801b73 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801b47:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4a:	8b 10                	mov    (%eax),%edx
  801b4c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b51:	8d 40 04             	lea    0x4(%eax),%eax
  801b54:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b57:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801b5c:	eb 54                	jmp    801bb2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b5e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b61:	8b 10                	mov    (%eax),%edx
  801b63:	8b 48 04             	mov    0x4(%eax),%ecx
  801b66:	8d 40 08             	lea    0x8(%eax),%eax
  801b69:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b6c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801b71:	eb 3f                	jmp    801bb2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b73:	8b 45 14             	mov    0x14(%ebp),%eax
  801b76:	8b 10                	mov    (%eax),%edx
  801b78:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b7d:	8d 40 04             	lea    0x4(%eax),%eax
  801b80:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b83:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801b88:	eb 28                	jmp    801bb2 <vprintfmt+0x38c>
			putch('0', putdat);
  801b8a:	83 ec 08             	sub    $0x8,%esp
  801b8d:	53                   	push   %ebx
  801b8e:	6a 30                	push   $0x30
  801b90:	ff d6                	call   *%esi
			putch('x', putdat);
  801b92:	83 c4 08             	add    $0x8,%esp
  801b95:	53                   	push   %ebx
  801b96:	6a 78                	push   $0x78
  801b98:	ff d6                	call   *%esi
			num = (unsigned long long)
  801b9a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b9d:	8b 10                	mov    (%eax),%edx
  801b9f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801ba4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801ba7:	8d 40 04             	lea    0x4(%eax),%eax
  801baa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801bad:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801bb2:	83 ec 0c             	sub    $0xc,%esp
  801bb5:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801bb9:	57                   	push   %edi
  801bba:	ff 75 e0             	pushl  -0x20(%ebp)
  801bbd:	50                   	push   %eax
  801bbe:	51                   	push   %ecx
  801bbf:	52                   	push   %edx
  801bc0:	89 da                	mov    %ebx,%edx
  801bc2:	89 f0                	mov    %esi,%eax
  801bc4:	e8 72 fb ff ff       	call   80173b <printnum>
			break;
  801bc9:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801bcc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801bcf:	83 c7 01             	add    $0x1,%edi
  801bd2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801bd6:	83 f8 25             	cmp    $0x25,%eax
  801bd9:	0f 84 62 fc ff ff    	je     801841 <vprintfmt+0x1b>
			if (ch == '\0')
  801bdf:	85 c0                	test   %eax,%eax
  801be1:	0f 84 8b 00 00 00    	je     801c72 <vprintfmt+0x44c>
			putch(ch, putdat);
  801be7:	83 ec 08             	sub    $0x8,%esp
  801bea:	53                   	push   %ebx
  801beb:	50                   	push   %eax
  801bec:	ff d6                	call   *%esi
  801bee:	83 c4 10             	add    $0x10,%esp
  801bf1:	eb dc                	jmp    801bcf <vprintfmt+0x3a9>
	if (lflag >= 2)
  801bf3:	83 f9 01             	cmp    $0x1,%ecx
  801bf6:	7f 1b                	jg     801c13 <vprintfmt+0x3ed>
	else if (lflag)
  801bf8:	85 c9                	test   %ecx,%ecx
  801bfa:	74 2c                	je     801c28 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801bfc:	8b 45 14             	mov    0x14(%ebp),%eax
  801bff:	8b 10                	mov    (%eax),%edx
  801c01:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c06:	8d 40 04             	lea    0x4(%eax),%eax
  801c09:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c0c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  801c11:	eb 9f                	jmp    801bb2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801c13:	8b 45 14             	mov    0x14(%ebp),%eax
  801c16:	8b 10                	mov    (%eax),%edx
  801c18:	8b 48 04             	mov    0x4(%eax),%ecx
  801c1b:	8d 40 08             	lea    0x8(%eax),%eax
  801c1e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c21:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  801c26:	eb 8a                	jmp    801bb2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801c28:	8b 45 14             	mov    0x14(%ebp),%eax
  801c2b:	8b 10                	mov    (%eax),%edx
  801c2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c32:	8d 40 04             	lea    0x4(%eax),%eax
  801c35:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801c38:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  801c3d:	e9 70 ff ff ff       	jmp    801bb2 <vprintfmt+0x38c>
			putch(ch, putdat);
  801c42:	83 ec 08             	sub    $0x8,%esp
  801c45:	53                   	push   %ebx
  801c46:	6a 25                	push   $0x25
  801c48:	ff d6                	call   *%esi
			break;
  801c4a:	83 c4 10             	add    $0x10,%esp
  801c4d:	e9 7a ff ff ff       	jmp    801bcc <vprintfmt+0x3a6>
			putch('%', putdat);
  801c52:	83 ec 08             	sub    $0x8,%esp
  801c55:	53                   	push   %ebx
  801c56:	6a 25                	push   $0x25
  801c58:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801c5a:	83 c4 10             	add    $0x10,%esp
  801c5d:	89 f8                	mov    %edi,%eax
  801c5f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801c63:	74 05                	je     801c6a <vprintfmt+0x444>
  801c65:	83 e8 01             	sub    $0x1,%eax
  801c68:	eb f5                	jmp    801c5f <vprintfmt+0x439>
  801c6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c6d:	e9 5a ff ff ff       	jmp    801bcc <vprintfmt+0x3a6>
}
  801c72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c75:	5b                   	pop    %ebx
  801c76:	5e                   	pop    %esi
  801c77:	5f                   	pop    %edi
  801c78:	5d                   	pop    %ebp
  801c79:	c3                   	ret    

00801c7a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801c7a:	f3 0f 1e fb          	endbr32 
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
  801c81:	83 ec 18             	sub    $0x18,%esp
  801c84:	8b 45 08             	mov    0x8(%ebp),%eax
  801c87:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801c8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c8d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801c91:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801c94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801c9b:	85 c0                	test   %eax,%eax
  801c9d:	74 26                	je     801cc5 <vsnprintf+0x4b>
  801c9f:	85 d2                	test   %edx,%edx
  801ca1:	7e 22                	jle    801cc5 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801ca3:	ff 75 14             	pushl  0x14(%ebp)
  801ca6:	ff 75 10             	pushl  0x10(%ebp)
  801ca9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801cac:	50                   	push   %eax
  801cad:	68 e4 17 80 00       	push   $0x8017e4
  801cb2:	e8 6f fb ff ff       	call   801826 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801cb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cba:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc0:	83 c4 10             	add    $0x10,%esp
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    
		return -E_INVAL;
  801cc5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cca:	eb f7                	jmp    801cc3 <vsnprintf+0x49>

00801ccc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801ccc:	f3 0f 1e fb          	endbr32 
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801cd6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801cd9:	50                   	push   %eax
  801cda:	ff 75 10             	pushl  0x10(%ebp)
  801cdd:	ff 75 0c             	pushl  0xc(%ebp)
  801ce0:	ff 75 08             	pushl  0x8(%ebp)
  801ce3:	e8 92 ff ff ff       	call   801c7a <vsnprintf>
	va_end(ap);

	return rc;
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801cea:	f3 0f 1e fb          	endbr32 
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
  801cf1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801cfd:	74 05                	je     801d04 <strlen+0x1a>
		n++;
  801cff:	83 c0 01             	add    $0x1,%eax
  801d02:	eb f5                	jmp    801cf9 <strlen+0xf>
	return n;
}
  801d04:	5d                   	pop    %ebp
  801d05:	c3                   	ret    

00801d06 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801d06:	f3 0f 1e fb          	endbr32 
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d10:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d13:	b8 00 00 00 00       	mov    $0x0,%eax
  801d18:	39 d0                	cmp    %edx,%eax
  801d1a:	74 0d                	je     801d29 <strnlen+0x23>
  801d1c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801d20:	74 05                	je     801d27 <strnlen+0x21>
		n++;
  801d22:	83 c0 01             	add    $0x1,%eax
  801d25:	eb f1                	jmp    801d18 <strnlen+0x12>
  801d27:	89 c2                	mov    %eax,%edx
	return n;
}
  801d29:	89 d0                	mov    %edx,%eax
  801d2b:	5d                   	pop    %ebp
  801d2c:	c3                   	ret    

00801d2d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801d2d:	f3 0f 1e fb          	endbr32 
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
  801d34:	53                   	push   %ebx
  801d35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d38:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d40:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801d44:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801d47:	83 c0 01             	add    $0x1,%eax
  801d4a:	84 d2                	test   %dl,%dl
  801d4c:	75 f2                	jne    801d40 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801d4e:	89 c8                	mov    %ecx,%eax
  801d50:	5b                   	pop    %ebx
  801d51:	5d                   	pop    %ebp
  801d52:	c3                   	ret    

00801d53 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801d53:	f3 0f 1e fb          	endbr32 
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	53                   	push   %ebx
  801d5b:	83 ec 10             	sub    $0x10,%esp
  801d5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801d61:	53                   	push   %ebx
  801d62:	e8 83 ff ff ff       	call   801cea <strlen>
  801d67:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801d6a:	ff 75 0c             	pushl  0xc(%ebp)
  801d6d:	01 d8                	add    %ebx,%eax
  801d6f:	50                   	push   %eax
  801d70:	e8 b8 ff ff ff       	call   801d2d <strcpy>
	return dst;
}
  801d75:	89 d8                	mov    %ebx,%eax
  801d77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801d7c:	f3 0f 1e fb          	endbr32 
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	56                   	push   %esi
  801d84:	53                   	push   %ebx
  801d85:	8b 75 08             	mov    0x8(%ebp),%esi
  801d88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8b:	89 f3                	mov    %esi,%ebx
  801d8d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801d90:	89 f0                	mov    %esi,%eax
  801d92:	39 d8                	cmp    %ebx,%eax
  801d94:	74 11                	je     801da7 <strncpy+0x2b>
		*dst++ = *src;
  801d96:	83 c0 01             	add    $0x1,%eax
  801d99:	0f b6 0a             	movzbl (%edx),%ecx
  801d9c:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801d9f:	80 f9 01             	cmp    $0x1,%cl
  801da2:	83 da ff             	sbb    $0xffffffff,%edx
  801da5:	eb eb                	jmp    801d92 <strncpy+0x16>
	}
	return ret;
}
  801da7:	89 f0                	mov    %esi,%eax
  801da9:	5b                   	pop    %ebx
  801daa:	5e                   	pop    %esi
  801dab:	5d                   	pop    %ebp
  801dac:	c3                   	ret    

00801dad <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801dad:	f3 0f 1e fb          	endbr32 
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	56                   	push   %esi
  801db5:	53                   	push   %ebx
  801db6:	8b 75 08             	mov    0x8(%ebp),%esi
  801db9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dbc:	8b 55 10             	mov    0x10(%ebp),%edx
  801dbf:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801dc1:	85 d2                	test   %edx,%edx
  801dc3:	74 21                	je     801de6 <strlcpy+0x39>
  801dc5:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801dc9:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801dcb:	39 c2                	cmp    %eax,%edx
  801dcd:	74 14                	je     801de3 <strlcpy+0x36>
  801dcf:	0f b6 19             	movzbl (%ecx),%ebx
  801dd2:	84 db                	test   %bl,%bl
  801dd4:	74 0b                	je     801de1 <strlcpy+0x34>
			*dst++ = *src++;
  801dd6:	83 c1 01             	add    $0x1,%ecx
  801dd9:	83 c2 01             	add    $0x1,%edx
  801ddc:	88 5a ff             	mov    %bl,-0x1(%edx)
  801ddf:	eb ea                	jmp    801dcb <strlcpy+0x1e>
  801de1:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801de3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801de6:	29 f0                	sub    %esi,%eax
}
  801de8:	5b                   	pop    %ebx
  801de9:	5e                   	pop    %esi
  801dea:	5d                   	pop    %ebp
  801deb:	c3                   	ret    

00801dec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801dec:	f3 0f 1e fb          	endbr32 
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801df6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801df9:	0f b6 01             	movzbl (%ecx),%eax
  801dfc:	84 c0                	test   %al,%al
  801dfe:	74 0c                	je     801e0c <strcmp+0x20>
  801e00:	3a 02                	cmp    (%edx),%al
  801e02:	75 08                	jne    801e0c <strcmp+0x20>
		p++, q++;
  801e04:	83 c1 01             	add    $0x1,%ecx
  801e07:	83 c2 01             	add    $0x1,%edx
  801e0a:	eb ed                	jmp    801df9 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e0c:	0f b6 c0             	movzbl %al,%eax
  801e0f:	0f b6 12             	movzbl (%edx),%edx
  801e12:	29 d0                	sub    %edx,%eax
}
  801e14:	5d                   	pop    %ebp
  801e15:	c3                   	ret    

00801e16 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801e16:	f3 0f 1e fb          	endbr32 
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	53                   	push   %ebx
  801e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e24:	89 c3                	mov    %eax,%ebx
  801e26:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801e29:	eb 06                	jmp    801e31 <strncmp+0x1b>
		n--, p++, q++;
  801e2b:	83 c0 01             	add    $0x1,%eax
  801e2e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801e31:	39 d8                	cmp    %ebx,%eax
  801e33:	74 16                	je     801e4b <strncmp+0x35>
  801e35:	0f b6 08             	movzbl (%eax),%ecx
  801e38:	84 c9                	test   %cl,%cl
  801e3a:	74 04                	je     801e40 <strncmp+0x2a>
  801e3c:	3a 0a                	cmp    (%edx),%cl
  801e3e:	74 eb                	je     801e2b <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801e40:	0f b6 00             	movzbl (%eax),%eax
  801e43:	0f b6 12             	movzbl (%edx),%edx
  801e46:	29 d0                	sub    %edx,%eax
}
  801e48:	5b                   	pop    %ebx
  801e49:	5d                   	pop    %ebp
  801e4a:	c3                   	ret    
		return 0;
  801e4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e50:	eb f6                	jmp    801e48 <strncmp+0x32>

00801e52 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801e52:	f3 0f 1e fb          	endbr32 
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e60:	0f b6 10             	movzbl (%eax),%edx
  801e63:	84 d2                	test   %dl,%dl
  801e65:	74 09                	je     801e70 <strchr+0x1e>
		if (*s == c)
  801e67:	38 ca                	cmp    %cl,%dl
  801e69:	74 0a                	je     801e75 <strchr+0x23>
	for (; *s; s++)
  801e6b:	83 c0 01             	add    $0x1,%eax
  801e6e:	eb f0                	jmp    801e60 <strchr+0xe>
			return (char *) s;
	return 0;
  801e70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e75:	5d                   	pop    %ebp
  801e76:	c3                   	ret    

00801e77 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801e77:	f3 0f 1e fb          	endbr32 
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e85:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801e88:	38 ca                	cmp    %cl,%dl
  801e8a:	74 09                	je     801e95 <strfind+0x1e>
  801e8c:	84 d2                	test   %dl,%dl
  801e8e:	74 05                	je     801e95 <strfind+0x1e>
	for (; *s; s++)
  801e90:	83 c0 01             	add    $0x1,%eax
  801e93:	eb f0                	jmp    801e85 <strfind+0xe>
			break;
	return (char *) s;
}
  801e95:	5d                   	pop    %ebp
  801e96:	c3                   	ret    

00801e97 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801e97:	f3 0f 1e fb          	endbr32 
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	57                   	push   %edi
  801e9f:	56                   	push   %esi
  801ea0:	53                   	push   %ebx
  801ea1:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ea4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801ea7:	85 c9                	test   %ecx,%ecx
  801ea9:	74 31                	je     801edc <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801eab:	89 f8                	mov    %edi,%eax
  801ead:	09 c8                	or     %ecx,%eax
  801eaf:	a8 03                	test   $0x3,%al
  801eb1:	75 23                	jne    801ed6 <memset+0x3f>
		c &= 0xFF;
  801eb3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801eb7:	89 d3                	mov    %edx,%ebx
  801eb9:	c1 e3 08             	shl    $0x8,%ebx
  801ebc:	89 d0                	mov    %edx,%eax
  801ebe:	c1 e0 18             	shl    $0x18,%eax
  801ec1:	89 d6                	mov    %edx,%esi
  801ec3:	c1 e6 10             	shl    $0x10,%esi
  801ec6:	09 f0                	or     %esi,%eax
  801ec8:	09 c2                	or     %eax,%edx
  801eca:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801ecc:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801ecf:	89 d0                	mov    %edx,%eax
  801ed1:	fc                   	cld    
  801ed2:	f3 ab                	rep stos %eax,%es:(%edi)
  801ed4:	eb 06                	jmp    801edc <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed9:	fc                   	cld    
  801eda:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801edc:	89 f8                	mov    %edi,%eax
  801ede:	5b                   	pop    %ebx
  801edf:	5e                   	pop    %esi
  801ee0:	5f                   	pop    %edi
  801ee1:	5d                   	pop    %ebp
  801ee2:	c3                   	ret    

00801ee3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801ee3:	f3 0f 1e fb          	endbr32 
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
  801eea:	57                   	push   %edi
  801eeb:	56                   	push   %esi
  801eec:	8b 45 08             	mov    0x8(%ebp),%eax
  801eef:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ef2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801ef5:	39 c6                	cmp    %eax,%esi
  801ef7:	73 32                	jae    801f2b <memmove+0x48>
  801ef9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801efc:	39 c2                	cmp    %eax,%edx
  801efe:	76 2b                	jbe    801f2b <memmove+0x48>
		s += n;
		d += n;
  801f00:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801f03:	89 fe                	mov    %edi,%esi
  801f05:	09 ce                	or     %ecx,%esi
  801f07:	09 d6                	or     %edx,%esi
  801f09:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801f0f:	75 0e                	jne    801f1f <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801f11:	83 ef 04             	sub    $0x4,%edi
  801f14:	8d 72 fc             	lea    -0x4(%edx),%esi
  801f17:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801f1a:	fd                   	std    
  801f1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801f1d:	eb 09                	jmp    801f28 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801f1f:	83 ef 01             	sub    $0x1,%edi
  801f22:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801f25:	fd                   	std    
  801f26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801f28:	fc                   	cld    
  801f29:	eb 1a                	jmp    801f45 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801f2b:	89 c2                	mov    %eax,%edx
  801f2d:	09 ca                	or     %ecx,%edx
  801f2f:	09 f2                	or     %esi,%edx
  801f31:	f6 c2 03             	test   $0x3,%dl
  801f34:	75 0a                	jne    801f40 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801f36:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801f39:	89 c7                	mov    %eax,%edi
  801f3b:	fc                   	cld    
  801f3c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801f3e:	eb 05                	jmp    801f45 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801f40:	89 c7                	mov    %eax,%edi
  801f42:	fc                   	cld    
  801f43:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801f45:	5e                   	pop    %esi
  801f46:	5f                   	pop    %edi
  801f47:	5d                   	pop    %ebp
  801f48:	c3                   	ret    

00801f49 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801f49:	f3 0f 1e fb          	endbr32 
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801f53:	ff 75 10             	pushl  0x10(%ebp)
  801f56:	ff 75 0c             	pushl  0xc(%ebp)
  801f59:	ff 75 08             	pushl  0x8(%ebp)
  801f5c:	e8 82 ff ff ff       	call   801ee3 <memmove>
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801f63:	f3 0f 1e fb          	endbr32 
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	56                   	push   %esi
  801f6b:	53                   	push   %ebx
  801f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f72:	89 c6                	mov    %eax,%esi
  801f74:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801f77:	39 f0                	cmp    %esi,%eax
  801f79:	74 1c                	je     801f97 <memcmp+0x34>
		if (*s1 != *s2)
  801f7b:	0f b6 08             	movzbl (%eax),%ecx
  801f7e:	0f b6 1a             	movzbl (%edx),%ebx
  801f81:	38 d9                	cmp    %bl,%cl
  801f83:	75 08                	jne    801f8d <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801f85:	83 c0 01             	add    $0x1,%eax
  801f88:	83 c2 01             	add    $0x1,%edx
  801f8b:	eb ea                	jmp    801f77 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801f8d:	0f b6 c1             	movzbl %cl,%eax
  801f90:	0f b6 db             	movzbl %bl,%ebx
  801f93:	29 d8                	sub    %ebx,%eax
  801f95:	eb 05                	jmp    801f9c <memcmp+0x39>
	}

	return 0;
  801f97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f9c:	5b                   	pop    %ebx
  801f9d:	5e                   	pop    %esi
  801f9e:	5d                   	pop    %ebp
  801f9f:	c3                   	ret    

00801fa0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801fa0:	f3 0f 1e fb          	endbr32 
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801fad:	89 c2                	mov    %eax,%edx
  801faf:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801fb2:	39 d0                	cmp    %edx,%eax
  801fb4:	73 09                	jae    801fbf <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801fb6:	38 08                	cmp    %cl,(%eax)
  801fb8:	74 05                	je     801fbf <memfind+0x1f>
	for (; s < ends; s++)
  801fba:	83 c0 01             	add    $0x1,%eax
  801fbd:	eb f3                	jmp    801fb2 <memfind+0x12>
			break;
	return (void *) s;
}
  801fbf:	5d                   	pop    %ebp
  801fc0:	c3                   	ret    

00801fc1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801fc1:	f3 0f 1e fb          	endbr32 
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	57                   	push   %edi
  801fc9:	56                   	push   %esi
  801fca:	53                   	push   %ebx
  801fcb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801fd1:	eb 03                	jmp    801fd6 <strtol+0x15>
		s++;
  801fd3:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801fd6:	0f b6 01             	movzbl (%ecx),%eax
  801fd9:	3c 20                	cmp    $0x20,%al
  801fdb:	74 f6                	je     801fd3 <strtol+0x12>
  801fdd:	3c 09                	cmp    $0x9,%al
  801fdf:	74 f2                	je     801fd3 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801fe1:	3c 2b                	cmp    $0x2b,%al
  801fe3:	74 2a                	je     80200f <strtol+0x4e>
	int neg = 0;
  801fe5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801fea:	3c 2d                	cmp    $0x2d,%al
  801fec:	74 2b                	je     802019 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801fee:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801ff4:	75 0f                	jne    802005 <strtol+0x44>
  801ff6:	80 39 30             	cmpb   $0x30,(%ecx)
  801ff9:	74 28                	je     802023 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801ffb:	85 db                	test   %ebx,%ebx
  801ffd:	b8 0a 00 00 00       	mov    $0xa,%eax
  802002:	0f 44 d8             	cmove  %eax,%ebx
  802005:	b8 00 00 00 00       	mov    $0x0,%eax
  80200a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80200d:	eb 46                	jmp    802055 <strtol+0x94>
		s++;
  80200f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  802012:	bf 00 00 00 00       	mov    $0x0,%edi
  802017:	eb d5                	jmp    801fee <strtol+0x2d>
		s++, neg = 1;
  802019:	83 c1 01             	add    $0x1,%ecx
  80201c:	bf 01 00 00 00       	mov    $0x1,%edi
  802021:	eb cb                	jmp    801fee <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802023:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  802027:	74 0e                	je     802037 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  802029:	85 db                	test   %ebx,%ebx
  80202b:	75 d8                	jne    802005 <strtol+0x44>
		s++, base = 8;
  80202d:	83 c1 01             	add    $0x1,%ecx
  802030:	bb 08 00 00 00       	mov    $0x8,%ebx
  802035:	eb ce                	jmp    802005 <strtol+0x44>
		s += 2, base = 16;
  802037:	83 c1 02             	add    $0x2,%ecx
  80203a:	bb 10 00 00 00       	mov    $0x10,%ebx
  80203f:	eb c4                	jmp    802005 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  802041:	0f be d2             	movsbl %dl,%edx
  802044:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  802047:	3b 55 10             	cmp    0x10(%ebp),%edx
  80204a:	7d 3a                	jge    802086 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  80204c:	83 c1 01             	add    $0x1,%ecx
  80204f:	0f af 45 10          	imul   0x10(%ebp),%eax
  802053:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  802055:	0f b6 11             	movzbl (%ecx),%edx
  802058:	8d 72 d0             	lea    -0x30(%edx),%esi
  80205b:	89 f3                	mov    %esi,%ebx
  80205d:	80 fb 09             	cmp    $0x9,%bl
  802060:	76 df                	jbe    802041 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  802062:	8d 72 9f             	lea    -0x61(%edx),%esi
  802065:	89 f3                	mov    %esi,%ebx
  802067:	80 fb 19             	cmp    $0x19,%bl
  80206a:	77 08                	ja     802074 <strtol+0xb3>
			dig = *s - 'a' + 10;
  80206c:	0f be d2             	movsbl %dl,%edx
  80206f:	83 ea 57             	sub    $0x57,%edx
  802072:	eb d3                	jmp    802047 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  802074:	8d 72 bf             	lea    -0x41(%edx),%esi
  802077:	89 f3                	mov    %esi,%ebx
  802079:	80 fb 19             	cmp    $0x19,%bl
  80207c:	77 08                	ja     802086 <strtol+0xc5>
			dig = *s - 'A' + 10;
  80207e:	0f be d2             	movsbl %dl,%edx
  802081:	83 ea 37             	sub    $0x37,%edx
  802084:	eb c1                	jmp    802047 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  802086:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80208a:	74 05                	je     802091 <strtol+0xd0>
		*endptr = (char *) s;
  80208c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80208f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  802091:	89 c2                	mov    %eax,%edx
  802093:	f7 da                	neg    %edx
  802095:	85 ff                	test   %edi,%edi
  802097:	0f 45 c2             	cmovne %edx,%eax
}
  80209a:	5b                   	pop    %ebx
  80209b:	5e                   	pop    %esi
  80209c:	5f                   	pop    %edi
  80209d:	5d                   	pop    %ebp
  80209e:	c3                   	ret    

0080209f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80209f:	f3 0f 1e fb          	endbr32 
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
  8020a6:	56                   	push   %esi
  8020a7:	53                   	push   %ebx
  8020a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8020ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  8020b1:	85 c0                	test   %eax,%eax
  8020b3:	74 3d                	je     8020f2 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  8020b5:	83 ec 0c             	sub    $0xc,%esp
  8020b8:	50                   	push   %eax
  8020b9:	e8 88 e2 ff ff       	call   800346 <sys_ipc_recv>
  8020be:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  8020c1:	85 f6                	test   %esi,%esi
  8020c3:	74 0b                	je     8020d0 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8020c5:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020cb:	8b 52 74             	mov    0x74(%edx),%edx
  8020ce:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  8020d0:	85 db                	test   %ebx,%ebx
  8020d2:	74 0b                	je     8020df <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  8020d4:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020da:	8b 52 78             	mov    0x78(%edx),%edx
  8020dd:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  8020df:	85 c0                	test   %eax,%eax
  8020e1:	78 21                	js     802104 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  8020e3:	a1 08 40 80 00       	mov    0x804008,%eax
  8020e8:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ee:	5b                   	pop    %ebx
  8020ef:	5e                   	pop    %esi
  8020f0:	5d                   	pop    %ebp
  8020f1:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  8020f2:	83 ec 0c             	sub    $0xc,%esp
  8020f5:	68 00 00 c0 ee       	push   $0xeec00000
  8020fa:	e8 47 e2 ff ff       	call   800346 <sys_ipc_recv>
  8020ff:	83 c4 10             	add    $0x10,%esp
  802102:	eb bd                	jmp    8020c1 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802104:	85 f6                	test   %esi,%esi
  802106:	74 10                	je     802118 <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802108:	85 db                	test   %ebx,%ebx
  80210a:	75 df                	jne    8020eb <ipc_recv+0x4c>
  80210c:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802113:	00 00 00 
  802116:	eb d3                	jmp    8020eb <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802118:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80211f:	00 00 00 
  802122:	eb e4                	jmp    802108 <ipc_recv+0x69>

00802124 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802124:	f3 0f 1e fb          	endbr32 
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	57                   	push   %edi
  80212c:	56                   	push   %esi
  80212d:	53                   	push   %ebx
  80212e:	83 ec 0c             	sub    $0xc,%esp
  802131:	8b 7d 08             	mov    0x8(%ebp),%edi
  802134:	8b 75 0c             	mov    0xc(%ebp),%esi
  802137:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  80213a:	85 db                	test   %ebx,%ebx
  80213c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802141:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802144:	ff 75 14             	pushl  0x14(%ebp)
  802147:	53                   	push   %ebx
  802148:	56                   	push   %esi
  802149:	57                   	push   %edi
  80214a:	e8 d0 e1 ff ff       	call   80031f <sys_ipc_try_send>
  80214f:	83 c4 10             	add    $0x10,%esp
  802152:	85 c0                	test   %eax,%eax
  802154:	79 1e                	jns    802174 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802156:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802159:	75 07                	jne    802162 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  80215b:	e8 f7 df ff ff       	call   800157 <sys_yield>
  802160:	eb e2                	jmp    802144 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802162:	50                   	push   %eax
  802163:	68 df 28 80 00       	push   $0x8028df
  802168:	6a 59                	push   $0x59
  80216a:	68 fa 28 80 00       	push   $0x8028fa
  80216f:	e8 c8 f4 ff ff       	call   80163c <_panic>
	}
}
  802174:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802177:	5b                   	pop    %ebx
  802178:	5e                   	pop    %esi
  802179:	5f                   	pop    %edi
  80217a:	5d                   	pop    %ebp
  80217b:	c3                   	ret    

0080217c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80217c:	f3 0f 1e fb          	endbr32 
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802186:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80218b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80218e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802194:	8b 52 50             	mov    0x50(%edx),%edx
  802197:	39 ca                	cmp    %ecx,%edx
  802199:	74 11                	je     8021ac <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80219b:	83 c0 01             	add    $0x1,%eax
  80219e:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021a3:	75 e6                	jne    80218b <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8021a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021aa:	eb 0b                	jmp    8021b7 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8021ac:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021af:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021b4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021b7:	5d                   	pop    %ebp
  8021b8:	c3                   	ret    

008021b9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021b9:	f3 0f 1e fb          	endbr32 
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021c3:	89 c2                	mov    %eax,%edx
  8021c5:	c1 ea 16             	shr    $0x16,%edx
  8021c8:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8021cf:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021d4:	f6 c1 01             	test   $0x1,%cl
  8021d7:	74 1c                	je     8021f5 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8021d9:	c1 e8 0c             	shr    $0xc,%eax
  8021dc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8021e3:	a8 01                	test   $0x1,%al
  8021e5:	74 0e                	je     8021f5 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021e7:	c1 e8 0c             	shr    $0xc,%eax
  8021ea:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8021f1:	ef 
  8021f2:	0f b7 d2             	movzwl %dx,%edx
}
  8021f5:	89 d0                	mov    %edx,%eax
  8021f7:	5d                   	pop    %ebp
  8021f8:	c3                   	ret    
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
