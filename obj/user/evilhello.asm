
obj/user/evilhello:     file format elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
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
  80003a:	83 ec 10             	sub    $0x10,%esp
	// try to print the kernel entry point as a string!  mua ha ha!
	sys_cputs((char*)0xf010000c, 100);
  80003d:	6a 64                	push   $0x64
  80003f:	68 0c 00 10 f0       	push   $0xf010000c
  800044:	e8 65 00 00 00       	call   8000ae <sys_cputs>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004e:	f3 0f 1e fb          	endbr32 
  800052:	55                   	push   %ebp
  800053:	89 e5                	mov    %esp,%ebp
  800055:	56                   	push   %esi
  800056:	53                   	push   %ebx
  800057:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80005d:	e8 d6 00 00 00       	call   800138 <sys_getenvid>
  800062:	25 ff 03 00 00       	and    $0x3ff,%eax
  800067:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006f:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800074:	85 db                	test   %ebx,%ebx
  800076:	7e 07                	jle    80007f <libmain+0x31>
		binaryname = argv[0];
  800078:	8b 06                	mov    (%esi),%eax
  80007a:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80007f:	83 ec 08             	sub    $0x8,%esp
  800082:	56                   	push   %esi
  800083:	53                   	push   %ebx
  800084:	e8 aa ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800089:	e8 0a 00 00 00       	call   800098 <exit>
}
  80008e:	83 c4 10             	add    $0x10,%esp
  800091:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800094:	5b                   	pop    %ebx
  800095:	5e                   	pop    %esi
  800096:	5d                   	pop    %ebp
  800097:	c3                   	ret    

00800098 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800098:	f3 0f 1e fb          	endbr32 
  80009c:	55                   	push   %ebp
  80009d:	89 e5                	mov    %esp,%ebp
  80009f:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8000a2:	6a 00                	push   $0x0
  8000a4:	e8 4a 00 00 00       	call   8000f3 <sys_env_destroy>
}
  8000a9:	83 c4 10             	add    $0x10,%esp
  8000ac:	c9                   	leave  
  8000ad:	c3                   	ret    

008000ae <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000ae:	f3 0f 1e fb          	endbr32 
  8000b2:	55                   	push   %ebp
  8000b3:	89 e5                	mov    %esp,%ebp
  8000b5:	57                   	push   %edi
  8000b6:	56                   	push   %esi
  8000b7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8000c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000c3:	89 c3                	mov    %eax,%ebx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 c6                	mov    %eax,%esi
  8000c9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000cb:	5b                   	pop    %ebx
  8000cc:	5e                   	pop    %esi
  8000cd:	5f                   	pop    %edi
  8000ce:	5d                   	pop    %ebp
  8000cf:	c3                   	ret    

008000d0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000d0:	f3 0f 1e fb          	endbr32 
  8000d4:	55                   	push   %ebp
  8000d5:	89 e5                	mov    %esp,%ebp
  8000d7:	57                   	push   %edi
  8000d8:	56                   	push   %esi
  8000d9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000da:	ba 00 00 00 00       	mov    $0x0,%edx
  8000df:	b8 01 00 00 00       	mov    $0x1,%eax
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	89 d3                	mov    %edx,%ebx
  8000e8:	89 d7                	mov    %edx,%edi
  8000ea:	89 d6                	mov    %edx,%esi
  8000ec:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000ee:	5b                   	pop    %ebx
  8000ef:	5e                   	pop    %esi
  8000f0:	5f                   	pop    %edi
  8000f1:	5d                   	pop    %ebp
  8000f2:	c3                   	ret    

008000f3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000f3:	f3 0f 1e fb          	endbr32 
  8000f7:	55                   	push   %ebp
  8000f8:	89 e5                	mov    %esp,%ebp
  8000fa:	57                   	push   %edi
  8000fb:	56                   	push   %esi
  8000fc:	53                   	push   %ebx
  8000fd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800100:	b9 00 00 00 00       	mov    $0x0,%ecx
  800105:	8b 55 08             	mov    0x8(%ebp),%edx
  800108:	b8 03 00 00 00       	mov    $0x3,%eax
  80010d:	89 cb                	mov    %ecx,%ebx
  80010f:	89 cf                	mov    %ecx,%edi
  800111:	89 ce                	mov    %ecx,%esi
  800113:	cd 30                	int    $0x30
	if(check && ret > 0)
  800115:	85 c0                	test   %eax,%eax
  800117:	7f 08                	jg     800121 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800119:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80011c:	5b                   	pop    %ebx
  80011d:	5e                   	pop    %esi
  80011e:	5f                   	pop    %edi
  80011f:	5d                   	pop    %ebp
  800120:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800121:	83 ec 0c             	sub    $0xc,%esp
  800124:	50                   	push   %eax
  800125:	6a 03                	push   $0x3
  800127:	68 2a 10 80 00       	push   $0x80102a
  80012c:	6a 23                	push   $0x23
  80012e:	68 47 10 80 00       	push   $0x801047
  800133:	e8 11 02 00 00       	call   800349 <_panic>

00800138 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800138:	f3 0f 1e fb          	endbr32 
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	57                   	push   %edi
  800140:	56                   	push   %esi
  800141:	53                   	push   %ebx
	asm volatile("int %1\n"
  800142:	ba 00 00 00 00       	mov    $0x0,%edx
  800147:	b8 02 00 00 00       	mov    $0x2,%eax
  80014c:	89 d1                	mov    %edx,%ecx
  80014e:	89 d3                	mov    %edx,%ebx
  800150:	89 d7                	mov    %edx,%edi
  800152:	89 d6                	mov    %edx,%esi
  800154:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800156:	5b                   	pop    %ebx
  800157:	5e                   	pop    %esi
  800158:	5f                   	pop    %edi
  800159:	5d                   	pop    %ebp
  80015a:	c3                   	ret    

0080015b <sys_yield>:

void
sys_yield(void)
{
  80015b:	f3 0f 1e fb          	endbr32 
  80015f:	55                   	push   %ebp
  800160:	89 e5                	mov    %esp,%ebp
  800162:	57                   	push   %edi
  800163:	56                   	push   %esi
  800164:	53                   	push   %ebx
	asm volatile("int %1\n"
  800165:	ba 00 00 00 00       	mov    $0x0,%edx
  80016a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80016f:	89 d1                	mov    %edx,%ecx
  800171:	89 d3                	mov    %edx,%ebx
  800173:	89 d7                	mov    %edx,%edi
  800175:	89 d6                	mov    %edx,%esi
  800177:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800179:	5b                   	pop    %ebx
  80017a:	5e                   	pop    %esi
  80017b:	5f                   	pop    %edi
  80017c:	5d                   	pop    %ebp
  80017d:	c3                   	ret    

0080017e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80017e:	f3 0f 1e fb          	endbr32 
  800182:	55                   	push   %ebp
  800183:	89 e5                	mov    %esp,%ebp
  800185:	57                   	push   %edi
  800186:	56                   	push   %esi
  800187:	53                   	push   %ebx
  800188:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80018b:	be 00 00 00 00       	mov    $0x0,%esi
  800190:	8b 55 08             	mov    0x8(%ebp),%edx
  800193:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800196:	b8 04 00 00 00       	mov    $0x4,%eax
  80019b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80019e:	89 f7                	mov    %esi,%edi
  8001a0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001a2:	85 c0                	test   %eax,%eax
  8001a4:	7f 08                	jg     8001ae <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a9:	5b                   	pop    %ebx
  8001aa:	5e                   	pop    %esi
  8001ab:	5f                   	pop    %edi
  8001ac:	5d                   	pop    %ebp
  8001ad:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	50                   	push   %eax
  8001b2:	6a 04                	push   $0x4
  8001b4:	68 2a 10 80 00       	push   $0x80102a
  8001b9:	6a 23                	push   $0x23
  8001bb:	68 47 10 80 00       	push   $0x801047
  8001c0:	e8 84 01 00 00       	call   800349 <_panic>

008001c5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001c5:	f3 0f 1e fb          	endbr32 
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	57                   	push   %edi
  8001cd:	56                   	push   %esi
  8001ce:	53                   	push   %ebx
  8001cf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001d8:	b8 05 00 00 00       	mov    $0x5,%eax
  8001dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001e0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001e3:	8b 75 18             	mov    0x18(%ebp),%esi
  8001e6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001e8:	85 c0                	test   %eax,%eax
  8001ea:	7f 08                	jg     8001f4 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ef:	5b                   	pop    %ebx
  8001f0:	5e                   	pop    %esi
  8001f1:	5f                   	pop    %edi
  8001f2:	5d                   	pop    %ebp
  8001f3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	50                   	push   %eax
  8001f8:	6a 05                	push   $0x5
  8001fa:	68 2a 10 80 00       	push   $0x80102a
  8001ff:	6a 23                	push   $0x23
  800201:	68 47 10 80 00       	push   $0x801047
  800206:	e8 3e 01 00 00       	call   800349 <_panic>

0080020b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80020b:	f3 0f 1e fb          	endbr32 
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	57                   	push   %edi
  800213:	56                   	push   %esi
  800214:	53                   	push   %ebx
  800215:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800218:	bb 00 00 00 00       	mov    $0x0,%ebx
  80021d:	8b 55 08             	mov    0x8(%ebp),%edx
  800220:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800223:	b8 06 00 00 00       	mov    $0x6,%eax
  800228:	89 df                	mov    %ebx,%edi
  80022a:	89 de                	mov    %ebx,%esi
  80022c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80022e:	85 c0                	test   %eax,%eax
  800230:	7f 08                	jg     80023a <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800232:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800235:	5b                   	pop    %ebx
  800236:	5e                   	pop    %esi
  800237:	5f                   	pop    %edi
  800238:	5d                   	pop    %ebp
  800239:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	50                   	push   %eax
  80023e:	6a 06                	push   $0x6
  800240:	68 2a 10 80 00       	push   $0x80102a
  800245:	6a 23                	push   $0x23
  800247:	68 47 10 80 00       	push   $0x801047
  80024c:	e8 f8 00 00 00       	call   800349 <_panic>

00800251 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800251:	f3 0f 1e fb          	endbr32 
  800255:	55                   	push   %ebp
  800256:	89 e5                	mov    %esp,%ebp
  800258:	57                   	push   %edi
  800259:	56                   	push   %esi
  80025a:	53                   	push   %ebx
  80025b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80025e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800263:	8b 55 08             	mov    0x8(%ebp),%edx
  800266:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800269:	b8 08 00 00 00       	mov    $0x8,%eax
  80026e:	89 df                	mov    %ebx,%edi
  800270:	89 de                	mov    %ebx,%esi
  800272:	cd 30                	int    $0x30
	if(check && ret > 0)
  800274:	85 c0                	test   %eax,%eax
  800276:	7f 08                	jg     800280 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800278:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027b:	5b                   	pop    %ebx
  80027c:	5e                   	pop    %esi
  80027d:	5f                   	pop    %edi
  80027e:	5d                   	pop    %ebp
  80027f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	6a 08                	push   $0x8
  800286:	68 2a 10 80 00       	push   $0x80102a
  80028b:	6a 23                	push   $0x23
  80028d:	68 47 10 80 00       	push   $0x801047
  800292:	e8 b2 00 00 00       	call   800349 <_panic>

00800297 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800297:	f3 0f 1e fb          	endbr32 
  80029b:	55                   	push   %ebp
  80029c:	89 e5                	mov    %esp,%ebp
  80029e:	57                   	push   %edi
  80029f:	56                   	push   %esi
  8002a0:	53                   	push   %ebx
  8002a1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002af:	b8 09 00 00 00       	mov    $0x9,%eax
  8002b4:	89 df                	mov    %ebx,%edi
  8002b6:	89 de                	mov    %ebx,%esi
  8002b8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002ba:	85 c0                	test   %eax,%eax
  8002bc:	7f 08                	jg     8002c6 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c1:	5b                   	pop    %ebx
  8002c2:	5e                   	pop    %esi
  8002c3:	5f                   	pop    %edi
  8002c4:	5d                   	pop    %ebp
  8002c5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002c6:	83 ec 0c             	sub    $0xc,%esp
  8002c9:	50                   	push   %eax
  8002ca:	6a 09                	push   $0x9
  8002cc:	68 2a 10 80 00       	push   $0x80102a
  8002d1:	6a 23                	push   $0x23
  8002d3:	68 47 10 80 00       	push   $0x801047
  8002d8:	e8 6c 00 00 00       	call   800349 <_panic>

008002dd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002dd:	f3 0f 1e fb          	endbr32 
  8002e1:	55                   	push   %ebp
  8002e2:	89 e5                	mov    %esp,%ebp
  8002e4:	57                   	push   %edi
  8002e5:	56                   	push   %esi
  8002e6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ed:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002f2:	be 00 00 00 00       	mov    $0x0,%esi
  8002f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002fa:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002fd:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002ff:	5b                   	pop    %ebx
  800300:	5e                   	pop    %esi
  800301:	5f                   	pop    %edi
  800302:	5d                   	pop    %ebp
  800303:	c3                   	ret    

00800304 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800304:	f3 0f 1e fb          	endbr32 
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	57                   	push   %edi
  80030c:	56                   	push   %esi
  80030d:	53                   	push   %ebx
  80030e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800311:	b9 00 00 00 00       	mov    $0x0,%ecx
  800316:	8b 55 08             	mov    0x8(%ebp),%edx
  800319:	b8 0c 00 00 00       	mov    $0xc,%eax
  80031e:	89 cb                	mov    %ecx,%ebx
  800320:	89 cf                	mov    %ecx,%edi
  800322:	89 ce                	mov    %ecx,%esi
  800324:	cd 30                	int    $0x30
	if(check && ret > 0)
  800326:	85 c0                	test   %eax,%eax
  800328:	7f 08                	jg     800332 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80032a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032d:	5b                   	pop    %ebx
  80032e:	5e                   	pop    %esi
  80032f:	5f                   	pop    %edi
  800330:	5d                   	pop    %ebp
  800331:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800332:	83 ec 0c             	sub    $0xc,%esp
  800335:	50                   	push   %eax
  800336:	6a 0c                	push   $0xc
  800338:	68 2a 10 80 00       	push   $0x80102a
  80033d:	6a 23                	push   $0x23
  80033f:	68 47 10 80 00       	push   $0x801047
  800344:	e8 00 00 00 00       	call   800349 <_panic>

00800349 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800349:	f3 0f 1e fb          	endbr32 
  80034d:	55                   	push   %ebp
  80034e:	89 e5                	mov    %esp,%ebp
  800350:	56                   	push   %esi
  800351:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800352:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800355:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80035b:	e8 d8 fd ff ff       	call   800138 <sys_getenvid>
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	ff 75 0c             	pushl  0xc(%ebp)
  800366:	ff 75 08             	pushl  0x8(%ebp)
  800369:	56                   	push   %esi
  80036a:	50                   	push   %eax
  80036b:	68 58 10 80 00       	push   $0x801058
  800370:	e8 bb 00 00 00       	call   800430 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800375:	83 c4 18             	add    $0x18,%esp
  800378:	53                   	push   %ebx
  800379:	ff 75 10             	pushl  0x10(%ebp)
  80037c:	e8 5a 00 00 00       	call   8003db <vcprintf>
	cprintf("\n");
  800381:	c7 04 24 7b 10 80 00 	movl   $0x80107b,(%esp)
  800388:	e8 a3 00 00 00       	call   800430 <cprintf>
  80038d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800390:	cc                   	int3   
  800391:	eb fd                	jmp    800390 <_panic+0x47>

00800393 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800393:	f3 0f 1e fb          	endbr32 
  800397:	55                   	push   %ebp
  800398:	89 e5                	mov    %esp,%ebp
  80039a:	53                   	push   %ebx
  80039b:	83 ec 04             	sub    $0x4,%esp
  80039e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003a1:	8b 13                	mov    (%ebx),%edx
  8003a3:	8d 42 01             	lea    0x1(%edx),%eax
  8003a6:	89 03                	mov    %eax,(%ebx)
  8003a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003ab:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003af:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b4:	74 09                	je     8003bf <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003b6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003bd:	c9                   	leave  
  8003be:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003bf:	83 ec 08             	sub    $0x8,%esp
  8003c2:	68 ff 00 00 00       	push   $0xff
  8003c7:	8d 43 08             	lea    0x8(%ebx),%eax
  8003ca:	50                   	push   %eax
  8003cb:	e8 de fc ff ff       	call   8000ae <sys_cputs>
		b->idx = 0;
  8003d0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	eb db                	jmp    8003b6 <putch+0x23>

008003db <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003db:	f3 0f 1e fb          	endbr32 
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003e8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ef:	00 00 00 
	b.cnt = 0;
  8003f2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003f9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003fc:	ff 75 0c             	pushl  0xc(%ebp)
  8003ff:	ff 75 08             	pushl  0x8(%ebp)
  800402:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800408:	50                   	push   %eax
  800409:	68 93 03 80 00       	push   $0x800393
  80040e:	e8 20 01 00 00       	call   800533 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800413:	83 c4 08             	add    $0x8,%esp
  800416:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80041c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800422:	50                   	push   %eax
  800423:	e8 86 fc ff ff       	call   8000ae <sys_cputs>

	return b.cnt;
}
  800428:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80042e:	c9                   	leave  
  80042f:	c3                   	ret    

00800430 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800430:	f3 0f 1e fb          	endbr32 
  800434:	55                   	push   %ebp
  800435:	89 e5                	mov    %esp,%ebp
  800437:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80043a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80043d:	50                   	push   %eax
  80043e:	ff 75 08             	pushl  0x8(%ebp)
  800441:	e8 95 ff ff ff       	call   8003db <vcprintf>
	va_end(ap);

	return cnt;
}
  800446:	c9                   	leave  
  800447:	c3                   	ret    

00800448 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800448:	55                   	push   %ebp
  800449:	89 e5                	mov    %esp,%ebp
  80044b:	57                   	push   %edi
  80044c:	56                   	push   %esi
  80044d:	53                   	push   %ebx
  80044e:	83 ec 1c             	sub    $0x1c,%esp
  800451:	89 c7                	mov    %eax,%edi
  800453:	89 d6                	mov    %edx,%esi
  800455:	8b 45 08             	mov    0x8(%ebp),%eax
  800458:	8b 55 0c             	mov    0xc(%ebp),%edx
  80045b:	89 d1                	mov    %edx,%ecx
  80045d:	89 c2                	mov    %eax,%edx
  80045f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800462:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800465:	8b 45 10             	mov    0x10(%ebp),%eax
  800468:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80046b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80046e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800475:	39 c2                	cmp    %eax,%edx
  800477:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80047a:	72 3e                	jb     8004ba <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80047c:	83 ec 0c             	sub    $0xc,%esp
  80047f:	ff 75 18             	pushl  0x18(%ebp)
  800482:	83 eb 01             	sub    $0x1,%ebx
  800485:	53                   	push   %ebx
  800486:	50                   	push   %eax
  800487:	83 ec 08             	sub    $0x8,%esp
  80048a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80048d:	ff 75 e0             	pushl  -0x20(%ebp)
  800490:	ff 75 dc             	pushl  -0x24(%ebp)
  800493:	ff 75 d8             	pushl  -0x28(%ebp)
  800496:	e8 15 09 00 00       	call   800db0 <__udivdi3>
  80049b:	83 c4 18             	add    $0x18,%esp
  80049e:	52                   	push   %edx
  80049f:	50                   	push   %eax
  8004a0:	89 f2                	mov    %esi,%edx
  8004a2:	89 f8                	mov    %edi,%eax
  8004a4:	e8 9f ff ff ff       	call   800448 <printnum>
  8004a9:	83 c4 20             	add    $0x20,%esp
  8004ac:	eb 13                	jmp    8004c1 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	56                   	push   %esi
  8004b2:	ff 75 18             	pushl  0x18(%ebp)
  8004b5:	ff d7                	call   *%edi
  8004b7:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004ba:	83 eb 01             	sub    $0x1,%ebx
  8004bd:	85 db                	test   %ebx,%ebx
  8004bf:	7f ed                	jg     8004ae <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	56                   	push   %esi
  8004c5:	83 ec 04             	sub    $0x4,%esp
  8004c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004cb:	ff 75 e0             	pushl  -0x20(%ebp)
  8004ce:	ff 75 dc             	pushl  -0x24(%ebp)
  8004d1:	ff 75 d8             	pushl  -0x28(%ebp)
  8004d4:	e8 e7 09 00 00       	call   800ec0 <__umoddi3>
  8004d9:	83 c4 14             	add    $0x14,%esp
  8004dc:	0f be 80 7d 10 80 00 	movsbl 0x80107d(%eax),%eax
  8004e3:	50                   	push   %eax
  8004e4:	ff d7                	call   *%edi
}
  8004e6:	83 c4 10             	add    $0x10,%esp
  8004e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004ec:	5b                   	pop    %ebx
  8004ed:	5e                   	pop    %esi
  8004ee:	5f                   	pop    %edi
  8004ef:	5d                   	pop    %ebp
  8004f0:	c3                   	ret    

008004f1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004f1:	f3 0f 1e fb          	endbr32 
  8004f5:	55                   	push   %ebp
  8004f6:	89 e5                	mov    %esp,%ebp
  8004f8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004fb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004ff:	8b 10                	mov    (%eax),%edx
  800501:	3b 50 04             	cmp    0x4(%eax),%edx
  800504:	73 0a                	jae    800510 <sprintputch+0x1f>
		*b->buf++ = ch;
  800506:	8d 4a 01             	lea    0x1(%edx),%ecx
  800509:	89 08                	mov    %ecx,(%eax)
  80050b:	8b 45 08             	mov    0x8(%ebp),%eax
  80050e:	88 02                	mov    %al,(%edx)
}
  800510:	5d                   	pop    %ebp
  800511:	c3                   	ret    

00800512 <printfmt>:
{
  800512:	f3 0f 1e fb          	endbr32 
  800516:	55                   	push   %ebp
  800517:	89 e5                	mov    %esp,%ebp
  800519:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80051c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80051f:	50                   	push   %eax
  800520:	ff 75 10             	pushl  0x10(%ebp)
  800523:	ff 75 0c             	pushl  0xc(%ebp)
  800526:	ff 75 08             	pushl  0x8(%ebp)
  800529:	e8 05 00 00 00       	call   800533 <vprintfmt>
}
  80052e:	83 c4 10             	add    $0x10,%esp
  800531:	c9                   	leave  
  800532:	c3                   	ret    

00800533 <vprintfmt>:
{
  800533:	f3 0f 1e fb          	endbr32 
  800537:	55                   	push   %ebp
  800538:	89 e5                	mov    %esp,%ebp
  80053a:	57                   	push   %edi
  80053b:	56                   	push   %esi
  80053c:	53                   	push   %ebx
  80053d:	83 ec 3c             	sub    $0x3c,%esp
  800540:	8b 75 08             	mov    0x8(%ebp),%esi
  800543:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800546:	8b 7d 10             	mov    0x10(%ebp),%edi
  800549:	e9 8e 03 00 00       	jmp    8008dc <vprintfmt+0x3a9>
		padc = ' ';
  80054e:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800552:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800559:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800560:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800567:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80056c:	8d 47 01             	lea    0x1(%edi),%eax
  80056f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800572:	0f b6 17             	movzbl (%edi),%edx
  800575:	8d 42 dd             	lea    -0x23(%edx),%eax
  800578:	3c 55                	cmp    $0x55,%al
  80057a:	0f 87 df 03 00 00    	ja     80095f <vprintfmt+0x42c>
  800580:	0f b6 c0             	movzbl %al,%eax
  800583:	3e ff 24 85 40 11 80 	notrack jmp *0x801140(,%eax,4)
  80058a:	00 
  80058b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80058e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800592:	eb d8                	jmp    80056c <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800594:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800597:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80059b:	eb cf                	jmp    80056c <vprintfmt+0x39>
  80059d:	0f b6 d2             	movzbl %dl,%edx
  8005a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8005ab:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005ae:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005b2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005b5:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005b8:	83 f9 09             	cmp    $0x9,%ecx
  8005bb:	77 55                	ja     800612 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8005bd:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005c0:	eb e9                	jmp    8005ab <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	8b 00                	mov    (%eax),%eax
  8005c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	8d 40 04             	lea    0x4(%eax),%eax
  8005d0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005d6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005da:	79 90                	jns    80056c <vprintfmt+0x39>
				width = precision, precision = -1;
  8005dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005df:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005e2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005e9:	eb 81                	jmp    80056c <vprintfmt+0x39>
  8005eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005ee:	85 c0                	test   %eax,%eax
  8005f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f5:	0f 49 d0             	cmovns %eax,%edx
  8005f8:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005fe:	e9 69 ff ff ff       	jmp    80056c <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800603:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800606:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80060d:	e9 5a ff ff ff       	jmp    80056c <vprintfmt+0x39>
  800612:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800615:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800618:	eb bc                	jmp    8005d6 <vprintfmt+0xa3>
			lflag++;
  80061a:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80061d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800620:	e9 47 ff ff ff       	jmp    80056c <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	8d 78 04             	lea    0x4(%eax),%edi
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	53                   	push   %ebx
  80062f:	ff 30                	pushl  (%eax)
  800631:	ff d6                	call   *%esi
			break;
  800633:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800636:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800639:	e9 9b 02 00 00       	jmp    8008d9 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8d 78 04             	lea    0x4(%eax),%edi
  800644:	8b 00                	mov    (%eax),%eax
  800646:	99                   	cltd   
  800647:	31 d0                	xor    %edx,%eax
  800649:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80064b:	83 f8 08             	cmp    $0x8,%eax
  80064e:	7f 23                	jg     800673 <vprintfmt+0x140>
  800650:	8b 14 85 a0 12 80 00 	mov    0x8012a0(,%eax,4),%edx
  800657:	85 d2                	test   %edx,%edx
  800659:	74 18                	je     800673 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80065b:	52                   	push   %edx
  80065c:	68 9e 10 80 00       	push   $0x80109e
  800661:	53                   	push   %ebx
  800662:	56                   	push   %esi
  800663:	e8 aa fe ff ff       	call   800512 <printfmt>
  800668:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80066b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80066e:	e9 66 02 00 00       	jmp    8008d9 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800673:	50                   	push   %eax
  800674:	68 95 10 80 00       	push   $0x801095
  800679:	53                   	push   %ebx
  80067a:	56                   	push   %esi
  80067b:	e8 92 fe ff ff       	call   800512 <printfmt>
  800680:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800683:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800686:	e9 4e 02 00 00       	jmp    8008d9 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80068b:	8b 45 14             	mov    0x14(%ebp),%eax
  80068e:	83 c0 04             	add    $0x4,%eax
  800691:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800699:	85 d2                	test   %edx,%edx
  80069b:	b8 8e 10 80 00       	mov    $0x80108e,%eax
  8006a0:	0f 45 c2             	cmovne %edx,%eax
  8006a3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8006a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006aa:	7e 06                	jle    8006b2 <vprintfmt+0x17f>
  8006ac:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006b0:	75 0d                	jne    8006bf <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006b5:	89 c7                	mov    %eax,%edi
  8006b7:	03 45 e0             	add    -0x20(%ebp),%eax
  8006ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006bd:	eb 55                	jmp    800714 <vprintfmt+0x1e1>
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	ff 75 d8             	pushl  -0x28(%ebp)
  8006c5:	ff 75 cc             	pushl  -0x34(%ebp)
  8006c8:	e8 46 03 00 00       	call   800a13 <strnlen>
  8006cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006d0:	29 c2                	sub    %eax,%edx
  8006d2:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006d5:	83 c4 10             	add    $0x10,%esp
  8006d8:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006da:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006de:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e1:	85 ff                	test   %edi,%edi
  8006e3:	7e 11                	jle    8006f6 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8006e5:	83 ec 08             	sub    $0x8,%esp
  8006e8:	53                   	push   %ebx
  8006e9:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ec:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ee:	83 ef 01             	sub    $0x1,%edi
  8006f1:	83 c4 10             	add    $0x10,%esp
  8006f4:	eb eb                	jmp    8006e1 <vprintfmt+0x1ae>
  8006f6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006f9:	85 d2                	test   %edx,%edx
  8006fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800700:	0f 49 c2             	cmovns %edx,%eax
  800703:	29 c2                	sub    %eax,%edx
  800705:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800708:	eb a8                	jmp    8006b2 <vprintfmt+0x17f>
					putch(ch, putdat);
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	53                   	push   %ebx
  80070e:	52                   	push   %edx
  80070f:	ff d6                	call   *%esi
  800711:	83 c4 10             	add    $0x10,%esp
  800714:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800717:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800719:	83 c7 01             	add    $0x1,%edi
  80071c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800720:	0f be d0             	movsbl %al,%edx
  800723:	85 d2                	test   %edx,%edx
  800725:	74 4b                	je     800772 <vprintfmt+0x23f>
  800727:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80072b:	78 06                	js     800733 <vprintfmt+0x200>
  80072d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800731:	78 1e                	js     800751 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800733:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800737:	74 d1                	je     80070a <vprintfmt+0x1d7>
  800739:	0f be c0             	movsbl %al,%eax
  80073c:	83 e8 20             	sub    $0x20,%eax
  80073f:	83 f8 5e             	cmp    $0x5e,%eax
  800742:	76 c6                	jbe    80070a <vprintfmt+0x1d7>
					putch('?', putdat);
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	53                   	push   %ebx
  800748:	6a 3f                	push   $0x3f
  80074a:	ff d6                	call   *%esi
  80074c:	83 c4 10             	add    $0x10,%esp
  80074f:	eb c3                	jmp    800714 <vprintfmt+0x1e1>
  800751:	89 cf                	mov    %ecx,%edi
  800753:	eb 0e                	jmp    800763 <vprintfmt+0x230>
				putch(' ', putdat);
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	53                   	push   %ebx
  800759:	6a 20                	push   $0x20
  80075b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80075d:	83 ef 01             	sub    $0x1,%edi
  800760:	83 c4 10             	add    $0x10,%esp
  800763:	85 ff                	test   %edi,%edi
  800765:	7f ee                	jg     800755 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800767:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80076a:	89 45 14             	mov    %eax,0x14(%ebp)
  80076d:	e9 67 01 00 00       	jmp    8008d9 <vprintfmt+0x3a6>
  800772:	89 cf                	mov    %ecx,%edi
  800774:	eb ed                	jmp    800763 <vprintfmt+0x230>
	if (lflag >= 2)
  800776:	83 f9 01             	cmp    $0x1,%ecx
  800779:	7f 1b                	jg     800796 <vprintfmt+0x263>
	else if (lflag)
  80077b:	85 c9                	test   %ecx,%ecx
  80077d:	74 63                	je     8007e2 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80077f:	8b 45 14             	mov    0x14(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800787:	99                   	cltd   
  800788:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8d 40 04             	lea    0x4(%eax),%eax
  800791:	89 45 14             	mov    %eax,0x14(%ebp)
  800794:	eb 17                	jmp    8007ad <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8b 50 04             	mov    0x4(%eax),%edx
  80079c:	8b 00                	mov    (%eax),%eax
  80079e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8d 40 08             	lea    0x8(%eax),%eax
  8007aa:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8007ad:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007b0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007b3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007b8:	85 c9                	test   %ecx,%ecx
  8007ba:	0f 89 ff 00 00 00    	jns    8008bf <vprintfmt+0x38c>
				putch('-', putdat);
  8007c0:	83 ec 08             	sub    $0x8,%esp
  8007c3:	53                   	push   %ebx
  8007c4:	6a 2d                	push   $0x2d
  8007c6:	ff d6                	call   *%esi
				num = -(long long) num;
  8007c8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007cb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007ce:	f7 da                	neg    %edx
  8007d0:	83 d1 00             	adc    $0x0,%ecx
  8007d3:	f7 d9                	neg    %ecx
  8007d5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007dd:	e9 dd 00 00 00       	jmp    8008bf <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ea:	99                   	cltd   
  8007eb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	8d 40 04             	lea    0x4(%eax),%eax
  8007f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f7:	eb b4                	jmp    8007ad <vprintfmt+0x27a>
	if (lflag >= 2)
  8007f9:	83 f9 01             	cmp    $0x1,%ecx
  8007fc:	7f 1e                	jg     80081c <vprintfmt+0x2e9>
	else if (lflag)
  8007fe:	85 c9                	test   %ecx,%ecx
  800800:	74 32                	je     800834 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	8b 10                	mov    (%eax),%edx
  800807:	b9 00 00 00 00       	mov    $0x0,%ecx
  80080c:	8d 40 04             	lea    0x4(%eax),%eax
  80080f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800812:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800817:	e9 a3 00 00 00       	jmp    8008bf <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	8b 10                	mov    (%eax),%edx
  800821:	8b 48 04             	mov    0x4(%eax),%ecx
  800824:	8d 40 08             	lea    0x8(%eax),%eax
  800827:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80082a:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80082f:	e9 8b 00 00 00       	jmp    8008bf <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	8b 10                	mov    (%eax),%edx
  800839:	b9 00 00 00 00       	mov    $0x0,%ecx
  80083e:	8d 40 04             	lea    0x4(%eax),%eax
  800841:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800844:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800849:	eb 74                	jmp    8008bf <vprintfmt+0x38c>
	if (lflag >= 2)
  80084b:	83 f9 01             	cmp    $0x1,%ecx
  80084e:	7f 1b                	jg     80086b <vprintfmt+0x338>
	else if (lflag)
  800850:	85 c9                	test   %ecx,%ecx
  800852:	74 2c                	je     800880 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	8b 10                	mov    (%eax),%edx
  800859:	b9 00 00 00 00       	mov    $0x0,%ecx
  80085e:	8d 40 04             	lea    0x4(%eax),%eax
  800861:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800864:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800869:	eb 54                	jmp    8008bf <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	8b 10                	mov    (%eax),%edx
  800870:	8b 48 04             	mov    0x4(%eax),%ecx
  800873:	8d 40 08             	lea    0x8(%eax),%eax
  800876:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800879:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80087e:	eb 3f                	jmp    8008bf <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	8b 10                	mov    (%eax),%edx
  800885:	b9 00 00 00 00       	mov    $0x0,%ecx
  80088a:	8d 40 04             	lea    0x4(%eax),%eax
  80088d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800890:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800895:	eb 28                	jmp    8008bf <vprintfmt+0x38c>
			putch('0', putdat);
  800897:	83 ec 08             	sub    $0x8,%esp
  80089a:	53                   	push   %ebx
  80089b:	6a 30                	push   $0x30
  80089d:	ff d6                	call   *%esi
			putch('x', putdat);
  80089f:	83 c4 08             	add    $0x8,%esp
  8008a2:	53                   	push   %ebx
  8008a3:	6a 78                	push   $0x78
  8008a5:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008aa:	8b 10                	mov    (%eax),%edx
  8008ac:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008b1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008b4:	8d 40 04             	lea    0x4(%eax),%eax
  8008b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ba:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008bf:	83 ec 0c             	sub    $0xc,%esp
  8008c2:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8008c6:	57                   	push   %edi
  8008c7:	ff 75 e0             	pushl  -0x20(%ebp)
  8008ca:	50                   	push   %eax
  8008cb:	51                   	push   %ecx
  8008cc:	52                   	push   %edx
  8008cd:	89 da                	mov    %ebx,%edx
  8008cf:	89 f0                	mov    %esi,%eax
  8008d1:	e8 72 fb ff ff       	call   800448 <printnum>
			break;
  8008d6:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008dc:	83 c7 01             	add    $0x1,%edi
  8008df:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008e3:	83 f8 25             	cmp    $0x25,%eax
  8008e6:	0f 84 62 fc ff ff    	je     80054e <vprintfmt+0x1b>
			if (ch == '\0')
  8008ec:	85 c0                	test   %eax,%eax
  8008ee:	0f 84 8b 00 00 00    	je     80097f <vprintfmt+0x44c>
			putch(ch, putdat);
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	53                   	push   %ebx
  8008f8:	50                   	push   %eax
  8008f9:	ff d6                	call   *%esi
  8008fb:	83 c4 10             	add    $0x10,%esp
  8008fe:	eb dc                	jmp    8008dc <vprintfmt+0x3a9>
	if (lflag >= 2)
  800900:	83 f9 01             	cmp    $0x1,%ecx
  800903:	7f 1b                	jg     800920 <vprintfmt+0x3ed>
	else if (lflag)
  800905:	85 c9                	test   %ecx,%ecx
  800907:	74 2c                	je     800935 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800909:	8b 45 14             	mov    0x14(%ebp),%eax
  80090c:	8b 10                	mov    (%eax),%edx
  80090e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800913:	8d 40 04             	lea    0x4(%eax),%eax
  800916:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800919:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80091e:	eb 9f                	jmp    8008bf <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800920:	8b 45 14             	mov    0x14(%ebp),%eax
  800923:	8b 10                	mov    (%eax),%edx
  800925:	8b 48 04             	mov    0x4(%eax),%ecx
  800928:	8d 40 08             	lea    0x8(%eax),%eax
  80092b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80092e:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800933:	eb 8a                	jmp    8008bf <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	8b 10                	mov    (%eax),%edx
  80093a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80093f:	8d 40 04             	lea    0x4(%eax),%eax
  800942:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800945:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80094a:	e9 70 ff ff ff       	jmp    8008bf <vprintfmt+0x38c>
			putch(ch, putdat);
  80094f:	83 ec 08             	sub    $0x8,%esp
  800952:	53                   	push   %ebx
  800953:	6a 25                	push   $0x25
  800955:	ff d6                	call   *%esi
			break;
  800957:	83 c4 10             	add    $0x10,%esp
  80095a:	e9 7a ff ff ff       	jmp    8008d9 <vprintfmt+0x3a6>
			putch('%', putdat);
  80095f:	83 ec 08             	sub    $0x8,%esp
  800962:	53                   	push   %ebx
  800963:	6a 25                	push   $0x25
  800965:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800967:	83 c4 10             	add    $0x10,%esp
  80096a:	89 f8                	mov    %edi,%eax
  80096c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800970:	74 05                	je     800977 <vprintfmt+0x444>
  800972:	83 e8 01             	sub    $0x1,%eax
  800975:	eb f5                	jmp    80096c <vprintfmt+0x439>
  800977:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80097a:	e9 5a ff ff ff       	jmp    8008d9 <vprintfmt+0x3a6>
}
  80097f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800982:	5b                   	pop    %ebx
  800983:	5e                   	pop    %esi
  800984:	5f                   	pop    %edi
  800985:	5d                   	pop    %ebp
  800986:	c3                   	ret    

00800987 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800987:	f3 0f 1e fb          	endbr32 
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
  80098e:	83 ec 18             	sub    $0x18,%esp
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800997:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80099a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80099e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009a8:	85 c0                	test   %eax,%eax
  8009aa:	74 26                	je     8009d2 <vsnprintf+0x4b>
  8009ac:	85 d2                	test   %edx,%edx
  8009ae:	7e 22                	jle    8009d2 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009b0:	ff 75 14             	pushl  0x14(%ebp)
  8009b3:	ff 75 10             	pushl  0x10(%ebp)
  8009b6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b9:	50                   	push   %eax
  8009ba:	68 f1 04 80 00       	push   $0x8004f1
  8009bf:	e8 6f fb ff ff       	call   800533 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009cd:	83 c4 10             	add    $0x10,%esp
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    
		return -E_INVAL;
  8009d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009d7:	eb f7                	jmp    8009d0 <vsnprintf+0x49>

008009d9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d9:	f3 0f 1e fb          	endbr32 
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009e3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009e6:	50                   	push   %eax
  8009e7:	ff 75 10             	pushl  0x10(%ebp)
  8009ea:	ff 75 0c             	pushl  0xc(%ebp)
  8009ed:	ff 75 08             	pushl  0x8(%ebp)
  8009f0:	e8 92 ff ff ff       	call   800987 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009f5:	c9                   	leave  
  8009f6:	c3                   	ret    

008009f7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009f7:	f3 0f 1e fb          	endbr32 
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a01:	b8 00 00 00 00       	mov    $0x0,%eax
  800a06:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a0a:	74 05                	je     800a11 <strlen+0x1a>
		n++;
  800a0c:	83 c0 01             	add    $0x1,%eax
  800a0f:	eb f5                	jmp    800a06 <strlen+0xf>
	return n;
}
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    

00800a13 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a13:	f3 0f 1e fb          	endbr32 
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a1d:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a20:	b8 00 00 00 00       	mov    $0x0,%eax
  800a25:	39 d0                	cmp    %edx,%eax
  800a27:	74 0d                	je     800a36 <strnlen+0x23>
  800a29:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a2d:	74 05                	je     800a34 <strnlen+0x21>
		n++;
  800a2f:	83 c0 01             	add    $0x1,%eax
  800a32:	eb f1                	jmp    800a25 <strnlen+0x12>
  800a34:	89 c2                	mov    %eax,%edx
	return n;
}
  800a36:	89 d0                	mov    %edx,%eax
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    

00800a3a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a3a:	f3 0f 1e fb          	endbr32 
  800a3e:	55                   	push   %ebp
  800a3f:	89 e5                	mov    %esp,%ebp
  800a41:	53                   	push   %ebx
  800a42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a45:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a48:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4d:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800a51:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800a54:	83 c0 01             	add    $0x1,%eax
  800a57:	84 d2                	test   %dl,%dl
  800a59:	75 f2                	jne    800a4d <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800a5b:	89 c8                	mov    %ecx,%eax
  800a5d:	5b                   	pop    %ebx
  800a5e:	5d                   	pop    %ebp
  800a5f:	c3                   	ret    

00800a60 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a60:	f3 0f 1e fb          	endbr32 
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	53                   	push   %ebx
  800a68:	83 ec 10             	sub    $0x10,%esp
  800a6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a6e:	53                   	push   %ebx
  800a6f:	e8 83 ff ff ff       	call   8009f7 <strlen>
  800a74:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	01 d8                	add    %ebx,%eax
  800a7c:	50                   	push   %eax
  800a7d:	e8 b8 ff ff ff       	call   800a3a <strcpy>
	return dst;
}
  800a82:	89 d8                	mov    %ebx,%eax
  800a84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a87:	c9                   	leave  
  800a88:	c3                   	ret    

00800a89 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a89:	f3 0f 1e fb          	endbr32 
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	56                   	push   %esi
  800a91:	53                   	push   %ebx
  800a92:	8b 75 08             	mov    0x8(%ebp),%esi
  800a95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a98:	89 f3                	mov    %esi,%ebx
  800a9a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a9d:	89 f0                	mov    %esi,%eax
  800a9f:	39 d8                	cmp    %ebx,%eax
  800aa1:	74 11                	je     800ab4 <strncpy+0x2b>
		*dst++ = *src;
  800aa3:	83 c0 01             	add    $0x1,%eax
  800aa6:	0f b6 0a             	movzbl (%edx),%ecx
  800aa9:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aac:	80 f9 01             	cmp    $0x1,%cl
  800aaf:	83 da ff             	sbb    $0xffffffff,%edx
  800ab2:	eb eb                	jmp    800a9f <strncpy+0x16>
	}
	return ret;
}
  800ab4:	89 f0                	mov    %esi,%eax
  800ab6:	5b                   	pop    %ebx
  800ab7:	5e                   	pop    %esi
  800ab8:	5d                   	pop    %ebp
  800ab9:	c3                   	ret    

00800aba <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aba:	f3 0f 1e fb          	endbr32 
  800abe:	55                   	push   %ebp
  800abf:	89 e5                	mov    %esp,%ebp
  800ac1:	56                   	push   %esi
  800ac2:	53                   	push   %ebx
  800ac3:	8b 75 08             	mov    0x8(%ebp),%esi
  800ac6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac9:	8b 55 10             	mov    0x10(%ebp),%edx
  800acc:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ace:	85 d2                	test   %edx,%edx
  800ad0:	74 21                	je     800af3 <strlcpy+0x39>
  800ad2:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ad6:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ad8:	39 c2                	cmp    %eax,%edx
  800ada:	74 14                	je     800af0 <strlcpy+0x36>
  800adc:	0f b6 19             	movzbl (%ecx),%ebx
  800adf:	84 db                	test   %bl,%bl
  800ae1:	74 0b                	je     800aee <strlcpy+0x34>
			*dst++ = *src++;
  800ae3:	83 c1 01             	add    $0x1,%ecx
  800ae6:	83 c2 01             	add    $0x1,%edx
  800ae9:	88 5a ff             	mov    %bl,-0x1(%edx)
  800aec:	eb ea                	jmp    800ad8 <strlcpy+0x1e>
  800aee:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800af0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800af3:	29 f0                	sub    %esi,%eax
}
  800af5:	5b                   	pop    %ebx
  800af6:	5e                   	pop    %esi
  800af7:	5d                   	pop    %ebp
  800af8:	c3                   	ret    

00800af9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800af9:	f3 0f 1e fb          	endbr32 
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
  800b00:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b03:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b06:	0f b6 01             	movzbl (%ecx),%eax
  800b09:	84 c0                	test   %al,%al
  800b0b:	74 0c                	je     800b19 <strcmp+0x20>
  800b0d:	3a 02                	cmp    (%edx),%al
  800b0f:	75 08                	jne    800b19 <strcmp+0x20>
		p++, q++;
  800b11:	83 c1 01             	add    $0x1,%ecx
  800b14:	83 c2 01             	add    $0x1,%edx
  800b17:	eb ed                	jmp    800b06 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b19:	0f b6 c0             	movzbl %al,%eax
  800b1c:	0f b6 12             	movzbl (%edx),%edx
  800b1f:	29 d0                	sub    %edx,%eax
}
  800b21:	5d                   	pop    %ebp
  800b22:	c3                   	ret    

00800b23 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b23:	f3 0f 1e fb          	endbr32 
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	53                   	push   %ebx
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b31:	89 c3                	mov    %eax,%ebx
  800b33:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b36:	eb 06                	jmp    800b3e <strncmp+0x1b>
		n--, p++, q++;
  800b38:	83 c0 01             	add    $0x1,%eax
  800b3b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b3e:	39 d8                	cmp    %ebx,%eax
  800b40:	74 16                	je     800b58 <strncmp+0x35>
  800b42:	0f b6 08             	movzbl (%eax),%ecx
  800b45:	84 c9                	test   %cl,%cl
  800b47:	74 04                	je     800b4d <strncmp+0x2a>
  800b49:	3a 0a                	cmp    (%edx),%cl
  800b4b:	74 eb                	je     800b38 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b4d:	0f b6 00             	movzbl (%eax),%eax
  800b50:	0f b6 12             	movzbl (%edx),%edx
  800b53:	29 d0                	sub    %edx,%eax
}
  800b55:	5b                   	pop    %ebx
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    
		return 0;
  800b58:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5d:	eb f6                	jmp    800b55 <strncmp+0x32>

00800b5f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b5f:	f3 0f 1e fb          	endbr32 
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b6d:	0f b6 10             	movzbl (%eax),%edx
  800b70:	84 d2                	test   %dl,%dl
  800b72:	74 09                	je     800b7d <strchr+0x1e>
		if (*s == c)
  800b74:	38 ca                	cmp    %cl,%dl
  800b76:	74 0a                	je     800b82 <strchr+0x23>
	for (; *s; s++)
  800b78:	83 c0 01             	add    $0x1,%eax
  800b7b:	eb f0                	jmp    800b6d <strchr+0xe>
			return (char *) s;
	return 0;
  800b7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b84:	f3 0f 1e fb          	endbr32 
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b92:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b95:	38 ca                	cmp    %cl,%dl
  800b97:	74 09                	je     800ba2 <strfind+0x1e>
  800b99:	84 d2                	test   %dl,%dl
  800b9b:	74 05                	je     800ba2 <strfind+0x1e>
	for (; *s; s++)
  800b9d:	83 c0 01             	add    $0x1,%eax
  800ba0:	eb f0                	jmp    800b92 <strfind+0xe>
			break;
	return (char *) s;
}
  800ba2:	5d                   	pop    %ebp
  800ba3:	c3                   	ret    

00800ba4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ba4:	f3 0f 1e fb          	endbr32 
  800ba8:	55                   	push   %ebp
  800ba9:	89 e5                	mov    %esp,%ebp
  800bab:	57                   	push   %edi
  800bac:	56                   	push   %esi
  800bad:	53                   	push   %ebx
  800bae:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bb1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bb4:	85 c9                	test   %ecx,%ecx
  800bb6:	74 31                	je     800be9 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bb8:	89 f8                	mov    %edi,%eax
  800bba:	09 c8                	or     %ecx,%eax
  800bbc:	a8 03                	test   $0x3,%al
  800bbe:	75 23                	jne    800be3 <memset+0x3f>
		c &= 0xFF;
  800bc0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bc4:	89 d3                	mov    %edx,%ebx
  800bc6:	c1 e3 08             	shl    $0x8,%ebx
  800bc9:	89 d0                	mov    %edx,%eax
  800bcb:	c1 e0 18             	shl    $0x18,%eax
  800bce:	89 d6                	mov    %edx,%esi
  800bd0:	c1 e6 10             	shl    $0x10,%esi
  800bd3:	09 f0                	or     %esi,%eax
  800bd5:	09 c2                	or     %eax,%edx
  800bd7:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bd9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bdc:	89 d0                	mov    %edx,%eax
  800bde:	fc                   	cld    
  800bdf:	f3 ab                	rep stos %eax,%es:(%edi)
  800be1:	eb 06                	jmp    800be9 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800be3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be6:	fc                   	cld    
  800be7:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800be9:	89 f8                	mov    %edi,%eax
  800beb:	5b                   	pop    %ebx
  800bec:	5e                   	pop    %esi
  800bed:	5f                   	pop    %edi
  800bee:	5d                   	pop    %ebp
  800bef:	c3                   	ret    

00800bf0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bf0:	f3 0f 1e fb          	endbr32 
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	57                   	push   %edi
  800bf8:	56                   	push   %esi
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bff:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c02:	39 c6                	cmp    %eax,%esi
  800c04:	73 32                	jae    800c38 <memmove+0x48>
  800c06:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c09:	39 c2                	cmp    %eax,%edx
  800c0b:	76 2b                	jbe    800c38 <memmove+0x48>
		s += n;
		d += n;
  800c0d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c10:	89 fe                	mov    %edi,%esi
  800c12:	09 ce                	or     %ecx,%esi
  800c14:	09 d6                	or     %edx,%esi
  800c16:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c1c:	75 0e                	jne    800c2c <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c1e:	83 ef 04             	sub    $0x4,%edi
  800c21:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c24:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c27:	fd                   	std    
  800c28:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c2a:	eb 09                	jmp    800c35 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c2c:	83 ef 01             	sub    $0x1,%edi
  800c2f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c32:	fd                   	std    
  800c33:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c35:	fc                   	cld    
  800c36:	eb 1a                	jmp    800c52 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c38:	89 c2                	mov    %eax,%edx
  800c3a:	09 ca                	or     %ecx,%edx
  800c3c:	09 f2                	or     %esi,%edx
  800c3e:	f6 c2 03             	test   $0x3,%dl
  800c41:	75 0a                	jne    800c4d <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c43:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c46:	89 c7                	mov    %eax,%edi
  800c48:	fc                   	cld    
  800c49:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c4b:	eb 05                	jmp    800c52 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800c4d:	89 c7                	mov    %eax,%edi
  800c4f:	fc                   	cld    
  800c50:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c52:	5e                   	pop    %esi
  800c53:	5f                   	pop    %edi
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    

00800c56 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c56:	f3 0f 1e fb          	endbr32 
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c60:	ff 75 10             	pushl  0x10(%ebp)
  800c63:	ff 75 0c             	pushl  0xc(%ebp)
  800c66:	ff 75 08             	pushl  0x8(%ebp)
  800c69:	e8 82 ff ff ff       	call   800bf0 <memmove>
}
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c70:	f3 0f 1e fb          	endbr32 
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	56                   	push   %esi
  800c78:	53                   	push   %ebx
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c7f:	89 c6                	mov    %eax,%esi
  800c81:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c84:	39 f0                	cmp    %esi,%eax
  800c86:	74 1c                	je     800ca4 <memcmp+0x34>
		if (*s1 != *s2)
  800c88:	0f b6 08             	movzbl (%eax),%ecx
  800c8b:	0f b6 1a             	movzbl (%edx),%ebx
  800c8e:	38 d9                	cmp    %bl,%cl
  800c90:	75 08                	jne    800c9a <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c92:	83 c0 01             	add    $0x1,%eax
  800c95:	83 c2 01             	add    $0x1,%edx
  800c98:	eb ea                	jmp    800c84 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800c9a:	0f b6 c1             	movzbl %cl,%eax
  800c9d:	0f b6 db             	movzbl %bl,%ebx
  800ca0:	29 d8                	sub    %ebx,%eax
  800ca2:	eb 05                	jmp    800ca9 <memcmp+0x39>
	}

	return 0;
  800ca4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca9:	5b                   	pop    %ebx
  800caa:	5e                   	pop    %esi
  800cab:	5d                   	pop    %ebp
  800cac:	c3                   	ret    

00800cad <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cad:	f3 0f 1e fb          	endbr32 
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cba:	89 c2                	mov    %eax,%edx
  800cbc:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cbf:	39 d0                	cmp    %edx,%eax
  800cc1:	73 09                	jae    800ccc <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cc3:	38 08                	cmp    %cl,(%eax)
  800cc5:	74 05                	je     800ccc <memfind+0x1f>
	for (; s < ends; s++)
  800cc7:	83 c0 01             	add    $0x1,%eax
  800cca:	eb f3                	jmp    800cbf <memfind+0x12>
			break;
	return (void *) s;
}
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    

00800cce <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cce:	f3 0f 1e fb          	endbr32 
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	57                   	push   %edi
  800cd6:	56                   	push   %esi
  800cd7:	53                   	push   %ebx
  800cd8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cdb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cde:	eb 03                	jmp    800ce3 <strtol+0x15>
		s++;
  800ce0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ce3:	0f b6 01             	movzbl (%ecx),%eax
  800ce6:	3c 20                	cmp    $0x20,%al
  800ce8:	74 f6                	je     800ce0 <strtol+0x12>
  800cea:	3c 09                	cmp    $0x9,%al
  800cec:	74 f2                	je     800ce0 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800cee:	3c 2b                	cmp    $0x2b,%al
  800cf0:	74 2a                	je     800d1c <strtol+0x4e>
	int neg = 0;
  800cf2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cf7:	3c 2d                	cmp    $0x2d,%al
  800cf9:	74 2b                	je     800d26 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cfb:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d01:	75 0f                	jne    800d12 <strtol+0x44>
  800d03:	80 39 30             	cmpb   $0x30,(%ecx)
  800d06:	74 28                	je     800d30 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d08:	85 db                	test   %ebx,%ebx
  800d0a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d0f:	0f 44 d8             	cmove  %eax,%ebx
  800d12:	b8 00 00 00 00       	mov    $0x0,%eax
  800d17:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d1a:	eb 46                	jmp    800d62 <strtol+0x94>
		s++;
  800d1c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d1f:	bf 00 00 00 00       	mov    $0x0,%edi
  800d24:	eb d5                	jmp    800cfb <strtol+0x2d>
		s++, neg = 1;
  800d26:	83 c1 01             	add    $0x1,%ecx
  800d29:	bf 01 00 00 00       	mov    $0x1,%edi
  800d2e:	eb cb                	jmp    800cfb <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d30:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d34:	74 0e                	je     800d44 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d36:	85 db                	test   %ebx,%ebx
  800d38:	75 d8                	jne    800d12 <strtol+0x44>
		s++, base = 8;
  800d3a:	83 c1 01             	add    $0x1,%ecx
  800d3d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d42:	eb ce                	jmp    800d12 <strtol+0x44>
		s += 2, base = 16;
  800d44:	83 c1 02             	add    $0x2,%ecx
  800d47:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d4c:	eb c4                	jmp    800d12 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800d4e:	0f be d2             	movsbl %dl,%edx
  800d51:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d54:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d57:	7d 3a                	jge    800d93 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d59:	83 c1 01             	add    $0x1,%ecx
  800d5c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d60:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d62:	0f b6 11             	movzbl (%ecx),%edx
  800d65:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d68:	89 f3                	mov    %esi,%ebx
  800d6a:	80 fb 09             	cmp    $0x9,%bl
  800d6d:	76 df                	jbe    800d4e <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800d6f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d72:	89 f3                	mov    %esi,%ebx
  800d74:	80 fb 19             	cmp    $0x19,%bl
  800d77:	77 08                	ja     800d81 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d79:	0f be d2             	movsbl %dl,%edx
  800d7c:	83 ea 57             	sub    $0x57,%edx
  800d7f:	eb d3                	jmp    800d54 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800d81:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d84:	89 f3                	mov    %esi,%ebx
  800d86:	80 fb 19             	cmp    $0x19,%bl
  800d89:	77 08                	ja     800d93 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d8b:	0f be d2             	movsbl %dl,%edx
  800d8e:	83 ea 37             	sub    $0x37,%edx
  800d91:	eb c1                	jmp    800d54 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d97:	74 05                	je     800d9e <strtol+0xd0>
		*endptr = (char *) s;
  800d99:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d9c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d9e:	89 c2                	mov    %eax,%edx
  800da0:	f7 da                	neg    %edx
  800da2:	85 ff                	test   %edi,%edi
  800da4:	0f 45 c2             	cmovne %edx,%eax
}
  800da7:	5b                   	pop    %ebx
  800da8:	5e                   	pop    %esi
  800da9:	5f                   	pop    %edi
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    
  800dac:	66 90                	xchg   %ax,%ax
  800dae:	66 90                	xchg   %ax,%ax

00800db0 <__udivdi3>:
  800db0:	f3 0f 1e fb          	endbr32 
  800db4:	55                   	push   %ebp
  800db5:	57                   	push   %edi
  800db6:	56                   	push   %esi
  800db7:	53                   	push   %ebx
  800db8:	83 ec 1c             	sub    $0x1c,%esp
  800dbb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800dbf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800dc3:	8b 74 24 34          	mov    0x34(%esp),%esi
  800dc7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800dcb:	85 d2                	test   %edx,%edx
  800dcd:	75 19                	jne    800de8 <__udivdi3+0x38>
  800dcf:	39 f3                	cmp    %esi,%ebx
  800dd1:	76 4d                	jbe    800e20 <__udivdi3+0x70>
  800dd3:	31 ff                	xor    %edi,%edi
  800dd5:	89 e8                	mov    %ebp,%eax
  800dd7:	89 f2                	mov    %esi,%edx
  800dd9:	f7 f3                	div    %ebx
  800ddb:	89 fa                	mov    %edi,%edx
  800ddd:	83 c4 1c             	add    $0x1c,%esp
  800de0:	5b                   	pop    %ebx
  800de1:	5e                   	pop    %esi
  800de2:	5f                   	pop    %edi
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    
  800de5:	8d 76 00             	lea    0x0(%esi),%esi
  800de8:	39 f2                	cmp    %esi,%edx
  800dea:	76 14                	jbe    800e00 <__udivdi3+0x50>
  800dec:	31 ff                	xor    %edi,%edi
  800dee:	31 c0                	xor    %eax,%eax
  800df0:	89 fa                	mov    %edi,%edx
  800df2:	83 c4 1c             	add    $0x1c,%esp
  800df5:	5b                   	pop    %ebx
  800df6:	5e                   	pop    %esi
  800df7:	5f                   	pop    %edi
  800df8:	5d                   	pop    %ebp
  800df9:	c3                   	ret    
  800dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e00:	0f bd fa             	bsr    %edx,%edi
  800e03:	83 f7 1f             	xor    $0x1f,%edi
  800e06:	75 48                	jne    800e50 <__udivdi3+0xa0>
  800e08:	39 f2                	cmp    %esi,%edx
  800e0a:	72 06                	jb     800e12 <__udivdi3+0x62>
  800e0c:	31 c0                	xor    %eax,%eax
  800e0e:	39 eb                	cmp    %ebp,%ebx
  800e10:	77 de                	ja     800df0 <__udivdi3+0x40>
  800e12:	b8 01 00 00 00       	mov    $0x1,%eax
  800e17:	eb d7                	jmp    800df0 <__udivdi3+0x40>
  800e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e20:	89 d9                	mov    %ebx,%ecx
  800e22:	85 db                	test   %ebx,%ebx
  800e24:	75 0b                	jne    800e31 <__udivdi3+0x81>
  800e26:	b8 01 00 00 00       	mov    $0x1,%eax
  800e2b:	31 d2                	xor    %edx,%edx
  800e2d:	f7 f3                	div    %ebx
  800e2f:	89 c1                	mov    %eax,%ecx
  800e31:	31 d2                	xor    %edx,%edx
  800e33:	89 f0                	mov    %esi,%eax
  800e35:	f7 f1                	div    %ecx
  800e37:	89 c6                	mov    %eax,%esi
  800e39:	89 e8                	mov    %ebp,%eax
  800e3b:	89 f7                	mov    %esi,%edi
  800e3d:	f7 f1                	div    %ecx
  800e3f:	89 fa                	mov    %edi,%edx
  800e41:	83 c4 1c             	add    $0x1c,%esp
  800e44:	5b                   	pop    %ebx
  800e45:	5e                   	pop    %esi
  800e46:	5f                   	pop    %edi
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    
  800e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e50:	89 f9                	mov    %edi,%ecx
  800e52:	b8 20 00 00 00       	mov    $0x20,%eax
  800e57:	29 f8                	sub    %edi,%eax
  800e59:	d3 e2                	shl    %cl,%edx
  800e5b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e5f:	89 c1                	mov    %eax,%ecx
  800e61:	89 da                	mov    %ebx,%edx
  800e63:	d3 ea                	shr    %cl,%edx
  800e65:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e69:	09 d1                	or     %edx,%ecx
  800e6b:	89 f2                	mov    %esi,%edx
  800e6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e71:	89 f9                	mov    %edi,%ecx
  800e73:	d3 e3                	shl    %cl,%ebx
  800e75:	89 c1                	mov    %eax,%ecx
  800e77:	d3 ea                	shr    %cl,%edx
  800e79:	89 f9                	mov    %edi,%ecx
  800e7b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e7f:	89 eb                	mov    %ebp,%ebx
  800e81:	d3 e6                	shl    %cl,%esi
  800e83:	89 c1                	mov    %eax,%ecx
  800e85:	d3 eb                	shr    %cl,%ebx
  800e87:	09 de                	or     %ebx,%esi
  800e89:	89 f0                	mov    %esi,%eax
  800e8b:	f7 74 24 08          	divl   0x8(%esp)
  800e8f:	89 d6                	mov    %edx,%esi
  800e91:	89 c3                	mov    %eax,%ebx
  800e93:	f7 64 24 0c          	mull   0xc(%esp)
  800e97:	39 d6                	cmp    %edx,%esi
  800e99:	72 15                	jb     800eb0 <__udivdi3+0x100>
  800e9b:	89 f9                	mov    %edi,%ecx
  800e9d:	d3 e5                	shl    %cl,%ebp
  800e9f:	39 c5                	cmp    %eax,%ebp
  800ea1:	73 04                	jae    800ea7 <__udivdi3+0xf7>
  800ea3:	39 d6                	cmp    %edx,%esi
  800ea5:	74 09                	je     800eb0 <__udivdi3+0x100>
  800ea7:	89 d8                	mov    %ebx,%eax
  800ea9:	31 ff                	xor    %edi,%edi
  800eab:	e9 40 ff ff ff       	jmp    800df0 <__udivdi3+0x40>
  800eb0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800eb3:	31 ff                	xor    %edi,%edi
  800eb5:	e9 36 ff ff ff       	jmp    800df0 <__udivdi3+0x40>
  800eba:	66 90                	xchg   %ax,%ax
  800ebc:	66 90                	xchg   %ax,%ax
  800ebe:	66 90                	xchg   %ax,%ax

00800ec0 <__umoddi3>:
  800ec0:	f3 0f 1e fb          	endbr32 
  800ec4:	55                   	push   %ebp
  800ec5:	57                   	push   %edi
  800ec6:	56                   	push   %esi
  800ec7:	53                   	push   %ebx
  800ec8:	83 ec 1c             	sub    $0x1c,%esp
  800ecb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800ecf:	8b 74 24 30          	mov    0x30(%esp),%esi
  800ed3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800ed7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800edb:	85 c0                	test   %eax,%eax
  800edd:	75 19                	jne    800ef8 <__umoddi3+0x38>
  800edf:	39 df                	cmp    %ebx,%edi
  800ee1:	76 5d                	jbe    800f40 <__umoddi3+0x80>
  800ee3:	89 f0                	mov    %esi,%eax
  800ee5:	89 da                	mov    %ebx,%edx
  800ee7:	f7 f7                	div    %edi
  800ee9:	89 d0                	mov    %edx,%eax
  800eeb:	31 d2                	xor    %edx,%edx
  800eed:	83 c4 1c             	add    $0x1c,%esp
  800ef0:	5b                   	pop    %ebx
  800ef1:	5e                   	pop    %esi
  800ef2:	5f                   	pop    %edi
  800ef3:	5d                   	pop    %ebp
  800ef4:	c3                   	ret    
  800ef5:	8d 76 00             	lea    0x0(%esi),%esi
  800ef8:	89 f2                	mov    %esi,%edx
  800efa:	39 d8                	cmp    %ebx,%eax
  800efc:	76 12                	jbe    800f10 <__umoddi3+0x50>
  800efe:	89 f0                	mov    %esi,%eax
  800f00:	89 da                	mov    %ebx,%edx
  800f02:	83 c4 1c             	add    $0x1c,%esp
  800f05:	5b                   	pop    %ebx
  800f06:	5e                   	pop    %esi
  800f07:	5f                   	pop    %edi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    
  800f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f10:	0f bd e8             	bsr    %eax,%ebp
  800f13:	83 f5 1f             	xor    $0x1f,%ebp
  800f16:	75 50                	jne    800f68 <__umoddi3+0xa8>
  800f18:	39 d8                	cmp    %ebx,%eax
  800f1a:	0f 82 e0 00 00 00    	jb     801000 <__umoddi3+0x140>
  800f20:	89 d9                	mov    %ebx,%ecx
  800f22:	39 f7                	cmp    %esi,%edi
  800f24:	0f 86 d6 00 00 00    	jbe    801000 <__umoddi3+0x140>
  800f2a:	89 d0                	mov    %edx,%eax
  800f2c:	89 ca                	mov    %ecx,%edx
  800f2e:	83 c4 1c             	add    $0x1c,%esp
  800f31:	5b                   	pop    %ebx
  800f32:	5e                   	pop    %esi
  800f33:	5f                   	pop    %edi
  800f34:	5d                   	pop    %ebp
  800f35:	c3                   	ret    
  800f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f3d:	8d 76 00             	lea    0x0(%esi),%esi
  800f40:	89 fd                	mov    %edi,%ebp
  800f42:	85 ff                	test   %edi,%edi
  800f44:	75 0b                	jne    800f51 <__umoddi3+0x91>
  800f46:	b8 01 00 00 00       	mov    $0x1,%eax
  800f4b:	31 d2                	xor    %edx,%edx
  800f4d:	f7 f7                	div    %edi
  800f4f:	89 c5                	mov    %eax,%ebp
  800f51:	89 d8                	mov    %ebx,%eax
  800f53:	31 d2                	xor    %edx,%edx
  800f55:	f7 f5                	div    %ebp
  800f57:	89 f0                	mov    %esi,%eax
  800f59:	f7 f5                	div    %ebp
  800f5b:	89 d0                	mov    %edx,%eax
  800f5d:	31 d2                	xor    %edx,%edx
  800f5f:	eb 8c                	jmp    800eed <__umoddi3+0x2d>
  800f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f68:	89 e9                	mov    %ebp,%ecx
  800f6a:	ba 20 00 00 00       	mov    $0x20,%edx
  800f6f:	29 ea                	sub    %ebp,%edx
  800f71:	d3 e0                	shl    %cl,%eax
  800f73:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f77:	89 d1                	mov    %edx,%ecx
  800f79:	89 f8                	mov    %edi,%eax
  800f7b:	d3 e8                	shr    %cl,%eax
  800f7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f81:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f85:	8b 54 24 04          	mov    0x4(%esp),%edx
  800f89:	09 c1                	or     %eax,%ecx
  800f8b:	89 d8                	mov    %ebx,%eax
  800f8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f91:	89 e9                	mov    %ebp,%ecx
  800f93:	d3 e7                	shl    %cl,%edi
  800f95:	89 d1                	mov    %edx,%ecx
  800f97:	d3 e8                	shr    %cl,%eax
  800f99:	89 e9                	mov    %ebp,%ecx
  800f9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800f9f:	d3 e3                	shl    %cl,%ebx
  800fa1:	89 c7                	mov    %eax,%edi
  800fa3:	89 d1                	mov    %edx,%ecx
  800fa5:	89 f0                	mov    %esi,%eax
  800fa7:	d3 e8                	shr    %cl,%eax
  800fa9:	89 e9                	mov    %ebp,%ecx
  800fab:	89 fa                	mov    %edi,%edx
  800fad:	d3 e6                	shl    %cl,%esi
  800faf:	09 d8                	or     %ebx,%eax
  800fb1:	f7 74 24 08          	divl   0x8(%esp)
  800fb5:	89 d1                	mov    %edx,%ecx
  800fb7:	89 f3                	mov    %esi,%ebx
  800fb9:	f7 64 24 0c          	mull   0xc(%esp)
  800fbd:	89 c6                	mov    %eax,%esi
  800fbf:	89 d7                	mov    %edx,%edi
  800fc1:	39 d1                	cmp    %edx,%ecx
  800fc3:	72 06                	jb     800fcb <__umoddi3+0x10b>
  800fc5:	75 10                	jne    800fd7 <__umoddi3+0x117>
  800fc7:	39 c3                	cmp    %eax,%ebx
  800fc9:	73 0c                	jae    800fd7 <__umoddi3+0x117>
  800fcb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  800fcf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  800fd3:	89 d7                	mov    %edx,%edi
  800fd5:	89 c6                	mov    %eax,%esi
  800fd7:	89 ca                	mov    %ecx,%edx
  800fd9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800fde:	29 f3                	sub    %esi,%ebx
  800fe0:	19 fa                	sbb    %edi,%edx
  800fe2:	89 d0                	mov    %edx,%eax
  800fe4:	d3 e0                	shl    %cl,%eax
  800fe6:	89 e9                	mov    %ebp,%ecx
  800fe8:	d3 eb                	shr    %cl,%ebx
  800fea:	d3 ea                	shr    %cl,%edx
  800fec:	09 d8                	or     %ebx,%eax
  800fee:	83 c4 1c             	add    $0x1c,%esp
  800ff1:	5b                   	pop    %ebx
  800ff2:	5e                   	pop    %esi
  800ff3:	5f                   	pop    %edi
  800ff4:	5d                   	pop    %ebp
  800ff5:	c3                   	ret    
  800ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ffd:	8d 76 00             	lea    0x0(%esi),%esi
  801000:	29 fe                	sub    %edi,%esi
  801002:	19 c3                	sbb    %eax,%ebx
  801004:	89 f2                	mov    %esi,%edx
  801006:	89 d9                	mov    %ebx,%ecx
  801008:	e9 1d ff ff ff       	jmp    800f2a <__umoddi3+0x6a>
