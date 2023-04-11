
obj/user/faultnostack:     file format elf32-i386


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
  80002c:	e8 27 00 00 00       	call   800058 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 10             	sub    $0x10,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  80003d:	68 53 03 80 00       	push   $0x800353
  800042:	6a 00                	push   $0x0
  800044:	e8 58 02 00 00       	call   8002a1 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800049:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800050:	00 00 00 
}
  800053:	83 c4 10             	add    $0x10,%esp
  800056:	c9                   	leave  
  800057:	c3                   	ret    

00800058 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800058:	f3 0f 1e fb          	endbr32 
  80005c:	55                   	push   %ebp
  80005d:	89 e5                	mov    %esp,%ebp
  80005f:	56                   	push   %esi
  800060:	53                   	push   %ebx
  800061:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800064:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800067:	e8 d6 00 00 00       	call   800142 <sys_getenvid>
  80006c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800071:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800074:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800079:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80007e:	85 db                	test   %ebx,%ebx
  800080:	7e 07                	jle    800089 <libmain+0x31>
		binaryname = argv[0];
  800082:	8b 06                	mov    (%esi),%eax
  800084:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	56                   	push   %esi
  80008d:	53                   	push   %ebx
  80008e:	e8 a0 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800093:	e8 0a 00 00 00       	call   8000a2 <exit>
}
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80009e:	5b                   	pop    %ebx
  80009f:	5e                   	pop    %esi
  8000a0:	5d                   	pop    %ebp
  8000a1:	c3                   	ret    

008000a2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a2:	f3 0f 1e fb          	endbr32 
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8000ac:	6a 00                	push   $0x0
  8000ae:	e8 4a 00 00 00       	call   8000fd <sys_env_destroy>
}
  8000b3:	83 c4 10             	add    $0x10,%esp
  8000b6:	c9                   	leave  
  8000b7:	c3                   	ret    

008000b8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000b8:	f3 0f 1e fb          	endbr32 
  8000bc:	55                   	push   %ebp
  8000bd:	89 e5                	mov    %esp,%ebp
  8000bf:	57                   	push   %edi
  8000c0:	56                   	push   %esi
  8000c1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000cd:	89 c3                	mov    %eax,%ebx
  8000cf:	89 c7                	mov    %eax,%edi
  8000d1:	89 c6                	mov    %eax,%esi
  8000d3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000d5:	5b                   	pop    %ebx
  8000d6:	5e                   	pop    %esi
  8000d7:	5f                   	pop    %edi
  8000d8:	5d                   	pop    %ebp
  8000d9:	c3                   	ret    

008000da <sys_cgetc>:

int
sys_cgetc(void)
{
  8000da:	f3 0f 1e fb          	endbr32 
  8000de:	55                   	push   %ebp
  8000df:	89 e5                	mov    %esp,%ebp
  8000e1:	57                   	push   %edi
  8000e2:	56                   	push   %esi
  8000e3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8000ee:	89 d1                	mov    %edx,%ecx
  8000f0:	89 d3                	mov    %edx,%ebx
  8000f2:	89 d7                	mov    %edx,%edi
  8000f4:	89 d6                	mov    %edx,%esi
  8000f6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000f8:	5b                   	pop    %ebx
  8000f9:	5e                   	pop    %esi
  8000fa:	5f                   	pop    %edi
  8000fb:	5d                   	pop    %ebp
  8000fc:	c3                   	ret    

008000fd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000fd:	f3 0f 1e fb          	endbr32 
  800101:	55                   	push   %ebp
  800102:	89 e5                	mov    %esp,%ebp
  800104:	57                   	push   %edi
  800105:	56                   	push   %esi
  800106:	53                   	push   %ebx
  800107:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80010a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80010f:	8b 55 08             	mov    0x8(%ebp),%edx
  800112:	b8 03 00 00 00       	mov    $0x3,%eax
  800117:	89 cb                	mov    %ecx,%ebx
  800119:	89 cf                	mov    %ecx,%edi
  80011b:	89 ce                	mov    %ecx,%esi
  80011d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80011f:	85 c0                	test   %eax,%eax
  800121:	7f 08                	jg     80012b <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800123:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800126:	5b                   	pop    %ebx
  800127:	5e                   	pop    %esi
  800128:	5f                   	pop    %edi
  800129:	5d                   	pop    %ebp
  80012a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80012b:	83 ec 0c             	sub    $0xc,%esp
  80012e:	50                   	push   %eax
  80012f:	6a 03                	push   $0x3
  800131:	68 ca 10 80 00       	push   $0x8010ca
  800136:	6a 23                	push   $0x23
  800138:	68 e7 10 80 00       	push   $0x8010e7
  80013d:	e8 37 02 00 00       	call   800379 <_panic>

00800142 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800142:	f3 0f 1e fb          	endbr32 
  800146:	55                   	push   %ebp
  800147:	89 e5                	mov    %esp,%ebp
  800149:	57                   	push   %edi
  80014a:	56                   	push   %esi
  80014b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80014c:	ba 00 00 00 00       	mov    $0x0,%edx
  800151:	b8 02 00 00 00       	mov    $0x2,%eax
  800156:	89 d1                	mov    %edx,%ecx
  800158:	89 d3                	mov    %edx,%ebx
  80015a:	89 d7                	mov    %edx,%edi
  80015c:	89 d6                	mov    %edx,%esi
  80015e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800160:	5b                   	pop    %ebx
  800161:	5e                   	pop    %esi
  800162:	5f                   	pop    %edi
  800163:	5d                   	pop    %ebp
  800164:	c3                   	ret    

00800165 <sys_yield>:

void
sys_yield(void)
{
  800165:	f3 0f 1e fb          	endbr32 
  800169:	55                   	push   %ebp
  80016a:	89 e5                	mov    %esp,%ebp
  80016c:	57                   	push   %edi
  80016d:	56                   	push   %esi
  80016e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80016f:	ba 00 00 00 00       	mov    $0x0,%edx
  800174:	b8 0a 00 00 00       	mov    $0xa,%eax
  800179:	89 d1                	mov    %edx,%ecx
  80017b:	89 d3                	mov    %edx,%ebx
  80017d:	89 d7                	mov    %edx,%edi
  80017f:	89 d6                	mov    %edx,%esi
  800181:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800183:	5b                   	pop    %ebx
  800184:	5e                   	pop    %esi
  800185:	5f                   	pop    %edi
  800186:	5d                   	pop    %ebp
  800187:	c3                   	ret    

00800188 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800188:	f3 0f 1e fb          	endbr32 
  80018c:	55                   	push   %ebp
  80018d:	89 e5                	mov    %esp,%ebp
  80018f:	57                   	push   %edi
  800190:	56                   	push   %esi
  800191:	53                   	push   %ebx
  800192:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800195:	be 00 00 00 00       	mov    $0x0,%esi
  80019a:	8b 55 08             	mov    0x8(%ebp),%edx
  80019d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a0:	b8 04 00 00 00       	mov    $0x4,%eax
  8001a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001a8:	89 f7                	mov    %esi,%edi
  8001aa:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001ac:	85 c0                	test   %eax,%eax
  8001ae:	7f 08                	jg     8001b8 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b3:	5b                   	pop    %ebx
  8001b4:	5e                   	pop    %esi
  8001b5:	5f                   	pop    %edi
  8001b6:	5d                   	pop    %ebp
  8001b7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	50                   	push   %eax
  8001bc:	6a 04                	push   $0x4
  8001be:	68 ca 10 80 00       	push   $0x8010ca
  8001c3:	6a 23                	push   $0x23
  8001c5:	68 e7 10 80 00       	push   $0x8010e7
  8001ca:	e8 aa 01 00 00       	call   800379 <_panic>

008001cf <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001cf:	f3 0f 1e fb          	endbr32 
  8001d3:	55                   	push   %ebp
  8001d4:	89 e5                	mov    %esp,%ebp
  8001d6:	57                   	push   %edi
  8001d7:	56                   	push   %esi
  8001d8:	53                   	push   %ebx
  8001d9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8001df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e2:	b8 05 00 00 00       	mov    $0x5,%eax
  8001e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001ea:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001ed:	8b 75 18             	mov    0x18(%ebp),%esi
  8001f0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001f2:	85 c0                	test   %eax,%eax
  8001f4:	7f 08                	jg     8001fe <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f9:	5b                   	pop    %ebx
  8001fa:	5e                   	pop    %esi
  8001fb:	5f                   	pop    %edi
  8001fc:	5d                   	pop    %ebp
  8001fd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001fe:	83 ec 0c             	sub    $0xc,%esp
  800201:	50                   	push   %eax
  800202:	6a 05                	push   $0x5
  800204:	68 ca 10 80 00       	push   $0x8010ca
  800209:	6a 23                	push   $0x23
  80020b:	68 e7 10 80 00       	push   $0x8010e7
  800210:	e8 64 01 00 00       	call   800379 <_panic>

00800215 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800215:	f3 0f 1e fb          	endbr32 
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	57                   	push   %edi
  80021d:	56                   	push   %esi
  80021e:	53                   	push   %ebx
  80021f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800222:	bb 00 00 00 00       	mov    $0x0,%ebx
  800227:	8b 55 08             	mov    0x8(%ebp),%edx
  80022a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80022d:	b8 06 00 00 00       	mov    $0x6,%eax
  800232:	89 df                	mov    %ebx,%edi
  800234:	89 de                	mov    %ebx,%esi
  800236:	cd 30                	int    $0x30
	if(check && ret > 0)
  800238:	85 c0                	test   %eax,%eax
  80023a:	7f 08                	jg     800244 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80023c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023f:	5b                   	pop    %ebx
  800240:	5e                   	pop    %esi
  800241:	5f                   	pop    %edi
  800242:	5d                   	pop    %ebp
  800243:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	50                   	push   %eax
  800248:	6a 06                	push   $0x6
  80024a:	68 ca 10 80 00       	push   $0x8010ca
  80024f:	6a 23                	push   $0x23
  800251:	68 e7 10 80 00       	push   $0x8010e7
  800256:	e8 1e 01 00 00       	call   800379 <_panic>

0080025b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80025b:	f3 0f 1e fb          	endbr32 
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
  800262:	57                   	push   %edi
  800263:	56                   	push   %esi
  800264:	53                   	push   %ebx
  800265:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800268:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026d:	8b 55 08             	mov    0x8(%ebp),%edx
  800270:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800273:	b8 08 00 00 00       	mov    $0x8,%eax
  800278:	89 df                	mov    %ebx,%edi
  80027a:	89 de                	mov    %ebx,%esi
  80027c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80027e:	85 c0                	test   %eax,%eax
  800280:	7f 08                	jg     80028a <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800282:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800285:	5b                   	pop    %ebx
  800286:	5e                   	pop    %esi
  800287:	5f                   	pop    %edi
  800288:	5d                   	pop    %ebp
  800289:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	50                   	push   %eax
  80028e:	6a 08                	push   $0x8
  800290:	68 ca 10 80 00       	push   $0x8010ca
  800295:	6a 23                	push   $0x23
  800297:	68 e7 10 80 00       	push   $0x8010e7
  80029c:	e8 d8 00 00 00       	call   800379 <_panic>

008002a1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a1:	f3 0f 1e fb          	endbr32 
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	57                   	push   %edi
  8002a9:	56                   	push   %esi
  8002aa:	53                   	push   %ebx
  8002ab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b9:	b8 09 00 00 00       	mov    $0x9,%eax
  8002be:	89 df                	mov    %ebx,%edi
  8002c0:	89 de                	mov    %ebx,%esi
  8002c2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c4:	85 c0                	test   %eax,%eax
  8002c6:	7f 08                	jg     8002d0 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cb:	5b                   	pop    %ebx
  8002cc:	5e                   	pop    %esi
  8002cd:	5f                   	pop    %edi
  8002ce:	5d                   	pop    %ebp
  8002cf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	50                   	push   %eax
  8002d4:	6a 09                	push   $0x9
  8002d6:	68 ca 10 80 00       	push   $0x8010ca
  8002db:	6a 23                	push   $0x23
  8002dd:	68 e7 10 80 00       	push   $0x8010e7
  8002e2:	e8 92 00 00 00       	call   800379 <_panic>

008002e7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002e7:	f3 0f 1e fb          	endbr32 
  8002eb:	55                   	push   %ebp
  8002ec:	89 e5                	mov    %esp,%ebp
  8002ee:	57                   	push   %edi
  8002ef:	56                   	push   %esi
  8002f0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f7:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002fc:	be 00 00 00 00       	mov    $0x0,%esi
  800301:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800304:	8b 7d 14             	mov    0x14(%ebp),%edi
  800307:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800309:	5b                   	pop    %ebx
  80030a:	5e                   	pop    %esi
  80030b:	5f                   	pop    %edi
  80030c:	5d                   	pop    %ebp
  80030d:	c3                   	ret    

0080030e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80030e:	f3 0f 1e fb          	endbr32 
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	57                   	push   %edi
  800316:	56                   	push   %esi
  800317:	53                   	push   %ebx
  800318:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80031b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800320:	8b 55 08             	mov    0x8(%ebp),%edx
  800323:	b8 0c 00 00 00       	mov    $0xc,%eax
  800328:	89 cb                	mov    %ecx,%ebx
  80032a:	89 cf                	mov    %ecx,%edi
  80032c:	89 ce                	mov    %ecx,%esi
  80032e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800330:	85 c0                	test   %eax,%eax
  800332:	7f 08                	jg     80033c <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800334:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800337:	5b                   	pop    %ebx
  800338:	5e                   	pop    %esi
  800339:	5f                   	pop    %edi
  80033a:	5d                   	pop    %ebp
  80033b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	50                   	push   %eax
  800340:	6a 0c                	push   $0xc
  800342:	68 ca 10 80 00       	push   $0x8010ca
  800347:	6a 23                	push   $0x23
  800349:	68 e7 10 80 00       	push   $0x8010e7
  80034e:	e8 26 00 00 00       	call   800379 <_panic>

00800353 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800353:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800354:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  800359:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80035b:	83 c4 04             	add    $0x4,%esp

	// %eip 存储在 40(%esp)
	// %esp 存储在 48(%esp) 
	// 48(%esp) 之前运行的栈的栈顶
	// 我们要将eip的值写入栈顶下面的位置,并将栈顶指向该位置
	movl 48(%esp), %eax
  80035e:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  800362:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  800366:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  800369:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  80036b:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	// 跳过fault_va以及err
	addl $8, %esp
  80036f:	83 c4 08             	add    $0x8,%esp
	popal
  800372:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过eip,恢复eflags
	addl $4, %esp
  800373:	83 c4 04             	add    $0x4,%esp
	popfl
  800376:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复esp,如果第一处不将trap-time esp指向下一个位置,这里esp就会指向之前的栈顶
	popl %esp
  800377:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// 由于第一处的设置,现在esp指向的值为trap-time eip,所以直接ret即可达到恢复上一次执行的效果
  800378:	c3                   	ret    

00800379 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800379:	f3 0f 1e fb          	endbr32 
  80037d:	55                   	push   %ebp
  80037e:	89 e5                	mov    %esp,%ebp
  800380:	56                   	push   %esi
  800381:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800382:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800385:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80038b:	e8 b2 fd ff ff       	call   800142 <sys_getenvid>
  800390:	83 ec 0c             	sub    $0xc,%esp
  800393:	ff 75 0c             	pushl  0xc(%ebp)
  800396:	ff 75 08             	pushl  0x8(%ebp)
  800399:	56                   	push   %esi
  80039a:	50                   	push   %eax
  80039b:	68 f8 10 80 00       	push   $0x8010f8
  8003a0:	e8 bb 00 00 00       	call   800460 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003a5:	83 c4 18             	add    $0x18,%esp
  8003a8:	53                   	push   %ebx
  8003a9:	ff 75 10             	pushl  0x10(%ebp)
  8003ac:	e8 5a 00 00 00       	call   80040b <vcprintf>
	cprintf("\n");
  8003b1:	c7 04 24 1b 11 80 00 	movl   $0x80111b,(%esp)
  8003b8:	e8 a3 00 00 00       	call   800460 <cprintf>
  8003bd:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003c0:	cc                   	int3   
  8003c1:	eb fd                	jmp    8003c0 <_panic+0x47>

008003c3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003c3:	f3 0f 1e fb          	endbr32 
  8003c7:	55                   	push   %ebp
  8003c8:	89 e5                	mov    %esp,%ebp
  8003ca:	53                   	push   %ebx
  8003cb:	83 ec 04             	sub    $0x4,%esp
  8003ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003d1:	8b 13                	mov    (%ebx),%edx
  8003d3:	8d 42 01             	lea    0x1(%edx),%eax
  8003d6:	89 03                	mov    %eax,(%ebx)
  8003d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003db:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003df:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003e4:	74 09                	je     8003ef <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003e6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003ed:	c9                   	leave  
  8003ee:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003ef:	83 ec 08             	sub    $0x8,%esp
  8003f2:	68 ff 00 00 00       	push   $0xff
  8003f7:	8d 43 08             	lea    0x8(%ebx),%eax
  8003fa:	50                   	push   %eax
  8003fb:	e8 b8 fc ff ff       	call   8000b8 <sys_cputs>
		b->idx = 0;
  800400:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800406:	83 c4 10             	add    $0x10,%esp
  800409:	eb db                	jmp    8003e6 <putch+0x23>

0080040b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80040b:	f3 0f 1e fb          	endbr32 
  80040f:	55                   	push   %ebp
  800410:	89 e5                	mov    %esp,%ebp
  800412:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800418:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80041f:	00 00 00 
	b.cnt = 0;
  800422:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800429:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80042c:	ff 75 0c             	pushl  0xc(%ebp)
  80042f:	ff 75 08             	pushl  0x8(%ebp)
  800432:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800438:	50                   	push   %eax
  800439:	68 c3 03 80 00       	push   $0x8003c3
  80043e:	e8 20 01 00 00       	call   800563 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800443:	83 c4 08             	add    $0x8,%esp
  800446:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80044c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800452:	50                   	push   %eax
  800453:	e8 60 fc ff ff       	call   8000b8 <sys_cputs>

	return b.cnt;
}
  800458:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80045e:	c9                   	leave  
  80045f:	c3                   	ret    

00800460 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800460:	f3 0f 1e fb          	endbr32 
  800464:	55                   	push   %ebp
  800465:	89 e5                	mov    %esp,%ebp
  800467:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80046a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80046d:	50                   	push   %eax
  80046e:	ff 75 08             	pushl  0x8(%ebp)
  800471:	e8 95 ff ff ff       	call   80040b <vcprintf>
	va_end(ap);

	return cnt;
}
  800476:	c9                   	leave  
  800477:	c3                   	ret    

00800478 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	57                   	push   %edi
  80047c:	56                   	push   %esi
  80047d:	53                   	push   %ebx
  80047e:	83 ec 1c             	sub    $0x1c,%esp
  800481:	89 c7                	mov    %eax,%edi
  800483:	89 d6                	mov    %edx,%esi
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048b:	89 d1                	mov    %edx,%ecx
  80048d:	89 c2                	mov    %eax,%edx
  80048f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800492:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800495:	8b 45 10             	mov    0x10(%ebp),%eax
  800498:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80049b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80049e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8004a5:	39 c2                	cmp    %eax,%edx
  8004a7:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8004aa:	72 3e                	jb     8004ea <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004ac:	83 ec 0c             	sub    $0xc,%esp
  8004af:	ff 75 18             	pushl  0x18(%ebp)
  8004b2:	83 eb 01             	sub    $0x1,%ebx
  8004b5:	53                   	push   %ebx
  8004b6:	50                   	push   %eax
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004bd:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c0:	ff 75 dc             	pushl  -0x24(%ebp)
  8004c3:	ff 75 d8             	pushl  -0x28(%ebp)
  8004c6:	e8 85 09 00 00       	call   800e50 <__udivdi3>
  8004cb:	83 c4 18             	add    $0x18,%esp
  8004ce:	52                   	push   %edx
  8004cf:	50                   	push   %eax
  8004d0:	89 f2                	mov    %esi,%edx
  8004d2:	89 f8                	mov    %edi,%eax
  8004d4:	e8 9f ff ff ff       	call   800478 <printnum>
  8004d9:	83 c4 20             	add    $0x20,%esp
  8004dc:	eb 13                	jmp    8004f1 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004de:	83 ec 08             	sub    $0x8,%esp
  8004e1:	56                   	push   %esi
  8004e2:	ff 75 18             	pushl  0x18(%ebp)
  8004e5:	ff d7                	call   *%edi
  8004e7:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004ea:	83 eb 01             	sub    $0x1,%ebx
  8004ed:	85 db                	test   %ebx,%ebx
  8004ef:	7f ed                	jg     8004de <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004f1:	83 ec 08             	sub    $0x8,%esp
  8004f4:	56                   	push   %esi
  8004f5:	83 ec 04             	sub    $0x4,%esp
  8004f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004fb:	ff 75 e0             	pushl  -0x20(%ebp)
  8004fe:	ff 75 dc             	pushl  -0x24(%ebp)
  800501:	ff 75 d8             	pushl  -0x28(%ebp)
  800504:	e8 57 0a 00 00       	call   800f60 <__umoddi3>
  800509:	83 c4 14             	add    $0x14,%esp
  80050c:	0f be 80 1d 11 80 00 	movsbl 0x80111d(%eax),%eax
  800513:	50                   	push   %eax
  800514:	ff d7                	call   *%edi
}
  800516:	83 c4 10             	add    $0x10,%esp
  800519:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80051c:	5b                   	pop    %ebx
  80051d:	5e                   	pop    %esi
  80051e:	5f                   	pop    %edi
  80051f:	5d                   	pop    %ebp
  800520:	c3                   	ret    

00800521 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800521:	f3 0f 1e fb          	endbr32 
  800525:	55                   	push   %ebp
  800526:	89 e5                	mov    %esp,%ebp
  800528:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80052b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80052f:	8b 10                	mov    (%eax),%edx
  800531:	3b 50 04             	cmp    0x4(%eax),%edx
  800534:	73 0a                	jae    800540 <sprintputch+0x1f>
		*b->buf++ = ch;
  800536:	8d 4a 01             	lea    0x1(%edx),%ecx
  800539:	89 08                	mov    %ecx,(%eax)
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	88 02                	mov    %al,(%edx)
}
  800540:	5d                   	pop    %ebp
  800541:	c3                   	ret    

00800542 <printfmt>:
{
  800542:	f3 0f 1e fb          	endbr32 
  800546:	55                   	push   %ebp
  800547:	89 e5                	mov    %esp,%ebp
  800549:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80054c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80054f:	50                   	push   %eax
  800550:	ff 75 10             	pushl  0x10(%ebp)
  800553:	ff 75 0c             	pushl  0xc(%ebp)
  800556:	ff 75 08             	pushl  0x8(%ebp)
  800559:	e8 05 00 00 00       	call   800563 <vprintfmt>
}
  80055e:	83 c4 10             	add    $0x10,%esp
  800561:	c9                   	leave  
  800562:	c3                   	ret    

00800563 <vprintfmt>:
{
  800563:	f3 0f 1e fb          	endbr32 
  800567:	55                   	push   %ebp
  800568:	89 e5                	mov    %esp,%ebp
  80056a:	57                   	push   %edi
  80056b:	56                   	push   %esi
  80056c:	53                   	push   %ebx
  80056d:	83 ec 3c             	sub    $0x3c,%esp
  800570:	8b 75 08             	mov    0x8(%ebp),%esi
  800573:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800576:	8b 7d 10             	mov    0x10(%ebp),%edi
  800579:	e9 8e 03 00 00       	jmp    80090c <vprintfmt+0x3a9>
		padc = ' ';
  80057e:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800582:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800589:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800590:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800597:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80059c:	8d 47 01             	lea    0x1(%edi),%eax
  80059f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005a2:	0f b6 17             	movzbl (%edi),%edx
  8005a5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005a8:	3c 55                	cmp    $0x55,%al
  8005aa:	0f 87 df 03 00 00    	ja     80098f <vprintfmt+0x42c>
  8005b0:	0f b6 c0             	movzbl %al,%eax
  8005b3:	3e ff 24 85 e0 11 80 	notrack jmp *0x8011e0(,%eax,4)
  8005ba:	00 
  8005bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8005be:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8005c2:	eb d8                	jmp    80059c <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8005c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005c7:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8005cb:	eb cf                	jmp    80059c <vprintfmt+0x39>
  8005cd:	0f b6 d2             	movzbl %dl,%edx
  8005d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8005db:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005de:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005e2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005e5:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005e8:	83 f9 09             	cmp    $0x9,%ecx
  8005eb:	77 55                	ja     800642 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8005ed:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005f0:	eb e9                	jmp    8005db <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8b 00                	mov    (%eax),%eax
  8005f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8d 40 04             	lea    0x4(%eax),%eax
  800600:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800603:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800606:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80060a:	79 90                	jns    80059c <vprintfmt+0x39>
				width = precision, precision = -1;
  80060c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80060f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800612:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800619:	eb 81                	jmp    80059c <vprintfmt+0x39>
  80061b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80061e:	85 c0                	test   %eax,%eax
  800620:	ba 00 00 00 00       	mov    $0x0,%edx
  800625:	0f 49 d0             	cmovns %eax,%edx
  800628:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80062b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80062e:	e9 69 ff ff ff       	jmp    80059c <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800633:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800636:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80063d:	e9 5a ff ff ff       	jmp    80059c <vprintfmt+0x39>
  800642:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800645:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800648:	eb bc                	jmp    800606 <vprintfmt+0xa3>
			lflag++;
  80064a:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80064d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800650:	e9 47 ff ff ff       	jmp    80059c <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	8d 78 04             	lea    0x4(%eax),%edi
  80065b:	83 ec 08             	sub    $0x8,%esp
  80065e:	53                   	push   %ebx
  80065f:	ff 30                	pushl  (%eax)
  800661:	ff d6                	call   *%esi
			break;
  800663:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800666:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800669:	e9 9b 02 00 00       	jmp    800909 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8d 78 04             	lea    0x4(%eax),%edi
  800674:	8b 00                	mov    (%eax),%eax
  800676:	99                   	cltd   
  800677:	31 d0                	xor    %edx,%eax
  800679:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80067b:	83 f8 08             	cmp    $0x8,%eax
  80067e:	7f 23                	jg     8006a3 <vprintfmt+0x140>
  800680:	8b 14 85 40 13 80 00 	mov    0x801340(,%eax,4),%edx
  800687:	85 d2                	test   %edx,%edx
  800689:	74 18                	je     8006a3 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80068b:	52                   	push   %edx
  80068c:	68 3e 11 80 00       	push   $0x80113e
  800691:	53                   	push   %ebx
  800692:	56                   	push   %esi
  800693:	e8 aa fe ff ff       	call   800542 <printfmt>
  800698:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80069b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80069e:	e9 66 02 00 00       	jmp    800909 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8006a3:	50                   	push   %eax
  8006a4:	68 35 11 80 00       	push   $0x801135
  8006a9:	53                   	push   %ebx
  8006aa:	56                   	push   %esi
  8006ab:	e8 92 fe ff ff       	call   800542 <printfmt>
  8006b0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006b3:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8006b6:	e9 4e 02 00 00       	jmp    800909 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	83 c0 04             	add    $0x4,%eax
  8006c1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8006c9:	85 d2                	test   %edx,%edx
  8006cb:	b8 2e 11 80 00       	mov    $0x80112e,%eax
  8006d0:	0f 45 c2             	cmovne %edx,%eax
  8006d3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8006d6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006da:	7e 06                	jle    8006e2 <vprintfmt+0x17f>
  8006dc:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006e0:	75 0d                	jne    8006ef <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006e5:	89 c7                	mov    %eax,%edi
  8006e7:	03 45 e0             	add    -0x20(%ebp),%eax
  8006ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006ed:	eb 55                	jmp    800744 <vprintfmt+0x1e1>
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	ff 75 d8             	pushl  -0x28(%ebp)
  8006f5:	ff 75 cc             	pushl  -0x34(%ebp)
  8006f8:	e8 46 03 00 00       	call   800a43 <strnlen>
  8006fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800700:	29 c2                	sub    %eax,%edx
  800702:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800705:	83 c4 10             	add    $0x10,%esp
  800708:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80070a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800711:	85 ff                	test   %edi,%edi
  800713:	7e 11                	jle    800726 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800715:	83 ec 08             	sub    $0x8,%esp
  800718:	53                   	push   %ebx
  800719:	ff 75 e0             	pushl  -0x20(%ebp)
  80071c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80071e:	83 ef 01             	sub    $0x1,%edi
  800721:	83 c4 10             	add    $0x10,%esp
  800724:	eb eb                	jmp    800711 <vprintfmt+0x1ae>
  800726:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800729:	85 d2                	test   %edx,%edx
  80072b:	b8 00 00 00 00       	mov    $0x0,%eax
  800730:	0f 49 c2             	cmovns %edx,%eax
  800733:	29 c2                	sub    %eax,%edx
  800735:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800738:	eb a8                	jmp    8006e2 <vprintfmt+0x17f>
					putch(ch, putdat);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	53                   	push   %ebx
  80073e:	52                   	push   %edx
  80073f:	ff d6                	call   *%esi
  800741:	83 c4 10             	add    $0x10,%esp
  800744:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800747:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800749:	83 c7 01             	add    $0x1,%edi
  80074c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800750:	0f be d0             	movsbl %al,%edx
  800753:	85 d2                	test   %edx,%edx
  800755:	74 4b                	je     8007a2 <vprintfmt+0x23f>
  800757:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80075b:	78 06                	js     800763 <vprintfmt+0x200>
  80075d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800761:	78 1e                	js     800781 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800763:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800767:	74 d1                	je     80073a <vprintfmt+0x1d7>
  800769:	0f be c0             	movsbl %al,%eax
  80076c:	83 e8 20             	sub    $0x20,%eax
  80076f:	83 f8 5e             	cmp    $0x5e,%eax
  800772:	76 c6                	jbe    80073a <vprintfmt+0x1d7>
					putch('?', putdat);
  800774:	83 ec 08             	sub    $0x8,%esp
  800777:	53                   	push   %ebx
  800778:	6a 3f                	push   $0x3f
  80077a:	ff d6                	call   *%esi
  80077c:	83 c4 10             	add    $0x10,%esp
  80077f:	eb c3                	jmp    800744 <vprintfmt+0x1e1>
  800781:	89 cf                	mov    %ecx,%edi
  800783:	eb 0e                	jmp    800793 <vprintfmt+0x230>
				putch(' ', putdat);
  800785:	83 ec 08             	sub    $0x8,%esp
  800788:	53                   	push   %ebx
  800789:	6a 20                	push   $0x20
  80078b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80078d:	83 ef 01             	sub    $0x1,%edi
  800790:	83 c4 10             	add    $0x10,%esp
  800793:	85 ff                	test   %edi,%edi
  800795:	7f ee                	jg     800785 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800797:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80079a:	89 45 14             	mov    %eax,0x14(%ebp)
  80079d:	e9 67 01 00 00       	jmp    800909 <vprintfmt+0x3a6>
  8007a2:	89 cf                	mov    %ecx,%edi
  8007a4:	eb ed                	jmp    800793 <vprintfmt+0x230>
	if (lflag >= 2)
  8007a6:	83 f9 01             	cmp    $0x1,%ecx
  8007a9:	7f 1b                	jg     8007c6 <vprintfmt+0x263>
	else if (lflag)
  8007ab:	85 c9                	test   %ecx,%ecx
  8007ad:	74 63                	je     800812 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b7:	99                   	cltd   
  8007b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	8d 40 04             	lea    0x4(%eax),%eax
  8007c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c4:	eb 17                	jmp    8007dd <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	8b 50 04             	mov    0x4(%eax),%edx
  8007cc:	8b 00                	mov    (%eax),%eax
  8007ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d7:	8d 40 08             	lea    0x8(%eax),%eax
  8007da:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8007dd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007e0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007e3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007e8:	85 c9                	test   %ecx,%ecx
  8007ea:	0f 89 ff 00 00 00    	jns    8008ef <vprintfmt+0x38c>
				putch('-', putdat);
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	53                   	push   %ebx
  8007f4:	6a 2d                	push   $0x2d
  8007f6:	ff d6                	call   *%esi
				num = -(long long) num;
  8007f8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007fb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007fe:	f7 da                	neg    %edx
  800800:	83 d1 00             	adc    $0x0,%ecx
  800803:	f7 d9                	neg    %ecx
  800805:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800808:	b8 0a 00 00 00       	mov    $0xa,%eax
  80080d:	e9 dd 00 00 00       	jmp    8008ef <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800812:	8b 45 14             	mov    0x14(%ebp),%eax
  800815:	8b 00                	mov    (%eax),%eax
  800817:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081a:	99                   	cltd   
  80081b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80081e:	8b 45 14             	mov    0x14(%ebp),%eax
  800821:	8d 40 04             	lea    0x4(%eax),%eax
  800824:	89 45 14             	mov    %eax,0x14(%ebp)
  800827:	eb b4                	jmp    8007dd <vprintfmt+0x27a>
	if (lflag >= 2)
  800829:	83 f9 01             	cmp    $0x1,%ecx
  80082c:	7f 1e                	jg     80084c <vprintfmt+0x2e9>
	else if (lflag)
  80082e:	85 c9                	test   %ecx,%ecx
  800830:	74 32                	je     800864 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	8b 10                	mov    (%eax),%edx
  800837:	b9 00 00 00 00       	mov    $0x0,%ecx
  80083c:	8d 40 04             	lea    0x4(%eax),%eax
  80083f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800842:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800847:	e9 a3 00 00 00       	jmp    8008ef <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	8b 10                	mov    (%eax),%edx
  800851:	8b 48 04             	mov    0x4(%eax),%ecx
  800854:	8d 40 08             	lea    0x8(%eax),%eax
  800857:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80085a:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80085f:	e9 8b 00 00 00       	jmp    8008ef <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	8b 10                	mov    (%eax),%edx
  800869:	b9 00 00 00 00       	mov    $0x0,%ecx
  80086e:	8d 40 04             	lea    0x4(%eax),%eax
  800871:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800874:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800879:	eb 74                	jmp    8008ef <vprintfmt+0x38c>
	if (lflag >= 2)
  80087b:	83 f9 01             	cmp    $0x1,%ecx
  80087e:	7f 1b                	jg     80089b <vprintfmt+0x338>
	else if (lflag)
  800880:	85 c9                	test   %ecx,%ecx
  800882:	74 2c                	je     8008b0 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	8b 10                	mov    (%eax),%edx
  800889:	b9 00 00 00 00       	mov    $0x0,%ecx
  80088e:	8d 40 04             	lea    0x4(%eax),%eax
  800891:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800894:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800899:	eb 54                	jmp    8008ef <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	8b 10                	mov    (%eax),%edx
  8008a0:	8b 48 04             	mov    0x4(%eax),%ecx
  8008a3:	8d 40 08             	lea    0x8(%eax),%eax
  8008a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008a9:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8008ae:	eb 3f                	jmp    8008ef <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8008b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b3:	8b 10                	mov    (%eax),%edx
  8008b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008ba:	8d 40 04             	lea    0x4(%eax),%eax
  8008bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008c0:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8008c5:	eb 28                	jmp    8008ef <vprintfmt+0x38c>
			putch('0', putdat);
  8008c7:	83 ec 08             	sub    $0x8,%esp
  8008ca:	53                   	push   %ebx
  8008cb:	6a 30                	push   $0x30
  8008cd:	ff d6                	call   *%esi
			putch('x', putdat);
  8008cf:	83 c4 08             	add    $0x8,%esp
  8008d2:	53                   	push   %ebx
  8008d3:	6a 78                	push   $0x78
  8008d5:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	8b 10                	mov    (%eax),%edx
  8008dc:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008e1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008e4:	8d 40 04             	lea    0x4(%eax),%eax
  8008e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ea:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008ef:	83 ec 0c             	sub    $0xc,%esp
  8008f2:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8008f6:	57                   	push   %edi
  8008f7:	ff 75 e0             	pushl  -0x20(%ebp)
  8008fa:	50                   	push   %eax
  8008fb:	51                   	push   %ecx
  8008fc:	52                   	push   %edx
  8008fd:	89 da                	mov    %ebx,%edx
  8008ff:	89 f0                	mov    %esi,%eax
  800901:	e8 72 fb ff ff       	call   800478 <printnum>
			break;
  800906:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800909:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80090c:	83 c7 01             	add    $0x1,%edi
  80090f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800913:	83 f8 25             	cmp    $0x25,%eax
  800916:	0f 84 62 fc ff ff    	je     80057e <vprintfmt+0x1b>
			if (ch == '\0')
  80091c:	85 c0                	test   %eax,%eax
  80091e:	0f 84 8b 00 00 00    	je     8009af <vprintfmt+0x44c>
			putch(ch, putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	53                   	push   %ebx
  800928:	50                   	push   %eax
  800929:	ff d6                	call   *%esi
  80092b:	83 c4 10             	add    $0x10,%esp
  80092e:	eb dc                	jmp    80090c <vprintfmt+0x3a9>
	if (lflag >= 2)
  800930:	83 f9 01             	cmp    $0x1,%ecx
  800933:	7f 1b                	jg     800950 <vprintfmt+0x3ed>
	else if (lflag)
  800935:	85 c9                	test   %ecx,%ecx
  800937:	74 2c                	je     800965 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800939:	8b 45 14             	mov    0x14(%ebp),%eax
  80093c:	8b 10                	mov    (%eax),%edx
  80093e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800943:	8d 40 04             	lea    0x4(%eax),%eax
  800946:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800949:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80094e:	eb 9f                	jmp    8008ef <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800950:	8b 45 14             	mov    0x14(%ebp),%eax
  800953:	8b 10                	mov    (%eax),%edx
  800955:	8b 48 04             	mov    0x4(%eax),%ecx
  800958:	8d 40 08             	lea    0x8(%eax),%eax
  80095b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80095e:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800963:	eb 8a                	jmp    8008ef <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800965:	8b 45 14             	mov    0x14(%ebp),%eax
  800968:	8b 10                	mov    (%eax),%edx
  80096a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80096f:	8d 40 04             	lea    0x4(%eax),%eax
  800972:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800975:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80097a:	e9 70 ff ff ff       	jmp    8008ef <vprintfmt+0x38c>
			putch(ch, putdat);
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	53                   	push   %ebx
  800983:	6a 25                	push   $0x25
  800985:	ff d6                	call   *%esi
			break;
  800987:	83 c4 10             	add    $0x10,%esp
  80098a:	e9 7a ff ff ff       	jmp    800909 <vprintfmt+0x3a6>
			putch('%', putdat);
  80098f:	83 ec 08             	sub    $0x8,%esp
  800992:	53                   	push   %ebx
  800993:	6a 25                	push   $0x25
  800995:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800997:	83 c4 10             	add    $0x10,%esp
  80099a:	89 f8                	mov    %edi,%eax
  80099c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009a0:	74 05                	je     8009a7 <vprintfmt+0x444>
  8009a2:	83 e8 01             	sub    $0x1,%eax
  8009a5:	eb f5                	jmp    80099c <vprintfmt+0x439>
  8009a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009aa:	e9 5a ff ff ff       	jmp    800909 <vprintfmt+0x3a6>
}
  8009af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009b2:	5b                   	pop    %ebx
  8009b3:	5e                   	pop    %esi
  8009b4:	5f                   	pop    %edi
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009b7:	f3 0f 1e fb          	endbr32 
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	83 ec 18             	sub    $0x18,%esp
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009ca:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009ce:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009d8:	85 c0                	test   %eax,%eax
  8009da:	74 26                	je     800a02 <vsnprintf+0x4b>
  8009dc:	85 d2                	test   %edx,%edx
  8009de:	7e 22                	jle    800a02 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009e0:	ff 75 14             	pushl  0x14(%ebp)
  8009e3:	ff 75 10             	pushl  0x10(%ebp)
  8009e6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009e9:	50                   	push   %eax
  8009ea:	68 21 05 80 00       	push   $0x800521
  8009ef:	e8 6f fb ff ff       	call   800563 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009f7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009fd:	83 c4 10             	add    $0x10,%esp
}
  800a00:	c9                   	leave  
  800a01:	c3                   	ret    
		return -E_INVAL;
  800a02:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a07:	eb f7                	jmp    800a00 <vsnprintf+0x49>

00800a09 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a09:	f3 0f 1e fb          	endbr32 
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a13:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a16:	50                   	push   %eax
  800a17:	ff 75 10             	pushl  0x10(%ebp)
  800a1a:	ff 75 0c             	pushl  0xc(%ebp)
  800a1d:	ff 75 08             	pushl  0x8(%ebp)
  800a20:	e8 92 ff ff ff       	call   8009b7 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a25:	c9                   	leave  
  800a26:	c3                   	ret    

00800a27 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a27:	f3 0f 1e fb          	endbr32 
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a31:	b8 00 00 00 00       	mov    $0x0,%eax
  800a36:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a3a:	74 05                	je     800a41 <strlen+0x1a>
		n++;
  800a3c:	83 c0 01             	add    $0x1,%eax
  800a3f:	eb f5                	jmp    800a36 <strlen+0xf>
	return n;
}
  800a41:	5d                   	pop    %ebp
  800a42:	c3                   	ret    

00800a43 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a43:	f3 0f 1e fb          	endbr32 
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a50:	b8 00 00 00 00       	mov    $0x0,%eax
  800a55:	39 d0                	cmp    %edx,%eax
  800a57:	74 0d                	je     800a66 <strnlen+0x23>
  800a59:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a5d:	74 05                	je     800a64 <strnlen+0x21>
		n++;
  800a5f:	83 c0 01             	add    $0x1,%eax
  800a62:	eb f1                	jmp    800a55 <strnlen+0x12>
  800a64:	89 c2                	mov    %eax,%edx
	return n;
}
  800a66:	89 d0                	mov    %edx,%eax
  800a68:	5d                   	pop    %ebp
  800a69:	c3                   	ret    

00800a6a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a6a:	f3 0f 1e fb          	endbr32 
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	53                   	push   %ebx
  800a72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a75:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a78:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7d:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800a81:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800a84:	83 c0 01             	add    $0x1,%eax
  800a87:	84 d2                	test   %dl,%dl
  800a89:	75 f2                	jne    800a7d <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800a8b:	89 c8                	mov    %ecx,%eax
  800a8d:	5b                   	pop    %ebx
  800a8e:	5d                   	pop    %ebp
  800a8f:	c3                   	ret    

00800a90 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a90:	f3 0f 1e fb          	endbr32 
  800a94:	55                   	push   %ebp
  800a95:	89 e5                	mov    %esp,%ebp
  800a97:	53                   	push   %ebx
  800a98:	83 ec 10             	sub    $0x10,%esp
  800a9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a9e:	53                   	push   %ebx
  800a9f:	e8 83 ff ff ff       	call   800a27 <strlen>
  800aa4:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800aa7:	ff 75 0c             	pushl  0xc(%ebp)
  800aaa:	01 d8                	add    %ebx,%eax
  800aac:	50                   	push   %eax
  800aad:	e8 b8 ff ff ff       	call   800a6a <strcpy>
	return dst;
}
  800ab2:	89 d8                	mov    %ebx,%eax
  800ab4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ab7:	c9                   	leave  
  800ab8:	c3                   	ret    

00800ab9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ab9:	f3 0f 1e fb          	endbr32 
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	56                   	push   %esi
  800ac1:	53                   	push   %ebx
  800ac2:	8b 75 08             	mov    0x8(%ebp),%esi
  800ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac8:	89 f3                	mov    %esi,%ebx
  800aca:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800acd:	89 f0                	mov    %esi,%eax
  800acf:	39 d8                	cmp    %ebx,%eax
  800ad1:	74 11                	je     800ae4 <strncpy+0x2b>
		*dst++ = *src;
  800ad3:	83 c0 01             	add    $0x1,%eax
  800ad6:	0f b6 0a             	movzbl (%edx),%ecx
  800ad9:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800adc:	80 f9 01             	cmp    $0x1,%cl
  800adf:	83 da ff             	sbb    $0xffffffff,%edx
  800ae2:	eb eb                	jmp    800acf <strncpy+0x16>
	}
	return ret;
}
  800ae4:	89 f0                	mov    %esi,%eax
  800ae6:	5b                   	pop    %ebx
  800ae7:	5e                   	pop    %esi
  800ae8:	5d                   	pop    %ebp
  800ae9:	c3                   	ret    

00800aea <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aea:	f3 0f 1e fb          	endbr32 
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	56                   	push   %esi
  800af2:	53                   	push   %ebx
  800af3:	8b 75 08             	mov    0x8(%ebp),%esi
  800af6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af9:	8b 55 10             	mov    0x10(%ebp),%edx
  800afc:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800afe:	85 d2                	test   %edx,%edx
  800b00:	74 21                	je     800b23 <strlcpy+0x39>
  800b02:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b06:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b08:	39 c2                	cmp    %eax,%edx
  800b0a:	74 14                	je     800b20 <strlcpy+0x36>
  800b0c:	0f b6 19             	movzbl (%ecx),%ebx
  800b0f:	84 db                	test   %bl,%bl
  800b11:	74 0b                	je     800b1e <strlcpy+0x34>
			*dst++ = *src++;
  800b13:	83 c1 01             	add    $0x1,%ecx
  800b16:	83 c2 01             	add    $0x1,%edx
  800b19:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b1c:	eb ea                	jmp    800b08 <strlcpy+0x1e>
  800b1e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b20:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b23:	29 f0                	sub    %esi,%eax
}
  800b25:	5b                   	pop    %ebx
  800b26:	5e                   	pop    %esi
  800b27:	5d                   	pop    %ebp
  800b28:	c3                   	ret    

00800b29 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b29:	f3 0f 1e fb          	endbr32 
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b33:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b36:	0f b6 01             	movzbl (%ecx),%eax
  800b39:	84 c0                	test   %al,%al
  800b3b:	74 0c                	je     800b49 <strcmp+0x20>
  800b3d:	3a 02                	cmp    (%edx),%al
  800b3f:	75 08                	jne    800b49 <strcmp+0x20>
		p++, q++;
  800b41:	83 c1 01             	add    $0x1,%ecx
  800b44:	83 c2 01             	add    $0x1,%edx
  800b47:	eb ed                	jmp    800b36 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b49:	0f b6 c0             	movzbl %al,%eax
  800b4c:	0f b6 12             	movzbl (%edx),%edx
  800b4f:	29 d0                	sub    %edx,%eax
}
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b53:	f3 0f 1e fb          	endbr32 
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	53                   	push   %ebx
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b61:	89 c3                	mov    %eax,%ebx
  800b63:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b66:	eb 06                	jmp    800b6e <strncmp+0x1b>
		n--, p++, q++;
  800b68:	83 c0 01             	add    $0x1,%eax
  800b6b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b6e:	39 d8                	cmp    %ebx,%eax
  800b70:	74 16                	je     800b88 <strncmp+0x35>
  800b72:	0f b6 08             	movzbl (%eax),%ecx
  800b75:	84 c9                	test   %cl,%cl
  800b77:	74 04                	je     800b7d <strncmp+0x2a>
  800b79:	3a 0a                	cmp    (%edx),%cl
  800b7b:	74 eb                	je     800b68 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b7d:	0f b6 00             	movzbl (%eax),%eax
  800b80:	0f b6 12             	movzbl (%edx),%edx
  800b83:	29 d0                	sub    %edx,%eax
}
  800b85:	5b                   	pop    %ebx
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    
		return 0;
  800b88:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8d:	eb f6                	jmp    800b85 <strncmp+0x32>

00800b8f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b8f:	f3 0f 1e fb          	endbr32 
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b9d:	0f b6 10             	movzbl (%eax),%edx
  800ba0:	84 d2                	test   %dl,%dl
  800ba2:	74 09                	je     800bad <strchr+0x1e>
		if (*s == c)
  800ba4:	38 ca                	cmp    %cl,%dl
  800ba6:	74 0a                	je     800bb2 <strchr+0x23>
	for (; *s; s++)
  800ba8:	83 c0 01             	add    $0x1,%eax
  800bab:	eb f0                	jmp    800b9d <strchr+0xe>
			return (char *) s;
	return 0;
  800bad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bb4:	f3 0f 1e fb          	endbr32 
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bc2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bc5:	38 ca                	cmp    %cl,%dl
  800bc7:	74 09                	je     800bd2 <strfind+0x1e>
  800bc9:	84 d2                	test   %dl,%dl
  800bcb:	74 05                	je     800bd2 <strfind+0x1e>
	for (; *s; s++)
  800bcd:	83 c0 01             	add    $0x1,%eax
  800bd0:	eb f0                	jmp    800bc2 <strfind+0xe>
			break;
	return (char *) s;
}
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    

00800bd4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bd4:	f3 0f 1e fb          	endbr32 
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	57                   	push   %edi
  800bdc:	56                   	push   %esi
  800bdd:	53                   	push   %ebx
  800bde:	8b 7d 08             	mov    0x8(%ebp),%edi
  800be1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800be4:	85 c9                	test   %ecx,%ecx
  800be6:	74 31                	je     800c19 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800be8:	89 f8                	mov    %edi,%eax
  800bea:	09 c8                	or     %ecx,%eax
  800bec:	a8 03                	test   $0x3,%al
  800bee:	75 23                	jne    800c13 <memset+0x3f>
		c &= 0xFF;
  800bf0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bf4:	89 d3                	mov    %edx,%ebx
  800bf6:	c1 e3 08             	shl    $0x8,%ebx
  800bf9:	89 d0                	mov    %edx,%eax
  800bfb:	c1 e0 18             	shl    $0x18,%eax
  800bfe:	89 d6                	mov    %edx,%esi
  800c00:	c1 e6 10             	shl    $0x10,%esi
  800c03:	09 f0                	or     %esi,%eax
  800c05:	09 c2                	or     %eax,%edx
  800c07:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c09:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c0c:	89 d0                	mov    %edx,%eax
  800c0e:	fc                   	cld    
  800c0f:	f3 ab                	rep stos %eax,%es:(%edi)
  800c11:	eb 06                	jmp    800c19 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c16:	fc                   	cld    
  800c17:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c19:	89 f8                	mov    %edi,%eax
  800c1b:	5b                   	pop    %ebx
  800c1c:	5e                   	pop    %esi
  800c1d:	5f                   	pop    %edi
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    

00800c20 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c20:	f3 0f 1e fb          	endbr32 
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	57                   	push   %edi
  800c28:	56                   	push   %esi
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c32:	39 c6                	cmp    %eax,%esi
  800c34:	73 32                	jae    800c68 <memmove+0x48>
  800c36:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c39:	39 c2                	cmp    %eax,%edx
  800c3b:	76 2b                	jbe    800c68 <memmove+0x48>
		s += n;
		d += n;
  800c3d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c40:	89 fe                	mov    %edi,%esi
  800c42:	09 ce                	or     %ecx,%esi
  800c44:	09 d6                	or     %edx,%esi
  800c46:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c4c:	75 0e                	jne    800c5c <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c4e:	83 ef 04             	sub    $0x4,%edi
  800c51:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c54:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c57:	fd                   	std    
  800c58:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c5a:	eb 09                	jmp    800c65 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c5c:	83 ef 01             	sub    $0x1,%edi
  800c5f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c62:	fd                   	std    
  800c63:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c65:	fc                   	cld    
  800c66:	eb 1a                	jmp    800c82 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c68:	89 c2                	mov    %eax,%edx
  800c6a:	09 ca                	or     %ecx,%edx
  800c6c:	09 f2                	or     %esi,%edx
  800c6e:	f6 c2 03             	test   $0x3,%dl
  800c71:	75 0a                	jne    800c7d <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c73:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c76:	89 c7                	mov    %eax,%edi
  800c78:	fc                   	cld    
  800c79:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c7b:	eb 05                	jmp    800c82 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800c7d:	89 c7                	mov    %eax,%edi
  800c7f:	fc                   	cld    
  800c80:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c82:	5e                   	pop    %esi
  800c83:	5f                   	pop    %edi
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    

00800c86 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c86:	f3 0f 1e fb          	endbr32 
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c90:	ff 75 10             	pushl  0x10(%ebp)
  800c93:	ff 75 0c             	pushl  0xc(%ebp)
  800c96:	ff 75 08             	pushl  0x8(%ebp)
  800c99:	e8 82 ff ff ff       	call   800c20 <memmove>
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ca0:	f3 0f 1e fb          	endbr32 
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8b 55 0c             	mov    0xc(%ebp),%edx
  800caf:	89 c6                	mov    %eax,%esi
  800cb1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cb4:	39 f0                	cmp    %esi,%eax
  800cb6:	74 1c                	je     800cd4 <memcmp+0x34>
		if (*s1 != *s2)
  800cb8:	0f b6 08             	movzbl (%eax),%ecx
  800cbb:	0f b6 1a             	movzbl (%edx),%ebx
  800cbe:	38 d9                	cmp    %bl,%cl
  800cc0:	75 08                	jne    800cca <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cc2:	83 c0 01             	add    $0x1,%eax
  800cc5:	83 c2 01             	add    $0x1,%edx
  800cc8:	eb ea                	jmp    800cb4 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800cca:	0f b6 c1             	movzbl %cl,%eax
  800ccd:	0f b6 db             	movzbl %bl,%ebx
  800cd0:	29 d8                	sub    %ebx,%eax
  800cd2:	eb 05                	jmp    800cd9 <memcmp+0x39>
	}

	return 0;
  800cd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cd9:	5b                   	pop    %ebx
  800cda:	5e                   	pop    %esi
  800cdb:	5d                   	pop    %ebp
  800cdc:	c3                   	ret    

00800cdd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cdd:	f3 0f 1e fb          	endbr32 
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cea:	89 c2                	mov    %eax,%edx
  800cec:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cef:	39 d0                	cmp    %edx,%eax
  800cf1:	73 09                	jae    800cfc <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cf3:	38 08                	cmp    %cl,(%eax)
  800cf5:	74 05                	je     800cfc <memfind+0x1f>
	for (; s < ends; s++)
  800cf7:	83 c0 01             	add    $0x1,%eax
  800cfa:	eb f3                	jmp    800cef <memfind+0x12>
			break;
	return (void *) s;
}
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    

00800cfe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cfe:	f3 0f 1e fb          	endbr32 
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	57                   	push   %edi
  800d06:	56                   	push   %esi
  800d07:	53                   	push   %ebx
  800d08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d0e:	eb 03                	jmp    800d13 <strtol+0x15>
		s++;
  800d10:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d13:	0f b6 01             	movzbl (%ecx),%eax
  800d16:	3c 20                	cmp    $0x20,%al
  800d18:	74 f6                	je     800d10 <strtol+0x12>
  800d1a:	3c 09                	cmp    $0x9,%al
  800d1c:	74 f2                	je     800d10 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800d1e:	3c 2b                	cmp    $0x2b,%al
  800d20:	74 2a                	je     800d4c <strtol+0x4e>
	int neg = 0;
  800d22:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d27:	3c 2d                	cmp    $0x2d,%al
  800d29:	74 2b                	je     800d56 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d2b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d31:	75 0f                	jne    800d42 <strtol+0x44>
  800d33:	80 39 30             	cmpb   $0x30,(%ecx)
  800d36:	74 28                	je     800d60 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d38:	85 db                	test   %ebx,%ebx
  800d3a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d3f:	0f 44 d8             	cmove  %eax,%ebx
  800d42:	b8 00 00 00 00       	mov    $0x0,%eax
  800d47:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d4a:	eb 46                	jmp    800d92 <strtol+0x94>
		s++;
  800d4c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d4f:	bf 00 00 00 00       	mov    $0x0,%edi
  800d54:	eb d5                	jmp    800d2b <strtol+0x2d>
		s++, neg = 1;
  800d56:	83 c1 01             	add    $0x1,%ecx
  800d59:	bf 01 00 00 00       	mov    $0x1,%edi
  800d5e:	eb cb                	jmp    800d2b <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d60:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d64:	74 0e                	je     800d74 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d66:	85 db                	test   %ebx,%ebx
  800d68:	75 d8                	jne    800d42 <strtol+0x44>
		s++, base = 8;
  800d6a:	83 c1 01             	add    $0x1,%ecx
  800d6d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d72:	eb ce                	jmp    800d42 <strtol+0x44>
		s += 2, base = 16;
  800d74:	83 c1 02             	add    $0x2,%ecx
  800d77:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d7c:	eb c4                	jmp    800d42 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800d7e:	0f be d2             	movsbl %dl,%edx
  800d81:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d84:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d87:	7d 3a                	jge    800dc3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d89:	83 c1 01             	add    $0x1,%ecx
  800d8c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d90:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d92:	0f b6 11             	movzbl (%ecx),%edx
  800d95:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d98:	89 f3                	mov    %esi,%ebx
  800d9a:	80 fb 09             	cmp    $0x9,%bl
  800d9d:	76 df                	jbe    800d7e <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800d9f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800da2:	89 f3                	mov    %esi,%ebx
  800da4:	80 fb 19             	cmp    $0x19,%bl
  800da7:	77 08                	ja     800db1 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800da9:	0f be d2             	movsbl %dl,%edx
  800dac:	83 ea 57             	sub    $0x57,%edx
  800daf:	eb d3                	jmp    800d84 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800db1:	8d 72 bf             	lea    -0x41(%edx),%esi
  800db4:	89 f3                	mov    %esi,%ebx
  800db6:	80 fb 19             	cmp    $0x19,%bl
  800db9:	77 08                	ja     800dc3 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800dbb:	0f be d2             	movsbl %dl,%edx
  800dbe:	83 ea 37             	sub    $0x37,%edx
  800dc1:	eb c1                	jmp    800d84 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800dc3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc7:	74 05                	je     800dce <strtol+0xd0>
		*endptr = (char *) s;
  800dc9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dcc:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800dce:	89 c2                	mov    %eax,%edx
  800dd0:	f7 da                	neg    %edx
  800dd2:	85 ff                	test   %edi,%edi
  800dd4:	0f 45 c2             	cmovne %edx,%eax
}
  800dd7:	5b                   	pop    %ebx
  800dd8:	5e                   	pop    %esi
  800dd9:	5f                   	pop    %edi
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    

00800ddc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800ddc:	f3 0f 1e fb          	endbr32 
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800de6:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800ded:	74 0a                	je     800df9 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800df7:	c9                   	leave  
  800df8:	c3                   	ret    
		if(sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P) < 0){
  800df9:	83 ec 04             	sub    $0x4,%esp
  800dfc:	6a 07                	push   $0x7
  800dfe:	68 00 f0 bf ee       	push   $0xeebff000
  800e03:	6a 00                	push   $0x0
  800e05:	e8 7e f3 ff ff       	call   800188 <sys_page_alloc>
  800e0a:	83 c4 10             	add    $0x10,%esp
  800e0d:	85 c0                	test   %eax,%eax
  800e0f:	78 2a                	js     800e3b <set_pgfault_handler+0x5f>
		if(sys_env_set_pgfault_upcall(0, _pgfault_upcall) < 0){
  800e11:	83 ec 08             	sub    $0x8,%esp
  800e14:	68 53 03 80 00       	push   $0x800353
  800e19:	6a 00                	push   $0x0
  800e1b:	e8 81 f4 ff ff       	call   8002a1 <sys_env_set_pgfault_upcall>
  800e20:	83 c4 10             	add    $0x10,%esp
  800e23:	85 c0                	test   %eax,%eax
  800e25:	79 c8                	jns    800def <set_pgfault_handler+0x13>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall failed!\n");
  800e27:	83 ec 04             	sub    $0x4,%esp
  800e2a:	68 90 13 80 00       	push   $0x801390
  800e2f:	6a 25                	push   $0x25
  800e31:	68 c8 13 80 00       	push   $0x8013c8
  800e36:	e8 3e f5 ff ff       	call   800379 <_panic>
			panic("set_pgfault_handler:sys_page_alloc failed!\n");
  800e3b:	83 ec 04             	sub    $0x4,%esp
  800e3e:	68 64 13 80 00       	push   $0x801364
  800e43:	6a 22                	push   $0x22
  800e45:	68 c8 13 80 00       	push   $0x8013c8
  800e4a:	e8 2a f5 ff ff       	call   800379 <_panic>
  800e4f:	90                   	nop

00800e50 <__udivdi3>:
  800e50:	f3 0f 1e fb          	endbr32 
  800e54:	55                   	push   %ebp
  800e55:	57                   	push   %edi
  800e56:	56                   	push   %esi
  800e57:	53                   	push   %ebx
  800e58:	83 ec 1c             	sub    $0x1c,%esp
  800e5b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800e5f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e63:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e67:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e6b:	85 d2                	test   %edx,%edx
  800e6d:	75 19                	jne    800e88 <__udivdi3+0x38>
  800e6f:	39 f3                	cmp    %esi,%ebx
  800e71:	76 4d                	jbe    800ec0 <__udivdi3+0x70>
  800e73:	31 ff                	xor    %edi,%edi
  800e75:	89 e8                	mov    %ebp,%eax
  800e77:	89 f2                	mov    %esi,%edx
  800e79:	f7 f3                	div    %ebx
  800e7b:	89 fa                	mov    %edi,%edx
  800e7d:	83 c4 1c             	add    $0x1c,%esp
  800e80:	5b                   	pop    %ebx
  800e81:	5e                   	pop    %esi
  800e82:	5f                   	pop    %edi
  800e83:	5d                   	pop    %ebp
  800e84:	c3                   	ret    
  800e85:	8d 76 00             	lea    0x0(%esi),%esi
  800e88:	39 f2                	cmp    %esi,%edx
  800e8a:	76 14                	jbe    800ea0 <__udivdi3+0x50>
  800e8c:	31 ff                	xor    %edi,%edi
  800e8e:	31 c0                	xor    %eax,%eax
  800e90:	89 fa                	mov    %edi,%edx
  800e92:	83 c4 1c             	add    $0x1c,%esp
  800e95:	5b                   	pop    %ebx
  800e96:	5e                   	pop    %esi
  800e97:	5f                   	pop    %edi
  800e98:	5d                   	pop    %ebp
  800e99:	c3                   	ret    
  800e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800ea0:	0f bd fa             	bsr    %edx,%edi
  800ea3:	83 f7 1f             	xor    $0x1f,%edi
  800ea6:	75 48                	jne    800ef0 <__udivdi3+0xa0>
  800ea8:	39 f2                	cmp    %esi,%edx
  800eaa:	72 06                	jb     800eb2 <__udivdi3+0x62>
  800eac:	31 c0                	xor    %eax,%eax
  800eae:	39 eb                	cmp    %ebp,%ebx
  800eb0:	77 de                	ja     800e90 <__udivdi3+0x40>
  800eb2:	b8 01 00 00 00       	mov    $0x1,%eax
  800eb7:	eb d7                	jmp    800e90 <__udivdi3+0x40>
  800eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ec0:	89 d9                	mov    %ebx,%ecx
  800ec2:	85 db                	test   %ebx,%ebx
  800ec4:	75 0b                	jne    800ed1 <__udivdi3+0x81>
  800ec6:	b8 01 00 00 00       	mov    $0x1,%eax
  800ecb:	31 d2                	xor    %edx,%edx
  800ecd:	f7 f3                	div    %ebx
  800ecf:	89 c1                	mov    %eax,%ecx
  800ed1:	31 d2                	xor    %edx,%edx
  800ed3:	89 f0                	mov    %esi,%eax
  800ed5:	f7 f1                	div    %ecx
  800ed7:	89 c6                	mov    %eax,%esi
  800ed9:	89 e8                	mov    %ebp,%eax
  800edb:	89 f7                	mov    %esi,%edi
  800edd:	f7 f1                	div    %ecx
  800edf:	89 fa                	mov    %edi,%edx
  800ee1:	83 c4 1c             	add    $0x1c,%esp
  800ee4:	5b                   	pop    %ebx
  800ee5:	5e                   	pop    %esi
  800ee6:	5f                   	pop    %edi
  800ee7:	5d                   	pop    %ebp
  800ee8:	c3                   	ret    
  800ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ef0:	89 f9                	mov    %edi,%ecx
  800ef2:	b8 20 00 00 00       	mov    $0x20,%eax
  800ef7:	29 f8                	sub    %edi,%eax
  800ef9:	d3 e2                	shl    %cl,%edx
  800efb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800eff:	89 c1                	mov    %eax,%ecx
  800f01:	89 da                	mov    %ebx,%edx
  800f03:	d3 ea                	shr    %cl,%edx
  800f05:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f09:	09 d1                	or     %edx,%ecx
  800f0b:	89 f2                	mov    %esi,%edx
  800f0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f11:	89 f9                	mov    %edi,%ecx
  800f13:	d3 e3                	shl    %cl,%ebx
  800f15:	89 c1                	mov    %eax,%ecx
  800f17:	d3 ea                	shr    %cl,%edx
  800f19:	89 f9                	mov    %edi,%ecx
  800f1b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f1f:	89 eb                	mov    %ebp,%ebx
  800f21:	d3 e6                	shl    %cl,%esi
  800f23:	89 c1                	mov    %eax,%ecx
  800f25:	d3 eb                	shr    %cl,%ebx
  800f27:	09 de                	or     %ebx,%esi
  800f29:	89 f0                	mov    %esi,%eax
  800f2b:	f7 74 24 08          	divl   0x8(%esp)
  800f2f:	89 d6                	mov    %edx,%esi
  800f31:	89 c3                	mov    %eax,%ebx
  800f33:	f7 64 24 0c          	mull   0xc(%esp)
  800f37:	39 d6                	cmp    %edx,%esi
  800f39:	72 15                	jb     800f50 <__udivdi3+0x100>
  800f3b:	89 f9                	mov    %edi,%ecx
  800f3d:	d3 e5                	shl    %cl,%ebp
  800f3f:	39 c5                	cmp    %eax,%ebp
  800f41:	73 04                	jae    800f47 <__udivdi3+0xf7>
  800f43:	39 d6                	cmp    %edx,%esi
  800f45:	74 09                	je     800f50 <__udivdi3+0x100>
  800f47:	89 d8                	mov    %ebx,%eax
  800f49:	31 ff                	xor    %edi,%edi
  800f4b:	e9 40 ff ff ff       	jmp    800e90 <__udivdi3+0x40>
  800f50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800f53:	31 ff                	xor    %edi,%edi
  800f55:	e9 36 ff ff ff       	jmp    800e90 <__udivdi3+0x40>
  800f5a:	66 90                	xchg   %ax,%ax
  800f5c:	66 90                	xchg   %ax,%ax
  800f5e:	66 90                	xchg   %ax,%ax

00800f60 <__umoddi3>:
  800f60:	f3 0f 1e fb          	endbr32 
  800f64:	55                   	push   %ebp
  800f65:	57                   	push   %edi
  800f66:	56                   	push   %esi
  800f67:	53                   	push   %ebx
  800f68:	83 ec 1c             	sub    $0x1c,%esp
  800f6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800f6f:	8b 74 24 30          	mov    0x30(%esp),%esi
  800f73:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 19                	jne    800f98 <__umoddi3+0x38>
  800f7f:	39 df                	cmp    %ebx,%edi
  800f81:	76 5d                	jbe    800fe0 <__umoddi3+0x80>
  800f83:	89 f0                	mov    %esi,%eax
  800f85:	89 da                	mov    %ebx,%edx
  800f87:	f7 f7                	div    %edi
  800f89:	89 d0                	mov    %edx,%eax
  800f8b:	31 d2                	xor    %edx,%edx
  800f8d:	83 c4 1c             	add    $0x1c,%esp
  800f90:	5b                   	pop    %ebx
  800f91:	5e                   	pop    %esi
  800f92:	5f                   	pop    %edi
  800f93:	5d                   	pop    %ebp
  800f94:	c3                   	ret    
  800f95:	8d 76 00             	lea    0x0(%esi),%esi
  800f98:	89 f2                	mov    %esi,%edx
  800f9a:	39 d8                	cmp    %ebx,%eax
  800f9c:	76 12                	jbe    800fb0 <__umoddi3+0x50>
  800f9e:	89 f0                	mov    %esi,%eax
  800fa0:	89 da                	mov    %ebx,%edx
  800fa2:	83 c4 1c             	add    $0x1c,%esp
  800fa5:	5b                   	pop    %ebx
  800fa6:	5e                   	pop    %esi
  800fa7:	5f                   	pop    %edi
  800fa8:	5d                   	pop    %ebp
  800fa9:	c3                   	ret    
  800faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800fb0:	0f bd e8             	bsr    %eax,%ebp
  800fb3:	83 f5 1f             	xor    $0x1f,%ebp
  800fb6:	75 50                	jne    801008 <__umoddi3+0xa8>
  800fb8:	39 d8                	cmp    %ebx,%eax
  800fba:	0f 82 e0 00 00 00    	jb     8010a0 <__umoddi3+0x140>
  800fc0:	89 d9                	mov    %ebx,%ecx
  800fc2:	39 f7                	cmp    %esi,%edi
  800fc4:	0f 86 d6 00 00 00    	jbe    8010a0 <__umoddi3+0x140>
  800fca:	89 d0                	mov    %edx,%eax
  800fcc:	89 ca                	mov    %ecx,%edx
  800fce:	83 c4 1c             	add    $0x1c,%esp
  800fd1:	5b                   	pop    %ebx
  800fd2:	5e                   	pop    %esi
  800fd3:	5f                   	pop    %edi
  800fd4:	5d                   	pop    %ebp
  800fd5:	c3                   	ret    
  800fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fdd:	8d 76 00             	lea    0x0(%esi),%esi
  800fe0:	89 fd                	mov    %edi,%ebp
  800fe2:	85 ff                	test   %edi,%edi
  800fe4:	75 0b                	jne    800ff1 <__umoddi3+0x91>
  800fe6:	b8 01 00 00 00       	mov    $0x1,%eax
  800feb:	31 d2                	xor    %edx,%edx
  800fed:	f7 f7                	div    %edi
  800fef:	89 c5                	mov    %eax,%ebp
  800ff1:	89 d8                	mov    %ebx,%eax
  800ff3:	31 d2                	xor    %edx,%edx
  800ff5:	f7 f5                	div    %ebp
  800ff7:	89 f0                	mov    %esi,%eax
  800ff9:	f7 f5                	div    %ebp
  800ffb:	89 d0                	mov    %edx,%eax
  800ffd:	31 d2                	xor    %edx,%edx
  800fff:	eb 8c                	jmp    800f8d <__umoddi3+0x2d>
  801001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801008:	89 e9                	mov    %ebp,%ecx
  80100a:	ba 20 00 00 00       	mov    $0x20,%edx
  80100f:	29 ea                	sub    %ebp,%edx
  801011:	d3 e0                	shl    %cl,%eax
  801013:	89 44 24 08          	mov    %eax,0x8(%esp)
  801017:	89 d1                	mov    %edx,%ecx
  801019:	89 f8                	mov    %edi,%eax
  80101b:	d3 e8                	shr    %cl,%eax
  80101d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801021:	89 54 24 04          	mov    %edx,0x4(%esp)
  801025:	8b 54 24 04          	mov    0x4(%esp),%edx
  801029:	09 c1                	or     %eax,%ecx
  80102b:	89 d8                	mov    %ebx,%eax
  80102d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801031:	89 e9                	mov    %ebp,%ecx
  801033:	d3 e7                	shl    %cl,%edi
  801035:	89 d1                	mov    %edx,%ecx
  801037:	d3 e8                	shr    %cl,%eax
  801039:	89 e9                	mov    %ebp,%ecx
  80103b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80103f:	d3 e3                	shl    %cl,%ebx
  801041:	89 c7                	mov    %eax,%edi
  801043:	89 d1                	mov    %edx,%ecx
  801045:	89 f0                	mov    %esi,%eax
  801047:	d3 e8                	shr    %cl,%eax
  801049:	89 e9                	mov    %ebp,%ecx
  80104b:	89 fa                	mov    %edi,%edx
  80104d:	d3 e6                	shl    %cl,%esi
  80104f:	09 d8                	or     %ebx,%eax
  801051:	f7 74 24 08          	divl   0x8(%esp)
  801055:	89 d1                	mov    %edx,%ecx
  801057:	89 f3                	mov    %esi,%ebx
  801059:	f7 64 24 0c          	mull   0xc(%esp)
  80105d:	89 c6                	mov    %eax,%esi
  80105f:	89 d7                	mov    %edx,%edi
  801061:	39 d1                	cmp    %edx,%ecx
  801063:	72 06                	jb     80106b <__umoddi3+0x10b>
  801065:	75 10                	jne    801077 <__umoddi3+0x117>
  801067:	39 c3                	cmp    %eax,%ebx
  801069:	73 0c                	jae    801077 <__umoddi3+0x117>
  80106b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80106f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801073:	89 d7                	mov    %edx,%edi
  801075:	89 c6                	mov    %eax,%esi
  801077:	89 ca                	mov    %ecx,%edx
  801079:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80107e:	29 f3                	sub    %esi,%ebx
  801080:	19 fa                	sbb    %edi,%edx
  801082:	89 d0                	mov    %edx,%eax
  801084:	d3 e0                	shl    %cl,%eax
  801086:	89 e9                	mov    %ebp,%ecx
  801088:	d3 eb                	shr    %cl,%ebx
  80108a:	d3 ea                	shr    %cl,%edx
  80108c:	09 d8                	or     %ebx,%eax
  80108e:	83 c4 1c             	add    $0x1c,%esp
  801091:	5b                   	pop    %ebx
  801092:	5e                   	pop    %esi
  801093:	5f                   	pop    %edi
  801094:	5d                   	pop    %ebp
  801095:	c3                   	ret    
  801096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80109d:	8d 76 00             	lea    0x0(%esi),%esi
  8010a0:	29 fe                	sub    %edi,%esi
  8010a2:	19 c3                	sbb    %eax,%ebx
  8010a4:	89 f2                	mov    %esi,%edx
  8010a6:	89 d9                	mov    %ebx,%ecx
  8010a8:	e9 1d ff ff ff       	jmp    800fca <__umoddi3+0x6a>
