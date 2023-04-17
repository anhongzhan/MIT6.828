
obj/user/faultwritekernel.debug:     file format elf32-i386


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
	*(unsigned*)0xf0100000 = 0;
  800037:	c7 05 00 00 10 f0 00 	movl   $0x0,0xf0100000
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
  800063:	a3 04 40 80 00       	mov    %eax,0x804004

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
  800096:	e8 df 04 00 00       	call   80057a <close_all>
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
  800123:	68 0a 1f 80 00       	push   $0x801f0a
  800128:	6a 23                	push   $0x23
  80012a:	68 27 1f 80 00       	push   $0x801f27
  80012f:	e8 9c 0f 00 00       	call   8010d0 <_panic>

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
  8001b0:	68 0a 1f 80 00       	push   $0x801f0a
  8001b5:	6a 23                	push   $0x23
  8001b7:	68 27 1f 80 00       	push   $0x801f27
  8001bc:	e8 0f 0f 00 00       	call   8010d0 <_panic>

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
  8001f6:	68 0a 1f 80 00       	push   $0x801f0a
  8001fb:	6a 23                	push   $0x23
  8001fd:	68 27 1f 80 00       	push   $0x801f27
  800202:	e8 c9 0e 00 00       	call   8010d0 <_panic>

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
  80023c:	68 0a 1f 80 00       	push   $0x801f0a
  800241:	6a 23                	push   $0x23
  800243:	68 27 1f 80 00       	push   $0x801f27
  800248:	e8 83 0e 00 00       	call   8010d0 <_panic>

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
  800282:	68 0a 1f 80 00       	push   $0x801f0a
  800287:	6a 23                	push   $0x23
  800289:	68 27 1f 80 00       	push   $0x801f27
  80028e:	e8 3d 0e 00 00       	call   8010d0 <_panic>

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
  8002c8:	68 0a 1f 80 00       	push   $0x801f0a
  8002cd:	6a 23                	push   $0x23
  8002cf:	68 27 1f 80 00       	push   $0x801f27
  8002d4:	e8 f7 0d 00 00       	call   8010d0 <_panic>

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
  80030e:	68 0a 1f 80 00       	push   $0x801f0a
  800313:	6a 23                	push   $0x23
  800315:	68 27 1f 80 00       	push   $0x801f27
  80031a:	e8 b1 0d 00 00       	call   8010d0 <_panic>

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
  80037a:	68 0a 1f 80 00       	push   $0x801f0a
  80037f:	6a 23                	push   $0x23
  800381:	68 27 1f 80 00       	push   $0x801f27
  800386:	e8 45 0d 00 00       	call   8010d0 <_panic>

0080038b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80038b:	f3 0f 1e fb          	endbr32 
  80038f:	55                   	push   %ebp
  800390:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800392:	8b 45 08             	mov    0x8(%ebp),%eax
  800395:	05 00 00 00 30       	add    $0x30000000,%eax
  80039a:	c1 e8 0c             	shr    $0xc,%eax
}
  80039d:	5d                   	pop    %ebp
  80039e:	c3                   	ret    

0080039f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80039f:	f3 0f 1e fb          	endbr32 
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a9:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003b3:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003b8:	5d                   	pop    %ebp
  8003b9:	c3                   	ret    

008003ba <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003ba:	f3 0f 1e fb          	endbr32 
  8003be:	55                   	push   %ebp
  8003bf:	89 e5                	mov    %esp,%ebp
  8003c1:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003c6:	89 c2                	mov    %eax,%edx
  8003c8:	c1 ea 16             	shr    $0x16,%edx
  8003cb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003d2:	f6 c2 01             	test   $0x1,%dl
  8003d5:	74 2d                	je     800404 <fd_alloc+0x4a>
  8003d7:	89 c2                	mov    %eax,%edx
  8003d9:	c1 ea 0c             	shr    $0xc,%edx
  8003dc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003e3:	f6 c2 01             	test   $0x1,%dl
  8003e6:	74 1c                	je     800404 <fd_alloc+0x4a>
  8003e8:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003ed:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003f2:	75 d2                	jne    8003c6 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8003fd:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800402:	eb 0a                	jmp    80040e <fd_alloc+0x54>
			*fd_store = fd;
  800404:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800407:	89 01                	mov    %eax,(%ecx)
			return 0;
  800409:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80040e:	5d                   	pop    %ebp
  80040f:	c3                   	ret    

00800410 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800410:	f3 0f 1e fb          	endbr32 
  800414:	55                   	push   %ebp
  800415:	89 e5                	mov    %esp,%ebp
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80041a:	83 f8 1f             	cmp    $0x1f,%eax
  80041d:	77 30                	ja     80044f <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80041f:	c1 e0 0c             	shl    $0xc,%eax
  800422:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800427:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80042d:	f6 c2 01             	test   $0x1,%dl
  800430:	74 24                	je     800456 <fd_lookup+0x46>
  800432:	89 c2                	mov    %eax,%edx
  800434:	c1 ea 0c             	shr    $0xc,%edx
  800437:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80043e:	f6 c2 01             	test   $0x1,%dl
  800441:	74 1a                	je     80045d <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800443:	8b 55 0c             	mov    0xc(%ebp),%edx
  800446:	89 02                	mov    %eax,(%edx)
	return 0;
  800448:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80044d:	5d                   	pop    %ebp
  80044e:	c3                   	ret    
		return -E_INVAL;
  80044f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800454:	eb f7                	jmp    80044d <fd_lookup+0x3d>
		return -E_INVAL;
  800456:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80045b:	eb f0                	jmp    80044d <fd_lookup+0x3d>
  80045d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800462:	eb e9                	jmp    80044d <fd_lookup+0x3d>

00800464 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800464:	f3 0f 1e fb          	endbr32 
  800468:	55                   	push   %ebp
  800469:	89 e5                	mov    %esp,%ebp
  80046b:	83 ec 08             	sub    $0x8,%esp
  80046e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800471:	ba b4 1f 80 00       	mov    $0x801fb4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800476:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80047b:	39 08                	cmp    %ecx,(%eax)
  80047d:	74 33                	je     8004b2 <dev_lookup+0x4e>
  80047f:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800482:	8b 02                	mov    (%edx),%eax
  800484:	85 c0                	test   %eax,%eax
  800486:	75 f3                	jne    80047b <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800488:	a1 04 40 80 00       	mov    0x804004,%eax
  80048d:	8b 40 48             	mov    0x48(%eax),%eax
  800490:	83 ec 04             	sub    $0x4,%esp
  800493:	51                   	push   %ecx
  800494:	50                   	push   %eax
  800495:	68 38 1f 80 00       	push   $0x801f38
  80049a:	e8 18 0d 00 00       	call   8011b7 <cprintf>
	*dev = 0;
  80049f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004a8:	83 c4 10             	add    $0x10,%esp
  8004ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004b0:	c9                   	leave  
  8004b1:	c3                   	ret    
			*dev = devtab[i];
  8004b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004b5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004bc:	eb f2                	jmp    8004b0 <dev_lookup+0x4c>

008004be <fd_close>:
{
  8004be:	f3 0f 1e fb          	endbr32 
  8004c2:	55                   	push   %ebp
  8004c3:	89 e5                	mov    %esp,%ebp
  8004c5:	57                   	push   %edi
  8004c6:	56                   	push   %esi
  8004c7:	53                   	push   %ebx
  8004c8:	83 ec 24             	sub    $0x24,%esp
  8004cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ce:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004d1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004d4:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004d5:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004db:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004de:	50                   	push   %eax
  8004df:	e8 2c ff ff ff       	call   800410 <fd_lookup>
  8004e4:	89 c3                	mov    %eax,%ebx
  8004e6:	83 c4 10             	add    $0x10,%esp
  8004e9:	85 c0                	test   %eax,%eax
  8004eb:	78 05                	js     8004f2 <fd_close+0x34>
	    || fd != fd2)
  8004ed:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004f0:	74 16                	je     800508 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8004f2:	89 f8                	mov    %edi,%eax
  8004f4:	84 c0                	test   %al,%al
  8004f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004fb:	0f 44 d8             	cmove  %eax,%ebx
}
  8004fe:	89 d8                	mov    %ebx,%eax
  800500:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800503:	5b                   	pop    %ebx
  800504:	5e                   	pop    %esi
  800505:	5f                   	pop    %edi
  800506:	5d                   	pop    %ebp
  800507:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80050e:	50                   	push   %eax
  80050f:	ff 36                	pushl  (%esi)
  800511:	e8 4e ff ff ff       	call   800464 <dev_lookup>
  800516:	89 c3                	mov    %eax,%ebx
  800518:	83 c4 10             	add    $0x10,%esp
  80051b:	85 c0                	test   %eax,%eax
  80051d:	78 1a                	js     800539 <fd_close+0x7b>
		if (dev->dev_close)
  80051f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800522:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800525:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80052a:	85 c0                	test   %eax,%eax
  80052c:	74 0b                	je     800539 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80052e:	83 ec 0c             	sub    $0xc,%esp
  800531:	56                   	push   %esi
  800532:	ff d0                	call   *%eax
  800534:	89 c3                	mov    %eax,%ebx
  800536:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	56                   	push   %esi
  80053d:	6a 00                	push   $0x0
  80053f:	e8 c3 fc ff ff       	call   800207 <sys_page_unmap>
	return r;
  800544:	83 c4 10             	add    $0x10,%esp
  800547:	eb b5                	jmp    8004fe <fd_close+0x40>

00800549 <close>:

int
close(int fdnum)
{
  800549:	f3 0f 1e fb          	endbr32 
  80054d:	55                   	push   %ebp
  80054e:	89 e5                	mov    %esp,%ebp
  800550:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800553:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800556:	50                   	push   %eax
  800557:	ff 75 08             	pushl  0x8(%ebp)
  80055a:	e8 b1 fe ff ff       	call   800410 <fd_lookup>
  80055f:	83 c4 10             	add    $0x10,%esp
  800562:	85 c0                	test   %eax,%eax
  800564:	79 02                	jns    800568 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800566:	c9                   	leave  
  800567:	c3                   	ret    
		return fd_close(fd, 1);
  800568:	83 ec 08             	sub    $0x8,%esp
  80056b:	6a 01                	push   $0x1
  80056d:	ff 75 f4             	pushl  -0xc(%ebp)
  800570:	e8 49 ff ff ff       	call   8004be <fd_close>
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	eb ec                	jmp    800566 <close+0x1d>

0080057a <close_all>:

void
close_all(void)
{
  80057a:	f3 0f 1e fb          	endbr32 
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  800581:	53                   	push   %ebx
  800582:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800585:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80058a:	83 ec 0c             	sub    $0xc,%esp
  80058d:	53                   	push   %ebx
  80058e:	e8 b6 ff ff ff       	call   800549 <close>
	for (i = 0; i < MAXFD; i++)
  800593:	83 c3 01             	add    $0x1,%ebx
  800596:	83 c4 10             	add    $0x10,%esp
  800599:	83 fb 20             	cmp    $0x20,%ebx
  80059c:	75 ec                	jne    80058a <close_all+0x10>
}
  80059e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005a1:	c9                   	leave  
  8005a2:	c3                   	ret    

008005a3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005a3:	f3 0f 1e fb          	endbr32 
  8005a7:	55                   	push   %ebp
  8005a8:	89 e5                	mov    %esp,%ebp
  8005aa:	57                   	push   %edi
  8005ab:	56                   	push   %esi
  8005ac:	53                   	push   %ebx
  8005ad:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005b3:	50                   	push   %eax
  8005b4:	ff 75 08             	pushl  0x8(%ebp)
  8005b7:	e8 54 fe ff ff       	call   800410 <fd_lookup>
  8005bc:	89 c3                	mov    %eax,%ebx
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	85 c0                	test   %eax,%eax
  8005c3:	0f 88 81 00 00 00    	js     80064a <dup+0xa7>
		return r;
	close(newfdnum);
  8005c9:	83 ec 0c             	sub    $0xc,%esp
  8005cc:	ff 75 0c             	pushl  0xc(%ebp)
  8005cf:	e8 75 ff ff ff       	call   800549 <close>

	newfd = INDEX2FD(newfdnum);
  8005d4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005d7:	c1 e6 0c             	shl    $0xc,%esi
  8005da:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005e0:	83 c4 04             	add    $0x4,%esp
  8005e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005e6:	e8 b4 fd ff ff       	call   80039f <fd2data>
  8005eb:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005ed:	89 34 24             	mov    %esi,(%esp)
  8005f0:	e8 aa fd ff ff       	call   80039f <fd2data>
  8005f5:	83 c4 10             	add    $0x10,%esp
  8005f8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005fa:	89 d8                	mov    %ebx,%eax
  8005fc:	c1 e8 16             	shr    $0x16,%eax
  8005ff:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800606:	a8 01                	test   $0x1,%al
  800608:	74 11                	je     80061b <dup+0x78>
  80060a:	89 d8                	mov    %ebx,%eax
  80060c:	c1 e8 0c             	shr    $0xc,%eax
  80060f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800616:	f6 c2 01             	test   $0x1,%dl
  800619:	75 39                	jne    800654 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80061b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80061e:	89 d0                	mov    %edx,%eax
  800620:	c1 e8 0c             	shr    $0xc,%eax
  800623:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80062a:	83 ec 0c             	sub    $0xc,%esp
  80062d:	25 07 0e 00 00       	and    $0xe07,%eax
  800632:	50                   	push   %eax
  800633:	56                   	push   %esi
  800634:	6a 00                	push   $0x0
  800636:	52                   	push   %edx
  800637:	6a 00                	push   $0x0
  800639:	e8 83 fb ff ff       	call   8001c1 <sys_page_map>
  80063e:	89 c3                	mov    %eax,%ebx
  800640:	83 c4 20             	add    $0x20,%esp
  800643:	85 c0                	test   %eax,%eax
  800645:	78 31                	js     800678 <dup+0xd5>
		goto err;

	return newfdnum;
  800647:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80064a:	89 d8                	mov    %ebx,%eax
  80064c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80064f:	5b                   	pop    %ebx
  800650:	5e                   	pop    %esi
  800651:	5f                   	pop    %edi
  800652:	5d                   	pop    %ebp
  800653:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800654:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80065b:	83 ec 0c             	sub    $0xc,%esp
  80065e:	25 07 0e 00 00       	and    $0xe07,%eax
  800663:	50                   	push   %eax
  800664:	57                   	push   %edi
  800665:	6a 00                	push   $0x0
  800667:	53                   	push   %ebx
  800668:	6a 00                	push   $0x0
  80066a:	e8 52 fb ff ff       	call   8001c1 <sys_page_map>
  80066f:	89 c3                	mov    %eax,%ebx
  800671:	83 c4 20             	add    $0x20,%esp
  800674:	85 c0                	test   %eax,%eax
  800676:	79 a3                	jns    80061b <dup+0x78>
	sys_page_unmap(0, newfd);
  800678:	83 ec 08             	sub    $0x8,%esp
  80067b:	56                   	push   %esi
  80067c:	6a 00                	push   $0x0
  80067e:	e8 84 fb ff ff       	call   800207 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800683:	83 c4 08             	add    $0x8,%esp
  800686:	57                   	push   %edi
  800687:	6a 00                	push   $0x0
  800689:	e8 79 fb ff ff       	call   800207 <sys_page_unmap>
	return r;
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	eb b7                	jmp    80064a <dup+0xa7>

00800693 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800693:	f3 0f 1e fb          	endbr32 
  800697:	55                   	push   %ebp
  800698:	89 e5                	mov    %esp,%ebp
  80069a:	53                   	push   %ebx
  80069b:	83 ec 1c             	sub    $0x1c,%esp
  80069e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006a4:	50                   	push   %eax
  8006a5:	53                   	push   %ebx
  8006a6:	e8 65 fd ff ff       	call   800410 <fd_lookup>
  8006ab:	83 c4 10             	add    $0x10,%esp
  8006ae:	85 c0                	test   %eax,%eax
  8006b0:	78 3f                	js     8006f1 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006b8:	50                   	push   %eax
  8006b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bc:	ff 30                	pushl  (%eax)
  8006be:	e8 a1 fd ff ff       	call   800464 <dev_lookup>
  8006c3:	83 c4 10             	add    $0x10,%esp
  8006c6:	85 c0                	test   %eax,%eax
  8006c8:	78 27                	js     8006f1 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8006ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006cd:	8b 42 08             	mov    0x8(%edx),%eax
  8006d0:	83 e0 03             	and    $0x3,%eax
  8006d3:	83 f8 01             	cmp    $0x1,%eax
  8006d6:	74 1e                	je     8006f6 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006db:	8b 40 08             	mov    0x8(%eax),%eax
  8006de:	85 c0                	test   %eax,%eax
  8006e0:	74 35                	je     800717 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006e2:	83 ec 04             	sub    $0x4,%esp
  8006e5:	ff 75 10             	pushl  0x10(%ebp)
  8006e8:	ff 75 0c             	pushl  0xc(%ebp)
  8006eb:	52                   	push   %edx
  8006ec:	ff d0                	call   *%eax
  8006ee:	83 c4 10             	add    $0x10,%esp
}
  8006f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006f4:	c9                   	leave  
  8006f5:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006f6:	a1 04 40 80 00       	mov    0x804004,%eax
  8006fb:	8b 40 48             	mov    0x48(%eax),%eax
  8006fe:	83 ec 04             	sub    $0x4,%esp
  800701:	53                   	push   %ebx
  800702:	50                   	push   %eax
  800703:	68 79 1f 80 00       	push   $0x801f79
  800708:	e8 aa 0a 00 00       	call   8011b7 <cprintf>
		return -E_INVAL;
  80070d:	83 c4 10             	add    $0x10,%esp
  800710:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800715:	eb da                	jmp    8006f1 <read+0x5e>
		return -E_NOT_SUPP;
  800717:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80071c:	eb d3                	jmp    8006f1 <read+0x5e>

0080071e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80071e:	f3 0f 1e fb          	endbr32 
  800722:	55                   	push   %ebp
  800723:	89 e5                	mov    %esp,%ebp
  800725:	57                   	push   %edi
  800726:	56                   	push   %esi
  800727:	53                   	push   %ebx
  800728:	83 ec 0c             	sub    $0xc,%esp
  80072b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80072e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800731:	bb 00 00 00 00       	mov    $0x0,%ebx
  800736:	eb 02                	jmp    80073a <readn+0x1c>
  800738:	01 c3                	add    %eax,%ebx
  80073a:	39 f3                	cmp    %esi,%ebx
  80073c:	73 21                	jae    80075f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80073e:	83 ec 04             	sub    $0x4,%esp
  800741:	89 f0                	mov    %esi,%eax
  800743:	29 d8                	sub    %ebx,%eax
  800745:	50                   	push   %eax
  800746:	89 d8                	mov    %ebx,%eax
  800748:	03 45 0c             	add    0xc(%ebp),%eax
  80074b:	50                   	push   %eax
  80074c:	57                   	push   %edi
  80074d:	e8 41 ff ff ff       	call   800693 <read>
		if (m < 0)
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	85 c0                	test   %eax,%eax
  800757:	78 04                	js     80075d <readn+0x3f>
			return m;
		if (m == 0)
  800759:	75 dd                	jne    800738 <readn+0x1a>
  80075b:	eb 02                	jmp    80075f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80075d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80075f:	89 d8                	mov    %ebx,%eax
  800761:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800764:	5b                   	pop    %ebx
  800765:	5e                   	pop    %esi
  800766:	5f                   	pop    %edi
  800767:	5d                   	pop    %ebp
  800768:	c3                   	ret    

00800769 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800769:	f3 0f 1e fb          	endbr32 
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	53                   	push   %ebx
  800771:	83 ec 1c             	sub    $0x1c,%esp
  800774:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800777:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80077a:	50                   	push   %eax
  80077b:	53                   	push   %ebx
  80077c:	e8 8f fc ff ff       	call   800410 <fd_lookup>
  800781:	83 c4 10             	add    $0x10,%esp
  800784:	85 c0                	test   %eax,%eax
  800786:	78 3a                	js     8007c2 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800788:	83 ec 08             	sub    $0x8,%esp
  80078b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80078e:	50                   	push   %eax
  80078f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800792:	ff 30                	pushl  (%eax)
  800794:	e8 cb fc ff ff       	call   800464 <dev_lookup>
  800799:	83 c4 10             	add    $0x10,%esp
  80079c:	85 c0                	test   %eax,%eax
  80079e:	78 22                	js     8007c2 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007a7:	74 1e                	je     8007c7 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ac:	8b 52 0c             	mov    0xc(%edx),%edx
  8007af:	85 d2                	test   %edx,%edx
  8007b1:	74 35                	je     8007e8 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007b3:	83 ec 04             	sub    $0x4,%esp
  8007b6:	ff 75 10             	pushl  0x10(%ebp)
  8007b9:	ff 75 0c             	pushl  0xc(%ebp)
  8007bc:	50                   	push   %eax
  8007bd:	ff d2                	call   *%edx
  8007bf:	83 c4 10             	add    $0x10,%esp
}
  8007c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c5:	c9                   	leave  
  8007c6:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007c7:	a1 04 40 80 00       	mov    0x804004,%eax
  8007cc:	8b 40 48             	mov    0x48(%eax),%eax
  8007cf:	83 ec 04             	sub    $0x4,%esp
  8007d2:	53                   	push   %ebx
  8007d3:	50                   	push   %eax
  8007d4:	68 95 1f 80 00       	push   $0x801f95
  8007d9:	e8 d9 09 00 00       	call   8011b7 <cprintf>
		return -E_INVAL;
  8007de:	83 c4 10             	add    $0x10,%esp
  8007e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007e6:	eb da                	jmp    8007c2 <write+0x59>
		return -E_NOT_SUPP;
  8007e8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007ed:	eb d3                	jmp    8007c2 <write+0x59>

008007ef <seek>:

int
seek(int fdnum, off_t offset)
{
  8007ef:	f3 0f 1e fb          	endbr32 
  8007f3:	55                   	push   %ebp
  8007f4:	89 e5                	mov    %esp,%ebp
  8007f6:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007fc:	50                   	push   %eax
  8007fd:	ff 75 08             	pushl  0x8(%ebp)
  800800:	e8 0b fc ff ff       	call   800410 <fd_lookup>
  800805:	83 c4 10             	add    $0x10,%esp
  800808:	85 c0                	test   %eax,%eax
  80080a:	78 0e                	js     80081a <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80080c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800812:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800815:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80081a:	c9                   	leave  
  80081b:	c3                   	ret    

0080081c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80081c:	f3 0f 1e fb          	endbr32 
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
  800823:	53                   	push   %ebx
  800824:	83 ec 1c             	sub    $0x1c,%esp
  800827:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80082a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80082d:	50                   	push   %eax
  80082e:	53                   	push   %ebx
  80082f:	e8 dc fb ff ff       	call   800410 <fd_lookup>
  800834:	83 c4 10             	add    $0x10,%esp
  800837:	85 c0                	test   %eax,%eax
  800839:	78 37                	js     800872 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800841:	50                   	push   %eax
  800842:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800845:	ff 30                	pushl  (%eax)
  800847:	e8 18 fc ff ff       	call   800464 <dev_lookup>
  80084c:	83 c4 10             	add    $0x10,%esp
  80084f:	85 c0                	test   %eax,%eax
  800851:	78 1f                	js     800872 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800853:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800856:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80085a:	74 1b                	je     800877 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80085c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80085f:	8b 52 18             	mov    0x18(%edx),%edx
  800862:	85 d2                	test   %edx,%edx
  800864:	74 32                	je     800898 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 0c             	pushl  0xc(%ebp)
  80086c:	50                   	push   %eax
  80086d:	ff d2                	call   *%edx
  80086f:	83 c4 10             	add    $0x10,%esp
}
  800872:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800875:	c9                   	leave  
  800876:	c3                   	ret    
			thisenv->env_id, fdnum);
  800877:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80087c:	8b 40 48             	mov    0x48(%eax),%eax
  80087f:	83 ec 04             	sub    $0x4,%esp
  800882:	53                   	push   %ebx
  800883:	50                   	push   %eax
  800884:	68 58 1f 80 00       	push   $0x801f58
  800889:	e8 29 09 00 00       	call   8011b7 <cprintf>
		return -E_INVAL;
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800896:	eb da                	jmp    800872 <ftruncate+0x56>
		return -E_NOT_SUPP;
  800898:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80089d:	eb d3                	jmp    800872 <ftruncate+0x56>

0080089f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80089f:	f3 0f 1e fb          	endbr32 
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	53                   	push   %ebx
  8008a7:	83 ec 1c             	sub    $0x1c,%esp
  8008aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008b0:	50                   	push   %eax
  8008b1:	ff 75 08             	pushl  0x8(%ebp)
  8008b4:	e8 57 fb ff ff       	call   800410 <fd_lookup>
  8008b9:	83 c4 10             	add    $0x10,%esp
  8008bc:	85 c0                	test   %eax,%eax
  8008be:	78 4b                	js     80090b <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008c0:	83 ec 08             	sub    $0x8,%esp
  8008c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008c6:	50                   	push   %eax
  8008c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ca:	ff 30                	pushl  (%eax)
  8008cc:	e8 93 fb ff ff       	call   800464 <dev_lookup>
  8008d1:	83 c4 10             	add    $0x10,%esp
  8008d4:	85 c0                	test   %eax,%eax
  8008d6:	78 33                	js     80090b <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8008d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008db:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8008df:	74 2f                	je     800910 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8008e1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8008e4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8008eb:	00 00 00 
	stat->st_isdir = 0;
  8008ee:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008f5:	00 00 00 
	stat->st_dev = dev;
  8008f8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008fe:	83 ec 08             	sub    $0x8,%esp
  800901:	53                   	push   %ebx
  800902:	ff 75 f0             	pushl  -0x10(%ebp)
  800905:	ff 50 14             	call   *0x14(%eax)
  800908:	83 c4 10             	add    $0x10,%esp
}
  80090b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80090e:	c9                   	leave  
  80090f:	c3                   	ret    
		return -E_NOT_SUPP;
  800910:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800915:	eb f4                	jmp    80090b <fstat+0x6c>

00800917 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800917:	f3 0f 1e fb          	endbr32 
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	56                   	push   %esi
  80091f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800920:	83 ec 08             	sub    $0x8,%esp
  800923:	6a 00                	push   $0x0
  800925:	ff 75 08             	pushl  0x8(%ebp)
  800928:	e8 fb 01 00 00       	call   800b28 <open>
  80092d:	89 c3                	mov    %eax,%ebx
  80092f:	83 c4 10             	add    $0x10,%esp
  800932:	85 c0                	test   %eax,%eax
  800934:	78 1b                	js     800951 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	50                   	push   %eax
  80093d:	e8 5d ff ff ff       	call   80089f <fstat>
  800942:	89 c6                	mov    %eax,%esi
	close(fd);
  800944:	89 1c 24             	mov    %ebx,(%esp)
  800947:	e8 fd fb ff ff       	call   800549 <close>
	return r;
  80094c:	83 c4 10             	add    $0x10,%esp
  80094f:	89 f3                	mov    %esi,%ebx
}
  800951:	89 d8                	mov    %ebx,%eax
  800953:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800956:	5b                   	pop    %ebx
  800957:	5e                   	pop    %esi
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	56                   	push   %esi
  80095e:	53                   	push   %ebx
  80095f:	89 c6                	mov    %eax,%esi
  800961:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800963:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80096a:	74 27                	je     800993 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80096c:	6a 07                	push   $0x7
  80096e:	68 00 50 80 00       	push   $0x805000
  800973:	56                   	push   %esi
  800974:	ff 35 00 40 80 00    	pushl  0x804000
  80097a:	e8 39 12 00 00       	call   801bb8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80097f:	83 c4 0c             	add    $0xc,%esp
  800982:	6a 00                	push   $0x0
  800984:	53                   	push   %ebx
  800985:	6a 00                	push   $0x0
  800987:	e8 a7 11 00 00       	call   801b33 <ipc_recv>
}
  80098c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80098f:	5b                   	pop    %ebx
  800990:	5e                   	pop    %esi
  800991:	5d                   	pop    %ebp
  800992:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800993:	83 ec 0c             	sub    $0xc,%esp
  800996:	6a 01                	push   $0x1
  800998:	e8 73 12 00 00       	call   801c10 <ipc_find_env>
  80099d:	a3 00 40 80 00       	mov    %eax,0x804000
  8009a2:	83 c4 10             	add    $0x10,%esp
  8009a5:	eb c5                	jmp    80096c <fsipc+0x12>

008009a7 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009a7:	f3 0f 1e fb          	endbr32 
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8009b7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009bf:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c9:	b8 02 00 00 00       	mov    $0x2,%eax
  8009ce:	e8 87 ff ff ff       	call   80095a <fsipc>
}
  8009d3:	c9                   	leave  
  8009d4:	c3                   	ret    

008009d5 <devfile_flush>:
{
  8009d5:	f3 0f 1e fb          	endbr32 
  8009d9:	55                   	push   %ebp
  8009da:	89 e5                	mov    %esp,%ebp
  8009dc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8009e5:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8009ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ef:	b8 06 00 00 00       	mov    $0x6,%eax
  8009f4:	e8 61 ff ff ff       	call   80095a <fsipc>
}
  8009f9:	c9                   	leave  
  8009fa:	c3                   	ret    

008009fb <devfile_stat>:
{
  8009fb:	f3 0f 1e fb          	endbr32 
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	53                   	push   %ebx
  800a03:	83 ec 04             	sub    $0x4,%esp
  800a06:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	8b 40 0c             	mov    0xc(%eax),%eax
  800a0f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a14:	ba 00 00 00 00       	mov    $0x0,%edx
  800a19:	b8 05 00 00 00       	mov    $0x5,%eax
  800a1e:	e8 37 ff ff ff       	call   80095a <fsipc>
  800a23:	85 c0                	test   %eax,%eax
  800a25:	78 2c                	js     800a53 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a27:	83 ec 08             	sub    $0x8,%esp
  800a2a:	68 00 50 80 00       	push   $0x805000
  800a2f:	53                   	push   %ebx
  800a30:	e8 8c 0d 00 00       	call   8017c1 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a35:	a1 80 50 80 00       	mov    0x805080,%eax
  800a3a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800a40:	a1 84 50 80 00       	mov    0x805084,%eax
  800a45:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a4b:	83 c4 10             	add    $0x10,%esp
  800a4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a56:	c9                   	leave  
  800a57:	c3                   	ret    

00800a58 <devfile_write>:
{
  800a58:	f3 0f 1e fb          	endbr32 
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
  800a5f:	83 ec 0c             	sub    $0xc,%esp
  800a62:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a65:	8b 55 08             	mov    0x8(%ebp),%edx
  800a68:	8b 52 0c             	mov    0xc(%edx),%edx
  800a6b:	89 15 00 50 80 00    	mov    %edx,0x805000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  800a71:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800a76:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800a7b:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  800a7e:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a83:	50                   	push   %eax
  800a84:	ff 75 0c             	pushl  0xc(%ebp)
  800a87:	68 08 50 80 00       	push   $0x805008
  800a8c:	e8 e6 0e 00 00       	call   801977 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800a91:	ba 00 00 00 00       	mov    $0x0,%edx
  800a96:	b8 04 00 00 00       	mov    $0x4,%eax
  800a9b:	e8 ba fe ff ff       	call   80095a <fsipc>
}
  800aa0:	c9                   	leave  
  800aa1:	c3                   	ret    

00800aa2 <devfile_read>:
{
  800aa2:	f3 0f 1e fb          	endbr32 
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	56                   	push   %esi
  800aaa:	53                   	push   %ebx
  800aab:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	8b 40 0c             	mov    0xc(%eax),%eax
  800ab4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800ab9:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800abf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac4:	b8 03 00 00 00       	mov    $0x3,%eax
  800ac9:	e8 8c fe ff ff       	call   80095a <fsipc>
  800ace:	89 c3                	mov    %eax,%ebx
  800ad0:	85 c0                	test   %eax,%eax
  800ad2:	78 1f                	js     800af3 <devfile_read+0x51>
	assert(r <= n);
  800ad4:	39 f0                	cmp    %esi,%eax
  800ad6:	77 24                	ja     800afc <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800ad8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800add:	7f 33                	jg     800b12 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800adf:	83 ec 04             	sub    $0x4,%esp
  800ae2:	50                   	push   %eax
  800ae3:	68 00 50 80 00       	push   $0x805000
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	e8 87 0e 00 00       	call   801977 <memmove>
	return r;
  800af0:	83 c4 10             	add    $0x10,%esp
}
  800af3:	89 d8                	mov    %ebx,%eax
  800af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800af8:	5b                   	pop    %ebx
  800af9:	5e                   	pop    %esi
  800afa:	5d                   	pop    %ebp
  800afb:	c3                   	ret    
	assert(r <= n);
  800afc:	68 c4 1f 80 00       	push   $0x801fc4
  800b01:	68 cb 1f 80 00       	push   $0x801fcb
  800b06:	6a 7c                	push   $0x7c
  800b08:	68 e0 1f 80 00       	push   $0x801fe0
  800b0d:	e8 be 05 00 00       	call   8010d0 <_panic>
	assert(r <= PGSIZE);
  800b12:	68 eb 1f 80 00       	push   $0x801feb
  800b17:	68 cb 1f 80 00       	push   $0x801fcb
  800b1c:	6a 7d                	push   $0x7d
  800b1e:	68 e0 1f 80 00       	push   $0x801fe0
  800b23:	e8 a8 05 00 00       	call   8010d0 <_panic>

00800b28 <open>:
{
  800b28:	f3 0f 1e fb          	endbr32 
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	56                   	push   %esi
  800b30:	53                   	push   %ebx
  800b31:	83 ec 1c             	sub    $0x1c,%esp
  800b34:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b37:	56                   	push   %esi
  800b38:	e8 41 0c 00 00       	call   80177e <strlen>
  800b3d:	83 c4 10             	add    $0x10,%esp
  800b40:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b45:	7f 6c                	jg     800bb3 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b47:	83 ec 0c             	sub    $0xc,%esp
  800b4a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b4d:	50                   	push   %eax
  800b4e:	e8 67 f8 ff ff       	call   8003ba <fd_alloc>
  800b53:	89 c3                	mov    %eax,%ebx
  800b55:	83 c4 10             	add    $0x10,%esp
  800b58:	85 c0                	test   %eax,%eax
  800b5a:	78 3c                	js     800b98 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	56                   	push   %esi
  800b60:	68 00 50 80 00       	push   $0x805000
  800b65:	e8 57 0c 00 00       	call   8017c1 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b75:	b8 01 00 00 00       	mov    $0x1,%eax
  800b7a:	e8 db fd ff ff       	call   80095a <fsipc>
  800b7f:	89 c3                	mov    %eax,%ebx
  800b81:	83 c4 10             	add    $0x10,%esp
  800b84:	85 c0                	test   %eax,%eax
  800b86:	78 19                	js     800ba1 <open+0x79>
	return fd2num(fd);
  800b88:	83 ec 0c             	sub    $0xc,%esp
  800b8b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b8e:	e8 f8 f7 ff ff       	call   80038b <fd2num>
  800b93:	89 c3                	mov    %eax,%ebx
  800b95:	83 c4 10             	add    $0x10,%esp
}
  800b98:	89 d8                	mov    %ebx,%eax
  800b9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b9d:	5b                   	pop    %ebx
  800b9e:	5e                   	pop    %esi
  800b9f:	5d                   	pop    %ebp
  800ba0:	c3                   	ret    
		fd_close(fd, 0);
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	6a 00                	push   $0x0
  800ba6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba9:	e8 10 f9 ff ff       	call   8004be <fd_close>
		return r;
  800bae:	83 c4 10             	add    $0x10,%esp
  800bb1:	eb e5                	jmp    800b98 <open+0x70>
		return -E_BAD_PATH;
  800bb3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800bb8:	eb de                	jmp    800b98 <open+0x70>

00800bba <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800bba:	f3 0f 1e fb          	endbr32 
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800bc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc9:	b8 08 00 00 00       	mov    $0x8,%eax
  800bce:	e8 87 fd ff ff       	call   80095a <fsipc>
}
  800bd3:	c9                   	leave  
  800bd4:	c3                   	ret    

00800bd5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800bd5:	f3 0f 1e fb          	endbr32 
  800bd9:	55                   	push   %ebp
  800bda:	89 e5                	mov    %esp,%ebp
  800bdc:	56                   	push   %esi
  800bdd:	53                   	push   %ebx
  800bde:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800be1:	83 ec 0c             	sub    $0xc,%esp
  800be4:	ff 75 08             	pushl  0x8(%ebp)
  800be7:	e8 b3 f7 ff ff       	call   80039f <fd2data>
  800bec:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bee:	83 c4 08             	add    $0x8,%esp
  800bf1:	68 f7 1f 80 00       	push   $0x801ff7
  800bf6:	53                   	push   %ebx
  800bf7:	e8 c5 0b 00 00       	call   8017c1 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bfc:	8b 46 04             	mov    0x4(%esi),%eax
  800bff:	2b 06                	sub    (%esi),%eax
  800c01:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800c07:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800c0e:	00 00 00 
	stat->st_dev = &devpipe;
  800c11:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c18:	30 80 00 
	return 0;
}
  800c1b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c20:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c23:	5b                   	pop    %ebx
  800c24:	5e                   	pop    %esi
  800c25:	5d                   	pop    %ebp
  800c26:	c3                   	ret    

00800c27 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c27:	f3 0f 1e fb          	endbr32 
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	53                   	push   %ebx
  800c2f:	83 ec 0c             	sub    $0xc,%esp
  800c32:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c35:	53                   	push   %ebx
  800c36:	6a 00                	push   $0x0
  800c38:	e8 ca f5 ff ff       	call   800207 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c3d:	89 1c 24             	mov    %ebx,(%esp)
  800c40:	e8 5a f7 ff ff       	call   80039f <fd2data>
  800c45:	83 c4 08             	add    $0x8,%esp
  800c48:	50                   	push   %eax
  800c49:	6a 00                	push   $0x0
  800c4b:	e8 b7 f5 ff ff       	call   800207 <sys_page_unmap>
}
  800c50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c53:	c9                   	leave  
  800c54:	c3                   	ret    

00800c55 <_pipeisclosed>:
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	57                   	push   %edi
  800c59:	56                   	push   %esi
  800c5a:	53                   	push   %ebx
  800c5b:	83 ec 1c             	sub    $0x1c,%esp
  800c5e:	89 c7                	mov    %eax,%edi
  800c60:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c62:	a1 04 40 80 00       	mov    0x804004,%eax
  800c67:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c6a:	83 ec 0c             	sub    $0xc,%esp
  800c6d:	57                   	push   %edi
  800c6e:	e8 da 0f 00 00       	call   801c4d <pageref>
  800c73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c76:	89 34 24             	mov    %esi,(%esp)
  800c79:	e8 cf 0f 00 00       	call   801c4d <pageref>
		nn = thisenv->env_runs;
  800c7e:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800c84:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c87:	83 c4 10             	add    $0x10,%esp
  800c8a:	39 cb                	cmp    %ecx,%ebx
  800c8c:	74 1b                	je     800ca9 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c8e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c91:	75 cf                	jne    800c62 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c93:	8b 42 58             	mov    0x58(%edx),%eax
  800c96:	6a 01                	push   $0x1
  800c98:	50                   	push   %eax
  800c99:	53                   	push   %ebx
  800c9a:	68 fe 1f 80 00       	push   $0x801ffe
  800c9f:	e8 13 05 00 00       	call   8011b7 <cprintf>
  800ca4:	83 c4 10             	add    $0x10,%esp
  800ca7:	eb b9                	jmp    800c62 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800ca9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800cac:	0f 94 c0             	sete   %al
  800caf:	0f b6 c0             	movzbl %al,%eax
}
  800cb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb5:	5b                   	pop    %ebx
  800cb6:	5e                   	pop    %esi
  800cb7:	5f                   	pop    %edi
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    

00800cba <devpipe_write>:
{
  800cba:	f3 0f 1e fb          	endbr32 
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	57                   	push   %edi
  800cc2:	56                   	push   %esi
  800cc3:	53                   	push   %ebx
  800cc4:	83 ec 28             	sub    $0x28,%esp
  800cc7:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800cca:	56                   	push   %esi
  800ccb:	e8 cf f6 ff ff       	call   80039f <fd2data>
  800cd0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800cd2:	83 c4 10             	add    $0x10,%esp
  800cd5:	bf 00 00 00 00       	mov    $0x0,%edi
  800cda:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800cdd:	74 4f                	je     800d2e <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800cdf:	8b 43 04             	mov    0x4(%ebx),%eax
  800ce2:	8b 0b                	mov    (%ebx),%ecx
  800ce4:	8d 51 20             	lea    0x20(%ecx),%edx
  800ce7:	39 d0                	cmp    %edx,%eax
  800ce9:	72 14                	jb     800cff <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  800ceb:	89 da                	mov    %ebx,%edx
  800ced:	89 f0                	mov    %esi,%eax
  800cef:	e8 61 ff ff ff       	call   800c55 <_pipeisclosed>
  800cf4:	85 c0                	test   %eax,%eax
  800cf6:	75 3b                	jne    800d33 <devpipe_write+0x79>
			sys_yield();
  800cf8:	e8 5a f4 ff ff       	call   800157 <sys_yield>
  800cfd:	eb e0                	jmp    800cdf <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d02:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800d06:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800d09:	89 c2                	mov    %eax,%edx
  800d0b:	c1 fa 1f             	sar    $0x1f,%edx
  800d0e:	89 d1                	mov    %edx,%ecx
  800d10:	c1 e9 1b             	shr    $0x1b,%ecx
  800d13:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800d16:	83 e2 1f             	and    $0x1f,%edx
  800d19:	29 ca                	sub    %ecx,%edx
  800d1b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800d1f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800d23:	83 c0 01             	add    $0x1,%eax
  800d26:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d29:	83 c7 01             	add    $0x1,%edi
  800d2c:	eb ac                	jmp    800cda <devpipe_write+0x20>
	return i;
  800d2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d31:	eb 05                	jmp    800d38 <devpipe_write+0x7e>
				return 0;
  800d33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3b:	5b                   	pop    %ebx
  800d3c:	5e                   	pop    %esi
  800d3d:	5f                   	pop    %edi
  800d3e:	5d                   	pop    %ebp
  800d3f:	c3                   	ret    

00800d40 <devpipe_read>:
{
  800d40:	f3 0f 1e fb          	endbr32 
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
  800d4a:	83 ec 18             	sub    $0x18,%esp
  800d4d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d50:	57                   	push   %edi
  800d51:	e8 49 f6 ff ff       	call   80039f <fd2data>
  800d56:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d58:	83 c4 10             	add    $0x10,%esp
  800d5b:	be 00 00 00 00       	mov    $0x0,%esi
  800d60:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d63:	75 14                	jne    800d79 <devpipe_read+0x39>
	return i;
  800d65:	8b 45 10             	mov    0x10(%ebp),%eax
  800d68:	eb 02                	jmp    800d6c <devpipe_read+0x2c>
				return i;
  800d6a:	89 f0                	mov    %esi,%eax
}
  800d6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6f:	5b                   	pop    %ebx
  800d70:	5e                   	pop    %esi
  800d71:	5f                   	pop    %edi
  800d72:	5d                   	pop    %ebp
  800d73:	c3                   	ret    
			sys_yield();
  800d74:	e8 de f3 ff ff       	call   800157 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d79:	8b 03                	mov    (%ebx),%eax
  800d7b:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d7e:	75 18                	jne    800d98 <devpipe_read+0x58>
			if (i > 0)
  800d80:	85 f6                	test   %esi,%esi
  800d82:	75 e6                	jne    800d6a <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  800d84:	89 da                	mov    %ebx,%edx
  800d86:	89 f8                	mov    %edi,%eax
  800d88:	e8 c8 fe ff ff       	call   800c55 <_pipeisclosed>
  800d8d:	85 c0                	test   %eax,%eax
  800d8f:	74 e3                	je     800d74 <devpipe_read+0x34>
				return 0;
  800d91:	b8 00 00 00 00       	mov    $0x0,%eax
  800d96:	eb d4                	jmp    800d6c <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d98:	99                   	cltd   
  800d99:	c1 ea 1b             	shr    $0x1b,%edx
  800d9c:	01 d0                	add    %edx,%eax
  800d9e:	83 e0 1f             	and    $0x1f,%eax
  800da1:	29 d0                	sub    %edx,%eax
  800da3:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800da8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dab:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800dae:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800db1:	83 c6 01             	add    $0x1,%esi
  800db4:	eb aa                	jmp    800d60 <devpipe_read+0x20>

00800db6 <pipe>:
{
  800db6:	f3 0f 1e fb          	endbr32 
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	56                   	push   %esi
  800dbe:	53                   	push   %ebx
  800dbf:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800dc2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dc5:	50                   	push   %eax
  800dc6:	e8 ef f5 ff ff       	call   8003ba <fd_alloc>
  800dcb:	89 c3                	mov    %eax,%ebx
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	85 c0                	test   %eax,%eax
  800dd2:	0f 88 23 01 00 00    	js     800efb <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dd8:	83 ec 04             	sub    $0x4,%esp
  800ddb:	68 07 04 00 00       	push   $0x407
  800de0:	ff 75 f4             	pushl  -0xc(%ebp)
  800de3:	6a 00                	push   $0x0
  800de5:	e8 90 f3 ff ff       	call   80017a <sys_page_alloc>
  800dea:	89 c3                	mov    %eax,%ebx
  800dec:	83 c4 10             	add    $0x10,%esp
  800def:	85 c0                	test   %eax,%eax
  800df1:	0f 88 04 01 00 00    	js     800efb <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  800df7:	83 ec 0c             	sub    $0xc,%esp
  800dfa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800dfd:	50                   	push   %eax
  800dfe:	e8 b7 f5 ff ff       	call   8003ba <fd_alloc>
  800e03:	89 c3                	mov    %eax,%ebx
  800e05:	83 c4 10             	add    $0x10,%esp
  800e08:	85 c0                	test   %eax,%eax
  800e0a:	0f 88 db 00 00 00    	js     800eeb <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e10:	83 ec 04             	sub    $0x4,%esp
  800e13:	68 07 04 00 00       	push   $0x407
  800e18:	ff 75 f0             	pushl  -0x10(%ebp)
  800e1b:	6a 00                	push   $0x0
  800e1d:	e8 58 f3 ff ff       	call   80017a <sys_page_alloc>
  800e22:	89 c3                	mov    %eax,%ebx
  800e24:	83 c4 10             	add    $0x10,%esp
  800e27:	85 c0                	test   %eax,%eax
  800e29:	0f 88 bc 00 00 00    	js     800eeb <pipe+0x135>
	va = fd2data(fd0);
  800e2f:	83 ec 0c             	sub    $0xc,%esp
  800e32:	ff 75 f4             	pushl  -0xc(%ebp)
  800e35:	e8 65 f5 ff ff       	call   80039f <fd2data>
  800e3a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e3c:	83 c4 0c             	add    $0xc,%esp
  800e3f:	68 07 04 00 00       	push   $0x407
  800e44:	50                   	push   %eax
  800e45:	6a 00                	push   $0x0
  800e47:	e8 2e f3 ff ff       	call   80017a <sys_page_alloc>
  800e4c:	89 c3                	mov    %eax,%ebx
  800e4e:	83 c4 10             	add    $0x10,%esp
  800e51:	85 c0                	test   %eax,%eax
  800e53:	0f 88 82 00 00 00    	js     800edb <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e59:	83 ec 0c             	sub    $0xc,%esp
  800e5c:	ff 75 f0             	pushl  -0x10(%ebp)
  800e5f:	e8 3b f5 ff ff       	call   80039f <fd2data>
  800e64:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e6b:	50                   	push   %eax
  800e6c:	6a 00                	push   $0x0
  800e6e:	56                   	push   %esi
  800e6f:	6a 00                	push   $0x0
  800e71:	e8 4b f3 ff ff       	call   8001c1 <sys_page_map>
  800e76:	89 c3                	mov    %eax,%ebx
  800e78:	83 c4 20             	add    $0x20,%esp
  800e7b:	85 c0                	test   %eax,%eax
  800e7d:	78 4e                	js     800ecd <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  800e7f:	a1 20 30 80 00       	mov    0x803020,%eax
  800e84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e87:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e8c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e93:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e96:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800ea2:	83 ec 0c             	sub    $0xc,%esp
  800ea5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea8:	e8 de f4 ff ff       	call   80038b <fd2num>
  800ead:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eb0:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800eb2:	83 c4 04             	add    $0x4,%esp
  800eb5:	ff 75 f0             	pushl  -0x10(%ebp)
  800eb8:	e8 ce f4 ff ff       	call   80038b <fd2num>
  800ebd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ec0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800ec3:	83 c4 10             	add    $0x10,%esp
  800ec6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ecb:	eb 2e                	jmp    800efb <pipe+0x145>
	sys_page_unmap(0, va);
  800ecd:	83 ec 08             	sub    $0x8,%esp
  800ed0:	56                   	push   %esi
  800ed1:	6a 00                	push   $0x0
  800ed3:	e8 2f f3 ff ff       	call   800207 <sys_page_unmap>
  800ed8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800edb:	83 ec 08             	sub    $0x8,%esp
  800ede:	ff 75 f0             	pushl  -0x10(%ebp)
  800ee1:	6a 00                	push   $0x0
  800ee3:	e8 1f f3 ff ff       	call   800207 <sys_page_unmap>
  800ee8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800eeb:	83 ec 08             	sub    $0x8,%esp
  800eee:	ff 75 f4             	pushl  -0xc(%ebp)
  800ef1:	6a 00                	push   $0x0
  800ef3:	e8 0f f3 ff ff       	call   800207 <sys_page_unmap>
  800ef8:	83 c4 10             	add    $0x10,%esp
}
  800efb:	89 d8                	mov    %ebx,%eax
  800efd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f00:	5b                   	pop    %ebx
  800f01:	5e                   	pop    %esi
  800f02:	5d                   	pop    %ebp
  800f03:	c3                   	ret    

00800f04 <pipeisclosed>:
{
  800f04:	f3 0f 1e fb          	endbr32 
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f0e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f11:	50                   	push   %eax
  800f12:	ff 75 08             	pushl  0x8(%ebp)
  800f15:	e8 f6 f4 ff ff       	call   800410 <fd_lookup>
  800f1a:	83 c4 10             	add    $0x10,%esp
  800f1d:	85 c0                	test   %eax,%eax
  800f1f:	78 18                	js     800f39 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  800f21:	83 ec 0c             	sub    $0xc,%esp
  800f24:	ff 75 f4             	pushl  -0xc(%ebp)
  800f27:	e8 73 f4 ff ff       	call   80039f <fd2data>
  800f2c:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  800f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f31:	e8 1f fd ff ff       	call   800c55 <_pipeisclosed>
  800f36:	83 c4 10             	add    $0x10,%esp
}
  800f39:	c9                   	leave  
  800f3a:	c3                   	ret    

00800f3b <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800f3b:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  800f3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f44:	c3                   	ret    

00800f45 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f45:	f3 0f 1e fb          	endbr32 
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
  800f4c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800f4f:	68 16 20 80 00       	push   $0x802016
  800f54:	ff 75 0c             	pushl  0xc(%ebp)
  800f57:	e8 65 08 00 00       	call   8017c1 <strcpy>
	return 0;
}
  800f5c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f61:	c9                   	leave  
  800f62:	c3                   	ret    

00800f63 <devcons_write>:
{
  800f63:	f3 0f 1e fb          	endbr32 
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	57                   	push   %edi
  800f6b:	56                   	push   %esi
  800f6c:	53                   	push   %ebx
  800f6d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800f73:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800f78:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800f7e:	3b 75 10             	cmp    0x10(%ebp),%esi
  800f81:	73 31                	jae    800fb4 <devcons_write+0x51>
		m = n - tot;
  800f83:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f86:	29 f3                	sub    %esi,%ebx
  800f88:	83 fb 7f             	cmp    $0x7f,%ebx
  800f8b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800f90:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800f93:	83 ec 04             	sub    $0x4,%esp
  800f96:	53                   	push   %ebx
  800f97:	89 f0                	mov    %esi,%eax
  800f99:	03 45 0c             	add    0xc(%ebp),%eax
  800f9c:	50                   	push   %eax
  800f9d:	57                   	push   %edi
  800f9e:	e8 d4 09 00 00       	call   801977 <memmove>
		sys_cputs(buf, m);
  800fa3:	83 c4 08             	add    $0x8,%esp
  800fa6:	53                   	push   %ebx
  800fa7:	57                   	push   %edi
  800fa8:	e8 fd f0 ff ff       	call   8000aa <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800fad:	01 de                	add    %ebx,%esi
  800faf:	83 c4 10             	add    $0x10,%esp
  800fb2:	eb ca                	jmp    800f7e <devcons_write+0x1b>
}
  800fb4:	89 f0                	mov    %esi,%eax
  800fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb9:	5b                   	pop    %ebx
  800fba:	5e                   	pop    %esi
  800fbb:	5f                   	pop    %edi
  800fbc:	5d                   	pop    %ebp
  800fbd:	c3                   	ret    

00800fbe <devcons_read>:
{
  800fbe:	f3 0f 1e fb          	endbr32 
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	83 ec 08             	sub    $0x8,%esp
  800fc8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800fcd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd1:	74 21                	je     800ff4 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800fd3:	e8 f4 f0 ff ff       	call   8000cc <sys_cgetc>
  800fd8:	85 c0                	test   %eax,%eax
  800fda:	75 07                	jne    800fe3 <devcons_read+0x25>
		sys_yield();
  800fdc:	e8 76 f1 ff ff       	call   800157 <sys_yield>
  800fe1:	eb f0                	jmp    800fd3 <devcons_read+0x15>
	if (c < 0)
  800fe3:	78 0f                	js     800ff4 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  800fe5:	83 f8 04             	cmp    $0x4,%eax
  800fe8:	74 0c                	je     800ff6 <devcons_read+0x38>
	*(char*)vbuf = c;
  800fea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fed:	88 02                	mov    %al,(%edx)
	return 1;
  800fef:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    
		return 0;
  800ff6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffb:	eb f7                	jmp    800ff4 <devcons_read+0x36>

00800ffd <cputchar>:
{
  800ffd:	f3 0f 1e fb          	endbr32 
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80100d:	6a 01                	push   $0x1
  80100f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801012:	50                   	push   %eax
  801013:	e8 92 f0 ff ff       	call   8000aa <sys_cputs>
}
  801018:	83 c4 10             	add    $0x10,%esp
  80101b:	c9                   	leave  
  80101c:	c3                   	ret    

0080101d <getchar>:
{
  80101d:	f3 0f 1e fb          	endbr32 
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801027:	6a 01                	push   $0x1
  801029:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80102c:	50                   	push   %eax
  80102d:	6a 00                	push   $0x0
  80102f:	e8 5f f6 ff ff       	call   800693 <read>
	if (r < 0)
  801034:	83 c4 10             	add    $0x10,%esp
  801037:	85 c0                	test   %eax,%eax
  801039:	78 06                	js     801041 <getchar+0x24>
	if (r < 1)
  80103b:	74 06                	je     801043 <getchar+0x26>
	return c;
  80103d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801041:	c9                   	leave  
  801042:	c3                   	ret    
		return -E_EOF;
  801043:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801048:	eb f7                	jmp    801041 <getchar+0x24>

0080104a <iscons>:
{
  80104a:	f3 0f 1e fb          	endbr32 
  80104e:	55                   	push   %ebp
  80104f:	89 e5                	mov    %esp,%ebp
  801051:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801054:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801057:	50                   	push   %eax
  801058:	ff 75 08             	pushl  0x8(%ebp)
  80105b:	e8 b0 f3 ff ff       	call   800410 <fd_lookup>
  801060:	83 c4 10             	add    $0x10,%esp
  801063:	85 c0                	test   %eax,%eax
  801065:	78 11                	js     801078 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801070:	39 10                	cmp    %edx,(%eax)
  801072:	0f 94 c0             	sete   %al
  801075:	0f b6 c0             	movzbl %al,%eax
}
  801078:	c9                   	leave  
  801079:	c3                   	ret    

0080107a <opencons>:
{
  80107a:	f3 0f 1e fb          	endbr32 
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801084:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801087:	50                   	push   %eax
  801088:	e8 2d f3 ff ff       	call   8003ba <fd_alloc>
  80108d:	83 c4 10             	add    $0x10,%esp
  801090:	85 c0                	test   %eax,%eax
  801092:	78 3a                	js     8010ce <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801094:	83 ec 04             	sub    $0x4,%esp
  801097:	68 07 04 00 00       	push   $0x407
  80109c:	ff 75 f4             	pushl  -0xc(%ebp)
  80109f:	6a 00                	push   $0x0
  8010a1:	e8 d4 f0 ff ff       	call   80017a <sys_page_alloc>
  8010a6:	83 c4 10             	add    $0x10,%esp
  8010a9:	85 c0                	test   %eax,%eax
  8010ab:	78 21                	js     8010ce <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8010ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b0:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010b6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8010b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010bb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8010c2:	83 ec 0c             	sub    $0xc,%esp
  8010c5:	50                   	push   %eax
  8010c6:	e8 c0 f2 ff ff       	call   80038b <fd2num>
  8010cb:	83 c4 10             	add    $0x10,%esp
}
  8010ce:	c9                   	leave  
  8010cf:	c3                   	ret    

008010d0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8010d0:	f3 0f 1e fb          	endbr32 
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	56                   	push   %esi
  8010d8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8010d9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8010dc:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8010e2:	e8 4d f0 ff ff       	call   800134 <sys_getenvid>
  8010e7:	83 ec 0c             	sub    $0xc,%esp
  8010ea:	ff 75 0c             	pushl  0xc(%ebp)
  8010ed:	ff 75 08             	pushl  0x8(%ebp)
  8010f0:	56                   	push   %esi
  8010f1:	50                   	push   %eax
  8010f2:	68 24 20 80 00       	push   $0x802024
  8010f7:	e8 bb 00 00 00       	call   8011b7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8010fc:	83 c4 18             	add    $0x18,%esp
  8010ff:	53                   	push   %ebx
  801100:	ff 75 10             	pushl  0x10(%ebp)
  801103:	e8 5a 00 00 00       	call   801162 <vcprintf>
	cprintf("\n");
  801108:	c7 04 24 58 23 80 00 	movl   $0x802358,(%esp)
  80110f:	e8 a3 00 00 00       	call   8011b7 <cprintf>
  801114:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801117:	cc                   	int3   
  801118:	eb fd                	jmp    801117 <_panic+0x47>

0080111a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80111a:	f3 0f 1e fb          	endbr32 
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	53                   	push   %ebx
  801122:	83 ec 04             	sub    $0x4,%esp
  801125:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801128:	8b 13                	mov    (%ebx),%edx
  80112a:	8d 42 01             	lea    0x1(%edx),%eax
  80112d:	89 03                	mov    %eax,(%ebx)
  80112f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801132:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801136:	3d ff 00 00 00       	cmp    $0xff,%eax
  80113b:	74 09                	je     801146 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80113d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801141:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801144:	c9                   	leave  
  801145:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801146:	83 ec 08             	sub    $0x8,%esp
  801149:	68 ff 00 00 00       	push   $0xff
  80114e:	8d 43 08             	lea    0x8(%ebx),%eax
  801151:	50                   	push   %eax
  801152:	e8 53 ef ff ff       	call   8000aa <sys_cputs>
		b->idx = 0;
  801157:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80115d:	83 c4 10             	add    $0x10,%esp
  801160:	eb db                	jmp    80113d <putch+0x23>

00801162 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801162:	f3 0f 1e fb          	endbr32 
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80116f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801176:	00 00 00 
	b.cnt = 0;
  801179:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801180:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801183:	ff 75 0c             	pushl  0xc(%ebp)
  801186:	ff 75 08             	pushl  0x8(%ebp)
  801189:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80118f:	50                   	push   %eax
  801190:	68 1a 11 80 00       	push   $0x80111a
  801195:	e8 20 01 00 00       	call   8012ba <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80119a:	83 c4 08             	add    $0x8,%esp
  80119d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8011a3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8011a9:	50                   	push   %eax
  8011aa:	e8 fb ee ff ff       	call   8000aa <sys_cputs>

	return b.cnt;
}
  8011af:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8011b5:	c9                   	leave  
  8011b6:	c3                   	ret    

008011b7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8011b7:	f3 0f 1e fb          	endbr32 
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8011c1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8011c4:	50                   	push   %eax
  8011c5:	ff 75 08             	pushl  0x8(%ebp)
  8011c8:	e8 95 ff ff ff       	call   801162 <vcprintf>
	va_end(ap);

	return cnt;
}
  8011cd:	c9                   	leave  
  8011ce:	c3                   	ret    

008011cf <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	57                   	push   %edi
  8011d3:	56                   	push   %esi
  8011d4:	53                   	push   %ebx
  8011d5:	83 ec 1c             	sub    $0x1c,%esp
  8011d8:	89 c7                	mov    %eax,%edi
  8011da:	89 d6                	mov    %edx,%esi
  8011dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e2:	89 d1                	mov    %edx,%ecx
  8011e4:	89 c2                	mov    %eax,%edx
  8011e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011e9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8011ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ef:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8011f5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8011fc:	39 c2                	cmp    %eax,%edx
  8011fe:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  801201:	72 3e                	jb     801241 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801203:	83 ec 0c             	sub    $0xc,%esp
  801206:	ff 75 18             	pushl  0x18(%ebp)
  801209:	83 eb 01             	sub    $0x1,%ebx
  80120c:	53                   	push   %ebx
  80120d:	50                   	push   %eax
  80120e:	83 ec 08             	sub    $0x8,%esp
  801211:	ff 75 e4             	pushl  -0x1c(%ebp)
  801214:	ff 75 e0             	pushl  -0x20(%ebp)
  801217:	ff 75 dc             	pushl  -0x24(%ebp)
  80121a:	ff 75 d8             	pushl  -0x28(%ebp)
  80121d:	e8 6e 0a 00 00       	call   801c90 <__udivdi3>
  801222:	83 c4 18             	add    $0x18,%esp
  801225:	52                   	push   %edx
  801226:	50                   	push   %eax
  801227:	89 f2                	mov    %esi,%edx
  801229:	89 f8                	mov    %edi,%eax
  80122b:	e8 9f ff ff ff       	call   8011cf <printnum>
  801230:	83 c4 20             	add    $0x20,%esp
  801233:	eb 13                	jmp    801248 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801235:	83 ec 08             	sub    $0x8,%esp
  801238:	56                   	push   %esi
  801239:	ff 75 18             	pushl  0x18(%ebp)
  80123c:	ff d7                	call   *%edi
  80123e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801241:	83 eb 01             	sub    $0x1,%ebx
  801244:	85 db                	test   %ebx,%ebx
  801246:	7f ed                	jg     801235 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801248:	83 ec 08             	sub    $0x8,%esp
  80124b:	56                   	push   %esi
  80124c:	83 ec 04             	sub    $0x4,%esp
  80124f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801252:	ff 75 e0             	pushl  -0x20(%ebp)
  801255:	ff 75 dc             	pushl  -0x24(%ebp)
  801258:	ff 75 d8             	pushl  -0x28(%ebp)
  80125b:	e8 40 0b 00 00       	call   801da0 <__umoddi3>
  801260:	83 c4 14             	add    $0x14,%esp
  801263:	0f be 80 47 20 80 00 	movsbl 0x802047(%eax),%eax
  80126a:	50                   	push   %eax
  80126b:	ff d7                	call   *%edi
}
  80126d:	83 c4 10             	add    $0x10,%esp
  801270:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801273:	5b                   	pop    %ebx
  801274:	5e                   	pop    %esi
  801275:	5f                   	pop    %edi
  801276:	5d                   	pop    %ebp
  801277:	c3                   	ret    

00801278 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801278:	f3 0f 1e fb          	endbr32 
  80127c:	55                   	push   %ebp
  80127d:	89 e5                	mov    %esp,%ebp
  80127f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801282:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801286:	8b 10                	mov    (%eax),%edx
  801288:	3b 50 04             	cmp    0x4(%eax),%edx
  80128b:	73 0a                	jae    801297 <sprintputch+0x1f>
		*b->buf++ = ch;
  80128d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801290:	89 08                	mov    %ecx,(%eax)
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	88 02                	mov    %al,(%edx)
}
  801297:	5d                   	pop    %ebp
  801298:	c3                   	ret    

00801299 <printfmt>:
{
  801299:	f3 0f 1e fb          	endbr32 
  80129d:	55                   	push   %ebp
  80129e:	89 e5                	mov    %esp,%ebp
  8012a0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8012a3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8012a6:	50                   	push   %eax
  8012a7:	ff 75 10             	pushl  0x10(%ebp)
  8012aa:	ff 75 0c             	pushl  0xc(%ebp)
  8012ad:	ff 75 08             	pushl  0x8(%ebp)
  8012b0:	e8 05 00 00 00       	call   8012ba <vprintfmt>
}
  8012b5:	83 c4 10             	add    $0x10,%esp
  8012b8:	c9                   	leave  
  8012b9:	c3                   	ret    

008012ba <vprintfmt>:
{
  8012ba:	f3 0f 1e fb          	endbr32 
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
  8012c1:	57                   	push   %edi
  8012c2:	56                   	push   %esi
  8012c3:	53                   	push   %ebx
  8012c4:	83 ec 3c             	sub    $0x3c,%esp
  8012c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8012ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012cd:	8b 7d 10             	mov    0x10(%ebp),%edi
  8012d0:	e9 8e 03 00 00       	jmp    801663 <vprintfmt+0x3a9>
		padc = ' ';
  8012d5:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8012d9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8012e0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8012e7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8012ee:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8012f3:	8d 47 01             	lea    0x1(%edi),%eax
  8012f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012f9:	0f b6 17             	movzbl (%edi),%edx
  8012fc:	8d 42 dd             	lea    -0x23(%edx),%eax
  8012ff:	3c 55                	cmp    $0x55,%al
  801301:	0f 87 df 03 00 00    	ja     8016e6 <vprintfmt+0x42c>
  801307:	0f b6 c0             	movzbl %al,%eax
  80130a:	3e ff 24 85 80 21 80 	notrack jmp *0x802180(,%eax,4)
  801311:	00 
  801312:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801315:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801319:	eb d8                	jmp    8012f3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80131b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80131e:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801322:	eb cf                	jmp    8012f3 <vprintfmt+0x39>
  801324:	0f b6 d2             	movzbl %dl,%edx
  801327:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80132a:	b8 00 00 00 00       	mov    $0x0,%eax
  80132f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801332:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801335:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801339:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80133c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80133f:	83 f9 09             	cmp    $0x9,%ecx
  801342:	77 55                	ja     801399 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  801344:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801347:	eb e9                	jmp    801332 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801349:	8b 45 14             	mov    0x14(%ebp),%eax
  80134c:	8b 00                	mov    (%eax),%eax
  80134e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801351:	8b 45 14             	mov    0x14(%ebp),%eax
  801354:	8d 40 04             	lea    0x4(%eax),%eax
  801357:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80135a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80135d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801361:	79 90                	jns    8012f3 <vprintfmt+0x39>
				width = precision, precision = -1;
  801363:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801366:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801369:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801370:	eb 81                	jmp    8012f3 <vprintfmt+0x39>
  801372:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801375:	85 c0                	test   %eax,%eax
  801377:	ba 00 00 00 00       	mov    $0x0,%edx
  80137c:	0f 49 d0             	cmovns %eax,%edx
  80137f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801382:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801385:	e9 69 ff ff ff       	jmp    8012f3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80138a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80138d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801394:	e9 5a ff ff ff       	jmp    8012f3 <vprintfmt+0x39>
  801399:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80139c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80139f:	eb bc                	jmp    80135d <vprintfmt+0xa3>
			lflag++;
  8013a1:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013a7:	e9 47 ff ff ff       	jmp    8012f3 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8013ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8013af:	8d 78 04             	lea    0x4(%eax),%edi
  8013b2:	83 ec 08             	sub    $0x8,%esp
  8013b5:	53                   	push   %ebx
  8013b6:	ff 30                	pushl  (%eax)
  8013b8:	ff d6                	call   *%esi
			break;
  8013ba:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8013bd:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8013c0:	e9 9b 02 00 00       	jmp    801660 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8013c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c8:	8d 78 04             	lea    0x4(%eax),%edi
  8013cb:	8b 00                	mov    (%eax),%eax
  8013cd:	99                   	cltd   
  8013ce:	31 d0                	xor    %edx,%eax
  8013d0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8013d2:	83 f8 0f             	cmp    $0xf,%eax
  8013d5:	7f 23                	jg     8013fa <vprintfmt+0x140>
  8013d7:	8b 14 85 e0 22 80 00 	mov    0x8022e0(,%eax,4),%edx
  8013de:	85 d2                	test   %edx,%edx
  8013e0:	74 18                	je     8013fa <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8013e2:	52                   	push   %edx
  8013e3:	68 dd 1f 80 00       	push   $0x801fdd
  8013e8:	53                   	push   %ebx
  8013e9:	56                   	push   %esi
  8013ea:	e8 aa fe ff ff       	call   801299 <printfmt>
  8013ef:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8013f2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8013f5:	e9 66 02 00 00       	jmp    801660 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8013fa:	50                   	push   %eax
  8013fb:	68 5f 20 80 00       	push   $0x80205f
  801400:	53                   	push   %ebx
  801401:	56                   	push   %esi
  801402:	e8 92 fe ff ff       	call   801299 <printfmt>
  801407:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80140a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80140d:	e9 4e 02 00 00       	jmp    801660 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  801412:	8b 45 14             	mov    0x14(%ebp),%eax
  801415:	83 c0 04             	add    $0x4,%eax
  801418:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80141b:	8b 45 14             	mov    0x14(%ebp),%eax
  80141e:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801420:	85 d2                	test   %edx,%edx
  801422:	b8 58 20 80 00       	mov    $0x802058,%eax
  801427:	0f 45 c2             	cmovne %edx,%eax
  80142a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80142d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801431:	7e 06                	jle    801439 <vprintfmt+0x17f>
  801433:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801437:	75 0d                	jne    801446 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801439:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80143c:	89 c7                	mov    %eax,%edi
  80143e:	03 45 e0             	add    -0x20(%ebp),%eax
  801441:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801444:	eb 55                	jmp    80149b <vprintfmt+0x1e1>
  801446:	83 ec 08             	sub    $0x8,%esp
  801449:	ff 75 d8             	pushl  -0x28(%ebp)
  80144c:	ff 75 cc             	pushl  -0x34(%ebp)
  80144f:	e8 46 03 00 00       	call   80179a <strnlen>
  801454:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801457:	29 c2                	sub    %eax,%edx
  801459:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80145c:	83 c4 10             	add    $0x10,%esp
  80145f:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801461:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801465:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801468:	85 ff                	test   %edi,%edi
  80146a:	7e 11                	jle    80147d <vprintfmt+0x1c3>
					putch(padc, putdat);
  80146c:	83 ec 08             	sub    $0x8,%esp
  80146f:	53                   	push   %ebx
  801470:	ff 75 e0             	pushl  -0x20(%ebp)
  801473:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801475:	83 ef 01             	sub    $0x1,%edi
  801478:	83 c4 10             	add    $0x10,%esp
  80147b:	eb eb                	jmp    801468 <vprintfmt+0x1ae>
  80147d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801480:	85 d2                	test   %edx,%edx
  801482:	b8 00 00 00 00       	mov    $0x0,%eax
  801487:	0f 49 c2             	cmovns %edx,%eax
  80148a:	29 c2                	sub    %eax,%edx
  80148c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80148f:	eb a8                	jmp    801439 <vprintfmt+0x17f>
					putch(ch, putdat);
  801491:	83 ec 08             	sub    $0x8,%esp
  801494:	53                   	push   %ebx
  801495:	52                   	push   %edx
  801496:	ff d6                	call   *%esi
  801498:	83 c4 10             	add    $0x10,%esp
  80149b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80149e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014a0:	83 c7 01             	add    $0x1,%edi
  8014a3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8014a7:	0f be d0             	movsbl %al,%edx
  8014aa:	85 d2                	test   %edx,%edx
  8014ac:	74 4b                	je     8014f9 <vprintfmt+0x23f>
  8014ae:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014b2:	78 06                	js     8014ba <vprintfmt+0x200>
  8014b4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8014b8:	78 1e                	js     8014d8 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8014ba:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8014be:	74 d1                	je     801491 <vprintfmt+0x1d7>
  8014c0:	0f be c0             	movsbl %al,%eax
  8014c3:	83 e8 20             	sub    $0x20,%eax
  8014c6:	83 f8 5e             	cmp    $0x5e,%eax
  8014c9:	76 c6                	jbe    801491 <vprintfmt+0x1d7>
					putch('?', putdat);
  8014cb:	83 ec 08             	sub    $0x8,%esp
  8014ce:	53                   	push   %ebx
  8014cf:	6a 3f                	push   $0x3f
  8014d1:	ff d6                	call   *%esi
  8014d3:	83 c4 10             	add    $0x10,%esp
  8014d6:	eb c3                	jmp    80149b <vprintfmt+0x1e1>
  8014d8:	89 cf                	mov    %ecx,%edi
  8014da:	eb 0e                	jmp    8014ea <vprintfmt+0x230>
				putch(' ', putdat);
  8014dc:	83 ec 08             	sub    $0x8,%esp
  8014df:	53                   	push   %ebx
  8014e0:	6a 20                	push   $0x20
  8014e2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8014e4:	83 ef 01             	sub    $0x1,%edi
  8014e7:	83 c4 10             	add    $0x10,%esp
  8014ea:	85 ff                	test   %edi,%edi
  8014ec:	7f ee                	jg     8014dc <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8014ee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8014f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8014f4:	e9 67 01 00 00       	jmp    801660 <vprintfmt+0x3a6>
  8014f9:	89 cf                	mov    %ecx,%edi
  8014fb:	eb ed                	jmp    8014ea <vprintfmt+0x230>
	if (lflag >= 2)
  8014fd:	83 f9 01             	cmp    $0x1,%ecx
  801500:	7f 1b                	jg     80151d <vprintfmt+0x263>
	else if (lflag)
  801502:	85 c9                	test   %ecx,%ecx
  801504:	74 63                	je     801569 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  801506:	8b 45 14             	mov    0x14(%ebp),%eax
  801509:	8b 00                	mov    (%eax),%eax
  80150b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80150e:	99                   	cltd   
  80150f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801512:	8b 45 14             	mov    0x14(%ebp),%eax
  801515:	8d 40 04             	lea    0x4(%eax),%eax
  801518:	89 45 14             	mov    %eax,0x14(%ebp)
  80151b:	eb 17                	jmp    801534 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80151d:	8b 45 14             	mov    0x14(%ebp),%eax
  801520:	8b 50 04             	mov    0x4(%eax),%edx
  801523:	8b 00                	mov    (%eax),%eax
  801525:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801528:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80152b:	8b 45 14             	mov    0x14(%ebp),%eax
  80152e:	8d 40 08             	lea    0x8(%eax),%eax
  801531:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801534:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801537:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80153a:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80153f:	85 c9                	test   %ecx,%ecx
  801541:	0f 89 ff 00 00 00    	jns    801646 <vprintfmt+0x38c>
				putch('-', putdat);
  801547:	83 ec 08             	sub    $0x8,%esp
  80154a:	53                   	push   %ebx
  80154b:	6a 2d                	push   $0x2d
  80154d:	ff d6                	call   *%esi
				num = -(long long) num;
  80154f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801552:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801555:	f7 da                	neg    %edx
  801557:	83 d1 00             	adc    $0x0,%ecx
  80155a:	f7 d9                	neg    %ecx
  80155c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80155f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801564:	e9 dd 00 00 00       	jmp    801646 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801569:	8b 45 14             	mov    0x14(%ebp),%eax
  80156c:	8b 00                	mov    (%eax),%eax
  80156e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801571:	99                   	cltd   
  801572:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801575:	8b 45 14             	mov    0x14(%ebp),%eax
  801578:	8d 40 04             	lea    0x4(%eax),%eax
  80157b:	89 45 14             	mov    %eax,0x14(%ebp)
  80157e:	eb b4                	jmp    801534 <vprintfmt+0x27a>
	if (lflag >= 2)
  801580:	83 f9 01             	cmp    $0x1,%ecx
  801583:	7f 1e                	jg     8015a3 <vprintfmt+0x2e9>
	else if (lflag)
  801585:	85 c9                	test   %ecx,%ecx
  801587:	74 32                	je     8015bb <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801589:	8b 45 14             	mov    0x14(%ebp),%eax
  80158c:	8b 10                	mov    (%eax),%edx
  80158e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801593:	8d 40 04             	lea    0x4(%eax),%eax
  801596:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801599:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80159e:	e9 a3 00 00 00       	jmp    801646 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8015a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a6:	8b 10                	mov    (%eax),%edx
  8015a8:	8b 48 04             	mov    0x4(%eax),%ecx
  8015ab:	8d 40 08             	lea    0x8(%eax),%eax
  8015ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015b1:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8015b6:	e9 8b 00 00 00       	jmp    801646 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8015bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8015be:	8b 10                	mov    (%eax),%edx
  8015c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015c5:	8d 40 04             	lea    0x4(%eax),%eax
  8015c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015cb:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8015d0:	eb 74                	jmp    801646 <vprintfmt+0x38c>
	if (lflag >= 2)
  8015d2:	83 f9 01             	cmp    $0x1,%ecx
  8015d5:	7f 1b                	jg     8015f2 <vprintfmt+0x338>
	else if (lflag)
  8015d7:	85 c9                	test   %ecx,%ecx
  8015d9:	74 2c                	je     801607 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8015db:	8b 45 14             	mov    0x14(%ebp),%eax
  8015de:	8b 10                	mov    (%eax),%edx
  8015e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015e5:	8d 40 04             	lea    0x4(%eax),%eax
  8015e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8015eb:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8015f0:	eb 54                	jmp    801646 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8015f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8015f5:	8b 10                	mov    (%eax),%edx
  8015f7:	8b 48 04             	mov    0x4(%eax),%ecx
  8015fa:	8d 40 08             	lea    0x8(%eax),%eax
  8015fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801600:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801605:	eb 3f                	jmp    801646 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801607:	8b 45 14             	mov    0x14(%ebp),%eax
  80160a:	8b 10                	mov    (%eax),%edx
  80160c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801611:	8d 40 04             	lea    0x4(%eax),%eax
  801614:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801617:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80161c:	eb 28                	jmp    801646 <vprintfmt+0x38c>
			putch('0', putdat);
  80161e:	83 ec 08             	sub    $0x8,%esp
  801621:	53                   	push   %ebx
  801622:	6a 30                	push   $0x30
  801624:	ff d6                	call   *%esi
			putch('x', putdat);
  801626:	83 c4 08             	add    $0x8,%esp
  801629:	53                   	push   %ebx
  80162a:	6a 78                	push   $0x78
  80162c:	ff d6                	call   *%esi
			num = (unsigned long long)
  80162e:	8b 45 14             	mov    0x14(%ebp),%eax
  801631:	8b 10                	mov    (%eax),%edx
  801633:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801638:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80163b:	8d 40 04             	lea    0x4(%eax),%eax
  80163e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801641:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801646:	83 ec 0c             	sub    $0xc,%esp
  801649:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80164d:	57                   	push   %edi
  80164e:	ff 75 e0             	pushl  -0x20(%ebp)
  801651:	50                   	push   %eax
  801652:	51                   	push   %ecx
  801653:	52                   	push   %edx
  801654:	89 da                	mov    %ebx,%edx
  801656:	89 f0                	mov    %esi,%eax
  801658:	e8 72 fb ff ff       	call   8011cf <printnum>
			break;
  80165d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801660:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801663:	83 c7 01             	add    $0x1,%edi
  801666:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80166a:	83 f8 25             	cmp    $0x25,%eax
  80166d:	0f 84 62 fc ff ff    	je     8012d5 <vprintfmt+0x1b>
			if (ch == '\0')
  801673:	85 c0                	test   %eax,%eax
  801675:	0f 84 8b 00 00 00    	je     801706 <vprintfmt+0x44c>
			putch(ch, putdat);
  80167b:	83 ec 08             	sub    $0x8,%esp
  80167e:	53                   	push   %ebx
  80167f:	50                   	push   %eax
  801680:	ff d6                	call   *%esi
  801682:	83 c4 10             	add    $0x10,%esp
  801685:	eb dc                	jmp    801663 <vprintfmt+0x3a9>
	if (lflag >= 2)
  801687:	83 f9 01             	cmp    $0x1,%ecx
  80168a:	7f 1b                	jg     8016a7 <vprintfmt+0x3ed>
	else if (lflag)
  80168c:	85 c9                	test   %ecx,%ecx
  80168e:	74 2c                	je     8016bc <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801690:	8b 45 14             	mov    0x14(%ebp),%eax
  801693:	8b 10                	mov    (%eax),%edx
  801695:	b9 00 00 00 00       	mov    $0x0,%ecx
  80169a:	8d 40 04             	lea    0x4(%eax),%eax
  80169d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016a0:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8016a5:	eb 9f                	jmp    801646 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8016a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016aa:	8b 10                	mov    (%eax),%edx
  8016ac:	8b 48 04             	mov    0x4(%eax),%ecx
  8016af:	8d 40 08             	lea    0x8(%eax),%eax
  8016b2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016b5:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8016ba:	eb 8a                	jmp    801646 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8016bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8016bf:	8b 10                	mov    (%eax),%edx
  8016c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016c6:	8d 40 04             	lea    0x4(%eax),%eax
  8016c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016cc:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8016d1:	e9 70 ff ff ff       	jmp    801646 <vprintfmt+0x38c>
			putch(ch, putdat);
  8016d6:	83 ec 08             	sub    $0x8,%esp
  8016d9:	53                   	push   %ebx
  8016da:	6a 25                	push   $0x25
  8016dc:	ff d6                	call   *%esi
			break;
  8016de:	83 c4 10             	add    $0x10,%esp
  8016e1:	e9 7a ff ff ff       	jmp    801660 <vprintfmt+0x3a6>
			putch('%', putdat);
  8016e6:	83 ec 08             	sub    $0x8,%esp
  8016e9:	53                   	push   %ebx
  8016ea:	6a 25                	push   $0x25
  8016ec:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8016ee:	83 c4 10             	add    $0x10,%esp
  8016f1:	89 f8                	mov    %edi,%eax
  8016f3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8016f7:	74 05                	je     8016fe <vprintfmt+0x444>
  8016f9:	83 e8 01             	sub    $0x1,%eax
  8016fc:	eb f5                	jmp    8016f3 <vprintfmt+0x439>
  8016fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801701:	e9 5a ff ff ff       	jmp    801660 <vprintfmt+0x3a6>
}
  801706:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801709:	5b                   	pop    %ebx
  80170a:	5e                   	pop    %esi
  80170b:	5f                   	pop    %edi
  80170c:	5d                   	pop    %ebp
  80170d:	c3                   	ret    

0080170e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80170e:	f3 0f 1e fb          	endbr32 
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	83 ec 18             	sub    $0x18,%esp
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80171e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801721:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801725:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801728:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80172f:	85 c0                	test   %eax,%eax
  801731:	74 26                	je     801759 <vsnprintf+0x4b>
  801733:	85 d2                	test   %edx,%edx
  801735:	7e 22                	jle    801759 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801737:	ff 75 14             	pushl  0x14(%ebp)
  80173a:	ff 75 10             	pushl  0x10(%ebp)
  80173d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801740:	50                   	push   %eax
  801741:	68 78 12 80 00       	push   $0x801278
  801746:	e8 6f fb ff ff       	call   8012ba <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80174b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80174e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801754:	83 c4 10             	add    $0x10,%esp
}
  801757:	c9                   	leave  
  801758:	c3                   	ret    
		return -E_INVAL;
  801759:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80175e:	eb f7                	jmp    801757 <vsnprintf+0x49>

00801760 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801760:	f3 0f 1e fb          	endbr32 
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
  801767:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80176a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80176d:	50                   	push   %eax
  80176e:	ff 75 10             	pushl  0x10(%ebp)
  801771:	ff 75 0c             	pushl  0xc(%ebp)
  801774:	ff 75 08             	pushl  0x8(%ebp)
  801777:	e8 92 ff ff ff       	call   80170e <vsnprintf>
	va_end(ap);

	return rc;
}
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80177e:	f3 0f 1e fb          	endbr32 
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801788:	b8 00 00 00 00       	mov    $0x0,%eax
  80178d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801791:	74 05                	je     801798 <strlen+0x1a>
		n++;
  801793:	83 c0 01             	add    $0x1,%eax
  801796:	eb f5                	jmp    80178d <strlen+0xf>
	return n;
}
  801798:	5d                   	pop    %ebp
  801799:	c3                   	ret    

0080179a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80179a:	f3 0f 1e fb          	endbr32 
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
  8017a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017a4:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8017a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ac:	39 d0                	cmp    %edx,%eax
  8017ae:	74 0d                	je     8017bd <strnlen+0x23>
  8017b0:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8017b4:	74 05                	je     8017bb <strnlen+0x21>
		n++;
  8017b6:	83 c0 01             	add    $0x1,%eax
  8017b9:	eb f1                	jmp    8017ac <strnlen+0x12>
  8017bb:	89 c2                	mov    %eax,%edx
	return n;
}
  8017bd:	89 d0                	mov    %edx,%eax
  8017bf:	5d                   	pop    %ebp
  8017c0:	c3                   	ret    

008017c1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8017c1:	f3 0f 1e fb          	endbr32 
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	53                   	push   %ebx
  8017c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8017cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d4:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8017d8:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8017db:	83 c0 01             	add    $0x1,%eax
  8017de:	84 d2                	test   %dl,%dl
  8017e0:	75 f2                	jne    8017d4 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8017e2:	89 c8                	mov    %ecx,%eax
  8017e4:	5b                   	pop    %ebx
  8017e5:	5d                   	pop    %ebp
  8017e6:	c3                   	ret    

008017e7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8017e7:	f3 0f 1e fb          	endbr32 
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	53                   	push   %ebx
  8017ef:	83 ec 10             	sub    $0x10,%esp
  8017f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8017f5:	53                   	push   %ebx
  8017f6:	e8 83 ff ff ff       	call   80177e <strlen>
  8017fb:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8017fe:	ff 75 0c             	pushl  0xc(%ebp)
  801801:	01 d8                	add    %ebx,%eax
  801803:	50                   	push   %eax
  801804:	e8 b8 ff ff ff       	call   8017c1 <strcpy>
	return dst;
}
  801809:	89 d8                	mov    %ebx,%eax
  80180b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801810:	f3 0f 1e fb          	endbr32 
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
  801817:	56                   	push   %esi
  801818:	53                   	push   %ebx
  801819:	8b 75 08             	mov    0x8(%ebp),%esi
  80181c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181f:	89 f3                	mov    %esi,%ebx
  801821:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801824:	89 f0                	mov    %esi,%eax
  801826:	39 d8                	cmp    %ebx,%eax
  801828:	74 11                	je     80183b <strncpy+0x2b>
		*dst++ = *src;
  80182a:	83 c0 01             	add    $0x1,%eax
  80182d:	0f b6 0a             	movzbl (%edx),%ecx
  801830:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801833:	80 f9 01             	cmp    $0x1,%cl
  801836:	83 da ff             	sbb    $0xffffffff,%edx
  801839:	eb eb                	jmp    801826 <strncpy+0x16>
	}
	return ret;
}
  80183b:	89 f0                	mov    %esi,%eax
  80183d:	5b                   	pop    %ebx
  80183e:	5e                   	pop    %esi
  80183f:	5d                   	pop    %ebp
  801840:	c3                   	ret    

00801841 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801841:	f3 0f 1e fb          	endbr32 
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	56                   	push   %esi
  801849:	53                   	push   %ebx
  80184a:	8b 75 08             	mov    0x8(%ebp),%esi
  80184d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801850:	8b 55 10             	mov    0x10(%ebp),%edx
  801853:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801855:	85 d2                	test   %edx,%edx
  801857:	74 21                	je     80187a <strlcpy+0x39>
  801859:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80185d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80185f:	39 c2                	cmp    %eax,%edx
  801861:	74 14                	je     801877 <strlcpy+0x36>
  801863:	0f b6 19             	movzbl (%ecx),%ebx
  801866:	84 db                	test   %bl,%bl
  801868:	74 0b                	je     801875 <strlcpy+0x34>
			*dst++ = *src++;
  80186a:	83 c1 01             	add    $0x1,%ecx
  80186d:	83 c2 01             	add    $0x1,%edx
  801870:	88 5a ff             	mov    %bl,-0x1(%edx)
  801873:	eb ea                	jmp    80185f <strlcpy+0x1e>
  801875:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801877:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80187a:	29 f0                	sub    %esi,%eax
}
  80187c:	5b                   	pop    %ebx
  80187d:	5e                   	pop    %esi
  80187e:	5d                   	pop    %ebp
  80187f:	c3                   	ret    

00801880 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801880:	f3 0f 1e fb          	endbr32 
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80188a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80188d:	0f b6 01             	movzbl (%ecx),%eax
  801890:	84 c0                	test   %al,%al
  801892:	74 0c                	je     8018a0 <strcmp+0x20>
  801894:	3a 02                	cmp    (%edx),%al
  801896:	75 08                	jne    8018a0 <strcmp+0x20>
		p++, q++;
  801898:	83 c1 01             	add    $0x1,%ecx
  80189b:	83 c2 01             	add    $0x1,%edx
  80189e:	eb ed                	jmp    80188d <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018a0:	0f b6 c0             	movzbl %al,%eax
  8018a3:	0f b6 12             	movzbl (%edx),%edx
  8018a6:	29 d0                	sub    %edx,%eax
}
  8018a8:	5d                   	pop    %ebp
  8018a9:	c3                   	ret    

008018aa <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018aa:	f3 0f 1e fb          	endbr32 
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	53                   	push   %ebx
  8018b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b8:	89 c3                	mov    %eax,%ebx
  8018ba:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8018bd:	eb 06                	jmp    8018c5 <strncmp+0x1b>
		n--, p++, q++;
  8018bf:	83 c0 01             	add    $0x1,%eax
  8018c2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8018c5:	39 d8                	cmp    %ebx,%eax
  8018c7:	74 16                	je     8018df <strncmp+0x35>
  8018c9:	0f b6 08             	movzbl (%eax),%ecx
  8018cc:	84 c9                	test   %cl,%cl
  8018ce:	74 04                	je     8018d4 <strncmp+0x2a>
  8018d0:	3a 0a                	cmp    (%edx),%cl
  8018d2:	74 eb                	je     8018bf <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018d4:	0f b6 00             	movzbl (%eax),%eax
  8018d7:	0f b6 12             	movzbl (%edx),%edx
  8018da:	29 d0                	sub    %edx,%eax
}
  8018dc:	5b                   	pop    %ebx
  8018dd:	5d                   	pop    %ebp
  8018de:	c3                   	ret    
		return 0;
  8018df:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e4:	eb f6                	jmp    8018dc <strncmp+0x32>

008018e6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018e6:	f3 0f 1e fb          	endbr32 
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8018f4:	0f b6 10             	movzbl (%eax),%edx
  8018f7:	84 d2                	test   %dl,%dl
  8018f9:	74 09                	je     801904 <strchr+0x1e>
		if (*s == c)
  8018fb:	38 ca                	cmp    %cl,%dl
  8018fd:	74 0a                	je     801909 <strchr+0x23>
	for (; *s; s++)
  8018ff:	83 c0 01             	add    $0x1,%eax
  801902:	eb f0                	jmp    8018f4 <strchr+0xe>
			return (char *) s;
	return 0;
  801904:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801909:	5d                   	pop    %ebp
  80190a:	c3                   	ret    

0080190b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80190b:	f3 0f 1e fb          	endbr32 
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801919:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80191c:	38 ca                	cmp    %cl,%dl
  80191e:	74 09                	je     801929 <strfind+0x1e>
  801920:	84 d2                	test   %dl,%dl
  801922:	74 05                	je     801929 <strfind+0x1e>
	for (; *s; s++)
  801924:	83 c0 01             	add    $0x1,%eax
  801927:	eb f0                	jmp    801919 <strfind+0xe>
			break;
	return (char *) s;
}
  801929:	5d                   	pop    %ebp
  80192a:	c3                   	ret    

0080192b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80192b:	f3 0f 1e fb          	endbr32 
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
  801932:	57                   	push   %edi
  801933:	56                   	push   %esi
  801934:	53                   	push   %ebx
  801935:	8b 7d 08             	mov    0x8(%ebp),%edi
  801938:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80193b:	85 c9                	test   %ecx,%ecx
  80193d:	74 31                	je     801970 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80193f:	89 f8                	mov    %edi,%eax
  801941:	09 c8                	or     %ecx,%eax
  801943:	a8 03                	test   $0x3,%al
  801945:	75 23                	jne    80196a <memset+0x3f>
		c &= 0xFF;
  801947:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80194b:	89 d3                	mov    %edx,%ebx
  80194d:	c1 e3 08             	shl    $0x8,%ebx
  801950:	89 d0                	mov    %edx,%eax
  801952:	c1 e0 18             	shl    $0x18,%eax
  801955:	89 d6                	mov    %edx,%esi
  801957:	c1 e6 10             	shl    $0x10,%esi
  80195a:	09 f0                	or     %esi,%eax
  80195c:	09 c2                	or     %eax,%edx
  80195e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801960:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801963:	89 d0                	mov    %edx,%eax
  801965:	fc                   	cld    
  801966:	f3 ab                	rep stos %eax,%es:(%edi)
  801968:	eb 06                	jmp    801970 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80196a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196d:	fc                   	cld    
  80196e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801970:	89 f8                	mov    %edi,%eax
  801972:	5b                   	pop    %ebx
  801973:	5e                   	pop    %esi
  801974:	5f                   	pop    %edi
  801975:	5d                   	pop    %ebp
  801976:	c3                   	ret    

00801977 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801977:	f3 0f 1e fb          	endbr32 
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	57                   	push   %edi
  80197f:	56                   	push   %esi
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	8b 75 0c             	mov    0xc(%ebp),%esi
  801986:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801989:	39 c6                	cmp    %eax,%esi
  80198b:	73 32                	jae    8019bf <memmove+0x48>
  80198d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801990:	39 c2                	cmp    %eax,%edx
  801992:	76 2b                	jbe    8019bf <memmove+0x48>
		s += n;
		d += n;
  801994:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801997:	89 fe                	mov    %edi,%esi
  801999:	09 ce                	or     %ecx,%esi
  80199b:	09 d6                	or     %edx,%esi
  80199d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8019a3:	75 0e                	jne    8019b3 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8019a5:	83 ef 04             	sub    $0x4,%edi
  8019a8:	8d 72 fc             	lea    -0x4(%edx),%esi
  8019ab:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8019ae:	fd                   	std    
  8019af:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019b1:	eb 09                	jmp    8019bc <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8019b3:	83 ef 01             	sub    $0x1,%edi
  8019b6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8019b9:	fd                   	std    
  8019ba:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8019bc:	fc                   	cld    
  8019bd:	eb 1a                	jmp    8019d9 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019bf:	89 c2                	mov    %eax,%edx
  8019c1:	09 ca                	or     %ecx,%edx
  8019c3:	09 f2                	or     %esi,%edx
  8019c5:	f6 c2 03             	test   $0x3,%dl
  8019c8:	75 0a                	jne    8019d4 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8019ca:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8019cd:	89 c7                	mov    %eax,%edi
  8019cf:	fc                   	cld    
  8019d0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019d2:	eb 05                	jmp    8019d9 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8019d4:	89 c7                	mov    %eax,%edi
  8019d6:	fc                   	cld    
  8019d7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8019d9:	5e                   	pop    %esi
  8019da:	5f                   	pop    %edi
  8019db:	5d                   	pop    %ebp
  8019dc:	c3                   	ret    

008019dd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8019dd:	f3 0f 1e fb          	endbr32 
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8019e7:	ff 75 10             	pushl  0x10(%ebp)
  8019ea:	ff 75 0c             	pushl  0xc(%ebp)
  8019ed:	ff 75 08             	pushl  0x8(%ebp)
  8019f0:	e8 82 ff ff ff       	call   801977 <memmove>
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8019f7:	f3 0f 1e fb          	endbr32 
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	56                   	push   %esi
  8019ff:	53                   	push   %ebx
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a06:	89 c6                	mov    %eax,%esi
  801a08:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801a0b:	39 f0                	cmp    %esi,%eax
  801a0d:	74 1c                	je     801a2b <memcmp+0x34>
		if (*s1 != *s2)
  801a0f:	0f b6 08             	movzbl (%eax),%ecx
  801a12:	0f b6 1a             	movzbl (%edx),%ebx
  801a15:	38 d9                	cmp    %bl,%cl
  801a17:	75 08                	jne    801a21 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801a19:	83 c0 01             	add    $0x1,%eax
  801a1c:	83 c2 01             	add    $0x1,%edx
  801a1f:	eb ea                	jmp    801a0b <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801a21:	0f b6 c1             	movzbl %cl,%eax
  801a24:	0f b6 db             	movzbl %bl,%ebx
  801a27:	29 d8                	sub    %ebx,%eax
  801a29:	eb 05                	jmp    801a30 <memcmp+0x39>
	}

	return 0;
  801a2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a30:	5b                   	pop    %ebx
  801a31:	5e                   	pop    %esi
  801a32:	5d                   	pop    %ebp
  801a33:	c3                   	ret    

00801a34 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a34:	f3 0f 1e fb          	endbr32 
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801a41:	89 c2                	mov    %eax,%edx
  801a43:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801a46:	39 d0                	cmp    %edx,%eax
  801a48:	73 09                	jae    801a53 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a4a:	38 08                	cmp    %cl,(%eax)
  801a4c:	74 05                	je     801a53 <memfind+0x1f>
	for (; s < ends; s++)
  801a4e:	83 c0 01             	add    $0x1,%eax
  801a51:	eb f3                	jmp    801a46 <memfind+0x12>
			break;
	return (void *) s;
}
  801a53:	5d                   	pop    %ebp
  801a54:	c3                   	ret    

00801a55 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a55:	f3 0f 1e fb          	endbr32 
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	57                   	push   %edi
  801a5d:	56                   	push   %esi
  801a5e:	53                   	push   %ebx
  801a5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a62:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a65:	eb 03                	jmp    801a6a <strtol+0x15>
		s++;
  801a67:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801a6a:	0f b6 01             	movzbl (%ecx),%eax
  801a6d:	3c 20                	cmp    $0x20,%al
  801a6f:	74 f6                	je     801a67 <strtol+0x12>
  801a71:	3c 09                	cmp    $0x9,%al
  801a73:	74 f2                	je     801a67 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801a75:	3c 2b                	cmp    $0x2b,%al
  801a77:	74 2a                	je     801aa3 <strtol+0x4e>
	int neg = 0;
  801a79:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801a7e:	3c 2d                	cmp    $0x2d,%al
  801a80:	74 2b                	je     801aad <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a82:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801a88:	75 0f                	jne    801a99 <strtol+0x44>
  801a8a:	80 39 30             	cmpb   $0x30,(%ecx)
  801a8d:	74 28                	je     801ab7 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801a8f:	85 db                	test   %ebx,%ebx
  801a91:	b8 0a 00 00 00       	mov    $0xa,%eax
  801a96:	0f 44 d8             	cmove  %eax,%ebx
  801a99:	b8 00 00 00 00       	mov    $0x0,%eax
  801a9e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801aa1:	eb 46                	jmp    801ae9 <strtol+0x94>
		s++;
  801aa3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801aa6:	bf 00 00 00 00       	mov    $0x0,%edi
  801aab:	eb d5                	jmp    801a82 <strtol+0x2d>
		s++, neg = 1;
  801aad:	83 c1 01             	add    $0x1,%ecx
  801ab0:	bf 01 00 00 00       	mov    $0x1,%edi
  801ab5:	eb cb                	jmp    801a82 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ab7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801abb:	74 0e                	je     801acb <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801abd:	85 db                	test   %ebx,%ebx
  801abf:	75 d8                	jne    801a99 <strtol+0x44>
		s++, base = 8;
  801ac1:	83 c1 01             	add    $0x1,%ecx
  801ac4:	bb 08 00 00 00       	mov    $0x8,%ebx
  801ac9:	eb ce                	jmp    801a99 <strtol+0x44>
		s += 2, base = 16;
  801acb:	83 c1 02             	add    $0x2,%ecx
  801ace:	bb 10 00 00 00       	mov    $0x10,%ebx
  801ad3:	eb c4                	jmp    801a99 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801ad5:	0f be d2             	movsbl %dl,%edx
  801ad8:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801adb:	3b 55 10             	cmp    0x10(%ebp),%edx
  801ade:	7d 3a                	jge    801b1a <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801ae0:	83 c1 01             	add    $0x1,%ecx
  801ae3:	0f af 45 10          	imul   0x10(%ebp),%eax
  801ae7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801ae9:	0f b6 11             	movzbl (%ecx),%edx
  801aec:	8d 72 d0             	lea    -0x30(%edx),%esi
  801aef:	89 f3                	mov    %esi,%ebx
  801af1:	80 fb 09             	cmp    $0x9,%bl
  801af4:	76 df                	jbe    801ad5 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801af6:	8d 72 9f             	lea    -0x61(%edx),%esi
  801af9:	89 f3                	mov    %esi,%ebx
  801afb:	80 fb 19             	cmp    $0x19,%bl
  801afe:	77 08                	ja     801b08 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801b00:	0f be d2             	movsbl %dl,%edx
  801b03:	83 ea 57             	sub    $0x57,%edx
  801b06:	eb d3                	jmp    801adb <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801b08:	8d 72 bf             	lea    -0x41(%edx),%esi
  801b0b:	89 f3                	mov    %esi,%ebx
  801b0d:	80 fb 19             	cmp    $0x19,%bl
  801b10:	77 08                	ja     801b1a <strtol+0xc5>
			dig = *s - 'A' + 10;
  801b12:	0f be d2             	movsbl %dl,%edx
  801b15:	83 ea 37             	sub    $0x37,%edx
  801b18:	eb c1                	jmp    801adb <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801b1a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b1e:	74 05                	je     801b25 <strtol+0xd0>
		*endptr = (char *) s;
  801b20:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b23:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801b25:	89 c2                	mov    %eax,%edx
  801b27:	f7 da                	neg    %edx
  801b29:	85 ff                	test   %edi,%edi
  801b2b:	0f 45 c2             	cmovne %edx,%eax
}
  801b2e:	5b                   	pop    %ebx
  801b2f:	5e                   	pop    %esi
  801b30:	5f                   	pop    %edi
  801b31:	5d                   	pop    %ebp
  801b32:	c3                   	ret    

00801b33 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b33:	f3 0f 1e fb          	endbr32 
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	56                   	push   %esi
  801b3b:	53                   	push   %ebx
  801b3c:	8b 75 08             	mov    0x8(%ebp),%esi
  801b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b42:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  801b45:	85 c0                	test   %eax,%eax
  801b47:	74 3d                	je     801b86 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  801b49:	83 ec 0c             	sub    $0xc,%esp
  801b4c:	50                   	push   %eax
  801b4d:	e8 f4 e7 ff ff       	call   800346 <sys_ipc_recv>
  801b52:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  801b55:	85 f6                	test   %esi,%esi
  801b57:	74 0b                	je     801b64 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b59:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b5f:	8b 52 74             	mov    0x74(%edx),%edx
  801b62:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  801b64:	85 db                	test   %ebx,%ebx
  801b66:	74 0b                	je     801b73 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  801b68:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b6e:	8b 52 78             	mov    0x78(%edx),%edx
  801b71:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  801b73:	85 c0                	test   %eax,%eax
  801b75:	78 21                	js     801b98 <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  801b77:	a1 04 40 80 00       	mov    0x804004,%eax
  801b7c:	8b 40 70             	mov    0x70(%eax),%eax
}
  801b7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b82:	5b                   	pop    %ebx
  801b83:	5e                   	pop    %esi
  801b84:	5d                   	pop    %ebp
  801b85:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  801b86:	83 ec 0c             	sub    $0xc,%esp
  801b89:	68 00 00 c0 ee       	push   $0xeec00000
  801b8e:	e8 b3 e7 ff ff       	call   800346 <sys_ipc_recv>
  801b93:	83 c4 10             	add    $0x10,%esp
  801b96:	eb bd                	jmp    801b55 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  801b98:	85 f6                	test   %esi,%esi
  801b9a:	74 10                	je     801bac <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  801b9c:	85 db                	test   %ebx,%ebx
  801b9e:	75 df                	jne    801b7f <ipc_recv+0x4c>
  801ba0:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801ba7:	00 00 00 
  801baa:	eb d3                	jmp    801b7f <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  801bac:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  801bb3:	00 00 00 
  801bb6:	eb e4                	jmp    801b9c <ipc_recv+0x69>

00801bb8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bb8:	f3 0f 1e fb          	endbr32 
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
  801bbf:	57                   	push   %edi
  801bc0:	56                   	push   %esi
  801bc1:	53                   	push   %ebx
  801bc2:	83 ec 0c             	sub    $0xc,%esp
  801bc5:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bc8:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bcb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  801bce:	85 db                	test   %ebx,%ebx
  801bd0:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801bd5:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  801bd8:	ff 75 14             	pushl  0x14(%ebp)
  801bdb:	53                   	push   %ebx
  801bdc:	56                   	push   %esi
  801bdd:	57                   	push   %edi
  801bde:	e8 3c e7 ff ff       	call   80031f <sys_ipc_try_send>
  801be3:	83 c4 10             	add    $0x10,%esp
  801be6:	85 c0                	test   %eax,%eax
  801be8:	79 1e                	jns    801c08 <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  801bea:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801bed:	75 07                	jne    801bf6 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  801bef:	e8 63 e5 ff ff       	call   800157 <sys_yield>
  801bf4:	eb e2                	jmp    801bd8 <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  801bf6:	50                   	push   %eax
  801bf7:	68 3f 23 80 00       	push   $0x80233f
  801bfc:	6a 59                	push   $0x59
  801bfe:	68 5a 23 80 00       	push   $0x80235a
  801c03:	e8 c8 f4 ff ff       	call   8010d0 <_panic>
	}
}
  801c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c0b:	5b                   	pop    %ebx
  801c0c:	5e                   	pop    %esi
  801c0d:	5f                   	pop    %edi
  801c0e:	5d                   	pop    %ebp
  801c0f:	c3                   	ret    

00801c10 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c10:	f3 0f 1e fb          	endbr32 
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c1a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c1f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c22:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c28:	8b 52 50             	mov    0x50(%edx),%edx
  801c2b:	39 ca                	cmp    %ecx,%edx
  801c2d:	74 11                	je     801c40 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801c2f:	83 c0 01             	add    $0x1,%eax
  801c32:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c37:	75 e6                	jne    801c1f <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801c39:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3e:	eb 0b                	jmp    801c4b <ipc_find_env+0x3b>
			return envs[i].env_id;
  801c40:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c43:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c48:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c4b:	5d                   	pop    %ebp
  801c4c:	c3                   	ret    

00801c4d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c4d:	f3 0f 1e fb          	endbr32 
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c57:	89 c2                	mov    %eax,%edx
  801c59:	c1 ea 16             	shr    $0x16,%edx
  801c5c:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c63:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c68:	f6 c1 01             	test   $0x1,%cl
  801c6b:	74 1c                	je     801c89 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801c6d:	c1 e8 0c             	shr    $0xc,%eax
  801c70:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c77:	a8 01                	test   $0x1,%al
  801c79:	74 0e                	je     801c89 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c7b:	c1 e8 0c             	shr    $0xc,%eax
  801c7e:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801c85:	ef 
  801c86:	0f b7 d2             	movzwl %dx,%edx
}
  801c89:	89 d0                	mov    %edx,%eax
  801c8b:	5d                   	pop    %ebp
  801c8c:	c3                   	ret    
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
